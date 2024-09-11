table 7207369 "QBU Activation Comments Line"
{
  
  
    CaptionML=ENU='Activation Comments Line',ESP='Lineas comentarios activaci¢n';
    LookupPageID="Activation Comments Line";
    DrillDownPageID="Activation Comments Line";
  
  fields
{
    field(1;"No.";Code[20])
    {
        CaptionML=ENU='No.',ESP='No.';


    }
    field(2;"Line No.";Integer)
    {
        CaptionML=ENU='Line No.',ESP='No. L¡nea';


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
//       ActivationCommentsLine@1000 :
      ActivationCommentsLine: Record 7207369;
    begin
      ActivationCommentsLine.SETRANGE("No.","No.");
      if not ActivationCommentsLine.FINDFIRST then
        Date := WORKDATE;
    end;

    /*begin
    end.
  */
}







