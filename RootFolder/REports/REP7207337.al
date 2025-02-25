report 7207337 "Job Rent Suggest"
{


    CaptionML = ENU = 'Job Rent Suggest', ESP = 'Proponer alquiler proyecto';

    dataset
    {

        DataItem("Element Contract Header"; "Element Contract Header")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.", "Date Filter";
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Rental Unit" = CONST(true));


                RequestFilterFields = "Piecework Code", "Filter Date";
                ;
                DataItemLink = "Job No." = FIELD("Job No."),
                            "Filter Date" = FIELD("Date Filter");
                trigger OnAfterGetRecord();
                BEGIN
                    "Data Piecework For Production".CALCFIELDS("Data Piecework For Production"."Number of Element");

                    ElementContractLines.INIT;
                    ElementContractLines."Document No." := "Element Contract Header"."No.";
                    CountLine := CountLine + 10000;
                    ElementContractLines."Line No." := CountLine;
                    ElementContractLines.INSERT(TRUE);
                    ElementContractLines.VALIDATE("No.", "Data Piecework For Production"."Element Of Rent");
                    ElementContractLines.VALIDATE("Location Code", Job."Job Location");
                    ElementContractLines.VALIDATE("Rent Price", "Data Piecework For Production"."Initial Produc. Price");
                    ElementContractLines.VALIDATE("Planned Delivery Quantity", "Data Piecework For Production"."Number of Element");
                    ElementContractLines.VALIDATE("Variant Code", "Data Piecework For Production"."Rental Variant");
                    ElementContractLines.MODIFY;
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN
                ElementContractLines.SETRANGE("Document No.", "Element Contract Header"."No.");
                IF ElementContractLines.FINDLAST THEN
                    CountLine := ElementContractLines."Line No."
                ELSE
                    CountLine := 0;
                Job.GET("Element Contract Header"."Job No.");
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
        //       ElementContractLines@7001100 :
        ElementContractLines: Record 7207354;
        //       CountLine@7001101 :
        CountLine: Integer;
        //       Job@7001102 :
        Job: Record 167;
        //       DataPieceworkForProduction@7001103 :
        DataPieceworkForProduction: Record 7207386;

    /*begin
    end.
  */

}



// RequestFilterFields="Piecework Code","Filter Date";
