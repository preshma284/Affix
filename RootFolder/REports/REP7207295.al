report 7207295 "Print Offer"
{


    ;
    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.";
            Column(Job_Description; Description)
            {
                //SourceExpr=Description;
            }
            Column(Job__No__; "No.")
            {
                //SourceExpr="No.";
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(Header; Header)
            {
                //SourceExpr=Header;
            }
            Column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(FORMAT_TODAY_0___Day__de__Month_Text__de__Year4___; FORMAT(TODAY, 0, '<Day> de <Month Text> de <Year4>'))
            {
                //SourceExpr=FORMAT(TODAY,0,'<Day> de <Month Text> de <Year4>');
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaption)
            {
                //SourceExpr=CurrReport_PAGENOCaption;
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Customer Certification Unit" = CONST(true));
                DataItemLink = "Job No." = FIELD("No.");
                Column(PADSTR____Indentation___2___Data_Piecework_For_Production_Description; PADSTR('', Indentation * 2) + "Data Piecework For Production".Description)
                {
                    //SourceExpr=PADSTR('',Indentation * 2)+"Data Piecework For Production".Description;
                }
                Column(Data_Piecework_For_Production___Piecework_Code; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(Data_Piecework_For_Production___Accumulated_Amount; "Accumulated Amount")
                {
                    //SourceExpr="Accumulated Amount";
                }
                Column(Data_Piecework_For_Production___Piecework_Code__Control1000000008; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(PADSTR____Indentation___2___Data_Piecework_For_Production_Description_Control1000000063; PADSTR('', Indentation * 2) + "Data Piecework For Production".Description)
                {
                    //SourceExpr=PADSTR('',Indentation * 2)+"Data Piecework For Production".Description;
                }
                Column(funUnitsOfMeasure; funUnitsOfMeasure)
                {
                    //SourceExpr=funUnitsOfMeasure;
                }
                Column(PADSTR____Indentation___2___Data_Piecework_For_Production_Description_Control1100229083; PADSTR('', Indentation * 2) + "Data Piecework For Production".Description)
                {
                    //SourceExpr=PADSTR('',Indentation * 2)+"Data Piecework For Production".Description;
                }
                Column(funUnitsOfMeasure_Control1100229085; funUnitsOfMeasure)
                {
                    //SourceExpr=funUnitsOfMeasure;
                }
                Column(Data_Piecework_For_Production___Piecework_Code__Control1100229087; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(AmountCaption; AmountCaption)
                {
                    //SourceExpr=AmountCaption;
                }
                Column(Unit_priceCaption; Unit_priceCaption)
                {
                    //SourceExpr=Unit_priceCaption;
                }
                Column(QuantityCaption; QuantityCaption)
                {
                    //SourceExpr=QuantityCaption;
                }
                Column(DescriptionCaption; DescriptionCaption)
                {
                    //SourceExpr=DescriptionCaption;
                }
                Column(CodeCaption; CodeCaption)
                {
                    //SourceExpr=CodeCaption;
                }
                Column(AmountCaption_Control1100229015; AmountCaption_Control1100229015)
                {
                    //SourceExpr=AmountCaption_Control1100229015;
                }
                Column(Unit_priceCaption_Control1100229023; Unit_priceCaption_Control1100229023)
                {
                    //SourceExpr=Unit_priceCaption_Control1100229023;
                }
                Column(QuantityCaption_Control1100229024; QuantityCaption_Control1100229024)
                {
                    //SourceExpr=QuantityCaption_Control1100229024;
                }
                Column(BiasedsCaption; BiasedsCaption)
                {
                    //SourceExpr=BiasedsCaption;
                }
                Column(HeightCaption; HeightCaption)
                {
                    //SourceExpr=HeightCaption;
                }
                Column(WidthCaption; WidthCaption)
                {
                    //SourceExpr=WidthCaption;
                }
                Column(LengthCaption; LengthCaption)
                {
                    //SourceExpr=LengthCaption;
                }
                Column(Units_Caption; Units_Caption)
                {
                    //SourceExpr=Units_Caption;
                }
                Column(DescriptionCaption_Control1100229025; DescriptionCaption_Control1100229025)
                {
                    //SourceExpr=DescriptionCaption_Control1100229025;
                }
                Column(CodeCaption_Control1100229026; CodeCaption_Control1100229026)
                {
                    //SourceExpr=CodeCaption_Control1100229026;
                }
                Column(Data_Piecework_For_Production__Job_No; "Job No.")
                {
                    //SourceExpr="Job No.";
                }
                Column(Data_Piecework_For_Production__Unique_Code; "Unique Code")
                {
                    //SourceExpr="Unique Code";
                }
                DataItem("QB Text"; "QB Text")
                {

                    DataItemTableView = SORTING("Table", "Key1", "Key2")
                                 WHERE("Table" = CONST("Job"));


                    DataItemLinkReference = "Data Piecework For Production";
                    DataItemLink = "Key1" = FIELD("Job No."),
                            "Key2" = FIELD("Piecework Code");
                    Column(ExtendedLine; ExtendedLine)
                    {
                        //SourceExpr=ExtendedLine;
                    }
                    //D2 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Heading THEN
                            CurrReport.BREAK;

                        CurrReport.SHOWOUTPUT(NOT Onlysummary);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        ExtendedLine := "QB Text".GetSalesText;
                    END;
                }
                DataItem("Measure Line Piecework Certif."; "Measure Line Piecework Certif.")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code", "Line No.");


                    DataItemLinkReference = "Data Piecework For Production";
                    DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework Code");
                    Column(Measure_Line_Piecework_Certif_Units; Units)
                    {
                        //SourceExpr=Units;
                    }
                    Column(Measure_Line_Piecework_Certif_Length; Length)
                    {
                        //SourceExpr=Length;
                    }
                    Column(Measure_Line_Piecework_Certif_Width; Width)
                    {
                        //SourceExpr=Width;
                    }
                    Column(Measure_Line_Piecework_Certif_Height; Height)
                    {
                        //SourceExpr=Height;
                    }
                    Column(Measure_Line_Piecework_Certif_Total; Total)
                    {
                        //SourceExpr=Total;
                    }
                    Column(Measure_Line_Piecework_Certif_Description; Description)
                    {
                        //SourceExpr=Description;
                    }
                    Column(Data_Piecework_For_Production_Sale_Quantity; "Data Piecework For Production"."Sale Quantity (base)")
                    {
                        //SourceExpr="Data Piecework For Production"."Sale Quantity (base)";
                    }
                    Column(Data_Piecework_For_Production____Unit_Price_Sale; "Data Piecework For Production"."Unit Price Sale (base)")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Price Sale (base)";
                        AutoFormatType = 2;
                    }
                    Column(Data_Piecework_For_Production___SaleAmount; "Data Piecework For Production"."Sale Amount")
                    {
                        //SourceExpr="Data Piecework For Production"."Sale Amount";
                        AutoFormatType = 1;
                    }
                    Column(Measure_Line_Piecework_Certif_Job_No; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(Measure_Line_Piecework_Certif_Piecework_Code; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    Column(Measure_Line_Piecework_Certif_Line_No; "Line No.")
                    {
                        //SourceExpr="Line No.";
                    }
                    //D3 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Heading THEN
                            CurrReport.BREAK;

                        CurrReport.SHOWOUTPUT((PrintLinesMeasure));
                        IF CurrReport.SHOWOUTPUT THEN
                            IF "Measure Line Piecework Certif.".Total = 0 THEN
                                CurrReport.SHOWOUTPUT(FALSE);


                        CurrReport.SHOWOUTPUT((NOT Onlysummary) AND PrintLinesMeasure);
                        IF WithoutValue THEN BEGIN
                            "Data Piecework For Production"."Unit Price Sale (base)" := 0;
                            "Data Piecework For Production"."Sale Amount" := 0;
                        END;
                    END;
                }
                DataItem("Integer1"; 2000000026)
                {

                    DataItemTableView = SORTING("Number");
                    MaxIteration = 1;
                    ;
                    Column(Data_Piecework_For_Production_Sale_Quantity__Control1100229092; "Data Piecework For Production"."Sale Quantity (base)")
                    {
                        //SourceExpr="Data Piecework For Production"."Sale Quantity (base)";
                    }
                    Column(Data_Piecework_For_Production_Unit_Price_Sale__Control1100229093; "Data Piecework For Production"."Unit Price Sale (base)")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Price Sale (base)";
                        AutoFormatType = 2;
                    }
                    Column(Data_Piecework_For_Production_Sale_Amount__Control1100229094; "Data Piecework For Production"."Sale Amount")
                    {
                        //SourceExpr="Data Piecework For Production"."Sale Amount";
                        AutoFormatType = 1;
                    }
                    Column(TOTAL_PIECEWORk_Caption; TOTAL_PIECEWORKCaption)
                    {
                        //SourceExpr=TOTAL_PIECEWORKCaption;
                    }
                    Column(Integer1_Number; Number)
                    {
                        //SourceExpr=Number;
                    }
                    //D4 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        CurrReport.SHOWOUTPUT((NOT Onlysummary) AND
                                              ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit));

                        IF WithoutValue THEN BEGIN
                            "Data Piecework For Production"."Unit Price Sale (base)" := 0;
                            "Data Piecework For Production"."Sale Amount" := 0;
                        END;
                    END;
                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    IF Onlysummary THEN
                        CurrReport.BREAK;

                    JobsSetup.GET;
                    Firstpage := TRUE;

                    CurrReport.SHOWOUTPUT((NOT PrintLinesMeasure));

                    IF WithoutValue THEN
                        "Data Piecework For Production"."Accumulated Amount" := 0;

                    IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN
                        CurrReport.SHOWOUTPUT(FALSE)
                    ELSE
                        CurrReport.SHOWOUTPUT(TRUE);

                    IF CurrReport.SHOWOUTPUT THEN BEGIN
                        IF NOT Firstpage THEN BEGIN
                            IF "Data Piecework For Production".Indentation = 0 THEN
                                CurrReport.NEWPAGE
                        END ELSE
                            Firstpage := FALSE;
                    END;

                    CurrReport.SHOWOUTPUT((NOT PrintLinesMeasure) AND
                                          ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit));
                    IF WithoutValue THEN BEGIN
                        "Data Piecework For Production"."Unit Price Sale (base)" := 0;
                        "Data Piecework For Production"."Sale Amount" := 0;
                    END;

                    CurrReport.SHOWOUTPUT((PrintLinesMeasure));

                    CurrReport.SHOWOUTPUT((PrintLinesMeasure) AND
                                          ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit));
                    IF WithoutValue THEN BEGIN
                        "Data Piecework For Production"."Unit Price Sale (base)" := 0;
                        "Data Piecework For Production"."Sale Amount" := 0;
                    END;
                END;
            }

            DataItem("Onlysummary1"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Customer Certification Unit" = CONST(true));
                DataItemLink = "Job No." = FIELD("No.");
                Column(CustAddr_1_; CustAddr[1])
                {
                    //SourceExpr=CustAddr[1];
                }
                Column(CustAddr_2_; CustAddr[2])
                {
                    //SourceExpr=CustAddr[2];
                }
                Column(CustAddr_4_; CustAddr[4])
                {
                    //SourceExpr=CustAddr[4];
                }
                Column(CustAddr_3_; CustAddr[3])
                {
                    //SourceExpr=CustAddr[3];
                }
                Column(CustAddr_5_; CustAddr[5])
                {
                    //SourceExpr=CustAddr[5];
                }
                Column(CustAddr_6_; CustAddr[6])
                {
                    //SourceExpr=CustAddr[6];
                }
                Column(Job_Description_Control1100229068; Job.Description)
                {
                    //SourceExpr=Job.Description;
                }
                Column(Onlysummary1_Sale_Amount; "Sale Amount")
                {
                    //SourceExpr="Sale Amount";
                }
                Column(PADSTR____Indentation___2_Onlysummary1_Description; PADSTR('', Indentation * 2) + Onlysummary1.Description)
                {
                    //SourceExpr=PADSTR('',Indentation * 2)+Onlysummary1.Description;
                }
                Column(Onlysummary1__Piecework_Code; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(TotalAmount; TotalAmount)
                {
                    //SourceExpr=TotalAmount;
                }
                Column(AmountCaption_Control1100229045; AmountCaption_Control1100229045)
                {
                    //SourceExpr=AmountCaption_Control1100229045;
                }
                Column(DescriptionCaption_Control1100229049; DescriptionCaption_Control1100229049)
                {
                    //SourceExpr=DescriptionCaption_Control1100229049;
                }
                Column(TitleCaption; TitleCaption)
                {
                    //SourceExpr=T¡tleCaption;
                }
                Column(TOTAL_BUDGETCaption; TOTAL_BUDGETCaption)
                {
                    //SourceExpr=TOTAL_BUDGETCaption;
                }
                Column(Onlysummary1_Cod__proyecto; "Job No.")
                {
                    //SourceExpr="Job No.";
                }
                //D5 Triggers
                trigger OnPreDataItem();
                BEGIN
                    IF NOT Onlysummary THEN
                        CurrReport.NEWPAGE;

                    CurrReport.CREATETOTALS(TotalAmount);

                    IF Onlysummary1."Account Type" = Onlysummary1."Account Type"::Unit THEN
                        CurrReport.SHOWOUTPUT(FALSE);

                    IF WithoutValue THEN
                        Onlysummary1."Accumulated Amount" := 0;

                    IF WithoutValue THEN
                        TotalAmount := 0;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Onlysummary1.CALCFIELDS("Accumulated Amount");
                    TotalAmount := Onlysummary1."Sale Amount";
                END;

                trigger OnPostDataItem();
                BEGIN
                    GeneralLedgerSetup.GET;
                    ChangeNotInLetters.Decimal2FormatText(TotalAmount, '');
                    //ChangeNotInLetters.FormatNoText(varDescription,ROUND(TotalAmount,0.01),GeneralLedgerSetup."LCY Code");
                    ChangeNotInLetters.Decimal2TextTwoLines(varDescription[1], varDescription[2], MAXSTRLEN(varDescription[1]), ROUND(TotalAmount, 0.01), FALSE, '', 0);
                END;


            }
            DataItem("Footpage"; "2000000026")
            {

                DataItemTableView = SORTING("Number");
                MaxIteration = 1;
                ;
                Column(Asciende_el_presupuesto_general_a_la_expresada_cantidad_de_____VarDescripcionText_1__________VarDescripcionText_2_; 'Asciende el presupuesto general a la expresada cantidad de ' + varDescription[1] + ' ' + varDescription[2])
                {
                    //SourceExpr='Asciende el presupuesto general a la expresada cantidad de ' + varDescription[1] + ' ' + varDescription[2];
                }
                Column(The_Validaty_of_the_present_____DescriptionTextvalidity_1____Months; THE_VALIDITY_OF_THE_PRESENT_Caption + DescriptionTextvalidity[1] + Months)
                {
                    //SourceExpr=THE_VALIDITY_OF_THE_PRESENT_Caption + DescriptionTextvalidity[1] + Months;
                }
                Column(CompanyInformation_City______a_____FORMAT_TODAY_0___Day__de__Month_Text__de__Year4___; CompanyInformation.City + ', a ' + FORMAT(TODAY, 0, '<Day> de <Month Text> de <Year4>'))
                {
                    //SourceExpr=CompanyInformation.City + ', a ' + FORMAT(TODAY,0,'<Day> de <Month Text> de <Year4>');
                }
                Column(EmptyStringCaption; EmptyStringCaption)
                {
                    //SourceExpr=EmptyStringCaption;
                }
                Column(This_amount_will_be_Caption; This_amount_will_be_Caption)
                {
                    //SourceExpr=This_amount_will_be_Caption;
                }
                Column(Will_be_of_accountCaption; Will_be_of_accountCaption)
                {
                    //SourceExpr=Will_be_of_accountCaption;
                }
                Column(All_item_that_is_carriedCaption; All_item_that_is_carriedCaption)
                {
                    //SourceExpr=All_item_that_is_carriedCaption;
                }
                Column(The_items_marked_A_JUSTIF_Caption; The_items_marked_A_JUSTIF_Caption)
                {
                    //SourceExpr=The_items_marked_A_JUSTIF_Caption;
                }
                Column(The_Contractor_shall_be_responsibleCaption; The_Contractor_shall_be_responsibleCaption)
                {
                    //SourceExpr=The_Contractor_shall_be_responsibleCaption;
                }
                Column(The_present_budgetCaption; The_present_budgetCaption)
                {
                    //SourceExpr=The_present_budgetCaption;
                }
                Column(According_the_properCaption; According_the_properCaption)
                {
                    //SourceExpr=According_the_properCaption;
                }
                Column(According_the_contractorCaption; According_the_contractorCaption)
                {
                    //SourceExpr=According_the_contractorCaption;
                }
                Column(EmptyStringCaption_Control1100229062; EmptyStringCaption_Control1100229062)
                {
                    //SourceExpr=EmptyStringCaption_Control1100229062;
                }
                Column(EmptyStringCaption_Control1100229063; EmptyStringCaption_Control1100229063)
                {
                    //SourceExpr=EmptyStringCaption_Control1100229063;
                }
                Column(EmptyStringCaption_Control1100229064; EmptyStringCaption_Control1100229064)
                {
                    //SourceExpr=EmptyStringCaption_Control1100229064;
                }
                Column(EmptyStringCaption_Control1100229065; EmptyStringCaption_Control1100229065)
                {
                    //SourceExpr=EmptyStringCaption_Control1100229065;
                }
                Column(EmptyStringCaption_Control1100229066; EmptyStringCaption_Control1100229066)
                {
                    //SourceExpr=EmptyStringCaption_Control1100229066;
                }
                Column(EmptyStringCaption_Control1100229067; EmptyStringCaption_Control1100229067)
                {
                    //SourceExpr=EmptyStringCaption_Control1100229067;
                }
                Column(Footpage_Number; Number)
                {
                    //SourceExpr=Number ;
                }
                //D6 Triggers
                trigger OnPreDataItem();
                BEGIN
                    IF TotalAmount = 0 THEN
                        CurrReport.SHOWOUTPUT(FALSE);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF (Job."Creation Date" <> 0D) AND (Job."Validate Quote" <> 0D) THEN BEGIN
                        ValidityOffer := Job."Validate Quote" - Job."Creation Date";
                        ValidityOffer := ROUND(ValidityOffer / 30, 1);
                        //ChangeNotInLetters.FormatNoText(DescriptionTextvalidity,ValidityOffer,'');
                        ChangeNotInLetters.Decimal2TextTwoLines(DescriptionTextvalidity[1], DescriptionTextvalidity[2], MAXSTRLEN(DescriptionTextvalidity[1]), ValidityOffer, FALSE, '', 0);

                        IF ValidityOffer = 1 THEN
                            Months := Text004
                        ELSE
                            Months := Text005
                    END;
                END;


            }
            //Job Triggers
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
                IF WithoutValue THEN
                    Header := Text001
                ELSE BEGIN
                    IF PrintLinesMeasure THEN
                        Header := Text002
                    ELSE
                        Header := Text003
                END;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                CLEAR(CustAddr);
                IF "Bill-to Customer No." <> '' THEN BEGIN
                    Customer.GET("Bill-to Customer No.");
                    FormatAddress.Customer(CustAddr, Customer);
                END;
                COMPRESSARRAY(CustAddr);
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
    }

    var
        //       varDescription@7001122 :
        varDescription: ARRAY[2] OF Text[80];
        //       ChangeNotInLetters@7001121 :
        ChangeNotInLetters: Codeunit 7207289;
        //       Firstpage@7001120 :
        Firstpage: Boolean;
        //       GeneralLedgerSetup@7001119 :
        GeneralLedgerSetup: Record 98;
        //       Customer@7001118 :
        Customer: Record 18;
        //       CustAddr@7001117 :
        CustAddr: ARRAY[8] OF Text[30];
        //       FormatAddress@7001116 :
        FormatAddress: Codeunit 365;
        //       JobsSetup@7001115 :
        JobsSetup: Record 315;
        //       PrintLinesMeasure@7001114 :
        PrintLinesMeasure: Boolean;
        //       Onlysummary@7001113 :
        Onlysummary: Boolean;
        //       ExtendedLine@7001112 :
        ExtendedLine: Text;
        //       CompanyInformation@7001110 :
        CompanyInformation: Record 79;
        //       WithoutValue@7001109 :
        WithoutValue: Boolean;
        //       TotalAmount@7001108 :
        TotalAmount: Decimal;
        //       ValidityOffer@7001107 :
        ValidityOffer: Decimal;
        //       DescriptionTextvalidity@7001106 :
        DescriptionTextvalidity: ARRAY[2] OF Text[57];
        //       Months@7001105 :
        Months: Text[30];
        //       Header@7001104 :
        Header: Text[30];
        //       DataPieceworkForProduction1@7001103 :
        DataPieceworkForProduction1: Record 7207386;
        //       PartTotal@7001102 :
        PartTotal: Boolean;
        //       DataPieceworkForProduction2@7001101 :
        DataPieceworkForProduction2: Record 7207386;
        //       test@7001100 :
        test: Text[150];
        //       CurrReport_PAGENOCaption@7001158 :
        CurrReport_PAGENOCaption: TextConst ENU = 'Page', ESP = 'P gina';
        //       AmountCaption@7001157 :
        AmountCaption: TextConst ENU = 'Amount', ESP = 'Importe';
        //       Unit_priceCaption@7001156 :
        Unit_priceCaption: TextConst ENU = 'Unit price', ESP = 'P. Unitario';
        //       QuantityCaption@7001155 :
        QuantityCaption: TextConst ENU = 'Quantity', ESP = 'Cantidad';
        //       DescriptionCaption@7001154 :
        DescriptionCaption: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       CodeCaption@7001153 :
        CodeCaption: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       AmountCaption_Control1100229015@7001152 :
        AmountCaption_Control1100229015: TextConst ENU = 'Amount', ESP = 'Importe';
        //       Unit_priceCaption_Control1100229023@7001151 :
        Unit_priceCaption_Control1100229023: TextConst ENU = 'Unit price', ESP = 'P. Unitario';
        //       QuantityCaption_Control1100229024@7001150 :
        QuantityCaption_Control1100229024: TextConst ENU = 'Quantity', ESP = 'Cantidad';
        //       BiasedsCaption@7001149 :
        BiasedsCaption: TextConst ENU = 'Biaseds', ESP = 'Parciales';
        //       HeightCaption@7001148 :
        HeightCaption: TextConst ENU = 'Height', ESP = 'Altura';
        //       WidthCaption@7001147 :
        WidthCaption: TextConst ENU = 'Width', ESP = 'Anchura';
        //       LengthCaption@7001146 :
        LengthCaption: TextConst ENU = 'Length', ESP = 'Longitud';
        //       Units_Caption@7001145 :
        Units_Caption: TextConst ENU = 'Units', ESP = 'Uds.';
        //       DescriptionCaption_Control1100229025@7001144 :
        DescriptionCaption_Control1100229025: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       CodeCaption_Control1100229026@7001143 :
        CodeCaption_Control1100229026: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       TOTAL_PIECEWORKCaption@7001142 :
        TOTAL_PIECEWORKCaption: TextConst ENU = 'TOTAL PIECEWORK', ESP = 'TOTAL U.O.';
        //       AmountCaption_Control1100229045@7001141 :
        AmountCaption_Control1100229045: TextConst ENU = 'Amount', ESP = 'Importe';
        //       DescriptionCaption_Control1100229049@7001140 :
        DescriptionCaption_Control1100229049: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       T¡tleCaption@7001139 :
        TitleCaption: TextConst ENU = 'T¡tle', ESP = 'T¡tulo';
        //       TOTAL_BUDGETCaption@7001138 :
        TOTAL_BUDGETCaption: TextConst ENU = 'TOTAL BUDGET', ESP = 'TOTAL PRESUPUESTO';
        //       EmptyStringCaption@7001137 :
        EmptyStringCaption: TextConst ENU = '-', ESP = '-';
        //       This_amount_will_be_Caption@7001136 :
        This_amount_will_be_Caption: TextConst ENU = 'This amount will be increased by the corresponding VAT.', ESP = 'Esta cantidad se ver  incrementada por el IVA correspondiente.';
        //       Will_be_of_accountCaption@7001135 :
        Will_be_of_accountCaption: TextConst ENU = 'Will be of account of the property all type of Municipal Licenses as well as the fees of the Facultative Direction.', ESP = 'Ser n de cuenta de la propiedad todo tipo de Licencias Municipales as¡ como los honorarios de la Direcci¢n Facultativa';
        //       All_item_that_is_carriedCaption@7001134 :
        All_item_that_is_carriedCaption: TextConst ENU = 'All item that is carried out outside budget, will be invoiced according to the unit prices agreed prior to its realization.', ESP = 'Toda partida que se realice fuera de presupuesto, ser  facturada conforme a los precios unitarios pactados con anterioridad a su realizaci¢n.';
        //       The_items_marked_A_JUSTIF_Caption@7001133 :
        The_items_marked_A_JUSTIF_Caption: TextConst ENU = 'The items marked A JUSTIFY, will be settled according to the work actually performed.', ESP = 'Las partidas marcadas como A JUSTIFICAR, se liquidar n seg£n obra realmente realizada.';
        //       The_Contractor_shall_be_responsibleCaption@7001132 :
        The_Contractor_shall_be_responsibleCaption: TextConst ENU = 'The Contractor shall be responsible for the service and implementation of the necessary materials for the good development of the same, fees of all the personnel that work to his orders as well as the Social Security of the same.', ESP = 'Quedar  de cuenta de Contratista el servicio y puesta en obra de los materiales necesarios para el buen desarrollo de la misma, honorarios de todo el personal que trabaje a sus ordenes as¡ como la Seguridad Social del mismo.';
        //       The_present_budgetCaption@7001131 :
        The_present_budgetCaption: TextConst ENU = 'The present budget has been made according to the items and measurements made by us and according to our criteria in terms of qualities and materials used, so we are not responsible if the qualities do not match those designed by the project architect, as well as in measurements.', ESP = 'El presente presupuesto ha sido realizado conforme a las partidas y mediciones realizad<as por nosotros y seg£n nuestros criterios en cuanto a calidades y materiales empleados, por lo que no nos responsabilizamos si las calidades no coinciden con las pensadas por el arquitecto redactor del proyecto, as¡ como en las mediciones.';
        //       THE_VALIDITY_OF_THE_PRESENT_Caption@7001164 :
        THE_VALIDITY_OF_THE_PRESENT_Caption: TextConst ENU = 'THE VALIDITY OF THE PRESENT BUDGET WILL BE', ESP = 'LA VALIDEZ DEL PRESENTE PRESUPUESTO SERA DE';
        //       According_the_properCaption@7001130 :
        According_the_properCaption: TextConst ENU = 'According the property', ESP = 'Conforme la propiedad';
        //       According_the_contractorCaption@7001129 :
        According_the_contractorCaption: TextConst ENU = 'According the contractor', ESP = 'Conforme el contratista';
        //       EmptyStringCaption_Control1100229062@7001128 :
        EmptyStringCaption_Control1100229062: TextConst ENU = '-', ESP = '-';
        //       EmptyStringCaption_Control1100229063@7001127 :
        EmptyStringCaption_Control1100229063: TextConst ENU = '-', ESP = '-';
        //       EmptyStringCaption_Control1100229064@7001126 :
        EmptyStringCaption_Control1100229064: TextConst ENU = '-', ESP = '-';
        //       EmptyStringCaption_Control1100229065@7001125 :
        EmptyStringCaption_Control1100229065: TextConst ENU = '-', ESP = '-';
        //       EmptyStringCaption_Control1100229066@7001124 :
        EmptyStringCaption_Control1100229066: TextConst ENU = '-', ESP = '-';
        //       EmptyStringCaption_Control1100229067@7001123 :
        EmptyStringCaption_Control1100229067: TextConst ENU = '-', ESP = '-';
        //       Text001@7001159 :
        Text001: TextConst ENU = 'MEASUREMENTS', ESP = 'MEDICIONES';
        //       Text002@7001160 :
        Text002: TextConst ENU = 'MEASUREMENTS and BUDGET', ESP = 'MEDICIONES Y PRESUPUESTO';
        //       Text003@7001161 :
        Text003: TextConst ENU = 'BUDGET', ESP = 'PRESUPUESTO';
        //       Text004@7001162 :
        Text004: TextConst ENU = 'MONTH', ESP = 'MES';
        //       Text005@7001163 :
        Text005: TextConst ENU = 'MONTHS', ESP = 'MESES';

    /*begin
    {
      Se filtra por Unidad de certificaci¢n igual a S¡ en las propiedades del dataitem  Datos unidad de obra para
      producci¢n y solo resumen.
    }
    end.
  */

}



