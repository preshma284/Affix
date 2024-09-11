page 7207350 "Budget Forecast CA"
{
    CaptionML = ENU = 'Budget Forecast CA', ESP = 'Previsi�n ppto. CA';
    SaveValues = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207316;

    layout
    {
        area(content)
        {
            group("group6")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("Job No."; rec."Job No.")
                {

                    CaptionML = ENU = 'Primary master code', ESP = 'C�d. proyecto';
                }
                field("Reestimation Code"; rec."Reestimation Code")
                {

                }

            }
            group("group9")
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
                field("ColumnSet"; ColumnSet)
                {

                    CaptionML = ENU = 'Column Set', ESP = 'Conjunto de valores';
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {
            action(action1)
            {
                CaptionML = ENU = '&Show Matrix', ESP = '&Muestra Matriz';
                Image = ShowMatrix;

                trigger OnAction()
                VAR
                    MatrixPage: Page 7207484;
                BEGIN
                    MatrixPage.Load(MatrixColumnCaptions, Date, QtyType, rec."Job No.", rec."Reestimation Code");
                    MatrixPage.RUNMODAL;
                END;


            }
            action(action2)
            {
                CaptionML = ENU = 'NEXT Set', ESP = 'Conjunto Siguiente';
                Image = NextSet;

                trigger OnAction()
                VAR
                    MATRIX_Step: Option "First","Previous","Next";
                BEGIN
                    SetColumns(SetWanted::NEXT);
                END;

            }
            action(action3)
            {
                ToolTipML = ENU = 'Previous Set', ESP = 'Conjunto Anterior';
                Image = PreviousSet;


                trigger OnAction()
                VAR
                    MATRIX_Step: Option "First","Previous","Next";
                BEGIN
                    SetColumns(SetWanted::Previous);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
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
    END;



    var
        Date: ARRAY[32] OF Record 2000000007;
        QtyType: Option;
        ColumnSet: Text[1024];
        SetWanted: Option Initial,Previous,Same,Next;
        // PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        PeriodType: Enum "Analysis Period Type";
        PKFirstRecInCurrSet: Text[100];
        MatrixColumnCaptions: ARRAY[32] OF Text[1024];
        CurrSetLength: Integer;

    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next);
    var
        MatrixMgt: Codeunit 9200;
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted, 32, FALSE, PeriodType, '',
          PKFirstRecInCurrSet, MatrixColumnCaptions, ColumnSet, CurrSetLength, Date);
    end;

    // begin//end
}







