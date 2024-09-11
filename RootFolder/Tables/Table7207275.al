table 7207275 "Aux. Table C. Dat. Ext. VERT"
{
  
  
    CaptionML=ENU='Aux. Table C. Dat. Ext. Vert.',ESP='Tabla auxiliar prec ext VERT';
  
  fields
{
    field(1;"Line No.";Integer)
    {
        CaptionML=ENU='Line No.',ESP='No. linea';


    }
    field(2;"Header Line";Text[2])
    {
        CaptionML=ENU='Header Line',ESP='Cabecera l¡nea';


    }
    field(3;"Code";Text[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(4;"Small Description";Text[80])
    {
        CaptionML=ENU='Small Description',ESP='Descripci¢n';


    }
    field(6;"Amount";Decimal)
    {
        CaptionML=ENU='Amount',ESP='Importe';


    }
    field(7;"Unit of Meansure";Text[10])
    {
        CaptionML=ENU='Unit of Meansure',ESP='Unidad de medida';


    }
    field(8;"Bill of Item Unit";Decimal)
    {
        CaptionML=ENU='Bill of Item Unit',ESP='Factor';
                                                   DecimalPlaces=2:12;


    }
    field(9;"Bill of Item Quantity";Decimal)
    {
        CaptionML=ENU='Bill of Item Quantity',ESP='Cantidad';
                                                   DecimalPlaces=2:6;


    }
    field(10;"Type";Option)
    {
        OptionMembers=" ","Cost Database","Title","Subtitle","Piecework","P. Auxiliar","Resource","Item","Equipament","Other","Measure";CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='" ,Cost Database,Title,Subtitle,Piecework,P. Auxiliar,Resource,Item,Equipament,Other,Measure"',ESP='" ,Preciario,Titulo,Subtitulo,Unidad de obra, P. auxiliar, Recurso, Producto,M quina,Otros,Medici¢n"';
                                                   


    }
    field(11;"Cost Database Code";Code[20])
    {
        CaptionML=ENU='Cost Database Code',ESP='Cod. Preciario';


    }
    field(12;"Bill of Item Code";Text[20])
    {
        CaptionML=ENU='Bill of Item Code',ESP='Cod. descompuesto';


    }
    field(13;"Session No.";Integer)
    {
        CaptionML=ENU='SessionNo.',ESP='No. Sesi¢n';


    }
    field(14;"Concept Type";Option)
    {
        OptionMembers=" ","Unclassified","Resource","Item","Equipament","Measure";CaptionML=ENU='Concept Type',ESP='Tipo concepto';
                                                   OptionCaptionML=ENU='" ,Unclassified,Resource,Item,Equipament,Measure"',ESP='" ,Sin clasificar,Recurso,Producto,M quina,Medici¢n"';
                                                   


    }
    field(15;"Units";Decimal)
    {
        CaptionML=ENU='Units',ESP='Unidades';


    }
    field(16;"Length";Decimal)
    {
        CaptionML=ENU='Length',ESP='Longitud';


    }
    field(17;"Width";Decimal)
    {
        CaptionML=ENU='Width',ESP='Anchura';


    }
    field(18;"Height";Decimal)
    {
        CaptionML=ENU='Height',ESP='Altura';


    }
    field(19;"Greater Account";Code[20])
    {
        CaptionML=ENU='Greater Account',ESP='C¢digo Propio';
                                                   Description='QB 1.24.24 JAV 27/11/22 ### Ya no se usa';


    }
    field(20;"Parents Account";Code[20])
    {
        CaptionML=ENU='Parents Account',ESP='C¢digo del padre';
                                                   Description='QB 1.24.24 JAV 27/11/22 ### Ya no se usa';


    }
    field(21;"Medition Total";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Medici¢n total';
                                                   Description='QB 1.12.24 JAV 27/11/22 Medici¢n total recibida';


    }
    field(22;"BlobText";BLOB)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB 1.05 El texto extendido';


    }
    field(23;"BlobTextLong";Integer)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB 1.05 El tama¤o del texto extendido';


    }
    field(24;"File Line";Integer)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB 1.05 L¡nea del fichero que la ha originado';


    }
    field(25;"Mesure Position";Text[30])
    {
        DataClassification=ToBeClassified;
                                                   Description='QB 1.24.24 JAV 02/12/22 Posici¢n en la estructura del presupuesto de la medici¢n';


    }
    field(500;"Guardar Concept Type";Text[3])
    {
        DataClassification=ToBeClassified;
                                                   Description='QB18285 AML 28/03/23';


    }
    field(502;"Procesado";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB18285 AML 28/03/23';


    }
    field(503;"Almohadilla";Boolean)
    {
        DataClassification=ToBeClassified;


    }
    field(504;"Doble Almohadilla";Boolean)
    {
        DataClassification=ToBeClassified;


    }
    field(505;"Iteracion";Integer)
    {
        DataClassification=ToBeClassified ;


    }
}
  keys
{
    key(key1;"Session No.","Cost Database Code","Line No.")
    {
        Clustered=true;
    }
    key(key2;"Session No.","Cost Database Code","Header Line","Code")
    {
        ;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Se a¤ade el campo 21
    }
    end.
  */
}







