table 7207358 "Lines Commen Deliv/Ret Element"
{
  
  
    CaptionML=ENU='Lines Commen Deliv/Ret Element',ESP='L¡neas comen Entrega/devol Ele';
    LookupPageID="Commen Deliv/Ret Element List";
    DrillDownPageID="Commen Deliv/Ret Element List";
  
  fields
{
    field(1;"No.";Code[20])
    {
        CaptionML=ENU='No.',ESP='N§';


    }
    field(2;"Line No.";Integer)
    {
        CaptionML=ENU='Line No.',ESP='N§ l¡nea';


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
//       LinescommenDelivRetElement@1000 :
      LinescommenDelivRetElement: Record 7207358;
    begin
      LinescommenDelivRetElement.RESET;
      LinescommenDelivRetElement.SETRANGE("No.","No.");
      if LinescommenDelivRetElement.ISEMPTY then
        Date := WORKDATE;
    end;

    /*begin
    end.
  */
}







