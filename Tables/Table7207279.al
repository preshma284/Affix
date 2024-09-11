table 7207279 "QBU Piecework Setup"
{
  
  
    CaptionML=ENU='Piecework Setup',ESP='Conf. unidades de obra';
  
  fields
{
    field(1;"Primary Key";Code[20])
    {
        CaptionML=ENU='Primary Key',ESP='Clave primaria';


    }
    field(2;"Series Measure No.";Code[20])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='Series Measure No.',ESP='N§ serie Mediciones';


    }
    field(3;"Series Certification No.";Code[20])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='Series Certification No.',ESP='N§ serie Certificaciones';


    }
    field(4;"Series Hist. Measure No.";Code[20])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='Series Hist. Measure No.',ESP='N§ serie Mediciones reg.';


    }
    field(5;"Series Hist. Certification No.";Code[20])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='Series Hist. Certification No.',ESP='N§ serie Certificaciones reg.';


    }
    field(6;"G.C. Resource PRESTO";Code[20])
    {
        TableRelation="Gen. Product Posting Group";
                                                   CaptionML=ENU='G.C. Resource PRESTO',ESP='G.C. recurso PRESTO';


    }
    field(7;"G.C. Item PRESTO";Code[20])
    {
        TableRelation="Gen. Product Posting Group";
                                                   CaptionML=ENU='G.C. Item PRESTO',ESP='G.C. Producto PRESTO';


    }
    field(8;"G.C. Stock PRESTO";Code[20])
    {
        TableRelation="Inventory Posting Group";
                                                   CaptionML=ENU='G.C. Stock PRESTO',ESP='G.C. Existencias PRESTO';


    }
    field(9;"G.R. BAT Product PRESTO";Code[20])
    {
        TableRelation="VAT Product Posting Group";
                                                   CaptionML=ENU='G.C. BAT Product PRESTO',ESP='G.C. IVA procuto PRESTO';


    }
    field(10;"CA Resource Sub";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='CA PRESTO',ESP='CA Subcontratas';
                                                   Description='JAV 25/02/21 Valor para subcontratas por defecto';

trigger OnLookup();
    BEGIN 
                                                              DimensionValue.RESET;
                                                              DimensionValue.SETRANGE("Dimension Code",FunctionQB.ReturnDimCA);

                                                              IF PAGE.RUNMODAL(PAGE::"Dimension Values",DimensionValue) = ACTION::LookupOK THEN
                                                                "CA Resource Sub" := DimensionValue.Code;
                                                            END;


    }
    field(11;"% Management Application";Decimal)
    {
        CaptionML=ENU='% Management Application',ESP='% Tramitaci¢n gesti¢n';
                                                   DecimalPlaces=2:2;
                                                   MinValue=0;
                                                   MaxValue=100;


    }
    field(12;"% Appl. Tecnique Approval";Decimal)
    {
        CaptionML=ENU='% Appl. Tecnique Approval',ESP='% Tramitac. Aprobaci¢n t‚cnica';
                                                   DecimalPlaces=2:2;
                                                   MinValue=1;
                                                   MaxValue=100;


    }
    field(13;"Cta. Generic Bill of Item No.";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Cta. Generic Bill of Item No.',ESP='No. Cta. Descompuesto gen‚rico';


    }
    field(14;"Series Jobs Reception No.";Code[20])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='Series Jobs Reception No.',ESP='N§ serie Recepciones proyecto';


    }
    field(15;"Acount Resource BC3 No.";Code[20])
    {
        TableRelation=Resource."No." WHERE ("Type"=CONST("Subcontracting"));
                                                   CaptionML=ENU='Acount Resource BC3 No.',ESP='No. recurso cuentas BC3';
                                                   Description='### ELIMINAR ### No se usa';


    }
    field(20;"Objective % Low";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Low probability',ESP='% Probabilidad Baja';
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='QB 1.09.40 - JAV 18/04/21: - OBJETIVOS Porcentaje cuando la probabilidad es baja';


    }
    field(21;"Objective % Medium";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Medium probability',ESP='% Probabilidad Media';
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='QB 1.09.40 - JAV 18/04/21: - OBJETIVOS Porcentaje cuando la probabilidad es media';


    }
    field(22;"Objective % High";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% High probability',ESP='% Probabilidad Alta';
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='QB 1.09.40 - JAV 18/04/21: - OBJETIVOS Porcentaje cuando la probabilidad es alta';


    }
    field(100;"PRESTO Default Create";Option)
    {
        OptionMembers="No","Generic Account","Identic  ITem Piecework","Identic Resource Piecework";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Create Generic Bill of Item if it Does Not Exist',ESP='Crear descompuesto gen‚rico si no existe';
                                                   OptionCaptionML=ENU='No,Generic Account,Identic  ITem Piecework,Identic Resource Piecework',ESP='No,Cta. gen‚rica,Producto id‚ntico a la U.O.,Recurso id‚ntico a la U.O.';
                                                   
                                                   Description='JAV valores por defecto al importar BC3';


    }
    field(101;"PRESTO Skip Cost";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Skip Bill of Item',ESP='Omitir descompuestos de coste';
                                                   Description='QB 1.06.09 - JAV valores por defecto al importar descompuestos de coste del BC3';


    }
    field(102;"PRESTO Skip Sales";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Skip Bill of Item',ESP='Omitir descompuestos de venta';
                                                   Description='QB 1.06.09 - JAV valores por defecto al importar descompuestos de venta del BC3';


    }
    field(103;"Default Porcentual Cost";Option)
    {
        OptionMembers="Upload","Distribute","DontUpload";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Los Porcentuales de Coste';
                                                   OptionCaptionML=ENU='Upload,Distribute,Don''t upload',ESP='Cargar,Distribuir,No cargar';
                                                   
                                                   Description='QB 1.12.24 JAV 12/12/22 - Por defecto al cargar el BC3 de coste para los porcentuales usar';


    }
    field(104;"Default Porcentual Sales";Option)
    {
        OptionMembers="Upload","Distribute","DontUpload";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Los Porcentuales de Venta';
                                                   OptionCaptionML=ENU='Upload,Distribute,Don''t upload',ESP='Cargar,Distribuir,No cargar';
                                                   
                                                   Description='QB 1.12.24 JAV 12/12/22 - Por defecto al cargar el BC3 de venta para los porcentuales usar';


    }
    field(105;"Default Cost Without Decom.";Option)
    {
        OptionMembers="None","Item","Resource";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='En partidas de coste sin descompuestos';
                                                   OptionCaptionML=ENU='None,Item,Resource',ESP='No hacer nada,Crear un Producto,Crear un Recurso';
                                                   
                                                   Description='QB 1.12.24 JAV 12/12/22 - Por defecto al cargar el BC3 si las partidas de coste no tienen descompuestos crear';


    }
    field(106;"Default Sales Without Decom.";Option)
    {
        OptionMembers="None","Item","Resource";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='En partidas de venta sin descompuestos';
                                                   OptionCaptionML=ENU='None,Item,Resource',ESP='No hacer nada,Crear un Producto,Crear un Recurso';
                                                   
                                                   Description='QB 1.12.24 JAV 12/12/22 - Por defecto al cargar el BC3 si las partidas de venta no tienen descompuestos crear';


    }
    field(107;"Minimum difference for notice";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Diferencia M¡nima para aviso';
                                                   Description='QB 1.12.24 JAV 27/11/22 Al revisar datos, avisar si la diferencia es mayor a esta';


    }
    field(108;"Default Cost Aux W/Dec.";Option)
    {
        OptionMembers="None","Item","Resource";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Auxiliares de coste sin descompuestos';
                                                   OptionCaptionML=ENU='None,Item,Resource',ESP='No cambiar,Cambiar a Producto,Cambiar a Recurso';
                                                   
                                                   Description='QB 1.12.24 JAV 12/12/22 - Por defecto al cargar el BC3 si los auxiliares de coste no tienen descompuestos cambiar por';


    }
    field(109;"Default Sales Aux W/Dec.";Option)
    {
        OptionMembers="None","Item","Resource";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Auxiliares de venta sin descompuestos';
                                                   OptionCaptionML=ENU='None,Item,Resource',ESP='No cambiar,Cambiar a Producto,Cambiar a Recurso';
                                                   
                                                   Description='QB 1.12.24 JAV 12/12/22 - Por defecto al cargar el BC3 si los auxiliares de venta no tienen descompuestos cambiar por';


    }
    field(110;"Skip Cost Meditions";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Skip Bill of Item',ESP='Omitir mediciones de coste';
                                                   Description='QB 1.12.24 JAV 14/12/22 - Por defecto al cargar el BC3 omitir las mediciones de coste';


    }
    field(111;"Skip Sales Meditions";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Skip Bill of Item',ESP='Omitir mediciones de venta';
                                                   Description='QB 1.12.24 JAV 14/12/22 - Por defecto al cargar el BC3 omitir las mediciones de venta';


    }
    field(200;"CA PRESTO Item";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='CA Presto Material',ESP='CA Descompuesto Producto';
                                                   Description='JAV 25/02/21: QB 1.08.15 [TT]  valores por defecto al importar BC3/Excel cuando el descompuesto es de tipo producto';


    }
    field(201;"CA PRESTO Resource";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='CA Presto Piecework',ESP='CA Descompuesto Recurso Persona';
                                                   Description='JAV 25/02/21: QB 1.08.15 [TT]  valores por defecto al importar BC3/Excel cuando el descompuesto es de tipo recurso Persona';


    }
    field(202;"CA PRESTO Machinery";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='CA Presto Piecework',ESP='CA Descompuesto Recurso Maquina';
                                                   Description='JAV 25/02/21: QB 1.08.15 [TT]  valores por defecto al importar BC3/Excel cuando el descompuesto es de tipo recurso M quina';


    }
    field(203;"CA PRESTO Account";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='CA Presto Equipment',ESP='CA Descompuesto Cuenta';
                                                   Description='JAV 25/02/21: QB 1.08.15 [TT]  valores por defecto al importar BC3/Excel cuando el descompuesto es de tipo cuenta u otros';


    }
    field(500;"Resource Difference";Code[20])
    {
        TableRelation="Resource"."No.";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Descompuesto Recurso diferencias',ESP='Descompuesto Recurso diferencias';
                                                   Description='QB18285 AML Recurso para compensar la diferencia entre las UO y los descompuestos';


    }
    field(501;"Resource No Bill Item";Code[20])
    {
        TableRelation="Resource"."No.";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Recurso UO sin Desc,',ESP='Recurso UO sin Desc,';
                                                   Description='QB18285 AML Recurso para las UO sin descompuesto';


    }
    field(502;"Resource Update Budget";Code[20])
    {
        TableRelation="Resource"."No.";
                                                   DataClassification=ToBeClassified;
                                                   Description='AML Recurso para importar los porcentuales cargados en el presupuesto' ;


    }
}
  keys
{
    key(key1;"Primary Key")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       FunctionQB@60000 :
      FunctionQB: Codeunit 7207272;
//       DimensionValue@60001 :
      DimensionValue: Record 349;

    /*begin
    {
      JAV 01/03/19: - Se a¤aden los campos 100 y 101 para valores por defecto al importar BC3
      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Se a¤aden los campos 103 a 106
    }
    end.
  */
}







