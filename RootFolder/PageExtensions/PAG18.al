pageextension 50145 MyExtension18 extends 18//15
{
layout
{
addafter("Default Deferral Template Code")
{
    field("QuoSII Payment Cash";rec."QuoSII Payment Cash")
    {
        
                Visible=vQuoSII ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 vQuoSII := FunctionQB.AccessToQuoSII;
               END;


//trigger

var
      Emphasize : Boolean ;
      NameIndent : Integer ;
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    

//procedure
//procedure SetSelection(var GLAcc : Record 15);
//    begin
//      CurrPage.SETSELECTIONFILTER(GLAcc);
//    end;
//
//    //[External]
//procedure GetSelectionFilter() : Text;
//    var
//      GLAcc : Record 15;
//      SelectionFilterManagement : Codeunit 46;
//    begin
//      CurrPage.SETSELECTIONFILTER(GLAcc);
//      exit(SelectionFilterManagement.GetSelectionFilterForGLAccount(GLAcc));
//    end;
//Local procedure FormatLine();
//    begin
//      NameIndent := rec."Indentation";
//      Emphasize := rec."Account Type" <> rec."Account Type"::Posting;
//    end;

//procedure
}

