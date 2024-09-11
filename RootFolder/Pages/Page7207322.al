page 7207322 "Certification lines subform"
{
    CaptionML = ENU = 'Measurement lines', ESP = 'L�neas certificaci�n';
    MultipleNewLines = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207337;
    DelayedInsert = true;
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

                    Editable = FALSE;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                }
                field("Description"; rec."Description")
                {

                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = isheader;
                }
                field("Cert Medition No."; rec."Cert Medition No.")
                {

                    Visible = FALSE;
                }
                field("Cert Medition Line No."; rec."Cert Medition Line No.")
                {

                    BlankZero = true;
                    Visible = FALSE;
                }
                field("Cert Pend. Medition Term"; rec."Cert Pend. Medition Term")
                {

                }
                field("Cert Pend. Medition Origin"; rec."Cert Pend. Medition Origin")
                {

                }
                field("Cert % to Certificate"; rec."Cert % to Certificate")
                {

                    Enabled = not isheader;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Cert Quantity to Term"; rec."Cert Quantity to Term")
                {

                    Enabled = not isheader;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Cert Quantity to Origin"; rec."Cert Quantity to Origin")
                {

                    Enabled = not isheader;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Term PEM Price"; rec."Term PEM Price")
                {

                }
                field("Cert Term PEM amount"; rec."Cert Term PEM amount")
                {

                    BlankZero = true;
                }
                field("Sales Price"; rec."Sales Price")
                {

                    BlankZero = true;
                    Editable = false;
                }
                field("Cert Source PEM amount"; rec."Cert Source PEM amount")
                {

                    BlankZero = true;
                }
                field("Contract Price"; rec."Contract Price")
                {

                    BlankZero = true;
                    Editable = FALSE;
                }
                field("Cert Term PEC amount"; rec."Cert Term PEC amount")
                {

                    BlankZero = true;
                }
                field("Cert Source PEC amount"; rec."Cert Source PEC amount")
                {

                    BlankZero = true;
                }
                field("Measurement Adjustment"; rec."Measurement Adjustment")
                {

                    BlankZero = true;
                    Visible = seeRed;
                }
                field("Previous Redetermined Price"; rec."Previous Redetermined Price")
                {

                    BlankZero = true;
                    Visible = seeRed;
                }
                field("Last Price Redetermined"; rec."Last Price Redetermined")
                {

                    BlankZero = true;
                    Visible = seeRed;
                }
                field("Cert Term RED amount"; rec."Cert Term RED amount")
                {

                    BlankZero = true;
                    Visible = seeRed;
                }
                field("Cert Source RED amount"; rec."Cert Source RED amount")
                {

                    BlankZero = true;
                    Visible = seeRed;
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

                Visible = false;
                group("group35")
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
                group("group38")
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

            action("action1")
            {
                CaptionML = ENU = 'Bring Measurements', ESP = 'Traer mediciones';
                Image = LinkWithExisting;

                trigger OnAction()
                BEGIN
                    BringMeasure;
                    CurrPage.UPDATE;
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Bring Measurements', ESP = 'Borrar L�neas';
                Image = Delete;

                trigger OnAction()
                BEGIN
                    DeleteLines;
                    CurrPage.UPDATE;
                END;


            }
            group("group4")
            {
                CaptionML = ENU = '&Line', ESP = 'L�nea';
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        _ShowDimensions;
                    END;


                }

            }
            group("group6")
            {
                CaptionML = ENU = 'F&unctions', ESP = 'Acci&ones';
                action("SeeAditionalText")
                {

                    CaptionML = ENU = 'See &Additional Text', ESP = '&textos adicionales';
                    RunObject = Page 7206929;
                    RunPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework No.");
                    Image = Text
    ;
                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        SetEditable;
        IF NOT DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework No.") THEN  //Q13466
            DataPieceworkForProduction.INIT;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."Document type" := rec."Document type"::Certification;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.UPDATE;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        SetEditable;
        CalcTotals;
    END;



    var
        MeasurementHeader: Record 7207336;
        MeasurementLines: Record 7207337;
        isHeader: Boolean;
        perPEM: Decimal;
        perPEC: Decimal;
        oriPEM: Decimal;
        oriPEC: Decimal;
        dif: Decimal;
        seeRed: Boolean;
        DataPieceworkForProduction: Record 7207386;

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure BringMeasure();
    var
        BringPostedMeasurements: Codeunit 7207283;
    begin
        MeasurementHeader.GET(rec."Document No.");
        BringPostedMeasurements.GetMeditions(MeasurementHeader."No.", MeasurementHeader."Job No.", MeasurementHeader."Customer No.");
        //CODEUNIT.RUN(CODEUNIT::"Bring Posted Measurements",Rec);
    end;

    LOCAL procedure DeleteLines();
    begin
        //Eliminar las l�neas de la certificaci�n
        MeasurementLines.RESET;
        MeasurementLines.SETRANGE("Document No.", rec."Document No.");
        MeasurementLines.DELETEALL;
    end;

    LOCAL procedure CalcTotals();
    begin
        if MeasurementHeader.GET(rec."Document No.") then begin
            MeasurementHeader.CalculateTotals;

            MeasurementLines.RESET;
            MeasurementLines.SETRANGE("Document No.", rec."Document No.");
            MeasurementLines.CALCSUMS("Cert Term PEM amount","Cert Source PEM amount", "Cert Term PEC amount", "Cert Source PEC amount");
            perPEM := MeasurementLines."Cert Term PEM amount";
            perPEC := MeasurementLines."Cert Term PEC amount";
            oriPEM := MeasurementLines."Cert Source PEM amount";
            oriPEC := MeasurementLines."Cert Source PEC amount";
            dif := perPEC - MeasurementHeader."Amount Document";
        end ELSE begin
            perPEM := 0;
            perPEC := 0;
            oriPEM := 0;
            oriPEC := 0;
            dif := 0;
        end;
    end;

    LOCAL procedure SetEditable();
    begin
        isHeader := (rec."Piecework No." = '');
        // if (MeasurementHeader.GET(rec."Document No.")) then
        //  seeRed := (MeasurementHeader."Certification Type" = MeasurementHeader."Certification Type"::"Price adjustment")
        // ELSE
        seeRed := FALSE;
    end;

    // begin
    /*{
      Q13466 QMD 25/05/21 - Se a�ade la unidad de medida de la unidad de obra
      JAV 15/09/21: - QB 1.09.18 Se hacen no visible los campos de las Redeterminaciones
    }*///end
}







