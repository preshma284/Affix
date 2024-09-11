page 7206970 "QB Liquidate Vendor Subform"
{
CaptionML=ENU='Vendor Pending Movs',ESP='Movimientos pendientes del Proveedor';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=25;
    PageType=ListPart;
    SourceTableTemporary=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("QB To Liquidate";rec."QB To Liquidate")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             IF (rec."QB To Liquidate" <> xRec."QB To Liquidate")  THEN BEGIN
                               Rec.CALCFIELDS("Remaining Amount");
                               IF (rec."QB To Liquidate") THEN
                                 TotalLiquidate += Rec."Remaining Amount"
                               ELSE
                                 TotalLiquidate -= Rec."Remaining Amount";

                               CurrPage.UPDATE;
                             END;
                           END;


    }
    field("Vendor No.";rec."Vendor No.")
    {
        
                ToolTipML=ENU='Specifies the customer account number that the entry is linked to.',ESP='Especifica el n�mero de la cuenta de cliente a la que est� vinculado el movimiento.';
                ApplicationArea=Basic,Suite;
                Editable=FALSE ;
    }
    field("Posting Date";rec."Posting Date")
    {
        
                ToolTipML=ENU='Specifies the customer entrys posting date.',ESP='Especifica la fecha de registro del movimiento del cliente.';
                ApplicationArea=Basic,Suite;
                Editable=FALSE ;
    }
    field("Document Type";rec."Document Type")
    {
        
                ToolTipML=ENU='Specifies the document type that the customer entry belongs to.',ESP='Especifica el tipo de documento al que pertenece el movimiento del cliente.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Document No.";rec."Document No.")
    {
        
                ToolTipML=ENU='Specifies the entrys document number.',ESP='Especifica el n�mero de documento del movimiento.';
                ApplicationArea=Basic,Suite;
                Editable=FALSE ;
    }
    field("Bill No.";rec."Bill No.")
    {
        
                ToolTipML=ENU='Specifies the bill number related to the customer entry.',ESP='Especifica el n�mero de efecto asociado a este movimiento de cliente.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("On Hold";rec."On Hold")
    {
        
                ToolTipML=ENU='Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.',ESP='Especifica que el movimiento relacionado representa una factura impagada para la que existe una sugerencia de pago, un recordatorio o un documento de inter�s.';
                ApplicationArea=Basic,Suite;
                Editable=FALSE ;
    }
    field("Document Status";rec."Document Status")
    {
        
                ToolTipML=ENU='Specifies the status of the document.',ESP='Especifica el estado del documento.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Description";rec."Description")
    {
        
                ToolTipML=ENU='Specifies a description of the customer entry.',ESP='Especifica una descripci�n del movimiento del cliente.';
                ApplicationArea=Basic,Suite;
                Editable=FALSE ;
    }
    field("Currency Code";rec."Currency Code")
    {
        
                ToolTipML=ENU='Specifies the currency code for the amount on the line.',ESP='Especifica el c�digo de divisa para el importe de la l�nea.';
                ApplicationArea=Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Amount";rec."Amount")
    {
        
                ToolTipML=ENU='Specifies the amount of the entry.',ESP='Especifica el importe del movimiento.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Amount (LCY)";rec."Amount (LCY)")
    {
        
                ToolTipML=ENU='Specifies the amount of the entry in LCY.',ESP='Especifica el importe del movimiento en DL.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Remaining Amount";rec."Remaining Amount")
    {
        
                ToolTipML=ENU='Specifies the amount that remains to be applied to before the entry has been completely applied.',ESP='Especifica el importe pendiente de liquidar antes de que se liquide todo el movimiento.';
                ApplicationArea=Basic,Suite;
                Editable=FALSE ;
    }
    field("Remaining Amt. (LCY)";rec."Remaining Amt. (LCY)")
    {
        
                ToolTipML=ENU='Specifies the amount that remains to be applied to before the entry is totally applied to.',ESP='Especifica el importe pendiente de liquidar antes de que se liquide todo el movimiento.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Bal. Account Type";rec."Bal. Account Type")
    {
        
                ToolTipML=ENU='Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.',ESP='"Especifica el tipo de cuenta en el que se registra un movimiento. por ejemplo BANCO para una cuenta de caja."';
                ApplicationArea=Basic,Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Bal. Account No.";rec."Bal. Account No.")
    {
        
                ToolTipML=ENU='Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.',ESP='Especifica el n�mero de la cuenta de contabilidad, cliente, proveedor o banco en la que se registra un movimiento de saldo, como una cuenta de caja para compras en efectivo.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Due Date";rec."Due Date")
    {
        
                ToolTipML=ENU='Specifies the due date on the entry.',ESP='Especifica la fecha de vencimiento del movimiento.';
                ApplicationArea=Basic,Suite;
                Editable=FALSE ;
    }
    field("Payment Method Code";rec."Payment Method Code")
    {
        
                ToolTipML=ENU='Specifies how to make payment, such as with bank transfer, cash, or check.',ESP='Especifica c�mo realizar el pago, por ejemplo transferencia bancaria, en efectivo o con cheque.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("User ID";rec."User ID")
    {
        
                ToolTipML=ENU='Specifies the ID of the user who posted the entry, to be used, for example, in the change log.',ESP='Especifica el identificador del usuario que registr� el movimiento, que se usar�, por ejemplo, en el registro de cambios.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Source Code";rec."Source Code")
    {
        
                ToolTipML=ENU='Specifies the source code that specifies where the entry was created.',ESP='Especifica el c�digo de origen que indica d�nde se cre� el movimiento.';
                ApplicationArea=Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Reason Code";rec."Reason Code")
    {
        
                ToolTipML=ENU='Specifies the reason code, a supplementary source code that enables you to trace the entry.',ESP='Especifica el c�digo de auditor�a, un c�digo de origen adicional que le permite realizar un seguimiento del movimiento.';
                ApplicationArea=Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("QB Job No.";rec."QB Job No.")
    {
        
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Entry No.";rec."Entry No.")
    {
        
                ToolTipML=ENU='Specifies the number of the entry, as assigned from the specified number series when the entry was created.',ESP='Especifica el n�mero del movimiento, tal como se asign� desde la serie num�rica especificada cuando se cre� el movimiento.';
                ApplicationArea=Basic,Suite;
                Visible=false;
                Editable=FALSE ;
    }

}
group("group122")
{
        
                CaptionML=ESP='Totales';
    field("TotalToLiquidate";TotalAmount)
    {
        
                CaptionML=ENU='Amount to Liquidate',ESP='Total movimientos';
                Editable=false ;
    }
    field("TotalLiquidate";TotalLiquidate)
    {
        
                CaptionML=ESP='Importe a liquidar';
                Editable=false 

  ;
    }

}

}
}
  
    var
      QBLiquidateMovs : Page 7206968;
      Third : Code[20];
      Currency : Code[20];
      Vendor : Record 23;
      VendorLedgerEntry : Record 25;
      TotalAmount : Decimal;
      TotalLiquidate : Decimal;

    procedure SetThird(pThird : Code[20];pCurrency : Code[20]);
    begin
      Third := pThird;
      Currency := pCurrency;

      TotalAmount := 0;
      TotalLiquidate := 0;
      Rec.DELETEALL;

      Vendor.RESET;
      Vendor.SETRANGE("QB Third No.", Third);
      if (Vendor.FINDSET(FALSE)) then
        repeat
          VendorLedgerEntry.RESET;
          VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
          VendorLedgerEntry.SETRANGE(Open, TRUE);
          VendorLedgerEntry.SETRANGE("Document Situation", VendorLedgerEntry."Document Situation"::" ");
          VendorLedgerEntry.SETFILTER("Currency Code",'=%1', Currency);
          if (VendorLedgerEntry.FINDSET(FALSE)) then
            repeat
              Rec := VendorLedgerEntry;
              Rec.INSERT;
              VendorLedgerEntry.CALCFIELDS("Remaining Amount");
              TotalAmount += VendorLedgerEntry."Remaining Amount";
            until (VendorLedgerEntry.NEXT = 0);
        until (Vendor.NEXT = 0);

      Rec.RESET;
      if not Rec.FINDFIRST then ;
    end;

    procedure GetAmount() : Decimal;
    begin
      exit(rec."Amount to Apply");
    end;

    // begin//end
}








