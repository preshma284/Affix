page 7207295 "QB Job Customers List"
{
CaptionML=ENU='QB Job Customers',ESP='Clientes del proyecto';
    SourceTable=7207272;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Job no.";rec."Job no.")
    {
        
                Visible=false;
                Enabled=false;
                Editable=false ;
    }
    field("Customer No.";rec."Customer No.")
    {
        
    }
    field("Customer Name";rec."Customer Name")
    {
        
    }
    field("Percentaje";rec."Percentaje")
    {
        
    }

}
group("group16")
{
        
                CaptionML=ESP='Total';
    field("Total Percentaje";rec."Total Percentaje")
    {
        
                Style=Attention;
                StyleExpr=stTotal 

  ;
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       stTotal := (rec."Total Percentaje" <> 100);
                     END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       Rec.CALCFIELDS("Total Percentaje");
                       IF (rec."Total Percentaje" <> 100) THEN
                         ERROR(Txt001);
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           Rec.CALCFIELDS("Total Percentaje");
                           stTotal := (rec."Total Percentaje" <> 100);
                         END;



    var
      stTotal : Boolean;
      Txt001 : TextConst ESP='El porcentaje total no est n al 100%, no puede cerrar la p gina.';

    /*begin
    end.
  
*/
}







