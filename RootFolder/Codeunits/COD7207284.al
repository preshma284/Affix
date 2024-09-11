Codeunit 7207284 "Bring Certifications"
{
  
  
    TableNo=37;
    Permissions=TableData 7207341=r,
                TableData 7207342=r;
    trigger OnRun()
VAR
            Text002 : TextConst ENU='&Certificaci�n desglosada,Certificaci�n completa o &parcial en una l�nea',ESP='&Certificaci�n desglosada,Certificaci�n com&pleta en una l�nea';
            HistCertificationLines : Record 7207342;
            SalesHeader : Record 36;
            BringCertificationLines : Page 7207331;
            iOption : Integer;
            VJobs : Record 167;
            // pgInvoicedCertificationLines : Page 7207278;
            // InvoicedCertificationLines : Record 7207446;
            QtyCert : Decimal;
            QtyInv : Decimal;
          BEGIN
            SalesHeader.GET(Rec."Document Type", Rec."Document No.");
            //SalesHeader.TESTFIELD("Document Type",SalesHeader."Document Type"::Invoice); //GAP027
            SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
            SalesHeader.TESTFIELD("Sell-to Customer No.");

            HistCertificationLines.FILTERGROUP(0);
            IF SalesHeader."QB Job No." <> '' THEN BEGIN
              //-H13152
              VJobs.GET(SalesHeader."QB Job No.");
              VJobs.TESTFIELD("VAT Prod. PostingGroup");
              //+H13152
              HistCertificationLines.SETRANGE("Job No.",SalesHeader."QB Job No.")
            END ELSE
              HistCertificationLines.SETRANGE("Job No.");

            //GAP027 >>
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
              HistCertificationLines.SETFILTER("Cert Quantity to Term",'<%1',0);
            // GAP027 <<

            HistCertificationLines.SETRANGE("Customer No.",SalesHeader."Sell-to Customer No.");
            //-Q19477
            //HistCertificationLines.SETRANGE("Invoiced Certif.",FALSE);
            //+Q19477
            HistCertificationLines.SETFILTER("Piecework No.",'<>%1','');
            //-Q19477
            IF HistCertificationLines.FINDSET THEN
              REPEAT
                QtyCert := 0;
                QtyInv := 0;
                // InvoicedCertificationLines.RESET;
                // InvoicedCertificationLines.SETRANGE(InvoicedCertificationLines."Document No.",HistCertificationLines."Document No.");
                // InvoicedCertificationLines.SETRANGE(InvoicedCertificationLines."Line No.",HistCertificationLines."Line No.");
                // IF InvoicedCertificationLines.FINDSET THEN
                // REPEAT
                //   QtyCert := InvoicedCertificationLines."Cert Quantity to Term";
                //   QtyInv := InvoicedCertificationLines."Quantity to Invoice";
                // UNTIL InvoicedCertificationLines.NEXT = 0;
                IF QtyCert <> QtyInv THEN HistCertificationLines.MARK(TRUE);
              UNTIL HistCertificationLines.NEXT = 0;
            HistCertificationLines.MARKEDONLY(TRUE);
            //+Q19477
            HistCertificationLines.FILTERGROUP(2);
            BringCertificationLines.SETTABLEVIEW(HistCertificationLines);
            BringCertificationLines.SetSalesHeader(SalesHeader);
            BringCertificationLines.LOOKUPMODE(TRUE);
            IF (BringCertificationLines.RUNMODAL = ACTION::LookupOK) THEN BEGIN
              BringCertificationLines.GETRECORD(HistCertificationLines);
              BringCertificationLines.SETSELECTIONFILTER(HistCertificationLines);
              //-Q19477 Cumplimentar la nueva tabla.
              CreateLines_Invoiced(HistCertificationLines,SalesHeader);
              COMMIT;
              // CLEAR(pgInvoicedCertificationLines);
              // InvoicedCertificationLines.RESET;
              // InvoicedCertificationLines.SETRANGE(InvoicedCertificationLines."Document Type",SalesHeader."Document Type");
              // InvoicedCertificationLines.SETRANGE(InvoicedCertificationLines."Invoice No",SalesHeader."No.");
              // pgInvoicedCertificationLines.SETTABLEVIEW(InvoicedCertificationLines);
              // pgInvoicedCertificationLines.RUNMODAL;
              //+Q19477
              iOption := STRMENU(Text002, 2);
              CASE iOption OF
                1: CreateInvLines(HistCertificationLines, SalesHeader, TRUE);
                2: CreateInvLines(HistCertificationLines, SalesHeader, FALSE);
              END;
            END;
          END;
    VAR
      Text000 : TextConst ENU='Certification No. %1: Option " ","ESP="N� certificaci�n %1:';
      Text001 : TextConst ENU='"Invoice - Certification No.: "',ESP='Factura - Certificaci�n N�:';
      Text002 : TextConst ENU='Certification No. %1: Option " ","ESP="N� U.O. %1';
      Text010 : TextConst ESP='Certificaci�n a Origen';
      Text011 : TextConst ESP='A deducir certificaci�n anterior';
      Text012 : TextConst ESP='Certificaci�n actual';
      Text013 : TextConst ESP='"  (+) Gastos Generales (%1%)"';
      Text014 : TextConst ESP='"  (+) Beneficio Industrial (%1%)"';
      Text015 : TextConst ESP='"  (-) Baja (%1%)"';
      Text016 : TextConst ESP='"      Total"';
      Currency : Record 4;
      Text017 : TextConst ENU='Total a Origen.';
      Text018 : TextConst ENU='"      Importe de la Certificaci�n."';
      Text019 : TextConst ENU='Total Agrupaci�n %1 con %2.';

    PROCEDURE GetItemChargeAssgnt(VAR SalesShptLine : Record 7207342);
    VAR
      SalesOrderLine : Record 37;
      ItemChargeAssgntSales : Record 5809;
      HistCertificationLines : Record 7207342;
      PostCertifications : Record 7207341;
    BEGIN
      WITH HistCertificationLines DO BEGIN
        SETRANGE("Document No.",PostCertifications."No.");
        IF FINDSET(FALSE) THEN
          REPEAT
            ItemChargeAssgntSales.LOCKTABLE;
            ItemChargeAssgntSales.RESET;
            ItemChargeAssgntSales.SETRANGE("Document Type",SalesOrderLine."Document Type");
            ItemChargeAssgntSales.SETRANGE("Document No.",SalesOrderLine."Document No.");
            ItemChargeAssgntSales.SETRANGE("Document Line No.",SalesOrderLine."Line No.");
            IF ItemChargeAssgntSales.FINDFIRST THEN BEGIN
              ItemChargeAssgntSales.CALCSUMS("Qty. to Assign");
              IF ItemChargeAssgntSales."Qty. to Assign" <> 0 THEN
                CopyItemChargeAssgnt(SalesOrderLine,HistCertificationLines,ItemChargeAssgntSales."Qty. to Assign");
            END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CopyItemChargeAssgnt(SalesOrderLine : Record 37;HistLinCertif : Record 7207342;QtyToAssign : Decimal);
    VAR
      HistLinCertif2 : Record 7207342;
      SalesLine2 : Record 37;
      ItemChargeAssgntSales : Record 5809;
      ItemChargeAssgntSales2 : Record 5809;
      InsertChargeAssgnt : Boolean;
    BEGIN
      WITH SalesOrderLine DO BEGIN
        ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
        ItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
        IF ItemChargeAssgntSales.FINDSET(TRUE) THEN
          REPEAT
            IF ItemChargeAssgntSales."Qty. to Assign" <> 0 THEN BEGIN
              ItemChargeAssgntSales2 := ItemChargeAssgntSales;
              SalesLine2.SETRANGE("Shipment No.",HistLinCertif."Document No.");
              SalesLine2.SETRANGE("Shipment Line No.",HistLinCertif."Line No.");
              IF SalesLine2.FINDSET(FALSE) THEN
                REPEAT
                  SalesLine2.CALCFIELDS("Qty. to Assign");
                  InsertChargeAssgnt := SalesLine2."Qty. to Assign" <> SalesLine2.Quantity;
                UNTIL (SalesLine2.NEXT = 0) OR InsertChargeAssgnt;

              IF InsertChargeAssgnt THEN BEGIN
                ItemChargeAssgntSales2."Document Type" := SalesLine2."Document Type";
                ItemChargeAssgntSales2."Document No." := SalesLine2."Document No.";
                ItemChargeAssgntSales2."Document Line No." := SalesLine2."Line No.";
                ItemChargeAssgntSales2."Qty. Assigned" := 0;
                IF ABS(QtyToAssign) < ABS(ItemChargeAssgntSales2."Qty. to Assign") THEN
                  ItemChargeAssgntSales2."Qty. to Assign" := QtyToAssign;
                IF ABS(SalesLine2.Quantity - SalesLine2."Qty. to Assign") <
                   ABS(ItemChargeAssgntSales2."Qty. to Assign")
                THEN
                  ItemChargeAssgntSales2."Qty. to Assign" :=
                    SalesLine2.Quantity - SalesLine2."Qty. to Assign";
                ItemChargeAssgntSales2.VALIDATE("Unit Cost");

                IF ItemChargeAssgntSales2."Applies-to Doc. Type" = "Document Type" THEN BEGIN
                  ItemChargeAssgntSales2."Applies-to Doc. Type" := SalesLine2."Document Type";
                  ItemChargeAssgntSales2."Applies-to Doc. No." := SalesLine2."Document No.";
                  HistLinCertif2.SETRANGE("Line No.",ItemChargeAssgntSales."Applies-to Doc. Line No.");
                  HistLinCertif2.SETRANGE("Document No.",HistLinCertif."Document No.");
                  IF HistLinCertif2.FINDSET(FALSE) THEN BEGIN
                    SalesLine2.SETCURRENTKEY("Document Type","Shipment No.","Shipment Line No.");
                    SalesLine2.SETRANGE("Document Type",SalesOrderLine."Document Type"::Invoice);
                    SalesLine2.SETRANGE("Shipment No.",HistLinCertif2."Document No.");
                    SalesLine2.SETRANGE("Shipment Line No.",HistLinCertif2."Line No.");
                    IF SalesLine2.FINDFIRST AND (SalesLine2.Quantity <> 0) THEN
                      ItemChargeAssgntSales2."Applies-to Doc. Line No." := SalesLine2."Line No."
                    ELSE
                     InsertChargeAssgnt := FALSE;
                  END ELSE
                    InsertChargeAssgnt := FALSE;
                END;
              END;

              IF InsertChargeAssgnt AND (ItemChargeAssgntSales2."Qty. to Assign" <> 0) THEN BEGIN
                ItemChargeAssgntSales2.INSERT;
                QtyToAssign := QtyToAssign - ItemChargeAssgntSales2."Qty. to Assign";
              END;
            END;
          UNTIL ItemChargeAssgntSales.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE InsertHeaderLine(PostCertifications : Record 7207341;SalesHeader : Record 36;VAR LineNo : Integer);
    VAR
      SalesLine : Record 37;
    BEGIN
      //Insertar la l�nea con la descripci�n de la certificaci�n

      LineNo += 10000;
      SalesLine.INIT;
      SalesLine."Document Type" := SalesHeader."Document Type";
      SalesLine."Document No." := SalesHeader."No.";
      SalesLine."Line No." := LineNo;
      SalesLine.Description := PostCertifications."Text Measure"; //JAV 11/04/19: - Se cambia el c�digo del documento por el texto de la certificaci�n, que es mas apropiado para el cliente
      SalesLine.INSERT;
    END;

    LOCAL PROCEDURE InsertBlankLine(SalesHeader : Record 36;VAR LineNo : Integer);
    VAR
      SalesLine : Record 37;
    BEGIN
      //Insertar una l�nea en blanco

      LineNo += 10000;
      SalesLine.INIT;
      SalesLine."Document Type" := SalesHeader."Document Type";
      SalesLine."Document No." := SalesHeader."No.";
      SalesLine."Line No." := LineNo;
      SalesLine.INSERT;
    END;

    LOCAL PROCEDURE InsertDataLine(PostCertifications : Record 7207341;HistCertificationLines : Record 7207342;SalesHeader : Record 36;VAR LineNo : Integer);
    VAR
      SalesLine : Record 37;
      Job : Record 167;
      JobPostingGroup : Record 208;
    BEGIN
      //Inserta una l�nea detallada en la factura

      InsertOneLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo,
                    HistCertificationLines.Description, STRSUBSTNO(Text002, HistCertificationLines."Piecework No."),
                    HistCertificationLines."Cert Quantity to Origin", HistCertificationLines."Sale Price", TRUE);
    END;

    LOCAL PROCEDURE InsertTotalGrLine(PostCertifications : Record 7207341;HistCertificationLines : Record 7207342;SalesHeader : Record 36;VAR LineNo : Integer;AmountTotal : Decimal);
    VAR
      SalesLine : Record 37;
      Job : Record 167;
      JobPostingGroup : Record 208;
      Text000 : TextConst;
    BEGIN
      //Inserta una l�nea de total de agrupaci�n

      InsertOneLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo,
                    ' Total Agrupaci�n ' + HistCertificationLines."Grouping Code", '',
                    0, AmountTotal, FALSE);
    END;

    LOCAL PROCEDURE InsertAditionalLines(PostCertifications : Record 7207341;HistCertificationLines : Record 7207342;SalesHeader : Record 36;VAR LineNo : Integer;AmountOrigen : Decimal;AmountPeriodo : Decimal;Desglosada : Boolean);
    VAR
      SalesLine : Record 37;
      Job : Record 167;
      JobPostingGroup : Record 208;
      Text000 : TextConst;
      GG : Decimal;
      BI : Decimal;
      Baja : Decimal;
      AmountGG : Decimal;
      AmountBI : Decimal;
      AmountLowCoefient : Decimal;
      GLSetup : Record 98;
    BEGIN
      //Inserta l�neas de detalle de GG/BI/Baja

      //Leer el proyecto
      Job.GET(SalesHeader."QB Job No.");
      JobPostingGroup.GET(Job."Job Posting Group");
      JobPostingGroup.TESTFIELD(JobPostingGroup."Recognized Sales Account");

      //Crear las l�neas adicionales
      GLSetup.GET;
      GetCurrency('');
      AmountGG := ROUND(AmountPeriodo * Job."General Expenses / Other"/100,Currency."Amount Rounding Precision");
      AmountBI := ROUND(AmountPeriodo * Job."Industrial Benefit"/100,Currency."Amount Rounding Precision");
      AmountLowCoefient := ROUND((AmountPeriodo + AmountGG + AmountBI) * Job."Low Coefficient"/100,Currency."Amount Rounding Precision");

      IF (Desglosada) THEN
        InsertOneLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo, Text017, '', 0, AmountOrigen, FALSE)
      ELSE
        InsertOneLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo, Text017, '', 1, AmountOrigen, FALSE);

      IF (AmountOrigen <> AmountPeriodo) THEN
        InsertOneLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo, Text011, '', -1, AmountOrigen - AmountPeriodo, FALSE);
      IF (PostCertifications."Amount Term" <> PostCertifications."Amount Origin") THEN
        InsertOneLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo, Text012, '', 0, AmountPeriodo, FALSE);
      IF (AmountGG <> 0) THEN
        InsertOneLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo, STRSUBSTNO(Text013, Job."General Expenses / Other"), '', 1, AmountGG, FALSE);
      IF (AmountBI <> 0) THEN
        InsertOneLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo, STRSUBSTNO(Text014, Job."Industrial Benefit"), '', 1, AmountBI, FALSE);
      IF (AmountLowCoefient <> 0) THEN
        InsertOneLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo, STRSUBSTNO(Text015, Job."Low Coefficient"), '', -1,AmountLowCoefient, FALSE);
      IF (PostCertifications."Amount Document" <> 0) THEN
        InsertOneLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo, Text018, '', 0, AmountPeriodo + AmountGG + AmountBI - AmountLowCoefient, FALSE);
    END;

    LOCAL PROCEDURE InsertOneLine(PostCertifications : Record 7207341;HistCertificationLines : Record 7207342;SalesHeader : Record 36;VAR LineNo : Integer;Des1 : Text;Des2 : Text;Qty : Decimal;Price : Decimal;pCertLine : Boolean);
    VAR
      SalesLine : Record 37;
      Job : Record 167;
      JobPostingGroup : Record 208;
    BEGIN
      //Inserta una l�nea con importes en la factura

      //Leer el proyecto
      Job.GET(SalesHeader."QB Job No.");
      JobPostingGroup.GET(Job."Job Posting Group");
      JobPostingGroup.TESTFIELD(JobPostingGroup."Recognized Sales Account");

      //Crear la l�nea
      LineNo += 10000;
      SalesLine.INIT;
      SalesLine."Document Type" := SalesHeader."Document Type";
      SalesLine."Document No." := SalesHeader."No.";
      SalesLine."Line No." := LineNo;

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
        SalesLine.VALIDATE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup"); //PSM 10/06/21: - QB 1.08.48 Error en el campo
      //-H13152
      IF HistCertificationLines."VAT Prod. Posting Group" <> '' THEN
        SalesLine.VALIDATE("VAT Prod. Posting Group",HistCertificationLines."VAT Prod. Posting Group");
      //+H13152

      SalesLine."Dimension Set ID" := HistCertificationLines."Dimension Set ID";
      SalesLine.VALIDATE("Job No.", HistCertificationLines."Job No.");
      SalesLine.Description := Des1;
      SalesLine."Description 2" := Des2;
      SalesLine.Quantity := Qty;
      SalesLine.VALIDATE("Unit Price", Price);
      SalesLine."QB Certification code" := HistCertificationLines."Document No.";
      IF (pCertLine) THEN
        SalesLine."QB Certification Line No." := HistCertificationLines."Line No.";

      SalesLine."Qty. to Ship" := SalesLine.Quantity;
      SalesLine."Qty. to Invoice" := SalesLine.Quantity;
      SalesLine."Outstanding Qty. (Base)" := 0;
      SalesLine."Outstanding Quantity" := 0;
      SalesLine."Quantity Invoiced" := 0;
      SalesLine."Qty. Invoiced (Base)" := 0;
      SalesLine."Purchase Order No." := '';
      SalesLine."Purch. Order Line No." := 0;
      SalesLine."Drop Shipment" := FALSE;

      SalesLine.INSERT;
    END;

    LOCAL PROCEDURE GetCurrency(CurrencyCode : Code[10]);
    BEGIN
      IF CurrencyCode = '' THEN
        Currency.InitRoundingPrecision
      ELSE BEGIN
        Currency.GET(CurrencyCode);
        Currency.TESTFIELD("Amount Rounding Precision");
      END;
    END;

    PROCEDURE CreateInvLines(VAR HistCertificationLines : Record 7207342;VAR SalesHeader : Record 36;pDesglosada : Boolean);
    VAR
      WithholdingTreating : Codeunit 7207306;
      LineNo : Integer;
      SalesLine : Record 37;
      PostCertifications : Record 7207341;
      LastHistCertificationLines : Record 7207342;
      SalesLineTemp : Record 37 TEMPORARY;
      QuoBuildingSetup : Record 7207278;
      Job : Record 167;
      DataPieceworkForProduction : Record 7207386;
      AntCER : Code[20];
      AntVAT : Code[20];
      AntAgr : Code[20];
      TotalOrigen : Decimal;
      TotalPeriodo : Decimal;
      TotalAgr : Decimal;
      nrAgr : Integer;
      // InvoicedCertificationLines : Record 7207446;
    BEGIN
      //Pasamos a la factura las l�neas de las certificaciones a insertar

      QuoBuildingSetup.GET;
      Job.GET(SalesHeader."QB Job No.");
      Job.TESTFIELD("VAT Prod. PostingGroup");

      //Leer la �ltima l�nea de la factura para poder a�adir detr�s
      SalesLine.RESET;
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      IF (SalesLine.FINDLAST) THEN
        LineNo := SalesLine."Line No."
      ELSE
        LineNo := 0;

      //Ajustamos los campos de las l�neas para poderlos agrupar
      //++HistCertificationLines.SETFILTER("Cert Quantity to Term",'<>0'); //JAV 18/10/21: - QB 1.09.22 Considerar todas las l�neas de la certificaci�n
      IF HistCertificationLines.FINDSET THEN
        REPEAT
          IF DataPieceworkForProduction.GET(HistCertificationLines."Job No.",HistCertificationLines."Piecework No.") THEN BEGIN
            //Informamos del c�digo de la agrupaci�n
            IF (QuoBuildingSetup."Use Grouping") THEN
              HistCertificationLines."Grouping Code" := DataPieceworkForProduction."Grouping Code"
            ELSE
              HistCertificationLines."Grouping Code" := '';

            //Informamos del Grupo de IVA. Si la unidad de obra no tiene Grupo Reg. IVA producto se asigna el de la obra.
            IF DataPieceworkForProduction."VAT Prod. Posting Group" <> '' THEN
              HistCertificationLines."VAT Prod. Posting Group" := DataPieceworkForProduction."VAT Prod. Posting Group"
            ELSE
              HistCertificationLines."VAT Prod. Posting Group" := Job."VAT Prod. PostingGroup";

            HistCertificationLines.MODIFY;
          END;
        UNTIL HistCertificationLines.NEXT = 0;

      //Contamos cuantas agrupaciones hay
      nrAgr := 0;
      IF (QuoBuildingSetup."Use Grouping") THEN BEGIN
        AntAgr := '';
        HistCertificationLines.SETCURRENTKEY("Document No.","Grouping Code");
        IF HistCertificationLines.FINDSET THEN
          REPEAT
            IF (nrAgr = 0) THEN
              nrAgr := 1
            ELSE IF (AntAgr <> HistCertificationLines."Grouping Code") THEN
              nrAgr += 1;
            AntAgr := HistCertificationLines."Grouping Code"
          UNTIL HistCertificationLines.NEXT = 0;
        MESSAGE('%1', nrAgr);
      END;

      //A�adirmos las l�neas al documento
      HistCertificationLines.SETCURRENTKEY("Document No.","VAT Prod. Posting Group","Grouping Code");
      IF HistCertificationLines.FINDSET THEN BEGIN
        SalesLine.LOCKTABLE;
        AntCER := '';
        AntVAT := '';
        AntAgr := '';
        TotalOrigen := 0;
        TotalPeriodo := 0;
        TotalAgr := 0;
        REPEAT
          //Si cambia la certificaci�n
          IF (AntCER <> HistCertificationLines."Document No.") THEN BEGIN
            PostCertifications.GET(HistCertificationLines."Document No.");
            PostCertifications.TESTFIELD(PostCertifications."Customer No.", SalesHeader."Bill-to Customer No."); //Debe ser del mismo cliente y proyecto
            PostCertifications.TESTFIELD(PostCertifications."Job No.", SalesHeader."QB Job No.");

            //Si es la primera no meto los totales
            IF (AntCER <> '') THEN BEGIN
              IF (nrAgr <> 1) THEN
                InsertTotalGrLine(PostCertifications, LastHistCertificationLines, SalesHeader, LineNo, TotalAgr);
              InsertAditionalLines(PostCertifications, LastHistCertificationLines, SalesHeader, LineNo, TotalOrigen, TotalPeriodo, pDesglosada);
              InsertBlankLine(SalesHeader, LineNo);
            END;

            InsertHeaderLine(PostCertifications, SalesHeader, LineNo);
            TotalOrigen := 0;
            TotalPeriodo := 0;
            TotalAgr := 0;
            AntCER := HistCertificationLines."Document No.";
            AntVAT := HistCertificationLines."VAT Prod. Posting Group";
            AntAgr := HistCertificationLines."Grouping Code";
          END;

          //Si cambia el IVA
          IF (AntVAT <> HistCertificationLines."VAT Prod. Posting Group") THEN BEGIN
            IF (nrAgr <> 1) THEN
              InsertTotalGrLine(PostCertifications, LastHistCertificationLines, SalesHeader, LineNo, TotalAgr);
            InsertAditionalLines(PostCertifications, LastHistCertificationLines, SalesHeader, LineNo, TotalOrigen, TotalPeriodo, pDesglosada);
            InsertBlankLine(SalesHeader, LineNo);

            TotalOrigen := 0;
            TotalPeriodo := 0;
            TotalAgr := 0;
            AntVAT := HistCertificationLines."VAT Prod. Posting Group";
            AntAgr := HistCertificationLines."Grouping Code";
          END;

          //Si cambia la agrupaci�n
          IF (AntAgr <> HistCertificationLines."Grouping Code") THEN BEGIN
            IF (nrAgr <> 1) THEN
              InsertTotalGrLine(PostCertifications, LastHistCertificationLines, SalesHeader, LineNo, TotalAgr);

            TotalAgr := 0;
            AntAgr := HistCertificationLines."Grouping Code";
          END;

          //Si es detallado, inserto la l�nea en la factura
          //-Q19477
          //IF (pDesglosada) THEN
          //  InsertDataLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo);
          // IF (pDesglosada) THEN BEGIN
          //   InsertDataLine(PostCertifications, HistCertificationLines, SalesHeader, LineNo);
            // IF InvoicedCertificationLines.GET(SalesHeader."Document Type",SalesHeader."No.",HistCertificationLines."Document No.",HistCertificationLines."Line No.") THEN BEGIN
            //    InvoicedCertificationLines."Invoice Line" := LineNo;
            //    InvoicedCertificationLines.MODIFY;
            // END;
          // END
          // ELSE BEGIN
          //   IF InvoicedCertificationLines.GET(SalesHeader."Document Type",SalesHeader."No.",HistCertificationLines."Document No.",HistCertificationLines."Line No.") THEN BEGIN
          //      InvoicedCertificationLines."Invoice Line" := LineNo + 10000;
          //      InvoicedCertificationLines.MODIFY;
          //   END;
          // END;
          //+Q19477
          //-Q19477
          TotalOrigen  += HistCertificationLines."Cert Source PEM amount";
          TotalPeriodo += HistCertificationLines."Cert Term PEM amount";
          TotalAgr     += HistCertificationLines."Cert Source PEM amount";

          //Me guardo la l�nea actual como la �ltima l�nea leida, ya que los totales se lanzan al leer una nueva l�nea y ver que es diferente a la anterior
          LastHistCertificationLines := HistCertificationLines;
        UNTIL HistCertificationLines.NEXT = 0;

        //Cerramos la �ltima certificaci�n
        IF (nrAgr > 1) THEN  //JAV 18/10/21: - QB 1.09.22 Pon�ia <> 1, debe ser mayor de 1 pues si no las de cero agrupaciones entran
          InsertTotalGrLine(PostCertifications, LastHistCertificationLines, SalesHeader, LineNo, TotalAgr);
        InsertAditionalLines(PostCertifications, LastHistCertificationLines, SalesHeader, LineNo, TotalOrigen, TotalPeriodo, pDesglosada);

        GetItemChargeAssgnt(HistCertificationLines);
      END;

      WithholdingTreating.CalculateWithholding_SalesHeader(SalesHeader);
    END;

    LOCAL PROCEDURE CreateLines_Invoiced(VAR HistCertificationLines : Record 7207342;VAR SalesHeader : Record 36);
    VAR
      // InvoicedCertificationLines : Record 7207446;
    BEGIN
      //EXIT;
      HistCertificationLines.SETCURRENTKEY("Document No.","VAT Prod. Posting Group","Grouping Code");
      IF HistCertificationLines.FINDSET THEN BEGIN
        REPEAT
          // InvoicedCertificationLines.TRANSFERFIELDS(HistCertificationLines);
          // InvoicedCertificationLines."Document Type" := SalesHeader."Document Type";
          // InvoicedCertificationLines."Invoice No" := SalesHeader."No.";
          // IF InvoicedCertificationLines.INSERT THEN; //Por si la traemos otra vez.
        UNTIL HistCertificationLines.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE "-----------------Table 37"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T37_OnAfterDelete(VAR Rec : Record 37;RunTrigger : Boolean);
    VAR
      // InvoicedCertificationLines : Record 7207446;
    BEGIN
      IF Rec."QB Certification code" = '' THEN EXIT;
      // InvoicedCertificationLines.SETRANGE(InvoicedCertificationLines."Document Type",Rec."Document Type");
      // InvoicedCertificationLines.SETRANGE(InvoicedCertificationLines."Invoice No",Rec."Document No.");
      // InvoicedCertificationLines.SETRANGE(InvoicedCertificationLines."Invoice Line",Rec."Line No.");
      // IF InvoicedCertificationLines.FINDSET THEN
      //   REPEAT
      //     InvoicedCertificationLines.VALIDATE(InvoicedCertificationLines."Quantity to Invoice",0);
      //     InvoicedCertificationLines.MODIFY;
      //   UNTIL InvoicedCertificationLines.NEXT = 0;
    END;

    /*BEGIN
/*{
      GAP027 PGM 23/07/2019 - Funcionalidad para filtrar las lineas de certificaciones en negativos si se llevan a un abono.
      Q13152 DGG 01/07/2021 - Modicicac�ones para que la inserccion de las lineas de certificacion en las facturas agrupe por Grupo de IVA producto y Agrupaci�n.
      Q19477 AML 04/07/23 Para que no permita certificar ya facturados.
    }
END.*/
}







