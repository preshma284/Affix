pageextension 50233 MyExtension5703 extends 5703//14
{
layout
{
addafter("Use As In-Transit")
{
group("QB_QuoBuilding")
{
        
                CaptionML=ESP='QuoBuilding';
    field("QB_DepartamentCode";rec."QB Departament Code")
    {
        
}
    field("QB_AverageCostPerPurchRcpt";rec."QB Job Location")
    {
        
}
}
group("AlmacenCentral")
{
        
                CaptionML=ENU='Almac‚n Central';
    field("QB Allow Deposit";rec."QB Allow Deposit")
    {
        
}
    field("QB Allow Ceded";rec."QB Allow Ceded")
    {
        
}
    field("QB Main Location";rec."QB Main Location")
    {
        
}
    field("QB View Item Disponibility";rec."QB View Item Disponibility")
    {
        
}
}
}

}

actions
{
addlast("Processing")
{    action("QB_InventoryPostingSetup")
    {
        CaptionML=ENU='&Configuraci¢n Existencias',ESP='&Configuraci¢n Existencias';
                      RunObject=Page 5826;
RunPageLink="Location Code"=field("Code");
                      Promoted=true;
                      Image=Setup;
                      PromotedCategory=Process;
}
}

}

//trigger

//trigger

var
      CustomizedCalEntry : Record 7603;
      CustomizedCalendar : Record 7602;
      CalendarMgmt : Codeunit 7600;
      OutboundWhseHandlingTimeEnable : Boolean ;
      InboundWhseHandlingTimeEnable : Boolean ;
      BaseCalendarCodeEnable : Boolean ;
      BinCapacityPolicyEnable : Boolean ;
      SpecialEquipmentEnable : Boolean ;
      AllowBreakbulkEnable : Boolean ;
      PutAwayTemplateCodeEnable : Boolean ;
      AlwaysCreatePickLineEnable : Boolean ;
      AlwaysCreatePutawayLineEnable : Boolean ;
      CrossDockDueDateCalcEnable : Boolean ;
      OpenShopFloorBinCodeEnable : Boolean ;
      ToProductionBinCodeEnable : Boolean ;
      FromProductionBinCodeEnable : Boolean ;
      ReceiptBinCodeEnable : Boolean ;
      ShipmentBinCodeEnable : Boolean ;
      AdjustmentBinCodeEnable : Boolean ;
      ToAssemblyBinCodeEnable : Boolean ;
      FromAssemblyBinCodeEnable : Boolean ;
      AssemblyShipmentBinCodeEnable : Boolean;
      PickAccordingToFEFOEnable : Boolean ;
      CrossDockBinCodeEnable : Boolean ;
      DirectedPutawayandPickEnable : Boolean ;
      UseADCSEnable : Boolean ;
      DefaultBinSelectionEnable : Boolean ;
      RequirePickEnable : Boolean ;
      RequirePutAwayEnable : Boolean ;
      RequireReceiveEnable : Boolean ;
      RequireShipmentEnable : Boolean ;
      BinMandatoryEnable : Boolean ;
      UsePutAwayWorksheetEnable : Boolean ;
      UseCrossDockingEnable : Boolean ;
      EditInTransit : Boolean ;
      ShowMapLbl : TextConst ENU='Show on Map',ESP='Mostrar en el mapa';

    
    

//procedure
//Local procedure UpdateEnabled();
//    begin
//      RequirePickEnable := not rec."Use As In-Transit" and not rec."Directed Put-away and Pick";
//      RequirePutAwayEnable := not rec."Use As In-Transit" and not rec."Directed Put-away and Pick";
//      RequireReceiveEnable := not rec."Use As In-Transit" and not rec."Directed Put-away and Pick";
//      RequireShipmentEnable := not rec."Use As In-Transit" and not rec."Directed Put-away and Pick";
//      OutboundWhseHandlingTimeEnable := not rec."Use As In-Transit";
//      InboundWhseHandlingTimeEnable := not rec."Use As In-Transit";
//      BinMandatoryEnable := not rec."Use As In-Transit" and not rec."Directed Put-away and Pick";
//      DirectedPutawayandPickEnable := not rec."Use As In-Transit" and rec."Bin Mandatory";
//      BaseCalendarCodeEnable := not rec."Use As In-Transit";
//
//      BinCapacityPolicyEnable := rec."Directed Put-away and Pick";
//      SpecialEquipmentEnable := rec."Directed Put-away and Pick";
//      AllowBreakbulkEnable := rec."Directed Put-away and Pick";
//      PutAwayTemplateCodeEnable := rec."Directed Put-away and Pick";
//      UsePutAwayWorksheetEnable :=
//        rec."Directed Put-away and Pick" or (rec."Require Put-away" and rec."Require Receive" and not rec."Use As In-Transit");
//      AlwaysCreatePickLineEnable := rec."Directed Put-away and Pick";
//      AlwaysCreatePutawayLineEnable := rec."Directed Put-away and Pick";
//
//      UseCrossDockingEnable := not rec."Use As In-Transit" and rec."Require Receive" and rec."Require Shipment" and rec."Require Put-away" and
//        rec."Require Pick";
//      CrossDockDueDateCalcEnable := rec."Use Cross-Docking";
//
//      OpenShopFloorBinCodeEnable := rec."Bin Mandatory";
//      ToProductionBinCodeEnable := rec."Bin Mandatory";
//      FromProductionBinCodeEnable := rec."Bin Mandatory";
//      ReceiptBinCodeEnable := rec."Bin Mandatory" and rec."Require Receive";
//      ShipmentBinCodeEnable := rec."Bin Mandatory" and rec."Require Shipment";
//      AdjustmentBinCodeEnable := rec."Directed Put-away and Pick";
//      CrossDockBinCodeEnable := rec."Bin Mandatory" and rec."Use Cross-Docking";
//      ToAssemblyBinCodeEnable := rec."Bin Mandatory";
//      FromAssemblyBinCodeEnable := rec."Bin Mandatory";
//      AssemblyShipmentBinCodeEnable := rec."Bin Mandatory" and not ShipmentBinCodeEnable;
//      DefaultBinSelectionEnable := rec."Bin Mandatory" and not rec."Directed Put-away and Pick";
//      UseADCSEnable := not rec."Use As In-Transit" and rec."Directed Put-away and Pick";
//      PickAccordingToFEFOEnable := rec."Require Pick" and rec."Bin Mandatory";
//    end;
//Local procedure TransitValidation();
//    var
//      TransferHeader : Record 5740;
//    begin
//      TransferHeader.SETFILTER("In-Transit Code",rec."Code");
//      EditInTransit := TransferHeader.ISEMPTY;
//    end;

//procedure
}

