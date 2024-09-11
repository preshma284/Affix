tableextension 50205 "MyExtension50205" extends "Return Receipt Line"
{
  
  /*
Permissions=TableData 32 r,
                TableData 5802 r;
*/
    CaptionML=ENU='Return Receipt Line',ESP='L¡n. recep. devol.';
    LookupPageID="Posted Return Receipt Lines";
  
  fields
{
    field(7207270;"QW % Withholding by G.E";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by G.E',ESP='% retenci¢n por B.E.';
                                                   Description='QB 1.00';


    }
    field(7207271;"QW Withholding Amount by G.E";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Wittholding Amount by G.E',ESP='Importe retenci¢n por B.E.';
                                                   Description='QB 1.00';
                                                   Editable=false;


    }
    field(7207272;"QW % Withholding by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding PIT',ESP='% retenci¢n IRPF';
                                                   Description='QB 1.00';


    }
    field(7207273;"QW Withholding Amount by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Withholding Amount by PIT',ESP='Importe retenci¢n por IRPF';
                                                   Description='QB 1.00';
                                                   Editable=false;


    }
    field(7207280;"Temp Job No";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   Description='QB 1,04 - JAV 12/05/20: Guardo temporalemente el proyecto para poder eliminarlo y volverlo a recuperar tras un proceso';


    }
    field(7207281;"Temp Dimension Set ID";Integer)
    {
        TableRelation="Dimension Set Entry";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Dimension Set ID';
                                                   Description='QB 1,04 - JAV 12/05/20: Guardo temporalemente el ID para poderlo recuperar tras un proceso';
                                                   Editable=false;

trigger OnValidate();
    VAR
//                                                                 DimMgt@1100286000 :
                                                                DimMgt: Codeunit 408;
                                                              BEGIN 
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

trigger OnLookup();
    BEGIN 
                                                              ShowDimensions;
                                                            END;


    }
    field(7207283;"QW Not apply Withholding GE";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='Aplicar retenci¢n por B.E.';
                                                   Description='QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci¢n por Buena Ejecuci¢n a la linea';


    }
    field(7207284;"QW Not apply Withholding PIT";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by PIT',ESP='Aplicar retenci¢n por IRPF';
                                                   Description='QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci¢n por IRPF a la l¡nea';


    }
    field(7207285;"QW Base Withholding by G.E";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by G.E',ESP='Base ret. B.E.';
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
    field(7207287;"QW Withholding by G.E Line";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='L¡nea de retenci¢n de B.E.';
                                                   Description='QB 1.00 - JAV 18/08/19: - Si es la l¡nea donde se calcula la retenci¢n por Buena Ejecuci¢n' ;


    }
}
  keys
{
   // key(key1;"Document No.","Line No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Return Order No.","Return Order Line No.")
  //  {
       /* ;
 */
   // }
   // key(key3;"Blanket Order No.","Blanket Order Line No.")
  //  {
       /* ;
 */
   // }
   // key(key4;"Item Rcpt. Entry No.")
  //  {
       /* ;
 */
   // }
   // key(key5;"Bill-to Customer No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Currency@1000 :
      Currency: Record 4;
//       ReturnRcptHeader@1005 :
      ReturnRcptHeader: Record 6660;
//       Text000@1003 :
      Text000: TextConst ENU='Return Receipt No. %1:',ESP='N§ recep. devol. %1:';
//       Text001@1002 :
      Text001: TextConst ENU='The program cannot find this purchase line.',ESP='El prog. no puede encontrar esta l¡n. compra.';
//       LanguageManagement@1001 :
      LanguageManagement: Codeunit 43;
//       CurrencyRead@1004 :
      CurrencyRead: Boolean;

    
    


/*
trigger OnDelete();    var
//                SalesDocLineComments@1000 :
               SalesDocLineComments: Record 44;
             begin
               SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::"Posted Return Receipt");
               SalesDocLineComments.SETRANGE("No.","Document No.");
               SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
               if not SalesDocLineComments.ISEMPTY then
                 SalesDocLineComments.DELETEALL;
             end;

*/




/*
procedure GetCurrencyCode () : Code[10];
    begin
      if "Document No." = ReturnRcptHeader."No." then
        exit(ReturnRcptHeader."Currency Code");
      if ReturnRcptHeader.GET("Document No.") then
        exit(ReturnRcptHeader."Currency Code");
      exit('');
    end;
*/


    
    
/*
procedure ShowDimensions ()
    var
//       DimMgt@1000 :
      DimMgt: Codeunit 408;
    begin
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Document No.","Line No."));
    end;
*/


    
    
/*
procedure ShowItemTrackingLines ()
    var
//       ItemTrackingDocMgt@1000 :
      ItemTrackingDocMgt: Codeunit 6503;
    begin
      ItemTrackingDocMgt.ShowItemTrackingForShptRcptLine(DATABASE::"Return Receipt Line",0,"Document No.",'',0,"Line No.");
    end;
*/


    
//     procedure InsertInvLineFromRetRcptLine (var SalesLine@1000 :
    
/*
procedure InsertInvLineFromRetRcptLine (var SalesLine: Record 37)
    var
//       SalesHeader@1011 :
      SalesHeader: Record 36;
//       SalesHeader2@1012 :
      SalesHeader2: Record 36;
//       SalesOrderHeader@1010 :
      SalesOrderHeader: Record 36;
//       SalesOrderLine@1005 :
      SalesOrderLine: Record 37;
//       TempSalesLine@1002 :
      TempSalesLine: Record 37 TEMPORARY;
//       SalesSetup@1020 :
      SalesSetup: Record 311;
//       TransferOldExtLines@1007 :
      TransferOldExtLines: Codeunit 379;
//       ItemTrackingMgt@1008 :
      ItemTrackingMgt: Codeunit 6500;
//       ExtTextLine@1006 :
      ExtTextLine: Boolean;
//       NextLineNo@1001 :
      NextLineNo: Integer;
//       IsHandled@1003 :
      IsHandled: Boolean;
    begin
      SETRANGE("Document No.","Document No.");

      TempSalesLine := SalesLine;
      if SalesLine.FIND('+') then
        NextLineNo := SalesLine."Line No." + 10000
      else
        NextLineNo := 10000;

      if SalesHeader."No." <> TempSalesLine."Document No." then
        SalesHeader.GET(TempSalesLine."Document Type",TempSalesLine."Document No.");

      if SalesLine."Return Receipt No." <> "Document No." then begin
        SalesLine.INIT;
        SalesLine."Line No." := NextLineNo;
        SalesLine."Document Type" := TempSalesLine."Document Type";
        SalesLine."Document No." := TempSalesLine."Document No.";
        LanguageManagement.SetGlobalLanguageByCode(SalesHeader."Language Code");
        SalesLine.Description := STRSUBSTNO(Text000,"Document No.");
        LanguageManagement.RestoreGlobalLanguage;
        IsHandled := FALSE;
        OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine(Rec,SalesLine,NextLineNo,IsHandled);
        if not IsHandled then begin
          SalesLine.INSERT;
          NextLineNo := NextLineNo + 10000;
        end;
      end;

      TransferOldExtLines.ClearLineNumbers;
      SalesSetup.GET;
      repeat
        ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

        if not SalesOrderLine.GET(
             SalesOrderLine."Document Type"::"Return Order","Return Order No.","Return Order Line No.")
        then begin
          if ExtTextLine then begin
            SalesOrderLine.INIT;
            SalesOrderLine."Line No." := "Return Order Line No.";
            SalesOrderLine.Description := Description;
            SalesOrderLine."Description 2" := "Description 2";
          end  else
            ERROR(Text001);
        end else begin
          if (SalesHeader2."Document Type" <> SalesOrderLine."Document Type"::"Return Order") or
             (SalesHeader2."No." <> SalesOrderLine."Document No.")
          then
            SalesHeader2.GET(SalesOrderLine."Document Type"::"Return Order","Return Order No.");

          InitCurrency("Currency Code");

          if SalesHeader."Prices Including VAT" then begin
            if not SalesHeader2."Prices Including VAT" then
              SalesOrderLine."Unit Price" :=
                ROUND(
                  SalesOrderLine."Unit Price" * (1 + SalesOrderLine."VAT %" / 100),
                  Currency."Unit-Amount Rounding Precision");
          end else begin
            if SalesHeader2."Prices Including VAT" then
              SalesOrderLine."Unit Price" :=
                ROUND(
                  SalesOrderLine."Unit Price" / (1 + SalesOrderLine."VAT %" / 100),
                  Currency."Unit-Amount Rounding Precision");
          end;
        end;
        SalesLine := SalesOrderLine;
        SalesLine."Line No." := NextLineNo;
        SalesLine."Document Type" := TempSalesLine."Document Type";
        SalesLine."Document No." := TempSalesLine."Document No.";
        SalesLine."Variant Code" := "Variant Code";
        SalesLine."Location Code" := "Location Code";
        SalesLine."Return Reason Code" := "Return Reason Code";
        SalesLine."Quantity (Base)" := 0;
        SalesLine.Quantity := 0;
        SalesLine."Outstanding Qty. (Base)" := 0;
        SalesLine."Outstanding Quantity" := 0;
        SalesLine."Return Qty. Received" := 0;
        SalesLine."Return Qty. Received (Base)" := 0;
        SalesLine."Quantity Invoiced" := 0;
        SalesLine."Qty. Invoiced (Base)" := 0;
        SalesLine."Drop Shipment" := FALSE;
        SalesLine."Return Receipt No." := "Document No.";
        SalesLine."Return Receipt Line No." := "Line No.";
        SalesLine."Appl.-to Item Entry" := 0;
        SalesLine."Appl.-from Item Entry" := 0;

        if not ExtTextLine then begin
          SalesLine.VALIDATE(Quantity,Quantity - "Quantity Invoiced");
          SalesLine.VALIDATE("Unit Price",SalesOrderLine."Unit Price");
          SalesLine."Allow Line Disc." := SalesOrderLine."Allow Line Disc.";
          SalesLine."Allow Invoice Disc." := SalesOrderLine."Allow Invoice Disc.";
          SalesLine.VALIDATE("Line Discount %",SalesOrderLine."Line Discount %");
          if SalesOrderLine.Quantity = 0 then
            SalesLine.VALIDATE("Inv. Discount Amount",0)
          else
            SalesLine.VALIDATE(
              "Inv. Discount Amount",
              ROUND(
                SalesOrderLine."Inv. Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
                Currency."Amount Rounding Precision"));
        end;
        SalesLine."Attached to Line No." :=
          TransferOldExtLines.TransferExtendedText(
            SalesOrderLine."Line No.",
            NextLineNo,
            "Attached to Line No.");
        SalesLine."Shortcut Dimension 1 Code" := SalesOrderLine."Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := SalesOrderLine."Shortcut Dimension 2 Code";
        SalesLine."Dimension Set ID" := SalesOrderLine."Dimension Set ID";

        OnBeforeInsertInvLineFromRetRcptLine(SalesLine,SalesOrderLine,Rec);
        SalesLine.INSERT;
        OnAftertInsertInvLineFromRetRcptLine(SalesLine);

        ItemTrackingMgt.CopyHandledItemTrkgToInvLine(SalesOrderLine,SalesLine);

        NextLineNo := NextLineNo + 10000;
        if "Attached to Line No." = 0 then
          SETRANGE("Attached to Line No.","Line No.");

      until (NEXT = 0) or ("Attached to Line No." = 0);

      if SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order,"Return Order No.") then begin
        SalesOrderHeader."Get Shipment Used" := TRUE;
        SalesOrderHeader.MODIFY;
      end;
    end;
*/


//     LOCAL procedure GetSalesCrMemoLines (var TempSalesCrMemoLine@1000 :
    
/*
LOCAL procedure GetSalesCrMemoLines (var TempSalesCrMemoLine: Record 115 TEMPORARY)
    var
//       SalesCrMemoLine@1003 :
      SalesCrMemoLine: Record 115;
//       ItemLedgEntry@1002 :
      ItemLedgEntry: Record 32;
//       ValueEntry@1001 :
      ValueEntry: Record 5802;
    begin
      TempSalesCrMemoLine.RESET;
      TempSalesCrMemoLine.DELETEALL;

      if Type <> Type::Item then
        exit;

      FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
      ItemLedgEntry.SETFILTER("Invoiced Quantity",'<>0');
      if ItemLedgEntry.FINDSET then begin
        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
        ValueEntry.SETRANGE("Entry Type",ValueEntry."Entry Type"::"Direct Cost");
        ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
        repeat
          ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
          if ValueEntry.FINDSET then
            repeat
              if ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Credit Memo" then
                if SalesCrMemoLine.GET(ValueEntry."Document No.",ValueEntry."Document Line No.") then begin
                  TempSalesCrMemoLine.INIT;
                  TempSalesCrMemoLine := SalesCrMemoLine;
                  if TempSalesCrMemoLine.INSERT then;
                end;
            until ValueEntry.NEXT = 0;
        until ItemLedgEntry.NEXT = 0;
      end;
    end;
*/


    
//     procedure FilterPstdDocLnItemLedgEntries (var ItemLedgEntry@1000 :
    
/*
procedure FilterPstdDocLnItemLedgEntries (var ItemLedgEntry: Record 32)
    begin
      ItemLedgEntry.RESET;
      ItemLedgEntry.SETCURRENTKEY("Document No.");
      ItemLedgEntry.SETRANGE("Document No.","Document No.");
      ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Sales Return Receipt");
      ItemLedgEntry.SETRANGE("Document Line No.","Line No.");
    end;
*/


    
    
/*
procedure ShowItemSalesCrMemoLines ()
    var
//       TempSalesCrMemoLine@1000 :
      TempSalesCrMemoLine: Record 115 TEMPORARY;
    begin
      if Type = Type::Item then begin
        GetSalesCrMemoLines(TempSalesCrMemoLine);
        PAGE.RUNMODAL(0,TempSalesCrMemoLine);
      end;
    end;
*/


//     LOCAL procedure InitCurrency (CurrencyCode@1001 :
    
/*
LOCAL procedure InitCurrency (CurrencyCode: Code[10])
    begin
      if (Currency.Code = CurrencyCode) and CurrencyRead then
        exit;

      if CurrencyCode <> '' then
        Currency.GET(CurrencyCode)
      else
        Currency.InitRoundingPrecision;
      CurrencyRead := TRUE;
    end;
*/


    
    
/*
procedure ShowLineComments ()
    var
//       SalesCommentLine@1000 :
      SalesCommentLine: Record 44;
    begin
      SalesCommentLine.ShowComments(SalesCommentLine."Document Type"::"Posted Return Receipt","Document No.","Line No.");
    end;
*/


    
//     procedure InitFromSalesLine (ReturnRcptHeader@1001 : Record 6660;SalesLine@1002 :
    
/*
procedure InitFromSalesLine (ReturnRcptHeader: Record 6660;SalesLine: Record 37)
    begin
      INIT;
      TRANSFERFIELDS(SalesLine);
      if ("No." = '') and (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) then
        Type := Type::" ";
      "Posting Date" := ReturnRcptHeader."Posting Date";
      "Document No." := ReturnRcptHeader."No.";
      Quantity := SalesLine."Return Qty. to Receive";
      "Quantity (Base)" := SalesLine."Return Qty. to Receive (Base)";
      if ABS(SalesLine."Qty. to Invoice") > ABS(SalesLine."Return Qty. to Receive") then begin
        "Quantity Invoiced" := SalesLine."Return Qty. to Receive";
        "Qty. Invoiced (Base)" := SalesLine."Return Qty. to Receive (Base)";
      end else begin
        "Quantity Invoiced" := SalesLine."Qty. to Invoice";
        "Qty. Invoiced (Base)" := SalesLine."Qty. to Invoice (Base)";
      end;
      "Return Qty. Rcd. not Invd." :=
        Quantity - "Quantity Invoiced";
      if SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" then begin
        "Return Order No." := SalesLine."Document No.";
        "Return Order Line No." := SalesLine."Line No.";
      end;

      OnAfterInitFromSalesLine(ReturnRcptHeader,SalesLine,Rec);
    end;
*/


    
//     LOCAL procedure OnAfterInitFromSalesLine (ReturnRcptHeader@1000 : Record 6660;SalesLine@1001 : Record 37;var ReturnRcptLine@1002 :
    
/*
LOCAL procedure OnAfterInitFromSalesLine (ReturnRcptHeader: Record 6660;SalesLine: Record 37;var ReturnRcptLine: Record 6661)
    begin
    end;
*/


    
//     LOCAL procedure OnAftertInsertInvLineFromRetRcptLine (var SalesLine@1000 :
    
/*
LOCAL procedure OnAftertInsertInvLineFromRetRcptLine (var SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeInsertInvLineFromRetRcptLine (var SalesLine@1000 : Record 37;SalesOrderLine@1001 : Record 37;var ReturnReceiptLine@1002 :
    
/*
LOCAL procedure OnBeforeInsertInvLineFromRetRcptLine (var SalesLine: Record 37;SalesOrderLine: Record 37;var ReturnReceiptLine: Record 6661)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine (var ReturnReceiptLine@1000 : Record 6661;var SalesLine@1001 : Record 37;var NextLineNo@1002 : Integer;var IsHandled@1003 :
    
/*
LOCAL procedure OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine (var ReturnReceiptLine: Record 6661;var SalesLine: Record 37;var NextLineNo: Integer;var IsHandled: Boolean)
    begin
    end;

    /*begin
    end.
  */
}




