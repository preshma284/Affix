table 7206975 "QB Ceded"
{
  
  
    CaptionML=ENU='Ceded',ESP='Prestados';
    LookupPageID="QB Ceded List";
    DrillDownPageID="QB Ceded List";
  
  fields
{
    field(1;"Entry No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Entry No.',ESP='N§ mov.';


    }
    field(2;"Item Entry No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Item Entry No.',ESP='No. mov. producto';


    }
    field(3;"Item No.";Code[20])
    {
        TableRelation="Item";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Item No.',ESP='N§ producto';


    }
    field(4;"Posting Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Posting Date',ESP='Fecha registro';


    }
    field(5;"Entry Type";Option)
    {
        OptionMembers=" ","Input","Output";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Entry Type',ESP='Tipo movimiento';
                                                   OptionCaptionML=ENU='" ,Input,Output"',ESP='" ,Entrada,Salida"';
                                                   


    }
    field(6;"Document No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document No.',ESP='N§ documento';


    }
    field(7;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(8;"Origin Location";Code[20])
    {
        TableRelation="Location";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Origin Location',ESP='Almac‚n origen';


    }
    field(9;"Destination Location";Code[20])
    {
        TableRelation="Location";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Destination Location',ESP='Almac‚n destino';


    }
    field(10;"Quantity";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Quantity',ESP='Cantidad';
                                                   DecimalPlaces=0:5;


    }
    field(11;"Remaining Quantity";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Ceded Entry"."Quantity" WHERE ("Ceded Entry No."=FIELD("Entry No.")));
                                                   CaptionML=ENU='Remaining Quantity',ESP='Cantidad pendiente';
                                                   DecimalPlaces=0:5;


    }
    field(12;"Open";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Open',ESP='Pendiente';


    }
    field(13;"Document Type";Option)
    {
        OptionMembers=" ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document Type',ESP='Tipo documento';
                                                   OptionCaptionML=ENU='" ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly"',ESP='" ,Albar n venta,Factura venta,Recep. devol. ventas,Abono venta,Albar n compra,Factura compra,Env¡o devoluci¢n compra,Abono compra,Env¡o transfer.,Recep. transfer.,Servicio regis.,Factura ventas,Abono ventas,Ensamblado registrado"';
                                                   


    }
    field(14;"User";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User',ESP='Usuario';


    }
    field(15;"Created Datetime";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Hora creaci¢n';


    }
    field(16;"Remaining Quantity.";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Remaining Quantity.',ESP='Cdad. pendiente.'; ;


    }
}
  keys
{
    key(key1;"Entry No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    // procedure FillData (var ItemLedgerEntry@1100286000 : Record 32;EntryType@1100286003 : Option;NewLocation@1100286005 : Code[20];Qty@1100286004 : Decimal;var CededNo@1100286001 :
procedure FillData (var ItemLedgerEntry: Record 32;EntryType: Option;NewLocation: Code[20];Qty: Decimal;var CededNo: Integer)
    var
//       Ceded@1100286002 :
      Ceded: Record 7206975;
//       rItem@1100286006 :
      rItem: Record 27;
    begin
        CededNo := 1;
        Ceded.RESET;
        if Ceded.FINDLAST then
          CededNo := Ceded."Entry No." +1;

        INIT;
        VALIDATE("Entry No.",CededNo);
        VALIDATE("Item Entry No.",ItemLedgerEntry."Entry No.");
        VALIDATE("Item No.",ItemLedgerEntry."Item No.");
        VALIDATE("Posting Date",ItemLedgerEntry."Posting Date");
        VALIDATE("Entry Type",EntryType);
        VALIDATE("Document No.",ItemLedgerEntry."Document No.");
        if ItemLedgerEntry.Description = '' then begin
          rItem.GET(ItemLedgerEntry."Item No.");
          Description := rItem.Description;
        end else
          VALIDATE(Description,ItemLedgerEntry.Description);
        VALIDATE("Origin Location",NewLocation);
        if NewLocation <> '' then
          VALIDATE("Destination Location",ItemLedgerEntry."Location Code");
        VALIDATE(Quantity,Qty);
        "Remaining Quantity." := Quantity;
        Open := TRUE;
        VALIDATE("Document Type",ItemLedgerEntry."Document Type");
        User := USERID;
        "Created Datetime" := CURRENTDATETIME;
        INSERT(TRUE);
    end;

    /*begin
    end.
  */
}







