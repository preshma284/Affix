page 7207304 "Measurement Lines Subform."
{
    CaptionML = ENU = 'Lines', ESP = 'L�neas';
    MultipleNewLines = true;
    SourceTable = 7207337;
    DelayedInsert = true;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No. Measurement"; rec."No. Measurement")
                {

                }
                field("From Measure"; rec."From Measure")
                {

                }
                field("Piecework No."; rec."Piecework No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Med. Pending Measurement"; rec."Med. Pending Measurement")
                {


                    ; trigger OnValidate()
                    BEGIN
                        //JAV 21/03/19: - Se a�aden currpage.update en los cmapos de mediciones para que se refresquen los totales de la cabecera
                        CurrPage.UPDATE;
                    END;


                }
                field("Med. % Measure"; rec."Med. % Measure")
                {

                    CaptionML = ENU = '% measure', ESP = '% de medici�n';
                    Editable = edValues;
                    StyleExpr = stValues;

                    ; trigger OnValidate()
                    BEGIN
                        //JAV 21/03/19: - Se a�aden currpage.update en los campos de mediciones para que se refresquen los totales de la cabecera
                        CurrPage.UPDATE;
                    END;


                }
                field("Med. Term Measure"; rec."Med. Term Measure")
                {

                    Editable = edValues;
                    StyleExpr = stTerm;

                    ; trigger OnValidate()
                    BEGIN
                        //JAV 21/03/19: - Se a�aden currpage.update en los campos de mediciones para que se refresquen los totales de la cabecera
                        CurrPage.UPDATE;
                    END;


                }
                field("Med. Source Measure"; rec."Med. Source Measure")
                {

                    Editable = edValues;
                    StyleExpr = stSource;

                    ; trigger OnValidate()
                    BEGIN
                        //JAV 21/03/19: - Se a�aden currpage.update en los campos de mediciones para que se refresquen los totales de la cabecera
                        CurrPage.UPDATE;
                    END;


                }
                field("Term PEM Price"; rec."Term PEM Price")
                {

                    Style = Unfavorable;
                    StyleExpr = PriceChanged;
                }
                field("Med. Term PEM Amount"; rec."Med. Term PEM Amount")
                {

                    Style = Unfavorable;
                    StyleExpr = PriceChanged;

                    ; trigger OnAssistEdit()
                    BEGIN
                        SeeLines;
                    END;


                }
                field("Sales Price"; rec."Sales Price")
                {

                    Editable = edPrice;
                    Style = Unfavorable;
                    StyleExpr = PriceChanged;

                    ; trigger OnValidate()
                    BEGIN
                        //JAV 21/03/19: - Se a�aden currpage.update en los campos de mediciones para que se refresquen los totales de la cabecera
                        CurrPage.UPDATE;
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        SeeLines;
                    END;


                }
                field("Med. Source PEM Amount"; rec."Med. Source PEM Amount")
                {

                    Style = Unfavorable;
                    StyleExpr = PriceChanged;

                    ; trigger OnAssistEdit()
                    BEGIN
                        SeeLines;
                    END;


                }
                field("Term PEC Price"; rec."Term PEC Price")
                {

                }
                field("Med. Term PEC Amount"; rec."Med. Term PEC Amount")
                {

                }
                field("Contract Price"; rec."Contract Price")
                {


                    ; trigger OnValidate()
                    BEGIN
                        //JAV 21/03/19: - Se a�aden currpage.update en los cmapos de mediciones para que se refresquen los totales de la cabecera
                        CurrPage.UPDATE;
                    END;


                }
                field("Med. Source PEC Amount"; rec."Med. Source PEC Amount")
                {

                    Style = Unfavorable;
                    StyleExpr = PriceChanged;
                }
                field("Last Price Redetermined"; rec."Last Price Redetermined")
                {

                    Visible = seeRED;
                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

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

                group("group32")
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
                group("group35")
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
                CaptionML = ESP = 'Traer L�neas';
                // PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    MeasurementHeader.GET(rec."Document No.");
                    MeasurementHeader.AddLines();
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Measurement Lines Bill of Item', ESP = 'Detalle l�neas de medici�n';
                Enabled = enMEd;
                Image = ItemTrackingLines;

                trigger OnAction()
                BEGIN
                    ShowBillofItemMeasurement;
                END;


            }
            group("group4")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action3")
                {
                    CaptionML = ENU = 'Data Piecework Meas-Cert List', ESP = 'Lista datos UO Med-Certif';
                    Image = EntriesList;

                    trigger OnAction()
                    BEGIN
                        seeListPiecework;
                    END;


                }
                action("action4")
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
            group("group7")
            {
                CaptionML = ENU = 'F&unctions', ESP = 'Acci&ones';
                action("SeeAditionalText")
                {

                    CaptionML = ENU = 'See Additional &Text', ESP = '&Textos adicionales';
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
        GetMastereader;
        edPrice := (MeasurementHeader."Certification Type" = MeasurementHeader."Certification Type"::"Price adjustment");
        IF NOT DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework No.") THEN  //Q13466
            DataPieceworkForProduction.INIT;

        SetStyles;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."Document type" := xRec."Document type";

        GetMastereader;
        rec."Job No." := MeasurementHeader."Job No.";
        rec."Document type" := MeasurementHeader."Document Type";
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CalcTotals;
        SetStyles;
        PriceChanged := rec.HavePriceChanged;
    END;



    var
        MeasurementHeader: Record 7207336;
        MeasurementLines: Record 7207337;
        DataPieceworkForProduction: Record 7207386;
        MeasureLinesBillofItem: Record 7207395;
        perPEM: Decimal;
        perPEC: Decimal;
        oriPEM: Decimal;
        oriPEC: Decimal;
        dif: Decimal;
        PriceChanged: Boolean;
        edPrice: Boolean;
        stTerm: Text;
        stSource: Text;
        edValues: Boolean;
        stValues: Text;
        enMed: Boolean;
        seeRED: Boolean;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure _ShowDimensions();
    begin
        rec.ShowDimensions;
    end;

    LOCAL procedure GetMastereader();
    begin
        if (not MeasurementHeader.GET(rec."Document No.")) then
            MeasurementHeader.INIT;
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
        locManagementLineofMeasure: Codeunit 7207292;
        locSourceMeasure: Decimal;
        locTermMeasure: Decimal;
        locConfirmed: Boolean;
        MeasurementLines: Record 7207337;
    begin
        //MeasurementLines.COPYFILTERS(Rec);
        //CurrPage.SETSELECTIONFILTER(Rec);
        //loccduManagementLineMeasure.BringMeasuresToDetails(Rec);
        //Rec.COPYFILTERS(MeasurementLines);

        //MeasurementHeader.GET(rec."Document No.");
        locManagementLineofMeasure.ConfirmBillofItemMeasure(locSourceMeasure, locTermMeasure, locConfirmed, rec."Document type", rec."Document No.", rec."Line No.");

        if locConfirmed then begin
            //Si no se ha tocado el % de medici�n no modificar los datos
            MeasureLinesBillofItem.RESET;
            MeasureLinesBillofItem.SETRANGE("Document type", rec."Document type");
            MeasureLinesBillofItem.SETRANGE("Document No.", rec."Document No.");
            MeasureLinesBillofItem.SETRANGE("Line No.", rec."Line No.");
            MeasureLinesBillofItem.SETFILTER("Measured % Progress", '<>%1', rec."Med. % Measure");
            if (not MeasureLinesBillofItem.ISEMPTY) then begin
                Rec.VALIDATE("From Measure", TRUE);
                Rec.VALIDATE("Med. Source Measure", locSourceMeasure);  //Esto quita la marca, la volvemos a poner
                Rec.VALIDATE("From Measure", TRUE);
                if not Rec.MODIFY then
                    Rec.INSERT;
            end;
        end;
    end;

    LOCAL procedure CalcTotals();
    begin
        if MeasurementHeader.GET(rec."Document No.") then begin
            MeasurementHeader.CalculateTotals;

            MeasurementLines.RESET;
            MeasurementLines.SETRANGE("Document No.", rec."Document No.");
            MeasurementLines.CALCSUMS("Med. Term PEM Amount", "Med. Term PEC Amount", "Med. Source PEM Amount", "Med. Source PEC Amount");
            perPEM := MeasurementLines."Med. Term PEM Amount";
            perPEC := MeasurementLines."Med. Term PEC Amount";
            oriPEM := MeasurementLines."Med. Source PEM Amount";
            oriPEC := MeasurementLines."Med. Source PEC Amount";
            dif := perPEC - MeasurementHeader."Amount Document";
        end ELSE begin
            perPEM := 0;
            perPEC := 0;
            oriPEM := 0;
            oriPEC := 0;
            dif := 0;
        end;
    end;

    LOCAL procedure SeeLines();
    var
        HistMeasureLines: Record 7207339;
        PostMeasureLinesList: Page 7207309;
    begin
        HistMeasureLines.RESET;
        HistMeasureLines.SETRANGE("Job No.", rec."Job No.");
        HistMeasureLines.SETRANGE("Piecework No.", rec."Piecework No.");

        CLEAR(PostMeasureLinesList);
        PostMeasureLinesList.SETTABLEVIEW(HistMeasureLines);
        PostMeasureLinesList.RUN;
    end;

    LOCAL procedure SetStyles();
    begin
        Rec.CALCFIELDS("No. Measurement");
        enMed := (rec."No. Measurement" <> 0);

        edValues := (not rec."From Measure");
        if (rec."From Measure") then
            stValues := 'Subordinate'
        ELSE
            stValues := 'None';

        if (rec."Med. Term Measure" >= 0) then begin
            if (rec."From Measure") then
                stTerm := 'Subordinate'
            ELSE
                stTerm := 'Standar'
        end ELSE
            stTerm := 'Attention';

        if (rec."Med. % Measure" <= 100) then begin
            if (rec."From Measure") then
                stSource := 'Subordinate'
            ELSE
                stSource := 'Standar'
        end ELSE
            stSource := 'Ambiguous';
    end;

    // begin
    /*{
      JAV 21/03/19: - Se a�aden currpage.update en los campos de mediciones para que se refresquen los totales de la cabecera
      Q13466 QMD 25/05/21 - Se a�ade la unidad de medida de la unidad de obra
      JAV 15/09/21: - QB 1.09.18 Se hace no visible el campo rec."Last Price Redetermined"
    }*///end
}







