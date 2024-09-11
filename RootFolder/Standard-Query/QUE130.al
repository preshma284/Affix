query 50181 "PostedDocs.With No Inc. Doc. 1"
{


    CaptionML = ENU = 'Posted Docs. With No Inc. Doc.', ESP = 'Doc. registrados sin doc. ent.';

    elements
    {

        DataItem("G_L_Entry"; "G/L Entry")
        {

            Filter(GLAccount; "G/L Account No.")
            {

            }
            Column(PostingDate; "Posting Date")
            {

            }
            Column(DocumentNo; "Document No.")
            {

            }
            Column(ExternalDocumentNo; "External Document No.")
            {

            }
            Column(DebitAmount; "Debit Amount")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column(CreditAmount; "Credit Amount")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column(NoOfEntries)
            {
                //MethodType=Totals;
                Method = Count;
            }
            DataItem("Incoming_Document"; "Incoming Document")
            {

                DataItemLink = "Document No." = "G_L_Entry"."Document No.",
                            "Posting Date" = "G_L_Entry"."Posting Date";
                Column(NoOfIncomingDocuments)
                {
                    ColumnFilter = NoOfIncomingDocuments = CONST(0);
                    //MethodType=Totals;
                    Method = Count;
                }
            }
        }
    }


    /*begin
    end.
  */
}




