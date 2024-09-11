page 7207287 "Piecework List"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Piecework List', ESP = 'Lista unidad de obra';
    SourceTable = 7207277;
    PopulateAllFields = true;
    PageType = ListPart;
    CardPageID = "Piecework Card";

    layout
    {
        area(content)
        {
            repeater("table")
            {

                IndentationColumn = rec.Identation;
                IndentationControls = "Cost Database Default", "No.";
                ShowAsTree = true;
                FreezeColumn = "Description";
                field("No."; rec."No.")
                {

                    StyleExpr = stLine;
                }
                field("PRESTO Code Cost"; rec."PRESTO Code Cost")
                {

                    StyleExpr = stLine;
                }
                field("PRESTO Code Sales"; rec."PRESTO Code Sales")
                {

                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stLine;
                }
                field("Account Type"; rec."Account Type")
                {

                    StyleExpr = stLineType;
                }
                field("Production Unit"; rec."Production Unit")
                {

                }
                field("Certification Unit"; rec."Certification Unit")
                {

                    StyleExpr = stLine;
                }
                field("Units of Measure"; rec."Units of Measure")
                {

                    StyleExpr = stLine;
                }
                field("Cod. Activity"; rec."Cod. Activity")
                {

                    StyleExpr = stLine;
                }
                field("Unit Type"; rec."Unit Type")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Identation"; rec."Identation")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Posting Group Unit Cost"; rec."Posting Group Unit Cost")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Allocation Terms"; rec."Allocation Terms")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Type Cost Unit"; rec."Type Cost Unit")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Totaling"; rec."Totaling")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Diferencia"; rec."Diferencia")
                {

                }
                field("Diferencia Descompuesto"; rec."Diferencia Descompuesto")
                {

                    Editable = false;
                }
                field("Measurement Cost"; rec."Measurement Cost")
                {

                    Editable = edMedCost;
                    StyleExpr = stLinemedCost;
                }
                field("Base Price Cost"; rec."Base Price Cost")
                {

                    Visible = false;
                    Editable = edPriceCost;
                    StyleExpr = stLinePriceCost;
                }
                field("Price Cost"; rec."Price Cost")
                {

                    Editable = edPriceCost;
                    StyleExpr = stLinePriceCost;
                }
                field("Total Amount Cost"; rec."Total Amount Cost")
                {

                    StyleExpr = stLineTotalCost;
                }
                field("Measurement Sale"; rec."Measurement Sale")
                {

                    Editable = edMedSale;
                    StyleExpr = stLinemedVenta;
                }
                field("Base Price Sales"; rec."Base Price Sales")
                {

                    Visible = false;
                    Editable = edPriceSale;
                    StyleExpr = stLinepriceVenta;
                }
                field("Proposed Sale Price"; rec."Proposed Sale Price")
                {

                    Editable = edPriceSale;
                    StyleExpr = stLinepriceVenta;
                }
                field("Total Amount Sales"; rec."Total Amount Sales")
                {

                    StyleExpr = stLineTotalVenta;
                }
                field("Aditional Text"; rec."Aditional Text")
                {

                    StyleExpr = stLine;
                }
                field("No. DP Cost"; rec."No. DP Cost")
                {

                    StyleExpr = stLine;
                }
                field("No. DP Sale"; rec."No. DP Sale")
                {

                    StyleExpr = stLine;
                }
                field("No. Medition detail Cost"; rec."No. Medition detail Cost")
                {

                    StyleExpr = stLine;
                }
                field("No. Medition detail Sales"; rec."No. Medition detail Sales")
                {

                    StyleExpr = stLine;
                }
                field("Cost Database Default"; rec."Cost Database Default")
                {

                    Visible = false;
                    StyleExpr = stLine;
                }
                field("Father Code"; rec."Father Code")
                {

                    Visible = false;
                }
                field("Received Cost Price"; rec."Received Cost Price")
                {

                    Visible = false;
                }
                field("Received Sales Price"; rec."Received Sales Price")
                {

                    Visible = false;
                }
                field("Received Cost Medition"; rec."Received Cost Medition")
                {

                    Visible = false;
                }
                field("Received Sales Medition"; rec."Received Sales Medition")
                {

                    Visible = false

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("BillOfItem")
            {

                CaptionML = ENU = 'Data of Bill of Item', ESP = 'Datos de descompuestos';
                RunObject = Page 7207509;
                RunPageView = SORTING("Cost Database Default", "No.");
                RunPageLink = "Cost Database Default" = FIELD("Cost Database Default"), "No." = FIELD("No.");
                Promoted = true;
                Image = BinContent;
                PromotedCategory = Report;
                PromotedOnly = true;
            }
            action("ExtendedText")
            {

                CaptionML = ENU = 'Extended Text', ESP = 'Textos adicionales';
                RunObject = Page 7206929;
                RunPageLink = "Table" = CONST("Preciario"), "Key1" = FIELD("Cost Database Default"), "Key2" = FIELD("No.");
                Image = Text;
            }
            action("Comments")
            {

                CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                RunObject = Page 124;
                RunPageLink = "Table Name" = CONST("Piecework"), "No." = FIELD("Unique Code");
                Image = ViewComments;
            }
            group("Identation_")
            {

                CaptionML = ENU = 'Dimensions', ESP = 'Identaci�n';
                action("IdentatitionPlus")
                {

                    CaptionML = ENU = 'Identation +', ESP = 'Identaci�n +';
                    Image = Indent;

                    trigger OnAction()
                    BEGIN
                        rec.Identation += 1;
                        Rec.MODIFY;
                        CurrPage.UPDATE;
                    END;


                }
                action("IdentatitionMinus")
                {

                    CaptionML = ENU = 'Identation -', ESP = 'Identaci�n -';
                    Image = IndentChartOfAccounts;

                    trigger OnAction()
                    BEGIN
                        IF rec.Identation > 0 THEN
                            rec.Identation -= 1;
                        Rec.MODIFY;
                        CurrPage.UPDATE
                    END;


                }

            }
            group("Dimensions")
            {

                CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                action("Dimensions-Individual")
                {

                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions-Individual', ESP = 'Dimensiones-Individual';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(7207277), "No." = FIELD("Unique Code");
                    Image = Dimensions;
                }
                action("Dimensions-Multiples")
                {

                    CaptionML = ENU = 'Dimensions-Multiples', ESP = 'Dimensiones-Multiples';
                    Image = DimensionSets;


                    trigger OnAction()
                    VAR
                        JobsUnits: Record 7207277;
                        DefaultDimensionsMultiple: Page 542;
                    BEGIN
                        //JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
                        CurrPage.SETSELECTIONFILTER(JobsUnits);
                        DefaultDimensionsMultiple.ClearTempDefaultDim;
                        IF JobsUnits.FINDSET THEN
                            REPEAT
                                DefaultDimensionsMultiple.CopyDefaultDimToDefaultDim(DATABASE::Piecework, JobsUnits."Unique Code");
                            UNTIL Rec.NEXT = 0;
                        DefaultDimensionsMultiple.RUNMODAL;
                    END;


                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        SetStyles;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        SetStyles;
    END;



    var
        Text001: TextConst ENU = 'It isn�t defined measure line data for larger units of jobs.', ESP = 'No se definen datos de l�neas de medici�n para mayores de unidad de obra';
        Text002: TextConst ESP = 'Rec�lculo Finalizado';
        CDCode: Code[20];
        edMedCost: Boolean;
        edMedSale: Boolean;
        edPriceCost: Boolean;
        edPriceSale: Boolean;
        stLine: Text;
        stLineType: Text;
        stLineMedCost: Text;
        stLinePriceCost: Text;
        stLineTotalCost: Text;
        stLineMedVenta: Text;
        stLinePriceVenta: Text;
        stLineTotalVenta: Text;

    LOCAL procedure SetStyles();
    begin
        Rec.CALCFIELDS("Bill Of Items Cost", "Bill Of Items Sales", "Meditions Cost", "Meditions Sale", "Have Sons");
        if (rec."Account Type" = rec."Account Type"::Heading) then begin
            edPriceCost := not Rec."Have Sons";
            edPriceSale := not Rec."Have Sons";
            edMedCost := TRUE;
            edMedSale := TRUE;
        end ELSE begin
            edPriceCost := not Rec."Bill Of Items Cost";
            edPriceSale := not Rec."Bill Of Items Sales";
            edMedCost := not Rec."Meditions Cost";
            edMedSale := not Rec."Meditions Sale";
        end;

        if (rec."Account Type" = rec."Account Type"::Heading) then begin
            stLine := 'Strong';
            stLineMedCost := 'Strong';
            stLinePriceCost := 'Strong';
            stLineTotalCost := 'Strong';
            stLineMedVenta := 'StrongAccent';
            stLinePriceVenta := 'StrongAccent';
            stLineTotalVenta := 'StrongAccent';
            stLineType := 'Strong';
        end ELSE begin
            stLine := 'Standard';
            stLineMedCost := 'Standard';
            stLinePriceCost := 'Standard';
            stLineTotalCost := 'Standard';
            stLineMedVenta := 'StandardAccent';
            stLinePriceVenta := 'StandardAccent';
            stLineTotalVenta := 'StandardAccent';
            stLineType := 'Ambiguous';
        end;

        if (not edMedCost) then
            stLineMedCost := 'Subordinate';
        if (not edPriceCost) then
            stLinePriceCost := 'Subordinate';

        if (not edMedSale) then
            stLineMedVenta := 'Subordinate';
        if (not edPriceSale) then
            stLinePriceVenta := 'Subordinate';
    end;

    // begin
    /*{
      FR  21/05/18: - A�adido CardPart para el calculo de margenes y campos nuevos de la tabla Piecework.
      JAV 27/09/19: - Se a�ade un bot�n de rec�lculo de los datos del preciario.
      JAV 05/10/19: - Se promueve la acci�n de test y se unifican las dos codeunits para preciarios y proyectos en una sola
      JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Se a�aden los campos 60 a 69
      AML 24/03/23 Q18285 A�adidos campos diferencia
    }*///end
}








