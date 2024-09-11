table 7207364 "Usage Comment Line"
{
  
  
    CaptionML=ENU='Usage Comment Line',ESP='Lineas comentarios utilizaci¢n';
    LookupPageID="Usage Comment List";
    DrillDownPageID="Usage Comment List";
  
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
//       LOUsageCommentLine@1000 :
      LOUsageCommentLine: Record 7207364;
    begin
      LOUsageCommentLine.SETRANGE("No.","No.");
      if not LOUsageCommentLine.FINDFIRST then
        Date := WORKDATE;
    end;

    /*begin
    end.
  */
}







