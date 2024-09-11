page 7207508 "Job Piecework Card"
{
    CaptionML = ENU = 'Job Piecework Card', ESP = 'Ficha unidad de obra Proyecto';
    SourceTable = 7207386;
    PopulateAllFields = true;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("group10")
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
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                }
                field("Additional Text Code"; rec."Additional Text Code")
                {

                    Visible = seeAditionalCode;
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


                    ; trigger OnValidate()
                    BEGIN
                        SetEditable;
                    END;


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
                field("Plannable"; rec."Plannable")
                {

                    Editable = false;
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
                Visible = seedirect;
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
                Visible = seeindirect;
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
                Visible = seeRental;
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
            group("group58")
            {

                CaptionML = ENU = 'Rent Data', ESP = 'Horas';
                Visible = seeHours;
                field("Registered Hours"; rec."Registered Hours")
                {

                }
                field("Manual Hours"; rec."Manual Hours")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Manual Hours + Registered Hours"; rec."Manual Hours" + rec."Registered Hours")
                {

                    CaptionML = ESP = 'Horas Totales';
                }
                field("Expected Hours"; rec."Expected Hours")
                {

                }
                field("Expected Hours - (Manual Hours + Registered Hours)"; rec."Expected Hours" - (rec."Manual Hours" + rec."Registered Hours"))
                {

                    CaptionML = ESP = 'Pendientes';
                    AutoFormatType = 2;
                }
                field("Registered Work Part"; rec."Registered Work Part")
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
                    Image = Comment;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Bill of Item D&ata', ESP = 'D&atos de descompuesto';
                    Image = BinContent;

                    trigger OnAction()
                    BEGIN
                        ShowPiecework;
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = '&L�neas de medici�n', ESP = '&L�neas de medici�n';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    BEGIN
                        ShowMeasureLinePiecework;
                    END;


                }
                action("action4")
                {
                    CaptionML = ENU = 'Extended Text', ESP = 'Textos adicionales';
                    RunObject = Page 7206929;
                    RunPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code");
                    Image = Text;
                }
                action("action5")
                {
                    CaptionML = ENU = '&Dimensions', ESP = '&Dimensiones';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(7207386), "No." = FIELD("Unique Code");
                    Image = Dimensions;
                }
                action("action6")
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
                            // GenResourceSubcontrJob.USEREQUESTPAGE(FALSE); //JAV 18/02/21: - No sacar la pantalla del report que no hace falta
                            // GenResourceSubcontrJob.RUNMODAL;
                            MESSAGE('Finalizado');
                        END;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        QuoBuildingSetup.GET();
        seeAditionalCode := (QuoBuildingSetup."Use Aditional Code");
        seeHours := (QuoBuildingSetup."Hours control" <> QuoBuildingSetup."Hours control"::No);
        seeRental := QuoBuildingSetup."Rental Management";   //JAV 25/06/22: - QB 1.10.44 Mejora en la pantalla, no ver datos que no son necesarios
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetEditable;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        DataPieceworkForProduction: Record 7207386;
        Text002: TextConst ENU = 'No bill of item or detail of measurement lines can be defined in major piecework.', ESP = 'No se pueden definir descompuestos ni detalle de l�neas de medici�n en mayores de unidades de obra.';
        Sale: Boolean;
        seeHours: Boolean;
        seeAditionalCode: Boolean;
        seeRental: Boolean;
        seeDirect: Boolean;
        seeIndirect: Boolean;

    procedure ShowPiecework();
    var
        Job: Record 167;
        DataCostByPiecework: Record 7207387;
        BillofItemsPiecbyJobCard: Page 7207513;
        DataPieceworkForProduction: Record 7207386;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text002);

        // DataCostByPiecework.FILTERGROUP(2);
        // DataCostByPiecework.RESET;
        // DataCostByPiecework.SETRANGE( "Job No.", rec. "Job No.");
        // DataCostByPiecework.SETRANGE( "Piecework Code", rec. "Piecework Code");
        // if Rec.GETFILTER("Budget Filter") <> '' then
        //  DataCostByPiecework.SETFILTER("Cod. Budget",GETFILTER("Budget Filter"))
        // ELSE begin
        //  Job.GET(rec."Job No.");
        //  DataCostByPiecework.SETFILTER("Cod. Budget", Job."Current Piecework Budget");
        // end;
        // DataCostByPiecework.FILTERGROUP(0);

        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Piecework Code", rec."Piecework Code");
        if Rec.GETFILTER("Budget Filter") <> '' then
            DataPieceworkForProduction.SETFILTER("Budget Filter", rec.GETFILTER("Budget Filter"))
        ELSE begin
            Job.GET(rec."Job No.");
            DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");
        end;
        //MESSAGE(FORMAT(DataPieceworkForProduction.COUNT));
        DataPieceworkForProduction.FILTERGROUP(0);

        CLEAR(BillofItemsPiecbyJobCard);
        BillofItemsPiecbyJobCard.SETTABLEVIEW(DataPieceworkForProduction);
        BillofItemsPiecbyJobCard.SETRECORD(Rec);
        BillofItemsPiecbyJobCard.RUNMODAL;
    end;

    procedure ShowMeasureLinePiecework();
    var
        Job: Record 167;
        ManagementLineofMeasure: Codeunit 7207292;
        JobPieceworkCardforSales: Page 7207652;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text002);

        if Sale then   //Q9291
            ManagementLineofMeasure.editMeasureLinePieceworkCertif(rec."Piecework Code", rec."Job No.")
        ELSE begin
            if Rec.GETFILTER("Budget Filter") <> '' then
                ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", Rec.GETFILTER("Budget Filter"), rec."Piecework Code")
            ELSE begin
                Job.GET(rec."Job No.");
                ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", Job."Current Piecework Budget", rec."Piecework Code");
            end;
        end;
    end;

    procedure SetSale(IsSale: Boolean);
    begin
        //Q9291
        Sale := IsSale;
    end;

    LOCAL procedure SetEditable();
    begin
        seeDirect := (rec.Type = rec.Type::Piecework);               //JAV 25/05/22: - QB 1.10.43 Solo ser� editable los datos de directos si la unidad lo es
        seeIndirect := (rec.Type = rec.Type::"Cost Unit");            //JAV 25/05/22: - QB 1.10.43 Solo ser� editable los datos de indirectos si la unidad lo es
    end;

    // begin
    /*{
      PGM 14/05/20: - Q9291 Modificada la funci�n "ShowMeasureLinePiecework"
      JAV 25/06/22: - QB 1.10.44 Mejora en la pantalla, no ver datos que no son necesarios
    }*///end
}







