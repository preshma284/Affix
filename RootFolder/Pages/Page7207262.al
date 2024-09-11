page 7207262 "QB Power BI Compras Liq. Subf."
{
Editable=false;
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=25;
    PageType=List;
  layout
{
area(content)
{
repeater("table")
{
        
    field("Posting Date";rec."Posting Date")
    {
        
                ToolTipML=ENU='Specifies the vendor entrys posting date.',ESP='Especifica la fecha de registro del movimiento de proveedor.';
                ApplicationArea=Basic,Suite;
    }
    field("Document Type";rec."Document Type")
    {
        
                ToolTipML=ENU='Specifies the document type that the vendor entry belongs to.',ESP='Especifica el tipo de documento al que pertenece el movimiento de proveedor.';
                ApplicationArea=Basic,Suite;
    }
    field("Document No.";rec."Document No.")
    {
        
                ToolTipML=ENU='Specifies the vendor entrys document number.',ESP='Especifica el n�mero de documento del movimiento de proveedor.';
                ApplicationArea=Basic,Suite;
    }
    field("Description";rec."Description")
    {
        
                ToolTipML=ENU='Specifies a description of the vendor entry.',ESP='Especifica una descripci�n del movimiento del proveedor.';
                ApplicationArea=Basic,Suite;
    }
    field("External Document No.";rec."External Document No.")
    {
        
                ToolTipML=ENU='Specifies a document number that refers to the customers or vendors numbering system.',ESP='Especifica un n�mero de documento que hace referencia al sistema de numeraci�n del cliente o el proveedor.';
                ApplicationArea=Basic,Suite;
                Visible=TRUE ;
    }
    field("Global Dimension 1 Code";rec."Global Dimension 1 Code")
    {
        
                ToolTipML=ENU='Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the companys most important activities, are available on all cards, documents, reports, and lists.',ESP='Especifica el c�digo de la dimensi�n global que est� vinculada al registro o al movimiento para fines de an�lisis. Hay dos dimensiones globales, normalmente para las actividades m�s importantes de la empresa, disponibles en todas las fichas, los documentos, los informes y las listas.';
                ApplicationArea=Dimensions;
                Visible=FALSE ;
    }
    field("Global Dimension 2 Code";rec."Global Dimension 2 Code")
    {
        
                ToolTipML=ENU='Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the companys most important activities, are available on all cards, documents, reports, and lists.',ESP='Especifica el c�digo de la dimensi�n global que est� vinculada al registro o al movimiento para fines de an�lisis. Hay dos dimensiones globales, normalmente para las actividades m�s importantes de la empresa, disponibles en todas las fichas, los documentos, los informes y las listas.';
                ApplicationArea=Dimensions;
                Visible=FALSE ;
    }
    field("Purchaser Code";rec."Purchaser Code")
    {
        
                ToolTipML=ENU='Specifies which purchaser is assigned to the vendor.',ESP='Especifica el comprador asignado al proveedor.';
                ApplicationArea=Suite;
                Visible=FALSE ;
    }
    field("Currency Code";rec."Currency Code")
    {
        
                ToolTipML=ENU='Specifies the currency code for the amount on the line.',ESP='Especifica el c�digo de divisa para el importe de la l�nea.';
                ApplicationArea=Suite;
    }
    field("Original Amount";rec."Original Amount")
    {
        
                ToolTipML=ENU='Specifies the amount of the original entry.',ESP='Especifica el importe del movimiento inicial.';
                ApplicationArea=Basic,Suite;
    }
    field("Amount";rec."Amount")
    {
        
                ToolTipML=ENU='Specifies the amount of the entry.',ESP='Especifica el importe del movimiento.';
                ApplicationArea=Basic,Suite;
                Visible=AmountVisible ;
    }
    field("Debit Amount";rec."Debit Amount")
    {
        
                ToolTipML=ENU='Specifies the total of the ledger entries that represent debits.',ESP='Especifica el total de movimientos contables que representan d�bitos.';
                ApplicationArea=Basic,Suite;
                Visible=DebitCreditVisible ;
    }
    field("Credit Amount";rec."Credit Amount")
    {
        
                ToolTipML=ENU='Specifies the total of the ledger entries that represent credits.',ESP='Especifica el total de movimientos contables que representan cr�ditos.';
                ApplicationArea=Basic,Suite;
                Visible=DebitCreditVisible ;
    }
    field("Closed by Amount";rec."Closed by Amount")
    {
        
                ToolTipML=ENU='Specifies the amount that the entry was finally applied to (closed) with.',ESP='Especifica el importe con el que se liquid� (se cerr�) finalmente el movimiento.';
                ApplicationArea=Basic,Suite;
    }
    field("Closed by Currency Code";rec."Closed by Currency Code")
    {
        
                ToolTipML=ENU='Specifies the currency code of the entry that was applied to (and closed) this vendor ledger entry.',ESP='Especifica el c�digo de divisa del movimiento con el que se liquid� (y cerr�) este movimiento de proveedor.';
                ApplicationArea=Suite;
    }
    field("Closed by Currency Amount";rec."Closed by Currency Amount")
    {
        
                ToolTipML=ENU='Specifies the amount that was finally applied to (and closed) this vendor ledger entry.',ESP='Especifica el importe con el que finalmente se liquid� (y cerr�) a este movimiento de proveedor.';
                ApplicationArea=Suite;
                AutoFormatType=1;
                AutoFormatExpression=rec."Closed by Currency Code" ;
    }
    field("User ID";rec."User ID")
    {
        
                ToolTipML=ENU='Specifies the ID of the user who posted the entry, to be used, for example, in the change log.',ESP='Especifica el identificador del usuario que registr� el movimiento, que se usar�, por ejemplo, en el registro de cambios.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE ;
    }
    field("Source Code";rec."Source Code")
    {
        
                ToolTipML=ENU='Specifies the source code that specifies where the entry was created.',ESP='Especifica el c�digo de origen que indica d�nde se cre� el movimiento.';
                ApplicationArea=Suite;
                Visible=FALSE ;
    }
    field("Reason Code";rec."Reason Code")
    {
        
                ToolTipML=ENU='Specifies the reason code, a supplementary source code that enables you to trace the entry.',ESP='Especifica el c�digo de auditor�a, un c�digo de origen adicional que le permite realizar un seguimiento del movimiento.';
                ApplicationArea=Suite;
                Visible=FALSE ;
    }
    field("Entry No.";rec."Entry No.")
    {
        
                ToolTipML=ENU='Specifies the number of the entry, as assigned from the specified number series when the entry was created.',ESP='Especifica el n�mero del movimiento, tal como se asign� desde la serie num�rica especificada cuando se cre� el movimiento.';
                ApplicationArea=Basic,Suite;
    }
    field("Remaining Amount";rec."Remaining Amount")
    {
        
    }

}

}
}
  
    var
      CreateVendLedgEntry : Record 25;
      AmountVisible : Boolean;
      DebitCreditVisible : Boolean;
      Navigate : Page 344;
      Heading : Text[50];
      Text000 : TextConst ENU='Document',ESP='Documento';

    procedure SetAppliedVendLedgEntryNo();
    begin
      Rec.RESET;
      SetConrolVisibility;

      if rec."Entry No." <> 0 then begin
        CreateVendLedgEntry := Rec;
        if CreateVendLedgEntry."Document Type" = Enum::"Purchase Document Type".FromInteger(0)  then
          Heading := Text000
        ELSE
          Heading := FORMAT(CreateVendLedgEntry."Document Type");
        Heading := Heading + ' ' + CreateVendLedgEntry."Document No.";

        FindApplnEntriesDtldtLedgEntry;
        Rec.SETCURRENTKEY("Entry No.");
        Rec.SETRANGE("Entry No.");

        if CreateVendLedgEntry."Closed by Entry No." <> 0 then begin
          rec."Entry No." := CreateVendLedgEntry."Closed by Entry No.";
          Rec.MARK(TRUE);
        end;

        Rec.SETCURRENTKEY("Closed by Entry No.");
        Rec.SETRANGE("Closed by Entry No.",CreateVendLedgEntry."Entry No.");
        if Rec.FIND('-') then
          repeat
            Rec.MARK(TRUE);
          until Rec.NEXT = 0;

        Rec.SETCURRENTKEY("Entry No.");
        Rec.SETRANGE("Closed by Entry No.");
      end;

      Rec.MARKEDONLY(TRUE);

      CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure FindApplnEntriesDtldtLedgEntry();
    var
      DtldVendLedgEntry1 : Record 380;
      DtldVendLedgEntry2 : Record 380;
    begin
      DtldVendLedgEntry1.SETCURRENTKEY("Vendor Ledger Entry No.");
      DtldVendLedgEntry1.SETRANGE("Vendor Ledger Entry No.",CreateVendLedgEntry."Entry No.");
      DtldVendLedgEntry1.SETRANGE(Unapplied,FALSE);
      if DtldVendLedgEntry1.FIND('-') then
        repeat
          if DtldVendLedgEntry1."Vendor Ledger Entry No." =
             DtldVendLedgEntry1."Applied Vend. Ledger Entry No."
          then begin
            DtldVendLedgEntry2.INIT;
            DtldVendLedgEntry2.SETCURRENTKEY("Applied Vend. Ledger Entry No.","Entry Type");
            DtldVendLedgEntry2.SETRANGE(
              "Applied Vend. Ledger Entry No.",DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
            DtldVendLedgEntry2.SETRANGE("Entry Type",DtldVendLedgEntry2."Entry Type"::Application);
            DtldVendLedgEntry2.SETRANGE(Unapplied,FALSE);
            if DtldVendLedgEntry2.FIND('-') then
              repeat
                if DtldVendLedgEntry2."Vendor Ledger Entry No." <>
                   DtldVendLedgEntry2."Applied Vend. Ledger Entry No."
                then begin
                  Rec.SETCURRENTKEY("Entry No.");
                  Rec.SETRANGE("Entry No.",DtldVendLedgEntry2."Vendor Ledger Entry No.");
                  if Rec.FIND('-') then
                    Rec.MARK(TRUE);
                end;
              until DtldVendLedgEntry2.NEXT = 0;
          end ELSE begin
            Rec.SETCURRENTKEY("Entry No.");
            Rec.SETRANGE("Entry No.",DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
            if Rec.FIND('-') then
              Rec.MARK(TRUE);
          end;
        until DtldVendLedgEntry1.NEXT = 0;
    end;

    LOCAL procedure SetConrolVisibility();
    var
      GLSetup : Record 98;
    begin
      GLSetup.GET;
      AmountVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
      DebitCreditVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
    end;

    // begin//end
}







