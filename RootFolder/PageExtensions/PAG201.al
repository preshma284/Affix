pageextension 50149 MyExtension201 extends 201//210
{
layout
{
addafter("Line Type")
{
    field("QB_EntryType";rec."Entry Type")
    {
        
                Editable=TRUE ;
}
} addafter("Job Task No.")
{
    field("QB_PieceworkCode";rec."Piecework Code")
    {
        
}
    field("QB_Chargeable";rec."Chargeable")
    {
        
}
} addafter("Time Sheet Date")
{
    field("Source Type";rec."Source Type")
    {
        
}
    field("Source Document Type";rec."Source Document Type")
    {
        
}
    field("Source No.";rec."Source No.")
    {
        
}
    field("Source Name";rec."Source Name")
    {
        
}
    field("Provision";rec."Provision")
    {
        
}
    field("Unprovision";rec."Unprovision")
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
      JobJnlManagement : Codeunit 1020;
      ReportPrint : Codeunit 228;
      ClientTypeManagement : Codeunit 50192; //changed from 4
      JobJnlReconcile : Page 376;
      JobDescription : Text[50];
      AccName : Text[50];
      CurrentJnlBatchName : Code[10];
      ShortcutDimCode : ARRAY [8] OF Code[20];
      IsSaasExcelAddinEnabled : Boolean;

    
    

//procedure
//Local procedure CurrentJnlBatchNameOnAfterVali();
//    begin
//      CurrPage.SAVERECORD;
//      JobJnlManagement.SetName(CurrentJnlBatchName,Rec);
//      CurrPage.UPDATE(FALSE);
//    end;
//
//    [Integration]
//Local procedure OnBeforeOpenPage(var JobJournalLine : Record 210;var CurrentJnlBatchName : Code[10]);
//    begin
//    end;

//procedure
}

