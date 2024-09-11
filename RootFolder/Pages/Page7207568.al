page 7207568 "Vendor Evaluation List"
{
    Editable = false;
    CaptionML = ENU = 'Vendor Evaluation List', ESP = 'Lista Evaluaciones proveedor';
    SourceTable = 7207424;
    PageType = List;
    CardPageID = "Evaluation Header";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Validated"; rec."Validated")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Vendor No."; rec."Vendor No.")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Vendor Name"; rec."Vendor Name")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Description"; rec."Description")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Evaluation Date"; rec."Evaluation Date")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Evaluation Score"; rec."Evaluation Score")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Evaluation Clasification"; rec."Evaluation Clasification")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Average Evaluation Score"; rec."Average Evaluation Score")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Average Clasification"; rec."Average Clasification")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("User ID."; rec."User ID.")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Comment"; rec."Comment")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("No. Series"; rec."No. Series")
                {

                    Visible = false;
                    Style = Strong;
                    StyleExpr = bValidated

  ;
                }

            }

        }
    }

    trigger OnAfterGetRecord()
    BEGIN
        bValidated := rec.Validated;
    END;



    var
        bValidated: Boolean;/*

    begin
    {
      JAV 26/11/19: - Se eliminan los campos "Posting Date" y "Posting No. Series"
    }
    end.*/


}







