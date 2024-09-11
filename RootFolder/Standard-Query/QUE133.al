query 50182 "Inc.Doc.Atts. Ready for OCR 1"
{


    CaptionML = ENU = 'Inc. Doc. Atts. Ready for OCR', ESP = 'Doc. ent. adjuntos listos para OCR';

    elements
    {

        DataItem("Incoming_Document"; "Incoming Document")
        {

            DataItemTableFilter = "OCR Status" = CONST("Ready");
            DataItem("Incoming_Document_Attachment"; "Incoming Document Attachment")
            {

                DataItemTableFilter = "Use for OCR" = CONST(true);
                DataItemLink = "Incoming Document Entry No." = "Incoming_Document"."Entry No.";
                SqlJoinType = InnerJoin;
                //DataItemLinkType=Exclude Row If No Match;
                Column("Incoming_Document_Entry_No"; "Incoming Document Entry No.")
                {

                }
                Column("Line_No"; "Line No.")
                {

                }
            }
        }
    }


    /*begin
    end.
  */
}




