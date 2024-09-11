page 7207052 "QB Service Order Subform"
{
    CaptionML = ENU = 'Lines', ESP = 'L�neas';
    MultipleNewLines = true;
    SourceTable = 7206967;
    DelayedInsert = true;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Piecework No."; rec."Piecework No.")
                {


                    ; trigger OnValidate()
                    BEGIN
                        PieceworkCodeOnAfterValidate;
                    END;


                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                    Visible = false;
                }
                field("Description"; rec."Description")
                {

                }
                field("Service Date"; rec."Service Date")
                {

                }
                field("Quantity"; rec."Quantity")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Contract Price"; rec."Contract Price")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Cost Amount"; rec."Cost Amount")
                {

                }
                field("Sale Price (base)"; rec."Sale Price (base)")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Sale Amount"; rec."Sale Amount")
                {

                }
                field("Profit"; rec."Profit")
                {

                }
                field("Price review percentage"; rec."Price review percentage")
                {

                }
                field("Sale Price With Price review"; rec."Sale Price With Price review")
                {

                }
                field("Sale Amount With Price review"; rec."Sale Amount With Price review")
                {

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
                    CaptionML = ENU = 'Data Piecework Meas-Cert List', ESP = 'Lista datos UO Med-Certif', ESN = 'Lista datos UO Med-Certif';
                    Image = EntriesList;

                    trigger OnAction()
                    BEGIN
                        //This functionality was copied from page 7021435. Unsupported part was commented. Please check it.
                        //CurrPage.LinDoc.FORM.
                        seeListPiecework;
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'D&imensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        //This functionality was copied from page 7021435. Unsupported part was commented. Please check it.
                        //CurrPage.LinDoc.FORM.
                        _ShowDimensions;
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = 'Measurement Lines Bill of Item', ESP = 'Detalle l�neas de medici�n', ESN = 'Detalle l�neas de medici�n';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    BEGIN
                        //This functionality was copied from page 7021435. Unsupported part was commented. Please check it.
                        //CurrPage.LinDoc.FORM.
                        ShowBillofItemMeasurement;
                    END;


                }

            }
            group("group6")
            {
                CaptionML = ENU = 'F&unctions', ESP = 'Acci&ones';
                Visible = false;
                action("action4")
                {
                    CaptionML = ENU = 'Insert Additional &Text', ESP = 'Insertar &textos adicionales';
                    Image = Text;


                    trigger OnAction()
                    BEGIN
                        //This functionality was copied from page 7021435. Unsupported part was commented. Please check it.
                        //CurrPage.LinDoc.FORM.
                        InsertTextAdic(TRUE);
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
        //CreateDim := xRec.CreateDim;

        IF MeasurementHeader.GET(rec."Document No.") THEN
            rec."Job No." := MeasurementHeader."Job No.";
    END;



    var
        ShortcutDimCode: ARRAY[8] OF Code[20];
        MeasurementHeader: Record 7206966;
        TransferExtendedText: Codeunit 7207288;

    LOCAL procedure PieceworkCodeOnAfterValidate();
    begin

        InsertTextAdic(FALSE);
    end;

    procedure InsertTextAdic(Unconditionally: Boolean);
    begin
        /*{SE COMENTA. NO EXISTEN FUNCIONES MeasurementCheckIfAnyExtText, InsertMeasurementExtText, MakeUpdate, EN CODEUNIT 7207288
        if TransferExtendedText.MeasurementCheckIfAnyExtText(Rec,Unconditionally) then begin
          CurrPage.SAVERECORD;
          TransferExtendedText.InsertMeasurementExtText(Rec);
        end;

        if TransferExtendedText.MakeUpdate then
          UpdateForm(TRUE);
        }*/
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure _ShowDimensions();
    begin
        rec.ShowDimensions;
    end;

    procedure seeListPiecework();
    var
        recDataPiecework: Record 7207386;
    begin
        recDataPiecework.SETRANGE("Job No.", rec."Job No.");
        recDataPiecework.GET(rec."Job No.", rec."Piecework No.");
        PAGE.RUNMODAL(PAGE::"Certif. Job-Piecework List", recDataPiecework);
    end;

    procedure ShowBillofItemMeasurement();
    var
        loccduManagementLineMeasure: Codeunit 7207292;
        locdecSourceMeasure: Decimal;
        locdecTermMeasure: Decimal;
        locbooConfirmed: Boolean;
    begin
        /*{SE COMENTA. PREGUNTAR LOS PARAMETROS EN LA FUNCION ConfirmBillofItemMeasure NO COINCIDEN
        MeasurementHeader.GET(rec."Document type",rec."Document No.");
        loccduManagementLineMeasure.ConfirmBillofItemMeasure("Piecework No.",MeasurementHeader."Job No.","Document type",
                                                               "Document No.","Line No.",locdecSourceMeasure,locdecTermMeasure,
                                                               locbooConfirmed);
        if locbooConfirmed then begin
          if MeasurementHeader."Measure Type" = MeasurementHeader."Measure Type"::Source then
            Rec.VALIDATE("Source Measure",locdecSourceMeasure)
          ELSE
            Rec.VALIDATE("Term Measure",locdecTermMeasure);
        end;
        }*/
    end;

    // begin//end
}







