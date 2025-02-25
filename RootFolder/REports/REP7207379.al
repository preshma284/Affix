report 7207379 "Closing Job Forecast"
{


    CaptionML = ENU = 'Closing Job Forecast', ESP = 'Previsi¢n cierre de obra';
    PreviewMode = Normal;

    dataset
    {

        DataItem("Job"; "Job")
        {

            PrintOnlyIfDetail = false;


            RequestFilterFields = "No.", "Posting Date Filter";
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(CompanyInformationPicture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(JobNo; "No.")
            {
                //SourceExpr="No.";
            }
            Column(JobFilters; Job.GETFILTER("Posting Date Filter"))
            {
                //SourceExpr=Job.GETFILTER("Posting Date Filter");
            }
            Column(JobDesc; Job.Description)
            {
                //SourceExpr=Job.Description;
            }
            Column(JobDesc2; Job."Description 2")
            {
                //SourceExpr=Job."Description 2";
            }
            Column(LocationAmount; LocationAmount)
            {
                //SourceExpr=LocationAmount;
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Production Unit" = CONST(true));
                PrintOnlyIfDetail = false;
                DataItemLink = "Job No." = FIELD("No.");
                Column(Indentation; "Data Piecework For Production".Indentation)
                {
                    //SourceExpr="Data Piecework For Production".Indentation;
                }
                Column(PieceworkCode; "Data Piecework For Production"."Piecework Code")
                {
                    //SourceExpr="Data Piecework For Production"."Piecework Code";
                }
                Column(PieceworkDescription; "Data Piecework For Production".Description)
                {
                    //SourceExpr="Data Piecework For Production".Description;
                }
                Column(UnitOfMeasure; "Data Piecework For Production"."Unit Of Measure")
                {
                    //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                }
                Column(OForecast; OForecast)
                {
                    //SourceExpr=OForecast;
                }
                Column(BudgetCost; BudgetCost)
                {
                    //SourceExpr=BudgetCost;
                }
                Column(RealizedCost; RealizedCost)
                {
                    //SourceExpr=RealizedCost;
                }
                Column(Parent; Parent)
                {
                    //SourceExpr=Parent;
                }
                Column(AccountType; "Data Piecework For Production"."Account Type")
                {
                    //SourceExpr="Data Piecework For Production"."Account Type";
                }
                Column(IsPiecework; IsPiecework)
                {
                    //SourceExpr=[IsPiecework ];
                }
                DataItem("Item"; "Item")
                {

                    DataItemTableView = SORTING("No.");
                    ;
                    Column(ProdAmount; ProdAmount)
                    {
                        //SourceExpr=ProdAmount ;
                    }
                    trigger OnAfterGetRecord();
                    BEGIN
                        SETFILTER("Location Filter", Job."Job Location");
                        SETFILTER("Date Filter", '%1..%2', 0D, Job.GETRANGEMAX("Posting Date Filter"));
                        CALCFIELDS("Net Change");
                        ItemCostMgt.CalculateAverageCost(Item, AverageCostLCY, AverageCostACY);

                        LocationAmount := LocationAmount + Item."Net Change" * AverageCostLCY;
                        ProdAmount := Item."Net Change" * AverageCostLCY;
                    END;


                }
                trigger OnPreDataItem();
                begin

                    //{CurrReport.CREATETOTALS(OForecast,
                    //                                      "Data Piecework For Production"."Amount Cost Budget",
                    //                                      "Data Piecework For Production"."Amount Cost Performed",
                    //                                      BudgetCost,
                    //                                      RealizedCost);
                    //                               }
                END;

                trigger OnAfterGetRecord();
                BEGIN


                    "Data Piecework For Production".SETRANGE("Filter Date");

                    IF "Data Piecework For Production"."Unit Of Measure" <> '' THEN BEGIN
                        SETRANGE("Budget Filter", Job."Initial Budget Piecework");
                        CALCFIELDS("Amount Cost Budget (JC)");
                        OForecast := "Amount Cost Budget (JC)";

                        //"Data Piecework For Production".RESET;
                        "Data Piecework For Production".SETRANGE("Filter Date");
                        SETRANGE("Budget Filter", Job."Current Piecework Budget");
                        CALCFIELDS("Amount Cost Budget (JC)");
                        BudgetCost := "Data Piecework For Production"."Amount Cost Budget (JC)";

                        //"Data Piecework For Production".RESET;
                        "Data Piecework For Production".SETRANGE("Filter Date");
                        SETRANGE("Budget Filter");
                        Job.COPYFILTER("Posting Date Filter", "Filter Date");
                        CALCFIELDS("Amount Cost Performed (JC)");
                        RealizedCost := "Data Piecework For Production"."Amount Cost Performed (JC)";
                    END
                    ELSE BEGIN
                        CLEAR(OForecast);
                        CLEAR(BudgetCost);
                        CLEAR(RealizedCost);
                    END;

                    Parent := "Data Piecework For Production".ReturnFather("Data Piecework For Production");
                    IF (OForecast = 0) AND (BudgetCost = 0) AND (RealizedCost = 0) THEN BEGIN
                        IF Parent <> '' THEN
                            CurrReport.SKIP
                        ELSE
                            IsPiecework := TRUE;
                    END
                    ELSE
                        IsPiecework := TRUE;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                DateFilter := GETFILTER(Job."Posting Date Filter");
                //{CurrReport.CREATETOTALS(OForecast,
                //                                      "Data Piecework For Production"."Amount Cost Budget",
                //                                      "Data Piecework For Production"."Amount Cost Performed",
                //                                      "Data Piecework For Production"."Amount Production Performed",
                //                                      LocationAmount,
                //                                      BudgetCost,
                //                                      RealizedCost);
                //                               }
            END;

            trigger OnAfterGetRecord();
            BEGIN
                OForecast := 0;
                LocationAmount := 0;
                BudgetCost := 0;
                RealizedCost := 0;
                //{
                //                                  DataPieceworkForProduction2.RESET;
                //                                  DataPieceworkForProduction2.SETRANGE("Job No.", Job."No.");
                //                                  DataPieceworkForProduction2.SETRANGE("Filter Date",Job."Posting Date Filter");
                //                                  //DataPieceworkForProduction2.SETFILTER("Unit Of Measure",'<>""');
                //                                  IF DataPieceworkForProduction2.FINDSET THEN
                //                                    REPEAT
                //                                      DataPieceworkForProduction3.RESET;
                //                                      DataPieceworkForProduction3.COPYFILTERS(DataPieceworkForProduction2);
                //                                      DataPieceworkForProduction3.SETRANGE("Budget Filter",Job."Initial Budget Piecework");
                //                                      DataPieceworkForProduction3.CALCFIELDS("Amount Cost Budget");
                //                                      IF DataPieceworkForProduction3."Unit Of Measure" <> '' THEN
                //                                        TotOForecast += DataPieceworkForProduction3."Amount Cost Budget";
                //
                //                                      DataPieceworkForProduction3.RESET;
                //                                      DataPieceworkForProduction3.COPYFILTERS(DataPieceworkForProduction2);
                //                                      DataPieceworkForProduction3.SETRANGE("Budget Filter",Job."Current Piecework Budget");
                //                                      DataPieceworkForProduction3.CALCFIELDS("Amount Cost Budget");
                //                                      IF DataPieceworkForProduction3."Unit Of Measure" <> '' THEN
                //                                        TotBudgetCost += DataPieceworkForProduction3."Amount Cost Budget";
                //
                //                                      DataPieceworkForProduction3.RESET;
                //                                      DataPieceworkForProduction3.COPYFILTERS(DataPieceworkForProduction2);
                //                                      DataPieceworkForProduction3.SETRANGE("Budget Filter");
                //                                      Job.COPYFILTER("Posting Date Filter",DataPieceworkForProduction3."Filter Date");
                //                                      DataPieceworkForProduction3.CALCFIELDS("Amount Cost Performed");
                //                                      IF DataPieceworkForProduction3."Unit Of Measure" <> '' THEN
                //                                        TotRealizedCost += DataPieceworkForProduction3."Amount Cost Performed";
                //                                    UNTIL DataPieceworkForProduction2.NEXT = 0;
                //                                    }
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
        txtJob = 'Job:/ Proyecto:/';
        txtPage = 'Page/ P g./';
        txtOForecast = 'Original Forecast/ Prev. inicial/';
        txtCurrForecast = 'Current Forecast/ Prev. actual/';
        txtReal = 'Real/ Real/';
        txtDev = 'Deviation/ Desviaci¢n/';
        txtPend = 'Pending/ Pendiente/';
        txtTotJob = 'Total Job/ Total proyecto/';
        txtStock = 'STOCK/ EXISTENCIAS/';
        txtTotal = 'TOTAL/ TOTAL/';
        txtPiecework = 'Piecework/ Unidad de obra/';
        txtReportName = 'Closing Job Forecast/ Previsi¢n cierre de obra/';
        txtDate = 'Date:/ Fecha:/';
    }

    var
        //       CompanyInformation@7001115 :
        CompanyInformation: Record 79;
        //       Recjob@7001114 :
        Recjob: Record 167;
        //       OForecast@7001113 :
        OForecast: Decimal;
        //       RecDataPieceworkForProduction@7001112 :
        RecDataPieceworkForProduction: Record 7207386;
        //       DateFilter@7001111 :
        DateFilter: Text[30];
        //       Since@7001110 :
        Since: Date;
        //       LocationAmount@7001109 :
        LocationAmount: Decimal;
        //       ItemLedgerEntry@7001108 :
        ItemLedgerEntry: Record 32;
        //       ItemCostMgt@7001107 :
        ItemCostMgt: Codeunit 5804;
        //       AverageCostLCY@7001106 :
        AverageCostLCY: Decimal;
        //       AverageCostACY@7001105 :
        AverageCostACY: Decimal;
        //       BudgetCost@7001104 :
        BudgetCost: Decimal;
        //       RealizedCost@7001103 :
        RealizedCost: Decimal;
        //       Parent@7001102 :
        Parent: Code[20];
        //       ProdAmount@7001101 :
        ProdAmount: Decimal;
        //       IsPiecework@7001100 :
        IsPiecework: Boolean;
        //       cont@7001116 :
        cont: Integer;



    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;



    /*begin
        end.
      */

}



