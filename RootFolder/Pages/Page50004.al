page 50004 "QuoSync See XML"
{
CaptionML=ENU='Company Sync See XML',ESP='Sincronizar Empresas: Ver XML';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    PageType=Card;
    
  layout
{
area(content)
{
group("group12")
{
        
    field("txtXML";txtXML)
    {
        
                CaptionML=ESP='XML';
                MultiLine=true 

  ;
    }

}

}
}
  trigger OnAfterGetRecord()    VAR
                       TempIntegrationFieldMapping : Record 5337;
                     BEGIN
                     END;



    var
      txtXML : Text;
      TempBlob : Codeunit "Temp Blob";

    procedure SetXML(pXML : Text);
    begin
      txtXML := pXML;
    end;

    // begin//end
}








