report 7207328 "Generate Opportunity"
{


    CaptionML = ENU = 'Generate Opportunity', ESP = 'Generate Opportunity';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");

            ;
            trigger OnPreDataItem();
            BEGIN
                IF Date = 0D THEN
                    ERROR(Text000);

                IF CCycle = '' THEN
                    ERROR(Text001);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                Opportunity.INIT;
                Opportunity.INSERT(TRUE);

                Opportunity."Quote No." := Job."No.";

                ContactBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SETRANGE("No.", Job."Bill-to Customer No.");

                IF NOT ContactBusinessRelation.FINDFIRST THEN
                    ERROR(Text002, Job."Bill-to Customer No.");

                Opportunity.VALIDATE("Contact No.", ContactBusinessRelation."Contact No.");
                Opportunity.VALIDATE("Creation Date", Date);
                Opportunity.VALIDATE("Sales Cycle Code", CCycle);
                Opportunity.VALIDATE("Salesperson Code", Job."Income Statement Responsible");
                Opportunity.Description := Job.Description;
                Opportunity.MODIFY;

                Job."Opportunity Code" := Opportunity."No.";
                Job.MODIFY;
            END;

            trigger OnPostDataItem();
            BEGIN
                MESSAGE(Text003, Opportunity."No.");
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group519")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("Date"; "Date")
                    {

                        CaptionML = ENU = 'Ending Date', ESP = 'Fecha creaci¢n';
                        // OptionCaptionML=ENU='Ending Date',ESP='Fecha creaci¢n';
                        ApplicationArea = Basic, Suite;
                    }
                    field("CCycle"; "CCycle")
                    {

                        CaptionML = ESP = 'Ciclo de Ventas';
                        TableRelation = "Sales Cycle"

    ;
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Date@7001100 :
        Date: Date;
        //       Text000@7001101 :
        Text000: TextConst ENU = 'Date created can not be empty.', ESP = 'Fecha de creaci¢n no puede estar vac¡a';
        //       Text001@7001102 :
        Text001: TextConst ENU = 'Sales cycle can not be empty', ESP = 'Ciclo de ventas no puede estar vac¡o';
        //       Opportunity@7001103 :
        Opportunity: Record 5092;
        //       ContactBusinessRelation@7001104 :
        ContactBusinessRelation: Record 5054;
        //       Text002@7001105 :
        Text002: TextConst ENU = 'There is no contact associated with the client %1.', ESP = 'No hay contacto asociado al cliente %1.';
        //       CCycle@7001106 :
        CCycle: Code[10];
        //       Text003@7001107 :
        Text003: TextConst ENU = 'Opportunity %1 has been created.', ESP = 'Se ha creado la oportunidad %1.';
        //       FechaCreacion@7001108 :
        FechaCreacion: Date;
        //       SalesCycleAnalysisCaptionLbl@7001109 :
        SalesCycleAnalysisCaptionLbl: TextConst ENU = 'Sales Cycle - Analysis', ESP = 'Ciclo ventas - An lisis';
        //       SalesCycleFilter@7001110 :
        SalesCycleFilter: Text;

    /*begin
    end.
  */

}



