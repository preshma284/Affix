page 7207047 "QB User List"
{
CaptionML=ENU='User Select',ESP='Seleccion del usuario';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=91;
    PageType=List;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("User ID";rec."User ID")
    {
        
                ToolTipML=ENU='Specifies the ID of the user who posted the entry, to be used, for example, in the change log.',ESP='Especifica el identificador del usuario que registr� el movimiento, que se usar�, por ejemplo, en el registro de cambios.';
                ApplicationArea=Basic,Suite;
    }

}

}
}
  
trigger OnOpenPage()    BEGIN
                 rec.HideExternalUsers;
               END;




    /*begin
    end.
  
*/
}







