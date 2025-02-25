report 7207344 "Generate Comparative Resources"
{


    CaptionML = ENU = 'Generate Comparative Resources', ESP = 'Generar comparativo recursos';
    ProcessingOnly = true;

    dataset
    {

        DataItem("PurchaseJournalLine"; "Purchase Journal Line")
        {

            DataItemTableView = SORTING("Job No.", "Activity Code", "Type", "No.")
                                 ORDER(Ascending)
                                 WHERE("Activity Code" = FILTER(<> ''));


            RequestFilterFields = "Activity Code", "Type", "No.";
            trigger OnPreDataItem();
            BEGIN
                Window.OPEN(Text001 +
                            Text002 +
                            Text003 +
                            Text004);

                Total := PurchaseJournalLine.COUNT;

                HeaderNo := 0;
                LineNo := 0;
                ProjectInProgress := '';
                ActivityInProgress := '';
                TypeLine := 9;
                FromComparative := '';
                ToComparative := '';

                CLEAR(Currency);
                Currency.InitRoundingPrecision;

                PurchaseJournalLine.SETRANGE(Generate, TRUE);  //JAV 04/05/20: - Solo l¡neas marcadas para generar
            END;

            trigger OnAfterGetRecord();
            BEGIN
                //JAV 10/08/19: - Se pone el contador de registros procesados en su lugar correcto
                Read := Read + 1;
                IF Total <> 0 THEN
                    Window.UPDATE(1, ROUND(Read / Total * 10000, 1));

                IF ByJob THEN
                    IF ProjectInProgress <> PurchaseJournalLine."Job No." THEN BEGIN
                        CreateHeader;
                        ProjectInProgress := PurchaseJournalLine."Job No.";
                    END;
                IF NOT MixedComparative THEN
                    IF TypeLine <> PurchaseJournalLine.Type THEN BEGIN
                        CreateHeader;
                        TypeLine := PurchaseJournalLine.Type;
                    END;
                IF NOT GroupedComparative THEN
                    IF ActivityInProgress <> PurchaseJournalLine."Activity Code" THEN BEGIN
                        CreateHeader;
                        ActivityInProgress := PurchaseJournalLine."Activity Code";
                    END;

                //Calcular el filtro de actividades
                IF GroupedComparative THEN BEGIN
                    IF (Actividades = '') THEN
                        Actividades := PurchaseJournalLine."Activity Code"
                    ELSE IF (STRPOS(Actividades, PurchaseJournalLine."Activity Code") = 0) THEN
                        IF (STRLEN(Actividades) + STRLEN(PurchaseJournalLine."Activity Code") + 1 < MAXSTRLEN(ComparativeQuoteHeader."Activity Filter")) THEN //JAV 07/11/22: QB 1.12.15 Evitar error de desbordamiento
                            Actividades += '|' + PurchaseJournalLine."Activity Code";

                    ComparativeQuoteHeader.VALIDATE("Activity Filter", Actividades);
                    ComparativeQuoteHeader.MODIFY;
                END;


                LineNo := LineNo + 1;
                Window.UPDATE(3, LineNo);
                ComparativeQuoteLines.INIT;
                ComparativeQuoteLines.VALIDATE("Quote No.", ComparativeQuoteHeader."No.");
                ComparativeQuoteLines.VALIDATE("Line No.", ComparativeQuoteLines."Line No." + 10000);
                IF ByJob = FALSE THEN
                    ComparativeQuoteLines."Job No." := PurchaseJournalLine."Job No.";
                IF ByJob THEN
                    ComparativeQuoteLines.VALIDATE("Job No.", PurchaseJournalLine."Job No.");

                IF PurchaseJournalLine.Type = PurchaseJournalLine.Type::Resource THEN BEGIN
                    ComparativeQuoteLines.Type := ComparativeQuoteLines.Type::Resource;
                    ComparativeQuoteLines.VALIDATE("No.", PurchaseJournalLine."No.");
                    Resource.GET(PurchaseJournalLine."No.");
                    ComparativeQuoteLines.VALIDATE(Description, Resource.Name);
                END;
                IF PurchaseJournalLine.Type = PurchaseJournalLine.Type::Item THEN BEGIN
                    ComparativeQuoteLines.Type := ComparativeQuoteLines.Type::Item;
                    ComparativeQuoteLines.VALIDATE("No.", PurchaseJournalLine."No.");
                    Item.GET(PurchaseJournalLine."No.");
                    ComparativeQuoteLines.VALIDATE(Description, Item.Description);
                END;
                ComparativeQuoteLines.VALIDATE("Unit of measurement Code", PurchaseJournalLine."Unit of Measure Code");
                ComparativeQuoteLines.INSERT(TRUE);


                ComparativeQuoteLines.VALIDATE("Job No.", PurchaseJournalLine."Job No.");
                ComparativeQuoteLines.VALIDATE("Activity Code", PurchaseJournalLine."Activity Code");
                ComparativeQuoteLines.VALIDATE("Location Code", PurchaseJournalLine."Location Code");
                ComparativeQuoteLines.VALIDATE(Quantity, PurchaseJournalLine.Quantity);
                ComparativeQuoteLines.VALIDATE("Initial Estimated Quantity", PurchaseJournalLine.Quantity);
                //ComparativeQuoteLines.VALIDATE("Estimated Price",PurchaseJournalLine."Estimated Price");
                //JMMA
                ComparativeQuoteLines.VALIDATE("Estimated Price", PurchaseJournalLine."Direct Unit Cost");
                ComparativeQuoteLines.VALIDATE("Estimated Price (JC)", PurchaseJournalLine."Direct Unit Cost (JC)");


                ComparativeQuoteLines.VALIDATE("Target Price", PurchaseJournalLine."Target Price");
                ComparativeQuoteLines.VALIDATE("Piecework No.", PurchaseJournalLine."Job Unit");
                ComparativeQuoteLines.VALIDATE(Quantity, PurchaseJournalLine.Quantity);
                ComparativeQuoteLines."Initial Estimated Amount" := ROUND(ComparativeQuoteLines."Initial Estimated Quantity" *
                                                                ComparativeQuoteLines."Estimated Price",
                                                                Currency."Amount Rounding Precision");
                ComparativeQuoteLines.VALIDATE("Initial Estimated Amount", ComparativeQuoteLines."Initial Estimated Amount");
                ComparativeQuoteLines.VALIDATE("Unit of measurement Code", PurchaseJournalLine."Unit of Measure Code");
                ComparativeQuoteLines.VALIDATE("Shortcut Dimension 1 Code", PurchaseJournalLine."Shortcut Dimension 1 Code");
                //-Q19864
                //ComparativeQuoteLines.VALIDATE("Shortcut Dimension 2 Code",PurchaseJournalLine."Shortcut Dimension 2 Code");
                IF ComparativeQuoteLines.Type = ComparativeQuoteLines.Type::Item THEN BEGIN
                    IF Job.GET(ComparativeQuoteLines."Job No.") THEN;
                    IF Job."Job Location" <> '' THEN Loc := Job."Job Location" ELSE Loc := ComparativeQuoteLines."Job No.";
                    Item.GET(ComparativeQuoteLines."No.");
                    InventoryPostingSetup.GET(Loc, Item."Inventory Posting Group");
                    ComparativeQuoteLines.VALIDATE("Shortcut Dimension 2 Code", InventoryPostingSetup."Analytic Concept");
                END
                ELSE
                    ComparativeQuoteLines.VALIDATE("Shortcut Dimension 2 Code", PurchaseJournalLine."Shortcut Dimension 2 Code");

                ComparativeQuoteLines.Description := PurchaseJournalLine.Decription;
                ComparativeQuoteLines."Description 2" := PurchaseJournalLine."Description 2";
                ComparativeQuoteLines.VALIDATE("Code Piecework PRESTO", PurchaseJournalLine."Code Piecework PRESTO");   //QB3685
                ComparativeQuoteLines.VALIDATE("Preselected Vendor", PurchaseJournalLine."Vendor No.");                 //QCPM_GAP06
                ComparativeQuoteLines.VALIDATE("Requirements date", PurchaseJournalLine."Date Needed");                  //JAV 15/12/21: - QB 1.10.08 Pasamos la fecha de necesidad al comparativo
                ComparativeQuoteLines.MODIFY;

                QBText.CopyTo(QBText.Table::Diario, PurchaseJournalLine."Job No.", PurchaseJournalLine."Journal Batch Name", FORMAT(PurchaseJournalLine."Line No."),
                              QBText.Table::Comparativo, ComparativeQuoteLines."Quote No.", FORMAT(ComparativeQuoteLines."Line No."), '');

                //JAV 10/08/19: - Se eliminan del diario las l¡neas generadas
                PurchaseJournalLine.DELETE(TRUE);

                //CPA 13/01/22. Q18722.Begin 
                ReportEvents.OnAfterProcessPurchJournalLineEvent(ComparativeQuoteHeader, ComparativeQuoteLines);
                //CPA 13/01/22. Q18722.End
            END;

            trigger OnPostDataItem();
            BEGIN
                //JAV 10/08/19: - Esto no hace nada aqu¡
                // Read := Read + 1;
                // IF Total <> 0 THEN
                //  Window.UPDATE(1,ROUND(Read / Total * 10000,1));
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group559")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("ByJob"; "ByJob")
                    {

                        CaptionML = ENU = 'By Job', ESP = 'Por proyecto';
                        Editable = false;

                        ; trigger OnValidate()
                        BEGIN
                            IF (ByJob) THEN
                                MESSAGE(Text008);
                        END;


                    }
                    field("MixedComparative"; "MixedComparative")
                    {

                        CaptionML = ENU = 'Mixed Comparative', ESP = 'Comparativos Mixtos';
                    }
                    field("GroupedComparative"; "GroupedComparative")
                    {

                        CaptionML = ENU = 'Grouped Comparative', ESP = 'Agrupar actividades distintas';
                    }

                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            ByJob := TRUE;
        END;


    }
    labels
    {
    }

    var
        //       Currency@7001116 :
        Currency: Record 4;
        //       ComparativeQuoteHeader@7001123 :
        ComparativeQuoteHeader: Record 7207412;
        //       ComparativeQuoteLines@7001122 :
        ComparativeQuoteLines: Record 7207413;
        //       Resource@7001124 :
        Resource: Record 156;
        //       Item@7001125 :
        Item: Record 27;
        //       QBText@1100286001 :
        QBText: Record 7206918;
        //       ProjectInProgress@7001112 :
        ProjectInProgress: Code[20];
        //       FromComparative@7001114 :
        FromComparative: Code[20];
        //       ToComparative@7001113 :
        ToComparative: Code[20];
        //       ActivityInProgress@7001111 :
        ActivityInProgress: Code[20];
        //       CodeInitialComparative@7001121 :
        CodeInitialComparative: Code[20];
        //       HeaderNo@7001110 :
        HeaderNo: Integer;
        //       LineNo@7001109 :
        LineNo: Integer;
        //       Total@7001107 :
        Total: Integer;
        //       TypeLine@7001115 :
        TypeLine: Integer;
        //       Read@7001126 :
        Read: Integer;
        //       ByJob@7001117 :
        ByJob: Boolean;
        //       MixedComparative@7001118 :
        MixedComparative: Boolean;
        //       GroupedComparative@7001119 :
        GroupedComparative: Boolean;
        //       First@7001120 :
        First: Boolean;
        //       Window@7001100 :
        Window: Dialog;
        //       Text001@7001106 :
        Text001: TextConst ENU = 'Generating comparative', ESP = '"Generando comparativo "';
        //       Text002@7001105 :
        Text002: TextConst ENU = ' @1@@@@@@@@@@\', ESP = ' @1@@@@@@@@@@\';
        //       Text003@7001104 :
        Text003: TextConst ENU = 'Comparative Header        #2#####\', ESP = 'Cabecera comparativo        #2#####\';
        //       Text004@7001103 :
        Text004: TextConst ENU = 'Comparative lines       #3#####\', ESP = 'L¡neas de comparativo       #3#####\';
        //       Text005@7001102 :
        Text005: TextConst ENU = 'Comparative %1 has been generated', ESP = 'Se han generado el comparativo %1';
        //       Text006@7001101 :
        Text006: TextConst ENU = '%1 comparatives were generated. From comparative %2 to comparative %3', ESP = 'Se han generado %1 comparativos. Desde el comparativo %2 hasta el comparativo %3';
        //       Text007@1100286000 :
        Text007: TextConst ESP = 'No se ha generado ning£n comparativo, recuerde asociar actividades a las l¡neas';
        //       Actividades@100000000 :
        Actividades: Text;
        //       Text008@1100286002 :
        Text008: TextConst ESP = 'NOTA IMPORTANTE: Los comparativos mixtos no se pueden convertir en contratos actualmente, £se esta opci¢n con prudencia';
        //       ReportEvents@1100286003 :
        ReportEvents: Codeunit 7207350;
        //       InventoryPostingSetup@1100286004 :
        InventoryPostingSetup: Record 5813;
        //       Job@1100286005 :
        Job: Record 167;
        //       Loc@1100286006 :
        Loc: Code[20];



    trigger OnPostReport();
    begin
        Window.CLOSE;
        CASE HeaderNo OF
            0:
                MESSAGE(Text007);
            1:
                MESSAGE(Text005, ComparativeQuoteHeader."No.")
            else
                MESSAGE(Text006, HeaderNo, CodeInitialComparative, ComparativeQuoteHeader."No.");
        end;
    end;



    procedure CreateHeader()
    var
        //       ComparativeQuoteHeader2@7001101 :
        ComparativeQuoteHeader2: Record 7207412;
        //       Job@7001102 :
        Job: Record 167;
    begin
        ComparativeQuoteHeader2.RESET;
        ComparativeQuoteHeader2.SETRANGE("No.", FromComparative, ToComparative);
        if ByJob then
            ComparativeQuoteHeader2.SETRANGE("Job No.", PurchaseJournalLine."Job No.")
        else
            ComparativeQuoteHeader2.SETRANGE("Job No.", PurchaseJournalLine."Job No.");
        if MixedComparative then
            ComparativeQuoteHeader2.SETRANGE("Comparative Type", ComparativeQuoteHeader2."Comparative Type"::Mixed)
        else
            ComparativeQuoteHeader2.SETRANGE("Comparative Type", PurchaseJournalLine.Type);
        if GroupedComparative then
            ComparativeQuoteHeader2.SETFILTER("Activity Filter", PurchaseJournalLine.GETFILTER("Activity Code"))
        else
            ComparativeQuoteHeader2.SETFILTER("Activity Filter", PurchaseJournalLine."Activity Code");
        if not ComparativeQuoteHeader2.FINDFIRST then begin
            HeaderNo := HeaderNo + 1;
            Window.UPDATE(2, HeaderNo);

            ComparativeQuoteHeader.INIT;
            ComparativeQuoteHeader."No." := '';
            ComparativeQuoteHeader.INSERT(TRUE);

            if not ByJob then
                ComparativeQuoteHeader."Job No." := ''
            else begin
                ComparativeQuoteHeader.VALIDATE(ComparativeQuoteHeader."Job No.", PurchaseJournalLine."Job No.");
                Job.GET(PurchaseJournalLine."Job No.");
                ComparativeQuoteHeader.VALIDATE(ComparativeQuoteHeader.Description, Job.Description);
            end;
            if not MixedComparative then
                ComparativeQuoteHeader."Comparative Type" := PurchaseJournalLine.Type
            else
                ComparativeQuoteHeader."Comparative Type" := ComparativeQuoteHeader."Comparative Type"::Mixed;
            ComparativeQuoteHeader.VALIDATE(ComparativeQuoteHeader."Comparative Date", WORKDATE);
            ComparativeQuoteHeader.VALIDATE(ComparativeQuoteHeader."Location Code", PurchaseJournalLine."Location Code");
            ComparativeQuoteHeader.VALIDATE("Activity Filter", PurchaseJournalLine."Activity Code");
            //JMMA DIVISAS
            ComparativeQuoteHeader."Currency Code" := PurchaseJournalLine."Currency Code";
            ComparativeQuoteHeader."Currency Date" := PurchaseJournalLine."Currency Date";
            ComparativeQuoteHeader."Currency Factor" := PurchaseJournalLine."Currency Factor";
            ComparativeQuoteHeader.MODIFY;
            Actividades := '';

            if not First then begin
                First := TRUE;
                CodeInitialComparative := ComparativeQuoteHeader."No.";
            end;
        end else
            ComparativeQuoteHeader := ComparativeQuoteHeader2;

        if FromComparative = '' then
            FromComparative := ComparativeQuoteHeader."No.";
        ToComparative := ComparativeQuoteHeader."No.";
    end;
    //verify
    // [Business]

    //     LOCAL procedure OnAfterProcessPurchJournalLineEvent (ComparativeQuoteHeader@1100286000 : Record 7207412;ComparativeQuoteLines@1100286001 :
    LOCAL procedure OnAfterProcessPurchJournalLineEvent(ComparativeQuoteHeader: Record 7207412; ComparativeQuoteLines: Record 7207413)
    begin
    end;

    /*begin
    //{
//      QB3685 24/09/18 PEL: Traspasar el campo Code Piecework PRESTO
//      QCPM_GAP06 07/05/19 PEL: Traspasar campo proveedor.
//      JAV 03/06/19: - Se cambia  COUNTAPPROX que est  obsoleto
//      JAV 09/08/19: - Se crea ya el registro del proveedor si lo tiene asociado a la l¡nea
//      JAV 10/08/19: - Se cambia el mensjae si no se han generado comparativos
//                    - Se eliminan del diario las l¡neas generadas
//                    - Se pone el contador de registros procesados en su lugar correcto
//      JAV 07/11/22: - QB 1.12.15 Evitar error de desbordamiento en las actividades
//      CPA 13/01/22: - Q18722 Creado un Event Publisher en: PurchaseJournalLine - OnAfterGetRecord()
//      AML 19/07/23   - !19864 Correccion CA para productos
//    }
    end.
  */

}



