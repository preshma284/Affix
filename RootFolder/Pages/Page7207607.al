page 7207607 "Job Unit Subcont. Subform"
{
    CaptionML = ENU = 'UNITS SUBCONTRACT', ESP = 'Unidades para Subcontrataci�n';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    SourceTableView = SORTING("Job No.", "Piecework Code");
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Piecework Code"; rec."Piecework Code")
                {

                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                    CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�digo U.O. Presto';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Additional Text Code"; rec."Additional Text Code")
                {

                    Visible = seeAditionalCode;
                }
                field("Description"; rec."Description")
                {

                }
                field("Sale Quantity (base)"; rec."Sale Quantity (base)")
                {

                    CaptionML = ENU = 'Sale Quantity (base)', ESP = 'Cantidad';
                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                }
                field("Budget Measure"; rec."Budget Measure")
                {

                }
                field("Price Subcontracting Cost"; rec."Price Subcontracting Cost")
                {

                }
                field("Initial Sale Measurement"; rec."Initial Sale Measurement")
                {

                }
                field("Outsourcing Name"; rec."Outsourcing Name")
                {

                    Editable = FALSE

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
                CaptionML = ENU = 'Subcontract Full budget line', ESP = 'Subcontratar partida completa';
                Promoted = true;
                Visible = verNo;
                PromotedIsBig = true;
                Image = CreateWhseLoc;
                PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    SubcontractAll;
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Subcontract Resource', ESP = 'Subcontratar recurso';
                Promoted = true;
                Visible = verNo;
                PromotedIsBig = true;
                Image = CreateSKU;
                PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    SubcontractResources;
                END;


            }
            action("action3")
            {
                CaptionML = ENU = 'Cancel Subcontracting', ESP = 'Anular subcontrataci�n';
                Promoted = true;
                Visible = verSi;
                PromotedIsBig = true;
                Image = CreateWhseLoc;
                PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    CancelSubcontrat;
                END;


            }
            action("action4")
            {
                CaptionML = ENU = 'Extended Texts', ESP = 'Textos adicionales';
                RunObject = Page 7206929;
                RunPageView = SORTING("Table", "Key1", "Key2");
                RunPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code");
                Image = AdjustItemCost;
            }
            group("group6")
            {
                CaptionML = ESP = 'Datos';
                // ActionContainerType =NewDocumentItems ;
                action("action5")
                {
                    ShortCutKey = 'Shift+F5';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    Image = Card;

                    trigger OnAction()
                    BEGIN
                        ShowCard;
                    END;


                }
                action("action6")
                {
                    CaptionML = ENU = 'Bill of Item D&ata', ESP = 'Descompuestos';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = BinContent;
                    PromotedCategory = Process;

                    trigger OnAction()
                    BEGIN
                        ShowPiecework;
                    END;


                }
                action("action7")
                {
                    CaptionML = ENU = '&L�neas de medici�n', ESP = 'L�neas de medici�n';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = ItemTrackingLines;
                    PromotedCategory = Process;


                    trigger OnAction()
                    BEGIN
                        ShowMeasureLinePiecework;
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        QuoBuildingSetup.GET();
        seeAditionalCode := (QuoBuildingSetup."Use Aditional Code");
    END;



    var
        QuoBuildingSetup: Record 7207278;
        ActivityCode: Code[20];
        ResourceCode: Code[20];
        CurrentBudgetCode: Code[20];
        verNo: Boolean;
        verSi: Boolean;
        seeAditionalCode: Boolean;

    procedure PassData(ActivityCodePass: Code[20]; ResourceCodePass: Code[20]; CurrentBudgetCodePass: Code[20]);
    begin
        ActivityCode := ActivityCodePass;
        ResourceCode := ResourceCodePass;
        CurrentBudgetCode := CurrentBudgetCodePass;
    end;

    procedure ShowCard();
    var
        LDataPieceworkForProduction: Record 7207386;
        PageJobPieceworkCard: Page 7207508;
    begin
        CLEAR(PageJobPieceworkCard);
        LDataPieceworkForProduction.GET(rec."Job No.", rec."Piecework Code");
        LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        LDataPieceworkForProduction.SETRANGE("Piecework Code", rec."Piecework Code");
        Rec.FILTERGROUP(4);
        Rec.COPYFILTER("Budget Filter", LDataPieceworkForProduction."Budget Filter");
        Rec.FILTERGROUP(0);
        if LDataPieceworkForProduction.FINDFIRST then;

        PageJobPieceworkCard.SETTABLEVIEW(LDataPieceworkForProduction);
        PageJobPieceworkCard.RUN;
    end;

    procedure ShowPiecework();
    var
        DataCostByPiecework: Record 7207387;
        BillofItemsPiecbyJobCard: Page 7207513;
    begin
        // DataCostByPiecework.RESET;
        // DataCostByPiecework.FILTERGROUP(2);
        // DataCostByPiecework.SETRANGE(DataCostByPiecework."Job No.","Job No.");
        // DataCostByPiecework.SETRANGE(DataCostByPiecework."Piecework Code","Piecework Code");
        // if CurrentBudgetCode <> '' then
        //  DataCostByPiecework.SETFILTER("Cod. Budget",CurrentBudgetCode);
        // DataCostByPiecework.FILTERGROUP(0);
        // PAGE.RUNMODAL(PAGE::"Bill of Items Piec by Job List",DataCostByPiecework);

        CLEAR(BillofItemsPiecbyJobCard);
        BillofItemsPiecbyJobCard.SETRECORD(Rec);
        BillofItemsPiecbyJobCard.RUNMODAL;
    end;

    procedure ShowMeasureLinePiecework();
    var
        Job: Record 167;
        ManagementLineofMeasure: Codeunit 7207292;
    begin
        Job.GET(rec."Job No.");
        if CurrentBudgetCode <> '' then
            ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", CurrentBudgetCode, rec."Piecework Code")
        ELSE
            ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", Job."Current Piecework Budget", rec."Piecework Code");
    end;

    procedure SetVer(pTipo: Boolean);
    begin
        verSi := pTipo;
        verNo := not pTipo;
    end;

    procedure SubcontractAll();
    var
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
        ActivityQB: Record 7207280;
        NewPriceSubcontract: Decimal;
    begin
        ActivityQB.GET(ActivityCode);
        ActivityQB.TESTFIELD("Cod. Resource Subcontracting");
        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
        if DataPieceworkForProduction.FINDSET then begin
            Job.GET(DataPieceworkForProduction."Job No.");
            repeat
                NewPriceSubcontract := DataPieceworkForProduction."Price Subcontracting Cost";

                DataPieceworkForProduction.SETRANGE("Budget Filter", CurrentBudgetCode);
                DataPieceworkForProduction.VALIDATE("No. Subcontracting Resource", ResourceCode);
                DataPieceworkForProduction.VALIDATE("Activity Code", ActivityCode);
                DataPieceworkForProduction."Price Subcontracting Cost" := NewPriceSubcontract;
                DataPieceworkForProduction.MODIFY;
                //-QB_2297
                CreateResourceUnitOfMeasure(ResourceCode, DataPieceworkForProduction."Unit Of Measure");
                //+QB_2297
                DataPieceworkForProduction.AssigBillOfItemUnitSubcontracting(0);
            until DataPieceworkForProduction.NEXT = 0;
        end;
        CurrPage.UPDATE;
    end;

    procedure SubcontractResources();
    var
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
        ActivityQB: Record 7207280;
        NewPriceSubcontract: Decimal;
    begin
        ActivityQB.GET(ActivityCode);
        ActivityQB.TESTFIELD("Cod. Resource Subcontracting");
        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
        if DataPieceworkForProduction.FINDSET then begin
            Job.GET(DataPieceworkForProduction."Job No.");
            repeat
                NewPriceSubcontract := DataPieceworkForProduction."Price Subcontracting Cost";

                DataPieceworkForProduction.SETRANGE("Budget Filter", CurrentBudgetCode);
                DataPieceworkForProduction.VALIDATE("No. Subcontracting Resource", ResourceCode);
                DataPieceworkForProduction.VALIDATE("Activity Code", ActivityCode);
                DataPieceworkForProduction."Price Subcontracting Cost" := NewPriceSubcontract;
                DataPieceworkForProduction.MODIFY;
                //-QB_2297
                CreateResourceUnitOfMeasure(ResourceCode, DataPieceworkForProduction."Unit Of Measure");
                //+QB_2297
                DataPieceworkForProduction.AssigBillOfItemUnitSubcontracting(1);
            until DataPieceworkForProduction.NEXT = 0;
        end;
        CurrPage.UPDATE;
    end;

    procedure CancelSubcontrat();
    var
        DataPieceworkForProduction: Record 7207386;
        DataCostByPieceworkSaved: Record 7207273;
        DataCostByPiecework: Record 7207387;
        QBTextSaved: Record 7207274;
        QBText: Record 7206918;
    begin
        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
        if DataPieceworkForProduction.FINDSET then
            repeat
                DataPieceworkForProduction.VALIDATE("No. Subcontracting Resource", '');
                DataPieceworkForProduction."Activity Code" := '';
                DataPieceworkForProduction."Price Subcontracting Cost" := 0;
                DataPieceworkForProduction."Analytical Concept Subcon Code" := '';
                DataPieceworkForProduction.MODIFY;

                //Elimino los Descompuestos modificados por la subcontrataci�n
                DataCostByPiecework.RESET;
                DataCostByPiecework.SETRANGE("Job No.", rec."Job No.");
                DataCostByPiecework.SETRANGE("Piecework Code", rec."Piecework Code");
                DataCostByPiecework.SETRANGE("Cod. Budget", CurrentBudgetCode);
                DataCostByPiecework.SETRANGE(Subcontrating, TRUE);
                if (DataCostByPiecework.FINDSET) then
                    repeat
                        DataCostByPiecework.DELETE;
                        if QBText.GET(QBText.Table::Job, DataCostByPiecework."Job No.", DataCostByPiecework."Piecework Code", DataCostByPiecework."No.") then
                            QBText.DELETE;
                    until DataCostByPiecework.NEXT = 0;

                //Recuperar los Descompuestos y textos originales
                DataCostByPieceworkSaved.RESET;
                DataCostByPieceworkSaved.SETRANGE("Job No.", rec."Job No.");
                DataCostByPieceworkSaved.SETRANGE("Piecework Code", rec."Piecework Code");
                DataCostByPieceworkSaved.SETRANGE("Cod. Budget", CurrentBudgetCode);
                if DataCostByPieceworkSaved.FINDSET then
                    repeat
                        DataCostByPiecework.TRANSFERFIELDS(DataCostByPieceworkSaved);
                        DataCostByPiecework.INSERT;
                        DataCostByPieceworkSaved.DELETE;

                        if QBTextSaved.GET(QBTextSaved.Table::Job, DataCostByPieceworkSaved."Job No.", DataCostByPieceworkSaved."Piecework Code", DataCostByPieceworkSaved."No.") then begin
                            QBTextSaved.CALCFIELDS("Cost Text", "Sales Text");
                            QBText.TRANSFERFIELDS(QBTextSaved);
                            QBText.INSERT;
                            QBTextSaved.DELETE;
                        end;
                    until DataCostByPieceworkSaved.NEXT = 0;

            until DataPieceworkForProduction.NEXT = 0;
        CurrPage.UPDATE;
    end;

    LOCAL procedure CreateResourceUnitOfMeasure(ResourceCode: Code[20]; UnitOfMeasureCode: Code[20]);
    var
        ResourceUnitofMeasure: Record 205;
    begin
        //QB_2297
        if ResourceUnitofMeasure.GET(ResourceCode, UnitOfMeasureCode) then
            exit;

        ResourceUnitofMeasure.INIT;

        ResourceUnitofMeasure.VALIDATE("Resource No.", ResourceCode);
        ResourceUnitofMeasure.VALIDATE(Code, UnitOfMeasureCode);
        ResourceUnitofMeasure.VALIDATE("Qty. per Unit of Measure", 1);
        ResourceUnitofMeasure.VALIDATE("Related to Base Unit of Meas.", TRUE);

        ResourceUnitofMeasure.INSERT(TRUE);
    end;

    // begin
    /*{
      QB_2297 19/06/18 PEL: Crear unidad de medida recurso.
      JDC 23/07/19: - GAP020 Added fields 50000"Outsourcing Code" and 50001rec."Outsourcing Name"
    }*///end
}







