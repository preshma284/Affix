report 7207359 "Needs of the Job"
{


    CaptionML = ENU = 'Needs of the Job', ESP = 'Necesidades de una Obra';
    EnableHyperlinks = true;

    dataset
    {

        DataItem("proy"; "Job")
        {

            DataItemTableView = SORTING("No.")
                                 ORDER(Ascending)
                                 WHERE("Job Type" = CONST("Operative"));


            RequestFilterFields = "No.";
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(proy_No; "No.")
            {
                //SourceExpr="No.";
            }
            Column(proy_Description; proy.Description)
            {
                //SourceExpr=proy.Description;
            }
            Column(proy_Description2; proy."Description 2")
            {
                //SourceExpr=proy."Description 2";
            }
            Column(Reestimation_Last_Date; Job."Reestimation Last Date")
            {
                //SourceExpr=Job."Reestimation Last Date";
            }
            Column(Restimation_Filter; "Reestimation Filter")
            {
                //SourceExpr="Reestimation Filter";
            }
            DataItem("Purchase Journal Line"; "Purchase Journal Line")
            {

                DataItemTableView = SORTING("Job No.", "Activity Code", "Type", "No.");


                RequestFilterFields = "Date Update", "Activity Code";
                CalcFields =;
                DataItemLink = "Job No." = FIELD("No.");
                Column(PJL_ActivityCode; "Activity Code")
                {
                    //SourceExpr="Activity Code";
                }
                Column(desActivity; descActivity)
                {
                    //SourceExpr=descActivity;
                }
                Column(decBaseQuantity; decBaseQuantity)
                {
                    //SourceExpr=decBaseQuantity;
                }
                Column(PJL_Description; Decription)
                {
                    //SourceExpr=Decription;
                }
                Column(decPricePlanned; decPricePlanned)
                {
                    //SourceExpr=decPricePlanned;
                }
                Column(decAmountPlanned; decAmountPlanned)
                {
                    //SourceExpr=decAmountPlanned;
                }
                Column(VarCod; VarCod)
                {
                    //SourceExpr=VarCod;
                }
                Column(VarUnitMeasure; VarUnitMeasure)
                {
                    //SourceExpr=VarUnitMeasure;
                }
                Column(PJL_TargetAmount; "Target Amount")
                {
                    //SourceExpr="Target Amount";
                }
                Column(VarAmount; VarAmount)
                {
                    //SourceExpr=VarAmount;
                }
                Column(decAmountPlannedTotal; decAmountPlannedTotal)
                {
                    //SourceExpr=decAmountPlannedTotal;
                }
                Column(PJL_LineNo; "Line No.")
                {
                    //SourceExpr="Line No.";
                }
                Column(PJL_Type; Type)
                {
                    //SourceExpr=Type;
                }
                Column(PJL_No; "No.")
                {
                    //SourceExpr="No.";
                }
                Column(PJL_JobNo; "Job No.")
                {
                    //SourceExpr="Job No.";
                }
                Column(itemBookmark; itemBookmark)
                {
                    //SourceExpr=itemBookmark ;
                }
                trigger OnPreDataItem();
                BEGIN
                    CurrReport.CREATETOTALS("Estimated Amount", "Target Amount");
                    CurrReport.CREATETOTALS(VarAmount, decBaseQuantity, decAmountPlanned);

                    ItemRecRef.OPEN(27); //Open reference to record 27 - Item
                END;

                trigger OnAfterGetRecord();
                BEGIN

                    IF Type = Type::Resource THEN BEGIN
                        Resource2.GET("No.");
                        VarCod := Resource2."No.";
                        VarUnitMeasure := Resource2."Base Unit of Measure";
                    END ELSE BEGIN
                        Item2.GET("No.");
                        VarCod := Item2."No.";
                        VarUnitMeasure := Item2."Base Unit of Measure";
                    END;

                    //Calculo el importe contratado
                    VarAmount := 0;
                    VarAmount := ContractAmount("Purchase Journal Line");
                    decBaseQuantity := "Purchase Journal Line".Quantity * "Purchase Journal Line"."Qty. Unit Measure base";
                    decAmountPlanned := "Purchase Journal Line".Quantity * "Purchase Journal Line"."Estimated Price";
                    decAmountPlannedTotal := decAmountPlannedTotal + decAmountPlanned;
                    //verify 2 lines
                    //CurrReport.SHOWOUTPUT :=

                    IF  CurrReport.TOTALSCAUSEDBY = "Purchase Journal Line".FIELDNO("No.") THEN 
                    CurrReport.ShowOutput(TRUE)
                    ELSE
                    CurrReport.ShowOutput(FALSE);
                  

                    IF CurrReport.TOTALSCAUSEDBY = "Purchase Journal Line".FIELDNO("No.") THEN BEGIN
                        "Purchase Journal Line".CALCFIELDS("Stock Contracts Items (Base)", "Stock Contracts Resource (B)");
                        IF "Purchase Journal Line".Type = "Purchase Journal Line".Type::Item THEN
                            //++PV0608
                            decQuantity := decBaseQuantity - "Purchase Journal Line"."Stock Contracts Items (Base)"
                        ELSE
                            decQuantity := decBaseQuantity - "Purchase Journal Line"."Stock Contracts Resource (B)";


                        decPricePlanned := 0;
                        IF decQuantity <> 0 THEN
                            decPricePlanned := decAmountPlanned / decQuantity;
                        //--PV0608

                        //CVP
                        //decAmountPlannedTotal := decAmountPlannedTotal + decAmountPlanned;
                    END;

                    IF NOT ActivityQB.GET("Activity Code") THEN
                        descActivity := Text0002
                    ELSE
                        descActivity := ActivityQB.Description;

                    IF ("Purchase Journal Line".Type = "Purchase Journal Line".Type::Item) THEN BEGIN
                        Item3.GET("Purchase Journal Line"."No."); //Get Item record
                        ItemRecRef.SETPOSITION(Item3.GETPOSITION); //Set position in item reference
                        itemBookmark := FORMAT(ItemRecRef.RECORDID, 0, 10); //Create NAV Bookmark
                    END;
                END;

                trigger OnPostDataItem();
                BEGIN
                    ItemRecRef.CLOSE;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation2.GET;
                CompanyInformation2.CALCFIELDS(CompanyInformation2.Picture);
                CLEAR(Currency);
                Currency.InitRoundingPrecision;

                CurrReport.CREATETOTALS(VarAmount);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                decAmountPlannedTotal := 0;
            END;


        }
    }
    requestpage
    {

        layout
        {
        }
    }
    labels
    {
        Page = 'Page/ P g./';
        Job = 'Job/ Obra/';
        Date = 'Date/ Fecha de actualizaci¢n/';
        RemainingQuantity = 'Remaining Quantity/ Cantidad Pendiente/';
        UnitMeasure = 'Unit of Measure/ Unidad medida/';
        EstimatedPrice = 'Estimated Price/ Precio previsto/';
        EstimatedAmount = 'Estimated Amount/ Importe previsto/';
        TargetAmount = 'Target Amount/ Importe objetivo/';
        ContractAmount = 'Contract Amount/ Importe contratado/';
        TotalActivity = 'Total Activity/ Total actividad/';
        Code = 'Code/ C¢digo/';
        Description = 'Description/ Descripci¢n/';
        DynamicsNAVURL = 'DynamicsNAV:///// DynamicsNAV://///';
        Total = 'TOTAL/ TOTAL/';
        EstimatedAmountItem = 'Estimated Amount for Item/ Importe previsto por Producto/';
        Item = 'Item/ Producto/';
        accumulated = '% Accumulated/ % Acumulado/';
    }

    var
        //       LastFieldNo@1100231000 :
        LastFieldNo: Integer;
        //       FooterPrinted@1100231001 :
        FooterPrinted: Boolean;
        //       VarHeader@1100231002 :
        VarHeader: ARRAY[4] OF Date;
        //       VarAccount@1100231003 :
        VarAccount: Integer;
        //       ActivityQB@1100231004 :
        ActivityQB: Record 7207280;
        //       Item@1100231005 :
        Item: Record 27;
        //       Resource@1100231006 :
        Resource: Record 156;
        //       Job@1100231007 :
        Job: Record 167;
        //       CompanyInformation@1100231008 :
        CompanyInformation: Record 79;
        //       Resource2@1100231009 :
        Resource2: Record 156;
        //       Item2@1100231010 :
        Item2: Record 27;
        //       VarCod@1100231011 :
        VarCod: Code[20];
        //       VarUnitMeasure@1100231012 :
        VarUnitMeasure: Code[10];
        //       CompanyInformation2@1100231013 :
        CompanyInformation2: Record 79;
        //       decQuantity@1100231014 :
        decQuantity: Decimal;
        //       decAmountPlanned@1100231015 :
        decAmountPlanned: Decimal;
        //       decAmountPlannedTotal@1100231016 :
        decAmountPlannedTotal: Decimal;
        //       decAmount2@1100231017 :
        decAmount2: Decimal;
        //       Text0001@1100251000 :
        Text0001: TextConst ENU = 'You must specify a date range in the Date Filter field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       VarAmount@1100251001 :
        VarAmount: Decimal;
        //       decBaseQuantity@1100251002 :
        decBaseQuantity: Decimal;
        //       decPricePlanned@1100251003 :
        decPricePlanned: Decimal;
        //       Currency@1100251004 :
        Currency: Record 4;
        //       Text0002@1100227005 :
        Text0002: TextConst ENU = 'NO ACTIVITY', ESP = 'SIN ACTIVIDAD';
        //       PendingConsumptionCaptionLbl@6420 :
        PendingConsumptionCaptionLbl: TextConst ENU = 'Pending Consumption', ESP = 'Consumos pendientes';
        //       CurrReport_PAGENOCaptionLbl@8565 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'page', ESP = 'p gina';
        //       CodeCaptionLbl@6538 :
        CodeCaptionLbl: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       Job_CaptionLbl@8440 :
        Job_CaptionLbl: TextConst ENU = 'Job:', ESP = 'Obra:';
        //       Estimated_Price_CaptionLbl@6074 :
        Estimated_Price_CaptionLbl: TextConst ENU = 'Estimated Price ', ESP = 'Precio previsto ';
        //       Estimated_Amount_pending_CaptionLbl@6890 :
        Estimated_Amount_pending_CaptionLbl: TextConst ENU = 'Estimated Amount Pending', ESP = 'Importe previsto pdte.';
        //       Quantity_Pending_CaptionLbl@3338 :
        Quantity_Pending_CaptionLbl: TextConst ENU = 'Quantity Pending', ESP = 'Cantidad pdte.';
        //       DescriptionCaptionLbl@2524 :
        DescriptionCaptionLbl: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       DAte_Update_CaptionLbl@6774 :
        DAte_Update_CaptionLbl: TextConst ENU = 'Date Update', ESP = 'Fecha de actualizaci¢n:';
        //       Unit_MeasureCaptionLbl@2696 :
        Unit_MeasureCaptionLbl: TextConst ENU = 'Unit of Measure', ESP = 'Unidad medida';
        //       Contract_AmountCaptionLbl@1174678268 :
        Contract_AmountCaptionLbl: TextConst ENU = 'Contract Amount', ESP = 'Importe Contratado';
        //       Total_ActivityCaptionLbl@8484 :
        Total_ActivityCaptionLbl: TextConst ENU = 'Total Activity', ESP = 'Total actividad';
        //       "--- Conect with page product"@1100227000 :
        "--- Conect with page product": Boolean;
        //       ItemRecRef@1100227001 :
        ItemRecRef: RecordRef;
        //       Item3@1100227002 :
        Item3: Record 27;
        //       itemBookmark@1100227003 :
        itemBookmark: Text[250];
        //       descActivity@1100227004 :
        descActivity: Text[100];

    //     procedure ContractAmount (PurchaseJournalLine@1100251000 :
    procedure ContractAmount(PurchaseJournalLine: Record 7207281) pardecAmount: Decimal;
    var
        //       PurchaseLine@1100251001 :
        PurchaseLine: Record 39;
        //       PurchaseHeader@1100251002 :
        PurchaseHeader: Record 38;
    begin
        //****************************************************************
        //leo las l¡neas de pedido de compra y pedidos de compra abierto del proyecto y el producto de la l¡nea.
        //y si el pedido est  lanzado sumo el importe
        //****************************************************************

        pardecAmount := 0;
        PurchaseLine.RESET;
        PurchaseLine.SETCURRENTKEY("Document Type", Type, "No.", "Job No.");
        PurchaseLine.SETFILTER(PurchaseLine."Document Type", '%1|%2',
        PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::"Blanket Order");
        PurchaseLine.SETRANGE(PurchaseLine."Job No.", PurchaseJournalLine."Job No.");
        //jmma corregido subcontrataci¢n
        if PurchaseJournalLine.Type = PurchaseJournalLine.Type::Resource then begin
            PurchaseLine.SETRANGE(PurchaseLine.Type, PurchaseLine.Type::Resource);
            PurchaseLine.SETRANGE("Piecework No.", PurchaseJournalLine."Job Unit");
        end else
            PurchaseLine.SETRANGE(PurchaseLine.Type, PurchaseLine.Type::Item);

        PurchaseLine.SETRANGE(PurchaseLine."No.", PurchaseJournalLine."No.");

        if PurchaseLine.FINDFIRST then
            repeat
                if PurchaseLine."Blanket Order No." = '' then begin
                    PurchaseHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
                    if PurchaseHeader.Status = PurchaseHeader.Status::Released then begin
                        pardecAmount := pardecAmount + PurchaseLine.Amount;
                    end;
                end;

            until PurchaseLine.NEXT = 0;
        exit(pardecAmount);
    end;

    /*begin
    end.
  */

}



// RequestFilterFields="Date Update","Activity Code";
