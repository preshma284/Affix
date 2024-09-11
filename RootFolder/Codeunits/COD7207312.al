Codeunit 7207312 "Record Delivery/Return Element"
{
  
  
    TableNo=7207356;
    trigger OnRun()
BEGIN
            IF PostingDateExists AND (ReplacePostingDate OR (rec."Posting Date" = 0D)) THEN
              rec.VALIDATE("Posting Date",PostingDate);
            CLEARALL;
            HeaderDeliveryReturnElement.COPY(Rec);
            WITH HeaderDeliveryReturnElement DO BEGIN
            // Comprobamos los campos obligatorios
              TESTFIELD("Contract Code");
              TESTFIELD("Posting Date");
            END;

            ElementContractHeader.GET(rec."Contract Code");
            // Comprobamos los campos que deben de ser obligatorios al registrar el documento.
            ElementContractHeader.TESTFIELD(ElementContractHeader."Document Status",ElementContractHeader."Document Status"::Released);

            // Sino no hay nada que registrar entonces

            Window.OPEN(
              '#1#################################\\' +
              Text005 +
              Text007 +
              Text7000000);

            Window.UPDATE(1,STRSUBSTNO('%1',rec."No."));

            GetCurrency;

            //Comprobamos que el n� de serie de registro este relleno
            rec.TESTFIELD("Posting No. Series");

            //Bloqueamos las tablas a usar
            IF rec.RECORDLEVELLOCKING THEN BEGIN
              LineDeliveryReturnElement.LOCKTABLE;
            END;

            //Tomamos el c�d. de origen.
            SourceCodeSetup.GET;
            IF HeaderDeliveryReturnElement."Document Type" = HeaderDeliveryReturnElement."Document Type"::Delivery THEN
              SrcCode := SourceCodeSetup."Rent Delivery"
            ELSE
              SrcCode := SourceCodeSetup."Rent Return";

            //Creo el documento que ir� al hist�rico
            HistHeadDelivRetElement.INIT;
            HistHeadDelivRetElement.TRANSFERFIELDS(HeaderDeliveryReturnElement);
            HistHeadDelivRetElement."Series No." := rec."Series No.";
            HistHeadDelivRetElement."No." := NoSeriesManagement.GetNextNo(rec."Posting No. Series",rec."Posting Date",TRUE);

            Window.UPDATE(1,STRSUBSTNO(Text010,rec."No.",HistHeadDelivRetElement."No."));

            HistHeadDelivRetElement."Source Code" := SrcCode;
            HistHeadDelivRetElement."User ID" := USERID;
            HistHeadDelivRetElement."Source Document" := HeaderDeliveryReturnElement."No.";
            HistHeadDelivRetElement."Dimensions Set ID" := HeaderDeliveryReturnElement."Dimensions Set ID";
            HistHeadDelivRetElement.INSERT;

            // Lineas
            LineDeliveryReturnElement.RESET;
            LineDeliveryReturnElement.SETRANGE("Document No.",rec."No.");
            CheckDim;
            LineCount := 0;
            IF LineDeliveryReturnElement.FINDSET(TRUE) THEN BEGIN
              REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2,LineCount);
                IF LineDeliveryReturnElement."Contract Code" <> '' THEN BEGIN
                  ElementJournalLine.INIT;
                  ElementJournalLine."Posting Date" := LineDeliveryReturnElement."Rent Effective Date";
                  ElementJournalLine."Document No." :=  HistHeadDelivRetElement."No.";
                  ElementJournalLine.Description := LineDeliveryReturnElement.Description;
                  ElementJournalLine."Unit Price" := LineDeliveryReturnElement."Unit Price";
                  ElementJournalLine.Quantity := LineDeliveryReturnElement."Amount to Manipulate";
                  ElementJournalLine."Entry Type" := rec."Document Type";
                  ElementJournalLine."Shortcut Dimension 1 Code" := LineDeliveryReturnElement."Shortcut Dimensios 1 Code";
                  ElementJournalLine."Shortcut Dimension 2 Code" := LineDeliveryReturnElement."Shortcut Dimension 2 Code";
                  ElementJournalLine."Reason code" := rec."Reason Code";
                  ElementJournalLine."Source Code" := SrcCode;
                  ElementJournalLine."Posting No. Series" := rec."Posting No. Series";
                  ElementJournalLine."Unit of Measure" := LineDeliveryReturnElement."Unit of Measure";
                  ElementJournalLine."Location Code" := LineDeliveryReturnElement."Location Code";
                  ElementJournalLine."Contract No." := LineDeliveryReturnElement."Contract Code";
                  ElementJournalLine."Element No." := LineDeliveryReturnElement."No.";
                  ElementJournalLine."Variante Code" := LineDeliveryReturnElement."Variant Code";
                  ElementJournalLine."Contract No." := LineDeliveryReturnElement."Contract Code";
                  ElementJournalLine."Customer No." := HeaderDeliveryReturnElement."Customer/Vendor No.";
                  ElementJournalLine."Job No." := HeaderDeliveryReturnElement."Job No.";
                  ElementJournalLine."Rent Effective Date" := HeaderDeliveryReturnElement."Rent Effective Date";
                  ElementJournalLine."Applied Entry No." := LineDeliveryReturnElement."Applicated Entry No.";
            // Para que la fecha efectiva sea la de la linea no la de la cabecera
                  ElementJournalLine."Piecework Code" := LineDeliveryReturnElement."Piecework Code";
                  ElementJournalLine."Job Task No." := LineDeliveryReturnElement."Job Task No.";
                  ElementJournalLine."Rent Effective Date" := LineDeliveryReturnElement."Rent Effective Date";
                  ElementJournalLine."Entry Pending First Applied" := TRUE;
                  ElementJournalLine."Dimensions Set ID" := LineDeliveryReturnElement."Dimension Set ID";
                  DayElementRegisterLine.RunWithCheck(ElementJournalLine);
                END;
                HistLinDelivReturnElem.INIT;
                HistLinDelivReturnElem.TRANSFERFIELDS(LineDeliveryReturnElement);
                HistLinDelivReturnElem."Document No." :=  HistHeadDelivRetElement."No.";
                HistLinDelivReturnElem."Source Document Line" := LineDeliveryReturnElement."Line No.";
                HistLinDelivReturnElem."Source Document" := LineDeliveryReturnElement."Document No.";
                HistLinDelivReturnElem."Dimension Set ID" := LineDeliveryReturnElement."Dimension Set ID";
                HistLinDelivReturnElem.INSERT;
              UNTIL LineDeliveryReturnElement.NEXT = 0;
            END;
            //No hay lineas, comprobar a ver que pasa.

            DeleteHeader(HeaderDeliveryReturnElement);

            IF VDelete THEN BEGIN
              rec.DELETE;
              LineDeliveryReturnElement.DELETEALL;
              LinesCommenDelivRetElement.SETRANGE("No.",rec."No.");
              LinesCommenDelivRetElement.DELETEALL;
            END;
            COMMIT;
            CLEAR(ElementJournalLine);
            Window.CLOSE;

            UpdateAnalysisView.UpdateAll(0,TRUE);
            Rec := HeaderDeliveryReturnElement;
          END;
    VAR
      PostingDateExists : Boolean;
      ReplacePostingDate : Boolean;
      HeaderDeliveryReturnElement : Record 7207356;
      PostingDate : Date;
      ElementContractHeader : Record 7207353;
      Window : Dialog;
      Text005 : TextConst ENU='Posting lines              #2######\',ESP='Registrando l�neas         #2######\';
      Text007 : TextConst ENU='Posting to vendors         #4######\',ESP='Registrando Maestro      #4######\';
      Text7000000 : TextConst ENU='Creating documents         #6######',ESP='Creando documentos         #6######';
      Currency : Record 4;
      LineDeliveryReturnElement : Record 7207357;
      SourceCodeSetup : Record 242;
      SrcCode : Code[10];
      HistHeadDelivRetElement : Record 7207359;
      NoSeriesManagement : Codeunit 396;
      Text010 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 -> Documento %2';
      DimensionManagement : Codeunit 408;
      Text032 : TextConst ENU='The combination of dimensions used in %1 %2 is blocked. %3',ESP='La combinaci�n de dimensiones utilizadas en el documento %1 est� bloqueada. %3';
      Text033 : TextConst ENU='The combination of dimensions used in %1 %2, line no. %3 is blocked. %4',ESP='La combinaci�n de dimensiones utilizadas en el documento %1  n� l�nea %3 est� bloqueada. %4';
      LineCount : Integer;
      ElementJournalLine : Record 7207350;
      DayElementRegisterLine : Codeunit 7207316;
      HistLinDelivReturnElem : Record 7207360;
      VDelete : Boolean;
      LinesCommenDelivRetElement : Record 7207358;
      UpdateAnalysisView : Codeunit 410;
      ReplaceDocumentDate : Boolean;
      LinesCommenDelivRetElement2 : Record 7207358;

    LOCAL PROCEDURE GetCurrency();
    BEGIN
      WITH HeaderDeliveryReturnElement DO
        IF "Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          Currency.GET("Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
    END;

    LOCAL PROCEDURE CheckDim();
    VAR
      VLineDeliveryReturnElement : Record 7207357;
    BEGIN
      VLineDeliveryReturnElement."Line No." := 0;
      CheckDimComb(VLineDeliveryReturnElement);

      VLineDeliveryReturnElement.SETRANGE("Document No.",HeaderDeliveryReturnElement."No.");
      IF VLineDeliveryReturnElement.FINDSET THEN
        REPEAT
          CheckDimComb(VLineDeliveryReturnElement);
        UNTIL VLineDeliveryReturnElement.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimComb(PLineDeliveryReturnElement : Record 7207357);
    BEGIN
      IF PLineDeliveryReturnElement."Line No." = 0 THEN
        IF NOT DimensionManagement.CheckDimIDComb(HeaderDeliveryReturnElement."Dimensions Set ID") THEN
          ERROR(
            Text032,
            HeaderDeliveryReturnElement."No.",DimensionManagement.GetDimCombErr);

      IF PLineDeliveryReturnElement."Line No." <> 0 THEN
        IF NOT DimensionManagement.CheckDimIDComb(PLineDeliveryReturnElement."Dimension Set ID") THEN
          ERROR(
            Text033,
            HeaderDeliveryReturnElement."No.",PLineDeliveryReturnElement."Line No.",DimensionManagement.GetDimCombErr);
    END;

    PROCEDURE DeleteHeader(PHeaderDeliveryReturnElement : Record 7207356);
    VAR
      VLineDeliveryReturnElement : Record 7207357;
    BEGIN
      // Se borra el documento si en todas las l�neas la cantidad manipulada = a la cantidad
      VDelete := TRUE;
      VLineDeliveryReturnElement.SETRANGE(VLineDeliveryReturnElement."Document No.",PHeaderDeliveryReturnElement."No.");
      IF VLineDeliveryReturnElement.FINDSET(FALSE) THEN
        REPEAT
          VLineDeliveryReturnElement.CALCFIELDS(VLineDeliveryReturnElement."Amount Manipulated");
          IF VLineDeliveryReturnElement."Amount Manipulated" <> VLineDeliveryReturnElement.Quantity THEN
            VDelete := FALSE;
        UNTIL VLineDeliveryReturnElement.NEXT = 0;
    END;

    PROCEDURE SetPostingDate(NewReplacePostingDate : Boolean;NewReplaceDocumentDate : Boolean;NewPostingDate : Date);
    BEGIN
      PostingDateExists := TRUE;
      ReplacePostingDate := NewReplacePostingDate;
      ReplaceDocumentDate := NewReplaceDocumentDate;
      PostingDate := NewPostingDate;
    END;

    LOCAL PROCEDURE ReverseAmount(VAR LineDeliveryReturnElement : Record 7207357);
    BEGIN

      //Cambia todos los importes de las lineas del documento al signo contrario.
      WITH LineDeliveryReturnElement DO BEGIN
        "Unit Price" := -"Unit Price";
      END;
    END;

    LOCAL PROCEDURE Increment(VAR Number : Decimal;Number2 : Decimal);
    BEGIN
      Number := Number + Number2;
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber : Code[20];ToNumber : Code[20]);
    BEGIN
      LinesCommenDelivRetElement.SETRANGE("No.",FromNumber);
      IF LinesCommenDelivRetElement.FINDSET(TRUE) THEN
        REPEAT
         LinesCommenDelivRetElement2 := LinesCommenDelivRetElement;
         LinesCommenDelivRetElement2."No." := ToNumber;
         LinesCommenDelivRetElement2.INSERT;
       UNTIL LinesCommenDelivRetElement.NEXT = 0;
    END;

    /* /*BEGIN
END.*/
}







