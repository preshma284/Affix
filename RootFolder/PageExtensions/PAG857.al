pageextension 50283 MyExtension857 extends 857//849
{
layout
{
addafter("Global Dimension 2 Code")
{
    field("Job No.";rec."Job No.")
    {
        
}
    field("Bank Account No.";rec."Bank Account No.")
    {
        
}
}

}

actions
{


}

//trigger

//trigger

var
      CashFlowManagement : Codeunit 841;
      Recurrence: Option " ","Daily","Weekly","Monthly","Quarterly","Yearly";
      EndingDateEnabled : Boolean;

    
    

//procedure
//Local procedure GetRecord();
//    begin
//      EnableControls;
//      CashFlowManagement.RecurringFrequencyToRecurrence(rec."Recurring Frequency",Recurrence);
//    end;
//Local procedure EnableControls();
//    begin
//      EndingDateEnabled := (Recurrence <> Recurrence::" ");
//      if ( not EndingDateEnabled  )then
//        rec."Ending Date" := 0D;
//    end;

//procedure
}

