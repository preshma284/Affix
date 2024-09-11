page 7206960 "QB Generic Import - Tables Stp"
{
CaptionML=ENU='QB Generic Import - Tables Setup',ESP='QB Importaci�n gen�rica - Conf. Tablas';
    SourceTable=7206941;
    SourceTableView=SORTING("Order");
    PageType=List;
    
  layout
{
area(content)
{
repeater("General")
{
        
    field("Field No.";rec."Field No.")
    {
        
    }
    field("Field Name";rec."Field Name")
    {
        
    }
    field("Order";rec."Order")
    {
        
    }
    field("Excel Column";rec."Excel Column")
    {
        
                Visible=vExcel or vCSV ;
    }
    field("Excel Column No";rec."Excel Column No")
    {
        
                Visible=false;
                Editable=false ;
    }
    field("Ini Postition";rec."Ini Postition")
    {
        
                Visible=vText ;
    }
    field("Long";rec."Long")
    {
        
                Visible=vText ;
    }
    field("End Position";rec."End Position")
    {
        
                Visible=vText ;
    }
    field("Format";rec."Format")
    {
        
                ToolTipML=ESP='Para Texto: ,Ic,Dc Para Fechas: DDsMMsAA o DDsMMsAAAA Para decimales: , N, -pgN o N-pg Para Booleanos:  o sn';
                Visible=vForm ;
    }
    field("Autoincrement By";rec."Autoincrement By")
    {
        
    }
    field("Default Value";rec."Default Value")
    {
        
    }
    field("Replacement Code";rec."Replacement Code")
    {
        
    }
    field("Group";rec."Group")
    {
        
    }
    field("Apply Summation";rec."Apply Summation")
    {
        
    }
    field("Export Filter";rec."Export Filter")
    {
        
    }

}

}
area(FactBoxes)
{
    systempart(MyNotes;MyNotes)
    {
        ;
    }
    systempart(Links;Links)
    {
        ;
    }

}
}
  trigger OnAfterGetRecord()    BEGIN
                       QBGenericImportHeader.GET(rec."Setup Code");
                       vExcel := (QBGenericImportHeader.Type = QBGenericImportHeader.Type::Excel);
                       vText  := (QBGenericImportHeader.Type = QBGenericImportHeader.Type::Text);
                       vCSV   := (QBGenericImportHeader.Type = QBGenericImportHeader.Type::CSV);
                       vForm  := (vText OR vCSV);
                     END;



    var
      QBGenericImportHeader : Record 7206940;
      vExcel : Boolean;
      vText : Boolean;
      vCSV : Boolean;
      vForm : Boolean;

    /*begin
    end.
  
*/
}








