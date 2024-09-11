page 7207547 "Comparative Quote Lin. Subform"
{
    CaptionML = ENU = 'Lines', ESP = 'L�neas';
    MultipleNewLines = true;
    SourceTable = 7207413;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("HaveAditionalText()"; HaveAditionalText())
                {

                    CaptionML = ESP = 'Textos Adicionales';
                    Enabled = false;
                }
                field("Job No."; rec."Job No.")
                {

                    Enabled = edJob;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("JobDescription"; JobDescription)
                {

                    CaptionML = ENU = 'Job Description', ESP = 'Descripci�n proyecto';
                    Visible = false;
                    Editable = false;
                }
                field("Piecework No."; rec."Piecework No.")
                {

                    CaptionClass = '1,5,' + txtFieldCaption;
                    Enabled = EditEnabled;

                    ; trigger OnValidate()
                    BEGIN
                        CalcPrices;
                    END;


                }
                field("QB CA Value"; rec."QB CA Value")
                {

                    Enabled = EditEnabled;
                }
                field("Type"; rec."Type")
                {

                    Enabled = EditEnabled;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("No."; rec."No.")
                {

                    Enabled = EditEnabled;
                }
                field("Description"; rec."Description")
                {

                    Enabled = EditEnabled;
                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                    Enabled = EditEnabled;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                    Enabled = EditEnabled;
                }
                field("Preselected Vendor"; rec."Preselected Vendor")
                {

                    Enabled = EditEnabled;
                }
                field("Unit of measurement Code"; rec."Unit of measurement Code")
                {

                    Enabled = EditEnabled;

                    ; trigger OnValidate()
                    BEGIN
                        Rec.CALCFIELDS("Lowest Price", "Lowert Amount");
                        CurrPage.UPDATE;
                    END;


                }
                field("Requirements date"; rec."Requirements date")
                {

                    ToolTipML = ESP = 'Fecha de necesidad, cuando pase al pedido ser� la fecha de recepci�n esperada';
                    Enabled = EditEnabled;
                }
                field("Initial Estimated Quantity"; rec."Initial Estimated Quantity")
                {

                    Enabled = EditEnabled;
                }
                field("Initial Estimated Amount"; rec."Initial Estimated Amount")
                {

                    Enabled = EditEnabled;
                }
                field("Activity Code"; rec."Activity Code")
                {

                    Enabled = EditEnabled;
                }
                field("Location Code"; rec."Location Code")
                {

                    Visible = FALSE;
                    Enabled = EditEnabled;
                }
                field("Qty. in Contract"; rec."Qty. in Contract")
                {

                    Enabled = EditEnabled;
                }
                field("Quantity"; rec."Quantity")
                {

                    Enabled = EditEnabled;

                    ; trigger OnValidate()
                    BEGIN
                        Rec.CALCFIELDS("Lowest Price", "Lowert Amount");
                        CurrPage.UPDATE;
                    END;


                }
                field("Qty to segregate"; rec."Qty to segregate")
                {

                }
                field("StudyPrice"; StudyPrice)
                {

                    CaptionML = ENU = 'Study Price', ESP = 'Precio Estudio';
                    Visible = FALSE;
                    Enabled = false;
                }
                field("ContractPrice"; ContractPrice)
                {

                    CaptionML = ENU = 'Contract Price', ESP = 'Precio Contrato';
                    Visible = FALSE;
                    Enabled = false;
                }
                field("Estimated Price"; rec."Estimated Price")
                {

                    Enabled = EditEnabled;
                }
                field("Estimated Amount"; rec."Estimated Amount")
                {

                    Enabled = EditEnabled;
                }
                field("Target Price"; rec."Target Price")
                {

                    Enabled = EditEnabled;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Estimated Price (JC)"; rec."Estimated Price (JC)")
                {

                    Enabled = EditEnabled;
                }
                field("Estimated Amount (JC)"; rec."Estimated Amount (JC)")
                {

                    Enabled = EditEnabled;
                }
                field("Target Amount"; rec."Target Amount")
                {

                    Enabled = EditEnabled;
                }
                field("Lowest Price"; rec."Lowest Price")
                {

                    Enabled = EditEnabled;
                }
                field("Lowert Amount"; rec."Lowert Amount")
                {

                    Enabled = EditEnabled;
                }
                field("Purchase Price"; rec."Purchase Price")
                {

                    ToolTipML = ESP = 'Precio final de compra, en rojo si est� por encima del precio previsto de compra, y en verde si est� por debajo del previsto.';
                    Enabled = EditEnabled;
                    StyleExpr = Style1;
                }
                field("Purchase Amount"; rec."Purchase Amount")
                {

                    ToolTipML = ESP = 'Importe final de compra, en rojo si est� por encima del precio previsto de compra, y en verde si est� por debajo del previsto.';
                    StyleExpr = Style1;
                }
                field("Purchase Amount * cnt"; rec."Purchase Amount" * cnt)
                {

                    CaptionML = ESP = 'Importe Total';
                    ToolTipML = ESP = 'Importe final de compra, en rojo si est� por encima del precio previsto de compra, y en verde si est� por debajo del previsto.';
                    Visible = seeMonths;
                    Enabled = false;
                    StyleExpr = Style1;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                    Visible = false;
                    Enabled = EditEnabled;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                    Visible = false;
                    Enabled = EditEnabled;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("ShortcutDimCode[3]_"; ShortcutDimCode[3])
                {

                    ApplicationArea = Suite;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), "Dimension Value Type" = CONST("Standard"), "Blocked" = CONST(false));
                    Visible = FALSE;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                        CurrPage.UPDATE;
                    END;


                }
                field("ShortcutDimCode[4]_"; ShortcutDimCode[4])
                {

                    ApplicationArea = Suite;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), "Dimension Value Type" = CONST("Standard"), "Blocked" = CONST(false));
                    Visible = FALSE;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                        CurrPage.UPDATE;
                    END;


                }
                field("ShortcutDimCode[5]_"; ShortcutDimCode[5])
                {

                    ApplicationArea = Suite;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), "Dimension Value Type" = CONST("Standard"), "Blocked" = CONST(false));
                    Visible = FALSE;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                        CurrPage.UPDATE;
                    END;


                }
                field("ShortcutDimCode[6]_"; ShortcutDimCode[6])
                {

                    ApplicationArea = Suite;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), "Dimension Value Type" = CONST("Standard"), "Blocked" = CONST(false));
                    Visible = FALSE;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                        CurrPage.UPDATE;
                    END;


                }
                field("ShortcutDimCode[7]_"; ShortcutDimCode[7])
                {

                    ApplicationArea = Suite;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), "Dimension Value Type" = CONST("Standard"), "Blocked" = CONST(false));
                    Visible = FALSE;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                        CurrPage.UPDATE;
                    END;


                }
                field("ShortcutDimCode[8]_"; ShortcutDimCode[8])
                {

                    ApplicationArea = Suite;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), "Dimension Value Type" = CONST("Standard"), "Blocked" = CONST(false));
                    Visible = FALSE;



                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                        CurrPage.UPDATE;
                    END;


                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ESP = 'Textos Adicionales';
                RunObject = Page 7206929;
                RunPageView = SORTING("Table", "Key1", "Key2", "Key3");
                RunPageLink = "Table" = CONST("Comparativo"), "Key1" = FIELD("Quote No."); //,"Key2" = FIELD("Line No.");
                Promoted = true;
                Image = Text;
                PromotedCategory = Process;
            }
            action("action2")
            {
                CaptionML = ENU = '&Duplicate lines (Marked)', ESP = 'Segregar L�neas';
                Promoted = true;
                Image = CopyCostBudget;
                PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    SegregateComparative;
                END;


            }
            action("Action1100286043")
            {
                AccessByPermission = TableData 348 = R;
                ShortCutKey = 'Shift+Ctrl+D';
                CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                ToolTipML = ENU = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', ESP = 'Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                ApplicationArea = Dimensions;
                Image = Dimensions;


                trigger OnAction()
                BEGIN
                    COMMIT;
                    rec.ShowDimensions;
                END;


            }

        }
    }
    trigger OnInit()
    BEGIN
        Style1 := 'Favorable';
    END;

    trigger OnOpenPage()
    BEGIN
        QuoBuildingSetup.GET;
        seeMonths := QuoBuildingSetup."Comparatives by months";

        SetFieldCaption(Rec."Job No.");
    END;

    trigger OnAfterGetRecord()
    BEGIN
        rec.ShowShortcutDimCode(ShortcutDimCode);

        IF (rec."Purchase Price" = 0) OR (rec."Purchase Price" = rec."Estimated Price") THEN
            Style1 := 'Standard'
        ELSE IF (rec."Purchase Price" < rec."Estimated Price") THEN
            Style1 := 'Favorable'
        ELSE
            Style1 := 'unFavorable';

        CalcPrices;

        SetEditable;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        CLEAR(ShortcutDimCode);
        rec.Type := xRec.Type;
        rec.Manual := TRUE;

        //JAV 15/12/21: - QB 1.10.08 Ponemos la cantidad de meses y la fecha de necesidad de la cabecera
        IF (ComparativeQuoteHeader.GET(Rec."Quote No.")) THEN BEGIN
            Rec."Requirements date" := ComparativeQuoteHeader."Requirements date";

            //JAV 13/03/22; - QB 1.10.24 Al crear la l�nea ponemos por defecto la U.O. de la cabecera
            Rec."Job No." := ComparativeQuoteHeader."Job No.";
            IF (ComparativeQuoteHeader."QB Budget item" <> '') THEN
                Rec."Piecework No." := ComparativeQuoteHeader."QB Budget item";
        END;

        Rec.VALIDATE("QB CA Code");
        Rec."Shortcut Dimension 1 Code" := ComparativeQuoteHeader."Shortcut Dimension 1 Code";
        Rec."Shortcut Dimension 2 Code" := ComparativeQuoteHeader."Shortcut Dimension 2 Code";
    END;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    BEGIN
        //JAV 14/10/19: - Se a�aden CurrPage.Update para que refresque la pantalla principal
        CurrPage.UPDATE(FALSE);
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        //JAV 14/10/19: - Se a�aden CurrPage.Update para que refresque la pantalla principal
        CurrPage.UPDATE(FALSE);
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        //JAV 14/10/19: - Se a�aden CurrPage.Update para que refresque la pantalla principal
        CurrPage.UPDATE(FALSE);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        SetEditable;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        ComparativeQuoteHeader: Record 7207412;
        Job: Record 167;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        Style1: Text;
        StudyPrice: Decimal;
        ContractPrice: Decimal;
        EditEnabled: Boolean;
        seeMonths: Boolean;
        cnt: Integer;
        txtFieldCaption: Text;
        edJob: Boolean;
        JobDescription: Text;

    procedure SegregateComparative();
    var
        // SegregateComparative: Report 7207374;
    begin
        ComparativeQuoteHeader.RESET;
        ComparativeQuoteHeader.SETRANGE("No.", rec."Quote No.");

        ContractPrice := ComparativeQuoteHeader.COUNT;


        // CLEAR(SegregateComparative);
        // SegregateComparative.SETTABLEVIEW(ComparativeQuoteHeader);
        // SegregateComparative.USEREQUESTPAGE(FALSE);
        // SegregateComparative.RUNMODAL;
    end;

    procedure BreakDown();
    var
        ComparativeQuoteLines: Record 7207413;
        // GenerateBrokenDown: Report 7207354;
    begin
        CurrPage.SETSELECTIONFILTER(ComparativeQuoteLines);
        // GenerateBrokenDown.SETTABLEVIEW(ComparativeQuoteLines);
        // GenerateBrokenDown.USEREQUESTPAGE := FALSE;
        // GenerateBrokenDown.RUNMODAL;
        // CLEAR(GenerateBrokenDown);
    end;

    procedure BreakDown_UpdatePrices(pMessages: Boolean);
    var
        ComparativeQuoteLines: Record 7207413;
        // GenerateBrokenDown: Report 7207354;
    begin
        //CurrPage.SETSELECTIONFILTER(ComparativeQuoteLines); //JMMA para que actualice todos los precios y no s�lo las l�neas marcadas
        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", rec."Quote No.");
        // GenerateBrokenDown.SETTABLEVIEW(ComparativeQuoteLines);
        // GenerateBrokenDown.USEREQUESTPAGE := FALSE;
        // GenerateBrokenDown.SetMessages(pMessages);
        // GenerateBrokenDown.RUNMODAL;
        // CLEAR(GenerateBrokenDown);
    end;

    LOCAL procedure CalcPrices();
    var
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
    begin
        //JAV 04/02/20: - Se pasa a una funci�n el calculo de "Precio de estudio" y "Precio de contrato", se refrescan al cargar la l�nea y al validar
        //JAV No inicializaba, por tanto se quedaba con el dato anterior
        StudyPrice := 0;
        ContractPrice := 0;

        //Q8464>>
        if (DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework No.")) then
            ContractPrice := DataPieceworkForProduction."Contract Price";

        if (Job.GET(rec."Job No.")) then
            if (DataPieceworkForProduction.GET(Job."Original Quote Code", rec."Piecework No.")) then
                StudyPrice := DataPieceworkForProduction.CostPrice;

        //Q8464<<
    end;

    LOCAL procedure HaveAditionalText(): Text[2];
    var
        QBText: Record 7206918;
    begin
        exit(FORMAT(QBText.GET(QBText.Table::Comparativo, rec."Quote No.", FORMAT(rec."Line No."), '')));
    end;

    LOCAL procedure SetEditable();
    begin
        //Q13150 -
        EditEnabled := FALSE;
        cnt := 1;
        if ComparativeQuoteHeader.GET(rec."Quote No.") then begin //JAV 15/12/21: - QB 1.10.08 Si no existe la cabecera, no hago nada
            EditEnabled := (ComparativeQuoteHeader."Generated Contract Doc No." = '');
            if (ComparativeQuoteHeader."Generate for months" = 0) then
                cnt := 1
            ELSE
                cnt := ComparativeQuoteHeader."Generate for months";
        end;

        //JAV 05/06/22: - QB 1.10.47 Se elimina el control de que solo sea el proyecto de la cabecera, as� puede ser multiproyecto
        // //Proyecto editable en proyectos de presupuestos o de Real Estate
        // if (Rec."Job No." = '') then
        //  edJob := TRUE
        // ELSE begin
        //  edJob := FALSE;
        //  if (Job.GET(rec."Job No.")) then
        //    edJob := EditEnabled and (Job."Card Type" IN [Job."Card Type"::Presupuesto, Job."Card Type"::Promocion]);
        // end;

        edJob := EditEnabled;

        //+Q17327
        JobDescription := '';
        if Job.GET(rec."Job No.") then
            JobDescription := Job.Description;
        //-Q17327
    end;

    procedure SetFieldCaption(JobNo: Code[20]);
    begin
        if JobNo <> '' then begin
            Job.GET(JobNo);
            if Job."Card Type" IN [Job."Card Type"::Presupuesto, Job."Card Type"::Promocion] then
                txtFieldCaption := 'Partida presupuestaria'
            ELSE
                txtFieldCaption := 'C¢d. unidad de obra';
            CurrPage.UPDATE(FALSE);
        end;
    end;

    // begin
    /*{
      JAV 14/10/19: - Se a�aden CurrPage.Update para que refresque la pantalla principal
      PGM 31/10/19: - Se comenta lo que habia y se a�ade el SETSELECTIONFILTER porque al report no le llegaba ningun registro
      PGM 19/12/19: - Q8464 A�adidos los campos "Precio de estudio" y "Precio de contrato" y se rellenan al validar la unidad de obra.
      JAV 04/02/20: - Se pasa a una funci�n el calculo de "Precio de estudio" y "Precio de contrato", se refrescan al cargar la l�nea y al validar
      Q13150 JDC 06/04/21 - Modified PageLayout
      JAV 10/08/22: - QB 1.11.01 (Q17327) Se incorpora la descripci�n del proyecto
    }*///end
}







