report 7207372 "Needs by level"
{


    CaptionML = ENU = 'Needs by level', ESP = 'Necesidades por nivel';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.";
            Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
                //SourceExpr=FORMAT(TODAY,0,4);
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(JobNo____JobDescription; Job."No." + '-' + Job.Description + Job."Description 2")
            {
                //SourceExpr=Job."No." + '-' + Job.Description + Job."Description 2";
            }
            Column(Job_ReestimationLastDate; Job."Reestimation Last Date")
            {
                //SourceExpr=Job."Reestimation Last Date";
            }
            Column(Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(ConsuByPuchLevel_Lbl; ConsuByPuchLevel_Lbl)
            {
                //SourceExpr=ConsuByPuchLevel_Lbl;
            }
            Column(Page_Lbl; Page_Lbl)
            {
                //SourceExpr=Page_Lbl;
            }
            Column(Code_Lbl; Code_Lbl)
            {
                //SourceExpr=Code_Lbl;
            }
            Column(Job_Lbl; Job_Lbl)
            {
                //SourceExpr=Job_Lbl;
            }
            Column(EstimatedPrice_Lbl; EstimatedPrice_Lbl)
            {
                //SourceExpr=EstimatedPrice_Lbl;
            }
            Column(EstimatedPendingAmount_Lbl; EstimatedPendingAmount_Lbl)
            {
                //SourceExpr=EstimatedPendingAmount_Lbl;
            }
            Column(PendingQty_Lbl; PendingQty_Lbl)
            {
                //SourceExpr=PendingQty_Lbl;
            }
            Column(Description_Lbl; Description_Lbl)
            {
                //SourceExpr=Description_Lbl;
            }
            Column(UpdateDate_Lbl; UpdateDate_Lbl)
            {
                //SourceExpr=UpdateDate_Lbl;
            }
            Column(UnitMeasure_Lbl; UnitMeasure_Lbl)
            {
                //SourceExpr=UnitMeasure_Lbl;
            }
            Column(PurchaseJournalLine_TargetAmount_CAPTION; PurchaseJournalLine.FIELDCAPTION("Target Amount"))
            {
                //SourceExpr=PurchaseJournalLine.FIELDCAPTION("Target Amount");
            }
            Column(ContractedAmount_Lbl; ContractedAmount_Lbl)
            {
                //SourceExpr=ContractedAmount_Lbl;
            }
            Column(Accum_Perc_Lbl; Accum_Perc_Lbl)
            {
                //SourceExpr=Accum_Perc_Lbl;
            }
            Column(No_Job; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            Column(ReestimationFilter_Job; Job."Reestimation Filter")
            {
                //SourceExpr=Job."Reestimation Filter";
            }
            Column(Limit_Perc; Limit_Perc)
            {
                //SourceExpr=Limit_Perc;
            }
            Column(Limit_Perc_Lbl; Limit_Perc_Lbl)
            {
                //SourceExpr=Limit_Perc_Lbl;
            }
            DataItem("Purchase Journal Line"; "Purchase Journal Line")
            {

                DataItemTableView = SORTING("Job No.", "Target Amount")
                                 ORDER(Descending);


                RequestFilterFields = "Activity Code", "Date Update";
                DataItemLink = "Job No." = FIELD("No.");
                Column(Amount; Amount)
                {
                    //SourceExpr=Amount;
                }
                Column(TargetAmount_PurchaseJournalLine; "Purchase Journal Line"."Target Amount")
                {
                    //SourceExpr="Purchase Journal Line"."Target Amount";
                }
                Column(EstimatedAmount; EstimatedAmount)
                {
                    //SourceExpr=EstimatedAmount;
                }
                Column(EstimatedPrice; EstimatedPrice)
                {
                    //SourceExpr=EstimatedPrice;
                }
                Column(UnitMeasure; UnitMeasure)
                {
                    //SourceExpr=UnitMeasure;
                }
                Column(Qty; Qty)
                {
                    //SourceExpr=Qty;
                }
                Column(Decription_PurchaseJournalLine; "Purchase Journal Line".Decription)
                {
                    //SourceExpr="Purchase Journal Line".Decription;
                }
                Column(No_PurchaseJournalLine; "Purchase Journal Line"."No.")
                {
                    //SourceExpr="Purchase Journal Line"."No.";
                }
                Column(Accumulated; Accumulated)
                {
                    //SourceExpr=Accumulated;
                }
                Column(ObjetiveAmount; ObjetiveAmount)
                {
                    //SourceExpr=ObjetiveAmount;
                }
                Column(Total_Lbl; Total_Lbl)
                {
                    //SourceExpr=Total_Lbl;
                }
                Column(LineNo_PurchaseJournalLine; "Purchase Journal Line"."Line No.")
                {
                    //SourceExpr="Purchase Journal Line"."Line No.";
                }
                Column(JobNo_PurchaseJournalLine; "Purchase Journal Line"."Job No.")
                {
                    //SourceExpr="Purchase Journal Line"."Job No." ;
                }
                trigger OnPreDataItem();
                BEGIN
                    CurrReport.CREATETOTALS("Estimated Amount");
                    CurrReport.CREATETOTALS(Amount, BaseAmount, EstimatedAmount, ObjetiveAmount);
                    PurchaseJournalLine.SETCURRENTKEY("Target Amount");
                    PurchaseJournalLine.COPYFILTERS("Purchase Journal Line");
                    PurchaseJournalLine.CALCSUMS("Target Amount");
                    TotalNeeds := PurchaseJournalLine."Target Amount";
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF Accumulated > Limit_Perc THEN
                        CurrReport.SKIP;
                    IF "Purchase Journal Line".Type = "Purchase Journal Line".Type::Resource THEN BEGIN
                        Resource.GET("No.");
                        Cod := Resource."No.";
                        UnitMeasure := Resource."Base Unit of Measure";
                    END ELSE BEGIN
                        Item2.GET("No.");
                        Cod := Item2."No.";
                        UnitMeasure := Item2."Base Unit of Measure";
                    END;

                    //Se calcula el importe contratado
                    Amount := 0;
                    ObjetiveAmount := "Purchase Journal Line"."Target Amount";
                    EstimatedAmount := "Purchase Journal Line"."Estimated Amount";
                    EstimatedPrice := "Purchase Journal Line"."Estimated Price";
                    Amount := ContractedAmount("Purchase Journal Line");
                    BaseAmount := "Purchase Journal Line".Quantity * "Purchase Journal Line"."Qty. Unit Measure base";
                    EstimatedAmount := "Purchase Journal Line".Quantity * "Purchase Journal Line"."Estimated Price";
                    PartialNeeds := PartialNeeds + "Purchase Journal Line"."Target Amount";
                    Accumulated := ROUND((PartialNeeds * 100) / TotalNeeds, 0.01);
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation2.GET;
                CompanyInformation2.CALCFIELDS(CompanyInformation2.Picture);
                CLEAR(Currency);
                Currency.InitRoundingPrecision;

                CurrReport.CREATETOTALS(Amount);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                TotalEstimatedAmount := 0;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                field("Limit_Perc"; "Limit_Perc")
                {

                    CaptionML = ESP = 'Lista hasta %';
                }

            }
        }
    }
    labels
    {
    }

    var
        //       LastFieldNo@7001127 :
        LastFieldNo: Integer;
        //       FooterPrinted@7001126 :
        FooterPrinted: Boolean;
        //       Header@7001125 :
        Header: ARRAY[4] OF Date;
        //       Account@7001124 :
        Account: Integer;
        //       ActivityQB@7001123 :
        ActivityQB: Record 7207280;
        //       Item@7001122 :
        Item: Record 27;
        //       Resource@7001121 :
        Resource: Record 156;
        //       CompanyInformation@7001119 :
        CompanyInformation: Record 79;
        //       Resource2@7001118 :
        Resource2: Record 156;
        //       Item2@7001117 :
        Item2: Record 27;
        //       Cod@7001116 :
        Cod: Code[20];
        //       UnitMeasure@7001115 :
        UnitMeasure: Code[10];
        //       CompanyInformation2@7001114 :
        CompanyInformation2: Record 79;
        //       Qty@7001113 :
        Qty: Decimal;
        //       EstimatedAmount@7001112 :
        EstimatedAmount: Decimal;
        //       TotalEstimatedAmount@7001111 :
        TotalEstimatedAmount: Decimal;
        //       Qty2@7001110 :
        Qty2: Decimal;
        //       Amount@7001109 :
        Amount: Decimal;
        //       BaseAmount@7001108 :
        BaseAmount: Decimal;
        //       EstimatedPrice@7001107 :
        EstimatedPrice: Decimal;
        //       Currency@7001106 :
        Currency: Record 4;
        //       Accumulated@7001105 :
        Accumulated: Decimal;
        //       TotalNeeds@7001104 :
        TotalNeeds: Decimal;
        //       PartialNeeds@7001103 :
        PartialNeeds: Decimal;
        //       PurchaseJournalLine@7001102 :
        PurchaseJournalLine: Record 7207281;
        //       ObjetiveAmount@7001101 :
        ObjetiveAmount: Decimal;
        //       Limit_Perc@7001100 :
        Limit_Perc: Decimal;
        //       Text0001@7001141 :
        Text0001: TextConst ENU = 'You must specify a date range in the Date Filter field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       ConsuByPuchLevel_Lbl@7001140 :
        ConsuByPuchLevel_Lbl: TextConst ENU = 'Consumption by Purchase levels', ESP = 'Consumos por niveles de Compra';
        //       Page_Lbl@7001139 :
        Page_Lbl: TextConst ENU = 'Page', ESP = 'P gina';
        //       Code_Lbl@7001138 :
        Code_Lbl: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       Job_Lbl@7001137 :
        Job_Lbl: TextConst ENU = 'Job:', ESP = 'Obra:';
        //       EstimatedPrice_Lbl@7001136 :
        EstimatedPrice_Lbl: TextConst ENU = 'Estimated price', ESP = '"Precio previsto "';
        //       EstimatedPendingAmount_Lbl@7001135 :
        EstimatedPendingAmount_Lbl: TextConst ENU = 'Estimated pending amount', ESP = 'Importe previsto pdte.';
        //       PendingQty_Lbl@7001134 :
        PendingQty_Lbl: TextConst ENU = 'Pending quantity.', ESP = 'Cantidad pdte.';
        //       Description_Lbl@7001133 :
        Description_Lbl: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       UpdateDate_Lbl@7001132 :
        UpdateDate_Lbl: TextConst ENU = 'Update date:', ESP = 'Fecha de actualizaci¢n:';
        //       UnitMeasure_Lbl@7001131 :
        UnitMeasure_Lbl: TextConst ENU = 'Unit of Measure', ESP = 'Unidad medida';
        //       ContractedAmount_Lbl@7001130 :
        ContractedAmount_Lbl: TextConst ENU = 'Contracted amount', ESP = 'Importe Contratado';
        //       Accum_Perc_Lbl@7001129 :
        Accum_Perc_Lbl: TextConst ENU = 'Accumulated %', ESP = '% Acumulado';
        //       Total_Lbl@7001128 :
        Total_Lbl: TextConst ENU = 'Total', ESP = 'Total';
        //       Limit_Perc_Lbl@7001120 :
        Limit_Perc_Lbl: TextConst ENU = 'List until %: ', ESP = 'Lista hasta %: ';

    //     procedure ContractedAmount (PAPurchaseJournalLine@1100251000 :
    procedure ContractedAmount(PAPurchaseJournalLine: Record 7207281) PAAmount: Decimal;
    var
        //       LOPurchaseLine@1100251001 :
        LOPurchaseLine: Record 39;
        //       LOPurchaseHeader@1100251002 :
        LOPurchaseHeader: Record 38;
    begin
        //****************************************************************
        //Se leen las l¡neas de pedido de compra y pedidos de compra abierto del proyecto y el producto de la l¡nea.
        //Si el pedido est  lanzado se suma el importe
        //****************************************************************
        LOPurchaseLine.RESET;
        LOPurchaseLine.SETCURRENTKEY("Document Type", Type, "No.", "Job No.");
        LOPurchaseLine.SETFILTER(LOPurchaseLine."Document Type", '%1|%2',
                                 LOPurchaseLine."Document Type"::Order, LOPurchaseLine."Document Type"::"Blanket Order");
        LOPurchaseLine.SETRANGE(LOPurchaseLine."Job No.", PAPurchaseJournalLine."Job No.");

        if PAPurchaseJournalLine.Type = PAPurchaseJournalLine.Type::Resource then
            LOPurchaseLine.SETRANGE(LOPurchaseLine.Type, LOPurchaseLine.Type::Resource)
        else
            LOPurchaseLine.SETRANGE(LOPurchaseLine.Type, LOPurchaseLine.Type::Item);

        LOPurchaseLine.SETRANGE(LOPurchaseLine."No.", PAPurchaseJournalLine."No.");

        if LOPurchaseLine.FINDSET then
            repeat
                if LOPurchaseLine."Blanket Order No." = '' then begin
                    LOPurchaseHeader.GET(LOPurchaseLine."Document Type", LOPurchaseLine."Document No.");
                    if LOPurchaseHeader.Status = LOPurchaseHeader.Status::Released then begin
                        PAAmount := PAAmount + LOPurchaseLine.Amount;
                    end;
                end;
            until LOPurchaseLine.NEXT = 0;
        exit(PAAmount);
    end;

    /*begin
    end.
  */

}



// RequestFilterFields="Activity Code","Date Update";
