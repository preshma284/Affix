report 7207299 "Print Material Box"
{


    CaptionML = ENU = 'Print Material Box', ESP = 'Impresi¢n cuadro de materiales';

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
            Column(Job_Description2; "Description 2")
            {
                //SourceExpr="Description 2";
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
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(JobCaption; JobCaption + ':')
            {
                //SourceExpr=JobCaption+ ':';
            }
            Column(LaborCaption; LaborCaption)
            {
                //SourceExpr=LaborCaption;
            }
            Column(MachineryCaption; MachineryCaption)
            {
                //SourceExpr=MachineryCaption;
            }
            Column(MaterialsCaption; MaterialsCaption)
            {
                //SourceExpr=MaterialsCaption;
            }
            Column(OthersCaption; OthersCaption)
            {
                //SourceExpr=OthersCaption;
            }
            Column(budgetlineTOTALCaption; budgetlineTOTALCaption)
            {
                //SourceExpr=budgetlineTOTALCaption;
            }
            Column(UMCaption; UMCaption)
            {
                //SourceExpr=UMCaption;
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Production Unit" = CONST(true), "Type" = CONST("Piecework"));
                DataItemLink = "Job No." = FIELD("No.");
                Column(PADSTR____Indentation___2___Data_Piecework_For_Production_DescUO; "Data Piecework For Production".DescUO)
                {
                    //SourceExpr="Data Piecework For Production".DescUO;
                }
                Column(Data_Piecework_For_Production_Piecework_Code; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(PADSTR____Indentation___2__Data_Piecework_For_Production___FunDescUO_Control1100229083; "Data Piecework For Production".DescUO)
                {
                    //SourceExpr="Data Piecework For Production".DescUO;
                }
                Column(funUnitsOfMeasure; funUnitsOfMeasure)
                {
                    //SourceExpr=funUnitsOfMeasure;
                }
                Column(Data_Piecework_For_Production__Piecework_Code__Control1100231003; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(AmountCaption; AmountCaption)
                {
                    //SourceExpr=AmountCaption;
                }
                Column(UnitpriceCaption; UnitpriceCaption)
                {
                    //SourceExpr=UnitpriceCaption;
                }
                Column(DescriptionCaption; DescriptionCaption)
                {
                    //SourceExpr=DescriptionCaption;
                }
                Column(Data_Cost_By_Piecework__Budget_Cost__Caption; DataCostByPiecework.FIELDCAPTION("Budget Cost"))
                {
                    //SourceExpr=DataCostByPiecework.FIELDCAPTION("Budget Cost");
                }
                Column(QuantityCaption; QuantityCaption)
                {
                    //SourceExpr=QuantityCaption;
                }
                Column(CodeCaption; CodeCaption)
                {
                    //SourceExpr=CodeCaption;
                }
                Column(Data_Piecework_For_Production__Job_No; "Job No.")
                {
                    //SourceExpr="Job No.";
                }
                Column(Data_Piecework_For_Production_Unique_Code; "Unique Code")
                {
                    //SourceExpr="Unique Code";
                }
                DataItem("QB Text"; "QB Text")
                {

                    DataItemTableView = SORTING("Table", "Key1", "Key2")
                                 WHERE("Table" = CONST("Job"));
                    DataItemLink = "Key1" = FIELD("Job No."),
                            "Key2" = FIELD("Piecework Code");
                    Column(ExtendedLine; ExtendedLine)
                    {
                        //SourceExpr=ExtendedLine;
                    }
                    trigger OnAfterGetRecord();
                    BEGIN
                        ExtendedLine := "QB Text".GetCostText;
                    END;
                }

                DataItem("Data Cost By Piecework"; "Data Cost By Piecework")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code", "Cost Type", "No.");
                    DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework Code");
                    Column(Datos_coste_por_UO__N__; "No.")
                    {
                        //SourceExpr="No.";
                    }
                    Column(DescPiecework; DescPiecework)
                    {
                        //SourceExpr=DescPiecework;
                    }
                    Column(Data_Cost_By_Piecework_Cod_Measure_Uni; "Cod. Measure Unit")
                    {
                        //SourceExpr="Cod. Measure Unit";
                    }
                    Column(Data_Cost_By_Piecework__Performance_By_Piecework; "Performance By Piecework")
                    {
                        //SourceExpr="Performance By Piecework";
                    }
                    Column(Data_Cost_By_Piecework__Direct_Unitary_Cost; "Direct Unitary Cost (JC)")
                    {
                        //SourceExpr="Direct Unitary Cost (JC)";
                    }
                    Column(Amount_1_; Amount[1])
                    {
                        //SourceExpr=Amount[1];
                    }
                    Column(Amount_2_; Amount[2])
                    {
                        //SourceExpr=Amount[2];
                    }
                    Column(Amount_3_; Amount[3])
                    {
                        //SourceExpr=Amount[3];
                    }
                    Column(Amount_4_; Amount[4])
                    {
                        //SourceExpr=Amount[4];
                    }
                    Column(Amount_1___Amount_2____Amount_3____Amount_4_; Amount[1] + Amount[2] + Amount[3] + Amount[4])
                    {
                        //SourceExpr=Amount[1] + Amount[2] + Amount[3] + Amount[4];
                    }
                    Column(Data_Cost_By_Piecework__Budget_Cost; "Budget Cost")
                    {
                        //SourceExpr="Budget Cost";
                    }
                    Column(Data_Cost_By_Piecework_Job_No; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(Data_Cost_By_Piecework_Piecework_Code; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    Column(Data_Cost_By_Piecework_Cod_Budget; "Cod. Budget")
                    {
                        //SourceExpr="Cod. Budget";
                    }
                    Column(Data_Cost_By_Piecework_Cost_Type; "Cost Type")
                    {
                        //SourceExpr="Cost Type" ;
                    }
                    trigger OnPreDataItem();
                    BEGIN
                        CurrReport.CREATETOTALS(Amount);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        DescPiecework := '';
                        Amount[1] := 0;
                        Amount[2] := 0;
                        Amount[3] := 0;
                        Amount[4] := 0;
                        IF "Data Cost By Piecework"."Cost Type" = "Data Cost By Piecework"."Cost Type"::Account THEN BEGIN
                            IF GLAccount.GET("Data Cost By Piecework"."No.") THEN
                                DescPiecework := GLAccount.Name;
                            Amount[4] := "Data Cost By Piecework"."Budget Cost";
                        END;

                        IF "Data Cost By Piecework"."Cost Type" = "Data Cost By Piecework"."Cost Type"::Resource THEN BEGIN
                            IF Resource.GET("Data Cost By Piecework"."No.") THEN BEGIN
                                DescPiecework := Resource.Name;
                                IF Resource.Type = Resource.Type::Machine THEN
                                    Amount[2] := "Data Cost By Piecework"."Budget Cost"
                                ELSE
                                    Amount[1] := "Data Cost By Piecework"."Budget Cost"
                            END ELSE
                                Amount[1] := "Data Cost By Piecework"."Budget Cost";
                        END;

                        IF "Data Cost By Piecework"."Cost Type" = "Data Cost By Piecework"."Cost Type"::Item THEN BEGIN
                            IF Resource.GET("Data Cost By Piecework"."No.") THEN
                                DescPiecework := Resource.Name;
                            Amount[3] := "Data Cost By Piecework"."Budget Cost"
                        END;

                        IF "Data Cost By Piecework"."Cost Type" = "Data Cost By Piecework"."Cost Type"::"Resource Group" THEN BEGIN
                            IF ResourceGroup.GET("Data Cost By Piecework"."No.") THEN
                                DescPiecework := ResourceGroup.Name;
                            Amount[4] := "Data Cost By Piecework"."Budget Cost"
                        END;
                    END;


                }

                trigger OnPreDataItem();
                BEGIN
                    CurrReport.CREATETOTALS("Data Piecework For Production"."Sale Amount");
                    JobsSetup.GET;
                    Firstpage := TRUE;

                    CurrReport.SHOWOUTPUT("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Heading);
                    CurrReport.SHOWOUTPUT("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    "Sales Amount (Base)" := ROUND("Sales Amount (Base)", 0.01);
                    IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN BEGIN
                        DataCostByPiecework.SETRANGE("Job No.", "Data Piecework For Production"."Job No.");
                        DataCostByPiecework.SETRANGE("Piecework Code", "Data Piecework For Production"."Piecework Code");
                        IF NOT DataCostByPiecework.FINDFIRST THEN
                            CurrReport.SKIP;
                    END;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
                Header := Text001;
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
        //       Firstpage@7001119 :
        Firstpage: Boolean;
        //       GeneralLedgerSetup@7001118 :
        GeneralLedgerSetup: Record 98;
        //       Offervalidity@7001117 :
        Offervalidity: Decimal;
        //       TexValiditytDescription@7001116 :
        TexValiditytDescription: ARRAY[2] OF Text[57];
        //       Month@7001115 :
        Month: Text[30];
        //       Customer@7001114 :
        Customer: Record 18;
        //       CustAddr@7001113 :
        CustAddr: ARRAY[8] OF Text[90];
        //       FormatAddress@7001112 :
        FormatAddress: Codeunit 365;
        //       JobsSetup@7001111 :
        JobsSetup: Record 315;
        //       ExtendedLine@7001110 :
        ExtendedLine: Text;
        //       CompanyInformation@7001108 :
        CompanyInformation: Record 79;
        //       Header@7001107 :
        Header: Text[30];
        //       DescPiecework@7001106 :
        DescPiecework: Text[40];
        //       Item@7001105 :
        Item: Record 27;
        //       Resource@7001104 :
        Resource: Record 156;
        //       GLAccount@7001103 :
        GLAccount: Record 15;
        //       ResourceGroup@7001102 :
        ResourceGroup: Record 152;
        //       Amount@7001101 :
        Amount: ARRAY[4] OF Decimal;
        //       DataCostByPiecework@7001100 :
        DataCostByPiecework: Record 7207387;
        //       CurrReport_PAGENOCaption@7001130 :
        CurrReport_PAGENOCaption: TextConst ENU = 'Page', ESP = 'P gina';
        //       AmountCaption@7001129 :
        AmountCaption: TextConst ENU = 'P.O§ U.O.', ESP = 'P.O§ U.O.';
        //       UnitpriceCaption@7001128 :
        UnitpriceCaption: TextConst ENU = 'Unit Price', ESP = 'P. Unitario';
        //       DescriptionCaption@7001127 :
        DescriptionCaption: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       QuantityCaption@7001126 :
        QuantityCaption: TextConst ENU = 'Quantity', ESP = 'Cantidad';
        //       CodeCaption@7001125 :
        CodeCaption: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       LaborCaption@7001124 :
        LaborCaption: TextConst ENU = 'Labor', ESP = 'Mano de obra';
        //       MachineryCaption@7001123 :
        MachineryCaption: TextConst ENU = 'Machinery', ESP = 'Maquinar¡a';
        //       MaterialsCaption@7001122 :
        MaterialsCaption: TextConst ENU = 'Materials ', ESP = 'Materiales';
        //       OthersCaption@7001121 :
        OthersCaption: TextConst ENU = 'Others', ESP = 'Otros';
        //       budgetlineTOTALCaption@7001120 :
        budgetlineTOTALCaption: TextConst ENU = 'BUDGET LINE TOTAL', ESP = 'TOTAL PARTIDA';
        //       Text001@7001131 :
        Text001: TextConst ENU = 'MATERIALS BOX', ESP = 'CUADRO DE MATERIALES';
        //       JobCaption@7001132 :
        JobCaption: TextConst ENU = 'Job', ESP = 'Proyecto';
        //       UMCaption@7001133 :
        UMCaption: TextConst ENU = 'U.M.', ESP = 'U.M.';

    /*begin
    {
      JAV 12/03/19: - Se aumenta el tama¤o de la variable global CustAddr a 90 para que coincida con lo que espera la CU y de DescPiecework a sin tama¤o
    }
    end.
  */

}



