tableextension 50122 "QBU Item Journal LineExt" extends "Item Journal Line"
{
  
  
    CaptionML=ENU='Item Journal Line',ESP='L¡n. diario producto';
    LookupPageID="Item Journal Lines";
    DrillDownPageID="Item Journal Lines";
  
  fields
{
    field(7207500;"QBU Diverse Entrance";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Diverse Entrance',ESP='Entrada diversa';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';


    }
    field(7207501;"QBU Ceded Control";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Ceded Control',ESP='Control cedidos';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';


    }
    field(7207503;"QBU Automatic Shipment";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Automatic Shipment',ESP='Albar n autom tico';
                                                   Description='Q15921. Si viene de un albar n de compra';
                                                   Editable=false;


    }
    field(7207700;"QBU Stocks Document Type";Option)
    {
        OptionMembers=" ","Receipt","Invoice","Return Receipt","Credit Memo","Output Shipment";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document Type stocks',ESP='Stock Tipo Documento';
                                                   OptionCaptionML=ENU='" ,Receipt,Invoice,Return Receipt,Credit Memo,Output Shipment No."',ESP='" ,Albaran compra, Factura Compra,Devoluci¢n Compra, Abono Compra,Albar n Salida"';
                                                   
                                                   Description='QB_ST01';


    }
    field(7207701;"QBU Stocks Document No";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document No Stocks',ESP='Stock Num. Documento';
                                                   Description='QB_ST01';


    }
    field(7207702;"QBU Stocks Output Shipment Line";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document Line Stocks',ESP='Stock Linea Documento';
                                                   Description='QB_ST01';


    }
    field(7207704;"QBU Stocks Output Shipment No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Output Shipment No.',ESP='Albar n de Salida';
                                                   Description='QB_ST01';


    }
    field(7207705;"QBU Stocks Document Line";Integer)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB_ST01';


    }
}
  keys
{
   // key(key1;"Item No.","Posting Date")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text001@1001 :
      Text001: TextConst ENU='%1 must be reduced.',ESP='%1 se debe reducir.';
//       Text002@1002 :
      Text002: TextConst ENU='You cannot change %1 when %2 is %3.',ESP='No se puede cambiar %1 cuando %2 es %3.';
//       Text006@1005 :
      Text006: TextConst ENU='You must not enter %1 in a revaluation sum line.',ESP='No debe introducir %1 en una l¡n. acum. de revaloriz.';
//       ItemJnlTemplate@1007 :
      ItemJnlTemplate: Record 82;
//       ItemJnlBatch@1008 :
      ItemJnlBatch: Record 233;
//       ItemJnlLine@1009 :
      ItemJnlLine: Record 83;
//       Item@1010 :
      Item: Record 27;
//       ItemVariant@1012 :
      ItemVariant: Record 5401;
//       GLSetup@1014 :
      GLSetup: Record 98;
//       MfgSetup@1034 :
      MfgSetup: Record 99000765;
//       WorkCenter@1040 :
      WorkCenter: Record 99000754;
//       MachineCenter@1039 :
      MachineCenter: Record 99000758;
//       Location@1048 :
      Location: Record 14;
//       Bin@1030 :
      Bin: Record 7354;
//       ItemCheckAvail@1021 :
      ItemCheckAvail: Codeunit 311;
//       ReserveItemJnlLine@1022 :
      ReserveItemJnlLine: Codeunit 99000835;
//       NoSeriesMgt@1023 :
      NoSeriesMgt: Codeunit 396;
//       UOMMgt@1024 :
      UOMMgt: Codeunit 5402;
//       DimMgt@1027 :
      DimMgt: Codeunit 408;
//       UserMgt@1033 :
      UserMgt: Codeunit 5700;
//       CalendarMgt@1041 :
      CalendarMgt: Codeunit 99000755;
//       CostCalcMgt@1042 :
      CostCalcMgt: Codeunit 5836;
//       PurchPriceCalcMgt@1020 :
      PurchPriceCalcMgt: Codeunit 7010;
//       SalesPriceCalcMgt@1025 :
      SalesPriceCalcMgt: Codeunit 7000;
//       WMSManagement@1026 :
      WMSManagement: Codeunit 7302;
//       WhseValidateSourceLine@1032 :
      WhseValidateSourceLine: Codeunit 5777;
//       PhysInvtEntered@1028 :
      PhysInvtEntered: Boolean;
//       GLSetupRead@1029 :
      GLSetupRead: Boolean;
//       MfgSetupRead@1035 :
      MfgSetupRead: Boolean;
//       UnitCost@1031 :
      UnitCost: Decimal;
//       Text007@1006 :
      Text007: TextConst ENU='New ',ESP='Nuevo ';
//       UpdateInterruptedErr@1045 :
      UpdateInterruptedErr: TextConst ENU='The update has been interrupted to respect the warning.',ESP='Se ha interrumpido la actualizaci¢n para respetar la advertencia.';
//       Text021@1051 :
      Text021: TextConst ENU='The entered bin code %1 is different from the bin code %2 in production order component %3.\\Are you sure that you want to post the consumption from bin code %1?',ESP='El c¢digo de ubicaci¢n %1 indicado es diferente del c¢digo de ubicaci¢n %2 del componente de orden de producci¢n %3.\\¨Est  seguro de que desea registrar el consumo del c¢digo de ubicaci¢n %1?';
//       Text029@1047 :
      Text029: TextConst ENU='must be positive',ESP='debe ser positivo';
//       Text030@1046 :
      Text030: TextConst ENU='must be negative',ESP='debe ser negativo';
//       Text031@1043 :
      Text031: TextConst ENU='You can not insert item number %1 because it is not produced on released production order %2.',ESP='No puede insertar el producto n£mero %1, no est  incluido en la orden de producci¢n lanzada %2.';
//       Text032@1000 :
      Text032: TextConst ENU='When posting, the entry %1 will be opened first.',ESP='Al registrar el movimiento, %1 se abrir  primero.';
//       Text033@1049 :
      Text033: TextConst ENU='if the item carries serial or lot numbers, then you must use the %1 field in the %2 window.',ESP='Si el producto tiene n£meros de serie o lote, debe usar el campo %1 de la ventana %2.';
//       RevaluationPerEntryNotAllowedErr@1050 :
      RevaluationPerEntryNotAllowedErr: TextConst ENU='This item ledger entry has already been revalued with the Calculate Inventory Value function, so you cannot use the Applies-to Entry field as that may change the valuation.',ESP='Este movimiento de producto ya ha revalorizado con la funci¢n Calcular valor inventario, por lo que no puede usar el campo Liq. por n.§ orden ya que eso puede cambiar la valoraci¢n.';
//       SubcontractedErr@1003 :
      SubcontractedErr: 
// %1 - Field Caption, %2 - Line No.
TextConst ENU='%1 must be zero in line number %2 because it is linked to the subcontracted work center.',ESP='%1 debe ser cero en el n£mero de l¡nea %2 porque est  vinculado al centro de trabajo subcontratado.';
//       FinishedOutputQst@1004 :
      FinishedOutputQst: TextConst ENU='The operation has been finished. Do you want to post output for the finished operation?',ESP='La operaci¢n ha finalizado. ¨Desea registrar el resultado de la operaci¢n finalizada?';
//       SalesBlockedErr@1011 :
      SalesBlockedErr: TextConst ENU='You cannot sell this item because the Sales Blocked check box is selected on the item card.',ESP='No puede vender este producto porque la casilla Ventas bloqueadas est  seleccionada en la ficha de producto.';
//       PurchasingBlockedErr@1013 :
      PurchasingBlockedErr: TextConst ENU='You cannot purchase this item because the Purchasing Blocked check box is selected on the item card.',ESP='No puede comprar este producto porque la casilla Compras bloqueadas est  seleccionada en la ficha de producto.';
//       BlockedErr@1015 :
      BlockedErr: TextConst ENU='You cannot purchase this item because the Blocked check box is selected on the item card.',ESP='No puede comprar este producto porque la casilla Bloqueado est  seleccionada en la ficha de producto.';

    
    


/*
trigger OnInsert();    begin
               LOCKTABLE;
               ItemJnlTemplate.GET("Journal Template Name");
               ItemJnlBatch.GET("Journal Template Name","Journal Batch Name");

               ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
               ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
               ValidateNewShortcutDimCode(1,"New Shortcut Dimension 1 Code");
               ValidateNewShortcutDimCode(2,"New Shortcut Dimension 2 Code");

               CheckPlanningAssignment;
             end;


*/

/*
trigger OnModify();    begin
               OnBeforeVerifyReservedQty(Rec,xRec,0);
               ReserveItemJnlLine.VerifyChange(Rec,xRec);
               CheckPlanningAssignment;
             end;


*/

/*
trigger OnDelete();    begin
               ReserveItemJnlLine.DeleteLine(Rec);

               CALCFIELDS("Reserved Qty. (Base)");
               TESTFIELD("Reserved Qty. (Base)",0);
             end;


*/

/*
trigger OnRename();    begin
               ReserveItemJnlLine.RenameLine(Rec,xRec);
             end;

*/




/*
procedure EmptyLine () : Boolean;
    begin
      exit(
        (Quantity = 0) and
        ((TimeIsEmpty and ("Item No." = '')) or
         ("Value Entry Type" = "Value Entry Type"::Revaluation)));
    end;
*/


    
    
/*
procedure IsValueEntryForDeletedItem () : Boolean;
    begin
      exit(
        (("Entry Type" = "Entry Type"::Output) or ("Value Entry Type" = "Value Entry Type"::Rounding)) and
        ("Item No." = '') and ("Item Charge No." = '') and ("Invoiced Qty. (Base)" <> 0));
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


//     LOCAL procedure CalcBaseTime (Qty@1000 :
    
/*
LOCAL procedure CalcBaseTime (Qty: Decimal) : Decimal;
    begin
      if "Run Time" <> 0 then
        TESTFIELD("Qty. per Cap. Unit of Measure");
      exit(ROUND(Qty * "Qty. per Cap. Unit of Measure",0.00001));
    end;
*/


    
/*
LOCAL procedure UpdateAmount ()
    begin
      Amount := ROUND(Quantity * "Unit Amount");

      OnAfterUpdateAmount(Rec);
    end;
*/


//     LOCAL procedure SelectItemEntry (CurrentFieldNo@1000 :
    
/*
LOCAL procedure SelectItemEntry (CurrentFieldNo: Integer)
    var
//       ItemLedgEntry@1001 :
      ItemLedgEntry: Record 32;
//       ItemJnlLine2@1002 :
      ItemJnlLine2: Record 83;
    begin
      if ("Entry Type" = "Entry Type"::Output) and
         ("Value Entry Type" <> "Value Entry Type"::Revaluation) and
         (CurrentFieldNo = FIELDNO("Applies-to Entry"))
      then begin
        ItemLedgEntry.SETCURRENTKEY(
          "Order Type","Order No.","Order Line No.","Entry Type","Prod. Order Comp. Line No.");
        ItemLedgEntry.SETRANGE("Order Type","Order Type"::Production);
        ItemLedgEntry.SETRANGE("Order No.","Order No.");
        ItemLedgEntry.SETRANGE("Order Line No.","Order Line No.");
        ItemLedgEntry.SETRANGE("Entry Type","Entry Type");
        ItemLedgEntry.SETRANGE("Prod. Order Comp. Line No.",0);
      end else begin
        ItemLedgEntry.SETCURRENTKEY("Item No.",Positive);
        ItemLedgEntry.SETRANGE("Item No.","Item No.");
      end;

      if "Location Code" <> '' then
        ItemLedgEntry.SETRANGE("Location Code","Location Code");

      if CurrentFieldNo = FIELDNO("Applies-to Entry") then begin
        ItemLedgEntry.SETRANGE(Positive,(Signed(Quantity) < 0) or ("Value Entry Type" = "Value Entry Type"::Revaluation));
        if "Value Entry Type" <> "Value Entry Type"::Revaluation then begin
          ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
          ItemLedgEntry.SETRANGE(Open,TRUE);
        end;
      end else
        ItemLedgEntry.SETRANGE(Positive,FALSE);

      if PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK then begin
        ItemJnlLine2 := Rec;
        if CurrentFieldNo = FIELDNO("Applies-to Entry") then
          ItemJnlLine2.VALIDATE("Applies-to Entry",ItemLedgEntry."Entry No.")
        else
          ItemJnlLine2.VALIDATE("Applies-from Entry",ItemLedgEntry."Entry No.");
        CheckItemAvailable(CurrentFieldNo);
        Rec := ItemJnlLine2;
      end;
    end;
*/


//     LOCAL procedure CheckItemAvailable (CalledByFieldNo@1000 :
    
/*
LOCAL procedure CheckItemAvailable (CalledByFieldNo: Integer)
    begin
      if (CurrFieldNo = 0) or (CurrFieldNo <> CalledByFieldNo) then // Prevent two checks on quantity
        exit;

      if (CurrFieldNo <> 0) and ("Item No." <> '') and (Quantity <> 0) and
         ("Value Entry Type" = "Value Entry Type"::"Direct Cost") and ("Item Charge No." = '')
      then
        if ItemCheckAvail.ItemJnlCheckLine(Rec) then
          ItemCheckAvail.RaiseUpdateInterruptedError;
    end;
*/


    
/*
LOCAL procedure GetItem ()
    begin
      if Item."No." <> "Item No." then
        Item.GET("Item No.");

      OnAfterGetItemChange(Item,Rec);
    end;
*/


    
//     procedure SetUpNewLine (LastItemJnlLine@1000 :
    
/*
procedure SetUpNewLine (LastItemJnlLine: Record 83)
    begin
      MfgSetup.GET;
      ItemJnlTemplate.GET("Journal Template Name");
      ItemJnlBatch.GET("Journal Template Name","Journal Batch Name");
      ItemJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      ItemJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      if ItemJnlLine.FINDFIRST then begin
        "Posting Date" := LastItemJnlLine."Posting Date";
        "Document Date" := LastItemJnlLine."Posting Date";
        if (ItemJnlTemplate.Type IN
            [ItemJnlTemplate.Type::Consumption,ItemJnlTemplate.Type::Output])
        then begin
          if not MfgSetup."Doc. No. Is Prod. Order No." then
            "Document No." := LastItemJnlLine."Document No."
        end else
          "Document No." := LastItemJnlLine."Document No.";
      end else begin
        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        if ItemJnlBatch."No. Series" <> '' then begin
          CLEAR(NoSeriesMgt);
          "Document No." := NoSeriesMgt.TryGetNextNo(ItemJnlBatch."No. Series","Posting Date");
        end;
        if (ItemJnlTemplate.Type IN
            [ItemJnlTemplate.Type::Consumption,ItemJnlTemplate.Type::Output]) and
           not MfgSetup."Doc. No. Is Prod. Order No."
        then
          if ItemJnlBatch."No. Series" <> '' then begin
            CLEAR(NoSeriesMgt);
            "Document No." := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series","Posting Date",FALSE);
          end;
      end;
      "Recurring Method" := LastItemJnlLine."Recurring Method";
      "Entry Type" := LastItemJnlLine."Entry Type";
      "Source Code" := ItemJnlTemplate."Source Code";
      "Reason Code" := ItemJnlBatch."Reason Code";
      "Posting No. Series" := ItemJnlBatch."Posting No. Series";
      if ItemJnlTemplate.Type = ItemJnlTemplate.Type::Revaluation then begin
        "Value Entry Type" := "Value Entry Type"::Revaluation;
        "Entry Type" := "Entry Type"::"Positive Adjmt.";
      end;

      CASE "Entry Type" OF
        "Entry Type"::Purchase:
          "Location Code" := UserMgt.GetLocation(1,'',UserMgt.GetPurchasesFilter);
        "Entry Type"::Sale:
          "Location Code" := UserMgt.GetLocation(0,'',UserMgt.GetSalesFilter);
        "Entry Type"::Output:
          CLEAR(DimMgt);
      end;

      if Location.GET("Location Code") then
        if  Location."Directed Put-away and Pick" then
          "Location Code" := '';

      OnAfterSetupNewLine(Rec,LastItemJnlLine,ItemJnlTemplate);
    end;
*/


    
//     procedure SetDocNos (DocType@1000 : Option;DocNo@1001 : Code[20];ExtDocNo@1002 : Text[35];PostingNos@1003 :
    
/*
procedure SetDocNos (DocType: Option;DocNo: Code[20];ExtDocNo: Text[35];PostingNos: Code[20])
    begin
      "Document Type" := DocType;
      "Document No." := DocNo;
      "External Document No." := ExtDocNo;
      "Posting No. Series" := PostingNos;
    end;
*/


//     LOCAL procedure GetUnitAmount (CalledByFieldNo@1000 :
    
/*
LOCAL procedure GetUnitAmount (CalledByFieldNo: Integer)
    var
//       UnitCostValue@1001 :
      UnitCostValue: Decimal;
    begin
      RetrieveCosts;
      if ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") or
         ("Item Charge No." <> '')
      then
        exit;

      UnitCostValue := UnitCost;
      if (CalledByFieldNo = FIELDNO(Quantity)) and
         (Item."No." <> '') and (Item."Costing Method" <> Item."Costing Method"::Standard)
      then
        UnitCostValue := "Unit Cost" / UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");

      CASE "Entry Type" OF
        "Entry Type"::Purchase:
          PurchPriceCalcMgt.FindItemJnlLinePrice(Rec,CalledByFieldNo);
        "Entry Type"::Sale:
          SalesPriceCalcMgt.FindItemJnlLinePrice(Rec,CalledByFieldNo);
        "Entry Type"::"Positive Adjmt.":
          "Unit Amount" :=
            ROUND(
              ((UnitCostValue - "Overhead Rate") * "Qty. per Unit of Measure") / (1 + "Indirect Cost %" / 100),
              GLSetup."Unit-Amount Rounding Precision");
        "Entry Type"::"Negative Adjmt.":
          "Unit Amount" := UnitCostValue * "Qty. per Unit of Measure";
        "Entry Type"::Transfer:
          "Unit Amount" := 0;
      end;
    end;
*/


    
//     procedure Signed (Value@1000 :
    
/*
procedure Signed (Value: Decimal) : Decimal;
    begin
      CASE "Entry Type" OF
        "Entry Type"::Purchase,
        "Entry Type"::"Positive Adjmt.",
        "Entry Type"::Output,
        "Entry Type"::"Assembly Output":
          exit(Value);
        "Entry Type"::Sale,
        "Entry Type"::"Negative Adjmt.",
        "Entry Type"::Consumption,
        "Entry Type"::Transfer,
        "Entry Type"::"Assembly Consumption":
          exit(-Value);
      end;
    end;
*/


    
    
/*
procedure IsInbound () : Boolean;
    begin
      exit((Signed(Quantity) > 0) or (Signed("Invoiced Quantity") > 0));
    end;
*/


    
//     procedure OpenItemTrackingLines (IsReclass@1000 :
    
/*
procedure OpenItemTrackingLines (IsReclass: Boolean)
    begin
      ReserveItemJnlLine.CallItemTracking(Rec,IsReclass);
    end;
*/


//     LOCAL procedure PickDimension (TableArray@1005 : ARRAY [10] OF Integer;CodeArray@1004 : ARRAY [10] OF Code[20];InheritFromDimSetID@1003 : Integer;InheritFromTableNo@1002 :
    
/*
LOCAL procedure PickDimension (TableArray: ARRAY [10] OF Integer;CodeArray: ARRAY [10] OF Code[20];InheritFromDimSetID: Integer;InheritFromTableNo: Integer)
    var
//       ItemJournalTemplate@1001 :
      ItemJournalTemplate: Record 82;
//       SourceCode@1000 :
      SourceCode: Code[10];
    begin
      SourceCode := "Source Code";
      if SourceCode = '' then
        if ItemJournalTemplate.GET("Journal Template Name") then
          SourceCode := ItemJournalTemplate."Source Code";

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableArray,CodeArray,SourceCode,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",InheritFromDimSetID,InheritFromTableNo);
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

      if "Entry Type" = "Entry Type"::Transfer then begin
        "New Dimension Set ID" := "Dimension Set ID";
        "New Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        "New Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
      end;
    end;
*/


//     LOCAL procedure CreateCodeArray (var CodeArray@1003 : ARRAY [10] OF Code[20];No1@1002 : Code[20];No2@1001 : Code[20];No3@1000 :
    
/*
LOCAL procedure CreateCodeArray (var CodeArray: ARRAY [10] OF Code[20];No1: Code[20];No2: Code[20];No3: Code[20])
    begin
      CLEAR(CodeArray);
      CodeArray[1] := No1;
      CodeArray[2] := No2;
      CodeArray[3] := No3;
    end;
*/


//     LOCAL procedure CreateTableArray (var TableID@1001 : ARRAY [10] OF Integer;Type1@1000 : Integer;Type2@1002 : Integer;Type3@1007 :
    
/*
LOCAL procedure CreateTableArray (var TableID: ARRAY [10] OF Integer;Type1: Integer;Type2: Integer;Type3: Integer)
    begin
      CLEAR(TableID);
      TableID[1] := Type1;
      TableID[2] := Type2;
      TableID[3] := Type3;
    end;
*/


    
//     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1007 : Integer;No3@1006 :
    
/*
procedure CreateDim (Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20])
    var
//       TableID@1004 :
      TableID: ARRAY [10] OF Integer;
//       No@1005 :
      No: ARRAY [10] OF Code[20];
    begin
      CreateTableArray(TableID,Type1,Type2,Type3);
      CreateCodeArray(No,No1,No2,No3);
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);
      PickDimension(TableID,No,0,0);
    end;
*/


    
//     procedure CopyDim (DimesionSetID@1000 :
    
/*
procedure CopyDim (DimesionSetID: Integer)
    var
//       DimSetEntry@1002 :
      DimSetEntry: Record 480;
    begin
      ReadGLSetup;
      "Dimension Set ID" := DimesionSetID;
      DimSetEntry.SETRANGE("Dimension Set ID",DimesionSetID);
      DimSetEntry.SETRANGE("Dimension Code",GLSetup."Global Dimension 1 Code");
      if DimSetEntry.FINDFIRST then
        "Shortcut Dimension 1 Code" := DimSetEntry."Dimension Value Code"
      else
        "Shortcut Dimension 1 Code" := '';
      DimSetEntry.SETRANGE("Dimension Code",GLSetup."Global Dimension 2 Code");
      if DimSetEntry.FINDFIRST then
        "Shortcut Dimension 2 Code" := DimSetEntry."Dimension Value Code"
      else
        "Shortcut Dimension 2 Code" := '';
    end;
*/


    
/*
LOCAL procedure CreateProdDim ()
    var
//       ProdOrder@1008 :
      ProdOrder: Record 5405;
//       ProdOrderLine@1009 :
      ProdOrderLine: Record 5406;
//       ProdOrderComp@1010 :
      ProdOrderComp: Record 5407;
//       DimSetIDArr@1001 :
      DimSetIDArr: ARRAY [10] OF Integer;
//       i@1000 :
      i: Integer;
    begin
      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" := 0;
      if ("Order Type" <> "Order Type"::Production) or ("Order No." = '') then
        exit;
      ProdOrder.GET(ProdOrder.Status::Released,"Order No.");
      i := 1;
      DimSetIDArr[i] := ProdOrder."Dimension Set ID";
      if "Order Line No." <> 0 then begin
        i := i + 1;
        ProdOrderLine.GET(ProdOrderLine.Status::Released,"Order No.","Order Line No.");
        DimSetIDArr[i] := ProdOrderLine."Dimension Set ID";
      end;
      if "Prod. Order Comp. Line No." <> 0 then begin
        i := i + 1;
        ProdOrderComp.GET(ProdOrderLine.Status::Released,"Order No.","Order Line No.","Prod. Order Comp. Line No.");
        DimSetIDArr[i] := ProdOrderComp."Dimension Set ID";
      end;
      "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;
*/


    
/*
LOCAL procedure CreateAssemblyDim ()
    var
//       AssemblyHeader@1008 :
      AssemblyHeader: Record 900;
//       AssemblyLine@1009 :
      AssemblyLine: Record 901;
//       DimSetIDArr@1001 :
      DimSetIDArr: ARRAY [10] OF Integer;
//       i@1000 :
      i: Integer;
    begin
      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" := 0;
      if ("Order Type" <> "Order Type"::Assembly) or ("Order No." = '') then
        exit;
      AssemblyHeader.GET(AssemblyHeader."Document Type"::Order,"Order No.");
      i := 1;
      DimSetIDArr[i] := AssemblyHeader."Dimension Set ID";
      if "Order Line No." <> 0 then begin
        i := i + 1;
        AssemblyLine.GET(AssemblyLine."Document Type"::Order,"Order No.","Order Line No.");
        DimSetIDArr[i] := AssemblyLine."Dimension Set ID";
      end;
      "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;
*/


    
/*
LOCAL procedure CreateDimWithProdOrderLine ()
    var
//       ProdOrderLine@1005 :
      ProdOrderLine: Record 5406;
//       InheritFromDimSetID@1004 :
      InheritFromDimSetID: Integer;
//       TableID@1001 :
      TableID: ARRAY [10] OF Integer;
//       No@1000 :
      No: ARRAY [10] OF Code[20];
    begin
      if "Order Type" = "Order Type"::Production then
        if ProdOrderLine.GET(ProdOrderLine.Status::Released,"Order No.","Order Line No.") then
          InheritFromDimSetID := ProdOrderLine."Dimension Set ID";

      CreateTableArray(TableID,DATABASE::"Work Center",DATABASE::"Salesperson/Purchaser",0);
      CreateCodeArray(No,"Work Center No.","Salespers./Purch. Code",'');
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);
      PickDimension(TableID,No,InheritFromDimSetID,DATABASE::Item);
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;
*/


    
//     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure LookupShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;
*/


    
//     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    
/*
procedure ShowShortcutDimCode (var ShortcutDimCode: ARRAY [8] OF Code[20])
    begin
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;
*/


    
//     procedure ValidateNewShortcutDimCode (FieldNumber@1000 : Integer;var NewShortcutDimCode@1001 :
    
/*
procedure ValidateNewShortcutDimCode (FieldNumber: Integer;var NewShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateShortcutDimValues(FieldNumber,NewShortcutDimCode,"New Dimension Set ID");
    end;
*/


    
//     procedure LookupNewShortcutDimCode (FieldNumber@1000 : Integer;var NewShortcutDimCode@1001 :
    
/*
procedure LookupNewShortcutDimCode (FieldNumber: Integer;var NewShortcutDimCode: Code[20])
    begin
      DimMgt.LookupDimValueCode(FieldNumber,NewShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,NewShortcutDimCode,"New Dimension Set ID");
    end;
*/


    
//     procedure ShowNewShortcutDimCode (var NewShortcutDimCode@1000 :
    
/*
procedure ShowNewShortcutDimCode (var NewShortcutDimCode: ARRAY [8] OF Code[20])
    begin
      DimMgt.GetShortcutDimensions("New Dimension Set ID",NewShortcutDimCode);
    end;
*/


//     LOCAL procedure InitRevalJnlLine (ItemLedgEntry2@1000 :
    
/*
LOCAL procedure InitRevalJnlLine (ItemLedgEntry2: Record 32)
    var
//       ItemApplnEntry@1002 :
      ItemApplnEntry: Record 339;
//       ValueEntry@1001 :
      ValueEntry: Record 5802;
//       CostAmtActual@1003 :
      CostAmtActual: Decimal;
    begin
      if "Value Entry Type" <> "Value Entry Type"::Revaluation then
        exit;

      ItemLedgEntry2.TESTFIELD("Item No.","Item No.");
      ItemLedgEntry2.TESTFIELD("Completely Invoiced",TRUE);
      ItemLedgEntry2.TESTFIELD(Positive,TRUE);
      ItemApplnEntry.CheckAppliedFromEntryToAdjust(ItemLedgEntry2."Entry No.");

      VALIDATE("Entry Type",ItemLedgEntry2."Entry Type");
      "Posting Date" := ItemLedgEntry2."Posting Date";
      VALIDATE("Unit Amount",0);
      VALIDATE(Quantity,ItemLedgEntry2."Invoiced Quantity");

      ValueEntry.RESET;
      ValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
      ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry2."Entry No.");
      ValueEntry.SETFILTER("Entry Type",'<>%1',ValueEntry."Entry Type"::Rounding);
      ValueEntry.FIND('-');
      repeat
        if not (ValueEntry."Expected Cost" or ValueEntry."Partial Revaluation") then
          CostAmtActual := CostAmtActual + ValueEntry."Cost Amount (Actual)";
      until ValueEntry.NEXT = 0;

      VALIDATE("Inventory Value (Calculated)",CostAmtActual);
      VALIDATE("Inventory Value (Revalued)",CostAmtActual);

      "Location Code" := ItemLedgEntry2."Location Code";
      "Variant Code" := ItemLedgEntry2."Variant Code";
      "Applies-to Entry" := ItemLedgEntry2."Entry No.";
      CopyDim(ItemLedgEntry2."Dimension Set ID");
    end;
*/


    
//     procedure CopyDocumentFields (DocType@1004 : Option;DocNo@1003 : Code[20];ExtDocNo@1002 : Text[35];SourceCode@1001 : Code[10];NoSeriesCode@1000 :
    
/*
procedure CopyDocumentFields (DocType: Option;DocNo: Code[20];ExtDocNo: Text[35];SourceCode: Code[10];NoSeriesCode: Code[20])
    begin
      "Document Type" := DocType;
      "Document No." := DocNo;
      "External Document No." := ExtDocNo;
      "Source Code" := SourceCode;
      if NoSeriesCode <> '' then
        "Posting No. Series" := NoSeriesCode;
    end;
*/


    
//     procedure CopyFromSalesHeader (SalesHeader@1000 :
    
/*
procedure CopyFromSalesHeader (SalesHeader: Record 36)
    begin
      "Posting Date" := SalesHeader."Posting Date";
      "Document Date" := SalesHeader."Document Date";
      "Order Date" := SalesHeader."Order Date";
      "Source Posting Group" := SalesHeader."Customer Posting Group";
      "Salespers./Purch. Code" := SalesHeader."Salesperson Code";
      "Reason Code" := SalesHeader."Reason Code";
      "Source Currency Code" := SalesHeader."Currency Code";
      "Shpt. Method Code" := SalesHeader."Shipment Method Code";

      OnAfterCopyItemJnlLineFromSalesHeader(Rec,SalesHeader);
    end;
*/


    
//     procedure CopyFromSalesLine (SalesLine@1000 :
    
/*
procedure CopyFromSalesLine (SalesLine: Record 37)
    begin
      "Item No." := SalesLine."No.";
      Description := SalesLine.Description;
      "Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := SalesLine."Dimension Set ID";
      "Location Code" := SalesLine."Location Code";
      "Bin Code" := SalesLine."Bin Code";
      "Variant Code" := SalesLine."Variant Code";
      "Inventory Posting Group" := SalesLine."Posting Group";
      "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
      "Transaction Type" := SalesLine."Transaction Type";
      "Transport Method" := SalesLine."Transport Method";
      "Entry/exit Point" := SalesLine."exit Point";
      Area := SalesLine.Area;
      "Transaction Specification" := SalesLine."Transaction Specification";
      "Drop Shipment" := SalesLine."Drop Shipment";
      "Entry Type" := "Entry Type"::Sale;
      "Unit of Measure Code" := SalesLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
      "Derived from Blanket Order" := SalesLine."Blanket Order No." <> '';
      "Cross-Reference No." := SalesLine."Cross-Reference No.";
      "Originally Ordered No." := SalesLine."Originally Ordered No.";
      "Originally Ordered var. Code" := SalesLine."Originally Ordered var. Code";
      "Out-of-Stock Substitution" := SalesLine."Out-of-Stock Substitution";
      "Item Category Code" := SalesLine."Item Category Code";
      Nonstock := SalesLine.Nonstock;
      "Purchasing Code" := SalesLine."Purchasing Code";
      "Return Reason Code" := SalesLine."Return Reason Code";
      "Planned Delivery Date" := SalesLine."Planned Delivery Date";
      "Document Line No." := SalesLine."Line No.";
      "Unit Cost" := SalesLine."Unit Cost (LCY)";
      "Unit Cost (ACY)" := SalesLine."Unit Cost";
      "Value Entry Type" := "Value Entry Type"::"Direct Cost";
      "Source Type" := "Source Type"::Customer;
      "Source No." := SalesLine."Sell-to Customer No.";
      "Invoice-to Source No." := SalesLine."Bill-to Customer No.";

      OnAfterCopyItemJnlLineFromSalesLine(Rec,SalesLine);
    end;
*/


    
//     procedure CopyFromPurchHeader (PurchHeader@1000 :
    
/*
procedure CopyFromPurchHeader (PurchHeader: Record 38)
    begin
      "Posting Date" := PurchHeader."Posting Date";
      "Document Date" := PurchHeader."Document Date";
      "Source Posting Group" := PurchHeader."Vendor Posting Group";
      "Salespers./Purch. Code" := PurchHeader."Purchaser Code";
      "Country/Region Code" := PurchHeader."Buy-from Country/Region Code";
      "Reason Code" := PurchHeader."Reason Code";
      "Source Currency Code" := PurchHeader."Currency Code";
      "Shpt. Method Code" := PurchHeader."Shipment Method Code";

      OnAfterCopyItemJnlLineFromPurchHeader(Rec,PurchHeader);
    end;
*/


    
//     procedure CopyFromPurchLine (PurchLine@1000 :
    
/*
procedure CopyFromPurchLine (PurchLine: Record 39)
    begin
      "Item No." := PurchLine."No.";
      Description := PurchLine.Description;
      "Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := PurchLine."Dimension Set ID";
      "Location Code" := PurchLine."Location Code";
      "Bin Code" := PurchLine."Bin Code";
      "Variant Code" := PurchLine."Variant Code";
      "Item Category Code" := PurchLine."Item Category Code";
      "Inventory Posting Group" := PurchLine."Posting Group";
      "Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
      "Job No." := PurchLine."Job No.";
      "Job Task No." := PurchLine."Job Task No.";
      if "Job No." <> '' then
        "Job Purchase" := TRUE;
      "Applies-to Entry" := PurchLine."Appl.-to Item Entry";
      "Transaction Type" := PurchLine."Transaction Type";
      "Transport Method" := PurchLine."Transport Method";
      "Entry/exit Point" := PurchLine."Entry Point";
      Area := PurchLine.Area;
      "Transaction Specification" := PurchLine."Transaction Specification";
      "Drop Shipment" := PurchLine."Drop Shipment";
      "Entry Type" := "Entry Type"::Purchase;
      if PurchLine."Prod. Order No." <> '' then begin
        "Order Type" := "Order Type"::Production;
        "Order No." := PurchLine."Prod. Order No.";
        "Order Line No." := PurchLine."Prod. Order Line No.";
      end;
      "Unit of Measure Code" := PurchLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
      "Cross-Reference No." := PurchLine."Cross-Reference No.";
      "Document Line No." := PurchLine."Line No.";
      "Unit Cost" := PurchLine."Unit Cost (LCY)";
      "Unit Cost (ACY)" := PurchLine."Unit Cost";
      "Value Entry Type" := "Value Entry Type"::"Direct Cost";
      "Source Type" := "Source Type"::Vendor;
      "Source No." := PurchLine."Buy-from Vendor No.";
      "Invoice-to Source No." := PurchLine."Pay-to Vendor No.";
      "Purchasing Code" := PurchLine."Purchasing Code";
      "Indirect Cost %" := PurchLine."Indirect Cost %";
      "Overhead Rate" := PurchLine."Overhead Rate";
      "Return Reason Code" := PurchLine."Return Reason Code";

      OnAfterCopyItemJnlLineFromPurchLine(Rec,PurchLine);
    end;
*/


    
//     procedure CopyFromServHeader (ServiceHeader@1000 :
    
/*
procedure CopyFromServHeader (ServiceHeader: Record 5900)
    begin
      "Document Date" := ServiceHeader."Document Date";
      "Order Date" := ServiceHeader."Order Date";
      "Source Posting Group" := ServiceHeader."Customer Posting Group";
      "Salespers./Purch. Code" := ServiceHeader."Salesperson Code";
      "Country/Region Code" := ServiceHeader."VAT Country/Region Code";
      "Reason Code" := ServiceHeader."Reason Code";
      "Source Type" := "Source Type"::Customer;
      "Source No." := ServiceHeader."Customer No.";
      "Shpt. Method Code" := ServiceHeader."Shipment Method Code";

      OnAfterCopyItemJnlLineFromServHeader(Rec,ServiceHeader);
    end;
*/


    
//     procedure CopyFromServLine (ServiceLine@1000 :
    
/*
procedure CopyFromServLine (ServiceLine: Record 5902)
    begin
      "Item No." := ServiceLine."No.";
      "Posting Date" := ServiceLine."Posting Date";
      Description := ServiceLine.Description;
      "Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServiceLine."Dimension Set ID";
      "Location Code" := ServiceLine."Location Code";
      "Bin Code" := ServiceLine."Bin Code";
      "Variant Code" := ServiceLine."Variant Code";
      "Inventory Posting Group" := ServiceLine."Posting Group";
      "Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
      "Applies-to Entry" := ServiceLine."Appl.-to Item Entry";
      "Transaction Type" := ServiceLine."Transaction Type";
      "Transport Method" := ServiceLine."Transport Method";
      "Entry/exit Point" := ServiceLine."exit Point";
      Area := ServiceLine.Area;
      "Transaction Specification" := ServiceLine."Transaction Specification";
      "Entry Type" := "Entry Type"::Sale;
      "Unit of Measure Code" := ServiceLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := ServiceLine."Qty. per Unit of Measure";
      "Derived from Blanket Order" := FALSE;
      "Item Category Code" := ServiceLine."Item Category Code";
      Nonstock := ServiceLine.Nonstock;
      "Return Reason Code" := ServiceLine."Return Reason Code";
      "Order Type" := "Order Type"::Service;
      "Order No." := ServiceLine."Document No.";
      "Order Line No." := ServiceLine."Line No.";
      "Job No." := ServiceLine."Job No.";
      "Job Task No." := ServiceLine."Job Task No.";

      OnAfterCopyItemJnlLineFromServLine(Rec,ServiceLine);
    end;
*/


    
//     procedure CopyFromServShptHeader (ServShptHeader@1000 :
    
/*
procedure CopyFromServShptHeader (ServShptHeader: Record 5990)
    begin
      "Document Date" := ServShptHeader."Document Date";
      "Order Date" := ServShptHeader."Order Date";
      "Country/Region Code" := ServShptHeader."VAT Country/Region Code";
      "Source Posting Group" := ServShptHeader."Customer Posting Group";
      "Salespers./Purch. Code" := ServShptHeader."Salesperson Code";
      "Reason Code" := ServShptHeader."Reason Code";

      OnAfterCopyItemJnlLineFromServShptHeader(Rec,ServShptHeader);
    end;
*/


    
//     procedure CopyFromServShptLine (ServShptLine@1000 :
    
/*
procedure CopyFromServShptLine (ServShptLine: Record 5991)
    begin
      "Item No." := ServShptLine."No.";
      Description := ServShptLine.Description;
      "Gen. Bus. Posting Group" := ServShptLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServShptLine."Gen. Prod. Posting Group";
      "Inventory Posting Group" := ServShptLine."Posting Group";
      "Location Code" := ServShptLine."Location Code";
      "Unit of Measure Code" := ServShptLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := ServShptLine."Qty. per Unit of Measure";
      "Variant Code" := ServShptLine."Variant Code";
      "Bin Code" := ServShptLine."Bin Code";
      "Shortcut Dimension 1 Code" := ServShptLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := ServShptLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServShptLine."Dimension Set ID";
      "Entry/exit Point" := ServShptLine."exit Point";
      "Value Entry Type" := ItemJnlLine."Value Entry Type"::"Direct Cost";
      "Transaction Type" := ServShptLine."Transaction Type";
      "Transport Method" := ServShptLine."Transport Method";
      Area := ServShptLine.Area;
      "Transaction Specification" := ServShptLine."Transaction Specification";
      "Qty. per Unit of Measure" := ServShptLine."Qty. per Unit of Measure";
      "Item Category Code" := ServShptLine."Item Category Code";
      Nonstock := ServShptLine.Nonstock;
      "Return Reason Code" := ServShptLine."Return Reason Code";

      OnAfterCopyItemJnlLineFromServShptLine(Rec,ServShptLine);
    end;
*/


    
//     procedure CopyFromServShptLineUndo (ServShptLine@1000 :
    
/*
procedure CopyFromServShptLineUndo (ServShptLine: Record 5991)
    begin
      "Item No." := ServShptLine."No.";
      "Posting Date" := ServShptLine."Posting Date";
      "Order Date" := ServShptLine."Order Date";
      "Inventory Posting Group" := ServShptLine."Posting Group";
      "Gen. Bus. Posting Group" := ServShptLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServShptLine."Gen. Prod. Posting Group";
      "Location Code" := ServShptLine."Location Code";
      "Variant Code" := ServShptLine."Variant Code";
      "Bin Code" := ServShptLine."Bin Code";
      "Entry/exit Point" := ServShptLine."exit Point";
      "Shortcut Dimension 1 Code" := ServShptLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := ServShptLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServShptLine."Dimension Set ID";
      "Value Entry Type" := "Value Entry Type"::"Direct Cost";
      "Item No." := ServShptLine."No.";
      Description := ServShptLine.Description;
      "Location Code" := ServShptLine."Location Code";
      "Variant Code" := ServShptLine."Variant Code";
      "Transaction Type" := ServShptLine."Transaction Type";
      "Transport Method" := ServShptLine."Transport Method";
      Area := ServShptLine.Area;
      "Transaction Specification" := ServShptLine."Transaction Specification";
      "Unit of Measure Code" := ServShptLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := ServShptLine."Qty. per Unit of Measure";
      "Derived from Blanket Order" := FALSE;
      "Item Category Code" := ServShptLine."Item Category Code";
      Nonstock := ServShptLine.Nonstock;
      "Return Reason Code" := ServShptLine."Return Reason Code";

      OnAfterCopyItemJnlLineFromServShptLineUndo(Rec,ServShptLine);
    end;
*/


    
//     procedure CopyFromJobJnlLine (JobJnlLine@1000 :
    
/*
procedure CopyFromJobJnlLine (JobJnlLine: Record 210)
    begin
      "Line No." := JobJnlLine."Line No.";
      "Item No." := JobJnlLine."No.";
      "Posting Date" := JobJnlLine."Posting Date";
      "Document Date" := JobJnlLine."Document Date";
      "Document No." := JobJnlLine."Document No.";
      "External Document No." := JobJnlLine."External Document No.";
      Description := JobJnlLine.Description;
      "Location Code" := JobJnlLine."Location Code";
      "Applies-to Entry" := JobJnlLine."Applies-to Entry";
      "Applies-from Entry" := JobJnlLine."Applies-from Entry";
      "Shortcut Dimension 1 Code" := JobJnlLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := JobJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := JobJnlLine."Dimension Set ID";
      "Country/Region Code" := JobJnlLine."Country/Region Code";
      "Entry Type" := "Entry Type"::"Negative Adjmt.";
      "Source Code" := JobJnlLine."Source Code";
      "Gen. Bus. Posting Group" := JobJnlLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := JobJnlLine."Gen. Prod. Posting Group";
      "Posting No. Series" := JobJnlLine."Posting No. Series";
      "Variant Code" := JobJnlLine."Variant Code";
      "Bin Code" := JobJnlLine."Bin Code";
      "Unit of Measure Code" := JobJnlLine."Unit of Measure Code";
      "Reason Code" := JobJnlLine."Reason Code";
      "Transaction Type" := JobJnlLine."Transaction Type";
      "Transport Method" := JobJnlLine."Transport Method";
      "Entry/exit Point" := JobJnlLine."Entry/exit Point";
      Area := JobJnlLine.Area;
      "Transaction Specification" := JobJnlLine."Transaction Specification";
      "Invoiced Quantity" := JobJnlLine.Quantity;
      "Invoiced Qty. (Base)" := JobJnlLine."Quantity (Base)";
      "Source Currency Code" := JobJnlLine."Source Currency Code";
      Quantity := JobJnlLine.Quantity;
      "Quantity (Base)" := JobJnlLine."Quantity (Base)";
      "Qty. per Unit of Measure" := JobJnlLine."Qty. per Unit of Measure";
      "Unit Cost" := JobJnlLine."Unit Cost (LCY)";
      "Unit Cost (ACY)" := JobJnlLine."Unit Cost";
      Amount := JobJnlLine."Total Cost (LCY)";
      "Amount (ACY)" := JobJnlLine."Total Cost";
      "Value Entry Type" := "Value Entry Type"::"Direct Cost";
      "Job No." := JobJnlLine."Job No.";
      "Job Task No." := JobJnlLine."Job Task No.";

      OnAfterCopyItemJnlLineFromJobJnlLine(Rec,JobJnlLine);
    end;
*/


//     LOCAL procedure CopyFromProdOrderComp (ProdOrderComp@1000 :
    
/*
LOCAL procedure CopyFromProdOrderComp (ProdOrderComp: Record 5407)
    begin
      VALIDATE("Order Line No.",ProdOrderComp."Prod. Order Line No.");
      VALIDATE("Prod. Order Comp. Line No.",ProdOrderComp."Line No.");
      "Unit of Measure Code" := ProdOrderComp."Unit of Measure Code";
      "Location Code" := ProdOrderComp."Location Code";
      VALIDATE("Variant Code",ProdOrderComp."Variant Code");
      VALIDATE("Bin Code",ProdOrderComp."Bin Code");

      OnAfterCopyFromProdOrderComp(Rec,ProdOrderComp);
    end;
*/


//     LOCAL procedure CopyFromProdOrderLine (ProdOrderLine@1000 :
    
/*
LOCAL procedure CopyFromProdOrderLine (ProdOrderLine: Record 5406)
    begin
      VALIDATE("Order Line No.",ProdOrderLine."Line No.");
      "Unit of Measure Code" := ProdOrderLine."Unit of Measure Code";
      "Location Code" := ProdOrderLine."Location Code";
      VALIDATE("Variant Code",ProdOrderLine."Variant Code");
      VALIDATE("Bin Code",ProdOrderLine."Bin Code");

      OnAfterCopyFromProdOrderLine(Rec,ProdOrderLine);
    end;
*/


//     LOCAL procedure CopyFromWorkCenter (WorkCenter@1000 :
    
/*
LOCAL procedure CopyFromWorkCenter (WorkCenter: Record 99000754)
    begin
      "Work Center No." := WorkCenter."No.";
      Description := WorkCenter.Name;
      "Gen. Prod. Posting Group" := WorkCenter."Gen. Prod. Posting Group";
      "Unit Cost Calculation" := WorkCenter."Unit Cost Calculation";

      OnAfterCopyFromWorkCenter(Rec,WorkCenter);
    end;
*/


//     LOCAL procedure CopyFromMachineCenter (MachineCenter@1000 :
    
/*
LOCAL procedure CopyFromMachineCenter (MachineCenter: Record 99000758)
    begin
      "Work Center No." := MachineCenter."Work Center No.";
      Description := MachineCenter.Name;
      "Gen. Prod. Posting Group" := MachineCenter."Gen. Prod. Posting Group";
      "Unit Cost Calculation" := "Unit Cost Calculation"::Time;

      OnAfterCopyFromMachineCenter(Rec,MachineCenter);
    end;
*/


    
/*
LOCAL procedure ReadGLSetup ()
    begin
      if not GLSetupRead then begin
        GLSetup.GET;
        GLSetupRead := TRUE;
      end;
    end;
*/


    
/*
LOCAL procedure RetrieveCosts ()
    var
//       SKU@1000 :
      SKU: Record 5700;
//       InventorySetup@1001 :
      InventorySetup: Record 313;
//       IsHandled@1002 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeRetrieveCosts(Rec,UnitCost,IsHandled);
      if IsHandled then
        exit;

      if ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") or
         ("Item Charge No." <> '')
      then
        exit;

      ReadGLSetup;
      GetItem;

      InventorySetup.GET;
      if InventorySetup."Average Cost Calc. Type" = InventorySetup."Average Cost Calc. Type"::Item then
        UnitCost := Item."Unit Cost"
      else
        if SKU.GET("Location Code","Item No.","Variant Code") then
          UnitCost := SKU."Unit Cost"
        else
          UnitCost := Item."Unit Cost";

      if "Entry Type" = "Entry Type"::Transfer then
        UnitCost := 0
      else
        if Item."Costing Method" <> Item."Costing Method"::Standard then
          UnitCost := ROUND(UnitCost,GLSetup."Unit-Amount Rounding Precision");
    end;
*/


//     LOCAL procedure CalcUnitCost (ItemLedgEntry@1000 :
    
/*
LOCAL procedure CalcUnitCost (ItemLedgEntry: Record 32) : Decimal;
    var
//       ValueEntry@1001 :
      ValueEntry: Record 5802;
//       UnitCost@1002 :
      UnitCost: Decimal;
    begin
      WITH ValueEntry DO begin
        RESET;
        SETCURRENTKEY("Item Ledger Entry No.");
        SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
        CALCSUMS("Cost Amount (Expected)","Cost Amount (Actual)");
        UnitCost :=
          ("Cost Amount (Expected)" + "Cost Amount (Actual)") / ItemLedgEntry.Quantity;
      end;
      exit(ABS(UnitCost * "Qty. per Unit of Measure"));
    end;
*/


    
/*
LOCAL procedure ClearSingleAndRolledUpCosts ()
    begin
      "Single-Level Material Cost" := "Unit Cost (Revalued)";
      "Single-Level Capacity Cost" := 0;
      "Single-Level Subcontrd. Cost" := 0;
      "Single-Level Cap. Ovhd Cost" := 0;
      "Single-Level Mfg. Ovhd Cost" := 0;
      "Rolled-up Material Cost" := "Unit Cost (Revalued)";
      "Rolled-up Capacity Cost" := 0;
      "Rolled-up Subcontracted Cost" := 0;
      "Rolled-up Mfg. Ovhd Cost" := 0;
      "Rolled-up Cap. Overhead Cost" := 0;
    end;
*/


    
/*
LOCAL procedure GetMfgSetup ()
    begin
      if not MfgSetupRead then
        MfgSetup.GET;
      MfgSetupRead := TRUE;
    end;
*/


//     LOCAL procedure GetProdOrderRtngLine (var ProdOrderRtngLine@1000 :
    
/*
LOCAL procedure GetProdOrderRtngLine (var ProdOrderRtngLine: Record 5409)
    begin
      TESTFIELD("Order Type","Order Type"::Production);
      TESTFIELD("Order No.");
      TESTFIELD("Operation No.");

      ProdOrderRtngLine.GET(
        ProdOrderRtngLine.Status::Released,
        "Order No.","Routing Reference No.","Routing No.","Operation No.");
    end;
*/


    
    
/*
procedure OnlyStopTime () : Boolean;
    begin
      exit(("Setup Time" = 0) and ("Run Time" = 0) and ("Stop Time" <> 0));
    end;
*/


    
    
/*
procedure OutputValuePosting () : Boolean;
    begin
      exit(TimeIsEmpty and ("Invoiced Quantity" <> 0) and not Subcontracting);
    end;
*/


    
    
/*
procedure TimeIsEmpty () : Boolean;
    begin
      exit(("Setup Time" = 0) and ("Run Time" = 0) and ("Stop Time" = 0));
    end;
*/


    
    
/*
procedure RowID1 () : Text[250];
    var
//       ItemTrackingMgt@1000 :
      ItemTrackingMgt: Codeunit 6500;
    begin
      exit(
        ItemTrackingMgt.ComposeRowID(DATABASE::"Item Journal Line","Entry Type",
          "Journal Template Name","Journal Batch Name",0,"Line No."));
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


//     LOCAL procedure GetBin (LocationCode@1000 : Code[10];BinCode@1001 :
    
/*
LOCAL procedure GetBin (LocationCode: Code[10];BinCode: Code[20])
    begin
      if BinCode = '' then
        CLEAR(Bin)
      else
        if (Bin.Code <> BinCode) or (Bin."Location Code" <> LocationCode) then
          Bin.GET(LocationCode,BinCode);
    end;
*/


    
    
/*
procedure ItemPosting () : Boolean;
    var
//       ProdOrderRtngLine@1000 :
      ProdOrderRtngLine: Record 5409;
    begin
      if ("Entry Type" = "Entry Type"::Output) and
         ("Output Quantity" <> 0) and
         ("Operation No." <> '')
      then begin
        ProdOrderRtngLine.GET(
          ProdOrderRtngLine.Status::Released,
          "Order No.",
          "Routing Reference No.",
          "Routing No.",
          "Operation No.");
        exit(ProdOrderRtngLine."Next Operation No." = '');
      end;
      exit(TRUE);
    end;
*/


    
/*
LOCAL procedure CheckPlanningAssignment ()
    begin
      if ("Quantity (Base)" <> 0) and ("Item No." <> '') and ("Posting Date" <> 0D) and
         ("Entry Type" IN ["Entry Type"::"Negative Adjmt.","Entry Type"::"Positive Adjmt.","Entry Type"::Transfer])
      then begin
        if ("Entry Type" = "Entry Type"::Transfer) and ("Location Code" = "New Location Code") then
          exit;

        ReserveItemJnlLine.AssignForPlanning(Rec);
      end;
    end;
*/


    
//     procedure LastOutputOperation (ItemJnlLine@1000 :
    
/*
procedure LastOutputOperation (ItemJnlLine: Record 83) : Boolean;
    var
//       ProdOrderRtngLine@1002 :
      ProdOrderRtngLine: Record 5409;
//       ItemJnlPostLine@1001 :
      ItemJnlPostLine: Codeunit 22;
//       Operation@1003 :
      Operation: Boolean;
//       IsHandled@1004 :
      IsHandled: Boolean;
    begin
      WITH ItemJnlLine DO begin
        if "Operation No." <> '' then begin
          IsHandled := FALSE;
          OnLastOutputOperationOnBeforeTestRoutingNo(ItemJnlLine,IsHandled);
          if not IsHandled then
            TESTFIELD("Routing No.");
          if not ProdOrderRtngLine.GET(
               ProdOrderRtngLine.Status::Released,"Order No.",
               "Routing Reference No.","Routing No.","Operation No.")
          then
            ProdOrderRtngLine.GET(
              ProdOrderRtngLine.Status::Finished,"Order No.",
              "Routing Reference No.","Routing No.","Operation No.");
          if Finished then
            ProdOrderRtngLine."Routing Status" := ProdOrderRtngLine."Routing Status"::Finished
          else
            ProdOrderRtngLine."Routing Status" := ProdOrderRtngLine."Routing Status"::"In Progress";
          Operation := not ItemJnlPostLine.NextOperationExist(ProdOrderRtngLine);
        end else
          Operation := TRUE;
      end;
      exit(Operation);
    end;
*/


    
    
/*
procedure LookupItemNo ()
    var
//       ItemList@1000 :
      ItemList: Page 31;
    begin
      CASE "Entry Type" OF
        "Entry Type"::Consumption:
          LookupProdOrderComp;
        "Entry Type"::Output:
          LookupProdOrderLine;
        else begin
          ItemList.LOOKUPMODE := TRUE;
          if ItemList.RUNMODAL = ACTION::LookupOK then begin
            ItemList.GETRECORD(Item);
            VALIDATE("Item No.",Item."No.");
          end;
        end;
      end;
    end;
*/


    
/*
LOCAL procedure LookupProdOrderLine ()
    var
//       ProdOrderLine@1004 :
      ProdOrderLine: Record 5406;
//       ProdOrderLineList@1001 :
      ProdOrderLineList: Page 5406;
    begin
      ProdOrderLine.SetFilterByReleasedOrderNo("Order No.");
      ProdOrderLine.Status := ProdOrderLine.Status::Released;
      ProdOrderLine."Prod. Order No." := "Order No.";
      ProdOrderLine."Line No." := "Order Line No.";
      ProdOrderLine."Item No." := "Item No.";

      ProdOrderLineList.LOOKUPMODE(TRUE);
      ProdOrderLineList.SETTABLEVIEW(ProdOrderLine);
      ProdOrderLineList.SETRECORD(ProdOrderLine);

      if ProdOrderLineList.RUNMODAL = ACTION::LookupOK then begin
        ProdOrderLineList.GETRECORD(ProdOrderLine);
        VALIDATE("Item No.",ProdOrderLine."Item No.");
        if "Order Line No." <> ProdOrderLine."Line No." then
          VALIDATE("Order Line No.",ProdOrderLine."Line No.");
      end;
    end;
*/


    
/*
LOCAL procedure LookupProdOrderComp ()
    var
//       ProdOrderComp@1004 :
      ProdOrderComp: Record 5407;
//       ProdOrderCompLineList@1001 :
      ProdOrderCompLineList: Page 5407;
    begin
      ProdOrderComp.SetFilterByReleasedOrderNo("Order No.");
      if "Order Line No." <> 0 then
        ProdOrderComp.SETRANGE("Prod. Order Line No.","Order Line No.");
      ProdOrderComp.Status := ProdOrderComp.Status::Released;
      ProdOrderComp."Prod. Order No." := "Order No.";
      ProdOrderComp."Prod. Order Line No." := "Order Line No.";
      ProdOrderComp."Line No." := "Prod. Order Comp. Line No.";
      ProdOrderComp."Item No." := "Item No.";

      ProdOrderCompLineList.LOOKUPMODE(TRUE);
      ProdOrderCompLineList.SETTABLEVIEW(ProdOrderComp);
      ProdOrderCompLineList.SETRECORD(ProdOrderComp);

      if ProdOrderCompLineList.RUNMODAL = ACTION::LookupOK then begin
        ProdOrderCompLineList.GETRECORD(ProdOrderComp);
        if "Prod. Order Comp. Line No." <> ProdOrderComp."Line No." then begin
          VALIDATE("Item No.",ProdOrderComp."Item No.");
          VALIDATE("Prod. Order Comp. Line No.",ProdOrderComp."Line No.");
        end;
      end;
    end;
*/


    
    
/*
procedure RecalculateUnitAmount ()
    var
//       ItemJnlLine1@1000 :
      ItemJnlLine1: Record 83;
    begin
      GetItem;

      if ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") or
         ("Item Charge No." <> '')
      then begin
        "Indirect Cost %" := 0;
        "Overhead Rate" := 0;
      end else begin
        "Indirect Cost %" := Item."Indirect Cost %";
        "Overhead Rate" := Item."Overhead Rate";
      end;

      "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
      GetUnitAmount(FIELDNO("Unit of Measure Code"));

      ReadGLSetup;

      UpdateAmount;

      CASE "Entry Type" OF
        "Entry Type"::Purchase:
          begin
            ItemJnlLine1.COPY(Rec);
            PurchPriceCalcMgt.FindItemJnlLinePrice(ItemJnlLine1,FIELDNO("Unit of Measure Code"));
            "Unit Cost" := ROUND(ItemJnlLine1."Unit Amount" * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
          end;
        "Entry Type"::Sale:
          "Unit Cost" := ROUND(UnitCost * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
        "Entry Type"::"Positive Adjmt.":
          "Unit Cost" :=
            ROUND(
              "Unit Amount" * (1 + "Indirect Cost %" / 100),GLSetup."Unit-Amount Rounding Precision") +
            "Overhead Rate" * "Qty. per Unit of Measure";
        "Entry Type"::"Negative Adjmt.":
          if not "Phys. Inventory" then
            "Unit Cost" := UnitCost * "Qty. per Unit of Measure";
      end;

      if "Entry Type" IN ["Entry Type"::Purchase,"Entry Type"::"Positive Adjmt."] then begin
        if Item."Costing Method" = Item."Costing Method"::Standard then
          "Unit Cost" := ROUND(UnitCost * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
      end;
    end;
*/


    
//     procedure IsReclass (ItemJnlLine@1000 :
    
/*
procedure IsReclass (ItemJnlLine: Record 83) : Boolean;
    begin
      if (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer) and
         ((ItemJnlLine."Order Type" <> ItemJnlLine."Order Type"::Transfer) or (ItemJnlLine."Order No." = ''))
      then
        exit(TRUE);
      exit(FALSE);
    end;
*/


    
//     procedure CheckWhse (LocationCode@1000 : Code[20];var QtyToPost@1002 :
    
/*
procedure CheckWhse (LocationCode: Code[20];var QtyToPost: Decimal)
    var
//       Location@1001 :
      Location: Record 14;
    begin
      Location.GET(LocationCode);
      if Location."Require Put-away" and
         (not Location."Directed Put-away and Pick") and
         (not Location."Require Receive")
      then
        QtyToPost := 0;
    end;
*/


    
    
/*
procedure ShowDimensions ()
    begin
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;
*/


    
    
/*
procedure ShowReclasDimensions ()
    begin
      DimMgt.EditReclasDimensionSet2(
        "Dimension Set ID","New Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
        "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","New Shortcut Dimension 1 Code","New Shortcut Dimension 2 Code");
    end;
*/


    
//     procedure PostingItemJnlFromProduction (Print@1000 :
    
/*
procedure PostingItemJnlFromProduction (Print: Boolean)
    var
//       ProductionOrder@1001 :
      ProductionOrder: Record 5405;
//       IsHandled@1002 :
      IsHandled: Boolean;
    begin
      if ("Order Type" = "Order Type"::Production) and ("Order No." <> '') then
        ProductionOrder.GET(ProductionOrder.Status::Released,"Order No.");

      IsHandled := FALSE;
      OnBeforePostingItemJnlFromProduction(Rec,Print,IsHandled);
      if IsHandled then
        exit;

      if Print then
        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print",Rec)
      else
        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",Rec);
    end;
*/


    
    
/*
procedure IsAssemblyResourceConsumpLine () : Boolean;
    begin
      exit(("Entry Type" = "Entry Type"::"Assembly Output") and (Type = Type::Resource));
    end;
*/


    
    
/*
procedure IsAssemblyOutputLine () : Boolean;
    begin
      exit(("Entry Type" = "Entry Type"::"Assembly Output") and (Type = Type::" "));
    end;
*/


    
    
/*
procedure IsATOCorrection () : Boolean;
    var
//       ItemLedgEntry@1000 :
      ItemLedgEntry: Record 32;
//       PostedATOLink@1001 :
      PostedATOLink: Record 914;
    begin
      if not Correction then
        exit(FALSE);
      if "Entry Type" <> "Entry Type"::Sale then
        exit(FALSE);
      if not ItemLedgEntry.GET("Applies-to Entry") then
        exit(FALSE);
      if ItemLedgEntry."Entry Type" <> ItemLedgEntry."Entry Type"::Sale then
        exit(FALSE);
      PostedATOLink.SETCURRENTKEY("Document Type","Document No.","Document Line No.");
      PostedATOLink.SETRANGE("Document Type",PostedATOLink."Document Type"::"Sales Shipment");
      PostedATOLink.SETRANGE("Document No.",ItemLedgEntry."Document No.");
      PostedATOLink.SETRANGE("Document Line No.",ItemLedgEntry."Document Line No.");
      exit(not PostedATOLink.ISEMPTY);
    end;
*/


//     LOCAL procedure RevaluationPerEntryAllowed (ItemNo@1000 :
    
/*
LOCAL procedure RevaluationPerEntryAllowed (ItemNo: Code[20]) : Boolean;
    var
//       ValueEntry@1001 :
      ValueEntry: Record 5802;
    begin
      GetItem;
      if Item."Costing Method" <> Item."Costing Method"::Average then
        exit(TRUE);

      ValueEntry.SETRANGE("Item No.",ItemNo);
      ValueEntry.SETRANGE("Entry Type",ValueEntry."Entry Type"::Revaluation);
      ValueEntry.SETRANGE("Partial Revaluation",TRUE);
      exit(ValueEntry.ISEMPTY);
    end;
*/


    
    
/*
procedure ClearTracking ()
    begin
      "Serial No." := '';
      "Lot No." := '';

      OnAfterClearTracking(Rec);
    end;
*/


    
//     procedure CopyTrackingFromSpec (TrackingSpecification@1000 :
    
/*
procedure CopyTrackingFromSpec (TrackingSpecification: Record 336)
    begin
      "Serial No." := TrackingSpecification."Serial No.";
      "Lot No." := TrackingSpecification."Lot No.";

      OnAfterCopyTrackingFromSpec(Rec,TrackingSpecification);
    end;
*/


    
    
/*
procedure TrackingExists () : Boolean;
    begin
      exit(("Serial No." <> '') or ("Lot No." <> ''));
    end;
*/


    
//     procedure TestItemFields (ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 :
    
/*
procedure TestItemFields (ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10])
    begin
      TESTFIELD("Item No.",ItemNo);
      TESTFIELD("Variant Code",VariantCode);
      TESTFIELD("Location Code",LocationCode);
    end;
*/


    
//     procedure DisplayErrorIfItemIsBlocked (Item@1000 :
    
/*
procedure DisplayErrorIfItemIsBlocked (Item: Record 27)
    begin
      if Item.Blocked then
        ERROR(BlockedErr);

      if "Item Charge No." <> '' then
        exit;

      CASE "Entry Type" OF
        "Entry Type"::Purchase:
          if Item."Purchasing Blocked" and
             not ("Document Type" IN ["Document Type"::"Purchase Return Shipment","Document Type"::"Purchase Credit Memo"])
          then
            ERROR(PurchasingBlockedErr);
        "Entry Type"::Sale:
          if Item."Sales Blocked" and
             not ("Document Type" IN ["Document Type"::"Sales Return Receipt","Document Type"::"Sales Credit Memo"])
          then
            ERROR(SalesBlockedErr);
      end;
    end;
*/


    
    
/*
procedure IsPurchaseReturn () : Boolean;
    begin
      exit(
        ("Document Type" IN ["Document Type"::"Purchase Credit Memo",
                             "Document Type"::"Purchase Return Shipment",
                             "Document Type"::"Purchase Invoice",
                             "Document Type"::"Purchase Receipt"]) and
        (Quantity < 0));
    end;
*/


    
    
/*
procedure IsOpenedFromBatch () : Boolean;
    var
//       ItemJournalBatch@1002 :
      ItemJournalBatch: Record 233;
//       TemplateFilter@1001 :
      TemplateFilter: Text;
//       BatchFilter@1000 :
      BatchFilter: Text;
    begin
      BatchFilter := GETFILTER("Journal Batch Name");
      if BatchFilter <> '' then begin
        TemplateFilter := GETFILTER("Journal Template Name");
        if TemplateFilter <> '' then
          ItemJournalBatch.SETFILTER("Journal Template Name",TemplateFilter);
        ItemJournalBatch.SETFILTER(Name,BatchFilter);
        ItemJournalBatch.FINDFIRST;
      end;

      exit((("Journal Batch Name" <> '') and ("Journal Template Name" = '')) or (BatchFilter <> ''));
    end;
*/


    
    
/*
procedure SubcontractingWorkCenterUsed () : Boolean;
    var
//       WorkCenter@1000 :
      WorkCenter: Record 99000754;
    begin
      if Type = Type::"Work Center" then
        if WorkCenter.GET("Work Center No.") then
          exit(WorkCenter."Subcontractor No." <> '');

      exit(FALSE);
    end;
*/


    
    
/*
procedure CheckItemJournalLineRestriction ()
    begin
      OnCheckItemJournalLinePostRestrictions;
    end;
*/


    
    
/*
procedure ValidateTypeWithItemNo ()
    begin
      // Validate the item type when defining a relation with another table

      // Service is not a valid item type
      // i.e items of type service cannot be in a relation with another table
      if Item.IsServiceType then
        Item.TESTFIELD(Type,Item.Type::Inventory);

      // Non-inventoriable item types are valid only for the following entry types
      if Item.IsNonInventoriableType and
         not ("Entry Type" IN ["Entry Type"::Consumption,"Entry Type"::"Assembly Consumption"])
      then
        Item.TESTFIELD(Type,Item.Type::Inventory);
    end;
*/


    
//     LOCAL procedure OnAfterSetupNewLine (var ItemJournalLine@1000 : Record 83;var LastItemJournalLine@1001 : Record 83;ItemJournalTemplate@1002 :
    
/*
LOCAL procedure OnAfterSetupNewLine (var ItemJournalLine: Record 83;var LastItemJournalLine: Record 83;ItemJournalTemplate: Record 82)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterClearTracking (var ItemJournalLine@1000 :
    
/*
LOCAL procedure OnAfterClearTracking (var ItemJournalLine: Record 83)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyItemJnlLineFromSalesHeader (var ItemJnlLine@1001 : Record 83;SalesHeader@1000 :
    
/*
LOCAL procedure OnAfterCopyItemJnlLineFromSalesHeader (var ItemJnlLine: Record 83;SalesHeader: Record 36)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyItemJnlLineFromSalesLine (var ItemJnlLine@1001 : Record 83;SalesLine@1000 :
    
/*
LOCAL procedure OnAfterCopyItemJnlLineFromSalesLine (var ItemJnlLine: Record 83;SalesLine: Record 37)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyItemJnlLineFromPurchHeader (var ItemJnlLine@1001 : Record 83;PurchHeader@1000 :
    
/*
LOCAL procedure OnAfterCopyItemJnlLineFromPurchHeader (var ItemJnlLine: Record 83;PurchHeader: Record 38)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyItemJnlLineFromPurchLine (var ItemJnlLine@1001 : Record 83;PurchLine@1000 :
    
/*
LOCAL procedure OnAfterCopyItemJnlLineFromPurchLine (var ItemJnlLine: Record 83;PurchLine: Record 39)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyItemJnlLineFromServHeader (var ItemJnlLine@1001 : Record 83;ServHeader@1000 :
    
/*
LOCAL procedure OnAfterCopyItemJnlLineFromServHeader (var ItemJnlLine: Record 83;ServHeader: Record 5900)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyItemJnlLineFromServLine (var ItemJnlLine@1001 : Record 83;ServLine@1000 :
    
/*
LOCAL procedure OnAfterCopyItemJnlLineFromServLine (var ItemJnlLine: Record 83;ServLine: Record 5902)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyItemJnlLineFromServShptHeader (var ItemJnlLine@1001 : Record 83;ServShptHeader@1000 :
    
/*
LOCAL procedure OnAfterCopyItemJnlLineFromServShptHeader (var ItemJnlLine: Record 83;ServShptHeader: Record 5990)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyItemJnlLineFromServShptLine (var ItemJnlLine@1001 : Record 83;ServShptLine@1000 :
    
/*
LOCAL procedure OnAfterCopyItemJnlLineFromServShptLine (var ItemJnlLine: Record 83;ServShptLine: Record 5991)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyItemJnlLineFromServShptLineUndo (var ItemJnlLine@1001 : Record 83;ServShptLine@1000 :
    
/*
LOCAL procedure OnAfterCopyItemJnlLineFromServShptLineUndo (var ItemJnlLine: Record 83;ServShptLine: Record 5991)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyItemJnlLineFromJobJnlLine (var ItemJournalLine@1001 : Record 83;JobJournalLine@1000 :
    
/*
LOCAL procedure OnAfterCopyItemJnlLineFromJobJnlLine (var ItemJournalLine: Record 83;JobJournalLine: Record 210)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyTrackingFromSpec (var ItemJournalLine@1000 : Record 83;TrackingSpecification@1001 :
    
/*
LOCAL procedure OnAfterCopyTrackingFromSpec (var ItemJournalLine: Record 83;TrackingSpecification: Record 336)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromProdOrderComp (var ItemJournalLine@1000 : Record 83;ProdOrderComponent@1001 :
    
/*
LOCAL procedure OnAfterCopyFromProdOrderComp (var ItemJournalLine: Record 83;ProdOrderComponent: Record 5407)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromProdOrderLine (var ItemJournalLine@1000 : Record 83;ProdOrderLine@1001 :
    
/*
LOCAL procedure OnAfterCopyFromProdOrderLine (var ItemJournalLine: Record 83;ProdOrderLine: Record 5406)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromWorkCenter (var ItemJournalLine@1000 : Record 83;WorkCenter@1001 :
    
/*
LOCAL procedure OnAfterCopyFromWorkCenter (var ItemJournalLine: Record 83;WorkCenter: Record 99000754)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromMachineCenter (var ItemJournalLine@1000 : Record 83;MachineCenter@1001 :
    
/*
LOCAL procedure OnAfterCopyFromMachineCenter (var ItemJournalLine: Record 83;MachineCenter: Record 99000758)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterGetItemChange (var Item@1000 : Record 27;var ItemJournalLine@1001 :
    
/*
LOCAL procedure OnAfterGetItemChange (var Item: Record 27;var ItemJournalLine: Record 83)
    begin
    end;

    [Integration(DEFAULT,TRUE)]
*/

//     LOCAL procedure OnAfterOnValidateItemNoAssignByEntryType (var ItemJournalLine@1000 : Record 83;var Item@1001 :
    
/*
LOCAL procedure OnAfterOnValidateItemNoAssignByEntryType (var ItemJournalLine: Record 83;var Item: Record 27)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCreateDimTableIDs (var ItemJournalLine@1000 : Record 83;FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :
    
/*
LOCAL procedure OnAfterCreateDimTableIDs (var ItemJournalLine: Record 83;FieldNo: Integer;var TableID: ARRAY [10] OF Integer;var No: ARRAY [10] OF Code[20])
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateAmount (var ItemJournalLine@1000 :
    
/*
LOCAL procedure OnAfterUpdateAmount (var ItemJournalLine: Record 83)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforePostingItemJnlFromProduction (var ItemJournalLine@1000 : Record 83;Print@1001 : Boolean;var IsHandled@1002 :
    
/*
LOCAL procedure OnBeforePostingItemJnlFromProduction (var ItemJournalLine: Record 83;Print: Boolean;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeRetrieveCosts (var ItemJournalLine@1000 : Record 83;var UnitCost@1001 : Decimal;var IsHandled@1002 :
    
/*
LOCAL procedure OnBeforeRetrieveCosts (var ItemJournalLine: Record 83;var UnitCost: Decimal;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeVerifyReservedQty (var ItemJournalLine@1000 : Record 83;xItemJournalLine@1001 : Record 83;CalledByFieldNo@1002 :
    
/*
LOCAL procedure OnBeforeVerifyReservedQty (var ItemJournalLine: Record 83;xItemJournalLine: Record 83;CalledByFieldNo: Integer)
    begin
    end;
*/


    
/*
LOCAL procedure ConfirmOutputOnFinishedOperation ()
    var
//       ProdOrderRtngLine@1000 :
      ProdOrderRtngLine: Record 5409;
    begin
      if ("Entry Type" <> "Entry Type"::Output) or ("Output Quantity" = 0) then
        exit;

      if not ProdOrderRtngLine.GET(
           ProdOrderRtngLine.Status::Released,"Order No.","Routing Reference No.","Routing No.","Operation No.")
      then
        exit;

      if ProdOrderRtngLine."Routing Status" <> ProdOrderRtngLine."Routing Status"::Finished then
        exit;

      if not CONFIRM(FinishedOutputQst) then
        ERROR(UpdateInterruptedErr);
    end;

    [Integration(TRUE)]
*/

    
/*
LOCAL procedure OnCheckItemJournalLinePostRestrictions ()
    begin
    end;
*/


    
//     LOCAL procedure OnLastOutputOperationOnBeforeTestRoutingNo (var ItemJournalLine@1000 : Record 83;var IsHandled@1001 :
    
/*
LOCAL procedure OnLastOutputOperationOnBeforeTestRoutingNo (var ItemJournalLine: Record 83;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnValidateItemNoOnAfterGetItem (var ItemJournalLine@1000 : Record 83;Item@1001 :
    
/*
LOCAL procedure OnValidateItemNoOnAfterGetItem (var ItemJournalLine: Record 83;Item: Record 27)
    begin
    end;

    /*begin
    //{
//      DGG 08/10/21: - QB 1.09.21 Added fields 7207500QB Diverse Entrance, 7207501QB Ceded Control
//      CPA 15/12/21: - QB 1.10.23 (Q15921) Si viene de un albar n de compra New Field: QB Automatic Shipment
//      AML 22/03/22 QB_ST01 Creados los campos QB_ST01 para control de valoraci¢n de stocks.
//    }
    end.
  */
}





