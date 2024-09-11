Codeunit 7207339 "RecpJob-Post Receipt"
{
  
  
    TableNo=7207411;
    trigger OnRun()
BEGIN
            LineReceptionJob.COPY(Rec);
            Code;
            Rec := LineReceptionJob;
          END;
    VAR
      LineReceptionJob : Record 7207411;
      Text001 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';
      HeaderJobReception : Record 7207410;
      PurchaseLine : Record 39;
      PurchaseHeader : Record 38;
      Text004 : TextConst ESP='Los siguientes pedidos han quedado sin recepcionar por problemas. Reviselos:';

    LOCAL PROCEDURE Code();
    BEGIN
      WITH LineReceptionJob DO BEGIN
        SETCURRENTKEY("Recept. Document No.");
        SETRANGE("Recept. Document No.","Recept. Document No.");
        SETFILTER("Qty. to Receive",'>0');
        IF NOT FINDFIRST THEN
          ERROR(Text001);

        HeaderJobReception.GET(LineReceptionJob."Recept. Document No.");
        HeaderJobReception.TESTFIELD("Posting Date");
        HeaderJobReception.TESTFIELD("Vendor Shipment No.");

        SETRANGE("Qty. to Receive");
        FINDSET;
        REPEAT
          IF PurchaseLine.GET(PurchaseLine."Document Type"::Order,LineReceptionJob."Document No.",
                    LineReceptionJob."Document Line No.") THEN BEGIN
            IF LineReceptionJob."Qty. to Receive" <> 0 THEN BEGIN
              PurchaseLine.VALIDATE("Qty. to Receive",LineReceptionJob."Qty. to Receive");
              PurchaseLine.MODIFY;
              IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Order,LineReceptionJob."Document No.") THEN BEGIN
                PurchaseHeader."Posting Date":=HeaderJobReception."Posting Date";
                PurchaseHeader."Vendor Shipment No.":=HeaderJobReception."Vendor Shipment No.";
                PurchaseHeader.Receive:=TRUE;
                PurchaseHeader.Invoice:=FALSE;
                PurchaseHeader.MODIFY;
              END;
            END ELSE BEGIN
              PurchaseLine.VALIDATE("Qty. to Receive",0);
              PurchaseLine.MODIFY;
            END;
          END;
        UNTIL NEXT = 0;
        COMMIT;
        PostingOrders;

      //paso a hist�rico
        HeaderJobReception.Posted:= TRUE;
        HeaderJobReception.MODIFY;
      END;
    END;

    PROCEDURE PostingOrders();
    VAR
      LPurchaseHeader : Record 38;
      LPurchPost : Codeunit 90;
      LLineReceptionJob : Record 7207411;
      LOrdersIncorrect : Text[1024];
    BEGIN
      LOrdersIncorrect := '';
      LPurchaseHeader.SETRANGE("Document Type",LPurchaseHeader."Document Type"::Order);
      LPurchaseHeader.SETRANGE(Status,LPurchaseHeader.Status::Released);
      LPurchaseHeader.SETRANGE("Vendor Shipment No.",HeaderJobReception."Vendor Shipment No.");
      LPurchaseHeader.SETRANGE("Buy-from Vendor No.",HeaderJobReception."Vendor No.");
      LPurchaseHeader.SETRANGE("QB Job No.",HeaderJobReception."Job No.");
      LPurchaseHeader.SETRANGE(Receive,TRUE);
      IF LPurchaseHeader.FINDSET THEN
        REPEAT
          LLineReceptionJob.SETRANGE("Recept. Document No.",HeaderJobReception."No.");
          LLineReceptionJob.SETRANGE("Document No.",LPurchaseHeader."No.");
          IF LLineReceptionJob.FINDSET THEN BEGIN
            CLEAR(LPurchPost);
            IF LPurchPost.RUN(LPurchaseHeader) THEN BEGIN
            END ELSE BEGIN
              IF LOrdersIncorrect = '' THEN
                LOrdersIncorrect := LPurchaseHeader."No."
              ELSE
                LOrdersIncorrect := LOrdersIncorrect + ',' + LPurchaseHeader."No.";
            END;
          END;
        UNTIL LPurchaseHeader.NEXT=0;

      LLineReceptionJob.RESET;
      LLineReceptionJob.SETRANGE("Recept. Document No.",HeaderJobReception."No.");
      LLineReceptionJob.SETRANGE("Document No.");
      IF LLineReceptionJob.FINDSET THEN
        REPEAT
          IF STRPOS(LOrdersIncorrect,LLineReceptionJob."Document No.") <> 0 THEN BEGIN
            LLineReceptionJob.Status := LLineReceptionJob.Status::"Wrong Record";
            LLineReceptionJob.MODIFY;
          END ELSE BEGIN
            IF LLineReceptionJob."Document No." <> '' THEN BEGIN
              LLineReceptionJob."Quantity Received" := LLineReceptionJob."Quantity Received" + LLineReceptionJob."Qty. to Receive";
              LLineReceptionJob."Outstanding Quantity" := LLineReceptionJob.Quantity - LLineReceptionJob."Quantity Received";
              LLineReceptionJob."Qty. to Receive" := 0;
              LLineReceptionJob."Qty.Received (Base)" := LLineReceptionJob."Qty.Received (Base)" +
                                                           LLineReceptionJob."Qty. to Receive (Base)";
              LLineReceptionJob."Outstanding QTy. (Base)" := LLineReceptionJob."Quantity (Base)" -
                                                              LLineReceptionJob."Qty.Received (Base)";
              LLineReceptionJob."Qty. to Receive (Base)" := 0;
              LLineReceptionJob.Status := LLineReceptionJob.Status::Registered;
              LLineReceptionJob.MODIFY;
            END;
          END;
        UNTIL LLineReceptionJob.NEXT = 0;

      IF LOrdersIncorrect <> '' THEN
        MESSAGE(Text004 + ' ' + LOrdersIncorrect);
    END;

    /* /*BEGIN
END.*/
}







