page 7207521 "Post. Prod. Meas. Line Subform"
{
    Editable = false;
    CaptionML = ENU = 'Lines', ESP = 'L�neas';
    SourceTable = 7207402;
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

                    Visible = false;
                }
                field("Line No."; rec."Line No.")
                {

                    Visible = false;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    Visible = false;
                }
                field("Piecework No."; rec."Piecework No.")
                {

                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                }
                field("Additional Text Code"; rec."Additional Text Code")
                {

                    Visible = seeAditionalCode;
                }
                field("Description"; rec."Description")
                {

                }
                field("% Progress To Source"; rec."% Progress To Source")
                {

                    StyleExpr = stValues;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Measure Term"; rec."Measure Term")
                {

                    StyleExpr = stValues;
                }
                field("Measure Source"; rec."Measure Source")
                {

                    StyleExpr = stValues;
                }
                field("PROD Price Old"; rec."PROD Price Old")
                {

                    StyleExpr = stOldPrice;
                }
                field("PROD Price"; rec."PROD Price")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("PROD Amount Realiced"; rec."PROD Amount Realiced")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("PROD Amount Term"; rec."PROD Amount Term")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("PROD Amount to Source"; rec."PROD Amount to Source")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Measure Pending"; rec."Measure Pending")
                {

                }
                field("Measure Realized"; rec."Measure Realized")
                {

                }
                field("DataPieceworkForProduction.% Processed Production"; DataPieceworkForProduction."% Processed Production")
                {

                    CaptionML = ESP = '% producci�n tramitada';
                    Editable = false;
                }
                field("PROD Amount Term * DataPieceworkForProduction.% Processed Production / 100"; rec."PROD Amount Term" * DataPieceworkForProduction."% Processed Production" / 100)
                {

                    CaptionML = ESP = 'Importe Producci�n';
                    Editable = false;
                }
                field("DataPieceworkForProduction.Unit Of Measure"; DataPieceworkForProduction."Unit Of Measure")
                {

                    CaptionML = ENU = 'Unit Of Measure', ESP = 'Unidad de medida';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("PEM Price"; rec."PEM Price")
                {

                    ToolTipML = ESP = 'Campo informativo.  Precio de Ejecuci�n por Contrato asociado a la Unidad de Obra';
                }
                field("PEM Amount Term"; rec."PEM Amount Term")
                {

                    ToolTipML = ESP = 'Campo informativo.  Importe del periodo valorado al Precio de Ejecuci�n por Contrato asociado a la Unidad de Obra';
                }
                field("PEM Amount Source"; rec."PEM Amount Source")
                {

                    ToolTipML = ESP = 'Campo informativo.  Importe a origen valorado al Precio de Ejecuci�n por Contrato asociado a la Unidad de Obra';
                }
                field("PEC Price"; rec."PEC Price")
                {

                    ToolTipML = ESP = 'Campo informativo.  Precio de Ejecuci�n por Contrato asociado a la Unidad de Obra';
                }
                field("PEC Amount Term"; rec."PEC Amount Term")
                {

                    ToolTipML = ESP = 'Campo informativo.  Importe del periodo valorado al Precio de Ejecuci�n por Contrato asociado a la Unidad de Obra';
                }
                field("PEC Amount Source"; rec."PEC Amount Source")
                {

                    ToolTipML = ESP = 'Campo informativo.  Importe a origen valorado al Precio de Ejecuci�n por Contrato asociado a la Unidad de Obra';
                }

            }
            group("group35")
            {

                field("COSTAnt"; COSTAnt)
                {

                    CaptionML = ESP = 'Importe Anterior';
                    Enabled = false;
                }
                field("COSTPer"; COSTPer)
                {

                    CaptionML = ESP = 'Importe Periodo';
                    Enabled = false;
                }
                field("COSTOri"; COSTOri)
                {

                    CaptionML = ESP = 'Importe Origen';
                    Enabled = false

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
                CaptionML = ENU = 'Bill of Item Measurement Lines', ESP = 'L�neas de medici�n';
                Image = ItemTrackingLines;

                trigger OnAction()
                BEGIN
                    ShowBillofItemMeasurement
                END;


            }
            group("group3")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;


                    trigger OnAction()
                    BEGIN
                        _ShowDimensions
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 09/10/20: - QB 1.06.20 Se a�ade la columna del c�digo adicional y su condici�n de visible
        QuoBuildingSetup.GET();
        seeAditionalCode := (QuoBuildingSetup."Use Aditional Code");
    END;

    trigger OnAfterGetRecord()
    BEGIN
        IF NOT DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework No.") THEN  //Q13466
            DataPieceworkForProduction.INIT
        ELSE
            DataPieceworkForProduction.CALCFIELDS("Amount Production Performed");

        OnAfterGet;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        OnAfterGet;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
        HistProdMeasureLines: Record 7207402;
        seeAditionalCode: Boolean;
        stInicial: Text;
        Text000: TextConst ESP = 'Debe recaclular el presupuesto del proyecto para que los c�lculos sean correctos';
        COSTAnt: Decimal;
        COSTPer: Decimal;
        COSTOri: Decimal;
        enMed: Boolean;
        edValues: Boolean;
        stValues: Text;
        stOldPrice: Text;

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    procedure ShowBillofItemMeasurement();
    var
        locrecPostMeasLinesBillofItem: Record 7207396;
        locpagePostMeasurBillofItem: Page 7207375;
    begin
        locrecPostMeasLinesBillofItem.SETRANGE("Document No.", rec."Document No.");
        locrecPostMeasLinesBillofItem.SETRANGE("Line No.", rec."Line No.");
        CLEAR(locpagePostMeasurBillofItem);
        locpagePostMeasurBillofItem.SETTABLEVIEW(locrecPostMeasLinesBillofItem);
        locpagePostMeasurBillofItem.EDITABLE(FALSE);
        locpagePostMeasurBillofItem.RUNMODAL;
    end;

    LOCAL procedure OnAfterGet();
    var
        i: Integer;
    begin
        //JAV 24/06/22: - QB 1.10.53 Cambiar los campos PEC por COST que es mas apropiado y se eliminan los PEM
        if (rec."Measure Initial" = rec."Measure Realized" + rec."Measure Pending") then
            stInicial := 'Subordinate'
        ELSE
            stInicial := 'Unfavorable';

        Rec.CALCFIELDS("No. Measurement");
        enMed := (rec."No. Measurement" <> 0);

        edValues := (not rec."From Measure");
        if (rec."From Measure") then
            stValues := 'Subordinate'
        ELSE
            stValues := 'None';

        if (rec."PROD Price Old" = 0) or (rec."PROD Price Old" = rec."PROD Price") then
            stOldPrice := 'Subordinate'
        ELSE
            stOldPrice := 'Unfavorable';

        HistProdMeasureLines.RESET;
        HistProdMeasureLines.SETRANGE("Document No.", rec."Document No.");
        HistProdMeasureLines.CALCSUMS("PROD Amount Realiced", "PROD Amount Term", "PROD Amount to Source");
        COSTAnt := HistProdMeasureLines."PROD Amount Realiced";
        COSTPer := HistProdMeasureLines."PROD Amount Term";
        COSTOri := HistProdMeasureLines."PROD Amount to Source";
        CurrPage.UPDATE(FALSE);
    end;

    // begin
    /*{
      JAV 30/05/19: - Se a�aden columnas cone l c�digo de la relaci�n valorada y la l�nea de la misma (no visible)
      JAV 09/10/20: - QB 1.06.20 Se hacen no visibles colunas de c�digo y fecha, se mueve la de Presto, y se a�ade el c�digo adicional
      Q13466 QMD 25/05/21 - Se a�ade la unidad de medida de la unidad de obra
      JAV 24/06/22: - QB 1.10.53 Cambiar los campos PEC por COST que es mas apropiado y se eliminan los PEM
    }*///end
}







