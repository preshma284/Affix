pageextension 50238 MyExtension5907 extends 5907//5902
{
layout
{
addafter("ShortcutDimCode[8]")
{
    field("Qty. to Consume";rec."Qty. to Consume")
    {
        
}
    field("Job No.";rec."Job No.")
    {
        
}
    field("Job Task No.";rec."Job Task No.")
    {
        
}
    field("Job Line Type";rec."Job Line Type")
    {
        
}
    field("Job Planning Line No.";rec."Job Planning Line No.")
    {
        
}
}

}

actions
{


}

//trigger

//trigger

var
      Text000 : TextConst ENU='You cannot open the window because %1 is %2 in the %3 table.',ESP='No puede abrir la ventana porque %1 es %2 en la tabla %3.';
      ServMgtSetup : Record 5911;
      ItemAvailFormsMgt : Codeunit 353;
      ServItemLineNo : Integer;
      ShortcutDimCode : ARRAY [8] OF Code[20];

    

//procedure
//procedure SetValues(TempServItemLineNo : Integer);
//    begin
//      ServItemLineNo := TempServItemLineNo;
//      Rec.SETFILTER("Service Item Line No.",'=%1|=%2',0,ServItemLineNo);
//    end;
//Local procedure InsertStartFee();
//    var
//      ServOrderMgt : Codeunit 5900;
//    begin
//      CLEAR(ServOrderMgt);
//      if ( ServOrderMgt.InsertServCost(Rec,1,TRUE)  )then
//        CurrPage.UPDATE;
//    end;
//Local procedure InsertTravelFee();
//    var
//      ServOrderMgt : Codeunit 5900;
//    begin
//      CLEAR(ServOrderMgt);
//      if ( ServOrderMgt.InsertServCost(Rec,0,TRUE)  )then
//        CurrPage.UPDATE;
//    end;
//Local procedure InsertExtendedText(Unconditionally : Boolean);
//    var
//      TransferExtendedText : Codeunit 378;
//    begin
//      OnBeforeInsertExtendedText(Rec);
//      if ( TransferExtendedText.ServCheckIfAnyExtText(Rec,Unconditionally)  )then begin
//        CurrPage.SAVERECORD;
//        TransferExtendedText.InsertServExtText(Rec);
//      end;
//      if ( TransferExtendedText.MakeUpdate  )then
//        CurrPage.UPDATE;
//    end;
//Local procedure ShowReservationEntries();
//    begin
//      rec.ShowReservationEntries(TRUE);
//    end;
//Local procedure SelectFaultResolutionCode();
//    var
//      ServItemLine : Record 5901;
//      FaultResolutionRelation : Page 5930;
//    begin
//      ServMgtSetup.GET;
//      CASE ServMgtSetup."Fault Reporting Level" OF
//        ServMgtSetup."Fault Reporting Level"::None:
//          ERROR(
//            Text000,
//            ServMgtSetup.FIELDCAPTION("Fault Reporting Level"),ServMgtSetup."Fault Reporting Level",ServMgtSetup.TABLECAPTION);
//      end;
//      ServItemLine.GET(rec."Document Type",rec."Document No.",rec."Service Item Line No.");
//      CLEAR(FaultResolutionRelation);
//      FaultResolutionRelation.SetDocument(DATABASE::"Service Line",rec."Document Type",rec."Document No.",rec."Line No.");
//      FaultResolutionRelation.SetFilters(rec."Symptom Code",rec."Fault Code",rec."Fault Area Code",ServItemLine."Service Item Group Code");
//      FaultResolutionRelation.RUNMODAL;
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure SelectItemSubstitution();
//    begin
//      rec.ShowItemSub;
//      Rec.MODIFY;
//    end;
//Local procedure NoOnAfterValidate();
//    begin
//      InsertExtendedText(FALSE);
//
//      if (rec."Reserve" = rec."Reserve"::Always) and
//         (rec."Outstanding Qty. (Base)" <> 0) and
//         (rec."No." <> xRec."No.")
//      then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//Local procedure LocationCodeOnAfterValidate();
//    begin
//      if (rec."Reserve" = rec."Reserve"::Always) and
//         (rec."Outstanding Qty. (Base)" <> 0) and
//         (rec."Location Code" <> xRec."Location Code")
//      then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//Local procedure QuantityOnAfterValidate();
//    begin
//      if ( rec."Type" = rec."Type"::Item  )then
//        CASE Reserve OF
//          rec."Reserve"::Always:
//            begin
//              CurrPage.SAVERECORD;
//              rec.AutoReserve;
//              CurrPage.UPDATE(FALSE);
//            end;
//          rec."Reserve"::Optional:
//            if ( (rec."Quantity" < xRec.Quantity) and (xRec.Quantity > 0)  )then begin
//              CurrPage.SAVERECORD;
//              CurrPage.UPDATE(FALSE);
//            end;
//        end;
//    end;
//Local procedure PostingDateOnAfterValidate();
//    begin
//      if (rec."Reserve" = rec."Reserve"::Always) and
//         (rec."Outstanding Qty. (Base)" <> 0) and
//         (rec."Posting Date" <> xRec."Posting Date")
//      then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//
//    [Integration]
//Local procedure OnBeforeInsertExtendedText(var ServiceLine : Record 5902);
//    begin
//    end;

//procedure
}

