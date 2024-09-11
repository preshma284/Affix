Codeunit 7207310 "Register Usage"
{
  
  
    TableNo=7207362;
    trigger OnRun()
VAR
            ItemChargeAssgntPurch : Record 5805;
            CUUpdateAnalysisView : Codeunit 410;
            CostBaseAmount : Decimal;
            DiscountVATAmount : Decimal;
          BEGIN
            IF PostingDateExists AND (ReplacePostingDate OR (rec."Posting Date" = 0D)) THEN
              rec.VALIDATE("Posting Date",PostingDate);

            rec."Preassigned Sheet Draft No." := GeneratedSheet;

            CLEARALL;
            UsageHeader.COPY(Rec);
            WITH UsageHeader DO BEGIN

            //Comprobamos los campos obligatorios
              TESTFIELD("Contract Code");
              TESTFIELD("Posting Date");
              UsageHeader.TESTFIELD(UsageHeader."Usage Date");
            END;

            ElementContractHeader.GET(rec."Contract Code");
            //Comprobamos los campos que deben de ser obligatorios al registrar el documento.
            ElementContractHeader.TESTFIELD(ElementContractHeader."Document Status",ElementContractHeader."Document Status"::Released);

            Window.OPEN(
              '#1#################################\\' +
              Text005 +
              Text007 +
              Text7000000);

            Window.UPDATE(1,STRSUBSTNO('%1',rec."No."));

            GetGLSetup;
            GetCurrency;

            //Comprobamos que el n� de serie de registro este relleno
            rec.TESTFIELD("Posting No. Series");

            //Bloqueamos las tablas a usar
            IF rec.RECORDLEVELLOCKING THEN BEGIN
              UsageLine.LOCKTABLE;
            END;

            //Tomamos el c�d. de origen.
            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup."Usage Document";

            //Creo el documento que ir� al hist�rico
            UsageHeaderHist.INIT;
            UsageHeaderHist.TRANSFERFIELDS(UsageHeader);
            UsageHeaderHist."Pre-Assigned No. Series" := rec."No. Series";
            IF rec."Next Historic No." = '' THEN BEGIN
              AssignDocNo(UsageHeader,GenJnlLineDocNo);
            END ELSE
              GenJnlLineDocNo := UsageHeader."Next Historic No.";

            UsageHeaderHist."No." := GenJnlLineDocNo;

            Window.UPDATE(1,STRSUBSTNO(Text010,rec."No.",UsageHeaderHist."No."));

            UsageHeaderHist."Source Code" := SrcCode;
            UsageHeaderHist."User ID" := USERID;
            IF rec."Preassigned Sheet Draft No." <> '' THEN BEGIN
              UsageHeaderHist."Generated Worksheet" := TRUE;
              UsageHeaderHist."Preassigned Sheet Draft No." := rec."Preassigned Sheet Draft No.";
            END;
            UsageHeaderHist."Dimension Set ID" := UsageHeader."Dimension Set ID";
            UsageHeaderHist.INSERT;

            CopyCommentLines(rec."No.",UsageHeaderHist."No.");

              // Lineas
            UsageLine.RESET;
            UsageLine.SETRANGE("Document No.",rec."No.");
            LineCount := 0;
            IF UsageLine.FINDSET(TRUE) THEN BEGIN
              REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2,LineCount);

                UsageLine.TESTFIELD(UsageLine."Delivery Mov. No.");
                UsageLine.TESTFIELD(UsageLine."No.");

                UsageLineHist.INIT;
                UsageLineHist.TRANSFERFIELDS(UsageLine);
                UsageLineHist."Document No." :=  UsageHeaderHist."No.";
                IF UsageHeader."Generated Purchase" THEN BEGIN
                  UsageLineHist."Invoiced Quantity" := UsageLineHist."Pending Quantity";
                  UsageLineHist."Pending Quantity" := 0;
                  UsageLineHist."Quantity to invoice" := 0;
                END;
                UsageLineHist."Dimension Set ID" := UsageLine."Dimension Set ID";
                UsageLineHist.INSERT;
                //Actualizo la fecha de liquidaci�n en los movimientos
                RentalElementsEntries.GET(UsageLine."Delivery Mov. No.");
                RentalElementsEntries."Return Last Date" := UsageLine."Return Date";
                RentalElementsEntries."Applied First Pending Entry" := FALSE;
                RentalElementsEntries.MODIFY;
              UNTIL UsageLine.NEXT = 0;
            END;

            rec.DELETE;
            UsageLine.DELETEALL;

            UsageCommentLine.SETRANGE("No.",rec."No.");
            UsageCommentLine.DELETEALL;

            COMMIT;
            Window.CLOSE;

            CUUpdateAnalysisView.UpdateAll(0,TRUE);
            Rec := UsageHeader;
          END;
    VAR
      GeneralLedgerSetup : Record 98;
      GLEntry : Record 17;
      UsageHeader : Record 7207362;
      UsageLine : Record 7207363;
      UsageHeaderHist : Record 7207365;
      UsageLineHist : Record 7207366;
      SourceCodeSetup : Record 242;
      UsageCommentLine : Record 7207364;
      UsageCommentLine2 : Record 7207364;
      Currency : Record 4;
      ElementContractHeader : Record 7207353;
      CUDimensionManagement : Codeunit 408;
      Window : Dialog;
      PostingDate : Date;
      GenJnlLineDocNo : Code[20];
      SrcCode : Code[10];
      LineCount : Integer;
      PostingDateExists : Boolean;
      ReplacePostingDate : Boolean;
      ReplaceDocumentDate : Boolean;
      GLSetupRead : Boolean;
      CUNoSeriesManagement : Codeunit 396;
      RentalElementsEntries : Record 7207345;
      GeneratedSheet : Code[20];
      Text001 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';
      Text005 : TextConst ENU='Posting lines              #2######\',ESP='Registrando l�neas         #2######\';
      Text007 : TextConst ENU='Posting to vendors         #4######\',ESP='Registrando Maestro      #4######\';
      Text009 : TextConst ENU='Posting lines         #2######',ESP='Registrando l�neas         #2######';
      Text010 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 -> Documento %2';
      Text023 : TextConst ENU='in the associated blanket order must not be greater than %1',ESP='en el pedido abierto asociado no debe ser superior a %1';
      Text024 : TextConst ENU='in the associated blanket order must be reduced.',ESP='en el pedido abierto asociado se debe reducir.';
      Text032 : TextConst ENU='The combination of dimensions used in %1 %2 is blocked. %3',ESP='La combinaci�n de dimensiones utilizadas en el documento %1 est� bloqueada. %3';
      Text033 : TextConst ENU='The combination of dimensions used in %1 %2, line no. %3 is blocked. %4',ESP='La combinaci�n de dimensiones utilizadas en el documento %1  n� l�nea %3 est� bloqueada. %4';
      Text034 : TextConst ENU='The dimensions used in %1 %2 are invalid. %3',ESP='Las dimensiones usadas en %1 %2 son inv�lidas %3';
      Text035 : TextConst ENU='The dimensions used in %1 %2, line no. %3 are invalid. %4',ESP='Las dim. usadas en %1 %2, no. l�n. %3 son inv�lidas %4';
      Text7000000 : TextConst ENU='Creating documents         #6######',ESP='Creando documentos         #6######';
      Loctexto7021500 : TextConst ENU='Movement %1 has last settlement date %2 and is later than %3',ESP='El movimiento %1 tiene fecha de �ltima liquidaci�n %2 y es posterior a la que pretende hacer %3';

    PROCEDURE SetPostingDate(NewReplacePostingDate : Boolean;NewReplaceDocumentDate : Boolean;NewPostingDate : Date);
    BEGIN
      PostingDateExists := TRUE;
      ReplacePostingDate := NewReplacePostingDate;
      ReplaceDocumentDate := NewReplaceDocumentDate;
      PostingDate := NewPostingDate;
    END;

    LOCAL PROCEDURE GetCurrency();
    BEGIN
      WITH UsageHeader DO
        IF "Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          Currency.GET("Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
    END;

    LOCAL PROCEDURE ReverseAmount(VAR LOUsageLine : Record 7207363);
    BEGIN
      //Cambia todos los importes de las lineas del documento al signo contrario.
      WITH UsageLine DO BEGIN
        Amount := -Amount;
      END;
    END;

    LOCAL PROCEDURE Increment(VAR Number : Decimal;Number2 : Decimal);
    BEGIN
      Number := Number + Number2;
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber : Code[20];ToNumber : Code[20]);
    BEGIN
      UsageCommentLine.SETRANGE("No.",FromNumber);
      IF UsageCommentLine.FINDSET(TRUE) THEN
        REPEAT
         UsageCommentLine2 := UsageCommentLine;
         UsageCommentLine2."No." := ToNumber;
         UsageCommentLine2.INSERT;
       UNTIL UsageCommentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
      IF NOT GLSetupRead THEN
        GeneralLedgerSetup.GET;
      GLSetupRead := TRUE;
    END;

    PROCEDURE CreatePurchaseOrder(VAR parUsageHeader : Record 7207362);
    VAR
      LOPurchaseHeader : Record 38;
      LORentalElementsSetup : Record 7207346;
      LOUsageLine : Record 7207363;
      LOPurchaseLine : Record 39;
      LORentalElements : Record 7207344;
      Price : Decimal;
      CUPurchPost : Codeunit 90;
      LOElementContractLines : Record 7207354;
    BEGIN
      IF parUsageHeader."Contract Type" = parUsageHeader."Contract Type"::Customer THEN
        EXIT;

      parUsageHeader.TESTFIELD("Contract Code");
      parUsageHeader.TESTFIELD("Posting Date");
      parUsageHeader.TESTFIELD("Usage Date");

      ElementContractHeader.GET(parUsageHeader."Contract Code");
      ElementContractHeader.TESTFIELD(ElementContractHeader."Document Status",ElementContractHeader."Document Status"::Released);

      AssignDocNo(parUsageHeader,GenJnlLineDocNo);

      LORentalElementsSetup.GET;

      CLEAR(LOPurchaseHeader);
      LOPurchaseHeader."Document Type" := LOPurchaseHeader."Document Type"::Order;
      LOPurchaseHeader."No." := '';
      LOPurchaseHeader.INSERT(TRUE);
      LOPurchaseHeader.VALIDATE("Buy-from Vendor No.",parUsageHeader."Customer/Vendor No.");
      LOPurchaseHeader."QB Order To" := LOPurchaseHeader."QB Order To"::Job;
      LOPurchaseHeader.VALIDATE("QB Job No.",parUsageHeader."Job No.");
      LOPurchaseHeader.VALIDATE("Currency Code",parUsageHeader."Currency Code");
      LOPurchaseHeader.VALIDATE("Shortcut Dimension 1 Code",parUsageHeader."Shortcut Dimension 1 Code");
      LOPurchaseHeader.VALIDATE("Shortcut Dimension 2 Code",parUsageHeader."Shortcut Dimension 2 Code");
      LOPurchaseHeader.VALIDATE("Order Date",parUsageHeader."Posting Date");
      LOPurchaseHeader.VALIDATE("Posting Date",parUsageHeader."Posting Date");
      LOPurchaseHeader.Receive := TRUE;
      LOPurchaseHeader.Invoice := FALSE;
      LOPurchaseHeader.MODIFY(TRUE);

      LOUsageLine.SETRANGE("Document No.",parUsageHeader."No.");
      IF LOUsageLine.FINDSET THEN
        REPEAT
          CLEAR(LOPurchaseLine);
          LOPurchaseLine."Document Type" := LOPurchaseHeader."Document Type";
          LOPurchaseLine."Document No." := LOPurchaseHeader."No.";
          LOPurchaseLine."Line No." := LOUsageLine."Line No.";
          LOPurchaseLine.INSERT(TRUE);

          LORentalElements.GET(LOUsageLine."No.");
          LORentalElements.TESTFIELD(LORentalElements."Invoicing Resource");
          LOPurchaseLine.VALIDATE(Type,LOPurchaseLine.Type::Resource);
          LOPurchaseLine.VALIDATE(LOPurchaseLine."No.",LORentalElements."Invoicing Resource");
          LOPurchaseLine.VALIDATE(Quantity,LOUsageLine."Quantity to invoice");
          Price := LOUsageLine."Unit Price";
          LOPurchaseLine.VALIDATE("Direct Unit Cost",Price);
          LOPurchaseLine."Usage Document" := parUsageHeader."Next Historic No.";
          LOPurchaseLine."Usage Document Line" := LOUsageLine."Line No.";
          LOPurchaseLine.VALIDATE("Job No.",parUsageHeader."Job No.");
          LOPurchaseLine.VALIDATE("Piecework No.",LOUsageLine."Piecework Code");
          LOPurchaseLine.VALIDATE("Shortcut Dimension 1 Code",LOUsageLine."Shortcut Dimension 1 Code");
          LOPurchaseLine.VALIDATE("Shortcut Dimension 2 Code",LOUsageLine."Shortcut Dimension 2 Code");
          LOPurchaseLine."Dimension Set ID" := LOUsageLine."Dimension Set ID";

          LOElementContractLines.SETRANGE(LOElementContractLines."Document No.",LOUsageLine."Contract Code");
          LOElementContractLines.SETRANGE("No.",LOUsageLine."No.");
          LOElementContractLines.SETRANGE("Job No.",LOUsageLine."Job No.");
          LOElementContractLines.SETRANGE("Piecework Code",LOUsageLine."Piecework Code");
          LOElementContractLines.SETRANGE("Variant Code",LOUsageLine."Variant Code");
          IF LOElementContractLines.FINDFIRST THEN
            LOPurchaseLine.Description := LOElementContractLines.Description;
          LOPurchaseLine.MODIFY(TRUE);
        UNTIL LOUsageLine.NEXT = 0;

      CLEAR(CUPurchPost);
      CUPurchPost.RUN(LOPurchaseHeader);

      parUsageHeader."Generated Purchase" := TRUE;
    END;

    PROCEDURE CreateWorksheet(parUsageHeader : Record 7207362;VAR GeneratedDocum : Code[20]);
    VAR
      LOWorksheetHeader : Record 7207290;
      LOUsageLine : Record 7207363;
      LOWorkSheetLines : Record 7207291;
      LORentalElements : Record 7207344;
      LOResource : Record 156;
      LOTexto : TextConst ENU='Usage Doc. %1 and contract %2',ESP='Doc Util.  %1 y contrato %2';
      LOElementContractLines : Record 7207354;
    BEGIN
      parUsageHeader.TESTFIELD("Contract Code");
      parUsageHeader.TESTFIELD("Posting Date");
      parUsageHeader.TESTFIELD("Usage Date");

      ElementContractHeader.GET(parUsageHeader."Contract Code");
      ElementContractHeader.TESTFIELD(ElementContractHeader."Document Status",ElementContractHeader."Document Status"::Released);

      LOWorksheetHeader.INIT;
      LOWorksheetHeader."No." := '';
      LOWorksheetHeader.INSERT(TRUE);
      LOWorksheetHeader."Sheet Type" := LOWorksheetHeader."Sheet Type"::"By Job";
      LOWorksheetHeader.VALIDATE("No. Resource /Job",parUsageHeader."Job No.");
      LOWorksheetHeader."Posting Date" := parUsageHeader."Posting Date";
      LOWorksheetHeader."Rental Machinery" := TRUE;
      LOWorksheetHeader.VALIDATE("Sheet Date",parUsageHeader."Usage Date");
      LOWorksheetHeader."Posting Description" := STRSUBSTNO(LOTexto,FORMAT(parUsageHeader."No."),FORMAT(parUsageHeader."Contract Code"));
      LOWorksheetHeader.MODIFY;
      LOUsageLine.SETRANGE("Document No.",parUsageHeader."No.");
      IF LOUsageLine.FINDSET THEN
        REPEAT
          LOWorkSheetLines.INIT;
          LOWorkSheetLines."Document No." := LOWorksheetHeader."No.";
          LOWorkSheetLines."Line No." := LOUsageLine."Line No.";
          LOWorkSheetLines.INSERT(TRUE);
          LORentalElements.GET(LOUsageLine."No.");
          LOResource.GET(LORentalElements."Invoicing Resource");
          LOWorkSheetLines.VALIDATE("Resource No.",LORentalElements."Invoicing Resource");
          LOWorkSheetLines.VALIDATE("Work Day Date",LOUsageLine."Return Date");
          LOWorkSheetLines.VALIDATE("Work Type Code",LORentalElements."Work Type");
          LOWorkSheetLines.VALIDATE("Piecework No.",LOUsageLine."Piecework Code");
          LOWorkSheetLines.VALIDATE(Quantity,LOUsageLine."Quantity to invoice");
          LOWorkSheetLines.VALIDATE("Sales Price",LOUsageLine."Unit Price");
          LOWorkSheetLines.VALIDATE("Direct Cost Price",LOUsageLine."Unit Price");
          LOWorkSheetLines.VALIDATE("Cost Price",LOUsageLine."Unit Price");
          LOWorkSheetLines.VALIDATE("Piecework No.",LOUsageLine."Piecework Code");
          LOWorkSheetLines.VALIDATE("Shortcut Dimension 1 Code",LOUsageLine."Shortcut Dimension 1 Code");
          LOWorkSheetLines.VALIDATE("Shortcut Dimension 2 Code",LOUsageLine."Shortcut Dimension 2 Code");
          LOElementContractLines.SETRANGE(LOElementContractLines."Document No.",LOUsageLine."Contract Code");
          LOElementContractLines.SETRANGE("No.",LOUsageLine."No.");
          LOElementContractLines.SETRANGE("Job No.",LOUsageLine."Job No.");
          LOElementContractLines.SETRANGE("Piecework Code",LOUsageLine."Piecework Code");
          LOElementContractLines.SETRANGE("Variant Code",LOUsageLine."Variant Code");
          IF LOElementContractLines.FINDFIRST THEN
            LOWorkSheetLines.Description := LOElementContractLines.Description;
          LOWorkSheetLines.MODIFY;
        UNTIL LOUsageLine.NEXT = 0;
      GeneratedDocum := LOWorksheetHeader."No.";
      GeneratedSheet :=LOWorksheetHeader."No.";
    END;

    PROCEDURE AssignDocNo(VAR LOUsageHeader : Record 7207362;VAR parGenJnlLineDocNo : Code[20]);
    BEGIN
      parGenJnlLineDocNo := CUNoSeriesManagement.GetNextNo(LOUsageHeader."Posting No. Series",LOUsageHeader."Posting Date",TRUE);
      LOUsageHeader."Next Historic No." := parGenJnlLineDocNo;
    END;

    /* /*BEGIN
END.*/
}







