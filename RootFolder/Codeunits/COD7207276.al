Codeunit 7207276 "Post Purchase Rcpt. Output"
{
  
  
    TableNo=7207308;
    Permissions=TableData 32=rimd,
                TableData 7207310=rimd;
                //TableData 50043=rimd,
    trigger OnRun()
VAR
            UpdateAnalysisView : Codeunit 410;
          BEGIN
            //Al registrar el albar�n de almac�n del proyecto, generar movimientos de proyecto y contables

            IF PostingDateExists AND (ReplacePostingDate OR (rec."Posting Date" = 0D)) THEN
              rec.VALIDATE(rec."Posting Date",PostingDate);

            CLEARALL;

            OutputShipmentHeader.COPY(Rec);
            WITH OutputShipmentHeader DO BEGIN
              TESTFIELD("Job No.");
              TESTFIELD("Posting Date");
            END;

            Job.GET(rec."Job No.");
            Job.TESTFIELD(Job.Blocked,Job.Blocked::" ");

            CheckDim;

            //CPA 21/03/23 - Q18753+
            OnBeforePostOutputShipmentHeader(Rec);
            //CPA 21/03/23 - Q18753-

            Window.OPEN(
              '#1#################################\\' +
              Text005 +
              Text007 +
              Text016 +
              Text015 +
              Text040);

            Window.UPDATE(1,STRSUBSTNO('%1',rec."No."));

            GetGLSetup;

            rec.TESTFIELD(rec."Posting Series No.");

            IF rec.RECORDLEVELLOCKING THEN BEGIN
              OutputShipmentLines.LOCKTABLE;
              GLEntry.LOCKTABLE;
              IF GLEntry.FINDLAST THEN;
            END;

            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup."Output Shipment to Job";

            //Verificar datos y crear la cabecera del movimiento de almac�n de proyecto registrado
            HeaderControl;
            CreatePostedHeader;

            OutputShipmentLines.RESET;
            OutputShipmentLines.SETRANGE("Document No.",rec."No.");
            LineCount := 0;
            IF OutputShipmentLines.FINDSET(TRUE) THEN BEGIN
              REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2,LineCount);
                QuantityControl;
                LineControl;
                GenerateItemEntries;
                GenerateJobEntries;
                GeneratePostPurchaseRcptOutput;
                CreateGLEntries;
              UNTIL OutputShipmentLines.NEXT = 0;
            END ELSE BEGIN
              //No hay lineas, comprobar a ver que pasa.
              IF rec."Automatic Shipment" THEN
                EXIT
              ELSE
                ERROR(Text001);
            END;


            rec.DELETE;
            OutputShipmentLines.DELETEALL;

            QBCommentLine.SETRANGE("No.",rec."No.");
            QBCommentLine.DELETEALL;

            IF (NOT OutputShipmentHeader."Automatic Shipment") AND
               (NOT rec."Sales Shipment Origin") THEN
              COMMIT;

            CLEAR(JobJournalLine);
            Window.CLOSE;

            IF (NOT OutputShipmentHeader."Automatic Shipment") AND
               (NOT rec."Sales Shipment Origin") THEN BEGIN
              UpdateAnalysisView.UpdateAll(0,TRUE);
              UpdateItemAnalysisView.UpdateAll(0,TRUE);
            END;

            Rec := OutputShipmentHeader;
          END;
    VAR
      Text001 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';
      Text002 : TextConst ENU='To register a Purchase Rcpt. Output against Job %1 you must select a department code',ESP='"Para registrar un albar�n de salida de producto contra el  proyecto %1 debe de seleccionar un c�digo de departamento "';
      Text003 : TextConst ENU='In order to register a Purchase Rcpt. Output against Job %1, you must indicate in Job Constraint Dimension %2 a Job Structure',ESP='Para registrar un albar�n de salida de producto contra el proyecto %1 debe de indicar en el valor %3 de la Dimensi�n %2 un Proy.Estructura';
      Text004 : TextConst ENU='Shipment',ESP='Albar�n';
      Text005 : TextConst ENU='Posting lines              #2######\',ESP='Registrando l�neas             #2######\';
      Text006 : TextConst ENU='Job t%1 must be of job type: "STRUCTURE"',ESP='El proyecto  %1 debe de ser de tipo de proyecto : "ESTRUCTURA"';
      Text007 : TextConst ENU='Posting to vendors         #4######\',ESP='Registrando Proyecto           #3######\';
      Text008 : TextConst ENU='It is not allowed to impute on a project of type Deviations. Project %1',ESP='No est� permitido  imputar sobre un proyecto de tipo Desviaciones. Proyecto %1';
      Text009 : TextConst ENU='Posting lines         #2######',ESP='Registrando l�neas         #2######';
      Text010 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 -> Documento %2';
      Text015 : TextConst ENU='Registering G/L Entry #7 ######\',ESP='Registrando Mov.Contabilidad   #7######\';
      Text016 : TextConst ENU='Registering Item Entries       #8######\',ESP='Registrando Mov.Producto       #8######\';
      Text023 : TextConst ENU='in the associated blanket order must not be greater than %1',ESP='en el pedido abierto asociado no debe ser superior a %1';
      Text024 : TextConst ENU='in the associated blanket order must be reduced.',ESP='en el pedido abierto asociado se debe reducir.';
      Text025 : TextConst ENU='Output Shipment',ESP='"Albar�n de salida: "';
      Text032 : TextConst ENU='The combination of dimensions used in %1 %2 is blocked. %3',ESP='La combinaci�n de dimensiones utilizadas en el documento %1 est� bloqueada. %3';
      Text033 : TextConst ENU='The combination of dimensions used in %1 %2, line no. %3 is blocked. %4',ESP='La combinaci�n de dimensiones utilizadas en el documento %1  n� l�nea %3 est� bloqueada. %4';
      Text034 : TextConst ENU='The dimensions used in %1 %2 are invalid. %3',ESP='Las dimensiones usadas en %1 %2 son inv�lidas %3';
      Text035 : TextConst ENU='The dimensions used in %1 %2, line no. %3 are invalid. %4',ESP='Las dim. usadas en %1 %2, no. l�n. %3 son inv�lidas %4';
      GLSetup : Record 98;
      GLEntry : Record 17;
      OutputShipmentHeader : Record 7207308;
      OutputShipmentLines : Record 7207309;
      PostedOutputShipmentHeader : Record 7207310;
      PostedOutputShipmentLines : Record 7207311;
      JobJournalLine : Record 210;
      ItemJournalLine : Record 83;
      GenJournalLine : Record 81;
      SourceCodeSetup : Record 242;
      QBCommentLine : Record 7207270;
      QBCommentLine2 : Record 7207270;
      Currency : Record 4;
      Job : Record 167;
      Job2 : Record 167;
      Item : Record 27;
      DimValue : Record 349;
      InventoryPostingSetup : Record 5813;
      GLAccount : Record 15;
      Location : Record 14;
      Job3 : Record 167;
      JobJnlPostLine : Codeunit 1012;
      DimMgt : Codeunit 408;
      FunctionQB : Codeunit 7207272;
      NoSeriesMgt : Codeunit 396;
      UpdateItemAnalysisView : Codeunit 7150;
      Window : Dialog;
      PostingDate : Date;
      GenJnlLineDocNo : Code[20];
      SrcCode : Code[10];
      LineCount : Integer;
      LineCountProy : Integer;
      LineCountHist : Integer;
      LineCountProd : Integer;
      LineCountCont : Integer;
      PostingDateExists : Boolean;
      ReplacePostingDate : Boolean;
      ReplaceDocumentDate : Boolean;
      Text040 : TextConst ENU='Creating documents         #6######',ESP='Creando documentos             #6######';
      GLSetupRead : Boolean;
      Text050 : TextConst ENU='No stock available for selected series or batch',ESP='No hay existencias disponibles para la serie o lote seleccionados';

    PROCEDURE SetPostingDate(NewReplacePostingDate : Boolean;NewReplaceDocumentDate : Boolean;NewPostingDate : Date);
    BEGIN
      //Guarda la fecha de registro
      PostingDateExists := TRUE;
      ReplacePostingDate := NewReplacePostingDate;
      ReplaceDocumentDate := NewReplaceDocumentDate;
      PostingDate := NewPostingDate;
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber : Code[20];ToNumber : Code[20]);
    BEGIN
      //Copiar las l�neas de comentarios de uno a otro documento
      QBCommentLine.SETRANGE("No.",FromNumber);
      IF QBCommentLine.FINDSET(TRUE) THEN
        REPEAT
         QBCommentLine."Document Type" := QBCommentLine."Document Type"::"Receipt Hist.";
         QBCommentLine := QBCommentLine;
         QBCommentLine."No." := ToNumber;
         QBCommentLine.INSERT;
       UNTIL QBCommentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
      //Leer la configuraci�n de contabilidad
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    PROCEDURE CreatePostedHeader();
    BEGIN
      //Crear la cabecera del albar�n de entrada en el almac�n
      PostedOutputShipmentHeader.INIT;
      PostedOutputShipmentHeader.TRANSFERFIELDS(OutputShipmentHeader);
      IF OutputShipmentHeader."Sales Shipment Origin" AND (OutputShipmentHeader."Sales Document No." <> '') THEN BEGIN
        PostedOutputShipmentHeader."No." := OutputShipmentHeader."Sales Document No.";
        PostedOutputShipmentHeader."Posting Description" := Text025 + OutputShipmentHeader."Sales Document No.";
      END ELSE BEGIN
        PostedOutputShipmentHeader."Pre-Assigned No. Series" := OutputShipmentHeader."Posting Series No.";
        PostedOutputShipmentHeader."No." := NoSeriesMgt.GetNextNo(OutputShipmentHeader."Posting Series No.",OutputShipmentHeader."Posting Date",TRUE);
      END;
      PostedOutputShipmentHeader."Source Code" := SrcCode;
      PostedOutputShipmentHeader."User ID" := USERID;
      PostedOutputShipmentHeader."Dimension Set ID" := OutputShipmentHeader."Dimension Set ID";
      PostedOutputShipmentHeader.INSERT;
      CopyCommentLines(OutputShipmentHeader."No.",PostedOutputShipmentHeader."No.");
      GenJnlLineDocNo :=  PostedOutputShipmentHeader."No.";
    END;

    PROCEDURE GenerateJobEntries();
    BEGIN
      //Crear el movimiento de proyecto asociado a la entrada, tanto en el proyecto actual como en el de desviaciones de almac�n

      Location.GET(OutputShipmentLines."Outbound Warehouse");
      DimValue.GET(FunctionQB.ReturnDimDpto,Location."QB Departament Code");

      //Crear el movimiento de proyecto que cancela el anterior
      LineCountProy := LineCountProy + 1;
      Window.UPDATE(3,LineCountProy);
      GenerateJobJournalLine(OutputShipmentHeader."Job No.", DimValue."Job Structure Warehouse", FALSE);

      //Crear la l�nea del proyecto de estructura de almac�n
      LineCountProy := LineCountProy + 1;
      Window.UPDATE(3,LineCountProy);
      GenerateJobJournalLine(OutputShipmentHeader."Job No.", DimValue."Job Structure Warehouse", TRUE);
    END;

    LOCAL PROCEDURE GenerateJobJournalLine(pJob1 : Code[20];pJob2 : Code[20];pAdjust : Boolean);
    VAR
      DefaultDimension : Record 352;
        JobJnlPostLine2: Codeunit 50012;
    BEGIN
      //JAV 05/02/22: - QB 1.10.16 Funci�n que crea y registra una l�nea en el diario de proyectos
      Item.GET(OutputShipmentLines."No.");
      IF (NOT pAdjust) THEN
        Job.GET(pJob1)
      ELSE
        Job.GET(pJob2);

      JobJournalLine.INIT;
      JobJournalLine."Job No." := Job."No.";
      JobJournalLine."Job Task No." := OutputShipmentLines."Job Task No.";
      JobJournalLine."Posting Date" := OutputShipmentHeader."Posting Date";
      JobJournalLine."Document Date" := OutputShipmentHeader."Posting Date";
      JobJournalLine."Document No." := GenJnlLineDocNo;
      JobJournalLine."External Document No." := PostedOutputShipmentHeader."Purchase Rcpt. No.";
      JobJournalLine.Type := JobJournalLine.Type::Item;
      JobJournalLine."No." := OutputShipmentLines."No.";
      JobJournalLine.Description := OutputShipmentLines.Description;
      IF (NOT pAdjust) THEN
        JobJournalLine.Quantity := OutputShipmentLines.Quantity
      ELSE
        JobJournalLine.Quantity := -OutputShipmentLines.Quantity;
      JobJournalLine.VALIDATE("Unit Cost (LCY)", OutputShipmentLines."Unit Cost");
      JobJournalLine."Unit of Measure Code" := OutputShipmentLines."Unit of Measure Code";
      JobJournalLine."Qty. per Unit of Measure" := OutputShipmentLines."Unit of Mensure Quantity";
      JobJournalLine."Quantity (Base)" := OutputShipmentLines."Quantity (Base)";
      JobJournalLine."Location Code" := OutputShipmentLines."Outbound Warehouse";
      JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
      JobJournalLine."Source Code" := SrcCode;
      JobJournalLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
      IF Job."Job Posting Group"<> '' THEN
        JobJournalLine."Posting Group" := Job."Job Posting Group";
      JobJournalLine."Posting No. Series" := OutputShipmentHeader."Posting Series No.";
      JobJournalLine."Post Job Entry Only" := TRUE;
      JobJournalLine."Serial No.":= OutputShipmentHeader."No. Series";
      JobJournalLine."Posting No. Series" := OutputShipmentHeader."Posting Series No.";
      JobJournalLine."Piecework Code" := OutputShipmentLines."Produccion Unit";
      JobJournalLine."Variant Code" := OutputShipmentLines."Variant Code";
      JobJournalLine."Related Item Entry No." := ItemJournalLine."Item Shpt. Entry No.";
      JobJournalLine."Job Posting Only" := TRUE;
      JobJournalLine."Activation Entry" := TRUE;
      JobJournalLine."Dimension Set ID" := OutputShipmentLines."Dimension Set ID";
      IF OutputShipmentLines."Job Line Type" = OutputShipmentLines."Job Line Type"::" " THEN
        JobJournalLine."Line Type" := Enum::"Job Line Type".FromInteger(OutputShipmentLines."Job Line Type"::"Both Budget and Billable")
      ELSE
        JobJournalLine."Line Type" := Enum::"Job Line Type".FromInteger(OutputShipmentLines."Job Line Type"); //option to enum
      JobJournalLine."Job Deviation Entry" := pAdjust;

      JobJnlPostLine2.ResetJobLedgEntry();

      JobJournalLine."Shortcut Dimension 1 Code" := OutputShipmentLines."Shortcut Dimension 1 Code";
      JobJournalLine."Shortcut Dimension 2 Code" := OutputShipmentLines."Shortcut Dimension 2 Code";
      JobJournalLine."Dimension Set ID" := OutputShipmentLines."Dimension Set ID";

      //Crear la l�nea del proyecto de estructura de almac�n
      IF (pAdjust) THEN BEGIN
        Job3.GET(pJob2);
        IF Job3."Warehouse Cost Unit" <> '' THEN                                      //JAV 30/03/21: - Se cambia el campo que era err�neo
          JobJournalLine."Piecework Code" := Job3."Warehouse Cost Unit"               //JAV 30/03/21: - Se cambia el campo que era err�neo
        ELSE BEGIN
          Job.GET(pJob1);
          IF Job."Warehouse Cost Unit" <> '' THEN
            JobJournalLine."Piecework Code" := Job."Warehouse Cost Unit"              //JAV 30/03/21: - Se cambia el campo que era err�neo
          ELSE
            JobJournalLine."Piecework Code" := OutputShipmentLines."Produccion Unit";
        END;

        IF Job3."Location Task No." <> '' THEN
          JobJournalLine."Job Task No." := Job3."Location Task No."
        ELSE BEGIN
          Job.GET(pJob1);
          IF Job."Location Task No." <> '' THEN
            JobJournalLine."Job Task No." := Job."Location Task No."
          ELSE
            JobJournalLine."Job Task No." := OutputShipmentLines."Job Task No."
        END;

        //Ajustar dimensiones
        IF (InventoryPostingSetup."App. Account Concept Analytic" <> '') THEN
          FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,InventoryPostingSetup."App. Account Concept Analytic",JobJournalLine."Dimension Set ID");
        IF (Location."QB Departament Code" <> '') THEN
          FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto,Location."QB Departament Code",JobJournalLine."Dimension Set ID")
        ELSE IF (FunctionQB.GetDepartment(DATABASE::Job,JobJournalLine."Job No.") <> '') THEN
          FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto,FunctionQB.GetDepartment(DATABASE::Job,JobJournalLine."Job No."),JobJournalLine."Dimension Set ID");

        DefaultDimension.SETRANGE("Table ID",DATABASE::Job);
        DefaultDimension.SETRANGE("No.",DimValue."Job Structure Warehouse");
        IF DefaultDimension.FINDSET(FALSE) THEN
          REPEAT
            IF DefaultDimension."Value Posting" = DefaultDimension."Value Posting"::"Same Code" THEN
              FunctionQB.UpdateDimSet(DefaultDimension."Dimension Code",DefaultDimension."Dimension Value Code",JobJournalLine."Dimension Set ID");
          UNTIL DefaultDimension.NEXT = 0;
      END;

      FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,JobJournalLine."Job No.",JobJournalLine."Dimension Set ID");
      DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID",JobJournalLine."Shortcut Dimension 1 Code",JobJournalLine."Shortcut Dimension 2 Code");

      JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    PROCEDURE GeneratePostPurchaseRcptOutput();
    BEGIN
      //Crear la l�nea del alabr�nd e movimiento de almac�n
      LineCountHist := LineCountHist + 1;

      PostedOutputShipmentLines.INIT;
      PostedOutputShipmentLines.TRANSFERFIELDS(OutputShipmentLines);
      PostedOutputShipmentLines."Document No." :=  PostedOutputShipmentHeader."No.";
      PostedOutputShipmentLines."Dimension Set ID" := OutputShipmentLines."Dimension Set ID";
      PostedOutputShipmentLines.INSERT;
    END;

    PROCEDURE GenerateItemEntries();
    VAR
      ItemJnlPostLine : Codeunit 22;
      ReservationEntry : Record 337;
      ReserveNumber : Integer;
      TransferQty : Decimal;
      CreateReservEntry : Codeunit 99000830;
      PurchRcptHdr : Record 120;
      ReturnShptHeader : Record 6650;
      QB_Stocks : Codeunit 7206975;
      ItemLedgerEntry : Record 32;
    BEGIN
      //Crear movimiento de producto

      //-QB_ST01 22/3/2022 Si est� activada la nueva funcionalidad y es una entrada no har� diario Para compras
      IF OutputShipmentHeader."Purchase Rcpt. No." <> '' THEN BEGIN
         IF QB_Stocks.ActiveJobConsumption(OutputShipmentHeader,OutputShipmentLines) THEN BEGIN
           QB_Stocks.AddStockInfo(OutputShipmentHeader,OutputShipmentLines,PostedOutputShipmentHeader);
           EXIT;
         END;
      END;
      //+QB_ST01

      LineCountProd := LineCountProd + 1;
      Window.UPDATE(8,LineCountProd);

      ItemJournalLine.INIT;

      ItemJournalLine."Item No.":=OutputShipmentLines."No.";
      ItemJournalLine."Posting Date":=OutputShipmentHeader."Posting Date";
      IF OutputShipmentHeader."Automatic Shipment" THEN BEGIN
        ItemJournalLine."Entry Type":=ItemJournalLine."Entry Type"::Purchase;
        ItemJournalLine."Document No.":= PostedOutputShipmentHeader."Purchase Rcpt. No.";

        //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.Begin
        //ItemJournalLine."Document Type" := ItemJournalLine."Document Type"::"Purchase Receipt";
        IF PostedOutputShipmentHeader."Documnet Type" = PostedOutputShipmentHeader."Documnet Type"::Shipment THEN
          ItemJournalLine."Document Type" := ItemJournalLine."Document Type"::"Purchase Receipt"
        ELSE
          ItemJournalLine."Document Type" := ItemJournalLine."Document Type"::"Purchase Return Shipment";
        //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.End

        ItemJournalLine."Document Line No." := 0;
        ItemJournalLine."External Document No." := GenJnlLineDocNo;
        ItemJournalLine.Quantity := - OutputShipmentLines.Quantity;
        ItemJournalLine."Qty. per Unit of Measure" := OutputShipmentLines."Unit of Mensure Quantity";
        ItemJournalLine."Quantity (Base)":= - OutputShipmentLines."Quantity (Base)";

        //CPA 14/12/2021 - Q15921. Errores detectados en almacenes de obras.Begin
        ItemJournalLine."QB Automatic Shipment" := TRUE;
        //CPA 14/12/2021 - Q15921. Errores detectados en almacenes de obras.End

        ItemJournalLine."Invoiced Qty. (Base)":= - OutputShipmentLines."Quantity (Base)";
        ItemJournalLine.Amount:= - OutputShipmentLines."Total Cost";

        //CPA 02/12/2021 - Q15921. Errores detectados en almacenes de obras.Begin
        CASE PostedOutputShipmentHeader."Documnet Type" OF
          PostedOutputShipmentHeader."Documnet Type"::Shipment: BEGIN
            IF PurchRcptHdr.GET(PostedOutputShipmentHeader."Purchase Rcpt. No.") THEN BEGIN
              ItemJournalLine."Gen. Bus. Posting Group" := PurchRcptHdr."Gen. Bus. Posting Group";
              ItemJournalLine."Source Type" := ItemJournalLine."Source Type"::Vendor;
              ItemJournalLine."Source No." := PurchRcptHdr."Buy-from Vendor No.";
            END;
          END;

          PostedOutputShipmentHeader."Documnet Type"::"Receipt.Return": BEGIN
            IF PurchRcptHdr.GET(PostedOutputShipmentHeader."Purchase Rcpt. No.") THEN BEGIN
              ItemJournalLine."Gen. Bus. Posting Group" := PurchRcptHdr."Gen. Bus. Posting Group";
              ItemJournalLine."Source Type" := ItemJournalLine."Source Type"::Vendor;
              ItemJournalLine."Source No." := PurchRcptHdr."Buy-from Vendor No.";
            END;
          END;
        END;
        //CPA 02/12/2021 - Q15921. Errores detectados en almacenes de obras.End
      END ELSE BEGIN
        IF PostedOutputShipmentHeader."Sales Shipment Origin" THEN BEGIN
          ItemJournalLine."Entry Type":=ItemJournalLine."Entry Type"::Sale;
          ItemJournalLine."Document Type" := ItemJournalLine."Document Type"::"Sales Shipment";
          ItemJournalLine."Document Line No." := 0;
        END ELSE
          ItemJournalLine."Entry Type":=ItemJournalLine."Entry Type"::"Negative Adjmt.";
        ItemJournalLine."Document No.":=GenJnlLineDocNo;
        IF PostedOutputShipmentHeader."Sales Shipment Origin" THEN
          ItemJournalLine."External Document No." := PostedOutputShipmentHeader."Sales Document No."
        ELSE
          ItemJournalLine."External Document No." := PostedOutputShipmentHeader."Purchase Rcpt. No.";
        ItemJournalLine.Quantity:=OutputShipmentLines.Quantity;
        ItemJournalLine."Qty. per Unit of Measure" := OutputShipmentLines."Unit of Mensure Quantity";
        ItemJournalLine."Quantity (Base)":=OutputShipmentLines."Quantity (Base)";
        ItemJournalLine."Invoiced Qty. (Base)":=OutputShipmentLines."Quantity (Base)";
        ItemJournalLine.Amount:= OutputShipmentLines."Total Cost";
      END;
      ItemJournalLine.Description:= OutputShipmentLines.Description;
      ItemJournalLine."Location Code":= OutputShipmentLines."Outbound Warehouse";
      ItemJournalLine."Unit Amount":= OutputShipmentLines."Sales Price";
      ItemJournalLine."Unit Cost":= OutputShipmentLines."Unit Cost";
      ItemJournalLine."Shortcut Dimension 1 Code":= OutputShipmentLines."Shortcut Dimension 1 Code";
      ItemJournalLine."Shortcut Dimension 2 Code":= OutputShipmentLines."Shortcut Dimension 2 Code";
      ItemJournalLine."Posting No. Series":= OutputShipmentHeader."Posting Series No.";
      ItemJournalLine."Unit of Measure Code":= OutputShipmentLines."Unit of Measure Code";
      ItemJournalLine."Qty. per Unit of Measure" := OutputShipmentLines."Unit of Mensure Quantity";

      Item.GET(OutputShipmentLines."No.");
      ItemJournalLine."Inventory Posting Group" := Item."Inventory Posting Group";
      ItemJournalLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group" ;
      ItemJournalLine."Source Code" := SrcCode;
      ItemJournalLine."Variant Code" := OutputShipmentLines."Variant Code";
      ItemJournalLine."Job No." := OutputShipmentLines."Job No.";
      //-AML QB_ST01 A�adidos los campos de control de QB_ST01
      IF  (OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::Shipment) AND (OutputShipmentHeader."Purchase Rcpt. No." <>'')
         THEN ItemJournalLine."QB Stocks Document Type" :=  ItemJournalLine."QB Stocks Document Type"::Receipt;
      IF  (OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::Shipment) AND (OutputShipmentHeader."Purchase Rcpt. No." = '')
         THEN ItemJournalLine."QB Stocks Document Type" :=  ItemJournalLine."QB Stocks Document Type"::"Output Shipment";
      IF OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::"Receipt.Return" THEN ItemJournalLine."QB Stocks Document Type" :=  ItemJournalLine."QB Stocks Document Type"::"Return Receipt";
      IF OutputShipmentHeader."Purchase Rcpt. No." <> '' THEN ItemJournalLine."QB Stocks Document No" := OutputShipmentHeader."Purchase Rcpt. No."
      ELSE ItemJournalLine."QB Stocks Document No" := PostedOutputShipmentHeader."No.";
      ItemJournalLine."QB Stocks Output Shipment Line" := OutputShipmentLines."Line No.";
      ItemJournalLine."QB Stocks Output Shipment No." := PostedOutputShipmentHeader."No.";
      //+AML QB_ST01 A�adidos los campos de control de QB_ST01
      //-AML Para cancelar la salida contra un movmiento
      IF (OutputShipmentLines."Cancel Mov." <> 0) THEN BEGIN
        IF ItemLedgerEntry.GET(OutputShipmentLines."Cancel Mov.") THEN BEGIN
          IF ItemLedgerEntry.Positive THEN ItemJournalLine.VALIDATE("Applies-to Entry" ,OutputShipmentLines."Cancel Mov.");
        END;
      END;
      //+AML

      IF OutputShipmentLines."No. Serie for Tracking" <> '' THEN BEGIN
        ReservationEntry.RESET;
        IF ReservationEntry.FINDLAST THEN
          ReserveNumber := ReservationEntry."Entry No."
        ELSE
          ReserveNumber := 0;
        ReservationEntry.INIT;
        ReserveNumber := ReserveNumber + 1;
        ReservationEntry."Entry No." := ReserveNumber;
        ReservationEntry.Positive := FALSE;
        ReservationEntry.VALIDATE("Item No.",OutputShipmentLines."No.");
        ReservationEntry.VALIDATE("Location Code",OutputShipmentLines."Outbound Warehouse");
        ReservationEntry.VALIDATE("Quantity (Base)",-OutputShipmentLines."Quantity (Base)" * ItemJournalLine."Qty. per Unit of Measure");
        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
        ReservationEntry.Description := '';
        ReservationEntry."Creation Date" := WORKDATE;
        ReservationEntry."Transferred from Entry No." := 0;
        IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Purchase THEN
          ReservationEntry."Source Type" := DATABASE::"Purchase Line"
        ELSE
          ReservationEntry."Source Type" := DATABASE::"Sales Line";
        ReservationEntry."Source Subtype" := 3;
        ReservationEntry."Source ID" := '';
        ReservationEntry."Source Batch Name" := '';
        ReservationEntry."Source Prod. Order Line" := 0;
        ReservationEntry."Source Ref. No." := ItemJournalLine."Line No.";
        ReservationEntry."Shipment Date" := OutputShipmentHeader."Posting Date";
        ReservationEntry."Created By" := USERID;
        ReservationEntry."Qty. per Unit of Measure" := ItemJournalLine."Qty. per Unit of Measure";
        ReservationEntry.VALIDATE(Quantity,-OutputShipmentLines.Quantity);
        ReservationEntry."Qty. to Handle (Base)" := -OutputShipmentLines."Quantity (Base)" * ItemJournalLine."Qty. per Unit of Measure";
        ReservationEntry.Binding := ReservationEntry.Binding::" ";
        ReservationEntry."Suppressed Action Msg." := FALSE;
        ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
        ReservationEntry.VALIDATE("Serial No.",OutputShipmentLines."No. Serie for Tracking");
        ReservationEntry.INSERT(TRUE);
      END ELSE BEGIN
        IF OutputShipmentLines."No. Lot for Tracking" <> '' THEN BEGIN
          ReservationEntry.RESET;
          IF ReservationEntry.FINDLAST THEN
            ReserveNumber := ReservationEntry."Entry No."
          ELSE
            ReserveNumber := 0;
          ReservationEntry.INIT;
          ReserveNumber := ReserveNumber + 1;
          ReservationEntry."Entry No." := ReserveNumber;
          ReservationEntry.Positive := FALSE;
          ReservationEntry.VALIDATE("Item No.",OutputShipmentLines."No.");
          ReservationEntry.VALIDATE("Location Code",OutputShipmentLines."Outbound Warehouse");
          ReservationEntry.VALIDATE("Quantity (Base)",-OutputShipmentLines."Quantity (Base)" * ItemJournalLine."Qty. per Unit of Measure");
          ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
          ReservationEntry.Description := '';
          ReservationEntry."Creation Date" := WORKDATE;
          ReservationEntry."Transferred from Entry No." := 0;
          IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Purchase THEN
            ReservationEntry."Source Type" := DATABASE::"Purchase Line"
          ELSE
            ReservationEntry."Source Type" := DATABASE::"Sales Line";
          ReservationEntry."Source Subtype" := 3;
          ReservationEntry."Source ID" := '';
          ReservationEntry."Source Batch Name" := '';
          ReservationEntry."Source Prod. Order Line" := 0;
          ReservationEntry."Source Ref. No." := ItemJournalLine."Line No.";
          ReservationEntry."Shipment Date" := OutputShipmentHeader."Posting Date";
          ReservationEntry."Created By" := USERID;
          ReservationEntry."Qty. per Unit of Measure" := -ItemJournalLine."Qty. per Unit of Measure";
          ReservationEntry.VALIDATE(Quantity,-OutputShipmentLines.Quantity);
          ReservationEntry."Qty. to Handle (Base)" := -OutputShipmentLines."Quantity (Base)" * ItemJournalLine."Qty. per Unit of Measure";
          ReservationEntry.Binding := ReservationEntry.Binding::" ";
          ReservationEntry."Suppressed Action Msg." := FALSE;
          ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
          ReservationEntry.VALIDATE("Lot No.",OutputShipmentLines."No. Lot for Tracking");
          ReservationEntry.INSERT(TRUE);
        END;
      END;

      IF Item."Item Tracking Code" <> '' THEN
        TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
            ItemJournalLine."Entry Type".AsInteger(),ItemJournalLine."Journal Template Name",
            ItemJournalLine."Journal Batch Name",0,ItemJournalLine."Line No.",
            ItemJournalLine."Qty. per Unit of Measure",ReservationEntry,ReservationEntry."Quantity (Base)");

      ItemJournalLine."Dimension Set ID" := OutputShipmentLines."Dimension Set ID";
      ItemJnlPostLine.RunWithCheck(ItemJournalLine);  //AML Descomentar

      //CPA 14/12/2021 - Q15921. Errores detectados en almacenes de obras.Begin
      IF OutputShipmentHeader."Automatic Shipment" THEN BEGIN
        IF (OutputShipmentLines."Item Rcpt. Entry No." <> 0) AND (OutputShipmentLines."Invoiced Quantity (Base)" <> 0) THEN
          ItemJnlPostLine.UndoValuePostingWithJob(OutputShipmentLines."Item Rcpt. Entry No.", ItemJournalLine."Item Shpt. Entry No.");
        OutputShipmentLines."Item Rcpt. Entry No." := ItemJournalLine."Item Shpt. Entry No.";
        OutputShipmentLines.MODIFY;
      END;
      //CPA 14/12/2021 - Q15921. Errores detectados en almacenes de obras.End

      InsertTracking;
    END;

    PROCEDURE CreateGLEntries();
    VAR
      GenJnlPostLine : Codeunit 12;
      QuoBuildingSetup : Record 7207278;
      DefaultDimension : Record 352;
      PurchasesPayablesSetup : Record 312;
    BEGIN
      PurchasesPayablesSetup.GET;
      IF PurchasesPayablesSetup."QB Stocks Post Inv.Cost to G/L" THEN EXIT;

      //Crear movimiento contable
      LineCountCont := LineCountCont + 1;
      Window.UPDATE(7,LineCountCont);

      InventoryPostingSetupControl(OutputShipmentLines."Outbound Warehouse",Item."Inventory Posting Group");

      GenJournalLine.INIT;
      QuoBuildingSetup.GET;
      QuoBuildingSetup.TESTFIELD("Delivery Note Batch Book");
      GenJournalLine."Journal Template Name" := QuoBuildingSetup."Delivery Note Book";
      GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Delivery Note Batch Book";

      GenJournalLine."Account No.":=InventoryPostingSetup."Location Account Consumption";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
      GenJournalLine."Document Type":=GenJournalLine."Document Type"::" ";
      GenJournalLine."Posting Date":=OutputShipmentHeader."Posting Date";
      GenJournalLine."Document No.":=GenJnlLineDocNo;
      GenJournalLine."External Document No." := PostedOutputShipmentHeader."Purchase Rcpt. No.";
      GLAccount.GET(InventoryPostingSetup."Location Account Consumption");
      GenJournalLine.Description:=GLAccount.Name;
      GenJournalLine.Amount:=ROUND(OutputShipmentLines."Total Cost",0.01);
      GenJournalLine."Amount (LCY)":=ROUND(OutputShipmentLines."Total Cost",0.01);
      GenJournalLine."Currency Factor":=1;
      GenJournalLine.Correction:=FALSE;
      GenJournalLine."Usage/Sale":=GenJournalLine."Usage/Sale"::Usage;
      GenJournalLine."System-Created Entry":=TRUE;
      GenJournalLine."Source Type":=GenJournalLine."Source Type"::" ";
      GenJournalLine."Shortcut Dimension 1 Code" := OutputShipmentLines."Shortcut Dimension 1 Code";
      GenJournalLine."Shortcut Dimension 2 Code" := OutputShipmentLines."Shortcut Dimension 2 Code";
      GenJournalLine."Job No.":=OutputShipmentHeader."Job No.";;
      GenJournalLine."Piecework Code":=OutputShipmentLines."Produccion Unit";
      GenJournalLine."Job Task No." := OutputShipmentLines."Job Task No.";
      GenJournalLine.Quantity:=OutputShipmentLines.Quantity;
      GenJournalLine."Posting No. Series" := OutputShipmentHeader."Posting Series No.";
      GenJournalLine."Already Generated Job Entry" := TRUE;
      GenJournalLine."Source Code":=SrcCode;
      GenJournalLine."Dimension Set ID" := OutputShipmentLines."Dimension Set ID";
      //-AML QB_ST01 A�adidos los campos de control de QB_ST01
      IF (OutputShipmentHeader."Purchase Rcpt. No." <> '') AND (OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::Shipment) THEN
        GenJournalLine."QB Stocks Document Type" :=  ItemJournalLine."QB Stocks Document Type"::Receipt;
      IF (OutputShipmentHeader."Purchase Rcpt. No." = '') AND (OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::Shipment) THEN
        GenJournalLine."QB Stocks Document Type" :=  ItemJournalLine."QB Stocks Document Type"::"Output Shipment";

      IF (OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::"Receipt.Return") THEN
        GenJournalLine."QB Stocks Document Type" :=  ItemJournalLine."QB Stocks Document Type"::"Return Receipt";

      IF OutputShipmentHeader."Purchase Rcpt. No." <> '' THEN GenJournalLine."QB Stocks Document No" := OutputShipmentHeader."Purchase Rcpt. No."
       ELSE GenJournalLine."QB Stocks Document No" := PostedOutputShipmentHeader."No.";

      GenJournalLine."QB Stocks Output Shipment Line" := OutputShipmentLines."Line No.";
      GenJournalLine."QB Stocks Output Shipment No." := PostedOutputShipmentHeader."No.";
      GenJournalLine."QB Stocks Item No." := OutputShipmentLines."No.";
      //+AML QB_ST01 A�adidos los campos de control de QB_ST01


      FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,InventoryPostingSetup."Analytic Concept",GenJournalLine."Dimension Set ID");
      DimMgt.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID",GenJournalLine."Shortcut Dimension 1 Code",GenJournalLine."Shortcut Dimension 2 Code");

      GenJnlPostLine.RunWithCheck(GenJournalLine);

      LineCountCont := LineCountCont + 1;
      Window.UPDATE(7,LineCountCont);

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name" := QuoBuildingSetup."Delivery Note Book";
      GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Delivery Note Batch Book";
      GenJournalLine."Account No.":=InventoryPostingSetup."App.Account Locat Acc. Consum.";
      GenJournalLine."Document Type":=GenJournalLine."Document Type"::" ";
      GenJournalLine."Posting Date":=OutputShipmentHeader."Posting Date";
      GenJournalLine."Document No.":=GenJnlLineDocNo;
      GenJournalLine.Description:=OutputShipmentLines.Description;
      GenJournalLine.Amount:=-ROUND(OutputShipmentLines."Total Cost",0.01);
      GenJournalLine."Amount (LCY)":=-ROUND(OutputShipmentLines."Total Cost",0.01);
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
      GenJournalLine."External Document No." := PostedOutputShipmentHeader."Purchase Rcpt. No.";
      GLAccount.GET(InventoryPostingSetup."App.Account Locat Acc. Consum.");
      GenJournalLine.Description:=GLAccount.Name;
      GenJournalLine."Currency Factor":=1;
      GenJournalLine.Correction:=FALSE;
      GenJournalLine."Usage/Sale":=GenJournalLine."Usage/Sale"::Usage;
      GenJournalLine."System-Created Entry":=TRUE;
      GenJournalLine."Source Type":=GenJournalLine."Source Type"::" ";
      DimValue.GET(FunctionQB.ReturnDimDpto,Location."QB Departament Code");
      GenJournalLine."Job No.":=DimValue."Job Structure Warehouse";

      GenJournalLine."Piecework Code":='';
      GenJournalLine."Job Task No." := '';

      GenJournalLine.Quantity := OutputShipmentLines.Quantity;
      GenJournalLine."Posting No. Series" := OutputShipmentHeader."Posting Series No.";
      GenJournalLine."Already Generated Job Entry" := TRUE;
      GenJournalLine."Source Code" := SrcCode;

      GenJournalLine."Dimension Set ID" := OutputShipmentLines."Dimension Set ID";
      //-AML QB_ST01 A�adidos los campos de control de QB_ST01
      IF (OutputShipmentHeader."Purchase Rcpt. No." <> '') AND (OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::Shipment) THEN
        GenJournalLine."QB Stocks Document Type" :=  ItemJournalLine."QB Stocks Document Type"::Receipt;
      IF (OutputShipmentHeader."Purchase Rcpt. No." = '') AND (OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::Shipment) THEN
        GenJournalLine."QB Stocks Document Type" :=  ItemJournalLine."QB Stocks Document Type"::"Output Shipment";

      IF (OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::"Receipt.Return") THEN
          GenJournalLine."QB Stocks Document Type" :=  ItemJournalLine."QB Stocks Document Type"::"Return Receipt";

      IF OutputShipmentHeader."Purchase Rcpt. No." <> '' THEN
        GenJournalLine."QB Stocks Document No" := OutputShipmentHeader."Purchase Rcpt. No."
       ELSE GenJournalLine."QB Stocks Document No" := PostedOutputShipmentHeader."No.";

      GenJournalLine."QB Stocks Output Shipment Line" := OutputShipmentLines."Line No.";
      GenJournalLine."QB Stocks Output Shipment No." := PostedOutputShipmentHeader."No.";
      GenJournalLine."QB Stocks Item No." := OutputShipmentLines."No.";
      //+AML QB_ST01 A�adidos los campos de control de QB_ST01

      FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto,Location."QB Departament Code",GenJournalLine."Dimension Set ID");
      FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,JobJournalLine."Job No.",GenJournalLine."Dimension Set ID");

      DefaultDimension.SETRANGE("Table ID",DATABASE::Job);
      DefaultDimension.SETRANGE("No.",DimValue."Job Structure Warehouse");
      IF DefaultDimension.FINDSET(FALSE) THEN
        REPEAT
          IF DefaultDimension."Value Posting" = DefaultDimension."Value Posting"::"Same Code" THEN BEGIN
            FunctionQB.UpdateDimSet(DefaultDimension."Dimension Code",DefaultDimension."Dimension Value Code",GenJournalLine."Dimension Set ID");
          END;
        UNTIL DefaultDimension.NEXT = 0;

      FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,InventoryPostingSetup."App. Account Concept Analytic",GenJournalLine."Dimension Set ID");
      DimMgt.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID",GenJournalLine."Shortcut Dimension 1 Code",GenJournalLine."Shortcut Dimension 2 Code");

      GenJnlPostLine.RunWithCheck(GenJournalLine);
    END;

    PROCEDURE LineControl();
    VAR
      Location : Record 14;
    BEGIN
      //Verificar informaci�n de las l�neas
      OutputShipmentLines.TESTFIELD(OutputShipmentLines.Quantity);
      OutputShipmentLines.TESTFIELD(OutputShipmentLines."Outbound Warehouse");
      OutputShipmentLines.TESTFIELD("Outbound Warehouse");
      Location.GET(OutputShipmentLines."Outbound Warehouse");

      DimValue.GET(FunctionQB.ReturnDimDpto,Location."QB Departament Code");
      IF DimValue."Job Structure Warehouse"='' THEN
        //JAV 12/06/19: - Se cambia el mensaje de error TEXT003 para que sea realmente informativo
        ERROR(Text003, Job."No.", FunctionQB.ReturnDimDpto, Location."QB Departament Code" );
    END;

    PROCEDURE HeaderControl();
    BEGIN
      //Verificar informaci�n de la cabecera
      Job.GET(Job."No.");
      IF FunctionQB.GetDepartment(DATABASE::Job,OutputShipmentHeader."Job No.") = '' THEN
        ERROR(Text002,Job."No.");

      Job.GET(OutputShipmentHeader."Job No.");
      IF Job."Job Type"=Job."Job Type"::Deviations THEN
        ERROR(Text008,Job."No.");
    END;

    PROCEDURE InventoryPostingSetupControl(VAR CodeLocate : Code[10];VAR Code : Code[20]);
    BEGIN
      //Verifica informaci�n de la configuraci�n de inventario
      InventoryPostingSetup.GET(CodeLocate,Code);
      InventoryPostingSetup.TESTFIELD("Location Code");
      InventoryPostingSetup.TESTFIELD("Analytic Concept");
      InventoryPostingSetup.TESTFIELD("App. Account Concept Analytic");
      InventoryPostingSetup.TESTFIELD("Location Account Consumption");
      InventoryPostingSetup.TESTFIELD("App.Account Locat Acc. Consum.");
    END;

    PROCEDURE QuantityControl();
    VAR
      ItemLedgerEntry : Record 32;
      Item : Record 27;
    BEGIN
      //Controles del producto
      Item.GET(OutputShipmentLines."No.");
      IF Item."Item Tracking Code" = '' THEN
        EXIT;

      IF NOT OutputShipmentHeader."Sales Shipment Origin" THEN
        EXIT;

      ItemLedgerEntry.RESET;
      ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date",
                       "Expiration Date","Lot No.","Serial No.");

      ItemLedgerEntry.SETRANGE("Item No.",OutputShipmentLines."No.");
      ItemLedgerEntry.SETRANGE("Variant Code",OutputShipmentLines."Variant Code");
      ItemLedgerEntry.SETRANGE("Location Code",OutputShipmentLines."Outbound Warehouse");

      IF OutputShipmentLines."No. Serie for Tracking" <> '' THEN
        ItemLedgerEntry.SETRANGE("Serial No.",OutputShipmentLines."No. Serie for Tracking");

      IF OutputShipmentLines."No. Lot for Tracking" <> '' THEN
        ItemLedgerEntry.SETRANGE("Lot No.",OutputShipmentLines."No. Lot for Tracking");

      ItemLedgerEntry.CALCSUMS(Quantity);
      IF ItemLedgerEntry.Quantity < OutputShipmentLines."Quantity (Base)" THEN
        ERROR(Text050);
    END;

    PROCEDURE InsertTracking();
    VAR
      TrackingSpecification : Record 336;
      LastMove : Integer;
      ItemEntryRelation : Record 6507;
    BEGIN
      //Movimientos de seguimiento de productos
      IF NOT OutputShipmentHeader."Sales Shipment Origin" THEN
        IF OutputShipmentHeader."Purchase Rcpt. No." = '' THEN
          EXIT;

      IF (OutputShipmentLines."No. Serie for Tracking" = '') AND (OutputShipmentLines."No. Lot for Tracking" = '') THEN
        EXIT;

      IF TrackingSpecification.FINDLAST THEN
        LastMove := TrackingSpecification."Entry No."
      ELSE
        LastMove := 0;

      IF OutputShipmentHeader."Sales Shipment Origin" THEN BEGIN
        CLEAR(TrackingSpecification);
        LastMove := LastMove + 1;
        TrackingSpecification."Entry No." := ItemJournalLine."Item Shpt. Entry No.";
        TrackingSpecification."Item No." := OutputShipmentLines."No.";
        TrackingSpecification."Location Code" := OutputShipmentLines."Outbound Warehouse";
        TrackingSpecification."Quantity (Base)" := -OutputShipmentLines."Quantity (Base)";
        TrackingSpecification.Description := OutputShipmentLines.Description;
        TrackingSpecification."Creation Date" := OutputShipmentHeader."Posting Date";
        IF OutputShipmentHeader."Sales Shipment Origin" THEN
          TrackingSpecification."Source Type" := DATABASE::"Sales Line"
        ELSE
          TrackingSpecification."Source Type" := DATABASE::"Purchase Line";
        TrackingSpecification."Source Subtype" := OutputShipmentLines."Source Document Type";
        TrackingSpecification."Source ID" := OutputShipmentLines."No. Source Document";
        TrackingSpecification."Source Batch Name" := '';
        TrackingSpecification."Source Prod. Order Line" := 0;
        TrackingSpecification."Source Ref. No." := OutputShipmentLines."No. Source Document Line";
        TrackingSpecification."Item Ledger Entry No." := ItemJournalLine."Item Shpt. Entry No.";
        TrackingSpecification."Transfer Item Entry No." := 0;
        TrackingSpecification."Serial No." := OutputShipmentLines."No. Serie for Tracking";
        TrackingSpecification.Positive := FALSE;
        TrackingSpecification."Qty. per Unit of Measure" := OutputShipmentLines."Unit of Mensure Quantity";
        TrackingSpecification."Warranty Date" := 0D;
        TrackingSpecification."Expiration Date" := 0D;
        TrackingSpecification."Qty. to Handle (Base)" := 0;
        IF OutputShipmentHeader."Sales Shipment Origin" THEN BEGIN
          TrackingSpecification."Qty. to Invoice (Base)" := -OutputShipmentLines."Quantity (Base)";
          TrackingSpecification."Quantity Handled (Base)" := -OutputShipmentLines."Quantity (Base)";
        END ELSE BEGIN
          TrackingSpecification."Qty. to Invoice (Base)" := OutputShipmentLines."Quantity (Base)";
          TrackingSpecification."Quantity Handled (Base)" := OutputShipmentLines."Quantity (Base)";
        END;
        TrackingSpecification."Quantity Invoiced (Base)" := 0;
        TrackingSpecification."Qty. to Handle" := 0;
        TrackingSpecification."Qty. to Invoice" := 0;
        TrackingSpecification."New Serial No." := '';
        TrackingSpecification."New Lot No." := '';
        TrackingSpecification."Lot No." := OutputShipmentLines."No. Lot for Tracking";
        TrackingSpecification."Variant Code" := '';
        TrackingSpecification."Bin Code" := '';
        TrackingSpecification.Correction := FALSE;
        TrackingSpecification."Quantity actual Handled (Base)" :=  0;
        TrackingSpecification.INSERT;
      END;

      CLEAR(ItemEntryRelation);
      ItemEntryRelation."Item Entry No." := ItemJournalLine."Item Shpt. Entry No.";
      IF OutputShipmentHeader."Sales Shipment Origin" THEN BEGIN
        ItemEntryRelation."Source Type" := DATABASE::"Sales Shipment Line";
        ItemEntryRelation."Source ID" := OutputShipmentHeader."Sales Document No.";
      END ELSE BEGIN
        ItemEntryRelation."Source Type" := DATABASE::"Purch. Rcpt. Line";
        ItemEntryRelation."Source ID" := OutputShipmentHeader."Purchase Rcpt. No.";
      END;
      ItemEntryRelation."Source Subtype" := 0;
      ItemEntryRelation."Source Batch Name" := '';
      ItemEntryRelation."Source Prod. Order Line" := 0;
      ItemEntryRelation."Source Ref. No." := OutputShipmentLines."No. Source Document Line";
      ItemEntryRelation."Serial No." := OutputShipmentLines."No. Serie for Tracking";
      ItemEntryRelation."Lot No." := OutputShipmentLines."No. Lot for Tracking";
      ItemEntryRelation."Order No." := OutputShipmentLines."No. Source Document";
      ItemEntryRelation."Order Line No." := OutputShipmentLines."No. Source Document Line";
      ItemEntryRelation.INSERT;
    END;

    LOCAL PROCEDURE CheckDim();
    VAR
      OutputShipmentLines : Record 7207309;
    BEGIN
      OutputShipmentLines."Line No." := 0;
      CheckDimValuePosting(OutputShipmentLines);
      CheckDimComb(OutputShipmentLines);

      OutputShipmentLines.SETRANGE("Document No.",OutputShipmentHeader."No.");
      IF OutputShipmentLines.FINDSET THEN
        REPEAT
          CheckDimComb(OutputShipmentLines);
          CheckDimValuePosting(OutputShipmentLines);
        UNTIL OutputShipmentLines.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimComb(OutputShipmentLines : Record 7207309);
    BEGIN
      IF OutputShipmentLines."Line No." = 0 THEN
        IF NOT DimMgt.CheckDimIDComb(OutputShipmentHeader."Dimension Set ID") THEN
          ERROR(
            Text032,
            OutputShipmentHeader."No.",DimMgt.GetDimCombErr);

      IF OutputShipmentLines."Line No." <> 0 THEN
        IF NOT DimMgt.CheckDimIDComb(OutputShipmentLines."Dimension Set ID") THEN
          ERROR(
            Text033,
            OutputShipmentHeader."No.",OutputShipmentLines."Line No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting(VAR OutputShipmentLines : Record 7207309);
    VAR
      TableIDArr : ARRAY [10] OF Integer;
      NumberArr : ARRAY [10] OF Code[20];
    BEGIN
      IF OutputShipmentLines."Line No." = 0 THEN BEGIN
        TableIDArr[1] := DATABASE::Job;
        NumberArr[1] := OutputShipmentHeader."Job No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,OutputShipmentHeader."Dimension Set ID") THEN
          ERROR(
            Text034,
            Text004,OutputShipmentHeader."No.",DimMgt.GetDimValuePostingErr);
      END ELSE BEGIN

        TableIDArr[1] := DATABASE::Job;
        NumberArr[1] := OutputShipmentLines."Job No.";
        TableIDArr[2] := DATABASE::Item;
        NumberArr[2] := OutputShipmentLines."No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,OutputShipmentLines."Dimension Set ID") THEN
          ERROR(
            Text035,
            Text004,OutputShipmentHeader."No.",OutputShipmentLines."Line No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE "//CPA 21/03/23 - Q18753+"();
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostOutputShipmentHeader(VAR Rec : Record 7207308);
    BEGIN
      //CPA 21/03/23 - Q18753+
    END;

    LOCAL PROCEDURE "//CPA 21/03/23 - Q18753-"();
    BEGIN
    END;

    /*BEGIN
/*{
      JAV 12/06/19: - QB 1.00 Se cambia el mensaje de error TEXT003 para que sea realmente informativo
      JAV 02/07/20: - QB 1.05 Anulaci�n correcta de las FRI
      JAV 19/11/20: - QB 1.07.06 Cambiaba err�neamente el signo al precio de la contrapartida del diario de proyecto, por lo que al final era err�neo el signo del total
      CPA 14/12/2021 - Q15921. Errores detectados en almacenes de obras
          - GenerateItemEntries
      AML 22/03/2022 QB_ST01 En GenerateItemEntries se pone control para saber si debe hacer diario de productos.
      AML 24/03/2022 QB_ST01 A�adidos los campos de control de QB_ST01 en GenerateItemEntries
      AML 24/03/2022 QB_ST01 A�adidos los campos de control de QB_ST01 en CreateGLEntries
      CPA 21/03/23: - Q18753
                    - OnRun
                    - Nuevo evento publicador "OnBeforePostOutputShipmentHeader"
    }
END.*/
}







