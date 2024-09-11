table 7206941 "QBU Generic Import Line"
{
  
  
    CaptionML=ENU='QB Generic Import Line',ESP='QB Lineas Importaci¢n Gen‚rica';
  
  fields
{
    field(1;"Setup Code";Code[20])
    {
        TableRelation="QB Generic Import Header"."Setup Code";
                                                   DataClassification=ToBeClassified;


    }
    field(2;"Table ID";Integer)
    {
        TableRelation="QB Generic Import Header"."Table ID";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Table ID',ESP='ID Tabla';


    }
    field(3;"Field No.";Integer)
    {
        TableRelation=Field."No." WHERE ("TableNo"=FIELD("Table ID"));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Field No.',ESP='N§ de campo';

trigger OnValidate();
    BEGIN 
                                                                CALCFIELDS("Field Name");
                                                              END;


    }
    field(10;"Field Name";Text[100])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Field"."FieldName" WHERE ("TableNo"=FIELD("Table ID"),
                                                                                             "No."=FIELD("Field No.")));
                                                   CaptionML=ENU='Field Name',ESP='Nombre de campo';
                                                   Editable=false;


    }
    field(11;"Order";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Orden';


    }
    field(12;"Excel Column";Code[2])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Columna';

trigger OnValidate();
    VAR
//                                                                 t@1100286000 :
                                                                t: Text[26];
//                                                                 p1@1100286001 :
                                                                p1: Integer;
//                                                                 p2@1100286002 :
                                                                p2: Integer;
                                                              BEGIN 
                                                                IF ("Excel Column" = '') THEN
                                                                  "Excel Column No" := 0
                                                                ELSE BEGIN 

                                                                  t := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                                                                  p1 := STRPOS(t, COPYSTR("Excel Column",1,1));
                                                                  IF (p1 = 0) THEN
                                                                    ERROR(txtQB000);

                                                                  IF (STRLEN("Excel Column") = 1) THEN BEGIN 
                                                                    "Excel Column No" := p1;
                                                                  END ELSE BEGIN 
                                                                    p2 := STRPOS(t, COPYSTR("Excel Column",2,1));
                                                                    IF (p2 = 0) THEN
                                                                      ERROR(txtQB000);
                                                                    "Excel Column No" := (p1 * STRLEN(t)) + p2;
                                                                  END;
                                                                END;
                                                              END;


    }
    field(13;"Excel Column No";Integer)
    {
        DataClassification=ToBeClassified;


    }
    field(14;"Autoincrement By";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Autoincrement',ESP='Auto incremento';


    }
    field(15;"Replacement Code";Code[20])
    {
        TableRelation="QB Replacement Header";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Replacement Code',ESP='C¢digo sustituci¢n';


    }
    field(16;"Group";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Group',ESP='Agrupado';

trigger OnValidate();
    BEGIN 
                                                                IF (Group) AND ("Apply Summation") THEN
                                                                  ERROR(txtQB001);
                                                              END;


    }
    field(17;"Apply Summation";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Apply Summation',ESP='Aplicar sumatorio';

trigger OnValidate();
    BEGIN 
                                                                IF (Group) AND ("Apply Summation") THEN
                                                                  ERROR(txtQB002);
                                                              END;


    }
    field(20;"Default Value";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Valor por defecto';


    }
    field(21;"Export Filter";Text[100])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Export Filter',ESP='Filtro para exportar';


    }
    field(30;"Ini Postition";Integer)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Inicio';

trigger OnValidate();
    BEGIN 
                                                                IF (Long <> 0) THEN
                                                                  "End Position" := "Ini Postition" + Long - 1
                                                                ELSE IF ("End Position" <> 0) THEN
                                                                  Long := "End Position" - "Ini Postition" + 1;
                                                              END;


    }
    field(31;"Long";Integer)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Longitud';

trigger OnValidate();
    BEGIN 
                                                                IF ("Ini Postition" <> 0) THEN
                                                                  "End Position" := "Ini Postition" + Long - 1
                                                                ELSE IF ("End Position" <> 0) THEN
                                                                  "Ini Postition" := "End Position" - Long + 1;
                                                              END;


    }
    field(32;"End Position";Integer)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Final';

trigger OnValidate();
    BEGIN 
                                                                IF ("Ini Postition" <> 0) THEN
                                                                  Long := "End Position" - "Ini Postition" + 1
                                                                ELSE IF (Long <> 0) THEN
                                                                  "Ini Postition" := "End Position" - Long + 1;
                                                              END;


    }
    field(33;"Format";Text[30])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Formato';
                                                   Description='[[TT]] Para Texto: "","Ic","Dc" Para Fechas: "DDsMMsAA" o "DDsMMsAAAA" Para decimales: "", "N", "-pgN" o "N-pg" Para Booleanos: "" o "sn"]' ;


    }
}
  keys
{
    key(key1;"Setup Code","Table ID","Field No.")
    {
        Clustered=true;
    }
    key(key2;"Excel Column No")
    {
        ;
    }
}
  fieldgroups
{
}
  
    var
//       QBGenericImportLine@1100286000 :
      QBGenericImportLine: Record 7206941;
//       txtQB000@1100286003 :
      txtQB000: TextConst ESP='Columna no v lida en la Excel, debe ser en el rango A..Z o AA..ZZ';
//       txtQB001@1100286001 :
      txtQB001: TextConst ESP='No puede usar una columna que acumule para agrupar.';
//       txtQB002@1100286002 :
      txtQB002: TextConst ESP='No puede usar un criterio de agrupaci¢n para sumar.';

    /*begin
    end.
  */
}







