table 7206924 "QBU Liq. Efectos Cabecera"
{
  
  
    
  fields
{
    field(1;"Relacion No.";Integer)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Liquidaci¢n';

trigger OnValidate();
    BEGIN 
                                                                IF ("Relacion No." = 0) THEN
                                                                  INSERT(TRUE);
                                                              END;


    }
    field(10;"Posting Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha de Registro';


    }
    field(18;"Total Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Liq. Efectos Linea"."Amount" WHERE ("Relacion No."=FIELD("Relacion No.")));
                                                   CaptionML=ESP='Importe Total';
                                                   Editable=false;


    }
    field(19;"Total Marked";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Liq. Efectos Linea"."Amount" WHERE ("Relacion No."=FIELD("Relacion No."),
                                                                                                         "Liquidar"=CONST(true)));
                                                   CaptionML=ESP='Importe Marcado';
                                                   Editable=false;


    }
    field(32;"Registrado";Boolean)
    {
        DataClassification=ToBeClassified ;


    }
}
  keys
{
    key(key1;"Relacion No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       recAux@7001100 :
      recAux: Record 7206924;
//       Lineas@7001101 :
      Lineas: Record 7206925;
//       hayError@7001102 :
      hayError: Boolean;
//       txtQB000@1100286000 :
      txtQB000: TextConst ESP='No ha indicado la fecha de registro.';

    

trigger OnInsert();    begin
               recAux.RESET;
               if recAux.FINDLAST then
                 "Relacion No." := recAux."Relacion No." + 1
               else
                 "Relacion No." := 1;
               "Posting Date" := TODAY;
             end;

trigger OnDelete();    begin
               Lineas.RESET;
               Lineas.SETRANGE("Relacion No.", "Relacion No.");
               Lineas.DELETEALL;
             end;



procedure HayErrores () : Boolean;
    begin
      if ("Posting Date" = 0D) then
        ERROR(txtQB000);

      hayError := FALSE;
      Lineas.RESET;
      Lineas.SETRANGE("Relacion No.", "Relacion No.");
      if Lineas.FINDSET then
        repeat
          if (Lineas.HayError) then hayError := TRUE;
        until Lineas.NEXT = 0;
      COMMIT;
      exit(hayError);
    end;

    /*begin
    end.
  */
}







