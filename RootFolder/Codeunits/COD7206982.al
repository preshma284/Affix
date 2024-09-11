Codeunit 7206982 "QB Post Inventory Cost"
{


    Permissions = TableData 32 = rimd,
                TableData 5802 = rimd;
    trigger OnRun()
    BEGIN
        //NumerarValue;
        //NumerarLineas('E_001960');
        ValoracionAjustes('');
    END;

    VAR
        ValueEntry: Record 5802;
        OutputShipmentHeader: Record 7207310;
        OutputShipmentLines: Record 7207311;
        SourceCodeSetup: Record 242;
        SrcCode: Code[20];
        Item: Record 27;
        Job: Record 167;
        Job2: Record 167;
        Job3: Record 167;
        InventoryPostingSetup: Record 5813;
        Location: Record 14;
        DimValue: Record 349;
        GenJournalLine: Record 81;
        GLAccount: Record 15;
        DefaultDimension: Record 352;
        JobJournalLine: Record 210;
        LineaJob: Integer;
        LineaCont: Integer;
        JobJnlPostLine: Codeunit 1012;
        DimMgt: Codeunit 408;
        FunctionQB: Codeunit 7207272;
        NoSeriesMgt: Codeunit 396;
        UpdateItemAnalysisView: Codeunit 7150;
        Ajuste: Boolean;
        Suma: Decimal;
        OutputShipmentHeader2: Record 7207310;
        OutputShipmentLines2: Record 7207311;
        ItemLedgerEntry: Record 32;

    PROCEDURE ValoracionFacturas(Prod: Code[20]);
    VAR
        ValueEntry2: Record 5802;
        ValueEntry3: Record 5802;
    BEGIN
        //Por si la factura cambia de valor.
        ValueEntry.RESET;
        IF Prod <> '' THEN ValueEntry.SETRANGE("Item No.", Prod);
        ValueEntry.SETFILTER("Document Type", '%1|%2', ValueEntry."Document Type"::"Purchase Invoice", ValueEntry."Document Type"::"Purchase Credit Memo");
        ValueEntry.SETRANGE("QB Stocks Adjusted GL", FALSE);
        IF ValueEntry.FINDSET THEN BEGIN
            REPEAT
                //AML 23/06/22: - QB 1.10.52 Condicionar el cambio a que tenga pendiente
                IF ValueEntry."Cost Amount (Actual)" - ValueEntry."Purchase Amount (Expected)" <> 0 THEN BEGIN
                    Ajuste := TRUE;
                    OutputShipmentHeader.RESET;
                    ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.");
                    IF ItemLedgerEntry."QB Stocks Output Shipment No." <> '' THEN BEGIN
                        OutputShipmentHeader.GET(ItemLedgerEntry."QB Stocks Output Shipment No.");
                        Ajuste := FALSE;
                        OutputShipmentLines.RESET;
                        //JAV 02/06/22: QB 1.10.46 Se a�ade la key para mejorar la velocidad
                        OutputShipmentLines.SETCURRENTKEY("Document No.", "No.");
                        OutputShipmentLines.SETRANGE("Document No.", OutputShipmentHeader."No.");
                        OutputShipmentLines.SETRANGE("No.", ValueEntry."Item No.");
                        IF OutputShipmentLines.FINDFIRST THEN
                            REPEAT
                                ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                                IF ValueEntry."Cost Amount (Actual)" - ValueEntry."Cost Amount (Expected)" <> 0 THEN BEGIN //Solo si hay diferencias
                                    Item.GET(ValueEntry."Item No.");
                                    Location.GET(OutputShipmentLines."Outbound Warehouse");

                                    //AML 25/07/22: - QB 1.11.01 Eliminar un control
                                    ////AML 27/05/22: - QB 1.10.45 Condicionar el cambio a que est� activo y cambio de signo que era err�neno
                                    //IF NOT OutputShipmentHeader."Automatic Shipment" THEN
                                    //  GenerateJobEntries(-(ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)"));

                                    CreateGLEntries(ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)");
                                    IF NOT OutputShipmentHeader."Automatic Shipment" THEN GenerateJobEntries(-(ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)"));
                                    IF NOT OutputShipmentLines."Coste Ajustado" THEN BEGIN
                                        OutputShipmentLines."Coste Ajustado" := TRUE;
                                        OutputShipmentLines."Coste Anterior" := OutputShipmentLines."Total Cost";
                                    END;
                                    OutputShipmentLines.Amount := OutputShipmentLines.Amount;
                                    //AML 27/05/22: - QB 1.10.45 Condicionar el cambio a que est� activo y cambio de signo que era err�neno
                                    OutputShipmentLines."Total Cost" := -(ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)");
                                    OutputShipmentLines.MODIFY;
                                END;
                            UNTIL OutputShipmentLines.NEXT = 0;
                    END;
                END;

                ValueEntry2.GET(ValueEntry."Entry No.");
                ValueEntry2."QB Stocks Adjusted GL" := TRUE;
                ValueEntry2."QB Stocks Adjusted Not Found" := Ajuste;
                ValueEntry2.MODIFY;
            UNTIL ValueEntry.NEXT = 0;
        END;
    END;

    PROCEDURE ValoracionAjustes(Prod: Code[20]);
    VAR
        ValueEntry2: Record 5802;
        ValueEntry3: Record 5802;
    BEGIN
        ValueEntry.RESET;
        IF Prod <> '' THEN ValueEntry.SETRANGE("Item No.", Prod);
        ValueEntry.SETRANGE(Adjustment, TRUE);
        ValueEntry.SETRANGE("QB Stocks Adjusted GL", FALSE);
        IF ValueEntry.FINDSET THEN BEGIN
            REPEAT
                Ajuste := TRUE;
                OutputShipmentHeader.RESET;
                ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.");
                IF ItemLedgerEntry."QB Stocks Output Shipment No." <> '' THEN BEGIN
                    OutputShipmentHeader.GET(ItemLedgerEntry."QB Stocks Output Shipment No.");
                    Ajuste := FALSE;
                    OutputShipmentLines.RESET;
                    OutputShipmentLines.SETRANGE("Document No.", OutputShipmentHeader."No.");
                    OutputShipmentLines.SETRANGE("No.", ValueEntry."Item No.");
                    IF OutputShipmentLines.FINDFIRST THEN
                        REPEAT
                            ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                            Item.GET(ValueEntry."Item No.");
                            Location.GET(OutputShipmentLines."Outbound Warehouse");

                            //AML 25/07/22: - QB 1.11.01 Eliminar un control
                            ////AML 27/05/22: - QB 1.10.45 Condicionar el cambio a que est� activo y cambio de signo que era err�neno
                            //IF NOT OutputShipmentHeader."Automatic Shipment" THEN
                            //  GenerateJobEntries(-(ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)"));

                            CreateGLEntries(ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)");
                            IF NOT OutputShipmentHeader."Automatic Shipment" THEN GenerateJobEntries(-(ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)"));
                            IF NOT OutputShipmentLines."Coste Ajustado" THEN BEGIN
                                OutputShipmentLines."Coste Ajustado" := TRUE;
                                OutputShipmentLines."Coste Anterior" := OutputShipmentLines."Total Cost";
                            END;
                            OutputShipmentLines.Amount := OutputShipmentLines.Amount;
                            //AML 27/05/22: - QB 1.10.45 Condicionar el cambio a que est� activo y cambio de signo que era err�neno
                            OutputShipmentLines."Total Cost" := -(ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)");
                            OutputShipmentLines.MODIFY;
                        UNTIL OutputShipmentLines.NEXT = 0;

                END;
                ValueEntry2.GET(ValueEntry."Entry No.");
                ValueEntry2."QB Stocks Adjusted GL" := TRUE;
                ValueEntry2."QB Stocks Adjusted Not Found" := Ajuste;
                ValueEntry2.MODIFY;
            UNTIL ValueEntry.NEXT = 0;
        END;
    END;

    PROCEDURE GenerateJobEntries(Adjust_Cost: Decimal);
    VAR
        PostDate: Date;
        JobJnlPostLine2: Codeunit 50012;
    BEGIN
        //Crear el movimiento de proyecto asociado a la entrada, tanto en el proyecto actual como en el de desviaciones de almac�n
        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup."Output Shipment to Job";

        //Crear el movimiento de proyecto que cancela el anterior
        JobJournalLine.INIT;
        LineaJob += 10000;
        IF ValueEntry.Adjustment THEN BEGIN
            IF (DATE2DMY(ValueEntry."Posting Date", 2) <> DATE2DMY(WORKDATE, 2)) OR (DATE2DMY(ValueEntry."Posting Date", 3) <> DATE2DMY(WORKDATE, 3)) THEN
                PostDate := WORKDATE ELSE
                PostDate := ValueEntry."Posting Date";
        END
        ELSE
            PostDate := ValueEntry."Posting Date";
        JobJournalLine."Journal Template Name" := 'PROYECTO';
        JobJournalLine."Journal Batch Name" := 'GENERICO';
        JobJournalLine."Line No." := LineaJob;
        JobJournalLine."Job No." := OutputShipmentHeader."Job No.";
        JobJournalLine."Job Task No." := OutputShipmentLines."Job Task No.";
        JobJournalLine."Posting Date" := PostDate;
        JobJournalLine."Document Date" := OutputShipmentHeader."Posting Date";
        JobJournalLine."Document No." := OutputShipmentHeader."No.";
        JobJournalLine."External Document No." := OutputShipmentHeader."Purchase Rcpt. No.";
        JobJournalLine.Type := JobJournalLine.Type::Item;
        JobJournalLine."No." := OutputShipmentLines."No.";
        JobJournalLine.Description := COPYSTR('Ajuste ' + OutputShipmentLines.Description, 1, 50);
        JobJournalLine.Quantity := OutputShipmentLines.Quantity;
        IF JobJournalLine.Quantity <> 0 THEN BEGIN
            JobJournalLine.VALIDATE("Unit Cost (LCY)", Adjust_Cost / JobJournalLine.Quantity);
            JobJournalLine."Total Cost (LCY)" := Adjust_Cost;
        END;
        JobJournalLine."Total Cost" := JobJournalLine."Total Cost (LCY)";
        JobJournalLine.Quantity := 1;   //AML 03/05/22: - QB 1.10.38 Cambio en cantidades, pon�a 0 y debe ser 1
        JobJournalLine."Unit of Measure Code" := OutputShipmentLines."Unit of Measure Code";
        JobJournalLine."Qty. per Unit of Measure" := OutputShipmentLines."Unit of Mensure Quantity";
        JobJournalLine."Quantity (Base)" := OutputShipmentLines."Quantity (Base)";
        JobJournalLine."Quantity (Base)" := 1;   //AML 03/05/22: - QB 1.10.38 Cambio en cantidades, pon�a 0 y debe ser 1
        JobJournalLine."Location Code" := OutputShipmentLines."Outbound Warehouse";
        JobJournalLine."Shortcut Dimension 1 Code" := OutputShipmentLines."Shortcut Dimension 1 Code";
        JobJournalLine."Shortcut Dimension 2 Code" := OutputShipmentLines."Shortcut Dimension 2 Code";
        JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
        JobJournalLine."Source Code" := SrcCode;
        Item.GET(OutputShipmentLines."No.");
        JobJournalLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        Job.GET(OutputShipmentHeader."Job No.");
        IF Job."Job Posting Group" <> '' THEN
            JobJournalLine."Posting Group" := Job."Job Posting Group";
        JobJournalLine."Posting No. Series" := OutputShipmentHeader."No.";
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Serial No." := OutputShipmentHeader."No. Series";
        JobJournalLine."Posting No. Series" := OutputShipmentHeader."No.";
        JobJournalLine."Piecework Code" := OutputShipmentLines."Produccion Unit";
        JobJournalLine."Variant Code" := OutputShipmentLines."Variant Code";
        /////////////////////////////////////ENCONTRAR JobJournalLine."Related Item Entry No." := ItemJournalLine."Item Shpt. Entry No.";
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Activation Entry" := TRUE;
        JobJournalLine."Dimension Set ID" := OutputShipmentLines."Dimension Set ID";
        //IF OutputShipmentLines."Job Line Type" = OutputShipmentLines."Job Line Type"::" " THEN
        //JobJournalLine."Line Type" := OutputShipmentLines."Job Line Type"::"Both Budget and Billable"
        //ELSE
        //JobJournalLine."Line Type" := OutputShipmentLines."Job Line Type";
        JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable";
        JobJnlPostLine2.ResetJobLedgEntry();

        JobJnlPostLine.RunWithCheck(JobJournalLine);


        //Crear la l�nea del proyecto de estructura de almac�n
        JobJournalLine.INIT;
        LineaJob += 10000;
        JobJournalLine."Journal Template Name" := 'PROYECTO';
        JobJournalLine."Journal Batch Name" := 'GENERICO';
        JobJournalLine."Line No." := LineaJob;
        JobJournalLine."Dimension Set ID" := OutputShipmentLines."Dimension Set ID";
        Item.GET(OutputShipmentLines."No.");
        InventoryPostingSetup.GET(OutputShipmentLines."Outbound Warehouse", Item."Inventory Posting Group");
        Location.GET(OutputShipmentLines."Outbound Warehouse");
        DimValue.GET(FunctionQB.ReturnDimDpto, Location."QB Departament Code");
        JobJournalLine.VALIDATE("Job No.", DimValue."Job Structure Warehouse");

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, InventoryPostingSetup."App. Account Concept Analytic", JobJournalLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, Location."QB Departament Code",
                                  JobJournalLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID", JobJournalLine."Shortcut Dimension 1 Code", JobJournalLine."Shortcut Dimension 2 Code");

        JobJournalLine."Job Deviation Entry" := TRUE;
        JobJournalLine."Posting Date" := PostDate;
        JobJournalLine."Document Date" := OutputShipmentHeader."Posting Date";
        JobJournalLine."Document No." := OutputShipmentHeader."No.";
        JobJournalLine."External Document No." := OutputShipmentHeader."Purchase Rcpt. No.";
        JobJournalLine."No." := OutputShipmentLines."No.";
        JobJournalLine.Description := COPYSTR('Ajuste ' + OutputShipmentLines.Description, 1, 50);
        JobJournalLine.Type := JobJournalLine.Type::Item;
        JobJournalLine.Quantity := -OutputShipmentLines.Quantity;
        IF JobJournalLine.Quantity <> 0 THEN BEGIN
            JobJournalLine.VALIDATE("Unit Cost (LCY)", -Adjust_Cost / OutputShipmentLines.Quantity);
            JobJournalLine."Total Cost (LCY)" := -Adjust_Cost;
        END;
        JobJournalLine."Total Cost" := JobJournalLine."Total Cost (LCY)";
        JobJournalLine.Quantity := 1;   //AML 03/05/22: - QB 1.10.38 Cambio en cantidades, pon�a 0 y debe ser 1
        JobJournalLine."Unit of Measure Code" := OutputShipmentLines."Unit of Measure Code";
        JobJournalLine."Qty. per Unit of Measure" := OutputShipmentLines."Unit of Mensure Quantity";
        JobJournalLine."Quantity (Base)" := OutputShipmentLines."Quantity (Base)";
        JobJournalLine."Quantity (Base)" := 1;   //AML 03/05/22: - QB 1.10.38 Cambio en cantidades, pon�a 0 y debe ser 1
        JobJournalLine."Location Code" := OutputShipmentLines."Outbound Warehouse";
        JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
        JobJournalLine."Source Code" := SrcCode;
        Item.GET(OutputShipmentLines."No.");
        JobJournalLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        Job.GET(OutputShipmentHeader."Job No.");
        IF Job."Job Posting Group" <> '' THEN
            JobJournalLine."Posting Group" := Job."Job Posting Group";
        JobJournalLine."Posting No. Series" := OutputShipmentHeader."No.";
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Serial No." := OutputShipmentHeader."No. Series";
        JobJournalLine."Posting No. Series" := OutputShipmentHeader."No.";

        Job3.GET(DimValue."Job Structure Warehouse");
        IF Job3."Warehouse Cost Unit" <> '' THEN                                    //JAV 30/03/21: - Se cambia el campo que era err�neo
            JobJournalLine."Piecework Code" := Job3."Warehouse Cost Unit"               //JAV 30/03/21: - Se cambia el campo que era err�neo
        ELSE BEGIN
            IF Job."Warehouse Cost Unit" <> '' THEN
                JobJournalLine."Piecework Code" := Job."Warehouse Cost Unit"              //JAV 30/03/21: - Se cambia el campo que era err�neo
            ELSE
                JobJournalLine."Piecework Code" := OutputShipmentLines."Produccion Unit";
        END;

        IF Job3."Location Task No." <> '' THEN
            JobJournalLine."Job Task No." := Job3."Location Task No."
        ELSE BEGIN
            IF Job."Location Task No." <> '' THEN
                JobJournalLine."Job Task No." := Job."Location Task No."
            ELSE
                JobJournalLine."Job Task No." := OutputShipmentLines."Job Task No."
        END;

        JobJournalLine."Variant Code" := OutputShipmentLines."Variant Code";
        //////////////////////////////Encontrar JobJournalLine."Related Item Entry No." := ItemJournalLine."Item Shpt. Entry No.";
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Activation Entry" := TRUE;


        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, JobJournalLine."Job No.", JobJournalLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, JobJournalLine."Job No."),
                                  JobJournalLine."Dimension Set ID");

        DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
        DefaultDimension.SETRANGE("No.", DimValue."Job Structure Warehouse");
        IF DefaultDimension.FINDSET(FALSE) THEN
            REPEAT
                IF DefaultDimension."Value Posting" = DefaultDimension."Value Posting"::"Same Code" THEN
                    FunctionQB.UpdateDimSet(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code", JobJournalLine."Dimension Set ID");
            UNTIL DefaultDimension.NEXT = 0;

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, InventoryPostingSetup."App. Account Concept Analytic", JobJournalLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID", JobJournalLine."Shortcut Dimension 1 Code", JobJournalLine."Shortcut Dimension 2 Code");
        /*{
              IF OutputShipmentLines."Job Line Type" = OutputShipmentLines."Job Line Type"::" " THEN
                JobJournalLine."Line Type" := OutputShipmentLines."Job Line Type"::"Both Budget and Billable"
              ELSE
                JobJournalLine."Line Type" := OutputShipmentLines."Job Line Type";
              }*/
        JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable";
        JobJnlPostLine2.ResetJobLedgEntry();
        JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    PROCEDURE CreateGLEntries(Adjust_Cost: Decimal);
    VAR
        GenJnlPostLine: Codeunit 12;
        QuoBuildingSetup: Record 7207278;
        DefaultDimension: Record 352;
        PurchasesPayablesSetup: Record 312;
        PostDate: Date;
    BEGIN
        PurchasesPayablesSetup.GET;
        IF PurchasesPayablesSetup."QB Stocks Post Inv.Cost to G/L" THEN EXIT;

        IF ValueEntry.Adjustment THEN BEGIN
            IF (DATE2DMY(ValueEntry."Posting Date", 2) <> DATE2DMY(WORKDATE, 2)) OR (DATE2DMY(ValueEntry."Posting Date", 3) <> DATE2DMY(WORKDATE, 3)) THEN
                PostDate := WORKDATE ELSE
                PostDate := ValueEntry."Posting Date";
        END
        ELSE
            PostDate := ValueEntry."Posting Date";

        //Crear movimiento contable
        InventoryPostingSetupControl(OutputShipmentLines."Outbound Warehouse", Item."Inventory Posting Group");

        GenJournalLine.INIT;
        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD("Delivery Note Batch Book");
        GenJournalLine."Journal Template Name" := QuoBuildingSetup."Delivery Note Book";
        GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Delivery Note Batch Book";

        GenJournalLine."Account No." := InventoryPostingSetup."Location Account Consumption";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
        GenJournalLine."Posting Date" := PostDate;
        GenJournalLine."Document No." := OutputShipmentHeader."No.";
        GenJournalLine."External Document No." := OutputShipmentHeader."Purchase Rcpt. No.";
        GLAccount.GET(InventoryPostingSetup."Location Account Consumption");
        GenJournalLine.Description := GLAccount.Name;
        //AML Correccion 14/11/23
        //GenJournalLine.Amount:=ROUND(-Adjust_Cost,0.01);
        GenJournalLine.VALIDATE(Amount, ROUND(-Adjust_Cost, 0.01));
        //GenJournalLine."Amount (LCY)":=ROUND(-Adjust_Cost,0.01);
        GenJournalLine."Currency Factor" := 1;
        GenJournalLine.Correction := FALSE;
        GenJournalLine."Usage/Sale" := GenJournalLine."Usage/Sale"::Usage;
        GenJournalLine."System-Created Entry" := TRUE;
        GenJournalLine."Source Type" := GenJournalLine."Source Type"::" ";
        GenJournalLine."Shortcut Dimension 1 Code" := OutputShipmentLines."Shortcut Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := OutputShipmentLines."Shortcut Dimension 2 Code";
        GenJournalLine."Job No." := OutputShipmentHeader."Job No.";
        ;
        GenJournalLine."Piecework Code" := OutputShipmentLines."Produccion Unit";
        GenJournalLine."Job Task No." := OutputShipmentLines."Job Task No.";
        GenJournalLine.Quantity := OutputShipmentLines.Quantity;
        GenJournalLine."Posting No. Series" := OutputShipmentHeader."No.";
        GenJournalLine."Already Generated Job Entry" := TRUE;
        GenJournalLine."Source Code" := SrcCode;
        GenJournalLine."Dimension Set ID" := OutputShipmentLines."Dimension Set ID";

        //-AML 24/03/22 QB_ST01 Incluir los campos de QB_ST01
        GenJournalLine."QB Stocks Document Type" := ItemLedgerEntry."QB Stocks Document Type";
        GenJournalLine."QB Stocks Document No" := ItemLedgerEntry."QB Stocks Document No";
        GenJournalLine."QB Stocks Output Shipment Line" := ItemLedgerEntry."QB Stocks Output Shipment Line";
        GenJournalLine."QB Stocks Item No." := ItemLedgerEntry."Item No.";
        GenJournalLine."QB Stocks Output Shipment No." := ItemLedgerEntry."QB Stocks Output Shipment No.";
        //+AML 24/03/22 QB_ST01


        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, InventoryPostingSetup."Analytic Concept", GenJournalLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID", GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code");

        GenJnlPostLine.RunWithCheck(GenJournalLine);


        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := QuoBuildingSetup."Delivery Note Book";
        GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Delivery Note Batch Book";
        GenJournalLine."Account No." := InventoryPostingSetup."App.Account Locat Acc. Consum.";
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
        GenJournalLine."Posting Date" := PostDate;
        GenJournalLine."Document No." := OutputShipmentHeader."No.";
        GenJournalLine.Description := OutputShipmentLines.Description;
        GenJournalLine.Amount := ROUND(Adjust_Cost, 0.01);
        GenJournalLine."Amount (LCY)" := ROUND(Adjust_Cost, 0.01);
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine."External Document No." := OutputShipmentHeader."Purchase Rcpt. No.";
        GLAccount.GET(InventoryPostingSetup."App.Account Locat Acc. Consum.");
        GenJournalLine.Description := GLAccount.Name;
        GenJournalLine."Currency Factor" := 1;
        GenJournalLine.Correction := FALSE;
        GenJournalLine."Usage/Sale" := GenJournalLine."Usage/Sale"::Usage;
        GenJournalLine."System-Created Entry" := TRUE;
        GenJournalLine."Source Type" := GenJournalLine."Source Type"::" ";
        DimValue.GET(FunctionQB.ReturnDimDpto, Location."QB Departament Code");
        GenJournalLine."Job No." := DimValue."Job Structure Warehouse";

        GenJournalLine."Piecework Code" := '';
        GenJournalLine."Job Task No." := '';

        GenJournalLine.Quantity := OutputShipmentLines.Quantity;
        GenJournalLine."Posting No. Series" := OutputShipmentHeader."No.";
        GenJournalLine."Already Generated Job Entry" := TRUE;
        GenJournalLine."Source Code" := SrcCode;

        GenJournalLine."Dimension Set ID" := OutputShipmentLines."Dimension Set ID";

        //-AML 24/03/22 QB_ST01 Incluir los campos de QB_ST01
        GenJournalLine."QB Stocks Document Type" := ItemLedgerEntry."QB Stocks Document Type";
        GenJournalLine."QB Stocks Document No" := ItemLedgerEntry."QB Stocks Document No";
        GenJournalLine."QB Stocks Output Shipment Line" := ItemLedgerEntry."QB Stocks Output Shipment Line";
        GenJournalLine."QB Stocks Item No." := ItemLedgerEntry."Item No.";
        GenJournalLine."QB Stocks Output Shipment No." := ItemLedgerEntry."QB Stocks Output Shipment No.";
        //+AML 24/03/22 QB_ST01


        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, Location."QB Departament Code", GenJournalLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, JobJournalLine."Job No.", GenJournalLine."Dimension Set ID");

        DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
        DefaultDimension.SETRANGE("No.", DimValue."Job Structure Warehouse");
        IF DefaultDimension.FINDSET(FALSE) THEN
            REPEAT
                IF DefaultDimension."Value Posting" = DefaultDimension."Value Posting"::"Same Code" THEN BEGIN
                    FunctionQB.UpdateDimSet(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code", GenJournalLine."Dimension Set ID");
                END;
            UNTIL DefaultDimension.NEXT = 0;

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, InventoryPostingSetup."App. Account Concept Analytic", GenJournalLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID", GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code");

        GenJnlPostLine.RunWithCheck(GenJournalLine);
    END;

    PROCEDURE InventoryPostingSetupControl(VAR CodeLocate: Code[10]; VAR Code: Code[20]);
    BEGIN
        //Verifica informaci�n de la configuraci�n de inventario
        InventoryPostingSetup.GET(CodeLocate, Code);
        InventoryPostingSetup.TESTFIELD("Location Code");
        InventoryPostingSetup.TESTFIELD("Analytic Concept");
        InventoryPostingSetup.TESTFIELD("App. Account Concept Analytic");
        InventoryPostingSetup.TESTFIELD("Location Account Consumption");
        InventoryPostingSetup.TESTFIELD("App.Account Locat Acc. Consum.");
    END;

    [EventSubscriber(ObjectType::Report, 795, OnAfterPreReport, '', true, true)]
    PROCEDURE LanzaProceso(VAR Sender: Report 795);
    BEGIN

        ValoracionFacturas('');
        ValoracionAjustes('');
    END;

    /*BEGIN
/*{
      AML 22/03/22: - Nueva Codeunit para registrar los ajustes de valoracion de stocks
      AML 03/05/22: - QB 1.10.38 Cambio en cantidades, pon�a 0 y debe ser 1
      AML 27/05/22: - QB 1.10.45 Condicionar el cambio a que est� activo y cambio de signo que era err�neno
      JAV 02/06/22: - QB 1.10.46 Se a�ade la key para mejorar la velocidad
      AML 23/06/22: - QB 1.10.52 Condicionar el cambio a que tenga pendiente
      AML 25/07/22: - QB 1.11.01 Eliminar un control
    }
END.*/
}









