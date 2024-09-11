page 7207557 "Purchase Contract Card"
{
    CaptionML = ENU = 'Purchase Contract Card', ESP = 'Ficha de datos del contrato';
    SourceTable = 7207391;

    layout
    {
        area(content)
        {
            group("group15")
            {

                CaptionML = ENU = 'Contrat', ESP = 'General';
                field("Contract No."; rec."Contract No.")
                {

                    Editable = false;
                }
                field("Job No."; rec."Job No.")
                {

                    Editable = false;
                }
                field("Job Name"; rec."Job Name")
                {

                }

            }
            group("group19")
            {

                CaptionML = ESP = 'Contrato';
                field("Work Objetive of the Contract"; rec."Work Objetive of the Contract")
                {

                }
                field("Work Work Type"; rec."Work Work Type")
                {

                }
                field("Work Start Date"; rec."Work Start Date")
                {

                }
                field("Work End Date"; rec."Work End Date")
                {

                }
                field("Work Duration"; rec."Work Duration")
                {

                }
                field("Work Import Contract"; rec."Work Import Contract")
                {

                }
                field("Work Import Material Transport"; rec."Work Import Material Transport")
                {

                }
                field("Work Secure Amount"; rec."Work Secure Amount")
                {

                }
                field("Work Minimum Period Contract"; rec."Work Minimum Period Contract")
                {

                }
                field("Work Payment Document Due"; rec."Work Payment Document Due")
                {

                }
                field("Work Testing Term"; rec."Work Testing Term")
                {

                }
                field("Work First Installment Penalty"; rec."Work First Installment Penalty")
                {

                }
                field("Work Second Installment Pen."; rec."Work Second Installment Pen.")
                {

                }
                field("Work % Of amount"; rec."Work % Of amount")
                {

                }
                field("Work % Withholding Aditional"; rec."Work % Withholding Aditional")
                {

                }
                field("Work Return Time"; rec."Work Return Time")
                {

                }
                field("Work Term Expiration Return"; rec."Work Term Expiration Return")
                {

                }
                field("Work Max Franchise"; rec."Work Max Franchise")
                {

                }
                field("Work Amt. Employer Liability"; rec."Work Amt. Employer Liability")
                {

                }
                field("Work Penalty for Breach"; rec."Work Penalty for Breach")
                {

                }
                field("Work Delay"; rec."Work Delay")
                {

                }
                field("Work Billing Milestones"; rec."Work Billing Milestones")
                {

                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        QuoBuildingSetup.GET;
        CompanyInformation.GET;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        IF NOT Vendor.GET(rec."Vendor No.") THEN
            Vendor.INIT;
    END;



    var
        ContractNo_: Code[20];
        QuoBuildingSetup: Record 7207278;
        CompanyInformation: Record 79;
        Vendor: Record 23;

    procedure SetContractNo(ContractNo: Code[20]);
    begin
        ContractNo_ := ContractNo;
        //Rec.GET(ContractNo_);
    end;

    // begin
    /*{

      Q12932 HAN 09/03/21 Added new fields for contract reports
    }*///end
}







