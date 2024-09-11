tableextension 50114 "MyExtension50114" extends "Sales Line"
{
  
  
    CaptionML=ENU='Sales Line',ESP='L¡n. venta';
    LookupPageID="Sales Lines";
    DrillDownPageID="Sales Lines";
  
  fields
{
    field(50001;"Price review line";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Price review line',ESP='Linea revision precio';
                                                   Description='Q12733';


    }
    field(50002;"G.E.W. mod.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='G.E.W. mod.',ESP='Ret. B.E. modificada';
                                                   Description='BS::20668';
                                                   Editable=false;


    }
    field(50003;"Do not print";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Do not print',ESP='No imprimir';
                                                   Description='BS::20479';


    }
    field(7174331;"QuoSII Situacion Inmueble";Code[2])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("PropertyLocation"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Property Situation',ESP='Situacion Inmueble';
                                                   Description='QuoSII.007';


    }
    field(7174332;"QuoSII Referencia Catastral";Code[25])
    {
        CaptionML=ENU='Cadastral Reference',ESP='Referencia Catastral';
                                                   Description='QuoSII.007';


    }
    field(7174333;"QuoSII Entity";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SIIEntity"),
                                                                                                   "SII Entity"=CONST(''));
                                                   

                                                   CaptionML=ENU='SII Entity',ESP='Entidad SII';
                                                   Description='QuoSII_1.4.2.042';

trigger OnValidate();
    VAR
//                                                                 SalesLine@7174331 :
                                                                SalesLine: Record 37;
                                                              BEGIN 
                                                              END;


    }
    field(7207270;"QW % Withholding by GE";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by G.E',ESP='% retenci¢n pago B.E.';
                                                   Description='QB 1.00 - QB22111     JAV 19/09/19: - Se cambia el caption';
                                                   Editable=false;


    }
    field(7207271;"QW Withholding Amount by GE";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Wittholding Amount by G.E',ESP='Importe retenci¢n pago B.E.';
                                                   Description='QB 1.00 - QB22111     JAV 19/09/19: - Se cambia el caption';
                                                   Editable=false;


    }
    field(7207272;"QW % Withholding by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding PIT',ESP='% retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207273;"QW Withholding Amount by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Withholding Amount by PIT',ESP='Importe retenci¢n por IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207274;"QB Certification code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Certification code',ESP='C¢d. certificaci¢n';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207275;"QB Certification Line No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Certification Line No.',ESP='N§ l¡nea de certificaci¢n';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207276;"OLD_Certification Piecework No";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='No. Unidad obra certificacion',ESP='N§ Unidad obra certificaci¢n';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(7207277;"QB Milestone No.";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Field No.',ESP='N§ de hito';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207278;"QB Usage Document";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Usage Document',ESP='Documento Utilizaci¢n';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207279;"QB Usage Document Line";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Usage Document Line',ESP='L¡n. Documento Utilizaci¢n';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207280;"QB Temp Job No";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   Description='QB 1,04 - JAV 12/05/20: Guardo temporalemente el proyecto para poder eliminarlo y volverlo a recuperar tras un proceso';


    }
    field(7207281;"QB Temp Dimension Set ID";Integer)
    {
        TableRelation="Dimension Set Entry";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Dimension Set ID';
                                                   Description='QB 1,04 - JAV 12/05/20: Guardo temporalemente el ID para poderlo recuperar tras un proceso';
                                                   Editable=false;

trigger OnValidate();
    BEGIN 
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

trigger OnLookup();
    BEGIN 
                                                              ShowDimensions;
                                                            END;


    }
    field(7207282;"QB Prepayment Line";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='L¡nea del anticipo';
                                                   Description='QB 1.06 - JAV 28/06/20: - Si esta l¡nea se ha creado para descontar el anticipo';


    }
    field(7207283;"QW Not apply Withholding by GE";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='No aplicar ret. B.E.';
                                                   Description='QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci¢n por Buena Ejecuci¢n a la linea';

trigger OnValidate();
    VAR
//                                                                 Withholdingtreating@100000000 :
                                                                Withholdingtreating: Codeunit 7207306;
                                                              BEGIN 
                                                                //JAV 11/08/19: - Campo nuevo que indica si no se plica la retenci¢n de B.E.
                                                                Withholdingtreating.CalculateWithholding_SalesLine(Rec, FALSE);
                                                              END;


    }
    field(7207284;"QW Not apply Withholding PIT";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by PIT',ESP='No aplicar ret. IRPF';
                                                   Description='QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci¢n por IRPF a la l¡nea     JAV 19/09/19: - Se cambia el caption';

trigger OnValidate();
    VAR
//                                                                 Withholdingtreating@100000000 :
                                                                Withholdingtreating: Codeunit 7207306;
                                                              BEGIN 
                                                                //JAV 11/08/19: - Campo nuevo que indica si no se plica la retenci¢n de B.E.
                                                                Withholdingtreating.CalculateWithholding_SalesLine(Rec, FALSE);
                                                              END;


    }
    field(7207285;"QW Base Withholding by GE";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by G.E',ESP='Base ret. pago B.E.';
                                                   Description='QB 1.00 - JAV 11/08/19: - Base de c lculo de la retenci¢n por B.E.';
                                                   Editable=false;


    }
    field(7207286;"QW Base Withholding by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by PIT',ESP='Base ret. IRPF';
                                                   Description='QB 1.00 - JAV 11/08/19: - Base de c lculo de la retenci¢n por IRPF';
                                                   Editable=false;


    }
    field(7207287;"QW Withholding by GE Line";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='L¡nea de retenci¢n de B.E.';
                                                   Description='QB 1.00 - JAV 18/08/19: - Si es la l¡nea donde se calcula la retenci¢n por Buena Ejecuci¢n';


    }
    field(7238177;"QB_Piecework No.";Text[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Piecework No.',ESP='Partida presupuestaria';
                                                   Description='QPR 0.00.02.15431';

trigger OnValidate();
    VAR
//                                                                 Job@1100286000 :
                                                                Job: Record 167;
//                                                                 Item@1100286001 :
                                                                Item: Record 27;
//                                                                 txtQB000@1100286002 :
                                                                txtQB000: TextConst ESP='No ha seleccionado un proyecto';
//                                                                 txtQB001@1100286003 :
                                                                txtQB001: TextConst ESP='Solo puede comprar contra almac‚mn productos';
//                                                                 txtQB002@1100286004 :
                                                                txtQB002: TextConst ESP='No existe el producto';
//                                                                 txtQB003@1100286005 :
                                                                txtQB003: TextConst ESP='Solo puede comprar contra almac‚n productos de tipo inventario';
//                                                                 InventoryPostingSetup@1100286006 :
                                                                InventoryPostingSetup: Record 5813;
                                                              BEGIN 
                                                              END;


    }
    field(7238178;"Job No. QB";Code[20])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No. QB',ESP='N§ proyecto QB';
                                                   Description='Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)' ;


    }
}
  keys
{
   // key(key1;"Document Type","Document No.","Line No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(No2;"Document No.","Line No.","Document Type")
   // {
       /* ;
 */
   // }
   // key(key3;"Document Type","Type","No.","Variant Code","Drop Shipment","Location Code","Shipment Date")
  //  {
       /* SumIndexFields="Outstanding Qty. (Base)";
 */
   // }
   // key(key4;"Document Type","Bill-to Customer No.","Currency Code","Document No.")
  //  {
       /* SumIndexFields="Outstanding Amount","Shipped Not Invoiced","Outstanding Amount (LCY)","Shipped Not Invoiced (LCY)","Return Rcd. Not Invd. (LCY)";
 */
   // }
   // key(No5;"Document Type","Type","No.","Variant Code","Drop Shipment","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Location Code","Shipment Date")
   // {
       /* SumIndexFields="Outstanding Qty. (Base)";
 */
   // }
   // key(No6;"Document Type","Bill-to Customer No.","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Currency Code","Document No.")
   // {
       /* SumIndexFields="Outstanding Amount","Shipped Not Invoiced","Outstanding Amount (LCY)","Shipped Not Invoiced (LCY)";
 */
   // }
   // key(key7;"Document Type","Blanket Order No.","Blanket Order Line No.")
  //  {
       /* ;
 */
   // }
   // key(key8;"Document Type","Document No.","Location Code")
  //  {
       /* //SumIndexFields="Amount","Amount Including VAT","Outstanding Amount","Shipped Not Invoiced","Outstanding Amount (LCY)","Shipped Not Invoiced (LCY)"
                                                   MaintainSQLIndex=false;
 */
   // }
   // key(key9;"Document Type","Shipment No.","Shipment Line No.")
  //  {
       /* ;
 */
   // }
   // key(key10;"Type","No.","Variant Code","Drop Shipment","Location Code","Document Type","Shipment Date")
  //  {
       /* MaintainSQLIndex=false;
 */
   // }
   // key(key11;"Document Type","Sell-to Customer No.","Shipment No.","Document No.")
  //  {
       /* SumIndexFields="Outstanding Amount (LCY)";
 */
   // }
   // key(key12;"Job Contract Entry No.")
  //  {
       /* ;
 */
   // }
   // key(No13;"Document Type","Document No.","Qty. Shipped Not Invoiced")
   // {
       /* ;
 */
   // }
   // key(No14;"Document Type","Document No.","Type","No.")
   // {
       /* ;
 */
   // }
   // key(key15;"Recalculate Invoice Disc.")
  //  {
       /* ;
 */
   // }
   // key(key16;"Qty. Shipped Not Invoiced")
  //  {
       /* ;
 */
   // }
   // key(key17;"Qty. Shipped (Base)")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(Brick;"No.","Description","Line Amount","Quantity","Unit of Measure Code","Price description")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='You cannot delete the order line because it is associated with purchase order %1 line %2.',ESP='No se puede eliminar la l¡nea del pedido porque est  asociada a la l¡nea %2 del pedido de compra %1.';
//       Text001@1001 :
      Text001: TextConst ENU='You cannot rename a %1.',ESP='No se puede cambiar el nombre a %1.';
//       Text002@1002 :
      Text002: TextConst ENU='You cannot change %1 because the order line is associated with purchase order %2 line %3.',ESP='No se puede cambiar %1 porque la l¡nea de pedido est  asociada a la l¡nea %3 del pedido de compra %2.';
//       Text003@1003 :
      Text003: TextConst ENU='must not be less than %1',ESP='No puede ser inferior a %1.';
//       Text005@1004 :
      Text005: TextConst ENU='You cannot invoice more than %1 units.',ESP='No se pueden facturar m s de %1 unidades.';
//       Text006@1005 :
      Text006: TextConst ENU='You cannot invoice more than %1 base units.',ESP='No se pueden facturar m s de %1 unidades base.';
//       Text007@1006 :
      Text007: TextConst ENU='You cannot ship more than %1 units.',ESP='No se pueden enviar m s de %1 unidades.';
//       Text008@1007 :
      Text008: TextConst ENU='You cannot ship more than %1 base units.',ESP='No se pueden enviar m s de %1 unidades base.';
//       Text009@1008 :
      Text009: TextConst ENU=' must be 0 when %1 is %2',ESP=' debe ser 0 cuando %1 es %2';
//       ManualReserveQst@1010 :
      ManualReserveQst: TextConst ENU='Automatic reservation is not possible.\Do you want to reserve items manually?',ESP='No se puede reservar autom ticamente.\¨Desea reservar los productos manualmente?';
//       Text014@1013 :
      Text014: TextConst ENU='%1 %2 is before work date %3',ESP='%1 %2 es antes de la fecha trab. %3';
//       Text016@1040 :
      Text016: TextConst ENU='%1 is required for %2 = %3.',ESP='Se requiere %1 para %2 = %3.';
//       WhseRequirementMsg@1044 :
      WhseRequirementMsg: 
// "%1=Document"
TextConst ENU='%1 is required for this line. The entered information may be disregarded by warehouse activities.',ESP='%1 se requiere para esta l¡nea. La informaci¢n introducida puede ser ignorada por las actividades de almac‚n.';
//       Text020@1019 :
      Text020: TextConst ENU='You cannot return more than %1 units.',ESP='No puede devolver m s de %1 unidades.';
//       Text021@1020 :
      Text021: TextConst ENU='You cannot return more than %1 base units.',ESP='No puede dev. m s del %1 unidades base.';
//       Text026@1025 :
      Text026: TextConst ENU='You cannot change %1 if the item charge has already been posted.',ESP='No puede cambiar %1 si el cargo prod. ya ha sido registrado.';
//       CurrExchRate@1030 :
      CurrExchRate: Record 330;
//       SalesHeader@1031 :
      SalesHeader: Record 36;
//       SalesLine2@1032 :
      SalesLine2: Record 37;
//       GLAcc@1035 :
      GLAcc: Record 15;
//       Resource@1400 :
      Resource: Record 156;
//       Currency@1037 :
      Currency: Record 4;
//       Res@1043 :
      Res: Record 156;
//       ResCost@1045 :
      ResCost: Record 202;
//       VATPostingSetup@1048 :
      VATPostingSetup: Record 325;
//       GenBusPostingGrp@1050 :
      GenBusPostingGrp: Record 250;
//       GenProdPostingGrp@1051 :
      GenProdPostingGrp: Record 251;
//       UnitOfMeasure@1054 :
      UnitOfMeasure: Record 204;
//       NonstockItem@1058 :
      NonstockItem: Record 5718;
//       SKU@1060 :
      SKU: Record 5700;
//       ItemCharge@1061 :
      ItemCharge: Record 5800;
//       InvtSetup@1063 :
      InvtSetup: Record 313;
//       Location@1064 :
      Location: Record 14;
//       ATOLink@1016 :
      ATOLink: Record 904;
//       SalesSetup@1065 :
      SalesSetup: Record 311;
//       TempItemTemplate@1099 :
//      TempItemTemplate: Record 1301 TEMPORARY;
//       CalChange@1052 :
      CalChange: Record 7602;
//       ConfigTemplateHeader@1057 :
      ConfigTemplateHeader: Record 8618;
//       TempErrorMessage@1069 :
      TempErrorMessage: Record 700 TEMPORARY;
//       PriceCalcMgt@1071 :
      PriceCalcMgt: Codeunit 7000;
//       CustCheckCreditLimit@1074 :
      CustCheckCreditLimit: Codeunit 312;
//       ItemCheckAvail@1075 :
      ItemCheckAvail: Codeunit 311;
//       SalesTaxCalculate@1076 :
      SalesTaxCalculate: Codeunit 398;
//       ReserveSalesLine@1079 :
      ReserveSalesLine: Codeunit 99000832;
//       UOMMgt@1080 :
      UOMMgt: Codeunit 5402;
//       AddOnIntegrMgt@1081 :
      AddOnIntegrMgt: Codeunit 5403;
//       DimMgt@1082 :
      DimMgt: Codeunit 408;
//       ItemSubstitutionMgt@1085 :
      ItemSubstitutionMgt: Codeunit 5701;
//       DistIntegration@1086 :
      DistIntegration: Codeunit 5702;
//       CatalogItemMgt@1087 :
      CatalogItemMgt: Codeunit 5703;
//       WhseValidateSourceLine@1088 :
      WhseValidateSourceLine: Codeunit 5777;
//       TransferExtendedText@1100 :
      TransferExtendedText: Codeunit 378;
//       DeferralUtilities@1026 :
      DeferralUtilities: Codeunit 1720;
//       CalendarMgmt@1056 :
      CalendarMgmt: Codeunit 7600;
//       PostingSetupMgt@1068 :
      PostingSetupMgt: Codeunit 48;
//       FullAutoReservation@1092 :
      FullAutoReservation: Boolean;
//       StatusCheckSuspended@1094 :
      StatusCheckSuspended: Boolean;
//       HasBeenShown@1018 :
      HasBeenShown: Boolean;
//       PlannedShipmentDateCalculated@1012 :
      PlannedShipmentDateCalculated: Boolean;
//       PlannedDeliveryDateCalculated@1070 :
      PlannedDeliveryDateCalculated: Boolean;
//       Text028@1098 :
      Text028: TextConst ENU='You cannot change the %1 when the %2 has been filled in.',ESP='No puede cambiar %1 despu‚s de introducir datos en %2.';
//       Text029@1021 :
      Text029: TextConst ENU='must be positive',ESP='debe ser positivo';
//       Text030@1042 :
      Text030: TextConst ENU='must be negative',ESP='debe ser negativo';
//       Text031@1093 :
      Text031: TextConst ENU='You must either specify %1 or %2.',ESP='Debe especificar %1 o %2.';
//       Text034@1084 :
      Text034: TextConst ENU='The value of %1 field must be a whole number for the item included in the service item group if the %2 field in the Service Item Groups window contains a check mark.',ESP='El valor del campo %1 debe ser un n£mero entero correspondiente al producto incluido en el grupo de productos de servicio si est  activada la casilla de verificaci¢n del campo %2 en la ventana Grupos producto servicio.';
//       Text035@1083 :
      Text035: TextConst ENU='Warehouse ',ESP='Almac‚n ';
//       Text036@1090 :
      Text036: TextConst ENU='Inventory ',ESP='Inventario ';
//       HideValidationDialog@1109 :
      HideValidationDialog: Boolean;
//       Text037@1009 :
      Text037: TextConst ENU='You cannot change %1 when %2 is %3 and %4 is positive.',ESP='No puede cambiar el %1 cuando la %2 es %3 y la %4 es positiva.';
//       Text038@1014 :
      Text038: TextConst ENU='You cannot change %1 when %2 is %3 and %4 is negative.',ESP='No puede cambiar el %1 cuando la %2 es %3 y la %4 es negativa.';
//       Text039@1034 :
      Text039: TextConst ENU='%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.',ESP='%1 unidades para el %2 %3 ya se han devuelto. Por lo tanto, s¢lo se pueden devolver %4 unidades.';
//       Text040@1039 :
      Text040: TextConst ENU='You must use form %1 to enter %2, if item tracking is used.',ESP='Utilice el formulario %1 para insertar %2, si se utiliza el seguimiento de productos.';
//       Text042@1055 :
      Text042: TextConst ENU='When posting the Applied to Ledger Entry %1 will be opened first',ESP='Al registrar, se abrir  primero Liq. por mov. producto %1';
//       ShippingMoreUnitsThanReceivedErr@1047 :
      ShippingMoreUnitsThanReceivedErr: TextConst ENU='You cannot ship more than the %1 units that you have received for document no. %2.',ESP='No se puede enviar m s de %1 unidades que se hayan recibido para el documento n§ %2.';
//       Text044@1103 :
      Text044: TextConst ENU='cannot be less than %1',ESP='no puede ser inferior a %1';
//       Text045@1104 :
      Text045: TextConst ENU='cannot be more than %1',ESP='no puede ser superior a %1';
//       Text046@1105 :
      Text046: TextConst ENU='You cannot return more than the %1 units that you have shipped for %2 %3.',ESP='No puede devolver m s de las %1 unidades enviadas para el %2 %3.';
//       Text047@1106 :
      Text047: TextConst ENU='must be positive when %1 is not 0.',ESP='debe ser positivo cuando %1 no es 0.';
//       Text048@1108 :
      Text048: TextConst ENU='You cannot use item tracking on a %1 created from a %2.',ESP='No puede utilizar el seguimiento de productos en una %1 creada desde un %2.';
//       Text049@1139 :
      Text049: TextConst ENU='cannot be %1.',ESP='no puede ser %1.';
//       Text051@1141 :
      Text051: TextConst ENU='You cannot use %1 in a %2.',ESP='No puede usar %1 en un %2.';
//       PrePaymentLineAmountEntered@1015 :
      PrePaymentLineAmountEntered: Boolean;
//       Text052@1022 :
      Text052: TextConst ENU='You cannot add an item line because an open warehouse shipment exists for the sales header and Shipping Advice is %1.\\You must add items as new lines to the existing warehouse shipment or change Shipping Advice to Partial.',ESP='No puede agregar una l¡nea de producto porque existe un env¡o de almac‚n abierto para la Cabecera venta y el Aviso env¡o es %1.\\Debe agregar productos como l¡neas nuevas en el env¡o de almac‚n existente o cambiar el Aviso env¡o a Parcial.';
//       Text053@1017 :
      Text053: TextConst ENU='You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?',ESP='Ha modificado una o varias dimensiones de %1, que ya se ha enviado. Al registrar la l¡nea con la dimensi¢n modificada en la contabilidad, los importes de la cuenta provisional de inventario no cuadrar n cuando se notifiquen por dimensi¢n.\\¨Desea conservar la dimensi¢n modificada?';
//       Text054@1023 :
      Text054: TextConst ENU='Cancelled.',ESP='Cancelado.';
//       Text055@1024 :
      Text055: 
// Quantity Invoiced must not be greater than the sum of Qty. Assigned and Qty. to Assign.
TextConst ENU='%1 must not be greater than the sum of %2 and %3.',ESP='%1 no debe ser superior a la suma de %2 y %3.';
//       Text056@1011 :
      Text056: TextConst ENU='You cannot add an item line because an open inventory pick exists for the Sales Header and because Shipping Advice is %1.\\You must first post or delete the inventory pick or change Shipping Advice to Partial.',ESP='No puede agregar una l¡nea de producto porque existe un picking inventario para la Cabecera venta y porque el Aviso env¡o es %1.\\Primero debe registrar o eliminar el picking inventario o cambiar el Aviso env¡o a Parcial.';
//       Text057@1027 :
      Text057: TextConst ENU='must have the same sign as the shipment',ESP='debe tener el mismo signo que el env¡o.';
//       Text058@1028 :
      Text058: TextConst ENU='The quantity that you are trying to invoice is greater than the quantity in shipment %1.',ESP='La cantidad que est  intentando facturar es mayor que la cantidad en el env¡o %1.';
//       Text059@1029 :
      Text059: TextConst ENU='must have the same sign as the return receipt',ESP='debe tener el mismo nombre que la recep. dev.';
//       Text060@1041 :
      Text060: TextConst ENU='The quantity that you are trying to invoice is greater than the quantity in return receipt %1.',ESP='La cantidad que est  intentando facturar es mayor que la cantidad en la recepci¢n de devoluci¢n %1.';
//       ItemChargeAssignmentErr@1097 :
      ItemChargeAssignmentErr: TextConst ENU='You can only assign Item Charges for Line Types of Charge (Item).',ESP='Solo puede asignar cargos de producto a los tipos de cargo de l¡nea (producto).';
//       SalesLineCompletelyShippedErr@1053 :
      SalesLineCompletelyShippedErr: TextConst ENU='You cannot change the purchasing code for a sales line that has been completely shipped.',ESP='No es posible modificar el c¢digo de compra para una l¡nea de venta que se ha enviado por completo.';
//       SalesSetupRead@1067 :
      SalesSetupRead: Boolean;
//       LookupRequested@1059 :
      LookupRequested: Boolean;
//       FreightLineDescriptionTxt@1033 :
      FreightLineDescriptionTxt: TextConst ENU='Freight Amount',ESP='Importe de flete';
//       CannotFindDescErr@1200 :
      CannotFindDescErr: 
// "%1 = Type caption %2 = Description"
TextConst ENU='Cannot find %1 with Description %2.\\Make sure to use the correct type.',ESP='No se encuentra %1 con la descripci¢n %2.\\Aseg£rese de usar el tipo correcto.';
//       PriceDescriptionTxt@1038 :
      PriceDescriptionTxt: 
// {Locked}
TextConst ENU='x%1 (%2%3/%4)',ESP='x%1 (%2%3/%4)';
//       PriceDescriptionWithLineDiscountTxt@1066 :
      PriceDescriptionWithLineDiscountTxt: 
// {Locked}
TextConst ENU='x%1 (%2%3/%4) - %5%',ESP='x%1 (%2%3/%4) - %5%';
//       SelectNonstockItemErr@1062 :
      SelectNonstockItemErr: TextConst ENU='You can only select a catalog item for an empty line.',ESP='Solo puede seleccionar un producto del cat logo para una l¡nea vac¡a.';
//       EstimateLbl@1072 :
      EstimateLbl: TextConst ENU='Estimate',ESP='Estimar';
//       CommentLbl@1046 :
      CommentLbl: TextConst ENU='Comment',ESP='Comentario';
//       LineDiscountPctErr@1073 :
      LineDiscountPctErr: TextConst ENU='The value in the Line Discount % field must be between 0 and 100.',ESP='El valor en el campo % Descuento l¡nea debe ser entre 0 y 100.';
//       SalesBlockedErr@1077 :
      SalesBlockedErr: TextConst ENU='You cannot sell this item because the Sales Blocked check box is selected on the item card.',ESP='No puede vender este producto porque la casilla Ventas bloqueadas est  seleccionada en la ficha de producto.';
//       CannotChangePrepaidServiceChargeErr@1078 :
      CannotChangePrepaidServiceChargeErr: TextConst ENU='You cannot change the line because it will affect service charges that are already invoiced as part of a prepayment.',ESP='No puede cambiar la l¡nea porque afectar  a los cargos por servicios que ya se han facturado como parte de un prepago.';
//       LineAmountInvalidErr@1089 :
      LineAmountInvalidErr: TextConst ENU='You have set the line amount to a value that results in a discount that is not valid. Consider increasing the unit price instead.',ESP='Ha establecido la cantidad de l¡neas para un valor que da como resultado un descuento que no es v lido. En su lugar, considere un aumento del precio unitario.';
//       UnitPriceChangedMsg@1091 :
      UnitPriceChangedMsg: 
// "%1 = Type caption %2 = No."
TextConst ENU='The unit price for %1 %2 that was copied from the posted document has been changed.',ESP='Se ha modificado el precio unitario de %1 %2 que se copi¢ del documento registrado.';
//       LineInvoiceDiscountAmountResetTok@1036 :
      LineInvoiceDiscountAmountResetTok: 
// %1 - Record ID
TextConst ENU='The value in the Inv. Discount Amount field in %1 has been cleared.',ESP='Se ha borrado el valor del campo Importe dto. factura de %1.';

    
    


/*
trigger OnInsert();    begin
               TestStatusOpen;
               if Quantity <> 0 then begin
                 OnBeforeVerifyReservedQty(Rec,xRec,0);
                 ReserveSalesLine.VerifyQuantity(Rec,xRec);
               end;
               LOCKTABLE;
               SalesHeader."No." := '';
               if Type = Type::Item then
                 if SalesHeader.InventoryPickConflict("Document Type","Document No.",SalesHeader."Shipping Advice") then
                   ERROR(Text056,SalesHeader."Shipping Advice");
               if ("Deferral Code" <> '') and (GetDeferralAmount <> 0) then
                 UpdateDeferralAmounts;
             end;


*/

/*
trigger OnModify();    begin
               if ("Document Type" = "Document Type"::"Blanket Order") and
                  ((Type <> xRec.Type) or ("No." <> xRec."No."))
               then begin
                 SalesLine2.RESET;
                 SalesLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
                 SalesLine2.SETRANGE("Blanket Order No.","Document No.");
                 SalesLine2.SETRANGE("Blanket Order Line No.","Line No.");
                 if SalesLine2.FINDSET then
                   repeat
                     SalesLine2.TESTFIELD(Type,Type);
                     SalesLine2.TESTFIELD("No.","No.");
                   until SalesLine2.NEXT = 0;
               end;

               if ((Quantity <> 0) or (xRec.Quantity <> 0)) and ItemExists(xRec."No.") and not FullReservedQtyIsForAsmToOrder then
                 ReserveSalesLine.VerifyChange(Rec,xRec);
             end;


*/

/*
trigger OnDelete();    var
//                SalesCommentLine@1001 :
               SalesCommentLine: Record 44;
//                CapableToPromise@1000 :
               CapableToPromise: Codeunit 99000886;
//                JobCreateInvoice@1002 :
               JobCreateInvoice: Codeunit 1002;
             begin
               TestStatusOpen;

               if (Quantity <> 0) and ItemExists("No.") then begin
                 ReserveSalesLine.DeleteLine(Rec);
                 CALCFIELDS("Reserved Qty. (Base)");
                 TESTFIELD("Reserved Qty. (Base)",0);
                 if "Shipment No." = '' then
                   TESTFIELD("Qty. Shipped not Invoiced",0);
                 if "Return Receipt No." = '' then
                   TESTFIELD("Return Qty. Rcd. not Invd.",0);
                 WhseValidateSourceLine.SalesLineDelete(Rec);
               end;

               if ("Document Type" = "Document Type"::Order) and (Quantity <> "Quantity Invoiced") then
                 TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

               CleanDropShipmentFields;
               CleanSpecialOrderFieldsAndCheckAssocPurchOrder;
               CatalogItemMgt.DelNonStockSales(Rec);

               if "Document Type" = "Document Type"::"Blanket Order" then begin
                 SalesLine2.RESET;
                 SalesLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
                 SalesLine2.SETRANGE("Blanket Order No.","Document No.");
                 SalesLine2.SETRANGE("Blanket Order Line No.","Line No.");
                 if SalesLine2.FINDFIRST then
                   SalesLine2.TESTFIELD("Blanket Order Line No.",0);
               end;

               if Type = Type::Item then begin
                 ATOLink.DeleteAsmFromSalesLine(Rec);
                 DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
               end;

               if Type = Type::"Charge (Item)" then
                 DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");

               CapableToPromise.RemoveReqLines("Document No.","Line No.",0,FALSE);

               if "Line No." <> 0 then begin
                 SalesLine2.RESET;
                 SalesLine2.SETRANGE("Document Type","Document Type");
                 SalesLine2.SETRANGE("Document No.","Document No.");
                 SalesLine2.SETRANGE("Attached to Line No.","Line No.");
                 SalesLine2.SETFILTER("Line No.",'<>%1',"Line No.");
                 SalesLine2.DELETEALL(TRUE);
               end;

               if "Job Contract Entry No." <> 0 then
                 JobCreateInvoice.DeleteSalesLine(Rec);

               SalesCommentLine.SETRANGE("Document Type","Document Type");
               SalesCommentLine.SETRANGE("No.","Document No.");
               SalesCommentLine.SETRANGE("Document Line No.","Line No.");
               if not SalesCommentLine.ISEMPTY then
                 SalesCommentLine.DELETEALL;

               // In case we have roundings on VAT or Sales Tax, we should update some other line
               if (Type <> Type::" ") and ("Line No." <> 0) and ("Attached to Line No." = 0) and ("Job Contract Entry No." = 0 ) and
                  (Quantity <> 0) and (Amount <> 0) and (Amount <> "Amount Including VAT") and not StatusCheckSuspended
               then begin
                 Quantity := 0;
                 "Quantity (Base)" := 0;
                 "Line Discount Amount" := 0;
                 "Inv. Discount Amount" := 0;
                 "Inv. Disc. Amount to Invoice" := 0;
                 UpdateAmounts;
               end;

               if "Deferral Code" <> '' then
                 DeferralUtilities.DeferralCodeOnDelete(
                   DeferralUtilities.GetSalesDeferralDocType,'','',
                   "Document Type","Document No.","Line No.");
             end;


*/

/*
trigger OnRename();    begin
               ERROR(Text001,TABLECAPTION);
             end;

*/




/*
procedure InitOutstanding ()
    begin
      if IsCreditDocType then begin
        "Outstanding Quantity" := Quantity - "Return Qty. Received";
        "Outstanding Qty. (Base)" := "Quantity (Base)" - "Return Qty. Received (Base)";
        "Return Qty. Rcd. not Invd." := "Return Qty. Received" - "Quantity Invoiced";
        "Ret. Qty. Rcd. not Invd.(Base)" := "Return Qty. Received (Base)" - "Qty. Invoiced (Base)";
      end else begin
        "Outstanding Quantity" := Quantity - "Quantity Shipped";
        "Outstanding Qty. (Base)" := "Quantity (Base)" - "Qty. Shipped (Base)";
        "Qty. Shipped not Invoiced" := "Quantity Shipped" - "Quantity Invoiced";
        "Qty. Shipped not Invd. (Base)" := "Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
      end;
      OnAfterInitOutstandingQty(Rec);
      UpdatePlanned;
      "Completely Shipped" := (Quantity <> 0) and ("Outstanding Quantity" = 0);
      InitOutstandingAmount;

      OnAfterInitOutstanding(Rec);
    end;
*/


    
    
/*
procedure InitOutstandingAmount ()
    var
//       AmountInclVAT@1000 :
      AmountInclVAT: Decimal;
    begin
      if Quantity = 0 then begin
        "Outstanding Amount" := 0;
        "Outstanding Amount (LCY)" := 0;
        "Shipped not Invoiced" := 0;
        "Shipped not Invoiced (LCY)" := 0;
        "Return Rcd. not Invd." := 0;
        "Return Rcd. not Invd. (LCY)" := 0;
      end else begin
        GetSalesHeader;
        AmountInclVAT := "Amount Including VAT";
        VALIDATE(
          "Outstanding Amount",
          ROUND(
            AmountInclVAT * "Outstanding Quantity" / Quantity,
            Currency."Amount Rounding Precision"));
        if IsCreditDocType then
          VALIDATE(
            "Return Rcd. not Invd.",
            ROUND(
              AmountInclVAT * "Return Qty. Rcd. not Invd." / Quantity,
              Currency."Amount Rounding Precision"))
        else
          VALIDATE(
            "Shipped not Invoiced",
            ROUND(
              AmountInclVAT * "Qty. Shipped not Invoiced" / Quantity,
              Currency."Amount Rounding Precision"));
      end;

      OnAfterInitOutstandingAmount(Rec,SalesHeader,Currency);
    end;
*/


    
    
/*
procedure InitQtyToShip ()
    begin
      GetSalesSetup;
      if (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Remainder) or
         ("Document Type" = "Document Type"::Invoice)
      then begin
        "Qty. to Ship" := "Outstanding Quantity";
        "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";
      end else
        if "Qty. to Ship" <> 0 then
          "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");

      CheckServItemCreation;

      OnAfterInitQtyToShip(Rec,CurrFieldNo);

      InitQtyToInvoice;
    end;
*/


    
    
/*
procedure InitQtyToReceive ()
    begin
      GetSalesSetup;
      if (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Remainder) or
         ("Document Type" = "Document Type"::"Credit Memo")
      then begin
        "Return Qty. to Receive" := "Outstanding Quantity";
        "Return Qty. to Receive (Base)" := "Outstanding Qty. (Base)";
      end else
        if "Return Qty. to Receive" <> 0 then
          "Return Qty. to Receive (Base)" := CalcBaseQty("Return Qty. to Receive");

      OnAfterInitQtyToReceive(Rec,CurrFieldNo);

      InitQtyToInvoice;
    end;
*/


    
    
/*
procedure InitQtyToInvoice ()
    begin
      "Qty. to Invoice" := MaxQtyToInvoice;
      "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
      "VAT Difference" := 0;
      "EC Difference" := 0;

      OnBeforeCalcInvDiscToInvoice(Rec);
      CalcInvDiscToInvoice;
      if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then
        CalcPrepaymentToDeduct;

      OnAfterInitQtyToInvoice(Rec,CurrFieldNo);
    end;
*/


//     LOCAL procedure InitItemAppl (OnlyApplTo@1000 :
    
/*
LOCAL procedure InitItemAppl (OnlyApplTo: Boolean)
    begin
      "Appl.-to Item Entry" := 0;
      if not OnlyApplTo then
        "Appl.-from Item Entry" := 0;
    end;
*/


    
    
/*
procedure MaxQtyToInvoice () : Decimal;
    begin
      if "Prepayment Line" then
        exit(1);
      if IsCreditDocType then
        exit("Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced");

      exit("Quantity Shipped" + "Qty. to Ship" - "Quantity Invoiced");
    end;
*/


    
    
/*
procedure MaxQtyToInvoiceBase () : Decimal;
    begin
      if IsCreditDocType then
        exit("Return Qty. Received (Base)" + "Return Qty. to Receive (Base)" - "Qty. Invoiced (Base)");

      exit("Qty. Shipped (Base)" + "Qty. to Ship (Base)" - "Qty. Invoiced (Base)");
    end;
*/


//     LOCAL procedure CalcBaseQty (Qty@1000 :
    
/*
LOCAL procedure CalcBaseQty (Qty: Decimal) : Decimal;
    begin
      TESTFIELD("Qty. per Unit of Measure");
      exit(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    end;
*/


    
    
/*
procedure CalcLineAmount () : Decimal;
    begin
      exit("Line Amount" - "Inv. Discount Amount");
    end;
*/


    
/*
LOCAL procedure CopyFromStandardText ()
    var
//       StandardText@1000 :
      StandardText: Record 7;
    begin
      StandardText.GET("No.");
      Description := StandardText.Description;
      "Allow Item Charge Assignment" := FALSE;
      OnAfterAssignStdTxtValues(Rec,StandardText);
    end;
*/


    
/*
LOCAL procedure CopyFromGLAccount ()
    begin
      GLAcc.GET("No.");
      GLAcc.CheckGLAcc;
      if not "System-Created Entry" then
        GLAcc.TESTFIELD("Direct Posting",TRUE);
      Description := GLAcc.Name;
      "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
      "Tax Group Code" := GLAcc."Tax Group Code";
      "Allow Invoice Disc." := not GLAcc.InvoiceDiscountAllowed("No.");
      "Allow Item Charge Assignment" := FALSE;
      InitDeferralCode;
      OnAfterAssignGLAccountValues(Rec,GLAcc);
    end;
*/


    
/*
LOCAL procedure CopyFromItem ()
    var
//       Item@1001 :
      Item: Record 27;
//       PrepaymentMgt@1000 :
      PrepaymentMgt: Codeunit 441;
    begin
      GetItem(Item);
      OnBeforeCopyFromItem(Rec,Item);
      Item.TESTFIELD(Blocked,FALSE);
      Item.TESTFIELD("Gen. Prod. Posting Group");
      if Item."Sales Blocked" and not IsCreditDocType then
        ERROR(SalesBlockedErr);
      if Item.Type = Item.Type::Inventory then begin
        Item.TESTFIELD("Inventory Posting Group");
        "Posting Group" := Item."Inventory Posting Group";
      end;
      Description := Item.Description;
      "Description 2" := Item."Description 2";
      GetUnitCost;
      "Allow Invoice Disc." := Item."Allow Invoice Disc.";
      "Units per Parcel" := Item."Units per Parcel";
      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
      "Tax Group Code" := Item."Tax Group Code";
      "Item Category Code" := Item."Item Category Code";
      Nonstock := Item."Created From Nonstock Item";
      "Profit %" := Item."Profit %";
      "Allow Item Charge Assignment" := TRUE;
      PrepaymentMgt.SetSalesPrepaymentPct(Rec,SalesHeader."Posting Date");
      if Item.Type = Item.Type::Inventory then
        PostingSetupMgt.CheckInvtPostingSetupInventoryAccount("Location Code","Posting Group");

      if SalesHeader."Language Code" <> '' then
        GetItemTranslation;

      if Item.Reserve = Item.Reserve::Optional then
        Reserve := SalesHeader.Reserve
      else
        Reserve := Item.Reserve;

      "Unit of Measure Code" := Item."Sales Unit of Measure";
      OnAfterCopyFromItem(Rec,Item);

      InitDeferralCode;
      SetDefaultItemQuantity;
      OnAfterAssignItemValues(Rec,Item);
    end;
*/


    
/*
LOCAL procedure CopyFromResource ()
    begin
      Res.GET("No.");
      Res.CheckResourcePrivacyBlocked(FALSE);
      Res.TESTFIELD(Blocked,FALSE);
      Res.TESTFIELD("Gen. Prod. Posting Group");
      Description := Res.Name;
      "Description 2" := Res."Name 2";
      "Unit of Measure Code" := Res."Base Unit of Measure";
      "Unit Cost (LCY)" := Res."Unit Cost";
      "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
      "Tax Group Code" := Res."Tax Group Code";
      "Allow Item Charge Assignment" := FALSE;
      FindResUnitCost;
      InitDeferralCode;
      OnAfterAssignResourceValues(Rec,Res);
    end;
*/


    
/*
LOCAL procedure CopyFromFixedAsset ()
    var
//       FixedAsset@1000 :
      FixedAsset: Record 5600;
    begin
      FixedAsset.GET("No.");
      FixedAsset.TESTFIELD(Inactive,FALSE);
      FixedAsset.TESTFIELD(Blocked,FALSE);
      GetFAPostingGroup;
      Description := FixedAsset.Description;
      "Description 2" := FixedAsset."Description 2";
      "Allow Invoice Disc." := FALSE;
      "Allow Item Charge Assignment" := FALSE;
      OnAfterAssignFixedAssetValues(Rec,FixedAsset);
    end;
*/


    
/*
LOCAL procedure CopyFromItemCharge ()
    begin
      ItemCharge.GET("No.");
      Description := ItemCharge.Description;
      "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
      "Tax Group Code" := ItemCharge."Tax Group Code";
      "Allow Invoice Disc." := FALSE;
      "Allow Item Charge Assignment" := FALSE;
      OnAfterAssignItemChargeValues(Rec,ItemCharge);
    end;
*/


//     procedure CopyFromSalesLine (FromSalesLine@1001 :
    
/*
procedure CopyFromSalesLine (FromSalesLine: Record 37)
    begin
      "No." := FromSalesLine."No.";
      "Variant Code" := FromSalesLine."Variant Code";
      "Location Code" := FromSalesLine."Location Code";
      "Bin Code" := FromSalesLine."Bin Code";
      "Unit of Measure Code" := FromSalesLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := FromSalesLine."Qty. per Unit of Measure";
      "Outstanding Quantity" := FromSalesLine.Quantity;
      "Qty. to Assemble to Order" := 0;
      "Drop Shipment" := FromSalesLine."Drop Shipment";
    end;
*/


//     procedure CopyFromSalesShptLine (FromSalesShptLine@1001 :
    
/*
procedure CopyFromSalesShptLine (FromSalesShptLine: Record 111)
    begin
      "No." := FromSalesShptLine."No.";
      "Variant Code" := FromSalesShptLine."Variant Code";
      "Location Code" := FromSalesShptLine."Location Code";
      "Bin Code" := FromSalesShptLine."Bin Code";
      "Unit of Measure Code" := FromSalesShptLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := FromSalesShptLine."Qty. per Unit of Measure";
      "Outstanding Quantity" := FromSalesShptLine.Quantity;
      "Qty. to Assemble to Order" := 0;
      "Drop Shipment" := FromSalesShptLine."Drop Shipment";
    end;
*/


//     procedure CopyFromSalesInvLine (FromSalesInvLine@1000 :
    
/*
procedure CopyFromSalesInvLine (FromSalesInvLine: Record 113)
    begin
      "No." := FromSalesInvLine."No.";
      "Variant Code" := FromSalesInvLine."Variant Code";
      "Location Code" := FromSalesInvLine."Location Code";
      "Bin Code" := FromSalesInvLine."Bin Code";
      "Unit of Measure Code" := FromSalesInvLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := FromSalesInvLine."Qty. per Unit of Measure";
      "Outstanding Quantity" := FromSalesInvLine.Quantity;
      "Drop Shipment" := FromSalesInvLine."Drop Shipment";
    end;
*/


//     procedure CopyFromReturnRcptLine (FromReturnRcptLine@1000 :
    
/*
procedure CopyFromReturnRcptLine (FromReturnRcptLine: Record 6661)
    begin
      "No." := FromReturnRcptLine."No.";
      "Variant Code" := FromReturnRcptLine."Variant Code";
      "Location Code" := FromReturnRcptLine."Location Code";
      "Bin Code" := FromReturnRcptLine."Bin Code";
      "Unit of Measure Code" := FromReturnRcptLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := FromReturnRcptLine."Qty. per Unit of Measure";
      "Outstanding Quantity" := FromReturnRcptLine.Quantity;
      "Drop Shipment" := FALSE;
    end;
*/


//     procedure CopyFromSalesCrMemoLine (FromSalesCrMemoLine@1000 :
    
/*
procedure CopyFromSalesCrMemoLine (FromSalesCrMemoLine: Record 115)
    begin
      "No." := FromSalesCrMemoLine."No.";
      "Variant Code" := FromSalesCrMemoLine."Variant Code";
      "Location Code" := FromSalesCrMemoLine."Location Code";
      "Bin Code" := FromSalesCrMemoLine."Bin Code";
      "Unit of Measure Code" := FromSalesCrMemoLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := FromSalesCrMemoLine."Qty. per Unit of Measure";
      "Outstanding Quantity" := FromSalesCrMemoLine.Quantity;
      "Drop Shipment" := FALSE;
    end;
*/


//     LOCAL procedure SelectItemEntry (CurrentFieldNo@1000 :
    
/*
LOCAL procedure SelectItemEntry (CurrentFieldNo: Integer)
    var
//       ItemLedgEntry@1001 :
      ItemLedgEntry: Record 32;
//       SalesLine3@1002 :
      SalesLine3: Record 37;
    begin
      ItemLedgEntry.SETRANGE("Item No.","No.");
      if "Location Code" <> '' then
        ItemLedgEntry.SETRANGE("Location Code","Location Code");
      ItemLedgEntry.SETRANGE("Variant Code","Variant Code");

      if CurrentFieldNo = FIELDNO("Appl.-to Item Entry") then begin
        ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
        ItemLedgEntry.SETRANGE(Positive,TRUE);
        ItemLedgEntry.SETRANGE(Open,TRUE);
      end else begin
        ItemLedgEntry.SETCURRENTKEY("Item No.",Positive);
        ItemLedgEntry.SETRANGE(Positive,FALSE);
        ItemLedgEntry.SETFILTER("Shipped Qty. not Returned",'<0');
      end;
      if PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK then begin
        SalesLine3 := Rec;
        if CurrentFieldNo = FIELDNO("Appl.-to Item Entry") then
          SalesLine3.VALIDATE("Appl.-to Item Entry",ItemLedgEntry."Entry No.")
        else
          SalesLine3.VALIDATE("Appl.-from Item Entry",ItemLedgEntry."Entry No.");
        CheckItemAvailable(CurrentFieldNo);
        Rec := SalesLine3;
      end;
    end;
*/


    
//     procedure SetSalesHeader (NewSalesHeader@1000 :
    
/*
procedure SetSalesHeader (NewSalesHeader: Record 36)
    begin
      SalesHeader := NewSalesHeader;

      if SalesHeader."Currency Code" = '' then
        Currency.InitRoundingPrecision
      else begin
        SalesHeader.TESTFIELD("Currency Factor");
        Currency.GET(SalesHeader."Currency Code");
        Currency.TESTFIELD("Amount Rounding Precision");
      end;
    end;
*/


    
    
/*
procedure GetSalesHeader ()
    begin
      TESTFIELD("Document No.");
      if ("Document Type" <> SalesHeader."Document Type") or ("Document No." <> SalesHeader."No.") then begin
        SalesHeader.GET("Document Type","Document No.");
        if SalesHeader."Currency Code" = '' then
          Currency.InitRoundingPrecision
        else begin
          SalesHeader.TESTFIELD("Currency Factor");
          Currency.GET(SalesHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        end;
      end;
    end;
*/


//     LOCAL procedure GetItem (var Item@1000 :
    
/*
LOCAL procedure GetItem (var Item: Record 27)
    begin
      TESTFIELD("No.");
      Item.GET("No.");
    end;
*/


    
/*
LOCAL procedure GetResource ()
    begin
      TESTFIELD("No.");
      if "No." <> Resource."No." then
        Resource.GET("No.");
    end;
*/


    
//     procedure UpdateUnitPrice (CalledByFieldNo@1000 :
    
/*
procedure UpdateUnitPrice (CalledByFieldNo: Integer)
    var
//       IsHandled@1001 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeUpdateUnitPrice(Rec,xRec,CalledByFieldNo,CurrFieldNo,IsHandled);
      if IsHandled then
        exit;

      GetSalesHeader;
      TESTFIELD("Qty. per Unit of Measure");

      CASE Type OF
        Type::Item,
        Type::Resource:
          begin
            IsHandled := FALSE;
            OnUpdateUnitPriceOnBeforeFindPrice(SalesHeader,Rec,CalledByFieldNo,CurrFieldNo,IsHandled);
            if not IsHandled then begin
              if not ("Copied From Posted Doc." and IsCreditDocType) then
                PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,Rec);
              PriceCalcMgt.FindSalesLinePrice(SalesHeader,Rec,CalledByFieldNo);
            end;
          end;
      end;

      if "Copied From Posted Doc." and IsCreditDocType and ("Appl.-from Item Entry" <> 0) then
        if xRec."Unit Price" <> "Unit Price" then
          if GUIALLOWED then
            ShowMessageOnce(STRSUBSTNO(UnitPriceChangedMsg,Type,"No."));

      VALIDATE("Unit Price");

      OnAfterUpdateUnitPrice(Rec,xRec,CalledByFieldNo,CurrFieldNo);
    end;
*/


//     LOCAL procedure ShowMessageOnce (MessageText@1000 :
    
/*
LOCAL procedure ShowMessageOnce (MessageText: Text)
    begin
      TempErrorMessage.SetContext(Rec);
      if TempErrorMessage.FindRecord(RECORDID,0,TempErrorMessage."Message Type"::Warning,MessageText) = 0 then begin
        TempErrorMessage.LogMessage(Rec,0,TempErrorMessage."Message Type"::Warning,MessageText);
        MESSAGE(MessageText);
      end;
    end;
*/


    
    
/*
procedure FindResUnitCost ()
    begin
      ResCost.INIT;
      ResCost.Code := "No.";
      ResCost."Work Type Code" := "Work Type Code";
      CODEUNIT.RUN(CODEUNIT::"Resource-Find Cost",ResCost);
      OnAfterFindResUnitCost(Rec,ResCost);
      VALIDATE("Unit Cost (LCY)",ResCost."Unit Cost" * "Qty. per Unit of Measure");
    end;
*/


    
    
/*
procedure UpdatePrepmtSetupFields ()
    var
//       GenPostingSetup@1001 :
      GenPostingSetup: Record 252;
//       GLAcc@1000 :
      GLAcc: Record 15;
    begin
      if ("Prepayment %" <> 0) and (Type <> Type::" ") then begin
        TESTFIELD("Document Type","Document Type"::Order);
        TESTFIELD("No.");
        if CurrFieldNo = FIELDNO("Prepayment %") then
          if "System-Created Entry" and not IsServiceCharge then
            FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,0));
        if "System-Created Entry" and not IsServiceCharge then
          "Prepayment %" := 0;
        GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
        if GenPostingSetup."Sales Prepayments Account" <> '' then begin
          GLAcc.GET(GenPostingSetup."Sales Prepayments Account");
          VATPostingSetup.GET("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
          VATPostingSetup.TESTFIELD("VAT Calculation Type","VAT Calculation Type");
        end else
          CLEAR(VATPostingSetup);
        "Prepayment VAT %" := VATPostingSetup."VAT %";
        "Prepayment EC %" := VATPostingSetup."EC %";
        "Prepmt. VAT Calc. Type" := VATPostingSetup."VAT Calculation Type";
        "Prepayment VAT Identifier" := VATPostingSetup."VAT Identifier";
        if "Prepmt. VAT Calc. Type" IN
           ["Prepmt. VAT Calc. Type"::"Reverse Charge VAT","Prepmt. VAT Calc. Type"::"Sales Tax"]
        then begin
          "Prepayment VAT %" := 0;
          "Prepayment EC %" := 0;
        end;
        "Prepayment Tax Group Code" := GLAcc."Tax Group Code";
      end;
    end;
*/


    
/*
LOCAL procedure UpdatePrepmtAmounts ()
    var
//       RemLineAmountToInvoice@1000 :
      RemLineAmountToInvoice: Decimal;
    begin
      if "Prepayment %" <> 0 then begin
        if Quantity < 0 then
          FIELDERROR(Quantity,STRSUBSTNO(Text047,FIELDCAPTION("Prepayment %")));
        if "Unit Price" < 0 then
          FIELDERROR("Unit Price",STRSUBSTNO(Text047,FIELDCAPTION("Prepayment %")));
      end;
      if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then begin
        "Prepayment VAT Difference" := 0;
        if not PrePaymentLineAmountEntered then
          "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
        if "Prepmt. Line Amount" < "Prepmt. Amt. Inv." then begin
          if IsServiceCharge then
            ERROR(CannotChangePrepaidServiceChargeErr);
          FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text049,"Prepmt. Amt. Inv."));
        end;
        PrePaymentLineAmountEntered := FALSE;
        if "Prepmt. Line Amount" <> 0 then begin
          RemLineAmountToInvoice :=
            ROUND("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity,Currency."Amount Rounding Precision");
          if RemLineAmountToInvoice < ("Prepmt. Line Amount" - "Prepmt Amt Deducted") then
            FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,RemLineAmountToInvoice + "Prepmt Amt Deducted"));
        end;
      end else
        if (CurrFieldNo <> 0) and ("Line Amount" <> xRec."Line Amount") and
           ("Prepmt. Amt. Inv." <> 0) and ("Prepayment %" = 100)
        then begin
          if "Line Amount" < xRec."Line Amount" then
            FIELDERROR("Line Amount",STRSUBSTNO(Text044,xRec."Line Amount"));
          FIELDERROR("Line Amount",STRSUBSTNO(Text045,xRec."Line Amount"));
        end;
    end;
*/


    
    
/*
procedure UpdateAmounts ()
    var
//       VATBaseAmount@1003 :
      VATBaseAmount: Decimal;
//       LineAmountChanged@1002 :
      LineAmountChanged: Boolean;
    begin
      if Type = Type::" " then
        exit;
      GetSalesHeader;
      VATBaseAmount := "VAT Base Amount";
      "Recalculate Invoice Disc." := TRUE;

      if "Line Amount" <> xRec."Line Amount" then begin
        "VAT Difference" := 0;
        LineAmountChanged := TRUE;
      end;
      if "Line Amount" <> ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Discount Amount" then begin
        "Line Amount" := ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Discount Amount";
        "VAT Difference" := 0;
        LineAmountChanged := TRUE;
        "EC Difference" := 0;
      end;

      if not "Prepayment Line" then
        UpdatePrepmtAmounts;

      OnAfterUpdateAmounts(Rec,xRec,CurrFieldNo);

      UpdateVATAmounts;
      InitOutstandingAmount;
      CheckCreditLimit;

      if Type = Type::"Charge (Item)" then
        UpdateItemChargeAssgnt;

      CalcPrepaymentToDeduct;
      if VATBaseAmount <> "VAT Base Amount" then
        LineAmountChanged := TRUE;

      if LineAmountChanged then begin
        UpdateDeferralAmounts;
        LineAmountChanged := FALSE;
      end;

      OnAfterUpdateAmountsDone(Rec,xRec,CurrFieldNo);
    end;
*/


    
    
/*
procedure UpdateVATAmounts ()
    var
//       SalesLine2@1000 :
      SalesLine2: Record 37;
//       TotalLineAmount@1005 :
      TotalLineAmount: Decimal;
//       TotalInvDiscAmount@1004 :
      TotalInvDiscAmount: Decimal;
//       TotalAmount@1001 :
      TotalAmount: Decimal;
//       TotalAmountInclVAT@1002 :
      TotalAmountInclVAT: Decimal;
//       TotalQuantityBase@1003 :
      TotalQuantityBase: Decimal;
    begin
      OnBeforeUpdateVATAmounts(Rec);

      GetSalesHeader;
      SalesLine2.SETRANGE("Document Type","Document Type");
      SalesLine2.SETRANGE("Document No.","Document No.");
      SalesLine2.SETFILTER("Line No.",'<>%1',"Line No.");
      SalesLine2.SETRANGE("VAT Identifier","VAT Identifier");
      SalesLine2.SETRANGE("Tax Group Code","Tax Group Code");

      if "Line Amount" = "Inv. Discount Amount" then begin
        Amount := 0;
        "VAT Base Amount" := 0;
        "Amount Including VAT" := 0;
        if (Quantity = 0) and (xRec.Quantity <> 0) and (xRec.Amount <> 0) then begin
          if "Line No." <> 0 then
            MODIFY;
          SalesLine2.SETFILTER(Amount,'<>0');
          if SalesLine2.FIND('<>') then begin
            SalesLine2.ValidateLineDiscountPercent(FALSE);
            SalesLine2.MODIFY;
          end;
        end;
      end else begin
        TotalLineAmount := 0;
        TotalInvDiscAmount := 0;
        TotalAmount := 0;
        TotalAmountInclVAT := 0;
        TotalQuantityBase := 0;
        if ("VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax") or
           (("VAT Calculation Type" IN
             ["VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"No Taxable VAT",
              "VAT Calculation Type"::"Reverse Charge VAT"]) and ("VAT %" <> 0))
        then begin
          SalesLine2.SETFILTER("VAT %",'<>0');
          if not SalesLine2.ISEMPTY then begin
            SalesLine2.CALCSUMS("Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT","Quantity (Base)");
            TotalLineAmount := SalesLine2."Line Amount";
            TotalInvDiscAmount := SalesLine2."Inv. Discount Amount";
            TotalAmount := SalesLine2.Amount;
            TotalAmountInclVAT := SalesLine2."Amount Including VAT";
            TotalQuantityBase := SalesLine2."Quantity (Base)";
            OnAfterUpdateTotalAmounts(Rec,SalesLine2,TotalAmount,TotalAmountInclVAT,TotalLineAmount,TotalInvDiscAmount);
          end;
        end;

        if SalesHeader."Prices Including VAT" then
          CASE "VAT Calculation Type" OF
            "VAT Calculation Type"::"Normal VAT",
            "VAT Calculation Type"::"Reverse Charge VAT",
            "VAT Calculation Type"::"No Taxable VAT":
              begin
                Amount :=
                  ROUND(
                    (TotalLineAmount - TotalInvDiscAmount + CalcLineAmount) / (1 + ("VAT %" + "EC %") / 100),
                    Currency."Amount Rounding Precision") -
                  TotalAmount;
                "VAT Base Amount" :=
                  ROUND(
                    Amount * (1 - SalesHeader."VAT Base Discount %" / 100),
                    Currency."Amount Rounding Precision");
                "Amount Including VAT" :=
                  TotalLineAmount + "Line Amount" -
                  ROUND(
                    (TotalAmount + Amount) * (SalesHeader."VAT Base Discount %" / 100) * ("VAT %" + "EC %") / 100,
                    Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                  TotalAmountInclVAT - TotalInvDiscAmount - "Inv. Discount Amount";
              end;
            "VAT Calculation Type"::"Full VAT":
              begin
                Amount := 0;
                "VAT Base Amount" := 0;
              end;
            "VAT Calculation Type"::"Sales Tax":
              begin
                SalesHeader.TESTFIELD("VAT Base Discount %",0);
                Amount :=
                  SalesTaxCalculate.ReverseCalculateTax(
                    "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                    TotalAmountInclVAT + "Amount Including VAT",TotalQuantityBase + "Quantity (Base)",
                    SalesHeader."Currency Factor") -
                  TotalAmount;
                if Amount <> 0 then
                  "VAT %" :=
                    ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                else begin
                  "VAT %" := 0;
                  "EC %" := 0;
                end;
                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                "VAT Base Amount" := Amount;
              end;
          end
        else
          CASE "VAT Calculation Type" OF
            "VAT Calculation Type"::"Normal VAT",
            "VAT Calculation Type"::"Reverse Charge VAT",
            "VAT Calculation Type"::"No Taxable VAT":
              begin
                Amount := ROUND(CalcLineAmount,Currency."Amount Rounding Precision");
                "VAT Base Amount" :=
                  ROUND(Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                "Amount Including VAT" :=
                  TotalAmount + Amount +
                  ROUND(
                    (TotalAmount + Amount) * (1 - SalesHeader."VAT Base Discount %" / 100) * ("VAT %" + "EC %") / 100,
                    Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                  TotalAmountInclVAT;
              end;
            "VAT Calculation Type"::"Full VAT":
              begin
                Amount := 0;
                "VAT Base Amount" := 0;
                "Amount Including VAT" := CalcLineAmount;
              end;
            "VAT Calculation Type"::"Sales Tax":
              begin
                Amount := ROUND(CalcLineAmount,Currency."Amount Rounding Precision");
                "VAT Base Amount" := Amount;
                "Amount Including VAT" :=
                  TotalAmount + Amount +
                  ROUND(
                    SalesTaxCalculate.CalculateTax(
                      "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                      TotalAmount + Amount,TotalQuantityBase + "Quantity (Base)",
                      SalesHeader."Currency Factor"),Currency."Amount Rounding Precision") -
                  TotalAmountInclVAT;
                if "VAT Base Amount" <> 0 then
                  "VAT %" :=
                    ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                else begin
                  "VAT %" := 0;
                  "EC %" := 0;
                end;
              end;
          end;
      end;

      OnAfterUpdateVATAmounts(Rec);
    end;
*/


    
//     procedure CheckItemAvailable (CalledByFieldNo@1000 :
    
/*
procedure CheckItemAvailable (CalledByFieldNo: Integer)
    var
//       IsHandled@1001 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeCheckItemAvailable(Rec,CalledByFieldNo,IsHandled);
      if IsHandled then
        exit;

      if Reserve = Reserve::Always then
        exit;

      if "Shipment Date" = 0D then begin
        GetSalesHeader;
        if SalesHeader."Shipment Date" <> 0D then
          VALIDATE("Shipment Date",SalesHeader."Shipment Date")
        else
          VALIDATE("Shipment Date",WORKDATE);
      end;

      if ((CalledByFieldNo = CurrFieldNo) or (CalledByFieldNo = FIELDNO("Shipment Date"))) and GUIALLOWED and
         ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) and
         (Type = Type::Item) and ("No." <> '') and
         ("Outstanding Quantity" > 0) and
         ("Job Contract Entry No." = 0) and
         not "Special Order"
      then begin
        if ItemCheckAvail.SalesLineCheck(Rec) then
          ItemCheckAvail.RaiseUpdateInterruptedError;
      end;
    end;
*/


    
/*
LOCAL procedure CheckCreditLimit ()
    var
//       IsHandled@1000 :
      IsHandled: Boolean;
    begin
      if (CurrFieldNo <> 0) and
         not ((Type = Type::Item) and (CurrFieldNo = FIELDNO("No.")) and (Quantity <> 0) and
              ("Qty. per Unit of Measure" <> xRec."Qty. per Unit of Measure")) and
         CheckCreditLimitCondition and
         (("Outstanding Amount" + "Shipped not Invoiced") > 0) and
         (CurrFieldNo <> FIELDNO("Blanket Order No.")) and
         (CurrFieldNo <> FIELDNO("Blanket Order Line No."))
      then begin
        IsHandled := FALSE;
        OnUpdateAmountOnBeforeCheckCreditLimit(Rec,IsHandled);
        if not IsHandled then
          CustCheckCreditLimit.SalesLineCheck(Rec);
      end;
    end;
*/


    
/*
LOCAL procedure CheckCreditLimitCondition () : Boolean;
    var
//       RunCheck@1000 :
      RunCheck: Boolean;
    begin
      RunCheck := "Document Type" <= "Document Type"::Invoice;
      OnAfterCheckCreditLimitCondition(Rec,RunCheck);
      exit(RunCheck);
    end;
*/


    
    
/*
procedure ShowReservation ()
    var
//       Reservation@1000 :
      Reservation: Page 498;
    begin
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      TESTFIELD(Reserve);
      CLEAR(Reservation);
      Reservation.SetSalesLine(Rec);
      Reservation.RUNMODAL;
      UpdatePlanned;
    end;
*/


    
//     procedure ShowReservationEntries (Modal@1000 :
    
/*
procedure ShowReservationEntries (Modal: Boolean)
    var
//       ReservEntry@1001 :
      ReservEntry: Record 337;
//       ReservEngineMgt@1002 :
      ReservEngineMgt: Codeunit 99000831;
    begin
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
      ReserveSalesLine.FilterReservFor(ReservEntry,Rec);
      if Modal then
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      else
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    end;
*/


    
    
/*
procedure AutoReserve ()
    var
//       SalesSetup@1003 :
      SalesSetup: Record 311;
//       ReservMgt@1002 :
      ReservMgt: Codeunit 99000845;
//       ConfirmManagement@1004 :
      ConfirmManagement: Codeunit 27;
//       QtyToReserve@1000 :
      QtyToReserve: Decimal;
//       QtyToReserveBase@1001 :
      QtyToReserveBase: Decimal;
    begin
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");

      ReserveSalesLine.ReservQuantity(Rec,QtyToReserve,QtyToReserveBase);
      if QtyToReserveBase <> 0 then begin
        ReservMgt.SetSalesLine(Rec);
        TESTFIELD("Shipment Date");
        ReservMgt.AutoReserve(FullAutoReservation,'',"Shipment Date",QtyToReserve,QtyToReserveBase);
        FIND;
        SalesSetup.GET;
        if (not FullAutoReservation) and (not SalesSetup."Skip Manual Reservation") then begin
          COMMIT;
          if ConfirmManagement.ConfirmProcessUI(ManualReserveQst,TRUE) then begin
            ShowReservation;
            FIND;
          end;
        end;
      end;

      OnAfterAutoReserve(Rec);
    end;
*/


    
    
/*
procedure AutoAsmToOrder ()
    begin
      OnBeforeAutoAsmToOrder(Rec);
      ATOLink.UpdateAsmFromSalesLine(Rec);
      OnAfterAutoAsmToOrder(Rec);
    end;
*/


    
/*
LOCAL procedure GetDate () : Date;
    begin
      if SalesHeader."Posting Date" <> 0D then
        exit(SalesHeader."Posting Date");
      exit(WORKDATE);
    end;
*/


    
//     procedure CalcPlannedDeliveryDate (CurrFieldNo@1000 :
    
/*
procedure CalcPlannedDeliveryDate (CurrFieldNo: Integer) PlannedDeliveryDate : Date;
    var
//       IsHandled@1001 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeCalcPlannedDeliveryDate(Rec,PlannedDeliveryDate,CurrFieldNo,IsHandled);
      if IsHandled then
        exit("Planned Delivery Date");

      if "Shipment Date" = 0D then
        exit("Planned Delivery Date");

      CASE CurrFieldNo OF
        FIELDNO("Shipment Date"):
          exit(CalendarMgmt.CalcDateBOC(
              FORMAT("Shipping Time"),
              "Planned Shipment Date",
              CalChange."Source Type"::"Shipping Agent",
              "Shipping Agent Code",
              "Shipping Agent Service Code",
              CalChange."Source Type"::Customer,
              "Sell-to Customer No.",
              '',
              TRUE));
        FIELDNO("Planned Delivery Date"):
          exit(CalendarMgmt.CalcDateBOC2(
              FORMAT("Shipping Time"),
              "Planned Delivery Date",
              CalChange."Source Type"::"Shipping Agent",
              "Shipping Agent Code",
              "Shipping Agent Service Code",
              CalChange."Source Type"::Location,
              "Location Code",
              '',
              TRUE));
      end;
    end;
*/


    
//     procedure CalcPlannedShptDate (CurrFieldNo@1000 :
    
/*
procedure CalcPlannedShptDate (CurrFieldNo: Integer) : Date;
    begin
      if "Shipment Date" = 0D then
        exit("Planned Shipment Date");

      CASE CurrFieldNo OF
        FIELDNO("Shipment Date"):
          exit(CalendarMgmt.CalcDateBOC(
              FORMAT("Outbound Whse. Handling Time"),
              "Shipment Date",
              CalChange."Source Type"::Location,
              "Location Code",
              '',
              CalChange."Source Type"::"Shipping Agent",
              "Shipping Agent Code",
              "Shipping Agent Service Code",
              TRUE));
        FIELDNO("Planned Delivery Date"):
          exit(CalendarMgmt.CalcDateBOC(
              FORMAT(''),
              "Planned Delivery Date",
              CalChange."Source Type"::Customer,
              "Sell-to Customer No.",
              '',
              CalChange."Source Type"::"Shipping Agent",
              "Shipping Agent Code",
              "Shipping Agent Service Code",
              TRUE));
      end;
    end;
*/


    
    
/*
procedure CalcShipmentDate () : Date;
    begin
      if "Planned Shipment Date" = 0D then
        exit("Shipment Date");

      if FORMAT("Outbound Whse. Handling Time") <> '' then
        exit(
          CalendarMgmt.CalcDateBOC2(
            FORMAT("Outbound Whse. Handling Time"),
            "Planned Shipment Date",
            CalChange."Source Type"::Location,
            "Location Code",
            '',
            CalChange."Source Type"::"Shipping Agent",
            "Shipping Agent Code",
            "Shipping Agent Service Code",
            FALSE));

      exit(
        CalendarMgmt.CalcDateBOC(
          FORMAT(FORMAT('')),
          "Planned Shipment Date",
          CalChange."Source Type"::"Shipping Agent",
          "Shipping Agent Code",
          "Shipping Agent Service Code",
          CalChange."Source Type"::Location,
          "Location Code",
          '',
          FALSE));
    end;
*/


    
//     procedure SignedXX (Value@1000 :
    
/*
procedure SignedXX (Value: Decimal) : Decimal;
    begin
      CASE "Document Type" OF
        "Document Type"::Quote,
        "Document Type"::Order,
        "Document Type"::Invoice,
        "Document Type"::"Blanket Order":
          exit(-Value);
        "Document Type"::"Return Order",
        "Document Type"::"Credit Memo":
          exit(Value);
      end;
    end;
*/


    
/*
LOCAL procedure BlanketOrderLookup ()
    var
//       IsHandled@1000 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeBlanketOrderLookup(Rec,IsHandled);
      if IsHandled then
        exit;

      SalesLine2.RESET;
      SalesLine2.SETCURRENTKEY("Document Type",Type,"No.");
      SalesLine2.SETRANGE("Document Type","Document Type"::"Blanket Order");
      SalesLine2.SETRANGE(Type,Type);
      SalesLine2.SETRANGE("No.","No.");
      SalesLine2.SETRANGE("Bill-to Customer No.","Bill-to Customer No.");
      SalesLine2.SETRANGE("Sell-to Customer No.","Sell-to Customer No.");
      if PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine2) = ACTION::LookupOK then begin
        SalesLine2.TESTFIELD("Document Type","Document Type"::"Blanket Order");
        "Blanket Order No." := SalesLine2."Document No.";
        VALIDATE("Blanket Order Line No.",SalesLine2."Line No.");
      end;

      OnAfterBlanketOrderLookup(Rec);
    end;
*/


    
    
/*
procedure ShowDimensions ()
    begin
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document Type","Document No.","Line No."));
      VerifyItemLineDim;
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      ATOLink.UpdateAsmDimFromSalesLine(Rec);
    end;
*/


    
    
/*
procedure OpenItemTrackingLines ()
    var
//       Job@1000 :
      Job: Record 167;
//       IsHandled@1001 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeOpenItemTrackingLines(Rec,IsHandled);
      if IsHandled then
        exit;

      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      TESTFIELD("Quantity (Base)");
      if "Job Contract Entry No." <> 0 then
        ERROR(Text048,TABLECAPTION,Job.TABLECAPTION);
      ReserveSalesLine.CallItemTracking(Rec);
    end;
*/


    
//     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 :
    
/*
procedure CreateDim (Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20])
    var
//       SourceCodeSetup@1006 :
      SourceCodeSetup: Record 242;
//       TableID@1007 :
      TableID: ARRAY [10] OF Integer;
//       No@1008 :
      No: ARRAY [10] OF Code[20];
    begin
      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      GetSalesHeader;
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Sales,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",SalesHeader."Dimension Set ID",DATABASE::Customer);
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      ATOLink.UpdateAsmDimFromSalesLine(Rec);
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
      VerifyItemLineDim;
    end;
*/


    
//     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure LookupShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    end;
*/


    
//     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    
/*
procedure ShowShortcutDimCode (var ShortcutDimCode: ARRAY [8] OF Code[20])
    begin
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;
*/


    
    
/*
procedure SelectMultipleItems ()
    var
//       ItemListPage@1000 :
      ItemListPage: Page 31;
//       SelectionFilter@1001 :
      SelectionFilter: Text;
    begin
      if IsCreditDocType then
        SelectionFilter := ItemListPage.SelectActiveItems
      else
        SelectionFilter := ItemListPage.SelectActiveItemsForSale;
      if SelectionFilter <> '' then
        AddItems(SelectionFilter);
    end;
*/


//     LOCAL procedure AddItems (SelectionFilter@1000 :
    
/*
LOCAL procedure AddItems (SelectionFilter: Text)
    var
//       Item@1001 :
      Item: Record 27;
//       SalesLine@1002 :
      SalesLine: Record 37;
//       LastSalesLine@1003 :
      LastSalesLine: Record 37;
    begin
      InitNewLine(SalesLine);
      Item.SETFILTER("No.",SelectionFilter);
      if Item.FINDSET then
        repeat
          SalesLine.INIT;
          SalesLine."Line No." += 10000;
          SalesLine.VALIDATE(Type,Type::Item);
          SalesLine.VALIDATE("No.",Item."No.");
          SalesLine.INSERT(TRUE);
          if TransferExtendedText.SalesCheckIfAnyExtText(SalesLine,FALSE) then begin
            TransferExtendedText.InsertSalesExtTextRetLast(SalesLine,LastSalesLine);
            SalesLine."Line No." := LastSalesLine."Line No."
          end;
        until Item.NEXT = 0;
    end;
*/


//     LOCAL procedure InitNewLine (var NewSalesLine@1001 :
    
/*
LOCAL procedure InitNewLine (var NewSalesLine: Record 37)
    var
//       SalesLine@1000 :
      SalesLine: Record 37;
    begin
      NewSalesLine.COPY(Rec);
      SalesLine.SETRANGE("Document Type",NewSalesLine."Document Type");
      SalesLine.SETRANGE("Document No.",NewSalesLine."Document No.");
      if SalesLine.FINDLAST then
        NewSalesLine."Line No." := SalesLine."Line No."
      else
        NewSalesLine."Line No." := 0;
    end;
*/


    
    
/*
procedure ShowItemSub ()
    begin
      CLEAR(SalesHeader);
      TestStatusOpen;
      ItemSubstitutionMgt.ItemSubstGet(Rec);
      if TransferExtendedText.SalesCheckIfAnyExtText(Rec,FALSE) then
        TransferExtendedText.InsertSalesExtText(Rec);

      OnAfterShowItemSub(Rec);
    end;
*/


    
    
/*
procedure ShowNonstock ()
    begin
      TESTFIELD(Type,Type::Item);
      if "No." <> '' then
        ERROR(SelectNonstockItemErr);
      if PAGE.RUNMODAL(PAGE::"Catalog Item List",NonstockItem) = ACTION::LookupOK then begin
        NonstockItem.TESTFIELD("Item Template Code");
        ConfigTemplateHeader.SETRANGE(Code,NonstockItem."Item Template Code");
        ConfigTemplateHeader.FINDFIRST;
        TempItemTemplate.InitializeTempRecordFromConfigTemplate(TempItemTemplate,ConfigTemplateHeader);
        TempItemTemplate.TESTFIELD("Gen. Prod. Posting Group");
        TempItemTemplate.TESTFIELD("Inventory Posting Group");

        "No." := NonstockItem."Entry No.";
        CatalogItemMgt.NonStockSales(Rec);
        VALIDATE("No.","No.");
        VALIDATE("Unit Price",NonstockItem."Unit Price");
      end;
    end;
*/


    
/*
LOCAL procedure GetSalesSetup ()
    begin
      if not SalesSetupRead then
        SalesSetup.GET;
      SalesSetupRead := TRUE;
    end;
*/


    
/*
LOCAL procedure GetFAPostingGroup ()
    var
//       LocalGLAcc@1000 :
      LocalGLAcc: Record 15;
//       FASetup@1001 :
      FASetup: Record 5603;
//       FAPostingGr@1002 :
      FAPostingGr: Record 5606;
//       FADeprBook@1003 :
      FADeprBook: Record 5612;
    begin
      if (Type <> Type::"Fixed Asset") or ("No." = '') then
        exit;
      if "Depreciation Book Code" = '' then begin
        FASetup.GET;
        "Depreciation Book Code" := FASetup."Default Depr. Book";
        if not FADeprBook.GET("No.","Depreciation Book Code") then
          "Depreciation Book Code" := '';
        if "Depreciation Book Code" = '' then
          exit;
      end;
      FADeprBook.GET("No.","Depreciation Book Code");
      FADeprBook.TESTFIELD("FA Posting Group");
      FAPostingGr.GET(FADeprBook."FA Posting Group");
      LocalGLAcc.GET(FAPostingGr.GetAcquisitionCostAccountOnDisposal);
      LocalGLAcc.CheckGLAcc;
      LocalGLAcc.TESTFIELD("Gen. Prod. Posting Group");
      "Posting Group" := FADeprBook."FA Posting Group";
      "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
      "Tax Group Code" := LocalGLAcc."Tax Group Code";
      VALIDATE("VAT Prod. Posting Group",LocalGLAcc."VAT Prod. Posting Group");
    end;
*/


    
//     procedure GetCaptionClass (FieldNumber@1000 :
    
/*
procedure GetCaptionClass (FieldNumber: Integer) : Text[80];
    var
//       CaptionManagement@1001 :
      CaptionManagement: Codeunit 42;
    begin
      exit(CaptionManagement.GetSalesLineCaptionClass(Rec,FieldNumber));
    end;
*/


    
/*
LOCAL procedure GetSKU () : Boolean;
    begin
      if (SKU."Location Code" = "Location Code") and
         (SKU."Item No." = "No.") and
         (SKU."Variant Code" = "Variant Code")
      then
        exit(TRUE);
      if SKU.GET("Location Code","No.","Variant Code") then
        exit(TRUE);

      exit(FALSE);
    end;
*/


    
    
/*
procedure GetUnitCost ()
    var
//       Item@1000 :
      Item: Record 27;
    begin
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      GetItem(Item);
      "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
      if GetSKU then
        VALIDATE("Unit Cost (LCY)",SKU."Unit Cost" * "Qty. per Unit of Measure")
      else
        VALIDATE("Unit Cost (LCY)",Item."Unit Cost" * "Qty. per Unit of Measure");

      OnAfterGetUnitCost(Rec,Item);
    end;
*/


//     LOCAL procedure CalcUnitCost (ItemLedgEntry@1000 :
    
/*
LOCAL procedure CalcUnitCost (ItemLedgEntry: Record 32) : Decimal;
    var
//       ValueEntry@1001 :
      ValueEntry: Record 5802;
//       UnitCost@1004 :
      UnitCost: Decimal;
    begin
      WITH ValueEntry DO begin
        SETCURRENTKEY("Item Ledger Entry No.");
        SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
        if IsNonInventoriableItem then begin
          CALCSUMS("Cost Amount (Non-Invtbl.)");
          UnitCost := "Cost Amount (Non-Invtbl.)" / ItemLedgEntry.Quantity;
        end else begin
          CALCSUMS("Cost Amount (Actual)","Cost Amount (Expected)");
          UnitCost :=
            ("Cost Amount (Expected)" + "Cost Amount (Actual)") / ItemLedgEntry.Quantity;
        end;
      end;

      exit(ABS(UnitCost * "Qty. per Unit of Measure"));
    end;
*/


    
    
/*
procedure ShowItemChargeAssgnt ()
    var
//       ItemChargeAssgntSales@1003 :
      ItemChargeAssgntSales: Record 5809;
//       AssignItemChargeSales@1001 :
      AssignItemChargeSales: Codeunit 5807;
//       ItemChargeAssgnts@1000 :
      ItemChargeAssgnts: Page 5814;
//       ItemChargeAssgntLineAmt@1002 :
      ItemChargeAssgntLineAmt: Decimal;
//       IsHandled@1004 :
      IsHandled: Boolean;
    begin
      GET("Document Type","Document No.","Line No.");
      TESTFIELD("No.");
      TESTFIELD(Quantity);

      if Type <> Type::"Charge (Item)" then
        ERROR(ItemChargeAssignmentErr);

      GetSalesHeader;
      Currency.Initialize(SalesHeader."Currency Code");
      if ("Inv. Discount Amount" = 0) and ("Line Discount Amount" = 0) and
         (not SalesHeader."Prices Including VAT")
      then
        ItemChargeAssgntLineAmt := "Line Amount"
      else
        if SalesHeader."Prices Including VAT" then
          ItemChargeAssgntLineAmt :=
            ROUND(CalcLineAmount / (1 + ("VAT %" + "EC %") / 100),Currency."Amount Rounding Precision")
        else
          ItemChargeAssgntLineAmt := CalcLineAmount;

      ItemChargeAssgntSales.RESET;
      ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
      ItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
      ItemChargeAssgntSales.SETRANGE("Item Charge No.","No.");
      if not ItemChargeAssgntSales.FINDLAST then begin
        ItemChargeAssgntSales."Document Type" := "Document Type";
        ItemChargeAssgntSales."Document No." := "Document No.";
        ItemChargeAssgntSales."Document Line No." := "Line No.";
        ItemChargeAssgntSales."Item Charge No." := "No.";
        ItemChargeAssgntSales."Unit Cost" :=
          ROUND(ItemChargeAssgntLineAmt / Quantity,Currency."Unit-Amount Rounding Precision");
      end;

      IsHandled := FALSE;
      OnShowItemChargeAssgntOnBeforeCalcItemCharge(Rec,ItemChargeAssgntLineAmt,Currency,IsHandled);
      if not IsHandled then
        ItemChargeAssgntLineAmt :=
          ROUND(ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity),Currency."Amount Rounding Precision");

      if IsCreditDocType then
        AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales,"Return Receipt No.")
      else
        AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales,"Shipment No.");
      CLEAR(AssignItemChargeSales);
      COMMIT;

      ItemChargeAssgnts.Initialize(Rec,ItemChargeAssgntLineAmt);
      ItemChargeAssgnts.RUNMODAL;
      CALCFIELDS("Qty. to Assign");
    end;
*/


    
    
/*
procedure UpdateItemChargeAssgnt ()
    var
//       ItemChargeAssgntSales@1003 :
      ItemChargeAssgntSales: Record 5809;
//       ShareOfVAT@1000 :
      ShareOfVAT: Decimal;
//       TotalQtyToAssign@1001 :
      TotalQtyToAssign: Decimal;
//       TotalAmtToAssign@1002 :
      TotalAmtToAssign: Decimal;
    begin
      if "Document Type" = "Document Type"::"Blanket Order" then
        exit;

      CALCFIELDS("Qty. Assigned","Qty. to Assign");
      if ABS("Quantity Invoiced") > ABS(("Qty. Assigned" + "Qty. to Assign")) then
        ERROR(Text055,FIELDCAPTION("Quantity Invoiced"),FIELDCAPTION("Qty. Assigned"),FIELDCAPTION("Qty. to Assign"));

      ItemChargeAssgntSales.RESET;
      ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
      ItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
      ItemChargeAssgntSales.CALCSUMS("Qty. to Assign");
      TotalQtyToAssign := ItemChargeAssgntSales."Qty. to Assign";
      if (CurrFieldNo <> 0) and (Amount <> xRec.Amount) and
         not ((Quantity <> xRec.Quantity) and (TotalQtyToAssign = 0))
      then begin
        ItemChargeAssgntSales.SETFILTER("Qty. Assigned",'<>0');
        if not ItemChargeAssgntSales.ISEMPTY then
          ERROR(Text026,
            FIELDCAPTION(Amount));
        ItemChargeAssgntSales.SETRANGE("Qty. Assigned");
      end;

      if ItemChargeAssgntSales.FINDSET(TRUE) then begin
        GetSalesHeader;
        TotalAmtToAssign := CalcTotalAmtToAssign(TotalQtyToAssign);
        repeat
          ShareOfVAT := 1;
          if SalesHeader."Prices Including VAT" then
            ShareOfVAT := 1 + "VAT %" / 100;
          if Quantity <> 0 then
            if ItemChargeAssgntSales."Unit Cost" <>
               ROUND(CalcLineAmount / Quantity / ShareOfVAT,Currency."Unit-Amount Rounding Precision")
            then
              ItemChargeAssgntSales."Unit Cost" :=
                ROUND(CalcLineAmount / Quantity / ShareOfVAT,Currency."Unit-Amount Rounding Precision");
          if TotalQtyToAssign <> 0 then begin
            ItemChargeAssgntSales."Amount to Assign" :=
              ROUND(ItemChargeAssgntSales."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                Currency."Amount Rounding Precision");
            TotalQtyToAssign -= ItemChargeAssgntSales."Qty. to Assign";
            TotalAmtToAssign -= ItemChargeAssgntSales."Amount to Assign";
          end;
          ItemChargeAssgntSales.MODIFY;
        until ItemChargeAssgntSales.NEXT = 0;
        CALCFIELDS("Qty. to Assign");
      end;
    end;
*/


//     LOCAL procedure DeleteItemChargeAssgnt (DocType@1000 : Option;DocNo@1001 : Code[20];DocLineNo@1002 :
    
/*
LOCAL procedure DeleteItemChargeAssgnt (DocType: Option;DocNo: Code[20];DocLineNo: Integer)
    var
//       ItemChargeAssgntSales@1003 :
      ItemChargeAssgntSales: Record 5809;
    begin
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type",DocType);
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.",DocNo);
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.",DocLineNo);
      if not ItemChargeAssgntSales.ISEMPTY then
        ItemChargeAssgntSales.DELETEALL(TRUE);
    end;
*/


//     LOCAL procedure DeleteChargeChargeAssgnt (DocType@1000 : Option;DocNo@1001 : Code[20];DocLineNo@1002 :
    
/*
LOCAL procedure DeleteChargeChargeAssgnt (DocType: Option;DocNo: Code[20];DocLineNo: Integer)
    var
//       ItemChargeAssgntSales@1003 :
      ItemChargeAssgntSales: Record 5809;
    begin
      if DocType <> "Document Type"::"Blanket Order" then
        if "Quantity Invoiced" <> 0 then begin
          CALCFIELDS("Qty. Assigned");
          TESTFIELD("Qty. Assigned","Quantity Invoiced");
        end;

      ItemChargeAssgntSales.RESET;
      ItemChargeAssgntSales.SETRANGE("Document Type",DocType);
      ItemChargeAssgntSales.SETRANGE("Document No.",DocNo);
      ItemChargeAssgntSales.SETRANGE("Document Line No.",DocLineNo);
      if not ItemChargeAssgntSales.ISEMPTY then
        ItemChargeAssgntSales.DELETEALL;
    end;
*/


    
/*
LOCAL procedure CheckItemChargeAssgnt ()
    var
//       ItemChargeAssgntSales@1000 :
      ItemChargeAssgntSales: Record 5809;
    begin
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type","Document Type");
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.","Document No.");
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.","Line No.");
      ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
      if ItemChargeAssgntSales.FINDSET then begin
        TESTFIELD("Allow Item Charge Assignment");
        repeat
          ItemChargeAssgntSales.TESTFIELD("Qty. to Assign",0);
        until ItemChargeAssgntSales.NEXT = 0;
      end;
    end;
*/


    
    
/*
procedure TestStatusOpen ()
    begin
      if StatusCheckSuspended then
        exit;

      GetSalesHeader;
      OnBeforeTestStatusOpen(Rec,SalesHeader);

      if not "System-Created Entry" then
        if HasTypeToFillMandatoryFields then
          SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);

      OnAfterTestStatusOpen(Rec,SalesHeader);
    end;
*/


    
//     procedure SuspendStatusCheck (Suspend@1000 :
    
/*
procedure SuspendStatusCheck (Suspend: Boolean)
    begin
      StatusCheckSuspended := Suspend;
    end;
*/


    
//     procedure UpdateVATOnLines (QtyType@1000 : 'General,Invoicing,Shipping';var SalesHeader@1001 : Record 36;var SalesLine@1002 : Record 37;var VATAmountLine@1003 :
    
/*
procedure UpdateVATOnLines (QtyType: Option "General","Invoicing","Shipping";var SalesHeader: Record 36;var SalesLine: Record 37;var VATAmountLine: Record 290) LineWasModified : Boolean;
    var
//       TempVATAmountLineRemainder@1004 :
      TempVATAmountLineRemainder: Record 290 TEMPORARY;
//       Currency@1005 :
      Currency: Record 4;
//       NewAmount@1006 :
      NewAmount: Decimal;
//       NewAmountIncludingVAT@1007 :
      NewAmountIncludingVAT: Decimal;
//       NewVATBaseAmount@1008 :
      NewVATBaseAmount: Decimal;
//       VATAmount@1009 :
      VATAmount: Decimal;
//       VATDifference@1010 :
      VATDifference: Decimal;
//       InvDiscAmount@1011 :
      InvDiscAmount: Decimal;
//       LineAmountToInvoice@1012 :
      LineAmountToInvoice: Decimal;
//       ECDifference@1100000 :
      ECDifference: Decimal;
//       LineAmountToInvoiceDiscounted@1013 :
      LineAmountToInvoiceDiscounted: Decimal;
//       DeferralAmount@1014 :
      DeferralAmount: Decimal;
    begin
      LineWasModified := FALSE;
      if QtyType = QtyType::Shipping then
        exit;
      if SalesHeader."Currency Code" = '' then
        Currency.InitRoundingPrecision
      else
        Currency.GET(SalesHeader."Currency Code");

      TempVATAmountLineRemainder.DELETEALL;

      WITH SalesLine DO begin
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        LOCKTABLE;
        if FINDSET then
          repeat
            if not ZeroAmountLine(QtyType) then begin
              DeferralAmount := GetDeferralAmount;
              VATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0);
              if VATAmountLine.Modified then begin
                if not TempVATAmountLineRemainder.GET(
                     "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0)
                then begin
                  TempVATAmountLineRemainder := VATAmountLine;
                  TempVATAmountLineRemainder.INIT;
                  TempVATAmountLineRemainder.INSERT;
                end;

                if QtyType = QtyType::General then
                  LineAmountToInvoice := "Line Amount"
                else
                  LineAmountToInvoice :=
                    ROUND("Line Amount" * "Qty. to Invoice" / Quantity,Currency."Amount Rounding Precision");

                if "Allow Invoice Disc." then begin
                  if (VATAmountLine."Inv. Disc. Base Amount" = 0) or (LineAmountToInvoice = 0) then
                    InvDiscAmount := 0
                  else begin
                    LineAmountToInvoiceDiscounted :=
                      VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice /
                      VATAmountLine."Inv. Disc. Base Amount";
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount" + LineAmountToInvoiceDiscounted;
                    InvDiscAmount :=
                      ROUND(
                        TempVATAmountLineRemainder."Invoice Discount Amount",Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount" - InvDiscAmount;
                  end;
                  if QtyType = QtyType::General then begin
                    "Inv. Discount Amount" := InvDiscAmount;
                    CalcInvDiscToInvoice;
                  end else
                    "Inv. Disc. Amount to Invoice" := InvDiscAmount;
                end else
                  InvDiscAmount := 0;

                if QtyType = QtyType::General then
                  if SalesHeader."Prices Including VAT" then begin
                    if (VATAmountLine.CalcLineAmount = 0) or ("Line Amount" = 0) then begin
                      VATAmount := 0;
                      NewAmountIncludingVAT := 0;
                    end else begin
                      VATAmount :=
                        TempVATAmountLineRemainder."VAT Amount" +
                        VATAmountLine."VAT Amount" * CalcLineAmount / VATAmountLine.CalcLineAmount +
                        VATAmountLine."EC Amount" * CalcLineAmount / VATAmountLine.CalcLineAmount;
                      NewAmountIncludingVAT :=
                        TempVATAmountLineRemainder."Amount Including VAT" +
                        VATAmountLine."Amount Including VAT" * CalcLineAmount / VATAmountLine.CalcLineAmount;
                    end;
                    NewAmount :=
                      ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision") -
                      ROUND(VATAmount,Currency."Amount Rounding Precision");
                    NewVATBaseAmount :=
                      ROUND(
                        NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                  end else begin
                    if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then begin
                      VATAmount := CalcLineAmount - "Pmt. Discount Amount";
                      NewAmount := 0;
                      NewVATBaseAmount := 0;
                    end else begin
                      NewAmount := CalcLineAmount - "Pmt. Discount Amount";
                      NewVATBaseAmount :=
                        ROUND(
                          NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                      if VATAmountLine."VAT Base" = 0 then
                        VATAmount := 0
                      else
                        VATAmount :=
                          TempVATAmountLineRemainder."VAT Amount" +
                          VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base" +
                          VATAmountLine."EC Amount" * NewAmount / VATAmountLine."VAT Base";
                    end;
                    NewAmountIncludingVAT := NewAmount + ROUND(VATAmount,Currency."Amount Rounding Precision");
                  end
                else begin
                  if VATAmountLine.CalcLineAmount = 0 then begin
                    VATDifference := 0;
                    ECDifference := 0;
                  end else begin
                    VATDifference :=
                      TempVATAmountLineRemainder."VAT Difference" +
                      VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) / VATAmountLine.CalcLineAmount;
                    ECDifference :=
                      TempVATAmountLineRemainder."EC Difference" +
                      VATAmountLine."EC Difference" * (LineAmountToInvoice - InvDiscAmount) / VATAmountLine.CalcLineAmount;
                  end;

                  if LineAmountToInvoice = 0 then begin
                    "VAT Difference" := 0;
                    "EC Difference" := 0;
                  end else begin
                    "VAT Difference" := ROUND(VATDifference,Currency."Amount Rounding Precision");
                    "EC Difference" := ROUND(ECDifference,Currency."Amount Rounding Precision");
                  end;
                end;
                if QtyType = QtyType::General then begin
                  if not "Prepayment Line" then
                    UpdatePrepmtAmounts;
                  UpdateBaseAmounts(NewAmount,ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision"),NewVATBaseAmount);
                end;
                InitOutstanding;
                if Type = Type::"Charge (Item)" then
                  UpdateItemChargeAssgnt;
                MODIFY;
                LineWasModified := TRUE;

                if ("Deferral Code" <> '') and (DeferralAmount <> GetDeferralAmount) then
                  UpdateDeferralAmounts;

                TempVATAmountLineRemainder."Amount Including VAT" :=
                  NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                TempVATAmountLineRemainder."VAT Difference" := VATDifference - "VAT Difference";
                TempVATAmountLineRemainder."EC Difference" := ECDifference - "EC Difference";
                TempVATAmountLineRemainder.MODIFY;
              end;
            end;
          until NEXT = 0;
      end;

      OnAfterUpdateVATOnLines(SalesHeader,SalesLine,VATAmountLine,QtyType);
    end;
*/


    
//     procedure CalcVATAmountLines (QtyType@1000 : 'General,Invoicing,Shipping';var SalesHeader@1001 : Record 36;var SalesLine@1002 : Record 37;var VATAmountLine@1003 :
    
/*
procedure CalcVATAmountLines (QtyType: Option "General","Invoicing","Shipping";var SalesHeader: Record 36;var SalesLine: Record 37;var VATAmountLine: Record 290)
    var
//       TotalVATAmount@1011 :
      TotalVATAmount: Decimal;
//       QtyToHandle@1006 :
      QtyToHandle: Decimal;
//       AmtToHandle@1015 :
      AmtToHandle: Decimal;
//       RoundingLineInserted@1010 :
      RoundingLineInserted: Boolean;
    begin
      if IsCalcVATAmountLinesHandled(SalesHeader,SalesLine,VATAmountLine) then
        exit;

      Currency.Initialize(SalesHeader."Currency Code");

      VATAmountLine.DELETEALL;

      WITH SalesLine DO begin
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        if FINDSET then
          repeat
            if not ZeroAmountLine(QtyType) then begin
              if (Type = Type::"G/L Account") and not "Prepayment Line" then
                RoundingLineInserted := (("No." = GetCPGInvRoundAcc(SalesHeader)) and "System-Created Entry") or RoundingLineInserted;
              if "VAT Calculation Type" IN
                 ["VAT Calculation Type"::"Reverse Charge VAT","VAT Calculation Type"::"Sales Tax"]
              then begin
                "VAT %" := 0;
                "EC %" := 0;
              end;
              if not VATAmountLine.GET(
                   "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0)
              then
                VATAmountLine.InsertNewLine(
                  "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"VAT %","Line Amount" >= 0,FALSE,"EC %");

              CASE QtyType OF
                QtyType::General:
                  begin
                    VATAmountLine.Quantity += "Quantity (Base)";
                    VATAmountLine.SumLine(
                      "Line Amount","Inv. Discount Amount","Pmt. Discount Amount","VAT Difference","EC Difference",
                      "Allow Invoice Disc.","Prepayment Line");
                  end;
                QtyType::Invoicing:
                  begin
                    CASE TRUE OF
                      ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) and
                      (not SalesHeader.Ship) and SalesHeader.Invoice and (not "Prepayment Line"):
                        if "Shipment No." = '' then begin
                          QtyToHandle := GetAbsMin("Qty. to Invoice","Qty. Shipped not Invoiced");
                          VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Qty. Shipped not Invd. (Base)");
                        end else begin
                          QtyToHandle := "Qty. to Invoice";
                          VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                        end;
                      IsCreditDocType and (not SalesHeader.Receive) and SalesHeader.Invoice:
                        if "Return Receipt No." = '' then begin
                          QtyToHandle := GetAbsMin("Qty. to Invoice","Return Qty. Rcd. not Invd.");
                          VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Ret. Qty. Rcd. not Invd.(Base)");
                        end else begin
                          QtyToHandle := "Qty. to Invoice";
                          VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                        end;
                      else
                        begin
                        QtyToHandle := "Qty. to Invoice";
                        VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                      end;
                    end;
                    AmtToHandle := GetLineAmountToHandleInclPrepmt(QtyToHandle);
                    if SalesHeader."Invoice Discount Calculation" <> SalesHeader."Invoice Discount Calculation"::Amount then
                      VATAmountLine.SumLine(
                        AmtToHandle,ROUND("Inv. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                        ROUND("Pmt. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                        "VAT Difference","EC Difference","Allow Invoice Disc.","Prepayment Line")
                    else
                      VATAmountLine.SumLine(
                        AmtToHandle,"Inv. Disc. Amount to Invoice",
                        ROUND("Pmt. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                        "VAT Difference","EC Difference","Allow Invoice Disc.","Prepayment Line");
                  end;
                QtyType::Shipping:
                  begin
                    if "Document Type" IN
                       ["Document Type"::"Return Order","Document Type"::"Credit Memo"]
                    then begin
                      QtyToHandle := "Return Qty. to Receive";
                      VATAmountLine.Quantity += "Return Qty. to Receive (Base)";
                    end else begin
                      QtyToHandle := "Qty. to Ship";
                      VATAmountLine.Quantity += "Qty. to Ship (Base)";
                    end;
                    AmtToHandle := GetLineAmountToHandleInclPrepmt(QtyToHandle);
                    VATAmountLine.SumLine(
                      AmtToHandle,ROUND("Inv. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                      ROUND("Pmt. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                      "VAT Difference","EC Difference","Allow Invoice Disc.","Prepayment Line");
                  end;
              end;
              TotalVATAmount += "Amount Including VAT" - Amount;
            end;
          until NEXT = 0;
      end;

      VATAmountLine.UpdateLines(
        TotalVATAmount,Currency,SalesHeader."Currency Factor",SalesHeader."Prices Including VAT",
        SalesHeader."VAT Base Discount %",SalesHeader."Tax Area Code",SalesHeader."Tax Liable",SalesHeader."Posting Date");

      if RoundingLineInserted and (TotalVATAmount <> 0) then
        if GetVATAmountLineOfMaxAmt(VATAmountLine,SalesLine) then begin
          VATAmountLine."VAT Amount" += TotalVATAmount;
          VATAmountLine."Amount Including VAT" += TotalVATAmount;
          VATAmountLine."Calculated VAT Amount" += TotalVATAmount;
          VATAmountLine.MODIFY;
        end;

      OnAfterCalcVATAmountLines(SalesHeader,SalesLine,VATAmountLine,QtyType);
    end;
*/


    
//     procedure GetCPGInvRoundAcc (var SalesHeader@1000 :
    
/*
procedure GetCPGInvRoundAcc (var SalesHeader: Record 36) : Code[20];
    var
//       Cust@1002 :
      Cust: Record 18;
//       CustTemplate@1003 :
      CustTemplate: Record 5105;
//       CustPostingGroup@1004 :
      CustPostingGroup: Record 92;
    begin
      GetSalesSetup;
      if SalesSetup."Invoice Rounding" then
        if Cust.GET(SalesHeader."Bill-to Customer No.") then
          CustPostingGroup.GET(Cust."Customer Posting Group")
        else
          if CustTemplate.GET(SalesHeader."Sell-to Customer Template Code") then
            CustPostingGroup.GET(CustTemplate."Customer Posting Group");

      exit(CustPostingGroup."Invoice Rounding Account");
    end;
*/


//     LOCAL procedure GetVATAmountLineOfMaxAmt (var VATAmountLine@1001 : Record 290;SalesLine@1000 :
    
/*
LOCAL procedure GetVATAmountLineOfMaxAmt (var VATAmountLine: Record 290;SalesLine: Record 37) : Boolean;
    var
//       VATAmount1@1002 :
      VATAmount1: Decimal;
//       VATAmount2@1003 :
      VATAmount2: Decimal;
//       IsPositive1@1004 :
      IsPositive1: Boolean;
//       IsPositive2@1005 :
      IsPositive2: Boolean;
    begin
      if VATAmountLine.GET(SalesLine."VAT Identifier",SalesLine."VAT Calculation Type",SalesLine."Tax Group Code",FALSE,FALSE) then begin
        VATAmount1 := VATAmountLine."VAT Amount";
        IsPositive1 := VATAmountLine.Positive;
      end;
      if VATAmountLine.GET(SalesLine."VAT Identifier",SalesLine."VAT Calculation Type",SalesLine."Tax Group Code",FALSE,TRUE) then begin
        VATAmount2 := VATAmountLine."VAT Amount";
        IsPositive2 := VATAmountLine.Positive;
      end;
      if ABS(VATAmount1) >= ABS(VATAmount2) then
        exit(
          VATAmountLine.GET(SalesLine."VAT Identifier",SalesLine."VAT Calculation Type",SalesLine."Tax Group Code",FALSE,IsPositive1));
      exit(
        VATAmountLine.GET(SalesLine."VAT Identifier",SalesLine."VAT Calculation Type",SalesLine."Tax Group Code",FALSE,IsPositive2));
    end;
*/


    
/*
LOCAL procedure CalcInvDiscToInvoice ()
    var
//       OldInvDiscAmtToInv@1000 :
      OldInvDiscAmtToInv: Decimal;
    begin
      GetSalesHeader;
      OldInvDiscAmtToInv := "Inv. Disc. Amount to Invoice";
      if Quantity = 0 then
        VALIDATE("Inv. Disc. Amount to Invoice",0)
      else
        VALIDATE(
          "Inv. Disc. Amount to Invoice",
          ROUND(
            "Inv. Discount Amount" * "Qty. to Invoice" / Quantity,
            Currency."Amount Rounding Precision"));

      if OldInvDiscAmtToInv <> "Inv. Disc. Amount to Invoice" then begin
        "Amount Including VAT" := "Amount Including VAT" - "VAT Difference";
        "VAT Difference" := 0;
        "EC Difference" := 0;
      end;
    end;
*/


    
    
/*
procedure UpdateWithWarehouseShip ()
    begin
      if Type = Type::Item then
        CASE TRUE OF
          ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) and (Quantity >= 0):
            if Location.RequireShipment("Location Code") then
              VALIDATE("Qty. to Ship",0)
            else
              VALIDATE("Qty. to Ship","Outstanding Quantity");
          ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) and (Quantity < 0):
            if Location.RequireReceive("Location Code") then
              VALIDATE("Qty. to Ship",0)
            else
              VALIDATE("Qty. to Ship","Outstanding Quantity");
          ("Document Type" = "Document Type"::"Return Order") and (Quantity >= 0):
            if Location.RequireReceive("Location Code") then
              VALIDATE("Return Qty. to Receive",0)
            else
              VALIDATE("Return Qty. to Receive","Outstanding Quantity");
          ("Document Type" = "Document Type"::"Return Order") and (Quantity < 0):
            if Location.RequireShipment("Location Code") then
              VALIDATE("Return Qty. to Receive",0)
            else
              VALIDATE("Return Qty. to Receive","Outstanding Quantity");
        end;
      SetDefaultQuantity;
    end;
*/


    
/*
LOCAL procedure CheckWarehouse ()
    var
//       Location2@1002 :
      Location2: Record 14;
//       WhseSetup@1000 :
      WhseSetup: Record 5769;
//       ShowDialog@1001 :
      ShowDialog: Option " ","Message","Error";
//       DialogText@1003 :
      DialogText: Text[50];
    begin
      GetLocation("Location Code");
      if "Location Code" = '' then begin
        WhseSetup.GET;
        Location2."Require Shipment" := WhseSetup."Require Shipment";
        Location2."Require Pick" := WhseSetup."Require Pick";
        Location2."Require Receive" := WhseSetup."Require Receive";
        Location2."Require Put-away" := WhseSetup."Require Put-away";
      end else
        Location2 := Location;

      DialogText := Text035;
      if ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) and
         Location2."Directed Put-away and Pick"
      then begin
        ShowDialog := ShowDialog::Error;
        if (("Document Type" = "Document Type"::Order) and (Quantity >= 0)) or
           (("Document Type" = "Document Type"::"Return Order") and (Quantity < 0))
        then
          DialogText :=
            DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"))
        else
          DialogText :=
            DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"));
      end else begin
        if (("Document Type" = "Document Type"::Order) and (Quantity >= 0) and
            (Location2."Require Shipment" or Location2."Require Pick")) or
           (("Document Type" = "Document Type"::"Return Order") and (Quantity < 0) and
            (Location2."Require Shipment" or Location2."Require Pick"))
        then begin
          if WhseValidateSourceLine.WhseLinesExist(
               DATABASE::"Sales Line",
               "Document Type",
               "Document No.",
               "Line No.",
               0,
               Quantity)
          then
            ShowDialog := ShowDialog::Error
          else
            if Location2."Require Shipment" then
              ShowDialog := ShowDialog::Message;
          if Location2."Require Shipment" then
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"))
          else begin
            DialogText := Text036;
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Pick"));
          end;
        end;

        if (("Document Type" = "Document Type"::Order) and (Quantity < 0) and
            (Location2."Require Receive" or Location2."Require Put-away")) or
           (("Document Type" = "Document Type"::"Return Order") and (Quantity >= 0) and
            (Location2."Require Receive" or Location2."Require Put-away"))
        then begin
          if WhseValidateSourceLine.WhseLinesExist(
               DATABASE::"Sales Line",
               "Document Type",
               "Document No.",
               "Line No.",
               0,
               Quantity)
          then
            ShowDialog := ShowDialog::Error
          else
            if Location2."Require Receive" then
              ShowDialog := ShowDialog::Message;
          if Location2."Require Receive" then
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"))
          else begin
            DialogText := Text036;
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Put-away"));
          end;
        end;
      end;

      CASE ShowDialog OF
        ShowDialog::Message:
          MESSAGE(WhseRequirementMsg,DialogText);
        ShowDialog::Error:
          ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
      end;

      HandleDedicatedBin(TRUE);
    end;
*/


    
/*
LOCAL procedure UpdateDates ()
    begin
      if CurrFieldNo = 0 then begin
        PlannedShipmentDateCalculated := FALSE;
        PlannedDeliveryDateCalculated := FALSE;
      end;
      if "Promised Delivery Date" <> 0D then
        VALIDATE("Promised Delivery Date")
      else
        if "Requested Delivery Date" <> 0D then
          VALIDATE("Requested Delivery Date")
        else
          VALIDATE("Shipment Date");

      OnAfterUpdateDates(Rec);
    end;
*/


    
    
/*
procedure GetItemTranslation ()
    var
//       ItemTranslation@1000 :
      ItemTranslation: Record 30;
    begin
      GetSalesHeader;
      if ItemTranslation.GET("No.","Variant Code",SalesHeader."Language Code") then begin
        Description := ItemTranslation.Description;
        "Description 2" := ItemTranslation."Description 2";
      end;
    end;
*/


//     LOCAL procedure GetLocation (LocationCode@1000 :
    
/*
LOCAL procedure GetLocation (LocationCode: Code[10])
    begin
      if LocationCode = '' then
        CLEAR(Location)
      else
        if Location.Code <> LocationCode then
          Location.GET(LocationCode);
    end;
*/


    
    
/*
procedure PriceExists () : Boolean;
    begin
      if "Document No." <> '' then begin
        GetSalesHeader;
        exit(PriceCalcMgt.SalesLinePriceExists(SalesHeader,Rec,TRUE));
      end;
      exit(FALSE);
    end;
*/


    
    
/*
procedure LineDiscExists () : Boolean;
    begin
      if "Document No." <> '' then begin
        GetSalesHeader;
        exit(PriceCalcMgt.SalesLineLineDiscExists(SalesHeader,Rec,TRUE));
      end;
      exit(FALSE);
    end;
*/


    
    
/*
procedure RowID1 () : Text[250];
    var
//       ItemTrackingMgt@1000 :
      ItemTrackingMgt: Codeunit 6500;
    begin
      exit(ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Line","Document Type",
          "Document No.",'',0,"Line No."));
    end;
*/


    
/*
LOCAL procedure UpdateItemCrossRef ()
    begin
      DistIntegration.EnterSalesItemCrossRef(Rec);
      UpdateICPartner;
    end;
*/


    
/*
LOCAL procedure GetDefaultBin ()
    var
//       WMSManagement@1000 :
      WMSManagement: Codeunit 7302;
//       IsHandled@1001 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeGetDefaultBin(Rec,IsHandled);
      if IsHandled then
        exit;

      if Type <> Type::Item then
        exit;

      "Bin Code" := '';
      if "Drop Shipment" then
        exit;

      if ("Location Code" <> '') and ("No." <> '') then begin
        GetLocation("Location Code");
        if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then begin
          if ("Qty. to Assemble to Order" > 0) or IsAsmToOrderRequired then
            if GetATOBin(Location,"Bin Code") then
              exit;

          WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code");
          HandleDedicatedBin(FALSE);
        end;
      end;
    end;
*/


    
//     procedure GetATOBin (Location@1001 : Record 14;var BinCode@1002 :
    
/*
procedure GetATOBin (Location: Record 14;var BinCode: Code[20]) : Boolean;
    var
//       AsmHeader@1000 :
      AsmHeader: Record 900;
    begin
      if not Location."Require Shipment" then
        BinCode := Location."Asm.-to-Order Shpt. Bin Code";
      if BinCode <> '' then
        exit(TRUE);

      if AsmHeader.GetFromAssemblyBin(Location,BinCode) then
        exit(TRUE);

      exit(FALSE);
    end;
*/


    
    
/*
procedure IsInbound () : Boolean;
    begin
      CASE "Document Type" OF
        "Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote,"Document Type"::"Blanket Order":
          exit("Quantity (Base)" < 0);
        "Document Type"::"Return Order","Document Type"::"Credit Memo":
          exit("Quantity (Base)" > 0);
      end;

      exit(FALSE);
    end;
*/


//     LOCAL procedure HandleDedicatedBin (IssueWarning@1001 :
    
/*
LOCAL procedure HandleDedicatedBin (IssueWarning: Boolean)
    var
//       WhseIntegrationMgt@1002 :
      WhseIntegrationMgt: Codeunit 7317;
    begin
      if not IsInbound and ("Quantity (Base)" <> 0) then
        WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc("Location Code","Bin Code",IssueWarning);
    end;
*/


//     LOCAL procedure CheckAssocPurchOrder (TheFieldCaption@1000 :
    
/*
LOCAL procedure CheckAssocPurchOrder (TheFieldCaption: Text[250])
    var
//       IsHandled@1001 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeCheckAssocPurchOrder(Rec,TheFieldCaption,IsHandled);
      if IsHandled then
        exit;

      if TheFieldCaption = '' then begin // if sales line is being deleted
        if "Purch. Order Line No." <> 0 then
          ERROR(Text000,"Purchase Order No.","Purch. Order Line No.");
        if "Special Order Purch. Line No." <> 0 then
          CheckPurchOrderLineDeleted("Special Order Purchase No.","Special Order Purch. Line No.");
      end else begin
        if "Purch. Order Line No." <> 0 then
          ERROR(Text002,TheFieldCaption,"Purchase Order No.","Purch. Order Line No.");

        if "Special Order Purch. Line No." <> 0 then
          ERROR(Text002,TheFieldCaption,"Special Order Purchase No.","Special Order Purch. Line No.");
      end;
    end;
*/


//     LOCAL procedure CheckPurchOrderLineDeleted (PurchaseOrderNo@1001 : Code[20];PurchaseLineNo@1002 :
    
/*
LOCAL procedure CheckPurchOrderLineDeleted (PurchaseOrderNo: Code[20];PurchaseLineNo: Integer)
    var
//       PurchaseLine@1000 :
      PurchaseLine: Record 39;
    begin
      if PurchaseLine.GET(PurchaseLine."Document Type"::Order,PurchaseOrderNo,PurchaseLineNo) then
        ERROR(Text000,PurchaseOrderNo,PurchaseLineNo);
    end;
*/


    
    
/*
procedure CrossReferenceNoLookUp ()
    var
//       ItemCrossReference@1000 :
      ItemCrossReference: Record 5717;
//       ICGLAcc@1001 :
      ICGLAcc: Record 410;
    begin
      CASE Type OF
        Type::Item:
          begin
            GetSalesHeader;
            ItemCrossReference.RESET;
            ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
            ItemCrossReference.SETFILTER(
              "Cross-Reference Type",'%1|%2',
              ItemCrossReference."Cross-Reference Type"::Customer,
              ItemCrossReference."Cross-Reference Type"::" ");
            ItemCrossReference.SETFILTER("Cross-Reference Type No.",'%1|%2',SalesHeader."Sell-to Customer No.",'');
            if PAGE.RUNMODAL(PAGE::"Cross Reference List",ItemCrossReference) = ACTION::LookupOK then begin
              "Cross-Reference No." := ItemCrossReference."Cross-Reference No.";
              ValidateCrossReferenceNo(ItemCrossReference,FALSE);
              PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,Rec);
              PriceCalcMgt.FindSalesLinePrice(SalesHeader,Rec,FIELDNO("Cross-Reference No."));
              OnCrossReferenceNoLookupOnBeforeValidateUnitPrice(SalesHeader,Rec);
              VALIDATE("Unit Price");
            end;
          end;
        Type::"G/L Account",Type::Resource:
          begin
            GetSalesHeader;
            SalesHeader.TESTFIELD("Sell-to IC Partner Code");
            if PAGE.RUNMODAL(PAGE::"IC G/L Account List",ICGLAcc) = ACTION::LookupOK then
              "Cross-Reference No." := ICGLAcc."No.";
          end;
      end;
    end;
*/


//     LOCAL procedure ValidateCrossReferenceNo (ItemCrossReference@1001 : Record 5717;SearchItem@1000 :
    
/*
LOCAL procedure ValidateCrossReferenceNo (ItemCrossReference: Record 5717;SearchItem: Boolean)
    var
//       ReturnedItemCrossReference@1002 :
      ReturnedItemCrossReference: Record 5717;
    begin
      ReturnedItemCrossReference.INIT;
      if "Cross-Reference No." <> '' then begin
        if SearchItem then
          DistIntegration.ICRLookupSalesItem(Rec,ReturnedItemCrossReference,CurrFieldNo <> 0)
        else
          ReturnedItemCrossReference := ItemCrossReference;

        OnBeforeCrossReferenceNoAssign(Rec,ReturnedItemCrossReference);

        if "No." <> ReturnedItemCrossReference."Item No." then
          VALIDATE("No.",ReturnedItemCrossReference."Item No.");
        if ReturnedItemCrossReference."Variant Code" <> '' then
          VALIDATE("Variant Code",ReturnedItemCrossReference."Variant Code");

        if ReturnedItemCrossReference."Unit of Measure" <> '' then
          VALIDATE("Unit of Measure Code",ReturnedItemCrossReference."Unit of Measure");
      end;

      "Unit of Measure (Cross Ref.)" := ReturnedItemCrossReference."Unit of Measure";
      "Cross-Reference Type" := ReturnedItemCrossReference."Cross-Reference Type";
      "Cross-Reference Type No." := ReturnedItemCrossReference."Cross-Reference Type No.";
      "Cross-Reference No." := ReturnedItemCrossReference."Cross-Reference No.";

      if (ReturnedItemCrossReference.Description <> '') or (ReturnedItemCrossReference."Description 2" <> '') then begin
        Description := ReturnedItemCrossReference.Description;
        "Description 2" := ReturnedItemCrossReference."Description 2";
      end;

      UpdateUnitPrice(FIELDNO("Cross-Reference No."));
      UpdateICPartner;
    end;
*/


    
/*
LOCAL procedure CheckServItemCreation ()
    var
//       Item@1001 :
      Item: Record 27;
//       ServItemGroup@1000 :
      ServItemGroup: Record 5904;
    begin
      if CurrFieldNo = 0 then
        exit;
      if Type <> Type::Item then
        exit;
      GetItem(Item);
      if Item."Service Item Group" = '' then
        exit;
      if ServItemGroup.GET(Item."Service Item Group") then
        if ServItemGroup."Create Service Item" then
          if "Qty. to Ship (Base)" <> ROUND("Qty. to Ship (Base)",1) then
            ERROR(
              Text034,
              FIELDCAPTION("Qty. to Ship (Base)"),
              ServItemGroup.FIELDCAPTION("Create Service Item"));
    end;
*/


    
//     procedure ItemExists (ItemNo@1000 :
    
/*
procedure ItemExists (ItemNo: Code[20]) : Boolean;
    var
//       Item2@1001 :
      Item2: Record 27;
    begin
      if Type = Type::Item then
        if not Item2.GET(ItemNo) then
          exit(FALSE);
      exit(TRUE);
    end;
*/


    
    
/*
procedure IsShipment () : Boolean;
    begin
      exit(SignedXX("Quantity (Base)") < 0);
    end;
*/


//     LOCAL procedure GetAbsMin (QtyToHandle@1000 : Decimal;QtyHandled@1001 :
    
/*
LOCAL procedure GetAbsMin (QtyToHandle: Decimal;QtyHandled: Decimal) : Decimal;
    begin
      if ABS(QtyHandled) < ABS(QtyToHandle) then
        exit(QtyHandled);

      exit(QtyToHandle);
    end;
*/


    
//     procedure SetHideValidationDialog (NewHideValidationDialog@1000 :
    
/*
procedure SetHideValidationDialog (NewHideValidationDialog: Boolean)
    begin
      HideValidationDialog := NewHideValidationDialog;
    end;
*/


    
/*
LOCAL procedure GetHideValidationDialog () : Boolean;
    var
//       IdentityManagement@1000 :
      IdentityManagement: Codeunit 9801;
    begin
      exit(HideValidationDialog or IdentityManagement.IsInvAppId);
    end;
*/


//     LOCAL procedure CheckApplFromItemLedgEntry (var ItemLedgEntry@1000 :
    
/*
LOCAL procedure CheckApplFromItemLedgEntry (var ItemLedgEntry: Record 32)
    var
//       ItemTrackingLines@1003 :
      ItemTrackingLines: Page 6510;
//       QtyNotReturned@1002 :
      QtyNotReturned: Decimal;
//       QtyReturned@1004 :
      QtyReturned: Decimal;
    begin
      if "Appl.-from Item Entry" = 0 then
        exit;

      if "Shipment No." <> '' then
        exit;

      TESTFIELD(Type,Type::Item);
      TESTFIELD(Quantity);
      if IsCreditDocType then begin
        if Quantity < 0 then
          FIELDERROR(Quantity,Text029);
      end else begin
        if Quantity > 0 then
          FIELDERROR(Quantity,Text030);
      end;

      ItemLedgEntry.GET("Appl.-from Item Entry");
      ItemLedgEntry.TESTFIELD(Positive,FALSE);
      ItemLedgEntry.TESTFIELD("Item No.","No.");
      ItemLedgEntry.TESTFIELD("Variant Code","Variant Code");
      if ItemLedgEntry.TrackingExists then
        ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-from Item Entry"));

      if ABS("Quantity (Base)") > -ItemLedgEntry.Quantity then
        ERROR(
          Text046,
          -ItemLedgEntry.Quantity,ItemLedgEntry.FIELDCAPTION("Document No."),
          ItemLedgEntry."Document No.");

      if IsCreditDocType then
        if ABS("Outstanding Qty. (Base)") > -ItemLedgEntry."Shipped Qty. not Returned" then begin
          QtyNotReturned := ItemLedgEntry."Shipped Qty. not Returned";
          QtyReturned := ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. not Returned";
          if "Qty. per Unit of Measure" <> 0 then begin
            QtyNotReturned :=
              ROUND(ItemLedgEntry."Shipped Qty. not Returned" / "Qty. per Unit of Measure",0.00001);
            QtyReturned :=
              ROUND(
                (ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. not Returned") /
                "Qty. per Unit of Measure",0.00001);
          end;
          ERROR(
            Text039,
            -QtyReturned,ItemLedgEntry.FIELDCAPTION("Document No."),
            ItemLedgEntry."Document No.",-QtyNotReturned);
        end;
    end;
*/


    
    
/*
procedure CalcPrepaymentToDeduct ()
    begin
      if ("Qty. to Invoice" <> 0) and ("Prepmt. Amt. Inv." <> 0) then begin
        GetSalesHeader;
        if ("Prepayment %" = 100) and not IsFinalInvoice then
          "Prepmt Amt to Deduct" := GetLineAmountToHandle("Qty. to Invoice")
        else
          "Prepmt Amt to Deduct" :=
            ROUND(
              ("Prepmt. Amt. Inv." - "Prepmt Amt Deducted") *
              "Qty. to Invoice" / (Quantity - "Quantity Invoiced"),Currency."Amount Rounding Precision")
      end else
        "Prepmt Amt to Deduct" := 0
    end;
*/


    
    
/*
procedure IsFinalInvoice () : Boolean;
    begin
      exit("Qty. to Invoice" = Quantity - "Quantity Invoiced");
    end;
*/


    
//     procedure GetLineAmountToHandle (QtyToHandle@1002 :
    
/*
procedure GetLineAmountToHandle (QtyToHandle: Decimal) : Decimal;
    var
//       LineAmount@1001 :
      LineAmount: Decimal;
//       LineDiscAmount@1000 :
      LineDiscAmount: Decimal;
    begin
      if "Line Discount %" = 100 then
        exit(0);

      GetSalesHeader;

      if "Prepmt Amt to Deduct" = 0 then
        LineAmount := ROUND(QtyToHandle * "Unit Price",Currency."Amount Rounding Precision")
      else begin
        LineAmount := ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision");
        LineAmount := ROUND(QtyToHandle * LineAmount / Quantity,Currency."Amount Rounding Precision");
      end;

      if QtyToHandle <> Quantity then
        LineDiscAmount := ROUND(LineAmount * "Line Discount %" / 100,Currency."Amount Rounding Precision")
      else
        LineDiscAmount := "Line Discount Amount";

      OnAfterGetLineAmountToHandle(Rec,QtyToHandle,LineAmount,LineDiscAmount);
      exit(LineAmount - LineDiscAmount);
    end;
*/


    
//     procedure GetLineAmountToHandleInclPrepmt (QtyToHandle@1002 :
    
/*
procedure GetLineAmountToHandleInclPrepmt (QtyToHandle: Decimal) : Decimal;
    begin
      if "Line Discount %" = 100 then
        exit(0);
      if ("Prepayment %" = 100) and not "Prepayment Line" and ("Prepmt Amt to Deduct" <> 0) then
        exit("Prepmt Amt to Deduct");
      exit(GetLineAmountToHandle(QtyToHandle));
    end;
*/


    
    
/*
procedure GetLineAmountExclVAT () : Decimal;
    begin
      if "Document No." = '' then
        exit(0);
      GetSalesHeader;
      if not SalesHeader."Prices Including VAT" then
        exit("Line Amount");

      exit(ROUND("Line Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision"));
    end;
*/


    
    
/*
procedure GetLineAmountInclVAT () : Decimal;
    begin
      if "Document No." = '' then
        exit(0);
      GetSalesHeader;
      if SalesHeader."Prices Including VAT" then
        exit("Line Amount");

      exit(ROUND("Line Amount" * (1 + "VAT %" / 100),Currency."Amount Rounding Precision"));
    end;
*/


    
    
/*
procedure SetHasBeenShown ()
    begin
      HasBeenShown := TRUE;
    end;
*/


    
/*
LOCAL procedure TestJobPlanningLine ()
    var
//       JobPostLine@1000 :
      JobPostLine: Codeunit 1001;
    begin
      if "Job Contract Entry No." = 0 then
        exit;

      JobPostLine.TestSalesLine(Rec);
    end;
*/


    
//     procedure BlockDynamicTracking (SetBlock@1000 :
    
/*
procedure BlockDynamicTracking (SetBlock: Boolean)
    begin
      ReserveSalesLine.Block(SetBlock);
    end;
*/


    
    
/*
procedure InitQtyToShip2 ()
    begin
      "Qty. to Ship" := "Outstanding Quantity";
      "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";

      ATOLink.UpdateQtyToAsmFromSalesLine(Rec);

      CheckServItemCreation;

      "Qty. to Invoice" := MaxQtyToInvoice;
      "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
      "VAT Difference" := 0;

      CalcInvDiscToInvoice;

      CalcPrepaymentToDeduct;
    end;
*/


    
    
/*
procedure ShowLineComments ()
    var
//       SalesCommentLine@1000 :
      SalesCommentLine: Record 44;
//       SalesCommentSheet@1001 :
      SalesCommentSheet: Page 67;
    begin
      TESTFIELD("Document No.");
      TESTFIELD("Line No.");
      SalesCommentLine.SETRANGE("Document Type","Document Type");
      SalesCommentLine.SETRANGE("No.","Document No.");
      SalesCommentLine.SETRANGE("Document Line No.","Line No.");
      SalesCommentSheet.SETTABLEVIEW(SalesCommentLine);
      SalesCommentSheet.RUNMODAL;
    end;
*/


    
    
/*
procedure SetDefaultQuantity ()
    begin
      GetSalesSetup;
      if SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Blank then begin
        if ("Document Type" = "Document Type"::Order) or ("Document Type" = "Document Type"::Quote) then begin
          "Qty. to Ship" := 0;
          "Qty. to Ship (Base)" := 0;
          "Qty. to Invoice" := 0;
          "Qty. to Invoice (Base)" := 0;
        end;
        if "Document Type" = "Document Type"::"Return Order" then begin
          "Return Qty. to Receive" := 0;
          "Return Qty. to Receive (Base)" := 0;
          "Qty. to Invoice" := 0;
          "Qty. to Invoice (Base)" := 0;
        end;
      end;

      OnAfterSetDefaultQuantity(Rec,xRec);
    end;
*/


    
/*
LOCAL procedure SetReserveWithoutPurchasingCode ()
    var
//       Item@1000 :
      Item: Record 27;
    begin
      GetItem(Item);
      if Item.Reserve = Item.Reserve::Optional then begin
        GetSalesHeader;
        Reserve := SalesHeader.Reserve;
      end else
        Reserve := Item.Reserve;
    end;
*/


    
/*
LOCAL procedure SetDefaultItemQuantity ()
    begin
      GetSalesSetup;
      if SalesSetup."Default Item Quantity" then begin
        VALIDATE(Quantity,1);
        CheckItemAvailable(CurrFieldNo);
      end;
    end;
*/


    
    
/*
procedure UpdatePrePaymentAmounts ()
    var
//       ShipmentLine@1000 :
      ShipmentLine: Record 111;
//       SalesOrderLine@1001 :
      SalesOrderLine: Record 37;
//       SalesOrderHeader@1002 :
      SalesOrderHeader: Record 36;
    begin
      if ("Document Type" <> "Document Type"::Invoice) or ("Prepayment %" = 0) then
        exit;

      if not ShipmentLine.GET("Shipment No.","Shipment Line No.") then begin
        "Prepmt Amt to Deduct" := 0;
        "Prepmt VAT Diff. to Deduct" := 0;
      end else
        if SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,ShipmentLine."Order No.",ShipmentLine."Order Line No.") then begin
          if ("Prepayment %" = 100) and (Quantity <> SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced") then
            "Prepmt Amt to Deduct" := "Line Amount"
          else
            "Prepmt Amt to Deduct" :=
              ROUND((SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted") *
                Quantity / (SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced"),Currency."Amount Rounding Precision");
          "Prepmt VAT Diff. to Deduct" := "Prepayment VAT Difference" - "Prepmt VAT Diff. Deducted";
          SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order,SalesOrderLine."Document No.");
        end else begin
          "Prepmt Amt to Deduct" := 0;
          "Prepmt VAT Diff. to Deduct" := 0;
        end;

      GetSalesHeader;
      SalesHeader.TESTFIELD("Prices Including VAT",SalesOrderHeader."Prices Including VAT");
      if SalesHeader."Prices Including VAT" then begin
        "Prepmt. Amt. Incl. VAT" := "Prepmt Amt to Deduct";
        "Prepayment Amount" :=
          ROUND(
            "Prepmt Amt to Deduct" / (1 + ("Prepayment VAT %" / 100)),
            Currency."Amount Rounding Precision");
      end else begin
        "Prepmt. Amt. Incl. VAT" :=
          ROUND(
            "Prepmt Amt to Deduct" * (1 + ("Prepayment VAT %" / 100)),
            Currency."Amount Rounding Precision");
        "Prepayment Amount" := "Prepmt Amt to Deduct";
      end;
      "Prepmt. Line Amount" := "Prepmt Amt to Deduct";
      "Prepmt. Amt. Inv." := "Prepmt. Line Amount";
      "Prepmt. VAT Base Amt." := "Prepayment Amount";
      "Prepmt. Amount Inv. Incl. VAT" := "Prepmt. Amt. Incl. VAT";
      "Prepmt Amt Deducted" := 0;
    end;
*/


    
//     procedure ZeroAmountLine (QtyType@1000 :
    
/*
procedure ZeroAmountLine (QtyType: Option "General","Invoicing","Shippin") : Boolean;
    begin
      if not HasTypeToFillMandatoryFields then
        exit(TRUE);
      if Quantity = 0 then
        exit(TRUE);
      if "Unit Price" = 0 then
        exit(TRUE);
      if QtyType = QtyType::Invoicing then
        if "Qty. to Invoice" = 0 then
          exit(TRUE);
      exit(FALSE);
    end;
*/


    
//     procedure FilterLinesWithItemToPlan (var Item@1000 : Record 27;DocumentType@1001 :
    
/*
procedure FilterLinesWithItemToPlan (var Item: Record 27;DocumentType: Option)
    begin
      RESET;
      SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date");
      SETRANGE("Document Type",DocumentType);
      SETRANGE(Type,Type::Item);
      SETRANGE("No.",Item."No.");
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Drop Shipment",Item.GETFILTER("Drop Shipment Filter"));
      SETFILTER("Shortcut Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
      SETFILTER("Shortcut Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
      SETFILTER("Shipment Date",Item.GETFILTER("Date Filter"));
      SETFILTER("Outstanding Qty. (Base)",'<>0');

      OnAfterFilterLinesWithItemToPlan(Rec,Item);
    end;
*/


    
//     procedure FindLinesWithItemToPlan (var Item@1000 : Record 27;DocumentType@1001 :
    
/*
procedure FindLinesWithItemToPlan (var Item: Record 27;DocumentType: Option) : Boolean;
    begin
      FilterLinesWithItemToPlan(Item,DocumentType);
      exit(FIND('-'));
    end;
*/


    
//     procedure LinesWithItemToPlanExist (var Item@1000 : Record 27;DocumentType@1001 :
    
/*
procedure LinesWithItemToPlanExist (var Item: Record 27;DocumentType: Option) : Boolean;
    begin
      FilterLinesWithItemToPlan(Item,DocumentType);
      exit(not ISEMPTY);
    end;
*/


//     LOCAL procedure DateFormularZero (var DateFormularValue@1001 : DateFormula;CalledByFieldNo@1002 : Integer;CalledByFieldCaption@1003 :
    
/*
LOCAL procedure DateFormularZero (var DateFormularValue: DateFormula;CalledByFieldNo: Integer;CalledByFieldCaption: Text[250])
    var
//       DateFormularZero@1000 :
      DateFormularZero: DateFormula;
    begin
      EVALUATE(DateFormularZero,'<0D>');
      if (DateFormularValue <> DateFormularZero) and (CalledByFieldNo = CurrFieldNo) then
        ERROR(Text051,CalledByFieldCaption,FIELDCAPTION("Drop Shipment"));
      EVALUATE(DateFormularValue,'<0D>');
    end;
*/


    
/*
LOCAL procedure InitQtyToAsm ()
    begin
      if not IsAsmToOrderAllowed then begin
        "Qty. to Assemble to Order" := 0;
        "Qty. to Asm. to Order (Base)" := 0;
        exit;
      end;

      if ((xRec."Qty. to Asm. to Order (Base)" = 0) and IsAsmToOrderRequired and ("Qty. Shipped (Base)" = 0)) or
         ((xRec."Qty. to Asm. to Order (Base)" <> 0) and
          (xRec."Qty. to Asm. to Order (Base)" = xRec."Quantity (Base)")) or
         ("Qty. to Asm. to Order (Base)" > "Quantity (Base)")
      then begin
        "Qty. to Assemble to Order" := Quantity;
        "Qty. to Asm. to Order (Base)" := "Quantity (Base)";
      end;
    end;
*/


    
//     procedure AsmToOrderExists (var AsmHeader@1000 :
    
/*
procedure AsmToOrderExists (var AsmHeader: Record 900) : Boolean;
    var
//       ATOLink@1001 :
      ATOLink: Record 904;
    begin
      if not ATOLink.AsmExistsForSalesLine(Rec) then
        exit(FALSE);
      exit(AsmHeader.GET(ATOLink."Assembly Document Type",ATOLink."Assembly Document No."));
    end;
*/


    
    
/*
procedure FullQtyIsForAsmToOrder () : Boolean;
    begin
      if "Qty. to Asm. to Order (Base)" = 0 then
        exit(FALSE);
      exit("Quantity (Base)" = "Qty. to Asm. to Order (Base)");
    end;
*/


    
/*
LOCAL procedure FullReservedQtyIsForAsmToOrder () : Boolean;
    begin
      if "Qty. to Asm. to Order (Base)" = 0 then
        exit(FALSE);
      CALCFIELDS("Reserved Qty. (Base)");
      exit("Reserved Qty. (Base)" = "Qty. to Asm. to Order (Base)");
    end;
*/


    
    
/*
procedure QtyBaseOnATO () : Decimal;
    var
//       AsmHeader@1000 :
      AsmHeader: Record 900;
    begin
      if AsmToOrderExists(AsmHeader) then
        exit(AsmHeader."Quantity (Base)");
      exit(0);
    end;
*/


    
    
/*
procedure QtyAsmRemainingBaseOnATO () : Decimal;
    var
//       AsmHeader@1000 :
      AsmHeader: Record 900;
    begin
      if AsmToOrderExists(AsmHeader) then
        exit(AsmHeader."Remaining Quantity (Base)");
      exit(0);
    end;
*/


    
    
/*
procedure QtyToAsmBaseOnATO () : Decimal;
    var
//       AsmHeader@1000 :
      AsmHeader: Record 900;
    begin
      if AsmToOrderExists(AsmHeader) then
        exit(AsmHeader."Quantity to Assemble (Base)");
      exit(0);
    end;
*/


    
    
/*
procedure IsAsmToOrderAllowed () : Boolean;
    begin
      if not ("Document Type" IN ["Document Type"::Quote,"Document Type"::"Blanket Order","Document Type"::Order]) then
        exit(FALSE);
      if Quantity < 0 then
        exit(FALSE);
      if Type <> Type::Item then
        exit(FALSE);
      if "No." = '' then
        exit(FALSE);
      if "Drop Shipment" or "Special Order" then
        exit(FALSE);
      exit(TRUE)
    end;
*/


    
    
/*
procedure IsAsmToOrderRequired () : Boolean;
    var
//       Item@1000 :
      Item: Record 27;
    begin
      if (Type <> Type::Item) or ("No." = '') then
        exit(FALSE);
      GetItem(Item);
      if GetSKU then
        exit(SKU."Assembly Policy" = SKU."Assembly Policy"::"Assemble-to-Order");
      exit(Item."Assembly Policy" = Item."Assembly Policy"::"Assemble-to-Order");
    end;
*/


    
//     procedure CheckAsmToOrder (AsmHeader@1001 :
    
/*
procedure CheckAsmToOrder (AsmHeader: Record 900)
    begin
      TESTFIELD("Qty. to Assemble to Order",AsmHeader.Quantity);
      TESTFIELD("Document Type",AsmHeader."Document Type");
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.",AsmHeader."Item No.");
      TESTFIELD("Location Code",AsmHeader."Location Code");
      TESTFIELD("Unit of Measure Code",AsmHeader."Unit of Measure Code");
      TESTFIELD("Variant Code",AsmHeader."Variant Code");
      TESTFIELD("Shipment Date",AsmHeader."Due Date");
      if "Document Type" = "Document Type"::Order then begin
        AsmHeader.CALCFIELDS("Reserved Qty. (Base)");
        AsmHeader.TESTFIELD("Reserved Qty. (Base)",AsmHeader."Remaining Quantity (Base)");
      end;
      TESTFIELD("Qty. to Asm. to Order (Base)",AsmHeader."Quantity (Base)");
      if "Outstanding Qty. (Base)" < AsmHeader."Remaining Quantity (Base)" then
        AsmHeader.FIELDERROR("Remaining Quantity (Base)",STRSUBSTNO(Text045,AsmHeader."Remaining Quantity (Base)"));
    end;
*/


    
    
/*
procedure ShowAsmToOrderLines ()
    var
//       ATOLink@1000 :
      ATOLink: Record 904;
    begin
      ATOLink.ShowAsmToOrderLines(Rec);
    end;
*/


    
//     procedure FindOpenATOEntry (LotNo@1003 : Code[50];SerialNo@1004 :
    
/*
procedure FindOpenATOEntry (LotNo: Code[50];SerialNo: Code[50]) : Integer;
    var
//       PostedATOLink@1002 :
      PostedATOLink: Record 914;
//       ItemLedgEntry@1001 :
      ItemLedgEntry: Record 32;
    begin
      TESTFIELD("Document Type","Document Type"::Order);
      if PostedATOLink.FindLinksFromSalesLine(Rec) then
        repeat
          ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Posted Assembly");
          ItemLedgEntry.SETRANGE("Document No.",PostedATOLink."Assembly Document No.");
          ItemLedgEntry.SETRANGE("Document Line No.",0);
          ItemLedgEntry.SetTrackingFilter(SerialNo,LotNo);
          ItemLedgEntry.SETRANGE(Open,TRUE);
          if ItemLedgEntry.FINDFIRST then
            exit(ItemLedgEntry."Entry No.");
        until PostedATOLink.NEXT = 0;
    end;
*/


    
    
/*
procedure RollUpAsmCost ()
    begin
      ATOLink.RollUpCost(Rec);
    end;
*/


    
    
/*
procedure RollupAsmPrice ()
    begin
      GetSalesHeader;
      ATOLink.RollUpPrice(SalesHeader,Rec);
    end;
*/


    
/*
LOCAL procedure UpdateICPartner ()
    var
//       ICPartner@1000 :
      ICPartner: Record 413;
//       ItemCrossReference@1001 :
      ItemCrossReference: Record 5717;
    begin
      if SalesHeader."Send IC Document" and
         (SalesHeader."IC Direction" = SalesHeader."IC Direction"::Outgoing) and
         (SalesHeader."Bill-to IC Partner Code" <> '')
      then
        CASE Type OF
          Type::" ",Type::"Charge (Item)":
            begin
              "IC Partner Ref. Type" := Type;
              "IC Partner Reference" := "No.";
            end;
          Type::"G/L Account":
            begin
              "IC Partner Ref. Type" := Type;
              "IC Partner Reference" := GLAcc."Default IC Partner G/L Acc. No";
            end;
          Type::Item:
            begin
              if SalesHeader."Sell-to IC Partner Code" <> '' then
                ICPartner.GET(SalesHeader."Sell-to IC Partner Code")
              else
                ICPartner.GET(SalesHeader."Bill-to IC Partner Code");
              CASE ICPartner."Outbound Sales Item No. Type" OF
                ICPartner."Outbound Sales Item No. Type"::"Common Item No.":
                  VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Common Item No.");
                ICPartner."Outbound Sales Item No. Type"::"Internal No.",
                ICPartner."Outbound Sales Item No. Type"::"Cross Reference":
                  begin
                    if ICPartner."Outbound Sales Item No. Type" = ICPartner."Outbound Sales Item No. Type"::"Internal No." then
                      VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::Item)
                    else
                      VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Cross Reference");
                    ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Customer);
                    ItemCrossReference.SETRANGE("Cross-Reference Type No.","Sell-to Customer No.");
                    ItemCrossReference.SETRANGE("Item No.","No.");
                    ItemCrossReference.SETRANGE("Variant Code","Variant Code");
                    ItemCrossReference.SETRANGE("Unit of Measure","Unit of Measure Code");
                    if ItemCrossReference.FINDFIRST then
                      "IC Partner Reference" := ItemCrossReference."Cross-Reference No."
                    else
                      "IC Partner Reference" := "No.";
                  end;
              end;
            end;
          Type::"Fixed Asset":
            begin
              "IC Partner Ref. Type" := "IC Partner Ref. Type"::" ";
              "IC Partner Reference" := '';
            end;
          Type::Resource:
            begin
              Resource.GET("No.");
              "IC Partner Ref. Type" := "IC Partner Ref. Type"::"G/L Account";
              "IC Partner Reference" := Resource."IC Partner Purch. G/L Acc. No.";
            end;
        end;
    end;
*/


    
//     procedure OutstandingInvoiceAmountFromShipment (SellToCustomerNo@1000 :
    
/*
procedure OutstandingInvoiceAmountFromShipment (SellToCustomerNo: Code[20]) : Decimal;
    var
//       SalesLine@1001 :
      SalesLine: Record 37;
    begin
      SalesLine.SETCURRENTKEY("Document Type","Sell-to Customer No.","Shipment No.");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Invoice);
      SalesLine.SETRANGE("Sell-to Customer No.",SellToCustomerNo);
      SalesLine.SETFILTER("Shipment No.",'<>%1','');
      SalesLine.CALCSUMS("Outstanding Amount (LCY)");
      exit(SalesLine."Outstanding Amount (LCY)");
    end;
*/


    
/*
LOCAL procedure CheckShipmentRelation ()
    var
//       SalesShptLine@1001 :
      SalesShptLine: Record 111;
    begin
      SalesShptLine.GET("Shipment No.","Shipment Line No.");
      if (Quantity * SalesShptLine."Qty. Shipped not Invoiced") < 0 then
        FIELDERROR("Qty. to Invoice",Text057);
      if ABS(Quantity) > ABS(SalesShptLine."Qty. Shipped not Invoiced") then
        ERROR(Text058,SalesShptLine."Document No.");
    end;
*/


    
/*
LOCAL procedure CheckRetRcptRelation ()
    var
//       ReturnRcptLine@1000 :
      ReturnRcptLine: Record 6661;
    begin
      ReturnRcptLine.GET("Return Receipt No.","Return Receipt Line No.");
      if (Quantity * (ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced")) < 0 then
        FIELDERROR("Qty. to Invoice",Text059);
      if ABS(Quantity) > ABS(ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced") then
        ERROR(Text060,ReturnRcptLine."Document No.");
    end;
*/


    
/*
LOCAL procedure VerifyItemLineDim ()
    begin
      if IsShippedReceivedItemDimChanged then
        ConfirmShippedReceivedItemDimChange;
    end;
*/


    
    
/*
procedure IsShippedReceivedItemDimChanged () : Boolean;
    begin
      exit(("Dimension Set ID" <> xRec."Dimension Set ID") and (Type = Type::Item) and
        (("Qty. Shipped not Invoiced" <> 0) or ("Return Rcd. not Invd." <> 0)));
    end;
*/


    
/*
LOCAL procedure IsServiceCharge () : Boolean;
    var
//       CustomerPostingGroup@1001 :
      CustomerPostingGroup: Record 92;
    begin
      if Type <> Type::"G/L Account" then
        exit(FALSE);

      GetSalesHeader;
      CustomerPostingGroup.GET(SalesHeader."Customer Posting Group");
      exit(CustomerPostingGroup."Service Charge Acc." = "No.");
    end;
*/


    
    
/*
procedure ConfirmShippedReceivedItemDimChange () : Boolean;
    var
//       ConfirmManagement@1000 :
      ConfirmManagement: Codeunit 27;
    begin
      if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text053,TABLECAPTION),TRUE) then
        ERROR(Text054);

      exit(TRUE);
    end;
*/


    
    
/*
procedure InitType ()
    begin
      if "Document No." <> '' then begin
        if not SalesHeader.GET("Document Type","Document No.") then
          exit;
        if (SalesHeader.Status = SalesHeader.Status::Released) and
           (xRec.Type IN [xRec.Type::Item,xRec.Type::"Fixed Asset"])
        then
          Type := Type::" "
        else
          Type := xRec.Type;
      end;
    end;
*/


    
/*
LOCAL procedure CheckWMS ()
    begin
      if CurrFieldNo <> 0 then
        CheckLocationOnWMS;
    end;
*/


    
    
/*
procedure CheckLocationOnWMS ()
    var
//       DialogText@1001 :
      DialogText: Text;
    begin
      if Type = Type::Item then begin
        DialogText := Text035;
        if "Quantity (Base)" <> 0 then
          CASE "Document Type" OF
            "Document Type"::Invoice:
              if "Shipment No." = '' then
                if Location.GET("Location Code") and Location."Directed Put-away and Pick" then begin
                  DialogText += Location.GetRequirementText(Location.FIELDNO("Require Shipment"));
                  ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                end;
            "Document Type"::"Credit Memo":
              if "Return Receipt No." = '' then
                if Location.GET("Location Code") and Location."Directed Put-away and Pick" then begin
                  DialogText += Location.GetRequirementText(Location.FIELDNO("Require Receive"));
                  ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                end;
          end;
      end;
    end;
*/


    
    
/*
procedure IsNonInventoriableItem () : Boolean;
    var
//       Item@1000 :
      Item: Record 27;
    begin
      if Type <> Type::Item then
        exit(FALSE);
      if "No." = '' then
        exit(FALSE);
      GetItem(Item);
      exit(Item.IsNonInventoriableType);
    end;
*/


    
    
/*
procedure IsInventoriableItem () : Boolean;
    var
//       Item@1000 :
      Item: Record 27;
    begin
      if Type <> Type::Item then
        exit(FALSE);
      if "No." = '' then
        exit(FALSE);
      GetItem(Item);
      exit(Item.IsInventoriableType);
    end;
*/


//     LOCAL procedure ValidateReturnReasonCode (CallingFieldNo@1000 :
    
/*
LOCAL procedure ValidateReturnReasonCode (CallingFieldNo: Integer)
    var
//       ReturnReason@1001 :
      ReturnReason: Record 6635;
    begin
      if CallingFieldNo = 0 then
        exit;
      if "Return Reason Code" = '' then begin
        if (Type = Type::Item) and ("No." <> '') then
          GetUnitCost;
        UpdateUnitPrice(CallingFieldNo);
      end;

      if ReturnReason.GET("Return Reason Code") then begin
        if (CallingFieldNo <> FIELDNO("Location Code")) and (ReturnReason."Default Location Code" <> '') then
          VALIDATE("Location Code",ReturnReason."Default Location Code");
        if ReturnReason."Inventory Value Zero" then
          VALIDATE("Unit Cost (LCY)",0)
        else
          if "Unit Price" = 0 then
            UpdateUnitPrice(CallingFieldNo);
      end;

      OnAfterValidateReturnReasonCode(Rec,CallingFieldNo);
    end;
*/


    
//     procedure ValidateLineDiscountPercent (DropInvoiceDiscountAmount@1000 :
    
/*
procedure ValidateLineDiscountPercent (DropInvoiceDiscountAmount: Boolean)
    begin
      TestJobPlanningLine;
      TestStatusOpen;
      "Line Discount Amount" :=
        ROUND(
          ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") *
          "Line Discount %" / 100,Currency."Amount Rounding Precision");
      if DropInvoiceDiscountAmount then begin
        "Inv. Discount Amount" := 0;
        "Inv. Disc. Amount to Invoice" := 0;
        "Pmt. Discount Amount" := 0;
      end;
      UpdateAmounts;
    end;
*/


    
    
/*
procedure HasTypeToFillMandatoryFields () : Boolean;
    begin
      exit(Type <> Type::" ");
    end;
*/


    
    
/*
procedure GetDeferralAmount () DeferralAmount : Decimal;
    begin
      if "VAT Base Amount" <> 0 then
        DeferralAmount := "VAT Base Amount"
      else
        DeferralAmount := CalcLineAmount;
    end;
*/


    
/*
LOCAL procedure UpdateDeferralAmounts ()
    var
//       AdjustStartDate@1000 :
      AdjustStartDate: Boolean;
//       DeferralPostDate@1001 :
      DeferralPostDate: Date;
    begin
      GetSalesHeader;
      OnGetDeferralPostDate(SalesHeader,DeferralPostDate,Rec);
      if DeferralPostDate = 0D then
        DeferralPostDate := SalesHeader."Posting Date";
      AdjustStartDate := TRUE;
      if "Document Type" = "Document Type"::"Return Order" then begin
        if "Returns Deferral Start Date" = 0D then
          "Returns Deferral Start Date" := SalesHeader."Posting Date";
        DeferralPostDate := "Returns Deferral Start Date";
        AdjustStartDate := FALSE;
      end;

      DeferralUtilities.RemoveOrSetDeferralSchedule(
        "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
        "Document Type","Document No.","Line No.",
        GetDeferralAmount,DeferralPostDate,Description,SalesHeader."Currency Code",AdjustStartDate);
    end;
*/


    
    
/*
procedure UpdatePriceDescription ()
    var
//       Currency@1000 :
      Currency: Record 4;
    begin
      "Price description" := '';
      if Type IN [Type::"Charge (Item)",Type::"Fixed Asset",Type::Item,Type::Resource] then begin
        if "Line Discount %" = 0 then
          "Price description" := STRSUBSTNO(
              PriceDescriptionTxt,Quantity,Currency.ResolveGLCurrencySymbol("Currency Code"),
              "Unit Price","Unit of Measure")
        else
          "Price description" := STRSUBSTNO(
              PriceDescriptionWithLineDiscountTxt,Quantity,Currency.ResolveGLCurrencySymbol("Currency Code"),
              "Unit Price","Unit of Measure","Line Discount %")
      end;
    end;
*/


//     procedure ShowDeferrals (PostingDate@1000 : Date;CurrencyCode@1001 :
    
/*
procedure ShowDeferrals (PostingDate: Date;CurrencyCode: Code[10]) : Boolean;
    begin
      exit(DeferralUtilities.OpenLineScheduleEdit(
          "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
          "Document Type","Document No.","Line No.",
          GetDeferralAmount,PostingDate,Description,CurrencyCode));
    end;
*/


//     LOCAL procedure InitHeaderDefaults (SalesHeader@1000 :
    
/*
LOCAL procedure InitHeaderDefaults (SalesHeader: Record 36)
    begin
      if SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then begin
        if (SalesHeader."Sell-to Customer No." = '') and
           (SalesHeader."Sell-to Customer Template Code" = '')
        then
          ERROR(
            Text031,
            SalesHeader.FIELDCAPTION("Sell-to Customer No."),
            SalesHeader.FIELDCAPTION("Sell-to Customer Template Code"));
        if (SalesHeader."Bill-to Customer No." = '') and
           (SalesHeader."Bill-to Customer Template Code" = '')
        then
          ERROR(
            Text031,
            SalesHeader.FIELDCAPTION("Bill-to Customer No."),
            SalesHeader.FIELDCAPTION("Bill-to Customer Template Code"));
      end else
        SalesHeader.TESTFIELD("Sell-to Customer No.");

      "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
      "Currency Code" := SalesHeader."Currency Code";
      if not IsNonInventoriableItem then
        "Location Code" := SalesHeader."Location Code";
      "Customer Price Group" := SalesHeader."Customer Price Group";
      "Customer Disc. Group" := SalesHeader."Customer Disc. Group";
      "Allow Line Disc." := SalesHeader."Allow Line Disc.";
      "Transaction Type" := SalesHeader."Transaction Type";
      "Transport Method" := SalesHeader."Transport Method";
      "Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
      "Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
      "VAT Bus. Posting Group" := SalesHeader."VAT Bus. Posting Group";
      "exit Point" := SalesHeader."exit Point";
      Area := SalesHeader.Area;
      "Transaction Specification" := SalesHeader."Transaction Specification";
      "Tax Area Code" := SalesHeader."Tax Area Code";
      "Tax Liable" := SalesHeader."Tax Liable";
      if not "System-Created Entry" and ("Document Type" = "Document Type"::Order) and HasTypeToFillMandatoryFields or
         IsServiceCharge
      then
        "Prepayment %" := SalesHeader."Prepayment %";
      "Prepayment Tax Area Code" := SalesHeader."Tax Area Code";
      "Prepayment Tax Liable" := SalesHeader."Tax Liable";
      "Responsibility Center" := SalesHeader."Responsibility Center";

      "Shipping Agent Code" := SalesHeader."Shipping Agent Code";
      "Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
      "Outbound Whse. Handling Time" := SalesHeader."Outbound Whse. Handling Time";
      "Shipping Time" := SalesHeader."Shipping Time";

      OnAfterInitHeaderDefaults(Rec,SalesHeader);
    end;
*/


    
/*
LOCAL procedure InitDeferralCode ()
    var
//       Item@1000 :
      Item: Record 27;
    begin
      if "Document Type" IN
         ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Credit Memo","Document Type"::"Return Order"]
      then
        CASE Type OF
          Type::"G/L Account":
            VALIDATE("Deferral Code",GLAcc."Default Deferral Template Code");
          Type::Item:
            begin
              GetItem(Item);
              VALIDATE("Deferral Code",Item."Default Deferral Template Code");
            end;
          Type::Resource:
            VALIDATE("Deferral Code",Res."Default Deferral Template Code");
        end;
    end;
*/


    
    
/*
procedure DefaultDeferralCode ()
    var
//       Item@1000 :
      Item: Record 27;
    begin
      CASE Type OF
        Type::"G/L Account":
          begin
            GLAcc.GET("No.");
            InitDeferralCode;
          end;
        Type::Item:
          begin
            GetItem(Item);
            InitDeferralCode;
          end;
        Type::Resource:
          begin
            Res.GET("No.");
            InitDeferralCode;
          end;
      end;
    end;
*/


    
    
/*
procedure IsCreditDocType () : Boolean;
    begin
      exit("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
    end;
*/


    
/*
LOCAL procedure IsFullyInvoiced () : Boolean;
    begin
      exit(("Qty. Shipped not Invd. (Base)" = 0) and ("Qty. Shipped (Base)" = "Quantity (Base)"))
    end;
*/


    
/*
LOCAL procedure CleanDropShipmentFields ()
    begin
      if ("Purch. Order Line No." <> 0) and IsFullyInvoiced then
        if CleanPurchaseLineDropShipmentFields then begin
          "Purchase Order No." := '';
          "Purch. Order Line No." := 0;
        end;
    end;
*/


    
/*
LOCAL procedure CleanSpecialOrderFieldsAndCheckAssocPurchOrder ()
    begin
      if ("Special Order Purch. Line No." <> 0) and IsFullyInvoiced then
        if CleanPurchaseLineSpecialOrderFields then begin
          "Special Order Purchase No." := '';
          "Special Order Purch. Line No." := 0;
        end;
      CheckAssocPurchOrder('');
    end;
*/


    
/*
LOCAL procedure CleanPurchaseLineDropShipmentFields () : Boolean;
    var
//       PurchaseLine@1000 :
      PurchaseLine: Record 39;
    begin
      if PurchaseLine.GET(PurchaseLine."Document Type"::Order,"Purchase Order No.","Purch. Order Line No.") then begin
        if PurchaseLine."Qty. Received (Base)" < "Qty. Shipped (Base)" then
          exit(FALSE);

        PurchaseLine."Sales Order No." := '';
        PurchaseLine."Sales Order Line No." := 0;
        PurchaseLine.MODIFY;
      end;

      exit(TRUE);
    end;
*/


    
/*
LOCAL procedure CleanPurchaseLineSpecialOrderFields () : Boolean;
    var
//       PurchaseLine@1000 :
      PurchaseLine: Record 39;
    begin
      if PurchaseLine.GET(PurchaseLine."Document Type"::Order,"Special Order Purchase No.","Special Order Purch. Line No.") then begin
        if PurchaseLine."Qty. Received (Base)" < "Qty. Shipped (Base)" then
          exit(FALSE);

        PurchaseLine."Special Order" := FALSE;
        PurchaseLine."Special Order Sales No." := '';
        PurchaseLine."Special Order Sales Line No." := 0;
        PurchaseLine.MODIFY;
      end;

      exit(TRUE);
    end;
*/


    
    
/*
procedure CanEditUnitOfMeasureCode () : Boolean;
    var
//       ItemUnitOfMeasure@1000 :
      ItemUnitOfMeasure: Record 5404;
    begin
      if (Type = Type::Item) and ("No." <> '') then begin
        ItemUnitOfMeasure.SETRANGE("Item No.","No.");
        exit(ItemUnitOfMeasure.COUNT > 1);
      end;
      exit(TRUE);
    end;
*/


    
/*
LOCAL procedure ValidateTaxGroupCode ()
    var
//       TaxDetail@1001 :
      TaxDetail: Record 322;
    begin
      if ("Tax Area Code" <> '') and ("Tax Group Code" <> '') then
        TaxDetail.ValidateTaxSetup("Tax Area Code","Tax Group Code","Posting Date");
    end;
*/


    
//     procedure InsertFreightLine (var FreightAmount@1000 :
    
/*
procedure InsertFreightLine (var FreightAmount: Decimal)
    var
//       SalesLine@1001 :
      SalesLine: Record 37;
//       FreightAmountQuantity@1002 :
      FreightAmountQuantity: Integer;
    begin
      if FreightAmount <= 0 then begin
        FreightAmount := 0;
        exit;
      end;

      FreightAmountQuantity := 1;

      SalesSetup.GET;
      SalesSetup.TESTFIELD("Freight G/L Acc. No.");

      TESTFIELD("Document Type");
      TESTFIELD("Document No.");

      SalesLine.SETRANGE("Document Type","Document Type");
      SalesLine.SETRANGE("Document No.","Document No.");
      SalesLine.SETRANGE(Type,SalesLine.Type::"G/L Account");
      SalesLine.SETRANGE("No.",SalesSetup."Freight G/L Acc. No.");
      // "Quantity Shipped" will be equal to 0 until FreightAmount line successfully shipped
      SalesLine.SETRANGE("Quantity Shipped",0);
      if SalesLine.FINDFIRST then begin
        SalesLine.VALIDATE(Quantity,FreightAmountQuantity);
        SalesLine.VALIDATE("Unit Price",FreightAmount);
        SalesLine.MODIFY;
      end else begin
        SalesLine.SETRANGE(Type);
        SalesLine.SETRANGE("No.");
        SalesLine.SETRANGE("Quantity Shipped");
        SalesLine.FINDLAST;
        SalesLine."Line No." += 10000;
        SalesLine.INIT;
        SalesLine.VALIDATE(Type,SalesLine.Type::"G/L Account");
        SalesLine.VALIDATE("No.",SalesSetup."Freight G/L Acc. No.");
        SalesLine.VALIDATE(Description,FreightLineDescriptionTxt);
        SalesLine.VALIDATE(Quantity,FreightAmountQuantity);
        SalesLine.VALIDATE("Unit Price",FreightAmount);
        SalesLine.INSERT;
      end;
    end;
*/


//     LOCAL procedure CalcTotalAmtToAssign (TotalQtyToAssign@1000 :
    
/*
LOCAL procedure CalcTotalAmtToAssign (TotalQtyToAssign: Decimal) TotalAmtToAssign : Decimal;
    begin
      TotalAmtToAssign := CalcLineAmount * TotalQtyToAssign / Quantity;
      if SalesHeader."Prices Including VAT" then
        TotalAmtToAssign := TotalAmtToAssign / (1 + "VAT %" / 100) - "VAT Difference";

      TotalAmtToAssign := ROUND(TotalAmtToAssign,Currency."Amount Rounding Precision");
    end;
*/


    
    
/*
procedure IsLookupRequested () Result : Boolean;
    begin
      Result := LookupRequested;
      LookupRequested := FALSE;
    end;
*/


    
//     procedure TestItemFields (ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 :
    
/*
procedure TestItemFields (ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10])
    begin
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.",ItemNo);
      TESTFIELD("Variant Code",VariantCode);
      TESTFIELD("Location Code",LocationCode);
    end;
*/


    
    
/*
procedure CalculateNotShippedInvExlcVatLCY ()
    var
//       Currency2@1000 :
      Currency2: Record 4;
    begin
      Currency2.InitRoundingPrecision;
      "Shipped not Inv. (LCY) No VAT" :=
        ROUND("Shipped not Invoiced (LCY)" / (1 + "VAT %" / 100),Currency2."Amount Rounding Precision");
    end;
*/


    
    
/*
procedure ClearSalesHeader ()
    begin
      CLEAR(SalesHeader);
    end;
*/


    
    
/*
procedure SendLineInvoiceDiscountResetNotification ()
    var
//       NotificationLifecycleMgt@1003 :
      NotificationLifecycleMgt: Codeunit 1511;
//       NotificationToSend@1000 :
      NotificationToSend: Notification;
    begin
      if ("Inv. Discount Amount" = 0) and (xRec."Inv. Discount Amount" <> 0) and ("Line Amount" <> 0) then begin
        NotificationToSend.ID := SalesHeader.GetLineInvoiceDiscountResetNotificationId;
        NotificationToSend.MESSAGE := STRSUBSTNO(LineInvoiceDiscountAmountResetTok,RECORDID);

        NotificationLifecycleMgt.SendNotification(NotificationToSend,RECORDID);
      end;
    end;
*/


    
    
/*
procedure GetDocumentTypeDescription () : Text;
    var
//       IdentityManagement@1000 :
      IdentityManagement: Codeunit 9801;
    begin
      if IdentityManagement.IsInvAppId and ("Document Type" = "Document Type"::Quote) then
        exit(EstimateLbl);

      exit(FORMAT("Document Type"));
    end;
*/


    
    
/*
procedure FormatType () : Text[20];
    begin
      if Type = Type::" " then
        exit(CommentLbl);

      exit(FORMAT(Type));
    end;
*/


    
//     procedure RenameNo (LineType@1000 : Option;OldNo@1001 : Code[20];NewNo@1002 :
    
/*
procedure RenameNo (LineType: Option;OldNo: Code[20];NewNo: Code[20])
    begin
      RESET;
      SETRANGE(Type,LineType);
      SETRANGE("No.",OldNo);
      MODIFYALL("No.",NewNo,TRUE);
    end;
*/


    
    
/*
procedure UpdatePlanned () : Boolean;
    begin
      TESTFIELD("Qty. per Unit of Measure");
      CALCFIELDS("Reserved Quantity");
      if Planned = ("Reserved Quantity" = "Outstanding Quantity") then
        exit(FALSE);
      Planned := not Planned;
      exit(TRUE);
    end;
*/


    
    
/*
procedure AssignedItemCharge () : Boolean;
    begin
      exit((Type = Type::"Charge (Item)") and ("No." <> '') and ("Qty. to Assign" < Quantity));
    end;
*/


    
/*
LOCAL procedure UpdateLineDiscPct ()
    var
//       LineDiscountPct@1000 :
      LineDiscountPct: Decimal;
    begin
      if ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") <> 0 then begin
        LineDiscountPct := ROUND(
            "Line Discount Amount" / ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") * 100,
            0.00001);
        if not (LineDiscountPct IN [0..100]) then
          ERROR(LineDiscountPctErr);
        "Line Discount %" := LineDiscountPct;
      end else
        "Line Discount %" := 0;
    end;
*/


//     LOCAL procedure UpdateBaseAmounts (NewAmount@1000 : Decimal;NewAmountIncludingVAT@1001 : Decimal;NewVATBaseAmount@1002 :
    
/*
LOCAL procedure UpdateBaseAmounts (NewAmount: Decimal;NewAmountIncludingVAT: Decimal;NewVATBaseAmount: Decimal)
    begin
      Amount := NewAmount;
      "Amount Including VAT" := NewAmountIncludingVAT;
      "VAT Base Amount" := NewVATBaseAmount;
      if not SalesHeader."Prices Including VAT" and (Amount > 0) and (Amount < "Prepmt. Line Amount") then
        "Prepmt. Line Amount" := Amount;
      if SalesHeader."Prices Including VAT" and ("Amount Including VAT" > 0) and ("Amount Including VAT" < "Prepmt. Line Amount") then
        "Prepmt. Line Amount" := "Amount Including VAT";
    end;
*/


    
    
/*
procedure CalcPlannedDate () : Date;
    begin
      if FORMAT("Shipping Time") <> '' then
        exit(CalcPlannedDeliveryDate(FIELDNO("Planned Delivery Date")));

      exit(CalcPlannedShptDate(FIELDNO("Planned Delivery Date")));
    end;
*/


//     LOCAL procedure IsCalcVATAmountLinesHandled (SalesHeader@1001 : Record 36;var SalesLine@1002 : Record 37;var VATAmountLine@1003 :
    
/*
LOCAL procedure IsCalcVATAmountLinesHandled (SalesHeader: Record 36;var SalesLine: Record 37;var VATAmountLine: Record 290) IsHandled : Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeCalcVATAmountLines(SalesHeader,SalesLine,VATAmountLine,IsHandled);
      exit(IsHandled);
    end;
*/


    
//     LOCAL procedure OnAfterAssignFieldsForNo (var SalesLine@1000 : Record 37;var xSalesLine@1001 : Record 37;SalesHeader@1002 :
    
/*
LOCAL procedure OnAfterAssignFieldsForNo (var SalesLine: Record 37;var xSalesLine: Record 37;SalesHeader: Record 36)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAssignHeaderValues (var SalesLine@1000 : Record 37;SalesHeader@1001 :
    
/*
LOCAL procedure OnAfterAssignHeaderValues (var SalesLine: Record 37;SalesHeader: Record 36)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAssignStdTxtValues (var SalesLine@1000 : Record 37;StandardText@1001 :
    
/*
LOCAL procedure OnAfterAssignStdTxtValues (var SalesLine: Record 37;StandardText: Record 7)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAssignGLAccountValues (var SalesLine@1000 : Record 37;GLAccount@1001 :
    
/*
LOCAL procedure OnAfterAssignGLAccountValues (var SalesLine: Record 37;GLAccount: Record 15)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAssignItemValues (var SalesLine@1000 : Record 37;Item@1001 :
    
/*
LOCAL procedure OnAfterAssignItemValues (var SalesLine: Record 37;Item: Record 27)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAssignItemChargeValues (var SalesLine@1000 : Record 37;ItemCharge@1001 :
    
/*
LOCAL procedure OnAfterAssignItemChargeValues (var SalesLine: Record 37;ItemCharge: Record 5800)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAssignResourceValues (var SalesLine@1000 : Record 37;Resource@1001 :
    
/*
LOCAL procedure OnAfterAssignResourceValues (var SalesLine: Record 37;Resource: Record 156)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAssignFixedAssetValues (var SalesLine@1000 : Record 37;FixedAsset@1001 :
    
/*
LOCAL procedure OnAfterAssignFixedAssetValues (var SalesLine: Record 37;FixedAsset: Record 5600)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAssignItemUOM (var SalesLine@1000 : Record 37;Item@1001 :
    
/*
LOCAL procedure OnAfterAssignItemUOM (var SalesLine: Record 37;Item: Record 27)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAssignResourceUOM (var SalesLine@1001 : Record 37;Resource@1000 : Record 156;ResourceUOM@1002 :
    
/*
LOCAL procedure OnAfterAssignResourceUOM (var SalesLine: Record 37;Resource: Record 156;ResourceUOM: Record 205)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAutoReserve (var SalesLine@1000 :
    
/*
LOCAL procedure OnAfterAutoReserve (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromItem (var SalesLine@1000 : Record 37;Item@1001 :
    
/*
LOCAL procedure OnAfterCopyFromItem (var SalesLine: Record 37;Item: Record 27)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterFindResUnitCost (var SalesLine@1000 : Record 37;var ResourceCost@1001 :
    
/*
LOCAL procedure OnAfterFindResUnitCost (var SalesLine: Record 37;var ResourceCost: Record 202)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterFilterLinesWithItemToPlan (var SalesLine@1000 : Record 37;var Item@1001 :
    
/*
LOCAL procedure OnAfterFilterLinesWithItemToPlan (var SalesLine: Record 37;var Item: Record 27)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterGetUnitCost (var SalesLine@1000 : Record 37;Item@1001 :
    
/*
LOCAL procedure OnAfterGetUnitCost (var SalesLine: Record 37;Item: Record 27)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateUnitPrice (var SalesLine@1000 : Record 37;xSalesLine@1001 : Record 37;CalledByFieldNo@1002 : Integer;CurrFieldNo@1003 :
    
/*
LOCAL procedure OnAfterUpdateUnitPrice (var SalesLine: Record 37;xSalesLine: Record 37;CalledByFieldNo: Integer;CurrFieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCalcInvDiscToInvoice (var SalesLine@1000 :
    
/*
LOCAL procedure OnBeforeCalcInvDiscToInvoice (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCalcVATAmountLines (SalesHeader@1002 : Record 36;var SalesLine@1001 : Record 37;var VATAmountLine@1000 : Record 290;var IsHandled@1003 :
    
/*
LOCAL procedure OnBeforeCalcVATAmountLines (SalesHeader: Record 36;var SalesLine: Record 37;var VATAmountLine: Record 290;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCheckAssocPurchOrder (SalesLine@1000 : Record 37;FieldCaption@1001 : Text[250];var IsHandled@1002 :
    
/*
LOCAL procedure OnBeforeCheckAssocPurchOrder (SalesLine: Record 37;FieldCaption: Text[250];var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCheckItemAvailable (SalesLine@1000 : Record 37;CalledByFieldNo@1001 : Integer;var IsHandled@1002 :
    
/*
LOCAL procedure OnBeforeCheckItemAvailable (SalesLine: Record 37;CalledByFieldNo: Integer;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCopyFromItem (var SalesLine@1000 : Record 37;Item@1001 :
    
/*
LOCAL procedure OnBeforeCopyFromItem (var SalesLine: Record 37;Item: Record 27)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCrossReferenceNoAssign (var SalesLine@1000 : Record 37;ItemCrossReference@1001 :
    
/*
LOCAL procedure OnBeforeCrossReferenceNoAssign (var SalesLine: Record 37;ItemCrossReference: Record 5717)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeGetDefaultBin (var SalesLine@1000 : Record 37;var IsHandled@1001 :
    
/*
LOCAL procedure OnBeforeGetDefaultBin (var SalesLine: Record 37;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeTestStatusOpen (var SalesLine@1000 : Record 37;var SalesHeader@1001 :
    
/*
LOCAL procedure OnBeforeTestStatusOpen (var SalesLine: Record 37;var SalesHeader: Record 36)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeUpdateUnitPrice (var SalesLine@1003 : Record 37;xSalesLine@1002 : Record 37;CalledByFieldNo@1001 : Integer;CurrFieldNo@1000 : Integer;var Handled@1004 :
    
/*
LOCAL procedure OnBeforeUpdateUnitPrice (var SalesLine: Record 37;xSalesLine: Record 37;CalledByFieldNo: Integer;CurrFieldNo: Integer;var Handled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeUpdateVATAmounts (var SalesLine@1000 :
    
/*
LOCAL procedure OnBeforeUpdateVATAmounts (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeVerifyReservedQty (var SalesLine@1000 : Record 37;xSalesLine@1001 : Record 37;CalledByFieldNo@1002 :
    
/*
LOCAL procedure OnBeforeVerifyReservedQty (var SalesLine: Record 37;xSalesLine: Record 37;CalledByFieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInitHeaderDefaults (var SalesLine@1000 : Record 37;SalesHeader@1001 :
    
/*
LOCAL procedure OnAfterInitHeaderDefaults (var SalesLine: Record 37;SalesHeader: Record 36)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInitOutstanding (var SalesLine@1000 :
    
/*
LOCAL procedure OnAfterInitOutstanding (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInitOutstandingQty (var SalesLine@1000 :
    
/*
LOCAL procedure OnAfterInitOutstandingQty (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInitOutstandingAmount (var SalesLine@1000 : Record 37;SalesHeader@1001 : Record 36;Currency@1002 :
    
/*
LOCAL procedure OnAfterInitOutstandingAmount (var SalesLine: Record 37;SalesHeader: Record 36;Currency: Record 4)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInitQtyToInvoice (var SalesLine@1000 : Record 37;CurrFieldNo@1001 :
    
/*
LOCAL procedure OnAfterInitQtyToInvoice (var SalesLine: Record 37;CurrFieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInitQtyToShip (var SalesLine@1000 : Record 37;CurrFieldNo@1001 :
    
/*
LOCAL procedure OnAfterInitQtyToShip (var SalesLine: Record 37;CurrFieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInitQtyToReceive (var SalesLine@1000 : Record 37;CurrFieldNo@1001 :
    
/*
LOCAL procedure OnAfterInitQtyToReceive (var SalesLine: Record 37;CurrFieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCalcVATAmountLines (var SalesHeader@1003 : Record 36;var SalesLine@1002 : Record 37;var VATAmountLine@1001 : Record 290;QtyType@1000 :
    
/*
LOCAL procedure OnAfterCalcVATAmountLines (var SalesHeader: Record 36;var SalesLine: Record 37;var VATAmountLine: Record 290;QtyType: Option "General","Invoicing","Shippin")
    begin
    end;
*/


    
//     LOCAL procedure OnAfterGetLineAmountToHandle (SalesLine@1000 : Record 37;QtyToHandle@1001 : Decimal;var LineAmount@1002 : Decimal;var LineDiscAmount@1003 :
    
/*
LOCAL procedure OnAfterGetLineAmountToHandle (SalesLine: Record 37;QtyToHandle: Decimal;var LineAmount: Decimal;var LineDiscAmount: Decimal)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateAmounts (var SalesLine@1000 : Record 37;var xSalesLine@1002 : Record 37;CurrentFieldNo@1001 :
    
/*
LOCAL procedure OnAfterUpdateAmounts (var SalesLine: Record 37;var xSalesLine: Record 37;CurrentFieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateAmountsDone (var SalesLine@1000 : Record 37;var xSalesLine@1001 : Record 37;CurrentFieldNo@1002 :
    
/*
LOCAL procedure OnAfterUpdateAmountsDone (var SalesLine: Record 37;var xSalesLine: Record 37;CurrentFieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateDates (var SalesLine@1000 :
    
/*
LOCAL procedure OnAfterUpdateDates (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateVATAmounts (var SalesLine@1000 :
    
/*
LOCAL procedure OnAfterUpdateVATAmounts (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateVATOnLines (var SalesHeader@1002 : Record 36;var SalesLine@1001 : Record 37;var VATAmountLine@1000 : Record 290;QtyType@1003 :
    
/*
LOCAL procedure OnAfterUpdateVATOnLines (var SalesHeader: Record 36;var SalesLine: Record 37;var VATAmountLine: Record 290;QtyType: Option "General","Invoicing","Shippin")
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCreateDimTableIDs (var SalesLine@1000 : Record 37;FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :
    
/*
LOCAL procedure OnAfterCreateDimTableIDs (var SalesLine: Record 37;FieldNo: Integer;var TableID: ARRAY [10] OF Integer;var No: ARRAY [10] OF Code[20])
    begin
    end;
*/


    
//     LOCAL procedure OnAfterShowItemSub (var SalesLine@1000 :
    
/*
LOCAL procedure OnAfterShowItemSub (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterValidateReturnReasonCode (var SalesLine@1000 : Record 37;CallingFieldNo@1001 :
    
/*
LOCAL procedure OnAfterValidateReturnReasonCode (var SalesLine: Record 37;CallingFieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnShowItemChargeAssgntOnBeforeCalcItemCharge (var SalesLine@1000 : Record 37;var ItemChargeAssgntLineAmt@1001 : Decimal;Currency@1002 : Record 4;var IsHandled@1003 :
    
/*
LOCAL procedure OnShowItemChargeAssgntOnBeforeCalcItemCharge (var SalesLine: Record 37;var ItemChargeAssgntLineAmt: Decimal;Currency: Record 4;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnUpdateUnitPriceOnBeforeFindPrice (SalesHeader@1000 : Record 36;var SalesLine@1001 : Record 37;CalledByFieldNo@1002 : Integer;FieldNo@1003 : Integer;var IsHandled@1004 :
    
/*
LOCAL procedure OnUpdateUnitPriceOnBeforeFindPrice (SalesHeader: Record 36;var SalesLine: Record 37;CalledByFieldNo: Integer;FieldNo: Integer;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnValidateLocationCodeOnBeforeSetShipmentDate (var SalesLine@1000 : Record 37;var IsHandled@1001 :
    
/*
LOCAL procedure OnValidateLocationCodeOnBeforeSetShipmentDate (var SalesLine: Record 37;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnValidateTypeOnAfterCheckItem (var SalesLine@1000 : Record 37;xSalesLine@1001 :
    
/*
LOCAL procedure OnValidateTypeOnAfterCheckItem (var SalesLine: Record 37;xSalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnValidateTypeOnCopyFromTempSalesLine (var SalesLine@1000 : Record 37;var TempSalesLine@1001 :
    
/*
LOCAL procedure OnValidateTypeOnCopyFromTempSalesLine (var SalesLine: Record 37;var TempSalesLine: Record 37 TEMPORARY)
    begin
    end;
*/


    
//     LOCAL procedure OnValidateNoOnAfterVerifyChange (var SalesLine@1000 : Record 37;xSalesLine@1001 :
    
/*
LOCAL procedure OnValidateNoOnAfterVerifyChange (var SalesLine: Record 37;xSalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnValidateNoOnCopyFromTempSalesLine (var SalesLine@1000 : Record 37;var TempSalesLine@1001 :
    
/*
LOCAL procedure OnValidateNoOnCopyFromTempSalesLine (var SalesLine: Record 37;var TempSalesLine: Record 37 TEMPORARY)
    begin
    end;
*/


    
//     LOCAL procedure OnValidateNoOnBeforeInitRec (var SalesLine@1000 : Record 37;xSalesLine@1001 : Record 37;FieldNo@1002 :
    
/*
LOCAL procedure OnValidateNoOnBeforeInitRec (var SalesLine: Record 37;xSalesLine: Record 37;FieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnValidateNoOnBeforeUpdateDates (var SalesLine@1000 : Record 37;xSalesLine@1001 : Record 37;SalesHeader@1002 : Record 36;FieldNo@1003 :
    
/*
LOCAL procedure OnValidateNoOnBeforeUpdateDates (var SalesLine: Record 37;xSalesLine: Record 37;SalesHeader: Record 36;FieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnValidateVariantCodeOnAfterChecks (var SalesLine@1000 : Record 37;xSalesLine@1001 : Record 37;FieldNo@1002 :
    
/*
LOCAL procedure OnValidateVariantCodeOnAfterChecks (var SalesLine: Record 37;xSalesLine: Record 37;FieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterTestStatusOpen (var SalesLine@1000 : Record 37;var SalesHeader@1001 :
    
/*
LOCAL procedure OnAfterTestStatusOpen (var SalesLine: Record 37;var SalesHeader: Record 36)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterSetDefaultQuantity (var SalesLine@1000 : Record 37;var xSalesLine@1001 :
    
/*
LOCAL procedure OnAfterSetDefaultQuantity (var SalesLine: Record 37;var xSalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateTotalAmounts (var SalesLine@1000 : Record 37;SalesLine2@1001 : Record 37;var TotalAmount@1003 : Decimal;var TotalAmountInclVAT@1002 : Decimal;var TotalLineAmount@1005 : Decimal;var TotalInvDiscAmount@1004 :
    
/*
LOCAL procedure OnAfterUpdateTotalAmounts (var SalesLine: Record 37;SalesLine2: Record 37;var TotalAmount: Decimal;var TotalAmountInclVAT: Decimal;var TotalLineAmount: Decimal;var TotalInvDiscAmount: Decimal)
    begin
    end;
*/


    
//     LOCAL procedure OnGetDeferralPostDate (SalesHeader@1000 : Record 36;var DeferralPostingDate@1001 : Date;SalesLine@1002 :
    
/*
LOCAL procedure OnGetDeferralPostDate (SalesHeader: Record 36;var DeferralPostingDate: Date;SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterAutoAsmToOrder (var SalesLine@1000 :
    
/*
LOCAL procedure OnAfterAutoAsmToOrder (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeAutoAsmToOrder (var SalesLine@1000 :
    
/*
LOCAL procedure OnBeforeAutoAsmToOrder (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterBlanketOrderLookup (var SalesLine@1000 :
    
/*
LOCAL procedure OnAfterBlanketOrderLookup (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeBlanketOrderLookup (var SalesLine@1000 : Record 37;IsHandled@1001 :
    
/*
LOCAL procedure OnBeforeBlanketOrderLookup (var SalesLine: Record 37;IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCalcPlannedDeliveryDate (SalesLine@1000 : Record 37;var PlannedDeliveryDate@1001 : Date;FieldNo@1002 : Integer;var IsHandled@1003 :
    
/*
LOCAL procedure OnBeforeCalcPlannedDeliveryDate (SalesLine: Record 37;var PlannedDeliveryDate: Date;FieldNo: Integer;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeOpenItemTrackingLines (SalesLine@1000 : Record 37;var IsHandled@1001 :
    
/*
LOCAL procedure OnBeforeOpenItemTrackingLines (SalesLine: Record 37;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckCreditLimitCondition (SalesLine@1000 : Record 37;var RunCheck@1001 :
    
/*
LOCAL procedure OnAfterCheckCreditLimitCondition (SalesLine: Record 37;var RunCheck: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnUpdateAmountOnBeforeCheckCreditLimit (var SalesLine@1000 : Record 37;var IsHandled@1001 :
    
/*
LOCAL procedure OnUpdateAmountOnBeforeCheckCreditLimit (var SalesLine: Record 37;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnCrossReferenceNoLookupOnBeforeValidateUnitPrice (SalesHeader@1000 : Record 36;var SalesLine@1001 :
    
/*
LOCAL procedure OnCrossReferenceNoLookupOnBeforeValidateUnitPrice (SalesHeader: Record 36;var SalesLine: Record 37)
    begin
    end;
*/


    
/*
procedure ShowDeferralSchedule ()
    begin
      GetSalesHeader;
      ShowDeferrals(SalesHeader."Posting Date",SalesHeader."Currency Code");
    end;

    /*begin
    //{
//      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci¢n de enviar a la ATCN
//      QPR 0.00.02 Q15431 MCM 20/10/21 - Se crea el campo QB_Piecework No.
//      Q12733 16/02/22 EPV A¤adido campo "Price review line"
//      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.).   NEW FIELD.
//      BS::20668 CSM 04/01/24 Í VEN027 Modificar importe retenci¢n en venta.
//      BS::20479 CSM 26/01/24 Í VEN024 Selecci¢n l¡neas a imprimir.
//    }
    end.
  */
}




