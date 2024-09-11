page 7207038 "QB Job Responsibles Templ.Pos."
{
CaptionML=ENU='Responsibles Templates Setup',ESP='Configuraci¢n de Responsables';
    SourceTable=7206991;
    PageType=ListPart;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
    }
    field("Use in";rec."Use in")
    {
        
    }
    field("Position";rec."Position")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("The User";rec."The User")
    {
        
    }
    field("User ID";rec."User ID")
    {
        
    }
    field("Name";rec."Name")
    {
        
    }

}

}
}
  
trigger OnOpenPage()    BEGIN
                 UserSetup.GET(USERID);
                 isUsuarioAprobacion := UserSetup."Approval Administrator";
                 SetEditable;
               END;

trigger OnAfterGetRecord()    BEGIN
                       SetEditable;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           SetEditable;
                         END;



    var
      UserSetup : Record 91;
      QuoBuildingSetup : Record 7207278;
      edUser : Boolean ;
      Mode: Option "Jobs","Departments";
      isUsuarioAprobacion : Boolean;
      Process : Boolean;

    LOCAL procedure SetEditable();
    begin
      QuoBuildingSetup.GET;
      edUser := (rec."The User" = rec."The User"::"is fixed");
    end;

    // begin//end
}







