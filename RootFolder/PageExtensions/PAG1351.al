pageextension 50127 MyExtension1351 extends 1351//122
{
layout
{
addfirst("Invoice Details")
{
group("Control1100286005")
{
        
                CaptionML=ENU='Invoice Details',ESP='Datos Generales';
}
} addafter("Creditor No.")
{
    field("QB_OnHold";rec."On Hold")
    {
        
}
    field("QB Payment Bank No.";rec."QB Payment Bank No.")
    {
        
}
} addafter("ID Type")
{
    field("QB_DoNotSendToSII";rec."Do not send to SII")
    {
        
                Visible=verSII ;
}
} addafter("Succeeded VAT Registration No.")
{
    field("QUOSII_DoNotSendToSII";rec."Do not send to SII")
    {
        
                Visible=verQuoSII ;
}
    field("QUOSII_AutoPostingDate";rec."QuoSII Auto Posting Date")
    {
        
                Visible=verQuoSII ;
}
}


//modify("Payment Reference")
//{
//
//
//}
//

//modify("Creditor No.")
//{
//
//
//}
//

modify("Special Scheme Code")
{
Visible=verSII;


}


modify("Invoice Type")
{
Visible=verSII;


}


modify("ID Type")
{
Visible=verSII;


}


modify("Succeeded Company Name")
{
Visible=verSII;


}


modify("Succeeded VAT Registration No.")
{
Visible=verSII;


}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 xPurchInvHeader := Rec;

                 //QB
                 verSII := FunctionQB.AccessToSII;
                 verQuoSII := FunctionQB.AccessToQuoSII;
               END;
trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                         IF RecordChanged THEN
                           CODEUNIT.RUN(CODEUNIT::"Purch. Inv. Header - Edit",Rec);

                       //JAV 06/07/22: - QB 1.10.59 Se cambia la forma de manejo de los campos propios para no usar cambios en la CU est ndar
                       IF (CloseAction = ACTION::LookupOK) THEN
                         OnBeforeChangeDocument(Rec);
                     END;


//trigger

var
      xPurchInvHeader : Record 122;
      "------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      verSII : Boolean;
      verQuoSII : Boolean;

    
    

//procedure
Local procedure RecordChanged() : Boolean;
   begin
     exit(
       (rec."Payment Reference" <> xPurchInvHeader."Payment Reference") or
       (rec."Creditor No." <> xPurchInvHeader."Creditor No.") or
       (rec."Ship-to Code" <> xPurchInvHeader."Ship-to Code") or
       (rec."Special Scheme Code" <> xPurchInvHeader."Special Scheme Code") or
       (rec."Invoice Type" <> xPurchInvHeader."Invoice Type") or
       (rec."ID Type" <> xPurchInvHeader."ID Type") or
       (rec."Succeeded Company Name" <> xPurchInvHeader."Succeeded Company Name") or
       (rec."Succeeded VAT Registration No." <> xPurchInvHeader."Succeeded VAT Registration No."));
   end;
//procedure SetRec(PurchInvHeader : Record 122);
//    begin
//      Rec := PurchInvHeader;
//      Rec.INSERT;
//    end;
LOCAL procedure "-------------------------- QB"();
    begin
    end;

    //[Business]
procedure OnBeforeChangeDocument(Rec : Record 122);
    begin
    end;

//procedure
}

