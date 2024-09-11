page 7207355 "QB Organization Department"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Organization Department', ESP = 'Departamentos Organizativos';
    SourceTable = 7207002;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                IndentationColumn = rec.Indentation;
                field("Code"; rec."Code")
                {

                    ToolTipML = ESP = 'Especifica el c�digo asociado al departamento de aprobaciones';
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field("Description"; rec."Description")
                {

                    ToolTipML = ESP = 'Especifica el nombre descriptivo del departamento de aprobaciones';
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field("Type"; rec."Type")
                {

                    Style = Strong;
                    StyleExpr = isHeading;

                    ; trigger OnValidate()
                    BEGIN
                        setStyle;
                    END;


                }
                field("Indentation"; rec."Indentation")
                {

                }
                field("For Payments"; rec."For Payments")
                {

                }

            }
            part("pgResponsibles"; 7207045)
            {

                CaptionML = ESP = 'Responsable';
                SubPageView = SORTING("Type", "Table Code", "Piecework No.", "ID Register");
                SubPageLink = "Type" = CONST("Department"), "Table Code" = FIELD("Code");
            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("Copiar")
            {

                CaptionML = ESP = 'Copiar de Dimension';
                Image = CopyDimensions;

                trigger OnAction()
                BEGIN
                    DimensionValue.RESET;
                    DimensionValue.SETRANGE("Dimension Code", FunctionQB.ReturnDimDpto);
                    IF (DimensionValue.FINDSET(FALSE)) THEN
                        REPEAT
                            Rec.INIT;
                            Rec.Code := DimensionValue.Code;
                            Rec.Description := DimensionValue.Name;
                            IF NOT Rec.INSERT THEN;
                        UNTIL (DimensionValue.NEXT = 0);
                END;


            }
            action("Dimension")
            {

                CaptionML = ESP = 'Dimensi�n Asociada';
                Image = DefaultDimension;


                trigger OnAction()
                BEGIN
                    DimensionValue.RESET;
                    DimensionValue.SETRANGE("Dimension Code", FunctionQB.ReturnDimDpto);

                    CLEAR(DimensionValues);
                    DimensionValues.SETTABLEVIEW(DimensionValue);
                    DimensionValues.RUNMODAL;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Copiar_Promoted; Copiar)
                {
                }
                actionref(Dimension_Promoted; Dimension)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    VAR
        DimensionCode: Code[20];
    BEGIN
    END;

    trigger OnAfterGetRecord()
    BEGIN
        setStyle;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        setStyle;
    END;



    var
        DimensionValue: Record 349;
        DimensionValues: Page 537;
        FunctionQB: Codeunit 7207272;
        isHeading: Boolean;

    LOCAL procedure setStyle();
    begin
        isHeading := (rec.Type = Rec.Type::Heading);
    end;

    // begin//end
}








