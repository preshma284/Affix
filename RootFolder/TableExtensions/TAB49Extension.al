tableextension 50119 "MyExtension50119" extends "Invoice Post. Buffer"
{
  
  /*
ReplicateData=false;
*/
    CaptionML=ENU='Invoice Post. Buffer',ESP='Mem. inter. factura';
  
  fields
{
    field(50000;"Texto";Text[100])
    {
        DataClassification=ToBeClassified;
                                                   Description='BS::20717';


    }
    field(7174361;"DP Prorrata %";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='IVA Prorrata Percentage',ESP='Porcentaje IVA Prorrata';
                                                   DecimalPlaces=0:0;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='DP 1.00.00 JAV 21/06/22: PRORRATA';
                                                   Editable=false;


    }
    field(7174362;"DP Non Deductible %";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='IVA non Deductible Percentage',ESP='Porcentaje IVA no Deducible';
                                                   DecimalPlaces=0:0;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='DP 1.00.04 JAV 14/07/22: IVA NO DEDUCIBLE';
                                                   Editable=false;


    }
    field(7207270;"Location Code";Code[20])
    {
        TableRelation="Location";
                                                   CaptionML=ENU='Location Code',ESP='Cod. Almacen';
                                                   Description='QB';


    }
    field(7207271;"Job Task No.";Code[20])
    {
        TableRelation="Job Task"."Job Task No." WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Job Task No.',ESP='No. tarea proyecto';
                                                   Description='QB';


    }
    field(7207272;"Piecework Code";Code[20])
    {
        CaptionML=ENU='Piecework Code',ESP='Cod. unidad de obra';
                                                   Description='QB' ;


    }
}
  keys
{
   // key(key1;"Type","G/L Account","Gen. Bus. Posting Group","Gen. Prod. Posting Group","VAT Bus. Posting Group","VAT Prod. Posting Group","Tax Area Code","Tax Group Code","Tax Liable","Use Tax","Dimension Set ID","Job No.","Fixed Asset Line No.","Deferral Code","Additional Grouping Identifier")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       DimMgt@1000 :
      DimMgt: Codeunit 408;

    
//     procedure PrepareSales (var SalesLine@1000 :
    
/*
procedure PrepareSales (var SalesLine: Record 37)
    begin
      CLEAR(Rec);
      Type := SalesLine.Type;
      "System-Created Entry" := TRUE;
      "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
      "VAT Calculation Type" := SalesLine."VAT Calculation Type";
      "Global Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := SalesLine."Dimension Set ID";
      "Job No." := SalesLine."Job No.";
      "VAT %" := SalesLine."VAT %" + SalesLine."EC %";
      "VAT Difference" := SalesLine."VAT Difference";
      if Type = Type::"Fixed Asset" then begin
        "FA Posting Date" := SalesLine."FA Posting Date";
        "Depreciation Book Code" := SalesLine."Depreciation Book Code";
        "Depr. until FA Posting Date" := SalesLine."Depr. until FA Posting Date";
        "Duplicate in Depreciation Book" := SalesLine."Duplicate in Depreciation Book";
        "Use Duplication List" := SalesLine."Use Duplication List";
      end;

      if "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" then
        SetSalesTaxForSalesLine(SalesLine);

      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Global Dimension 2 Code");

      if SalesLine."Line Discount %" = 100 then begin
        "VAT Base Amount" := 0;
        "VAT Base Amount (ACY)" := 0;
        "VAT Amount" := 0;
        "VAT Amount (ACY)" := 0;
      end;

      OnAfterInvPostBufferPrepareSales(SalesLine,Rec);
    end;
*/


    
//     procedure CalcDiscount (PricesInclVAT@1000 : Boolean;DiscountAmount@1001 : Decimal;DiscountAmountACY@1002 :
    
/*
procedure CalcDiscount (PricesInclVAT: Boolean;DiscountAmount: Decimal;DiscountAmountACY: Decimal)
    var
//       CurrencyLCY@1003 :
      CurrencyLCY: Record 4;
//       CurrencyACY@1004 :
      CurrencyACY: Record 4;
//       GLSetup@1005 :
      GLSetup: Record 98;
    begin
      CurrencyLCY.InitRoundingPrecision;
      GLSetup.GET;
      if GLSetup."Additional Reporting Currency" <> '' then
        CurrencyACY.GET(GLSetup."Additional Reporting Currency")
      else
        CurrencyACY := CurrencyLCY;
      "VAT Amount" := ROUND(
          CalcVATAmount(PricesInclVAT,DiscountAmount,"VAT %"),
          CurrencyLCY."Amount Rounding Precision",
          CurrencyLCY.VATRoundingDirection);
      "VAT Amount (ACY)" := ROUND(
          CalcVATAmount(PricesInclVAT,DiscountAmountACY,"VAT %"),
          CurrencyACY."Amount Rounding Precision",
          CurrencyACY.VATRoundingDirection);

      if PricesInclVAT and ("VAT %" <> 0) then begin
        "VAT Base Amount" := DiscountAmount - "VAT Amount";
        "VAT Base Amount (ACY)" := DiscountAmountACY - "VAT Amount (ACY)";
      end else begin
        "VAT Base Amount" := DiscountAmount;
        "VAT Base Amount (ACY)" := DiscountAmountACY;
      end;
      Amount := "VAT Base Amount";
      "Amount (ACY)" := "VAT Base Amount (ACY)";
      "VAT Base Before Pmt. Disc." := "VAT Base Amount"
    end;
*/


//     LOCAL procedure CalcVATAmount (ValueInclVAT@1000 : Boolean;Value@1001 : Decimal;VATPercent@1002 :
    
/*
LOCAL procedure CalcVATAmount (ValueInclVAT: Boolean;Value: Decimal;VATPercent: Decimal) : Decimal;
    begin
      if VATPercent = 0 then
        exit(0);
      if ValueInclVAT then
        exit(Value / (1 + (VATPercent / 100)) * (VATPercent / 100));

      exit(Value * (VATPercent / 100));
    end;
*/


    
//     procedure SetAccount (AccountNo@1000 : Code[20];var TotalVAT@1004 : Decimal;var TotalVATACY@1003 : Decimal;var TotalAmount@1002 : Decimal;var TotalAmountACY@1001 :
    
/*
procedure SetAccount (AccountNo: Code[20];var TotalVAT: Decimal;var TotalVATACY: Decimal;var TotalAmount: Decimal;var TotalAmountACY: Decimal)
    begin
      TotalVAT := TotalVAT - "VAT Amount";
      TotalVATACY := TotalVATACY - "VAT Amount (ACY)";
      TotalAmount := TotalAmount - Amount;
      TotalAmountACY := TotalAmountACY - "Amount (ACY)";
      "G/L Account" := AccountNo;
    end;
*/


    
//     procedure SetAmounts (TotalVAT@1003 : Decimal;TotalVATACY@1002 : Decimal;TotalAmount@1001 : Decimal;TotalAmountACY@1000 : Decimal;VATDifference@1004 : Decimal;TotalVATBase@1006 : Decimal;TotalVATBaseACY@1005 :
    
/*
procedure SetAmounts (TotalVAT: Decimal;TotalVATACY: Decimal;TotalAmount: Decimal;TotalAmountACY: Decimal;VATDifference: Decimal;TotalVATBase: Decimal;TotalVATBaseACY: Decimal)
    begin
      Amount := TotalAmount;
      "VAT Base Amount" := TotalVATBase;
      "VAT Amount" := TotalVAT;
      "Amount (ACY)" := TotalAmountACY;
      "VAT Base Amount (ACY)" := TotalVATBaseACY;
      "VAT Amount (ACY)" := TotalVATACY;
      "VAT Difference" := VATDifference;
      "VAT Base Before Pmt. Disc." := TotalAmount;
    end;
*/


    
//     procedure PreparePurchase (var PurchLine@1000 :
    
/*
procedure PreparePurchase (var PurchLine: Record 39)
    begin
      CLEAR(Rec);
      Type := PurchLine.Type;
      "System-Created Entry" := TRUE;
      "Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := PurchLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := PurchLine."VAT Prod. Posting Group";
      "VAT Calculation Type" := PurchLine."VAT Calculation Type";
      "Global Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := PurchLine."Dimension Set ID";
      "Job No." := PurchLine."Job No.";
      "VAT %" := PurchLine."VAT %" + PurchLine."EC %";
      "VAT Difference" := PurchLine."VAT Difference";
      if Type = Type::"Fixed Asset" then begin
        "FA Posting Date" := PurchLine."FA Posting Date";
        "Depreciation Book Code" := PurchLine."Depreciation Book Code";
        "Depr. until FA Posting Date" := PurchLine."Depr. until FA Posting Date";
        "Duplicate in Depreciation Book" := PurchLine."Duplicate in Depreciation Book";
        "Use Duplication List" := PurchLine."Use Duplication List";
        "FA Posting Type" := PurchLine."FA Posting Type";
        "Depreciation Book Code" := PurchLine."Depreciation Book Code";
        "Salvage Value" := PurchLine."Salvage Value";
        "Depr. Acquisition Cost" := PurchLine."Depr. Acquisition Cost";
        "Maintenance Code" := PurchLine."Maintenance Code";
        "Insurance No." := PurchLine."Insurance No.";
        "Budgeted FA No." := PurchLine."Budgeted FA No.";
      end;

      if "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" then
        SetSalesTaxForPurchLine(PurchLine);

      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Global Dimension 2 Code");

      if PurchLine."Line Discount %" = 100 then begin
        "VAT Base Amount" := 0;
        "VAT Base Amount (ACY)" := 0;
        "VAT Amount" := 0;
        "VAT Amount (ACY)" := 0;
      end;

      OnAfterInvPostBufferPreparePurchase(PurchLine,Rec);
    end;
*/


    
//     procedure CalcDiscountNoVAT (DiscountAmount@1001 : Decimal;DiscountAmountACY@1002 :
    
/*
procedure CalcDiscountNoVAT (DiscountAmount: Decimal;DiscountAmountACY: Decimal)
    begin
      "VAT Base Amount" := DiscountAmount;
      "VAT Base Amount (ACY)" := DiscountAmountACY;
      Amount := "VAT Base Amount";
      "Amount (ACY)" := "VAT Base Amount (ACY)";
      "VAT Base Before Pmt. Disc." := "VAT Base Amount";
    end;
*/


    
//     procedure SetSalesTaxForPurchLine (PurchaseLine@1000 :
    
/*
procedure SetSalesTaxForPurchLine (PurchaseLine: Record 39)
    begin
      "Tax Area Code" := PurchaseLine."Tax Area Code";
      "Tax Liable" := PurchaseLine."Tax Liable";
      "Tax Group Code" := PurchaseLine."Tax Group Code";
      "Use Tax" := PurchaseLine."Use Tax";
      Quantity := PurchaseLine."Qty. to Invoice (Base)";
    end;
*/


    
//     procedure SetSalesTaxForSalesLine (SalesLine@1000 :
    
/*
procedure SetSalesTaxForSalesLine (SalesLine: Record 37)
    begin
      "Tax Area Code" := SalesLine."Tax Area Code";
      "Tax Liable" := SalesLine."Tax Liable";
      "Tax Group Code" := SalesLine."Tax Group Code";
      "Use Tax" := FALSE;
      Quantity := SalesLine."Qty. to Invoice (Base)";
    end;
*/


    
    
/*
procedure ReverseAmounts ()
    begin
      Amount := -Amount;
      "VAT Base Amount" := -"VAT Base Amount";
      "Amount (ACY)" := -"Amount (ACY)";
      "VAT Base Amount (ACY)" := -"VAT Base Amount (ACY)";
      "VAT Amount" := -"VAT Amount";
      "VAT Amount (ACY)" := -"VAT Amount (ACY)";
    end;
*/


    
//     procedure SetAmountsNoVAT (TotalAmount@1001 : Decimal;TotalAmountACY@1000 : Decimal;VATDifference@1004 :
    
/*
procedure SetAmountsNoVAT (TotalAmount: Decimal;TotalAmountACY: Decimal;VATDifference: Decimal)
    begin
      Amount := TotalAmount;
      "VAT Base Amount" := TotalAmount;
      "VAT Amount" := 0;
      "Amount (ACY)" := TotalAmountACY;
      "VAT Base Amount (ACY)" := TotalAmountACY;
      "VAT Amount (ACY)" := 0;
      "VAT Difference" := VATDifference;
    end;
*/


    
//     procedure PrepareService (var ServiceLine@1000 :
    
/*
procedure PrepareService (var ServiceLine: Record 5902)
    begin
      CLEAR(Rec);
      CASE ServiceLine.Type OF
        ServiceLine.Type::Item:
          Type := Type::Item;
        ServiceLine.Type::Resource:
          Type := Type::Resource;
        ServiceLine.Type::"G/L Account":
          Type := Type::"G/L Account";
      end;
      "System-Created Entry" := TRUE;
      "Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := ServiceLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := ServiceLine."VAT Prod. Posting Group";
      "VAT Calculation Type" := ServiceLine."VAT Calculation Type";
      "Global Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServiceLine."Dimension Set ID";
      "Job No." := ServiceLine."Job No.";
      "VAT %" := ServiceLine."VAT %" + ServiceLine."EC %";
      "VAT Difference" := ServiceLine."VAT Difference";
      if "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" then begin
        "Tax Area Code" := ServiceLine."Tax Area Code";
        "Tax Group Code" := ServiceLine."Tax Group Code";
        "Tax Liable" := ServiceLine."Tax Liable";
        "Use Tax" := FALSE;
        Quantity := ServiceLine."Qty. to Invoice (Base)";
      end;

      OnAfterInvPostBufferPrepareService(ServiceLine,Rec);
    end;
*/


    
//     procedure FillPrepmtAdjBuffer (var TempInvoicePostBuffer@1005 : TEMPORARY Record 49;InvoicePostBuffer@1006 : Record 49;GLAccountNo@1001 : Code[20];AdjAmount@1003 : Decimal;RoundingEntry@1004 :
    
/*
procedure FillPrepmtAdjBuffer (var TempInvoicePostBuffer: Record 49 TEMPORARY;InvoicePostBuffer: Record 49;GLAccountNo: Code[20];AdjAmount: Decimal;RoundingEntry: Boolean)
    var
//       PrepmtAdjInvPostBuffer@1002 :
      PrepmtAdjInvPostBuffer: Record 49;
    begin
      WITH PrepmtAdjInvPostBuffer DO begin
        INIT;
        Type := Type::"Prepmt. Exch. Rate Difference";
        "G/L Account" := GLAccountNo;
        Amount := AdjAmount;
        if RoundingEntry then
          "Amount (ACY)" := AdjAmount
        else
          "Amount (ACY)" := 0;
        "Dimension Set ID" := InvoicePostBuffer."Dimension Set ID";
        "Global Dimension 1 Code" := InvoicePostBuffer."Global Dimension 1 Code";
        "Global Dimension 2 Code" := InvoicePostBuffer."Global Dimension 2 Code";
        "System-Created Entry" := TRUE;
        InvoicePostBuffer := PrepmtAdjInvPostBuffer;

        TempInvoicePostBuffer := InvoicePostBuffer;
        if TempInvoicePostBuffer.FIND then begin
          TempInvoicePostBuffer.Amount += InvoicePostBuffer.Amount;
          TempInvoicePostBuffer."Amount (ACY)" += InvoicePostBuffer."Amount (ACY)";
          TempInvoicePostBuffer.MODIFY;
        end else begin
          TempInvoicePostBuffer := InvoicePostBuffer;
          TempInvoicePostBuffer.INSERT;
        end;
      end;
    end;
*/


    
//     procedure Update (InvoicePostBuffer@1000 : Record 49;var InvDefLineNo@1001 : Integer;var DeferralLineNo@1002 :
    
/*
procedure Update (InvoicePostBuffer: Record 49;var InvDefLineNo: Integer;var DeferralLineNo: Integer)
    begin
      OnBeforeInvPostBufferUpdate(Rec,InvoicePostBuffer);

      Rec := InvoicePostBuffer;
      if FIND then begin
        Amount += InvoicePostBuffer.Amount;
        "VAT Amount" += InvoicePostBuffer."VAT Amount";
        "VAT Base Amount" += InvoicePostBuffer."VAT Base Amount";
        "Amount (ACY)" += InvoicePostBuffer."Amount (ACY)";
        "VAT Amount (ACY)" += InvoicePostBuffer."VAT Amount (ACY)";
        "VAT Difference" += InvoicePostBuffer."VAT Difference";
        "VAT Base Amount (ACY)" += InvoicePostBuffer."VAT Base Amount (ACY)";
        Quantity += InvoicePostBuffer.Quantity;
        "VAT Base Before Pmt. Disc." += InvoicePostBuffer."VAT Base Before Pmt. Disc.";
        if not InvoicePostBuffer."System-Created Entry" then
          "System-Created Entry" := FALSE;
        if "Deferral Code" = '' then
          AdjustRoundingForUpdate;
        OnBeforeInvPostBufferModify(Rec,InvoicePostBuffer);
        MODIFY;
        OnAfterInvPostBufferModify(Rec,InvoicePostBuffer);
        InvDefLineNo := "Deferral Line No.";
      end else begin
        if "Deferral Code" <> '' then begin
          DeferralLineNo := DeferralLineNo + 1;
          "Deferral Line No." := DeferralLineNo;
          InvDefLineNo := "Deferral Line No.";
        end;
        INSERT;
      end;

      OnAfterInvPostBufferUpdate(Rec,InvoicePostBuffer);
    end;
*/


    
//     procedure UpdateVATBase (var TotalVATBase@1001 : Decimal;var TotalVATBaseACY@1000 :
    
/*
procedure UpdateVATBase (var TotalVATBase: Decimal;var TotalVATBaseACY: Decimal)
    begin
      TotalVATBase := TotalVATBase - "VAT Base Amount";
      TotalVATBaseACY := TotalVATBaseACY - "VAT Base Amount (ACY)"
    end;
*/


    
/*
LOCAL procedure AdjustRoundingForUpdate ()
    begin
      AdjustRoundingFieldsPair(Amount,"Amount (ACY)");
      AdjustRoundingFieldsPair("VAT Amount","VAT Amount (ACY)");
      AdjustRoundingFieldsPair("VAT Base Amount","VAT Base Amount (ACY)");
    end;
*/


//     LOCAL procedure AdjustRoundingFieldsPair (var Value1@1000 : Decimal;var Value2@1001 :
    
/*
LOCAL procedure AdjustRoundingFieldsPair (var Value1: Decimal;var Value2: Decimal)
    begin
      if (Value1 = 0) and (Value2 <> 0) then
        Value2 := 0;
      if (Value1 <> 0) and (Value2 = 0) then
        Value1 := 0;
    end;
*/


    
//     LOCAL procedure OnAfterInvPostBufferPrepareSales (var SalesLine@1000 : Record 37;var InvoicePostBuffer@1001 :
    
/*
LOCAL procedure OnAfterInvPostBufferPrepareSales (var SalesLine: Record 37;var InvoicePostBuffer: Record 49)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInvPostBufferPreparePurchase (var PurchaseLine@1000 : Record 39;var InvoicePostBuffer@1001 :
    
/*
LOCAL procedure OnAfterInvPostBufferPreparePurchase (var PurchaseLine: Record 39;var InvoicePostBuffer: Record 49)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInvPostBufferPrepareService (var ServiceLine@1000 : Record 5902;var InvoicePostBuffer@1001 :
    
/*
LOCAL procedure OnAfterInvPostBufferPrepareService (var ServiceLine: Record 5902;var InvoicePostBuffer: Record 49)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInvPostBufferModify (var InvoicePostBuffer@1000 : Record 49;FromInvoicePostBuffer@1001 :
    
/*
LOCAL procedure OnAfterInvPostBufferModify (var InvoicePostBuffer: Record 49;FromInvoicePostBuffer: Record 49)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterInvPostBufferUpdate (var InvoicePostBuffer@1000 : Record 49;var FromInvoicePostBuffer@1001 :
    
/*
LOCAL procedure OnAfterInvPostBufferUpdate (var InvoicePostBuffer: Record 49;var FromInvoicePostBuffer: Record 49)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeInvPostBufferUpdate (var InvoicePostBuffer@1000 : Record 49;var FromInvoicePostBuffer@1001 :
    
/*
LOCAL procedure OnBeforeInvPostBufferUpdate (var InvoicePostBuffer: Record 49;var FromInvoicePostBuffer: Record 49)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeInvPostBufferModify (var InvoicePostBuffer@1000 : Record 49;FromInvoicePostBuffer@1001 :
    
/*
LOCAL procedure OnBeforeInvPostBufferModify (var InvoicePostBuffer: Record 49;FromInvoicePostBuffer: Record 49)
    begin
    end;

    /*begin
    //{
//      JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos para el manejo de la prorrata: "DP Prorrata %". Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
//      BS::20717 23/02/24 Creaci¢n del campo Texto
//    }
    end.
  */
}




