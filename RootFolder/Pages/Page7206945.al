page 7206945 "QB Payment Phases Card"
{
CaptionML=ENU='Payment Phases Card',ESP='L�neas de fases de pago';
    SourceTable=7206930;
    PageType=List;
    
  layout
{
area(content)
{
    field("texto";texto)
    {
        
                Enabled=false;
                StyleExpr=TRUE ;
    }
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
                Visible=false;
                Editable=false ;
    }
    field("Line No.";rec."Line No.")
    {
        
                BlankZero=true;
                Editable=bEditable ;
    }
    field("Description";rec."Description")
    {
        
    }
    field("% Payment";rec."% Payment")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Amount";rec."Amount")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


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
    field("QB Calc Due Date";rec."QB Calc Due Date")
    {
        
    }
    field("QB No. Days Calc Due Date";rec."QB No. Days Calc Due Date")
    {
        
    }

}
group("group26")
{
        
group("group27")
{
        
                CaptionML=ESP='Total Fases';
    field("Total %";rec."Total %")
    {
        
    }
    field("Total Amount";rec."Total Amount")
    {
        
    }

}

}

}
}
  

trigger OnInit()    BEGIN
             bEditable := TRUE;
           END;

trigger OnOpenPage()    BEGIN
                 IF (Rec.FINDFIRST) THEN
                   IF (QBPaymentsPhases.GET(rec.Code)) THEN
                     texto := Txt000 +rec. Code + ' - ' + QBPaymentsPhases.Description;
               END;



    var
      QBPaymentsPhases : Record 7206929;
      texto : Text;
      bInvoice : Boolean;
      bEditable : Boolean;
      QB_Amount : Decimal;
      QB_Used : Decimal;
      Txt000 : TextConst ESP='" Fase de Pago: "';

    procedure SetOrder(pAmount : Decimal;pUsed : Decimal);
    begin
      bEditable := FALSE;
      QB_Amount := pAmount;
      QB_Used := pUsed;
    end;

    procedure SetInvoice(pAmount : Decimal;pUsed : Decimal);
    begin
      bInvoice := TRUE;
      bEditable := FALSE;
      QB_Amount := pAmount;
      QB_Used := pUsed;
    end;

    // begin//end
}








