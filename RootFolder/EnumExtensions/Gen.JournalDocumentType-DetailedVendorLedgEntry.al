enumextension 50101 "Gen.JournalDocumentTypeEnum" extends "Gen. Journal Document Type"
{
    //[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,Shipment,WIP,,,,,,,,,,Bill] 

    value(100; "Shipment")
    {
        Caption = 'Shipment';
    }
    value(101; "WIP")
    {
        Caption = 'WIP';
    }
    // value(102; "Bill")
    // {
    //     Caption = 'Bill';
    // }
}