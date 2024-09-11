page 7207507 "Piecework Planning"
{
    CaptionML = ENU = 'Piecework Planning', ESP = 'Planificaci�n unidades de obra';
    SaveValues = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207386;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("group6")
            {

                CaptionML = ENU = 'Matrix Options', ESP = 'Opciones Matriz';
                field("PeriodType"; PeriodType)
                {

                    CaptionML = ENU = 'View By', ESP = 'Ver por';
                    OptionCaptionML = ENU = 'View By', ESP = 'Ver por';
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        SetColumns(SetWanted::Initial);
                    END;


                }
                field("QtyType"; QtyType)
                {

                    CaptionML = ENU = 'View as', ESP = 'Ver como';
                    OptionCaptionML = ENU = 'View as', ESP = 'Ver como';
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        SetColumns(SetWanted::Initial);
                    END;


                }
                field("ColumSet"; ColumnSet)
                {

                    CaptionML = ENU = 'Column Set', ESP = 'Conjunto de valores';
                    Editable = FALSE

  ;
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
                CaptionML = ENU = '&Show Matrix', ESP = '&Muestra Matriz';
                Image = ShowMatrix;

                trigger OnAction()
                VAR
                    PieceworkPlanningMatrix: Page 7207619;
                BEGIN
                    PieceworkPlanningMatrix.Load(MatrixColumnCaptions, MatrixRecords, QtyType, JobCode, BudgetFilter);
                    PieceworkPlanningMatrix.RUNMODAL;
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Next Set', ESP = 'Conjunto Siguiente';
                ToolTipML = ENU = 'Next Set';
                Image = NextSet;

                trigger OnAction()
                VAR
                    MATRIX_Step: Option "First","Previous","Next";
                BEGIN
                    SetColumns(SetWanted::NEXT);
                END;


            }
            action("action3")
            {
                CaptionML = ENU = 'Previous Set', ESP = 'Conjunto Anterior';
                ToolTipML = ENU = 'Previous Set';
                Image = PreviousSet;


                trigger OnAction()
                VAR
                    MATRIX_Step: Option "First","Previous","Next";
                BEGIN
                    SetColumns(SetWanted::Previous);
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        SetColumns(SetWanted::Initial);
        JobCode := Rec.GETFILTER("Job No.");
        BudgetFilter := Rec.GETFILTER("Budget Filter");
    END;



    var
        MatrixRecords: ARRAY[32] OF Record 2000000007;
        // PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        PeriodType: Enum "Analysis Period Type";
        QtyType: Option "Net Change","Balance at Date";
        SetWanted: Option Initial,Previous,Same,Next;
        MatrixColumnCaptions: ARRAY[32] OF Text[1024];
        ColumnSet: Text[1024];
        PKFirstRecInCurrSet: Text[100];
        CurrSetLength: Integer;
        JobCode: Code[20];
        BudgetFilter: Code[20];

    procedure SetColumns(SetWanted: Option "First","Previous","Next");
    var
        MatrixManagement: Codeunit 9200;
    begin
        MatrixManagement.GeneratePeriodMatrixData(SetWanted, 32, FALSE, PeriodType, '',
          PKFirstRecInCurrSet, MatrixColumnCaptions, ColumnSet, CurrSetLength, MatrixRecords);
    end;

    // begin//end
}







