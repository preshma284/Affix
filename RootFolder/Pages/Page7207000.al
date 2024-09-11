page 7207000 "QB Web Service Medition 2"
{
SourceTable=7206963;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Piecework No.";rec."Piecework No.")
    {
        
    }
    field("Code Piecework PRESTO";rec."Code Piecework PRESTO")
    {
        
    }
    field("Is Chapter";rec."Is Chapter")
    {
        
    }
    field("Parent";rec."Parent")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Description 2";rec."Description 2")
    {
        
    }
    field("Unit Of Measure";rec."Unit Of Measure")
    {
        
    }
    field("Contract Price";rec."Contract Price")
    {
        
    }
    field("Sales Price";rec."Sales Price")
    {
        
    }
    field("Contrat Measure";rec."Contrat Measure")
    {
        
    }
    field("Med. Anterior";rec."Med. Anterior")
    {
        
    }
    field("Med. Term Measure";rec."Med. Term Measure")
    {
        
    }
    field("Med. Source Measure";rec."Med. Source Measure")
    {
        
    }
    field("Med. Pending Measurement";rec."Med. Pending Measurement")
    {
        
    }
    field("Contrat Amount";rec."Contrat Amount")
    {
        
    }
    field("Med. Anterior PEM amount";rec."Med. Anterior PEM amount")
    {
        
    }
    field("Med. Term PEM Amount";rec."Med. Term PEM Amount")
    {
        
    }
    field("Med. Source PEM Amount";rec."Med. Source PEM Amount")
    {
        
    }
    field("Med. % Measure";rec."Med. % Measure")
    {
        
    }
    field("txtLong";"txtLong")
    {
        
                CaptionML=ESP='Texto Largo';
    }

}

}
}
  
trigger OnAfterGetRecord()    BEGIN
                       txtLong := '';
                       IF QBText.GET(QBText.Table::Job, rec."Job No.", rec."Piecework No.", '') THEN
                         txtLong := QBText.GetCostText;
                     END;



    var
      QBText : Record 7206918;
      DataPieceworkForProduction : Record 7207386;
      txtLong : Text;

    /*begin
    end.
  
*/
}







