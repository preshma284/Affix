page 7206959 "QB Generic Import - Tables"
{
  ApplicationArea=All;

CaptionML=ENU='QB Generic Import - Tables',ESP='QB Importaci�n gen�rica - Tablas';
    SourceTable=7206940;
    PageType=List;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Setup Code";rec."Setup Code")
    {
        
    }
    field("Table ID";rec."Table ID")
    {
        
    }
    field("Table Name";rec."Table Name")
    {
        
    }
    field("Type";rec."Type")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             SetEditable;
                           END;


    }
    field("Group";rec."Group")
    {
        
    }
    field("Skip from Begginnig";rec."Skip from Begginnig")
    {
        
    }
    field("Skip form End";rec."Skip form End")
    {
        
    }
    field("Sep";rec."Sep")
    {
        
                Enabled=enCSV ;
    }
    field("Del";rec."Del")
    {
        
                Enabled=enCSV ;
    }
    field("File Name";rec."File Name")
    {
        
    }
    field("Sheet Name";rec."Sheet Name")
    {
        
    }

}
    systempart(MyNotes;MyNotes)
    {
        ;
    }

}
area(FactBoxes)
{
    systempart(Links;Links)
    {
        ;
    }

}
}actions
{
area(Creation)
{
//Name=General;
    action("Setup")
    {
        
                      CaptionML=ENU='Setup',ESP='Configurar';
                      Image=Setup;
                      
                                
    trigger OnAction()    VAR
                                 QBGenericImportHeader : Record 7206940;
                                 QBGenericImportLine : Record 7206941;
                                 QBGenericImportTablesStp : Page 7206960;
                               BEGIN
                                 QBGenericImportHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(QBGenericImportHeader);
                                 QBGenericImportLine.RESET;
                                 QBGenericImportLine.SETRANGE("Setup Code",QBGenericImportHeader."Setup Code");
                                 QBGenericImportLine.SETRANGE("Table ID",QBGenericImportHeader."Table ID");
                                 //IF QBGenericImportLine.FINDSET THEN BEGIN
                                 QBGenericImportTablesStp.SETTABLEVIEW(QBGenericImportLine);
                                 QBGenericImportTablesStp.RUNMODAL;
                                 //END;
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Setup_Promoted; Setup)
                {
                }
            }
        }
}
  trigger OnAfterGetRecord()    BEGIN
                       SetEditable;
                     END;



    var
      enCSV : Boolean;

    LOCAL procedure SetEditable();
    begin
      enCSV := rec.Type = rec.Type::CSV;
    end;

    // begin//end
}









