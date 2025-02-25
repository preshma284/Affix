report 7207360 "Purchase plan of the Job"
{


    CaptionML = ENU = 'Purchase plan of the Job', ESP = 'Plan de compras de una obra';

    dataset
    {

        DataItem("proy"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.";
            Column(proy_No_; "No.")
            {
                //SourceExpr="No.";
            }
            Column(proy_Reestimation_Filter; "Reestimation Filter")
            {
                //SourceExpr="Reestimation Filter";
            }
            DataItem("SearchDate"; "Purchase Journal Line")
            {

                DataItemTableView = SORTING("Job No.", "Type", "No.", "Date Needed")
                                 ORDER(Ascending);


                RequestFilterFields = "Activity Code", "Date Update";
                CalcFields = "Stock Contracts Items (Base)", "Stock Contracts Resource (B)";
                DataItemLink = "Job No." = FIELD("No.");
                trigger OnPreDataItem();
                BEGIN
                    LastFieldNo := FIELDNO("Job No.");
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Date.RESET;
                    Date.SETRANGE(Date."Period Type", Date."Period Type"::Date);
                    Date.SETRANGE(Date."Period Start", SearchDate."Date Needed");
                    IF NOT Date.FINDFIRST THEN BEGIN
                        Date."Period Type" := Date."Period Type"::Date;
                        Date."Period Start" := SearchDate."Date Needed";
                        Date."Period End" := SearchDate."Date Needed";
                        Date.INSERT;
                    END;
                END;

                trigger OnPostDataItem();
                BEGIN
                    Date.RESET;
                END;



            }
            DataItem("<Integer>"; "2000000026")
            {

                DataItemTableView = SORTING("Number");
                PrintOnlyIfDetail = true;
                ;
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
                Column(proy__No________proy_Description; proy."No." + '- ' + proy.Description + proy."Description 2")
                {
                    //SourceExpr=proy."No."+'- '+proy.Description+proy."Description 2";
                }
                Column(Header_1_; Header[1])
                {
                    //SourceExpr=Header[1];
                }
                Column(Header_2_; Header[2])
                {
                    //SourceExpr=Header[2];
                }
                Column(Header_3_; Header[3])
                {
                    //SourceExpr=Header[3];
                }
                Column(Planned_1_; Planned[1])
                {
                    //SourceExpr=Planned[1];
                }
                Column(Objetive_1_; Objetive[1])
                {
                    //SourceExpr=Objetive[1];
                }
                Column(Objetive_2_; Objetive[2])
                {
                    //SourceExpr=Objetive[2];
                }
                Column(Planned_2_; Planned[2])
                {
                    //SourceExpr=Planned[2];
                }
                Column(Objetive_3_; Objetive[3])
                {
                    //SourceExpr=Objetive[3];
                }
                Column(Planned_3_; Planned[3])
                {
                    //SourceExpr=Planned[3];
                }
                Column(Actual_1_; Actual[1])
                {
                    //SourceExpr=Actual[1];
                }
                Column(Actual_2_; Actual[2])
                {
                    //SourceExpr=Actual[2];
                }
                Column(Actual_3_; Actual[3])
                {
                    //SourceExpr=Actual[3];
                }
                Column(Purchase_plan_of_the_JobCaption; Purchase_plan_of_the_jobCaptionLbl)
                {
                    //SourceExpr=Purchase_plan_of_the_jobCaptionLbl;
                }
                Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                    //SourceExpr=CurrReport_PAGENOCaptionLbl;
                }
                Column(CodeCaption; CodeCaptionLbl)
                {
                    //SourceExpr=CodeCaptionLbl;
                }
                Column(Job_Caption; Job_CaptionLbl)
                {
                    //SourceExpr=Job_CaptionLbl;
                }
                Column(Description_Caption; Description_Caption)
                {
                    //SourceExpr=Description_Caption;
                }
                Column(Integer_Number; Number)
                {
                    //SourceExpr=Number;
                }
                DataItem("Purchase Journal Line"; "Purchase Journal Line")
                {

                    DataItemTableView = SORTING("Job No.", "Activity Code", "Type", "No.")
                                 ORDER(Ascending);
                    ;
                    Column(Purchase_Journal_Line__Purchase_Journal_Line___N__; "No.")
                    {
                        //SourceExpr="No.";
                    }
                    Column(AmountPlanned_1_; AmountPlanned[1])
                    {
                        //SourceExpr=AmountPlanned[1];
                    }
                    Column(AmountObjetive_1_; AmountObjetive[1])
                    {
                        //SourceExpr=AmountObjetive[1];
                    }
                    Column(AmountPlanned_3_; AmountPlanned[3])
                    {
                        //SourceExpr=AmountPlanned[3];
                    }
                    Column(AmountObjetive_3_; AmountObjetive[3])
                    {
                        //SourceExpr=AmountObjetive[3];
                    }
                    Column(AmountPlanned_2_; AmountPlanned[2])
                    {
                        //SourceExpr=AmountPlanned[2];
                    }
                    Column(AmountObjetive_2_; AmountObjetive[2])
                    {
                        //SourceExpr=AmountObjetive[2];
                    }
                    Column(Purchase_Journal_Line__Purchase_Journal_Line__Description; "Purchase Journal Line".Decription)
                    {
                        //SourceExpr="Purchase Journal Line".Decription;
                    }
                    Column(AmountActual_3_; AmountActual[3])
                    {
                        //SourceExpr=AmountActual[3];
                    }
                    Column(AmountActual_2_; AmountActual[2])
                    {
                        //SourceExpr=AmountActual[2];
                    }
                    Column(AmountActual_1_; AmountActual[1])
                    {
                        //SourceExpr=AmountActual[1];
                    }
                    Column(Purchase_Journal_Line__Purchase_Journal_Line___Activity_Code_; "Purchase Journal Line"."Activity Code")
                    {
                        //SourceExpr="Purchase Journal Line"."Activity Code";
                    }
                    Column(ActivityQB_Description; ActivityQB.Description)
                    {
                        //SourceExpr=ActivityQB.Description;
                    }
                    Column(AmountPlanned_1__Control21; AmountPlanned[1])
                    {
                        //SourceExpr=AmountPlanned[1];
                    }
                    Column(AmountObjetive_1__Control23; AmountObjetive[1])
                    {
                        //SourceExpr=AmountObjetive[1];
                    }
                    Column(AmountActual_1__Control30; AmountActual[1])
                    {
                        //SourceExpr=AmountActual[1];
                    }
                    Column(AmountPlanned_2__Control40; AmountPlanned[2])
                    {
                        //SourceExpr=AmountPlanned[2];
                    }
                    Column(AmountObjetive_2__Control41; AmountObjetive[2])
                    {
                        //SourceExpr=AmountObjetive[2];
                    }
                    Column(AmountActual_2__Control46; AmountActual[2])
                    {
                        //SourceExpr=AmountActual[2];
                    }
                    Column(AmountPlanned_3__Control47; AmountPlanned[3])
                    {
                        //SourceExpr=AmountPlanned[3];
                    }
                    Column(AmountObjetive_3__Control48; AmountObjetive[3])
                    {
                        //SourceExpr=AmountObjetive[3];
                    }
                    Column(AmountActual_3__Control49; AmountActual[3])
                    {
                        //SourceExpr=AmountActual[3];
                    }
                    Column(ActivityQB_Description_Control31; ActivityQB.Description)
                    {
                        //SourceExpr=ActivityQB.Description;
                    }
                    Column(Purchase_Journal_Line__Purchase_Journal_Line___Activity_Code__Control45; "Purchase Journal Line"."Activity Code")
                    {
                        //SourceExpr="Purchase Journal Line"."Activity Code";
                    }
                    Column(AmountPlanned_1__Control50; AmountPlanned[1])
                    {
                        //SourceExpr=AmountPlanned[1];
                    }
                    Column(AmountObjetive_1__Control51; AmountObjetive[1])
                    {
                        //SourceExpr=AmountObjetive[1];
                    }
                    Column(AmountActual_1__Control52; AmountActual[1])
                    {
                        //SourceExpr=AmountActual[1];
                    }
                    Column(AmountPlanned_2__Control54; AmountPlanned[2])
                    {
                        //SourceExpr=AmountPlanned[2];
                    }
                    Column(AmountObjetive_2__Control55; AmountObjetive[2])
                    {
                        //SourceExpr=AmountObjetive[2];
                    }
                    Column(AmountActual_2__Control66; AmountActual[2])
                    {
                        //SourceExpr=AmountActual[2];
                    }
                    Column(AmountPlanned_3__Control67; AmountPlanned[3])
                    {
                        //SourceExpr=AmountPlanned[3];
                    }
                    Column(AmountObjetive_3__Control68; AmountObjetive[3])
                    {
                        //SourceExpr=AmountObjetive[3];
                    }
                    Column(AmountActual_3__Control69; AmountActual[3])
                    {
                        //SourceExpr=AmountActual[3];
                    }
                    Column(Purchase_Journal_Line_N__line; "Line No.")
                    {
                        //SourceExpr="Line No.";
                    }
                    Column(Purchase_Journal_Line_Type; Type)
                    {
                        //SourceExpr=Type ;
                    }
                    trigger OnPreDataItem();
                    BEGIN
                        //verify
                        //TO be REfactored
                        //CurrReport.CREATETOTALS(AmountPlanned, AmountObjetive, AmountActual);

                        "Purchase Journal Line".SETRANGE("Job No.", proy."No.");
                        "Purchase Journal Line".SETRANGE("Date Needed", VarHeader[1], VarHeader[VarAccount]);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        CALCFIELDS("Stock Contracts Items (Base)", "Stock Contracts Resource (B)");
                        SumQuantity;
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    Date.SETCURRENTKEY(Date."Period Type", Date."Period Start");
                    IF NOT Date.FIND('-') THEN
                        CurrReport.BREAK;
                    More := TRUE;

                    "Purchase Journal Line".COPYFILTERS(SearchDate);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF NOT More THEN
                        CurrReport.BREAK;

                    CLEAR(VarHeader);
                    CLEAR(Planned);
                    CLEAR(Objetive);
                    CLEAR(Actual);
                    VarAccount := 0;

                    REPEAT
                        VarAccount := VarAccount + 1;
                        VarHeader[VarAccount] := Date."Period Start";
                        Header[VarAccount] := DateOfNeed + ' ' + FORMAT(Date."Period Start");
                        Objetive[VarAccount] := Estimated_amount;
                        Planned[VarAccount] := Target_Amount;
                        Actual[VarAccount] := Real_Amount;

                        IF Date.NEXT = 0 THEN
                            More := FALSE;
                    UNTIL (VarAccount = 3) OR (NOT More);
                    IF VarAccount = 0 THEN
                        CurrReport.BREAK;
                END;


            }

            trigger OnPreDataItem();
            BEGIN
                Date.RESET;
                Date.DELETEALL;
                //verify
                //To be REfactored
                //CurrReport.CREATETOTALS(AmountPlanned, AmountObjetive, AmountActual);
            END;


        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
        }
    }
    labels
    {
        Total_Estimated_Amount_Caption = 'TOTAL IMPORTE PREVISTO/ TOTAL ESTIMATED AMOUNT/';
        Total_Real_Amount_Caption = 'TOTAL IMPORTE REAL/ TOTAL REAL AMOUNT/';
        Total_Target_Amount_Caption = 'TOTAL IMPORTE OBJETIVO/ TOTAL TARGET AMOUNT/';
    }

    var
        //       LastFieldNo@1100231000 :
        LastFieldNo: Integer;
        //       FooterPrinted@1100231001 :
        FooterPrinted: Boolean;
        //       Date@1100231002 :
        Date: Record 2000000007 TEMPORARY;
        //       More@1100231003 :
        More: Boolean;
        //       VarHeader@1100231004 :
        VarHeader: ARRAY[3] OF Date;
        //       Header@1100231005 :
        Header: ARRAY[3] OF Text[50];
        //       VarAccount@1100231006 :
        VarAccount: Integer;
        //       AmountPlanned@1100231007 :
        AmountPlanned: ARRAY[3] OF Decimal;
        //       AmountObjetive@1100231008 :
        AmountObjetive: ARRAY[3] OF Decimal;
        //       AmountActual@1100231009 :
        AmountActual: ARRAY[3] OF Decimal;
        //       ActivityQB@1100231010 :
        ActivityQB: Record 7207280;
        //       Item@1100231011 :
        Item: Record 27;
        //       Resource@1100231012 :
        Resource: Record 156;
        //       Planned@1100231013 :
        Planned: ARRAY[3] OF Text[20];
        //       Objetive@1100231014 :
        Objetive: ARRAY[3] OF Text[20];
        //       Actual@1100231015 :
        Actual: ARRAY[3] OF Text[20];
        //       Job@1100231016 :
        Job: Record 167;
        //       Purchase_plan_of_the_jobCaptionLbl@4702 :
        Purchase_plan_of_the_jobCaptionLbl: TextConst ENU = 'Purchase plan of the job', ESP = 'Plan de compras de una obra';
        //       CurrReport_PAGENOCaptionLbl@8565 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'page', ESP = 'p gina';
        //       CodeCaptionLbl@6538 :
        CodeCaptionLbl: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       Job_CaptionLbl@8440 :
        Job_CaptionLbl: TextConst ENU = 'Job:', ESP = 'Obra:';
        //       Target_Amount@7001100 :
        Target_Amount: TextConst ENU = 'Target Amount', ESP = 'Importe Objetivo';
        //       DateOfNeed@7001101 :
        DateOfNeed: TextConst ENU = 'Date Of Need', ESP = 'Fecha de Necesidad';
        //       Real_Amount@7001102 :
        Real_Amount: TextConst ENU = 'Real Amount', ESP = 'Importe Real';
        //       Estimated_amount@7001103 :
        Estimated_amount: TextConst ENU = 'Estimated Amount', ESP = 'Importe Previsto';
        //       Description_Caption@7001104 :
        Description_Caption: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       Total_Target_Amount_Caption@7001108 :
        Total_Target_Amount_Caption: TextConst ENU = 'Total Target Amount', ESP = 'Total Importe Objetivo';
        //       Total_Real_Amount_Caption@7001106 :
        Total_Real_Amount_Caption: TextConst ENU = 'Total Real Amount', ESP = 'Total Importe Real';
        //       Total_Estimated_Amount_Caption@7001105 :
        Total_Estimated_Amount_Caption: TextConst ENU = 'Total Estimated Amount', ESP = 'Total Importe Previsto';

    procedure SumQuantity()
    var
        //       i@1100231000 :
        i: Integer;
    begin
        FOR i := 1 TO VarAccount DO begin
            if VarHeader[i] = "Purchase Journal Line"."Date Needed" then begin
                AmountPlanned[i] := AmountPlanned[i] + ("Purchase Journal Line"."Estimated Price" *
                                         "Purchase Journal Line".Quantity);
                AmountActual[i] := AmountActual[i] +
                                     ("Purchase Journal Line"."Estimated Price" *
                                      "Purchase Journal Line"."Stock Contracts Resource (B)");
                AmountObjetive[i] := AmountObjetive[i] + "Purchase Journal Line"."Target Amount";
            end;
        end;
    end;

    //     procedure CheckYearBuy (PurchaseJournalLine@1100231000 :
    procedure CheckYearBuy(PurchaseJournalLine: Record 7207281): Boolean;
    begin
        PurchaseJournalLine.SETCURRENTKEY("Job No.", "Activity Code", Type, "No.");
        PurchaseJournalLine.SETRANGE("Job No.", PurchaseJournalLine."Job No.");
        PurchaseJournalLine.SETRANGE("Activity Code", PurchaseJournalLine."Activity Code");
        if PurchaseJournalLine.FINDFIRST then begin
            PurchaseJournalLine.SETFILTER(PurchaseJournalLine."Date Needed", '<%1&>%2',
                                        DMY2DATE(1, 1, DATE2DMY(PurchaseJournalLine."Date Needed", 3)),
                                        DMY2DATE(31, 12, DATE2DMY(PurchaseJournalLine."Date Needed", 3)));
            if PurchaseJournalLine.FINDFIRST then
                exit(FALSE)
            else
                exit(TRUE);
        end else
            exit(FALSE);
    end;

    /*begin
    end.
  */

}



// RequestFilterFields="Activity Code","Date Update";
