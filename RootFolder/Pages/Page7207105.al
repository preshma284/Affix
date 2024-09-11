page 7207105 "QPR Budget Data Amounts"
{
SourceTable=7207383;
    SourceTableView=SORTING("Job No.","Budget Code","Piecework code","Type","Expected Date");
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Budget Code";rec."Budget Code")
    {
        
    }
    field("Piecework code";rec."Piecework code")
    {
        
    }
    field("Type";rec."Type")
    {
        
    }
    field("Cost Amount";rec."Cost Amount")
    {
        
                Visible=IsCost ;
    }
    field("Sale Amount";rec."Sale Amount")
    {
        
                Visible=NOT IsCost ;
    }
    field("Expected Date";rec."Expected Date")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IsCost := Rec.Type = Rec.Type::Cost;
                     END;



    var
      IsCost : Boolean;

    /*begin
    end.
  
*/
}







