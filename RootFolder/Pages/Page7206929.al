page 7206929 "QB Text Card"
{
SourceTable=7206918;
    
  layout
{
area(content)
{
group("Group")
{
        
                CaptionML=ESP='Texto';
    field("Table";rec."Table")
    {
        
                Visible=false ;
    }
    field("Key1";rec."Key1")
    {
        
                Visible=false ;
    }
    field("Key2";rec."Key2")
    {
        
                Visible=false ;
    }
    field("Key3";rec."Key3")
    {
        
                Visible=FALSE ;
    }

}
group("group61")
{
        
                CaptionML=ESP='Textos';
group("group62")
{
        
                CaptionML=ESP='Texto para Coste';
                Visible=seeCost;
    field("CText";"CText")
    {
        
                ToolTipML=ESP='Si deja en blanco el texto para venta, se usar� el de coste para la misma';
                MultiLine=true;
                
                            ;trigger OnValidate()    BEGIN
                             rec.SetCostText(CText);
                             CurrPage.UPDATE;
                           END;


    }
    field("Cost Size";rec."Cost Size")
    {
        
    }

}
group("group65")
{
        
                CaptionML=ESP='Texto para Venta';
                Visible=seeSales;
    field("VText";"VText")
    {
        
                MultiLine=true;
                
                            ;trigger OnValidate()    BEGIN
                             rec.SetSalesText(VText);
                             CurrPage.UPDATE;
                           END;


    }
    field("Sales Size";rec."Sales Size")
    {
        
    }

}

}

}
}
  

trigger OnOpenPage()    BEGIN
                 IF NOT QBText.GET(rec.Table, rec.Key1, rec.Key2, rec.Key3) THEN
                   Rec.INSERT;
               END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF (rec."Cost Size" + rec."Sales Size" = 0) THEN
                         Rec.DELETE;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           CText := rec.GetCostText();
                           VText := rec.GetSalesText();
                           seeCost := rec.IsCost(rec.Table);
                           seeSales := rec.IsSales(rec.Table);
                         END;



    var
      CText : Text;
      VText : Text;
      Text01 : TextConst ESP='Si deja en blanco el texto para venta, se usar� el de coste para la misma';
      QBText : Record 7206918;
      seeCost : Boolean;
      seeSales : Boolean;

    /*begin
    end.
  
*/
}








