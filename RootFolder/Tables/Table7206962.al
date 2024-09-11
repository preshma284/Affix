table 7206962 "QB Aux Measurement Header"
{
  
  
    CaptionML=ENU='Measurement Header',ESP='Cabecera Medici¢n';
  
  fields
{
    field(1;"No.";Code[20])
    {
        CaptionML=ENU='No.',ESP='N§';


    }
    field(2;"Description";Text[50])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';
                                                   Editable=false;


    }
    field(3;"Description 2";Text[50])
    {
        CaptionML=ENU='Description 2',ESP='Descripci¢n 2';


    }
    field(4;"Posting Date";Date)
    {
        CaptionML=ENU='Posting Date',ESP='Fecha registro';


    }
    field(5;"Send Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha entrega';


    }
    field(8;"Currency Code";Code[10])
    {
        TableRelation="Currency";
                                                   CaptionML=ENU='Currency Code',ESP='C¢d. divisa';
                                                   Editable=true;


    }
    field(9;"Currency Factor";Decimal)
    {
        CaptionML=ENU='Currency Factor',ESP='Factor divisa';
                                                   DecimalPlaces=0:15;
                                                   MinValue=0;
                                                   Editable=false;


    }
    field(16;"Measurement Date";Date)
    {
        CaptionML=ENU='Measurement Date',ESP='Fecha medici¢n';


    }
    field(17;"No. Measure";Code[10])
    {
        CaptionML=ENU='No. Measure',ESP='N§ de medici¢n';


    }
    field(19;"Text Measure";Text[30])
    {
        CaptionML=ENU='Text Measure',ESP='Texto medici¢n';


    }
    field(20;"Job No.";Code[20])
    {
        TableRelation=Job WHERE ("Card Type"=CONST("Proyecto operativo"),
                                                                            "Job Type"=CONST("Operative"));
                                                   CaptionML=ENU='Job No.',ESP='N§ proyecto';


    }
    field(21;"Customer No.";Code[20])
    {
        TableRelation="Customer";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Customer No.',ESP='N§  cliente';

trigger OnLookup();
    VAR
//                                                               cust@1100286000 :
                                                              cust: Code[20];
                                                            BEGIN 
                                                            END;


    }
    field(23;"Name";Text[50])
    {
        CaptionML=ENU='Name',ESP='Nombre';
                                                   Editable=false;


    }
    field(24;"Address";Text[50])
    {
        CaptionML=ENU='Address',ESP='Direcci¢n';
                                                   Editable=false;


    }
    field(25;"Address 2";Text[50])
    {
        CaptionML=ENU='Address 2',ESP='Direcci¢n 2';
                                                   Editable=false;


    }
    field(26;"City";Text[50])
    {
        CaptionML=ENU='City',ESP='Poblaci¢n';
                                                   Editable=false;


    }
    field(27;"Contact";Text[50])
    {
        CaptionML=ENU='Contact',ESP='Contacto';
                                                   Editable=false;


    }
    field(28;"County";Text[50])
    {
        CaptionML=ENU='County',ESP='Provincia';
                                                   Editable=false;


    }
    field(29;"Post Code";Code[20])
    {
        CaptionML=ENU='Post Code',ESP='C.P.';
                                                   Editable=false;


    }
    field(30;"Country Code";Code[10])
    {
        TableRelation="Country/Region";
                                                   CaptionML=ENU='Country Code',ESP='C¢d. Pa¡s';
                                                   Editable=false;


    }
    field(31;"Name 2";Text[50])
    {
        CaptionML=ENU='Name 2',ESP='Nombre 2';
                                                   Editable=false;


    }
    field(51;"Bill-to No. Customer";Code[20])
    {
        TableRelation="Customer";
                                                   CaptionML=ENU='Bill-to No. Customer',ESP='Factura a N§ cliente';


    }
    field(90;"Amount Origin";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='A origen';


    }
    field(91;"Amount Previous";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Anterior';


    }
    field(92;"Amount Term";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Periodo';


    }
    field(93;"Amount GG";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='GG';
                                                   Editable=false;


    }
    field(94;"Amount BI";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='BI';
                                                   Editable=false;


    }
    field(95;"Amount Low";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Baja';
                                                   Editable=false;


    }
    field(96;"Amount Document";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe';
                                                   Editable=false;


    }
    field(500;"Porc. GG";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Gastos Generales';


    }
    field(501;"Porc. BI";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Beneficio Industrial';


    }
    field(502;"Porc. Baja";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Baja';


    }
    field(503;"Porc. RET";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Retenci¢n';


    }
    field(505;"Porc. Ejec.";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Ejecutado';


    }
    field(506;"Porc. Pte";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Pendiente';


    }
    field(510;"Am. PEM Con";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe PEM Contrato';


    }
    field(511;"Am. PEM Mes";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe PEM Mes';


    }
    field(512;"Am. PEM Ant";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe PEM Anterior';


    }
    field(513;"Am. PEM Ori";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe PEM Origen';


    }
    field(520;"Am. GG_BI_BJ Con";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe GG/BI/Baja Contrato';


    }
    field(521;"Am. GG_BI_BJ Mes";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe GG/BI/Baja Mes';


    }
    field(522;"Am. GG_BI_BJ Ant";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe GG/BI/Baja Anterior';


    }
    field(523;"Am. GG_BI_BJ Ori";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe GG/BI/Baja Origen';


    }
    field(530;"Am. PEC Con";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe PEC Contrato';


    }
    field(531;"Am. PEC Mes";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe PEC Mes';


    }
    field(532;"Am. PEC Ant";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe PEC Anterior';


    }
    field(533;"Am. PEC Ori";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe PEC Origen';


    }
    field(541;"Am. RET Mes";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Retenci¢n Mes';


    }
    field(542;"Am. RET Ant";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Retenci¢n Anterior';


    }
    field(543;"Am. RET Ori";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Retenci¢n Origen';


    }
    field(551;"Am. TOT Mes";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Total Mes';


    }
    field(552;"Am. TOT Ant";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Total Anterior';


    }
    field(553;"Am. TOT Ori";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Total Origen';


    }
}
  keys
{
    key(key1;"No.")
    {
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







