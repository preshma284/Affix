Codeunit 7238188 "QPR - Table - Subscriber"
{


    trigger OnRun()
    BEGIN
    END;

    LOCAL PROCEDURE "----------------------------------------------------------------------- T81 Diario Contable"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterValidateEvent, 'Piecework Code', true, true)]
    LOCAL PROCEDURE TabGenJournalLine_OnAfterValidateEvent_PieceworkCode(VAR Rec: Record 81; VAR xRec: Record 81; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        PurchaseLine: Record 39;
        FunctionQB: Codeunit 7207272;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //QPR_15435+
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            IF (Rec."Piecework Code" <> '') THEN BEGIN
                QuoBuildingSetup.GET;
                //Solo si est� marcado crear Valor Dimensi�n = Partida
                IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN BEGIN
                    CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) OF
                        1:
                            Rec.VALIDATE("Shortcut Dimension 1 Code", Rec."Piecework Code");
                        2:
                            Rec.VALIDATE("Shortcut Dimension 2 Code", Rec."Piecework Code");
                    END;
                END;
                //Solo si est� marcado crear grupo registro = Partida
                IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN BEGIN
                    Rec.VALIDATE("Posting Group", Rec."Piecework Code");
                    Rec.VALIDATE("Gen. Prod. Posting Group", Rec."Piecework Code");
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterValidateEvent, 'Gen. Bus. Posting Group', true, true)]
    LOCAL PROCEDURE TabGenJournalLine_OnAfterValidateEvent_GenBusPostingGroup(VAR Rec: Record 81; VAR xRec: Record 81; CurrFieldNo: Integer);
    BEGIN
        //QPR_15433+
        TabGenJournalLine_ValidatePostingGroup(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterValidateEvent, 'Gen. Prod. Posting Group', true, true)]
    LOCAL PROCEDURE TabGenJournalLine_OnAfterValidateEvent_GenProdPostingGroup(VAR Rec: Record 81; VAR xRec: Record 81; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        QuoBuildingSetup: Record 7207278;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
    BEGIN
        //QPR_15456-
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            QuoBuildingSetup.GET;
            IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN BEGIN
                IF (Rec."Gen. Prod. Posting Group" <> '') AND (Rec."Gen. Prod. Posting Group" <> Rec."Piecework Code") THEN
                    ERROR(Text000, Rec.FIELDCAPTION("Gen. Prod. Posting Group"), Rec.FIELDCAPTION("Piecework Code"));
            END;
        END;
        //QPR_15456+
        //QPR_15433+
        TabGenJournalLine_ValidatePostingGroup(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterValidateEvent, 'Shortcut Dimension 1 Code', true, true)]
    LOCAL PROCEDURE TabGenJournalLine_OnAfterValidateEvent_ShortcutDimension1(VAR Rec: Record 81; VAR xRec: Record 81; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        QuoBuildingSetup: Record 7207278;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
    BEGIN
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            QuoBuildingSetup.GET;
            IF (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Resource) THEN
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) = 1 THEN
                    IF ((Rec."Shortcut Dimension 1 Code" <> '') AND (Rec."Piecework Code" <> '')) AND (Rec."Shortcut Dimension 1 Code" <> Rec."Piecework Code") THEN
                        ERROR(Text000, Rec.FIELDCAPTION("Shortcut Dimension 1 Code"), Rec.FIELDCAPTION("Piecework Code"));
        END;
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterValidateEvent, 'Shortcut Dimension 2 Code', true, true)]
    LOCAL PROCEDURE TabGenJournalLine_OnAfterValidateEvent_ShortcutDimension2(VAR Rec: Record 81; VAR xRec: Record 81; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        QuoBuildingSetup: Record 7207278;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
    BEGIN
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            QuoBuildingSetup.GET;
            IF (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Resource) THEN
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) = 2 THEN
                    IF ((Rec."Shortcut Dimension 2 Code" <> '') AND (Rec."Piecework Code" <> '')) AND (Rec."Shortcut Dimension 2 Code" <> Rec."Piecework Code") THEN
                        ERROR(Text000, Rec.FIELDCAPTION("Shortcut Dimension 2 Code"), Rec.FIELDCAPTION("Piecework Code"));
        END;
    END;

    PROCEDURE TabGenJournalLine_ValidatePostingGroup(VAR Rec: Record 81);
    VAR
        Job: Record 167;
        DimensionValue: Record 349;
        GeneralPostingSetup: Record 252;
        FunctionQB: Codeunit 7207272;
        QuoBuildingSetup: Record 7207278;
        JobNo: Code[20];
    BEGIN
        //QPR_15433+
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            //Solo si est� marcado crear grupo registro = Partida
            QuoBuildingSetup.GET;
            IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN BEGIN
                IF DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."Gen. Prod. Posting Group") THEN BEGIN
                    IF GeneralPostingSetup.GET(Rec."Gen. Bus. Posting Group", Rec."Gen. Prod. Posting Group") THEN BEGIN
                        JobNo := Rec."Job No.";
                        Rec.VALIDATE("Account Type", Rec."Account Type"::"G/L Account");
                        CASE DimensionValue.Type OF
                            DimensionValue.Type::Income:
                                Rec.VALIDATE("Account No.", GeneralPostingSetup."Sales Account");
                            DimensionValue.Type::Expenses:
                                Rec.VALIDATE("Account No.", GeneralPostingSetup."Purch. Account");
                        END;
                        Rec.VALIDATE("Job No.", JobNo);
                    END;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------------------------------------- T36 Cab. Venta"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, 'QB Budget item', true, true)]
    LOCAL PROCEDURE TabSalesHeader_OnAfterValidateEvent_QBBudgetitem(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        SalesLine: Record 37;
        DimensionValue: Record 349;
        QB_SalesLineExt: Record 7238727;
        Text001: TextConst ESP = '�Desea traspasar el campo %1 a las l�neas del documento?';
        QBSalesHeaderExt: Record 7238726;
        FunctionQB: Codeunit 7207272;
        Result: Boolean;
    BEGIN
        //JAV 23/05/22: - QRE 0.00.15 Se elimina el traspaso a las l�neas

        //QPR_15434+ Validate de la Partida Presupuestaria
        // IF NOT FunctionQB.AccessToBudgets() THEN
        //  EXIT;
        //
        // IF (FunctionQB.Job_IsBudget(Rec."QB Job No.")) THEN BEGIN
        //  IF (Rec."QB Budget item" <> xRec."QB Budget item") THEN BEGIN
        //    SalesLine.RESET;
        //    SalesLine.SETRANGE("Document No.", Rec."No.");
        //    SalesLine.SETRANGE("Document Type", Rec."Document Type");
        //    SalesLine.SETFILTER(Type,'%1|%2',SalesLine.Type::Item,SalesLine.Type::Resource);
        //    IF SalesLine.FINDSET THEN
        //      Result := CONFIRM(Text001, TRUE, Rec.FIELDCAPTION("QB Budget item"));
        //
        //    IF Rec."QB Budget item" <> '' THEN BEGIN
        //      IF (DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."QB Budget item")) THEN BEGIN
        //        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) = 1 THEN
        //          Rec.VALIDATE("Shortcut Dimension 1 Code",Rec."QB Budget item")
        //        ELSE
        //          Rec.VALIDATE("Shortcut Dimension 2 Code",Rec."QB Budget item");
        //      END;
        //
        //      IF Result THEN BEGIN
        //        REPEAT
        //          SalesLine.VALIDATE("QB_Piecework No.", Rec."QB Budget item");
        //          SalesLine.MODIFY;
        //        UNTIL SalesLine.NEXT = 0;
        //      END
        //    END;
        //  END;
        // END;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "QB Job No.", true, true)]
    LOCAL PROCEDURE TabSalesHeader_OnAfterValidateEvent_QBJobNo(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        SalesLine: Record 37;
        Text000: TextConst ENU = 'Va a cambiar el campo %1, esto provocar� que se eliminen las l�neas, �desea continuar?';
        Text001: TextConst ENU = 'No se cambiar� el valor del campo %1.';
    BEGIN
        //JAV 23/05/22: - QRE 0.00.15 Se elimina el traspaso a las l�neas

        // IF Rec."QB Job No." <> xRec."QB Job No." THEN BEGIN
        //  SalesLine.RESET;
        //  SalesLine.SETRANGE("Document No.", Rec."No.");
        //  SalesLine.SETRANGE("Document Type", Rec."Document Type");
        //  IF NOT SalesLine.ISEMPTY THEN BEGIN
        //    IF CONFIRM(STRSUBSTNO(Text000,Rec.FIELDCAPTION("QB Job No."))) THEN BEGIN
        //      SalesLine.DELETEALL;
        //      Rec.VALIDATE("QB Budget item",'');
        //    END ELSE
        //      ERROR(Text001,Rec.FIELDCAPTION("QB Job No."));
        //  END ELSE
        //    Rec.VALIDATE("QB Budget item",'');
        // END;
    END;

    LOCAL PROCEDURE "----------------------------------------------------------------------- T37 Lin.Venta"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, 'QB_Piecework No.', true, true)]
    LOCAL PROCEDURE TabSalesLine_OnAfterValidateEvent_QBPieceworkNo(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        QuoBuildingSetup: Record 7207278;
        DataPieceworkForProduction: Record 7207386;
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
        QBSalesLineExt: Record 7238727;
        Resource: Record 156;
        Item: Record 27;
        existResourceItem: Boolean;
        DimensionValue: Record 349;
    BEGIN
        //QPR_15456+ Validate del campo de la unidad de obra/Partida presupuestaria
        IF NOT (FunctionQB.AccessToBudgets OR FunctionQB.AccessToRealEstate) THEN
            EXIT;

        GetSalesLineExt(QBSalesLineExt, Rec.RECORDID);
        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            QuoBuildingSetup.GET;

            IF Rec.Type = Rec.Type::Resource THEN BEGIN
                IF Resource.GET(Rec."QB_Piecework No.") THEN BEGIN
                    Rec.VALIDATE("No.", Rec."QB_Piecework No.");

                    IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN
                        IF (DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."QB_Piecework No.")) THEN
                            CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) OF
                                1:
                                    Rec.VALIDATE("Shortcut Dimension 1 Code", Rec."QB_Piecework No.");
                                2:
                                    Rec.VALIDATE("Shortcut Dimension 2 Code", Rec."QB_Piecework No.");
                            END;

                    IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN
                        IF (Rec."Posting Group" <> Rec."QB_Piecework No.") THEN
                            Rec.VALIDATE("Posting Group", Rec."QB_Piecework No.");
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, 'No.', true, true)]
    LOCAL PROCEDURE TabSalesLine_OnAfterValidateEvent_No(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        QBSalesLineExt: Record 7238727;
        DimensionValue: Record 349;
        SalesHeader: Record 36;
    BEGIN
        //QPR_15456+
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        GetSalesLineExt(QBSalesLineExt, Rec.RECORDID);
        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            QuoBuildingSetup.GET;
            IF Rec.Type = Rec.Type::Resource THEN BEGIN
                IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN
                    IF (DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."QB_Piecework No.")) THEN
                        CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) OF
                            1:
                                Rec.VALIDATE("Shortcut Dimension 1 Code", Rec."QB_Piecework No.");
                            2:
                                Rec.VALIDATE("Shortcut Dimension 2 Code", Rec."QB_Piecework No.");
                        END;

                Rec."QB_Piecework No." := Rec."No.";

                IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN
                    IF (Rec."Posting Group" <> Rec."QB_Piecework No.") THEN
                        Rec.VALIDATE("Posting Group", Rec."QB_Piecework No.");
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, 'Shortcut Dimension 1 Code', true, true)]
    LOCAL PROCEDURE TabSalesLine_OnAfterValidateEvent_ShortcutDimension1Code(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        QuoBuildingSetup: Record 7207278;
        DimensionValue: Record 349;
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
        QBSalesLineExt: Record 7238727;
    BEGIN
        //QPR_15456+
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        GetSalesLineExt(QBSalesLineExt, Rec.RECORDID);
        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            QuoBuildingSetup.GET;
            IF Rec.Type = Rec.Type::Resource THEN
                IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN
                    IF (DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."No.")) THEN BEGIN
                        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) = 1 THEN BEGIN
                            IF (Rec."Shortcut Dimension 1 Code" <> '') AND (Rec."Shortcut Dimension 1 Code" <> Rec."No.") THEN
                                ERROR(Text000, Rec.FIELDCAPTION("Shortcut Dimension 1 Code"), Rec.FIELDCAPTION("No."));
                        END;
                    END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, 'Shortcut Dimension 2 Code', true, true)]
    LOCAL PROCEDURE TabSalesLine_OnAfterValidateEvent_ShortcutDimension2Code(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
    BEGIN
        //QPR_15456+
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            QuoBuildingSetup.GET;
            IF (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Resource) THEN
                IF Rec.Type = Rec.Type::Resource THEN
                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) = 2 THEN
                        IF (Rec."Shortcut Dimension 2 Code" <> '') AND (Rec."Shortcut Dimension 2 Code" <> Rec."No.") THEN
                            ERROR(Text000, Rec.FIELDCAPTION("Shortcut Dimension 2 Code"), Rec.FIELDCAPTION("No."));
        END;
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, 'Gen. Prod. Posting Group', true, true)]
    LOCAL PROCEDURE TabSalesLine_OnAfterValidateEvent_GenProdPostingGroup(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
    BEGIN
        //QPR_15456+
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            QuoBuildingSetup.GET;
            IF (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Resource) THEN
                IF Rec.Type = Rec.Type::Resource THEN
                    IF (Rec."Gen. Prod. Posting Group" <> '') AND (Rec."Gen. Prod. Posting Group" <> Rec."No.") THEN
                        ERROR(Text000, Rec.FIELDCAPTION("Gen. Prod. Posting Group"), Rec.FIELDCAPTION("No."));
        END;
    END;

    [EventSubscriber(ObjectType::Table, 37, OnValidateNoOnCopyFromTempSalesLine, '', true, true)]
    LOCAL PROCEDURE TabSalesLine_OnValidateNoOnCopyFromTempSalesLine(VAR SalesLine: Record 37; VAR TempSalesLine: Record 37 TEMPORARY);
    VAR
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        QBSalesLineExt: Record 7238727;
    BEGIN
        //JAV 27/10/21: - QPR 0.00.02 Nuevos campos al copiar del temporal guardado al validar el campo No.
        IF (FunctionQB.Job_IsBudget(SalesLine."Job No.")) THEN BEGIN
            SalesLine."QB_Piecework No." := TempSalesLine."QB_Piecework No.";
        END;
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterInitHeaderDefaults, '', true, true)]
    LOCAL PROCEDURE TabSalesLine_OnAfterInitHeaderDefaults(VAR SalesLine: Record 37; SalesHeader: Record 36);
    VAR
        Job: Record 167;
        QuoBuildingSetup: Record 7207278;
        DataPieceworkForProduction: Record 7207386;
        FunctionQB: Codeunit 7207272;
        QBSalesHeaderExt: Record 7238726;
        QBSalesLineExt: Record 7238727;
    BEGIN
        //JAV 27/10/21: - QPR 0.00.02 Nuevos campos al inicializar el registro tras validar el campo No.
        IF (FunctionQB.Job_IsBudget(SalesLine."Job No.")) THEN BEGIN
            SalesLine."Job No." := SalesHeader."QB Job No.";
            SalesLine."QB_Piecework No." := SalesHeader."QB Budget item";
            //Solo si est� marcado crear Valor Recurso = Partida
            QuoBuildingSetup.GET;
            IF (SalesLine.Type = SalesLine.Type::Resource) AND (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Resource) THEN BEGIN
                IF (DataPieceworkForProduction.GET(SalesLine."Job No.", SalesLine."No.")) THEN
                    SalesLine."QB_Piecework No." := SalesLine."No.";
            END;
        END;
    END;

    // [EventSubscriber(ObjectType::Table, 37, OnAfterCreateDimTableIDs, '', true, true)]
    LOCAL PROCEDURE TabSalesLine_OnAfterCreateDimTableIDs(VAR SalesLine: Record 37; FieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR No: ARRAY[10] OF Code[20]);
    VAR
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        DataPieceworkForProduction: Record 7207386;
        i: Integer;
        QBSalesLineExt: Record 7238727;
    BEGIN
        //JAV 27/10/21: - QPR 0.00.02 A¤adir la dimensi¢n u.o. en el documento de compra
        IF (FunctionQB.Job_IsBudget(SalesLine."Job No.")) THEN BEGIN
            IF (DataPieceworkForProduction.GET(SalesLine."Job No.", SalesLine."QB_Piecework No.")) THEN BEGIN
                FOR i := 1 TO ARRAYLEN(TableID) DO
                    IF (TableID[i] = 0) OR (TableID[i] = DATABASE::Job) THEN BEGIN
                        TableID[i] := DATABASE::Job;
                        No[i] := SalesLine."Job No.";
                        EXIT;
                    END;
            END;
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------------------------------------- T39 Cab. Compra"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, 'QB Budget item', true, true)]
    LOCAL PROCEDURE TabPurchaseHeader_OnAfterValidateEvent_QBBudgetitem(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        PurchaseLine: Record 39;
        DimensionValue: Record 349;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ESP = '�Desea traspasar el campo %1 a las l�neas del documento?';
        Result: Boolean;
    BEGIN
        //JAV 23/05/22: - QRE 0.00.15 Se elimina el traspaso a las l�neas

        //QPR_15434+ Validate de la Partida Presupuestaria
        // IF (FunctionQB.Job_IsBudget(Rec."QB Job No.")) THEN BEGIN
        //  IF (Rec."QB Budget item" <> xRec."QB Budget item") THEN BEGIN
        //    PurchaseLine.RESET;
        //    PurchaseLine.SETRANGE("Document No.", Rec."No.");
        //    PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
        //    PurchaseLine.SETFILTER(Type,'%1|%2',PurchaseLine.Type::Item,PurchaseLine.Type::Resource);
        // //RE15469-LCG-020222-INI
        //    PurchaseLine.SETFILTER("Job No.",'<>%1','');
        // //RE15469-LCG-020222-FIN
        //    IF PurchaseLine.FINDSET THEN
        //      Result := CONFIRM(Text001, TRUE, Rec.FIELDCAPTION("QB Budget item"));
        //
        //    IF Rec."QB Budget item" <> '' THEN BEGIN
        //      IF (DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."QB Budget item")) THEN BEGIN
        //        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) = 1 THEN
        //          Rec.VALIDATE("Shortcut Dimension 1 Code",Rec."QB Budget item")
        //        ELSE
        //          Rec.VALIDATE("Shortcut Dimension 2 Code",Rec."QB Budget item");
        //      END;
        //
        //      IF Result THEN
        //        REPEAT
        //          PurchaseLine.VALIDATE("Piecework No.", Rec."QB Budget item");
        //          PurchaseLine.MODIFY;
        //        UNTIL PurchaseLine.NEXT = 0;
        //    END;
        //  END;
        // END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "QB Job No.", true, true)]
    LOCAL PROCEDURE TabPurchaseHeader_OnAfterValidateEvent_QBJobNo(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        Text000: TextConst ENU = 'Va a cambiar el campo %1, esto provocar� que se eliminen las l�neas, �desea continuar?';
        Text001: TextConst ENU = 'No se cambiar� el valor del campo %1.';
        PurchaseLine: Record 39;
    BEGIN
        //JAV 23/05/22: - QRE 0.00.15 Se elimina el traspaso a las l�neas
        //
        // IF Rec."QB Job No." <> xRec."QB Job No." THEN BEGIN
        //  PurchaseLine.RESET;
        //  PurchaseLine.SETRANGE("Document No.", Rec."No.");
        //  PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
        //  IF NOT PurchaseLine.ISEMPTY THEN BEGIN
        //    IF CONFIRM(STRSUBSTNO(Text000,Rec.FIELDCAPTION("QB Job No."))) THEN BEGIN
        //      PurchaseLine.DELETEALL;
        //      Rec.VALIDATE("QB Budget item",'');
        //    END ELSE
        //      ERROR(Text001,Rec.FIELDCAPTION("QB Job No."));
        //  END ELSE
        //    Rec.VALIDATE("QB Budget item",'');
        // END;
    END;

    LOCAL PROCEDURE "----------------------------------------------------------------------- T39 Lin. Compra"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, 'Piecework No.', true, true)]
    LOCAL PROCEDURE TabPurchaseLine_OnAfterValidateEvent_PieceworkNo(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
        PurchaseHeader: Record 38;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
        Resource: Record 156;
        Item: Record 27;
        existResourceItem: Boolean;
        Vendor: Record 23;
        DimensionValue: Record 349;
    BEGIN
        //JAV 23/05/22: - QRE 0.00.15 Se elimina el validate en esta CU

        //QPR_15456+ Validate del campo de la unidad de obra/Partida presupuestaria
        // IF NOT FunctionQB.AccessToBudgets() THEN
        //  EXIT;
        //
        // IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
        //  QuoBuildingSetup.GET;
        //
        //  //RE16220-LCG-260122-INI
        //  IF Vendor.GET(Rec."Buy-from Vendor No.") THEN
        //    IF Vendor."IC Partner Code" <> '' THEN
        //      EXIT;
        //  //RE16220-LCG-260122-FIN
        //
        //  IF Rec.Type = Rec.Type::Resource THEN BEGIN
        //    IF Resource.GET(Rec."Piecework No.") THEN BEGIN
        //      Rec.VALIDATE("No.", Rec."Piecework No.");
        //
        //      IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN
        //        IF (DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."Piecework No.")) THEN
        //          CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) OF
        //            1 : Rec.VALIDATE("Shortcut Dimension 1 Code", Rec."Piecework No.");
        //            2 : Rec.VALIDATE("Shortcut Dimension 2 Code", Rec."Piecework No.");
        //          END;
        //
        //      IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN
        //        IF (Rec."Posting Group" <> Rec."Piecework No.") THEN
        //          Rec.VALIDATE("Posting Group", Rec."Piecework No.");
        //    END;
        //  END;
        // END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, 'No.', true, true)]
    LOCAL PROCEDURE TabPurchaseLine_OnAfterValidateEvent_No(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        PurchaseHeader: Record 38;
        QuoBuildingSetup: Record 7207278;
        DimensionValue: Record 349;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 23/05/22: - QRE 0.00.15 Se elimina el validate en esta CU

        //QPR_15456+
        // IF NOT FunctionQB.AccessToBudgets() THEN
        //  EXIT;
        //
        // IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
        //  QuoBuildingSetup.GET;
        //  IF Rec.Type = Rec.Type::Resource THEN BEGIN
        //    IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN
        //      IF (DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."Piecework No.")) THEN
        //        CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) OF
        //          1 : Rec.VALIDATE("Shortcut Dimension 1 Code", Rec."Piecework No.");
        //          2 : Rec.VALIDATE("Shortcut Dimension 2 Code", Rec."Piecework No.");
        //        END;
        //
        //    Rec."Piecework No." := Rec."No.";
        //
        //    IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN
        //      IF (Rec."Posting Group" <> Rec."Piecework No.") THEN
        //        Rec.VALIDATE("Posting Group", Rec."Piecework No.");
        //  END;
        // END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, 'Shortcut Dimension 1 Code', true, true)]
    LOCAL PROCEDURE TabPurchaseLine_OnAfterValidateEvent_ShortcutDimension1Code(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        PurchaseHeader: Record 38;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
    BEGIN
        //JAV 23/05/22: - QRE 0.00.15 Se elimina el validate en esta CU

        //QPR_15456+
        // IF NOT FunctionQB.AccessToBudgets() THEN
        //  EXIT;
        //
        // IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
        //  QuoBuildingSetup.GET;
        //  IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN BEGIN
        //    IF (Rec.Type = Rec.Type::Resource) AND (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) = 1) THEN
        //      IF (Rec."Shortcut Dimension 1 Code" <> '') AND (Rec."Shortcut Dimension 1 Code" <> Rec."No.") THEN
        //        ERROR(Text000,Rec.FIELDCAPTION("Shortcut Dimension 1 Code"), Rec.FIELDCAPTION("No."));
        //  END;
        // END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, 'Shortcut Dimension 2 Code', true, true)]
    LOCAL PROCEDURE TabPurchaseLine_OnAfterValidateEvent_ShortcutDimension2Code(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        PurchaseHeader: Record 38;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
    BEGIN
        //JAV 23/05/22: - QRE 0.00.15 Se elimina el validate en esta CU

        //QPR_15456+
        // IF NOT FunctionQB.AccessToBudgets() THEN
        //  EXIT;
        //
        // IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
        //  QuoBuildingSetup.GET;
        //  IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN BEGIN
        //    IF (Rec.Type = Rec.Type::Resource) AND (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) = 2) THEN
        //      IF (Rec."Shortcut Dimension 2 Code" <> '') AND (Rec."Shortcut Dimension 2 Code" <> Rec."No.") THEN
        //        ERROR(Text000,Rec.FIELDCAPTION("Shortcut Dimension 1 Code"), Rec.FIELDCAPTION("No."));
        //  END;
        // END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, 'Gen. Prod. Posting Group', true, true)]
    LOCAL PROCEDURE TabPurchaseLine_OnAfterValidateEvent_GenProdPostingGroup(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        PurchaseHeader: Record 38;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ESP = 'El valor del campo %1 no puede ser distinto del valor del campo %2';
    BEGIN
        //QPR_15456+
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            QuoBuildingSetup.GET;
            IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN BEGIN
                IF (Rec.Type = Rec.Type::Resource) AND (Rec."Gen. Prod. Posting Group" <> '') AND (Rec."Gen. Prod. Posting Group" <> Rec."No.") THEN
                    ERROR(Text000, Rec.FIELDCAPTION("Gen. Prod. Posting Group"), Rec.FIELDCAPTION("No."));
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnValidateNoOnCopyFromTempPurchLine, '', true, true)]
    LOCAL PROCEDURE TabPurchaseLine_OnValidateNoOnCopyFromTempPurchLine(VAR PurchLine: Record 39; TempPurchaseLine: Record 39 TEMPORARY);
    VAR
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 27/10/21: - QPR 0.00.02 Nuevos campos al copiar del temporal guardado al validar el campo No.
        IF (FunctionQB.Job_IsBudget(PurchLine."Job No.")) THEN BEGIN
            PurchLine."Piecework No." := TempPurchaseLine."Piecework No.";
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterInitHeaderDefaults, '', true, true)]
    LOCAL PROCEDURE TabPurchaseLine_OnAfterInitHeaderDefaults(VAR PurchLine: Record 39; PurchHeader: Record 38);
    VAR
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        QuoBuildingSetup: Record 7207278;
        DataPieceworkForProduction: Record 7207386;
        QBPurchaseHeaderExt: Record 7238728;
    BEGIN
        //JAV 23/05/22: - QRE 0.00.15 Se elimina el validate en esta CU

        //JAV 27/10/21: - QPR 0.00.02 Nuevos campos al inicializar el registro tras validar el campo No.
        // IF (FunctionQB.Job_IsBudget(PurchLine."Job No.")) THEN BEGIN
        //  PurchLine."Job No."  := PurchHeader."QB Job No.";
        //  PurchLine."Piecework No." := PurchHeader."QB Budget item";
        //
        //  //Solo si est� marcado crear Valor Recurso = Partida
        //  QuoBuildingSetup.GET;
        //  IF (PurchLine.Type = PurchLine.Type::Resource) AND (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Resource) THEN BEGIN
        //    IF (DataPieceworkForProduction.GET(PurchLine."Job No.", PurchLine."No.")) THEN
        //      PurchLine."Piecework No." := PurchLine."No.";
        //  END;
        // END;
    END;

    // [EventSubscriber(ObjectType::Table, 39, OnAfterCreateDimTableIDs, '', true, true)]
    LOCAL PROCEDURE TabPurchaseLine_OnAfterCreateDimTableIDs(VAR PurchLine: Record 39; FieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR No: ARRAY[10] OF Code[20]);
    VAR
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        DataPieceworkForProduction: Record 7207386;
        i: Integer;
    BEGIN
        //JAV 27/10/21: - QPR 0.00.02 A¤adir la dimensi¢n u.o. en el documento de compra
        IF (FunctionQB.Job_IsBudget(PurchLine."Job No.")) THEN BEGIN
            IF (DataPieceworkForProduction.GET(PurchLine."Job No.", PurchLine."Piecework No.")) THEN BEGIN
                FOR i := 1 TO ARRAYLEN(TableID) DO
                    IF (TableID[i] = 0) OR (TableID[i] = DATABASE::Job) THEN BEGIN
                        TableID[i] := DATABASE::Job;
                        No[i] := PurchLine."Job No.";
                        EXIT;
                    END;
            END;
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------------------------------------- T7207386 Data Piecework"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnBeforeInsertEvent, '', true, true)]
    LOCAL PROCEDURE TabDataPieceworkForProduction_OnBeforeInsertEvent(VAR Rec: Record 7207386; RunTrigger: Boolean);
    BEGIN
        //QPR_15432+
        IF NOT RunTrigger THEN
            EXIT;

        TabDataPieceworkForProduction_CreateData(Rec, TRUE);

        //QPR_15432-
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnBeforeModifyEvent, '', true, true)]
    LOCAL PROCEDURE TabDataPieceworkForProduction_OnBeforeModifyEvent(VAR Rec: Record 7207386; VAR xRec: Record 7207386; RunTrigger: Boolean);
    BEGIN
        //QPR_15432+
        IF NOT RunTrigger THEN
            EXIT;

        IF (Rec."Account Type" = Rec."Account Type"::Heading) AND (Rec."Account Type" = xRec."Account Type"::Unit) THEN  //Era detalle y cambia a mayor, hay que dar bajas
            TabDataPieceworkForProduction_CreateData(Rec, FALSE)
        ELSE
            TabDataPieceworkForProduction_CreateData(Rec, TRUE);

        //QPR_15432-
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE TabDataPieceworkForProduction_OnAfterDeleteEvent(VAR Rec: Record 7207386; RunTrigger: Boolean);
    BEGIN
        //QPR_15432+
        IF NOT RunTrigger THEN
            EXIT;

        TabDataPieceworkForProduction_CreateData(Rec, FALSE)
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterValidateEvent, 'Piecework Code', true, true)]
    LOCAL PROCEDURE TabDataPieceworkForProduction_OnAfterValidateEvent_PieceworkCode(VAR Rec: Record 7207386; VAR xRec: Record 7207386; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        DimensionValue: Record 349;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //QPR_15432+
        IF NOT FunctionQB.AccessToBudgets() THEN
            EXIT;

        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            QuoBuildingSetup.GET;
            IF (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Resource) THEN BEGIN
                IF DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."Piecework Code") THEN BEGIN
                    Rec.Description := DimensionValue.Name;
                    IF DimensionValue.Totaling = '' THEN
                        Rec."Account Type" := Rec."Account Type"::Unit
                    ELSE
                        Rec."Account Type" := Rec."Account Type"::Heading;
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterValidateEvent, Description, true, true)]
    LOCAL PROCEDURE TabDataPieceworkForProduction_OnAfterValidateEvent_Description(VAR Rec: Record 7207386; VAR xRec: Record 7207386; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        DimensionValue: Record 349;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //QPR_15432+
        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            Rec.MODIFY(TRUE);
            IF (Rec."QPR No." <> '') THEN
                Rec.VALIDATE("QPR No.");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterValidateEvent, 'QPR No.', true, true)]
    LOCAL PROCEDURE TabDataPieceworkForProduction_OnAfterValidateEvent_QPRNo(VAR Rec: Record 7207386; VAR xRec: Record 7207386; CurrFieldNo: Integer);
    VAR
        GLAccount: Record 15;
        Resource: Record 156;
        Item: Record 27;
        FunctionQB: Codeunit 7207272;
        Value: Code[20];
    BEGIN
        //QPR_15432+
        IF (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
            CASE Rec."QPR Type" OF
                Rec."QPR Type"::Account:
                    BEGIN
                        IF (GLAccount.GET(Rec."QPR No.")) THEN BEGIN
                            //JAV 04/06/22: - QRE y QPR 1.00.17 Se cambia el uso de la dimensi�n 2 fija por buscar la real
                            //Rec."QPR AC" := GLAccount."Global Dimension 2 Code";                           //TO-DO Esto hay que cambiarlo
                            CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) OF
                                1:
                                    Value := GLAccount."Global Dimension 1 Code";
                                2:
                                    Value := GLAccount."Global Dimension 2 Code";
                                ELSE
                                    Value := '';
                            END;
                            IF (Value <> '') THEN
                                Rec."QPR AC" := Value;
                            Rec."QPR Gen Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
                            Rec."QPR VAT Prod. Posting Group" := GLAccount."VAT Prod. Posting Group";
                        END;
                    END;
                Rec."QPR Type"::Resource:
                    BEGIN
                        IF (Resource.GET(Rec."QPR No.")) THEN BEGIN
                            //JAV 04/06/22: - QRE y QPR 1.00.17 Se cambia el uso de la dimensi�n 2 fija por buscar la real
                            //Rec."QPR AC" := Resource."Global Dimension 2 Code";                           //TO-DO Esto hay que cambiarlo
                            CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) OF
                                1:
                                    Value := Resource."Global Dimension 1 Code";
                                2:
                                    Value := Resource."Global Dimension 2 Code";
                                ELSE
                                    Value := '';
                            END;
                            IF (Value <> '') THEN
                                Rec."QPR AC" := Value;
                            Rec."QPR Gen Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
                            Rec."QPR VAT Prod. Posting Group" := Resource."VAT Prod. Posting Group";
                        END;
                    END;
                Rec."QPR Type"::Item:
                    BEGIN
                        IF (Item.GET(Rec."QPR No.")) THEN BEGIN
                            //JAV 04/06/22: - QRE y QPR 1.00.17 Se cambia el uso de la dimensi�n 2 fija por buscar la real
                            //Rec."QPR AC" := Item."Global Dimension 2 Code";                           //TO-DO Esto hay que cambiarlo
                            CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) OF
                                1:
                                    Value := Item."Global Dimension 1 Code";
                                2:
                                    Value := Item."Global Dimension 2 Code";
                                ELSE
                                    Value := '';
                            END;
                            IF (Value <> '') THEN
                                Rec."QPR AC" := Value;
                            Rec."QPR Gen Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            Rec."QPR VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                        END;
                    END;
            END;
            TabDataPieceworkForProduction_SetAccount(Rec);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterValidateEvent, 'QPR Gen Posting Group', true, true)]
    LOCAL PROCEDURE TabDataPieceworkForProduction_OnAfterValidateEvent_QPRPGenPG(VAR Rec: Record 7207386; VAR xRec: Record 7207386; CurrFieldNo: Integer);
    VAR
        GLAccount: Record 15;
        Resource: Record 156;
        Item: Record 27;
        FunctionQB: Codeunit 7207272;
    BEGIN
        TabDataPieceworkForProduction_SetAccount(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterValidateEvent, 'QPR Gen Prod. Posting Group', true, true)]
    LOCAL PROCEDURE TabDataPieceworkForProduction_OnAfterValidateEvent_QPRPPodPG(VAR Rec: Record 7207386; VAR xRec: Record 7207386; CurrFieldNo: Integer);
    VAR
        GLAccount: Record 15;
        Resource: Record 156;
        Item: Record 27;
        FunctionQB: Codeunit 7207272;
    BEGIN
        TabDataPieceworkForProduction_SetAccount(Rec);
    END;

    PROCEDURE TabDataPieceworkForProduction_CreateData(VAR Rec: Record 7207386; AltaMod: Boolean);
    VAR
        Job: Record 167;
        GenProductPostingGroup: Record 251;
        DimensionValue: Record 349;
        Resource: Record 156;
        ResourceUnitofMeasure: Record 205;
        Item: Record 27;
        itemUnitofMeasure: Record 5404;
        DataPieceworkForProduction: Record 7207386;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        QBTableSubscriber: Codeunit 7207347;
        TypeIG: Integer;
        Text000: TextConst ESP = '�Desea cambiar el valor del campo %1 de las tablas relacionadas?';
        Text001: TextConst ESP = 'Seleccione tipo de Partida Presupuestaria';
        Text002: TextConst ESP = 'Gasto,Ingreso';
        Text003: TextConst ESP = 'No se crear� la l�nea seleccionada.';
        Existen: Boolean;
        ChangeDes: Boolean;
    BEGIN
        //QPR_15432+ Este proceso crea o modificad datos en las tablas relacionadas al dar de alta o modificar una partida presupuestaria

        //Verificar condiciones para hacer este proceso
        IF (NOT FunctionQB.Job_IsBudget(Rec."Job No.")) THEN
            EXIT;

        QuoBuildingSetup.GET;

        //Si queremos dar altas o modificaciones
        IF (AltaMod) THEN BEGIN

            //Si no est�n informados estos valores los informo con el valor de configuraci�n por defecto si son de tipo unidad
            IF Rec."Account Type" = Rec."Account Type"::Unit THEN BEGIN
                IF (Rec."QPR Gen Posting Group" = '') THEN
                    Rec."QPR Gen Posting Group" := QuoBuildingSetup."QB_QPR Gen. Business Post. Gr.";
                IF (Rec."VAT Prod. Posting Group" = '') THEN
                    Rec."VAT Prod. Posting Group" := QuoBuildingSetup."QB_QPR VAT Product Post. Gr.";
            END;

            //Ver si ha cambiado la descripcion
            ChangeDes := FALSE;
            IF DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."Piecework Code") THEN BEGIN
                IF (DimensionValue.Name = '') THEN
                    ChangeDes := TRUE
                ELSE IF (Rec.Description <> '') AND (Rec.Description <> DimensionValue.Name) THEN
                    ChangeDes := CONFIRM(STRSUBSTNO(Text000, Rec.FIELDCAPTION(Description)));
            END;

            //Modificar o crear el Valor de dimensi�n para C.A.
            IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN BEGIN
                IF DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."Piecework Code") THEN BEGIN
                    IF (ChangeDes) THEN
                        DimensionValue.Name := Rec.Description;

                    CASE Rec."QPR Use" OF
                        1:
                            DimensionValue.Type := DimensionValue.Type::Expenses;
                        2:
                            DimensionValue.Type := DimensionValue.Type::Income;
                    END;
                    DimensionValue.MODIFY;
                END ELSE BEGIN
                    TypeIG := Rec."QPR Use";
                    IF (TypeIG = 0) THEN BEGIN
                        TypeIG := STRMENU(Text002, 0, Text001);
                        IF (TypeIG = 0) THEN
                            ERROR(Text003);
                    END;

                    DimensionValue.INIT;
                    DimensionValue."Dimension Code" := FunctionQB.ReturnDimCA();
                    DimensionValue.Code := Rec."Piecework Code";
                    DimensionValue.Name := Rec.Description;
                    CASE TypeIG OF
                        1:
                            DimensionValue.Type := DimensionValue.Type::Expenses;
                        2:
                            DimensionValue.Type := DimensionValue.Type::Income;
                    END;

                    IF Rec."Account Type" = Rec."Account Type"::Unit THEN BEGIN
                        DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
                        DimensionValue.Totaling := '';
                    END ELSE BEGIN
                        DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Heading;
                        DimensionValue.Totaling := Rec."Piecework Code" + '..' + PADSTR(Rec."Piecework Code", MAXSTRLEN(Rec."Piecework Code"), '9')
                    END;

                    DimensionValue.INSERT(TRUE);

                    CASE TypeIG OF
                        1:
                            Rec."QPR Use" := Rec."QPR Use"::Gasto;
                        2:
                            Rec."QPR Use" := Rec."QPR Use"::Ingreso;
                    END;
                END;
            END;

            //Estas tablas no se crean para unidades de mayor
            IF Rec."Account Type" = Rec."Account Type"::Unit THEN BEGIN

                //Modificar o crear el Valor del grupo contable de producto
                IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN BEGIN
                    IF GenProductPostingGroup.GET(Rec."Piecework Code") THEN BEGIN
                        IF (ChangeDes) THEN BEGIN
                            GenProductPostingGroup.Description := Rec.Description;
                            GenProductPostingGroup.MODIFY;
                        END;
                    END ELSE BEGIN
                        GenProductPostingGroup.INIT;
                        GenProductPostingGroup.VALIDATE(Code, Rec."Piecework Code");
                        GenProductPostingGroup.VALIDATE(Description, Rec.Description);
                        GenProductPostingGroup.INSERT();
                    END;
                    //Lo asocio a la l�nea
                    Rec."QPR Gen Prod. Posting Group" := GenProductPostingGroup.Code;
                END;

                //JAV 04/06/22: - QRE y QPR 1.00.17 Si tienen valores no los debo cambiar autom�ticamente
                IF (Rec."QPR Type" = Rec."QPR Type"::" ") AND (Rec."QPR No." = '') THEN BEGIN

                    //Modificar o crear el registro de Recurso
                    IF (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Resource) THEN BEGIN
                        IF Resource.GET(Rec."Piecework Code") THEN BEGIN
                            IF (ChangeDes) THEN BEGIN
                                Resource.Name := Rec.Description;
                                Resource.MODIFY;
                            END;
                        END ELSE BEGIN
                            Resource.INIT();
                            Resource.VALIDATE("No.", Rec."Piecework Code");
                            Resource.VALIDATE(Type, Resource.Type::PartidaPresupuestaria);
                            Resource.VALIDATE(Name, Rec.Description);
                            Resource.INSERT(TRUE);

                            //Unidad de medida del recurso
                            IF (NOT ResourceUnitofMeasure.GET(Rec."Piecework Code", QuoBuildingSetup."QB_QPR Base UOM")) THEN BEGIN
                                ResourceUnitofMeasure.INIT();
                                ResourceUnitofMeasure.VALIDATE("Resource No.", Rec."Piecework Code");
                                ResourceUnitofMeasure.VALIDATE(Code, QuoBuildingSetup."QB_QPR Base UOM");
                                ResourceUnitofMeasure.INSERT;
                            END;
                            Resource.VALIDATE("Base Unit of Measure", QuoBuildingSetup."QB_QPR Base UOM");
                            Resource.MODIFY();
                        END;

                        //Resto de datos del recurso
                        Resource_SetDim(Resource, Rec."Piecework Code");
                        Resource.VALIDATE("Gen. Prod. Posting Group", Rec."QPR Gen Prod. Posting Group");
                        Resource.VALIDATE("VAT Prod. Posting Group", Rec."QPR VAT Prod. Posting Group");
                        Resource.MODIFY();

                        //Lo asocio a la l�nea
                        Rec."QPR Type" := Rec."QPR Type"::Resource;
                        Rec."QPR No." := Resource."No.";
                    END;

                    //Modificar o crear el registro de producto
                    IF (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Item) THEN BEGIN
                        IF Item.GET(Rec."Piecework Code") THEN BEGIN
                            IF (ChangeDes) THEN BEGIN
                                Item.Description := Rec.Description;
                                Item.MODIFY;
                            END;
                        END ELSE BEGIN
                            Item.INIT();
                            Item.VALIDATE("No.", Rec."Piecework Code");
                            Item.VALIDATE(Type, Item.Type::"Non-Inventory");
                            Item.VALIDATE(Description, Rec.Description);
                            Item.INSERT(TRUE);

                            //Unidad de medida del producto
                            IF (NOT itemUnitofMeasure.GET(Rec."Piecework Code", QuoBuildingSetup."QB_QPR Base UOM")) THEN BEGIN
                                itemUnitofMeasure.INIT();
                                itemUnitofMeasure.VALIDATE("Item No.", Rec."Piecework Code");
                                itemUnitofMeasure.VALIDATE(Code, QuoBuildingSetup."QB_QPR Base UOM");
                                itemUnitofMeasure.INSERT;
                            END;
                            Item.VALIDATE("Base Unit of Measure", QuoBuildingSetup."QB_QPR Base UOM");
                            Item.MODIFY();
                        END;
                        //Resto de datos del producto
                        QBTableSubscriber.Item_SetDim(Item, Rec."Piecework Code");
                        Item.VALIDATE("Gen. Prod. Posting Group", Rec."QPR Gen Prod. Posting Group");
                        Item.VALIDATE("VAT Prod. Posting Group", Rec."QPR VAT Prod. Posting Group");
                        Item.MODIFY();

                        //Lo asocio a la l�nea
                        Rec."QPR Type" := Rec."QPR Type"::Item;
                        Rec."QPR No." := Item."No.";
                    END;
                END;

                IF (Rec."QPR No." <> '') THEN
                    Rec.VALIDATE("QPR No.");
            END;
        END;

        //Si son bajas
        IF (NOT AltaMod) THEN BEGIN
            //Miro si hay mas registros del mismo c�digo en otros proyectos, si los hay dejo los registros
            Existen := FALSE;
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Piecework Code", Rec."Piecework Code");
            DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
            IF (DataPieceworkForProduction.FINDSET) THEN
                REPEAT
                    IF Job.GET(DataPieceworkForProduction."Job No.") THEN
                        Existen := (Job."Card Type" = Job."Card Type"::Presupuesto);
                UNTIL (Existen) OR (DataPieceworkForProduction.NEXT = 0);

            //No hay, elimino los registros que ya no usaremos
            IF (NOT Existen) THEN BEGIN
                IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN BEGIN
                    IF (DimensionValue.GET(FunctionQB.ReturnDimCA(), Rec."Piecework Code")) THEN
                        DimensionValue.DELETE;
                END;
                IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN BEGIN
                    IF (GenProductPostingGroup.GET(Rec."Piecework Code")) THEN
                        GenProductPostingGroup.DELETE;
                END;
                IF (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Resource) THEN BEGIN
                    IF (Resource.GET(Rec."Piecework Code")) THEN
                        Resource.DELETE;
                    IF (ResourceUnitofMeasure.GET(Rec."Piecework Code", QuoBuildingSetup."QB_QPR Base UOM")) THEN
                        ResourceUnitofMeasure.DELETE;
                END;
                IF (QuoBuildingSetup."QB_QPR Create Auto" = QuoBuildingSetup."QB_QPR Create Auto"::Item) THEN BEGIN
                    IF (Item.GET(Rec."Piecework Code")) THEN
                        Item.DELETE;
                    IF (itemUnitofMeasure.GET(Rec."Piecework Code", QuoBuildingSetup."QB_QPR Base UOM")) THEN
                        itemUnitofMeasure.DELETE;
                END;

            END;
        END;
    END;

    LOCAL PROCEDURE TabDataPieceworkForProduction_SetAccount(VAR rec: Record 7207386);
    VAR
        GenBusinessPostingGroup: Record 250;
        GenProductPostingGroup: Record 251;
        GeneralPostingSetup: Record 252;
        DimensionValue: Record 349;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //Verificar condiciones para hacer este proceso
        IF (NOT FunctionQB.Job_IsBudget(rec."Job No.")) THEN
            EXIT;

        rec."QPR Account No" := '';
        CASE rec."QPR Type" OF
            rec."QPR Type"::Account:
                BEGIN
                    rec."QPR Account No" := rec."QPR No.";
                END;
            rec."QPR Type"::Resource, rec."QPR Type"::Item:
                BEGIN
                    IF GeneralPostingSetup.GET(rec."QPR Gen Posting Group", rec."QPR Gen Prod. Posting Group") THEN
                        CASE rec."QPR Use" OF

                            rec."QPR Use"::Gasto:
                                rec."QPR Account No" := GeneralPostingSetup."Purch. Account";
                            rec."QPR Use"::Ingreso:
                                rec."QPR Account No" := GeneralPostingSetup."Sales Account";
                        END;
                END;
        END;

        IF (rec."QPR Account No" <> '') AND (DimensionValue.GET(FunctionQB.ReturnDimCA(), rec."QPR AC")) THEN BEGIN
            IF (DimensionValue."Account Budget E Reestimations" = '') THEN BEGIN
                DimensionValue."Account Budget E Reestimations" := rec."QPR Account No";
                DimensionValue.MODIFY;
            END;
        END;
    END;

    PROCEDURE Resource_SetDim(VAR Rec: Record 156; CA: Code[20]);
    VAR
        FunctionQB: Codeunit 7207272;
        QREFunctions: Codeunit 7238197;
    BEGIN
        //QRE16044-LCG-INI
        IF QREFunctions.ExistValDim(CA) THEN
            EXIT;
        //QRE16044-LCG-FIN
        //JAV 01/11/21: QB 1.09.26 Establecer las dimensiones globales en un registro de tipo RECURSO
        CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) OF
            1:
                Rec.VALIDATE("Global Dimension 1 Code", CA);
            2:
                Rec.VALIDATE("Global Dimension 2 Code", CA);
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------------Procedures"();
    BEGIN
    END;

    LOCAL PROCEDURE GetSalesLineExt(VAR QBSalesLineExt: Record 7238727; rID: RecordID);
    BEGIN
        QBSalesLineExt.RESET();
        QBSalesLineExt.SETRANGE("Record Id", rID);
        IF QBSalesLineExt.FINDFIRST THEN;
    END;

    LOCAL PROCEDURE GetSalesHdrExt(VAR QBSalesHeaderExt: Record 7238726; rID: RecordID);
    BEGIN
        QBSalesHeaderExt.RESET();
        QBSalesHeaderExt.SETRANGE("Record Id", rID);
        IF QBSalesHeaderExt.FINDFIRST THEN;
    END;

    LOCAL PROCEDURE GetPurchLineExt(VAR QBPurchaseLineExt: Record 7238729; rID: RecordID);
    BEGIN
        QBPurchaseLineExt.RESET();
        QBPurchaseLineExt.SETRANGE("Record Id", rID);
        IF QBPurchaseLineExt.FINDFIRST THEN;
    END;

    LOCAL PROCEDURE GetPurchHdrExt(VAR QBPurchaseHeaderExt: Record 7238728; rID: RecordID);
    BEGIN
        QBPurchaseHeaderExt.RESET();
        QBPurchaseHeaderExt.SETRANGE("Record Id", rID);
        IF QBPurchaseHeaderExt.FINDFIRST THEN;
    END;

    /*BEGIN
/*{
      RE15469-LCG-020222- Sino encuentra n� proyecto, no actualiza la l�nea.
    }
END.*/
}







