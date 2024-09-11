Codeunit 7207278 "Post Certification"
{
  
  
    TableNo=7207336;
    Permissions=TableData 7207339=rimd,
                TableData 7207341=rimd,
                TableData 7207342=rimd;
    trigger OnRun()
BEGIN
          END;
    VAR
      Text001 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';
      Text005 : TextConst ENU='Posting lines              #2######\',ESP='Registrando l�neas           #2######\';
      Text007 : TextConst ENU='Posting to vendors         #4######\',ESP='Registrando cliente          #4######\';
      Text009 : TextConst ENU='Posting lines         #2######',ESP='Registrando l�neas           #2######';
      Text010 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 -> Documento %2';
      Text023 : TextConst ENU='in the associated blanket order must not be greater than %1',ESP='en el pedido abierto asociado no debe ser superior a %1';
      Text024 : TextConst ENU='in the associated blanket order must be reduced.',ESP='en el pedido abierto asociado se debe reducir.';
      Text032 : TextConst ENU='The combination of dimensions used in %1 %2 is blocked. %3',ESP='La combinaci�n de dimensiones utilizadas en el documento %1 est� bloqueada. %3';
      Text033 : TextConst ENU='The combination of dimensions used in %1 %2, line no. %3 is blocked. %4',ESP='La combinaci�n de dimensiones utilizadas en el documento %1  n� l�nea %3 est� bloqueada. %4';
      Text034 : TextConst ENU='The dimensions used in %1 %2 are invalid. %3',ESP='Las dimensiones usadas en %1 %2 son inv�lidas %3';
      Text035 : TextConst ENU='The dimensions used in %1 %2, line no. %3 are invalid. %4',ESP='Las dim. usadas en %1 %2, no. l�n. %3 son inv�lidas %4';
      Text7000000 : TextConst ENU='Creating documents         #6######',ESP='Creando documentos           #6######';
      Text011 : TextConst ENU='Posting to vendors         #4######\',ESP='Registrando factura          #4######\';
      Text012 : TextConst ESP='La certificaci�n del borrador excede la medici�n presupuestada';
      Text013 : TextConst ESP='La unidad %1 de la  medicion %2 ya ha sido certificada.';
      Text014 : TextConst ESP='No se puede facturar m�s  cantidad de la certificada';
      Text050 : TextConst ENU='#1#################################\\',ESP='#1#################################\\';
      Text051 : TextConst ENU='Invoice - Certification N�: Option " ","ESP=""Factura - Certificaci�n N�: "';
      Window : Dialog;

    PROCEDURE PostCertification(VAR MeasurementHeader : Record 7207336;pInvoice : Boolean);
    VAR
      ItemChargeAssgntPurch : Record 5805;
      UpdateAnalysisView : Codeunit 410;
      CostBaseAmount : Decimal;
      DiscountVATAmount : Decimal;
      i : Integer;
      PostCertifications2 : Record 7207341;
      Customer : Record 18;
      Job : Record 167;
      LineCount : Integer;
      SalesPost : Codeunit 80;
      QBCommentLine : Record 7207270;
      PostCertificationsHeader : Record 7207341;
      SalesHeader : Record 36;
      MeasurementLines : Record 7207337;
    BEGIN
      Window.OPEN(Text050 + Text005);
      Window.UPDATE(1,STRSUBSTNO('%1',MeasurementHeader."No."));

      //Comprobamos los campos obligatorios
      MeasurementHeader.TESTFIELD("Document Type", MeasurementHeader."Document Type"::Certification);
      MeasurementHeader.TESTFIELD("Posting Date");
      MeasurementHeader.TESTFIELD("Certification Date");
      MeasurementHeader.TESTFIELD("Job No.");
      //El control debe existir s�lo para Proyecto y no para Promociones
      MeasurementHeader.TESTFIELD("Customer No.");


      //Comprobamos los campos que deben de ser obligatorios al registrar el documento.
      //El control debe existir s�lo para Proyecto y no para Promociones
      Customer.GET(MeasurementHeader."Customer No.");
      Customer.TESTFIELD(Blocked, 0);
      Job.GET(MeasurementHeader."Job No.");
      Job.TESTFIELD(Blocked,Job.Blocked::" ");

      //Copiamos las dimensiones.
      CheckDim(MeasurementHeader);

      //Bloqueamos las tablas a usar
      IF MeasurementHeader.RECORDLEVELLOCKING THEN BEGIN
        MeasurementLines.LOCKTABLE;
      END;

      //Creo el documento que ir� al hist�rico de certificaci�n
      CreatePostedCertificationHeader(MeasurementHeader, PostCertificationsHeader);
      Window.UPDATE(1,STRSUBSTNO(Text010,MeasurementHeader."No.",PostCertificationsHeader."No."));

      // Lineas
      LineCount := 0;
      MeasurementLines.RESET;
      MeasurementLines.SETRANGE("Document No.",MeasurementHeader."No.");
      IF MeasurementLines.FINDSET THEN BEGIN
        REPEAT
          LineCount := LineCount + 1;
          Window.UPDATE(2,LineCount);
          CreatePostedCertificationLine(PostCertificationsHeader, MeasurementLines);
        UNTIL MeasurementLines.NEXT = 0;
      END ELSE BEGIN
        ERROR(Text001);
      END;

      // Crear las facturas de venta y registrarlas
      IF (pInvoice) THEN BEGIN
        CreateInvoices(PostCertificationsHeader, TRUE);
        SalesHeader.RESET;
        SalesHeader.SETRANGE("QB Certification code", PostCertificationsHeader."No.");
        IF (SalesHeader.FINDSET) THEN
          SalesPost.RUN(SalesHeader);
      END;

      //JAV 31/07/19: - Marcar la certificaci�n que se cancela con la que la cancel�
      IF (PostCertifications2.GET(MeasurementHeader."Cancel No.")) THEN BEGIN
        PostCertifications2."Cancel By" := PostCertificationsHeader."No.";
        PostCertifications2."Text Measure" := COPYSTR(PostCertifications2."Text Measure" + ' Cancelada', 1, MAXSTRLEN(PostCertifications2."Text Measure"));
        PostCertifications2."No. Measure" := COPYSTR(PostCertifications2."No. Measure" + ' Cancelada', 1, MAXSTRLEN(PostCertifications2."No. Measure"));
        PostCertifications2.MODIFY;
      END;

      //Eliminar el documento una vez registrado
      MeasurementHeader.DELETE;
      MeasurementLines.RESET;
      MeasurementLines.SETRANGE("Document No.",MeasurementHeader."No.");
      MeasurementLines.DELETEALL;
      QBCommentLine.SETRANGE("No.",MeasurementHeader."No.");
      QBCommentLine.DELETEALL;

      Window.CLOSE;

      UpdateAnalysisView.UpdateAll(0,TRUE);
    END;

    PROCEDURE FunActInvoicedCertification(VAR recLinSale : Record 37;parcodeNumInvoice : Code[20];parPostingDate : Date);
    VAR
      HistCertificationLines : Record 7207342;
      PostCertificationsHeader : Record 7207341;
    BEGIN
      //Esta funci�n se lanza al registrar una factura de venta para ajustar el hist�rico de certificaciones

      //Si no viene de una certificaci�n, salimos
      IF (NOT PostCertificationsHeader.GET(recLinSale."QB Certification code")) THEN
        EXIT;

      //Marcar la cabecera como certificada completamente o no
      IF PostCertificationsHeader.GET(recLinSale."QB Certification code") THEN BEGIN
        HistCertificationLines.RESET;
        HistCertificationLines.SETRANGE("Document No.",PostCertificationsHeader."No.");
        HistCertificationLines.SETRANGE("Invoiced Certif.",FALSE);
        IF HistCertificationLines.FINDFIRST THEN
          PostCertificationsHeader."Invoiced Certification" := FALSE
        ELSE
          PostCertificationsHeader."Invoiced Certification" := TRUE;
        PostCertificationsHeader.MODIFY;
      END;
    END;

    PROCEDURE CreateInvoices(PostCertificationsHeader : Record 7207341;pSilentMode : Boolean);
    VAR
      Customer : Record 18;
      Job : Record 167;
      QBJobCustomers : Record 7207272;
      SalesHeader : Record 36;
      BaseAmount : Decimal;
      Amount : Decimal;
      SumAmount : Decimal;
      SumPorc : Decimal;
      Txt001 : TextConst ESP='No ha definido los porcentajes de reparto al 100%';
      Txt002 : TextConst ESP='Ya ha facturado esta certificaci�n';
      Txt003 : TextConst ESP='Existen facturas creadas desde esta cerfificaci�n, elim�nelas antes de volverlas a generar';
      Nro : Integer;
      Txt004 : TextConst ESP='No se ha creado ninguna factura';
      Txt005 : TextConst ESP='Se ha creado una factura';
      Txt006 : TextConst ESP='Se han creado %1 facturas';
    BEGIN
      IF (PostCertificationsHeader."Invoiced Certification") THEN
        ERROR(Txt002);

      SalesHeader.RESET;
      SalesHeader.SETRANGE("QB Certification code", PostCertificationsHeader."No.");
      IF (NOT SalesHeader.ISEMPTY) THEN
        ERROR(Txt003);

      Nro := 0;
      BaseAmount := CalcInvoiceAmount(PostCertificationsHeader);
      Job.GET(PostCertificationsHeader."Job No.");
      IF (Job."Multi-Client Job" <> Job."Multi-Client Job"::ByPercentages) THEN BEGIN
        CreateSaleInvoice(PostCertificationsHeader, PostCertificationsHeader."Customer No.", BaseAmount, 0, 0);
        Nro += 1;
      END ELSE BEGIN
        QBJobCustomers.RESET;
        QBJobCustomers.SETRANGE("Job no.", PostCertificationsHeader."Job No.");
        IF (QBJobCustomers.FINDSET(FALSE)) THEN
          REPEAT
            SumPorc += QBJobCustomers.Percentaje;
            IF (SumPorc = 100) THEN
              Amount := BaseAmount - SumAmount
            ELSE
              Amount := ROUND(BaseAmount * QBJobCustomers.Percentaje / 100, 0.01);
            SumAmount += Amount;
            CreateSaleInvoice(PostCertificationsHeader, QBJobCustomers."Customer No.", Amount, QBJobCustomers.Percentaje, BaseAmount);
            Nro += 1;
          UNTIL QBJobCustomers.NEXT = 0;
          IF (BaseAmount <> SumAmount) THEN
            ERROR(Txt001);
      END;

      //JAV 22/02/21: - QB 1.08.14 Mensaje final
      IF (NOT pSilentMode) THEN
        CASE Nro OF
          0: MESSAGE(Txt004);
          1: MESSAGE(Txt005);
          ELSE MESSAGE(Txt006, Nro);
        END;
    END;

    LOCAL PROCEDURE CreateSaleInvoice(PostCertificationsHeader : Record 7207341;pCustomer : Code[20];pAmount : Decimal;pPorc : Decimal;pBaseAmount : Decimal);
    VAR
      Customer : Record 18;
      Job : Record 167;
      JobPostingGroup : Record 208;
      SalesLine : Record 37;
      SalesHeader : Record 36;
    BEGIN
      //Crear factura venta
      Customer.GET(pCustomer);
      Job.GET(PostCertificationsHeader."Job No.");
      JobPostingGroup.GET(Job."Job Posting Group");

      SalesHeader.INIT;
      SalesHeader."No." := '';
      SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
      SalesHeader."Posting Date" := PostCertificationsHeader."Posting Date";
      SalesHeader.VALIDATE("Sell-to Customer No.",PostCertificationsHeader."Customer No.");
      SalesHeader.VALIDATE("QB Job No.",PostCertificationsHeader."Job No.");
      SalesHeader.VALIDATE("QB Job No.",PostCertificationsHeader."Job No.");
      SalesHeader."QB Certification code" := PostCertificationsHeader."No.";
      SalesHeader.Invoice:= TRUE;
      SalesHeader."Shortcut Dimension 1 Code" := PostCertificationsHeader."Shortcut Dimension 1 Code";
      SalesHeader."Shortcut Dimension 2 Code" := PostCertificationsHeader."Shortcut Dimension 2 Code";
      SalesHeader."Dimension Set ID" := PostCertificationsHeader."Dimension Set ID";
      SalesHeader.INSERT(TRUE);
      //Q19876 CSM 18/07/23 � Fecha emisi�n superior a Fecha registro. -
      //el Insert(true) vuelve a poner la fecha de trabajo.  Lo modificamos despues.
      SalesHeader."Shipment Date" := PostCertificationsHeader."Send Date";
      SalesHeader."Document Date" := PostCertificationsHeader."Posting Date";
      SalesHeader.MODIFY(TRUE);
      //Q19876 CSM 18/07/23 � Fecha emisi�n superior a Fecha registro. +

      SalesLine.INIT;
      SalesLine."Document Type" := SalesHeader."Document Type";
      SalesLine."Document No." := SalesHeader."No.";
      SalesLine."Line No." := 10000;
      SalesLine.INSERT(TRUE);

      //JAV 14/04/21: - QB 1.08.39 Usar otros tipos, no solo cuenta
      CASE JobPostingGroup."QB Invoice Certi. Type" OF
        JobPostingGroup."QB Invoice Certi. Type"::Standar:  //Si no se ha definido otra cosa, usar esta cuenta que es la estandar de Busines Central
          BEGIN
            SalesLine.Type := SalesLine.Type::"G/L Account";
            SalesLine.VALIDATE("No.",JobPostingGroup."Recognized Sales Account");
          END;
        JobPostingGroup."QB Invoice Certi. Type"::Account:  //Si usamos cuenta
          BEGIN
            SalesLine.Type := SalesLine.Type::"G/L Account";
            SalesLine.VALIDATE("No.",JobPostingGroup."QB Invoice Certi. No.");
          END;
        JobPostingGroup."QB Invoice Certi. Type"::Resource: //Si usamos recurso
          BEGIN
            SalesLine.Type := SalesLine.Type::Resource;
            SalesLine.VALIDATE("No.",JobPostingGroup."QB Invoice Certi. No.");
          END;
        JobPostingGroup."QB Invoice Certi. Type"::Item: //Si usamos producto
          BEGIN
            SalesLine.Type := SalesLine.Type::Item;
            SalesLine.VALIDATE("No.",JobPostingGroup."QB Invoice Certi. No.");
          END;
      END;
      //Usar el grupo de IVA asociado al proyecto si est� definido, si no usar� el asociado al registro usado
      IF (Job."VAT Prod. PostingGroup" <> '') THEN
        SalesLine.VALIDATE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");

      SalesLine."Shipment Date" := WORKDATE;
      SalesLine.VALIDATE("Sell-to Customer No.",SalesHeader."Sell-to Customer No.");
      SalesLine.VALIDATE("Gen. Bus. Posting Group",Customer."Gen. Bus. Posting Group");
      SalesLine.VALIDATE("Job No.",PostCertificationsHeader."Job No.");
      IF PostCertificationsHeader."Text Measure" <> '' THEN
        SalesLine.Description := PostCertificationsHeader."Text Measure"
      ELSE
        SalesLine.Description := Text051 + PostCertificationsHeader."No.";

      IF (pPorc <> 0) THEN
        SalesLine.Description := COPYSTR(SalesLine.Description + ' (' + FORMAT(pPorc) + '% sobre ' + FORMAT(pBaseAmount) + ')',1,MAXSTRLEN(SalesLine.Description));

      SalesLine.VALIDATE(Quantity,1);
      SalesLine.VALIDATE("Unit Price", pAmount);
      SalesLine."QB Certification code" := PostCertificationsHeader."No.";
      SalesLine.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber : Code[20];ToNumber : Code[20]);
    VAR
      QBCommentLine1 : Record 7207270;
      QBCommentLine2 : Record 7207270;
    BEGIN
      QBCommentLine1.SETRANGE("No.",FromNumber);
      IF QBCommentLine1.FINDSET(TRUE) THEN
        REPEAT
         QBCommentLine2 := QBCommentLine1;
         QBCommentLine2."No." := ToNumber;
         QBCommentLine2.INSERT;
       UNTIL QBCommentLine1.NEXT = 0;
    END;

    LOCAL PROCEDURE CreatePostedCertificationHeader(MeasurementHeader : Record 7207336;VAR PostCertificationsHeader : Record 7207341);
    VAR
      SourceCodeSetup : Record 242;
      NoSeriesMgt : Codeunit 396;
      PieceworkSetup : Record 7207279;
    BEGIN
      //Creo el documento cabecera hist. certificaci�n
      //Tomamos el c�d. de origen.
      SourceCodeSetup.GET;
      SourceCodeSetup.TESTFIELD(SourceCodeSetup."Measurements and Certif.");

      PieceworkSetup.GET;
      PieceworkSetup.TESTFIELD(PieceworkSetup."Series Hist. Certification No.");

      MeasurementHeader.CalculateTotals;

      PostCertificationsHeader.INIT;
      PostCertificationsHeader.TRANSFERFIELDS(MeasurementHeader);
      PostCertificationsHeader."Pre-Assigned No. Series" :=  MeasurementHeader."Posting No. Series";
      PostCertificationsHeader."No." := NoSeriesMgt.GetNextNo(PieceworkSetup."Series Hist. Certification No.",MeasurementHeader."Posting Date",TRUE);
      PostCertificationsHeader."Source Code" := SourceCodeSetup."Measurements and Certif.";
      PostCertificationsHeader."User ID" := USERID;
      PostCertificationsHeader."Dimension Set ID" := MeasurementHeader."Dimension Set ID";
      PostCertificationsHeader.INSERT;

      CopyCommentLines(MeasurementHeader."No.",PostCertificationsHeader."No.");

      IF MeasurementHeader."Certification Type" = MeasurementHeader."Certification Type"::"Price adjustment" THEN
        FunActRedetermination(MeasurementHeader);
    END;

    LOCAL PROCEDURE CreatePostedCertificationLine(PostCertificationsHeader : Record 7207341;MeasurementLines : Record 7207337);
    VAR
      HistCertificationLines : Record 7207342;
    BEGIN
      //Creo  lineas hist. certificaci�n
      HistCertificationLines.INIT;
      HistCertificationLines.TRANSFERFIELDS(MeasurementLines);
      HistCertificationLines."Document No." := PostCertificationsHeader."No.";
      HistCertificationLines."Customer No." := PostCertificationsHeader."Customer No.";
      HistCertificationLines."Certification Date" := PostCertificationsHeader."Posting Date";     //JAV 20/04/21: - QB 1.08.40 Faltaba pasar la fecha a las l�neas
      HistCertificationLines."Certif. Quantity Not Inv." := HistCertificationLines."Cert Term PEM amount";
      HistCertificationLines."Invoiced Quantity" := 0;
      //Actualizo Cantidad ppte. certificar
      FunActPostedMeasureLine(MeasurementLines);
      PostCertificationsHeader."Dimension Set ID" := MeasurementLines."Dimension Set ID";

      //JAV 22/06/22: - QB 1.10.52 Se recalculan estos importes a PEC porque dan problemas
      HistCertificationLines."Cert Term PEC amount"   := ROUND(HistCertificationLines."Cert Quantity to Term"   * HistCertificationLines."Contract Price", 0.01);
      HistCertificationLines."Cert Source PEC amount" := ROUND(HistCertificationLines."Cert Quantity to Origin" * HistCertificationLines."Contract Price", 0.01);

      HistCertificationLines.INSERT;
    END;

    LOCAL PROCEDURE CalcInvoiceAmount(PostCertificationsHeader : Record 7207341) : Decimal;
    VAR
      TotalAmount : Decimal;
      HistCertificationLines : Record 7207342;
    BEGIN
      TotalAmount := 0;

      HistCertificationLines.RESET;
      HistCertificationLines.SETRANGE("Document No.",PostCertificationsHeader."No.");
      IF HistCertificationLines.FINDSET(FALSE) THEN
        REPEAT
          //-Q19745
          //TotalAmount += HistCertificationLines."Term Contract Amount"
          TotalAmount += HistCertificationLines."Cert Term PEC amount"
          //+Q19745
        UNTIL HistCertificationLines.NEXT=0;
      EXIT(TotalAmount);
    END;

    LOCAL PROCEDURE FunActPostedMeasureLine(MeasurementLines : Record 7207337);
    VAR
      HistMeasurements : Record 7207338;
      HistMeasureLines : Record 7207339;
    BEGIN
      //Guardar en la medici�n registada la cantidad certificada
      IF (MeasurementLines."Cert Quantity to Term" <> 0) THEN  //Si hay algo que registrar
        IF (HistMeasureLines.GET(MeasurementLines."Cert Medition No.", MeasurementLines."Cert Medition Line No.")) THEN BEGIN
          IF (MeasurementLines."Med. Term Measure" > 0) AND (HistMeasureLines."Certificated Quantity" > HistMeasureLines."Med. Term Measure") THEN
            ERROR(Text013,HistMeasureLines."Piecework No.",HistMeasureLines."Document No.");

          HistMeasureLines."Certificated Quantity" += MeasurementLines."Cert Quantity to Term";
          HistMeasureLines."Quantity Measure Not Cert" -= MeasurementLines."Cert Quantity to Term";
          HistMeasureLines.MODIFY;

          //Miro si est� completamente procesado para marcarla como completada
          HistMeasureLines.RESET;
          HistMeasureLines.SETRANGE("Document No.", MeasurementLines."Cert Medition No.");
          HistMeasureLines.SETFILTER("Quantity Measure Not Cert", '<>0');
          IF (HistMeasureLines.ISEMPTY) THEN BEGIN
            HistMeasurements.GET(MeasurementLines."Cert Medition No.");
            HistMeasurements."Certification Completed" := TRUE;
            HistMeasurements.MODIFY;
          END;
        END;
    END;

    LOCAL PROCEDURE CheckDim(MeasurementHeader : Record 7207336);
    VAR
      recMeasurementLine2 : Record 7207337;
    BEGIN
      recMeasurementLine2."Line No." := 0;
      CheckDimValuePosting(MeasurementHeader, recMeasurementLine2);
      CheckDimComb(MeasurementHeader, recMeasurementLine2);

      recMeasurementLine2.RESET;
      recMeasurementLine2.SETRANGE("Document No.",MeasurementHeader."No.");
      recMeasurementLine2.SETFILTER("Piecework No.",'<>%1','');               //JAV 06/10/21: - QB 1.09.20 Saltamos verificar l�neas sin Unidad de Obra ya que son comentarios
      IF recMeasurementLine2.FINDSET THEN
        REPEAT
          CheckDimComb(MeasurementHeader, recMeasurementLine2);
          CheckDimValuePosting(MeasurementHeader, recMeasurementLine2);
        UNTIL recMeasurementLine2.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimComb(MeasurementHeader : Record 7207336;recMeasurementLine2 : Record 7207337);
    VAR
      DimMgt : Codeunit 408;
    BEGIN
      IF recMeasurementLine2."Line No." = 0 THEN
        IF NOT DimMgt.CheckDimIDComb(MeasurementHeader."Dimension Set ID") THEN
          ERROR(
            Text032,
            MeasurementHeader."No.",DimMgt.GetDimCombErr);

      IF recMeasurementLine2."Line No." <> 0 THEN
        IF NOT DimMgt.CheckDimIDComb(recMeasurementLine2."Dimension Set ID") THEN
          ERROR(
            Text033,
            MeasurementHeader."No.",recMeasurementLine2."Line No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting(MeasurementHeader : Record 7207336;VAR recMeasurementLine2 : Record 7207337);
    VAR
      TableIDArr : ARRAY [10] OF Integer;
      NumberArr : ARRAY [10] OF Code[20];
      DimMgt : Codeunit 408;
      DimMgt2:codeunit 50361;
    BEGIN
      IF recMeasurementLine2."Line No." = 0 THEN BEGIN
        TableIDArr[1] := DATABASE::Customer;
        NumberArr[1] := MeasurementHeader."Customer No.";
        TableIDArr[2] := DATABASE::Job;
        NumberArr[2] := MeasurementHeader."Job No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,MeasurementHeader."Dimension Set ID") THEN
          ERROR(
            Text034,
            MeasurementHeader."Document Type",MeasurementHeader."No.",DimMgt.GetDimValuePostingErr);
      END ELSE BEGIN
        TableIDArr[1] := DimMgt2.TypeToTableID3(recMeasurementLine2."Document type");
        NumberArr[1] := recMeasurementLine2."Document No.";
        TableIDArr[2] := DATABASE::Job;
        NumberArr[2] := recMeasurementLine2."Job No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,recMeasurementLine2."Dimension Set ID") THEN
          ERROR(
            Text035,
                  MeasurementHeader."Document Type",MeasurementHeader."No.",recMeasurementLine2."Line No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE FunActRedetermination(MeasurementHeader : Record 7207336);
    VAR
      JobRedetermination : Record 7207437;
      CertUnitRedetermination : Record 7207438;
    BEGIN
      IF JobRedetermination.GET(MeasurementHeader."Job No.",MeasurementHeader."Redetermination Code") THEN BEGIN
        JobRedetermination.TESTFIELD(Validated,TRUE);
        JobRedetermination.TESTFIELD(Adjusted,FALSE);
        JobRedetermination.Adjusted := TRUE;
        JobRedetermination.MODIFY;
        CertUnitRedetermination.SETRANGE("Job No.",JobRedetermination."Job No.");
        CertUnitRedetermination.SETRANGE("Redetermination Code",JobRedetermination.Code);
        IF CertUnitRedetermination.FINDSET THEN
          REPEAT
            CertUnitRedetermination.Adjusted := TRUE;
            CertUnitRedetermination.MODIFY;
          UNTIL CertUnitRedetermination.NEXT = 0;
      END;
    END;

    PROCEDURE MarkInvoiced(PostCertificationsHeader : Record 7207341;pMark : Boolean);
    VAR
      PostCertificationsLines : Record 7207342;
    BEGIN
      //JAV 26/02/21: - QB 1.08.16 Funci�n para marcar la certificaci�n como facturada o no seg�n par�metro
      PostCertificationsHeader."Invoiced Certification" := pMark;

      //JAV 21/02/22: - QB 1.10.21 No pon�a el importe al marcar
      IF (pMark) THEN
        PostCertificationsHeader."Amount Invoiced" := PostCertificationsHeader."Amount Document"
      ELSE
        PostCertificationsHeader."Amount Invoiced" := 0;

      PostCertificationsHeader.MODIFY;

      PostCertificationsLines.RESET;
      PostCertificationsLines.SETRANGE("Document No.",PostCertificationsHeader."No.");
      IF PostCertificationsLines.FINDSET(TRUE) THEN
        REPEAT
          PostCertificationsLines."Invoiced Certif." := pMark;
          PostCertificationsLines.MODIFY;
        UNTIL PostCertificationsLines.NEXT = 0;
    END;

    PROCEDURE FunActInvoicedWIP(VAR recLinSale : Record 37;pDocumentNo : Code[20];pPostingDate : Date);
    VAR
      SalesHeader : Record 36;
      Job : Record 167;
      CustLedgerEntry : Record 21;
      DetailedCustLedgEntry : Record 379;
      GLEntry : Record 17;
      JobLedgerEntry : Record 169;
      tmpDetailedCustLedgEntry : Record 379 TEMPORARY;
      tmpGenJournalLine : Record 81 TEMPORARY;
      tmpJobJournalLine : Record 210 TEMPORARY;
      GenJnlPostLine : Codeunit 12;
      JobJnlPostLine : Codeunit 1012;
      InitialAmount : Decimal;
      Amount : Decimal;
      PorcAmount : Decimal;
      Sum : Decimal;
      SumDL : Decimal;
      LineNo : Integer;
      EntryNo : Integer;
    BEGIN
      //Esta funci�n se lanza al registrar una factura de venta para ajustar el WIP

      //Si no viene de una certificaci�n, salimos
      IF (recLinSale."QB Certification code" = '') THEN
        EXIT;

      //Si no es WIP por meses, salimos
      Job.GET(recLinSale."Job No.");
      IF (Job."Calculate WIP by periods") THEN BEGIN
        Amount := recLinSale.Amount;  //Este el importe base de la producci�n que debemos liquidar, luego iremos recorriendo registros y descontando de este importe hasta que sea cero
        Sum := 0;
        SumDL := 0;
        LineNo := 0;
        tmpGenJournalLine.DELETEALL;
        tmpJobJournalLine.DELETEALL;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", recLinSale."Sell-to Customer No.");
        CustLedgerEntry.SETRANGE("QB Job No.", recLinSale."Job No.");
        CustLedgerEntry.SETFILTER("QB WIP Remaining Amount", '<>0');
        IF (CustLedgerEntry.FINDSET(FALSE)) THEN
          REPEAT
            //Calculo el porcentaje que le voy a descontar al asiento original y se lo resto del pendiente
            CustLedgerEntry.CALCFIELDS("QB WIP Remaining Amount");
            IF (CustLedgerEntry."QB WIP Remaining Amount" < Amount) THEN
              PorcAmount := 1
            ELSE
              PorcAmount := Amount / CustLedgerEntry."QB WIP Remaining Amount";

            Amount -= CustLedgerEntry."QB WIP Remaining Amount" * PorcAmount;

            //Busco los movimientos detallados que no sean de aplicaci�n para ver que documentos han sido los registrados
            DetailedCustLedgEntry.RESET;
            DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
            DetailedCustLedgEntry.SETFILTER("Entry Type", '<>%1', DetailedCustLedgEntry."Entry Type"::Application);
            IF (DetailedCustLedgEntry.FINDSET(FALSE)) THEN
              REPEAT
                //Sumo importes
                Sum += DetailedCustLedgEntry.Amount * PorcAmount ;
                IF (DetailedCustLedgEntry."Entry Type" = DetailedCustLedgEntry."Entry Type"::"Initial Entry") THEN
                  SumDL += DetailedCustLedgEntry."Amount (LCY)" * PorcAmount;

                //Cancelar el movimiento contable del WIP
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", DetailedCustLedgEntry."Document No.");
                IF GLEntry.FINDSET(FALSE) THEN
                  REPEAT
                    LineNo += 1;
                    tmpGenJournalLine.INIT;
                    tmpGenJournalLine."Line No." := LineNo;
                    CancelGLDiary(GLEntry, tmpGenJournalLine, pDocumentNo, pPostingDate, PorcAmount);
                  UNTIL GLEntry.NEXT = 0;

                //Cancelar el movimiento de proyecto del WIP
                JobLedgerEntry.RESET;
                JobLedgerEntry.SETRANGE("Document No.", DetailedCustLedgEntry."Document No.");
                IF JobLedgerEntry.FINDSET(FALSE) THEN
                  REPEAT
                    LineNo += 1;
                    tmpJobJournalLine.INIT;
                    tmpJobJournalLine."Line No." := LineNo;
                    CancelJobDiary(JobLedgerEntry, tmpJobJournalLine, pDocumentNo, pPostingDate, PorcAmount);
                  UNTIL JobLedgerEntry.NEXT = 0;

                //Cancelar el movimiento detallado del cliente
                CancelDetailedCust(DetailedCustLedgEntry, tmpDetailedCustLedgEntry, pPostingDate, PorcAmount);

              UNTIL (DetailedCustLedgEntry.NEXT = 0);
          UNTIL (CustLedgerEntry.NEXT = 0) OR (Amount <= 0);

        //Registramos los diarios creados para cancelar el WIP anterior
        tmpGenJournalLine.RESET;
        IF tmpGenJournalLine.FINDSET THEN
          REPEAT
            GenJnlPostLine.RunWithCheck(tmpGenJournalLine);
          UNTIL tmpGenJournalLine.NEXT = 0;

        tmpJobJournalLine.RESET;
        IF tmpJobJournalLine.FINDSET THEN
          REPEAT
            JobJnlPostLine.RunWithCheck(tmpJobJournalLine);
          UNTIL tmpJobJournalLine.NEXT = 0;

        DetailedCustLedgEntry.RESET;
        //JAV 24/03/21: - QB 1.08.27 No controlaba el error del findlast
        IF DetailedCustLedgEntry.FINDLAST THEN
          LineNo := DetailedCustLedgEntry."Entry No." + 1
        ELSE
          LineNo := 1;

        tmpDetailedCustLedgEntry.RESET;
        IF tmpDetailedCustLedgEntry.FINDSET THEN
          REPEAT
            DetailedCustLedgEntry := tmpDetailedCustLedgEntry;
            DetailedCustLedgEntry."Entry No." := LineNo;
            DetailedCustLedgEntry.INSERT;
            LineNo += 1;
          UNTIL tmpDetailedCustLedgEntry.NEXT = 0;

        //Calculamos el importe de las diferencias de cambio del WIP
        SalesHeader.GET(recLinSale."Document Type", recLinSale."Document No.");
        IF (SalesHeader."Currency Factor" =0) THEN
          Amount := 0
        ELSE
          Amount := ((recLinSale.Amount / SalesHeader."Currency Factor") * (Sum / recLinSale.Amount)) - SumDL;    //Importe liquidado en divisa al cambio actual
        IF (Amount <> 0) THEN BEGIN
          EntryNo := GenerateGLDiary(recLinSale, pDocumentNo, pPostingDate, Amount);                   //Crear el movimiento contable de las diferencias del WIP
          GenerateJobDiary(recLinSale, pDocumentNo, pPostingDate, Amount, EntryNo);                    //Crear el movimiento del proyecto de las diferencias del WIP
        END;
      END;
    END;

    PROCEDURE GenerateGLDiary(SalesLine : Record 37;pDocumentNo : Code[20];pDate : Date;pAmount : Decimal) : Integer;
    VAR
      GenJournalLine : Record 81;
      GLAccount : Record 15;
      QuoBuildingSetup : Record 7207278;
      Job : Record 167;
      JobPostingGroup : Record 208;
      Currency : Record 4;
      SourceCodeSetup : Record 242;
      GenJnlPostLine : Codeunit 12;
      UpdateViews : Codeunit 410;
      FunctionQB : Codeunit 7207272;
      RegNo : Integer;
    BEGIN
      Job.GET(SalesLine."Job No.");
      JobPostingGroup.GET(Job."Job Posting Group");
      Currency.GET(SalesLine."Currency Code");

      SourceCodeSetup.GET;
      SourceCodeSetup.TESTFIELD(WIP);

      //Generar y registrar las l�neas del diario contable
      GenJournalLine.INIT;
      GenJournalLine."Job No." := SalesLine."Job No.";

      GenJournalLine."Document Type" := GenJournalLine."Document Type"::WIP;   //JAV 13/11/20: - QB 1.07.05 El movimiento es de tipo WIP

      GenJournalLine."Posting Date" := pDate;
      GenJournalLine."Document No." := pDocumentNo;
      GenJournalLine.Description := 'Ajuste Divisas WIP';
      GenJournalLine."Source Code" := SourceCodeSetup.WIP;
      GenJournalLine."System-Created Entry" := TRUE;
      GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
      GenJournalLine.Correction := FALSE;
      GenJournalLine."Source Type" := GenJournalLine."Source Type"::" ";
      GenJournalLine."Reason Code" := ''; ///////////////////////////////ProductionDailyLine."Reason Code";
      GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
      GenJournalLine."Already Generated Job Entry" := TRUE;
      GenJournalLine."Usage/Sale" := GenJournalLine."Usage/Sale"::Sale;
      GenJournalLine."Adjust WIP" := TRUE;

      //Primero el apunte con el C.A. de diferencias de cambio del proyecto
      GenJournalLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
      GenJournalLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
      GenJournalLine."Dimension Set ID" := SalesLine."Dimension Set ID";
      IF (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1) THEN
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Job."Adjust Exchange Rate A.C.")
      ELSE IF (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2) THEN
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Job."Adjust Exchange Rate A.C.");

      GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
      IF (pAmount > 0) THEN
        GenJournalLine."Account No." := Currency."Realized Gains Acc."
      ELSE
        GenJournalLine."Account No." := Currency."Realized Losses Acc.";
      GenJournalLine.VALIDATE(Amount, -pAmount);

      GenJnlPostLine.RunWithCheck(GenJournalLine);

      //Segundo el apunte contra las dimensiones de la l�nea
      GenJournalLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
      GenJournalLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
      GenJournalLine."Dimension Set ID" := SalesLine."Dimension Set ID";

      GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
      GenJournalLine."Account No." := SalesLine."No.";
      GenJournalLine.VALIDATE(Amount, pAmount);

      EXIT(GenJnlPostLine.RunWithCheck(GenJournalLine));
    END;

    PROCEDURE GenerateJobDiary(SalesLine : Record 37;pDocumentNo : Code[20];pDate : Date;pAmount : Decimal;pEntryNo : Integer);
    VAR
      Job : Record 167;
      JobJournalLine : Record 210;
      GLAccount : Record 15;
      SourceCodeSetup : Record 242;
      JobJnlPostLine : Codeunit 1012;
      FunctionQB : Codeunit 7207272;
    BEGIN
      //Generar y registrar las l�neas del diario de proyectos
      Job.GET(SalesLine."Job No.");

      SourceCodeSetup.GET;
      SourceCodeSetup.TESTFIELD(WIP);

      JobJournalLine.INIT;
      JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Sale;
      JobJournalLine.VALIDATE("Job No.", SalesLine."Job No.");
      JobJournalLine."Posting Date" := pDate;
      JobJournalLine."Document Date" := JobJournalLine."Posting Date";
      JobJournalLine."Document No." := pDocumentNo;
      JobJournalLine.Type := JobJournalLine.Type::"G/L Account";
      JobJournalLine."No." := SalesLine."No.";
      JobJournalLine.Description := 'Ajuste Divisas WIP';

      JobJournalLine.VALIDATE(Quantity, 1);
      JobJournalLine."Unit Price (LCY)"  := pAmount;
      JobJournalLine."Total Price (LCY)" := JobJournalLine.Quantity * JobJournalLine."Unit Price (LCY)";
      JobJournalLine."Line Amount (LCY)" := JobJournalLine.Quantity * JobJournalLine."Unit Price (LCY)";

      JobJournalLine."Posting Group" := SalesLine."Gen. Bus. Posting Group";
      JobJournalLine."Source Code" := SourceCodeSetup.WIP;
      JobJournalLine."Post Job Entry Only" := TRUE;
      JobJournalLine."Reason Code" := ''; /////////////////////// SalesLine."Reason Code";
      JobJournalLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
      JobJournalLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
      //JobJournalLine."Serial No." := SalesLine."Serie No.";
      //JobJournalLine."Posting No. Series" := SalesLine."Posting Serie No.";
      JobJournalLine."Quantity (Base)" := 1;
      JobJournalLine."Job Deviation Entry" := FALSE;
      JobJournalLine."Job in Progress" := TRUE;
      JobJournalLine.Chargeable := FALSE;
      JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Invoice;
      JobJournalLine."Related G/L Entry" := pEntryNo;   //JAV 03/12/20: - QB 1.07.10 Guardo el movimiento contable relacionado
      JobJournalLine."Currency Adjust" := TRUE;

      //Pongo las dimensiones generales primero
      JobJournalLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
      JobJournalLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
      JobJournalLine."Dimension Set ID" := SalesLine."Dimension Set ID";
      //Ajutar el C.A. del movimiento con la de ajuste de divisas del proyecto
      IF (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1) THEN
        JobJournalLine.VALIDATE("Shortcut Dimension 1 Code", Job."Adjust Exchange Rate A.C.")
      ELSE IF (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2) THEN
        JobJournalLine.VALIDATE("Shortcut Dimension 2 Code", Job."Adjust Exchange Rate A.C.");

      JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    PROCEDURE CancelGLDiary(GLEntry : Record 17;VAR GenJournalLine : Record 81;pDocumentNo : Code[20];pDate : Date;pPorc : Decimal);
    VAR
      GLAccount : Record 15;
      QuoBuildingSetup : Record 7207278;
      Job : Record 167;
      JobPostingGroup : Record 208;
    BEGIN
      //Crear la l�nea para cancela un apunte contable WIP
      GenJournalLine.VALIDATE("Job No.", GLEntry."Job No.");
      GenJournalLine."Document Type" := GLEntry."Document Type";
      GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
      GenJournalLine."Account No." := GLEntry."G/L Account No.";
      GenJournalLine."Posting Date" := pDate;
      GenJournalLine."Document No." := pDocumentNo;
      GenJournalLine.Description := COPYSTR(STRSUBSTNO('Cancelar %1 al %2%, %3', GLEntry."Document No.", pPorc* 100, GLEntry.Description) , 1, MAXSTRLEN(GenJournalLine.Description));
      GenJournalLine."Shortcut Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
      GenJournalLine."Shortcut Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
      GenJournalLine."Source Code" := GLEntry."Source Code";
      GenJournalLine."System-Created Entry" := FALSE;
      GenJournalLine."Job No." := GLEntry."Job No.";
      GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
      GenJournalLine.VALIDATE(Amount, -GLEntry.Amount * pPorc);
      //GenJournalLine.Correction := TRUE;
      GenJournalLine."System-Created Entry" := TRUE;
      GenJournalLine."Source Type" := GenJournalLine."Source Type"::" ";
      GenJournalLine."Reason Code" := GLEntry."Reason Code";
      GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
      GenJournalLine."Already Generated Job Entry" := TRUE;
      GenJournalLine."Usage/Sale" := GenJournalLine."Usage/Sale"::Sale;
      GenJournalLine."Dimension Set ID" := GLEntry."Dimension Set ID";
      GenJournalLine.INSERT;
    END;

    PROCEDURE CancelJobDiary(JobLedgerEntry : Record 169;VAR JobJournalLine : Record 210;pDocumentNo : Code[20];pDate : Date;pPorc : Decimal);
    VAR
      GLAccount : Record 15;
    BEGIN
      //Generar las l�neas del diario de proyectos para anular WIP
      JobJournalLine.VALIDATE("Job No.", JobLedgerEntry."Job No.");
      JobJournalLine.VALIDATE("Piecework Code", JobLedgerEntry."Piecework No.");
      JobJournalLine."Posting Date" := pDate;
      JobJournalLine."Document Date" := JobJournalLine."Posting Date";
      JobJournalLine."Document No." := JobLedgerEntry."Document No.";
      JobJournalLine.Type := JobJournalLine.Type::"G/L Account";
      JobJournalLine."No." := JobLedgerEntry."No.";
      JobJournalLine.Description := COPYSTR(STRSUBSTNO('Cancelar %1 al %2%, %3', JobLedgerEntry."Document No.", pPorc* 100, JobLedgerEntry.Description) , 1, MAXSTRLEN(JobLedgerEntry.Description));
      JobJournalLine.Quantity := -JobLedgerEntry.Quantity;

      //JAV 09/06/21: - Si no tiene divisa, no cargo estos datos
      IF (JobLedgerEntry."Currency Code" <> '') THEN BEGIN
        JobJournalLine.VALIDATE("Currency Code", JobLedgerEntry."Currency Code");
        JobJournalLine.VALIDATE("Currency Factor", JobLedgerEntry."Currency Factor");
      END;

      JobJournalLine."Unit Cost"         := JobLedgerEntry."Unit Cost" * pPorc;
      JobJournalLine."Unit Cost (LCY)"   := JobLedgerEntry."Unit Cost (LCY)" * pPorc;
      JobJournalLine."Unit Price"        := JobLedgerEntry."Unit Price" * pPorc;
      JobJournalLine."Unit Price (LCY)"  := JobLedgerEntry."Unit Price (LCY)" * pPorc;
      JobJournalLine."Total Cost"        := JobLedgerEntry."Total Cost" * pPorc;
      JobJournalLine."Total Cost (LCY)"  := JobLedgerEntry."Total Cost (LCY)" * pPorc;
      JobJournalLine."Total Price"       := JobLedgerEntry."Total Price" * pPorc;
      JobJournalLine."Total Price (LCY)" := JobLedgerEntry."Total Price (LCY)" * pPorc;
      JobJournalLine."Line Amount"       := JobLedgerEntry."Line Amount" * pPorc; ;
      JobJournalLine."Line Amount (LCY)" := JobLedgerEntry."Line Amount (LCY)" * pPorc;

      JobJournalLine."Cancel WIP" := TRUE;
      JobJournalLine."Posting Group" := JobLedgerEntry."Gen. Bus. Posting Group";
      JobJournalLine."Entry Type" := JobLedgerEntry."Entry Type";
      JobJournalLine."Source Code" := JobLedgerEntry."Source Code";
      JobJournalLine."Post Job Entry Only" := TRUE;
      JobJournalLine."Reason Code" := JobLedgerEntry."Reason Code";
      JobJournalLine."Gen. Bus. Posting Group" := JobLedgerEntry."Gen. Bus. Posting Group";
      JobJournalLine."Gen. Prod. Posting Group" := JobLedgerEntry."Gen. Prod. Posting Group";
      JobJournalLine."Quantity (Base)" := 1;
      JobJournalLine."Job Deviation Entry" := FALSE;
      JobJournalLine."Job in Progress" := TRUE;
      JobJournalLine.Chargeable := FALSE;
      JobJournalLine."Shortcut Dimension 1 Code" := JobLedgerEntry."Global Dimension 1 Code";
      JobJournalLine."Shortcut Dimension 2 Code" := JobLedgerEntry."Global Dimension 2 Code";
      JobJournalLine."Dimension Set ID" := JobLedgerEntry."Dimension Set ID";
      JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Journal;    //GAP888
      JobJournalLine."Related G/L Entry" := JobJournalLine."Related G/L Entry";   //JAV 03/12/20: - QB 1.07.10 Guardo el movimiento contable relacionado
      JobJournalLine.INSERT;
    END;

    PROCEDURE CancelDetailedCust(DetailedCustLedgEntry : Record 379;VAR tmpDetailedCustLedgEntry : Record 379;pDate : Date;pPorc : Decimal);
    VAR
      GLAccount : Record 15;
    BEGIN
      //Generar los movimientos detallados de cliente para anular el WIP
      tmpDetailedCustLedgEntry := DetailedCustLedgEntry;
      tmpDetailedCustLedgEntry."Posting Date" := pDate;
      tmpDetailedCustLedgEntry."Entry Type" := tmpDetailedCustLedgEntry."Entry Type"::Application;
      tmpDetailedCustLedgEntry."Document Type" := tmpDetailedCustLedgEntry."Document Type"::WIP;
      tmpDetailedCustLedgEntry.Amount := - DetailedCustLedgEntry.Amount * pPorc;
      tmpDetailedCustLedgEntry."Amount (LCY)" := -DetailedCustLedgEntry."Amount (LCY)" * pPorc;
      tmpDetailedCustLedgEntry.UpdateDebitCredit(TRUE);
      tmpDetailedCustLedgEntry.INSERT;
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Eventos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, Quantity, true, true)]
    LOCAL PROCEDURE T37_OnAfterValidateEvent_Quantity(VAR Rec : Record 37;VAR xRec : Record 37;CurrFieldNo : Integer);
    VAR
      FunctionQB : Codeunit 7207272;
      HistCertificationLines : Record 7207342;
      Text000 : TextConst ENU='You can not invoice more than the invoice for the certification %1 piecework %2',ESP='No se puede facturar m s de los pendiente de factura de la certificaci¢n %1 unidad de obra %2';
    BEGIN
      IF FunctionQB.AccessToQuobuilding THEN BEGIN
        IF (Rec."Document Type" <> Rec."Document Type"::Invoice) OR (Rec."QB Certification code" = '') THEN
          EXIT;

        IF HistCertificationLines.GET(Rec."QB Certification code",Rec."QB Certification Line No.") THEN BEGIN
          IF Rec.Quantity > HistCertificationLines."Certif. Quantity Not Inv." THEN
            ERROR(Text000,Rec."QB Certification code",HistCertificationLines."Piecework No.");
        END;
      END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterFinalizePosting, '', true, true)]
    LOCAL PROCEDURE CU80_OnAfterFinalizePosting(VAR SalesHeader : Record 36;VAR SalesShipmentHeader : Record 110;VAR SalesInvoiceHeader : Record 112;VAR SalesCrMemoHeader : Record 114;VAR ReturnReceiptHeader : Record 6660;VAR GenJnlPostLine : Codeunit 12;CommitIsSuppressed : Boolean;PreviewMode : Boolean);
    VAR
      SalesInvoiceLine : Record 113;
      SalesCrMemoLine : Record 115;
      PostCertifications : Record 7207341;
    BEGIN
      //JAV 22/03/21: - QB 1.08.27 Al registrar una factura o abono de venta de una certificaci�n, actualziar el importe facturado de la misma.

      IF (SalesInvoiceHeader."No." <> '') THEN BEGIN
        SalesInvoiceLine.RESET;
        SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
        SalesInvoiceLine.SETFILTER("QB Certification code", '<>%1','');
        IF (SalesInvoiceLine.FINDSET) THEN
          REPEAT
            IF (PostCertifications.GET(SalesInvoiceLine."QB Certification code")) THEN BEGIN
              PostCertifications."Amount Invoiced" += SalesInvoiceLine.Amount;
              PostCertifications."Invoiced Certification" := (PostCertifications."Amount Invoiced" = PostCertifications."Amount Document");
              PostCertifications.MODIFY;
            END;
          UNTIL (SalesInvoiceLine.NEXT = 0);
      END;

      IF (SalesCrMemoHeader."No." <> '') THEN BEGIN
        SalesCrMemoLine.RESET;
        SalesCrMemoLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
        SalesCrMemoLine.SETFILTER("QB Certification code", '<>%1','');
        IF (SalesCrMemoLine.FINDSET) THEN
          REPEAT
            IF (PostCertifications.GET(SalesCrMemoLine."QB Certification code")) THEN BEGIN
              PostCertifications."Amount Invoiced" -= SalesCrMemoLine.Amount;
              PostCertifications."Invoiced Certification" := (PostCertifications."Amount Invoiced" = PostCertifications."Amount Document");
              PostCertifications.MODIFY;
            END;
          UNTIL (SalesCrMemoLine.NEXT = 0);
      END;
    END;

    /*BEGIN
/*{
      SR.001 Actualizamos la redeterminaci�n para que quede marcada como ajustada.
      SR.002 En certificaciones por ajuste no se controlar� la cantidad
      SR.003 En las certifcaciones por ajuste la catulaizaci�n al facturar es mas facil
      JAV 31/07/19: - Marcar la certificaci�n que se cancela con la que la cancel�
      JAV 15/10/19: - Se cambia el uso de la variable MeasureHeader."Certification Text" que se ha eliminado por MeasureHeader."Text Measure"
                    - Se elimina el uso del campo "Posting Description" que no se utiliza
      JAV 22/06/22: - QB 1.10.52 Se recalculan estos importes a PEC porque dan problemas
      AML 03/07/23: - Q19745 Correcci�n de la facturacion de certificaciones.
      Q19892 Se pasa Q19876 de BS como Q19892 en QB. Q19876 CSM 18/07/23 � Fecha emisi�n superior a Fecha registro.
    }
END.*/
}







