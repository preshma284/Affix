pageextension 50178 MyExtension371 extends 371//270
{
layout
{
addafter("Search Name")
{
    field("Balance";rec."Balance")
    {
        
                Visible=seeBalance ;
}
    field("Balance (LCY)";rec."Balance (LCY)")
    {
        
                Visible=seeBalance ;
}
    field("Net Change";rec."Net Change")
    {
        
                Visible=seeBalance ;
}
}

}

actions
{
addafter("UpdateBankAccountLinking")
{
    action("QB_CreditPolicies")
    {
        CaptionML=ENU='Credit policies',ESP='Polizas de cr‚dito';
                      RunObject=Page 7207306;
                      RunPageView=SORTING("No.");
RunPageLink="No."=field("No.");
                      Promoted=true;
                      Image=ViewPage;
                      PromotedCategory=Process;
}
}

}

//trigger
trigger OnOpenPage()    BEGIN
                 ShowBankLinkingActions := rec.StatementProvidersExist;

                 //JAV 16/06/21: - QB 1.08.48 Si puede ver el saldo en el diario
                 IF UserSetup.GET(USERID) THEN
                   seeBalance := UserSetup."See Balance"
                 ELSE
                   seeBalance := FALSE;
               END;


//trigger

var
      MultiselectNotSupportedErr : TextConst ENU='You can only link to one online bank account at a time.',ESP='Solo puede vincular a un banco en l¡nea a la vez.';
      Linked : Boolean;
      ShowBankLinkingActions : Boolean;
      OnlineFeedStatementStatus: Option "not Linked","Linked","Linked and Auto. Bank Statement Enabled";
      "------------------------------------ QB" : Integer;
      UserSetup : Record 91;
      seeBalance : Boolean;

    
    

//procedure
//Local procedure VerifySingleSelection();
//    var
//      BankAccount : Record 270;
//    begin
//      CurrPage.SETSELECTIONFILTER(BankAccount);
//
//      if ( BankAccount.COUNT > 1  )then
//        ERROR(MultiselectNotSupportedErr);
//    end;

//procedure
}

