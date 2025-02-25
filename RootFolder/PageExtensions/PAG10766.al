pageextension 50108 MyExtension10766 extends 10766//114
{
layout
{
addfirst("Invoice Details")
{
group("Control1100286006")
{
        
                CaptionML=ESP='General';
    field("External Document No.";rec."External Document No.")
    {
        
}
    field("QB_PaymentBankNo";rec."Payment bank No.")
    {
        
}
}
group("Control1100286007")
{
        
                CaptionML=ESP='SII';
                Visible=seeSII;
}
} addafter("Correction Type")
{
    field("Do not send to SII";rec."Do not send to SII")
    {
        
                Visible=seeSII ;
}
}


modify("Special Scheme Code")
{
Visible=seeMSSII;


}


modify("Cr. Memo Type")
{
Visible=seeMSSII;


}


modify("Correction Type")
{
Visible=seeMSSII;


}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 xSalesCrMemoHeader := Rec;

                 //QB
                 seeQFA := FunctionQB.AccessToFacturae;
                 seeMSSII := FunctionQB.AccessToSII;
                 seeQuoSII := FunctionQB.AccessToQuoSII;
                 seeSII := seeMSSII OR seeQuoSII;
               END;
trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                         IF RecordChanged THEN
                           CODEUNIT.RUN(CODEUNIT::"Sales Cr.Memo Header - Edit",Rec);

                       //JAV 06/07/22: - QB 1.10.59 Se cambia la forma de manejo de los campos propios para no usar cambios en la CU est ndar
                       IF (CloseAction = ACTION::LookupOK) THEN
                         OnBeforeChangeDocument(Rec);
                     END;


//trigger

var
      xSalesCrMemoHeader : Record 114;
      "---------------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      seeQFA : Boolean;
      seeMSSII : Boolean;
      seeQuoSII : Boolean;
      seeSII : Boolean;

    
    

//procedure
Local procedure RecordChanged() : Boolean;
   begin
     exit(
       (rec."Special Scheme Code" <> xSalesCrMemoHeader."Special Scheme Code") or
       (rec."Cr. Memo Type" <> xSalesCrMemoHeader."Cr. Memo Type") or
       (rec."Correction Type" <> xSalesCrMemoHeader."Correction Type"));
   end;
//procedure SetRec(SalesCrMemoHeader : Record 114);
//    begin
//      Rec := SalesCrMemoHeader;
//      Rec.INSERT;
//    end;
LOCAL procedure "-------------------------- QB"();
    begin
    end;

    //[Business]
procedure OnBeforeChangeDocument(Rec : Record 114);
    begin
    end;

//procedure
}

