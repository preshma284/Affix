tableextension 50109 "MyExtension50109" extends "Vendor"
{
  
  /*
Permissions=TableData 25 r,
                TableData 5940 rm,
                TableData 7012 rd,
                TableData 7014 rd;
*/DataCaptionFields="No.","Name";
    CaptionML=ENU='Vendor',ESP='Proveedor';
    LookupPageID="Vendor Lookup";
    DrillDownPageID="Vendor List";
  
  fields
{
    field(50000;"Several Vendors";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Several Vendors',ESP='Proveedores varios';
                                                   Description='Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';

trigger OnValidate();
    BEGIN 
                                                                //Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.) -
                                                                IF "Several Vendors" THEN BEGIN 
                                                                  TESTFIELD("Country/Region Code");
                                                                  VALIDATE("VAT Registration No.", '');
                                                                END;
                                                                //Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.) +
                                                              END;


    }
    field(7174331;"QuoSII VAT Reg No. Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("IDType"),
                                                                                                   "SII Entity"=CONST('AEAT'));
                                                   CaptionML=ENU='VAT Reg No. Type',ESP='Tipo CIF/NIF';
                                                   Description='QuoSII';


    }
    field(7174335;"QuoSII Purch Special Regimen";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialPurchInv"),
                                                                                                   "SII Entity"=CONST('AEAT'));
                                                   CaptionML=ENU='Special Regimen AEAT',ESP='R‚gimen Especial AEAT';
                                                   Description='QuoSII_1.4.2.042.04';


    }
    field(7174336;"QuoSII Purch Special Regimen 1";Code[20])
    {
        TableRelation=IF ("QuoSII Purch Special Regimen"=FILTER(07)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                "SII Entity"=CONST('AEAT'),                                                                                                                                                "Code"=FILTER('01'|'03'|'05'|'12'))                                                                                                                                                ELSE IF ("QuoSII Purch Special Regimen"=FILTER(05)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                    "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                    "Code"=FILTER('01'|'06'|'07'|'08'|'12'))                                                                                                                                                                                                                                    ELSE IF ("QuoSII Purch Special Regimen"=FILTER(12)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                        "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                                                                                                        "Code"=FILTER('05'|'06'|'07'|'08'))                                                                                                                                                                                                                                                                                                                        ELSE IF ("QuoSII Purch Special Regimen"=FILTER(03)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                            "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                                                                                                                                                                                            "Code"=FILTER(01))                                                                                                                                                                                                                                                                                                                                                                                                            ELSE IF ("QuoSII Purch Special Regimen"=FILTER(01)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "Code"=FILTER(08));
                                                   

                                                   CaptionML=ENU='Special Regimen 1 AEAT',ESP='R‚gimen Especial 1 AEAT';
                                                   Description='QuoSII_1.4.2.042.04';

trigger OnValidate();
    VAR
//                                                                 Text7174331@1100286002 :
                                                                Text7174331: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2';
//                                                                 Text7174333@1100286001 :
                                                                Text7174333: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2, %3, %4, %5';
//                                                                 Text7174334@1100286000 :
                                                                Text7174334: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2, %3, %4, %5, %6';
                                                              BEGIN 
                                                              END;


    }
    field(7174337;"QuoSII Purch Special Regimen 2";Code[20])
    {
        TableRelation=IF ("QuoSII Purch Special Regimen"=FILTER(07)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                "SII Entity"=CONST('AEAT'),                                                                                                                                                "Code"=FILTER('01'|'03'|'05'|'12'))                                                                                                                                                ELSE IF ("QuoSII Purch Special Regimen"=FILTER(05)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                    "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                    "Code"=FILTER('01'|'06'|'07'|'08'|'12'))                                                                                                                                                                                                                                    ELSE IF ("QuoSII Purch Special Regimen"=FILTER(12)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                        "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                                                                                                        "Code"=FILTER('05'|'06'|'07'|'08'))                                                                                                                                                                                                                                                                                                                        ELSE IF ("QuoSII Purch Special Regimen"=FILTER(03)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                            "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                                                                                                                                                                                            "Code"=FILTER(01))                                                                                                                                                                                                                                                                                                                                                                                                            ELSE IF ("QuoSII Purch Special Regimen"=FILTER(01)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "SII Entity"=CONST('AEAT'),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "Code"=FILTER(08));
                                                   

                                                   CaptionML=ENU='Special Regimen 2 AEAT',ESP='R‚gimen Especial 2 AEAT';
                                                   Description='QuoSII_1.4.2.042.04';

trigger OnValidate();
    VAR
//                                                                 Text7174331@1100286002 :
                                                                Text7174331: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2';
//                                                                 Text7174333@1100286001 :
                                                                Text7174333: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2, %3, %4, %5';
//                                                                 Text7174334@1100286000 :
                                                                Text7174334: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2, %3, %4, %5, %6';
                                                              BEGIN 
                                                              END;


    }
    field(7174338;"QuoSII Purch Special R. ATCN";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialPurchInv"),
                                                                                                   "SII Entity"=CONST('ATCN'));
                                                   CaptionML=ENU='Special Regimen ATCN',ESP='R‚gimen Especial ATCN';
                                                   Description='QuoSII_1.4.2.042.04';


    }
    field(7174339;"QuoSII Purch Special R. 1 ATCN";Code[20])
    {
        TableRelation=IF ("QuoSII Purch Special Regimen"=FILTER(07)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                "SII Entity"=CONST('ATCN'),                                                                                                                                                "Code"=FILTER('01'|'03'|'05'|'12'))                                                                                                                                                ELSE IF ("QuoSII Purch Special Regimen"=FILTER(05)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                    "SII Entity"=CONST('ATCN'),                                                                                                                                                                                                                                    "Code"=FILTER('01'|'06'|'07'|'08'|'12'))                                                                                                                                                                                                                                    ELSE IF ("QuoSII Purch Special Regimen"=FILTER(12)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                        "SII Entity"=CONST('ATCN'),                                                                                                                                                                                                                                                                                                                        "Code"=FILTER('05'|'06'|'07'|'08'))                                                                                                                                                                                                                                                                                                                        ELSE IF ("QuoSII Purch Special Regimen"=FILTER(03)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                            "SII Entity"=CONST('ATCN'),                                                                                                                                                                                                                                                                                                                                                                                                            "Code"=FILTER(01))                                                                                                                                                                                                                                                                                                                                                                                                            ELSE IF ("QuoSII Purch Special Regimen"=FILTER(01)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "SII Entity"=CONST('ATCN'),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "Code"=FILTER(08));
                                                   

                                                   CaptionML=ENU='Special Regimen 1 ATCN',ESP='R‚gimen Especial 1 ATCN';
                                                   Description='QuoSII_1.4.2.042.04';

trigger OnValidate();
    VAR
//                                                                 Text7174331@1100286002 :
                                                                Text7174331: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2';
//                                                                 Text7174333@1100286001 :
                                                                Text7174333: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2, %3, %4, %5';
//                                                                 Text7174334@1100286000 :
                                                                Text7174334: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2, %3, %4, %5, %6';
                                                              BEGIN 
                                                              END;


    }
    field(7174340;"QuoSII Purch Special R. 2 ATCN";Code[20])
    {
        TableRelation=IF ("QuoSII Purch Special Regimen"=FILTER(07)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                "SII Entity"=CONST('ATCN'),                                                                                                                                                "Code"=FILTER('01'|'03'|'05'|'12'))                                                                                                                                                ELSE IF ("QuoSII Purch Special Regimen"=FILTER(05)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                    "SII Entity"=CONST('ATCN'),                                                                                                                                                                                                                                    "Code"=FILTER('01'|'06'|'07'|'08'|'12'))                                                                                                                                                                                                                                    ELSE IF ("QuoSII Purch Special Regimen"=FILTER(12)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                        "SII Entity"=CONST('ATCN'),                                                                                                                                                                                                                                                                                                                        "Code"=FILTER('05'|'06'|'07'|'08'))                                                                                                                                                                                                                                                                                                                        ELSE IF ("QuoSII Purch Special Regimen"=FILTER(03)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                            "SII Entity"=CONST('ATCN'),                                                                                                                                                                                                                                                                                                                                                                                                            "Code"=FILTER(01))                                                                                                                                                                                                                                                                                                                                                                                                            ELSE IF ("QuoSII Purch Special Regimen"=FILTER(01)) "SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "SII Entity"=CONST('ATCN'),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "Code"=FILTER(08));
                                                   

                                                   CaptionML=ENU='Special Regimen 2 ATCN',ESP='R‚gimen Especial 2 ATCN';
                                                   Description='QuoSII_1.4.2.042.04';

trigger OnValidate();
    VAR
//                                                                 Text7174331@1100286002 :
                                                                Text7174331: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2';
//                                                                 Text7174333@1100286001 :
                                                                Text7174333: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2, %3, %4, %5';
//                                                                 Text7174334@1100286000 :
                                                                Text7174334: TextConst ENU='El campo %1 s¢lo puede tomar los valores %2, %3, %4, %5, %6';
                                                              BEGIN 
                                                              END;


    }
    field(7207270;"QW Withholding Group by PIT";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("PIT"));
                                                   CaptionML=ENU='PIT Withholding Group',ESP='Grupo de retenciones IRPF';
                                                   Description='QB 1.00 - QB2511';


    }
    field(7207271;"QW Withholding Group by G.E.";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("G.E"),
                                                                                                 "Use in"=FILTER('Vendor'|'Booth'));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Withholding Group by G.E.',ESP='Grupo retenciones por B.E.';
                                                   Description='QB 1.00 - QB2511,   JAV 19/08/19: - Se filtra para que sean retenciones de clientes o de ambos';

trigger OnValidate();
    BEGIN 
                                                                IF ("QW Withholding Group by G.E." = '') THEN
                                                                  CLEAR("QW Calc Due Date");
                                                              END;


    }
    field(7207272;"QW Withholding Amount PIT";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Withholding Movements"."Amount" WHERE ("Type"=CONST("Vendor"),
                                                                                                         "Withholding Type"=CONST("PIT"),
                                                                                                         "No."=FIELD("No.")));
                                                   CaptionML=ENU='Withholding Amount PIT',ESP='Importe Retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207273;"QW Withholding Amount G.E";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Withholding Movements"."Amount" WHERE ("Type"=CONST("Vendor"),
                                                                                                         "Withholding Type"=CONST("G.E"),
                                                                                                         "No."=FIELD("No.")));
                                                   CaptionML=ENU='Withholding Amount G.E',ESP='Importe Retenci¢n B.E.';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207274;"QW Withholding Pending Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Withholding Movements"."Amount" WHERE ("Type"=CONST("Vendor"),
                                                                                                         "No."=FIELD("No."),
                                                                                                         "Open"=CONST(true),
                                                                                                         "Withholding Type"=CONST("G.E")));
                                                   CaptionML=ENU='Pending Withholding Amount',ESP='Importe Retenci¢n B.E. pdte.';
                                                   Description='QB 1.00 - QB22111    JAV 18/10/19: - Solo suma las retenciones de B.E. pendiente, no todas pues no tiene sentido sumar con IRPF';
                                                   Editable=false;


    }
    field(7207275;"QB Payment Phases";Code[20])
    {
        TableRelation="QB Payments Phases";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fases de pagos';
                                                   Description='QB 1.06 - JAV 07/07/20: [TT] Que fase de pago usar  el proveedor por defecto en las compras, puede quedar en blanco';


    }
    field(7207276;"QB SII Operation Description";Code[20])
    {
        TableRelation="QB SII Operation Description";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Descripci¢n Operaci¢n para el SII';
                                                   Description='QB 1.06 - JAV 09/07/20: [TT] Que descripci¢n de operaci¢n se usar  por defecto con este proveedor para el SII                 QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


    }
    field(7207277;"QB JV Dimension Code";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='JV Dimension Code',ESP='C¢d. dimensi¢n UTE';
                                                   Description='QB 1.00 - QB2518';
                                                   CaptionClass='1,2,5';

trigger OnLookup();
    VAR
//                                                               QBTablePublisher@100000000 :
                                                              QBTablePublisher: Codeunit 7207346;
                                                            BEGIN 
                                                              QBTablePublisher.OnLookupJVDimensionCode(Rec);
                                                            END;


    }
    field(7207278;"QB Validity Quotes";DateFormula)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Validez ofertas',ESP='Validez ofertas';
                                                   Description='QB 1.00 - JAV 15/11/19: - Plazo de validez de las ofertas por defecto';


    }
    field(7207279;"QB Warranty";DateFormula)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Garantia',ESP='Plazo de Garant¡a';
                                                   Description='QB 1.00 - JAV 15/11/19: - Plazo de garant¡a por defecto';


    }
    field(7207280;"QB No. Activities";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("Vendor Quality Data" WHERE ("Vendor No."=FIELD("No.")));
                                                   CaptionML=ESP='N§ de Actividades Asocidas';
                                                   Description='QB 1.00 - JAV 19/02/19: - N§ de actividades asociadas al proveedor';
                                                   Editable=false;


    }
    field(7207281;"QB No. Cetificates";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("Vendor Certificates" WHERE ("Vendor No."=FIELD("No."),
                                                                                                  "Required"=CONST(true)));
                                                   CaptionML=ESP='N§ de Certificados Obligatorios';
                                                   Description='QB 1.00 - JAV 20/11/19: - Cuantos certificados obligatorios tiene asociados';
                                                   Editable=false;


    }
    field(7207282;"QB Do not control certificates";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No controlar certificados';
                                                   Description='QB 1.00 - JAV 20/11/29: - Si hay que controlar los certificados obligatorios';


    }
    field(7207283;"QB Obralia";Option)
    {
        OptionMembers="IfPossible","Mandatory","Never";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Obralia',ESP='Verificar con Obralia';
                                                   OptionCaptionML=ENU='If possible,Mandatory,Never',ESP='Si es posible,Obligatorio,Nunca';
                                                   
                                                   Description='QB 1.00 - OBR: Si lo tiene activo el proveedor';


    }
    field(7207284;"QB Quantity available contract";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Contracts Control"."Importe Pendiente" WHERE ("Proveedor"=FIELD("No."),
                                                                                                                  "Linea de Totales"=CONST(false)));
                                                   CaptionML=ENU='Quantity available in contracts',ESP='Importe Disponible en Contratos';
                                                   Description='QB - 09/05/19 JAV Cantidad en contratos del proveedor';
                                                   Editable=false;


    }
    field(7207285;"QB Do not control in contracts";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No controlar en contratos';
                                                   Description='QB - JAV 30/06/19: No incluir en el control de contratos';


    }
    field(7207286;"QB Category";Code[20])
    {
        TableRelation="TAux General Categories" WHERE ("Use In"=FILTER('All'|'Vendors'));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Category',ESP='Categor¡a';
                                                   Description='QB - GAP006 KALAM: - Tipo de proveedor';
                                                   CaptionClass='7206910,23,7207286';

trigger OnValidate();
    BEGIN 
                                                                IF ("QB Category" <> xRec."QB Category") THEN
                                                                  "QB Sub-Category" := '';
                                                              END;


    }
    field(7207287;"QB Main Activity Code";Code[20])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Vendor Quality Data"."Activity Code" WHERE ("Main Activity"=FILTER(true),
                                                                                                                   "Vendor No."=FIELD("No.")));
                                                   CaptionML=ENU='Activity Code',ESP='C¢digo actividad Principal';
                                                   Description='QB - GAP003 KALAM: - Se marca la actividad principal del proveedor';
                                                   Editable=false;


    }
    field(7207288;"QB Main Activity Description";Text[30])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Activity QB"."Description" WHERE ("Activity Code"=FIELD("QB Main Activity Code")));
                                                   CaptionML=ENU='Activity Description',ESP='Descripci¢n actividad Principal';
                                                   Description='QB - GAP003 KALAM: - Se marca la actividad principal del proveedor';
                                                   Editable=false;


    }
    field(7207289;"QB Representative 1";Code[20])
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
                                                                Txt001: TextConst ESP='No puede usar el mismo contacto en dos representantes';
                                                              BEGIN 
                                                                IF "QB Representative 1" <> '' THEN BEGIN 
                                                                  Cont.GET("QB Representative 1");
                                                                  ContBusRel.FindOrRestoreContactBusinessRelation(Cont,Rec,ContBusRel."Link to Table"::Vendor);
                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    ERROR(Text003,Cont."No.",Cont.Name,"No.",Name);
                                                                END;

                                                                IF ("QB Representative 1" <> '') THEN
                                                                  IF ("QB Representative 1" = "QB Representative 2") OR ("QB Representative 1" = "QB Representative PRL") THEN
                                                                    ERROR(Txt001);
                                                                CALCFIELDS("QB Representative 1 Name");
                                                              END;

trigger OnLookup();
    VAR
//                                                               Cont@100000002 :
                                                              Cont: Record 5050;
//                                                               ContBusRel@100000001 :
                                                              ContBusRel: Record 5054;
//                                                               TempVen@100000000 :
                                                              TempVen: Record 23 TEMPORARY;
                                                            BEGIN 
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FINDFIRST THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("No.",'');

                                                              IF "QB Representative 1" <> '' THEN
                                                                IF Cont.GET("QB Representative 1") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN 
                                                                //TempVen.COPY(Rec);
                                                                //FIND;
                                                                //TRANSFERFIELDS(TempVen,FALSE);
                                                                VALIDATE("QB Representative 1",Cont."No.");
                                                              END;
                                                            END;


    }
    field(7207290;"QB Representative 1 Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Contact"."Name" WHERE ("No."=FIELD("QB Representative 1")));
                                                   CaptionML=ENU='Nombre representante 1',ESP='Nombre Representante 1';
                                                   Description='QB 1.00 - QB2511 JAV 18/03/20: - Se pasan los representantes a contactos';
                                                   Editable=false;


    }
    field(7207291;"QB Representative 2";Code[20])
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
                                                                Txt001: TextConst ESP='No puede usar el mismo contacto en dos representantes';
                                                              BEGIN 
                                                                IF "QB Representative 2" <> '' THEN BEGIN 
                                                                  Cont.GET("QB Representative 2");
                                                                  ContBusRel.FindOrRestoreContactBusinessRelation(Cont,Rec,ContBusRel."Link to Table"::Vendor);
                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    ERROR(Text003,Cont."No.",Cont.Name,"No.",Name);
                                                                END;

                                                                IF ("QB Representative 2" <> '') THEN
                                                                  IF ("QB Representative 2" = "QB Representative 1") OR ("QB Representative 2" = "QB Representative PRL") THEN
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
                                                              TempCust: Record 23 TEMPORARY;
                                                            BEGIN 
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FINDFIRST THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("No.",'');

                                                              IF "QB Representative 2" <> '' THEN
                                                                IF Cont.GET("QB Representative 2") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN 
                                                                //TempCust.COPY(Rec);
                                                                //FIND;
                                                                //TRANSFERFIELDS(TempCust,FALSE);
                                                                VALIDATE("QB Representative 2",Cont."No.");
                                                              END;
                                                            END;


    }
    field(7207292;"QB Representative 2 Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Contact"."Name" WHERE ("No."=FIELD("QB Representative 2")));
                                                   CaptionML=ENU='Nombre representante 1',ESP='Nombre Representante 2';
                                                   Description='QB 1.00 - QB2511 JAV 18/03/20: - Se pasan los representantes a contactos';
                                                   Editable=false;


    }
    field(7207293;"QB Representative PRL";Code[20])
    {
        TableRelation="Contact";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Nombre representante 1',ESP='Representante PRL';
                                                   Description='QB 1.00 - QB2511 JAV 18/03/20: - Se pasan los representantes a contactos';

trigger OnValidate();
    VAR
//                                                                 Cont@100000001 :
                                                                Cont: Record 5050;
//                                                                 ContBusRel@100000000 :
                                                                ContBusRel: Record 5054;
//                                                                 Txt001@100000002 :
                                                                Txt001: TextConst ESP='No puede usar el mismo contacto en dos representantes';
                                                              BEGIN 
                                                                IF "QB Representative PRL" <> '' THEN BEGIN 
                                                                  Cont.GET("QB Representative PRL");
                                                                  ContBusRel.FindOrRestoreContactBusinessRelation(Cont,Rec,ContBusRel."Link to Table"::Vendor);
                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    ERROR(Text003,Cont."No.",Cont.Name,"No.",Name);
                                                                END;

                                                                IF ("QB Representative PRL" <> '') THEN
                                                                  IF ("QB Representative PRL" = "QB Representative 1")  OR ("QB Representative PRL" = "QB Representative 2") THEN
                                                                    ERROR(Txt001);
                                                                CALCFIELDS("QB Representative PRL Name");
                                                              END;

trigger OnLookup();
    VAR
//                                                               Cont@100000002 :
                                                              Cont: Record 5050;
//                                                               ContBusRel@100000001 :
                                                              ContBusRel: Record 5054;
//                                                               TempVendor@100000000 :
                                                              TempVendor: Record 23 TEMPORARY;
                                                            BEGIN 
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FINDFIRST THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("No.",'');

                                                              IF "QB Representative PRL" <> '' THEN
                                                                IF Cont.GET("QB Representative PRL") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN 
                                                                //tempvendor.COPY(Rec);
                                                                //FIND;
                                                                //TRANSFERFIELDS(tempvendor,FALSE);
                                                                VALIDATE("QB Representative PRL",Cont."No.");
                                                              END;
                                                            END;


    }
    field(7207294;"QB Representative PRL Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Contact"."Name" WHERE ("No."=FIELD("QB Representative PRL")));
                                                   CaptionML=ENU='Nombre representante 1',ESP='Nombre Representante PRL';
                                                   Description='QB 1.00 - QB2511 JAV 18/03/20: - Se pasan los representantes a contactos';
                                                   Editable=false;


    }
    field(7207295;"QB Employee";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Employee',ESP='Empleado';
                                                   Description='QB 1.00 - QB2511';


    }
    field(7207296;"QB Establishment Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Fecha de constitucion',ESP='Fecha de constituci¢n';
                                                   Description='QB 1.00 - QB2511';


    }
    field(7207297;"QB Before the notary";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Ante el notario',ESP='Ante el notario';
                                                   Description='QB 1.00 - QB2511';


    }
    field(7207298;"QB Protocol No.";Text[30])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='No. de protocolo',ESP='N§ de protocolo';
                                                   Description='QB 1.00 - QB2511';


    }
    field(7207299;"QB Business Registration";Text[100])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Registro mercantil',ESP='Registro mercantil';
                                                   Description='QB 1.00 - QB2511';


    }
    field(7207303;"QB Operation Counties";Text[50])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Operation County',ESP='Provincias en que opera';
                                                   Description='QB 1.00 - ELECNOR GEN001-04';

trigger OnValidate();
    VAR
//                                                                 VendorQualityData@100000001 :
                                                                VendorQualityData: Record 7207418;
//                                                                 QBPageSubscriber@100000000 :
                                                                QBPageSubscriber: Codeunit 7207349;
                                                              BEGIN 
                                                                //GEN001-04
                                                                QBPageSubscriber.VerifyCounties(Rec."QB Operation Counties");

                                                                VendorQualityData.RESET;
                                                                VendorQualityData.SETRANGE("Vendor No.", Rec."No.");
                                                                IF VendorQualityData.FINDSET(TRUE) THEN
                                                                  REPEAT
                                                                    VendorQualityData."Operation Counties" := Rec."QB Operation Counties";
                                                                    VendorQualityData.MODIFY(FALSE);
                                                                  UNTIL VendorQualityData.NEXT = 0;
                                                              END;


    }
    field(7207304;"QB Operation Countries";Text[50])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Operation Country',ESP='Paises en que opera';
                                                   Description='QB 1.00 - ELECNOR GEN001-04';

trigger OnValidate();
    VAR
//                                                                 VendorQualityData@100000002 :
                                                                VendorQualityData: Record 7207418;
//                                                                 QBPageSubscriber@100000001 :
                                                                QBPageSubscriber: Codeunit 7207349;
                                                              BEGIN 
                                                                //GEN001-04
                                                                QBPageSubscriber.VerifyCountries(Rec."QB Operation Countries");

                                                                VendorQualityData.RESET;
                                                                VendorQualityData.SETRANGE("Vendor No.", Rec."No.");
                                                                IF VendorQualityData.FINDSET(TRUE) THEN
                                                                  REPEAT
                                                                    VendorQualityData."Operation Countries" := Rec."QB Operation Countries";
                                                                    VendorQualityData.MODIFY(FALSE);
                                                                  UNTIL VendorQualityData.NEXT = 0;
                                                              END;


    }
    field(7207305;"QB Third No.";Code[20])
    {
        TableRelation=Contact WHERE ("Type"=CONST("Company"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Related Vendor No.',ESP='C¢digo de Tercero';
                                                   Description='QB 1.06.15 - JAV 25/09/20: - ORTIZ GFGAP029 [TT] Este campo relaciona al cliente con un tercero, que ser  cliente, proveedor o banco';


    }
    field(7207306;"QB Sub-Category";Code[20])
    {
        TableRelation="QB TAux General Sub-Categories"."Code" WHERE ("Categorie"=FIELD("QB Category"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Customer Type',ESP='Sub-Categor¡a';
                                                   Description='QB 1.06 - ORTIZ GFGAP015   QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';
                                                   CaptionClass='7206910,23,7207306';


    }
    field(7207307;"QB Prepayment Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Prepayment"."Amount" WHERE ("Account Type"=CONST("Vendor"),
                                                                                                 "Account No."=FIELD("No.")));
                                                   CaptionML=ENU='Amount',ESP='Importe Anticipos Pendientes';
                                                   Description='QB 1.06 - ORTIZ OBGAP012';
                                                   Editable=false;


    }
    field(7207308;"QB Prepayment Amount (LCY)";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Prepayment"."Amount (LCY)" WHERE ("Account Type"=CONST("Vendor"),
                                                                                                         "Account No."=FIELD("No.")));
                                                   CaptionML=ENU='Amount (LCY)',ESP='Importe Anticipos Pendientes (DL)';
                                                   Description='QB 1.06 - ORTIZ OBGAP012';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(7207309;"QB Calc Due Date";Option)
    {
        OptionMembers="Standar","Document","Reception","Approval";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Calculo Vencimientos';
                                                   OptionCaptionML=ENU='Standar,Document,Reception,Approval',ESP='La configurada en QB,Fecha del Documento,Fecha de Recepci¢n,Fecha de Aprobaci¢n';
                                                   
                                                   Description='QB 1.06 - JAV 12/07/20: - A partir de que fecha se calcula el vto de las fras de compra, GAP12 ROIG CyS,ORTIZ';


    }
    field(7207310;"QB No. Days Calc Due Date";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ d¡as tras Recepci¢n';
                                                   Description='QB 1.06 - JAV 12/07/20: - d¡as adicionales para el c lculo del vto de las fras de compra,ORTIZ';


    }
    field(7207313;"QB Shipments Balance";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount" WHERE ("Vendor No."=FIELD("No."),
                                                                                                                "Initial Entry Global Dim. 1"=FIELD("Global Dimension 1 Filter"),
                                                                                                                "Initial Entry Global Dim. 2"=FIELD("Global Dimension 2 Filter"),
                                                                                                                "Currency Code"=FIELD("Currency Filter"),
                                                                                                                "Document Type"=CONST("Shipment")));
                                                   CaptionML=ENU='Balance',ESP='Saldo Albaranes Ptes';
                                                   Description='QB 1.06.20 - JAV 09/10/20: - Saldo de albaranes pendientes de facturar, por movimientos de tipo albar n';
                                                   Editable=false;
                                                   AutoFormatType=1;
                                                   AutoFormatExpression="Currency Code";


    }
    field(7207314;"QB Shipments Balance (LCY)";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE ("Vendor No."=FIELD("No."),
                                                                                                                        "Initial Entry Global Dim. 1"=FIELD("Global Dimension 1 Filter"),
                                                                                                                        "Initial Entry Global Dim. 2"=FIELD("Global Dimension 2 Filter"),
                                                                                                                        "Currency Code"=FIELD("Currency Filter"),
                                                                                                                        "Document Type"=CONST("Shipment")));
                                                   CaptionML=ENU='Balance (LCY)',ESP='Saldo Albaranes Ptes (DL)';
                                                   Description='QB 1.06.20 - JAV 09/10/20: - Saldo de albaranes pendientes de facturar, por movimientos de tipo albar n';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(7207315;"QB Attorney";Code[20])
    {
        TableRelation="Contact";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Attorney',ESP='Apoderado';
                                                   Description='QB 1.08.28 - JAV 24/03/21: - Se pasa el apoderado a contacto';

trigger OnValidate();
    VAR
//                                                                 Cont@100000001 :
                                                                Cont: Record 5050;
//                                                                 ContBusRel@100000000 :
                                                                ContBusRel: Record 5054;
//                                                                 Txt001@100000002 :
                                                                Txt001: TextConst ESP='No puede usar el mismo contacto en dos representantes';
                                                              BEGIN 
                                                                IF "QB Attorney" <> '' THEN BEGIN 
                                                                  Cont.GET("QB Attorney");
                                                                  ContBusRel.FindOrRestoreContactBusinessRelation(Cont,Rec,ContBusRel."Link to Table"::Vendor);
                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    ERROR(Text003,Cont."No.",Cont.Name,"No.",Name);
                                                                END;

                                                                IF ("QB Attorney" <> '') THEN
                                                                  IF ("QB Attorney" = "QB Representative 2") OR ("QB Attorney" = "QB Representative PRL") THEN
                                                                    ERROR(Txt001);
                                                                CALCFIELDS("QB Attorney Name");
                                                              END;

trigger OnLookup();
    VAR
//                                                               Cont@100000002 :
                                                              Cont: Record 5050;
//                                                               ContBusRel@100000001 :
                                                              ContBusRel: Record 5054;
//                                                               TempVen@100000000 :
                                                              TempVen: Record 23 TEMPORARY;
                                                            BEGIN 
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FINDFIRST THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("No.",'');

                                                              IF "QB Attorney" <> '' THEN
                                                                IF Cont.GET("QB Attorney") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN 
                                                                //TempVen.COPY(Rec);
                                                                //FIND;
                                                                //TRANSFERFIELDS(TempVen,FALSE);
                                                                VALIDATE("QB Attorney",Cont."No.");
                                                              END;
                                                            END;


    }
    field(7207316;"QB Attorney Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Contact"."Name" WHERE ("No."=FIELD("QB Attorney")));
                                                   CaptionML=ENU='Nombre representante 1',ESP='Nombre Apoderado';
                                                   Description='QB 1.00 - QB2511 JAV 18/03/20: - Se pasan los representantes a contactos';
                                                   Editable=false;


    }
    field(7207317;"QB notary city";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Ante el notario',ESP='Ciudad del notario';
                                                   Description='QB 1.08.28 - JAV 24/03/21: - Nuevo campo referente a la ocnstituci¢n para los contratos';


    }
    field(7207318;"QB Reg. Sheet";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Ante el notario',ESP='Folio Registro';
                                                   Description='QB 1.08.28 - JAV 24/03/21: - Nuevo campo referente a la ocnstituci¢n para los contratos';


    }
    field(7207319;"QB Seg.Soc. Number";Text[15])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Patronal S.Social';
                                                   Description='QB 1.08.28 - JAV 24/03/21: - Nuevo campo referente a la ocnstituci¢n para los contratos';


    }
    field(7207320;"QW Calc Due Date";Option)
    {
        OptionMembers="Group","DocDate","WorkEnd","JobEnd";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Calculo Vto. Retenci¢n',ENG='Calc Due Date Withholding';
                                                   OptionCaptionML=ENU='By Withholding Group,By Document Date,By end of Work,By end of Job.',ESP='Seg£n Grupo Retenci¢n,Por Fecha Documento,Por Fin de Trabajo,Por Fin de obra.';
                                                   
                                                   Description='Q13647';


    }
    field(7207496;"QB Data Missed";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Data Missed';
                                                   Description='QB 1.00 - ELECNOR GEN001-02   OJO- Hace un transferfields de vendor a contact, hay que respetar las numeraciones, reservamos 7207400..7207459 para campos de contacto';
                                                   Editable=false;


    }
    field(7207497;"QB Data Missed Message";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Data Missed Message',ESP='Datos Obligatorios que faltan';
                                                   Description='QB 1.00 - ELECNOR GEN001-02';
                                                   Editable=false;


    }
    field(7207498;"QB Data Missed Old Blocked";Option)
    {
        OptionMembers=" ","Ship","Invoice","All";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Last Blocked';
                                                   OptionCaptionML=ENU='" ,Ship,Invoice,All"',ESP='" ,Env¡ar,Facturar,Todos"';
                                                   
                                                   Description='QB 1.00 - ELECNOR GEN001-02';


    }
    field(7207499;"QB Payable Bank No.";Code[20])
    {
        TableRelation="Bank Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='QB Payable Bank No.',ESP='N§ de banco de pago';
                                                   Description='QB 1.09.22 JAV 06/10/21 Banco por defecto para los pagos a este proveedor' ;


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
   // key(key3;"Vendor Posting Group")
  //  {
       /* ;
 */
   // }
   // key(key4;"Currency Code")
  //  {
       /* ;
 */
   // }
   // key(key5;"Priority")
  //  {
       /* ;
 */
   // }
   // key(key6;"Country/Region Code")
  //  {
       /* ;
 */
   // }
   // key(key7;"Gen. Bus. Posting Group")
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
      Text000: TextConst ENU='You cannot delete %1 %2 because there is at least one outstanding Purchase %3 for this vendor.',ESP='No puede borrar %1 %2 porque hay al menos una compra pendiente %3 para este proveedor.';
//       Text002@1001 :
      Text002: TextConst ENU='You have set %1 to %2. Do you want to update the %3 price list accordingly?',ESP='Tiene fijado %1 a %2. ¨Quiere actualizar el %3 lista precio en concordancia?';
//       Text003@1002 :
      Text003: TextConst ENU='Do you wish to create a contact for %1 %2?',ESP='¨Confirma que desea crear un contacto para %1 %2?';
//       PurchSetup@1003 :
      PurchSetup: Record 312;
//       CommentLine@1005 :
      CommentLine: Record 97;
//       PostCode@1007 :
      PostCode: Record 225;
//       VendBankAcc@1008 :
      VendBankAcc: Record 288;
//       OrderAddr@1009 :
      OrderAddr: Record 224;
//       GenBusPostingGrp@1010 :
      GenBusPostingGrp: Record 250;
//       ItemCrossReference@1016 :
//      ItemCrossReference: Record 5717;
//       RMSetup@1020 :
      RMSetup: Record 5079;
//       ServiceItem@1024 :
      ServiceItem: Record 5940;
//       SalespersonPurchaser@1050 :
      SalespersonPurchaser: Record 13;
//       CustomizedCalendarChange@1032 :
      CustomizedCalendarChange: Record 7602;
//       VendPmtAddr@1100000 :
      VendPmtAddr: Record 7000015;
//       NoSeriesMgt@1011 :
      NoSeriesMgt: Codeunit 396;
//       MoveEntries@1012 :
      MoveEntries: Codeunit 361;
//       UpdateContFromVend@1013 :
      UpdateContFromVend: Codeunit 5057;
//       DimMgt@1014 :
      DimMgt: Codeunit 408;
//       LeadTimeMgt@1006 :
      LeadTimeMgt: Codeunit 5404;
//       ApprovalsMgmt@1028 :
      ApprovalsMgmt: Codeunit 1535;
//       CalendarManagement@1033 :
      CalendarManagement: Codeunit 7600;
//       InsertFromContact@1015 :
      InsertFromContact: Boolean;
//       Text004@1019 :
      Text004: TextConst ENU='Contact %1 %2 is not related to vendor %3 %4.',ESP='Contacto %1 %2 no est  relacionado con proveedor %3 %4.';
//       Text005@1021 :
      Text005: TextConst ENU='post',ESP='registrar';
//       Text006@1022 :
      Text006: TextConst ENU='create',ESP='crear';
//       Text007@1023 :
      Text007: TextConst ENU='You cannot %1 this type of document when Vendor %2 is blocked with type %3',ESP='No puede %1 este tipo de documento cuando el proveedor %2 est  bloqueado por el tipo %3';
//       Text008@1025 :
      Text008: TextConst ENU='The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3.',ESP='%1 %2 se asign¢ a %3 %4.\No es posible seleccionar de nuevo %1 para m s de un %3.';
//       Text009@1027 :
      Text009: TextConst ENU='Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?',ESP='El control de transacciones de IC puede ser dif¡cil si cambia el campo C¢digo socio IC porque este %1 contiene movimientos contables de un ejercicio que a£n no est  cerrado.\ ¨Todav¡a quiere cambiar el campo C¢digo socio IC?';
//       Text010@1026 :
      Text010: TextConst ENU='You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.',ESP='No puede cambiar el contenido del campo %1. %2 contiene al menos un movimiento contable abierto.';
//       Text011@1004 :
      Text011: TextConst ENU='Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.',ESP='Para poder usar Online Map, primero debe rellenar la ventana Configuraci¢n Online Map.\Consulte Configuraci¢n de Online Map en la Ayuda.';
//       SelectVendorErr@1017 :
      SelectVendorErr: TextConst ENU='You must select an existing vendor.',ESP='Debe seleccionar un proveedor existente.';
//       CreateNewVendTxt@1129 :
      CreateNewVendTxt: 
// "%1 is the name to be used to create the customer. "
TextConst ENU='Create a new vendor card for %1.',ESP='Cree una nueva ficha de proveedor para %1.';
//       VendNotRegisteredTxt@1128 :
      VendNotRegisteredTxt: TextConst ENU='This vendor is not registered. To continue, choose one of the following options:',ESP='Este proveedor no est  registrado. Para continuar, elija una de las opciones siguientes:';
//       SelectVendTxt@1118 :
      SelectVendTxt: TextConst ENU='Select an existing vendor.',ESP='Seleccione un proveedor existente.';
//       InsertFromTemplate@1018 :
      InsertFromTemplate: Boolean;
//       PrivacyBlockedActionErr@1061 :
      PrivacyBlockedActionErr: 
// "%1 = action (create or post), %2 = vendor code."
TextConst ENU='You cannot %1 this type of document when Vendor %2 is blocked for privacy.',ESP='No puede %1 este tipo de documento cuando el proveedor %2 est  bloqueado por motivos de privacidad.';
//       PrivacyBlockedGenericTxt@1062 :
      PrivacyBlockedGenericTxt: 
// "%1 = vendor code"
TextConst ENU='Privacy Blocked must not be true for vendor %1.',ESP='La opci¢n Privacidad bloqueada no debe ser verdadera para el proveedor %1.';
//       ConfirmBlockedPrivacyBlockedQst@1030 :
      ConfirmBlockedPrivacyBlockedQst: TextConst ENU='if you change the Blocked field, the Privacy Blocked field is changed to No. Do you want to continue?',ESP='Si cambia el campo Bloqueado, se cambiar  el campo Privacidad bloqueada a No. ¨Desea continuar?';
//       CanNotChangeBlockedDueToPrivacyBlockedErr@1029 :
      CanNotChangeBlockedDueToPrivacyBlockedErr: TextConst ENU='The Blocked field cannot be changed because the user is blocked for privacy reasons.',ESP='No se puede cambiar el campo Bloqueado porque el usuario est  bloqueado por motivos de privacidad.';
//       PhoneNoCannotContainLettersErr@1031 :
      PhoneNoCannotContainLettersErr: TextConst ENU='You cannot enter letters in this field.',ESP='No puede introducir letras en este campo.';

    
    


/*
trigger OnInsert();    begin
               if "No." = '' then begin
                 PurchSetup.GET;
                 PurchSetup.TESTFIELD("Vendor Nos.");
                 NoSeriesMgt.InitSeries(PurchSetup."Vendor Nos.",xRec."No. Series",0D,"No.","No. Series");
               end;

               if "Invoice Disc. Code" = '' then
                 "Invoice Disc. Code" := "No.";

               "Payment Days Code" := "No.";
               "Non-Paymt. Periods Code" := "No.";

               if not (InsertFromContact or (InsertFromTemplate and (Contact <> ''))) then
                 UpdateContFromVend.OnInsert(Rec);

               if "Purchaser Code" = '' then
                 SetDefaultPurchaser;

               DimMgt.UpdateDefaultDim(
                 DATABASE::Vendor,"No.",
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
                 UpdateContFromVend.OnModify(Rec);
                 if not FIND then begin
                   RESET;
                   if FIND then;
                 end;
               end;
             end;


*/

/*
trigger OnDelete();    var
//                ItemVendor@1000 :
               ItemVendor: Record 99;
//                PurchPrice@1001 :
               PurchPrice: Record 7012;
//                PurchLineDiscount@1002 :
               PurchLineDiscount: Record 7014;
//                PurchPrepmtPct@1003 :
               PurchPrepmtPct: Record 460;
//                SocialListeningSearchTopic@1005 :
               SocialListeningSearchTopic: Record 871;
//                CustomReportSelection@1006 :
               CustomReportSelection: Record 9657;
//                PurchOrderLine@1007 :
               PurchOrderLine: Record 39;
//                IntrastatSetup@1008 :
               IntrastatSetup: Record 247;
//                VATRegistrationLogMgt@1004 :
               VATRegistrationLogMgt: Codeunit 249;
//                DocumentMove@1100000 :
               DocumentMove: Codeunit 7000004;
             begin
               ApprovalsMgmt.OnCancelVendorApprovalRequest(Rec);

               MoveEntries.MoveVendorEntries(Rec);

               DocumentMove.MovePayableDocs(Rec);

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Vendor);
               CommentLine.SETRANGE("No.","No.");
               if not CommentLine.ISEMPTY then
                 CommentLine.DELETEALL;

               VendBankAcc.SETRANGE("Vendor No.","No.");
               if not VendBankAcc.ISEMPTY then
                 VendBankAcc.DELETEALL;

               OrderAddr.SETRANGE("Vendor No.","No.");
               if not OrderAddr.ISEMPTY then
                 OrderAddr.DELETEALL;

               VendPmtAddr.SETRANGE("Vendor No.","No.");
               if VendPmtAddr.FINDFIRST then
                 VendPmtAddr.DELETEALL;

               ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
               ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Vendor);
               ItemCrossReference.SETRANGE("Cross-Reference Type No.","No.");
               if not ItemCrossReference.ISEMPTY then
                 ItemCrossReference.DELETEALL;

               PurchOrderLine.SETCURRENTKEY("Document Type","Pay-to Vendor No.");
               PurchOrderLine.SETRANGE("Pay-to Vendor No.","No.");
               if PurchOrderLine.FINDFIRST then
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.",
                   PurchOrderLine."Document Type");

               PurchOrderLine.SETRANGE("Pay-to Vendor No.");
               PurchOrderLine.SETRANGE("Buy-from Vendor No.","No.");
               if not PurchOrderLine.ISEMPTY then
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.");

               UpdateContFromVend.OnDelete(Rec);

               DimMgt.DeleteDefaultDim(DATABASE::Vendor,"No.");

               ServiceItem.SETRANGE("Vendor No.","No.");
               if not ServiceItem.ISEMPTY then
                 ServiceItem.MODIFYALL("Vendor No.",'');

               ItemVendor.SETRANGE("Vendor No.","No.");
               if not ItemVendor.ISEMPTY then
                 ItemVendor.DELETEALL(TRUE);

               if not SocialListeningSearchTopic.ISEMPTY then begin
                 SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Vendor,"No.");
                 SocialListeningSearchTopic.DELETEALL;
               end;

               PurchPrice.SETCURRENTKEY("Vendor No.");
               PurchPrice.SETRANGE("Vendor No.","No.");
               if not PurchPrice.ISEMPTY then
                 PurchPrice.DELETEALL(TRUE);

               PurchLineDiscount.SETCURRENTKEY("Vendor No.");
               PurchLineDiscount.SETRANGE("Vendor No.","No.");
               if not PurchLineDiscount.ISEMPTY then
                 PurchLineDiscount.DELETEALL(TRUE);

               CustomReportSelection.SETRANGE("Source Type",DATABASE::Vendor);
               CustomReportSelection.SETRANGE("Source No.","No.");
               if not CustomReportSelection.ISEMPTY then
                 CustomReportSelection.DELETEALL;

               PurchPrepmtPct.SETCURRENTKEY("Vendor No.");
               PurchPrepmtPct.SETRANGE("Vendor No.","No.");
               if not PurchPrepmtPct.ISEMPTY then
                 PurchPrepmtPct.DELETEALL(TRUE);

               VATRegistrationLogMgt.DeleteVendorLog(Rec);

               IntrastatSetup.CheckDeleteIntrastatContact(IntrastatSetup."Intrastat Contact Type"::Vendor,"No.");

               CalendarManagement.DeleteCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::Vendor,"No.");
             end;


*/

/*
trigger OnRename();    begin
               ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);
               DimMgt.RenameDefaultDim(DATABASE::Vendor,xRec."No.","No.");
               SetLastModifiedDateTime;
               if xRec."Invoice Disc. Code" = xRec."No." then
                 "Invoice Disc. Code" := "No.";

               CalendarManagement.RenameCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::Vendor,"No.",xRec."No.");
             end;

*/



// procedure AssistEdit (OldVend@1000 :

/*
procedure AssistEdit (OldVend: Record 23) : Boolean;
    var
//       Vend@1001 :
      Vend: Record 23;
    begin
      WITH Vend DO begin
        Vend := Rec;
        PurchSetup.GET;
        PurchSetup.TESTFIELD("Vendor Nos.");
        if NoSeriesMgt.SelectSeries(PurchSetup."Vendor Nos.",OldVend."No. Series","No. Series") then begin
          PurchSetup.GET;
          PurchSetup.TESTFIELD("Vendor Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := Vend;
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
      DimMgt.SaveDefaultDim(DATABASE::Vendor,"No.",FieldNumber,ShortcutDimCode);
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
//       OfficeContact@1003 :
      OfficeContact: Record 5050;
//       OfficeMgt@1002 :
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
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
        ContBusRel.SETRANGE("No.","No.");
        if not ContBusRel.FINDFIRST then begin
          if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text003,TABLECAPTION,"No."),TRUE) then
            exit;
          UpdateContFromVend.InsertNewContact(Rec,FALSE);
          ContBusRel.FINDFIRST;
        end;
        COMMIT;

        Cont.FILTERGROUP(2);
        Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
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


    
//     procedure CheckBlockedVendOnDocs (Vend2@1003 : Record 23;Transaction@1000 :
    
/*
procedure CheckBlockedVendOnDocs (Vend2: Record 23;Transaction: Boolean)
    begin
      if Vend2."Privacy Blocked" then
        VendPrivacyBlockedErrorMessage(Vend2,Transaction);

      if Vend2.Blocked = Vend2.Blocked::All then
        VendBlockedErrorMessage(Vend2,Transaction);
    end;
*/


    
//     procedure CheckBlockedVendOnJnls (Vend2@1005 : Record 23;DocType@1004 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';Transaction@1003 :
    
/*
procedure CheckBlockedVendOnJnls (Vend2: Record 23;DocType: Option " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund";Transaction: Boolean)
    begin
      WITH Vend2 DO begin
        if "Privacy Blocked" then
          VendPrivacyBlockedErrorMessage(Vend2,Transaction);

        if (Blocked = Blocked::All) or
           (Blocked = Blocked::Payment) and (DocType = DocType::Payment)
        then
          VendBlockedErrorMessage(Vend2,Transaction);
      end;
    end;
*/


    
    
/*
procedure CreateAndShowNewInvoice ()
    var
//       PurchaseHeader@1000 :
      PurchaseHeader: Record 38;
    begin
      PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
      PurchaseHeader.SETRANGE("Buy-from Vendor No.","No.");
      PurchaseHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Purchase Invoice",PurchaseHeader)
    end;
*/


    
    
/*
procedure CreateAndShowNewCreditMemo ()
    var
//       PurchaseHeader@1000 :
      PurchaseHeader: Record 38;
    begin
      PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
      PurchaseHeader.SETRANGE("Buy-from Vendor No.","No.");
      PurchaseHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Purchase Credit Memo",PurchaseHeader)
    end;
*/


    
    
/*
procedure CreateAndShowNewPurchaseOrder ()
    var
//       PurchaseHeader@1000 :
      PurchaseHeader: Record 38;
    begin
      PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
      PurchaseHeader.SETRANGE("Buy-from Vendor No.","No.");
      PurchaseHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Purchase Order",PurchaseHeader);
    end;
*/


    
//     procedure VendBlockedErrorMessage (Vend2@1001 : Record 23;Transaction@1002 :
    
/*
procedure VendBlockedErrorMessage (Vend2: Record 23;Transaction: Boolean)
    var
//       Action@1000 :
      Action: Text[30];
    begin
      if Transaction then
        Action := Text005
      else
        Action := Text006;
      ERROR(Text007,Action,Vend2."No.",Vend2.Blocked);
    end;
*/


    
//     procedure VendPrivacyBlockedErrorMessage (Vend2@1001 : Record 23;Transaction@1002 :
    
/*
procedure VendPrivacyBlockedErrorMessage (Vend2: Record 23;Transaction: Boolean)
    var
//       Action@1000 :
      Action: Text[30];
    begin
      if Transaction then
        Action := Text005
      else
        Action := Text006;

      ERROR(PrivacyBlockedActionErr,Action,Vend2."No.");
    end;
*/


    
//     procedure GetPrivacyBlockedGenericErrorText (Vend2@1001 :
    
/*
procedure GetPrivacyBlockedGenericErrorText (Vend2: Record 23) : Text[250];
    begin
      exit(STRSUBSTNO(PrivacyBlockedGenericTxt,Vend2."No."));
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
        MapMgt.MakeSelection(DATABASE::Vendor,GETPOSITION)
      else
        MESSAGE(Text011);
    end;
*/


    
    
/*
procedure CalcOverDueBalance () OverDueBalance : Decimal;
    var
//       VendLedgEntryRemainAmtQuery@1001 :
      VendLedgEntryRemainAmtQuery: Query 25 SECURITYFILTERING(Filtered);
    begin
      VendLedgEntryRemainAmtQuery.SETRANGE(Vendor_No,"No.");
      VendLedgEntryRemainAmtQuery.SETRANGE(IsOpen,TRUE);
      VendLedgEntryRemainAmtQuery.SETFILTER(Due_Date,'<%1',WORKDATE);
      VendLedgEntryRemainAmtQuery.OPEN;

      if VendLedgEntryRemainAmtQuery.READ then
        OverDueBalance := -VendLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    end;
*/


    
    
/*
procedure GetInvoicedPrepmtAmountLCY () : Decimal;
    var
//       PurchLine@1000 :
      PurchLine: Record 39;
    begin
      PurchLine.SETCURRENTKEY("Document Type","Pay-to Vendor No.");
      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
      PurchLine.SETRANGE("Pay-to Vendor No.","No.");
      PurchLine.CALCSUMS("Prepmt. Amount Inv. (LCY)","Prepmt. VAT Amount Inv. (LCY)");
      exit(PurchLine."Prepmt. Amount Inv. (LCY)" + PurchLine."Prepmt. VAT Amount Inv. (LCY)");
    end;
*/


    
    
/*
procedure GetTotalAmountLCY () : Decimal;
    begin
      CALCFIELDS(
        "Balance (LCY)","Outstanding Orders (LCY)","Amt. Rcd. not Invoiced (LCY)","Outstanding Invoices (LCY)");

      exit(
        "Balance (LCY)" + "Outstanding Orders (LCY)" +
        "Amt. Rcd. not Invoiced (LCY)" + "Outstanding Invoices (LCY)" - GetInvoicedPrepmtAmountLCY);
    end;
*/


    
    
/*
procedure HasAddress () : Boolean;
    begin
      CASE TRUE OF
        Address <> '':
          exit(TRUE);
        "Address 2" <> '':
          exit(TRUE);
        City <> '':
          exit(TRUE);
        "Country/Region Code" <> '':
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


    
//     procedure GetVendorNo (VendorText@1000 :
    
/*
procedure GetVendorNo (VendorText: Text[50]) : Code[20];
    begin
      exit(GetVendorNoOpenCard(VendorText,TRUE));
    end;
*/


    
//     procedure GetVendorNoOpenCard (VendorText@1000 : Text[50];ShowVendorCard@1006 :
    
/*
procedure GetVendorNoOpenCard (VendorText: Text[50];ShowVendorCard: Boolean) : Code[20];
    var
//       Vendor@1001 :
      Vendor: Record 23;
//       VendorNo@1002 :
      VendorNo: Code[20];
//       NoFiltersApplied@1007 :
      NoFiltersApplied: Boolean;
//       VendorWithoutQuote@1003 :
      VendorWithoutQuote: Text;
//       VendorFilterFromStart@1004 :
      VendorFilterFromStart: Text;
//       VendorFilterContains@1005 :
      VendorFilterContains: Text;
    begin
      if VendorText = '' then
        exit('');

      if STRLEN(VendorText) <= MAXSTRLEN(Vendor."No.") then
        if Vendor.GET(VendorText) then
          exit(Vendor."No.");

      VendorWithoutQuote := CONVERTSTR(VendorText,'''','?');

      Vendor.SETFILTER(Name,'''@' + VendorWithoutQuote + '''');
      if Vendor.FINDFIRST then
        exit(Vendor."No.");
      Vendor.SETRANGE(Name);

      VendorFilterFromStart := '''@' + VendorWithoutQuote + '*''';

      Vendor.FILTERGROUP := -1;
      Vendor.SETFILTER("No.",VendorFilterFromStart);
      Vendor.SETFILTER(Name,VendorFilterFromStart);
      if Vendor.FINDFIRST then
        exit(Vendor."No.");

      VendorFilterContains := '''@*' + VendorWithoutQuote + '*''';

      Vendor.SETFILTER("No.",VendorFilterContains);
      Vendor.SETFILTER(Name,VendorFilterContains);
      Vendor.SETFILTER(City,VendorFilterContains);
      Vendor.SETFILTER(Contact,VendorFilterContains);
      Vendor.SETFILTER("Phone No.",VendorFilterContains);
      Vendor.SETFILTER("Post Code",VendorFilterContains);

      if Vendor.COUNT = 0 then
        MarkVendorsWithSimilarName(Vendor,VendorText);

      if Vendor.COUNT = 1 then begin
        Vendor.FINDFIRST;
        exit(Vendor."No.");
      end;

      if not GUIALLOWED then
        ERROR(SelectVendorErr);

      if Vendor.COUNT = 0 then begin
        if Vendor.WRITEPERMISSION then
          CASE STRMENU(STRSUBSTNO('%1,%2',STRSUBSTNO(CreateNewVendTxt,VendorText),SelectVendTxt),1,VendNotRegisteredTxt) OF
            0:
              ERROR(SelectVendorErr);
            1:
              exit(CreateNewVendor(COPYSTR(VendorText,1,MAXSTRLEN(Vendor.Name)),ShowVendorCard));
          end;
        Vendor.RESET;
        NoFiltersApplied := TRUE;
      end;

      if ShowVendorCard then
        VendorNo := PickVendor(Vendor,NoFiltersApplied)
      else
        exit('');

      if VendorNo <> '' then
        exit(VendorNo);

      ERROR(SelectVendorErr);
    end;
*/


//     LOCAL procedure MarkVendorsWithSimilarName (var Vendor@1001 : Record 23;VendorText@1000 :
    
/*
LOCAL procedure MarkVendorsWithSimilarName (var Vendor: Record 23;VendorText: Text)
    var
//       TypeHelper@1002 :
      TypeHelper: Codeunit 10;
//       VendorCount@1003 :
      VendorCount: Integer;
//       VendorTextLenght@1004 :
      VendorTextLenght: Integer;
//       Treshold@1005 :
      Treshold: Integer;
    begin
      if VendorText = '' then
        exit;
      if STRLEN(VendorText) > MAXSTRLEN(Vendor.Name) then
        exit;
      VendorTextLenght := STRLEN(VendorText);
      Treshold := VendorTextLenght DIV 5;
      if Treshold = 0 then
        exit;
      Vendor.RESET;
      Vendor.ASCENDING(FALSE); // most likely to search for newest Vendors
      if Vendor.FINDSET then
        repeat
          VendorCount += 1;
          if ABS(VendorTextLenght - STRLEN(Vendor.Name)) <= Treshold then
            if TypeHelper.TextDistance(UPPERCASE(VendorText),UPPERCASE(Vendor.Name)) <= Treshold then
              Vendor.MARK(TRUE);
        until Vendor.MARK or (Vendor.NEXT = 0) or (VendorCount > 1000);
      Vendor.MARKEDONLY(TRUE);
    end;
*/


//     LOCAL procedure CreateNewVendor (VendorName@1000 : Text[50];ShowVendorCard@1001 :
    
/*
LOCAL procedure CreateNewVendor (VendorName: Text[50];ShowVendorCard: Boolean) : Code[20];
    var
//       Vendor@1005 :
      Vendor: Record 23;
//       MiniVendorTemplate@1006 :
      MiniVendorTemplate: Record 1303;
//       VendorCard@1002 :
      VendorCard: Page 26;
    begin
      if not MiniVendorTemplate.NewVendorFromTemplate(Vendor) then
        ERROR(SelectVendorErr);

      Vendor.Name := VendorName;
      Vendor.MODIFY(TRUE);
      COMMIT;
      if not ShowVendorCard then
        exit(Vendor."No.");
      Vendor.SETRANGE("No.",Vendor."No.");
      VendorCard.SETTABLEVIEW(Vendor);
      if not (VendorCard.RUNMODAL = ACTION::OK) then
        ERROR(SelectVendorErr);

      exit(Vendor."No.");
    end;
*/


//     LOCAL procedure PickVendor (var Vendor@1000 : Record 23;NoFiltersApplied@1002 :
    
/*
LOCAL procedure PickVendor (var Vendor: Record 23;NoFiltersApplied: Boolean) : Code[20];
    var
//       VendorList@1001 :
      VendorList: Page 27;
    begin
      if not NoFiltersApplied then
        MarkVendorsByFilters(Vendor);

      VendorList.SETTABLEVIEW(Vendor);
      VendorList.SETRECORD(Vendor);
      VendorList.LOOKUPMODE := TRUE;
      if VendorList.RUNMODAL = ACTION::LookupOK then
        VendorList.GETRECORD(Vendor)
      else
        CLEAR(Vendor);

      exit(Vendor."No.");
    end;
*/


//     LOCAL procedure MarkVendorsByFilters (var Vendor@1000 :
    
/*
LOCAL procedure MarkVendorsByFilters (var Vendor: Record 23)
    begin
      if Vendor.FINDSET then
        repeat
          Vendor.MARK(TRUE);
        until Vendor.NEXT = 0;
      if Vendor.FINDFIRST then;
      Vendor.MARKEDONLY := TRUE;
    end;
*/


    
//     procedure OpenVendorLedgerEntries (FilterOnDueEntries@1002 :
    
/*
procedure OpenVendorLedgerEntries (FilterOnDueEntries: Boolean)
    var
//       DetailedVendorLedgEntry@1001 :
      DetailedVendorLedgEntry: Record 380;
//       VendorLedgerEntry@1000 :
      VendorLedgerEntry: Record 25;
    begin
      DetailedVendorLedgEntry.SETRANGE("Vendor No.","No.");
      COPYFILTER("Global Dimension 1 Filter",DetailedVendorLedgEntry."Initial Entry Global Dim. 1");
      COPYFILTER("Global Dimension 2 Filter",DetailedVendorLedgEntry."Initial Entry Global Dim. 2");
      if FilterOnDueEntries and (GETFILTER("Date Filter") <> '') then begin
        COPYFILTER("Date Filter",DetailedVendorLedgEntry."Initial Entry Due Date");
        DetailedVendorLedgEntry.SETFILTER("Posting Date",'<=%1',GETRANGEMAX("Date Filter"));
      end;
      COPYFILTER("Currency Filter",DetailedVendorLedgEntry."Currency Code");
      VendorLedgerEntry.DrillDownOnEntries(DetailedVendorLedgEntry);
    end;
*/


    
/*
LOCAL procedure IsContactUpdateNeeded () : Boolean;
    var
//       VendContUpdate@1001 :
      VendContUpdate: Codeunit 5057;
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
        ("Purchaser Code" <> xRec."Purchaser Code") or
        ("Country/Region Code" <> xRec."Country/Region Code") or
        ("Fax No." <> xRec."Fax No.") or
        ("Telex Answer Back" <> xRec."Telex Answer Back") or
        ("VAT Registration No." <> xRec."VAT Registration No.") or
        ("Post Code" <> xRec."Post Code") or
        (County <> xRec.County) or
        ("E-Mail" <> xRec."E-Mail") or
        ("Home Page" <> xRec."Home Page");

      if not UpdateNeeded and not ISTEMPORARY then
        UpdateNeeded := VendContUpdate.ContactNameIsBlank("No.");

      OnBeforeIsContactUpdateNeeded(Rec,xRec,UpdateNeeded);
      exit(UpdateNeeded);
    end;
*/


    
//     procedure SetInsertFromTemplate (FromTemplate@1000 :
    
/*
procedure SetInsertFromTemplate (FromTemplate: Boolean)
    begin
      InsertFromTemplate := FromTemplate;
    end;
*/


    
//     procedure SetAddress (VendorAddress@1001 : Text[50];VendorAddress2@1002 : Text[50];VendorPostCode@1003 : Code[20];VendorCity@1000 : Text[30];VendorCounty@1004 : Text[30];VendorCountryCode@1005 : Code[10];VendorContact@1006 :
    
/*
procedure SetAddress (VendorAddress: Text[50];VendorAddress2: Text[50];VendorPostCode: Code[20];VendorCity: Text[30];VendorCounty: Text[30];VendorCountryCode: Code[10];VendorContact: Text[50])
    begin
      Address := VendorAddress;
      "Address 2" := VendorAddress2;
      "Post Code" := VendorPostCode;
      City := VendorCity;
      County := VendorCounty;
      "Country/Region Code" := VendorCountryCode;
      UpdateContFromVend.OnModify(Rec);
      Contact := VendorContact;
    end;
*/


    
/*
LOCAL procedure SetDefaultPurchaser ()
    var
//       UserSetup@1000 :
      UserSetup: Record 91;
    begin
      if not UserSetup.GET(USERID) then
        exit;

      if UserSetup."Salespers./Purch. Code" <> '' then
        VALIDATE("Purchaser Code",UserSetup."Salespers./Purch. Code");
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
//       VATRegistrationLog@1005 :
      VATRegistrationLog: Record 249;
//       VATRegistrationNoFormat@1004 :
      VATRegistrationNoFormat: Record 381;
//       VATRegNoSrvConfig@1003 :
      VATRegNoSrvConfig: Record 248;
//       VATRegistrationLogMgt@1002 :
      VATRegistrationLogMgt: Codeunit 249;
//       ResultRecordRef@1001 :
      ResultRecordRef: RecordRef;
//       ApplicableCountryCode@1000 :
      ApplicableCountryCode: Code[10];
    begin
      if not VATRegistrationNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor) then
        exit;
      VATRegistrationLogMgt.LogVendor(Rec);

      if ("Country/Region Code" = '') and (VATRegistrationNoFormat."Country/Region Code" = '') then
        exit;
      ApplicableCountryCode := "Country/Region Code";
      if ApplicableCountryCode = '' then
        ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
      if VATRegNoSrvConfig.VATRegNoSrvIsEnabled then begin
        VATRegistrationLogMgt.ValidateVATRegNoWithVIES(ResultRecordRef,Rec,"No.",
          VATRegistrationLog."Account Type"::Vendor,ApplicableCountryCode);
        ResultRecordRef.SETTABLE(Rec);
      end;
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
      UpdatePaymentMethodId;
    end;
*/


    
//     procedure GetReferencedIds (var TempField@1000 :
    
/*
procedure GetReferencedIds (var TempField: Record 2000000041 TEMPORARY)
    var
//       DataTypeManagement@1001 :
      DataTypeManagement: Codeunit 701;
    begin
      DataTypeManagement.InsertFieldToBuffer(TempField,DATABASE::Vendor,FIELDNO("Currency Id"));
      DataTypeManagement.InsertFieldToBuffer(TempField,DATABASE::Vendor,FIELDNO("Payment Terms Id"));
      DataTypeManagement.InsertFieldToBuffer(TempField,DATABASE::Vendor,FIELDNO("Payment Method Id"));
    end;
*/


    
/*
LOCAL procedure ValidatePurchaserCode ()
    begin
      if "Purchaser Code" <> '' then
        if SalespersonPurchaser.GET("Purchaser Code") then
          if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
            ERROR(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser,FALSE))
    end;
*/


    
//     LOCAL procedure OnBeforeIsContactUpdateNeeded (Vendor@1000 : Record 23;xVendor@1001 : Record 23;var UpdateNeeded@1002 :
    
/*
LOCAL procedure OnBeforeIsContactUpdateNeeded (Vendor: Record 23;xVendor: Record 23;var UpdateNeeded: Boolean)
    begin
    end;

    /*begin
    //{
//      JAV 19/02/19: - Se a¤ade el campo 50000 "No. Actividades" con el N§ de actividades asociadas al proveedor
//      PEL 19/03/19: - OBR Creado campo Obralia
//      JAV 08/05/19: - Se a¤ade el campo 50001 "Quantity available contracts"
//      JAV 30/06/19: - Se a¤ade el campo 50002 "No controlar en contratos"
//      PGM 12/07/19: - GAP006 Creado el campo Category asociado a la tabla Contact Categories
//      PGM 19/07/19: - GAP003 Creado los campos "Activity Code" y "Activiy Description"
//      JAV 18/10/19: - Se hace que el campo "Pending Withholding Amount solo sume B.E. pendiente, no todas pues no tiene sentido sumar con IRPF
//      JAV 15/11/19: - Se a¤aden los campos de plazo de validez de ofertas y periodo de garant¡a
//      JAV 20/11/19: - Se renumera n§ actividades para que est‚ en el vertical
//                    - Se a¤ade informaci¢n de los certificados obligatorios
//      QuoSII_1.3.02.005 171108 MCM - Se incluyen los campo Servicio y "Entry No." para el RENAME la tabla SII Document
//                                     Se incluye el campo "Entry No." para el RENAME la tabla SII Shipment Line
//      QuoSII1.4 23/04/18 PEL - Cambiado primer semestre en Purch. Invoice Type, Purch. Invoice Type 1 y Purch. Invoice Type 2
//      QuoSII1.4 23/04/18 PEL - Nuevas validaciones en Special Regiments
//      QuoSII_1.4.0.017 MCM 04/07/18 - Se modifica el emisor en facturas intracomunitarias.
//      QuoSII_1.4.97.999 15/07/19 QMD - Traer datos del nuevo campo VAT Reg No. Type de la tabla Country/Region
//      Q12932 HAN 03/03/21 Correct TempCust variable in the function QB Representative PRL - OnLookup() to point to Vendor not Customer
//      Q13647 MMS 30/06/21 Para mejorar las Retenciones, se crea el campo Option "Calc Due Date",ÊC lculo del VencimientoË y valores: Fecha Documento, Fin de Trabajo, Fin de obra..
//      QuoSII1.5z 15/09/21 JAV - Mejora en el manejo de los campos del r‚gimen especial, se pasa todo el c¢digo a la CU de manejo de objetos est ndar del QuoSII
//      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)
//    }
    end.
  */
}




