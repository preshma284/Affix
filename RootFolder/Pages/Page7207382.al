page 7207382 "Rees Measure Lines Bill of Ite"
{
    CaptionML = ENU = 'Rees Measure Lines Bill of Item', ESP = 'Descomp l�neas medici�n reesti';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207395;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            field("FORMAT(TypeEstimated)"; FORMAT(TypeEstimated))
            {

                CaptionClass = FORMAT(TypeEstimated);
                Editable = False;
                Style = Standard;
                StyleExpr = TRUE;
            }
            repeater("Group")
            {

                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Budget Units"; rec."Budget Units")
                {

                    Editable = False;
                }
                field("Budget Length"; rec."Budget Length")
                {

                    Editable = False;
                }
                field("Budget Width"; rec."Budget Width")
                {

                    Editable = False;
                }
                field("Budget Height"; rec."Budget Height")
                {

                    Editable = False;
                }
                field("Budget Total"; rec."Budget Total")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Measured Units"; rec."Measured Units")
                {


                    ; trigger OnValidate()
                    BEGIN
                        OnAfterValidateUnitofMeasure;
                    END;


                }
                field("Measured Total"; rec."Measured Total")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Realized Total"; rec."Realized Total")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }

            }
            group("group15")
            {

                group("group16")
                {

                    CaptionML = ENU = 'Dear Pending Production', ESP = 'Producci�n pdte estimada';
                    field("MeasureNewPeriod"; MeasureNewPeriod)
                    {

                        Editable = False;
                        Style = Strong;
                        StyleExpr = TRUE

  ;
                    }

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
                CaptionML = ENU = 'Con&firm', ESP = 'Con&firmar';
                Image = Approval;


                trigger OnAction()
                BEGIN
                    Rec.MODIFY(TRUE);
                    CurrPage.CLOSE;
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
            }
        }
    }




    trigger OnAfterGetRecord()
    BEGIN
        CreateText;
        rec.CalculateData(TotalMeasureNewOrigin, MeasureNewPeriod,
                      QuantityMeasure, rec."Document Type", rec."Document No.", rec."Line No.");
    END;



    var
        TotalMeasureNewOrigin: Decimal;
        MeasureNewPeriod: Decimal;
        QuantityMeasure: Decimal;
        TypeEstimated: Text[150];
        Text000: TextConst ENU = 'Source Measure', ESP = 'Medici�n';
        Text001: TextConst ENU = 'Period Measure', ESP = 'Certificaci�n';
        Text002: TextConst ENU = 'Source Certification', ESP = 'Relaci�n valorada';

    procedure RefreshData();
    begin
        TotalMeasureNewOrigin := 0;
        rec.CalculateData(TotalMeasureNewOrigin, MeasureNewPeriod,
                         QuantityMeasure, rec."Document Type", rec."Document No.", rec."Line No.");
        TotalMeasureNewOrigin := TotalMeasureNewOrigin + rec."Measured Total" - xRec."Measured Total";
        MeasureNewPeriod := TotalMeasureNewOrigin - QuantityMeasure;
    end;

    procedure CreateText();
    var
        LMeasurementHeader: Record 7207336;
        LProdMeasureHeader: Record 7207399;
    begin
        TypeEstimated := '';
        CASE rec."Document Type" OF
            rec."Document Type"::Measuring:
                TypeEstimated := Text000;
            rec."Document Type"::Certification:
                TypeEstimated := Text001;
            rec."Document Type"::"Valued Relationship":
                TypeEstimated := Text002;
        end;
    end;

    LOCAL procedure OnAfterValidateUnitofMeasure();
    begin
        RefreshData;
    end;

    // begin//end
}







