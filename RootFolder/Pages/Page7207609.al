page 7207609 "Job Reception Header"
{
    CaptionML = ENU = 'Job Reception Header', ESP = 'Cab. recepci�n proyecto';
    SourceTable = 7207410;
    PopulateAllFields = true;
    SourceTableView = SORTING("Job No.", "Posted")
                    WHERE("Posted" = FILTER(false));
    PageType = Document;
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Vendor No."; rec."Vendor No.")
                {

                }
                field("Vendor Name"; rec."Vendor Name")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Vendor Shipment No."; rec."Vendor Shipment No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }

            }
            part("WhseReceiptLines"; 7207610)
            {

                SubPageView = SORTING("Recept. Document No.", "Line No.");
                SubPageLink = "Recept. Document No." = FIELD("No.");
            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = 'F&unctions', ESP = 'Acci&ones';
                action("action1")
                {
                    ShortCutKey = 'Ctrl+F7';
                    Ellipsis = true;
                    CaptionML = ENU = 'Get Source Documents', ESP = 'Traer doc. origen';
                    Image = CopyToTask;

                    trigger OnAction()
                    VAR
                        GetOrdersJob: Codeunit 7207337;
                    BEGIN
                        GetOrdersJob.GetOrdersJob(Rec);
                    END;


                }
                separator("separator2")
                {

                }
                group("group5")
                {
                    CaptionML = ENU = 'P&osting', ESP = '&Registro';
                    action("action3")
                    {
                        ShortCutKey = 'F9';
                        CaptionML = ENU = 'P&ost Receipt', ESP = '&Registrar recep.';
                        Image = Post;


                        trigger OnAction()
                        BEGIN
                            WhsePostRcptYesNo;
                        END;


                    }

                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
            }
        }
    }


    procedure WhsePostRcptYesNo();
    var
        LineReceptionJob: Record 7207411;
        RecpPrPostReceiptYesNo: Codeunit 7207338;
    begin
        LineReceptionJob.SETRANGE("Recept. Document No.", rec."No.");
        if LineReceptionJob.FINDFIRST then begin
            RecpPrPostReceiptYesNo.RUN(LineReceptionJob);
            CurrPage.UPDATE(FALSE);
        end;
    end;

    // begin//end
}







