tableextension 50112 "MyExtension50112" extends "Item Ledger Entry"
{
  
  /*
Permissions=TableData 32 rimd;
*/
    CaptionML=ENU='Item Ledger Entry',ESP='Mov. producto';
    LookupPageID="Item Ledger Entries";
    DrillDownPageID="Item Ledger Entries";
  
  fields
{
    field(7207500;"QB Diverse Entrance";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Diverse Entrance',ESP='Entrada diversa';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';


    }
    field(7207501;"QB Ceded Control";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Ceded Control',ESP='Control cedidos';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';


    }
    field(7207502;"QB Plant Item";Boolean)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Item"."QB Plant Item" WHERE ("No."=FIELD("Item No.")));
                                                   CaptionML=ENU='Plant Item',ESP='Producto planta';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';
                                                   Editable=false;


    }
    field(7207503;"QB Automatic Shipment";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Automatic Shipment',ESP='Albar n autom tico';
                                                   Description='Q15921. CPA. Si viene de un albar n de compra';
                                                   Editable=false;


    }
    field(7207700;"QB Stocks Document Type";Option)
    {
        OptionMembers=" ","Receipt","Invoice","Return Receipt","Credit Memo","Output Shipment";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document Type stocks',ESP='Stock Tipo Documento';
                                                   OptionCaptionML=ENU='" ,Receipt,Invoice,Return Receipt,Credit Memo,Output Shipment No."',ESP='" ,Albaran compra, Factura Compra,Devoluci¢n Compra, Abono Compra,Albar n Salida"';
                                                   
                                                   Description='QB_ST01';


    }
    field(7207701;"QB Stocks Document No";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document No Stocks',ESP='Stock Num. Documento';
                                                   Description='QB_ST01';


    }
    field(7207702;"QB Stocks Output Shipment Line";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document Line Stocks',ESP='Stock Linea Documento';
                                                   Description='QB_ST01';


    }
    field(7207704;"QB Stocks Output Shipment No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Output Shipment No.',ESP='Albar n de Salida';
                                                   Description='QB_ST01';


    }
    field(7207705;"QB Stocks Document Line";Integer)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB_ST01' ;


    }
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Item No.")
  //  {
       /* SumIndexFields="Invoiced Quantity","Quantity";
 */
   // }
   // key(key3;"Item No.","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key4;"Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date")
  //  {
       /* SumIndexFields="Quantity","Invoiced Quantity";
 */
   // }
   // key(key5;"Source Type","Source No.","Item No.","Variant Code","Posting Date")
  //  {
       /* SumIndexFields="Quantity";
 */
   // }
   // key(key6;"Item No.","Open","Variant Code","Positive","Location Code","Posting Date")
  //  {
       /* SumIndexFields="Quantity","Remaining Quantity";
 */
   // }
   // key(No7;"Item No.","Open","Variant Code","Positive","Location Code","Posting Date","Expiration Date","Lot No.","Serial No.")
   // {
       /* SumIndexFields="Quantity","Remaining Quantity";
 */
   // }
   // key(key8;"Country/Region Code","Entry Type","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key9;"Document No.","Document Type","Document Line No.")
  //  {
       /* ;
 */
   // }
   // key(No10;"Item No.","Entry Type","Variant Code","Drop Shipment","Global Dimension 1 Code","Global Dimension 2 Code","Location Code","Posting Date")
   // {
       /* SumIndexFields="Quantity","Invoiced Quantity";
 */
   // }
   // key(No11;"Source Type","Source No.","Global Dimension 1 Code","Global Dimension 2 Code","Item No.","Variant Code","Posting Date")
   // {
       /* SumIndexFields="Quantity";
 */
   // }
   // key(key12;"Item No.","Applied Entry to Adjust")
  //  {
       /* ;
 */
   // }
   // key(key13;"Item No.","Positive","Location Code","Variant Code")
  //  {
       /* ;
 */
   // }
   // key(No14;"Entry Type","Nonstock","Item No.","Posting Date")
   // {
       /* ;
 */
   // }
   // key(No15;"Item No.","Location Code","Open","Variant Code","Unit of Measure Code","Lot No.","Serial No.")
   // {
       /* SumIndexFields="Remaining Quantity";
 */
   // }
   // key(No16;"Lot No.")
   // {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"Entry No.","Description","Item No.","Posting Date","Entry Type","Document No.")
   // {
       // 
   // }
}
  
    var
//       GLSetup@1000 :
      GLSetup: Record 98;
//       ReservEntry@1001 :
      ReservEntry: Record 337;
//       ReservEngineMgt@1002 :
      ReservEngineMgt: Codeunit 99000831;
//       ReserveItemLedgEntry@1003 :
      ReserveItemLedgEntry: Codeunit 99000841;
//       ItemTrackingMgt@1006 :
      ItemTrackingMgt: Codeunit 6500;
//       GLSetupRead@1005 :
      GLSetupRead: Boolean;
//       IsNotOnInventoryErr@1004 :
      IsNotOnInventoryErr: TextConst ENU='You have insufficient quantity of Item %1 on inventory.',ESP='Dispone de una cantidad insuficiente del producto %1 en stock.';

    
/*
LOCAL procedure GetCurrencyCode () : Code[10];
    begin
      if not GLSetupRead then begin
        GLSetup.GET;
        GLSetupRead := TRUE;
      end;
      exit(GLSetup."Additional Reporting Currency");
    end;
*/


    
//     procedure ShowReservationEntries (Modal@1000 :
    
/*
procedure ShowReservationEntries (Modal: Boolean)
    begin
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
      ReserveItemLedgEntry.FilterReservFor(ReservEntry,Rec);
      if Modal then
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      else
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    end;
*/


    
//     procedure SetAppliedEntryToAdjust (AppliedEntryToAdjust@1001 :
    
/*
procedure SetAppliedEntryToAdjust (AppliedEntryToAdjust: Boolean)
    begin
      if "Applied Entry to Adjust" <> AppliedEntryToAdjust then begin
        "Applied Entry to Adjust" := AppliedEntryToAdjust;
        MODIFY;
      end;
    end;
*/


    
    
/*
procedure SetAvgTransCompletelyInvoiced () : Boolean;
    var
//       ItemApplnEntry@1005 :
      ItemApplnEntry: Record 339;
//       InbndItemLedgEntry@1004 :
      InbndItemLedgEntry: Record 32;
//       CompletelyInvoiced@1002 :
      CompletelyInvoiced: Boolean;
    begin
      if "Entry Type" <> "Entry Type"::Transfer then
        exit(FALSE);

      ItemApplnEntry.SETCURRENTKEY("Item Ledger Entry No.");
      ItemApplnEntry.SETRANGE("Item Ledger Entry No.","Entry No.");
      ItemApplnEntry.FIND('-');
      if not "Completely Invoiced" then begin
        CompletelyInvoiced := TRUE;
        repeat
          InbndItemLedgEntry.GET(ItemApplnEntry."Inbound Item Entry No.");
          if not InbndItemLedgEntry."Completely Invoiced" then
            CompletelyInvoiced := FALSE;
        until ItemApplnEntry.NEXT = 0;

        if CompletelyInvoiced then begin
          SetCompletelyInvoiced;
          exit(TRUE);
        end;
      end;
      exit(FALSE);
    end;
*/


    
    
/*
procedure SetCompletelyInvoiced ()
    begin
      if not "Completely Invoiced" then begin
        "Completely Invoiced" := TRUE;
        MODIFY;
      end;
    end;
*/


    
//     procedure AppliedEntryToAdjustExists (ItemNo@1001 :
    
/*
procedure AppliedEntryToAdjustExists (ItemNo: Code[20]) : Boolean;
    begin
      RESET;
      SETCURRENTKEY("Item No.","Applied Entry to Adjust");
      SETRANGE("Item No.",ItemNo);
      SETRANGE("Applied Entry to Adjust",TRUE);
      exit(FIND('-'));
    end;
*/


    
    
/*
procedure IsOutbndConsump () : Boolean;
    begin
      exit(("Entry Type" = "Entry Type"::Consumption) and not Positive);
    end;
*/


    
    
/*
procedure IsExactCostReversingPurchase () : Boolean;
    begin
      exit(
        ("Applies-to Entry" <> 0) and
        ("Entry Type" = "Entry Type"::Purchase) and
        ("Invoiced Quantity" < 0));
    end;
*/


    
    
/*
procedure IsExactCostReversingOutput () : Boolean;
    begin
      exit(
        ("Applies-to Entry" <> 0) and
        ("Entry Type" IN ["Entry Type"::Output,"Entry Type"::"Assembly Output"]) and
        ("Invoiced Quantity" < 0));
    end;
*/


    
    
/*
procedure UpdateItemTracking ()
    var
//       ItemTrackingMgt@1000 :
      ItemTrackingMgt: Codeunit 6500;
    begin
      "Item Tracking" := ItemTrackingMgt.ItemTrackingOption("Lot No.","Serial No.");
    end;
*/


    
    
/*
procedure GetUnitCostLCY () : Decimal;
    begin
      if Quantity = 0 then
        exit("Cost Amount (Actual)");

      exit(ROUND("Cost Amount (Actual)" / Quantity,0.00001));
    end;
*/


    
//     procedure FilterLinesWithItemToPlan (var Item@1000 : Record 27;NetChange@1001 :
    
/*
procedure FilterLinesWithItemToPlan (var Item: Record 27;NetChange: Boolean)
    begin
      RESET;
      SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
      SETRANGE("Item No.",Item."No.");
      SETRANGE(Open,TRUE);
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Global Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
      SETFILTER("Global Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
      if NetChange then
        SETFILTER("Posting Date",Item.GETFILTER("Date Filter"));

      OnAfterFilterLinesWithItemToPlan(Rec,Item);
    end;
*/


    
//     procedure FindLinesWithItemToPlan (var Item@1000 : Record 27;NetChange@1001 :
    
/*
procedure FindLinesWithItemToPlan (var Item: Record 27;NetChange: Boolean) : Boolean;
    begin
      FilterLinesWithItemToPlan(Item,NetChange);
      exit(FIND('-'));
    end;
*/


    
//     procedure LinesWithItemToPlanExist (var Item@1000 : Record 27;NetChange@1001 :
    
/*
procedure LinesWithItemToPlanExist (var Item: Record 27;NetChange: Boolean) : Boolean;
    begin
      FilterLinesWithItemToPlan(Item,NetChange);
      exit(not ISEMPTY);
    end;
*/


    
    
/*
procedure IsOutbndSale () : Boolean;
    begin
      exit(("Entry Type" = "Entry Type"::Sale) and not Positive);
    end;
*/


    
    
/*
procedure ShowDimensions ()
    var
//       DimMgt@1000 :
      DimMgt: Codeunit 408;
    begin
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    end;
*/


    
//     procedure CalculateRemQuantity (ItemLedgEntryNo@1000 : Integer;PostingDate@1001 :
    
/*
procedure CalculateRemQuantity (ItemLedgEntryNo: Integer;PostingDate: Date) : Decimal;
    var
//       ItemApplnEntry@1002 :
      ItemApplnEntry: Record 339;
//       RemQty@1003 :
      RemQty: Decimal;
    begin
      ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.");
      ItemApplnEntry.SETRANGE("Inbound Item Entry No.",ItemLedgEntryNo);
      RemQty := 0;
      if ItemApplnEntry.FINDSET then
        repeat
          if ItemApplnEntry."Posting Date" <= PostingDate then
            RemQty += ItemApplnEntry.Quantity;
        until ItemApplnEntry.NEXT = 0;
      exit(RemQty);
    end;
*/


    
    
/*
procedure VerifyOnInventory ()
    var
//       Item@1000 :
      Item: Record 27;
    begin
      if not Open then
        exit;
      if Quantity >= 0 then
        exit;
      CASE "Entry Type" OF
        "Entry Type"::Consumption,"Entry Type"::"Assembly Consumption","Entry Type"::Transfer:
          ERROR(IsNotOnInventoryErr,"Item No.");
        else begin
          Item.GET("Item No.");
          if Item.PreventNegativeInventory then
            ERROR(IsNotOnInventoryErr,"Item No.");
        end;
      end;
    end;
*/


    
//     procedure CalculateRemInventoryValue (ItemLedgEntryNo@1000 : Integer;ItemLedgEntryQty@1004 : Decimal;RemQty@1005 : Decimal;IncludeExpectedCost@1001 : Boolean;PostingDate@1006 :
    
/*
procedure CalculateRemInventoryValue (ItemLedgEntryNo: Integer;ItemLedgEntryQty: Decimal;RemQty: Decimal;IncludeExpectedCost: Boolean;PostingDate: Date) : Decimal;
    var
//       ValueEntry@1002 :
      ValueEntry: Record 5802;
//       AdjustedCost@1003 :
      AdjustedCost: Decimal;
//       TotalQty@1007 :
      TotalQty: Decimal;
    begin
      ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
      ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntryNo);
      ValueEntry.SETFILTER("Valuation Date",'<=%1',PostingDate);
      if not IncludeExpectedCost then
        ValueEntry.SETRANGE("Expected Cost",FALSE);
      if ValueEntry.FINDSET then
        repeat
          if ValueEntry."Entry Type" = ValueEntry."Entry Type"::Revaluation then
            TotalQty := ValueEntry."Valued Quantity"
          else
            TotalQty := ItemLedgEntryQty;
          if ValueEntry."Entry Type" <> ValueEntry."Entry Type"::Rounding then
            if IncludeExpectedCost then
              AdjustedCost += RemQty / TotalQty * (ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)")
            else
              AdjustedCost += RemQty / TotalQty * ValueEntry."Cost Amount (Actual)";
        until ValueEntry.NEXT = 0;
      exit(AdjustedCost);
    end;
*/


    
    
/*
procedure TrackingExists () : Boolean;
    begin
      exit(("Serial No." <> '') or ("Lot No." <> ''));
    end;
*/


    
//     procedure SetItemVariantLocationFilters (ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 : Code[10];PostingDate@1003 :
    
/*
procedure SetItemVariantLocationFilters (ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];PostingDate: Date)
    begin
      RESET;
      SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
      SETRANGE("Item No.",ItemNo);
      SETRANGE("Variant Code",VariantCode);
      SETRANGE("Location Code",LocationCode);
      SETRANGE("Posting Date",0D,PostingDate);
    end;
*/


    
//     procedure SetTrackingFilter (SerialNo@1000 : Code[50];LotNo@1001 :
    
/*
procedure SetTrackingFilter (SerialNo: Code[50];LotNo: Code[50])
    begin
      SETRANGE("Serial No.",SerialNo);
      SETRANGE("Lot No.",LotNo);
    end;
*/


    
//     procedure SetTrackingFilterFromSpec (TrackingSpecification@1000 :
    
/*
procedure SetTrackingFilterFromSpec (TrackingSpecification: Record 336)
    begin
      SETRANGE("Serial No.",TrackingSpecification."Serial No.");
      SETRANGE("Lot No.",TrackingSpecification."Lot No.");
    end;
*/


    
/*
procedure ClearTrackingFilter ()
    begin
      SETRANGE("Serial No.");
      SETRANGE("Lot No.");
    end;
*/


    
//     LOCAL procedure OnAfterFilterLinesWithItemToPlan (var ItemLedgerEntry@1000 : Record 32;var Item@1001 :
    
/*
LOCAL procedure OnAfterFilterLinesWithItemToPlan (var ItemLedgerEntry: Record 32;var Item: Record 27)
    begin
    end;

    /*begin
    //{
//      DGG 08/10/21: - QB 1.09.21 Added Fields: 7207500QB Diverse EntranceDiverse Entrance, 7207501QB Ceded Control, 7207502QB Plant ItemPlant Item
//      CPA 15/12/21: - QB 1.10.22 (Q15921) Si viene de un albar n de compra. New Field: "QB Automatic Shipment"
//      AML 22/03/22 QB_ST01 A¤adidos campos QB_ST01 para control de valoracion de stocks y variaci¢n de existencias.
//    }
    end.
  */
}




