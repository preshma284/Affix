page 7207024 "QB Activable Expenses Setup"
{
  ApplicationArea=All;

CaptionML=ENU='Activable Expenses Setup',ESP='Conf. Activaci¢n de Gastos';
    SourceTable=7206997;
    
  layout
{
area(content)
{
group("group38")
{
        
                CaptionML=ESP='General';
group("group39")
{
        
                CaptionML=ESP='Uso';
    field("Activable QPR";rec."Activable QPR")
    {
        
    }
    field("Activable RE";rec."Activable RE")
    {
        
                ToolTipML=ESP='N§ de serie que se usar  para numerar los registros de Gastos Activables';
                TableRelation="No. Series" ;
    }

}
group("group42")
{
        
                CaptionML=ESP='Datos generales';
    field("Activable First Date";rec."Activable First Date")
    {
        
    }
    field("Activable Detailed";rec."Activable Detailed")
    {
        
    }
    field("Serie for Activables Expenses";rec."Serie for Activables Expenses")
    {
        
                ToolTipML=ESP='Forma del numerador para el registro de documento de Gastos activables, puede usar %1 para el periodo';
    }

}
group("group46")
{
        
                CaptionML=ESP='Diario de registro';
    field("Journal Template";rec."Journal Template")
    {
        
    }
    field("Journal Batch";rec."Journal Batch")
    {
        
    }

}

}

}
}
  




trigger OnOpenPage()    BEGIN
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;
               END;


/*

    begin
    {
      JAV 14/11/22: - QB 1.12.00 Nueva page para la configuraci¢n de las activaciones, ajustada a los cambios £ltimos
    }
    end.*/
  

}








