pageextension 50170 MyExtension30 extends 30//27
{
layout
{
addafter("Item")
{
group("QB_QuoBuilding")
{
        
                CaptionML=ENU='rec."Inventory"',ESP='QB_QuoBuilding';
    field("QB_DataMissedMessage";rec."QB Data Missed Message")
    {
        
                Visible=QB_MandatoryFields ;
}
    field("QB_Created by PRESTO s/n";rec."QB Created by PRESTO")
    {
        
}
    field("QB Proformable";rec."QB Proformable")
    {
        
                ToolTipML=ESP='Indica si el producto se puede incluir en una proforma o no lo es desde un pedido de compra';
}
    field("QB_ActivityCode";rec."QB Activity Code")
    {
        
}
    field("QB_Cod. C.A. Direct Costs";rec."QB Cod. C.A. Direct Costs")
    {
        
}
    field("QB_AverageCostLCY";"QB_AverageCostLCY")
    {
        
                CaptionML=ENU='Average Cost (LCY)',ESP='Coste promedio (DL)';
                Editable=FALSE ;
}
    field("QB_Rent Element Code";rec."QB Rent Element Code")
    {
        
}
    field("QB_Rentable S/N";rec."QB Rentable")
    {
        
}
    field("QB Auxiliary Location";rec."QB Auxiliary Location")
    {
        
}
group("AlmacenCentral")
{
        
                CaptionML=ENU='Almac‚n Central';
                Visible=seeCeded;
    field("QB Allows Deposit";rec."QB Allows Deposit")
    {
        
                Visible=seeCeded ;
}
    field("QB Allow Ceded";rec."QB Allow Ceded")
    {
        
                Visible=seeCeded ;
}
    field("QB Qty. Ceded";rec."QB Qty. Ceded")
    {
        
                Visible=seeCeded ;
}
    field("QB Plant Item";rec."QB Plant Item")
    {
        
                Visible=seeCeded ;
}
    field("QB Main Location";rec."QB Main Location")
    {
        
                Visible=seeCeded ;
}
    field("QB Main Location Cost";rec."QB Main Location Cost")
    {
        
                DecimalPlaces=0:6;
                Visible=seeCeded ;
}
    field("QB Main Loc. Purch. Average Pr";rec."QB Main Loc. Purch. Average Pr")
    {
        
                Visible=seeCeded ;
}
}
}
    part("QB_DataSynchronization";7174395)
    {
        
                SubPageView=SORTING("Table","Code 1","With Company");SubPageLink="Table"=CONST(27), "Code 1"=field("No.");
                Visible=verMasterData;
                UpdatePropagation=Both ;
}
// group("InventoryGrp")
// {
        
//                 CaptionML=ENU='Inventory',ESP='Inventario';
//                 Visible=IsInventoriable;
// }
} addafter("Description")
{
    field("QB_Description2";rec."Description 2")
    {
        
}
}


modify("Blocked")
{
Enabled=QB_BlockedEnabled ;


}

}

actions
{
addafter("ApprovalEntries")
{
    action("PrintCededItems")
    {
        
                      CaptionML=ENU='Print Ceded Items Report',ESP='Imprimir informe productos cedidos';
                      Promoted=true;
                      Image=PrintReport;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                //  ItemsCeded : Report 7207450;
                               BEGIN
                                //  ItemsCeded.SetItemNo(Rec."No.");
                                //  ItemsCeded.RUN;
                               END;


}
    action("PrintUnitCost")
    {
        
                      CaptionML=ENU='Print Unit Cost Report',ESP='Imprimir informe precio unitario';
                      Promoted=true;
                      Image=PrintReport;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 Item : Record 27;
                               BEGIN
                                 Item.RESET;
                                 Item.SETRANGE("No.", Rec."No.");
                                 Item.FINDFIRST;

                                //  REPORT.RUN(REPORT::"QB Item Unit Cost", TRUE, FALSE, Item);
                               END;


}
} addafter("ItemsByLocation")
{
    action("Ceded Disponibility")
    {
        
                      AccessByPermission=TableData 14=R;
                      CaptionML=ENU='Items b&y Location',ESP='Disponibilidad prestados';
                      ToolTipML=ENU='Show a list of items grouped by location.',ESP='Muestra una lista de productos agrupados por ubicaci¢n.';
                      ApplicationArea=Advanced;
                      Visible=seeCeded;
                      Image=ItemAvailbyLoc;
                      
                                trigger OnAction()    BEGIN
                                 PAGE.RUN(PAGE::"QB Items by Location",Rec);
                               END;


}
} addafter("Stockkeepin&g Units")
{
group("Action1100286007")
{
        
                      CaptionML=ESP='Almac‚n Central';
    action("Action1100286008")
    {
        CaptionML=ESP='C lculo de precio medio compra';
                      Image=CalculateCost;
                      
                                trigger OnAction()    VAR
                                 cduSuscripcionesAlm : Codeunit 7206910;
                               BEGIN
                                 //Q17138 15-06-2022 EPV.BEGIN
                                 rec."QB Main Loc. Purch. Average Pr" := cduSuscripcionesAlm.CalcPurchAveragePrice(rec."No.");
                                 Rec.MODIFY;
                                 //Q17138 15-06-2022 EPV.END
                               END;


}
}
}

}

//trigger
trigger OnOpenPage()    VAR
                 PermissionManager : Codeunit 9002;
                 PermissionManager1: Codeunit 51256;

               BEGIN
                 IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled;
                 EnableControls;
                 SetNoFieldVisible;
                 IsSaaS := PermissionManager1.SoftwareAsAService;

                 //QB
                 //JAV 02/04/20: - Campo visible si faltan datos
                 rRef.GETTABLE(Rec);
                 QB_MandatoryFields := QBTablesSetup.AsMandatoryFields(rRef.NUMBER);

                 //JAV 01/03/21: - QB 1.08.19 Se pasan funciones de QBSetup a Fucntions QB
                 //JAV 14/02/22: - QM 1.00.00 Se pasan las funciones de MasterData a su propia CU
                 verMasterData := QMMasterDataManagement.SetMasterDataVisible(DATABASE::Vendor);

                 //JAV 16/11/21: - QB 1.09.26 Control de cedidos visible
                 QuoBuildingSetup.GET;
                 seeCeded := QuoBuildingSetup."Ceded Control";
               END;
trigger OnAfterGetRecord()    BEGIN
                       //QB
                       QB_ItemCostManagement.CalculateAverageCost(Rec, QB_AverageCostLCY, QB_AverageCostACY);
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           CRMCouplingManagement : Codeunit 5331;
                           WorkflowManagement : Codeunit 1501;
                           WorkflowEventHandling : Codeunit 1520;
                           WorkflowWebhookManagement : Codeunit 1543;
                         BEGIN
                          //  CreateItemFromTemplate;
                          //  EnableControls;
                          //  IF CRMIntegrationEnabled THEN BEGIN
                          //    CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RECORDID);
                          //    IF rec."No." <> xRec."No." THEN
                          //      CRMIntegrationManagement.SendResultNotification(Rec);
                          //  END;
                          //  OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
                          //  OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
                          //  ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);

                          //  WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

                          //  EventFilter := WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode + '|' +
                          //    WorkflowEventHandling.RunWorkflowOnItemChangedCode;

                          //  EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Item,EventFilter);

                          //  CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData(rec."No.");

                           //QB
                           //JAV 02/04/20: - Bloqueo no puede ser editable si faltan datos
                           QB_BlockedEnabled  := NOT rec."QB Data Missed";
                         END;


//trigger

var
      ApplicationAreaMgmtFacade : Codeunit 9179;
      CalculateStdCost : Codeunit 5812;
      CRMIntegrationManagement : Codeunit 5330;
      ItemAvailFormsMgt : Codeunit 353;
      ApprovalsMgmt : Codeunit 1535;
      SkilledResourceList : Page 6023;
      IsFoundationEnabled : Boolean;
      ShowStockoutWarningDefaultYes : Boolean;
      ShowStockoutWarningDefaultNo : Boolean;
      ShowPreventNegInventoryDefaultYes : Boolean;
      ShowPreventNegInventoryDefaultNo : Boolean;
      TimeBucketEnable : Boolean ;
      SafetyLeadTimeEnable : Boolean ;
      SafetyStockQtyEnable : Boolean ;
      ReorderPointEnable : Boolean ;
      ReorderQtyEnable : Boolean ;
      MaximumInventoryEnable : Boolean ;
      MinimumOrderQtyEnable : Boolean ;
      MaximumOrderQtyEnable : Boolean ;
      OrderMultipleEnable : Boolean ;
      IncludeInventoryEnable : Boolean ;
      ReschedulingPeriodEnable : Boolean ;
      LotAccumulationPeriodEnable : Boolean ;
      DampenerPeriodEnable : Boolean ;
      DampenerQtyEnable : Boolean ;
      OverflowLevelEnable : Boolean ;
      StandardCostEnable : Boolean ;
      UnitCostEnable : Boolean ;
      SocialListeningSetupVisible : Boolean ;
      SocialListeningVisible : Boolean ;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      OpenApprovalEntriesExistCurrUser : Boolean;
      OpenApprovalEntriesExist : Boolean;
      ShowWorkflowStatus : Boolean;
      UnitCostEditable : Boolean ;
      ProfitEditable : Boolean;
      PriceEditable : Boolean;
      SpecialPricesAndDiscountsTxt : Text;
      CreateNewTxt : TextConst ENU='Create New...',ESP='Crear nuevo...';
      ViewExistingTxt : TextConst ENU='View Existing Prices and Discounts...',ESP='Permite ver los descuentos y precios existentes...';
      CreateNewSpecialPriceTxt : TextConst ENU='Create New Special Price...',ESP='Crear nuevo precio especial...';
      CreateNewSpecialDiscountTxt : TextConst ENU='Create New Special Discount...',ESP='Crear nuevo descuento especial...';
      SpecialPurchPricesAndDiscountsTxt : Text;
      EnabledApprovalWorkflowsExist : Boolean;
      EventFilter : Text;
      NoFieldVisible : Boolean;
      NewMode : Boolean;
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      IsSaaS : Boolean;
      IsService : Boolean;
      IsNonInventoriable : Boolean;
      IsInventoriable : Boolean;
      "--------------------------- QB" : Integer;
      QB_ItemCostManagement : Codeunit 5804;
      QB_AverageCostLCY : Decimal;
      QB_AverageCostACY : Decimal;
      QB_MandatoryFields : Boolean;
      rRef : RecordRef;
      QBTablesSetup : Record 7206903;
      QB_BlockedEnabled : Boolean;
      verMasterData : Boolean;
      QMMasterDataManagement : Codeunit 7174368;
      FunctionQB : Codeunit 7207272;
      seeCeded : Boolean;
      QuoBuildingSetup : Record 7207278;

    
    

//procedure
//Local procedure EnableControls();
//    var
//      ItemLedgerEntry : Record 32;
//      CRMIntegrationManagement : Codeunit 5330;
//    begin
//      IsService := rec.IsServiceType;
//      IsNonInventoriable := rec.IsNonInventoriableType;
//      IsInventoriable := rec.IsInventoriableType;
//
//      if ( rec."Type" = rec."Type"::"Inventory"  )then begin
//        ItemLedgerEntry.SETRANGE("Item No.",rec."No.");
//        UnitCostEditable := ItemLedgerEntry.ISEMPTY;
//      end ELSE
//        UnitCostEditable := TRUE;
//
//      ProfitEditable := rec."Price/Profit Calculation" <> rec."Price/Profit Calculation"::"Profit=Price-Cost";
//      PriceEditable := rec."Price/Profit Calculation" <> rec."Price/Profit Calculation"::"Price=Cost+Profit";
//
//      EnablePlanningControls;
//      EnableCostingControls;
//
//      EnableShowStockOutWarning;
//
//      SetSocialListeningFactboxVisibility;
//      EnableShowShowEnforcePositivInventory;
//      CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
//
//      UpdateSpecialPricesAndDiscountsTxt;
//    end;
//Local procedure OnNewRec();
//    var
//      DocumentNoVisibility : Codeunit 1400;
//    begin
//      if ( GUIALLOWED  )then begin
//        EnableControls;
//        if ( rec."No." = ''  )then
//          if ( DocumentNoVisibility.ItemNoSeriesIsDefault  )then
//            NewMode := TRUE;
//      end;
//    end;
//Local procedure EnableShowStockOutWarning();
//    var
//      SalesSetup : Record 311;
//    begin
//      if ( rec.IsNonInventoriableType  )then
//        rec."Stockout Warning" := rec."Stockout Warning"::No;
//
//      SalesSetup.GET;
//      ShowStockoutWarningDefaultYes := SalesSetup."Stockout Warning";
//      ShowStockoutWarningDefaultNo := not ShowStockoutWarningDefaultYes;
//
//      EnableShowShowEnforcePositivInventory;
//    end;
//Local procedure InsertItemUnitOfMeasure();
//    var
//      ItemUnitOfMeasure : Record 5404;
//    begin
//      if ( rec."Base Unit of Measure" <> ''  )then begin
//        ItemUnitOfMeasure.INIT;
//        ItemUnitOfMeasure."Item No." := rec."No.";
//        ItemUnitOfMeasure.VALIDATE(Code,rec."Base Unit of Measure");
//        ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
//        ItemUnitOfMeasure.INSERT;
//      end;
//    end;
//Local procedure EnableShowShowEnforcePositivInventory();
//    var
//      InventorySetup : Record 313;
//    begin
//      InventorySetup.GET;
//      ShowPreventNegInventoryDefaultYes := InventorySetup."Prevent Negative Inventory";
//      ShowPreventNegInventoryDefaultNo := not ShowPreventNegInventoryDefaultYes;
//    end;
//Local procedure EnablePlanningControls();
//    var
//      PlanningGetParam : Codeunit 99000855;
//      TimeBucketEnabled : Boolean;
//      SafetyLeadTimeEnabled : Boolean;
//      SafetyStockQtyEnabled : Boolean;
//      ReorderPointEnabled : Boolean;
//      ReorderQtyEnabled : Boolean;
//      MaximumInventoryEnabled : Boolean;
//      MinimumOrderQtyEnabled : Boolean;
//      MaximumOrderQtyEnabled : Boolean;
//      OrderMultipleEnabled : Boolean;
//      IncludeInventoryEnabled : Boolean;
//      ReschedulingPeriodEnabled : Boolean;
//      LotAccumulationPeriodEnabled : Boolean;
//      DampenerPeriodEnabled : Boolean;
//      DampenerQtyEnabled : Boolean;
//      OverflowLevelEnabled : Boolean;
//    begin
//      PlanningGetParam.SetUpPlanningControls(rec."Reordering Policy",rec."Include Inventory",
//        TimeBucketEnabled,SafetyLeadTimeEnabled,SafetyStockQtyEnabled,
//        ReorderPointEnabled,ReorderQtyEnabled,MaximumInventoryEnabled,
//        MinimumOrderQtyEnabled,MaximumOrderQtyEnabled,OrderMultipleEnabled,IncludeInventoryEnabled,
//        ReschedulingPeriodEnabled,LotAccumulationPeriodEnabled,
//        DampenerPeriodEnabled,DampenerQtyEnabled,OverflowLevelEnabled);
//
//      TimeBucketEnable := TimeBucketEnabled;
//      SafetyLeadTimeEnable := SafetyLeadTimeEnabled;
//      SafetyStockQtyEnable := SafetyStockQtyEnabled;
//      ReorderPointEnable := ReorderPointEnabled;
//      ReorderQtyEnable := ReorderQtyEnabled;
//      MaximumInventoryEnable := MaximumInventoryEnabled;
//      MinimumOrderQtyEnable := MinimumOrderQtyEnabled;
//      MaximumOrderQtyEnable := MaximumOrderQtyEnabled;
//      OrderMultipleEnable := OrderMultipleEnabled;
//      IncludeInventoryEnable := IncludeInventoryEnabled;
//      ReschedulingPeriodEnable := ReschedulingPeriodEnabled;
//      LotAccumulationPeriodEnable := LotAccumulationPeriodEnabled;
//      DampenerPeriodEnable := DampenerPeriodEnabled;
//      DampenerQtyEnable := DampenerQtyEnabled;
//      OverflowLevelEnable := OverflowLevelEnabled;
//    end;
//Local procedure EnableCostingControls();
//    begin
//      StandardCostEnable := rec."Costing Method" = rec."Costing Method"::Standard;
//      UnitCostEnable := rec."Costing Method" <> rec."Costing Method"::Standard;
//    end;
//Local procedure SetSocialListeningFactboxVisibility();
//    var
//      SocialListeningMgt : Codeunit 871;
//    begin
//      SocialListeningMgt.GetItemFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
//    end;
//Local procedure InitControls();
//    begin
//      UnitCostEnable := TRUE;
//      StandardCostEnable := TRUE;
//      OverflowLevelEnable := TRUE;
//      DampenerQtyEnable := TRUE;
//      DampenerPeriodEnable := TRUE;
//      LotAccumulationPeriodEnable := TRUE;
//      ReschedulingPeriodEnable := TRUE;
//      IncludeInventoryEnable := TRUE;
//      OrderMultipleEnable := TRUE;
//      MaximumOrderQtyEnable := TRUE;
//      MinimumOrderQtyEnable := TRUE;
//      MaximumInventoryEnable := TRUE;
//      ReorderQtyEnable := TRUE;
//      ReorderPointEnable := TRUE;
//      SafetyStockQtyEnable := TRUE;
//      SafetyLeadTimeEnable := TRUE;
//      TimeBucketEnable := TRUE;
//      rec."Costing Method" := rec."Costing Method"::FIFO;
//      UnitCostEditable := TRUE;
//    end;
//Local procedure UpdateSpecialPricesAndDiscountsTxt();
//    var
//      TempSalesPriceAndLineDiscBuff : Record 1304 TEMPORARY ;
//      TempPurchPriceLineDiscBuff : Record 1315 TEMPORARY ;
//    begin
//      SpecialPricesAndDiscountsTxt := CreateNewTxt;
//      if ( TempSalesPriceAndLineDiscBuff.ItemHasLines(Rec)  )then
//        SpecialPricesAndDiscountsTxt := ViewExistingTxt;
//
//      SpecialPurchPricesAndDiscountsTxt := CreateNewTxt;
//      if ( TempPurchPriceLineDiscBuff.ItemHasLines(Rec)  )then
//        SpecialPurchPricesAndDiscountsTxt := ViewExistingTxt;
//    end;
// Local procedure CreateItemFromTemplate();
//    var
//      ItemTemplate : Record "Item Templ.";
//      Item : Record 27;
//      InventorySetup : Record 313;
//      ConfigTemplateHeader : Record 8618;
//    begin
//      OnBeforeCreateItemFromTemplate(NewMode);

//      if ( NewMode  )then begin
//        if ( ItemTemplate.NewItemFromTemplate(Item)  )then begin
//          Rec.COPY(Item);
//          CurrPage.UPDATE;
//        end ELSE begin
//          ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Item);
//          ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
//          if ( not ConfigTemplateHeader.ISEMPTY  )then begin
//            CurrPage.CLOSE;
//            NewMode := FALSE;
//            exit;
//          end;
//        end;

//        if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then
//          if ( (Item."No." = '') and InventorySetup.GET  )then
//            Rec.VALIDATE("Costing Method",InventorySetup."Default Costing Method");

//        NewMode := FALSE;
//      end;
//    end;
Local procedure SetNoFieldVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
   begin
     NoFieldVisible := DocumentNoVisibility.ItemNoIsVisible;
   end;
//
//    [Integration]
Local procedure OnBeforeCreateItemFromTemplate(var NewMode : Boolean);
   begin
   end;

//procedure
}

