tableextension 50111 "MyExtension50111" extends "Item"
{
  
  /*
Permissions=TableData 337 d,
                TableData 5940 rm,
                TableData 5941 rm;
*/DataCaptionFields="No.","Description";
    CaptionML=ENU='Item',ESP='Producto';
    LookupPageID="Item Lookup";
    DrillDownPageID="Item List";
  
  fields
{
    field(50000;"Do Not Control In Contracts";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Do Not Control In Contracts',ESP='No controlar en contratos';
                                                   Description='BS::19831';


    }
    field(7207270;"QB Created by PRESTO";Boolean)
    {
        CaptionML=ENU='Created by PRESTO s/n',ESP='Creado desde PRESTO';
                                                   Description='QB 1.0 - QB2411';
                                                   Editable=false;


    }
    field(7207271;"QB Activity Code";Code[20])
    {
        TableRelation="Activity QB";
                                                   CaptionML=ENU='Activity Code',ESP='C¢d. actividad';
                                                   Description='QB 1.07.07 - QB2512   JAV 23/11/20 Se amplia a 20';


    }
    field(7207272;"QB Rent Element Code";Code[20])
    {
        TableRelation="Rental Elements";
                                                   CaptionML=ENU='Rent Element Code',ESP='C¢digo elemento alquiler';
                                                   Description='QB 1.0 - QB2413          QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


    }
    field(7207273;"QB Rentable";Boolean)
    {
        CaptionML=ENU='Rentable S/N',ESP='Alquilable S/N';
                                                   Description='QB 1.0 - QB2413';


    }
    field(7207274;"QB Quantity Planned Purchase";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Journal Line"."Quantity" WHERE ("Type"=CONST("Item"),
                                                                                                           "No."=FIELD("No."),
                                                                                                           "Shortcut Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                                                                                                           "Shortcut Dimension 2 Code"=FIELD("Global Dimension 2 Filter"),
                                                                                                           "Location Code"=FIELD("Location Filter"),
                                                                                                           "Date Needed"=FIELD("Date Filter")));
                                                   CaptionML=ENU='Quantity Planned Purchase',ESP='Cantidad planific. de compras';
                                                   Description='QB 1.0';


    }
    field(7207275;"QB Entry (units)";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Ledger Entry"."Quantity" WHERE ("Entry Type"=FILTER('Purchase'|'Positive Adjmt.'),
                                                                                                       "Item No."=FIELD("No."),
                                                                                                       "Location Code"=FIELD("Location Filter"),
                                                                                                       "Posting Date"=FIELD("Date Filter"),
                                                                                                       "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                                                                                                       "Global Dimension 2 Code"=FIELD("Global Dimension 2 Filter"),
                                                                                                       "Job Purchase"=CONST(false)));
                                                   CaptionML=ENU='Entry (units)',ESP='Entrada (udes)';
                                                   Description='QB 1.0';


    }
    field(7207276;"QB Output (units)";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Ledger Entry"."Quantity" WHERE ("Entry Type"=FILTER('Sale'|'Negative Adjmt.'),
                                                                                                       "Item No."=FIELD("No."),
                                                                                                       "Location Code"=FIELD("Location Filter"),
                                                                                                       "Posting Date"=FIELD("Date Filter"),
                                                                                                       "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                                                                                                       "Global Dimension 2 Code"=FIELD("Global Dimension 2 Filter"),
                                                                                                       "Job Purchase"=CONST(false)));
                                                   CaptionML=ENU='Output (units)',ESP='Salida (udes)';
                                                   Description='QB 1.0';


    }
    field(7207277;"QB Location Sum Cost Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Cost Amount (Actual)" WHERE ("Item No."=FIELD("No."),
                                                                                                               "Item Ledger Entry Type"=FILTER('Purchase'|'Transfer'),
                                                                                                               "Location Code"=FIELD("Location Filter"),
                                                                                                               "Posting Date"=FIELD("Date Filter")));
                                                   CaptionML=ENU='Location Cost Amount',ESP='Suma Costes Almac‚n';
                                                   Description='QB 1.04 JAV 27/05/20: - Suma de importes movimientos del almac‚n, al dividir por el siguiente nos da el coste medio del periodo';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(7207278;"QB Location Sum Cost Qty";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Invoiced Quantity" WHERE ("Item No."=FIELD("No."),
                                                                                                            "Item Ledger Entry Type"=FILTER('Purchase'|'Transfer'),
                                                                                                            "Location Code"=FIELD("Location Filter"),
                                                                                                            "Posting Date"=FIELD("Date Filter")));
                                                   CaptionML=ENU='Location Cost Amount',ESP='Suma Cantidades Almac‚n';
                                                   Description='QB 1.04 JAV 27/05/20: - Suma de cantidades de movimeintos del almac‚n';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(7207279;"QB Proformable";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Asignable a proforma';
                                                   Description='QB 1.08.41 JAV 21/04/21: - Si el producto es asignable a una proforma o no';


    }
    field(7207281;"QB Cod. C.A. Direct Costs";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. C.A. Indirects Costs',ESP='C.A. Costes Directos';
                                                   Description='QB 1.06.08 - JAV 14/08/20: - Concepto anal¡tico para usar en costes directos';

trigger OnLookup();
    VAR
//                                                               FunctionQB@100000001 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("QB Cod. C.A. Direct Costs",FALSE);
                                                            END;


    }
    field(7207311;"QB Created from Master Data";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Creado desde Master Data';
                                                   Description='QB 1.06.12 - JAV 09/09/20: - Si se ha creado desde la empresa Master Data';
                                                   Editable=false;


    }
    field(7207312;"QB Updated from Master Data";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Actualizado desde Master Data';
                                                   Description='QB 1.06.12 - JAV 09/09/20: - Si se ha creado desde la empresa Master Data';
                                                   Editable=false;


    }
    field(7207496;"QB Data Missed";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Data Missed';
                                                   Description='QB 1.06.14 JAV 17/08/20: - Si faltan datos obligatorios';
                                                   Editable=false;


    }
    field(7207497;"QB Data Missed Message";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Data Missed Message',ESP='Datos Obligatorios que faltan';
                                                   Description='QB 1.06.14 JAV 17/08/20: - Texto con los datos que faltan';
                                                   Editable=false;


    }
    field(7207498;"QB Data Missed Old Blocked";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Last Blocked';
                                                   Description='QB 1.06.14 JAV 17/08/20: - Estado del bloqueo antes de faltar datos para poder reponerlo';

trigger OnValidate();
    VAR
//                                                                 CustLedgerEntry@1001 :
                                                                CustLedgerEntry: Record 21;
//                                                                 AccountingPeriod@1002 :
                                                                AccountingPeriod: Record 50;
//                                                                 IdentityManagement@1000 :
                                                                IdentityManagement: Codeunit 9801;
                                                              BEGIN 
                                                              END;


    }
    field(7207499;"QB Auxiliary Location";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Auxiliary Location',ESP='Almac‚n auxiliar';
                                                   Description='QB 1.06.15';


    }
    field(7207500;"QB Allows Deposit";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allows Deposit',ESP='Permite dep¢sito';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';


    }
    field(7207501;"QB Allow Ceded";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Ceded',ESP='Permite cedidos';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';


    }
    field(7207502;"QB Origen Location Filter";Code[20])
    {
        FieldClass=FlowFilter;
                                                   CaptionML=ENU='Origen Location Filter',ESP='Filtro almac‚n origen';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';


    }
    field(7207503;"QB Destination Location Filter";Code[20])
    {
        FieldClass=FlowFilter;
                                                   CaptionML=ENU='Destination Location Filter',ESP='Filtro almac‚n destino';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';


    }
    field(7207504;"QB Qty. Ceded";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Ceded"."Remaining Quantity." WHERE ("Item No."=FIELD("No."),
                                                                                                           "Origin Location"=FIELD("QB Origen Location Filter"),
                                                                                                           "Destination Location"=FIELD("QB Destination Location Filter")));
                                                   

                                                   CaptionML=ENU='Qty. Ceded',ESP='Cdad. cedida';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';
                                                   Editable=false;

trigger OnValidate();
    BEGIN 
                                                                //Sum("QB Ceded"."Remaining Quantity." WHERE (Item No.=FIELD(No.),Origin Location=FIELD(Origen Location Filter),Destination Location=FIELD(Destination Location Filter)))
                                                              END;


    }
    field(7207505;"QB Plant Item";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Plant Item',ESP='Producto planta';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';


    }
    field(7207506;"QB Main Location";Code[20])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Location"."Code" WHERE ("QB Main Location"=CONST(true)));
                                                   CaptionML=ENU='Main Location',ESP='Almac‚n Principal';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';


    }
    field(7207507;"QB Main Location Cost";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Stockkeeping Unit"."Unit Cost" WHERE ("Item No."=FIELD("No."),
                                                                                                          "Location Code"=FIELD("QB Main Location")));
                                                   CaptionML=ENU='Main Location Cost',ESP='Coste almac‚n principal';
                                                   MinValue=0;
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';
                                                   Editable=false;
                                                   AutoFormatType=2;


    }
    field(7207508;"QB Main Loc. Purch. Average Pr";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Coste medio de compra alm. principal';
                                                   DecimalPlaces=0:6;
                                                   Description='Q17138';


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Search Description")
  //  {
       /* ;
 */
   // }
   // key(key3;"Inventory Posting Group")
  //  {
       /* ;
 */
   // }
   // key(key4;"Shelf No.")
  //  {
       /* ;
 */
   // }
   // key(key5;"Vendor No.")
  //  {
       /* ;
 */
   // }
   // key(key6;"Gen. Prod. Posting Group")
  //  {
       /* ;
 */
   // }
   // key(key7;"Low-Level Code")
  //  {
       /* ;
 */
   // }
   // key(key8;"Production BOM No.")
  //  {
       /* ;
 */
   // }
   // key(key9;"Routing No.")
  //  {
       /* ;
 */
   // }
   // key(key10;"Vendor Item No.","Vendor No.")
  //  {
       /* ;
 */
   // }
   // key(key11;"Common Item No.")
  //  {
       /* ;
 */
   // }
   // key(key12;"Service Item Group")
  //  {
       /* ;
 */
   // }
   // key(key13;"Cost is Adjusted","Allow Online Adjustment")
  //  {
       /* ;
 */
   // }
   // key(key14;"Description")
  //  {
       /* ;
 */
   // }
   // key(key15;"Base Unit of Measure")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"No.","Description","Base Unit of Measure","Unit Price")
   // {
       // 
   // }
   // fieldgroup(Brick;"No.","Description","Inventory","Unit Price","Base Unit of Measure","Description 2","Picture")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='You cannot delete %1 %2 because there is at least one outstanding Purchase %3 that includes this item.',ESP='No puede borrar %1 %2 porque hay al menos una compra pendiente %3 que incluye este producto.';
//       CannotDeleteItemIfSalesDocExistErr@1001 :
      CannotDeleteItemIfSalesDocExistErr: 
// 1: Type, 2 Item No. and 3 : Type of document Order,Invoice
TextConst ENU='You cannot delete %1 %2 because there is at least one outstanding Sales %3 that includes this item.',ESP='No puede borrar %1 %2 porque hay al menos una venta pendiente %3 que incluye este producto.';
//       CannotDeleteItemIfSalesDocExistInvoicingErr@1041 :
      CannotDeleteItemIfSalesDocExistInvoicingErr: 
// 1: Type, 2: Item No., 3: Description of document, 4: Document number
TextConst ENU='You cannot delete %1 %2 because at least one sales document (%3 %4) includes the item.',ESP='No puede eliminar %1 %2 porque hay al menos un documento de ventas (%3 %4) que incluye este producto.';
//       Text002@1002 :
      Text002: TextConst ENU='You cannot delete %1 %2 because there are one or more outstanding production orders that include this item.',ESP='No se puede eliminar el %1 %2 porque hay ordenes de producci¢n pendientes para este producto.';
//       Text003@1057 :
      Text003: TextConst ENU='Do you want to change %1?',ESP='¨Confirma que desea cambiar %1?';
//       Text004@1064 :
      Text004: TextConst ENU='You cannot delete %1 %2 because there are one or more certified Production BOM that include this item.',ESP='No puede eliminar %1 %2 porque una o m s LM producci¢n incluyen este producto.';
//       CannotDeleteItemIfProdBOMVersionExistsErr@1084 :
      CannotDeleteItemIfProdBOMVersionExistsErr: 
// %1 - Tablecaption, %2 - No.
TextConst ENU='You cannot delete %1 %2 because there are one or more certified production BOM version that include this item.',ESP='No puede eliminar %1 %2 porque una o m s versiones de la L.M. de producci¢n certificada incluyen este producto.';
//       Text006@1003 :
      Text006: TextConst ENU='Prices including VAT cannot be calculated when %1 is %2.',ESP='No se pueden calcular precios IVA incluido cuando %1 es %2.';
//       Text007@1004 :
      Text007: TextConst ENU='You cannot change %1 because there are one or more ledger entries for this item.',ESP='No se puede cambiar el producto %1 porque tiene movimientos pendientes.';
//       Text008@1005 :
      Text008: TextConst ENU='You cannot change %1 because there is at least one outstanding Purchase %2 that include this item.',ESP='No puede cambiar %1 porque existe al menos un %2 compra pendiente que incluye este producto.';
//       Text014@1006 :
      Text014: TextConst ENU='You cannot delete %1 %2 because there are one or more production order component lines that include this item with a remaining quantity that is not 0.',ESP='No puede eliminar %1 %2 porque una o m s l¡ns. comp. pedido producci¢n que incluyen este producto tienen una cantidad pendiente que no es 0.';
//       Text016@1008 :
      Text016: TextConst ENU='You cannot delete %1 %2 because there are one or more outstanding transfer orders that include this item.',ESP='No puede borrar %1 %2 porque hay uno o m s pedidos de transfer. pendientes que incluyen este producto.';
//       Text017@1009 :
      Text017: TextConst ENU='You cannot delete %1 %2 because there is at least one outstanding Service %3 that includes this item.',ESP='No puede borrar el %1 %2 porque hay al menos un documento de tipo %3 de servicio pendiente que incluyen este producto.';
//       Text018@1010 :
      Text018: TextConst ENU='%1 must be %2 in %3 %4 when %5 is %6.',ESP='%1 debe ser %2 en %3 %4 cuando %5 es %6.';
//       Text019@1011 :
      Text019: TextConst ENU='You cannot change %1 because there are one or more open ledger entries for this item.',ESP='No puede cambiar %1 porque hay uno o m s movs. pendientes para este producto.';
//       Text020@1012 :
      Text020: TextConst ENU='There may be orders and open ledger entries for the item. ',ESP='El producto tiene pedidos o movimientos pendientes. ';
//       Text021@1013 :
      Text021: TextConst ENU='if you change %1 it may affect new orders and entries.\\',ESP='Si cambia el %1 puede afectar a los pedidos y movimientos nuevos.\\';
//       Text022@1014 :
      Text022: TextConst ENU='Do you want to change %1?',ESP='¨Confirma que desea cambiar %1?';
//       GLSetup@1053 :
      GLSetup: Record 98;
//       InvtSetup@1015 :
      InvtSetup: Record 313;
//       Text023@1066 :
      Text023: TextConst ENU='You cannot delete %1 %2 because there is at least one %3 that includes this item.',ESP='No puede eliminar %1 %2 porque hay al menos un(a) %3 que incluye este producto.';
//       Text024@1072 :
      Text024: TextConst ENU='if you change %1 it may affect existing production orders.\',ESP='Un cambio en %1 podr¡a afectar a las ¢rdenes de producci¢n existentes.\';
//       Text025@1055 :
      Text025: TextConst ENU='%1 must be an integer because %2 %3 is set up to use %4.',ESP='%1 debe ser un n£mero entero porque %2 %3 est  configurado para usar %4.';
//       Text026@1077 :
      Text026: TextConst ENU='%1 cannot be changed because the %2 has work in process (WIP). Changing the value may offset the WIP account.',ESP='%1 no se puede modificar porque %2 tiene un trabajo en curso (WIP). El cambio de los valores podr¡a provocar un desfase en la cuenta WIP.';
//       Text7380@1058 :
      Text7380: 
// if you change the Phys Invt Counting Period Code, the Next Counting Start Date and Next Counting end Date are calculated.\Do you still want to change the Phys Invt Counting Period Code?
TextConst ENU='if you change the %1, the %2 and %3 are calculated.\Do you still want to change the %1?',ESP='Si cambia el %1, se calculan el %2 y el %3.\¨Desea cambiar el %1?';
//       Text7381@1056 :
      Text7381: TextConst ENU='Cancelled.',ESP='Cancelado.';
//       Text99000000@1017 :
      Text99000000: TextConst ENU='The change will not affect existing entries.\',ESP='El cambio no afectar  movimientos existentes.\';
//       CommentLine@1018 :
      CommentLine: Record 97;
//       Text99000001@1019 :
      Text99000001: TextConst ENU='if you want to generate %1 for existing entries, you must run a regenerative planning.',ESP='Si quiere generar %1 para mov. existentes, debe ejecutar planificaci¢n regenerativa.';
//       ItemVend@1020 :
      ItemVend: Record 99;
//       Text99000002@1021 :
      Text99000002: TextConst ENU='tracking,tracking and action messages',ESP='seguimiento,seguim. y mensajes acci¢n';
//       SalesPrice@1022 :
      SalesPrice: Record 7002;
//       SalesLineDisc@1059 :
      SalesLineDisc: Record 7004;
//       SalesPrepmtPct@1051 :
      SalesPrepmtPct: Record 459;
//       PurchPrice@1060 :
      PurchPrice: Record 7012;
//       PurchLineDisc@1061 :
      PurchLineDisc: Record 7014;
//       PurchPrepmtPct@1076 :
      PurchPrepmtPct: Record 460;
//       ItemTranslation@1023 :
      ItemTranslation: Record 30;
//       BOMComp@1024 :
      BOMComp: Record 90;
//       VATPostingSetup@1027 :
      VATPostingSetup: Record 325;
//       ExtTextHeader@1028 :
      ExtTextHeader: Record 279;
//       GenProdPostingGrp@1029 :
      GenProdPostingGrp: Record 251;
//       ItemUnitOfMeasure@1030 :
      ItemUnitOfMeasure: Record 5404;
//       ItemVariant@1031 :
      ItemVariant: Record 5401;
//       ItemJnlLine@1007 :
      ItemJnlLine: Record 83;
//       ProdOrderLine@1032 :
      ProdOrderLine: Record 5406;
//       ProdOrderComp@1033 :
      ProdOrderComp: Record 5407;
//       PlanningAssignment@1035 :
      PlanningAssignment: Record 99000850;
//       SKU@1036 :
      SKU: Record 5700;
//       ItemTrackingCode@1037 :
      ItemTrackingCode: Record 6502;
//       ItemTrackingCode2@1038 :
      ItemTrackingCode2: Record 6502;
//       ServInvLine@1039 :
      ServInvLine: Record 5902;
//       ItemSub@1040 :
      ItemSub: Record 5715;
//       TransLine@1042 :
      TransLine: Record 5741;
//       Vend@1016 :
      Vend: Record 23;
//       NonstockItem@1034 :
      NonstockItem: Record 5718;
//       ProdBOMHeader@1062 :
      ProdBOMHeader: Record 99000771;
//       ProdBOMLine@1063 :
      ProdBOMLine: Record 99000772;
//       ItemIdent@1065 :
      ItemIdent: Record 7704;
//       RequisitionLine@1067 :
      RequisitionLine: Record 246;
//       ItemBudgetEntry@1075 :
      ItemBudgetEntry: Record 7134;
//       ItemAnalysisViewEntry@1074 :
      ItemAnalysisViewEntry: Record 7154;
//       ItemAnalysisBudgViewEntry@1073 :
      ItemAnalysisBudgViewEntry: Record 7156;
//       TroubleshSetup@1050 :
      TroubleshSetup: Record 5945;
//       ServiceItem@1068 :
      ServiceItem: Record 5940;
//       ServiceContractLine@1069 :
      ServiceContractLine: Record 5964;
//       ServiceItemComponent@1070 :
      ServiceItemComponent: Record 5941;
//       NoSeriesMgt@1043 :
      NoSeriesMgt: Codeunit 396;
//       MoveEntries@1044 :
      MoveEntries: Codeunit 361;
//       DimMgt@1045 :
      DimMgt: Codeunit 408;
//       CatalogItemMgt@1046 :
      CatalogItemMgt: Codeunit 5703;
//       ItemCostMgt@1047 :
      ItemCostMgt: Codeunit 5804;
//       ResSkillMgt@1071 :
      ResSkillMgt: Codeunit 5931;
//       CalendarMgt@1054 :
      CalendarMgt: Codeunit 7600;
//       LeadTimeMgt@1025 :
      LeadTimeMgt: Codeunit 5404;
//       ApprovalsMgmt@1085 :
      ApprovalsMgmt: Codeunit 1535;
//       HasInvtSetup@1049 :
      HasInvtSetup: Boolean;
//       GLSetupRead@1052 :
      GLSetupRead: Boolean;
//       Text027@1078 :
      Text027: 
// starts with "Rounding Precision"
TextConst ENU='must be greater than 0.',ESP='debe ser mayor que 0.';
//       Text028@1080 :
      Text028: TextConst ENU='You cannot perform this action because entries for item %1 are unapplied in %2 by user %3.',ESP='No puede realizar esta acci¢n porque los movs. para el producto %1 no se han desliquidado en %2 por parte del usuario %3.';
//       CannotChangeFieldErr@1079 :
      CannotChangeFieldErr: 
// "%1 = Field Caption, %2 = Item Table Name, %3 = Item No., %4 = Table Name"
TextConst ENU='You cannot change the %1 field on %2 %3 because at least one %4 exists for this item.',ESP='No puede cambiar el campo %1 en %2 %3 porque existe como m¡nimo una %4 de este producto.';
//       BaseUnitOfMeasureQtyMustBeOneErr@1081 :
      BaseUnitOfMeasureQtyMustBeOneErr: 
// "%1 Name of Unit of measure (e.g. BOX, PCS, KG...), %2 Qty. of %1 per base unit of measure "
TextConst ENU='The quantity per base unit of measure must be 1. %1 is set up with %2 per unit of measure.\\You can change this setup in the Item Units of Measure window.',ESP='La cantidad por unidad de medida base debe ser 1. %1 est  configurado con %2 por unidad de medida.\\Puede cambiar esta configuraci¢n en la ventana Unidades de medida.';
//       OpenDocumentTrackingErr@1082 :
      OpenDocumentTrackingErr: TextConst ENU='You cannot change ""Item Tracking Code"" because there is at least one open document that includes this item with specified tracking: Source Type = %1, Document No. = %2.',ESP='No puede cambiar la opci¢n ""C¢d. seguim. prod."" porque hay al menos un documento que incluye este art¡culo con el seguimiento especificado. Tipo de origen = %1, N.§ de documento = %2.';
//       SelectItemErr@1083 :
      SelectItemErr: TextConst ENU='You must select an existing item.',ESP='Debe seleccionar un producto existente.';
//       CreateNewItemTxt@1187 :
      CreateNewItemTxt: 
// "%1 is the name to be used to create the customer. "
TextConst ENU='Create a new item card for %1.',ESP='Cree una nueva ficha de producto para %1.';
//       ItemNotRegisteredTxt@1186 :
      ItemNotRegisteredTxt: TextConst ENU='This item is not registered. To continue, choose one of the following options:',ESP='Este producto no est  registrado. Para continuar, elija una de las opciones siguientes:';
//       SelectItemTxt@1185 :
      SelectItemTxt: TextConst ENU='Select an existing item.',ESP='Seleccione un producto existente.';
//       UnitOfMeasureNotExistErr@1026 :
      UnitOfMeasureNotExistErr: 
// "%1 = Code of Unit of measure"
TextConst ENU='The Unit of Measure with Code %1 does not exist.',ESP='No existe la unidad de medida con el c¢digo %1.';
//       ItemLedgEntryTableCaptionTxt@1048 :
      ItemLedgEntryTableCaptionTxt: TextConst ENU='Item Ledger Entry',ESP='Mov. producto';

    


/*
trigger OnInsert();    begin
               if "No." = '' then begin
                 GetInvtSetup;
                 InvtSetup.TESTFIELD("Item Nos.");
                 NoSeriesMgt.InitSeries(InvtSetup."Item Nos.",xRec."No. Series",0D,"No.","No. Series");
                 "Costing Method" := InvtSetup."Default Costing Method";
               end;

               DimMgt.UpdateDefaultDim(
                 DATABASE::Item,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");

               UpdateReferencedIds;
               SetLastDateTimeModified;
             end;


*/

/*
trigger OnModify();    begin
               UpdateReferencedIds;
               SetLastDateTimeModified;
               PlanningAssignment.ItemChange(Rec,xRec);
             end;


*/

/*
trigger OnDelete();    begin
               ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);

               CheckJournalsAndWorksheets(0);
               CheckDocuments(0);

               MoveEntries.MoveItemEntries(Rec);

               ServiceItem.RESET;
               ServiceItem.SETRANGE("Item No.","No.");
               if ServiceItem.FIND('-') then
                 repeat
                   ServiceItem.VALIDATE("Item No.",'');
                   ServiceItem.MODIFY(TRUE);
                 until ServiceItem.NEXT = 0;

               DeleteRelatedData;
             end;


*/

/*
trigger OnRename();    var
//                SalesLine@1000 :
               SalesLine: Record 37;
//                PurchaseLine@1001 :
               PurchaseLine: Record 39;
//                TransferLine@1003 :
               TransferLine: Record 5741;
//                ItemAttributeValueMapping@1002 :
               ItemAttributeValueMapping: Record 7505;
             begin
               SalesLine.RenameNo(SalesLine.Type::Item,xRec."No.","No.");
               PurchaseLine.RenameNo(PurchaseLine.Type::Item,xRec."No.","No.");
               TransferLine.RenameNo(xRec."No.","No.");
               DimMgt.RenameDefaultDim(DATABASE::Item,xRec."No.","No.");

               ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);
               ItemAttributeValueMapping.RenameItemAttributeValueMapping(xRec."No.","No.");
               SetLastDateTimeModified;
             end;

*/




/*
LOCAL procedure DeleteRelatedData ()
    var
//       BinContent@1002 :
      BinContent: Record 7302;
//       ItemCrossReference@1001 :
      ItemCrossReference: Record 5717;
//       SocialListeningSearchTopic@1000 :
      SocialListeningSearchTopic: Record 871;
//       MyItem@1003 :
      MyItem: Record 9152;
//       ItemAttributeValueMapping@1004 :
      ItemAttributeValueMapping: Record 7505;
    begin
      ItemBudgetEntry.SETCURRENTKEY("Analysis Area","Budget Name","Item No.");
      ItemBudgetEntry.SETRANGE("Item No.","No.");
      ItemBudgetEntry.DELETEALL(TRUE);

      ItemSub.RESET;
      ItemSub.SETRANGE(Type,ItemSub.Type::Item);
      ItemSub.SETRANGE("No.","No.");
      ItemSub.DELETEALL;

      ItemSub.RESET;
      ItemSub.SETRANGE("Substitute Type",ItemSub."Substitute Type"::Item);
      ItemSub.SETRANGE("Substitute No.","No.");
      ItemSub.DELETEALL;

      SKU.RESET;
      SKU.SETCURRENTKEY("Item No.");
      SKU.SETRANGE("Item No.","No.");
      SKU.DELETEALL;

      CatalogItemMgt.NonstockItemDel(Rec);
      CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Item);
      CommentLine.SETRANGE("No.","No.");
      CommentLine.DELETEALL;

      ItemVend.SETCURRENTKEY("Item No.");
      ItemVend.SETRANGE("Item No.","No.");
      ItemVend.DELETEALL;

      SalesPrice.SETRANGE("Item No.","No.");
      SalesPrice.DELETEALL;

      SalesLineDisc.SETRANGE(Type,SalesLineDisc.Type::Item);
      SalesLineDisc.SETRANGE(Code,"No.");
      SalesLineDisc.DELETEALL;

      SalesPrepmtPct.SETRANGE("Item No.","No.");
      SalesPrepmtPct.DELETEALL;

      PurchPrice.SETRANGE("Item No.","No.");
      PurchPrice.DELETEALL;

      PurchLineDisc.SETRANGE("Item No.","No.");
      PurchLineDisc.DELETEALL;

      PurchPrepmtPct.SETRANGE("Item No.","No.");
      PurchPrepmtPct.DELETEALL;

      ItemTranslation.SETRANGE("Item No.","No.");
      ItemTranslation.DELETEALL;

      ItemUnitOfMeasure.SETRANGE("Item No.","No.");
      ItemUnitOfMeasure.DELETEALL;

      ItemVariant.SETRANGE("Item No.","No.");
      ItemVariant.DELETEALL;

      ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::Item);
      ExtTextHeader.SETRANGE("No.","No.");
      ExtTextHeader.DELETEALL(TRUE);

      ItemAnalysisViewEntry.SETRANGE("Item No.","No.");
      ItemAnalysisViewEntry.DELETEALL;

      ItemAnalysisBudgViewEntry.SETRANGE("Item No.","No.");
      ItemAnalysisBudgViewEntry.DELETEALL;

      PlanningAssignment.SETRANGE("Item No.","No.");
      PlanningAssignment.DELETEALL;

      BOMComp.RESET;
      BOMComp.SETRANGE("Parent Item No.","No.");
      BOMComp.DELETEALL;

      TroubleshSetup.RESET;
      TroubleshSetup.SETRANGE(Type,TroubleshSetup.Type::Item);
      TroubleshSetup.SETRANGE("No.","No.");
      TroubleshSetup.DELETEALL;

      ResSkillMgt.DeleteItemResSkills("No.");
      DimMgt.DeleteDefaultDim(DATABASE::Item,"No.");

      ItemIdent.RESET;
      ItemIdent.SETCURRENTKEY("Item No.");
      ItemIdent.SETRANGE("Item No.","No.");
      ItemIdent.DELETEALL;

      ServiceItemComponent.RESET;
      ServiceItemComponent.SETRANGE(Type,ServiceItemComponent.Type::Item);
      ServiceItemComponent.SETRANGE("No.","No.");
      ServiceItemComponent.MODIFYALL("No.",'');

      BinContent.SETCURRENTKEY("Item No.");
      BinContent.SETRANGE("Item No.","No.");
      BinContent.DELETEALL;

      ItemCrossReference.SETRANGE("Item No.","No.");
      ItemCrossReference.DELETEALL;

      MyItem.SETRANGE("Item No.","No.");
      MyItem.DELETEALL;

      if not SocialListeningSearchTopic.ISEMPTY then begin
        SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Item,"No.");
        SocialListeningSearchTopic.DELETEALL;
      end;

      ItemAttributeValueMapping.RESET;
      ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::Item);
      ItemAttributeValueMapping.SETRANGE("No.","No.");
      ItemAttributeValueMapping.DELETEALL;

      OnAfterDeleteRelatedData(Rec);
    end;
*/


    
    
/*
procedure AssistEdit () : Boolean;
    begin
      GetInvtSetup;
      InvtSetup.TESTFIELD("Item Nos.");
      if NoSeriesMgt.SelectSeries(InvtSetup."Item Nos.",xRec."No. Series","No. Series") then begin
        NoSeriesMgt.SetSeries("No.");
        exit(TRUE);
      end;
    end;
*/


    
//     procedure FindItemVend (var ItemVend@1000 : Record 99;LocationCode@1002 :
    
/*
procedure FindItemVend (var ItemVend: Record 99;LocationCode: Code[10])
    var
//       GetPlanningParameters@1004 :
      GetPlanningParameters: Codeunit 99000855;
    begin
      TESTFIELD("No.");
      ItemVend.RESET;
      ItemVend.SETRANGE("Item No.","No.");
      ItemVend.SETRANGE("Vendor No.",ItemVend."Vendor No.");
      ItemVend.SETRANGE("Variant Code",ItemVend."Variant Code");

      if not ItemVend.FIND('+') then begin
        ItemVend."Item No." := "No.";
        ItemVend."Vendor Item No." := '';
        GetPlanningParameters.AtSKU(SKU,"No.",ItemVend."Variant Code",LocationCode);
        if ItemVend."Vendor No." = '' then
          ItemVend."Vendor No." := SKU."Vendor No.";
        if ItemVend."Vendor Item No." = '' then
          ItemVend."Vendor Item No." := SKU."Vendor Item No.";
        ItemVend."Lead Time Calculation" := SKU."Lead Time Calculation";
      end;
      if FORMAT(ItemVend."Lead Time Calculation") = '' then begin
        GetPlanningParameters.AtSKU(SKU,"No.",ItemVend."Variant Code",LocationCode);
        ItemVend."Lead Time Calculation" := SKU."Lead Time Calculation";
        if FORMAT(ItemVend."Lead Time Calculation") = '' then
          if Vend.GET(ItemVend."Vendor No.") then
            ItemVend."Lead Time Calculation" := Vend."Lead Time Calculation";
      end;
      ItemVend.RESET;
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Item,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    end;
*/


    
//     procedure TestNoEntriesExist (CurrentFieldName@1000 :
    
/*
procedure TestNoEntriesExist (CurrentFieldName: Text[100])
    var
//       ItemLedgEntry@1001 :
      ItemLedgEntry: Record 32;
//       PurchaseLine@1002 :
      PurchaseLine: Record 39;
    begin
      if "No." = '' then
        exit;

      ItemLedgEntry.SETCURRENTKEY("Item No.");
      ItemLedgEntry.SETRANGE("Item No.","No.");
      if not ItemLedgEntry.ISEMPTY then
        ERROR(
          Text007,
          CurrentFieldName);

      PurchaseLine.SETCURRENTKEY("Document Type",Type,"No.");
      PurchaseLine.SETFILTER(
        "Document Type",'%1|%2',
        PurchaseLine."Document Type"::Order,
        PurchaseLine."Document Type"::"Return Order");
      PurchaseLine.SETRANGE(Type,PurchaseLine.Type::Item);
      PurchaseLine.SETRANGE("No.","No.");
      if PurchaseLine.FINDFIRST then
        ERROR(
          Text008,
          CurrentFieldName,
          PurchaseLine."Document Type");
    end;
*/


    
//     procedure TestNoOpenEntriesExist (CurrentFieldName@1000 :
    
/*
procedure TestNoOpenEntriesExist (CurrentFieldName: Text[100])
    var
//       ItemLedgEntry@1001 :
      ItemLedgEntry: Record 32;
    begin
      ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
      ItemLedgEntry.SETRANGE("Item No.","No.");
      ItemLedgEntry.SETRANGE(Open,TRUE);
      if not ItemLedgEntry.ISEMPTY then
        ERROR(
          Text019,
          CurrentFieldName);
    end;
*/


    
/*
LOCAL procedure TestNoOpenDocumentsWithTrackingExist ()
    var
//       TrackingSpecification@1000 :
      TrackingSpecification: Record 336;
//       ReservationEntry@1001 :
      ReservationEntry: Record 337;
//       RecRef@1004 :
      RecRef: RecordRef;
//       SourceType@1002 :
      SourceType: Integer;
//       SourceID@1003 :
      SourceID: Code[20];
    begin
      if ItemTrackingCode2.Code = '' then
        exit;

      TrackingSpecification.SETRANGE("Item No.","No.");
      if TrackingSpecification.FINDFIRST then begin
        SourceType := TrackingSpecification."Source Type";
        SourceID := TrackingSpecification."Source ID";
      end else begin
        ReservationEntry.SETRANGE("Item No.","No.");
        ReservationEntry.SETFILTER("Item Tracking",'<>%1',ReservationEntry."Item Tracking"::None);
        if ReservationEntry.FINDFIRST then begin
          SourceType := ReservationEntry."Source Type";
          SourceID := ReservationEntry."Source ID";
        end;
      end;

      if SourceType = 0 then
        exit;

      RecRef.OPEN(SourceType);
      ERROR(OpenDocumentTrackingErr,RecRef.CAPTION,SourceID);
    end;
*/


    
//     procedure ItemSKUGet (var Item@1000 : Record 27;LocationCode@1001 : Code[10];VariantCode@1002 :
    
/*
procedure ItemSKUGet (var Item: Record 27;LocationCode: Code[10];VariantCode: Code[10])
    var
//       SKU@1003 :
      SKU: Record 5700;
    begin
      if Item.GET("No.") then begin
        if SKU.GET(LocationCode,Item."No.",VariantCode) then
          Item."Shelf No." := SKU."Shelf No.";
      end;
    end;
*/


    
/*
LOCAL procedure GetInvtSetup ()
    begin
      if not HasInvtSetup then begin
        InvtSetup.GET;
        HasInvtSetup := TRUE;
      end;
    end;
*/


    
    
/*
procedure IsMfgItem () : Boolean;
    begin
      exit("Replenishment System" = "Replenishment System"::"Prod. Order");
    end;
*/


    
    
/*
procedure IsAssemblyItem () : Boolean;
    begin
      exit("Replenishment System" = "Replenishment System"::Assembly);
    end;
*/


    
    
/*
procedure HasBOM () : Boolean;
    begin
      CALCFIELDS("Assembly BOM");
      exit("Assembly BOM" or ("Production BOM No." <> ''));
    end;
*/


    
/*
LOCAL procedure GetGLSetup ()
    begin
      if not GLSetupRead then
        GLSetup.GET;
      GLSetupRead := TRUE;
    end;
*/


    
/*
LOCAL procedure ProdOrderExist () : Boolean;
    begin
      ProdOrderLine.SETCURRENTKEY(Status,"Item No.");
      ProdOrderLine.SETFILTER(Status,'..%1',ProdOrderLine.Status::Released);
      ProdOrderLine.SETRANGE("Item No.","No.");
      if not ProdOrderLine.ISEMPTY then
        exit(TRUE);

      exit(FALSE);
    end;
*/


    
//     procedure CheckSerialNoQty (ItemNo@1000 : Code[20];FieldName@1001 : Text[30];Quantity@1002 :
    
/*
procedure CheckSerialNoQty (ItemNo: Code[20];FieldName: Text[30];Quantity: Decimal)
    var
//       ItemRec@1003 :
      ItemRec: Record 27;
//       ItemTrackingCode3@1004 :
      ItemTrackingCode3: Record 6502;
    begin
      if Quantity = ROUND(Quantity,1) then
        exit;
      if not ItemRec.GET(ItemNo) then
        exit;
      if ItemRec."Item Tracking Code" = '' then
        exit;
      if not ItemTrackingCode3.GET(ItemRec."Item Tracking Code") then
        exit;
      if ItemTrackingCode3."SN Specific Tracking" then
        ERROR(Text025,
          FieldName,
          TABLECAPTION,
          ItemNo,
          ItemTrackingCode3.FIELDCAPTION("SN Specific Tracking"));
    end;
*/


//     LOCAL procedure CheckForProductionOutput (ItemNo@1000 :
    
/*
LOCAL procedure CheckForProductionOutput (ItemNo: Code[20])
    var
//       ItemLedgEntry@1001 :
      ItemLedgEntry: Record 32;
    begin
      CLEAR(ItemLedgEntry);
      ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
      ItemLedgEntry.SETRANGE("Item No.",ItemNo);
      ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Output);
      if not ItemLedgEntry.ISEMPTY then
        ERROR(Text026,FIELDCAPTION("Inventory Value Zero"),TABLECAPTION);
    end;
*/


    
    
/*
procedure CheckBlockedByApplWorksheet ()
    var
//       ApplicationWorksheet@1000 :
      ApplicationWorksheet: Page 521;
    begin
      if "Application Wksh. User ID" <> '' then
        ERROR(Text028,"No.",ApplicationWorksheet.CAPTION,"Application Wksh. User ID");
    end;
*/


    
//     procedure ShowTimelineFromItem (var Item@1000 :
    
/*
procedure ShowTimelineFromItem (var Item: Record 27)
    var
//       ItemAvailByTimeline@1001 :
      ItemAvailByTimeline: Page 5540;
    begin
      ItemAvailByTimeline.SetItem(Item);
      ItemAvailByTimeline.RUN;
    end;
*/


    
//     procedure ShowTimelineFromSKU (ItemNo@1000 : Code[20];LocationCode@1001 : Code[10];VariantCode@1002 :
    
/*
procedure ShowTimelineFromSKU (ItemNo: Code[20];LocationCode: Code[10];VariantCode: Code[10])
    var
//       Item@1003 :
      Item: Record 27;
    begin
      Item.GET(ItemNo);
      Item.SETRANGE("No.",Item."No.");
      Item.SETRANGE("Variant Filter",VariantCode);
      Item.SETRANGE("Location Filter",LocationCode);
      ShowTimelineFromItem(Item);
    end;
*/


    
//     procedure CheckJournalsAndWorksheets (CurrFieldNo@1001 :
    
/*
procedure CheckJournalsAndWorksheets (CurrFieldNo: Integer)
    begin
      CheckItemJnlLine(CurrFieldNo);
      CheckStdCostWksh(CurrFieldNo);
      CheckReqLine(CurrFieldNo);
    end;
*/


//     LOCAL procedure CheckItemJnlLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckItemJnlLine (CurrFieldNo: Integer)
    begin
      ItemJnlLine.SETRANGE("Item No.","No.");
      if not ItemJnlLine.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text023,TABLECAPTION,"No.",ItemJnlLine.TABLECAPTION);
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ItemJnlLine.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckStdCostWksh (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckStdCostWksh (CurrFieldNo: Integer)
    var
//       StdCostWksh@1001 :
      StdCostWksh: Record 5841;
    begin
      StdCostWksh.RESET;
      StdCostWksh.SETRANGE(Type,StdCostWksh.Type::Item);
      StdCostWksh.SETRANGE("No.","No.");
      if not StdCostWksh.ISEMPTY then
        if CurrFieldNo = 0 then
          ERROR(Text023,TABLECAPTION,"No.",StdCostWksh.TABLECAPTION);
    end;
*/


//     LOCAL procedure CheckReqLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckReqLine (CurrFieldNo: Integer)
    begin
      RequisitionLine.SETCURRENTKEY(Type,"No.");
      RequisitionLine.SETRANGE(Type,RequisitionLine.Type::Item);
      RequisitionLine.SETRANGE("No.","No.");
      if not RequisitionLine.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text023,TABLECAPTION,"No.",RequisitionLine.TABLECAPTION);
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",RequisitionLine.TABLECAPTION);
      end;
    end;
*/


    
//     procedure CheckDocuments (CurrFieldNo@1002 :
    
/*
procedure CheckDocuments (CurrFieldNo: Integer)
    begin
      if "No." = '' then
        exit;

      CheckBOM(CurrFieldNo);
      CheckPurchLine(CurrFieldNo);
      CheckSalesLine(CurrFieldNo);
      CheckProdOrderLine(CurrFieldNo);
      CheckProdOrderCompLine(CurrFieldNo);
      CheckPlanningCompLine(CurrFieldNo);
      CheckTransLine(CurrFieldNo);
      CheckServLine(CurrFieldNo);
      CheckProdBOMLine(CurrFieldNo);
      CheckServContractLine(CurrFieldNo);
      CheckAsmHeader(CurrFieldNo);
      CheckAsmLine(CurrFieldNo);
      CheckJobPlanningLine(CurrFieldNo);

      OnAfterCheckDocuments(Rec,xRec,CurrFieldNo);
    end;
*/


//     LOCAL procedure CheckBOM (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckBOM (CurrFieldNo: Integer)
    begin
      BOMComp.RESET;
      BOMComp.SETCURRENTKEY(Type,"No.");
      BOMComp.SETRANGE(Type,BOMComp.Type::Item);
      BOMComp.SETRANGE("No.","No.");
      if not BOMComp.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text023,TABLECAPTION,"No.",BOMComp.TABLECAPTION);
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",BOMComp.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckPurchLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckPurchLine (CurrFieldNo: Integer)
    var
//       PurchaseLine@1001 :
      PurchaseLine: Record 39;
    begin
      PurchaseLine.SETCURRENTKEY(Type,"No.");
      PurchaseLine.SETRANGE(Type,PurchaseLine.Type::Item);
      PurchaseLine.SETRANGE("No.","No.");
      if PurchaseLine.FINDFIRST then begin
        if CurrFieldNo = 0 then
          ERROR(Text000,TABLECAPTION,"No.",PurchaseLine."Document Type");
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",PurchaseLine.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckSalesLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckSalesLine (CurrFieldNo: Integer)
    var
//       SalesLine@1001 :
      SalesLine: Record 37;
//       IdentityManagement@1002 :
      IdentityManagement: Codeunit 9801;
    begin
      SalesLine.SETCURRENTKEY(Type,"No.");
      SalesLine.SETRANGE(Type,SalesLine.Type::Item);
      SalesLine.SETRANGE("No.","No.");
      if SalesLine.FINDFIRST then begin
        if CurrFieldNo = 0 then begin
          if IdentityManagement.IsInvAppId then
            ERROR(CannotDeleteItemIfSalesDocExistInvoicingErr,TABLECAPTION,Description,
              SalesLine.GetDocumentTypeDescription,SalesLine."Document No.");
          ERROR(CannotDeleteItemIfSalesDocExistErr,TABLECAPTION,"No.",SalesLine."Document Type");
        end;
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",SalesLine.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckProdOrderLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckProdOrderLine (CurrFieldNo: Integer)
    begin
      if ProdOrderExist then begin
        if CurrFieldNo = 0 then
          ERROR(Text002,TABLECAPTION,"No.");
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdOrderLine.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckProdOrderCompLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckProdOrderCompLine (CurrFieldNo: Integer)
    begin
      ProdOrderComp.SETCURRENTKEY(Status,"Item No.");
      ProdOrderComp.SETFILTER(Status,'..%1',ProdOrderComp.Status::Released);
      ProdOrderComp.SETRANGE("Item No.","No.");
      if not ProdOrderComp.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text014,TABLECAPTION,"No.");
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdOrderComp.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckPlanningCompLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckPlanningCompLine (CurrFieldNo: Integer)
    var
//       PlanningComponent@1005 :
      PlanningComponent: Record 99000829;
    begin
      PlanningComponent.SETCURRENTKEY("Item No.","Variant Code","Location Code","Due Date","Planning Line Origin");
      PlanningComponent.SETRANGE("Item No.","No.");
      if not PlanningComponent.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text023,TABLECAPTION,"No.",PlanningComponent.TABLECAPTION);
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",PlanningComponent.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckTransLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckTransLine (CurrFieldNo: Integer)
    begin
      TransLine.SETCURRENTKEY("Item No.");
      TransLine.SETRANGE("Item No.","No.");
      if not TransLine.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text016,TABLECAPTION,"No.");
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",TransLine.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckServLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckServLine (CurrFieldNo: Integer)
    begin
      ServInvLine.RESET;
      ServInvLine.SETCURRENTKEY(Type,"No.");
      ServInvLine.SETRANGE(Type,ServInvLine.Type::Item);
      ServInvLine.SETRANGE("No.","No.");
      if not ServInvLine.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text017,TABLECAPTION,"No.",ServInvLine."Document Type");
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ServInvLine.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckProdBOMLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckProdBOMLine (CurrFieldNo: Integer)
    var
//       ProductionBOMVersion@1001 :
      ProductionBOMVersion: Record 99000779;
    begin
      ProdBOMLine.RESET;
      ProdBOMLine.SETCURRENTKEY(Type,"No.");
      ProdBOMLine.SETRANGE(Type,ProdBOMLine.Type::Item);
      ProdBOMLine.SETRANGE("No.","No.");
      if ProdBOMLine.FIND('-') then begin
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdBOMLine.TABLECAPTION);
        if CurrFieldNo = 0 then
          repeat
            if ProdBOMHeader.GET(ProdBOMLine."Production BOM No.") and
               (ProdBOMHeader.Status = ProdBOMHeader.Status::Certified)
            then
              ERROR(Text004,TABLECAPTION,"No.");
            if ProductionBOMVersion.GET(ProdBOMLine."Production BOM No.",ProdBOMLine."Version Code") and
               (ProductionBOMVersion.Status = ProductionBOMVersion.Status::Certified)
            then
              ERROR(CannotDeleteItemIfProdBOMVersionExistsErr,TABLECAPTION,"No.");
          until ProdBOMLine.NEXT = 0;
      end;
    end;
*/


//     LOCAL procedure CheckServContractLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckServContractLine (CurrFieldNo: Integer)
    begin
      ServiceContractLine.RESET;
      ServiceContractLine.SETRANGE("Item No.","No.");
      if not ServiceContractLine.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text023,TABLECAPTION,"No.",ServiceContractLine.TABLECAPTION);
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ServiceContractLine.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckAsmHeader (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckAsmHeader (CurrFieldNo: Integer)
    var
//       AsmHeader@1004 :
      AsmHeader: Record 900;
    begin
      AsmHeader.SETCURRENTKEY("Document Type","Item No.");
      AsmHeader.SETRANGE("Item No.","No.");
      if not AsmHeader.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text023,TABLECAPTION,"No.",AsmHeader.TABLECAPTION);
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",AsmHeader.TABLECAPTION);
      end;
    end;
*/


//     LOCAL procedure CheckAsmLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckAsmLine (CurrFieldNo: Integer)
    var
//       AsmLine@1003 :
      AsmLine: Record 901;
    begin
      AsmLine.SETCURRENTKEY(Type,"No.");
      AsmLine.SETRANGE(Type,AsmLine.Type::Item);
      AsmLine.SETRANGE("No.","No.");
      if not AsmLine.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text023,TABLECAPTION,"No.",AsmLine.TABLECAPTION);
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",AsmLine.TABLECAPTION);
      end;
    end;
*/


    
    
/*
procedure PreventNegativeInventory () : Boolean;
    var
//       InventorySetup@1000 :
      InventorySetup: Record 313;
    begin
      CASE "Prevent Negative Inventory" OF
        "Prevent Negative Inventory"::Yes:
          exit(TRUE);
        "Prevent Negative Inventory"::No:
          exit(FALSE);
        "Prevent Negative Inventory"::Default:
          begin
            InventorySetup.GET;
            exit(InventorySetup."Prevent Negative Inventory");
          end;
      end;
    end;
*/


//     LOCAL procedure CheckJobPlanningLine (CurrFieldNo@1000 :
    
/*
LOCAL procedure CheckJobPlanningLine (CurrFieldNo: Integer)
    var
//       JobPlanningLine@1001 :
      JobPlanningLine: Record 1003;
    begin
      JobPlanningLine.SETCURRENTKEY(Type,"No.");
      JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::Item);
      JobPlanningLine.SETRANGE("No.","No.");
      if not JobPlanningLine.ISEMPTY then begin
        if CurrFieldNo = 0 then
          ERROR(Text023,TABLECAPTION,"No.",JobPlanningLine.TABLECAPTION);
        if CurrFieldNo = FIELDNO(Type) then
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",JobPlanningLine.TABLECAPTION);
      end;
    end;
*/


    
/*
LOCAL procedure CalcVAT () : Decimal;
    begin
      if "Price Includes VAT" then begin
        VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group");
        CASE VATPostingSetup."VAT Calculation Type" OF
          VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
            VATPostingSetup."VAT+EC %" := 0;
          VATPostingSetup."VAT Calculation Type"::"Sales Tax":
            ERROR(
              Text006,
              VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
              VATPostingSetup."VAT Calculation Type");
        end;
      end else
        CLEAR(VATPostingSetup);

      exit(VATPostingSetup."VAT %" / 100);
    end;
*/


    
    
/*
procedure CalcUnitPriceExclVAT () : Decimal;
    begin
      GetGLSetup;
      if 1 + CalcVAT = 0 then
        exit(0);
      exit(ROUND("Unit Price" / (1 + CalcVAT),GLSetup."Unit-Amount Rounding Precision"));
    end;
*/


    
//     procedure GetItemNo (ItemText@1000 :
    
/*
procedure GetItemNo (ItemText: Text) : Code[20];
    var
//       ItemNo@1001 :
      ItemNo: Text[50];
    begin
      TryGetItemNo(ItemNo,ItemText,TRUE);
      exit(COPYSTR(ItemNo,1,MAXSTRLEN("No.")));
    end;
*/


    
//     procedure TryGetItemNo (var ReturnValue@1007 : Text[50];ItemText@1000 : Text;DefaultCreate@1006 :
    
/*
procedure TryGetItemNo (var ReturnValue: Text[50];ItemText: Text;DefaultCreate: Boolean) : Boolean;
    begin
      exit(TryGetItemNoOpenCard(ReturnValue,ItemText,DefaultCreate,TRUE,TRUE));
    end;
*/


    
//     procedure TryGetItemNoOpenCard (var ReturnValue@1007 : Text;ItemText@1000 : Text;DefaultCreate@1006 : Boolean;ShowItemCard@1008 : Boolean;ShowCreateItemOption@1011 :
    
/*
procedure TryGetItemNoOpenCard (var ReturnValue: Text;ItemText: Text;DefaultCreate: Boolean;ShowItemCard: Boolean;ShowCreateItemOption: Boolean) : Boolean;
    var
//       Item@1001 :
      Item: Record 27;
//       SalesLine@1004 :
      SalesLine: Record 37;
//       FindRecordMgt@1009 :
      FindRecordMgt: Codeunit 703;
//       ItemNo@1002 :
      ItemNo: Code[20];
//       ItemWithoutQuote@1005 :
      ItemWithoutQuote: Text;
//       ItemFilterContains@1003 :
      ItemFilterContains: Text;
//       FoundRecordCount@1010 :
      FoundRecordCount: Integer;
    begin
      ReturnValue := COPYSTR(ItemText,1,MAXSTRLEN(ReturnValue));
      if ItemText = '' then
        exit(DefaultCreate);

      FoundRecordCount := FindRecordMgt.FindRecordByDescription(ReturnValue,SalesLine.Type::Item,ItemText);

      if FoundRecordCount = 1 then
        exit(TRUE);

      ReturnValue := COPYSTR(ItemText,1,MAXSTRLEN(ReturnValue));
      if FoundRecordCount = 0 then begin
        if not DefaultCreate then
          exit(FALSE);

        if not GUIALLOWED then
          ERROR(SelectItemErr);

        if Item.WRITEPERMISSION then
          if ShowCreateItemOption then
            CASE STRMENU(
                   STRSUBSTNO('%1,%2',STRSUBSTNO(CreateNewItemTxt,CONVERTSTR(ItemText,',','.')),SelectItemTxt),1,ItemNotRegisteredTxt)
            OF
              0:
                ERROR('');
              1:
                begin
                  ReturnValue := CreateNewItem(COPYSTR(ItemText,1,MAXSTRLEN(Item.Description)),ShowItemCard);
                  exit(TRUE);
                end;
            end
          else
            exit(FALSE);
      end;

      if not GUIALLOWED then
        ERROR(SelectItemErr);

      if FoundRecordCount > 0 then begin
        ItemWithoutQuote := CONVERTSTR(ItemText,'''','?');
        ItemFilterContains := '''@*' + ItemWithoutQuote + '*''';
        Item.FILTERGROUP(-1);
        Item.SETFILTER("No.",ItemFilterContains);
        Item.SETFILTER(Description,ItemFilterContains);
        Item.SETFILTER("Base Unit of Measure",ItemFilterContains);
      end;

      if ShowItemCard then
        ItemNo := PickItem(Item)
      else begin
        ReturnValue := '';
        exit(TRUE);
      end;

      if ItemNo <> '' then begin
        ReturnValue := ItemNo;
        exit(TRUE);
      end;

      if not DefaultCreate then
        exit(FALSE);
      ERROR('');
    end;
*/


//     LOCAL procedure CreateNewItem (ItemName@1000 : Text[50];ShowItemCard@1001 :
    
/*
LOCAL procedure CreateNewItem (ItemName: Text[50];ShowItemCard: Boolean) : Code[20];
    var
//       Item@1005 :
      Item: Record 27;
//       ItemTemplate@1006 :
      ItemTemplate: Record 1301;
//       ItemCard@1002 :
      ItemCard: Page 30;
    begin
      if not ItemTemplate.NewItemFromTemplate(Item) then
        ERROR(SelectItemErr);

      Item.Description := ItemName;
      Item.MODIFY(TRUE);
      COMMIT;
      if not ShowItemCard then
        exit(Item."No.");
      Item.SETRANGE("No.",Item."No.");
      ItemCard.SETTABLEVIEW(Item);
      if not (ItemCard.RUNMODAL = ACTION::OK) then
        ERROR(SelectItemErr);

      exit(Item."No.");
    end;
*/


    
//     procedure PickItem (var Item@1000 :
    
/*
procedure PickItem (var Item: Record 27) : Code[20];
    var
//       ItemList@1001 :
      ItemList: Page 31;
    begin
      if Item.FILTERGROUP = -1 then
        ItemList.SetTempFilteredItemRec(Item);

      if Item.FINDFIRST then;
      ItemList.SETTABLEVIEW(Item);
      ItemList.SETRECORD(Item);
      ItemList.LOOKUPMODE := TRUE;
      if ItemList.RUNMODAL = ACTION::LookupOK then
        ItemList.GETRECORD(Item)
      else
        CLEAR(Item);

      exit(Item."No.");
    end;
*/


    
/*
LOCAL procedure SetLastDateTimeModified ()
    begin
      "Last DateTime Modified" := CURRENTDATETIME;
      "Last Date Modified" := DT2DATE("Last DateTime Modified");
      "Last Time Modified" := DT2TIME("Last DateTime Modified");
    end;
*/


    
//     procedure SetLastDateTimeFilter (DateFilter@1001 :
    
/*
procedure SetLastDateTimeFilter (DateFilter: DateTime)
    var
//       DotNet_DateTimeOffset@1004 :
      DotNet_DateTimeOffset: Codeunit 3006;
//       SyncDateTimeUtc@1002 :
      SyncDateTimeUtc: DateTime;
//       CurrentFilterGroup@1003 :
      CurrentFilterGroup: Integer;
    begin
      SyncDateTimeUtc := DotNet_DateTimeOffset.ConvertToUtcDateTime(DateFilter);
      CurrentFilterGroup := FILTERGROUP;
      SETFILTER("Last Date Modified",'>=%1',DT2DATE(SyncDateTimeUtc));
      FILTERGROUP(-1);
      SETFILTER("Last Date Modified",'>%1',DT2DATE(SyncDateTimeUtc));
      SETFILTER("Last Time Modified",'>%1',DT2TIME(SyncDateTimeUtc));
      FILTERGROUP(CurrentFilterGroup);
    end;
*/


    
    
/*
procedure UpdateReplenishmentSystem () : Boolean;
    begin
      CALCFIELDS("Assembly BOM");

      if "Assembly BOM" then begin
        if not ("Replenishment System" IN ["Replenishment System"::Assembly,"Replenishment System"::"Prod. Order"])
        then begin
          VALIDATE("Replenishment System","Replenishment System"::Assembly);
          exit(TRUE);
        end
      end else
        if  "Replenishment System" = "Replenishment System"::Assembly then begin
          if "Assembly Policy" <> "Assembly Policy"::"Assemble-to-Order" then begin
            VALIDATE("Replenishment System","Replenishment System"::Purchase);
            exit(TRUE);
          end
        end
    end;
*/


    
    
/*
procedure UpdateUnitOfMeasureId ()
    var
//       UnitOfMeasure@1000 :
      UnitOfMeasure: Record 204;
    begin
      if "Base Unit of Measure" = '' then begin
        CLEAR("Unit of Measure Id");
        exit;
      end;

      if not UnitOfMeasure.GET("Base Unit of Measure") then
        exit;

      "Unit of Measure Id" := UnitOfMeasure.Id;
    end;
*/


    
    
/*
procedure UpdateItemCategoryId ()
    var
//       ItemCategory@1000 :
      ItemCategory: Record 5722;
//       GraphMgtGeneralTools@1001 :
      GraphMgtGeneralTools: Codeunit 5465;
    begin
      if ISTEMPORARY then
        exit;

      if not GraphMgtGeneralTools.IsApiEnabled then
        exit;

      if "Item Category Code" = '' then begin
        CLEAR("Item Category Id");
        exit;
      end;

      if not ItemCategory.GET("Item Category Code") then
        exit;

      "Item Category Id" := ItemCategory.Id;
    end;
*/


    
    
/*
procedure UpdateTaxGroupId ()
    var
//       TaxGroup@1000 :
      TaxGroup: Record 321;
    begin
      if "Tax Group Code" = '' then begin
        CLEAR("Tax Group Id");
        exit;
      end;

      if not TaxGroup.GET("Tax Group Code") then
        exit;

      "Tax Group Id" := TaxGroup.Id;
    end;
*/


    
/*
LOCAL procedure UpdateUnitOfMeasureCode ()
    var
//       UnitOfMeasure@1001 :
      UnitOfMeasure: Record 204;
    begin
      if not ISNULLGUID("Unit of Measure Id") then begin
        UnitOfMeasure.SETRANGE(Id,"Unit of Measure Id");
        UnitOfMeasure.FINDFIRST;
      end;

      "Base Unit of Measure" := UnitOfMeasure.Code;
    end;
*/


    
/*
LOCAL procedure UpdateTaxGroupCode ()
    var
//       TaxGroup@1001 :
      TaxGroup: Record 321;
    begin
      if not ISNULLGUID("Tax Group Id") then begin
        TaxGroup.SETRANGE(Id,"Tax Group Id");
        TaxGroup.FINDFIRST;
      end;

      VALIDATE("Tax Group Code",TaxGroup.Code);
    end;
*/


    
/*
LOCAL procedure UpdateItemCategoryCode ()
    var
//       ItemCategory@1000 :
      ItemCategory: Record 5722;
    begin
      if ISNULLGUID("Item Category Id") then begin
        ItemCategory.SETRANGE(Id,"Item Category Id");
        ItemCategory.FINDFIRST;
      end;

      "Item Category Code" := ItemCategory.Code;
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

      UpdateUnitOfMeasureId;
      UpdateTaxGroupId;
      UpdateItemCategoryId;
    end;
*/


    
//     procedure GetReferencedIds (var TempField@1000 :
    
/*
procedure GetReferencedIds (var TempField: Record 2000000041 TEMPORARY)
    var
//       DataTypeManagement@1001 :
      DataTypeManagement: Codeunit 701;
    begin
      DataTypeManagement.InsertFieldToBuffer(TempField,DATABASE::Item,FIELDNO("Unit of Measure Id"));
      DataTypeManagement.InsertFieldToBuffer(TempField,DATABASE::Item,FIELDNO("Tax Group Id"));
    end;
*/


    
/*
procedure IsServiceType () : Boolean;
    begin
      exit(Type = Type::Service);
    end;
*/


    
/*
procedure IsNonInventoriableType () : Boolean;
    begin
      exit(Type IN [Type::"Non-Inventory",Type::Service]);
    end;
*/


    
/*
procedure IsInventoriableType () : Boolean;
    begin
      exit(not IsNonInventoriableType);
    end;
*/


    
//     LOCAL procedure OnAfterCheckDocuments (var Item@1000 : Record 27;var xItem@1001 : Record 27;var CurrentFieldNo@1002 :
    
/*
LOCAL procedure OnAfterCheckDocuments (var Item: Record 27;var xItem: Record 27;var CurrentFieldNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterDeleteRelatedData (Item@1000 :
    
/*
LOCAL procedure OnAfterDeleteRelatedData (Item: Record 27)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeValidateStandardCost (var Item@1000 : Record 27;xItem@1001 : Record 27;FieldNo@1002 : Integer;var IsHandled@1003 :
    
/*
LOCAL procedure OnBeforeValidateStandardCost (var Item: Record 27;xItem: Record 27;FieldNo: Integer;var IsHandled: Boolean)
    begin
    end;
*/


    
    
/*
procedure ExistsItemLedgerEntry () : Boolean;
    var
//       ItemLedgEntry@1000 :
      ItemLedgEntry: Record 32;
    begin
      ItemLedgEntry.RESET;
      ItemLedgEntry.SETCURRENTKEY("Item No.");
      ItemLedgEntry.SETRANGE("Item No.","No.");
      exit(not ItemLedgEntry.ISEMPTY);
    end;

    /*begin
    //{
//      // EPV 15/06/22 nuevo campo
//                                  7207508 QB Main Loc. Purch. Average Pr
//      BS::19831 CSM 30/10/23 Í Bolsas de contrataci¢n en proy.  New Field 50000.
//    }
    end.
  */
}




