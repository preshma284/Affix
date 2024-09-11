// value(0; "G/L Account") { }
//     value(1; "Customer") { }
//     value(2; "Vendor") { }
//     value(3; "Item") { }
//     value(4; "Resource") { }
//     value(5; "Job") { }
//     value(7; "Resource Group") { }
//     value(8; "Bank Account") { }
//     value(9; "Campaign") { }
//     value(10; "Fixed Asset") { }
//     value(11; "Insurance") { }
//     value(12; "Nonstock Item") { }
//     value(13; "IC Partner") { }
//     value(23; "Vendor Agreement") { }
//     value(24; "Customer Agreement") { }

//OptionString=G/L Account,Customer,Vendor,Item,Resource,Job,,Resource Group,
// Bank Account,Campaign,Fixed Asset,Insurance,Nonstock Item,
// IC Partner,,,,,,,,,,Historic G/L Account,New G/L Account,Piecework,Job Cost Piecework,Vendor Evaluation,Elements }

enumextension 50102 "CommentLineTableNameEnum" extends "Comment Line Table Name"
{
    value(100; "Historic G/L Account")
    {
        Caption = 'Historic G/L Account';

    }
    value(101; "New G/L Account")
    {
        Caption = 'New G/L Account';

    }

    value(102; "Piecework")
    {
        Caption = 'Piecework';

    }

    value(103; "Job Cost Piecework")
    {
        Caption = 'Job Cost Piecework';

    }

    value(104; "Vendor Evaluation")
    {
        Caption = 'Vendor Evaluation';

    }

    value(105; "Elements")
    {
        Caption = 'Elements';

    }
}