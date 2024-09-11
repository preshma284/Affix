page 7206946 "QB Payment Phases Document"
{
CaptionML=ENU='Payment Phases Card',ESP='L�neas de fases de pago';
    SourceTable=7206932;
    SourceTableView=SORTING("Document Type","Document No.","Line No.");
    PageType=List;
    
  layout
{
area(content)
{
    field("texto";texto)
    {
        
                Enabled=false;
                Style=Strong;
                StyleExpr=TRUE ;
    }
repeater("Group")
{
        
    field("Line No.";rec."Line No.")
    {
        
                Visible=false;
                Editable=false;
                Style=Strong;
                StyleExpr=stHeader ;
    }
    field("Description";rec."Description")
    {
        
    }
    field("% Payment";rec."% Payment")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
                Editable=edAmount ;
    }
    field("Used";rec."Used")
    {
        
    }
    field("Document Date";rec."Document Date")
    {
        
    }
    field("Cald Date";rec."Cald Date")
    {
        
    }
    field("Date Formula";rec."Date Formula")
    {
        
    }
    field("Calculated Date";rec."Calculated Date")
    {
        
    }
    field("Payment Terms Code";rec."Payment Terms Code")
    {
        
    }
    field("Payment Method Code";rec."Payment Method Code")
    {
        
    }
    field("Calc Due Date";rec."Calc Due Date")
    {
        
    }
    field("No. Days Calc Due Date";rec."No. Days Calc Due Date")
    {
        
    }

}
group("group46")
{
        
group("group47")
{
        
                CaptionML=ESP='Suma L�neas';
    field("Total %";rec."Total %")
    {
        
                StyleExpr=stPorc ;
    }
    field("Total Amount";rec."Total Amount")
    {
        
                StyleExpr=stTotal ;
    }

}
group("group50")
{
        
                CaptionML=ESP='Total Pedido';
    field("Document Amount";rec."Document Amount")
    {
        
                CaptionML=ESP='Importe';
                Enabled=false ;
    }
    field("QB_Used";QB_Used)
    {
        
                CaptionML=ESP='Usado';
                Visible=not bInvoice;
                Enabled=false ;
    }
    field("QB_Register";QB_Register)
    {
        
                CaptionML=ESP='A Registrar';
                Visible=not bInvoice;
                Enabled=false ;
    }
    field("QB_Amount - QB_Used - QB_Register";QB_Amount - QB_Used - QB_Register)
    {
        
                CaptionML=ESP='Pendiente';
                Visible=not bInvoice 

  ;
    }

}

}

}
}
  trigger OnOpenPage()    BEGIN
                 texto := Txt000;

                 IF (Rec.FINDFIRST) THEN
                   IF (PurchaseHeader.GET(rec."Document Type", rec."Document No.")) THEN
                     IF (QBPaymentsPhases.GET(PurchaseHeader."QB Payment Phases")) THEN
                       texto := Txt000 + QBPaymentsPhases.Code + ' - ' + QBPaymentsPhases.Description;

                 //Posicionarse en el primero sin usar
                 QBPaymentsPhasesDoc.RESET;
                 QBPaymentsPhasesDoc.SETRANGE("Document Type", rec."Document Type");
                 QBPaymentsPhasesDoc.SETRANGE("Document No.", rec."Document No.");
                 QBPaymentsPhasesDoc.SETRANGE(Used, FALSE);
                 IF (NOT QBPaymentsPhasesDoc.FINDFIRST) THEN BEGIN
                   QBPaymentsPhasesDoc.SETRANGE(Used);
                   QBPaymentsPhasesDoc.FINDLAST;
                 END;
                 Rec.GET(QBPaymentsPhasesDoc."Document Type",QBPaymentsPhasesDoc."Document No.",QBPaymentsPhasesDoc."Line No.");
               END;

trigger OnAfterGetRecord()    BEGIN
                       SetPage;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           SetPage;
                         END;



    var
      QBPaymentsPhases : Record 7206929;
      QBPaymentsPhasesDoc : Record 7206932;
      PurchaseHeader : Record 38;
      stHeader : Text;
      stTotal : Text;
      stPorc : Text;
      texto : Text;
      bInvoice : Boolean;
      QB_Amount : Decimal;
      QB_Used : Decimal;
      QB_Register : Decimal;
      Txt000 : TextConst ESP='" Fase de Pago: "';
      edAmount : Boolean;

    procedure SetOrder(pAmount : Decimal;pUsed : Decimal;pReg : Decimal);
    begin
      QB_Amount := pAmount;
      QB_Used := pUsed;
      QB_Register := pReg;
    end;

    procedure SetInvoice(pAmount : Decimal;pUsed : Decimal;pReg : Decimal);
    begin
      bInvoice := TRUE;
      QB_Amount := pAmount;
      QB_Used := pUsed;
      QB_Register := pReg;
    end;

    LOCAL procedure SetPage();
    begin
      Rec.CALCFIELDS("Total %", "Total Amount");

      if (rec.Used) then
        stHeader := 'Bold'
      ELSE
        stHeader := 'Standar';

      if (rec."Total Amount" <> rec."Document Amount") then
        stTotal := 'Attention'
      ELSE
        stTotal := 'Standard';

      if (rec."Total %" <> 100) then
        stPorc := 'Attention'
      ELSE
        stPorc := 'Standard';

      edAmount := (rec."% Payment" = 0);
    end;

    // begin//end
}








