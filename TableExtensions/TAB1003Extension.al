tableextension 50185 "QBU Job Planning LineExt" extends "Job Planning Line"
{
  
  
    CaptionML=ENU='Job Planning Line',ESP='L¡nea planificaci¢n proyecto';
    LookupPageID="Job Planning Lines";
    DrillDownPageID="Job Planning Lines";
  
  fields
{
    field(7207270;"QBU Analytical concept";Code[20])
    {
        

                                                   CaptionML=ENU='Analytical concept',ESP='Concepto anal¡tico';
                                                   Description='QB 1.00 - QB2515' ;

trigger OnLookup();
    VAR
//                                                               FunctionQB@1100286000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("Analytical concept",FALSE);
                                                            END;


    }
}
  keys
{
   // key(key1;"Job No.","Job Task No.","Line No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Job No.","Job Task No.","Schedule Line","Planning Date")
  //  {
       /* SumIndexFields="Total Price (LCY)","Total Cost (LCY)","Line Amount (LCY)","Remaining Total Cost (LCY)","Remaining Line Amount (LCY)","Total Cost","Line Amount";
 */
   // }
   // key(key3;"Job No.","Job Task No.","Contract Line","Planning Date")
  //  {
       /* SumIndexFields="Total Price (LCY)","Total Cost (LCY)","Line Amount (LCY)","Remaining Total Cost (LCY)","Remaining Line Amount (LCY)","Total Cost","Line Amount";
 */
   // }
   // key(key4;"Job No.","Job Task No.","Schedule Line","Currency Date")
  //  {
       /* ;
 */
   // }
   // key(key5;"Job No.","Job Task No.","Contract Line","Currency Date")
  //  {
       /* ;
 */
   // }
   // key(key6;"Job No.","Schedule Line","Type","No.","Planning Date")
  //  {
       /* SumIndexFields="Quantity (Base)";
 */
   // }
   // key(key7;"Job No.","Schedule Line","Type","Resource Group No.","Planning Date")
  //  {
       /* SumIndexFields="Quantity (Base)";
 */
   // }
   // key(key8;"Status","Schedule Line","Type","No.","Planning Date")
  //  {
       /* SumIndexFields="Quantity (Base)";
 */
   // }
   // key(key9;"Status","Schedule Line","Type","Resource Group No.","Planning Date")
  //  {
       /* SumIndexFields="Quantity (Base)";
 */
   // }
   // key(key10;"Job No.","Contract Line")
  //  {
       /* ;
 */
   // }
   // key(key11;"Job Contract Entry No.")
  //  {
       /* ;
 */
   // }
   // key(key12;"Type","No.","Job No.","Job Task No.","Usage Link","System-Created Entry")
  //  {
       /* ;
 */
   // }
   // key(key13;"Status","Type","No.","Variant Code","Location Code","Planning Date")
  //  {
       /* SumIndexFields="Remaining Qty. (Base)";
 */
   // }
   // key(key14;"Job No.","Planning Date","Document No.")
  //  {
       /* ;
 */
   // }
    //key(Extkey15;"Job No.","Analytical concept","Job Task No.")
   // {
        /*  ;
 */
   // }
    key(Extkey16;"Job No.","Contract Line","Qty. to Invoice","Planning Date")
    {
        SumIndexFields="Quantity","Quantity (Base)","Total Price (LCY)","Total Cost (LCY)";
    }
}
  fieldgroups
{
}
  
    var
//       GLAcc@1018 :
      GLAcc: Record 15;
//       Location@1013 :
      Location: Record 14;
//       Item@1014 :
      Item: Record 27;
//       JobTask@1001 :
      JobTask: Record 1001;
//       ItemVariant@1004 :
      ItemVariant: Record 5401;
//       Res@1006 :
      Res: Record 156;
//       ResCost@1007 :
      ResCost: Record 202;
//       WorkType@1009 :
      WorkType: Record 200;
//       Job@1002 :
      Job: Record 167;
//       ResourceUnitOfMeasure@1010 :
      ResourceUnitOfMeasure: Record 205;
//       CurrExchRate@1025 :
      CurrExchRate: Record 330;
//       SKU@1022 :
      SKU: Record 5700;
//       StandardText@1030 :
      StandardText: Record 7;
//       ItemTranslation@1032 :
      ItemTranslation: Record 30;
//       GLSetup@1015 :
      GLSetup: Record 98;
//       JobPlanningLineReserve@1011 :
      JobPlanningLineReserve: Codeunit 1032;
//       UOMMgt@1017 :
      UOMMgt: Codeunit 5402;
//       ItemCheckAvail@1012 :
      ItemCheckAvail: Codeunit 311;
//       CurrencyFactorErr@1020 :
      CurrencyFactorErr: 
// "%1 = Currency Code field name"
TextConst ENU='cannot be specified without %1',ESP='no se puede especificar sin %1';
//       RecordRenameErr@1024 :
      RecordRenameErr: 
// "%1 = Job Number field name; %2 = Job Task Number field name; %3 = Job Planning Line table name"
TextConst ENU='You cannot change the %1 or %2 of this %3.',ESP='No puede cambiar el %1 o %2 de este %3.';
//       CurrencyDate@1023 :
      CurrencyDate: Date;
//       MissingItemResourceGLErr@1031 :
      MissingItemResourceGLErr: 
// "%1 = Document Type (Item, Resoure, or G/L); %2 = Field name"
TextConst ENU='You must specify %1 %2 in planning line.',ESP='Debe especificar %1 %2 en la l¡nea de planificaci¢n.';
//       HasGotGLSetup@1016 :
      HasGotGLSetup: Boolean;
//       UnitAmountRoundingPrecision@1019 :
      UnitAmountRoundingPrecision: Decimal;
//       AmountRoundingPrecision@1028 :
      AmountRoundingPrecision: Decimal;
//       QtyLessErr@1027 :
      QtyLessErr: 
// "%1 = Name of first field to compare; %2 = Name of second field to compare"
TextConst ENU='%1 cannot be less than %2.',ESP='%1 no puede ser inferior que %2.';
//       ControlUsageLinkErr@1029 :
      ControlUsageLinkErr: 
// "%1 = Job Planning Line table name; %2 = Caption for field Schedule Line; %3 = Captiion for field Usage Link"
TextConst ENU='The %1 must be a %2 and %3 must be enabled, because linked Job Ledger Entries exist.',ESP='El %1 debe ser un %2 y %3 debe activarse porque existen Movs. proyectos vinculados.';
//       JobUsageLinkErr@1034 :
      JobUsageLinkErr: 
// "%1 = Job Planning Line table name"
TextConst ENU='This %1 cannot be deleted because linked job ledger entries exist.',ESP='Este %1 no se puede eliminar porque existen movs. proyectos vinculados.';
//       BypassQtyValidation@1035 :
      BypassQtyValidation: Boolean;
//       LinkedJobLedgerErr@1033 :
      LinkedJobLedgerErr: TextConst ENU='You cannot change this value because linked job ledger entries exist.',ESP='No puede cambiar este valor porque existen movs. proyectos vinculados.';
//       LineTypeErr@1003 :
      LineTypeErr: 
// The Job Planning Line cannot be of Line Type Schedule, because it is transferred to an invoice.
TextConst ENU='The %1 cannot be of %2 %3 because it is transferred to an invoice.',ESP='El %1 no puede ser de %2 %3 porque se ha transferido a una factura.';
//       QtyToTransferToInvoiceErr@1005 :
      QtyToTransferToInvoiceErr: 
// "%1 = Qty. to Transfer to Invoice field name; %2 = First value in comparison; %3 = Second value in comparison"
TextConst ENU='%1 may not be lower than %2 and may not exceed %3.',ESP='%1 no puede ser inferior a %2 ni puede superar %3.';
//       AutoReserveQst@1040 :
      AutoReserveQst: TextConst ENU='Automatic reservation is not possible.\Do you want to reserve items manually?',ESP='No se puede reservar autom ticamente.\¨Desea reservar los productos manualmente?';
//       NoContractLineErr@1021 :
      NoContractLineErr: 
// "%1 = Qty. to Transfer to Invoice field name; %2 = Job Planning Line table name; %3 = The job''s line type"
TextConst ENU='%1 cannot be set on a %2 of type %3.',ESP='%1 no se puede establecer en un %2 de tipo %3.';
//       QtyAlreadyTransferredErr@1038 :
      QtyAlreadyTransferredErr: 
// "%1 = Job Planning Line table name"
TextConst ENU='The %1 has already been completely transferred.',ESP='El %1 ya se ha transferido por completo.';
//       UsageLinkErr@1039 :
      UsageLinkErr: 
// Usage Link cannot be enabled on a Job Planning Line with Line Type Schedule
TextConst ENU='%1 cannot be enabled on a %2 with %3 %4.',ESP='%1 no se puede activar en un %2 con %3 %4.';
//       QtyGreaterErr@1041 :
      QtyGreaterErr: 
// "%1 = Caption for field Quantity; %2 = Captiion for field Qty. Transferred to Invoice"
TextConst ENU='%1 cannot be higher than %2.',ESP='%1 no puede ser superior a %2.';
//       RequestedDeliveryDateErr@1026 :
      RequestedDeliveryDateErr: 
// "%1 = Caption for field Requested Delivery Date; %2 = Captiion for field Promised Delivery Date"
TextConst ENU='You cannot change the %1 when the %2 has been filled in.',ESP='No puede cambiar %1 despu‚s de introducir datos en %2.';
//       UnitAmountRoundingPrecisionFCY@1036 :
      UnitAmountRoundingPrecisionFCY: Decimal;
//       AmountRoundingPrecisionFCY@1037 :
      AmountRoundingPrecisionFCY: Decimal;
//       NotPossibleJobPlanningLineErr@1000 :
      NotPossibleJobPlanningLineErr: TextConst ENU='It is not possible to deleted job planning line transferred to an invoice.',ESP='No se puede eliminar una l¡nea de planificaci¢n de trabajo transferida a una factura.';
//       QBTablePublisher@1100286000 :
      QBTablePublisher: Codeunit 7207346;

    


/*
trigger OnInsert();    begin
               LOCKTABLE;
               GetJob;
               if Job.Blocked = Job.Blocked::All then
                 Job.TestBlocked;
               JobTask.GET("Job No.","Job Task No.");
               JobTask.TESTFIELD("Job Task Type",JobTask."Job Task Type"::Posting);
               InitJobPlanningLine;
               if Quantity <> 0 then
                 UpdateReservation(0);

               if "Schedule Line" then
                 Job.UpdateOverBudgetValue("Job No.",FALSE,"Total Cost (LCY)");
             end;


*/

/*
trigger OnModify();    begin
               "Last Date Modified" := TODAY;
               "User ID" := USERID;

               if ((Quantity <> 0) or (xRec.Quantity <> 0)) and ItemExists(xRec."No.") then
                 UpdateReservation(0);

               if "Schedule Line" then
                 Job.UpdateOverBudgetValue("Job No.",FALSE,"Total Cost (LCY)");
             end;


*/

/*
trigger OnDelete();    var
//                JobUsageLink@1000 :
               JobUsageLink: Record 1020;
             begin
               ValidateModification(TRUE);
               CheckRelatedJobPlanningLineInvoice;

               if "Usage Link" then begin
                 JobUsageLink.SETRANGE("Job No.","Job No.");
                 JobUsageLink.SETRANGE("Job Task No.","Job Task No.");
                 JobUsageLink.SETRANGE("Line No.","Line No.");
                 if not JobUsageLink.ISEMPTY then
                   ERROR(JobUsageLinkErr,TABLECAPTION);
               end;

               if (Quantity <> 0) and ItemExists("No.") then begin
                 JobPlanningLineReserve.DeleteLine(Rec);
                 CALCFIELDS("Reserved Qty. (Base)");
                 TESTFIELD("Reserved Qty. (Base)",0);
               end;

               if "Schedule Line" then
                 Job.UpdateOverBudgetValue("Job No.",FALSE,"Total Cost (LCY)");
             end;


*/

/*
trigger OnRename();    begin
               ERROR(RecordRenameErr,FIELDCAPTION("Job No."),FIELDCAPTION("Job Task No."),TABLECAPTION);
             end;

*/



// LOCAL procedure CalcBaseQty (Qty@1000 :

/*
LOCAL procedure CalcBaseQty (Qty: Decimal) : Decimal;
    begin
      TESTFIELD("Qty. per Unit of Measure");
      exit(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    end;
*/


//     LOCAL procedure CheckItemAvailable (CalledByFieldNo@1000 :
    
/*
LOCAL procedure CheckItemAvailable (CalledByFieldNo: Integer)
    begin
      if CurrFieldNo <> CalledByFieldNo then
        exit;
      if Reserve = Reserve::Always then
        exit;
      if (Type <> Type::Item) or ("No." = '') then
        exit;
      if Quantity <= 0 then
        exit;
      if not (Status IN [Status::Order]) then
        exit;

      if ItemCheckAvail.JobPlanningLineCheck(Rec) then
        ItemCheckAvail.RaiseUpdateInterruptedError;
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
LOCAL procedure GetJob ()
    begin
      if ("Job No." <> Job."No.") and ("Job No." <> '') then
        Job.GET("Job No.");
    end;
*/


    
    
/*
procedure UpdateCurrencyFactor ()
    begin
      if "Currency Code" <> '' then begin
        if "Currency Date" = 0D then
          CurrencyDate := WORKDATE
        else
          CurrencyDate := "Currency Date";
        "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
      end else
        "Currency Factor" := 0;
    end;
*/


//     LOCAL procedure ItemExists (ItemNo@1000 :
    
/*
LOCAL procedure ItemExists (ItemNo: Code[20]) : Boolean;
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
LOCAL procedure GetItem ()
    begin
      if "No." <> Item."No." then
        if not Item.GET("No.") then
          CLEAR(Item);
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
LOCAL procedure InitRoundingPrecisions ()
    var
//       Currency@1000 :
      Currency: Record 4;
    begin
      if (AmountRoundingPrecision = 0) or
         (UnitAmountRoundingPrecision = 0) or
         (AmountRoundingPrecisionFCY = 0) or
         (UnitAmountRoundingPrecisionFCY = 0)
      then begin
        CLEAR(Currency);
        Currency.InitRoundingPrecision;
        AmountRoundingPrecision := Currency."Amount Rounding Precision";
        UnitAmountRoundingPrecision := Currency."Unit-Amount Rounding Precision";

        if "Currency Code" <> '' then begin
          Currency.GET("Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
          Currency.TESTFIELD("Unit-Amount Rounding Precision");
        end;

        AmountRoundingPrecisionFCY := Currency."Amount Rounding Precision";
        UnitAmountRoundingPrecisionFCY := Currency."Unit-Amount Rounding Precision";
      end;
    end;
*/


    
    
/*
procedure Caption () : Text[250];
    var
//       Job@1000 :
      Job: Record 167;
//       JobTask@1001 :
      JobTask: Record 1001;
    begin
      if not Job.GET("Job No.") then
        exit('');
      if not JobTask.GET("Job No.","Job Task No.") then
        exit('');
      exit(STRSUBSTNO('%1 %2 %3 %4',
          Job."No.",
          Job.Description,
          JobTask."Job Task No.",
          JobTask.Description));
    end;
*/


    
//     procedure SetUpNewLine (LastJobPlanningLine@1000 :
    
/*
procedure SetUpNewLine (LastJobPlanningLine: Record 1003)
    begin
      "Document Date" := LastJobPlanningLine."Planning Date";
      "Document No." := LastJobPlanningLine."Document No.";
      Type := LastJobPlanningLine.Type;
      VALIDATE("Line Type",LastJobPlanningLine."Line Type");
      GetJob;
      "Currency Code" := Job."Currency Code";
      UpdateCurrencyFactor;
      if LastJobPlanningLine."Planning Date" <> 0D then
        VALIDATE("Planning Date",LastJobPlanningLine."Planning Date");

      OnAfterSetupNewLine(Rec,LastJobPlanningLine);
    end;
*/


    
    
/*
procedure InitJobPlanningLine ()
    var
//       JobJnlManagement@1000 :
      JobJnlManagement: Codeunit 1020;
    begin
      GetJob;
      if "Planning Date" = 0D then
        VALIDATE("Planning Date",WORKDATE);
      "Currency Code" := Job."Currency Code";
      UpdateCurrencyFactor;
      "VAT Unit Price" := 0;
      "VAT Line Discount Amount" := 0;
      "VAT Line Amount" := 0;
      "VAT %" := 0;
      "Job Contract Entry No." := JobJnlManagement.GetNextEntryNo;
      "User ID" := USERID;
      "Last Date Modified" := 0D;
      Status := Job.Status;
      ControlUsageLink;
      "Country/Region Code" := Job."Bill-to Country/Region Code";

      OnAfterInitJobPlanningLine(Rec);
    end;
*/


    
/*
LOCAL procedure DeleteAmounts ()
    begin
      Quantity := 0;
      "Quantity (Base)" := 0;

      "Direct Unit Cost (LCY)" := 0;
      "Unit Cost (LCY)" := 0;
      "Unit Cost" := 0;

      "Total Cost (LCY)" := 0;
      "Total Cost" := 0;

      "Unit Price (LCY)" := 0;
      "Unit Price" := 0;

      "Total Price (LCY)" := 0;
      "Total Price" := 0;

      "Line Amount (LCY)" := 0;
      "Line Amount" := 0;

      "Line Discount %" := 0;

      "Line Discount Amount (LCY)" := 0;
      "Line Discount Amount" := 0;

      "Remaining Qty." := 0;
      "Remaining Qty. (Base)" := 0;
      "Remaining Total Cost" := 0;
      "Remaining Total Cost (LCY)" := 0;
      "Remaining Line Amount" := 0;
      "Remaining Line Amount (LCY)" := 0;

      "Qty. Posted" := 0;
      "Qty. to Transfer to Journal" := 0;
      "Posted Total Cost" := 0;
      "Posted Total Cost (LCY)" := 0;
      "Posted Line Amount" := 0;
      "Posted Line Amount (LCY)" := 0;

      "Qty. to Transfer to Invoice" := 0;
      "Qty. to Invoice" := 0;
    end;
*/


    
/*
LOCAL procedure UpdateFromCurrency ()
    begin
      UpdateAllAmounts;
    end;
*/


    
/*
LOCAL procedure GetItemTranslation ()
    begin
      GetJob;
      if ItemTranslation.GET("No.","Variant Code",Job."Language Code") then begin
        Description := ItemTranslation.Description;
        "Description 2" := ItemTranslation."Description 2";
      end;
    end;
*/


    
/*
LOCAL procedure GetGLSetup ()
    begin
      if HasGotGLSetup then
        exit;
      GLSetup.GET;
      HasGotGLSetup := TRUE;
    end;
*/


    
/*
LOCAL procedure UpdateAllAmounts ()
    begin
      OnBeforeUpdateAllAmounts(Rec);

      InitRoundingPrecisions;

      UpdateUnitCost;
      UpdateTotalCost;
      FindPriceAndDiscount(Rec,CurrFieldNo);
      HandleCostFactor;
      UpdateUnitPrice;
      UpdateTotalPrice;
      UpdateAmountsAndDiscounts;
      UpdateRemainingCostsAndAmounts("Currency Date","Currency Factor");
      if Type = Type::Text then
        FIELDERROR(Type);
    end;
*/


    
/*
LOCAL procedure UpdateUnitCost ()
    var
//       RetrievedCost@1000 :
      RetrievedCost: Decimal;
    begin
      GetJob;
      if (Type = Type::Item) and Item.GET("No.") then
        if Item."Costing Method" = Item."Costing Method"::Standard then begin
          if RetrieveCostPrice then begin
            if GetSKU then
              "Unit Cost (LCY)" := ROUND(SKU."Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision)
            else
              "Unit Cost (LCY)" := ROUND(Item."Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision);
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Currency Date","Currency Code",
                  "Unit Cost (LCY)","Currency Factor"),
                UnitAmountRoundingPrecisionFCY);
          end else
            RecalculateAmounts(Job."Exch. Calculation (Cost)",xRec."Unit Cost","Unit Cost","Unit Cost (LCY)");
        end else begin
          if RetrieveCostPrice then begin
            if GetSKU then
              RetrievedCost := SKU."Unit Cost" * "Qty. per Unit of Measure"
            else
              RetrievedCost := Item."Unit Cost" * "Qty. per Unit of Measure";
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Currency Date","Currency Code",
                  RetrievedCost,"Currency Factor"),
                UnitAmountRoundingPrecisionFCY);
            "Unit Cost (LCY)" := ROUND(RetrievedCost,UnitAmountRoundingPrecision);
          end else
            RecalculateAmounts(Job."Exch. Calculation (Cost)",xRec."Unit Cost","Unit Cost","Unit Cost (LCY)");
        end
      else
        if (Type = Type::Resource) and Res.GET("No.") then begin
          if RetrieveCostPrice then begin
            ResCost.INIT;
            ResCost.Code := "No.";
            ResCost."Work Type Code" := "Work Type Code";
            CODEUNIT.RUN(CODEUNIT::"Resource-Find Cost",ResCost);
            OnAfterResourceFindCost(Rec,ResCost);
            "Direct Unit Cost (LCY)" := ROUND(ResCost."Direct Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision);
            RetrievedCost := ResCost."Unit Cost" * "Qty. per Unit of Measure";
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Currency Date","Currency Code",
                  RetrievedCost,"Currency Factor"),
                UnitAmountRoundingPrecisionFCY);
            "Unit Cost (LCY)" := ROUND(RetrievedCost,UnitAmountRoundingPrecision);
          end else
            RecalculateAmounts(Job."Exch. Calculation (Cost)",xRec."Unit Cost","Unit Cost","Unit Cost (LCY)");
        end else
          RecalculateAmounts(Job."Exch. Calculation (Cost)",xRec."Unit Cost","Unit Cost","Unit Cost (LCY)");
    end;
*/


    
/*
LOCAL procedure RetrieveCostPrice () : Boolean;
    var
//       ShouldRetrieveCostPrice@1000 :
      ShouldRetrieveCostPrice: Boolean;
//       IsHandled@1001 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      ShouldRetrieveCostPrice := FALSE;
      OnBeforeRetrieveCostPrice(Rec,xRec,ShouldRetrieveCostPrice,IsHandled);
      if IsHandled then
        exit(ShouldRetrieveCostPrice);

      CASE Type OF
        Type::Item:
          ShouldRetrieveCostPrice :=
            ("No." <> xRec."No.") or
            ("Location Code" <> xRec."Location Code") or
            ("Variant Code" <> xRec."Variant Code") or
            (not BypassQtyValidation and (Quantity <> xRec.Quantity)) or
            ("Unit of Measure Code" <> xRec."Unit of Measure Code");
        Type::Resource:
          ShouldRetrieveCostPrice :=
            ("No." <> xRec."No.") or
            ("Work Type Code" <> xRec."Work Type Code") or
            ("Unit of Measure Code" <> xRec."Unit of Measure Code");
        Type::"G/L Account":
          ShouldRetrieveCostPrice := "No." <> xRec."No.";
        else
          exit(FALSE);
      end;
      exit(ShouldRetrieveCostPrice);
    end;
*/


    
/*
LOCAL procedure UpdateTotalCost ()
    begin
      "Total Cost" := ROUND("Unit Cost" * Quantity,AmountRoundingPrecisionFCY);
      "Total Cost (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Currency Date","Currency Code",
            "Total Cost","Currency Factor"),
          AmountRoundingPrecision);
    end;
*/


//     LOCAL procedure FindPriceAndDiscount (var JobPlanningLine@1000 : Record 1003;CalledByFieldNo@1001 :
    
/*
LOCAL procedure FindPriceAndDiscount (var JobPlanningLine: Record 1003;CalledByFieldNo: Integer)
    var
//       SalesPriceCalcMgt@1002 :
      SalesPriceCalcMgt: Codeunit 7000;
//       PurchPriceCalcMgt@1003 :
      PurchPriceCalcMgt: Codeunit 7010;
    begin
      if RetrieveCostPrice and ("No." <> '') then begin
        SalesPriceCalcMgt.FindJobPlanningLinePrice(JobPlanningLine,CalledByFieldNo);

        if Type <> Type::"G/L Account" then
          PurchPriceCalcMgt.FindJobPlanningLinePrice(JobPlanningLine,CalledByFieldNo)
        else begin
          // Because the SalesPriceCalcMgt.FindJobJnlLinePrice function also retrieves costs for G/L Account,
          // cost and total cost need to get updated again.
          UpdateUnitCost;
          UpdateTotalCost;
        end;
      end;
    end;
*/


    
/*
LOCAL procedure HandleCostFactor ()
    begin
      if ("Cost Factor" <> 0) and (("Unit Cost" <> xRec."Unit Cost") or ("Cost Factor" <> xRec."Cost Factor")) then
        "Unit Price" := ROUND("Unit Cost" * "Cost Factor",UnitAmountRoundingPrecisionFCY)
      else
        if (Item."Price/Profit Calculation" = Item."Price/Profit Calculation"::"Price=Cost+Profit") and
           (Item."Profit %" < 100) and
           ("Unit Cost" <> xRec."Unit Cost")
        then
          "Unit Price" := ROUND("Unit Cost" / (1 - Item."Profit %" / 100),UnitAmountRoundingPrecisionFCY);
    end;
*/


    
/*
LOCAL procedure UpdateUnitPrice ()
    begin
      GetJob;
      RecalculateAmounts(Job."Exch. Calculation (Price)",xRec."Unit Price","Unit Price","Unit Price (LCY)");
    end;
*/


//     LOCAL procedure RecalculateAmounts (JobExchCalculation@1003 : 'Fixed FCY,Fixed LCY';xAmount@1000 : Decimal;var Amount@1001 : Decimal;var AmountLCY@1002 :
    
/*
LOCAL procedure RecalculateAmounts (JobExchCalculation: Option "Fixed FCY","Fixed LCY";xAmount: Decimal;var Amount: Decimal;var AmountLCY: Decimal)
    begin
      if (xRec."Currency Factor" <> "Currency Factor") and
         (Amount = xAmount) and (JobExchCalculation = JobExchCalculation::"Fixed LCY")
      then
        Amount := ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              "Currency Date","Currency Code",
              AmountLCY,"Currency Factor"),
            UnitAmountRoundingPrecisionFCY)
      else
        AmountLCY := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date","Currency Code",
              Amount,"Currency Factor"),
            UnitAmountRoundingPrecision);
    end;
*/


    
/*
LOCAL procedure UpdateTotalPrice ()
    begin
      "Total Price" := ROUND(Quantity * "Unit Price",AmountRoundingPrecisionFCY);
      "Total Price (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Currency Date","Currency Code",
            "Total Price","Currency Factor"),
          AmountRoundingPrecision);
    end;
*/


    
/*
LOCAL procedure UpdateAmountsAndDiscounts ()
    begin
      if "Total Price" = 0 then begin
        "Line Amount" := 0;
        "Line Discount Amount" := 0;
      end else
        if ("Line Amount" <> xRec."Line Amount") and ("Line Discount Amount" = xRec."Line Discount Amount") then begin
          "Line Amount" := ROUND("Line Amount",AmountRoundingPrecisionFCY);
          "Line Discount Amount" := "Total Price" - "Line Amount";
          "Line Discount %" :=
            ROUND("Line Discount Amount" / "Total Price" * 100,0.00001);
        end else
          if ("Line Discount Amount" <> xRec."Line Discount Amount") and ("Line Amount" = xRec."Line Amount") then begin
            "Line Discount Amount" := ROUND("Line Discount Amount",AmountRoundingPrecisionFCY);
            "Line Amount" := "Total Price" - "Line Discount Amount";
            "Line Discount %" :=
              ROUND("Line Discount Amount" / "Total Price" * 100,0.00001);
          end else
            if ("Line Discount Amount" = xRec."Line Discount Amount") and
               (("Line Amount" <> xRec."Line Amount") or ("Line Discount %" <> xRec."Line Discount %") or
                ("Total Price" <> xRec."Total Price"))
            then begin
              "Line Discount Amount" :=
                ROUND("Total Price" * "Line Discount %" / 100,AmountRoundingPrecisionFCY);
              "Line Amount" := "Total Price" - "Line Discount Amount";
            end;

      "Line Amount (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Currency Date","Currency Code",
            "Line Amount","Currency Factor"),
          AmountRoundingPrecision);

      "Line Discount Amount (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Currency Date","Currency Code",
            "Line Discount Amount","Currency Factor"),
          AmountRoundingPrecision);
    end;
*/


    
//     procedure Use (PostedQty@1001 : Decimal;PostedTotalCost@1000 : Decimal;PostedLineAmount@1002 : Decimal;PostingDate@1003 : Date;CurrencyFactor@1004 :
    
/*
procedure Use (PostedQty: Decimal;PostedTotalCost: Decimal;PostedLineAmount: Decimal;PostingDate: Date;CurrencyFactor: Decimal)
    begin
      if "Usage Link" then begin
        InitRoundingPrecisions;
        // Update Quantity Posted
        VALIDATE("Qty. Posted","Qty. Posted" + PostedQty);

        // Update Posted Costs and Amounts.
        "Posted Total Cost" += ROUND(PostedTotalCost,AmountRoundingPrecisionFCY);
        "Posted Total Cost (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              PostingDate,"Currency Code",
              "Posted Total Cost",CurrencyFactor),
            AmountRoundingPrecision);

        "Posted Line Amount" += ROUND(PostedLineAmount,AmountRoundingPrecisionFCY);
        "Posted Line Amount (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              PostingDate,"Currency Code",
              "Posted Line Amount",CurrencyFactor),
            AmountRoundingPrecision);

        // Update Remaining Quantity
        if (PostedQty >= 0) = ("Remaining Qty." >= 0) then
          if ABS(PostedQty) <= ABS("Remaining Qty.") then
            VALIDATE("Remaining Qty.","Remaining Qty." - PostedQty)
          else begin
            VALIDATE(Quantity,Quantity + PostedQty - "Remaining Qty.");
            VALIDATE("Remaining Qty.",0);
          end
        else
          VALIDATE("Remaining Qty.","Remaining Qty." - PostedQty);

        // Update Remaining Costs and Amounts
        UpdateRemainingCostsAndAmounts(PostingDate,CurrencyFactor);

        // Update Quantity to Post
        VALIDATE("Qty. to Transfer to Journal","Remaining Qty.");
      end else
        ClearValues;

      MODIFY(TRUE);
    end;
*/


//     LOCAL procedure UpdateRemainingCostsAndAmounts (PostingDate@1000 : Date;CurrencyFactor@1001 :
    
/*
LOCAL procedure UpdateRemainingCostsAndAmounts (PostingDate: Date;CurrencyFactor: Decimal)
    begin
      if "Usage Link" then begin
        InitRoundingPrecisions;
        "Remaining Total Cost" := ROUND("Unit Cost" * "Remaining Qty.",AmountRoundingPrecisionFCY);
        "Remaining Total Cost (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              PostingDate,"Currency Code",
              "Remaining Total Cost",CurrencyFactor),
            AmountRoundingPrecision);
        "Remaining Line Amount" := CalcLineAmount("Remaining Qty.");
        "Remaining Line Amount (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              PostingDate,"Currency Code",
              "Remaining Line Amount",CurrencyFactor),
            AmountRoundingPrecision);
      end else
        ClearValues;
    end;
*/


    
    
/*
procedure UpdateQtyToTransfer ()
    begin
      if "Contract Line" then begin
        CALCFIELDS("Qty. Transferred to Invoice");
        VALIDATE("Qty. to Transfer to Invoice",Quantity - "Qty. Transferred to Invoice");
      end else
        VALIDATE("Qty. to Transfer to Invoice",0);
    end;
*/


    
    
/*
procedure UpdateQtyToInvoice ()
    begin
      if "Contract Line" then begin
        CALCFIELDS("Qty. Invoiced");
        VALIDATE("Qty. to Invoice",Quantity - "Qty. Invoiced")
      end else
        VALIDATE("Qty. to Invoice",0);
    end;
*/


    
//     procedure UpdatePostedTotalCost (AdjustJobCost@1000 : Decimal;AdjustJobCostLCY@1001 :
    
/*
procedure UpdatePostedTotalCost (AdjustJobCost: Decimal;AdjustJobCostLCY: Decimal)
    begin
      if "Usage Link" then begin
        InitRoundingPrecisions;
        "Posted Total Cost" += ROUND(AdjustJobCost,AmountRoundingPrecisionFCY);
        "Posted Total Cost (LCY)" += ROUND(AdjustJobCostLCY,AmountRoundingPrecision);
      end;
    end;
*/


//     LOCAL procedure ValidateModification (FieldChanged@1000 :
    
/*
LOCAL procedure ValidateModification (FieldChanged: Boolean)
    begin
      if FieldChanged then begin
        CALCFIELDS("Qty. Transferred to Invoice");
        TESTFIELD("Qty. Transferred to Invoice",0);
      end;

      OnAfterValidateModification(Rec,FieldChanged);
    end;
*/


    
/*
LOCAL procedure CheckUsageLinkRelations ()
    var
//       JobUsageLink@1000 :
      JobUsageLink: Record 1020;
    begin
      JobUsageLink.SETRANGE("Job No.","Job No.");
      JobUsageLink.SETRANGE("Job Task No.","Job Task No.");
      JobUsageLink.SETRANGE("Line No.","Line No.");
      if not JobUsageLink.ISEMPTY then
        ERROR(LinkedJobLedgerErr);
    end;
*/


    
/*
LOCAL procedure ControlUsageLink ()
    var
//       JobUsageLink@1000 :
      JobUsageLink: Record 1020;
    begin
      GetJob;

      if Job."Apply Usage Link" then begin
        if "Schedule Line" then
          "Usage Link" := TRUE
        else
          "Usage Link" := FALSE;
      end else begin
        if not "Schedule Line" then
          "Usage Link" := FALSE;
      end;

      JobUsageLink.SETRANGE("Job No.","Job No.");
      JobUsageLink.SETRANGE("Job Task No.","Job Task No.");
      JobUsageLink.SETRANGE("Line No.","Line No.");
      if not JobUsageLink.ISEMPTY and not "Usage Link" then
        ERROR(ControlUsageLinkErr,TABLECAPTION,FIELDCAPTION("Schedule Line"),FIELDCAPTION("Usage Link"));

      VALIDATE("Remaining Qty.",Quantity - "Qty. Posted");
      VALIDATE("Qty. to Transfer to Journal",Quantity - "Qty. Posted");
      UpdateRemainingCostsAndAmounts("Currency Date","Currency Factor");

      UpdateQtyToTransfer;
      UpdateQtyToInvoice;
    end;
*/


//     LOCAL procedure CalcLineAmount (Qty@1000 :
    
/*
LOCAL procedure CalcLineAmount (Qty: Decimal) : Decimal;
    var
//       TotalPrice@1001 :
      TotalPrice: Decimal;
    begin
      InitRoundingPrecisions;
      TotalPrice := ROUND(Qty * "Unit Price",AmountRoundingPrecisionFCY);
      exit(TotalPrice - ROUND(TotalPrice * "Line Discount %" / 100,AmountRoundingPrecisionFCY));
    end;
*/


    
    
/*
procedure Overdue () : Boolean;
    begin
      if ("Planning Date" < WORKDATE) and ("Remaining Qty." > 0) then
        exit(TRUE);
      exit(FALSE);
    end;
*/


    
//     procedure SetBypassQtyValidation (Bypass@1000 :
    
/*
procedure SetBypassQtyValidation (Bypass: Boolean)
    begin
      BypassQtyValidation := Bypass;
    end;
*/


//     LOCAL procedure UpdateReservation (CalledByFieldNo@1000 :
    
/*
LOCAL procedure UpdateReservation (CalledByFieldNo: Integer)
    var
//       ReservationCheckDateConfl@1001 :
      ReservationCheckDateConfl: Codeunit 99000815;
    begin
      if (CurrFieldNo <> CalledByFieldNo) and (CurrFieldNo <> 0) then
        exit;
      CASE CalledByFieldNo OF
        FIELDNO("Planning Date"),FIELDNO("Planned Delivery Date"):
          if (xRec."Planning Date" <> "Planning Date") and
             (Quantity <> 0) and
             (Reserve <> Reserve::Never)
          then
            ReservationCheckDateConfl.JobPlanningLineCheck(Rec,TRUE);
        FIELDNO(Quantity):
          JobPlanningLineReserve.VerifyQuantity(Rec,xRec);
        FIELDNO("Usage Link"):
          if (Type = Type::Item) and "Usage Link" then begin
            GetItem;
            if Item.Reserve = Item.Reserve::Optional then begin
              GetJob;
              Reserve := Job.Reserve
            end else
              Reserve := Item.Reserve;
          end else
            Reserve := Reserve::Never;
      end;
      JobPlanningLineReserve.VerifyChange(Rec,xRec);
      UpdatePlanned;
    end;
*/


    
/*
LOCAL procedure UpdateDescription ()
    begin
      if (xRec.Type = xRec.Type::Resource) and (xRec."No." <> '') then begin
        Res.GET(xRec."No.");
        if Description = Res.Name then
          Description := '';
        if "Description 2" = Res."Name 2" then
          "Description 2" := '';
      end;
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
      TESTFIELD("Usage Link");
      Reservation.SetJobPlanningLine(Rec);
      Reservation.RUNMODAL;
    end;
*/


    
//     procedure ShowReservationEntries (Modal@1000 :
    
/*
procedure ShowReservationEntries (Modal: Boolean)
    var
//       ReservEntry@1003 :
      ReservEntry: Record 337;
//       ReservEngineMgt@1001 :
      ReservEngineMgt: Codeunit 99000831;
    begin
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
      JobPlanningLineReserve.FilterReservFor(ReservEntry,Rec);
      if Modal then
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      else
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    end;
*/


    
    
/*
procedure AutoReserve ()
    var
//       ReservMgt@1000 :
      ReservMgt: Codeunit 99000845;
//       FullAutoReservation@1001 :
      FullAutoReservation: Boolean;
//       QtyToReserve@1002 :
      QtyToReserve: Decimal;
//       QtyToReserveBase@1003 :
      QtyToReserveBase: Decimal;
    begin
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      if Reserve = Reserve::Never then
        FIELDERROR(Reserve);
      JobPlanningLineReserve.ReservQuantity(Rec,QtyToReserve,QtyToReserveBase);
      if QtyToReserveBase <> 0 then begin
        ReservMgt.SetJobPlanningLine(Rec);
        TESTFIELD("Planning Date");
        ReservMgt.AutoReserve(FullAutoReservation,'',"Planning Date",QtyToReserve,QtyToReserveBase);
        FIND;
        if not FullAutoReservation then begin
          COMMIT;
          if CONFIRM(AutoReserveQst,TRUE) then begin
            ShowReservation;
            FIND;
          end;
        end;
        UpdatePlanned;
      end;
    end;
*/


    
    
/*
procedure ShowTracking ()
    var
//       OrderTrackingForm@1000 :
      OrderTrackingForm: Page 99000822;
    begin
      OrderTrackingForm.SetJobPlanningLine(Rec);
      OrderTrackingForm.RUNMODAL;
    end;
*/


    
    
/*
procedure ShowOrderPromisingLine ()
    var
//       OrderPromisingLine@1000 :
      OrderPromisingLine: Record 99000880;
//       OrderPromisingLines@1001 :
      OrderPromisingLines: Page 99000959;
    begin
      OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::Job);
      OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::Job);
      OrderPromisingLine.SETRANGE("Source ID","Job No.");
      OrderPromisingLine.SETRANGE("Source Line No.","Job Contract Entry No.");

      OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::Job);
      OrderPromisingLines.SETTABLEVIEW(OrderPromisingLine);
      OrderPromisingLines.RUNMODAL;
    end;
*/


    
//     procedure FilterLinesWithItemToPlan (var Item@1000 :
    
/*
procedure FilterLinesWithItemToPlan (var Item: Record 27)
    begin
      RESET;
      SETCURRENTKEY(Status,Type,"No.","Variant Code","Location Code","Planning Date");
      SETRANGE(Status,Status::Order);
      SETRANGE(Type,Type::Item);
      SETRANGE("No.",Item."No.");
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Planning Date",Item.GETFILTER("Date Filter"));
      SETFILTER("Remaining Qty. (Base)",'<>0');
    end;
*/


    
//     procedure FindLinesWithItemToPlan (var Item@1000 :
    
/*
procedure FindLinesWithItemToPlan (var Item: Record 27) : Boolean;
    begin
      FilterLinesWithItemToPlan(Item);
      exit(FIND('-'));
    end;
*/


    
//     procedure LinesWithItemToPlanExist (var Item@1000 :
    
/*
procedure LinesWithItemToPlanExist (var Item: Record 27) : Boolean;
    begin
      FilterLinesWithItemToPlan(Item);
      exit(not ISEMPTY);
    end;
*/


    
    
/*
procedure DrillDownJobInvoices ()
    var
//       JobInvoices@1000 :
      JobInvoices: Page 1029;
    begin
      JobInvoices.SetShowDetails(FALSE);
      JobInvoices.SetPrJobPlanningLine(Rec);
      JobInvoices.RUN;
    end;
*/


    
/*
LOCAL procedure CheckRelatedJobPlanningLineInvoice ()
    var
//       JobPlanningLineInvoice@1000 :
      JobPlanningLineInvoice: Record 1022;
    begin
      JobPlanningLineInvoice.SETRANGE("Job No.","Job No.");
      JobPlanningLineInvoice.SETRANGE("Job Task No.","Job Task No.");
      JobPlanningLineInvoice.SETRANGE("Job Planning Line No.","Line No.");
      if not JobPlanningLineInvoice.ISEMPTY then
        ERROR(NotPossibleJobPlanningLineErr);
    end;
*/


    
    
/*
procedure RowID1 () : Text[250];
    var
//       ItemTrackingMgt@1000 :
      ItemTrackingMgt: Codeunit 6500;
    begin
      exit(
        ItemTrackingMgt.ComposeRowID(DATABASE::"Job Planning Line",Status,
          "Job No.",'',0,"Job Contract Entry No."));
    end;
*/


    
    
/*
procedure UpdatePlanned () : Boolean;
    begin
      CALCFIELDS("Reserved Quantity");
      if Planned = ("Reserved Quantity" = "Remaining Qty.") then
        exit(FALSE);
      Planned := not Planned;
      exit(TRUE);
    end;
*/


    
    
/*
procedure ClearValues ()
    begin
      VALIDATE("Remaining Qty.",0);
      "Remaining Total Cost" := 0;
      "Remaining Total Cost (LCY)" := 0;
      "Remaining Line Amount" := 0;
      "Remaining Line Amount (LCY)" := 0;
      VALIDATE("Qty. Posted",0);
      VALIDATE("Qty. to Transfer to Journal",0);
      "Posted Total Cost" := 0;
      "Posted Total Cost (LCY)" := 0;
      "Posted Line Amount" := 0;
      "Posted Line Amount (LCY)" := 0;
    end;
*/


    
//     procedure InitFromJobPlanningLine (FromJobPlanningLine@1000 : Record 1003;NewQuantity@1001 :
    
/*
procedure InitFromJobPlanningLine (FromJobPlanningLine: Record 1003;NewQuantity: Decimal)
    var
//       ToJobPlanningLine@1003 :
      ToJobPlanningLine: Record 1003;
//       JobJnlManagement@1002 :
      JobJnlManagement: Codeunit 1020;
    begin
      ToJobPlanningLine := Rec;

      ToJobPlanningLine.INIT;
      ToJobPlanningLine.TRANSFERFIELDS(FromJobPlanningLine);
      ToJobPlanningLine."Line No." := GetNextJobLineNo(FromJobPlanningLine);
      ToJobPlanningLine.VALIDATE("Line Type","Line Type"::Billable);
      ToJobPlanningLine.ClearValues;
      ToJobPlanningLine."Job Contract Entry No." := JobJnlManagement.GetNextEntryNo;
      if ToJobPlanningLine.Type <> ToJobPlanningLine.Type::Text then begin
        ToJobPlanningLine.VALIDATE(Quantity,NewQuantity);
        ToJobPlanningLine.VALIDATE("Currency Code",FromJobPlanningLine."Currency Code");
        ToJobPlanningLine.VALIDATE("Currency Date",FromJobPlanningLine."Currency Date");
        ToJobPlanningLine.VALIDATE("Currency Factor",FromJobPlanningLine."Currency Factor");
        ToJobPlanningLine.VALIDATE("Unit Cost",FromJobPlanningLine."Unit Cost");
        ToJobPlanningLine.VALIDATE("Unit Price",FromJobPlanningLine."Unit Price");
      end;

      Rec := ToJobPlanningLine;
    end;
*/


//     LOCAL procedure GetNextJobLineNo (FromJobPlanningLine@1000 :
    
/*
LOCAL procedure GetNextJobLineNo (FromJobPlanningLine: Record 1003) : Integer;
    var
//       JobPlanningLine@1001 :
      JobPlanningLine: Record 1003;
    begin
      JobPlanningLine.SETRANGE("Job No.",FromJobPlanningLine."Job No.");
      JobPlanningLine.SETRANGE("Job Task No.",FromJobPlanningLine."Job Task No.");
      if JobPlanningLine.FINDLAST then;
      exit(JobPlanningLine."Line No." + 10000);
    end;
*/


    
    
/*
procedure IsNonInventoriableItem () : Boolean;
    begin
      if Type <> Type::Item then
        exit(FALSE);
      if "No." = '' then
        exit(FALSE);
      GetItem;
      exit(Item.IsNonInventoriableType);
    end;
*/


    
//     LOCAL procedure OnAfterInitJobPlanningLine (var JobPlanningLine@1000 :
    
/*
LOCAL procedure OnAfterInitJobPlanningLine (var JobPlanningLine: Record 1003)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterResourceFindCost (var JobPlanningLine@1000 : Record 1003;var ResourceCost@1001 :
    
/*
LOCAL procedure OnAfterResourceFindCost (var JobPlanningLine: Record 1003;var ResourceCost: Record 202)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterSetupNewLine (var JobPlanningLine@1000 : Record 1003;LastJobPlanningLine@1001 :
    
/*
LOCAL procedure OnAfterSetupNewLine (var JobPlanningLine: Record 1003;LastJobPlanningLine: Record 1003)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterValidateModification (var JobPlanningLine@1000 : Record 1003;FieldChanged@1001 :
    
/*
LOCAL procedure OnAfterValidateModification (var JobPlanningLine: Record 1003;FieldChanged: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeRetrieveCostPrice (var JobPlanningLine@1000 : Record 1003;xJobPlanningLine@1001 : Record 1003;var ShouldRetrieveCostPrice@1002 : Boolean;var IsHandled@1003 :
    
/*
LOCAL procedure OnBeforeRetrieveCostPrice (var JobPlanningLine: Record 1003;xJobPlanningLine: Record 1003;var ShouldRetrieveCostPrice: Boolean;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeUpdateAllAmounts (var JobPlanningLine@1000 :
    
/*
LOCAL procedure OnBeforeUpdateAllAmounts (var JobPlanningLine: Record 1003)
    begin
    end;

    /*begin
    //{
//      CPA 29/03/22: Q16867 - Mejora de rendimiento
//          - Nueva Clave: Job No.,Contract Line,Qty. to Invoice,Planing Date
//    }
    end.
  */
}





