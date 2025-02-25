report 7207349 "Product. Measurement"
{


    CaptionML = ENU = 'Product. Measurement', ESP = 'Medici¢n producci¢n';

    dataset
    {

        DataItem("Prod. Measure Header"; "Prod. Measure Header")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterHeadingML = ENU = 'Product. Measurement', ESP = 'Medici¢n producci¢n';


            RequestFilterFields = "No.";
            Column(ProdMeasureHeader_N_; "No.")
            {
                //SourceExpr="No.";
            }
            DataItem("2000000026"; "2000000026")
            {

                DataItemTableView = SORTING("Number");
                MaxIteration = 1;
                Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                    //SourceExpr=FORMAT(TODAY,0,4);
                }
                Column(COMPANYNAME; COMPANYNAME)
                {
                    //SourceExpr=COMPANYNAME;
                }
                Column(ProdMeasureHeader___N__; "Prod. Measure Header"."No.")
                {
                    //SourceExpr="Prod. Measure Header"."No.";
                }
                Column(ProdMeasureHeader___JobN_; "Prod. Measure Header"."Job No." + ' ' + "Prod. Measure Header".Description + ' ' + "Prod. Measure Header"."Description 2" + '          ')
                {
                    //SourceExpr="Prod. Measure Header"."Job No." + ' ' + "Prod. Measure Header".Description + ' ' + "Prod. Measure Header"."Description 2" + '          ';
                }
                Column(ProdMeasureHeader___Description_; "Prod. Measure Header".Description)
                {
                    //SourceExpr="Prod. Measure Header".Description;
                }
                Column(ProdMeasureHeader___Description2_; "Prod. Measure Header"."Description 2")
                {
                    //SourceExpr="Prod. Measure Header"."Description 2";
                }
                Column(ProdMeasureHeader___MeasureDate_; "Prod. Measure Header"."Measure Date")
                {
                    //SourceExpr="Prod. Measure Header"."Measure Date";
                }
                Column(ProdMeasureHeader___MeasureReference_; "Prod. Measure Header"."Measurement No.")
                {
                    //SourceExpr="Prod. Measure Header"."Measurement No.";
                }
                Column(ProdMeasureHeader___MeasureText_; "Prod. Measure Header"."Measurement Text")
                {
                    //SourceExpr="Prod. Measure Header"."Measurement Text";
                }
                Column(ProdMeasureHeader___CustomerN_; "Prod. Measure Header"."Customer No.")
                {
                    //SourceExpr="Prod. Measure Header"."Customer No.";
                }
                Column(Customer_Name; Customer.Name)
                {
                    //SourceExpr=Customer.Name;
                }
                Column(USERID; USERID)
                {
                    //SourceExpr=USERID;
                }
                Column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                    //SourceExpr=CurrReport.PAGENO;
                }
                Column(ProdMeasureCaption; ProdMeasureCaptionLbl)
                {
                    //SourceExpr=ProdMeasureCaptionLbl;
                }
                Column(ProdMeasureHeader___N__Caption; "Prod. Measure Header".FIELDCAPTION("No."))
                {
                    //SourceExpr="Prod. Measure Header".FIELDCAPTION("No.");
                }
                Column(ProdMeasureHeader___JobN_Caption; "Prod. Measure Header".FIELDCAPTION("Job No."))
                {
                    //SourceExpr="Prod. Measure Header".FIELDCAPTION("Job No.");
                }
                Column(ProdMeasureHeader___MeasureDate_Caption; "Prod. Measure Header".FIELDCAPTION("Measure Date"))
                {
                    //SourceExpr="Prod. Measure Header".FIELDCAPTION("Measure Date");
                }
                Column(ProdMeasureHeader___MeasureReference_Caption; "Prod. Measure Header".FIELDCAPTION("Measurement No."))
                {
                    //SourceExpr="Prod. Measure Header".FIELDCAPTION("Measurement No.");
                }
                Column(ProdMeasureHeader___MeasureText_Caption; "Prod. Measure Header".FIELDCAPTION("Measurement Text"))
                {
                    //SourceExpr="Prod. Measure Header".FIELDCAPTION("Measurement Text");
                }
                Column(ProdMeasureLines___Description_Caption; "Prod. Measure Lines".FIELDCAPTION(Description))
                {
                    //SourceExpr="Prod. Measure Lines".FIELDCAPTION(Description);
                }
                Column(ProdMeasureLines___Description_2_Caption; "Prod. Measure Lines".FIELDCAPTION("Description 2"))
                {
                    //SourceExpr="Prod. Measure Lines".FIELDCAPTION("Description 2");
                }
                Column(ProdMeasureLines__Sales_Price_Caption; "Prod. Measure Lines".FIELDCAPTION("PROD Price"))
                {
                    //SourceExpr="Prod. Measure Lines".FIELDCAPTION("PROD Price");
                }
                Column(ProdMeasureLines__AmountCaption; "Prod. Measure Lines".FIELDCAPTION("PROD Amount Term"))
                {
                    //SourceExpr="Prod. Measure Lines".FIELDCAPTION("PROD Amount Term");
                }
                Column(CustomerCaption; CustomerCaptionLbl)
                {
                    //SourceExpr=CustomerCaptionLbl;
                }
                Column(ProdMeasureLines__Piecework_N_Caption; "Prod. Measure Lines".FIELDCAPTION("Piecework No."))
                {
                    //SourceExpr="Prod. Measure Lines".FIELDCAPTION("Piecework No.");
                }
                Column(ProdMeasureLines__Source_Measure_Caption; "Prod. Measure Lines".FIELDCAPTION("Measure Source"))
                {
                    //SourceExpr="Prod. Measure Lines".FIELDCAPTION("Measure Source");
                }
                Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                    //SourceExpr=CurrReport_PAGENOCaptionLbl;
                }
                Column(Integer_Number; Number)
                {
                    //SourceExpr=Number;
                }
            }
            DataItem("Prod. Measure Lines"; "Prod. Measure Lines")
            {

                DataItemTableView = SORTING("Document No.", "Line No.");
                DataItemLink = "Document No." = FIELD("No.");
                Column(ProdMeasureLines_Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(ProdMeasureLines_Description_2; "Description 2")
                {
                    //SourceExpr="Description 2";
                }
                Column(ProdMeasureLines_Sales_Price; "PROD Price")
                {
                    //SourceExpr="PROD Price";
                }
                Column(ProdMeasureLines_Amount; "PROD Amount Term")
                {
                    //SourceExpr="PROD Amount Term";
                }
                Column(ProdMeasureLines_Piecework_N; "Piecework No.")
                {
                    //SourceExpr="Piecework No.";
                }
                Column(ProdMeasureLines_Source_Measure; "Measure Source")
                {
                    //SourceExpr="Measure Source";
                }
                Column(ProdMeasureLines_Document_N; "Document No.")
                {
                    //SourceExpr="Document No.";
                }
                Column(ProdMeasureLines_Line_N; "Line No.")
                {
                    //SourceExpr="Line No.";
                }
                Column(ProdMeasureLines_Job_N; "Job No.")
                {
                    //SourceExpr="Job No.";
                }
                DataItem("Data Piecework For Production"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending);
                    DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework No.");
                    Column(DataPieceworkForProduction__Job_N_; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(DataPieceworkForProduction__Piecework_Code_; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    Column(DataPieceworkForProduction__Unique_Code_; "Unique Code")
                    {
                        //SourceExpr="Unique Code";
                    }
                    DataItem("QB Text"; "QB Text")
                    {

                        DataItemTableView = SORTING("Table", "Key1", "Key2")
                                 ORDER(Ascending)
                                 WHERE("Table" = CONST("Job"));
                        DataItemLink = "Key1" = FIELD("Job No."),
                            "Key2" = FIELD("Piecework Code");
                        Column(textLineExtended; textLineExtended)
                        {
                            //SourceExpr=textLineExtended ;
                        }
                        //D4 Triggers
                        trigger OnPreDataItem();
                        BEGIN
                            IF NOT boolTxtAdic THEN
                                CurrReport.BREAK;
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            textLineExtended := "QB Text".GetCostText;
                        END;


                    }
                    //D3 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        IF NOT boolTxtAdic THEN
                            CurrReport.BREAK;
                    END;


                }
            }
            //PMH Triggers
            trigger OnPreDataItem();
            BEGIN
                LastFieldNo := FIELDNO("No.");
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF NOT Customer.GET("Prod. Measure Header"."Customer No.") THEN
                    CLEAR(Customer);
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
        TotalMeasureL = 'Total Measure/ Total medici¢n/';
    }

    var
        //       LastFieldNo@7001105 :
        LastFieldNo: Integer;
        //       FooterPrinted@7001104 :
        FooterPrinted: Boolean;
        //       Customer@7001103 :
        Customer: Record 18;
        //       boolTxtAdic@7001102 :
        boolTxtAdic: Boolean;
        //       textLineExtended@7001100 :
        textLineExtended: Text[150];
        //       ProdMeasureCaptionLbl@7001109 :
        ProdMeasureCaptionLbl: TextConst ENU = 'Production Measurement', ESP = 'Medici¢n producci¢n';
        //       CustomerCaptionLbl@7001108 :
        CustomerCaptionLbl: TextConst ENU = 'CUSTOMER', ESP = 'CLIENTE';
        //       CurrReport_PAGENOCaptionLbl@7001107 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P g.';

    /*begin
    end.
  */

}



