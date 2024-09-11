table 7206963 "QB Aux Measurement Lines"
{
  
  
    CaptionML=ENU='Measurement Lines',ESP='L¡neas medici¢n';
  
  fields
{
    field(1;"Document No.";Code[20])
    {
        CaptionML=ENU='Document No.',ESP='N§ documento';


    }
    field(3;"Piecework No.";Text[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                         "Account Type"=CONST("Unit"),
                                                                                                                         "Customer Certification Unit"=CONST(true));
                                                   CaptionML=ENU='Piecework No.',ESP='N§ unidad de obra';


    }
    field(4;"Description";Text[50])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(5;"Description 2";Text[50])
    {
        CaptionML=ENU='Description 2',ESP='Descripci¢n 2';


    }
    field(6;"Med. Term PEC Amount";Decimal)
    {
        CaptionML=ENU='Amount',ESP='Importe Periodo PEC';
                                                   Description='Importe PEC Periodo';
                                                   Editable=false;
                                                   AutoFormatType=1;
                                                   AutoFormatExpression="Currency Code";


    }
    field(9;"Currency Code";Code[10])
    {
        TableRelation="Currency";
                                                   CaptionML=ENU='Currency Code',ESP='C¢d. divisa';
                                                   Editable=false;


    }
    field(11;"Contract Price";Decimal)
    {
        CaptionML=ENU='Sale Price',ESP='Precio E.C.';
                                                   DecimalPlaces=2:4;
                                                   Description='Precio PEC';
                                                   Editable=false;


    }
    field(13;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ proyecto';


    }
    field(17;"Sales Price";Decimal)
    {
        CaptionML=ENU='Precio Contrato',ESP='Precio E.M.';
                                                   DecimalPlaces=2:4;
                                                   Description='Precio PEM';


    }
    field(28;"Med. Source Measure";Decimal)
    {
        CaptionML=ENU='Source Measure',ESP='Medici¢n origen';
                                                   DecimalPlaces=2:4;
                                                   Description='Cantidad Origen';


    }
    field(29;"Med. Term Measure";Decimal)
    {
        CaptionML=ENU='Medicion periodo',ESP='Medici¢n per¡odo';
                                                   DecimalPlaces=2:4;
                                                   Description='Cantidad Periodo';


    }
    field(35;"Med. Measured Quantity";Decimal)
    {
        CaptionML=ENU='Cantidad medida',ESP='Cantidad medida';
                                                   DecimalPlaces=2:4;
                                                   Editable=false;


    }
    field(36;"Med. Pending Measurement";Decimal)
    {
        CaptionML=ENU='Medicion pendiente',ESP='Medici¢n pendiente';
                                                   DecimalPlaces=2:4;
                                                   Editable=false;


    }
    field(39;"Med. % Measure";Decimal)
    {
        CaptionML=ENU='% de medicion',ESP='% de medici¢n';
                                                   DecimalPlaces=2:6;


    }
    field(107;"Code Piecework PRESTO";Code[40])
    {
        CaptionML=ENU='Code Piecework PRESTO',ESP='C¢d. U.O PRESTO';
                                                   Description='QB3685';


    }
    field(109;"Med. Term PEM Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Periodo PEM';
                                                   Description='Importe PEM del periodo                               JAV 04/04/19: - Se incluyen los campos para realizar el c lculo del importe correcto';
                                                   Editable=false;


    }
    field(111;"Med. Source PEM Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Certification Amount (base)',ESP='Imp. Origen a PEM';
                                                   Description='Importe PEM a origen de Mediciones';
                                                   Editable=false;
                                                   AutoFormatType=1;
                                                   AutoFormatExpression="Currency Code";


    }
    field(113;"Med. Anterior PEM amount";Decimal)
    {
        CaptionML=ESP='Imp.Anterior a PEM';
                                                   Description='QB 1.08.28 - JAV 25/03/21 Suma anterior a PEM';


    }
    field(500;"Is Chapter";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Es Cap¡tulo';


    }
    field(501;"Parent";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Padre';


    }
    field(502;"Contrat Measure";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Medici¢n del contrato';


    }
    field(503;"Contrat Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe contrato';


    }
    field(504;"Unit Of Measure";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Unidad de Medida';


    }
    field(505;"Med. Anterior";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Medici¢n Anterior';


    }
}
  keys
{
    key(key1;"Document No.","Piecework No.")
    {
        SumIndexFields="Med. Term PEC Amount","Med. Term PEM Amount";
                                                   Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 06/04/21: - QB 1.08.33 Tabla auxiliar para imprimir mediciones
    }
    end.
  */
}







