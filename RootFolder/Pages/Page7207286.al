page 7207286 "Piecework Card"
{
    CaptionML = ENU = 'Piecework Card', ESP = 'Ficha unidad de obra';
    SourceTable = 7207277;
    PopulateAllFields = true;
    PageType = Card;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("group15")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("Cost Database Default"; rec."Cost Database Default")
                {

                    Editable = FALSE;
                }
                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Account Type"; rec."Account Type")
                {

                }
                field("Totaling"; rec."Totaling")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Alias"; rec."Alias")
                {

                }
                field("Units of Measure"; rec."Units of Measure")
                {

                }
                field("Unit Type"; rec."Unit Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Identation"; rec."Identation")
                {

                }
                field("Automatic Additional Text"; rec."Automatic Additional Text")
                {

                }
                field("Blocked"; rec."Blocked")
                {

                }
                field("Date Last Modified"; rec."Date Last Modified")
                {

                }

            }
            group("group29")
            {

                CaptionML = ENU = 'Registering', ESP = 'Registro';
                field("Certification Unit"; rec."Certification Unit")
                {

                    Editable = TRUE;
                }
                group("group31")
                {

                    CaptionML = ESP = 'Mediciones';
                    field("Measurement Cost"; rec."Measurement Cost")
                    {

                        Editable = edCostMeasure;
                    }
                    field("Measurement Sale"; rec."Measurement Sale")
                    {

                        Editable = edSalesMeasure;
                    }

                }
                group("group34")
                {

                    CaptionML = ESP = 'Precios';
                    field("Price Cost"; rec."Price Cost")
                    {

                        Editable = edCostPrice;
                    }
                    field("Proposed Sale Price"; rec."Proposed Sale Price")
                    {

                        Editable = edSalesPrice;
                    }
                    field("% Margin"; rec."% Margin")
                    {

                        Editable = edSalesPrice;
                    }
                    field("Gross Profit Percentage"; rec."Gross Profit Percentage")
                    {

                    }

                }

            }
            group("group39")
            {

                CaptionML = ENU = 'Subcontrating', ESP = 'Subcontrataci�n';
                field("Resource Subcontracting Code"; rec."Resource Subcontracting Code")
                {

                }
                field("Concept Analitycal Subcon Code"; rec."Concept Analitycal Subcon Code")
                {

                }
                field("Cod. Activity"; rec."Cod. Activity")
                {

                }

            }
            group("group43")
            {

                CaptionML = ENU = 'Cost Unit', ESP = 'Unidad Coste Indirecto';
                field("Subtype Cost"; rec."Subtype Cost")
                {

                }
                field("Type Cost Unit"; rec."Type Cost Unit")
                {

                }
                field("Periodic Cost"; rec."Periodic Cost")
                {

                }
                field("Allocation Terms"; rec."Allocation Terms")
                {

                }
                field("Posting Group Unit Cost"; rec."Posting Group Unit Cost")
                {

                }
                field("Jobs Structured Billing"; rec."Jobs Structured Billing")
                {

                }

            }

        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Masterpiece', ESP = 'Maestra';
                action("action1")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Piecework"), "No." = FIELD("Unique Code");
                    Image = ViewComments;
                }
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(7207277), "No." = FIELD("Unique Code");
                    Image = Dimensions;
                }
                separator("separator3")
                {

                }
                action("action4")
                {
                    CaptionML = ENU = 'Created subcontrating resource', ESP = 'Crear recurso subcontrataci�n';
                    Image = CreateInteraction;

                    trigger OnAction()
                    VAR
                        JobsUnits: Record 7207277;
                        // ResourceGenerateSubcontract: Report 7207303;
                    BEGIN
                        JobsUnits.SETRANGE("Cost Database Default", rec."Cost Database Default");
                        JobsUnits.SETRANGE("No.", rec."No.");
                        IF JobsUnits.FINDFIRST THEN BEGIN
                            // ResourceGenerateSubcontract.SETTABLEVIEW(JobsUnits);
                            // ResourceGenerateSubcontract.RUNMODAL;
                        END;
                    END;


                }
                action("action5")
                {
                    CaptionML = ENU = 'Date of Bill of Item', ESP = 'Datos de descompuesto';
                    RunObject = Page 7207509;
                    RunPageView = SORTING("Cost Database Default", "No.");
                    RunPageLink = "Cost Database Default" = FIELD("Cost Database Default"), "No." = FIELD("No.");
                    Image = BinContent;
                }
                separator("separator6")
                {

                }
                action("Extended Text")
                {

                    CaptionML = ENU = 'Extended Text', ESP = 'Textos adicionales';
                    RunObject = Page 7206929;
                    RunPageLink = "Table" = CONST("Preciario"), "Key1" = FIELD("Cost Database Default"), "Key2" = FIELD("No.");
                    Image = Text;
                }
                separator("separator8")
                {

                }
                action("action9")
                {
                    CaptionML = ENU = 'Measure Line', ESP = 'L�neas de medici�n Coste';
                    Image = ServiceLines;

                    trigger OnAction()
                    VAR
                        ManagementLineofMeasure: Codeunit 7207292;
                    BEGIN
                        IF rec."Account Type" = rec."Account Type"::Heading THEN
                            ERROR(Text001);
                        ManagementLineofMeasure.editMeasureLinePieceworkPRESTO(rec."Cost Database Default", rec."No.", 0);
                    END;


                }
                action("action10")
                {
                    CaptionML = ENU = 'Measure Line', ESP = 'L�neas de medici�n Venta';
                    Image = ServiceLines;

                    trigger OnAction()
                    VAR
                        ManagementLineofMeasure: Codeunit 7207292;
                    BEGIN
                        IF rec."Account Type" = rec."Account Type"::Heading THEN
                            ERROR(Text001);
                        ManagementLineofMeasure.editMeasureLinePieceworkPRESTO(rec."Cost Database Default", rec."No.", 1);
                    END;


                }

            }

        }
        area(Processing)
        {


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
            }
        }
    }


    trigger OnClosePage()
    VAR
        Piecework: Record 7207277;
    BEGIN
        IF (Modi) THEN BEGIN
            //JAV 24/11/22: - QB 1.12.24 Nueva funci�n de rec�lculo de la unidad
            Piecework.GET(Rec."Cost Database Default", Rec."No.");
            Piecework.CalculateLine();
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        Rec.CALCFIELDS("No. DP Cost", "No. DP Sale", "No. Medition detail Cost", "No. Medition detail Sales");
        edCostPrice := (rec."Account Type" = rec."Account Type"::Unit) AND (rec."No. DP Cost" = 0);
        edSalesPrice := (rec."Account Type" = rec."Account Type"::Unit) AND (rec."No. DP Sale" = 0);
        edCostMeasure := (rec."Account Type" = rec."Account Type"::Unit) AND (rec."No. Medition detail Cost" = 0);
        edSalesMeasure := (rec."Account Type" = rec."Account Type"::Unit) AND (rec."No. Medition detail Sales" = 0);
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        Modi := TRUE;
    END;



    var
        Text001: TextConst ENU = 'It isn�t defined measure line data for larger unit of jobs.', ESP = 'No se definen datos de l�neas de medici�n para mayores de unidades de obra.';
        Modi: Boolean;
        edCostPrice: Boolean;
        edSalesPrice: Boolean;
        edCostMeasure: Boolean;
        edSalesMeasure: Boolean;/*

    begin
    {
      JAV 04/10/19: - Se reordenan un poco los campos y se elimina el campo de subtipo de coste duplicado
      JAV 12/04/22: - QB 1.10.35 Se cambia el caption del campo "Fecha �ltima modificaci�n" para homogeneizar y mejorar la sincronizaci�n
      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3.
    }
    end.*/


}







