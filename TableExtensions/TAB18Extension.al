tableextension 50107 "QBU CustomerExt" extends "Customer"
{
  
  /*
Permissions=TableData 21 r,
                TableData 167 r,
                TableData 249 rd,
                TableData 5900 r,
                TableData 5907 r,
                TableData 5940 rm,
                TableData 5965 rm,
                TableData 7002 rd,
                TableData 7004 rd;
*/DataCaptionFields="No.","Name";
    CaptionML=ENU='Customer',ESP='Cliente';
    LookupPageID="Customer Lookup";
    DrillDownPageID="Customer List";
  
  fields
{
    field(50000;"QBU Several Customer";Boolean)
    {
        

                                                   DataClassification=CustomerContent;
                                                   CaptionML=ENU='Several Customers',ESP='Clientes varios';
                                                   Description='Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';

trigger OnValidate();
    BEGIN 
                                                                //Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.) -
                                                                IF "Several Customer" THEN BEGIN 
                                                                  TESTFIELD("Country/Region Code");
                                                                  VALIDATE("VAT Registration No.",'');
                                                                END;
                                                                //Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.) +
                                                              END;


    }
    field(50001;"QBU Secondary Holder";Code[20])
    {
        TableRelation=Contact."No." WHERE ("Type"=CONST("Person"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Segundo titular';
                                                   Description='BS::21380';


    }
    field(50002;"QBU Secondary Holder Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Contact"."Name" WHERE ("No."=FIELD("Secondary Holder")));
                                                   CaptionML=ENU='Secondary Holder Name',ESP='Nombre segundo titular';
                                                   Description='BS::20703';


    }
    field(7174331;"QBU QuoSII VAT Reg No. Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("IDType"),
                                                                                                   "SII Entity"=CONST('AEAT'));
                                                   CaptionML=ENU='VAT Reg No. Type',ESP='Tipo CIF/NIF';
                                                   Description='QuoSII';


    }
    field(7174335;"QBU QuoSII Sales Special Regimen";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),
                                                                                                   "SII Entity"=CONST('AEAT'));
                                                   CaptionML=ENU='Special Regimen AEAT',ESP='R‚gimen Especial AEAT';
                                                   Description='QuoSII_1.4.2.042.04';


    }
    field(7174336;"QBU QuoSII Sales Special Regimen 1";Code[20])
    {
        TableRelation=IF ("QuoSII Sales Special Regimen"=FILTER(07)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                "SII Entity"=CONST('AEAT'),                                                                                                                                                "Code"=FILTER('01'|'03'|'05'|'09'|'11'|'12'|'13'|'14'|'15'))                                                                                                                                                ELSE IF ("QuoSII Sales Special Regimen"=FILTER(05)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                    "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                    "Code"=FILTER('01'|'06'|'07'|'08'|'11'|'12'|'13'))                                                                                                                                                                                                                                    ELSE IF ("QuoSII Sales Special Regimen"=FILTER(06)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                        "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                                                                                                        "Code"=FILTER('05'|'11'|'12'|'13'|'14'|'15'))                                                                                                                                                                                                                                                                                                                        ELSE IF ("QuoSII Sales Special Regimen"=FILTER('11'|'12'|'13')) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                                  "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                                                                                                                                                                                                  "Code"=FILTER('06'|'07'|'08'|'15'))                                                                                                                                                                                                                                                                                                                                                                                                                  ELSE IF ("QuoSII Sales Special Regimen"=FILTER(03)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      "Code"=FILTER(01))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ELSE IF ("QuoSII Sales Special Regimen"=FILTER(01)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "Code"=FILTER('02'|'05'|'07'|'08'));
                                                   CaptionML=ENU='Special Regimen 1 AEAT',ESP='R‚gimen Especial 1 AEAT';
                                                   Description='QuoSII_1.4.2.042.04';


    }
    field(7174337;"QBU QuoSII Sales Special Regimen 2";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),
                                                                                                   "SII Entity"=CONST('AEAT'));
                                                   CaptionML=ENU='Special Regimen 2 AEAT',ESP='R‚gimen Especial 2 AEAT';
                                                   Description='QuoSII_1.4.2.042.04';


    }
    field(7174338;"QBU QuoSII Sales Special R. ATCN";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),
                                                                                                   "SII Entity"=CONST('ATCN'));
                                                   CaptionML=ENU='Special Regimen ATCN',ESP='R‚gimen Especial ATCN';
                                                   Description='QuoSII_1.4.2.042.04';


    }
    field(7174339;"QBU QuoSII Sales Special R. 1 ATCN";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),
                                                                                                   "SII Entity"=CONST('ATCN'));
                                                   CaptionML=ENU='Special Regimen 1 ATCN',ESP='R‚gimen Especial 1 ATCN';
                                                   Description='QuoSII_1.4.2.042.04';


    }
    field(7174340;"QBU QuoSII Sales Special R. 2 ATCN";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),
                                                                                                   "SII Entity"=CONST('ATCN'));
                                                   CaptionML=ENU='Special Regimen 2 ATCN',ESP='R‚gimen Especial 2 ATCN';
                                                   Description='QuoSII_1.4.2.042.04';


    }
    field(7174365;"QBU QFA Quofacturae endpoint";Code[20])
    {
        TableRelation="QuoFacturae endpoint"."Code";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Quofacturae endpoint',ESP='Punto de entrada de Quofacturae';
                                                   Description='QFA 0.3';


    }
    field(7207270;"QBU QW Withholding Group by GE";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("G.E"),
                                                                                                 "Use in"=FILTER('Customer'|'Booth'));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Withholding Group by G.E',ESP='Grupo retenciones por B.E.';
                                                   Description='QB 1.00 - QB22111,   JAV 19/08/19: - Se filtra para que sean retenciones de clientes o de ambos';


    }
    field(7207271;"QBU QW Withholding Group by PIT";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("PIT"));
                                                   CaptionML=ENU='Withholding Group by PIT',ESP='Grupo retenciones por IRPF';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207272;"QBU QW Withholding Amount PIT";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Withholding Movements"."Amount" WHERE ("Type"=CONST("Customer"),
                                                                                                         "Withholding Type"=CONST("PIT"),
                                                                                                         "No."=FIELD("No.")));
                                                   CaptionML=ENU='Withholding Amount PIT',ESP='Importe Retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207273;"QBU QW Withholding Pending GE";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Withholding Movements"."Amount" WHERE ("Type"=CONST("Customer"),
                                                                                                         "No."=FIELD("No."),
                                                                                                         "Open"=CONST(true),
                                                                                                         "Withholding Type"=CONST("G.E")));
                                                   CaptionML=ENU='Pending Withholding G.E. Amount',ESP='Importe Retenci¢n B.E. pdte.';
                                                   Description='QB 1.00 - JAV 18/10/19: - Suma de las retenciones de B.E. pendientes';
                                                   Editable=false;


    }
    field(7207274;"QBU Establishment Date";Date)
    {
        CaptionML=ENU='Establishment Date',ESP='Fecha de constituci¢n';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207275;"QBU Before The Notary";Text[50])
    {
        CaptionML=ENU='Before The Notary',ESP='Ante el notario';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207276;"QBU Protocol No.";Text[30])
    {
        CaptionML=ENU='Protocol No.',ESP='No. de protocolo';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207277;"QBU Commercial Register";Text[100])
    {
        CaptionML=ENU='Commercial Register',ESP='Registro mercantil';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207278;"QBU JV Dimension Code";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='JV Dimension Code',ESP='Cod. dimension UTE';
                                                   Description='QB 1.00 -';

trigger OnLookup();
    VAR
//                                                               QBTablePublisher@100000000 :
                                                              QBTablePublisher: Codeunit 7207346;
                                                            BEGIN 
                                                              QBTablePublisher.OnLookupJVDimensionCodeTCustomer(Rec); //QB
                                                            END;


    }
    field(7207279;"QBU Customer Type";Code[20])
    {
        TableRelation="TAux General Categories"."Code" WHERE ("Use In"=FILTER('All'|'Customers'));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Customer Type',ESP='Tipo de cliente';
                                                   Description='QB 1.00- KALAM GAP011    QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


    }
    field(7207280;"QBU First Surname";Text[30])
    {
        CaptionML=ENU='First Surname',ESP='Primer apellido';
                                                   Description='QB 1.00 -';


    }
    field(7207281;"QBU Second Surname";Text[30])
    {
        CaptionML=ENU='Second Surname',ESP='Segundo apellido';
                                                   Description='QB 1.00 -';


    }
    field(7207282;"QBU Receivable Bank No.";Code[20])
    {
        TableRelation="Bank Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Receivable Bank No.',ESP='N§ de banco de cobro';
                                                   Description='QB 1.00 - Q3707';


    }
    field(7207283;"QBU Generic Customer";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Generic Customer',ESP='Cliente Gen‚rico';
                                                   Description='QB 1.00 - QX7105';


    }
    field(7207284;"QBU Category";Code[20])
    {
        TableRelation="TAux General Categories" WHERE ("Use In"=FILTER('All'|'Customers'));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Customer Type',ESP='Categor¡a';
                                                   Description='QB 1.10.13 - JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';
                                                   CaptionClass='7206910,18,7207284';

trigger OnValidate();
    BEGIN 
                                                                IF ("QB Category" <> xRec."QB Category") THEN
                                                                  "QB Sub-Category" := '';
                                                              END;


    }
    field(7207285;"QBU Referring of Customer";Code[20])
    {
        TableRelation=Contact."No." WHERE ("Tipo Referente"=FILTER(<>0));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Referring of Customer',ESP='Referente del cliente';
                                                   Description='QB 1.00 - ANDRASA 08/02/19 JAV - Referente del Cliente Andrasa (Administrador, Arquitecto)';

trigger OnValidate();
    VAR
//                                                                 DefaultDimension@1100286000 :
                                                                DefaultDimension: Record 352;
//                                                                 Contacto@1100286002 :
                                                                Contacto: Record 5050;
//                                                                 FunctionQB@1100286001 :
                                                                FunctionQB: Codeunit 7207272;
                                                              BEGIN 
                                                                IF (FunctionQB.QB_UseReferents) AND (FunctionQB.ReturnDimReferents <> '') THEN BEGIN 
                                                                  IF Contacto.GET("QB Referring of Customer") THEN BEGIN 
                                                                    IF (Contacto."Valor Dimension" <> '') THEN BEGIN 
                                                                      IF DefaultDimension.GET(DATABASE::Customer, "No.", FunctionQB.ReturnDimReferents) THEN BEGIN 
                                                                        DefaultDimension."Dimension Value Code" := Contacto."Valor Dimension";
                                                                        DefaultDimension.MODIFY;
                                                                      END ELSE BEGIN 
                                                                        DefaultDimension.INIT;
                                                                        DefaultDimension."Table ID" := DATABASE::Customer;
                                                                        DefaultDimension."No." := "No.";
                                                                        DefaultDimension."Dimension Code" := FunctionQB.ReturnDimReferents;
                                                                        DefaultDimension."Dimension Value Code" := Contacto."Valor Dimension";
                                                                        DefaultDimension.INSERT;
                                                                      END;
                                                                    END;
                                                                  END;
                                                                END;
                                                              END;


    }
    field(7207286;"QBU Representative 1";Code[20])
    {
        TableRelation="Contact";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Nombre representante 1',ESP='Representante 1';
                                                   Description='QB 1.00 - QB2511 JAV 18/03/20: - Se pasan los representantes a contactos';

trigger OnValidate();
    VAR
//                                                                 Cont@100000001 :
                                                                Cont: Record 5050;
//                                                                 ContBusRel@100000000 :
                                                                ContBusRel: Record 5054;
//                                                                 Txt001@100000002 :
                                                                Txt001: TextConst ESP='No puede usar el mismo contacto en ambos representantes';
                                                              BEGIN 
                                                                IF "QB Representative 1" <> '' THEN BEGIN 
                                                                  Cont.GET("QB Representative 1");
                                                                  ContBusRel.FindOrRestoreContactBusinessRelation(Cont,Rec,ContBusRel."Link to Table"::Customer);
                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    ERROR(Text003,Cont."No.",Cont.Name,"No.",Name);
                                                                END;

                                                                IF ("QB Representative 1" <> '') AND ("QB Representative 1" = "QB Representative 2") THEN
                                                                  ERROR(Txt001);
                                                                CALCFIELDS("QB Representative 1 Name");
                                                              END;

trigger OnLookup();
    VAR
//                                                               Cont@100000002 :
                                                              Cont: Record 5050;
//                                                               ContBusRel@100000001 :
                                                              ContBusRel: Record 5054;
//                                                               TempCust@100000000 :
                                                              TempCust: Record 18 TEMPORARY;
                                                            BEGIN 
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FINDFIRST THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("No.",'');

                                                              IF "QB Representative 1" <> '' THEN
                                                                IF Cont.GET("QB Representative 1") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN 
                                                                TempCust.COPY(Rec);
                                                                FIND;
                                                                TRANSFERFIELDS(TempCust,FALSE);
                                                                VALIDATE("QB Representative 1",Cont."No.");
                                                              END;
                                                            END;


    }
    field(7207287;"QBU Representative 1 Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Contact"."Name" WHERE ("No."=FIELD("QB Representative 1")));
                                                   CaptionML=ENU='Nombre representante 1',ESP='Nombre Representante 1';
                                                   Description='QB 1.00 - QB2511 JAV 18/03/20: - Se pasan los representantes a contactos';
                                                   Editable=false;


    }
    field(7207288;"QBU Representative 2";Code[20])
    {
        TableRelation="Contact";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Nombre representante 1',ESP='Representante 2';
                                                   Description='QB 1.00 - QB2511 JAV 18/03/20: - Se pasan los representantes a contactos';

trigger OnValidate();
    VAR
//                                                                 Cont@100000001 :
                                                                Cont: Record 5050;
//                                                                 ContBusRel@100000000 :
                                                                ContBusRel: Record 5054;
//                                                                 Txt001@100000002 :
                                                                Txt001: TextConst ESP='No puede usar el mismo contacto en ambos representantes';
                                                              BEGIN 
                                                                IF "QB Representative 2" <> '' THEN BEGIN 
                                                                  Cont.GET("QB Representative 2");
                                                                  ContBusRel.FindOrRestoreContactBusinessRelation(Cont,Rec,ContBusRel."Link to Table"::Customer);
                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    ERROR(Text003,Cont."No.",Cont.Name,"No.",Name);
                                                                END;

                                                                IF ("QB Representative 2" <> '') AND ("QB Representative 1" = "QB Representative 2") THEN
                                                                  ERROR(Txt001);
                                                                CALCFIELDS("QB Representative 2 Name");
                                                              END;

trigger OnLookup();
    VAR
//                                                               Cont@100000002 :
                                                              Cont: Record 5050;
//                                                               ContBusRel@100000001 :
                                                              ContBusRel: Record 5054;
//                                                               TempCust@100000000 :
                                                              TempCust: Record 18 TEMPORARY;
                                                            BEGIN 
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FINDFIRST THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("No.",'');

                                                              IF "QB Representative 2" <> '' THEN
                                                                IF Cont.GET("QB Representative 2") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN 
                                                                TempCust.COPY(Rec);
                                                                FIND;
                                                                TRANSFERFIELDS(TempCust,FALSE);
                                                                VALIDATE("QB Representative 2",Cont."No.");
                                                              END;
                                                            END;


    }
    field(7207289;"QBU Representative 2 Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Contact"."Name" WHERE ("No."=FIELD("QB Representative 2")));
                                                   CaptionML=ENU='Nombre representante 1',ESP='Nombre Representante 2';
                                                   Description='QB 1.00 - QB2511 JAV 18/03/20: - Se pasan los representantes a contactos';
                                                   Editable=false;


    }
    field(7207292;"QBU Third No.";Code[20])
    {
        TableRelation=Contact WHERE ("Type"=CONST("Company"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Related Vendor No.',ESP='C¢digo de Tercero';
                                                   Description='QB 1.06.15 - JAV 25/09/20: - ORTIZ GFGAP029 [TT] Este campo relaciona al cliente con un tercero, que ser  cliente, proveedor o banco';


    }
    field(7207306;"QBU Sub-Category";Code[20])
    {
        TableRelation="QB TAux General Sub-Categories"."Code" WHERE ("Categorie"=FIELD("QB Category"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Customer Type',ESP='Sub-Categor¡a';
                                                   Description='QB 1.06 - ORTIZ GFGAP015 QB 1.10.13 - JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';
                                                   CaptionClass='7206910,18,7207306';


    }
    field(7207307;"QBU Prepayment Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Prepayment"."Amount" WHERE ("Account Type"=CONST("Customer"),
                                                                                                 "Account No."=FIELD("No.")));
                                                   CaptionML=ENU='Amount',ESP='Importe Anticipos Pendientes';
                                                   Description='QB 1.06 - ORTIZ OBGAP012';
                                                   Editable=false;


    }
    field(7207308;"QBU Prepayment Amount (LCY)";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Prepayment"."Amount (LCY)" WHERE ("Account Type"=CONST("Customer"),
                                                                                                         "Account No."=FIELD("No.")));
                                                   CaptionML=ENU='Amount (LCY)',ESP='Importe Anticipos Pendientes (DL)';
                                                   Description='QB 1.06 - ORTIZ OBGAP012';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(7207496;"QBU Data Missed";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Data Missed';
                                                   Description='QB 1.00 - ELECNOR GEN001-02';
                                                   Editable=false;


    }
    field(7207497;"QBU Data Missed Message";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Data Missed Message',ESP='Datos Obligatorios que faltan';
                                                   Description='QB 1.00 - ELECNOR GEN001-02';
                                                   Editable=false;


    }
    field(7207498;"QBU Data Missed Old Blocked";Option)
    {
        OptionMembers=" ","Ship","Invoice","All";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Last Blocked';
                                                   OptionCaptionML=ENU='" ,Ship,Invoice,All"',ESP='" ,Env¡ar,Facturar,Todos"';
                                                   
                                                   Description='QB 1.00 - ELECNOR GEN001-02' ;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Search Name")
  //  {
       /* ;
 */
   // }
   // key(key3;"Customer Posting Group")
  //  {
       /* ;
 */
   // }
   // key(key4;"Currency Code")
  //  {
       /* ;
 */
   // }
   // key(key5;"Country/Region Code")
  //  {
       /* ;
 */
   // }
   // key(key6;"Gen. Bus. Posting Group")
  //  {
       /* ;
 */
   // }
   // key(key7;"Name","Address","City")
  //  {
       /* ;
 */
   // }
   // key(key8;"VAT Registration No.")
  //  {
       /* ;
 */
   // }
   // key(key9;"Name")
  //  {
       /* ;
 */
   // }
   // key(key10;"City")
  //  {
       /* ;
 */
   // }
   // key(key11;"Post Code")
  //  {
       /* ;
 */
   // }
   // key(key12;"Phone No.")
  //  {
       /* ;
 */
   // }
   // key(key13;"Contact")
  //  {
       /* ;
 */
   // }
   // key(key14;"Blocked")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"No.","Name","City","Post Code","Phone No.","Contact","VAT Registration No.")
   // {
       // 
   // }
   // fieldgroup(Brick;"No.","Name","Balance (LCY)","Contact","Balance Due (LCY)","Image")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='You cannot delete %1 %2 because there is at least one outstanding Sales %3 for this customer.',ESP='No puede borrar %1 %2 porque hay al menos una venta pendiente %3 para este cliente.';
//       Text002@1001 :
      Text002: TextConst ENU='Do you wish to create a contact for %1 %2?',ESP='¨Confirma que desea crear un contacto para %1 %2?';
//       SalesSetup@1002 :
      SalesSetup: Record 311;
//       CommentLine@1004 :
      CommentLine: Record 97;
//       SalesOrderLine@1005 :
      SalesOrderLine: Record 37;
//       CustBankAcc@1006 :
      CustBankAcc: Record 287;
//       ShipToAddr@1007 :
      ShipToAddr: Record 222;
//       PostCode@1008 :
      PostCode: Record 225;
//       GenBusPostingGrp@1009 :
      GenBusPostingGrp: Record 250;
//       ShippingAgentService@1010 :
      ShippingAgentService: Record 5790;
//       ItemCrossReference@1016 :
//      ItemCrossReference: Record 5717;
//       RMSetup@1018 :
      RMSetup: Record 5079;
//       SalesPrice@1021 :
      SalesPrice: Record 7002;
//       SalesLineDisc@1022 :
      SalesLineDisc: Record 7004;
//       SalesPrepmtPct@1003 :
      SalesPrepmtPct: Record 459;
//       ServContract@1026 :
      ServContract: Record 5965;
//       ServiceItem@1027 :
      ServiceItem: Record 5940;
//       SalespersonPurchaser@1060 :
      SalespersonPurchaser: Record 13;
//       CustomizedCalendarChange@1048 :
      CustomizedCalendarChange: Record 7602;
//       CustPmtAddress@1100000 :
      CustPmtAddress: Record 7000014;
//       PaymentToleranceMgt@1038 :
      PaymentToleranceMgt: Codeunit 426;
//       IdentityManagement@1047 :
      IdentityManagement: Codeunit 9801;
//       NoSeriesMgt@1011 :
      NoSeriesMgt: Codeunit 396;
//       MoveEntries@1012 :
      MoveEntries: Codeunit 361;
//       UpdateContFromCust@1013 :
      UpdateContFromCust: Codeunit 5056;
//       DimMgt@1014 :
      DimMgt: Codeunit 408;
//       ApprovalsMgmt@1039 :
      ApprovalsMgmt: Codeunit 1535;
//       CalendarManagement@1049 :
      CalendarManagement: Codeunit 7600;
//       InsertFromContact@1015 :
      InsertFromContact: Boolean;
//       Text003@1020 :
      Text003: TextConst ENU='Contact %1 %2 is not related to customer %3 %4.',ESP='Contacto %1 %2 no est  relacionado con cliente %3 %4.';
//       Text004@1023 :
      Text004: TextConst ENU='post',ESP='registrar';
//       Text005@1024 :
      Text005: TextConst ENU='create',ESP='crear';
//       Text006@1025 :
      Text006: TextConst ENU='You cannot %1 this type of document when Customer %2 is blocked with type %3',ESP='No puede %1 este tipo de documento cuando el cliente %2 est  bloqueado por el tipo %3';
//       Text007@1028 :
      Text007: TextConst ENU='You cannot delete %1 %2 because there is at least one not cancelled Service Contract for this customer.',ESP='No puede borrar %1 %2 por que hay al menos un contrato de servicio no cancelado para este cliente.';
//       Text008@1029 :
      Text008: TextConst ENU='Deleting the %1 %2 will cause the %3 to be deleted for the associated Service Items. Do you want to continue?',ESP='Eliminar el %1 %2 har  que se elimine el %3 de los Prods. servicio asociados. ¨Desea continuar?';
//       Text009@1030 :
      Text009: TextConst ENU='Cannot delete customer.',ESP='No se puede eliminar el cliente.';
//       Text010@1031 :
      Text010: TextConst ENU='The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3. Enter another code.',ESP='%1 %2 se asign¢ a %3 %4.\No es posible seleccionar de nuevo %1 para m s de un %3. Introduzca otro c¢digo.';
//       Text011@1033 :
      Text011: TextConst ENU='Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?',ESP='El control de transacciones de IC puede ser dif¡cil si cambia el campo C¢digo socio IC porque este %1 contiene movimientos contables de un ejercicio que a£n no est  cerrado.\ ¨Todav¡a quiere cambiar el campo C¢digo socio IC?';
//       Text012@1032 :
      Text012: TextConst ENU='You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.',ESP='No puede cambiar el contenido del campo %1. %2 contiene al menos un movimiento contable abierto.';
//       Text013@1035 :
      Text013: TextConst ENU='You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.',ESP='No puede eliminar %1 %2 porque hay al menos un servicio pendiente %3 para este cliente.';
//       Text014@1017 :
      Text014: TextConst ENU='Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.',ESP='Para poder usar Online Map, primero debe rellenar la ventana Configuraci¢n Online Map.\Consulte Configuraci¢n de Online Map en la Ayuda.';
//       Text015@1036 :
      Text015: TextConst ENU='You cannot delete %1 %2 because there is at least one %3 associated to this customer.',ESP='No puede borrar %1 %2 porque existe al menos un %3 asociado a este cliente.';
//       AllowPaymentToleranceQst@1037 :
      AllowPaymentToleranceQst: TextConst ENU='Do you want to allow payment tolerance for entries that are currently open?',ESP='¨Desea permitir la tolerancia de pago para movimientos pendientes?';
//       RemovePaymentRoleranceQst@1019 :
      RemovePaymentRoleranceQst: TextConst ENU='Do you want to remove payment tolerance from entries that are currently open?',ESP='¨Confirma que desea eliminar la tolerancia pago de los movimientos actualmente pendientes?';
//       CreateNewCustTxt@1041 :
      CreateNewCustTxt: 
// "%1 is the name to be used to create the customer. "
TextConst ENU='Create a new customer card for %1',ESP='Crear una nueva ficha cliente para %1';
//       SelectCustErr@1040 :
      SelectCustErr: TextConst ENU='You must select an existing customer.',ESP='Debe seleccionar un cliente existente.';
//       CustNotRegisteredTxt@1042 :
      CustNotRegisteredTxt: TextConst ENU='This customer is not registered. To continue, choose one of the following options:',ESP='Este cliente no est  registrado. Para continuar, elija una de las opciones siguientes:';
//       SelectCustTxt@1043 :
      SelectCustTxt: TextConst ENU='Select an existing customer',ESP='Seleccionar un cliente existente';
//       InsertFromTemplate@1044 :
      InsertFromTemplate: Boolean;
//       LookupRequested@1034 :
      LookupRequested: Boolean;
//       OverrideImageQst@1045 :
      OverrideImageQst: TextConst ENU='Override Image?',ESP='¨Reemplazar la imagen?';
//       PrivacyBlockedActionErr@1061 :
      PrivacyBlockedActionErr: 
// "%1 = action (create or post), %2 = customer code."
TextConst ENU='You cannot %1 this type of document when Customer %2 is blocked for privacy.',ESP='No puede %1 este tipo de documento cuando el cliente %2 est  bloqueado por motivos de privacidad.';
//       PrivacyBlockedGenericTxt@1062 :
      PrivacyBlockedGenericTxt: 
// "%1 = customer code"
TextConst ENU='Privacy Blocked must not be true for customer %1.',ESP='La opci¢n Privacidad bloqueada no debe ser verdadera para el cliente %1.';
//       ConfirmBlockedPrivacyBlockedQst@1071 :
      ConfirmBlockedPrivacyBlockedQst: TextConst ENU='if you change the Blocked field, the Privacy Blocked field is changed to No. Do you want to continue?',ESP='Si cambia el campo Bloqueado, se cambiar  el campo Privacidad bloqueada a No. ¨Desea continuar?';
//       CanNotChangeBlockedDueToPrivacyBlockedErr@1072 :
      CanNotChangeBlockedDueToPrivacyBlockedErr: TextConst ENU='The Blocked field cannot be changed because the user is blocked for privacy reasons.',ESP='No se puede cambiar el campo Bloqueado porque el usuario est  bloqueado por motivos de privacidad.';
//       PhoneNoCannotContainLettersErr@1046 :
      PhoneNoCannotContainLettersErr: TextConst ENU='You cannot enter letters in this field.',ESP='No puede introducir letras en este campo.';

    
    


/*
trigger OnInsert();    begin
               if "No." = '' then begin
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD("Customer Nos.");
                 NoSeriesMgt.InitSeries(SalesSetup."Customer Nos.",xRec."No. Series",0D,"No.","No. Series");
               end;

               if "Invoice Disc. Code" = '' then
                 "Invoice Disc. Code" := "No.";

               "Payment Days Code" := "No.";
               "Non-Paymt. Periods Code" := "No.";

               if not (InsertFromContact or (InsertFromTemplate and (Contact <> '')) or ISTEMPORARY) then
                 UpdateContFromCust.OnInsert(Rec);

               if "Salesperson Code" = '' then
                 SetDefaultSalesperson;

               DimMgt.UpdateDefaultDim(
                 DATABASE::Customer,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");

               UpdateReferencedIds;
               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnModify();    begin
               UpdateReferencedIds;
               SetLastModifiedDateTime;
               if IsContactUpdateNeeded then begin
                 MODIFY;
                 UpdateContFromCust.OnModify(Rec);
                 if not FIND then begin
                   RESET;
                   if FIND then;
                 end;
               end;
             end;


*/

/*
trigger OnDelete();    var
//                CampaignTargetGr@1000 :
               CampaignTargetGr: Record 7030;
//                ContactBusRel@1001 :
               ContactBusRel: Record 5054;
//                Job@1004 :
               Job: Record 167;
//                SocialListeningSearchTopic@1007 :
               SocialListeningSearchTopic: Record 871;
//                StdCustSalesCode@1003 :
               StdCustSalesCode: Record 172;
//                CustomReportSelection@1008 :
               CustomReportSelection: Record 9657;
//                MyCustomer@1005 :
               MyCustomer: Record 9150;
//                ServHeader@1009 :
               ServHeader: Record 5900;
//                CampaignTargetGrMgmt@1002 :
               CampaignTargetGrMgmt: Codeunit 7030;
//                VATRegistrationLogMgt@1006 :
               VATRegistrationLogMgt: Codeunit 249;
//                ConfirmManagement@1010 :
               ConfirmManagement: Codeunit 27;
//                DocumentMove@1100000 :
               DocumentMove: Codeunit 7000004;
             begin
               ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);

               ServiceItem.SETRANGE("Customer No.","No.");
               if ServiceItem.FINDFIRST then
                 if ConfirmManagement.ConfirmProcess(
                      STRSUBSTNO(Text008,TABLECAPTION,"No.",ServiceItem.FIELDCAPTION("Customer No.")),TRUE)
                 then
                   ServiceItem.MODIFYALL("Customer No.",'')
                 else
                   ERROR(Text009);

               Job.SETRANGE("Bill-to Customer No.","No.");
               if not Job.ISEMPTY then
                 ERROR(Text015,TABLECAPTION,"No.",Job.TABLECAPTION);

               MoveEntries.MoveCustEntries(Rec);

               DocumentMove.MoveReceivableDocs(Rec);

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Customer);
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               CustBankAcc.SETRANGE("Customer No.","No.");
               CustBankAcc.DELETEALL;

               ShipToAddr.SETRANGE("Customer No.","No.");
               ShipToAddr.DELETEALL;

               SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::Customer);
               SalesPrice.SETRANGE("Sales Code","No.");
               SalesPrice.DELETEALL;

               SalesLineDisc.SETRANGE("Sales Type",SalesLineDisc."Sales Type"::Customer);
               SalesLineDisc.SETRANGE("Sales Code","No.");
               SalesLineDisc.DELETEALL;

               SalesPrepmtPct.SETCURRENTKEY("Sales Type","Sales Code");
               SalesPrepmtPct.SETRANGE("Sales Type",SalesPrepmtPct."Sales Type"::Customer);
               SalesPrepmtPct.SETRANGE("Sales Code","No.");
               SalesPrepmtPct.DELETEALL;

               StdCustSalesCode.SETRANGE("Customer No.","No.");
               StdCustSalesCode.DELETEALL(TRUE);

               CustPmtAddress.SETRANGE("Customer No.","No.");
               if CustPmtAddress.FINDFIRST then
                 CustPmtAddress.DELETEALL;

               ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
               ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Customer);
               ItemCrossReference.SETRANGE("Cross-Reference Type No.","No.");
               ItemCrossReference.DELETEALL;

               if not SocialListeningSearchTopic.ISEMPTY then begin
                 SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Customer,"No.");
                 SocialListeningSearchTopic.DELETEALL;
               end;

               SalesOrderLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
               SalesOrderLine.SETRANGE("Bill-to Customer No.","No.");
               if SalesOrderLine.FINDFIRST then
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.",SalesOrderLine."Document Type");

               SalesOrderLine.SETRANGE("Bill-to Customer No.");
               SalesOrderLine.SETRANGE("Sell-to Customer No.","No.");
               if SalesOrderLine.FINDFIRST then
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.",SalesOrderLine."Document Type");

               CampaignTargetGr.SETRANGE("No.","No.");
               CampaignTargetGr.SETRANGE(Type,CampaignTargetGr.Type::Customer);
               if CampaignTargetGr.FIND('-') then begin
                 ContactBusRel.SETRANGE("Link to Table",ContactBusRel."Link to Table"::Customer);
                 ContactBusRel.SETRANGE("No.","No.");
                 ContactBusRel.FINDFIRST;
                 repeat
                   CampaignTargetGrMgmt.ConverttoContact(Rec,ContactBusRel."Contact No.");
                 until CampaignTargetGr.NEXT = 0;
               end;

               ServContract.SETFILTER(Status,'<>%1',ServContract.Status::Canceled);
               ServContract.SETRANGE("Customer No.","No.");
               if not ServContract.ISEMPTY then
                 ERROR(
                   Text007,
                   TABLECAPTION,"No.");

               ServContract.SETRANGE(Status);
               ServContract.MODIFYALL("Customer No.",'');

               ServContract.SETFILTER(Status,'<>%1',ServContract.Status::Canceled);
               ServContract.SETRANGE("Bill-to Customer No.","No.");
               if not ServContract.ISEMPTY then
                 ERROR(
                   Text007,
                   TABLECAPTION,"No.");

               ServContract.SETRANGE(Status);
               ServContract.MODIFYALL("Bill-to Customer No.",'');

               ServHeader.SETCURRENTKEY("Customer No.","Order Date");
               ServHeader.SETRANGE("Customer No.","No.");
               if ServHeader.FINDFIRST then
                 ERROR(
                   Text013,
                   TABLECAPTION,"No.",ServHeader."Document Type");

               ServHeader.SETRANGE("Bill-to Customer No.");
               if ServHeader.FINDFIRST then
                 ERROR(
                   Text013,
                   TABLECAPTION,"No.",ServHeader."Document Type");

               UpdateContFromCust.OnDelete(Rec);

               CustomReportSelection.SETRANGE("Source Type",DATABASE::Customer);
               CustomReportSelection.SETRANGE("Source No.","No.");
               CustomReportSelection.DELETEALL;

               MyCustomer.SETRANGE("Customer No.","No.");
               MyCustomer.DELETEALL;
               VATRegistrationLogMgt.DeleteCustomerLog(Rec);

               DimMgt.DeleteDefaultDim(DATABASE::Customer,"No.");

               CalendarManagement.DeleteCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::Customer,"No.");
             end;


*/

/*
trigger OnRename();    var
//                CustomerTemplate@1000 :
               CustomerTemplate: Record 5105;
             begin
               ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);
               DimMgt.RenameDefaultDim(DATABASE::Customer,xRec."No.","No.");

               SetLastModifiedDateTime;
               if xRec."Invoice Disc. Code" = xRec."No." then
                 "Invoice Disc. Code" := "No.";
               CustomerTemplate.SETRANGE("Invoice Disc. Code",xRec."No.");
               CustomerTemplate.MODIFYALL("Invoice Disc. Code","No.");

               CalendarManagement.RenameCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::Customer,"No.",xRec."No.");
             end;

*/



// procedure AssistEdit (OldCust@1000 :

/*
procedure AssistEdit (OldCust: Record 18) : Boolean;
    var
//       Cust@1001 :
      Cust: Record 18;
    begin
      WITH Cust DO begin
        Cust := Rec;
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Customer Nos.");
        if NoSeriesMgt.SelectSeries(SalesSetup."Customer Nos.",OldCust."No. Series","No. Series") then begin
          NoSeriesMgt.SetSeries("No.");
          Rec := Cust;
          exit(TRUE);
        end;
      end;
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Customer,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    end;
*/


    
    
/*
procedure ShowContact ()
    var
//       ContBusRel@1000 :
      ContBusRel: Record 5054;
//       Cont@1001 :
      Cont: Record 5050;
//       OfficeContact@1002 :
      OfficeContact: Record 5050;
//       OfficeMgt@1003 :
      OfficeMgt: Codeunit 1630;
//       ConfirmManagement@1004 :
      ConfirmManagement: Codeunit 27;
    begin
      if OfficeMgt.GetContact(OfficeContact,"No.") and (OfficeContact.COUNT = 1) then
        PAGE.RUN(PAGE::"Contact Card",OfficeContact)
      else begin
        if "No." = '' then
          exit;

        ContBusRel.SETCURRENTKEY("Link to Table","No.");
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
        ContBusRel.SETRANGE("No.","No.");
        if not ContBusRel.FINDFIRST then begin
          if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text002,TABLECAPTION,"No."),TRUE) then
            exit;
          UpdateContFromCust.InsertNewContact(Rec,FALSE);
          ContBusRel.FINDFIRST;
        end;
        COMMIT;

        Cont.FILTERGROUP(2);
        Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
        if Cont.ISEMPTY then begin
          Cont.SETRANGE("Company No.");
          Cont.SETRANGE("No.",ContBusRel."Contact No.");
        end;
        PAGE.RUN(PAGE::"Contact List",Cont);
      end;
    end;
*/


    
//     procedure SetInsertFromContact (FromContact@1000 :
    
/*
procedure SetInsertFromContact (FromContact: Boolean)
    begin
      InsertFromContact := FromContact;
    end;
*/


    
//     procedure CheckBlockedCustOnDocs (Cust2@1000 : Record 18;DocType@1001 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';Shipment@1005 : Boolean;Transaction@1003 :
    
/*
procedure CheckBlockedCustOnDocs (Cust2: Record 18;DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";Shipment: Boolean;Transaction: Boolean)
    begin
      WITH Cust2 DO begin
        if "Privacy Blocked" then
          CustPrivacyBlockedErrorMessage(Cust2,Transaction);

        if ((Blocked = Blocked::All) or
            ((Blocked = Blocked::Invoice) and
             (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"])) or
            ((Blocked = Blocked::Ship) and (DocType IN [DocType::Quote,DocType::Order,DocType::"Blanket Order"]) and
             (not Transaction)) or
            ((Blocked = Blocked::Ship) and (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"]) and
             Shipment and Transaction))
        then
          CustBlockedErrorMessage(Cust2,Transaction);
      end;
    end;
*/


    
//     procedure CheckBlockedCustOnJnls (Cust2@1003 : Record 18;DocType@1002 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';Transaction@1000 :
    
/*
procedure CheckBlockedCustOnJnls (Cust2: Record 18;DocType: Option " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund";Transaction: Boolean)
    begin
      WITH Cust2 DO begin
        if "Privacy Blocked" then
          CustPrivacyBlockedErrorMessage(Cust2,Transaction);

        if (Blocked = Blocked::All) or
           ((Blocked = Blocked::Invoice) and (DocType IN [DocType::Invoice,DocType::" "]))
        then
          CustBlockedErrorMessage(Cust2,Transaction)
      end;
    end;
*/


    
//     procedure CustBlockedErrorMessage (Cust2@1001 : Record 18;Transaction@1000 :
    
/*
procedure CustBlockedErrorMessage (Cust2: Record 18;Transaction: Boolean)
    var
//       Action@1002 :
      Action: Text[30];
    begin
      if Transaction then
        Action := Text004
      else
        Action := Text005;
      ERROR(Text006,Action,Cust2."No.",Cust2.Blocked);
    end;
*/


    
//     procedure CustPrivacyBlockedErrorMessage (Cust2@1001 : Record 18;Transaction@1000 :
    
/*
procedure CustPrivacyBlockedErrorMessage (Cust2: Record 18;Transaction: Boolean)
    var
//       Action@1002 :
      Action: Text[30];
    begin
      if Transaction then
        Action := Text004
      else
        Action := Text005;

      ERROR(PrivacyBlockedActionErr,Action,Cust2."No.");
    end;
*/


    
//     procedure GetPrivacyBlockedGenericErrorText (Cust2@1001 :
    
/*
procedure GetPrivacyBlockedGenericErrorText (Cust2: Record 18) : Text[250];
    begin
      exit(STRSUBSTNO(PrivacyBlockedGenericTxt,Cust2."No."));
    end;
*/


    
    
/*
procedure DisplayMap ()
    var
//       MapPoint@1001 :
      MapPoint: Record 800;
//       MapMgt@1000 :
      MapMgt: Codeunit 802;
    begin
      if MapPoint.FINDFIRST then
        MapMgt.MakeSelection(DATABASE::Customer,GETPOSITION)
      else
        MESSAGE(Text014);
    end;
*/


    
    
/*
procedure GetTotalAmountLCY () : Decimal;
    begin
      CALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped not Invoiced (LCY)","Outstanding Invoices (LCY)",
        "Outstanding Serv. Orders (LCY)","Serv Shipped not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");

      exit(GetTotalAmountLCYCommon);
    end;
*/


    
    
/*
procedure GetTotalAmountLCYUI () : Decimal;
    begin
      SETAUTOCALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped not Invoiced (LCY)","Outstanding Invoices (LCY)",
        "Outstanding Serv. Orders (LCY)","Serv Shipped not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");

      exit(GetTotalAmountLCYCommon);
    end;
*/


    
/*
LOCAL procedure GetTotalAmountLCYCommon () : Decimal;
    var
//       SalesLine@1000 :
      SalesLine: Record 37;
//       ServiceLine@1002 :
      ServiceLine: Record 5902;
//       SalesOutstandingAmountFromShipment@1001 :
      SalesOutstandingAmountFromShipment: Decimal;
//       ServOutstandingAmountFromShipment@1003 :
      ServOutstandingAmountFromShipment: Decimal;
//       InvoicedPrepmtAmountLCY@1004 :
      InvoicedPrepmtAmountLCY: Decimal;
//       RetRcdNotInvAmountLCY@1006 :
      RetRcdNotInvAmountLCY: Decimal;
    begin
      SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment("No.");
      ServOutstandingAmountFromShipment := ServiceLine.OutstandingInvoiceAmountFromShipment("No.");
      InvoicedPrepmtAmountLCY := GetInvoicedPrepmtAmountLCY;
      RetRcdNotInvAmountLCY := GetReturnRcdNotInvAmountLCY;

      exit("Balance (LCY)" + "Outstanding Orders (LCY)" + "Shipped not Invoiced (LCY)" + "Outstanding Invoices (LCY)" +
        "Outstanding Serv. Orders (LCY)" + "Serv Shipped not Invoiced(LCY)" + "Outstanding Serv.Invoices(LCY)" -
        SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment - InvoicedPrepmtAmountLCY - RetRcdNotInvAmountLCY);
    end;
*/


    
    
/*
procedure GetSalesLCY () : Decimal;
    var
//       CustomerSalesYTD@1005 :
      CustomerSalesYTD: Record 18;
//       AccountingPeriod@1004 :
      AccountingPeriod: Record 50;
//       StartDate@1001 :
      StartDate: Date;
//       EndDate@1000 :
      EndDate: Date;
    begin
      StartDate := AccountingPeriod.GetFiscalYearStartDate(WORKDATE);
      EndDate := AccountingPeriod.GetFiscalYearEndDate(WORKDATE);
      CustomerSalesYTD := Rec;
      CustomerSalesYTD."SECURITYFILTERING"("SECURITYFILTERING");
      CustomerSalesYTD.SETRANGE("Date Filter",StartDate,EndDate);
      CustomerSalesYTD.CALCFIELDS("Sales (LCY)");
      exit(CustomerSalesYTD."Sales (LCY)");
    end;
*/


    
    
/*
procedure CalcAvailableCredit () : Decimal;
    begin
      exit(CalcAvailableCreditCommon(FALSE));
    end;
*/


    
    
/*
procedure CalcAvailableCreditUI () : Decimal;
    begin
      exit(CalcAvailableCreditCommon(TRUE));
    end;
*/


//     LOCAL procedure CalcAvailableCreditCommon (CalledFromUI@1000 :
    
/*
LOCAL procedure CalcAvailableCreditCommon (CalledFromUI: Boolean) : Decimal;
    begin
      if "Credit Limit (LCY)" = 0 then
        exit(0);
      if CalledFromUI then
        exit("Credit Limit (LCY)" - GetTotalAmountLCYUI);
      exit("Credit Limit (LCY)" - GetTotalAmountLCY);
    end;
*/


    
    
/*
procedure CalcOverdueBalance () OverDueBalance : Decimal;
    var
//       CustLedgEntryRemainAmtQuery@1000 :
      CustLedgEntryRemainAmtQuery: Query 21 SECURITYFILTERING(Filtered);
    begin
      CustLedgEntryRemainAmtQuery.SETRANGE(Customer_No,"No.");
      CustLedgEntryRemainAmtQuery.SETRANGE(IsOpen,TRUE);
      CustLedgEntryRemainAmtQuery.SETFILTER(Due_Date,'<%1',WORKDATE);
      CustLedgEntryRemainAmtQuery.OPEN;

      if CustLedgEntryRemainAmtQuery.READ then
        OverDueBalance := CustLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    end;
*/


    
    
/*
procedure GetLegalEntityType () : Text;
    begin
      exit(FORMAT("Partner Type"));
    end;
*/


    
    
/*
procedure GetLegalEntityTypeLbl () : Text;
    begin
      exit(FIELDCAPTION("Partner Type"));
    end;
*/


    
    
/*
procedure SetStyle () : Text;
    begin
      if CalcAvailableCredit < 0 then
        exit('Unfavorable');
      exit('');
    end;
*/


    
//     procedure HasValidDDMandate (Date@1000 :
    
/*
procedure HasValidDDMandate (Date: Date) : Boolean;
    var
//       SEPADirectDebitMandate@1001 :
      SEPADirectDebitMandate: Record 1230;
    begin
      exit(SEPADirectDebitMandate.GetDefaultMandate("No.",Date) <> '');
    end;
*/


    
    
/*
procedure GetReturnRcdNotInvAmountLCY () : Decimal;
    var
//       SalesLine@1000 :
      SalesLine: Record 37;
    begin
      SalesLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::"Return Order");
      SalesLine.SETRANGE("Bill-to Customer No.","No.");
      SalesLine.CALCSUMS("Return Rcd. not Invd. (LCY)");
      exit(SalesLine."Return Rcd. not Invd. (LCY)");
    end;
*/


    
    
/*
procedure GetInvoicedPrepmtAmountLCY () : Decimal;
    var
//       SalesLine@1000 :
      SalesLine: Record 37;
    begin
      SalesLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
      SalesLine.SETRANGE("Bill-to Customer No.","No.");
      SalesLine.CALCSUMS("Prepmt. Amount Inv. (LCY)","Prepmt. VAT Amount Inv. (LCY)");
      exit(SalesLine."Prepmt. Amount Inv. (LCY)" + SalesLine."Prepmt. VAT Amount Inv. (LCY)");
    end;
*/


    
    
/*
procedure CalcCreditLimitLCYExpendedPct () : Decimal;
    begin
      if "Credit Limit (LCY)" = 0 then
        exit(0);

      if "Balance (LCY)" / "Credit Limit (LCY)" < 0 then
        exit(0);

      if "Balance (LCY)" / "Credit Limit (LCY)" > 1 then
        exit(10000);

      exit(ROUND("Balance (LCY)" / "Credit Limit (LCY)" * 10000,1));
    end;
*/


    
    
/*
procedure CreateAndShowNewInvoice ()
    var
//       SalesHeader@1000 :
      SalesHeader: Record 36;
    begin
      SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.SetDefaultPaymentServices;
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Sales Invoice",SalesHeader)
    end;
*/


    
    
/*
procedure CreateAndShowNewOrder ()
    var
//       SalesHeader@1000 :
      SalesHeader: Record 36;
    begin
      SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Sales Order",SalesHeader)
    end;
*/


    
    
/*
procedure CreateAndShowNewCreditMemo ()
    var
//       SalesHeader@1000 :
      SalesHeader: Record 36;
    begin
      SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Sales Credit Memo",SalesHeader)
    end;
*/


    
    
/*
procedure CreateAndShowNewQuote ()
    var
//       SalesHeader@1000 :
      SalesHeader: Record 36;
    begin
      SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Sales Quote",SalesHeader)
    end;
*/


//     LOCAL procedure UpdatePaymentTolerance (UseDialog@1000 :
    
/*
LOCAL procedure UpdatePaymentTolerance (UseDialog: Boolean)
    begin
      if "Block Payment Tolerance" then begin
        if UseDialog then
          if not CONFIRM(RemovePaymentRoleranceQst,FALSE) then
            exit;
        PaymentToleranceMgt.DelTolCustLedgEntry(Rec);
      end else begin
        if UseDialog then
          if not CONFIRM(AllowPaymentToleranceQst,FALSE) then
            exit;
        PaymentToleranceMgt.CalcTolCustLedgEntry(Rec);
      end;
    end;
*/


    
    
/*
procedure GetBillToCustomerNo () : Code[20];
    begin
      if "Bill-to Customer No." <> '' then
        exit("Bill-to Customer No.");
      exit("No.");
    end;
*/


    
    
/*
procedure HasAddressIgnoreCountryCode () : Boolean;
    begin
      CASE TRUE OF
        Address <> '':
          exit(TRUE);
        "Address 2" <> '':
          exit(TRUE);
        City <> '':
          exit(TRUE);
        County <> '':
          exit(TRUE);
        "Post Code" <> '':
          exit(TRUE);
        Contact <> '':
          exit(TRUE);
      end;

      exit(FALSE);
    end;
*/


    
    
/*
procedure HasAddress () : Boolean;
    begin
      exit(HasAddressIgnoreCountryCode or ("Country/Region Code" <> ''));
    end;
*/


    
//     procedure HasDifferentAddress (OtherCustomer@1000 :
    
/*
procedure HasDifferentAddress (OtherCustomer: Record 18) : Boolean;
    begin
      CASE TRUE OF
        Address <> OtherCustomer.Address:
          exit(TRUE);
        "Address 2" <> OtherCustomer."Address 2":
          exit(TRUE);
        City <> OtherCustomer.City:
          exit(TRUE);
        County <> OtherCustomer.County:
          exit(TRUE);
        "Post Code" <> OtherCustomer."Post Code":
          exit(TRUE);
        "Country/Region Code" <> OtherCustomer."Country/Region Code":
          exit(TRUE);
      end;

      exit(FALSE);
    end;
*/


    
//     procedure GetCustNo (CustomerText@1000 :
    
/*
procedure GetCustNo (CustomerText: Text) : Text;
    begin
      exit(GetCustNoOpenCard(CustomerText,TRUE,TRUE));
    end;
*/


    
//     procedure GetCustNoOpenCard (CustomerText@1000 : Text;ShowCustomerCard@1006 : Boolean;ShowCreateCustomerOption@1007 :
    
/*
procedure GetCustNoOpenCard (CustomerText: Text;ShowCustomerCard: Boolean;ShowCreateCustomerOption: Boolean) : Code[20];
    var
//       Customer@1001 :
      Customer: Record 18;
//       CustomerNo@1002 :
      CustomerNo: Code[20];
//       NoFiltersApplied@1008 :
      NoFiltersApplied: Boolean;
//       CustomerWithoutQuote@1005 :
      CustomerWithoutQuote: Text;
//       CustomerFilterFromStart@1004 :
      CustomerFilterFromStart: Text;
//       CustomerFilterContains@1003 :
      CustomerFilterContains: Text;
    begin
      if CustomerText = '' then
        exit('');

      if STRLEN(CustomerText) <= MAXSTRLEN(Customer."No.") then
        if Customer.GET(COPYSTR(CustomerText,1,MAXSTRLEN(Customer."No."))) then
          exit(Customer."No.");

      Customer.SETRANGE(Blocked,Customer.Blocked::" ");
      Customer.SETRANGE(Name,CustomerText);
      if Customer.FINDFIRST then
        exit(Customer."No.");

      Customer.SETCURRENTKEY(Name);

      CustomerWithoutQuote := CONVERTSTR(CustomerText,'''','?');
      Customer.SETFILTER(Name,'''@' + CustomerWithoutQuote + '''');
      if Customer.FINDFIRST then
        exit(Customer."No.");
      Customer.SETRANGE(Name);

      CustomerFilterFromStart := '''@' + CustomerWithoutQuote + '*''';

      Customer.FILTERGROUP := -1;
      Customer.SETFILTER("No.",CustomerFilterFromStart);

      Customer.SETFILTER(Name,CustomerFilterFromStart);

      if Customer.FINDFIRST then
        exit(Customer."No.");

      CustomerFilterContains := '''@*' + CustomerWithoutQuote + '*''';

      Customer.SETFILTER("No.",CustomerFilterContains);
      Customer.SETFILTER(Name,CustomerFilterContains);
      Customer.SETFILTER(City,CustomerFilterContains);
      Customer.SETFILTER(Contact,CustomerFilterContains);
      Customer.SETFILTER("Phone No.",CustomerFilterContains);
      Customer.SETFILTER("Post Code",CustomerFilterContains);

      if Customer.COUNT = 0 then
        MarkCustomersWithSimilarName(Customer,CustomerText);

      if Customer.COUNT = 1 then begin
        Customer.FINDFIRST;
        exit(Customer."No.");
      end;

      if not GUIALLOWED then
        ERROR(SelectCustErr);

      if Customer.COUNT = 0 then begin
        if Customer.WRITEPERMISSION then
          if ShowCreateCustomerOption then
            CASE STRMENU(
                   STRSUBSTNO(
                     '%1,%2',STRSUBSTNO(CreateNewCustTxt,CONVERTSTR(CustomerText,',','.')),SelectCustTxt),1,CustNotRegisteredTxt) OF
              0:
                ERROR(SelectCustErr);
              1:
                exit(CreateNewCustomer(COPYSTR(CustomerText,1,MAXSTRLEN(Customer.Name)),ShowCustomerCard));
            end
          else
            exit('');
        Customer.RESET;
        NoFiltersApplied := TRUE;
      end;

      if ShowCustomerCard then
        CustomerNo := PickCustomer(Customer,NoFiltersApplied)
      else begin
        LookupRequested := TRUE;
        exit('');
      end;

      if CustomerNo <> '' then
        exit(CustomerNo);

      ERROR(SelectCustErr);
    end;
*/


//     LOCAL procedure MarkCustomersWithSimilarName (var Customer@1001 : Record 18;CustomerText@1000 :
    
/*
LOCAL procedure MarkCustomersWithSimilarName (var Customer: Record 18;CustomerText: Text)
    var
//       TypeHelper@1002 :
      TypeHelper: Codeunit 10;
//       CustomerCount@1003 :
      CustomerCount: Integer;
//       CustomerTextLength@1004 :
      CustomerTextLength: Integer;
//       Treshold@1005 :
      Treshold: Integer;
    begin
      if CustomerText = '' then
        exit;
      if STRLEN(CustomerText) > MAXSTRLEN(Customer.Name) then
        exit;
      CustomerTextLength := STRLEN(CustomerText);
      Treshold := CustomerTextLength DIV 5;
      if Treshold = 0 then
        exit;

      Customer.RESET;
      Customer.ASCENDING(FALSE); // most likely to search for newest customers
      Customer.SETRANGE(Blocked,Customer.Blocked::" ");
      if Customer.FINDSET then
        repeat
          CustomerCount += 1;
          if ABS(CustomerTextLength - STRLEN(Customer.Name)) <= Treshold then
            if TypeHelper.TextDistance(UPPERCASE(CustomerText),UPPERCASE(Customer.Name)) <= Treshold then
              Customer.MARK(TRUE);
        until Customer.MARK or (Customer.NEXT = 0) or (CustomerCount > 1000);
      Customer.MARKEDONLY(TRUE);
    end;
*/


    
//     procedure CreateNewCustomer (CustomerName@1000 : Text[50];ShowCustomerCard@1001 :
    
/*
procedure CreateNewCustomer (CustomerName: Text[50];ShowCustomerCard: Boolean) : Code[20];
    var
//       Customer@1005 :
      Customer: Record 18;
//       MiniCustomerTemplate@1006 :
      MiniCustomerTemplate: Record 1300;
//       CustomerCard@1002 :
      CustomerCard: Page 21;
    begin
      Customer.Name := CustomerName;
      if not MiniCustomerTemplate.NewCustomerFromTemplate(Customer) then
        Customer.INSERT(TRUE)
      else
        if CustomerName <> Customer.Name then begin
          Customer.Name := CustomerName;
          Customer.MODIFY(TRUE);
        end;

      COMMIT;
      if not ShowCustomerCard then
        exit(Customer."No.");
      Customer.SETRANGE("No.",Customer."No.");
      CustomerCard.SETTABLEVIEW(Customer);
      if not (CustomerCard.RUNMODAL = ACTION::OK) then
        ERROR(SelectCustErr);

      exit(Customer."No.");
    end;
*/


//     LOCAL procedure PickCustomer (var Customer@1000 : Record 18;NoFiltersApplied@1002 :
    
/*
LOCAL procedure PickCustomer (var Customer: Record 18;NoFiltersApplied: Boolean) : Code[20];
    var
//       CustomerList@1001 :
      CustomerList: Page 22;
    begin
      if not NoFiltersApplied then
        MarkCustomersByFilters(Customer);

      CustomerList.SETTABLEVIEW(Customer);
      CustomerList.SETRECORD(Customer);
      CustomerList.LOOKUPMODE := TRUE;
      if CustomerList.RUNMODAL = ACTION::LookupOK then
        CustomerList.GETRECORD(Customer)
      else
        CLEAR(Customer);

      exit(Customer."No.");
    end;
*/


//     LOCAL procedure MarkCustomersByFilters (var Customer@1000 :
    
/*
LOCAL procedure MarkCustomersByFilters (var Customer: Record 18)
    begin
      if Customer.FINDSET then
        repeat
          Customer.MARK(TRUE);
        until Customer.NEXT = 0;
      if Customer.FINDFIRST then;
      Customer.MARKEDONLY := TRUE;
    end;
*/


    
//     procedure OpenCustomerLedgerEntries (FilterOnDueEntries@1002 :
    
/*
procedure OpenCustomerLedgerEntries (FilterOnDueEntries: Boolean)
    var
//       DetailedCustLedgEntry@1001 :
      DetailedCustLedgEntry: Record 379;
//       CustLedgerEntry@1000 :
      CustLedgerEntry: Record 21;
    begin
      DetailedCustLedgEntry.SETRANGE("Customer No.","No.");
      COPYFILTER("Global Dimension 1 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 1");
      COPYFILTER("Global Dimension 2 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 2");
      if FilterOnDueEntries and (GETFILTER("Date Filter") <> '') then begin
        COPYFILTER("Date Filter",DetailedCustLedgEntry."Initial Entry Due Date");
        DetailedCustLedgEntry.SETFILTER("Posting Date",'<=%1',GETRANGEMAX("Date Filter"));
      end;
      COPYFILTER("Currency Filter",DetailedCustLedgEntry."Currency Code");
      CustLedgerEntry.DrillDownOnEntries(DetailedCustLedgEntry);
    end;
*/


    
//     procedure SetInsertFromTemplate (FromTemplate@1000 :
    
/*
procedure SetInsertFromTemplate (FromTemplate: Boolean)
    begin
      InsertFromTemplate := FromTemplate;
    end;
*/


    
    
/*
procedure IsLookupRequested () Result : Boolean;
    begin
      Result := LookupRequested;
      LookupRequested := FALSE;
    end;
*/


    
/*
LOCAL procedure IsContactUpdateNeeded () : Boolean;
    var
//       CustContUpdate@1001 :
      CustContUpdate: Codeunit 5056;
//       UpdateNeeded@1000 :
      UpdateNeeded: Boolean;
    begin
      UpdateNeeded :=
        (Name <> xRec.Name) or
        ("Search Name" <> xRec."Search Name") or
        ("Name 2" <> xRec."Name 2") or
        (Address <> xRec.Address) or
        ("Address 2" <> xRec."Address 2") or
        (City <> xRec.City) or
        ("Phone No." <> xRec."Phone No.") or
        ("Telex No." <> xRec."Telex No.") or
        ("Territory Code" <> xRec."Territory Code") or
        ("Currency Code" <> xRec."Currency Code") or
        ("Language Code" <> xRec."Language Code") or
        ("Salesperson Code" <> xRec."Salesperson Code") or
        ("Country/Region Code" <> xRec."Country/Region Code") or
        ("Fax No." <> xRec."Fax No.") or
        ("Telex Answer Back" <> xRec."Telex Answer Back") or
        ("VAT Registration No." <> xRec."VAT Registration No.") or
        ("Post Code" <> xRec."Post Code") or
        (County <> xRec.County) or
        ("E-Mail" <> xRec."E-Mail") or
        ("Home Page" <> xRec."Home Page") or
        (Contact <> xRec.Contact);

      if not UpdateNeeded and not ISTEMPORARY then
        UpdateNeeded := CustContUpdate.ContactNameIsBlank("No.");

      OnBeforeIsContactUpdateNeeded(Rec,xRec,UpdateNeeded);
      exit(UpdateNeeded);
    end;
*/


    
    
/*
procedure IsBlocked () : Boolean;
    begin
      if Blocked <> Blocked::" " then
        exit(TRUE);

      if "Privacy Blocked" then
        exit(TRUE);

      exit(FALSE);
    end;
*/


    
    
/*
procedure HasAnyOpenOrPostedDocuments () : Boolean;
    var
//       SalesHeader@1001 :
      SalesHeader: Record 36;
//       SalesLine@1000 :
      SalesLine: Record 37;
//       CustLedgerEntry@1002 :
      CustLedgerEntry: Record 21;
//       HasAnyDocs@1003 :
      HasAnyDocs: Boolean;
    begin
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      if SalesHeader.FINDFIRST then
        exit(TRUE);

      SalesLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
      SalesLine.SETRANGE("Bill-to Customer No.","No.");
      if SalesLine.FINDFIRST then
        exit(TRUE);

      SalesLine.SETRANGE("Bill-to Customer No.");
      SalesLine.SETRANGE("Sell-to Customer No.","No.");
      if SalesLine.FINDFIRST then
        exit(TRUE);

      CustLedgerEntry.SETRANGE("Customer No.","No.");
      if not CustLedgerEntry.ISEMPTY then
        exit(TRUE);

      HasAnyDocs := FALSE;
      OnAfterHasAnyOpenOrPostedDocuments(Rec,HasAnyDocs);
      exit(HasAnyDocs);
    end;
*/


    
//     procedure CopyFromCustomerTemplate (CustomerTemplate@1000 :
    
/*
procedure CopyFromCustomerTemplate (CustomerTemplate: Record 5105)
    begin
      "Territory Code" := CustomerTemplate."Territory Code";
      "Global Dimension 1 Code" := CustomerTemplate."Global Dimension 1 Code";
      "Global Dimension 2 Code" := CustomerTemplate."Global Dimension 2 Code";
      "Customer Posting Group" := CustomerTemplate."Customer Posting Group";
      "Currency Code" := CustomerTemplate."Currency Code";
      "Invoice Disc. Code" := CustomerTemplate."Invoice Disc. Code";
      "Customer Price Group" := CustomerTemplate."Customer Price Group";
      "Customer Disc. Group" := CustomerTemplate."Customer Disc. Group";
      "Country/Region Code" := CustomerTemplate."Country/Region Code";
      "Allow Line Disc." := CustomerTemplate."Allow Line Disc.";
      "Gen. Bus. Posting Group" := CustomerTemplate."Gen. Bus. Posting Group";
      "VAT Bus. Posting Group" := CustomerTemplate."VAT Bus. Posting Group";
      VALIDATE("Payment Terms Code",CustomerTemplate."Payment Terms Code");
      VALIDATE("Payment Method Code",CustomerTemplate."Payment Method Code");
      "Prices Including VAT" := CustomerTemplate."Prices Including VAT";
      "Shipment Method Code" := CustomerTemplate."Shipment Method Code";

      OnAfterCopyFromCustomerTemplate(Rec,CustomerTemplate);
    end;
*/


//     LOCAL procedure CopyContactPicture (var Cont@1000 :
    
/*
LOCAL procedure CopyContactPicture (var Cont: Record 5050)
    var
//       TempNameValueBuffer@1005 :
      TempNameValueBuffer: Record 823 TEMPORARY;
//       FileManagement@1001 :
      FileManagement: Codeunit 419;
//       ConfirmManagement@1002 :
      ConfirmManagement: Codeunit 27;
//       ExportPath@1006 :
      ExportPath: Text;
    begin
      if Image.HASVALUE then
        if not ConfirmManagement.ConfirmProcess(OverrideImageQst,TRUE) then
          exit;

      ExportPath := TEMPORARYPATH + Cont."No." + FORMAT(Cont.Image.MEDIAID);
      Cont.Image.EXPORTFILE(ExportPath);
      FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer,TEMPORARYPATH);
      TempNameValueBuffer.SETFILTER(Name,STRSUBSTNO('%1*',ExportPath));
      TempNameValueBuffer.FINDFIRST;

      CLEAR(Image);
      Image.IMPORTFILE(TempNameValueBuffer.Name,'');
      MODIFY;
      if FileManagement.DeleteServerFile(TempNameValueBuffer.Name) then;
    end;
*/


    
/*
LOCAL procedure SetDefaultSalesperson ()
    var
//       UserSetup@1000 :
      UserSetup: Record 91;
    begin
      if not UserSetup.GET(USERID) then
        exit;

      if UserSetup."Salespers./Purch. Code" <> '' then
        VALIDATE("Salesperson Code",UserSetup."Salespers./Purch. Code");
    end;
*/


    
/*
LOCAL procedure SetLastModifiedDateTime ()
    begin
      "Last Modified Date Time" := CURRENTDATETIME;
      "Last Date Modified" := TODAY;
    end;
*/


    
/*
LOCAL procedure VATRegistrationValidation ()
    var
//       VATRegistrationNoFormat@1005 :
      VATRegistrationNoFormat: Record 381;
//       VATRegistrationLog@1004 :
      VATRegistrationLog: Record 249;
//       VATRegNoSrvConfig@1003 :
      VATRegNoSrvConfig: Record 248;
//       VATRegistrationLogMgt@1002 :
      VATRegistrationLogMgt: Codeunit 249;
//       ResultRecordRef@1001 :
      ResultRecordRef: RecordRef;
//       ApplicableCountryCode@1000 :
      ApplicableCountryCode: Code[10];
    begin
      if not VATRegistrationNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Customer) then
        exit;
      VATRegistrationLogMgt.LogCustomer(Rec);
      if ("Country/Region Code" = '') and (VATRegistrationNoFormat."Country/Region Code" = '') then
        exit;
      ApplicableCountryCode := "Country/Region Code";
      if ApplicableCountryCode = '' then
        ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
      if VATRegNoSrvConfig.VATRegNoSrvIsEnabled then begin
        VATRegistrationLogMgt.ValidateVATRegNoWithVIES(ResultRecordRef,Rec,"No.",
          VATRegistrationLog."Account Type"::Customer,ApplicableCountryCode);
        ResultRecordRef.SETTABLE(Rec);
      end;
    end;
*/


    
//     procedure SetAddress (CustomerAddress@1001 : Text[50];CustomerAddress2@1002 : Text[50];CustomerPostCode@1003 : Code[20];CustomerCity@1000 : Text[30];CustomerCounty@1004 : Text[30];CustomerCountryCode@1005 : Code[10];CustomerContact@1006 :
    
/*
procedure SetAddress (CustomerAddress: Text[50];CustomerAddress2: Text[50];CustomerPostCode: Code[20];CustomerCity: Text[30];CustomerCounty: Text[30];CustomerCountryCode: Code[10];CustomerContact: Text[50])
    begin
      Address := CustomerAddress;
      "Address 2" := CustomerAddress2;
      "Post Code" := CustomerPostCode;
      City := CustomerCity;
      County := CustomerCounty;
      "Country/Region Code" := CustomerCountryCode;
      UpdateContFromCust.OnModify(Rec);
      Contact := CustomerContact;
    end;
*/


    
//     procedure FindByEmail (var Customer@1001 : Record 18;Email@1000 :
    
/*
procedure FindByEmail (var Customer: Record 18;Email: Text) : Boolean;
    var
//       LocalContact@1002 :
      LocalContact: Record 5050;
//       ContactBusinessRelation@1003 :
      ContactBusinessRelation: Record 5054;
//       MarketingSetup@1004 :
      MarketingSetup: Record 5079;
    begin
      Customer.SETRANGE("E-Mail",Email);
      if Customer.FINDFIRST then
        exit(TRUE);

      Customer.SETRANGE("E-Mail");
      LocalContact.SETRANGE("E-Mail",Email);
      if LocalContact.FINDSET then begin
        MarketingSetup.GET;
        repeat
          if ContactBusinessRelation.GET(LocalContact."No.",MarketingSetup."Bus. Rel. Code for Customers") then begin
            Customer.GET(ContactBusinessRelation."No.");
            exit(TRUE);
          end;
        until LocalContact.NEXT = 0
      end;
    end;
*/


    
    
/*
procedure UpdateReferencedIds ()
    var
//       GraphMgtGeneralTools@1000 :
      GraphMgtGeneralTools: Codeunit 5465;
    begin
      if ISTEMPORARY then
        exit;

      if not GraphMgtGeneralTools.IsApiEnabled then
        exit;

      UpdateCurrencyId;
      UpdatePaymentTermsId;
      UpdateShipmentMethodId;
      UpdatePaymentMethodId;
      UpdateTaxAreaId;
    end;
*/


    
//     procedure GetReferencedIds (var TempField@1000 :
    
/*
procedure GetReferencedIds (var TempField: Record 2000000041 TEMPORARY)
    var
//       DataTypeManagement@1001 :
      DataTypeManagement: Codeunit 701;
    begin
      DataTypeManagement.InsertFieldToBuffer(TempField,DATABASE::Customer,FIELDNO("Currency Id"));
      DataTypeManagement.InsertFieldToBuffer(TempField,DATABASE::Customer,FIELDNO("Payment Terms Id"));
      DataTypeManagement.InsertFieldToBuffer(TempField,DATABASE::Customer,FIELDNO("Payment Method Id"));
      DataTypeManagement.InsertFieldToBuffer(TempField,DATABASE::Customer,FIELDNO("Shipment Method Id"));
      DataTypeManagement.InsertFieldToBuffer(TempField,DATABASE::Customer,FIELDNO("Tax Area ID"));
    end;
*/


    
/*
LOCAL procedure UpdateCurrencyCode ()
    var
//       Currency@1001 :
      Currency: Record 4;
    begin
      if not ISNULLGUID("Currency Id") then begin
        Currency.SETRANGE(Id,"Currency Id");
        Currency.FINDFIRST;
      end;

      VALIDATE("Currency Code",Currency.Code);
    end;
*/


    
/*
LOCAL procedure UpdatePaymentTermsCode ()
    var
//       PaymentTerms@1001 :
      PaymentTerms: Record 3;
    begin
      if not ISNULLGUID("Payment Terms Id") then begin
        PaymentTerms.SETRANGE(Id,"Payment Terms Id");
        PaymentTerms.FINDFIRST;
      end;

      VALIDATE("Payment Terms Code",PaymentTerms.Code);
    end;
*/


    
/*
LOCAL procedure UpdateShipmentMethodCode ()
    var
//       ShipmentMethod@1001 :
      ShipmentMethod: Record 10;
    begin
      if not ISNULLGUID("Shipment Method Id") then begin
        ShipmentMethod.SETRANGE(Id,"Shipment Method Id");
        ShipmentMethod.FINDFIRST;
      end;

      VALIDATE("Shipment Method Code",ShipmentMethod.Code);
    end;
*/


    
/*
LOCAL procedure UpdatePaymentMethodCode ()
    var
//       PaymentMethod@1001 :
      PaymentMethod: Record 289;
    begin
      if not ISNULLGUID("Payment Method Id") then begin
        PaymentMethod.SETRANGE(Id,"Payment Method Id");
        PaymentMethod.FINDFIRST;
      end;

      VALIDATE("Payment Method Code",PaymentMethod.Code);
    end;
*/


    
    
/*
procedure UpdateCurrencyId ()
    var
//       Currency@1000 :
      Currency: Record 4;
    begin
      if "Currency Code" = '' then begin
        CLEAR("Currency Id");
        exit;
      end;

      if not Currency.GET("Currency Code") then
        exit;

      "Currency Id" := Currency.Id;
    end;
*/


    
    
/*
procedure UpdatePaymentTermsId ()
    var
//       PaymentTerms@1000 :
      PaymentTerms: Record 3;
    begin
      if "Payment Terms Code" = '' then begin
        CLEAR("Payment Terms Id");
        exit;
      end;

      if not PaymentTerms.GET("Payment Terms Code") then
        exit;

      "Payment Terms Id" := PaymentTerms.Id;
    end;
*/


    
    
/*
procedure UpdateShipmentMethodId ()
    var
//       ShipmentMethod@1000 :
      ShipmentMethod: Record 10;
    begin
      if "Shipment Method Code" = '' then begin
        CLEAR("Shipment Method Id");
        exit;
      end;

      if not ShipmentMethod.GET("Shipment Method Code") then
        exit;

      "Shipment Method Id" := ShipmentMethod.Id;
    end;
*/


    
    
/*
procedure UpdatePaymentMethodId ()
    var
//       PaymentMethod@1000 :
      PaymentMethod: Record 289;
    begin
      if "Payment Method Code" = '' then begin
        CLEAR("Payment Method Id");
        exit;
      end;

      if not PaymentMethod.GET("Payment Method Code") then
        exit;

      "Payment Method Id" := PaymentMethod.Id;
    end;
*/


    
    
/*
procedure UpdateTaxAreaId ()
    var
//       VATBusinessPostingGroup@1002 :
      VATBusinessPostingGroup: Record 323;
//       TaxArea@1000 :
      TaxArea: Record 318;
//       GeneralLedgerSetup@1001 :
      GeneralLedgerSetup: Record 98;
    begin
      if GeneralLedgerSetup.UseVat then begin
        if "VAT Bus. Posting Group" = '' then begin
          CLEAR("Tax Area ID");
          exit;
        end;

        if not VATBusinessPostingGroup.GET("VAT Bus. Posting Group") then
          exit;

        "Tax Area ID" := VATBusinessPostingGroup.Id;
      end else begin
        if "Tax Area Code" = '' then begin
          CLEAR("Tax Area ID");
          exit;
        end;

        if not TaxArea.GET("Tax Area Code") then
          exit;

        "Tax Area ID" := TaxArea.Id;
      end;
    end;
*/


    
/*
LOCAL procedure UpdateTaxAreaCode ()
    var
//       TaxArea@1001 :
      TaxArea: Record 318;
//       VATBusinessPostingGroup@1000 :
      VATBusinessPostingGroup: Record 323;
//       GeneralLedgerSetup@1002 :
      GeneralLedgerSetup: Record 98;
    begin
      if ISNULLGUID("Tax Area ID") then
        exit;

      if GeneralLedgerSetup.UseVat then begin
        VATBusinessPostingGroup.SETRANGE(Id,"Tax Area ID");
        VATBusinessPostingGroup.FINDFIRST;
        "VAT Bus. Posting Group" := VATBusinessPostingGroup.Code;
      end else begin
        TaxArea.SETRANGE(Id,"Tax Area ID");
        TaxArea.FINDFIRST;
        "Tax Area Code" := TaxArea.Code;
      end;
    end;
*/


    
//     LOCAL procedure OnBeforeIsContactUpdateNeeded (Customer@1000 : Record 18;xCustomer@1001 : Record 18;var UpdateNeeded@1002 :
    
/*
LOCAL procedure OnBeforeIsContactUpdateNeeded (Customer: Record 18;xCustomer: Record 18;var UpdateNeeded: Boolean)
    begin
    end;
*/


    
/*
LOCAL procedure ValidateSalesPersonCode ()
    begin
      if "Salesperson Code" <> '' then
        if SalespersonPurchaser.GET("Salesperson Code") then
          if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
            ERROR(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser,TRUE))
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromCustomerTemplate (var Customer@1000 : Record 18;CustomerTemplate@1001 :
    
/*
LOCAL procedure OnAfterCopyFromCustomerTemplate (var Customer: Record 18;CustomerTemplate: Record 5105)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterHasAnyOpenOrPostedDocuments (var Customer@1000 : Record 18;var HasAnyDocs@1001 :
    
/*
LOCAL procedure OnAfterHasAnyOpenOrPostedDocuments (var Customer: Record 18;var HasAnyDocs: Boolean)
    begin
    end;

    /*begin
    //{
//      MCG 19/07/18: - Q3707 A¤adido campo "Payment bank No."
//      JAV 08/02/19: - A¤adido campo 50100 con el Cliente para Andrasa (Administrador, Arquitecto), da de alta la dimensi¢n asociada
//      RSH 29/04/19: - QX7105 A¤adido campo Generic customer, para usarse en los estudios y poder asignarlos a contactos y no a clientes.
//      JAV 21/09/19: - Mejora en el uso de la dimensi¢n asociada al referente
//      PGM 12/07/19: - CPM GAP006 Creado el campo Category asociado a la tabla Contact Categories
//      PGM 20/09/19: - KALAM GAP011 Creado el campo "Customer Type"
//      JAV 18/10/19: - Se a¤ade el campo 7207279 "Pending Withholding Amount" que suma de las retenciones de B.E. pendientes
//      JAV 18/02/20: - Se unifican los campos "Category" y "Customer Type" en uno solo
//      JAV 18/03/20: - Se renumeran campos en el rango de QB, se pasan los representantes a contactos
//      PGM 17/09/20: - QB 1.06.13 ORTIZ GFGAP029 Se crea el campo "Related Vendor No." que relaciona al cliente con un proveedor para liquidar movimientos entre ellos
//
//      ---------------------------- QuoSII -----------------------------------------------------------------------------------------------
//      QuoSII_1.3.02.005 171108 MCM - Se incluyen los campo Servicio y "Entry No." para el RENAME la tabla SII Document
//                                     Se incluye el campo "Entry No." para el RENAME la tabla SII Shipment Line
//      QuoSII1.4 23/04/18 PEL - Nuevas validaciones en Special Regiments
//      QuoSII_1.4.0.017 MCM 04/07/18 - Se modifica el emisor en facturas intracomunitarias.
//      QuoSII_1.4.02.042 16/11/18 MCM - Adaptaciones SII Canarias
//      QuoSII_1.4.97.999 15/07/19 QMD - Traer datos del nuevo campo VAT Reg No. Type de la tabla Country/Region
//      QuoSII1.5z 15/09/21 JAV - Mejora en el manejo de los campos del r‚gimen especial, se pasa todo el c¢digo a la CU de manejo de objetos est ndar del QuoSII
//      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)
//      BS::21380 CSM 11/03/24 Í VEN029 Segundo titular en Clientes.
//    }
    end.
  */
}





