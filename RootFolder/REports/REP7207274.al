report 7207274 "Update Ppto. Dptos"
{


    CaptionML = ENU = 'Update Ppto. Dptos', ESP = 'Actualizar Ppto Dptos';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Dimension Value"; "Dimension Value")
        {

            DataItemTableView = SORTING("Dimension Code", "Code")
                                 ORDER(Ascending);
            ;
            DataItem("G/L Budget Name"; "G/L Budget Name")
            {

                DataItemTableView = SORTING("Name")
                                 ORDER(Ascending);


                RequestFilterFields = "Name";

                trigger OnAfterGetRecord();
                BEGIN
                    // Primero borro el presupuesto del departamento o departamentos que me hayan elegido.
                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN BEGIN
                        "G/L Budget Entry".RESET;
                        "G/L Budget Entry".SETCURRENTKEY("Budget Name", "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code",
                                                         "Global Dimension 2 Code", "Budget Dimension 1 Code", "Budget Dimension 2 Code", "Budget Dimension 3 Code",
                                                         "Budget Dimension 4 Code", Date);
                        "G/L Budget Entry".SETRANGE("Budget Name", "G/L Budget Name".Name);
                        "G/L Budget Entry".SETFILTER(Date, "G/L Budget Entry".GETFILTER(Date));
                        "G/L Budget Entry".SETRANGE("Global Dimension 1 Code", DimensionValue.Code);
                        "G/L Budget Entry".DELETEALL(TRUE);
                    END ELSE BEGIN
                        "G/L Budget Entry".RESET;
                        "G/L Budget Entry".SETCURRENTKEY("Budget Name", "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code",
                                                         "Global Dimension 2 Code", "Budget Dimension 1 Code", "Budget Dimension 2 Code", "Budget Dimension 3 Code",
                                     "Budget Dimension 4 Code", Date);
                        "G/L Budget Entry".SETRANGE("Budget Name", "G/L Budget Name".Name);
                        "G/L Budget Entry".SETFILTER(Date, "G/L Budget Entry".GETFILTER(Date));
                        "G/L Budget Entry".SETRANGE("Global Dimension 2 Code", "Dimension Value".Code);
                        "G/L Budget Entry".DELETEALL(TRUE);
                    END;
                    Window.UPDATE(2, "G/L Budget Name".Name);
                END;



            }
            DataItem("Job"; "Job")
            {

                DataItemTableView = SORTING("No.")
                                 ORDER(Ascending)
                                 WHERE("Job Type" = FILTER("Structure"), "Blocked" = CONST(" "));


                RequestFilterFields = "No.";
                DataItem("G/L Budget Entry"; "G/L Budget Entry")
                {

                    DataItemTableView = SORTING("Budget Name", "G/L Account No.", "Date")
                                 ORDER(Ascending);


                    RequestFilterFields = "Date";
                    trigger OnPreDataItem();
                    BEGIN
                        //Filtro por el presupuesto de proyectos.
                        //"G/L Budget Entry".SETRANGE("Budget Name",FunctionQB.ReturnrPptoJobs);

                        //filtro por el proyecto del departamento.
                        "G/L Budget Name".GET(FunctionQB.ReturnBudgetJobs);
                        IF "G/L Budget Name"."Budget Dimension 1 Code" = FunctionQB.ReturnDimJobs THEN
                            "G/L Budget Entry".SETRANGE("Budget Dimension 1 Code", Job."No.");

                        IF "G/L Budget Name"."Budget Dimension 2 Code" = FunctionQB.ReturnDimJobs THEN
                            "G/L Budget Entry".SETRANGE("Budget Dimension 2 Code", Job."No.");

                        IF "G/L Budget Name"."Budget Dimension 3 Code" = FunctionQB.ReturnDimJobs THEN
                            "G/L Budget Entry".SETRANGE("Budget Dimension 3 Code", Job."No.");

                        IF "G/L Budget Name"."Budget Dimension 4 Code" = FunctionQB.ReturnDimJobs THEN
                            "G/L Budget Entry".SETRANGE("Budget Dimension 4 Code", Job."No.");

                        "G/L Budget Entry".RESET;
                        "G/L Budget Entry".SETCURRENTKEY("Entry No.");
                        IF "G/L Budget Entry".FINDLAST THEN
                            intCont := "G/L Budget Entry"."Entry No."
                        ELSE
                            intCont := 0;

                        Window.UPDATE(4, "G/L Budget Entry".GETFILTER(Date));
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        intCont += 1;

                        "G/L Budget Entry".RESET;

                        "G/L Budget Entry".INIT;
                        "G/L Budget Entry"."Entry No." := intCont;
                        "G/L Budget Entry"."Budget Name" := "G/L Budget Name".Name;
                        "G/L Budget Entry"."G/L Account No." := "G/L Budget Entry"."G/L Account No.";
                        "G/L Budget Entry".Date := "G/L Budget Entry".Date;
                        "G/L Budget Entry"."Global Dimension 1 Code" := "G/L Budget Entry"."Global Dimension 1 Code";
                        "G/L Budget Entry"."Global Dimension 2 Code" := "G/L Budget Entry"."Global Dimension 2 Code";
                        "G/L Budget Entry".Amount := "G/L Budget Entry".Amount;
                        "G/L Budget Entry".Description := "G/L Budget Entry".Description;
                        "G/L Budget Entry"."Business Unit Code" := "G/L Budget Entry"."Business Unit Code";
                        "G/L Budget Entry"."User ID" := USERID;
                        "G/L Budget Entry".INSERT(TRUE);

                        Window.UPDATE(5, "G/L Budget Entry"."Entry No.");
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    //Filtro los proyectos del departamento de arriba.
                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
                        Job.SETRANGE("Global Dimension 1 Code", "Dimension Value".Code)
                    ELSE
                        Job.SETRANGE("Global Dimension 2 Code", "Dimension Value".Code);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Window.UPDATE(3, Job."No.");
                END;


            }

            trigger OnPreDataItem();
            BEGIN
                DimensionValue.SETRANGE("Dimension Code", FunctionQB.ReturnDimDpto);
                DimensionValue.SETFILTER(Code, TextFilterDpto);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                Window.UPDATE(1, DimensionValue.Code);
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
        //       FunctionQB@7207270 :
        FunctionQB: Codeunit 7207272;
        //       GLBudgetName@7207271 :
        GLBudgetName: Record 95;
        //       GLBudgetEntry@7207272 :
        GLBudgetEntry: Record 96;
        //       DimensionValue@7207273 :
        DimensionValue: Record 349;
        //       GeneralLedgerSetup@7207274 :
        GeneralLedgerSetup: Record 98;
        //       DimensionValues@7207275 :
        DimensionValues: Page 537;
        //       Text000@7207276 :
        Text000: TextConst ENU = 'You must specify the budget to update', ESP = 'Debe especificar el presupuesto a actualizar';
        //       Text001@7207277 :
        Text001: TextConst ENU = 'You can not specify as budget to update the configured budget for jobs', ESP = 'No puede especificar como presupuesto a actualizar el presupuesto configurado para proyectos';
        //       Text002@7207278 :
        Text002: TextConst ENU = 'You must only specify budgets to update', ESP = 'Solo debe especificar un presupuestos a actualizar';
        //       Text003@7207279 :
        Text003: TextConst ENU = 'You must specify a range of dates to copy', ESP = 'Debe especificar un rango de fechas a copiar';
        //       Window@7207280 :
        Window: Dialog;
        //       TextFilterDpto@7207281 :
        TextFilterDpto: Text[250];
        //       intCont@7207282 :
        intCont: Integer;



    trigger OnPreReport();
    begin
        if "G/L Budget Name".GETFILTER(Name) = '' then
            ERROR(Text000);

        if "G/L Budget Name".GETFILTER(Name) = FunctionQB.ReturnBudgetJobs then
            ERROR(Text001);

        if "G/L Budget Name".GETRANGEMIN(Name) <> "G/L Budget Name".GETRANGEMAX(Name) then
            ERROR(Text002);

        if "G/L Budget Entry".GETFILTER(Date) = '' then
            ERROR(Text003);

        Window.OPEN('Updating Ppto Dpto   #1#############\' +
                    'Destination budget   #2#############\' +
                    'Jobs                 #3#############\' +
                    'Dates                #4#############\' +
                    'Entry                #5#############\');
    end;



    /*begin
        end.
      */

}



// RequestFilterFields="Date";
