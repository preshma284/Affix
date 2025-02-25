pageextension 50109 MyExtension10767 extends 10767//124
{
layout
{
addafter("Posting Date")
{
    field("QB Payment Bank No.";rec."QB Payment Bank No.")
    {
        
}
} addafter("Correction Type")
{
    field("Do not send to SII";rec."Do not send to SII")
    {
        
                Visible=seeSII 

  ;
}
}


modify("Invoice Details")
{
Visible=seeSII;


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
                 xPurchCrMemoHdr := Rec;

                 //QB
                 seeMSSII := FunctionQB.AccessToSII;
                 seeQuoSII := FunctionQB.AccessToQuoSII;
                 seeSII := seeMSSII OR seeQuoSII;
               END;
trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                         IF RecordChanged THEN
                           CODEUNIT.RUN(CODEUNIT::"Purch. Cr. Memo Hdr. - Edit",Rec);

                       //JAV 06/07/22: - QB 1.10.59 Se cambia la forma de manejo de los campos propios para no usar cambios en la CU est ndar
                       IF (CloseAction = ACTION::LookupOK) THEN
                         OnBeforeChangeDocument(Rec);
                     END;


//trigger

var
      xPurchCrMemoHdr : Record 124;
      "------------------------------------ QB" : Integer;
      FunctionQB : Codeunit 7207272;
      seeMSSII : Boolean;
      seeQuoSII : Boolean;
      seeSII : Boolean;

    
    

//procedure
Local procedure RecordChanged() : Boolean;
   begin
     exit(
       (rec."Special Scheme Code" <> xPurchCrMemoHdr."Special Scheme Code") or
       (rec."Cr. Memo Type" <> xPurchCrMemoHdr."Cr. Memo Type") or
       (rec."Correction Type" <> xPurchCrMemoHdr."Correction Type"));
   end;
//procedure SetRec(PurchCrMemoHdr : Record 124);
//    begin
//      Rec := PurchCrMemoHdr;
//      Rec.INSERT;
//    end;
LOCAL procedure "-------------------------- QB"();
    begin
    end;

    //[Business]
procedure OnBeforeChangeDocument(Rec : Record 124);
    begin
    end;

//procedure
}

