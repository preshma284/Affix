page 7207324 "Post. Certification Lines Subf"
{
    Editable = false;
    CaptionML = ENU = 'Post. Certification Lines Subform.', ESP = 'Subform. hist. lin. certificaci�n';
    SourceTable = 7207342;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Piecework No."; rec."Piecework No.")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Cert % to Certificate"; rec."Cert % to Certificate")
                {

                }
                field("Cert Quantity to Term"; rec."Cert Quantity to Term")
                {

                }
                field("Cert Quantity to Origin"; rec."Cert Quantity to Origin")
                {

                }
                field("Term PEM Price"; rec."Term PEM Price")
                {

                }
                field("Cert Term PEM amount"; rec."Cert Term PEM amount")
                {

                }
                field("Sale Price"; rec."Sale Price")
                {

                    BlankZero = true;
                }
                field("Cert Source PEM amount"; rec."Cert Source PEM amount")
                {

                }
                field("Contract Price"; rec."Contract Price")
                {

                    BlankZero = true;
                }
                field("Cert Term PEC amount"; rec."Cert Term PEC amount")
                {

                }
                field("Cert Source PEC amount"; rec."Cert Source PEC amount")
                {

                }
                field("Last Price Redetermined"; rec."Last Price Redetermined")
                {

                    BlankZero = true;
                    Visible = seeRED;
                }
                field("Adjustment Redeterm. Prices"; rec."Adjustment Redeterm. Prices")
                {

                    BlankZero = true;
                    Visible = seeRED;
                }
                field("Cert Term RED amount"; rec."Cert Term RED amount")
                {

                    Visible = seeRED;
                }
                field("Cert Source RED amount"; rec."Cert Source RED amount")
                {

                    Visible = seeRED;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                    Visible = FALSE;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                    Visible = FALSE;
                }
                field("DataPieceworkForProduction.Unit Of Measure"; DataPieceworkForProduction."Unit Of Measure")
                {

                    CaptionML = ENU = 'Unit Of Measure', ESP = 'Unidad de medida';
                }
                field("Record"; rec.Record)
                {

                }

            }
            group("QB_Totales")
            {

                Visible = seeadmin;
                group("group28")
                {

                    field("oriPEM"; oriPEM)
                    {

                        CaptionML = ENU = 'TOTAL', ESP = 'Suma PEM Origen';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("perPEM"; perPEM)
                    {

                        CaptionML = ESP = 'Suma PEM periodo';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }

                }
                group("group31")
                {

                    field("oriPEC"; oriPEC)
                    {

                        CaptionML = ENU = 'Total Withholding G.E', ESP = 'Suma PEC Origen';
                        Visible = false;
                        Editable = false;
                    }
                    field("perPEC"; perPEC)
                    {

                        CaptionML = ENU = 'Total PEC term', ESP = 'Suma PEC Periodo';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("dif"; dif)
                    {

                        CaptionML = ESP = 'Diferencia';
                        Enabled = false;
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

            group("group2")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action1")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;


                    trigger OnAction()
                    BEGIN
                        //This functionality was copied from page 7021458. Unsupported part was commented. Please check it.
                        // CurrPage.HistLinDoc.FORM.
                        ShowDimensions_;
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 09/02/22: - QB 1.10.19 Se hace no visible los totales, salvo para personal de CEI
        seeAdmin := (FunctionQB.IsQBAdmin);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        IF NOT DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework No.") THEN //Q13466
            DataPieceworkForProduction.INIT;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CalcTotals;
    END;



    var
        PostCertifications: Record 7207341;
        HistCertificationLines: Record 7207342;
        perPEM: Decimal;
        perPEC: Decimal;
        oriPEM: Decimal;
        oriPEC: Decimal;
        dif: Decimal;
        DataPieceworkForProduction: Record 7207386;
        FunctionQB: Codeunit 7207272;
        seeRED: Boolean;
        seeAdmin: Boolean;

    procedure ShowDimensions_();
    begin
        Rec.ShowDimensions;
    end;

    LOCAL procedure CalcTotals();
    begin
        PostCertifications.GET(rec."Document No.");

        HistCertificationLines.RESET;
        HistCertificationLines.SETRANGE("Document No.", rec."Document No.");
        HistCertificationLines.CALCSUMS("Cert Term PEM amount", "Cert Term PEC amount", "Cert Source PEM amount", "Cert Source PEC amount");
        perPEM := HistCertificationLines."Cert Term PEM amount";
        perPEC := HistCertificationLines."Cert Term PEC amount";
        oriPEM := HistCertificationLines."Cert Source PEM amount";
        oriPEC := HistCertificationLines."Cert Source PEC amount";

        dif := perPEC - PostCertifications."Amount Document";
    end;

    // begin
    /*{
      Q13466 QMD 25/05/21 - Se a�ade la unidad de medida de la unidad de obra
      JAV 15/09/21: - QB 1.09.18 Se hacen no visible los campos de las Redeterminaciones
      JAV 09/02/22: - QB 1.10.19 Se hace no visible los totales, salvo para personal de CEI
    }*///end
}







