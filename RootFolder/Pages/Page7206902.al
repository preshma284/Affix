page 7206902 "Deviations Jobs List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = 'Deviations Jobs List', ESP = 'Lista proyectos de Desviaciones';
    SourceTable = 167;
    SourceTableView = SORTING("No.")
                    ORDER(Descending)
                    WHERE("Card Type" = FILTER("Proyecto operativo"), "Job Type" = CONST("Deviations"));
    PageType = List;
    CardPageID = "Operative Jobs Card";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Creation Date"; rec."Creation Date")
                {

                }
                field("Mandatory Allocation Term By"; rec."Mandatory Allocation Term By")
                {

                    CaptionML = ENU = 'Mandatory Allocation Term By', ESP = 'Imputaci�n';
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {

                    CaptionML = ENU = 'Bill-to Name', ESP = 'Cliente';
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Job Type"; rec."Job Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Invoicing Type"; rec."Invoicing Type")
                {

                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                    CaptionML = ENU = 'Bill-to Customer No.', ESP = 'N� cliente';
                }
                field("Status"; rec."Status")
                {

                    Visible = False;
                }
                field("Starting Date"; rec."Starting Date")
                {

                }
                field("Ending Date"; rec."Ending Date")
                {

                }
                field("Person Responsible"; rec."Person Responsible")
                {

                    Visible = False;
                }
                field("Next Invoice Date"; rec."Next Invoice Date")
                {

                    Visible = False;
                }
                field("Job Posting Group"; rec."Job Posting Group")
                {

                    Visible = False;
                }
                field("Budget Cost Amount"; rec."Budget Cost Amount")
                {

                }
                field("Actual Production Amount"; rec."Actual Production Amount")
                {

                }
                field("Production Budget Amount"; rec."Production Budget Amount")
                {

                }
                field("Budget Sales Amount"; rec."Budget Sales Amount")
                {

                }
                field("Direct Cost Amount PieceWork"; rec."Direct Cost Amount PieceWork")
                {

                }
                field("Usage (Cost) (LCY)"; rec."Usage (Cost) (LCY)")
                {

                }
                field("Invoiced Price (LCY)"; rec."Invoiced Price (LCY)")
                {

                }
                field("Search Description"; rec."Search Description")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207499)
            {
                SubPageLink = "No." = FIELD("No."), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter"), "Budget Filter" = FIELD("Current Piecework Budget");
            }
            part("JobAttributesFactbox"; 7206921)
            {

                ApplicationArea = Basic, Suite;
            }
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("BtnJob")
            {

                CaptionML = ENU = '&Job', ESP = 'Pro&yecto';
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                group("group4")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    action("action2")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Single', ESP = 'Dimensiones-&Individual';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(167), "No." = FIELD("No.");
                        Image = Dimensions;
                    }
                    action("action3")
                    {
                        CaptionML = ENU = 'Dimensions-&Multiple', ESP = 'Dimensiones-&Multiple';
                        Image = DimensionSets;

                        trigger OnAction()
                        VAR
                            Job: Record 167;
                            DefaultDimensionsMultiple: Page 542;
                        BEGIN
                            CurrPage.SETSELECTIONFILTER(Job);
                            DefaultDimensionsMultiple.SetMultiJob(Job);
                            DefaultDimensionsMultiple.RUNMODAL;
                        END;


                    }

                }
                action("action4")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = '&Movimientos';
                    RunObject = Page 92;
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = JobLedger;
                }
                action("action5")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207332;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                separator("separator6")
                {

                }
                action("action7")
                {
                    CaptionML = ENU = 'Job Crhonovision', ESP = 'Cronovisi�n proyecto';
                    RunObject = Page 7207351;
                    RunPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
                    Image = MachineCenterCalendar;
                }
                action("action8")
                {
                    CaptionML = ENU = 'Job Analytics', ESP = 'Analitica proyecto';
                    RunObject = Page 554;
                    Image = InsertStartingFee;
                }
                action("action9")
                {
                    CaptionML = ENU = 'Job Scheme', ESP = 'Esquema de proyectos';
                    RunObject = Page 490;
                    RunPageLink = "Dimension 3 Filter" = FIELD("No.");
                    Image = ChartOfAccounts;
                }
                action("action10")
                {
                    CaptionML = ENU = 'Production analysis', ESP = 'An�lisis de producci�n';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                        TrackingbyPiecework: Page 7207651;
                    BEGIN

                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.FILTERGROUP(2);
                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."No.");
                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Production Unit", TRUE);
                        DataPieceworkForProduction.FILTERGROUP(0);
                        DataPieceworkForProduction.SETRANGE("Budget Filter", rec."Current Piecework Budget");
                        CLEAR(TrackingbyPiecework);
                        TrackingbyPiecework.LOOKUPMODE(TRUE);
                        TrackingbyPiecework.SETTABLEVIEW(DataPieceworkForProduction);
                        TrackingbyPiecework.ReceivesJob(rec."No.", rec."Current Piecework Budget");
                        IF DataPieceworkForProduction.FINDFIRST THEN
                            TrackingbyPiecework.SETRECORD(DataPieceworkForProduction);
                        IF TrackingbyPiecework.RUNMODAL = ACTION::LookupOK THEN;
                    END;


                }

            }
            group("BtnPrice")
            {

                CaptionML = ENU = '&Price', ESP = '&Precios';
                action("action11")
                {
                    CaptionML = ENU = 'Resource', ESP = 'Recurso';
                    RunObject = Page 1011;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = ResourcePrice;
                }
                action("action12")
                {
                    CaptionML = ENU = 'Item', ESP = 'Producto';
                    RunObject = Page 1012;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = ItemCosts;
                }
                action("action13")
                {
                    CaptionML = ENU = 'G/L Account', ESP = 'Cuenta';
                    RunObject = Page 1013;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = GL;
                }

            }
            group("BtnControl")
            {

                CaptionML = ENU = 'Plan&ning', ESP = 'Pla&nific.';
                action("action14")
                {
                    CaptionML = ENU = 'Resource &Allocated pero Job', ESP = '&Asignaci�n recursos';
                    RunObject = Page 221;
                    Visible = FALSE;
                    Image = ResourcePlanning;
                }
                action("action15")
                {
                    CaptionML = ENU = 'Res. Group All&ocated per Job', ESP = 'A&signaci�n fams. recursos';
                    RunObject = Page 228;
                    Visible = FALSE;
                    Image = ResourceGroup
    ;
                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action7_Promoted; action7)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
                actionref(action10_Promoted; action10)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FilterResponsability(Rec);
    END;



    var
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ENU = 'Cost Database', ESP = 'Presupuesto';

    procedure ExistJob(): Boolean;
    var
        Job: Record 167;
    begin
        if rec."Job Matrix - Work" = rec."Job Matrix - Work"::"Matrix Job" then begin
            Job.RESET;
            Job.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
            Job.SETRANGE("Job Matrix - Work", Job."Job Matrix - Work"::Work);
            Job.SETRANGE("Matrix Job it Belongs", rec."No.");
            if not Job.ISEMPTY then
                exit(TRUE)
            ELSE
                exit(FALSE);
        end ELSE
            exit(FALSE);
    end;

    // begin
    /*{
      JAV 11/04/19: - Nueva lista de proyectos
      QMD 30/10/2019: - Q8164 Ten�a err�neo la p�gina en el CardPageID de las propiedades, se pone "Operative Jobs Card"
      JAV 05/04/21: - QB 1.08.32 Se eliminan los paneles laterales que ralentizan la p�gina
    }*///end
}









