page 7174661 "Library Types Values"
{
CaptionML=ENU='Library Types Values',ESP='Seleccione etiqueta';
    SourceTable=7174655;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Name";rec."Name")
    {
        
                CaptionML=ENU='Metadata Name',ESP='Nombre Etiqueta';
                Editable=FALSE;
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Value";rec."Value")
    {
        
                Style=Favorable;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
    }
    field("Last Date Modified";rec."Last Date Modified")
    {
        
                Visible=false 

  ;
    }

}

}
}
  

    procedure SetSelection(var LibraryTypesValuesSP : Record 7174655);
    begin
      CurrPage.SETSELECTIONFILTER(LibraryTypesValuesSP);
    end;

    procedure GetSelectionFilter() : Text;
    var
      LibraryTypesValuesSP : Record 7174655;
      DropAreaManagement : Codeunit 7174650;
    begin
      CurrPage.SETSELECTIONFILTER(LibraryTypesValuesSP);
      exit(DropAreaManagement.GetSelectionFilterForTypeValuesSP(LibraryTypesValuesSP));
    end;

    // begin//end
}








