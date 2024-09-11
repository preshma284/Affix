Codeunit 7207274 "QB Measurements"
{
  
  
    TableNo=7207336;
    Permissions=TableData 7207338=rimd,
                TableData 7207339=rimd,
                TableData 7207341=rimd,
                TableData 7207342=rimd;
    trigger OnRun()
BEGIN
          END;
    VAR
      recMeasurementHeader : Record 7207336;
      MastJob : Record 167;
      MastCustomer : Record 18;
      SourceCodeSetup : Record 242;
      recMeasurementLines : Record 7207337;
      PieceworkSetup : Record 7207279;
      recLinComDoc : Record 7207270;
      recLinComDoc2 : Record 7207270;
      recMeasurementLines2 : Record 7207337;
      recDataPieceworkMeasCert : Record 7207386;
      recHistLinMeasurement : Record 7207339;
      recCertifications : Record 7207336;
      PostCertifications : Record 7207341;
      LinesCertification : Record 7207337;
      PostLineCertifications : Record 7207342;
      DimMgt : Codeunit 408;
      DimMgt2:codeunit 50361;
      Text005 : TextConst ENU='Posting lines              #2######\',ESP='Registrando l�neas           #2######\';
      Text7000000 : TextConst ENU='Creating documents         #6######',ESP='Creando documentos           #6######';
      Window : Dialog;
      SrcCode : Code[10];
      Text010 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 -> Documento %2';
      QuantMeasurementDraft : Decimal;
      Text011 : TextConst ENU='Measuring draft exceed the budgeted measure',ESP='La medici�n del borrador excede la presupuestada';
      LineCount : Integer;
      Text001 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';
      Text032 : TextConst ENU='The combination of dimensions used in %1 %2 is blocked. %3',ESP='La combinaci�n de dimensiones utilizadas en el documento %1 est� bloqueada. %3';
      Text033 : TextConst ENU='The combination of dimensions used in %1 %2, line no. %3 is blocked. %4',ESP='La combinaci�n de dimensiones utilizadas en el documento %1  n� l�nea %3 est� bloqueada. %4';
      Text034 : TextConst ENU='The dimensions used in %1 %2 are invalid. %3',ESP='Las dimensiones usadas en %1 %2 son inv�lidas %3';
      Text035 : TextConst ENU='The dimensions used in %1 %2, line no. %3 are invalid. %4',ESP='Las dim. usadas en %1 %2, no. l�n. %3 son inv�lidas %4';
      PostingDateExists : Boolean;
      ReplacePostingDate : Boolean;
      ReplaceDocumentDate : Boolean;
      PostingDate : Date;
      Primero : Boolean;

    PROCEDURE PostMeasurement(VAR pMeasurementHeader : Record 7207336;pCertificate : Boolean);
    VAR
      HistMeasurements : Record 7207338;
      HistMeasurements2 : Record 7207338;
      UpdateAnalysisView : Codeunit 410;
      Job : Record 167;
      Messages : Boolean;
    BEGIN
      CLEARALL;

      recMeasurementHeader.COPY(pMeasurementHeader);

      //Comprobamos los campos obligatorios
      WITH pMeasurementHeader DO BEGIN
        TESTFIELD("Document Type","Document Type"::Measuring);
        TESTFIELD("Posting Date");
        TESTFIELD("Job No.");
        TESTFIELD("Customer No.");
        TESTFIELD("No. Measure");
      END;

      MastJob.GET(pMeasurementHeader."Job No.");
      MastJob.TESTFIELD(Blocked, MastJob.Blocked::" ");

      MastCustomer.GET(pMeasurementHeader."Customer No.");
      MastCustomer.TESTFIELD(Blocked, 0);

      //Copiamos las dimensiones.
      CheckDim;

      Window.OPEN(
        '#1#################################\\' +
        Text005 +
        Text7000000);

      Window.UPDATE(1,STRSUBSTNO('%1',pMeasurementHeader."No."));

      //Bloqueamos las tablas a usar
      IF pMeasurementHeader.RECORDLEVELLOCKING THEN
          recMeasurementLines.LOCKTABLE;

      //Tomamos el c�d. de origen.
      SourceCodeSetup.GET;
      SourceCodeSetup.TESTFIELD(SourceCodeSetup."Measurements and Certif.");
      SrcCode := SourceCodeSetup."Measurements and Certif.";

      //Creo el documento que ir� al hist�rico de medici�n
      CreatePostMeasurementHeader(pMeasurementHeader, HistMeasurements);

      // Lineas
      LineCount := 0;
      Messages := TRUE;

      recMeasurementLines.RESET;
      recMeasurementLines.SETRANGE("Document No.",pMeasurementHeader."No.");
      IF (NOT recMeasurementLines.FINDSET(FALSE)) THEN
        ERROR(Text001);
      REPEAT
        LineCount := LineCount + 1;
        Window.UPDATE(2,LineCount);

        // Controles a realizar con las lineas del documento que registramos, hago un testfield de los campos obligatorios
        recMeasurementLines.TESTFIELD(recMeasurementLines."Piecework No.");
        Job.GET(recMeasurementHeader."Job No.");

        //JAV 15/09/21: - QB 1.09.18 Si el precio es cero, dar un aviso pero solo la primera vez
        IF (Messages) AND (recMeasurementLines."Sales Price" = 0) THEN BEGIN
          IF NOT CONFIRM('Tiene precios a cero, �desea continuar?', FALSE) THEN
            ERROR('Proceso cancelado');
          Messages := FALSE;
        END;


        //Comprobar antes de registrar que la medici�n de las lineas no sea superior a la presupuestada
        IF recDataPieceworkMeasCert.GET(recMeasurementLines."Job No.",recMeasurementLines."Piecework No.") THEN
          IF (recMeasurementLines."Med. Source Measure" > recDataPieceworkMeasCert."Sale Quantity (base)") THEN
            IF NOT recDataPieceworkMeasCert."Allow Over Measure" THEN //JMMA Permite registro de m�s medici�n que la de contrato si se fuerza Allow over measure
              ERROR(Text011);

        //Creo  lineas hist. medici�n
        recHistLinMeasurement.INIT;
        recHistLinMeasurement.TRANSFERFIELDS(recMeasurementLines);
        recHistLinMeasurement."Document No." := HistMeasurements."No.";
        recHistLinMeasurement."Certificated Quantity" := 0;
        recHistLinMeasurement."Quantity Measure Not Cert" := recHistLinMeasurement."Med. Term Measure";
        recHistLinMeasurement.INSERT;

        //Copio las l�neas de medici�n detalladas
        CrearPostBillofItemMeasurement(recMeasurementLines,HistMeasurements."No.");
      UNTIL recMeasurementLines.NEXT = 0;

      pMeasurementHeader.DELETE;

      recMeasurementLines.RESET;
      recMeasurementLines.SETRANGE("Document No.", pMeasurementHeader."No.");
      recMeasurementLines.DELETEALL;

      recLinComDoc.SETRANGE("No.",pMeasurementHeader."No.");
      recLinComDoc.DELETEALL;

      UpdateAnalysisView.UpdateAll(0,TRUE);

      pMeasurementHeader := recMeasurementHeader;

      //JAV 31/07/19: - Marcar la medici�n que se cancela con la que la cancel�
      IF (HistMeasurements2.GET(pMeasurementHeader."Cancel No.")) THEN BEGIN
        HistMeasurements2."Cancel By" := HistMeasurements."No.";
        HistMeasurements2."Text Measure" := COPYSTR(HistMeasurements2."Text Measure" + ' Cancelada', 1, MAXSTRLEN(HistMeasurements2."Text Measure"));
        HistMeasurements2."No. Measure" := COPYSTR(HistMeasurements2."No. Measure" + ' Cancelada', 1, MAXSTRLEN(HistMeasurements2."No. Measure"));
        HistMeasurements2.MODIFY;
      END;

      //Si certificamos la medici�n recien registrada
      IF (pCertificate) THEN
        CreateAndPostCertification(HistMeasurements);

      Window.CLOSE;
    END;

    PROCEDURE CreatePostMeasurementHeader(MeasurementHeader : Record 7207336;VAR HistMeasurements : Record 7207338);
    VAR
      NoSeriesMgt : Codeunit 396;
    BEGIN
      //Creo el documento cabecera hist. medici�n
      PieceworkSetup.GET;
      PieceworkSetup.TESTFIELD(PieceworkSetup."Series Certification No.");

      recMeasurementHeader.CalculateTotals;

      HistMeasurements.INIT;
      HistMeasurements.TRANSFERFIELDS(recMeasurementHeader);

      HistMeasurements."No." := NoSeriesMgt.GetNextNo(PieceworkSetup."Series Hist. Measure No.",recMeasurementHeader."Posting Date",TRUE);
      HistMeasurements."Pre-Assigned No. Series" :=  recMeasurementHeader."Posting No. Series";
      HistMeasurements."Source Code" := SrcCode;
      HistMeasurements."User ID" := USERID;
      HistMeasurements.INSERT;

      Window.UPDATE(1,STRSUBSTNO(Text010,recMeasurementHeader."No.",HistMeasurements."No."));

      CopyCommentLines(recMeasurementHeader."No.",HistMeasurements."No.");

      //Antes de procesar las l�neas, debo cargar las que est�n en otras mediciones, as� no tengo problemas para la cantidad a origen
      MeasurementHeader.AddLines;
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber : Code[20];ToNumber : Code[20]);
    BEGIN
      recLinComDoc.SETRANGE("No.",FromNumber);
      IF recLinComDoc.FINDSET(TRUE) THEN
       REPEAT
         recLinComDoc2 := recLinComDoc;
         recLinComDoc2."No." := ToNumber;
         recLinComDoc2.INSERT;
       UNTIL recLinComDoc.NEXT = 0;
    END;

    PROCEDURE CrearPostBillofItemMeasurement(parrecLineMeasurement : Record 7207337;parcodNumDoc : Code[20]);
    VAR
      locrecPostBillOfItemMeasurement : Record 7207396;
      locrecBillofItemMeasurement : Record 7207395;
    BEGIN
      locrecBillofItemMeasurement.RESET;
      locrecBillofItemMeasurement.SETRANGE("Document No.",parrecLineMeasurement."Document No.");
      locrecBillofItemMeasurement.SETRANGE("Line No.",parrecLineMeasurement."Line No.");
      IF locrecBillofItemMeasurement.FINDSET THEN
        REPEAT
          //Q19284 CSM 17/05/23 � Cancelar detalle de medici�n en RV. -
          locrecBillofItemMeasurement.CALCFIELDS(locrecBillofItemMeasurement."Realized Units", locrecBillofItemMeasurement."Realized Total");
          //Q19284 CSM 17/05/23 � Cancelar detalle de medici�n en RV. +
          locrecPostBillOfItemMeasurement.INIT;
          locrecPostBillOfItemMeasurement.TRANSFERFIELDS(locrecBillofItemMeasurement);
          locrecPostBillOfItemMeasurement."Document No." := parcodNumDoc;
          //Q19284 CSM 17/05/23 � Cancelar detalle de medici�n en RV. -
          locrecPostBillOfItemMeasurement."Realized Units" := locrecBillofItemMeasurement."Realized Units";
          locrecPostBillOfItemMeasurement."Realized Total" := locrecBillofItemMeasurement."Realized Total";
          //Q19284 CSM 17/05/23 � Cancelar detalle de medici�n en RV. +
          locrecPostBillOfItemMeasurement.INSERT;
        UNTIL locrecBillofItemMeasurement.NEXT = 0;
    END;

    PROCEDURE CreateAndPostCertification(HistMeasurements : Record 7207338);
    VAR
      NoSeriesMgt : Codeunit 396;
      BringPostedMeasurements : Codeunit 7207283;
      PostCertification : Codeunit 7207278;
    BEGIN
      //Crear y registrar la certificaci�n asociada a la medici�n recien registrada
      PieceworkSetup.GET;
      PieceworkSetup.TESTFIELD(PieceworkSetup."Series Certification No.");

      recCertifications.INIT;
      recCertifications.TRANSFERFIELDS(recMeasurementHeader);
      recCertifications."Document Type" := recCertifications."Document Type"::Certification;
      recCertifications."No." := NoSeriesMgt.GetNextNo(PieceworkSetup."Series Certification No.",recMeasurementHeader."Posting Date",TRUE);
      recCertifications."Posting Date" := recMeasurementHeader."Posting Date";
      recCertifications.VALIDATE(recCertifications."Job No.",recMeasurementHeader."Job No.");
      //JAV 15/10/19: - Se pone el n�mero de medici�n y el texto de registro al crear la certificaci�n. Guardo  el registro para poder validar dimensiones
      recCertifications.INSERT(TRUE);

      //JMMA 26/08/19: - A�adido para que se pueda certificar a cliente diferente
      recCertifications.VALIDATE("Customer No.",recMeasurementHeader."Customer No.");

      //JMMA ERROR EN FECHAS REGISTRO
      //-Q19892 Para que el registro se haga con la fecha de certificaci�n
      //recCertifications.VALIDATE("Posting Date", recMeasurementHeader."Posting Date");
      IF recMeasurementHeader."Certification Date" <= recMeasurementHeader."Posting Date" THEN
        recCertifications.VALIDATE("Posting Date", recMeasurementHeader."Posting Date")
      ELSE
        recCertifications.VALIDATE("Posting Date", recMeasurementHeader."Certification Date");
      //+Q19892
      recCertifications."Certification Date" := recMeasurementHeader."Certification Date";
      recCertifications."Measurement Date" := recMeasurementHeader."Measurement Date";

      // TO-DO esto no funciona bien, hay que arreglarlo con las dimensiones del cliente tambien, pero asi est� un poco mejor
      recCertifications.VALIDATE("Shortcut Dimension 1 Code", recMeasurementHeader."Shortcut Dimension 1 Code");
      recCertifications.VALIDATE("Shortcut Dimension 2 Code", recMeasurementHeader."Shortcut Dimension 2 Code");

      recCertifications."Dimension Set ID" := recMeasurementHeader."Dimension Set ID";
      recCertifications.MODIFY(TRUE);

      Window.UPDATE(1,STRSUBSTNO(Text010,recMeasurementHeader."No.",recCertifications."No."));

      //Traigo las l�neas con el proceso autom�tico
      BringPostedMeasurements.CreateLines(recCertifications."No.", HistMeasurements);

      //Registro la certificaci�n
      PostCertification.PostCertification(recCertifications, FALSE);
    END;

    PROCEDURE SetPostingDate(NewReplacePostingDate : Boolean;NewReplaceDocumentDate : Boolean;NewPostingDate : Date);
    BEGIN
      PostingDateExists := TRUE;
      ReplacePostingDate := NewReplacePostingDate;
      ReplaceDocumentDate := NewReplaceDocumentDate;
      PostingDate := NewPostingDate;
    END;

    LOCAL PROCEDURE CheckDim();
    VAR
      reclinMeasurement2 : Record 7207337;
    BEGIN
      reclinMeasurement2."Line No." := 0;
      CheckDimValuePosting(reclinMeasurement2);
      CheckDimComb(reclinMeasurement2);

      reclinMeasurement2.RESET;
      reclinMeasurement2.SETRANGE("Document No.",recMeasurementHeader."No.");
      IF reclinMeasurement2.FINDSET THEN
        REPEAT
          CheckDimComb(reclinMeasurement2);
          CheckDimValuePosting(reclinMeasurement2);
        UNTIL reclinMeasurement2.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimComb(recLinMeasurement2 : Record 7207337);
    BEGIN
      IF recLinMeasurement2."Line No." = 0 THEN
        IF NOT DimMgt.CheckDimIDComb(recMeasurementHeader."Dimension Set ID") THEN
          ERROR(
            Text032,
            recMeasurementHeader."No.",DimMgt.GetDimCombErr);

      IF recLinMeasurement2."Line No." <> 0 THEN
        IF NOT DimMgt.CheckDimIDComb(recLinMeasurement2."Dimension Set ID") THEN
          ERROR(
            Text033,
            recMeasurementHeader."No.",recLinMeasurement2."Line No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting(VAR recLinMeasurement2 : Record 7207337);
    VAR
      TableIDArr : ARRAY [10] OF Integer;
      NumberArr : ARRAY [10] OF Code[20];
    BEGIN
      IF recLinMeasurement2."Line No." = 0 THEN BEGIN
        TableIDArr[1] := DATABASE::Customer;
        NumberArr[1] := recMeasurementHeader."Customer No.";
        TableIDArr[2] := DATABASE::Job;
        NumberArr[2] := recMeasurementHeader."Job No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,recMeasurementHeader."Dimension Set ID") THEN
          ERROR(
            Text034,
            recMeasurementHeader."Document Type",recMeasurementHeader."No.",DimMgt.GetDimValuePostingErr);
      END ELSE BEGIN
        TableIDArr[1] := DimMgt2.TypeToTableID3(recLinMeasurement2."Document type");
        NumberArr[1] := recLinMeasurement2."Document No.";
        TableIDArr[2] := DATABASE::Job;
        NumberArr[2] := recLinMeasurement2."Job No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,recLinMeasurement2."Dimension Set ID") THEN
          ERROR(
            Text035,
                  recMeasurementHeader."Document Type",recMeasurementHeader."No.",recLinMeasurement2."Line No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE "--------------------------------- Acciones"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7207336, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T7207336_OnAfterInsertEvent(VAR Rec : Record 7207336;RunTrigger : Boolean);
    BEGIN
      IF (Rec."Document Type" = Rec."Document Type"::Measuring) AND (Rec."Cancel No." = '') THEN
        Rec.AddLines;
    END;

    PROCEDURE HistProdMeasureCancel(VAR HistProdMeasureHeader : Record 7207401);
    VAR
      ProdMeasureHeader : Record 7207399;
      ProdMeasureLines : Record 7207400;
      HistProdMeasureLines : Record 7207402;
      txt01 : TextConst ESP='Cuando cancela una relaci�n valorada se crea una complementaria en negativo que debe registrar, �desea crearla?';
      txt02 : TextConst ESP='Esta relaci�n ya ha sido cancelada con la %1';
      HistProdMeasureHeader2 : Record 7207401;
      txt03 : TextConst ESP='Esta relaci�n cancela a la %1';
      txt04 : TextConst ESP='No hay ninguna relaci�n a cancelar';
      txt05 : TextConst ESP='Solo puede cancelar la �ltima Valorada';
    BEGIN
      //JAV 25/07/19: - Evento HistProdMeasureCancel para cancelar una relaci�n valorada registrada, crea una en negativo
      //JAV 31/07/19: - Mira que no se cancele dos veces y se guarda la medici�n que se cancela

      IF (HistProdMeasureHeader."Cancel No." <> '') THEN
        ERROR(txt03, HistProdMeasureHeader."Cancel No.");
      IF (HistProdMeasureHeader."Cancel By" <> '') THEN
        ERROR(txt02, HistProdMeasureHeader."Cancel By");

      //Solo podemos cancelar la �ltima, si no se lian las cosas
      HistProdMeasureHeader2.RESET;
      HistProdMeasureHeader2.SETRANGE("Job No.", HistProdMeasureHeader."Job No.");                       //Que sea del proyecto
      HistProdMeasureHeader2.SETFILTER("No.", '>%1', HistProdMeasureHeader."No.");                       //Con un c�digo mayor que la actual
      HistProdMeasureHeader2.SETFILTER("Cancel By",'=%1','');                                            //Que no est� cancelada
      HistProdMeasureHeader2.SETFILTER("Cancel No.",'=%1','');                                           //Que no cancele otra
      IF (NOT HistProdMeasureHeader2.ISEMPTY) THEN
        ERROR(txt05);

      IF CONFIRM(txt01, FALSE) THEN BEGIN
        ProdMeasureHeader.TRANSFERFIELDS(HistProdMeasureHeader);
        ProdMeasureHeader."No." := '';
        ProdMeasureHeader.Description := COPYSTR('Cancelar ' + HistProdMeasureHeader.Description,1,MAXSTRLEN(ProdMeasureHeader.Description));
        ProdMeasureHeader."Cancel No." := HistProdMeasureHeader."No.";
        ProdMeasureHeader."Cancel By" := '';
        ProdMeasureHeader.INSERT(TRUE);

        ProdMeasureHeader."Measurement No." := COPYSTR(HistProdMeasureHeader."Measurement No." + ' CANCELADA',1,MAXSTRLEN(ProdMeasureHeader."Measurement No."));
        ProdMeasureHeader."Measurement Text" := COPYSTR('Cancelar ' + HistProdMeasureHeader."Measurement Text", 1, MAXSTRLEN(ProdMeasureHeader."Measurement Text"));
        ProdMeasureHeader.MODIFY(TRUE);

        HistProdMeasureLines.RESET;
        HistProdMeasureLines.SETRANGE("Document No.",HistProdMeasureHeader."No.");
        IF HistProdMeasureLines.FINDSET THEN BEGIN
          REPEAT
            ProdMeasureLines.TRANSFERFIELDS(HistProdMeasureLines);
            ProdMeasureLines."Document No." := ProdMeasureHeader."No.";
            ProdMeasureLines."Cancel Line" := TRUE;                       //JAV 21/09/20: - QB 1.06.15 Marco la l�nea como de cancelaci�n
            //JMMA 28/08/19: - Se modifica la cancelaci�n  de la valorada porque hay que poner la medici�n total menos la origen anterior
            ProdMeasureLines.VALIDATE("Piecework No.");
            ProdMeasureLines.VALIDATE("Measure Source", HistProdMeasureLines."Measure Source" - HistProdMeasureLines."Measure Term");
            //JMMA

            //Tomamos los importes del original cambiando los signos
            //JAV 24/06/22: - QB 1.10.53 Cambiar los campos PEC por COST que es mas apropiado y se eliminan los PEM
            //ProdMeasureLines.OLD_Price            :=  HistProdMeasureLines.OLD_Price;
            //ProdMeasureLines."OLD_Amount Realiced"  :=  HistProdMeasureLines."OLD_Amount To Source";
            //ProdMeasureLines."OLD_Amount Term"      := -HistProdMeasureLines."OLD_Amount Term";
            //ProdMeasureLines."OLD_Amount To Source" :=  HistProdMeasureLines."OLD_Amount Realiced";
            ProdMeasureLines."PROD Price"            :=  HistProdMeasureLines."PROD Price";
            ProdMeasureLines."PROD Amount Realiced"  :=  HistProdMeasureLines."PROD Amount to Source";
            ProdMeasureLines."PROD Amount Term"      := -HistProdMeasureLines."PROD Amount Term";
            ProdMeasureLines."PROD Amount to Source" :=  HistProdMeasureLines."PROD Amount Realiced";
            ProdMeasureLines.INSERT;

            //Q19284 CSM 10/04/23 � Cancelar el detalle de la medici�n. -
            CancelPostBillofItemMeasurement(HistProdMeasureLines."Document No.",HistProdMeasureLines."Line No.",ProdMeasureHeader."No.");
            //Q19284 CSM 10/04/23 � Cancelar el detalle de la medici�n. +

          UNTIL HistProdMeasureLines.NEXT = 0;
        END;
        //Presentarla
        PAGE.RUN(7207516,ProdMeasureHeader);
      END;
    END;

    PROCEDURE HistMeasurementsCancel(VAR HistMeasurements : Record 7207338);
    VAR
      txt01 : TextConst ESP='Cuando cancela una medici�n se crea una complementaria en negativo que debe registrar, �desea crearla?';
      MeasurementHeader : Record 7207336;
      MeasurementLines : Record 7207337;
      HistMeasureLines : Record 7207339;
      txt02 : TextConst ESP='Esta medici�n ya ha sido cancelada con la %1';
      txt03 : TextConst ESP='Esta medici�n cancela a la %1';
      txt04 : TextConst ESP='No hay ninguna medici�n a cancelar';
      txt05 : TextConst ESP='Solo puede cancelar la �ltima medici�n';
      HistMeasurements2 : Record 7207338;
    BEGIN
      //PGM y JAV 22/03/19: - Evento HistMeasurementsCancel para cancelar una medici�n registrada, hace una complementaria en negativo
      //JAV 08/04/19: - Se mejora el evento de cancelar medici�n, no se valida para que no de errores.
      //JAV 31/07/19: - Mira que no se cancele dos veces y se guarda la medici�n que se cancela

      IF (HistMeasurements."Cancel No." <> '') THEN
        ERROR(txt03, HistMeasurements."Cancel No.");
      IF (HistMeasurements."Cancel By" <> '') THEN
        ERROR(txt02, HistMeasurements."Cancel By");

      //JAV 06/06/21 - Solo podemos cancelar la �ltima, si no se lian las cosas
      HistMeasurements2.RESET;
      HistMeasurements2.SETRANGE("Job No.", HistMeasurements."Job No.");                            //Que sea del proyecto
      HistMeasurements2.SETFILTER("No.", '>%1', HistMeasurements."No.");                            //Con un c�digo mayor que la actual
      HistMeasurements2.SETFILTER("Cancel By",'=%1','');                                            //Que no est� cancelada
      HistMeasurements2.SETFILTER("Cancel No.",'=%1','');                                           //Que no cancele otra
      IF (NOT HistMeasurements2.ISEMPTY) THEN
        ERROR(txt05);

      IF CONFIRM(txt01, FALSE) THEN BEGIN
        MeasurementHeader.INIT;
        MeasurementHeader.VALIDATE("Document Type", MeasurementHeader."Document Type"::Measuring);
        MeasurementHeader.VALIDATE("Job No.", HistMeasurements."Job No.");
        MeasurementHeader.VALIDATE(Description, HistMeasurements.Description);
        MeasurementHeader.VALIDATE("Customer No.", HistMeasurements."Customer No.");
        MeasurementHeader.VALIDATE(Name, HistMeasurements.Name);
        MeasurementHeader.VALIDATE(Address, HistMeasurements.Address);
        MeasurementHeader.VALIDATE("Posting Date", HistMeasurements."Posting Date");
        MeasurementHeader."Measurement Date" := HistMeasurements."Measurement Date";
        MeasurementHeader."No. Measure" := HistMeasurements."No. Measure";
        MeasurementHeader.VALIDATE("Dimension Set ID",HistMeasurements."Dimension Set ID");
        MeasurementHeader."Text Measure" := 'Cancelar Med. ' + HistMeasurements."No.";
        MeasurementHeader."Cancel No." := HistMeasurements."No.";
        MeasurementHeader."Cancel By" := '';
        MeasurementHeader.INSERT(TRUE);

        //JAV 11/04/19: - Se pone en la cacelaci�n el mismo nro y texto de certificaci�n que la original
        MeasurementHeader."No. Measure" := COPYSTR(HistMeasurements."No. Measure" + ' cancelada', 1, MAXSTRLEN(MeasurementHeader."No. Measure"));
        MeasurementHeader."Text Measure" := COPYSTR('Cancela ' + HistMeasurements."Text Measure", 1, MAXSTRLEN(MeasurementHeader."Text Measure"));
        MeasurementHeader.MODIFY(TRUE);

        HistMeasureLines.RESET;
        HistMeasureLines.SETRANGE("Document No.",HistMeasurements."No.");
        IF HistMeasureLines.FINDSET THEN BEGIN
          REPEAT
            //IF FALSE THEN  //++++++++++++++++++++++++++++++++++++++++++++++++ Solo para probar
            IF (HistMeasureLines."Certificated Quantity" <> 0) THEN
              ERROR('No puede cancelar la medici�n pues tiene l�neas certificadas.');

            MeasurementLines.INIT;
            MeasurementLines.TRANSFERFIELDS(HistMeasureLines);
            MeasurementLines.VALIDATE("Document type",MeasurementLines."Document type"::Measuring);
            MeasurementLines.VALIDATE("Document No.",MeasurementHeader."No.");

            MeasurementLines.SetSkipMessages(TRUE);
            MeasurementLines.VALIDATE("Is Cancel Line", TRUE);
            MeasurementLines.VALIDATE("Med. Term Measure", -HistMeasureLines."Med. Term Measure");
            MeasurementLines.INSERT;

            //Q19284 CSM 10/04/23 � Cancelar el detalle de la medici�n. -
            CancelPostBillofItemMeasurement(HistMeasureLines."Document No.",HistMeasureLines."Line No.",MeasurementHeader."No.");
            //Q19284 CSM 10/04/23 � Cancelar el detalle de la medici�n. +

          UNTIL HistMeasureLines.NEXT = 0;
        END;
        //Presentarla
        PAGE.RUN(7207302,MeasurementHeader);
      END;
    END;

    PROCEDURE PostCertificationsCancel(VAR PostCertifications : Record 7207341);
    VAR
      txt01 : TextConst ESP='Cuando cancela una medici�n se crea una complementaria en negativo que debe registrar, �desea crearla?';
      MeasurementHeader : Record 7207336;
      MeasurementLines : Record 7207337;
      HistCertificationLines : Record 7207342;
      txt02 : TextConst ESP='Esta certficaci�n ya ha sido cancelada con la %1';
      txt03 : TextConst ESP='Esta certficaci�n cancela a la %1';
      txt04 : TextConst ESP='No hay ninguna certficaci�n a cancelar';
      txt05 : TextConst ESP='Solo puede cancelar la �ltima certficaci�n';
    BEGIN
      //PGM y JAV 22/03/19: - Evento PostCertificationsCancel para cancelar una certificaci�n registrada, hace una complementaria en negativo
      //JAV 08/04/19: - Se mejora el evento de cancelar certificaci�n, no se valida para que no de errores y se pone correcto el texto
      //JAV 31/07/19: - Mira que no se cancele dos veces y se guarda la medici�n que se cancela

      IF (PostCertifications."Cancel No." <> '') THEN
        ERROR(txt03, PostCertifications."Cancel No.");
      IF (PostCertifications."Cancel By" <> '') THEN
        ERROR(txt02, PostCertifications."Cancel By");

      IF CONFIRM(txt01, FALSE) THEN BEGIN
        MeasurementHeader.INIT;
        MeasurementHeader."Cancel No." := PostCertifications."No.";

        MeasurementHeader.VALIDATE("Document Type",MeasurementHeader."Document Type"::Certification);
        MeasurementHeader.VALIDATE("Job No.",PostCertifications."Job No.");
        MeasurementHeader.VALIDATE(Description,PostCertifications.Description);
        MeasurementHeader."Customer No." := PostCertifications."Customer No.";
        MeasurementHeader.VALIDATE(Name,PostCertifications.Name);
        MeasurementHeader.VALIDATE(Address,PostCertifications.Address);
        MeasurementHeader.VALIDATE("Posting Date",PostCertifications."Posting Date");
        MeasurementHeader."Measurement Date" := PostCertifications."Measurement Date";
        MeasurementHeader.VALIDATE("Dimension Set ID",PostCertifications."Dimension Set ID");
        MeasurementHeader."Cancel No." := PostCertifications."No.";
        MeasurementHeader."Cancel By" := '';
        MeasurementHeader.INSERT(TRUE);

        //JAV 11/04/19: - Se pone en la cacelaci�n el mismo nro y texto de certificaci�n que la original
        MeasurementHeader."No. Measure" := COPYSTR(PostCertifications."No. Measure" + ' cancelada', 1, MAXSTRLEN(MeasurementHeader."No. Measure"));
        MeasurementHeader."Text Measure" := COPYSTR('Cancela ' + PostCertifications."Text Measure", 1, MAXSTRLEN(MeasurementHeader."Text Measure"));
        MeasurementHeader.MODIFY(TRUE);

        HistCertificationLines.RESET;
        HistCertificationLines.SETRANGE("Document No.", PostCertifications."No.");
        IF HistCertificationLines.FINDSET THEN BEGIN
          REPEAT
            MeasurementLines.INIT;
            MeasurementLines.TRANSFERFIELDS(HistCertificationLines);
            MeasurementLines.VALIDATE("Document type", MeasurementHeader."Document Type");
            MeasurementLines.VALIDATE("Document No.", MeasurementHeader."No.");
            MeasurementLines."Cert Quantity to Term" := -HistCertificationLines."Cert Quantity to Term";
            MeasurementLines."Cert Pend. Medition Term" := -HistCertificationLines."Cert Pend. Medition Term";
            MeasurementLines."Cert Pend. Medition Origin":= -HistCertificationLines."Cert Pend. Medition Origin";
            MeasurementLines.INSERT;
            //JMMA
            MeasurementLines.VALIDATE("Cert Quantity to Term");
            MeasurementLines.MODIFY;
            //JMMA 220321

            //Q19284 CSM 10/04/23 � Cancelar el detalle de la medici�n. -
      //PDTE. ACLARAR DESDE CONSULTORIA.
      //      CancelPostBillofItemMeasurement(HistCertificationLines."Document No.",HistCertificationLines."Line No.",MeasurementHeader."No.");
            //Q19284 CSM 10/04/23 � Cancelar el detalle de la medici�n. +

          UNTIL HistCertificationLines.NEXT = 0;
        END;
        //Presentarla
        PAGE.RUN(7207321,MeasurementHeader);
      END;
    END;

    PROCEDURE PrintWS(pNro : Code[20]);
    VAR
      QBAuxMeasurementHeader : Record 7206962;
      QBAuxMeasurementLines : Record 7206963;
      QBAuxMeasurementLines2 : Record 7206963;
      QBAuxMeasurementDetLines : Record 7206964;
      MeasurementHeader : Record 7207336;
      MeasurementLines : Record 7207337;
      MeasureLinesBillofItem : Record 7207395;
      Job : Record 167;
      Customer : Record 18;
      WithholdingGroup : Record 7207330;
      DataPieceworkForProduction : Record 7207386;
      i : Integer;
    BEGIN
      //JAV 06/04/21: - QB 1.08.34 Esta funci�n imprime una Medici�n desde un WS externo
      CreateTables(pNro);
      //Enviar al WS
    END;

    PROCEDURE CreateTables(pNro : Code[20]);
    VAR
      QBAuxMeasurementHeader : Record 7206962;
      QBAuxMeasurementLines : Record 7206963;
      QBAuxMeasurementLines2 : Record 7206963;
      QBAuxMeasurementDetLines : Record 7206964;
      MeasurementHeader : Record 7207336;
      MeasurementLines : Record 7207337;
      MeasureLinesBillofItem : Record 7207395;
      Job : Record 167;
      Customer : Record 18;
      WithholdingGroup : Record 7207330;
      DataPieceworkForProduction : Record 7207386;
      i : Integer;
    BEGIN
      //JAV 06/04/21: - QB 1.08.34 Esta funci�n prepara las tablas para imprimir una medici�n borrador por un Web Service Externo

      //Elimino los datos actuales
      QBAuxMeasurementHeader.RESET;
      QBAuxMeasurementHeader.SETRANGE("No.", pNro);
      QBAuxMeasurementHeader.DELETEALL;

      QBAuxMeasurementLines.RESET;
      QBAuxMeasurementLines.SETRANGE("Document No.", pNro);
      QBAuxMeasurementLines.DELETEALL;

      QBAuxMeasurementDetLines.RESET;
      QBAuxMeasurementDetLines.SETRANGE("Document No.", pNro);
      QBAuxMeasurementDetLines.DELETEALL;

      //A�ado la cabecera
      MeasurementHeader.GET(pNro);
      Job.GET(MeasurementHeader."Job No.");
      Customer.GET(MeasurementHeader."Customer No.");
      IF NOT WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", Customer."QW Withholding Group by GE") THEN
        WithholdingGroup.INIT;

      MeasurementHeader.CalculateTotals;
      QBAuxMeasurementHeader.TRANSFERFIELDS(MeasurementHeader);

      QBAuxMeasurementHeader."Porc. GG" := Job."General Expenses / Other";
      QBAuxMeasurementHeader."Porc. BI" := Job."Industrial Benefit";
      QBAuxMeasurementHeader."Porc. Baja" := Job."Low Coefficient";
      QBAuxMeasurementHeader."Porc. RET" := WithholdingGroup."Percentage Withholding";
      QBAuxMeasurementHeader.INSERT;

      //A�ado las l�neas
      MeasurementLines.RESET;
      MeasurementLines.SETRANGE("Document No.", pNro);
      IF (MeasurementLines.FINDSET(FALSE)) THEN
        REPEAT
          MeasurementLines.CALCFIELDS("Med. Anterior PEM amount");
          IF (NOT DataPieceworkForProduction.GET(MeasurementLines."Job No.", MeasurementLines."Piecework No.")) THEN
            DataPieceworkForProduction.INIT;

          QBAuxMeasurementLines.TRANSFERFIELDS(MeasurementLines);
          QBAuxMeasurementLines."Med. Anterior PEM amount" := MeasurementLines."Med. Anterior PEM amount";
          QBAuxMeasurementLines."Code Piecework PRESTO" := DataPieceworkForProduction."Code Piecework PRESTO";
          QBAuxMeasurementLines.Parent := GetParent(QBAuxMeasurementLines."Job No.", QBAuxMeasurementLines."Piecework No.");
          QBAuxMeasurementLines."Contrat Measure" := DataPieceworkForProduction."Sale Quantity (base)";
          QBAuxMeasurementLines."Contrat Amount"  := DataPieceworkForProduction."Amount Sale Contract";
          QBAuxMeasurementLines."Unit Of Measure" := DataPieceworkForProduction."Unit Of Measure";
          QBAuxMeasurementLines."Med. Anterior"   := MeasurementLines."Med. Source Measure" - MeasurementLines."Med. Term Measure";
          QBAuxMeasurementLines.INSERT;

          //A�adimos los cap�tulos con sus sumatorios
          FOR i:=1 TO STRLEN(MeasurementLines."Piecework No.") - 1 DO BEGIN
            IF (DataPieceworkForProduction.GET(MeasurementLines."Job No.", COPYSTR(MeasurementLines."Piecework No.",1,i))) THEN BEGIN
              IF (NOT QBAuxMeasurementLines2.GET(MeasurementLines."Document No.", DataPieceworkForProduction."Piecework Code")) THEN BEGIN
                QBAuxMeasurementLines2.INIT;
                QBAuxMeasurementLines2."Document No." := MeasurementLines."Document No.";
                QBAuxMeasurementLines2."Piecework No." := DataPieceworkForProduction."Piecework Code";
                QBAuxMeasurementLines2."Code Piecework PRESTO" := DataPieceworkForProduction."Code Piecework PRESTO";
                QBAuxMeasurementLines2."Is Chapter" := TRUE;
                QBAuxMeasurementLines2.Description := DataPieceworkForProduction.Description;
                QBAuxMeasurementLines2."Description 2" := DataPieceworkForProduction."Description 2";
                QBAuxMeasurementLines2.Parent := GetParent(QBAuxMeasurementLines2."Job No.", QBAuxMeasurementLines2."Piecework No.");
                QBAuxMeasurementLines2.INSERT;
              END;
              QBAuxMeasurementLines2."Med. Term PEM Amount" += QBAuxMeasurementLines."Med. Term PEM Amount";
              QBAuxMeasurementLines2."Med. Source PEM Amount" += QBAuxMeasurementLines."Med. Source PEM Amount";
              QBAuxMeasurementLines2."Med. Anterior PEM amount" += QBAuxMeasurementLines."Med. Anterior PEM amount";
              QBAuxMeasurementLines2."Contrat Measure" := 1;
              QBAuxMeasurementLines2."Contrat Amount"  += QBAuxMeasurementLines."Contrat Amount";
              QBAuxMeasurementLines2.MODIFY;
            END;
          END;

          //Sumamos importe del contrato a la cabecera para que cuadre bien
          QBAuxMeasurementHeader."Am. PEM Con" += QBAuxMeasurementLines2."Contrat Amount";
          QBAuxMeasurementHeader.MODIFY;
        UNTIL (MeasurementLines.NEXT = 0);

      //A�ado las l�nea de medici�n detalladas
      MeasureLinesBillofItem.RESET;
      MeasureLinesBillofItem.SETRANGE("Document No.", pNro);
      IF (MeasureLinesBillofItem.FINDSET(FALSE)) THEN
        REPEAT
          QBAuxMeasurementDetLines.TRANSFERFIELDS(MeasureLinesBillofItem);
          IF NOT QBAuxMeasurementDetLines.INSERT THEN;
        UNTIL (MeasureLinesBillofItem.NEXT = 0);


      SetHeaderAmounts(QBAuxMeasurementHeader, pNro);
    END;

    LOCAL PROCEDURE GetParent(pJob : Code[20];pPiecework : Code[20]) : Code[20];
    VAR
      DataPieceworkForProduction : Record 7207386;
      i : Integer;
    BEGIN
      //Buscar el padre de una unidad
      FOR i:=STRLEN(pPiecework) - 1 DOWNTO 1 DO BEGIN
        IF (DataPieceworkForProduction.GET(pJob, COPYSTR(pPiecework,1,i))) THEN
          EXIT(DataPieceworkForProduction."Piecework Code");
      END;

      EXIT('');
    END;

    LOCAL PROCEDURE SetHeaderAmounts(QBAuxMeasurementHeader : Record 7206962;pNro : Code[20]);
    VAR
      MeasurementHeader : Record 7207336;
      Job : Record 167;
      Customer : Record 18;
      WithholdingGroup : Record 7207330;
    BEGIN
      IF (QBAuxMeasurementHeader."Am. PEM Con" <> 0) THEN
        QBAuxMeasurementHeader."Porc. Ejec." := ROUND(QBAuxMeasurementHeader."Amount Origin" * 100 / QBAuxMeasurementHeader."Am. PEM Con", 0.01)
      ELSE
        QBAuxMeasurementHeader."Porc. Ejec." := 0;
      QBAuxMeasurementHeader."Porc. Pte" := 100 - QBAuxMeasurementHeader."Porc. Ejec.";

      QBAuxMeasurementHeader."Am. PEM Mes" := QBAuxMeasurementHeader."Amount Term";
      QBAuxMeasurementHeader."Am. PEM Ant" := QBAuxMeasurementHeader."Amount Previous";
      QBAuxMeasurementHeader."Am. PEM Ori" := QBAuxMeasurementHeader."Amount Origin";

      QBAuxMeasurementHeader."Am. GG_BI_BJ Con" := CalcAmountGBB(QBAuxMeasurementHeader, QBAuxMeasurementHeader."Am. PEM Con");
      QBAuxMeasurementHeader."Am. GG_BI_BJ Mes" := CalcAmountGBB(QBAuxMeasurementHeader, QBAuxMeasurementHeader."Am. PEM Mes");
      QBAuxMeasurementHeader."Am. GG_BI_BJ Ant" := CalcAmountGBB(QBAuxMeasurementHeader, QBAuxMeasurementHeader."Am. PEM Ant");
      QBAuxMeasurementHeader."Am. GG_BI_BJ Ori" := CalcAmountGBB(QBAuxMeasurementHeader, QBAuxMeasurementHeader."Am. PEM Ori");

      QBAuxMeasurementHeader."Am. PEC Con" := QBAuxMeasurementHeader."Am. PEM Con" - QBAuxMeasurementHeader."Am. GG_BI_BJ Con";
      QBAuxMeasurementHeader."Am. PEC Mes" := QBAuxMeasurementHeader."Am. PEM Mes" - QBAuxMeasurementHeader."Am. GG_BI_BJ Mes";
      QBAuxMeasurementHeader."Am. PEC Ant" := QBAuxMeasurementHeader."Am. PEM Ant" - QBAuxMeasurementHeader."Am. GG_BI_BJ Ant";
      QBAuxMeasurementHeader."Am. PEC Ori" := QBAuxMeasurementHeader."Am. PEM Ori" - QBAuxMeasurementHeader."Am. GG_BI_BJ Ori";

      QBAuxMeasurementHeader."Am. RET Mes" := ROUND(QBAuxMeasurementHeader."Am. PEC Mes" * QBAuxMeasurementHeader."Porc. RET" / 100, 0.01);
      QBAuxMeasurementHeader."Am. RET Ant" := ROUND(QBAuxMeasurementHeader."Am. PEC Ant" * QBAuxMeasurementHeader."Porc. RET" / 100, 0.01);
      QBAuxMeasurementHeader."Am. RET Ori" := ROUND(QBAuxMeasurementHeader."Am. PEC Ori" * QBAuxMeasurementHeader."Porc. RET" / 100, 0.01);

      QBAuxMeasurementHeader."Am. TOT Mes" := QBAuxMeasurementHeader."Am. PEC Mes" - QBAuxMeasurementHeader."Am. RET Mes";
      QBAuxMeasurementHeader."Am. TOT Ant" := QBAuxMeasurementHeader."Am. PEC Ant" - QBAuxMeasurementHeader."Am. RET Ant";
      QBAuxMeasurementHeader."Am. TOT Ori" := QBAuxMeasurementHeader."Am. PEC Ori" - QBAuxMeasurementHeader."Am. RET Ori";
      QBAuxMeasurementHeader.MODIFY;
    END;

    LOCAL PROCEDURE CalcAmountGBB(QBAuxMeasurementHeader : Record 7206962;pAmount : Decimal) : Decimal;
    VAR
      aux1 : Decimal;
      aux2 : Decimal;
      aux3 : Decimal;
    BEGIN
      aux1 := ROUND(pAmount * QBAuxMeasurementHeader."Porc. GG" / 100, 0.01);
      aux2 := ROUND(pAmount * QBAuxMeasurementHeader."Porc. BI" / 100, 0.01);
      aux3 := ROUND((pAmount + aux1 + aux2) * QBAuxMeasurementHeader."Porc. Baja" / 100, 0.01);
      EXIT(ROUND(aux1 + aux2 - aux3, 0.01));
    END;

    PROCEDURE CancelPostBillofItemMeasurement(parFromDocumentNo : Code[20];parFromLineNo : Integer;parcodNumDoc : Code[20]);
    VAR
      locrecPostBillOfItemMeasurement : Record 7207396;
      locrecBillOfItemMeasure : Record 7207395;
    BEGIN
      //Q19284 CSM 10/04/23 � Cancelar el detalle de la medici�n. -
      locrecPostBillOfItemMeasurement.RESET;
      locrecPostBillOfItemMeasurement.SETRANGE("Document No.",parFromDocumentNo);
      locrecPostBillOfItemMeasurement.SETRANGE("Line No.",parFromLineNo);
      IF locrecPostBillOfItemMeasurement.FINDSET THEN
        REPEAT
          CLEAR(locrecBillOfItemMeasure);
          locrecBillOfItemMeasure.TRANSFERFIELDS(locrecPostBillOfItemMeasurement);
          locrecBillOfItemMeasure."Document No." := parcodNumDoc;
/*{
          locrecBillOfItemMeasure."Measured Units" := -locrecPostBillOfItemMeasurement."Measured Units";
          locrecBillOfItemMeasure."Measured Total" := -locrecPostBillOfItemMeasurement."Measured Total";
          locrecBillOfItemMeasure."Realized Units" := -locrecPostBillOfItemMeasurement."Realized Units";
          locrecBillOfItemMeasure."Realized Total" := -locrecPostBillOfItemMeasurement."Realized Total";
          locrecBillOfItemMeasure."Period Units" := -locrecPostBillOfItemMeasurement."Period Units";
          locrecBillOfItemMeasure."Period Total" := -locrecPostBillOfItemMeasurement."Period Total";
          }*/
          locrecBillOfItemMeasure.INSERT(TRUE);

          locrecBillOfItemMeasure.VALIDATE("Period Units", -locrecPostBillOfItemMeasurement."Period Units");
          locrecBillOfItemMeasure.MODIFY;
        UNTIL locrecPostBillOfItemMeasurement.NEXT = 0;
      //Q19284 CSM 10/04/23 � Cancelar el detalle de la medici�n. +
    END;

    /*BEGIN
/*{
                   : - QVE_3370 Se ha cambiado el error por un message para que no pare el proceso.
      JAV 31/07/19 : - Marcar la medici�n que se cancela con la que la cancel�
      JMMA 26/08/19: - A�adido para que se pueda certificar a cliente diferente
      JAV 15/10/19 : - Se pone el n�mero de medici�n y el texto de registro al crear la certificaci�n
                     - Se pasa como par�mentro para crear el documento hist�rico el documento de origen
                     - Se elimina el campo "Posting Description" de varias tablas que no se utiliza
                     - Se unifican las dos funciones de registro en una con un par�metro de certificaci�n si o no, asi no se repite c�digo
      JAV 24/06/22: - QB 1.10.53 Cambiar los campos PEC por COST que es mas apropiado y se eliminan los PEM
      Q19284 CSM 10/04/23 � Cancelar el detalle de la medici�n.
              Modify Functions: HistProdMeasurementsCancel, HistMeasurementsCancel, PostCertificationsCancel, CrearPostBillofItemMeasurement.
              New Function: CancelPostBillofItemMeasurement

      // TO-DO esto no funciona bien, hay que arreglarlo con las dimensiones del cliente tambien, pero asi est� un poco mejor
      Q19892 AML 31/08/23 Fecha de registro de certificacion igual a fecha de certificacion.

    }
END.*/
}







