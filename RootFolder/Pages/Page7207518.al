page 7207518 "Prod. Measure Lines Subform."
{
    CaptionML = ENU = 'Lines', ESP = 'Lineas';
    MultipleNewLines = true;
    SourceTable = 7207400;
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


                    ; trigger OnValidate()
                    BEGIN
                        IF NOT DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework No.") THEN
                            CLEAR(DataPieceworkForProduction);

                        CurrPage.UPDATE;
                    END;


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
                field("Measure Initial"; rec."Measure Initial")
                {

                    StyleExpr = stInicial;
                }
                field("Measure Realized + Measure Pending"; rec."Measure Realized" + rec."Measure Pending")
                {

                    CaptionML = ESP = 'Medici�n total';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Measure Pending"; rec."Measure Pending")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("% Progress Cost"; rec."% Progress Cost")
                {

                    Editable = FALSE;
                }
                field("% Progress To Source"; rec."% Progress To Source")
                {

                    Editable = edValues;
                    StyleExpr = stValues;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Measure Term"; rec."Measure Term")
                {

                    Editable = edValues;
                    StyleExpr = stValues;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Measure Source"; rec."Measure Source")
                {

                    Editable = edValues;
                    StyleExpr = stValues;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Pending Production Price"; rec."Pending Production Price")
                {

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
                field("DataPieceworkForProduction.CostPrice"; DataPieceworkForProduction.CostPrice)
                {

                    CaptionML = ESP = 'Precio de coste';
                    Visible = False;
                    Editable = False;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("DataPieceworkForProduction.PriceSales"; DataPieceworkForProduction.PriceSales)
                {

                    CaptionML = ESP = 'Precio Base';
                    Visible = False;
                    Editable = False;
                    Style = Strong;
                    StyleExpr = TRUE;
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
            group("group37")
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
                CaptionML = ESP = 'Traer L�neas';
                // PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    ProdMeasureHeader.GET(rec."Document No.");
                    ProdMeasureHeader.AddLines();
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Measurement Lines Bill of Item', ESP = 'Detalle l�neas de medici�n';
                Enabled = enMEd;
                Image = ItemTrackingLines;

                trigger OnAction()
                BEGIN
                    ShowMeditions;
                END;


            }
            group("group4")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action3")
                {
                    CaptionML = ENU = 'Data Piecework', ESP = 'Datos Unidad obra';
                    Image = SuggestSalesPrice;

                    trigger OnAction()
                    BEGIN
                        funDataLine;
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

        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 09/10/20: - QB 1.06.20 Se a�ade la columna del c�digo adicional y su condici�n de visible
        QuoBuildingSetup.GET();
        seeAditionalCode := (QuoBuildingSetup."Use Aditional Code");
    END;

    trigger OnAfterGetRecord()
    VAR
        Job: Record 167;
    BEGIN
        //QB5896 >>
        //JAV 21/02/22: - QB 1.10.21 Se condiciona para evitar error al abrir la p�gina
        IF Job.GET(rec."Job No.") THEN BEGIN

            JobBudget.GET(rec."Job No.", Rec.GetBudget);
            IF (JobBudget."Pending Calculation Budget") THEN
                ERROR(Text000);

            IF NOT DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework No.") THEN  //Q13466
                DataPieceworkForProduction.INIT;

            //"Contract Price" := DataPieceworkForProduction."Contract Price";
        END;
        //QB5896 <<

        rec.ShowShortcutDimCode(ShortcutDimCode);

        OnAfterGet;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        CLEAR(ShortcutDimCode);
        CLEAR(DataPieceworkForProduction);

        IF ProdMeasureHeader.GET(rec."Document No.") THEN
            rec."Job No." := ProdMeasureHeader."Job No.";
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        //JAV 26/03/19: - Propagar los importes modificados hacia arriba con CurrPage.UPDATE
        CurrPage.UPDATE;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        OnAfterGet;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        Job: Record 167;
        ProdMeasureHeader: Record 7207399;
        ProdMeasureLines: Record 7207400;
        DataPieceworkForProduction: Record 7207386;
        JobBudget: Record 7207407;
        ShortcutDimCode: ARRAY[8] OF Code[20];
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

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure funDataLine();
    var
        DataPieceworkForProduction: Record 7207386;
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Piecework Code", rec."Piecework No.");
        //JAV 02/04/19: - La acci�n de ver U.O. se cambia para que saque directamente la ficha y no la lista
        //PAGE.RUNMODAL(PAGE::"Data Piecework List",DataPieceworkForProduction);
        PAGE.RUNMODAL(PAGE::"Job Piecework Card", DataPieceworkForProduction);
    end;

    procedure ShowMeditions();
    var
        locManagementLineofMeasure: Codeunit 7207292;
        locSourceMeasure: Decimal;
        locTermMeasure: Decimal;
        locConfirmed: Boolean;
    begin
        ProdMeasureHeader.GET(rec."Document No.");
        locManagementLineofMeasure.ConfirmBillofItemMeasure(locSourceMeasure, locTermMeasure, locConfirmed, Enum::"Sales Line Type".FromInteger(2), rec."Document No.", rec."Line No.");
        if locConfirmed then begin
            rec."Measure Source" := locSourceMeasure;  //No podemos hacer el Rec.VALIDATE porque la funci�n CalcMeasureAmount rehace las l�neas
            rec.UpdateMeasureTerm;
            rec.CalcMeasureAmount(FALSE);
            Rec.VALIDATE("From Measure", TRUE);
            //-Q17698 AML 25/05/23
            Rec.VALIDATE("Measure Source");
            //+Q17698
            Rec.MODIFY;
        end;
    end;

    LOCAL procedure OnBeforePutRecord();
    begin
        if ProdMeasureHeader.GET(rec."Document No.") then
            rec."Job No." := ProdMeasureHeader."Job No.";
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

        ProdMeasureLines.RESET;
        ProdMeasureLines.SETRANGE("Document No.", rec."Document No.");
        ProdMeasureLines.CALCSUMS("PROD Amount Realiced", "PROD Amount Term", "PROD Amount to Source");
        COSTAnt := ProdMeasureLines."PROD Amount Realiced";
        COSTPer := ProdMeasureLines."PROD Amount Term";
        COSTOri := ProdMeasureLines."PROD Amount to Source";

        CurrPage.UPDATE(FALSE);
    end;

    // begin
    /*{
      QB5896 PGM 25/01/2019 - A�adidos los campos "Contract Price" y "Contract Amount"
      JAV 26/03/19: - Propagar los importes modificados hacia arriba con CurrPage.UPDATE
      JAV 02/04/19: - Mejoras en mediciones: Se elimina la funci�n funColumns que ya no tienen sentido, y las variables MeasureOriginEditable y MeasureTermEditable que no se usaban como deb�a
                    - La acci�n de ver U.O. se cambia para que saque directamente la ficha y no la lista
                    - Mas CurrPage.UPDATE en el Rec.DELETE
                    - Se eliminan las variables globales "Contract Amount" y "Contract Price" que ya se han a�adido a la tabla
      PGM 16/10/19: - Q8047 Se controla que solo se puedan elegir las unidades de obra, segun el cliente que se informe.
      JAV 09/10/20: - QB 1.06.20 Se a�ade la columna del c�digo adicional y su condici�on de visible
      JAV 19/11/20: - QB 1.07.06 Se a�ade una columna con la medici�n inicial de la U.O.
      QMD 25/05/21: - Q13466 Se a�ade la unidad de medida de la unidad de obra
      JAV 15/09/21: - QB 1.09.17 Se fuerza el ver solo los campos PEC y no los PEM, que es lo adecuado.
      JAV 03/12/21: - QB 1.10.07 Se a�ade la columna del c�digo U.O. Presto
      JAV 24/06/22: - QB 1.10.53 Cambiar los campos PEC por COST que es mas apropiado y se eliminan los PEM
      AML 06/06/23  - Q17698 Correcci�n de la manipulaci�n del avance por l�neas de medici�n.
    }*///end
}







