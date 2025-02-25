pageextension 50234 MyExtension5709 extends 5709//121
{
layout
{
addafter("Buy-from Vendor No.")
{
    field("QB Have Proforms";rec."QB Have Proforms")
    {
        
}
    field("QB Posting Date";rec."QB Posting Date")
    {
        
}
    field("QB Vendor Shipment No.";rec."QB Vendor Shipment No.")
    {
        
}
} addafter("Qty. Rcd. Not Invoiced")
{
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 //JAV 01/07/19: - Se filtran los pedidos cancelados para que no aparezcan
                 Rec.FILTERGROUP(2);
                 Rec.SETRANGE("Cancelled", FALSE);
                 Rec.FILTERGROUP(0);

                 //JAV 06/06/21: - QB 1.08.48 Filtramos que no tengan relaci¢n con proformas, pero dejamos que se pueda quitar el filtro por si se ha empezado a recibir sin proformar.
                 Rec.SETRANGE("QB Have Proforms", FALSE);

                 //JAV 06/07/22: - QB 1.10.59 Se traslada el filtro de proyecto de la cabecera de la factura desde la CU 74
                 //JAV 28/06/19: - Filtrar por proyecto  de la factura
                 IF (PurchHeader."QB Job No." <> '') THEN
                  Rec.SETRANGE("Job No.", PurchHeader."QB Job No.");
               END;


//trigger

var
      PurchHeader : Record 38;
      PurchRcptHeader : Record 120;
      TempPurchRcptLine : Record 121 TEMPORARY ;
      GetReceipts : Codeunit 74;
      DocumentNoHideValue : Boolean ;

    

//procedure
//procedure SetPurchHeader(var PurchHeader2 : Record 38);
//    begin
//      PurchHeader.GET(PurchHeader2."Document Type",PurchHeader2."No.");
//      PurchHeader.TESTFIELD("Document Type",PurchHeader."Document Type"::Invoice);
//    end;
//Local procedure IsFirstDocLine() : Boolean;
//    var
//      PurchRcptLine : Record 121;
//    begin
//      TempPurchRcptLine.RESET;
//      TempPurchRcptLine.COPYFILTERS(Rec);
//      TempPurchRcptLine.SETRANGE("Document No.",rec."Document No.");
//      if ( not TempPurchRcptLine.FINDFIRST  )then begin
//        PurchRcptLine.COPYFILTERS(Rec);
//        PurchRcptLine.SETRANGE("Document No.",rec."Document No.");
//        PurchRcptLine.SETFILTER("Qty. Rcd. not Invoiced",'<>0');
//        if ( PurchRcptLine.FINDFIRST  )then begin
//          TempPurchRcptLine := PurchRcptLine;
//          TempPurchRcptLine.INSERT;
//        end;
//      end;
//      if ( rec."Line No." = TempPurchRcptLine."Line No."  )then
//        exit(TRUE);
//    end;
//Local procedure CreateLines();
//    begin
//      CurrPage.SETSELECTIONFILTER(Rec);
//      GetReceipts.SetPurchHeader(PurchHeader);
//      GetReceipts.CreateInvLines(Rec);
//    end;
//Local procedure DocumentNoOnFormat();
//    begin
//      if ( not IsFirstDocLine  )then
//        DocumentNoHideValue := TRUE;
//    end;

//procedure
}

