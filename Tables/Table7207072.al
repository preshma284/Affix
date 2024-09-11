table 7207072 "QBU Sales Line Ext."
{
  
  
    CaptionML=ENU='Sales Line Ext',ESP='Lin. venta Ext';
  
  fields
{
    field(1;"Record Id";RecordID)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document Type',ESP='ID. Registro'; ;


    }
}
  keys
{
    key(key1;"Record Id")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    // procedure Read (rID@1100286002 :
procedure Read (rID: RecordID) : Boolean;
    begin
      //Busca un registro, si no existe lo inicializa, retorna encontrado o no
      Rec.RESET;
      Rec.SETRANGE("Record Id", rID);
      if not Rec.FINDFIRST then begin
        Rec.INIT;
        Rec."Record Id" := rID;
        exit(FALSE);
      end;
      exit(TRUE)
    end;

    procedure Save ()
    begin
      //Guarda el registro
      if not Rec.MODIFY then
        Rec.INSERT(TRUE);
    end;

    /*begin
    end.
  */
}







