table 7206976 "QBU Ceded Entry"
{
  
  
    CaptionML=ENU='Ceded Entry',ESP='Mov. prestados';
    LookupPageID="QB Ceded Entry List";
    DrillDownPageID="QB Ceded Entry List";
  
  fields
{
    field(1;"Entry No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Entry No.',ESP='N§ mov.';


    }
    field(2;"Ceded Entry No.";Integer)
    {
        TableRelation="QB Ceded"."Entry No.";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Ceded Entry No.',ESP='No. mov. prestado';


    }
    field(3;"Posting Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Posting Date',ESP='Fecha registro';


    }
    field(4;"Document No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document No.',ESP='N§ documento';


    }
    field(5;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(6;"Origin Location";Code[20])
    {
        TableRelation="Location";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Origin Location',ESP='C¢d. almac‚n origen';


    }
    field(7;"Quantity";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Quantity',ESP='Cantidad';


    }
    field(8;"User";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User',ESP='Usuario';


    }
    field(9;"Item Entry No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Item Entry No.',ESP='No. mov. producto';


    }
    field(10;"Destination Location";Code[20])
    {
        TableRelation="Location";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Destination Location',ESP='Almac‚n destino';


    }
    field(11;"Item No.";Code[20])
    {
        TableRelation="Item"."No.";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Item No.',ESP='No. producto';


    }
    field(12;"Cost Amount (Actual)";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Coste real';
                                                   Description='Q17138';


    }
    field(13;"Cost Amount (Expected)";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Coste te¢rico';
                                                   Description='Q17138' ;


    }
}
  keys
{
    key(key1;"Entry No.")
    {
        SumIndexFields="Quantity";
                                                   Clustered=true;
    }
    key(key2;"Item No.")
    {
        SumIndexFields="Quantity";
    }
}
  fieldgroups
{
}
  

    // procedure CreateCededEntry (ItemLedgerEntry@1100286000 : Record 32;CededEntryNo@1100286001 : Integer;LocationNew@1100286006 : Code[20];Qty@1100286002 : Decimal;TotalQty@1100286008 :
procedure CreateCededEntry (ItemLedgerEntry: Record 32;CededEntryNo: Integer;LocationNew: Code[20];Qty: Decimal;TotalQty: Decimal)
    var
//       CededEntry@1100286003 :
      CededEntry: Record 7206976;
//       rItem@1100286004 :
      rItem: Record 27;
//       NoMov@1100286005 :
      NoMov: Integer;
//       Ceded@1100286007 :
      Ceded: Record 7206975;
    begin
      NoMov := 1;
      CededEntry.RESET;
      if CededEntry.FINDLAST then
        NoMov := CededEntry."Entry No."+ 1;

      INIT;
      VALIDATE("Entry No.",NoMov);
      VALIDATE("Ceded Entry No.",CededEntryNo);
      VALIDATE("Posting Date",ItemLedgerEntry."Posting Date");
      VALIDATE("Document No.",ItemLedgerEntry."Document No.");
      "Item No." := ItemLedgerEntry."Item No.";
      VALIDATE(Description,ItemLedgerEntry.Description);
      if ItemLedgerEntry.Description = '' then begin
        rItem.GET(ItemLedgerEntry."Item No.");
        Description := rItem.Description;
      end else
        VALIDATE(Description,ItemLedgerEntry.Description);

      //CPA begin
      VALIDATE("Origin Location",LocationNew);
      VALIDATE("Destination Location",ItemLedgerEntry."Location Code");

      //Deshago el cambio
      //VALIDATE("Origin Location",ItemLedgerEntry."Location Code");
      //VALIDATE("Destination Location",LocationNew);
      //CPA end

      //EPV 26/05/22 <--
      CalculateCostCededEntry(ItemLedgerEntry);
      // EPV 26/05/22 -->

      //PGM 06/10/20 -
      if TotalQty <> 0 then begin
        if Qty >= TotalQty then
          VALIDATE(Quantity,Qty)
        else
          VALIDATE(Quantity,TotalQty);
      end else
        VALIDATE(Quantity,Qty);
      //PGM 06/10/20 +
      User := USERID;
      VALIDATE("Item Entry No.",ItemLedgerEntry."Entry No.");
      INSERT(TRUE);

      if Ceded.GET(CededEntryNo) then  begin
        Ceded.CALCFIELDS("Remaining Quantity");
      //PGM 06/10/20 -
        if TotalQty <> 0 then begin
          if Qty >= TotalQty then
            Ceded."Remaining Quantity." := Ceded."Remaining Quantity"
          else
            Ceded."Remaining Quantity." := Ceded."Remaining Quantity." + TotalQty;
        end else
          Ceded."Remaining Quantity." := Ceded."Remaining Quantity";
      //PGM 06/10/20 +
        if Ceded."Remaining Quantity" = 0 then
          Ceded.Open := FALSE;
        Ceded.MODIFY;
      end;
    end;

//     LOCAL procedure CalculateCostCededEntry (pItemLedgerEntry@1100286000 :
    LOCAL procedure CalculateCostCededEntry (pItemLedgerEntry: Record 32)
    var
//       rlPurchaseLine@1100286001 :
      rlPurchaseLine: Record 39;
//       rlItem@1100286002 :
      rlItem: Record 27;
//       QuoBuildingSetup@1100286003 :
      QuoBuildingSetup: Record 7207278;
    begin
      CASE pItemLedgerEntry."Entry Type" OF

        pItemLedgerEntry."Entry Type"::Purchase:
          begin
            if rlPurchaseLine.GET(rlPurchaseLine."Document Type"::Order, pItemLedgerEntry."QB Stocks Document No", pItemLedgerEntry."QB Stocks Output Shipment Line") then
              "Cost Amount (Actual)":= rlPurchaseLine."Unit Cost";
          end;

        pItemLedgerEntry."Entry Type"::"Positive Adjmt.":
          begin
            if rlItem.GET(pItemLedgerEntry."Item No.") then
              begin
                // El movimiento de pr‚stamo se valora seg£n la configuraci¢n de QB Setup.
                QuoBuildingSetup.GET;
                CASE QuoBuildingSetup."Coste prod. prestados recibido" OF
                  QuoBuildingSetup."Coste prod. prestados recibido"::"Coste almacen principal":
                    begin
                      rlItem.CALCFIELDS("QB Main Location Cost");
                      "Cost Amount (Expected)":= rlItem."QB Main Location Cost";
                    end;

                  QuoBuildingSetup."Coste prod. prestados recibido"::"Ultimo coste directo":
                    begin
                      "Cost Amount (Expected)":= rlItem."Last Direct Cost";
                    end;

                  QuoBuildingSetup."Coste prod. prestados recibido"::"Coste medio compra":
                    begin
                      "Cost Amount (Expected)":= rlItem."QB Main Loc. Purch. Average Pr";
                    end;
                end; //case
              end;
          end;

      end;
    end;

    /*begin
    //{
//      EPV 26/05/22 Q17138 Creaci¢n de nuevos campos para control del coste
//            12 Cost Amount (Actual)
//            13 Cost Amount (Expected)
//
//      EPV 26/05/22 Q17138 Funci¢n "CalculateCostCededEntry" para el c lculo del coste del movimiento prestado.
//    }
    end.
  */
}







