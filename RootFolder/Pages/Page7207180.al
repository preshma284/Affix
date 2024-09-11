page 7207180 "QB BI Acc. Schedule"
{
Editable=false;
    CaptionML=ENU='QB BI Acc. Schedule',ESP='QB BI Esquema de cuenta';
    SourceTable=85;
    PageType=Worksheet;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Schedule Name";rec."Schedule Name")
    {
        
    }
    field("Line No.";rec."Line No.")
    {
        
    }
    field("Row No.";rec."Row No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Totaling";rec."Totaling")
    {
        
    }
    field("Totaling Type";rec."Totaling Type")
    {
        
    }
    field("New Page";rec."New Page")
    {
        
    }
    field("Date Filter";rec."Date Filter")
    {
        
    }
    field("Dimension 1 Filter";rec."Dimension 1 Filter")
    {
        
    }
    field("Dimension 2 Filter";rec."Dimension 2 Filter")
    {
        
    }
    field("G/L Budget Filter";rec."G/L Budget Filter")
    {
        
    }
    field("Business Unit Filter";rec."Business Unit Filter")
    {
        
    }
    field("Show";rec."Show")
    {
        
    }
    field("Dimension 3 Filter";rec."Dimension 3 Filter")
    {
        
    }
    field("Dimension 4 Filter";rec."Dimension 4 Filter")
    {
        
    }
    field("Dimension 1 Totaling";rec."Dimension 1 Totaling")
    {
        
    }
    field("Dimension 2 Totaling";rec."Dimension 2 Totaling")
    {
        
    }
    field("Dimension 3 Totaling";rec."Dimension 3 Totaling")
    {
        
    }
    field("Dimension 4 Totaling";rec."Dimension 4 Totaling")
    {
        
    }
    field("Bold";rec."Bold")
    {
        
    }
    field("Italic";rec."Italic")
    {
        
    }
    field("Underline";rec."Underline")
    {
        
    }
    field("Show Opposite Sign";rec."Show Opposite Sign")
    {
        
    }
    field("Row Type";rec."Row Type")
    {
        
    }
    field("Amount Type";rec."Amount Type")
    {
        
    }
    field("Double Underline";rec."Double Underline")
    {
        
    }
    //field present in spanish base 
    // field("Type";rec."Type")
    // {
        
    // }
    field("Indentation";rec."Indentation")
    {
        
    }
    field("Positive Only";rec."Positive Only")
    {
        
    }
    field("Reverse Sign";rec."Reverse Sign")
    {
        
    }

}

}
}
  
trigger OnAfterGetRecord()    BEGIN
                       Rec.CALCFIELDS("Date Filter","Dimension 1 Filter","Dimension 2 Filter","G/L Budget Filter","Business Unit Filter","Dimension 3 Filter","Dimension 4 Filter");
                     END;


/*

    begin
    {
      QMD 14/06/22: - (17516) Nueva p�gina 7207108 para los esquemas de cuentas en el BI
      JAV 30/06/22: - QB 1.10.57 Se cambia el n�mero a 7207180 que es el rango adecuado, y se a�ade en la versi�n el nombre del Web Service asociado
    }
    end.*/
  

}







