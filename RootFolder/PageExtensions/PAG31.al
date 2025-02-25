pageextension 50171 MyExtension31 extends 31//27
{
layout
{
addafter("Description")
{
    field("QB_Description2";rec."Description 2")
    {
        
}
} addafter("Default Deferral Template Code")
{
    field("QB Plant Item";rec."QB Plant Item")
    {
        
                ApplicationArea=Basic,Suite;
}
    field("QB Main Location Cost";rec."QB Main Location Cost")
    {
        
                ApplicationArea=Basic,Suite;
                Visible=seeCeded ;
}
    field("QB Main Loc. Purch. Average Pr";rec."QB Main Loc. Purch. Average Pr")
    {
        
                ApplicationArea=Basic,Suite;
                Visible=seeCeded ;
}
}

}

actions
{
addfirst("Processing")
{group("Action1100286003")
{
        
                      CaptionML=ESP='Almac‚n';
    action("Ceded Items")
    {
        CaptionML=ENU='Ceded',ESP='Prestados';
                      RunObject=Page 7207013;
                      RunPageView=SORTING("Item No.");
RunPageLink="Item No."=field("No.");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Loaners;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
}
    action("PrintCededItems")
    {
        
                      CaptionML=ENU='Print Ceded Items Report',ESP='Informe Recepciones y  Salidas a Obra';
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
                      PromotedIsBig=true;
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
    action("Action1100286000")
    {
        CaptionML=ESP='Informe Almacen/Obras';
                      // RunObject=Report 7207367;
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=PrintReport;
                      PromotedCategory=Process;
}
}
} addafter("Items b&y Location")
{
    action("Action1100286006")
    {
        AccessByPermission=TableData 14=R;
                      CaptionML=ENU='Items b&y Location',ESP='Disponibilidad prestados';
                      ToolTipML=ENU='Show a list of items grouped by location.',ESP='Muestra una lista de productos agrupados por ubicaci¢n.';
                      ApplicationArea=Location;
                      Visible=seeCeded;
                      Image=ItemAvailbyLoc;
                      
                                trigger OnAction()    BEGIN
                                 PAGE.RUN(PAGE::"QB Items by Location",Rec);
                               END;


}
} addafter("Warehouse")
{
group("Action1100286008")
{
        
                      CaptionML=ESP='Almac‚n Central';
    action("Action1100286007")
    {
        CaptionML=ESP='C lculo de precio medio compra';
                      Image=CalculateCost;
                      
                                trigger OnAction()    VAR
                                 cduSuscripcionesAlm : Codeunit 7206910;
                                 rlItem : Record 27;
                                 vfiltros : Text;
                               BEGIN
                                 //Q17138 15-06-2022 EPV.BEGIN
                                 //CurrPage.SETSELECTIONFILTER(rlItem);
                                 CLEAR(rlItem);
                                 rlItem.COPYFILTERS(Rec);
                                 IF rlItem.FINDSET THEN
                                   REPEAT
                                     rlItem."QB Main Loc. Purch. Average Pr" := cduSuscripcionesAlm.CalcPurchAveragePrice(rlItem."No.");
                                     rlItem.MODIFY;
                                   UNTIL rlItem.NEXT=0;
                                 //Q17138 15-06-2022 EPV.END
                               END;


}
}
}

}

//trigger
trigger OnOpenPage()    VAR
              //    SocialListeningSetup : Record 870;
                //  CRMIntegrationManagement : Codeunit 5330;
                //  ClientTypeManagement : Codeunit 4;
               BEGIN
              //    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
              //    WITH SocialListeningSetup DO
              //      SocialListeningSetupVisible := Rec.GET AND "Show on Customers" AND "Accept License Agreement" AND ("Solution ID" <> '');
              //    IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled;
              //    SetWorkflowManagementEnabledState;
              //    IsOnPhone := ClientTypeManagement.IsClientType(CLIENTTYPE::Phone);

                 //JAV 16/11/21: - QB 1.09.26 Control de cedidos visible
                 QuoBuildingSetup.GET;
                 seeCeded := QuoBuildingSetup."Ceded Control";
               END;


//trigger

var
      TempFilterItemAttributesBuffer : Record 7506 TEMPORARY ;
      TempItemFilteredFromAttributes : Record 27 TEMPORARY ;
      TempItemFilteredFromPickItem : Record 27 TEMPORARY ;
      ApplicationAreaMgmtFacade : Codeunit 9179;
      CalculateStdCost : Codeunit 5812;
      ItemAvailFormsMgt : Codeunit 353;
      ApprovalsMgmt : Codeunit 1535;
      ClientTypeManagement : Codeunit 50192;
      SkilledResourceList : Page 6023;
      IsFoundationEnabled : Boolean;
      SocialListeningSetupVisible : Boolean ;
      SocialListeningVisible : Boolean ;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      OpenApprovalEntriesExist : Boolean;
      EnabledApprovalWorkflowsExist : Boolean;
      CanCancelApprovalForRecord : Boolean;
      IsOnPhone : Boolean;
      RunOnTempRec : Boolean;
      EventFilter : Text;
      PowerBIVisible : Boolean;
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      IsNonInventoriable : Boolean ;
      IsInventoriable : Boolean ;
      RunOnPickItem : Boolean;
      "--------------------------------- QB" : Integer;
      QuoBuildingSetup : Record 7207278;
      seeCeded : Boolean;

    

//procedure
//procedure SelectActiveItems() : Text;
//    var
//      Item : Record 27;
//    begin
//      exit(SelectInItemList(Item));
//    end;
//
//    //[External]
//procedure SelectActiveItemsForSale() : Text;
//    var
//      Item : Record 27;
//    begin
//      Item.SETRANGE("Sales Blocked",FALSE);
//      exit(SelectInItemList(Item));
//    end;
//
//    //[External]
//procedure SelectActiveItemsForPurchase() : Text;
//    var
//      Item : Record 27;
//    begin
//      Item.SETRANGE("Purchasing Blocked",FALSE);
//      exit(SelectInItemList(Item));
//    end;
//Local procedure SelectInItemList(var Item : Record 27) : Text;
//    var
//      ItemListPage : Page 31;
//    begin
//      Item.SETRANGE("Blocked",FALSE);
//      ItemListPage.SETTABLEVIEW(Item);
//      ItemListPage.LOOKUPMODE(TRUE);
//      if ( ItemListPage.RUNMODAL = ACTION::LookupOK  )then
//        exit(ItemListPage.GetSelectionFilter);
//    end;
//
//    //[External]
//procedure GetSelectionFilter() : Text;
//    var
//      Item : Record 27;
//      SelectionFilterManagement : Codeunit 46;
//    begin
//      CurrPage.SETSELECTIONFILTER(Item);
//      exit(SelectionFilterManagement.GetSelectionFilterForItem(Item));
//    end;
//
//    //[External]
//procedure SetSelection(var Item : Record 27);
//    begin
//      CurrPage.SETSELECTIONFILTER(Item);
//    end;
//Local procedure EnableControls();
//    begin
//      IsNonInventoriable := rec.IsNonInventoriableType;
//      IsInventoriable := rec.IsInventoriableType;
//    end;
//Local procedure SetWorkflowManagementEnabledState();
//    var
//      WorkflowManagement : Codeunit 1501;
//      WorkflowEventHandling : Codeunit 1520;
//    begin
//      EventFilter := WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode + '|' +
//        WorkflowEventHandling.RunWorkflowOnItemChangedCode;
//
//      EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Item,EventFilter);
//    end;
//Local procedure ClearAttributesFilter();
//    begin
//      Rec.CLEARMARKS;
//      Rec.MARKEDONLY(FALSE);
//      TempFilterItemAttributesBuffer.RESET;
//      TempFilterItemAttributesBuffer.DELETEALL;
//      Rec.FILTERGROUP(0);
//      Rec.SETRANGE("No.");
//    end;
//
//    //[External]
//procedure SetTempFilteredItemRec(var Item : Record 27);
//    begin
//      TempItemFilteredFromAttributes.RESET;
//      TempItemFilteredFromAttributes.DELETEALL;
//
//      TempItemFilteredFromPickItem.RESET;
//      TempItemFilteredFromPickItem.DELETEALL;
//
//      RunOnTempRec := TRUE;
//      RunOnPickItem := TRUE;
//
//      if ( Item.FINDSET  )then
//        repeat
//          TempItemFilteredFromAttributes := Item;
//          TempItemFilteredFromAttributes.INSERT;
//          TempItemFilteredFromPickItem := Item;
//          TempItemFilteredFromPickItem.INSERT;
//        until Item.NEXT = 0;
//    end;
//Local procedure RestoreTempItemFilteredFromAttributes();
//    begin
//      if ( not RunOnPickItem  )then
//        exit;
//
//      TempItemFilteredFromAttributes.RESET;
//      TempItemFilteredFromAttributes.DELETEALL;
//      RunOnTempRec := TRUE;
//
//      if ( TempItemFilteredFromPickItem.FINDSET  )then
//        repeat
//          TempItemFilteredFromAttributes := TempItemFilteredFromPickItem;
//          TempItemFilteredFromAttributes.INSERT;
//        until TempItemFilteredFromPickItem.NEXT = 0;
//    end;

//procedure
}

