Codeunit 7207295 "Purchase Rcpt. Pending Invoice"
{


    Permissions = TableData 121 = rim,
                TableData 6651 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        GenJnlPostLine: Codeunit 12;
        GLAccount: Record 15;
        GenJournalLine: Record 81;
        TempPurchRcptLine: Record 121 TEMPORARY;
        PurchaseHeaderDif: Record 38;

    LOCAL PROCEDURE "--------------------------------------------------- Funciones para compras"();
    BEGIN
    END;

    PROCEDURE ActivatePurchaseRcpt(VAR PurchRcptHeader: Record 120; PostDate: Date);
    VAR
        PurchRcptLine: Record 121;
    BEGIN
        //Genera la provisi�n del albar�n de compra
        CLEAR(GenJnlPostLine);
        PurchRcptLine.SETRANGE("Document No.", PurchRcptHeader."No.");
        PurchRcptLine.SETFILTER("Job No.", '<>%1', '');
        IF PurchRcptLine.FINDSET(TRUE) THEN
            REPEAT
                ActivatePurchaseRcptLine(PurchRcptLine, PostDate);
            UNTIL PurchRcptLine.NEXT = 0;
    END;

    LOCAL PROCEDURE ActivatePurchaseRcptLine(VAR PurchRcptLine: Record 121; PostDate: Date);
    VAR
        PurchaseLine: Record 39;
        Currency: Record 4;
        Quantity: Decimal;
        Amount: Decimal;
        Job: Record 167;
    BEGIN
        //Genera la provisi�n de una l�nea del albar�n de compra
        IF (PurchRcptLine.Quantity = PurchRcptLine."Quantity Invoiced") THEN
            EXIT;

        IF PurchRcptLine.Accounted THEN
            EXIT;

        //Si el proyecto no tiene el tick de Almac�n de proyecto, entonces no hacemos nada
        Job.GET(PurchRcptLine."Job No.");
        IF NOT Job."Purcharse Shipment Provision" THEN
            EXIT;

        PurchaseLine.GET(PurchaseLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");

        IF (PurchaseLine."Currency Code" = '') THEN
            CLEAR(Currency)
        ELSE
            Currency.GET(PurchaseLine."Currency Code");
        Currency.InitRoundingPrecision;

        Quantity := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
        Amount := ROUND(Quantity * PurchRcptLine."Unit Cost", Currency."Amount Rounding Precision");

        IF Amount = 0 THEN
            EXIT;

        CreateAccountingNotes(Amount, PostDate, PurchRcptLine, FALSE);
        CreateJobJournal(PurchRcptLine, Quantity, PostDate, FALSE);

        PurchRcptLine.Accounted := TRUE;
        PurchRcptLine."QB Qty Provisioned" += Quantity;  //JAV 22/10/21: - QB 1.09.22 Sumar a la cantidad provisionada del albar�n
        PurchRcptLine."QB Amount Provisioned" += Amount;
        PurchRcptLine.MODIFY;
    END;

    PROCEDURE DeactivatePurchaseRcpt(DateCanceled: Date; VAR TempPurchRcptLine: Record 121 TEMPORARY);
    VAR
        PurchRcptLine: Record 121;
        Job: Record 167;
    BEGIN
        //Genera la desprovisi�n de un albar�n de compra al facturarlo o cancelarlo
        CLEAR(GenJnlPostLine);
        IF TempPurchRcptLine.FINDSET(FALSE) THEN
            REPEAT
                PurchRcptLine.GET(TempPurchRcptLine."Document No.", TempPurchRcptLine."Line No.");
                IF PurchRcptLine."Job No." <> '' THEN BEGIN
                    //Si el Job no tiene el tick de provisionar albaranes de compra entonces no hacemos nada
                    Job.GET(PurchRcptLine."Job No.");
                    //-Q19771
                    //IF Job."Purcharse Shipment Provision" THEN
                    IF (Job."Purcharse Shipment Provision") AND (PurchRcptLine."Order No." <> '') THEN  //No se desprovisiona si no viene de otro albaran
                                                                                                        //+Q19771
                        DeactivatePurchaseRcptLine(TempPurchRcptLine.Quantity, DateCanceled, PurchRcptLine);

                END;
            UNTIL TempPurchRcptLine.NEXT = 0;
    END;

    LOCAL PROCEDURE DeactivatePurchaseRcptLine(QuantityToInvoice: Decimal; Date: Date; VAR PurchRcptLine: Record 121);
    VAR
        Currency: Record 4;
        PurchRcptHeader: Record 120;
        DetailedVendorLedgEntry: Record 380;
        DetailedVendorLedgEntry2: Record 380;
        NoMov: Integer;
        newMov: Integer;
        endSum: Decimal;
        endSumDL: Decimal;
        Amount: Decimal;
        Quantity: Decimal;
        Job: Record 167;
        PurchInvLine: Record 123;
        Importe: Decimal;
        GeneralLedgerSetup: Record 98;
    BEGIN
        //Genera la desprovisi�n de una l�nea de albar�n de compra al facturarlo o cancelarlo
        PurchRcptHeader.GET(PurchRcptLine."Document No.");

        IF (PurchRcptHeader."Currency Code" = '') THEN
            CLEAR(Currency)
        ELSE
            Currency.GET(PurchRcptHeader."Currency Code");
        Currency.InitRoundingPrecision;

        Quantity := QuantityToInvoice;
        Amount := ROUND(QuantityToInvoice * PurchRcptLine."Unit Cost", Currency."Amount Rounding Precision");

        CreateAccountingNotes(-Amount, Date, PurchRcptLine, TRUE);
        CreateJobJournal(PurchRcptLine, -Quantity, Date, TRUE);

        //Buscamos el importe actual del albar�n en divisa y DL incluyendo los ajustes de cambio, y si debe quedar a cero creo los ajustes necesarios
        NoMov := 0;
        endSum := 0;
        endSumDL := 0;
        DetailedVendorLedgEntry.RESET;
        DetailedVendorLedgEntry.SETRANGE("Document Type", DetailedVendorLedgEntry."Document Type"::Shipment);
        DetailedVendorLedgEntry.SETRANGE("Document No.", PurchRcptLine."Document No.");
        DetailedVendorLedgEntry.SETRANGE("QB Shipment Line No", PurchRcptLine."Line No.");
        IF (DetailedVendorLedgEntry.FINDSET(FALSE)) THEN
            REPEAT
                //Realizar� el ajuste sobre el �ltimo movimiento de albar�n
                NoMov := DetailedVendorLedgEntry."Entry No.";
                //Sumo los importes de los movimientos relacionados con el movimiento de proveedor, lo que incluye los ajustes de divisas
                DetailedVendorLedgEntry2.RESET;
                DetailedVendorLedgEntry2.SETRANGE("Vendor Ledger Entry No.", DetailedVendorLedgEntry."Vendor Ledger Entry No.");
                IF (DetailedVendorLedgEntry2.FINDSET(FALSE)) THEN
                    REPEAT
                        endSum += DetailedVendorLedgEntry2.Amount;
                        endSumDL += DetailedVendorLedgEntry2."Amount (LCY)";
                    UNTIL DetailedVendorLedgEntry2.NEXT = 0;
            UNTIL DetailedVendorLedgEntry.NEXT = 0;

        //Si no queda nada pendiente en divisa pero si en DL, creo un movimiento para dejarlo a cero
        IF (endSum = 0) AND (endSumDL <> 0) THEN BEGIN
            CreateAdjustAccountingNotes(PurchRcptLine, endSumDL, Date);
            CreateAdjustJobJournal(PurchRcptLine, endSumDL, Date);
            //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.Begin
            //CreateVendorDetailedLedger(PurchRcptLine, -endSumDL, Date, NoMov);
            CreateVendorDetailedLedger(PurchRcptLine."Job No.", -endSumDL, Date, NoMov);
            //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.End
        END;

        //JAV 22/10/21: - QB 1.09.22 Restar a la cantidad provisionada de la l�nea
        PurchRcptLine."QB Qty Provisioned" -= Quantity;
        PurchRcptLine."QB Amount Provisioned" -= endSum;
        PurchRcptLine.MODIFY;

        //-Q19430 AML 4/5/23 Ajuste en caso de almacenar y precio factura <> precio Albaran
        //AMLXXX
        IF Job.GET(PurchRcptLine."Job No.") THEN BEGIN
            GeneralLedgerSetup.GET;
            PurchInvLine.SETRANGE("Receipt No.", PurchRcptLine."Document No.");
            PurchInvLine.SETRANGE("Receipt Line No.", PurchRcptLine."Line No.");
            //-Q19877
            PurchInvLine.SETRANGE(Type, PurchInvLine.Type::Item);
            //+Q19877
            IF PurchInvLine.FINDFIRST THEN BEGIN
                //-Q19877 Solo ajustamos si hay acopio.
                IF (PurchInvLine."Piecework No." = Job."Warehouse Cost Unit") AND (PurchInvLine."Piecework No." <> '') THEN BEGIN
                    //+Q19877
                    //-Q19877
                    //Importe := ROUND(PurchRcptLine."Unit Cost" * PurchRcptLine.Quantity ,GeneralLedgerSetup."Amount Rounding Precision");
                    //+Q19877
                    Importe := ROUND(PurchRcptLine."Unit Cost" * PurchInvLine.Quantity, GeneralLedgerSetup."Amount Rounding Precision");

                    IF (ABS(Importe - PurchInvLine.Amount) > 1) THEN BEGIN //AML As� evitamos diferencias por redondeos.
                        CreateAdjustJobJournalDifferences(PurchRcptLine, ROUND(PurchInvLine.Amount - Importe, GeneralLedgerSetup."Amount Rounding Precision"), Date);
                    END;

                    //-Q19877
                END;
                //+Q19877
            END;
        END;
        //+Q19430
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Funciones para Devoluciones"();
    BEGIN
    END;

    PROCEDURE ActivateReturnShipment(VAR ReturnShipmentHeader: Record 6650; PostDate: Date);
    VAR
        ReturnShipmentLine: Record 6651;
    BEGIN
        //Genera la provisi�n del albar�n de compra
        CLEAR(ReturnShipmentLine);
        ReturnShipmentLine.SETRANGE("Document No.", ReturnShipmentHeader."No.");
        ReturnShipmentLine.SETFILTER("Job No.", '<>%1', '');
        IF ReturnShipmentLine.FINDSET(TRUE) THEN
            REPEAT
                ActivateReturnShipmentLine(ReturnShipmentLine, PostDate);
            UNTIL ReturnShipmentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE ActivateReturnShipmentLine(VAR ReturnShipmentLine: Record 6651; PostDate: Date);
    VAR
        PurchaseLine: Record 39;
        Currency: Record 4;
        Quantity: Decimal;
        Amount: Decimal;
        Job: Record 167;
    BEGIN
        //Genera la provisi�n de una l�nea del albar�n de compra
        IF (ReturnShipmentLine.Quantity = ReturnShipmentLine."Quantity Invoiced") THEN
            EXIT;

        IF ReturnShipmentLine.Accounted THEN
            EXIT;

        //Si el proyecto no tiene el tick de Almac�n de proyecto, entonces no hacemos nada
        Job.GET(ReturnShipmentLine."Job No.");
        IF NOT Job."Purcharse Shipment Provision" THEN
            EXIT;

        PurchaseLine.GET(PurchaseLine."Document Type"::"Return Order", ReturnShipmentLine."Return Order No.", ReturnShipmentLine."Return Order Line No.");

        IF (PurchaseLine."Currency Code" = '') THEN
            CLEAR(Currency)
        ELSE
            Currency.GET(PurchaseLine."Currency Code");
        Currency.InitRoundingPrecision;

        Quantity := -(ReturnShipmentLine.Quantity - ReturnShipmentLine."Quantity Invoiced");
        Amount := ROUND(Quantity * ReturnShipmentLine."Unit Cost", Currency."Amount Rounding Precision");

        IF Amount = 0 THEN
            EXIT;

        CreateReturnShipmentAccountingNotes(Amount, PostDate, ReturnShipmentLine, FALSE);
        CreateReturnShipmentJobJournal(ReturnShipmentLine, Quantity, PostDate, FALSE);

        ReturnShipmentLine.Accounted := TRUE;
        ReturnShipmentLine."QB Qty Provisioned" += Quantity;  //JAV 22/10/21: - QB 1.09.22 Sumar a la cantidad provisionada del albar�n
        ReturnShipmentLine."QB Amount Provisioned" += Amount;
        ReturnShipmentLine.MODIFY;
    END;

    PROCEDURE DeactivateReturnShipment(DateCanceled: Date; VAR TempReturnShipmentLine: Record 6651 TEMPORARY; PurchaseHeader: Record 38);
    VAR
        ReturnShipmentLine: Record 6651;
        Job: Record 167;
        PurchCrMemoLine: Record 125;
        GeneralLedgerSetup: Record 98;
        Importe: Decimal;
        PurchaseLine: Record 39;
    BEGIN
        //Genera la desprovisi�n de un albar�n de compra al facturarlo o cancelarlo
        CLEAR(GenJnlPostLine);
        IF TempReturnShipmentLine.FINDSET(FALSE) THEN
            REPEAT
                ReturnShipmentLine.GET(TempReturnShipmentLine."Document No.", TempReturnShipmentLine."Line No.");
                IF ReturnShipmentLine."Job No." <> '' THEN BEGIN
                    //Si el Job no tiene el tick de provisionar albaranes de compra entonces no hacemos nada
                    Job.GET(ReturnShipmentLine."Job No.");
                    IF Job."Purcharse Shipment Provision" THEN
                        DeactivateReturnShipmentLine(TempReturnShipmentLine.Quantity, DateCanceled, ReturnShipmentLine);
                END;
            UNTIL TempReturnShipmentLine.NEXT = 0;

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //q20364 Ajuste para abonos Tomado de -Q19430 AML 4/5/23 Ajuste en caso de almacenar y precio factura <> precio Albaran
        //AMLXXX
        IF Job.GET(ReturnShipmentLine."Job No.") THEN BEGIN
            GeneralLedgerSetup.GET;
            /*{
                     PurchCrMemoLine.SETRANGE("Receipt No.",ReturnShipmentLine."Document No.");
                     PurchCrMemoLine.SETRANGE("Receipt Line No.",ReturnShipmentLine."Line No.");
                     PurchCrMemoLine.SETRANGE(Type,PurchCrMemoLine.Type::Item);
                     IF PurchCrMemoLine.FINDFIRST THEN BEGIN
                       //Solo ajustamos si hay acopio.
                       IF (PurchCrMemoLine."Piecework No." = Job."Warehouse Cost Unit") AND (PurchCrMemoLine."Piecework No."<> '') THEN BEGIN
                          Importe := ROUND(ReturnShipmentLine."Unit Cost" * PurchCrMemoLine.Quantity ,GeneralLedgerSetup."Amount Rounding Precision");
                          IF (ABS(Importe - PurchCrMemoLine.Amount) > 1) THEN BEGIN //AML As� evitamos diferencias por redondeos.
                             CreateAdjustReturnShipmentJobJournalDifferences(ReturnShipmentLine,ROUND(PurchCrMemoLine.Amount - Importe,GeneralLedgerSetup."Amount Rounding Precision"),TempReturnShipmentLine."Posting Date");
                          END;
                        END;
                     END;
                     }*/
            PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
            PurchaseLine.SETRANGE("Return Shipment No.", ReturnShipmentLine."Document No.");
            PurchaseLine.SETRANGE("Return Shipment Line No.", ReturnShipmentLine."Line No.");
            PurchaseLine.SETRANGE(Type, PurchCrMemoLine.Type::Item);
            IF PurchaseLine.FINDFIRST THEN BEGIN
                //Solo ajustamos si hay acopio.
                IF (PurchaseLine."Piecework No." = Job."Warehouse Cost Unit") AND (PurchaseLine."Piecework No." <> '') THEN BEGIN
                    Importe := ROUND(ReturnShipmentLine."Unit Cost" * PurchaseLine."Qty. to Invoice", GeneralLedgerSetup."Amount Rounding Precision");
                    IF (ABS(Importe - PurchaseLine.Amount) > 0.03) THEN BEGIN //AML As� evitamos diferencias por redondeos.
                        CreateAdjustReturnShipmentJobJournalDifferences(ReturnShipmentLine, ROUND(PurchaseLine.Amount - Importe, GeneralLedgerSetup."Amount Rounding Precision"), DateCanceled);
                    END;
                END;

            END;
        END;
    END;

    LOCAL PROCEDURE DeactivateReturnShipmentLine(QuantityToInvoice: Decimal; Date: Date; VAR ReturnShipmentLine: Record 6651);
    VAR
        Currency: Record 4;
        ReturnShipmentHeader: Record 6650;
        DetailedVendorLedgEntry: Record 380;
        DetailedVendorLedgEntry2: Record 380;
        NoMov: Integer;
        newMov: Integer;
        endSum: Decimal;
        endSumDL: Decimal;
        Amount: Decimal;
        Quantity: Decimal;
    BEGIN
        //Genera la desprovisi�n de una l�nea de albar�n de compra al facturarlo o cancelarlo
        ReturnShipmentHeader.GET(ReturnShipmentLine."Document No.");

        IF (ReturnShipmentHeader."Currency Code" = '') THEN
            CLEAR(Currency)
        ELSE
            Currency.GET(ReturnShipmentHeader."Currency Code");
        Currency.InitRoundingPrecision;

        Quantity := -QuantityToInvoice;
        Amount := -ROUND(QuantityToInvoice * ReturnShipmentLine."Unit Cost", Currency."Amount Rounding Precision");

        CreateReturnShipmentAccountingNotes(-Amount, Date, ReturnShipmentLine, TRUE);
        //-Q20364
        //CreateReturnShipmentJobJournal(ReturnShipmentLine, -Quantity, Date, TRUE);
        CreateReturnShipmentJobJournal(ReturnShipmentLine, Quantity, Date, TRUE);
        //+Q20364

        //Buscamos el importe actual del albar�n en divisa y DL incluyendo los ajustes de cambio, y si debe quedar a cero creo los ajustes necesarios
        NoMov := 0;
        endSum := 0;
        endSumDL := 0;
        DetailedVendorLedgEntry.RESET;
        DetailedVendorLedgEntry.SETRANGE("Document Type", DetailedVendorLedgEntry."Document Type"::Shipment);
        DetailedVendorLedgEntry.SETRANGE("Document No.", ReturnShipmentLine."Document No.");
        DetailedVendorLedgEntry.SETRANGE("QB Shipment Line No", ReturnShipmentLine."Line No.");
        IF (DetailedVendorLedgEntry.FINDSET(FALSE)) THEN
            REPEAT
                //Realizar� el ajuste sobre el �ltimo movimiento de albar�n
                NoMov := DetailedVendorLedgEntry."Entry No.";
                //Sumo los importes de los movimientos relacionados con el movimiento de proveedor, lo que incluye los ajustes de divisas
                DetailedVendorLedgEntry2.RESET;
                DetailedVendorLedgEntry2.SETRANGE("Vendor Ledger Entry No.", DetailedVendorLedgEntry."Vendor Ledger Entry No.");
                IF (DetailedVendorLedgEntry2.FINDSET(FALSE)) THEN
                    REPEAT
                        endSum += DetailedVendorLedgEntry2.Amount;
                        endSumDL += DetailedVendorLedgEntry2."Amount (LCY)";
                    UNTIL DetailedVendorLedgEntry2.NEXT = 0;
            UNTIL DetailedVendorLedgEntry.NEXT = 0;

        //Si no queda nada pendiente en divisa pero si en DL, creo un movimiento para dejarlo a cero
        IF (endSum = 0) AND (endSumDL <> 0) THEN BEGIN
            CreateAdjustReturnShipmentAccountingNotes(ReturnShipmentLine, endSumDL, Date);
            CreateAdjustReturnShipmentJobJournal(ReturnShipmentLine, endSumDL, Date);
            //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.Begin
            //CreateVendorDetailedLedger(ReturnShipmentLine, -endSumDL, Date, NoMov);
            CreateVendorDetailedLedger(ReturnShipmentLine."Job No.", -endSumDL, Date, NoMov);
            //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.End
        END;

        //JAV 22/10/21: - QB 1.09.22 Restar a la cantidad provisionada de la l�nea
        ReturnShipmentLine."QB Qty Provisioned" -= Quantity;
        ReturnShipmentLine."QB Amount Provisioned" -= endSum;
        ReturnShipmentLine.MODIFY;
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Crear Movimiento detallado de proveedor"();
    BEGIN
    END;

    LOCAL PROCEDURE CreateVendorDetailedLedger(VAR JobNo: Code[20]; AmountLCY: Decimal; Date: Date; NoMov: Integer);
    VAR
        DetailedVendorLedgEntry1: Record 380;
        DetailedVendorLedgEntry2: Record 380;
        NewMov: Integer;
        VendorMov: Integer;
    BEGIN
        //Crear el movimiento detallado de proveedor del ajuste de divisas para cerrar la l�nea del albar�n
        IF JobNo = '' THEN
            EXIT;

        IF (AmountLCY = 0) THEN
            EXIT;

        //Crear un movimiento copiando del que nos pasan por la diferencia de cambio
        DetailedVendorLedgEntry1.RESET;
        IF DetailedVendorLedgEntry1.FINDLAST THEN
            NewMov := DetailedVendorLedgEntry1."Entry No." + 1
        ELSE
            NewMov := 1;

        DetailedVendorLedgEntry1.GET(NoMov);
        VendorMov := DetailedVendorLedgEntry1."Vendor Ledger Entry No.";

        DetailedVendorLedgEntry2 := DetailedVendorLedgEntry1;
        DetailedVendorLedgEntry2."Entry No." := NewMov;         //JMMA 26/10/20 Para que no asigne el mismo n�mero de documento

        IF (AmountLCY >= 0) THEN
            DetailedVendorLedgEntry2."Entry Type" := DetailedVendorLedgEntry2."Entry Type"::"Unrealized Gain"
        ELSE
            DetailedVendorLedgEntry2."Entry Type" := DetailedVendorLedgEntry2."Entry Type"::"Unrealized Loss";

        DetailedVendorLedgEntry2.Amount := 0;
        DetailedVendorLedgEntry2."Debit Amount" := 0;
        DetailedVendorLedgEntry2."Credit Amount" := 0;
        DetailedVendorLedgEntry2."Amount (LCY)" := AmountLCY;
        IF (DetailedVendorLedgEntry2."Amount (LCY)" > 0) THEN BEGIN
            DetailedVendorLedgEntry2."Credit Amount (LCY)" := DetailedVendorLedgEntry2."Amount (LCY)";
            DetailedVendorLedgEntry2."Debit Amount (LCY)" := 0;
        END ELSE BEGIN
            DetailedVendorLedgEntry2."Credit Amount (LCY)" := 0;
            DetailedVendorLedgEntry2."Debit Amount (LCY)" := DetailedVendorLedgEntry2."Amount (LCY)";
        END;
        DetailedVendorLedgEntry2."Excluded from calculation" := TRUE;
        DetailedVendorLedgEntry2.INSERT;
        /*{-------------------- De momento no se pone
              //Ahora liquidamos todos los movimientos pendientes para dejarlos a cero
              DetailedVendorLedgEntry1.reset;
              DetailedVendorLedgEntry1.SETRANGE("2", VendorMov);
              DetailedVendorLedgEntry1.CALCSUMS(Amount, "Amount (LCY)");

              DetailedVendorLedgEntry2."Entry No." += 1;
              DetailedVendorLedgEntry2."Entry Type" := DetailedVendorLedgEntry2."Entry Type"::Application;

              //Cancelar el importe en divisa
              DetailedVendorLedgEntry2.Amount := -DetailedVendorLedgEntry1.Amount;
              IF (DetailedVendorLedgEntry2.Amount > 0) THEN BEGIN
                DetailedVendorLedgEntry2."Credit Amount" := DetailedVendorLedgEntry2."Amount";
                DetailedVendorLedgEntry2."Debit Amount"  := 0;
              END ELSE BEGIN
                DetailedVendorLedgEntry2."Credit Amount"  := 0;
                DetailedVendorLedgEntry2."Debit Amount" := DetailedVendorLedgEntry2."Amount";
              END;
              //Cancelar el importe en DL
              DetailedVendorLedgEntry2."Amount (LCY)" := -DetailedVendorLedgEntry1."Amount (LCY)";
              IF (DetailedVendorLedgEntry2."Amount (LCY)" > 0) THEN BEGIN
                DetailedVendorLedgEntry2."Credit Amount (LCY)" := DetailedVendorLedgEntry2."Amount (LCY)";
                DetailedVendorLedgEntry2."Debit Amount (LCY)"  := 0;
              END ELSE BEGIN
                DetailedVendorLedgEntry2."Credit Amount (LCY)"  := 0;
                DetailedVendorLedgEntry2."Debit Amount (LCY)" := DetailedVendorLedgEntry2."Amount (LCY)";
              END;
              DetailedVendorLedgEntry2.INSERT;
              }*/
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Crear diario del proyecto"();
    BEGIN
    END;

    LOCAL PROCEDURE CreateJobJournal(VAR PurchRcptLine: Record 121; Quantity: Decimal; Date: Date; IsInvoice: Boolean);
    VAR
        JobJournalLine: Record 210;
        PurchaseLine: Record 39;
    BEGIN
        //Crear el diario de proyecto asociado a la l�nea del albar�n
        IF PurchRcptLine."Job No." = '' THEN
            EXIT;

        IF (NOT IsInvoice) AND (PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced" = 0) THEN
            EXIT;

        //JMMA 161020 con esto me aseguro que el valor en divisa de proyecto es correcto, sin esta l�nea
        //el sistema cambiaba a divisa de proyecto con fecha de reversi�n y descuadraba el importe de la divisa del proyecto
        //provisionaba un importe en la divisa del proyecto y desprovisionaba otro importe diferente en la divisa del proyecto.
        IF (Quantity <> 0) THEN
            PurchRcptLine."Unit Cost (LCY)" := GenJournalLine."Amount (LCY)" / Quantity;

        //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n
        JobJournal_Init(JobJournalLine, PurchRcptLine, Date, PurchRcptLine."Direct Unit Cost" * Quantity);

        //Informamos de los precios e importes
        JobJournalLine.VALIDATE(Quantity, Quantity);                                    //Cantidad
        JobJournalLine.VALIDATE("Unit Cost (LCY)", PurchRcptLine."Unit Cost (LCY)");    //Precio de coste en DL, esto pone el precio en la divisa del proyecto y calcula los importes totales
                                                                                        //JMMA 041120
        JobJournalLine."Total Cost (LCY)" := JobJournalLine.Quantity * JobJournalLine."Unit Cost (LCY)";
        //Cierro y registro
        JobJournal_End(JobJournalLine);
    END;

    LOCAL PROCEDURE CreateAdjustJobJournal(VAR PurchRcptLine: Record 121; AmountLCY: Decimal; Date: Date);
    VAR
        JobJournalLine: Record 210;
        PurchLine: Record 39;
    BEGIN
        //Crear el diario de proyecto asociado a un ajuste de divisas para cerrar la l�nea del albar�n
        IF PurchRcptLine."Job No." = '' THEN
            EXIT;

        IF (PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced" <> 0) THEN
            EXIT;

        //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n
        JobJournal_Init(JobJournalLine, PurchRcptLine, Date, 0);

        //Informamos de los precios e importes
        JobJournalLine.VALIDATE(Quantity, 1);                                         //Cantidad siempre ser� 1
        JobJournalLine.VALIDATE("Unit Cost (LCY)", AmountLCY);                        //Precio de coste en DL, esto tambi�n pone el precio e importe en la divisa del proyecto
        JobJournalLine."Unit Cost" := 0;                                              //El precio de coste en divisa debe ser cero
        JobJournalLine."Total Cost" := 0;                                             //El importe en la divisa debe ser cero

        //Cierro y registro
        JobJournal_End(JobJournalLine);
    END;

    LOCAL PROCEDURE CreateAdjustJobJournalDifferences(PurchRcptLine: Record 121; Importe: Decimal; Date: Date);
    VAR
        JobJournalLine: Record 210;
        PurchLine: Record 39;
        DimensionValue: Record 349;
        GeneralLedgerSetup: Record 98;
        GenJournalLine2: Record 81;
    BEGIN
        //Q19430 AML 04/05/23
        //Crear el diario de proyecto asociado a un ajuste por diferencias entre la factura y el albar�n.
        //-Q19877 Correcciones

        IF PurchRcptLine."Job No." = '' THEN
            EXIT;
        //Obtenemos el proyecto desv�o Almacen

        GeneralLedgerSetup.GET;
        IF NOT DimensionValue.GET(GeneralLedgerSetup."Global Dimension 1 Code", PurchRcptLine."Shortcut Dimension 1 Code") THEN EXIT;
        IF DimensionValue."Job Structure Warehouse" = '' THEN EXIT;

        //-Q19877
        //IF (PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced" <> 0) THEN
        //  EXIT;
        //+Q19877

        //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n para descontar del albar�n
        JobJournal_Init_Differences(JobJournalLine, PurchRcptLine, Date, 0, GenJournalLine2, 1000);


        //Informamos de los precios e importes
        JobJournalLine.VALIDATE(Quantity, 1);                                         //Cantidad siempre ser� 1
        JobJournalLine.VALIDATE("Unit Cost", -Importe);                              //Precio de coste en DL, esto tambi�n pone el precio e importe en la divisa del proyecto

        GenJournalLine2.VALIDATE(Quantity, 1);
        GenJournalLine2.VALIDATE(Amount, -Importe);
        GenJournalLine2.MODIFY;
        //Cierro y registro
        JobJournal_End_Differences(JobJournalLine, GenJournalLine2, FALSE);


        PurchRcptLine."Job No." := DimensionValue."Job Structure Warehouse"; //Para que nos haga el diario con el movimiento de estructura.
                                                                             //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n
        JobJournal_Init_Differences(JobJournalLine, PurchRcptLine, Date, 0, GenJournalLine2, 2000);


        //Informamos de los precios e importes
        JobJournalLine.VALIDATE(Quantity, 1);                                         //Cantidad siempre ser� 1
        JobJournalLine.VALIDATE("Unit Cost", Importe);                              //Precio de coste en DL, esto tambi�n pone el precio e importe en la divisa del proyecto

        GenJournalLine.VALIDATE(Quantity, 1);
        GenJournalLine2.VALIDATE(Amount, Importe);
        GenJournalLine2.MODIFY;
        //Cierro y registro
        JobJournal_End_Differences(JobJournalLine, GenJournalLine2, TRUE);
    END;

    LOCAL PROCEDURE JobJournal_Init_Differences(VAR JobJournalLine: Record 210; PurchRcptLine: Record 121; Date: Date; pCurrencyAmount: Decimal; VAR GenJournalLine2: Record 81; Numlin: Integer);
    VAR
        PurchRcptHeader: Record 120;
        SourceCodeSetup: Record 242;
        SrcCode: Code[20];
        PurchaseLine: Record 39;
        Job: Record 167;
        Vendor: Record 23;
        PostedOutputShipmentHeader: Record 7207310;
        DocNo: Code[20];
        InventoryPostingSetup: Record 5813;
        CodAlm: Code[20];
        Item: Record 27;
        GLAccount: Record 15;
        DefaultDimension: Record 352;
        DimensionManagement: Codeunit 408;
        FunctionQB: Codeunit 7207272;
        DimMgt: Codeunit 408;
        GeneralLedgerSetup: Record 98;
        Line: Integer;
        PurchaseHeader: Record 38;
    BEGIN
        //Q19430 AML 04/05/23
        //Crear el diario de proyecto asociado a un ajuste por diferencias entre la factura y el albar�n.
        //-Q19877 Correcciones
        //Crear la l�nea del diario de proyecto asociado a la  del albar�n

        PurchRcptHeader.GET(PurchRcptLine."Document No.");


        PostedOutputShipmentHeader.SETRANGE("Purchase Rcpt. No.", PurchRcptLine."Document No.");
        IF PostedOutputShipmentHeader.FINDFIRST THEN DocNo := PostedOutputShipmentHeader."No." ELSE DocNo := PurchRcptHeader."No.";

        //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n
        JobJournalLine.INIT;
        JobJournalLine.VALIDATE("Posting Date", Date);
        JobJournalLine.VALIDATE(JobJournalLine."Document No.", DocNo);
        // En l�nea de proyectos y en hist�rico l�neas albar�n de compras el orden de las opciones es
        // distinto. me faltaria el caso de "Cargos(prod)" de momento no lo pongo
        CASE PurchRcptLine.Type OF
            PurchRcptLine.Type::Item:
                BEGIN
                    JobJournalLine.VALIDATE(Type, JobJournalLine.Type::Item);
                END;
            PurchRcptLine.Type::"G/L Account":
                BEGIN
                    JobJournalLine.VALIDATE(Type, JobJournalLine.Type::"G/L Account");
                END;

        END;
        JobJournalLine.VALIDATE("Job No.", PurchRcptLine."Job No.");     //Esto pone la divisa del proyecto en el diario
        JobJournalLine.VALIDATE("No.", PurchRcptLine."No.");

        JobJournalLine."Gen. Bus. Posting Group" := PurchRcptLine."Gen. Bus. Posting Group";
        JobJournalLine."Gen. Prod. Posting Group" := PurchRcptLine."Gen. Prod. Posting Group";
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Activation Entry" := TRUE;

        JobJournalLine."Unit of Measure Code" := PurchRcptLine."Unit of Measure Code";
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD(SourceCodeSetup.Purchases);
        SrcCode := SourceCodeSetup.Purchases;
        JobJournalLine."Source Code" := SrcCode;

        JobJournalLine."Piecework Code" := PurchRcptLine."Piecework NÂº";
        JobJournalLine."Job Task No." := PurchRcptLine."Job Task No.";

        JobJournalLine.Description := PurchRcptLine.Description;

        //Dimensiones
        //-Q19430
        //JobJournalLine."Shortcut Dimension 1 Code" := PurchRcptLine."Shortcut Dimension 1 Code";
        //JobJournalLine."Shortcut Dimension 2 Code" := PurchRcptLine."Shortcut Dimension 2 Code";
        //JobJournalLine."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
        IF PurchRcptHeader."Job No." = PurchRcptLine."Job No." THEN BEGIN //Para que coja las dimensiones de ALMACEN en caso de diferencias.
            JobJournalLine."Shortcut Dimension 1 Code" := PurchRcptLine."Shortcut Dimension 1 Code";
            JobJournalLine."Shortcut Dimension 2 Code" := PurchRcptLine."Shortcut Dimension 2 Code";
            JobJournalLine."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
        END
        ELSE BEGIN
            DefaultDimension.SETRANGE("Table ID", 27);
            DefaultDimension.SETRANGE("No.", PurchRcptLine."No.");
            IF DefaultDimension.FINDSET THEN BEGIN
                REPEAT
                    IF DefaultDimension."Dimension Value Code" <> '' THEN BEGIN
                        FunctionQB.UpdateDimSet(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code", JobJournalLine."Dimension Set ID");
                        DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID", JobJournalLine."Shortcut Dimension 1 Code", JobJournalLine."Shortcut Dimension 2 Code");

                    END;
                UNTIL DefaultDimension.NEXT = 0;
            END;
            IF JobJournalLine."Shortcut Dimension 2 Code" = '' THEN JobJournalLine.VALIDATE("Shortcut Dimension 2 Code", PurchRcptLine."Shortcut Dimension 2 Code");
        END;
        //+Q19430

        JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable"; //QMD

        //GAP888
        JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Shipping;
        JobJournalLine.Provision := TRUE;
        JobJournalLine."Source Type" := JobJournalLine."Source Type"::Vendor;
        JobJournalLine."Source No." := PurchRcptLine."Buy-from Vendor No.";

        //JAV 04/07/22: - QB 1.10.48 A�adir en el registro de movimiento del proyecto el nombre del proveedor
        IF Vendor.GET(PurchRcptLine."Buy-from Vendor No.") THEN
            JobJournalLine."Source Name" := Vendor.Name;

        //JMMA 280920 se a�ade la divisa de la transacci�n y el importe en la divisa de la transacci�n, para lo que buscamos el pedido original
        IF PurchaseLine.GET(PurchaseLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.") THEN BEGIN
            PurchRcptHeader.GET(PurchRcptLine."Document No.");
            JobJournalLine."Transaction Currency" := PurchRcptHeader."Currency Code";
            JobJournalLine."Total Cost (TC)" := pCurrencyAmount;
        END;

        //GenJournalLine2.SETRANGE("Journal Template Name" , PurchRcptLine."Document No.");
        //GenJournalLine2.SETRANGE("Journal Batch Name" , PurchRcptLine."Document No.");
        //GenJournalLine2.SETRANGE("Journal Template Name" , PurchaseHeaderDif."No.");
        //GenJournalLine2.SETRANGE("Journal Batch Name" , PurchaseHeaderDif."No.");
        //IF GenJournalLine2.FINDLAST THEN BEGIN
        //  Line := GenJournalLine2."Line No." + 10000
        //END
        //ELSE BEGIN
        //  Line := 10000;
        //END;
        //GenJournalLine2.RESET;
        GenJournalLine2.INIT;
        GenJournalLine2."Journal Template Name" := PurchaseHeaderDif."No.";  //AML Asi no se mezcla en otros diario y lo puedo registrar despu�s.
        GenJournalLine2."Journal Batch Name" := PurchaseHeaderDif."No.";
        GenJournalLine2."Line No." := Numlin;
        GenJournalLine2.VALIDATE("Posting Date", Date);
        GenJournalLine2.VALIDATE("Document No.", DocNo);
        Job.GET(JobJournalLine."Job No.");
        CodAlm := '';
        IF Job."Job Location" = '' THEN CodAlm := JobJournalLine."Job No." ELSE CodAlm := Job."Job Location";
        Item.GET(PurchRcptLine."No.");
        InventoryPostingSetup.GET(CodAlm, Item."Inventory Posting Group");
        GenJournalLine2."Account Type" := GenJournalLine2."Account Type"::"G/L Account";
        GenJournalLine2."Account No." := InventoryPostingSetup."Location Account Consumption";
        GLAccount.GET(InventoryPostingSetup."Location Account Consumption");
        GenJournalLine2.Description := GLAccount.Name;
        GenJournalLine2."Document Type" := GenJournalLine2."Document Type"::" ";
        GenJournalLine2."Currency Factor" := 1;
        GenJournalLine2.Correction := FALSE;


        GenJournalLine2."Shortcut Dimension 1 Code" := JobJournalLine."Shortcut Dimension 1 Code";
        GenJournalLine2."Shortcut Dimension 2 Code" := JobJournalLine."Shortcut Dimension 2 Code";
        GenJournalLine2."Job No." := JobJournalLine."Job No.";
        ;
        GenJournalLine2."Piecework Code" := JobJournalLine."Piecework Code";
        GenJournalLine2."Job Task No." := JobJournalLine."Job Task No.";
        //-AML QB_ST01 A�adidos los campos de control de QB_ST01
        GenJournalLine2."QB Stocks Document Type" := GenJournalLine2."QB Stocks Document Type"::Receipt;
        GenJournalLine2."QB Stocks Document No" := DocNo;
        GenJournalLine2."QB Stocks Output Shipment Line" := PurchRcptLine."Line No.";
        GenJournalLine2."QB Stocks Output Shipment No." := PurchRcptLine."Document No.";
        GenJournalLine2."QB Stocks Item No." := PurchRcptLine."No.";
        GenJournalLine2."Dimension Set ID" := JobJournalLine."Dimension Set ID";
        //+AML QB_ST01 A�adidos los campos de control de QB_ST01
        GenJournalLine2.INSERT;
    END;

    LOCAL PROCEDURE JobJournal_End_Differences(VAR JobJournalLine: Record 210; VAR GenJournalLine2: Record 81; Reg2: Boolean);
    VAR
        JobJnlPostLine: Codeunit 1012;
        GenJnlPostLine2: Codeunit 12;
    BEGIN
        //-Q19877 Aqui registraremos las diferencias en proyectos, en conta no deja
        //Cierra la l�nea y registra el diario de proyecto asociado a la l�nea del albar�n
        /////////AMLXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXJobJnlPostLine.RunWithCheck(JobJournalLine);
        //GenJnlPostLine.RunWithCheck(GenJournalLine2);
        CLEAR(GenJnlPostLine2);
        IF Reg2 THEN BEGIN
            GenJournalLine2.SETRANGE("Journal Template Name", PurchaseHeaderDif."No.");
            IF GenJournalLine2.FINDFIRST THEN
                REPEAT
                    GenJnlPostLine2.RunWithCheck(GenJournalLine2);
                UNTIL GenJournalLine2.NEXT = 0;
        END;
    END;

    PROCEDURE Invoice_Dif(PurchaseHeader: Record 38);
    BEGIN
        //AML 19877 Para pasr el registro de factura y poder registrar las diferencias si las hay, porque en JobJournal_End_Differences da un error de consistencia
        // (Debe haber alguna transaccion a medias y no le gusta)
        PurchaseHeaderDif := PurchaseHeader;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE cdu90_OnAfterPostPurchaseDoc(VAR PurchaseHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean);
    VAR
        GenJournalLine2: Record 81;
        GenJnlPostLine2: Codeunit 12;
    BEGIN
        //-Q19877 Aqui registraremos las diferencias en contabilidad
        EXIT;
        IF PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Invoice THEN EXIT;

        GenJournalLine2.SETRANGE("Journal Template Name", PurchaseHeader."No.");
        GenJournalLine2.SETRANGE("Journal Batch Name", PurchaseHeader."No.");
        IF GenJournalLine2.FINDFIRST THEN
            GenJnlPostLine2.RunWithCheck(GenJournalLine2);
    END;

    LOCAL PROCEDURE JobJournal_Init(VAR JobJournalLine: Record 210; PurchRcptLine: Record 121; Date: Date; pCurrencyAmount: Decimal);
    VAR
        PurchRcptHeader: Record 120;
        SourceCodeSetup: Record 242;
        SrcCode: Code[20];
        PurchaseLine: Record 39;
        Job: Record 167;
        Vendor: Record 23;
    BEGIN
        //Crear la l�nea del diario de proyecto asociado a la  del albar�n


        PurchRcptHeader.GET(PurchRcptLine."Document No.");

        //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n
        JobJournalLine.INIT;
        JobJournalLine.VALIDATE("Posting Date", Date);
        JobJournalLine.VALIDATE(JobJournalLine."Document No.", PurchRcptLine."Document No.");
        // En l�nea de proyectos y en hist�rico l�neas albar�n de compras el orden de las opciones es
        // distinto. me faltaria el caso de "Cargos(prod)" de momento no lo pongo
        CASE PurchRcptLine.Type OF
            PurchRcptLine.Type::Item:
                BEGIN
                    JobJournalLine.VALIDATE(Type, JobJournalLine.Type::Item);
                END;
            PurchRcptLine.Type::"G/L Account":
                BEGIN
                    JobJournalLine.VALIDATE(Type, JobJournalLine.Type::"G/L Account");
                END;

        END;
        JobJournalLine.VALIDATE("Job No.", PurchRcptLine."Job No.");     //Esto pone la divisa del proyecto en el diario
        JobJournalLine.VALIDATE("No.", PurchRcptLine."No.");

        JobJournalLine."Gen. Bus. Posting Group" := PurchRcptLine."Gen. Bus. Posting Group";
        JobJournalLine."Gen. Prod. Posting Group" := PurchRcptLine."Gen. Prod. Posting Group";
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Activation Entry" := TRUE;

        JobJournalLine."Unit of Measure Code" := PurchRcptLine."Unit of Measure Code";
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD(SourceCodeSetup.Purchases);
        SrcCode := SourceCodeSetup.Purchases;
        JobJournalLine."Source Code" := SrcCode;

        JobJournalLine."Piecework Code" := PurchRcptLine."Piecework NÂº";
        JobJournalLine."Job Task No." := PurchRcptLine."Job Task No.";

        JobJournalLine.Description := PurchRcptLine.Description;

        //Dimensiones
        //-Q19430
        //JobJournalLine."Shortcut Dimension 1 Code" := PurchRcptLine."Shortcut Dimension 1 Code";
        //JobJournalLine."Shortcut Dimension 2 Code" := PurchRcptLine."Shortcut Dimension 2 Code";
        //JobJournalLine."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
        //-20265
        IF PurchRcptHeader."Job No." = PurchRcptLine."Job No." THEN BEGIN //Para que coja las dimensiones de ALMACEN en caso de diferencias.
            JobJournalLine."Shortcut Dimension 1 Code" := PurchRcptLine."Shortcut Dimension 1 Code";
            JobJournalLine."Shortcut Dimension 2 Code" := PurchRcptLine."Shortcut Dimension 2 Code";
            JobJournalLine."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
        END;
        //+Q20265
        //+Q19430

        JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable"; //QMD

        //GAP888
        JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Shipping;
        JobJournalLine.Provision := TRUE;
        JobJournalLine."Source Type" := JobJournalLine."Source Type"::Vendor;
        JobJournalLine."Source No." := PurchRcptLine."Buy-from Vendor No.";

        //JAV 04/07/22: - QB 1.10.48 A�adir en el registro de movimiento del proyecto el nombre del proveedor
        IF Vendor.GET(PurchRcptLine."Buy-from Vendor No.") THEN
            JobJournalLine."Source Name" := Vendor.Name;

        //JMMA 280920 se a�ade la divisa de la transacci�n y el importe en la divisa de la transacci�n, para lo que buscamos el pedido original
        IF PurchaseLine.GET(PurchaseLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.") THEN BEGIN
            PurchRcptHeader.GET(PurchRcptLine."Document No.");
            JobJournalLine."Transaction Currency" := PurchRcptHeader."Currency Code";
            JobJournalLine."Total Cost (TC)" := pCurrencyAmount;
        END;
    END;

    LOCAL PROCEDURE JobJournal_End(VAR JobJournalLine: Record 210);
    VAR
        JobJnlPostLine: Codeunit 1012;
    BEGIN
        //Cierra la l�nea y registra el diario de proyecto asociado a la l�nea del albar�n
        JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    PROCEDURE JobJournalExchangesDif(VAR DetailedVendorLedgEntry: Record 380; pDocNo: Code[20]; QuantityToAdjust: Decimal; pAccount: Code[20]);
    VAR
        Currency: Record 4;
        JobJournalLine: Record 210;
        SourceCodeSetup: Record 242;
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
        Vendor: Record 23;
    BEGIN
        //Genera movimientos de proyecto de una l�nea de ajustes por diferencias de cambio en el pago
        DetailedVendorLedgEntry.CALCFIELDS("QB Job No.");
        IF DetailedVendorLedgEntry."QB Job No." = '' THEN
            EXIT;

        Job.GET(DetailedVendorLedgEntry."QB Job No.");
        IF (Job."Adjust Exchange Rate Piecework" = '') THEN
            ERROR('No ha indicado la U.O. para ajustes de divisas en el proyecto %1', Job."No.");
        IF (Job."Adjust Exchange Rate A.C." = '') THEN
            ERROR('No ha indicado Concepto Anal�tico para ajustes de divisas en el proyecto %1', Job."No.");

        //Si no existe la U.O. la creo como unidad de indirectos
        IF NOT DataPieceworkForProduction.GET(Job."No.", Job."Adjust Exchange Rate Piecework") THEN BEGIN
            DataPieceworkForProduction.INIT;
            DataPieceworkForProduction."Job No." := Job."No.";
            DataPieceworkForProduction."Piecework Code" := Job."Adjust Exchange Rate Piecework";
            DataPieceworkForProduction."Account Type" := DataPieceworkForProduction."Account Type"::Unit;
            DataPieceworkForProduction.Description := 'Ajustes por diferencias de cambio en el proyecto';
            DataPieceworkForProduction.Type := DataPieceworkForProduction.Type::"Cost Unit";
            DataPieceworkForProduction."Production Unit" := TRUE;
            DataPieceworkForProduction.INSERT(TRUE);
        END;

        //Crear una l�nea del diario de proyecto asociado a la l�nea
        JobJournalLine.INIT;
        JobJournalLine.VALIDATE("Posting Date", DetailedVendorLedgEntry."Posting Date");
        JobJournalLine.VALIDATE("Document No.", pDocNo);
        JobJournalLine.VALIDATE("Job No.", DetailedVendorLedgEntry."QB Job No.");     //Esto pone la divisa del proyecto en el diario

        JobJournalLine.VALIDATE(Type, JobJournalLine.Type::"G/L Account");
        JobJournalLine.VALIDATE("No.", pAccount);

        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Activation Entry" := TRUE;

        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD(SourceCodeSetup."Exchange Rate Adjmt.");
        JobJournalLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";

        JobJournalLine."Piecework Code" := Job."Adjust Exchange Rate Piecework";
        JobJournalLine.Description := 'Ajuste de divisas en el pago';

        //Dimensiones
        JobJournalLine.VALIDATE("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
        //JobJournalLine.VALIDATE("Shortcut Dimension 2 Code", Job."Global Dimension 2 Code");
        JobJournalLine.VALIDATE("Shortcut Dimension 2 Code", Job."Adjust Exchange Rate A.C.");


        JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable"; //QMD

        //GAP888
        JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Shipping;
        JobJournalLine.Provision := FALSE;
        JobJournalLine."Source Type" := JobJournalLine."Source Type"::Vendor;
        JobJournalLine."Source No." := DetailedVendorLedgEntry."Vendor No.";

        //JAV 04/07/22: - QB 1.10.48 A�adir en el registro de movimiento del proyecto el nombre del proveedor
        IF Vendor.GET(DetailedVendorLedgEntry."Vendor No.") THEN
            JobJournalLine."Source Name" := Vendor.Name;

        //JMMA 280920 se a�ade la divisa de la transacci�n y el importe en la divisa de la transacci�n, para lo que buscamos el pedido original
        JobJournalLine."Transaction Currency" := DetailedVendorLedgEntry."Currency Code";
        JobJournalLine."Total Cost (TC)" := QuantityToAdjust;

        //Informamos de los precios e importes
        JobJournalLine.VALIDATE(Quantity, 1);                                         //Cantidad siempre ser� 1
        JobJournalLine.VALIDATE("Unit Cost (LCY)", QuantityToAdjust);                 //Precio de coste en DL, esto tambi�n pone el precio e importe en la divisa del proyecto
        JobJournalLine."Unit Cost" := 0;                                              //El precio de coste en divisa debe ser cero
        JobJournalLine."Total Cost" := 0;                                             //El importe en la divisa debe ser cero

        //Cierro y registro
        JobJournal_End(JobJournalLine);
    END;

    LOCAL PROCEDURE CreateReturnShipmentJobJournal(VAR ReturnShipmentLine: Record 6651; Quantity: Decimal; Date: Date; IsInvoice: Boolean);
    VAR
        JobJournalLine: Record 210;
        PurchaseLine: Record 39;
    BEGIN
        //Crear el diario de proyecto asociado a la l�nea del albar�n
        IF ReturnShipmentLine."Job No." = '' THEN
            EXIT;

        IF (NOT IsInvoice) AND (ReturnShipmentLine.Quantity - ReturnShipmentLine."Quantity Invoiced" = 0) THEN
            EXIT;

        //JMMA 161020 con esto me aseguro que el valor en divisa de proyecto es correcto, sin esta l�nea
        //el sistema cambiaba a divisa de proyecto con fecha de reversi�n y descuadraba el importe de la divisa del proyecto
        //provisionaba un importe en la divisa del proyecto y desprovisionaba otro importe diferente en la divisa del proyecto.
        IF (Quantity <> 0) THEN
            ReturnShipmentLine."Unit Cost (LCY)" := GenJournalLine."Amount (LCY)" / Quantity;

        //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n
        ReturnShipmentJobJournal_Init(JobJournalLine, ReturnShipmentLine, Date, ReturnShipmentLine."Direct Unit Cost" * Quantity);

        //Informamos de los precios e importes
        JobJournalLine.VALIDATE(Quantity, Quantity);                                    //Cantidad
        JobJournalLine.VALIDATE("Unit Cost (LCY)", ReturnShipmentLine."Unit Cost (LCY)");    //Precio de coste en DL, esto pone el precio en la divisa del proyecto y calcula los importes totales
                                                                                             //JMMA 041120
        JobJournalLine."Total Cost (LCY)" := JobJournalLine.Quantity * JobJournalLine."Unit Cost (LCY)";
        //Cierro y registro
        JobJournal_End(JobJournalLine);
    END;

    LOCAL PROCEDURE CreateAdjustReturnShipmentJobJournal(VAR ReturnShipmentLine: Record 6651; AmountLCY: Decimal; Date: Date);
    VAR
        JobJournalLine: Record 210;
        PurchLine: Record 39;
    BEGIN
        //Crear el diario de proyecto asociado a un ajuste de divisas para cerrar la l�nea del albar�n
        IF ReturnShipmentLine."Job No." = '' THEN
            EXIT;

        IF (ReturnShipmentLine.Quantity - ReturnShipmentLine."Quantity Invoiced" <> 0) THEN
            EXIT;

        //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n
        ReturnShipmentJobJournal_Init(JobJournalLine, ReturnShipmentLine, Date, 0);

        //Informamos de los precios e importes
        JobJournalLine.VALIDATE(Quantity, 1);                                         //Cantidad siempre ser� 1
        JobJournalLine.VALIDATE("Unit Cost (LCY)", AmountLCY);                        //Precio de coste en DL, esto tambi�n pone el precio e importe en la divisa del proyecto
        JobJournalLine."Unit Cost" := 0;                                              //El precio de coste en divisa debe ser cero
        JobJournalLine."Total Cost" := 0;                                             //El importe en la divisa debe ser cero

        //Cierro y registro
        JobJournal_End(JobJournalLine);
    END;

    LOCAL PROCEDURE CreateAdjustReturnShipmentJobJournalDifferences(PurchRcptLine: Record 6651; Importe: Decimal; Date: Date);
    VAR
        JobJournalLine: Record 210;
        PurchLine: Record 39;
        DimensionValue: Record 349;
        GeneralLedgerSetup: Record 98;
        GenJournalLine2: Record 81;
    BEGIN
        //-Q20364 Funci�n a�adida Para abonos
        //-Q20364 Ojo PurchRcptLine es 6651 no 121
        IF PurchRcptLine."Job No." = '' THEN
            EXIT;
        //Obtenemos el proyecto desv�o Almacen

        GeneralLedgerSetup.GET;
        IF NOT DimensionValue.GET(GeneralLedgerSetup."Global Dimension 1 Code", PurchRcptLine."Shortcut Dimension 1 Code") THEN EXIT;
        IF DimensionValue."Job Structure Warehouse" = '' THEN EXIT;


        //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n para descontar del albar�n
        ReturnShipmentJobJournal_Init_Differences(JobJournalLine, PurchRcptLine, Date, 0, GenJournalLine2, 1000);


        //Informamos de los precios e importes
        JobJournalLine.VALIDATE(Quantity, 1);                                         //Cantidad siempre ser� 1
        JobJournalLine.VALIDATE("Unit Cost", -Importe);                              //Precio de coste en DL, esto tambi�n pone el precio e importe en la divisa del proyecto

        GenJournalLine2.VALIDATE(Quantity, 1);
        GenJournalLine2.VALIDATE(Amount, -Importe);
        GenJournalLine2.MODIFY;
        //Cierro y registro
        JobJournal_End_Differences(JobJournalLine, GenJournalLine2, FALSE);


        PurchRcptLine."Job No." := DimensionValue."Job Structure Warehouse"; //Para que nos haga el diario con el movimiento de estructura.
                                                                             //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n
        ReturnShipmentJobJournal_Init_Differences(JobJournalLine, PurchRcptLine, Date, 0, GenJournalLine2, 2000);


        //Informamos de los precios e importes
        JobJournalLine.VALIDATE(Quantity, 1);                                         //Cantidad siempre ser� 1
        JobJournalLine.VALIDATE("Unit Cost", Importe);                              //Precio de coste en DL, esto tambi�n pone el precio e importe en la divisa del proyecto

        GenJournalLine.VALIDATE(Quantity, 1);
        GenJournalLine2.VALIDATE(Amount, Importe);
        GenJournalLine2.MODIFY;
        //Cierro y registro
        JobJournal_End_Differences(JobJournalLine, GenJournalLine2, TRUE);
    END;

    LOCAL PROCEDURE ReturnShipmentJobJournal_Init(VAR JobJournalLine: Record 210; ReturnShipmentLine: Record 6651; Date: Date; pCurrencyAmount: Decimal);
    VAR
        ReturnShipmentHeader: Record 6650;
        SourceCodeSetup: Record 242;
        SrcCode: Code[20];
        PurchaseLine: Record 39;
        Job: Record 167;
        Vendor: Record 23;
    BEGIN
        //Crear la l�nea del diario de proyecto asociado a la l�nea del albar�n

        ReturnShipmentHeader.GET(ReturnShipmentLine."Document No.");

        //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n
        JobJournalLine.INIT;
        JobJournalLine.VALIDATE("Posting Date", Date);
        JobJournalLine.VALIDATE(JobJournalLine."Document No.", ReturnShipmentLine."Document No.");
        // En l�nea de proyectos y en hist�rico l�neas albar�n de compras el orden de las opciones es
        // distinto. me faltaria el caso de "Cargos(prod)" de momento no lo pongo
        CASE ReturnShipmentLine.Type OF
            ReturnShipmentLine.Type::Item:
                BEGIN
                    JobJournalLine.VALIDATE(Type, JobJournalLine.Type::Item);
                END;
            ReturnShipmentLine.Type::"G/L Account":
                BEGIN
                    JobJournalLine.VALIDATE(Type, JobJournalLine.Type::"G/L Account");
                END;

        END;
        JobJournalLine.VALIDATE("Job No.", ReturnShipmentLine."Job No.");     //Esto pone la divisa del proyecto en el diario
        JobJournalLine.VALIDATE("No.", ReturnShipmentLine."No.");

        JobJournalLine."Gen. Bus. Posting Group" := ReturnShipmentLine."Gen. Bus. Posting Group";
        JobJournalLine."Gen. Prod. Posting Group" := ReturnShipmentLine."Gen. Prod. Posting Group";
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Activation Entry" := TRUE;

        JobJournalLine."Unit of Measure Code" := ReturnShipmentLine."Unit of Measure Code";
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD(SourceCodeSetup.Purchases);
        SrcCode := SourceCodeSetup.Purchases;
        JobJournalLine."Source Code" := SrcCode;

        JobJournalLine."Piecework Code" := ReturnShipmentLine."Piecework NÂº";
        JobJournalLine."Job Task No." := ReturnShipmentLine."Job Task No.";

        JobJournalLine.Description := ReturnShipmentLine.Description;

        //Dimensiones
        JobJournalLine."Shortcut Dimension 1 Code" := ReturnShipmentLine."Shortcut Dimension 1 Code";
        JobJournalLine."Shortcut Dimension 2 Code" := ReturnShipmentLine."Shortcut Dimension 2 Code";
        JobJournalLine."Dimension Set ID" := ReturnShipmentLine."Dimension Set ID";

        JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable"; //QMD

        //GAP888
        JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Shipping;
        JobJournalLine.Provision := TRUE;
        JobJournalLine."Source Type" := JobJournalLine."Source Type"::Vendor;
        JobJournalLine."Source No." := ReturnShipmentLine."Buy-from Vendor No.";

        //JAV 04/07/22: - QB 1.10.48 A�adir en el registro de movimiento del proyecto el nombre del proveedor
        IF Vendor.GET(ReturnShipmentLine."Buy-from Vendor No.") THEN
            JobJournalLine."Source Name" := Vendor.Name;

        //JMMA 280920 se a�ade la divisa de la transacci�n y el importe en la divisa de la transacci�n, para lo que buscamos el pedido original
        IF PurchaseLine.GET(PurchaseLine."Document Type"::Order, ReturnShipmentLine."Return Order No.", ReturnShipmentLine."Return Order Line No.") THEN BEGIN
            ReturnShipmentHeader.GET(ReturnShipmentLine."Document No.");
            JobJournalLine."Transaction Currency" := ReturnShipmentHeader."Currency Code";
            JobJournalLine."Total Cost (TC)" := pCurrencyAmount;
        END;
    END;

    LOCAL PROCEDURE ReturnShipmentJobJournal_End(VAR JobJournalLine: Record 210);
    VAR
        JobJnlPostLine: Codeunit 1012;
    BEGIN
        //Cierra la l�nea y registra el diario de proyecto asociado a la l�nea del albar�n
        JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    LOCAL PROCEDURE ReturnShipmentJobJournal_Init_Differences(VAR JobJournalLine: Record 210; PurchRcptLine: Record 6651; Date: Date; pCurrencyAmount: Decimal; VAR GenJournalLine2: Record 81; Numlin: Integer);
    VAR
        PurchRcptHeader: Record 6650;
        SourceCodeSetup: Record 242;
        SrcCode: Code[20];
        PurchaseLine: Record 39;
        Job: Record 167;
        Vendor: Record 23;
        PostedOutputShipmentHeader: Record 7207310;
        DocNo: Code[20];
        InventoryPostingSetup: Record 5813;
        CodAlm: Code[20];
        Item: Record 27;
        GLAccount: Record 15;
        DefaultDimension: Record 352;
        DimensionManagement: Codeunit 408;
        FunctionQB: Codeunit 7207272;
        DimMgt: Codeunit 408;
        GeneralLedgerSetup: Record 98;
        Line: Integer;
        PurchaseHeader: Record 38;
    BEGIN
        //-Q20364 Funci�n a�adida Para abonos
        //Crear el diario de proyecto asociado a un ajuste por diferencias entre la factura y el albar�n.
        //Crear la l�nea del diario de proyecto asociado a la  del albar�n

        PurchRcptHeader.GET(PurchRcptLine."Document No.");


        PostedOutputShipmentHeader.SETRANGE("Purchase Rcpt. No.", PurchRcptLine."Document No.");
        IF PostedOutputShipmentHeader.FINDFIRST THEN DocNo := PostedOutputShipmentHeader."No." ELSE DocNo := PurchRcptHeader."No.";

        //Crear una l�nea del diario de proyecto asociado a la l�nea del albar�n
        JobJournalLine.INIT;
        JobJournalLine.VALIDATE("Posting Date", Date);
        JobJournalLine.VALIDATE(JobJournalLine."Document No.", DocNo);
        // En l�nea de proyectos y en hist�rico l�neas albar�n de compras el orden de las opciones es
        // distinto. me faltaria el caso de "Cargos(prod)" de momento no lo pongo
        CASE PurchRcptLine.Type OF
            PurchRcptLine.Type::Item:
                BEGIN
                    JobJournalLine.VALIDATE(Type, JobJournalLine.Type::Item);
                END;
            PurchRcptLine.Type::"G/L Account":
                BEGIN
                    JobJournalLine.VALIDATE(Type, JobJournalLine.Type::"G/L Account");
                END;

        END;
        JobJournalLine.VALIDATE("Job No.", PurchRcptLine."Job No.");     //Esto pone la divisa del proyecto en el diario
        JobJournalLine.VALIDATE("No.", PurchRcptLine."No.");

        JobJournalLine."Gen. Bus. Posting Group" := PurchRcptLine."Gen. Bus. Posting Group";
        JobJournalLine."Gen. Prod. Posting Group" := PurchRcptLine."Gen. Prod. Posting Group";
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Activation Entry" := TRUE;

        JobJournalLine."Unit of Measure Code" := PurchRcptLine."Unit of Measure Code";
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD(SourceCodeSetup.Purchases);
        SrcCode := SourceCodeSetup.Purchases;
        JobJournalLine."Source Code" := SrcCode;

        JobJournalLine."Piecework Code" := PurchRcptLine."Piecework NÂº";
        JobJournalLine."Job Task No." := PurchRcptLine."Job Task No.";

        JobJournalLine.Description := PurchRcptLine.Description;

        //Dimensiones
        IF PurchRcptHeader."Job No." = PurchRcptLine."Job No." THEN BEGIN //Para que coja las dimensiones de ALMACEN en caso de diferencias.
            JobJournalLine."Shortcut Dimension 1 Code" := PurchRcptLine."Shortcut Dimension 1 Code";
            JobJournalLine."Shortcut Dimension 2 Code" := PurchRcptLine."Shortcut Dimension 2 Code";
            JobJournalLine."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
        END
        ELSE BEGIN
            DefaultDimension.SETRANGE("Table ID", 27);
            DefaultDimension.SETRANGE("No.", PurchRcptLine."No.");
            IF DefaultDimension.FINDSET THEN BEGIN
                REPEAT
                    IF DefaultDimension."Dimension Value Code" <> '' THEN BEGIN
                        FunctionQB.UpdateDimSet(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code", JobJournalLine."Dimension Set ID");
                        DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID", JobJournalLine."Shortcut Dimension 1 Code", JobJournalLine."Shortcut Dimension 2 Code");

                    END;
                UNTIL DefaultDimension.NEXT = 0;
            END;
            IF JobJournalLine."Shortcut Dimension 2 Code" = '' THEN JobJournalLine.VALIDATE("Shortcut Dimension 2 Code", PurchRcptLine."Shortcut Dimension 2 Code");
        END;

        JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable"; //QMD

        //GAP888
        JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Shipping;
        JobJournalLine.Provision := TRUE;
        JobJournalLine."Source Type" := JobJournalLine."Source Type"::Vendor;
        JobJournalLine."Source No." := PurchRcptLine."Buy-from Vendor No.";

        //JAV 04/07/22: - QB 1.10.48 A�adir en el registro de movimiento del proyecto el nombre del proveedor
        IF Vendor.GET(PurchRcptLine."Buy-from Vendor No.") THEN
            JobJournalLine."Source Name" := Vendor.Name;

        //JMMA 280920 se a�ade la divisa de la transacci�n y el importe en la divisa de la transacci�n, para lo que buscamos el pedido original
        IF PurchaseLine.GET(PurchaseLine."Document Type"::Order, PurchRcptLine."Return Order No.", PurchRcptLine."Return Order Line No.") THEN BEGIN
            PurchRcptHeader.GET(PurchRcptLine."Document No.");
            JobJournalLine."Transaction Currency" := PurchRcptHeader."Currency Code";
            JobJournalLine."Total Cost (TC)" := pCurrencyAmount;
        END;

        GenJournalLine2.INIT;
        GenJournalLine2."Journal Template Name" := PurchaseHeaderDif."No.";  //AML Asi no se mezcla en otros diario y lo puedo registrar despu�s.
        GenJournalLine2."Journal Batch Name" := PurchaseHeaderDif."No.";
        GenJournalLine2."Line No." := Numlin;
        GenJournalLine2.VALIDATE("Posting Date", Date);
        GenJournalLine2.VALIDATE("Document No.", DocNo);
        Job.GET(JobJournalLine."Job No.");
        CodAlm := '';
        IF Job."Job Location" = '' THEN CodAlm := JobJournalLine."Job No." ELSE CodAlm := Job."Job Location";
        Item.GET(PurchRcptLine."No.");
        InventoryPostingSetup.GET(CodAlm, Item."Inventory Posting Group");
        GenJournalLine2."Account Type" := GenJournalLine2."Account Type"::"G/L Account";
        GenJournalLine2."Account No." := InventoryPostingSetup."Location Account Consumption";
        GLAccount.GET(InventoryPostingSetup."Location Account Consumption");
        GenJournalLine2.Description := GLAccount.Name;
        GenJournalLine2."Document Type" := GenJournalLine2."Document Type"::" ";
        GenJournalLine2."Currency Factor" := 1;
        GenJournalLine2.Correction := FALSE;


        GenJournalLine2."Shortcut Dimension 1 Code" := JobJournalLine."Shortcut Dimension 1 Code";
        GenJournalLine2."Shortcut Dimension 2 Code" := JobJournalLine."Shortcut Dimension 2 Code";
        GenJournalLine2."Job No." := JobJournalLine."Job No.";
        ;
        GenJournalLine2."Piecework Code" := JobJournalLine."Piecework Code";
        GenJournalLine2."Job Task No." := JobJournalLine."Job Task No.";
        //-AML QB_ST01 A�adidos los campos de control de QB_ST01
        GenJournalLine2."QB Stocks Document Type" := GenJournalLine2."QB Stocks Document Type"::Receipt;
        GenJournalLine2."QB Stocks Document No" := DocNo;
        GenJournalLine2."QB Stocks Output Shipment Line" := PurchRcptLine."Line No.";
        GenJournalLine2."QB Stocks Output Shipment No." := PurchRcptLine."Document No.";
        GenJournalLine2."QB Stocks Item No." := PurchRcptLine."No.";
        GenJournalLine2."Dimension Set ID" := JobJournalLine."Dimension Set ID";
        //+AML QB_ST01 A�adidos los campos de control de QB_ST01
        GenJournalLine2.INSERT;
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Crear diario contable compras"();
    BEGIN
    END;

    LOCAL PROCEDURE CreateAccountingNotes(Amount: Decimal; Date: Date; VAR PurchRcptLine: Record 121; pCancel: Boolean);
    VAR
        Job: Record 167;
        GeneralPostingSetup: Record 252;
        Vendor: Record 23;
        VendorPostingGroup: Record 93;
        VendorLedgerEntry: Record 25;
        PurchRcptHeader: Record 120;
    BEGIN
        //Crear las l�neas del diario contable para registrar el albar�n.   JAV 08/10/20: - QB 1.06.20 Se indica si es la provisi�n o la cancelaci�n

        Job.RESET;
        Job.GET(PurchRcptLine."Job No.");
        IF PurchRcptLine.Type.AsInteger() > PurchRcptLine.Type::"G/L Account".AsInteger() THEN BEGIN
            GeneralPostingSetup.GET(PurchRcptLine."Gen. Bus. Posting Group", PurchRcptLine."Gen. Prod. Posting Group");
            GeneralPostingSetup.TESTFIELD("Purch. Account");
        END ELSE BEGIN
            IF PurchRcptLine.Type = PurchRcptLine.Type::"G/L Account" THEN
                GeneralPostingSetup."Purch. Account" := PurchRcptLine."No.";
        END;
        Vendor.GET(PurchRcptLine."Buy-from Vendor No.");
        VendorPostingGroup.GET(Vendor."Vendor Posting Group");
        VendorPostingGroup.TESTFIELD(VendorPostingGroup."Acct. Purch. Rcpt Pending Inv.");

        //Leer la cabecera
        PurchRcptHeader.GET(PurchRcptLine."Document No.");

        //Crear las l�neas
        CLEAR(GenJournalLine);
        AccountingNote_Forecast(Amount, Date, VendorPostingGroup."Acct. Purch. Rcpt Pending Inv.", PurchRcptLine, PurchRcptHeader."Currency Code", pCancel);
        AccountingNote_Expense(Amount, Date, GeneralPostingSetup."Purch. Account", PurchRcptLine, PurchRcptHeader."Currency Code", pCancel);

        //Poner el proyecto en el movimiento del proveedor
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETCURRENTKEY("Document No.");
        VendorLedgerEntry.SETRANGE("Document No.", PurchRcptLine."Document No.");
        VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Shipment);
        VendorLedgerEntry.MODIFYALL("QB Job No.", Job."No.");
    END;

    LOCAL PROCEDURE AccountingNote_Forecast(Amount: Decimal; Date: Date; Account: Code[20]; PurchRcptLine: Record 121; pCurrency: Code[20]; pCancel: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        GeneralLedgerSetup: Record 98;
        FunctionQB: Codeunit 7207272;
        DimensionManagement: Codeunit 408;
    BEGIN
        //General el apunte al proveedor o a la cuenta de albaranes pendientes de recibir factura. Retorna el importe en DL por si el movimiento es en divisas

        //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.Begin
        //AccountingNote_Init(Date,PurchRcptLine, pCancel);    //Inicializar el apunte
        AccountingNote_Init(Date, PurchRcptLine."Document No.", pCancel, PurchRcptLine."Gen. Bus. Posting Group", PurchRcptLine."Gen. Prod. Posting Group");    //Inicializar el apunte
                                                                                                                                                                //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.Begin

        //JAV 08/10/20: - Tipo de documento y cuenta, ser� Albar�n y Proveedor en divisa si as� est� configurado, si no ser� en blanco y cuenta en DL
        QuoBuildingSetup.GET;
        IF (QuoBuildingSetup."Use Shipment type in Vendor") THEN BEGIN
            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Vendor);
            GenJournalLine.VALIDATE("Account No.", PurchRcptLine."Buy-from Vendor No.");
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Shipment);
            GenJournalLine.VALIDATE("Shipment Line No", PurchRcptLine."Line No.");  //JAV 21/10/20: - QB 1.06.21 A�adimos la l�nea del albar�n
        END ELSE BEGIN
            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
            GenJournalLine.VALIDATE("Account No.", Account);
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::" ");
            GenJournalLine.VALIDATE("Shipment Line No", 0);
        END;

        //JAV 31/05/22: - QB 1.10.46 Se cambia de lugar el poner la descripci�n de la l�nea para que lo haga correctamente
        IF (NOT pCancel) THEN
            GenJournalLine.Description := 'Provisi�n albar�n ' + PurchRcptLine."Document No."
        ELSE
            GenJournalLine.Description := 'Cancelar provisi�n albar�n ' + PurchRcptLine."Document No.";

        //JAV 10/10/20 se a�ade la divisa del albar�n, que usar� el cambio oficial del d�a de registro
        GenJournalLine.VALIDATE("Currency Code", pCurrency);
        GenJournalLine.VALIDATE(Amount, -Amount);                                                  // El importe es negativo

        AccountingNote_End(PurchRcptLine."Job No.", PurchRcptLine."Job Task No.", PurchRcptLine."Piecework NÂº", PurchRcptLine."Shortcut Dimension 1 Code", PurchRcptLine."Shortcut Dimension 2 Code", PurchRcptLine."Dimension Set ID");  //Cerrar el apunte
    END;

    LOCAL PROCEDURE AccountingNote_Expense(Amount: Decimal; Date: Date; Account: Code[20]; PurchRcptLine: Record 121; pCurrency: Code[20]; pCancel: Boolean);
    BEGIN
        //Generar el apunte al gasto
        //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.Begin
        //AccountingNote_Init(Date,PurchRcptLine, pCancel);    //Inicializar el apunte
        AccountingNote_Init(Date, PurchRcptLine."Document No.", pCancel, PurchRcptLine."Gen. Bus. Posting Group", PurchRcptLine."Gen. Prod. Posting Group");    //Inicializar el apunte
                                                                                                                                                                //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.Begin


        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.VALIDATE("Account No.", Account);
        GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::" ");

        //JAV 31/05/22: - QB 1.10.46 Se cambia de lugar el poner la descripci�n de la l�nea para que lo haga correctamente
        IF (NOT pCancel) THEN
            GenJournalLine.Description := 'Provisi�n albar�n ' + PurchRcptLine."Document No."
        ELSE
            GenJournalLine.Description := 'Cancelar provisi�n albar�n ' + PurchRcptLine."Document No.";

        //JAV 10/10/20 se a�ade la divisa del albar�n, con el cambio oficial del d�a de registro
        GenJournalLine.VALIDATE("Currency Code", pCurrency);

        GenJournalLine.VALIDATE(Amount, Amount);                                             // el importe es positivo

        GenJournalLine."Piecework Code" := PurchRcptLine."Piecework NÂº";
        GenJournalLine."Job Task No." := PurchRcptLine."Job Task No.";
        AccountingNote_End(PurchRcptLine."Job No.", PurchRcptLine."Job Task No.", PurchRcptLine."Piecework NÂº", PurchRcptLine."Shortcut Dimension 1 Code", PurchRcptLine."Shortcut Dimension 2 Code", PurchRcptLine."Dimension Set ID");  //Cerrar el apunte
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Crear diario contable devolucion"();
    BEGIN
    END;

    LOCAL PROCEDURE CreateAdjustAccountingNotes(VAR PurchRcptLine: Record 121; Amount: Decimal; Date: Date);
    VAR
        Job: Record 167;
        Currency: Record 4;
        GeneralPostingSetup: Record 252;
        Vendor: Record 23;
        VendorPostingGroup: Record 93;
        VendorLedgerEntry: Record 25;
        PurchRcptHeader: Record 120;
    BEGIN
        //Crear las l�neas del diario contable de ajuste de divisas para liberar el albar�n.

        Job.RESET;
        Job.GET(PurchRcptLine."Job No.");
        IF PurchRcptLine.Type.AsInteger() > PurchRcptLine.Type::"G/L Account".AsInteger() THEN BEGIN
            GeneralPostingSetup.GET(PurchRcptLine."Gen. Bus. Posting Group", PurchRcptLine."Gen. Prod. Posting Group");
            GeneralPostingSetup.TESTFIELD("Purch. Account");
        END ELSE BEGIN
            IF PurchRcptLine.Type = PurchRcptLine.Type::"G/L Account" THEN
                GeneralPostingSetup."Purch. Account" := PurchRcptLine."No.";
        END;
        Vendor.GET(PurchRcptLine."Buy-from Vendor No.");
        VendorPostingGroup.GET(Vendor."Vendor Posting Group");
        VendorPostingGroup.TESTFIELD(VendorPostingGroup."Acct. Purch. Rcpt Pending Inv.");

        //Leer la cabecera y la divisa
        PurchRcptHeader.GET(PurchRcptLine."Document No.");
        IF (PurchRcptHeader."Currency Code" = '') THEN
            CLEAR(Currency)
        ELSE
            Currency.GET(PurchRcptHeader."Currency Code");

        //Crear las l�neas
        PostAdjmt(PurchRcptLine."Document No.", VendorPostingGroup."Acct. Purch. Rcpt Pending Inv.", -Amount, Date, Vendor."IC Partner Code",
                  PurchRcptHeader."Currency Code", PurchRcptLine."Shortcut Dimension 1 Code", PurchRcptLine."Shortcut Dimension 2 Code", PurchRcptLine."Dimension Set ID");
        IF (Amount > 0) THEN
            PostAdjmt(PurchRcptLine."Document No.", Currency."Unrealized Losses Acc.", Amount, Date, Vendor."IC Partner Code",
                      PurchRcptHeader."Currency Code", PurchRcptLine."Shortcut Dimension 1 Code", PurchRcptLine."Shortcut Dimension 2 Code", PurchRcptLine."Dimension Set ID")  ///---
        ELSE
            PostAdjmt(PurchRcptLine."Document No.", Currency."Unrealized Gains Acc.", Amount, Date, Vendor."IC Partner Code",
                      PurchRcptHeader."Currency Code", PurchRcptLine."Shortcut Dimension 1 Code", PurchRcptLine."Shortcut Dimension 2 Code", PurchRcptLine."Dimension Set ID");

        //Poner el proyecto en el movimiento del proveedor
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETCURRENTKEY("Document No.");
        VendorLedgerEntry.SETRANGE("Document No.", PurchRcptLine."Document No.");
        VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Shipment);
        VendorLedgerEntry.MODIFYALL("QB Job No.", Job."No.");
    END;

    LOCAL PROCEDURE CreateReturnShipmentAccountingNotes(Amount: Decimal; Date: Date; VAR ReturnShipmentLine: Record 6651; pCancel: Boolean);
    VAR
        Job: Record 167;
        GeneralPostingSetup: Record 252;
        Vendor: Record 23;
        VendorPostingGroup: Record 93;
        VendorLedgerEntry: Record 25;
        ReturnShipmentHeader: Record 6650;
    BEGIN
        //Crear las l�neas del diario contable para registrar el albar�n.   JAV 08/10/20: - QB 1.06.20 Se indica si es la provisi�n o la cancelaci�n

        Job.RESET;
        Job.GET(ReturnShipmentLine."Job No.");
        IF ReturnShipmentLine.Type.AsInteger() > ReturnShipmentLine.Type::"G/L Account".AsInteger() THEN BEGIN
            GeneralPostingSetup.GET(ReturnShipmentLine."Gen. Bus. Posting Group", ReturnShipmentLine."Gen. Prod. Posting Group");
            GeneralPostingSetup.TESTFIELD("Purch. Account");
        END ELSE BEGIN
            IF ReturnShipmentLine.Type = ReturnShipmentLine.Type::"G/L Account" THEN
                GeneralPostingSetup."Purch. Account" := ReturnShipmentLine."No.";
        END;
        Vendor.GET(ReturnShipmentLine."Buy-from Vendor No.");
        VendorPostingGroup.GET(Vendor."Vendor Posting Group");
        VendorPostingGroup.TESTFIELD(VendorPostingGroup."Acct. Purch. Rcpt Pending Inv.");

        //Leer la cabecera
        ReturnShipmentHeader.GET(ReturnShipmentLine."Document No.");

        //Crear las l�neas
        CLEAR(GenJournalLine);
        ReturnShipmentAccountingNote_Forecast(Amount, Date, VendorPostingGroup."Acct. Purch. Rcpt Pending Inv.", ReturnShipmentLine, ReturnShipmentHeader."Currency Code", pCancel);
        ReturnShipmentAccountingNote_Expense(Amount, Date, GeneralPostingSetup."Purch. Account", ReturnShipmentLine, ReturnShipmentHeader."Currency Code", pCancel);

        //Poner el proyecto en el movimiento del proveedor
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETCURRENTKEY("Document No.");
        VendorLedgerEntry.SETRANGE("Document No.", ReturnShipmentLine."Document No.");
        VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Shipment);
        VendorLedgerEntry.MODIFYALL("QB Job No.", Job."No.");
    END;

    LOCAL PROCEDURE ReturnShipmentAccountingNote_Forecast(Amount: Decimal; Date: Date; Account: Code[20]; ReturnShipmentLine: Record 6651; pCurrency: Code[20]; pCancel: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        GeneralLedgerSetup: Record 98;
        FunctionQB: Codeunit 7207272;
        DimensionManagement: Codeunit 408;
    BEGIN
        //General el apunte al proveedor o a la cuenta de albaranes pendientes de recibir factura. Retorna el importe en DL por si el movimiento es en divisas
        AccountingNote_Init(Date, ReturnShipmentLine."Document No.", pCancel, ReturnShipmentLine."Gen. Bus. Posting Group", ReturnShipmentLine."Gen. Prod. Posting Group");    //Inicializar el apunte

        //JAV 08/10/20: - Tipo de documento y cuenta, ser� Albar�n y Proveedor en divisa si as� est� configurado, si no ser� en blanco y cuenta en DL
        QuoBuildingSetup.GET;
        IF (QuoBuildingSetup."Use Shipment type in Vendor") THEN BEGIN
            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Vendor);
            GenJournalLine.VALIDATE("Account No.", ReturnShipmentLine."Buy-from Vendor No.");
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Shipment);
            GenJournalLine.VALIDATE("Shipment Line No", ReturnShipmentLine."Line No.");  //JAV 21/10/20: - QB 1.06.21 A�adimos la l�nea del albar�n
        END ELSE BEGIN
            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
            GenJournalLine.VALIDATE("Account No.", Account);
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::" ");
            GenJournalLine.VALIDATE("Shipment Line No", 0);
        END;

        //JAV 31/05/22: - QB 1.10.46 Se cambia de lugar el poner la descripci�n de la l�nea para que lo haga correctamente
        IF (NOT pCancel) THEN
            GenJournalLine.Description := 'Provisi�n devol. ' + ReturnShipmentLine."Document No."
        ELSE
            GenJournalLine.Description := 'Cancelar provisi�n devol. ' + ReturnShipmentLine."Document No.";

        //JAV 10/10/20 se a�ade la divisa del albar�n, que usar� el cambio oficial del d�a de registro
        GenJournalLine.VALIDATE("Currency Code", pCurrency);
        //-Q20364
        //GenJournalLine.VALIDATE(Amount,-Amount);                                                  // El importe es negativo
        IF NOT pCancel THEN GenJournalLine.VALIDATE(Amount, -Amount) ELSE GenJournalLine.VALIDATE(Amount, Amount);  // El importe es negativo
                                                                                                                    //+Q20364
        AccountingNote_End(ReturnShipmentLine."Job No.",
                           ReturnShipmentLine."Job Task No.",
                           ReturnShipmentLine."Piecework NÂº",
                           ReturnShipmentLine."Shortcut Dimension 1 Code",
                           ReturnShipmentLine."Shortcut Dimension 2 Code",
                           ReturnShipmentLine."Dimension Set ID");  //Cerrar el apunte
    END;

    LOCAL PROCEDURE ReturnShipmentAccountingNote_Expense(Amount: Decimal; Date: Date; Account: Code[20]; ReturnShipmentLine: Record 6651; pCurrency: Code[20]; pCancel: Boolean);
    BEGIN
        //Generar el apunte al gasto
        AccountingNote_Init(Date, ReturnShipmentLine."Document No.", pCancel, ReturnShipmentLine."Gen. Bus. Posting Group", ReturnShipmentLine."Gen. Prod. Posting Group");    //Inicializar el apunte

        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.VALIDATE("Account No.", Account);
        GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::" ");

        //JAV 31/05/22: - QB 1.10.46 Se cambia de lugar el poner la descripci�n de la l�nea para que lo haga correctamente
        //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras. Se cambia PurchRcptLine."Document No." por DocumentNo;
        IF (NOT pCancel) THEN
            GenJournalLine.Description := 'Provisi�n devol. ' + ReturnShipmentLine."Document No."
        ELSE
            GenJournalLine.Description := 'Cancelar provisi�n devol. ' + ReturnShipmentLine."Document No.";

        //JAV 10/10/20 se a�ade la divisa del albar�n, con el cambio oficial del d�a de registro
        GenJournalLine.VALIDATE("Currency Code", pCurrency);

        //-Q20364
        //GenJournalLine.VALIDATE(Amount,Amount);                                             // el importe es positivo
        IF NOT pCancel THEN GenJournalLine.VALIDATE(Amount, Amount) ELSE GenJournalLine.VALIDATE(Amount, -Amount);         // el importe es positivo
                                                                                                                           //+Q20364
        GenJournalLine."Piecework Code" := ReturnShipmentLine."Piecework NÂº";
        GenJournalLine."Job Task No." := ReturnShipmentLine."Job Task No.";
        AccountingNote_End(ReturnShipmentLine."Job No.",
                           ReturnShipmentLine."Job Task No.",
                           ReturnShipmentLine."Piecework NÂº",
                           ReturnShipmentLine."Shortcut Dimension 1 Code",
                           ReturnShipmentLine."Shortcut Dimension 2 Code",
                           ReturnShipmentLine."Dimension Set ID");  //Cerrar el apunte
    END;

    LOCAL PROCEDURE CreateAdjustReturnShipmentAccountingNotes(VAR ReturnShipmentLine: Record 6651; Amount: Decimal; Date: Date);
    VAR
        Job: Record 167;
        Currency: Record 4;
        GeneralPostingSetup: Record 252;
        Vendor: Record 23;
        VendorPostingGroup: Record 93;
        VendorLedgerEntry: Record 25;
        ReturnShipmentHeader: Record 6650;
    BEGIN
        //Crear las l�neas del diario contable de ajuste de divisas para liberar el albar�n.

        Job.RESET;
        Job.GET(ReturnShipmentLine."Job No.");
        IF ReturnShipmentLine.Type.AsInteger() > ReturnShipmentLine.Type::"G/L Account".AsInteger() THEN BEGIN
            GeneralPostingSetup.GET(ReturnShipmentLine."Gen. Bus. Posting Group", ReturnShipmentLine."Gen. Prod. Posting Group");
            GeneralPostingSetup.TESTFIELD("Purch. Account");
        END ELSE BEGIN
            IF ReturnShipmentLine.Type = ReturnShipmentLine.Type::"G/L Account" THEN
                GeneralPostingSetup."Purch. Account" := ReturnShipmentLine."No.";
        END;
        Vendor.GET(ReturnShipmentLine."Buy-from Vendor No.");
        VendorPostingGroup.GET(Vendor."Vendor Posting Group");
        VendorPostingGroup.TESTFIELD(VendorPostingGroup."Acct. Purch. Rcpt Pending Inv.");

        //Leer la cabecera y la divisa
        ReturnShipmentHeader.GET(ReturnShipmentLine."Document No.");
        IF (ReturnShipmentHeader."Currency Code" = '') THEN
            CLEAR(Currency)
        ELSE
            Currency.GET(ReturnShipmentHeader."Currency Code");

        //Crear las l�neas
        PostAdjmt(ReturnShipmentLine."Document No.", VendorPostingGroup."Acct. Purch. Rcpt Pending Inv.", -Amount, Date, Vendor."IC Partner Code",
                  ReturnShipmentHeader."Currency Code", ReturnShipmentLine."Shortcut Dimension 1 Code", ReturnShipmentLine."Shortcut Dimension 2 Code", ReturnShipmentLine."Dimension Set ID");
        IF (Amount > 0) THEN
            PostAdjmt(ReturnShipmentLine."Document No.", Currency."Unrealized Losses Acc.", Amount, Date, Vendor."IC Partner Code",
                      ReturnShipmentHeader."Currency Code", ReturnShipmentLine."Shortcut Dimension 1 Code", ReturnShipmentLine."Shortcut Dimension 2 Code", ReturnShipmentLine."Dimension Set ID")  ///---
        ELSE
            PostAdjmt(ReturnShipmentLine."Document No.", Currency."Unrealized Gains Acc.", Amount, Date, Vendor."IC Partner Code",
                      ReturnShipmentHeader."Currency Code", ReturnShipmentLine."Shortcut Dimension 1 Code", ReturnShipmentLine."Shortcut Dimension 2 Code", ReturnShipmentLine."Dimension Set ID");

        //Poner el proyecto en el movimiento del proveedor
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETCURRENTKEY("Document No.");
        VendorLedgerEntry.SETRANGE("Document No.", ReturnShipmentLine."Document No.");
        VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Shipment);
        VendorLedgerEntry.MODIFYALL("QB Job No.", Job."No.");
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Crear diario contable comunes"();
    BEGIN
    END;

    LOCAL PROCEDURE PostAdjmt(VAR DocumentNo: Code[20]; GLAccNo: Code[20]; PostingAmount: Decimal; PostingDate2: Date; ICCode: Code[20]; CurrencyCode: Code[10]; ShortcutDimension1Code: Code[20]; ShortcutDimension2Code: Code[20]; DimensionSetID: Integer) TransactionNo: Integer;
    VAR
        GenJnlLine: Record 81;
        SourceCodeSetup: Record 242;
        PurchRcptHeader: Record 120;
    BEGIN
        SourceCodeSetup.GET;
        //PurchRcptHeader.GET(PurchRcptLine."Document No.");

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Posting Date", PostingDate2);
        GenJnlLine."Document Type" := GenJournalLine."Document Type"::Shipment;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine.VALIDATE("Account No.", GLAccNo);
        GenJnlLine.Description := PADSTR(STRSUBSTNO('Ajuste %1 cancelar albar�n', PurchRcptHeader."Currency Code"), MAXSTRLEN(GenJnlLine.Description));
        GenJnlLine.VALIDATE(Amount, PostingAmount);
        GenJnlLine."Source Currency Code" := CurrencyCode;
        GenJnlLine."IC Partner Code" := ICCode;
        GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Shortcut Dimension 1 Code" := ShortcutDimension1Code;
        GenJnlLine."Shortcut Dimension 2 Code" := ShortcutDimension2Code;
        GenJnlLine."Dimension Set ID" := DimensionSetID;
        GenJnlPostLine.RUN(GenJnlLine);
    END;

    LOCAL PROCEDURE AccountingNote_Init(Date: Date; DocumentNo: Code[20]; pCancel: Boolean; pGenPG: Code[20]; pProPG: Code[20]);
    VAR
        SourceCodeSetup: Record 242;
        nro: Integer;
    BEGIN
        //Inicializar el apunte y rellenar los datos comunes a ambos apuntes
        nro := GenJournalLine.COUNT * 100;

        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'GENERAL';    //Esto solo sirve para verlos si hay que hacer un debug, por eso va a dato fijo
        GenJournalLine."Journal Batch Name" := 'GENERAL';       //Esto solo sirve para verlos si hay que hacer un debug, por eso va a dato fijo
        GenJournalLine."Line No." := nro;

        GenJournalLine.VALIDATE("Posting Date", Date);

        //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.Begin
        //GenJournalLine.VALIDATE("Document No.", PurchRcptLine."Document No.");
        GenJournalLine.VALIDATE("Document No.", DocumentNo);
        //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.End
        IF (NOT pCancel) THEN
            //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.Begin
            //GenJournalLine.Description := 'Provisi�n albar�n ' + PurchRcptLine."Document No."
            GenJournalLine.Description := 'Provisi�n albar�n ' + DocumentNo
        //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.End
        ELSE
            //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.Begin
            //GenJournalLine.Description := 'Cancelar provisi�n albar�n ' + PurchRcptLine."Document No.";
            GenJournalLine.Description := 'Cancelar provisi�n albar�n ' + DocumentNo;
        //CPA 26/01/22 - Q15921. Errores detectados en almacenes de obras.End

        GenJournalLine.VALIDATE("Already Generated Job Entry", TRUE);
        GenJournalLine."Gen. Bus. Posting Group" := '';
        GenJournalLine."Gen. Prod. Posting Group" := '';
        GenJournalLine."VAT Bus. Posting Group" := '';
        GenJournalLine."VAT Prod. Posting Group" := '';
        GenJournalLine.Correction := FALSE;
        GenJournalLine."Post Purch. Rcpt. Pending y/n" := TRUE;
        GenJournalLine."System-Created Entry" := TRUE;

        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD(SourceCodeSetup.Purchases);
        GenJournalLine."Source Code" := SourceCodeSetup.Purchases;
    END;

    LOCAL PROCEDURE AccountingNote_End(JobNo: Code[20]; JobTaskNo: Code[20]; PieceWorkNo: Text[20]; ShortcutDimension1Code: Code[20]; ShortcutDimension2Code: Code[20]; DimensionSetID: Integer);
    VAR
        setJob: Boolean;
    BEGIN
        //Cerrar el apunte, a�adir datos y guardarlo

        //A�ado proyecto y unidad de obra
        setJob := FALSE;
        IF (GLAccount.GET(GenJournalLine."Account No.")) THEN                                                 //Solo tienen proyecto los movimientos de tipo cuenta si son de tipo comercial
            setJob := (GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement");

        IF (setJob) THEN BEGIN
            GenJournalLine.VALIDATE("Job No.", JobNo);
            GenJournalLine."Piecework Code" := PieceWorkNo;
            GenJournalLine."Job Task No." := JobTaskNo;
        END ELSE BEGIN
            GenJournalLine."Job No." := '';
            GenJournalLine."Piecework Code" := '';
            GenJournalLine."Job Task No." := '';
        END;

        //Recupero las dimensiones del albar�n
        GenJournalLine."Shortcut Dimension 1 Code" := ShortcutDimension1Code;
        GenJournalLine."Shortcut Dimension 2 Code" := ShortcutDimension2Code;
        GenJournalLine."Dimension Set ID" := DimensionSetID;

        IF (GenJournalLine."Gen. Bus. Posting Group" <> '') OR (GenJournalLine."Gen. Prod. Posting Group" <> '') OR
           (GenJournalLine."VAT Bus. Posting Group" <> '') OR (GenJournalLine."VAT Prod. Posting Group" <> '') THEN
            GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::Purchase
        ELSE
            GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";

        //GeneralLedgerSetup.GET;
        //FunctionQB.UpdateDimSet(GeneralLedgerSetup."Global Dimension 1 Code",PurchRcptLine."Shortcut Dimension 1 Code",GenJournalLine."Dimension Set ID");
        //FunctionQB.UpdateDimSet(GeneralLedgerSetup."Global Dimension 2 Code",PurchRcptLine."Shortcut Dimension 2 Code",GenJournalLine."Dimension Set ID");
        //DimensionManagement.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID",GenJournalLine."Shortcut Dimension 1 Code",GenJournalLine."Shortcut Dimension 2 Code");

        //Quitar siempre el IVA por si acaso, ya que los albaranes no contabilizan nunca con IVA
        GenJournalLine.VALIDATE("VAT Bus. Posting Group", '');
        GenJournalLine.VALIDATE("VAT Prod. Posting Group", '');
        //JAV 01/04/21 Se quitan mas campos para que no genere IVA
        GenJournalLine.VALIDATE("Gen. Posting Type", GenJournalLine."Gen. Posting Type"::" ");
        GenJournalLine.VALIDATE("Gen. Bus. Posting Group", '');
        GenJournalLine.VALIDATE("Gen. Prod. Posting Group", '');

        //GenJournalLine.INSERT;                           //Solo se activa para el debug, si se activa se comenta la siguiente l�nea
        GenJnlPostLine.RunWithCheck(GenJournalLine);
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Varios"();
    BEGIN
    END;

    PROCEDURE InQueuePurchaseRcptToDeactivate(VAR PurchRcptLine: Record 121; QtyToBeInvoiced: Decimal; VAR TempPurchRcptLine: Record 121 TEMPORARY);
    BEGIN
        TempPurchRcptLine."Document No." := PurchRcptLine."Document No.";
        TempPurchRcptLine."Line No." := PurchRcptLine."Line No.";
        TempPurchRcptLine.Quantity := QtyToBeInvoiced;
        TempPurchRcptLine.INSERT;
        //COMMIT;
    END;

    PROCEDURE InQueuePurchaseReturnToDeactivate(VAR PurchRcptLine: Record 6651; QtyToBeInvoiced: Decimal; VAR TempPurchRcptLine: Record 6651 TEMPORARY);
    BEGIN
        //-Q20364 Cambiada la variable PurcRcptLine de 121 a 6651
        TempPurchRcptLine."Document No." := PurchRcptLine."Document No.";
        TempPurchRcptLine."Line No." := PurchRcptLine."Line No.";
        TempPurchRcptLine.Quantity := QtyToBeInvoiced;
        TempPurchRcptLine.INSERT;
        //COMMIT;
    END;

    PROCEDURE CreatePurchaseRcpttOutQuantityStock(VAR PurchRcptHeader: Record 120; Negative: Boolean);
    VAR
        OutputShipmentHeading: Record 7207308;
        OutputShipmentLines: Record 7207309;
        PurchRcptLine: Record 121;
        PurchRcptLine2: Record 121;
        ReservationEntry: Record 337;
        ReservationEntry2: Record 337;
        Job: Record 167;
        Location: Record 14;
        PostPurchaseRcptOutput: Codeunit 7207276;
        FunctionQB: Codeunit 7207272;
        PurchaseJob: Code[20];
        CountLines: Integer;
        TotalValueEntries: Decimal;
        ThereIsMore: Boolean;
        Text001: TextConst ENU = 'Stock Purchase Rcpt. 1', ESP = 'Albar�n de compra %1';
    BEGIN
        //Esta funci�n crea una entrada de almac�n en el proyecto a partir de un albar�n. Cuando se registra crea los movimientos de producto y de valor asociados al albar�n
        IF (PurchRcptHeader."Order To" <> PurchRcptHeader."Order To"::Job) THEN
            EXIT;

        PurchaseJob := '';
        ThereIsMore := TRUE;
        PurchRcptLine.RESET;
        PurchRcptLine.SETRANGE("Document No.", PurchRcptHeader."No.");
        PurchRcptLine.SETRANGE(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SETFILTER(Quantity, '<>%1', 0);

        IF PurchRcptLine.FINDFIRST THEN
            ThereIsMore := TRUE;

        IF PurchaseJob <> PurchRcptLine."Job No." THEN
            REPEAT
                PurchaseJob := PurchRcptLine."Job No.";

                //compruebo si el almac�n es de obra
                PurchRcptLine.TESTFIELD("Job No.");
                Job.GET(PurchRcptLine."Job No.");
                IF Job."Job Location" <> '' THEN
                    Location.GET(Job."Job Location");
                //AML QB_ST01.1
                IF Job."Warehouse Cost Unit" = '' THEN EXIT; //Si no est� informada y no es obligatorio la unidad de obra lo registrar� como no almace�n.
                                                             //AML QB_ST01.1
                PurchRcptLine2.RESET;
                PurchRcptLine2.SETRANGE("Document No.", PurchRcptHeader."No.");
                PurchRcptLine2.SETRANGE(Type, PurchRcptLine.Type::Item);
                PurchRcptLine2.SETFILTER(Quantity, '<>%1', 0);
                PurchRcptLine2.SETRANGE("Job No.", Job."No.");
                PurchRcptLine2.SETRANGE("Piecework NÂº", Job."Warehouse Cost Unit");

                IF (Job."Job Location" <> '') AND (Location."QB Job Location") AND (PurchRcptLine2.FINDFIRST) THEN BEGIN
                    CLEAR(OutputShipmentHeading);
                    //JAV 09/07/19: - Se a�ade el proyecto antes de crear la cabecera de salida para que pueda tomar los datos correctamente
                    OutputShipmentHeading.VALIDATE("Job No.", PurchaseJob);
                    OutputShipmentHeading."No." := '';
                    OutputShipmentHeading.INSERT(TRUE);
                    OutputShipmentHeading.VALIDATE("Job No.", PurchaseJob);
                    //-Q20221
                    OutputShipmentHeading."Request Date" := PurchRcptHeader."Posting Date";
                    //+Q20221
                    OutputShipmentHeading.VALIDATE("Posting Date", PurchRcptHeader."Posting Date");
                    OutputShipmentHeading."Posting Description" := STRSUBSTNO(Text001, PurchRcptHeader."No.");
                    OutputShipmentHeading."Automatic Shipment" := TRUE;
                    OutputShipmentHeading."Purchase Rcpt. No." := PurchRcptHeader."No.";
                    OutputShipmentHeading."Dimension Set ID" := PurchRcptHeader."Dimension Set ID";
                    OutputShipmentHeading."Automatic Shipment" := TRUE;   //JAV 03/04/21: - QB 1.08.32 Marcamos que se ha generado desde un albar�n de compra
                    OutputShipmentHeading.MODIFY;

                    CountLines := 0;
                    TotalValueEntries := 0;
                    REPEAT
                        IF PurchRcptLine."Piecework NÂº" = Job."Warehouse Cost Unit" THEN BEGIN
                            ReservationEntry.RESET;
                            ReservationEntry.SETRANGE("Source ID", PurchRcptLine."Order No.");
                            ReservationEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
                            //filtro para el caso de pedidos
                            ReservationEntry.SETRANGE("Source Subtype", 1);
                            ReservationEntry.SETRANGE("Source Ref. No.", PurchRcptLine."Order Line No.");
                            ReservationEntry.SETRANGE("Item No.", PurchRcptLine."No.");
                            IF NOT ReservationEntry.FINDFIRST THEN BEGIN
                                OutputShipmentLines.INIT;
                                OutputShipmentLines.VALIDATE("Document No.", OutputShipmentHeading."No.");
                                //AML QB_ST01 Para mantener la integridad
                                //OutputShipmentLines."Line No." := CountLines + 10000;
                                OutputShipmentLines."Line No." := PurchRcptLine."Line No.";
                                //AML QB_ST01
                                CountLines := CountLines + 10000;
                                //
                                OutputShipmentLines.VALIDATE("Job No.", PurchaseJob);
                                OutputShipmentLines.VALIDATE("No.", PurchRcptLine."No.");
                                OutputShipmentLines.VALIDATE("Unit of Measure Code", PurchRcptLine."Unit of Measure Code");
                                OutputShipmentLines."Unit of Mensure Quantity" := PurchRcptLine."Qty. per Unit of Measure";
                                IF (Negative) THEN
                                    OutputShipmentLines.VALIDATE(Quantity, PurchRcptLine.Quantity)
                                ELSE
                                    OutputShipmentLines.VALIDATE(Quantity, -PurchRcptLine.Quantity);
                                Job.GET(PurchaseJob);
                                OutputShipmentLines.VALIDATE("Outbound Warehouse", Job."Job Location");
                                OutputShipmentLines.VALIDATE("Produccion Unit", PurchRcptLine."Piecework NÂº");
                                OutputShipmentLines.VALIDATE("Unit Cost", PurchRcptLine."Unit Cost (LCY)");
                                TotalValueEntries := TotalValueEntries + OutputShipmentLines."Total Cost";
                                OutputShipmentLines."Job Task No." := PurchRcptLine."Job Task No.";
                                OutputShipmentLines."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
                                //AML 04/08/22 Correccion para llevar las dimensiones
                                OutputShipmentLines."Shortcut Dimension 1 Code" := PurchRcptLine."Shortcut Dimension 1 Code";
                                OutputShipmentLines."Shortcut Dimension 2 Code" := PurchRcptLine."Shortcut Dimension 2 Code";
                                //AML

                                //CPA 7/12/21 - Q15921. Errores detectados en almacenes de obras.Begin
                                OutputShipmentLines."Item Rcpt. Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
                                OutputShipmentLines."Invoiced Quantity (Base)" := PurchRcptLine."Quantity Invoiced";
                                //CPA 7/12/21 - Q15921. Errores detectados en almacenes de obras.End
                                OutputShipmentLines.INSERT;
                            END ELSE BEGIN
                                REPEAT
                                    IF ReservationEntry."Qty. to Handle (Base)" <> 0 THEN BEGIN
                                        OutputShipmentLines.INIT;
                                        OutputShipmentLines.VALIDATE("Document No.", OutputShipmentHeading."No.");
                                        OutputShipmentLines."Line No." := CountLines + 10000;
                                        CountLines := CountLines + 10000;
                                        OutputShipmentLines.VALIDATE("Job No.", PurchaseJob);
                                        OutputShipmentLines.VALIDATE("No.", PurchRcptLine."No.");
                                        OutputShipmentLines.VALIDATE(Quantity, -ReservationEntry."Qty. to Handle (Base)");
                                        Job.GET(PurchaseJob);
                                        OutputShipmentLines.VALIDATE("Outbound Warehouse", Job."Job Location");
                                        OutputShipmentLines.VALIDATE("Produccion Unit", PurchRcptLine."Piecework NÂº");
                                        OutputShipmentLines.VALIDATE("Unit Cost", PurchRcptLine."Unit Cost (LCY)");
                                        TotalValueEntries := TotalValueEntries + OutputShipmentLines."Total Cost";
                                        OutputShipmentLines."Job Task No." := PurchRcptLine."Job Task No.";
                                        //CPA 7/12/21 - Q15921. Errores detectados en almacenes de obras.Begin
                                        OutputShipmentLines."Item Rcpt. Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
                                        OutputShipmentLines."Invoiced Quantity (Base)" := PurchRcptLine."Quantity Invoiced";
                                        //CPA 7/12/21 - Q15921. Errores detectados en almacenes de obras.End
                                        OutputShipmentLines.INSERT;

                                        OutputShipmentLines."Source Document Type" := OutputShipmentLines."Source Document Type"::Order;
                                        OutputShipmentLines."No. Source Document" := PurchRcptLine."Order No.";
                                        OutputShipmentLines."No. Source Document Line" := PurchRcptLine."Order Line No.";
                                        OutputShipmentLines."No. Serie for Tracking" := ReservationEntry."Serial No.";
                                        OutputShipmentLines."No. Lot for Tracking" := ReservationEntry."Lot No.";
                                        OutputShipmentLines."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
                                        //AML 04/08/22 Correccion para llevar las dimensiones
                                        OutputShipmentLines."Shortcut Dimension 1 Code" := PurchRcptLine."Shortcut Dimension 1 Code";
                                        OutputShipmentLines."Shortcut Dimension 2 Code" := PurchRcptLine."Shortcut Dimension 2 Code";
                                        //AML
                                        OutputShipmentLines.MODIFY(TRUE);

                                        ReservationEntry2 := ReservationEntry;
                                        ReservationEntry2.DELETE;
                                    END ELSE BEGIN
                                        ReservationEntry."Qty. to Handle (Base)" := -1;
                                        ReservationEntry."Qty. to Invoice (Base)" := -1;
                                        ReservationEntry.MODIFY;
                                    END;
                                UNTIL ReservationEntry.NEXT = 0;
                            END;
                        END;
                        IF PurchRcptLine.NEXT = 0 THEN
                            ThereIsMore := FALSE;
                    UNTIL (NOT ThereIsMore) OR (PurchaseJob <> PurchRcptLine."Job No.");
                    PostPurchaseRcptOutput.RUN(OutputShipmentHeading);
                END ELSE BEGIN
                    IF PurchRcptLine.NEXT = 0 THEN
                        ThereIsMore := FALSE;
                END;
            UNTIL NOT ThereIsMore
    END;

    PROCEDURE CreatePurchaseReturnShipmentOutQuantityStock(VAR ReturnShipmentHeader: Record 6650; Negative: Boolean);
    VAR
        OutputShipmentHeading: Record 7207308;
        OutputShipmentLines: Record 7207309;
        ReturnShipmentLine: Record 6651;
        ReturnShipmentLine2: Record 6651;
        ReservationEntry: Record 337;
        ReservationEntry2: Record 337;
        Job: Record 167;
        Location: Record 14;
        PostPurchaseRcptOutput: Codeunit 7207276;
        FunctionQB: Codeunit 7207272;
        PurchaseJob: Code[20];
        CountLines: Integer;
        TotalValueEntries: Decimal;
        ThereIsMore: Boolean;
        Text001: TextConst ENU = 'Stock Purchase Rcpt. 1', ESP = 'Albar�n de compra %1';
    BEGIN
        //Esta funci�n crea una entrada de almac�n en el proyecto a partir de un albar�n. Cuando se registra crea los movimientos de producto y de valor asociados al albar�n
        //IF (ReturnShipmentHeader."Order To" <> ReturnShipmentHeader."Order To"::Job) THEN
        //  EXIT;

        PurchaseJob := '';
        ThereIsMore := TRUE;
        ReturnShipmentLine.RESET;
        ReturnShipmentLine.SETRANGE("Document No.", ReturnShipmentHeader."No.");
        ReturnShipmentLine.SETRANGE(Type, ReturnShipmentLine.Type::Item);
        ReturnShipmentLine.SETFILTER(Quantity, '<>%1', 0);

        IF ReturnShipmentLine.FINDFIRST THEN
            ThereIsMore := TRUE;

        IF PurchaseJob <> ReturnShipmentLine."Job No." THEN
            REPEAT
                PurchaseJob := ReturnShipmentLine."Job No.";

                //compruebo si el almac�n es de obra
                ReturnShipmentLine.TESTFIELD("Job No.");
                Job.GET(ReturnShipmentLine."Job No.");
                IF Job."Job Location" <> '' THEN
                    Location.GET(Job."Job Location");

                ReturnShipmentLine2.RESET;
                ReturnShipmentLine2.SETRANGE("Document No.", ReturnShipmentHeader."No.");
                ReturnShipmentLine2.SETRANGE(Type, ReturnShipmentLine2.Type::Item);
                ReturnShipmentLine2.SETFILTER(Quantity, '<>%1', 0);
                ReturnShipmentLine2.SETRANGE("Job No.", Job."No.");
                ReturnShipmentLine2.SETRANGE("Piecework NÂº", Job."Warehouse Cost Unit");

                IF (Job."Job Location" <> '') AND (Location."QB Job Location") AND (ReturnShipmentLine2.FINDFIRST) THEN BEGIN
                    CLEAR(OutputShipmentHeading);
                    //JAV 09/07/19: - Se a�ade el proyecto antes de crear la cabecera de salida para que pueda tomar los datos correctamente
                    OutputShipmentHeading.VALIDATE("Job No.", PurchaseJob);
                    OutputShipmentHeading."No." := '';
                    OutputShipmentHeading.INSERT(TRUE);
                    OutputShipmentHeading.VALIDATE("Job No.", PurchaseJob);
                    OutputShipmentHeading.VALIDATE("Posting Date", ReturnShipmentHeader."Posting Date");
                    OutputShipmentHeading."Posting Description" := STRSUBSTNO(Text001, ReturnShipmentHeader."No.");
                    OutputShipmentHeading."Automatic Shipment" := TRUE;

                    OutputShipmentHeading."Documnet Type" := OutputShipmentHeading."Documnet Type"::"Receipt.Return";
                    OutputShipmentHeading."Purchase Rcpt. No." := ReturnShipmentHeader."No.";

                    OutputShipmentHeading."Dimension Set ID" := ReturnShipmentHeader."Dimension Set ID";
                    OutputShipmentHeading."Automatic Shipment" := TRUE;   //JAV 03/04/21: - QB 1.08.32 Marcamos que se ha generado desde un albar�n de compra
                    OutputShipmentHeading.MODIFY;

                    CountLines := 0;
                    TotalValueEntries := 0;
                    REPEAT
                        IF ReturnShipmentLine."Piecework NÂº" = Job."Warehouse Cost Unit" THEN BEGIN
                            ReservationEntry.RESET;
                            ReservationEntry.SETRANGE("Source ID", ReturnShipmentLine."Return Order No.");
                            ReservationEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
                            //filtro para el caso de pedidos
                            ReservationEntry.SETRANGE("Source Subtype", 1);
                            ReservationEntry.SETRANGE("Source Ref. No.", ReturnShipmentLine."Return Order Line No.");
                            ReservationEntry.SETRANGE("Item No.", ReturnShipmentLine."No.");
                            IF NOT ReservationEntry.FINDFIRST THEN BEGIN
                                OutputShipmentLines.INIT;
                                OutputShipmentLines.VALIDATE("Document No.", OutputShipmentHeading."No.");
                                OutputShipmentLines."Line No." := CountLines + 10000;
                                CountLines := CountLines + 10000;
                                OutputShipmentLines.VALIDATE("Job No.", PurchaseJob);
                                OutputShipmentLines.VALIDATE("No.", ReturnShipmentLine."No.");
                                OutputShipmentLines.VALIDATE("Unit of Measure Code", ReturnShipmentLine."Unit of Measure Code");
                                OutputShipmentLines."Unit of Mensure Quantity" := ReturnShipmentLine."Qty. per Unit of Measure";
                                IF (Negative) THEN
                                    OutputShipmentLines.VALIDATE(Quantity, -ReturnShipmentLine.Quantity)
                                ELSE
                                    OutputShipmentLines.VALIDATE(Quantity, ReturnShipmentLine.Quantity);
                                Job.GET(PurchaseJob);
                                OutputShipmentLines.VALIDATE("Outbound Warehouse", Job."Job Location");
                                OutputShipmentLines.VALIDATE("Produccion Unit", ReturnShipmentLine."Piecework NÂº");
                                OutputShipmentLines.VALIDATE("Unit Cost", ReturnShipmentLine."Unit Cost (LCY)");
                                TotalValueEntries := TotalValueEntries + OutputShipmentLines."Total Cost";
                                OutputShipmentLines."Job Task No." := ReturnShipmentLine."Job Task No.";
                                OutputShipmentLines."Dimension Set ID" := ReturnShipmentLine."Dimension Set ID";
                                //AML 04/08/22 Correccion para llevar las dimensiones
                                OutputShipmentLines."Shortcut Dimension 1 Code" := ReturnShipmentLine."Shortcut Dimension 1 Code";
                                OutputShipmentLines."Shortcut Dimension 2 Code" := ReturnShipmentLine."Shortcut Dimension 2 Code";
                                //AML

                                //CPA 7/12/21 - Q15921. Errores detectados en almacenes de obras.Begin
                                OutputShipmentLines."Item Rcpt. Entry No." := ReturnShipmentLine."Item Shpt. Entry No.";
                                OutputShipmentLines."Invoiced Quantity (Base)" := -ReturnShipmentLine."Quantity Invoiced";
                                //CPA 7/12/21 - Q15921. Errores detectados en almacenes de obras.End
                                OutputShipmentLines.INSERT;
                            END ELSE BEGIN
                                REPEAT
                                    IF ReservationEntry."Qty. to Handle (Base)" <> 0 THEN BEGIN
                                        OutputShipmentLines.INIT;
                                        OutputShipmentLines.VALIDATE("Document No.", OutputShipmentHeading."No.");
                                        OutputShipmentLines."Line No." := CountLines + 10000;
                                        CountLines := CountLines + 10000;
                                        OutputShipmentLines.VALIDATE("Job No.", PurchaseJob);
                                        OutputShipmentLines.VALIDATE("No.", ReturnShipmentLine."No.");
                                        OutputShipmentLines.VALIDATE(Quantity, ReservationEntry."Qty. to Handle (Base)");
                                        Job.GET(PurchaseJob);
                                        OutputShipmentLines.VALIDATE("Outbound Warehouse", Job."Job Location");
                                        OutputShipmentLines.VALIDATE("Produccion Unit", ReturnShipmentLine."Piecework NÂº");
                                        OutputShipmentLines.VALIDATE("Unit Cost", ReturnShipmentLine."Unit Cost (LCY)");
                                        TotalValueEntries := TotalValueEntries + OutputShipmentLines."Total Cost";
                                        OutputShipmentLines."Job Task No." := ReturnShipmentLine."Job Task No.";
                                        //CPA 7/12/21 - Q15921. Errores detectados en almacenes de obras.Begin
                                        OutputShipmentLines."Item Rcpt. Entry No." := ReturnShipmentLine."Item Shpt. Entry No.";
                                        OutputShipmentLines."Invoiced Quantity (Base)" := -ReturnShipmentLine."Quantity Invoiced";
                                        //CPA 7/12/21 - Q15921. Errores detectados en almacenes de obras.End
                                        OutputShipmentLines.INSERT;

                                        OutputShipmentLines."Source Document Type" := OutputShipmentLines."Source Document Type"::Order;
                                        OutputShipmentLines."No. Source Document" := ReturnShipmentLine."Return Order No.";
                                        OutputShipmentLines."No. Source Document Line" := ReturnShipmentLine."Return Order Line No.";
                                        OutputShipmentLines."No. Serie for Tracking" := ReservationEntry."Serial No.";
                                        OutputShipmentLines."No. Lot for Tracking" := ReservationEntry."Lot No.";
                                        OutputShipmentLines."Dimension Set ID" := ReturnShipmentLine."Dimension Set ID";
                                        //AML 04/08/22 Correccion para llevar las dimensiones
                                        OutputShipmentLines."Shortcut Dimension 1 Code" := ReturnShipmentLine."Shortcut Dimension 1 Code";
                                        OutputShipmentLines."Shortcut Dimension 2 Code" := ReturnShipmentLine."Shortcut Dimension 2 Code";
                                        //AML
                                        OutputShipmentLines.MODIFY(TRUE);

                                        ReservationEntry2 := ReservationEntry;
                                        ReservationEntry2.DELETE;
                                    END ELSE BEGIN
                                        ReservationEntry."Qty. to Handle (Base)" := 1;
                                        ReservationEntry."Qty. to Invoice (Base)" := 1;
                                        ReservationEntry.MODIFY;
                                    END;
                                UNTIL ReservationEntry.NEXT = 0;
                            END;
                        END;
                        IF ReturnShipmentLine.NEXT = 0 THEN
                            ThereIsMore := FALSE;
                    UNTIL (NOT ThereIsMore) OR (PurchaseJob <> ReturnShipmentLine."Job No.");
                    PostPurchaseRcptOutput.RUN(OutputShipmentHeading);
                END ELSE BEGIN
                    IF ReturnShipmentLine.NEXT = 0 THEN
                        ThereIsMore := FALSE;
                END;
            UNTIL NOT ThereIsMore
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Eventos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforePostVAT, '', true, true)]
    LOCAL PROCEDURE C12_OnBeforePostVAT(GenJnlLine: Record 81; VAR GLEntry: Record 17; VATPostingSetup: Record 325; VAR IsHandled: Boolean);
    BEGIN
        IF (GenJnlLine."Post Purch. Rcpt. Pending y/n" = TRUE) THEN BEGIN
            GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
            IsHandled := TRUE;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforeInitGLEntry, '', true, true)]
    LOCAL PROCEDURE C21_OnBeforeInitGLEntry(VAR GenJournalLine: Record 81);
    BEGIN
        IF (GenJournalLine."Post Purch. Rcpt. Pending y/n" = TRUE) THEN BEGIN
            GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforeInitVAT, '', true, true)]
    LOCAL PROCEDURE C21_OnBeforeInitVAT(VAR GenJournalLine: Record 81; VAR GLEntry: Record 17; VAR VATPostingSetup: Record 325);
    BEGIN
        IF (GenJournalLine."Post Purch. Rcpt. Pending y/n" = TRUE) THEN BEGIN
            GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
        END;
    END;

    /*BEGIN
/*{
      JAV 09/07/19: - Se a�ade el proyecto antes de crear la cabecera de salida para que pueda tomar los datos correctamente
      PGM 07/10/20: - QB 1.06.20 Tipo de documento Albar�n para generar/cancerar el apunte contable de previsi�n del albar�n. JAV: Si as� est� configurado
      JAV 22/10/21: - QB 1.09.22 Actualizar la cantidad e importe provisionados del albar�n

      CPA 26/01/22: - QB 1.10.23 (Q15921). Errores detectados en almacenes de obras
                          Modificaciones
                              - CreatePurchaseReturnShipmentOutQuantityStock
                              - CreatePurchaseRcpttOutQuantityStock
                              - CreateVendorDetailedLedger: Modificado el primer par�metro de la funci�n
                                  VAR PurchRcptLine : Record "Purch. Rcpt. Line" --> JobNo : Code[20]
                              - AccountingNote_Init: Modificado el par�metro de la funci�n
                                  VAR PurchRcptLine : Record "Purch. Rcpt. Line" --> DocumentNo: Code[20]
                              - AccountingNote_Forecast
                              - AccountingNote_End:
                                  Eliminado el par�metro
                                    PurchRptLine
                                  A�adidos los par�metros
                                    JobNo
                                    JobTaskNo
                                    PieceWorkNo
                                    ShortcutDimension1Code
                                    ShortcutDimension2Code
                                    DimensionSetID
                              - PostAdjmt
                                  Eliminado el par�metro PurchRcptLine
                                  A�adidos los par�metros
                                    DocumentNo
                                    CurrencyCode
                                    ShortcutDimension1Code
                                    ShortcutDimension2Code
                                    DimensionSetID


                          Nueva funci�n
                              - CreatePurchaseReturnShipmentOutQuantityStock
                              - ActivateReturnShipment
                              - ActivateReturnShipmentLine
                              - DeactivateReturnShipment
                              - DeactivateReturnShipmentLine
                              - CreateReturnShipmentJobJournal
                              - ReturnShipmentJobJournal_Init
                              - ReturnShipmentJobJournal_End
                              - CreateAdjustReturnShipmentJobJournal
                              - CreateReturnShipmentAccountingNotes
                              - ReturnShipmentAccountingNote_Forecast
                              - ReturnShipmentAccountingNote_Expense
                              - CreateAdjustReturnShipmentAccountingNotes
      AML QB_ST01 Cambiar el contador de lineas de los albaranes de salida.
      JAV 31/05/22: - QB 1.10.46 Se cambia de lugar el poner la descripci�n de la l�nea para que lo haga correctamente
      AML 23/06/22: - QB 1.10.52 Se da permiso a la tabla "Value entry"
      JAV 04/07/22: - QB 1.10.48 A�adir en el registro de movimiento del proyecto el nombre del proveedor
      AML 04/08/22: - QB 1.11.01 Correccion para llevar las dimensiones
      AML 04/05/23:   Q19430 Correcci�n para ajustar cuando la factura tiene un importe diferente al de albar�n.
      AML 15/05/23:   QB_ST01.1 Ajuste para que no registre como pedido almac�n si no est� informada la unidad coste almac�n.
      AML 03/07/23: - Q19771 Correccion para que no desprovisione las facturas que no vienen de albaranes.
      AML 07/07/23: - Q19877 Correccion de Q19430
      AML 03/10/23: - Q20221 Informar la fecha de solicitud en los albaranes de salida.
      AML 09/10/23: - Q20265 Ajuste 19430
      AML 24/10/23: - Q20364 Abonos
    }
END.*/
}







