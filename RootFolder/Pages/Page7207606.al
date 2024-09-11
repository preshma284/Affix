page 7207606 "Activities for Subcontract"
{
    CaptionML = ENU = 'Activities for Subcontract', ESP = 'Actividades para subcontratar';
    SourceTable = 7207280;
    DataCaptionFields = "Job Filter";
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            group("group31")
            {

                repeater("Group")
                {

                    field("Activity Code"; rec."Activity Code")
                    {

                    }
                    field("Description"; rec."Description")
                    {

                    }
                    field("Cod. Resource Subcontracting"; rec."Cod. Resource Subcontracting")
                    {

                    }
                    field("getNro()"; getNro())
                    {

                        CaptionML = ESP = 'N� U.O. Subcontratados';
                    }

                }
                group("group37")
                {

                    part("PG_NotSubcontractUnits"; 7207607)
                    {

                        CaptionML = ESP = 'Unidades no Subcontratadas';
                        SubPageView = SORTING("Job No.", "Piecework Code");
                        SubPageLink = "Job No." = FIELD("Job Filter"), "Account Type" = CONST("Unit"), "Production Unit" = CONST(true), "Type" = CONST("Piecework"), "No. Subcontracting Resource" = FILTER('');
                        UpdatePropagation = Both;
                    }
                    part("PG_SubcontractUnits"; 7207607)
                    {

                        CaptionML = ESP = 'Unidades Subcontratadas de la Actividad Seleccionada';
                        SubPageView = SORTING("Job No.", "Piecework Code");
                        SubPageLink = "Job No." = FIELD("Job Filter"), "Activity Code" = FIELD("Activity Code"), "Account Type" = CONST("Unit"), "Production Unit" = CONST(true), "Type" = CONST("Piecework"), "No. Subcontracting Resource" = FILTER(<> '');
                        UpdatePropagation = Both

  ;
                    }

                }

            }

        }
    }

    trigger OnOpenPage()
    BEGIN
        CurrPage.PG_NotSubcontractUnits.PAGE.SetVer(FALSE);
        CurrPage.PG_SubcontractUnits.PAGE.SetVer(TRUE);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        //NrSub := getNro;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CurrPage.PG_NotSubcontractUnits.PAGE.PassData(rec."Activity Code", rec."Cod. Resource Subcontracting", CurrentBudgetCode);
        CurrPage.PG_SubcontractUnits.PAGE.PassData(rec."Activity Code", rec."Cod. Resource Subcontracting", CurrentBudgetCode);
    END;



    var
        CurrentBudgetCode: Code[20];
        JobCode: Code[20];
        DataPieceworkForProduction: Record 7207386;

    procedure PassCurrentBudgetCode(CurrentBudgetCodePass: Code[20]; JobCodePass: Code[20]);
    begin
        CurrentBudgetCode := CurrentBudgetCodePass;
        JobCode := JobCodePass;
    end;

    LOCAL procedure getNro(): Integer;
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", JobCode);
        DataPieceworkForProduction.SETRANGE("Activity Code", rec."Activity Code");
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
        DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::Piecework);
        DataPieceworkForProduction.SETFILTER("No. Subcontracting Resource", '<>%1', '');
        exit(DataPieceworkForProduction.COUNT);
    end;

    // begin
    /*{
      JAV 09/10/19: - Se ajusta la pantalla para que sea un poco mas operativa
      JAV 02/05/20: - Se mejora toda la pantalla en general, incluidas las sub-p�ginas
    }*///end
}







