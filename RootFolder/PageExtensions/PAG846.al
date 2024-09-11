pageextension 50281 MyExtension846 extends 846//843
{
    layout
    {
        addafter("Azure AI") //change from cortana intelligence
        {
            group("Control1100286001")
            {

                CaptionML = ENU = 'QuoBuilding', ESP = 'QuoBuilding';
                field("WorkShoop CF Account No."; rec."WorkShoop CF Account No.")
                {

                }
                field("Paysheet CF Account No."; rec."Paysheet CF Account No.")
                {

                }
            }
        }

    }

    actions
    {


    }

    //trigger

    //trigger

    var
        CortanaIntelligenceUsage: Record "Azure AI Usage"; //changed from cortana intelligence 2003
        TaxAccountTypeValid: Boolean;



    //procedure

    //procedure
}

