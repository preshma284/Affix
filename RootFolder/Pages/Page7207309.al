page 7207309 "Post. Measure Lines List"
{
    Editable = false;
    CaptionML = ENU = 'Lines', ESP = 'L�neas';
    SourceTable = 7207339;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Document No."; rec."Document No.")
                {

                }
                field("Piecework No."; rec."Piecework No.")
                {

                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Med. % Measure"; rec."Med. % Measure")
                {

                }
                field("Med. Source Measure"; rec."Med. Source Measure")
                {

                }
                field("Med. Term Measure"; rec."Med. Term Measure")
                {

                }
                field("Certificated Quantity"; rec."Certificated Quantity")
                {

                }
                field("Quantity Measure Not Cert"; rec."Quantity Measure Not Cert")
                {

                    Visible = FALSE;
                }
                field("Sale Price"; rec."Sale Price")
                {

                }
                field("Med. Term Amount"; rec."Med. Term Amount")
                {

                }
                field("Med. Source Amount PEM"; rec."Med. Source Amount PEM")
                {

                }
                field("Contract Price"; rec."Contract Price")
                {

                }
                field("Med. Term PEC Amount"; rec."Med. Term PEC Amount")
                {

                }
                field("Med. Source Amount PEC"; rec."Med. Source Amount PEC")
                {

                }
                field("Last Price Redetermined"; rec."Last Price Redetermined")
                {

                    Visible = seeRED;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }
            group("QB_Totales")
            {

                group("group26")
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
                group("group29")
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
                        //This functionality was copied from page 7021439. Unsupported part was commented. Please check it.
                        // CurrPage.HistLinDoc.FORM.
                        _ShowDimensions;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Measurement Lines Bill of Item', ESP = 'Descompuesto lineas de medici�n';
                    Image = ItemTrackingLines;


                    trigger OnAction()
                    BEGIN
                        //This functionality was copied from page 7021439. Unsupported part was commented. Please check it.
                        // CurrPage.HistLinDoc.FORM.
                        ShowBillofItemMeasurement;
                    END;


                }

            }

        }
    }
    trigger OnAfterGetCurrRecord()
    BEGIN
        CalcTotals;
    END;



    var
        HistMeasurements: Record 7207338;
        HistMeasureLines: Record 7207339;
        perPEM: Decimal;
        perPEC: Decimal;
        oriPEM: Decimal;
        oriPEC: Decimal;
        dif: Decimal;
        seeRED: Boolean;

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    procedure ShowBillofItemMeasurement();
    var
        recPostMeasLinesBillofItem: Record 7207396;
        pagePostMeasurBillofItem: Page 7207375;
    begin
        recPostMeasLinesBillofItem.SETRANGE("Document No.", rec."Document No.");
        recPostMeasLinesBillofItem.SETRANGE("Line No.", rec."Line No.");
        CLEAR(pagePostMeasurBillofItem);
        pagePostMeasurBillofItem.SETTABLEVIEW(recPostMeasLinesBillofItem);
        pagePostMeasurBillofItem.EDITABLE(FALSE);
        pagePostMeasurBillofItem.LOOKUPMODE(TRUE);
        pagePostMeasurBillofItem.RUNMODAL;
    end;

    LOCAL procedure CalcTotals();
    begin
        HistMeasurements.GET(rec."Document No.");

        HistMeasureLines.RESET;
        HistMeasureLines.SETRANGE("Job No.", rec."Job No.");
        HistMeasureLines.SETRANGE("Piecework No.", rec."Piecework No.");
        HistMeasureLines.CALCSUMS("Med. Term Amount", "Med. Term PEC Amount", "Med. Source Amount PEM", "Med. Source Amount PEC");
        perPEM := HistMeasureLines."Med. Term Amount";
        perPEC := HistMeasureLines."Med. Term PEC Amount";
        oriPEM := HistMeasureLines."Med. Source Amount PEM";
        oriPEC := HistMeasureLines."Med. Source Amount PEC";
        dif := perPEC - HistMeasurements."Amount Document";
    end;

    // begin
    /*{
      JAV 15/09/21: - QB 1.09.18 Se hace no visible el campo rec."Last Price Redetermined"
    }*///end
}







