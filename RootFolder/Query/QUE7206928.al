query 50112 "QB BI Expedientes"
{


    elements
    {

        DataItem("Records"; "Records")
        {

            Column("No"; "No.")
            {

            }
            Column("Description"; "Description")
            {

            }
            Column("SearchDescription"; "Search Description")
            {

            }
            Column("Description2"; "Description 2")
            {

            }
            Column("Comment"; "Comment")
            {

            }
            Column("Blocked"; "Blocked")
            {

            }
            Column("LastModifiedDate"; "Last Modified Date")
            {

            }
            Column("SeriesNo"; "Series No.")
            {

            }
            Column("JobNo"; "Job No.")
            {

            }
            Column("SaleType"; "Sale Type")
            {

            }
            Column("RecordType"; "Record Type")
            {

            }
            Column("RecordStatus"; "Record Status")
            {

            }
            Column("JobDescription"; "Job Description")
            {

            }
            Column("CustomerNo"; "Customer No.")
            {

            }
            Column("EntryRecordDate"; "Entry Record Date")
            {

            }
            Column("ShipmentToCentralDate"; "Shipment To Central Date")
            {

            }
            Column("InitialProcedureDate"; "Initial Procedure Date")
            {

            }
            Column("EstimatedAmount"; "Estimated Amount")
            {

            }
            Column("PieceworkNo"; "Piecework No.")
            {

            }
            Column("Finished"; "Finished")
            {

            }
            Column("FinishRecordDate"; "Finish Record Date")
            {

            }
            Column("LaunchDate"; "Launch Date")
            {

            }
            Column("TechnicalApprovalDate"; "Technical Approval Date")
            {

            }
            Column("DefinitiveApprovalDate"; "Definitive Approval Date")
            {

            }
            DataItem("Data_Piecework_For_Production"; "Data Piecework For Production")
            {

                DataItemTableFilter = "Customer Certification Unit" = CONST(true),
                                   "Account Type" = CONST("Unit");
                DataItemLink = "Job No." = "Records"."Job No.",
                            "No. Record" = "Records"."No.";
                Column("SaleAmount"; "Sale Amount")
                {

                    //MethodType=Totals;
                    Method = Sum;
                }
            }
        }
    }


    /*begin
    {
      CPA 01/02/2021: Q16262 - Incluir la columna PieceWork Code en la consulta 50081 WSName=QBI_Expedientes proveniente de "Data Piecework for Production"
    }
    end.
  */
}








