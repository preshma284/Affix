pageextension 50143 MyExtension17 extends 17//15
{
layout
{
addafter("Omit Default Descr. in Jnl.")
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
      SubCategoryDescription : Text[80];
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    
    

//procedure
//Local procedure UpdateAccountSubcategoryDescription();
//    begin
//      Rec.CALCFIELDS("Account Subcategory Descript.");
//      SubCategoryDescription := rec."Account Subcategory Descript.";
//    end;

//procedure
}

