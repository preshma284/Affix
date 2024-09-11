table 7207322 "QBU Comment Lines Expen. Notes"
{
  
  
    CaptionML=ENU='Comment Lines Expen. Notes',ESP='Lineas de Comentario NG';
    LookupPageID="Expen. Note Comment List";
    DrillDownPageID="Exp. Notes Comment Sheet";
  
  fields
{
    field(1;"Document Type";Option)
    {
        OptionMembers="Expense Notes","Expense Notes Hist.";CaptionML=ENU='Document Type',ESP='Tipo Documento';
                                                   OptionCaptionML=ENU=',,,,,,,,,,,,Expense Notes,Expense Notes Hist.',ESP=',,,,,,,,,,,,Notas gastos,Hist. Notas gastos';
                                                   


    }
    field(2;"No.";Code[20])
    {
        CaptionML=ENU='No',ESP='N§';


    }
    field(3;"Line No.";Integer)
    {
        CaptionML=ENU='Line No',ESP='N§ l¡nea';


    }
    field(4;"Date";Date)
    {
        CaptionML=ENU='Date',ESP='Fecha';


    }
    field(5;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(6;"Comment";Text[80])
    {
        CaptionML=ENU='Comment',ESP='Comentario'; ;


    }
}
  keys
{
    key(key1;"Document Type","No.","Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    procedure SetUpNewLine ()
    var
//       CommentLinesExpenNotes@1000 :
      CommentLinesExpenNotes: Record 7207322;
    begin
      CommentLinesExpenNotes.SETRANGE("No.","No.");
      if not CommentLinesExpenNotes.FINDFIRST then
        Date := WORKDATE;
    end;

    /*begin
    end.
  */
}







