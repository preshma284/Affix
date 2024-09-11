Codeunit 7207328 "QB Comparatives"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      Text50000 : TextConst ENU='This comparative has already been assigned a contract. Contract No. %1',ESP='Este comparativo ya tiene asignado un contrato. Contrato N� %1';
      Text50001 : TextConst ENU='You must assign a vendor to select a contract',ESP='Debe asignar un proveedor para seleccionar un contrato';
      Text50002 : TextConst ENU='The Quote has no lines to add to contracts',ESP='La Oferta no tiene l�neas que agregar a contratos';
      Text50003 : TextConst ENU='The quote is not approved and the contract can not be generated',ESP='La oferta no est� aprobada y no puede generarse el contrato';
      Text50004 : TextConst ENU='Generate Lines #1##################',ESP='Generando Lineas #1##################';
      Text50005 : TextConst ENU='Can not be contracted in Job on Quote',ESP='No se puede contratar en proyectos en oferta';

    LOCAL PROCEDURE "------------------------------------------ Funciones generales"();
    BEGIN
    END;

    PROCEDURE AsociateContract(VAR Rec : Record 7207412);
    VAR
      ComparativeQuoteLines : Record 7207413;
      Job : Record 167;
      PurchaseHeader : Record 38;
      PurchaseList : Page 53;
    BEGIN
      IF Rec."Job No."<>'' THEN BEGIN
        Job.GET(Rec."Job No.");
        IF Job.Status<>Job.Status::Open THEN
           ERROR(Text50005);
      END;

      IF (Rec."Generated Contract Doc No." <> '') THEN
         ERROR(Text50000, Rec."Generated Contract Doc No.");

      IF Rec."Selected Vendor" = '' THEN
         ERROR(Text50001);

      ComparativeQuoteLines.RESET;
      ComparativeQuoteLines.SETRANGE("Quote No.",Rec."No.");
      ComparativeQuoteLines.SETRANGE("Contract Line No.",0);  //Busco l�neas no asociadas a ning�n contrato
      IF NOT ComparativeQuoteLines.FINDFIRST THEN
        ERROR(Text50002);

      PurchaseHeader.RESET;
      PurchaseHeader.FILTERGROUP(2);
      PurchaseHeader.SETFILTER("Document Type",'%1|%2',PurchaseHeader."Document Type"::Order,PurchaseHeader."Document Type"::"Blanket Order");
      PurchaseHeader.SETRANGE("Buy-from Vendor No.",Rec."Selected Vendor");
      PurchaseHeader.SETRANGE("QB Contract",FALSE);
      IF Rec."Comparative To" = Rec."Comparative To"::Job THEN
        PurchaseHeader.SETRANGE("QB Job No.",Rec."Job No.")
      ELSE
        PurchaseHeader.SETRANGE("Location Code",Rec."Location Code");
      PurchaseHeader.FILTERGROUP(0);

      CLEAR(PurchaseList);
      PurchaseList.SETTABLEVIEW(PurchaseHeader);
      PurchaseList.LOOKUPMODE(TRUE);
      IF PurchaseList.RUNMODAL=ACTION::LookupOK THEN BEGIN
        PurchaseList.GETRECORD(PurchaseHeader);

        //JAV 30/04/21: - QB 1.08.41 Marcamos la cabecera como contrato
        PurchaseHeader."QB Contract" := TRUE;
        PurchaseHeader.MODIFY;

        //Q13150 -
        Rec."Generated Contract Doc Type" := PurchaseHeader."Document Type";
        Rec."Generated Contract Doc No." := PurchaseHeader."No.";
        Rec.MODIFY;

        InsertLines(Rec, PurchaseHeader);
      END;
    END;

    PROCEDURE InsertLines(ComparativeQuoteHeader : Record 7207412;PurchaseHeader : Record 38);
    VAR
      ComparativeQuoteLines : Record 7207413;
      ComparativeQuoteLines2 : Record 7207413;
      DataPricesVendor : Record 7207415;
      PurchaseLine : Record 39;
      LineNumber : Integer;
      Window : Dialog;
    BEGIN
      Window.OPEN(Text50004);
      ComparativeQuoteLines2.RESET;
      ComparativeQuoteLines2.SETRANGE("Quote No.",ComparativeQuoteHeader."No.");
      ComparativeQuoteLines2.SETRANGE("Contract Line No.",0);                          //Solo l�neas no asociadas a ning�n contrato
      IF ComparativeQuoteLines2.FINDFIRST THEN BEGIN
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type",PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.",PurchaseHeader."No.");
        IF PurchaseLine.FINDLAST THEN
          LineNumber := PurchaseLine."Line No."
        ELSE
          LineNumber := 0;
        REPEAT
          PurchaseLine.INIT;
          LineNumber += 10000;
          PurchaseLine."Document Type" := PurchaseHeader."Document Type";
          PurchaseLine."Document No." := PurchaseHeader."No.";
          PurchaseLine."Line No." := LineNumber;
          PurchaseLine.INSERT(TRUE);
          PurchaseLine.VALIDATE("Buy-from Vendor No.",ComparativeQuoteHeader."Selected Vendor");
          IF ComparativeQuoteLines2.Type = ComparativeQuoteLines2.Type::Resource THEN
            PurchaseLine.VALIDATE(Type,PurchaseLine.Type::Resource)
          ELSE
            PurchaseLine.VALIDATE(Type,PurchaseLine.Type::Item);
          PurchaseLine.VALIDATE("No.",ComparativeQuoteLines2."No.");
          IF ComparativeQuoteHeader."Comparative To" = ComparativeQuoteHeader."Comparative To"::Job THEN BEGIN
            PurchaseLine.VALIDATE("Job No.",ComparativeQuoteHeader."Job No.");
            PurchaseLine."Location Code" := '';
          END ELSE BEGIN
            PurchaseLine."Job No.":= '';
            PurchaseLine.VALIDATE("Location Code",ComparativeQuoteLines2."Location Code");
          END;
          PurchaseLine.VALIDATE("Qty. per Unit of Measure",1);
          PurchaseLine.VALIDATE("Unit of Measure Code",ComparativeQuoteLines2."Unit of measurement Code");
          PurchaseLine.VALIDATE(Quantity,ComparativeQuoteLines2.Quantity);
          DataPricesVendor.GET(ComparativeQuoteLines."Quote No.",ComparativeQuoteHeader."Selected Vendor",
                           ComparativeQuoteHeader."Contact Selectd No.",ComparativeQuoteLines2."Line No.");
          PurchaseLine.VALIDATE("Direct Unit Cost",DataPricesVendor."Vendor Price");
          PurchaseLine."Piecework No." := ComparativeQuoteLines2."Piecework No.";
          PurchaseLine.VALIDATE("Qty. to Receive",0);
          PurchaseLine.VALIDATE("Qty. to Receive (Base)",0);
          Window.UPDATE(1,FORMAT(PurchaseLine."Document No."+' '+PurchaseLine.Description));
          PurchaseLine.MODIFY;
          PurchaseLine.VALIDATE("Shortcut Dimension 1 Code",ComparativeQuoteLines2."Shortcut Dimension 1 Code");
          PurchaseLine.VALIDATE("Shortcut Dimension 2 Code",ComparativeQuoteLines2."Shortcut Dimension 2 Code");
          PurchaseLine."Job Task No." := ComparativeQuoteLines2."Job Task No.";
          PurchaseLine.MODIFY;
          ComparativeQuoteLines2."Contract Line No." := PurchaseLine."Line No.";
          ComparativeQuoteLines2.MODIFY;
        UNTIL ComparativeQuoteLines2.NEXT=0;
      END;
    END;

    LOCAL PROCEDURE "------------------------------------------ Respuestas a Eventos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7207414, OnBeforeInsertEvent, '', true, true)]
    LOCAL PROCEDURE T7207414_OnBeforeInsertEvent(VAR Rec : Record 7207414;RunTrigger : Boolean);
    VAR
      VendorConditionsData : Record 7207414;
    BEGIN
      //Q13150 - Da n�mero a la versi�n antes del alta de un proveedor/contacto en el comparativo
      IF (NOT RunTrigger) OR (Rec.ISTEMPORARY) THEN
        EXIT;

      WITH VendorConditionsData DO BEGIN
        SETRANGE("Quote Code",Rec."Quote Code");
        SETRANGE("Vendor No.",Rec."Vendor No.");
        SETRANGE("Contact No.",Rec."Contact No.");
        IF FINDLAST THEN
          Rec."Version No." := VendorConditionsData."Version No." + 1
        ELSE
          Rec."Version No." := 1;
        Rec."Version Date" := TODAY;
      END;
      //Q13150 +
    END;

    [EventSubscriber(ObjectType::Table, 7207414, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T7207414_OnAfterInsertEvent(VAR Rec : Record 7207414;RunTrigger : Boolean);
    VAR
      DataOtherConditions : Record 7207421;
      OtherVendorConditions : Record 7207416;
      ComparativeQuoteLines : Record 7207413;
      DataPricesVendor : Record 7207415;
      ContactActivitiesQB : Record 7207430;
      ComparativeQuoteHeader : Record 7207412;
      ConditionsExistErr : TextConst ENU='The condition to be inserted already exists',ESP='La condici�n que se va a insertar ya existe';
    BEGIN
      //Q13150 - Al dar un alta de un proveedor/contacto, cargas los datos necesarios
      IF (NOT RunTrigger) OR (Rec.ISTEMPORARY) THEN
        EXIT;

      WITH Rec DO BEGIN
        IF "Vendor No." <> '' THEN BEGIN
          //Insertar las otras condiciones del proveedor
          DataOtherConditions.RESET;
          DataOtherConditions.SETRANGE("Vendor No.","Vendor No.");
          IF DataOtherConditions.FINDSET(FALSE) THEN
            REPEAT
              IF (NOT OtherVendorConditions.GET(Rec."Quote Code",Rec."Vendor No.",Rec."Contact No.",Rec."Version No.",DataOtherConditions.Code)) THEN BEGIN
                OtherVendorConditions.INIT;
                OtherVendorConditions.VALIDATE("Quote Code","Quote Code");
                OtherVendorConditions.VALIDATE("Vendor No.",DataOtherConditions."Vendor No.");
                OtherVendorConditions.VALIDATE("Version No.", "Version No.");
                OtherVendorConditions.VALIDATE(Code,DataOtherConditions.Code);
                OtherVendorConditions.VALIDATE(Description,DataOtherConditions.Description);
                OtherVendorConditions.VALIDATE(Amount,DataOtherConditions.Amount);
                OtherVendorConditions.INSERT(TRUE);
              END;
            UNTIL DataOtherConditions.NEXT = 0;

          //Insertar las l�neas del comparativo
          ComparativeQuoteLines.RESET;
          ComparativeQuoteLines.SETRANGE("Quote No.","Quote Code");
          IF ComparativeQuoteLines.FINDSET(FALSE) THEN
            REPEAT
              CLEAR(DataPricesVendor);
              DataPricesVendor.INIT;
              DataPricesVendor.VALIDATE("Quote Code","Quote Code");
              DataPricesVendor.VALIDATE("Vendor No.","Vendor No.");
              DataPricesVendor.VALIDATE("Version No.", "Version No.");
              DataPricesVendor.VALIDATE("Line No.",ComparativeQuoteLines."Line No.");
              DataPricesVendor.VALIDATE(Type,ComparativeQuoteLines.Type);
              DataPricesVendor.VALIDATE("No.",ComparativeQuoteLines."No.");
/*{
              IF DataPricesVendor.Type=DataPricesVendor.Type::Item THEN
                DataPricesVendor.VALIDATE("Vendor Price",GetItemUnitCost(TypeOption::Item,ComparativeQuoteLines."No.","Vendor No.",''));
              IF DataPricesVendor.Type=DataPricesVendor.Type::Resource THEN
                DataPricesVendor.VALIDATE("Vendor Price",GetItemUnitCost(TypeOption::Resource,ComparativeQuoteLines."No.","Vendor No.",''));
              }*/

              DataPricesVendor.VALIDATE(Quantity,ComparativeQuoteLines.Quantity);
              DataPricesVendor.VALIDATE("Job No.",ComparativeQuoteLines."Job No.");
              DataPricesVendor.VALIDATE("Location Code",ComparativeQuoteLines."Location Code");
              DataPricesVendor.VALIDATE("Code Piecework PRESTO",ComparativeQuoteLines."Code Piecework PRESTO"); //QB3685
              DataPricesVendor.VALIDATE("Piecework No.", ComparativeQuoteLines."Piecework No.");
              IF DataPricesVendor.INSERT(TRUE) THEN;
            UNTIL ComparativeQuoteLines.NEXT = 0;
        END ELSE
          IF "Contact No." <> '' THEN BEGIN
            ComparativeQuoteLines.RESET;
            ComparativeQuoteLines.SETRANGE(ComparativeQuoteLines."Quote No.","Quote Code");
            IF ComparativeQuoteLines.FIND('-') THEN
              REPEAT
                CLEAR(DataPricesVendor);
                DataPricesVendor.INIT;
                DataPricesVendor.VALIDATE(DataPricesVendor."Quote Code","Quote Code");
                DataPricesVendor.VALIDATE(DataPricesVendor."Contact No.","Contact No.");
                DataPricesVendor.VALIDATE(DataPricesVendor."Vendor No.","Vendor No.");
                DataPricesVendor."Version No." := "Version No.";
                DataPricesVendor.VALIDATE(DataPricesVendor."Line No.",ComparativeQuoteLines."Line No.");
                DataPricesVendor.VALIDATE(DataPricesVendor.Type,ComparativeQuoteLines.Type);
                DataPricesVendor.VALIDATE(DataPricesVendor."No.",ComparativeQuoteLines."No.");
/*{
                IF DataPricesVendor.Type=DataPricesVendor.Type::Item THEN
                  DataPricesVendor.VALIDATE("Vendor Price",GetItemUnitCost(TypeOption::Item,ComparativeQuoteLines."No.","Vendor No.",''));
                IF DataPricesVendor.Type=DataPricesVendor.Type::Resource THEN
                  DataPricesVendor.VALIDATE("Vendor Price",GetItemUnitCost(TypeOption::Resource,ComparativeQuoteLines."No.","Vendor No.",''));
      }*/

                DataPricesVendor.VALIDATE(DataPricesVendor.Quantity,ComparativeQuoteLines.Quantity);
                DataPricesVendor.VALIDATE(DataPricesVendor."Job No.",ComparativeQuoteLines."Job No.");
                DataPricesVendor.VALIDATE(DataPricesVendor."Location Code",ComparativeQuoteLines."Location Code");
                DataPricesVendor.VALIDATE("Code Piecework PRESTO",ComparativeQuoteLines."Code Piecework PRESTO"); //QB3685
                DataPricesVendor.VALIDATE("Piecework No.", ComparativeQuoteLines."Piecework No.");
                IF DataPricesVendor.INSERT(TRUE) THEN;
              UNTIL ComparativeQuoteLines.NEXT = 0;
          END;
      END;
      //Q13150 +
    END;

    [EventSubscriber(ObjectType::Table, 7207414, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T7207414_OnAfterModifyEvent(VAR Rec : Record 7207414;VAR xRec : Record 7207414;RunTrigger : Boolean);
    VAR
      ChangeVendNoAllowedErr : TextConst ENU='The %1 or %2 cannot be modified for the current line. Please, create a new line and delete the existing if it is required.',ESP='No se pueden modificar proveedor/contacto o el n�mero de versi�n para la l�nea actual. Por favor, cree una nueva l�nea y borre la actual si fuese necesario.';
    BEGIN
      //Q13150 - Al modificar un registro, no se puede cambiar proveedor, contacto o versi�n
      IF (NOT RunTrigger) OR (Rec.ISTEMPORARY) THEN
        EXIT;

      IF (xRec."Vendor No." <> Rec."Vendor No.") OR (xRec."Contact No." <> Rec."Contact No.") OR (xRec."Version No." <> Rec."Version No.") THEN
        ERROR(ChangeVendNoAllowedErr);
      //Q13150 +
    END;

    [EventSubscriber(ObjectType::Table, 7207414, OnAfterRenameEvent, '', true, true)]
    LOCAL PROCEDURE T7207414_OnAfterRenameEvent(VAR Rec : Record 7207414;VAR xRec : Record 7207414;RunTrigger : Boolean);
    VAR
      ChangeVendNoAllowedErr : TextConst ENU='The %1 or %2 cannot be modified for the current line. Please, create a new line and delete the existing if it is required.',ESP='No se pueden modificar proveedor/contacto o el n�mero de versi�n para la l�nea actual. Por favor, cree una nueva l�nea y borre la actual si fuese necesario.';
    BEGIN
      //JAV 23/04/21 - No se pueden renombrar registros
      IF (NOT RunTrigger) OR (Rec.ISTEMPORARY) THEN
        EXIT;

      ERROR(ChangeVendNoAllowedErr);
    END;

    /*BEGIN
/*{
      JDC 05/04/21: - Q13150 Modified function "OnRun"
      JAV 23/04/21: - Se convienrte la CU en gen�rica, se traspasa el c�digo del OnRun a la funci�n AsociateContract
    }
END.*/
}







