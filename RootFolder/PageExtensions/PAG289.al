pageextension 50168 MyExtension289 extends 289//210
{
layout
{
addafter("Job No.")
{
    field("QB_PieceworkCode";rec."Piecework Code")
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
      JobJnlReconcile : Page 376;
      JobDescription : Text[50];
      AccName : Text[50];
      CurrentJnlBatchName : Code[10];
      ShortcutDimCode : ARRAY [8] OF Code[20];

    
    

//procedure
//Local procedure CurrentJnlBatchNameOnAfterVali();
//    begin
//      CurrPage.SAVERECORD;
//      JobJnlManagement.SetName(CurrentJnlBatchName,Rec);
//      CurrPage.UPDATE(FALSE);
//    end;

//procedure
}

