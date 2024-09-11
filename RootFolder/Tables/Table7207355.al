table 7207355 "Element Contract Comment Lines"
{
  
  
    CaptionML=ENU='Element Contract Comment Lines',ESP='L¡neas comen contrato elemento';
    LookupPageID="Quotes Type List";
    DrillDownPageID="Quotes Type List";
  
  fields
{
    field(1;"No.";Code[20])
    {
        CaptionML=ENU='No.',ESP='No.';


    }
    field(2;"Line No.";Integer)
    {
        CaptionML=ENU='Line No.',ESP='No. l¡neas';


    }
    field(3;"Date";Date)
    {
        CaptionML=ENU='Date',ESP='Fecha';


    }
    field(4;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(5;"Comment";Text[80])
    {
        CaptionML=ENU='Comment',ESP='Comentario'; ;


    }
}
  keys
{
    key(key1;"No.","Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    procedure SetUpNewLine ()
    var
//       ElementContractCommentLines@1000 :
      ElementContractCommentLines: Record 7207355;
    begin
      ElementContractCommentLines.SETRANGE(ElementContractCommentLines."No.","No.");
      if not ElementContractCommentLines.FIND('-') then
        Date := WORKDATE;
    end;

    /*begin
    end.
  */
}







