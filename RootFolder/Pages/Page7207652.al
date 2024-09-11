page 7207652 "Job Piecework Card for Sales"
{
    CaptionML = ENU = 'Job Piecework Card', ESP = 'Ficha unidad de obra Proyecto';
    SourceTable = 7207386;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            group("group13")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("Job No."; rec."Job No.")
                {

                    Editable = False;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Piecework Code"; rec."Piecework Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                }
                field("Type"; rec."Type")
                {

                }
                field("Account Type"; rec."Account Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Indentation"; rec."Indentation")
                {

                }
                field("Totaling"; rec."Totaling")
                {

                }
                field("Record Type"; rec."Record Type")
                {

                }
                field("Record Status"; rec."Record Status")
                {

                }
                field("% Processed Production"; rec."% Processed Production")
                {

                }
                field("Additional Auto Text"; rec."Additional Auto Text")
                {

                }
                field("Blocked"; rec."Blocked")
                {

                }
                field("Last Modified Date"; rec."Last Modified Date")
                {

                }
                field("No. Record"; rec."No. Record")
                {

                }
                field("Production Unit"; rec."Production Unit")
                {

                }
                field("Customer Certification Unit"; rec."Customer Certification Unit")
                {

                }
                field("Rental Unit"; rec."Rental Unit")
                {

                }
                field("% Of Margin"; rec."% Of Margin")
                {

                }
                field("Quantity in Measurements"; rec."Quantity in Measurements")
                {

                }
                field("% Expense Cost"; rec."% Expense Cost")
                {

                }
                field("Allow Over Measure"; rec."Allow Over Measure")
                {

                }

            }
            group("group37")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {

                }
                field("Relationship Valued By Income"; rec."Relationship Valued By Income")
                {

                }

            }
            group("group41")
            {

                CaptionML = ENU = 'Subcontrating', ESP = 'Subcontrataciones';
                field("No. Subcontracting Resource"; rec."No. Subcontracting Resource")
                {

                }
                field("Analytical Concept Subcon Code"; rec."Analytical Concept Subcon Code")
                {

                }
                field("Price Subcontracting Cost"; rec."Price Subcontracting Cost")
                {

                }
                field("Activity Code"; rec."Activity Code")
                {

                }

            }
            group("group46")
            {

                CaptionML = ENU = 'Cost Unit', ESP = 'Udad. coste';
                field("Type Unit Cost"; rec."Type Unit Cost")
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
                field("Job Billing Structure"; rec."Job Billing Structure")
                {

                }
                field("Subtype Cost"; rec."Subtype Cost")
                {

                }

            }
            group("group53")
            {

                CaptionML = ENU = 'Rent Data', ESP = 'Datos alquiler';
                field("Element Of Rent"; rec."Element Of Rent")
                {

                }
                field("Analytical Concept Rent"; rec."Analytical Concept Rent")
                {

                }
                field("Unit Cost Element/Time"; rec."Unit Cost Element/Time")
                {

                }
                field("Rental Variant"; rec."Rental Variant")
                {

                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Master', ESP = '&Unidades de obra';
                action("action1")
                {
                    CaptionML = ENU = '&Comments', ESP = '&Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job Cost Piecework"), "No." = FIELD("Unique Code");
                }
                action("action2")
                {
                    CaptionML = ENU = 'Extended Text', ESP = 'Textos adicionales';
                    RunObject = Page 7206929;
                    RunPageView = SORTING("Table", "Key1", "Key2");
                    RunPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code");
                }
                action("action3")
                {
                    CaptionML = ENU = '&Dimensions', ESP = '&Dimensiones';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(7207386), "No." = FIELD("Unique Code");
                    Image = Dimensions;
                }
                separator("separator4")
                {

                }
                action("action5")
                {
                    CaptionML = ENU = '&Subcontract Create', ESP = 'Crear &Subcontrata';
                    Image = CreateWhseLoc;

                    trigger OnAction()
                    VAR
                        // GenResourceSubcontrJob: Report 7207315;
                    BEGIN
                        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                        DataPieceworkForProduction.SETRANGE("Piecework Code", rec."Piecework Code");
                        IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                            // GenResourceSubcontrJob.SETTABLEVIEW(DataPieceworkForProduction);
                            // GenResourceSubcontrJob.RUNMODAL;
                        END;
                    END;


                }
                action("action6")
                {
                    CaptionML = ENU = 'Bill of Item D&ata', ESP = 'D&atos de descompuesto';
                    Image = BinContent;

                    trigger OnAction()
                    BEGIN
                        ShowPiecework;
                    END;


                }
                separator("separator7")
                {

                }
                action("action8")
                {
                    CaptionML = ENU = '&L�neas de medici�n', ESP = '&L�neas de medici�n';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    BEGIN
                        ShowMeasureLinePiecework;
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
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
            }
        }
    }

    var
        DataPieceworkForProduction: Record 7207386;
        Text002: TextConst ENU = 'No bill of item or detail of measurement lines can be defined in major piecework.', ESP = 'No se pueden definir descompuestos ni detalle de l�neas de medici�n en mayores de unidades de obra.';
        ManagementLineofMeasure: Codeunit 7207292;

    procedure ShowPiecework();
    var
        DataCostByPieceworkCert: Record 7207340;
    begin
        //JAV 13/10/20: - QB 1.06.20 Se muestran los descompuestos de venta y no los de coste
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text002);
        DataCostByPieceworkCert.RESET;
        DataCostByPieceworkCert.FILTERGROUP(2);
        DataCostByPieceworkCert.SETRANGE("Job No.", rec."Job No.");
        DataCostByPieceworkCert.SETRANGE("Piecework Code", rec."Piecework Code");
        DataCostByPieceworkCert.FILTERGROUP(0);
        PAGE.RUNMODAL(PAGE::"Bill of Items Piec Sales", DataCostByPieceworkCert);
    end;

    procedure ShowMeasureLinePiecework();
    var
        Job: Record 167;
        ManagementLineofMeasure: Codeunit 7207292;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text002);
        ManagementLineofMeasure.editMeasureLinePieceworkCertif(rec."Job No.", rec."Piecework Code")
    end;

    // begin
    /*{
      JAV 13/10/20: - QB 1.06.20 Se muestran los descompuestos de venta y no los de coste
    }*///end
}







