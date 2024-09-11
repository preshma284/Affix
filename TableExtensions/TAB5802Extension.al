tableextension 50200 "QBU Value EntryExt" extends "Value Entry"
{
  
  
    CaptionML=ENU='Value Entry',ESP='Movimiento valor';
    LookupPageID="Value Entries";
    DrillDownPageID="Value Entries";
  
  fields
{
    field(7207296;"QBU Outstanding Amount (JC)";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job Currency Amount',ESP='Importe Pendiente (DC)';
                                                   Description='QB 1.0 - GEN005-02 -> Es el importe pendiente de recibir en Divisa del proyecto, se usa en ta tabla Job';


    }
    field(7207297;"QBU Job Curr. Exch. Rate";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job Currency Exchange Rate',ESP='Tipo cambio divisa proyecto';
                                                   Description='QB 1.0 - GEN005-02';


    }
    field(7207298;"QBU Outstanding Amount (ACY)";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Aditional Currency Amount',ESP='Importe Pendiente (DR)';
                                                   Description='QB 1.0 - GEN005-02 -> Es el importe pendiente de recibir en Divisa adicional, se usa en ta tabla Job';


    }
    field(7207299;"QBU Aditional Curr. Exch. Rate";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Aditional Currency Exchange Rate',ESP='Tipo cambio divisa adicional';
                                                   Description='QB 1.0 - GEN005-02';


    }
    field(7207700;"QBU Stocks Adjusted GL";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB_ST01';


    }
    field(7207701;"QBU Stocks Adjusted Not Found";Boolean)
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
   // key(key2;"Item Ledger Entry No.","Entry Type")
  //  {
       /* SumIndexFields="Invoiced Quantity","Sales Amount (Expected)","Sales Amount (Actual)","Cost Amount (Expected)","Cost Amount (Actual)","Cost Amount (Non-Invtbl.)","Cost Amount (Expected) (ACY)","Cost Amount (Actual) (ACY)","Cost Amount (Non-Invtbl.)(ACY)","Purchase Amount (Actual)","Purchase Amount (Expected)","Discount Amount";
 */
   // }
   // key(No3;"Item Ledger Entry No.","Document No.","Document Line No.")
   // {
       /* MaintainSQLIndex=false;
 */
   // }
   // key(key4;"Item No.","Posting Date","Item Ledger Entry Type","Entry Type","Variance Type","Item Charge No.","Location Code","Variant Code")
  //  {
       /* SumIndexFields="Invoiced Quantity","Sales Amount (Expected)","Sales Amount (Actual)","Cost Amount (Expected)","Cost Amount (Actual)","Cost Amount (Non-Invtbl.)","Purchase Amount (Actual)","Expected Cost Posted to G/L","Cost Posted to G/L","Item Ledger Entry Quantity","Cost Amount (Expected) (ACY)","Cost Amount (Actual) (ACY)";
 */
   // }
   // key(No5;"Item No.","Posting Date","Item Ledger Entry Type","Entry Type","Variance Type","Item Charge No.","Location Code","Variant Code","Global Dimension 1 Code","Global Dimension 2 Code","Source Type","Source No.")
   // {
       /* SumIndexFields="Invoiced Quantity","Sales Amount (Expected)","Sales Amount (Actual)","Cost Amount (Expected)","Cost Amount (Actual)","Cost Amount (Non-Invtbl.)","Purchase Amount (Actual)","Expected Cost Posted to G/L","Cost Posted to G/L","Item Ledger Entry Quantity";
 */
   // }
   // key(key6;"Document No.")
  //  {
       /* ;
 */
   // }
   // key(key7;"Item No.","Valuation Date","Location Code","Variant Code")
  //  {
       /* SumIndexFields="Cost Amount (Expected)","Cost Amount (Actual)","Cost Amount (Expected) (ACY)","Cost Amount (Actual) (ACY)","Item Ledger Entry Quantity";
 */
   // }
   // key(key8;"Source Type","Source No.","Item No.","Posting Date","Entry Type","Adjustment","Item Ledger Entry Type")
  //  {
       /* SumIndexFields="Discount Amount","Cost Amount (Non-Invtbl.)","Cost Amount (Actual)","Cost Amount (Expected)","Sales Amount (Actual)","Sales Amount (Expected)","Invoiced Quantity";
 */
   // }
   // key(key9;"Item Charge No.","Inventory Posting Group","Item No.")
  //  {
       /* ;
 */
   // }
   // key(key10;"Capacity Ledger Entry No.","Entry Type")
  //  {
       /* SumIndexFields="Cost Amount (Actual)","Cost Amount (Actual) (ACY)";
 */
   // }
   // key(key11;"Order Type","Order No.","Order Line No.")
  //  {
       /* ;
 */
   // }
   // key(No12;"Source Type","Source No.","Global Dimension 1 Code","Global Dimension 2 Code","Item No.","Posting Date","Entry Type","Adjustment")
   // {
       /* SumIndexFields="Discount Amount","Cost Amount (Non-Invtbl.)","Cost Amount (Actual)","Cost Amount (Expected)","Sales Amount (Actual)","Sales Amount (Expected)","Invoiced Quantity";
 */
   // }
   // key(key13;"Job No.","Job Task No.","Document No.")
  //  {
       /* ;
 */
   // }
   // key(key14;"Item Ledger Entry Type","Posting Date","Item No.","Inventory Posting Group","Dimension Set ID")
  //  {
       /* SumIndexFields="Invoiced Quantity","Sales Amount (Actual)","Purchase Amount (Actual)";
 */
   // }
   // key(No15;"Item Ledger Entry No.","Valuation Date")
   // {
       /* ;
 */
   // }
   // key(key16;"Location Code","Inventory Posting Group")
  //  {
       /* ;
 */
   // }
    //key(Extkey17;"Item No.","Adjustment","QB Stocks Adjusted GL")
   // {
        /*  ;
 */
   // }
    key(Extkey18;"Location Code","Expected Cost","Posting Date")
    {
        SumIndexFields="Cost Amount (Actual)";
    }
}
  fieldgroups
{
   // fieldgroup(DropDown;"Entry No.","Item Ledger Entry Type","Item Ledger Entry No.","Item No.","Posting Date","Source No.","Document No.")
   // {
       // 
   // }
}
  
    var
//       GLSetup@1000 :
      GLSetup: Record 98;
//       GLSetupRead@1002 :
      GLSetupRead: Boolean;

    
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


    
    
/*
procedure GetValuationDate () : Date;
    begin
      if "Valuation Date" < "Posting Date" then
        exit("Posting Date");
      exit("Valuation Date");
    end;
*/


    
//     procedure AddCost (InvtAdjmtBuffer@1000 :
    
/*
procedure AddCost (InvtAdjmtBuffer: Record 5895)
    begin
      "Cost Amount (Expected)" := "Cost Amount (Expected)" + InvtAdjmtBuffer."Cost Amount (Expected)";
      "Cost Amount (Expected) (ACY)" := "Cost Amount (Expected) (ACY)" + InvtAdjmtBuffer."Cost Amount (Expected) (ACY)";
      "Cost Amount (Actual)" := "Cost Amount (Actual)" + InvtAdjmtBuffer."Cost Amount (Actual)";
      "Cost Amount (Actual) (ACY)" := "Cost Amount (Actual) (ACY)" + InvtAdjmtBuffer."Cost Amount (Actual) (ACY)";
    end;
*/


    
//     procedure SumCostsTillValuationDate (var ValueEntry@1000 :
    
/*
procedure SumCostsTillValuationDate (var ValueEntry: Record 5802)
    var
//       AccountingPeriod@1002 :
      AccountingPeriod: Record 50;
//       PrevValueEntrySum@1008 :
      PrevValueEntrySum: Record 5802;
//       Item@1010 :
      Item: Record 27;
//       FromDate@1005 :
      FromDate: Date;
//       ToDate@1006 :
      ToDate: Date;
//       CostCalcIsChanged@1004 :
      CostCalcIsChanged: Boolean;
//       QtyFactor@1009 :
      QtyFactor: Decimal;
    begin
      Item.GET(ValueEntry."Item No.");
      if Item."Costing Method" = Item."Costing Method"::Average then
        ToDate := GetAvgToDate(ValueEntry."Valuation Date")
      else
        ToDate := ValueEntry."Valuation Date";

      repeat
        if Item."Costing Method" = Item."Costing Method"::Average then
          FromDate := GetAvgFromDate(ToDate,AccountingPeriod,CostCalcIsChanged)
        else
          FromDate := 0D;

        QtyFactor := 1;
        RESET;
        SETCURRENTKEY("Item No.","Valuation Date","Location Code","Variant Code");
        SETRANGE("Item No.",ValueEntry."Item No.");
        SETRANGE("Valuation Date",FromDate,ToDate);
        if (AccountingPeriod."Average Cost Calc. Type" =
            AccountingPeriod."Average Cost Calc. Type"::"Item & Location & Variant") or
           (Item."Costing Method" <> Item."Costing Method"::Average)
        then begin
          SETRANGE("Location Code",ValueEntry."Location Code");
          SETRANGE("Variant Code",ValueEntry."Variant Code");
        end else
          if CostCalcIsChanged then
            QtyFactor := ValueEntry.CalcQtyFactor(FromDate,ToDate);

        CALCSUMS(
          "Item Ledger Entry Quantity","Invoiced Quantity",
          "Cost Amount (Actual)","Cost Amount (Actual) (ACY)",
          "Cost Amount (Expected)","Cost Amount (Expected) (ACY)");

        "Item Ledger Entry Quantity" :=
          ROUND("Item Ledger Entry Quantity" * QtyFactor,0.00001) + PrevValueEntrySum."Item Ledger Entry Quantity";
        "Invoiced Quantity" :=
          ROUND("Invoiced Quantity" * QtyFactor,0.00001) + PrevValueEntrySum."Invoiced Quantity";
        "Cost Amount (Actual)" :=
          "Cost Amount (Actual)" * QtyFactor + PrevValueEntrySum."Cost Amount (Actual)";
        "Cost Amount (Expected)" :=
          "Cost Amount (Expected)" * QtyFactor + PrevValueEntrySum."Cost Amount (Expected)";
        "Cost Amount (Expected) (ACY)" :=
          "Cost Amount (Expected) (ACY)" * QtyFactor + PrevValueEntrySum."Cost Amount (Expected) (ACY)";
        "Cost Amount (Actual) (ACY)" :=
          "Cost Amount (Actual) (ACY)" * QtyFactor + PrevValueEntrySum."Cost Amount (Actual) (ACY)";
        PrevValueEntrySum := Rec;

        if FromDate <> 0D then
          ToDate := CALCDATE('<-1D>',FromDate);
      until FromDate = 0D;
    end;
*/


    
//     procedure CalcItemLedgEntryCost (ItemLedgEntryNo@1000 : Integer;Expected@1001 :
    
/*
procedure CalcItemLedgEntryCost (ItemLedgEntryNo: Integer;Expected: Boolean)
    var
//       ItemLedgEntryQty@1006 :
      ItemLedgEntryQty: Decimal;
//       CostAmtActual@1002 :
      CostAmtActual: Decimal;
//       CostAmtActualACY@1003 :
      CostAmtActualACY: Decimal;
//       CostAmtExpected@1004 :
      CostAmtExpected: Decimal;
//       CostAmtExpectedACY@1005 :
      CostAmtExpectedACY: Decimal;
    begin
      RESET;
      SETCURRENTKEY("Item Ledger Entry No.");
      SETRANGE("Item Ledger Entry No.",ItemLedgEntryNo);
      if FIND('-') then
        repeat
          if "Expected Cost" = Expected then begin
            ItemLedgEntryQty := ItemLedgEntryQty + "Item Ledger Entry Quantity";
            CostAmtActual := CostAmtActual + "Cost Amount (Actual)";
            CostAmtActualACY := CostAmtActualACY + "Cost Amount (Actual) (ACY)";
            CostAmtExpected := CostAmtExpected + "Cost Amount (Expected)";
            CostAmtExpectedACY := CostAmtExpectedACY + "Cost Amount (Expected) (ACY)";
          end;
        until NEXT = 0;

      "Item Ledger Entry Quantity" := ItemLedgEntryQty;
      "Cost Amount (Actual)" := CostAmtActual;
      "Cost Amount (Actual) (ACY)" := CostAmtActualACY;
      "Cost Amount (Expected)" := CostAmtExpected;
      "Cost Amount (Expected) (ACY)" := CostAmtExpectedACY;
    end;
*/


    
//     procedure NotInvdRevaluationExists (ItemLedgEntryNo@1000 :
    
/*
procedure NotInvdRevaluationExists (ItemLedgEntryNo: Integer) : Boolean;
    begin
      RESET;
      SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
      SETRANGE("Item Ledger Entry No.",ItemLedgEntryNo);
      SETRANGE("Entry Type","Entry Type"::Revaluation);
      SETRANGE("Applies-to Entry",0);
      exit(FINDSET);
    end;
*/


    
//     procedure CalcQtyFactor (FromDate@1000 : Date;ToDate@1002 :
    
/*
procedure CalcQtyFactor (FromDate: Date;ToDate: Date) QtyFactor : Decimal;
    var
//       ValueEntry2@1001 :
      ValueEntry2: Record 5802;
    begin
      ValueEntry2.SETCURRENTKEY("Item No.","Valuation Date","Location Code","Variant Code");
      ValueEntry2.SETRANGE("Item No.","Item No.");
      ValueEntry2.SETRANGE("Valuation Date",FromDate,ToDate);
      ValueEntry2.SETRANGE("Location Code","Location Code");
      ValueEntry2.SETRANGE("Variant Code","Variant Code");
      ValueEntry2.CALCSUMS("Item Ledger Entry Quantity");
      QtyFactor := ValueEntry2."Item Ledger Entry Quantity";

      ValueEntry2.SETRANGE("Location Code");
      ValueEntry2.SETRANGE("Variant Code");
      ValueEntry2.CALCSUMS("Item Ledger Entry Quantity");
      if ValueEntry2."Item Ledger Entry Quantity" <> 0 then
        QtyFactor := QtyFactor / ValueEntry2."Item Ledger Entry Quantity";

      exit(QtyFactor);
    end;
*/


    
    
/*
procedure ShowGL ()
    var
//       GLItemLedgRelation@1000 :
      GLItemLedgRelation: Record 5823;
//       GLEntry@1002 :
      GLEntry: Record 17;
//       TempGLEntry@1001 :
      TempGLEntry: Record 17 TEMPORARY;
    begin
      GLItemLedgRelation.SETCURRENTKEY("Value Entry No.");
      GLItemLedgRelation.SETRANGE("Value Entry No.","Entry No.");
      if GLItemLedgRelation.FINDSET then
        repeat
          GLEntry.GET(GLItemLedgRelation."G/L Entry No.");
          TempGLEntry.INIT;
          TempGLEntry := GLEntry;
          TempGLEntry.INSERT;
        until GLItemLedgRelation.NEXT = 0;

      PAGE.RUNMODAL(0,TempGLEntry);
    end;
*/


    
//     procedure IsAvgCostException (IsAvgCostCalcTypeItem@1000 :
    
/*
procedure IsAvgCostException (IsAvgCostCalcTypeItem: Boolean) : Boolean;
    var
//       ItemApplnEntry@1001 :
      ItemApplnEntry: Record 339;
//       ItemLedgEntry@1002 :
      ItemLedgEntry: Record 32;
//       TempItemLedgEntry@1005 :
      TempItemLedgEntry: Record 32 TEMPORARY;
    begin
      if "Partial Revaluation" then
        exit(TRUE);
      if "Item Charge No." <> '' then
        exit(TRUE);

      ItemLedgEntry.GET("Item Ledger Entry No.");
      if ItemLedgEntry.Positive then
        exit(FALSE);

      ItemApplnEntry.GetVisitedEntries(ItemLedgEntry,TempItemLedgEntry,TRUE);
      TempItemLedgEntry.SETCURRENTKEY("Item No.",Positive,"Location Code","Variant Code");
      TempItemLedgEntry.SETRANGE("Item No.","Item No.");
      TempItemLedgEntry.SETRANGE(Positive,TRUE);
      if not IsAvgCostCalcTypeItem then begin
        TempItemLedgEntry.SETRANGE("Location Code","Location Code");
        TempItemLedgEntry.SETRANGE("Variant Code","Variant Code");
      end;
      exit(not TempItemLedgEntry.ISEMPTY);
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


    
//     procedure GetAvgToDate (ToDate@1002 :
    
/*
procedure GetAvgToDate (ToDate: Date) : Date;
    var
//       CalendarPeriod@1000 :
      CalendarPeriod: Record 2000000007;
//       AvgCostAdjmtEntryPoint@1001 :
      AvgCostAdjmtEntryPoint: Record 5804;
    begin
      CalendarPeriod."Period Start" := ToDate;
      AvgCostAdjmtEntryPoint."Valuation Date" := ToDate;
      AvgCostAdjmtEntryPoint.GetValuationPeriod(CalendarPeriod);
      exit(CalendarPeriod."Period end");
    end;
*/


    
//     procedure GetAvgFromDate (ToDate@1002 : Date;var AccountingPeriod@1007 : Record 50;var CostCalcIsChanged@1001 :
    
/*
procedure GetAvgFromDate (ToDate: Date;var AccountingPeriod: Record 50;var CostCalcIsChanged: Boolean) FromDate : Date;
    var
//       PrevAccountingPeriod@1000 :
      PrevAccountingPeriod: Record 50;
//       AccountingPeriodMgt@1003 :
      AccountingPeriodMgt: Codeunit 360;
    begin
      if PrevAccountingPeriod.ISEMPTY then begin
        AccountingPeriodMgt.InitDefaultAccountingPeriod(AccountingPeriod,ToDate);
        FromDate := 0D;
        exit;
      end;

      FromDate := ToDate;
      AccountingPeriod.SETRANGE("Starting Date",0D,ToDate);
      AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
      if not AccountingPeriod.FIND('+') then begin
        AccountingPeriod.SETRANGE("Starting Date");
        AccountingPeriod.FIND('-');
      end;

      WHILE (FromDate = ToDate) and (FromDate <> 0D) DO begin
        PrevAccountingPeriod := AccountingPeriod;
        CASE TRUE OF
          AccountingPeriod."Average Cost Calc. Type" = AccountingPeriod."Average Cost Calc. Type"::Item:
            FromDate := 0D;
          AccountingPeriod.NEXT(-1) = 0:
            FromDate := 0D;
          AccountingPeriod."Average Cost Calc. Type" <> PrevAccountingPeriod."Average Cost Calc. Type":
            begin
              AccountingPeriod := PrevAccountingPeriod;
              FromDate := PrevAccountingPeriod."Starting Date";
              CostCalcIsChanged := TRUE;
              exit;
            end;
        end;
      end;
      AccountingPeriod := PrevAccountingPeriod;
    end;
*/


    
//     procedure FindFirstValueEntryByItemLedgerEntryNo (ItemLedgerEntryNo@1000 :
    
/*
procedure FindFirstValueEntryByItemLedgerEntryNo (ItemLedgerEntryNo: Integer)
    begin
      RESET;
      SETCURRENTKEY("Item Ledger Entry No.");
      SETRANGE("Item Ledger Entry No.",ItemLedgerEntryNo);
      FINDFIRST;
    end;
*/


    
    
/*
procedure IsInbound () : Boolean;
    begin
      if (("Item Ledger Entry Type" IN
           ["Item Ledger Entry Type"::Purchase,
            "Item Ledger Entry Type"::"Positive Adjmt.",
            "Item Ledger Entry Type"::"Assembly Output"]) or
          ("Item Ledger Entry Type" = "Item Ledger Entry Type"::Output) and ("Invoiced Quantity" > 0))
      then
        exit(TRUE);
      exit(FALSE);
    end;

    /*begin
    //{
//      AML 23/03/22 QB_ST01 A¤adidos campos QB_ST01 para control de ajustes por Valoraci¢n de stocks
//
//      CPA 29/03/22: Q16867 - Mejora de rendimiento
//          - Nueva Clave: Location Code,Expected Cost,Posting Date
//    }
    end.
  */
}





