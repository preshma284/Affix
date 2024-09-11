page 7207531 "Subform. Line Regul. Stock"
{
    CaptionML = ENU = 'Subform. Line Regul. Stock', ESP = 'Subform. lineas regul. stock';
    SourceTable = 7207409;
    DelayedInsert = true;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Line No."; rec."Line No.")
                {

                    Visible = False;
                }
                field("Document No."; rec."Document No.")
                {

                    Visible = False;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Item No."; rec."Item No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Unit of Measure Cod."; rec."Unit of Measure Cod.")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Adjusted"; rec."Adjusted")
                {

                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Piecework No."; rec."Piecework No.")
                {

                }
                field("Calculated Stocks"; rec."Calculated Stocks")
                {

                }
                field("Current Stocks"; rec."Current Stocks")
                {

                }
                field("Unit Cost"; rec."Unit Cost")
                {

                    Editable = FALSE;
                }
                field("Total Cost"; rec."Total Cost")
                {

                    Editable = False;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action1")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'D&imensiones';
                    Image = Dimensions;


                    trigger OnAction()
                    BEGIN
                        _ShowDimensions;
                    END;


                }

            }

        }
    }

    trigger OnAfterGetRecord()
    BEGIN
        rec.ShowShortcutDimCode(ShortcutDimCode);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        CLEAR(ShortcutDimCode);
    END;



    var
        ShortcutDimCode: ARRAY[8] OF Code[20];

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    // begin
    /*{
      CPA 23/03/22: - QB 1.10.27 (Q16789) El campo Precio Coste se pone no editable para evitar fallos
      CSM 11/05/22: � QB 1.10.42 (QBU17147) Mostrar columna de Concepto Anal�tico en la regularizaci�n de stock.
    }*///end
}







