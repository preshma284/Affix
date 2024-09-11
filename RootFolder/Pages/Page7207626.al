page 7207626 "General Piecework RTC Offer"
{
    CaptionML = ENU = 'General Piecework RTC Offer', ESP = 'General Unidad de Obra';
    SourceTable = 7207386;
    DelayedInsert = true;
    PopulateAllFields = true;
    SourceTableView = SORTING("Job No.", "Piecework Code")
                    WHERE("Production Unit" = CONST(true));
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                IndentationColumn = rec.Indentation;
                IndentationControls = "Piecework Code";
                ShowAsTree = true;
                FreezeColumn = "Description";
                field("Piecework Code"; rec."Piecework Code")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        rec."Piecework Code" := UPPERCASE(rec."Piecework Code");
                        IF (xRec."Piecework Code" <> rec."Piecework Code") AND (xRec."Piecework Code" <> '') THEN BEGIN
                            IF NOT DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework Code") THEN BEGIN
                                IF DataPieceworkForProduction.GET(xRec."Job No.", xRec."Piecework Code") THEN BEGIN
                                    DataPieceworkForProduction.TRANSFERFIELDS(Rec, TRUE);
                                    DataPieceworkForProduction."Piecework Code" := rec."Piecework Code";
                                    IF DataPieceworkForProduction.INSERT THEN;
                                END;
                            END;
                        END;
                        C243PieceworkOnAfterValidate;
                    END;


                }
                field("Title"; rec."Title")
                {

                    Visible = false;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stLine;
                }
                field("Totaling"; rec."Totaling")
                {

                    StyleExpr = stLine;
                }
                field("Production Unit"; rec."Production Unit")
                {

                    StyleExpr = stLine;
                }
                field("Type"; rec."Type")
                {

                    StyleExpr = stLine;
                }
                field("Posting Group Unit Cost"; rec."Posting Group Unit Cost")
                {

                    StyleExpr = stLine;
                }
                field("Customer Certification Unit"; rec."Customer Certification Unit")
                {

                    StyleExpr = stLine;
                }
                field("Account Type"; rec."Account Type")
                {

                    StyleExpr = stLineType;
                }
                field("Description 2"; rec."Description 2")
                {

                    StyleExpr = stLine;
                }
                field("Budget Measure New"; rec."Budget Measure New")
                {

                    CaptionML = ENU = 'Budget Measure', ESP = 'Medici�n ppto.';
                    BlankZero = true;
                    Editable = edMeasureBudgPieceworkSol;
                    StyleExpr = stMeasureBudgPieceworkSol;
                }
                field("Amount Production Budget"; rec."Amount Production Budget")
                {

                    StyleExpr = stLine;
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                {

                    StyleExpr = stLine;
                }
                field("CalculateMarginBudget"; rec."CalculateMarginBudget")
                {

                    CaptionML = ENU = 'Margin', ESP = 'Margen';
                    StyleExpr = stLine;
                }
                field("CalculateMarginBudgetPerc"; rec."CalculateMarginBudgetPerc")
                {

                    CaptionML = ENU = 'Margin %', ESP = '% Margen';
                    StyleExpr = stLine;
                }
                field("Activity Code"; rec."Activity Code")
                {

                    StyleExpr = stLine

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {
            //Name=<Action1900000004>;
            group("<Action1907935204>")
            {

                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action1")
                {
                    ShortCutKey = 'Shift+F5';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';

                    trigger OnAction()
                    BEGIN
                        ShowCard;
                    END;


                }
                action("NuevaLinea")
                {

                    CaptionML = ENU = 'New Line', ESP = 'Nueva l�nea';
                    RunObject = Page 7207508;
                    RunPageLink = "Job No." = FIELD("Job No.");
                    RunPageMode = Create;
                }
                action("<Action1100251008>")
                {

                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    Image = Note;

                    trigger OnAction()
                    BEGIN
                        ShowComments;
                    END;


                }
                group("<Action1100251010>")
                {

                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    action("<Action1100251012>")
                    {

                        CaptionML = ENU = 'Individuals Dimensions', ESP = 'Dimensiones Individuales';
                        Image = Dimensions;

                        trigger OnAction()
                        BEGIN
                            ShowDimensionsInd;
                        END;


                    }
                    action("<Action1100251014>")
                    {

                        CaptionML = ENU = 'Multiple Dimensions', ESP = 'Dimensiones m�ltiples';


                        trigger OnAction()
                        BEGIN
                            ShowDimGlobals;
                        END;


                    }

                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        DescriptionIndent := 0;
        C243PieceworkOnFormat;
        Description243nOnFormat;


        funOnAfterGetRecord;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetRecord;
    END;



    var
        DataPieceworkForProduction: Record 7207386;
        PieceworkCodeEmphasize: Boolean;
        DescriptionEmphasize: Boolean;
        DescriptionIndent: Integer;
        // JobBudgetCopy: Report 7207305;
        // BringCostDatabase: Report 7207277;
        JobBudget: Record 7207407;
        stLine: Text;
        stLineType: Text;
        stMeasureBudgPieceworkSol: Text;
        edMeasureBudgPieceworkSol: Boolean;

    LOCAL procedure C243PieceworkOnAfterValidate();
    begin
        //JAV 05/10/19: - Se cambia el CurrPage.UPDATE de true a false para evitar un error si se renombra una unidad de obra
        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure C243PieceworkOnFormat();
    begin
        PieceworkCodeEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure Description243nOnFormat();
    begin
        DescriptionIndent := (rec.Indentation) * 220;
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            DescriptionEmphasize := TRUE;
        end;
    end;

    procedure ShowCard();
    var
        DataPieceworkForProduction: Record 7207386;
        JobPieceworkCard: Page 7207508;
    begin
        CLEAR(JobPieceworkCard);
        DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework Code");
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Piecework Code", rec."Piecework Code");
        Rec.FILTERGROUP(4);
        Rec.COPYFILTER("Budget Filter", DataPieceworkForProduction."Budget Filter");
        Rec.FILTERGROUP(0);
        if DataPieceworkForProduction.FINDFIRST then;

        JobPieceworkCard.SETTABLEVIEW(DataPieceworkForProduction);
        JobPieceworkCard.RUN;
    end;

    procedure ShowComments();
    var
        CommentLine: Record 97;
        CommentSheet: Page 124;
    begin
        CLEAR(CommentSheet);
        CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::"Job Cost Piecework");
        CommentLine.SETRANGE("No.", rec."Unique Code");
        CommentSheet.SETTABLEVIEW(CommentLine);
        CommentSheet.RUNMODAL;
    end;

    procedure ShowDimensionsInd();
    var
        DefaultDimension: Record 352;
        DefaultDimensions: Page 540;
    begin
        DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
        DefaultDimension.SETRANGE("No.", rec."Unique Code");
        DefaultDimensions.SETTABLEVIEW(DefaultDimension);
        DefaultDimensions.RUNMODAL;
    end;

    procedure ShowDimGlobals();
    var
        DataPieceworkForProduction: Record 7207386;
        DefaultDimensionsMultiple: Page 542;
    begin
        //JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
        DefaultDimensionsMultiple.ClearTempDefaultDim;
        if DataPieceworkForProduction.FINDSET then
            repeat
                DefaultDimensionsMultiple.CopyDefaultDimToDefaultDim(DATABASE::"Data Piecework For Production", DataPieceworkForProduction."Unique Code");
            until Rec.NEXT = 0;
        DefaultDimensionsMultiple.RUNMODAL;
    end;

    procedure CopyBudgetOtherJob();
    begin
        // CLEAR(JobBudgetCopy);
        // JobBudgetCopy.ColletData(rec."Job No.", rec."Budget Filter", TRUE);
        // JobBudgetCopy.RUNMODAL;
    end;

    procedure GetCostDatabase();
    begin
        // CLEAR(BringCostDatabase);
        // BringCostDatabase.GatherDate(rec."Job No.", '');
        // BringCostDatabase.RUNMODAL;
    end;

    procedure CopyPieceworkBillOfItem();
    var
        BringPieceworktoTheJob: Page 7207584;
    begin
        BringPieceworktoTheJob.ReceivedJob(rec."Job No.", Rec);
        BringPieceworktoTheJob.RUNMODAL;
        CLEAR(BringPieceworktoTheJob);
    end;

    LOCAL procedure funOnAfterGetRecord();
    begin
        //Estilos de campos
        stLine := rec.GetStyle('');
        stLineType := rec.GetStyle('StrongAccent');

        if (rec."No. Medition detail Cost" <> 0) then
            stMeasureBudgPieceworkSol := rec.GetStyle('Subordinate')
        ELSE
            stMeasureBudgPieceworkSol := rec.GetStyle('StandardAccent');

        Rec.CALCFIELDS("No. Medition detail Cost");
        edMeasureBudgPieceworkSol := (rec."No. Medition detail Cost" = 0);
    end;

    // begin
    /*{
      PGM 30/01/19: - Q6226 A�adida nueva accion "Linea Nueva".
      JAV 05/10/19: - Se cambia el CurrPage.UPDATE de true a false para evitar un error si se renombra una unidad de obra
      JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
    }*///end
}







