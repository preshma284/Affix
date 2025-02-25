pageextension 50128 MyExtension136 extends 136//120
{
layout
{
addafter("Buy-from Vendor No.")
{
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("QB_JobDescription";"JobDescription")
    {
        
                CaptionML=ENU='Job Description',ESP='Descripci¢n Proyecto';
                Editable=FALSE ;
}
    field("QB Budget item";rec."QB Budget item")
    {
        
                CaptionML=ESP='Partida Presupuestaria';
                Editable=FALSE ;
}
} addafter("Responsibility Center")
{
group("QB_DATOS")
{
        
                CaptionML=ENU='General',ESP='QuoBuilding';
    field("QB_ReceiveInFRI";rec."Receive in FRIS")
    {
        
}
    field("QB Have Proforms";rec."QB Have Proforms")
    {
        
}
    field("QB_NoReceiptCancel";rec."No. Receipt Cancel")
    {
        
                Editable=FALSE ;
}
    field("QB_Canceled";rec."Cancelled")
    {
        
}
    field("QB Canceled By";rec."QB Canceled By")
    {
        
                ToolTipML=ESP='Indica el usuario que cancel¢ completamente el albar n';
}
    field("QB Canceled in Date";rec."QB Canceled in Date")
    {
        
                ToolTipML=ESP='Indica la fecha en que se cancel¢ completamente el albar n';
}
    field("QB Canceled With Date";rec."QB Canceled With Date")
    {
        
                ToolTipML=ESP='Indica la fecha con la que se cancel¢ completamente el albar n';
}
}
} addafter("Pay-to")
{
    field("QB_PaymentTermsCode";rec."Payment Terms Code")
    {
        
                Editable=FALSE ;
}
    field("QB_PaymentMethodCode";rec."Payment Method Code")
    {
        
                Editable=FALSE ;
}
    field("QB_CurrencyCode";rec."Currency Code")
    {
        
                Editable=FALSE ;
}
}


modify("Buy-from Contact No.")
{
Importance=Additional;


}


modify("Buy-from Address")
{
Importance=Additional;


}


modify("Buy-from Address 2")
{
Importance=Additional;


}


modify("Buy-from City")
{
Importance=Additional;


}


modify("Buy-from County")
{
Importance=Additional;


}


modify("Buy-from Post Code")
{
Importance=Additional;


}


modify("Buy-from Country/Region Code")
{
Importance=Additional;


}


modify("Buy-from Contact")
{
Importance=Additional;


}


modify("No. Printed")
{
Importance=Additional;


}


modify("Document Date")
{
Importance=Additional;


}


modify("Requested Receipt Date")
{
Importance=Additional ;


}


modify("Promised Receipt Date")
{
Importance=Additional ;


}


modify("Quote No.")
{
Importance=Additional ;


}


modify("Vendor Order No.")
{
Importance=Additional;


}


modify("Vendor Shipment No.")
{
Importance=Additional;


}


modify("Order Address Code")
{
Importance=Additional;


}


modify("Purchaser Code")
{
Importance=Additional;


}


modify("Responsibility Center")
{
Importance=Additional;


}

}

actions
{
addfirst("Processing")
{    action("QB_Anular")
    {
        
                      CaptionML=ENU='Anular FRI',ESP='Anular Albar n';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=DeleteQtyToHandle;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 Text50000 : TextConst ESP='El albar n ya est  anulado';
                                 Text50001 : TextConst ESP='false es posible anular un albar n que ya est‚ parcial o totalmente facturado';
                                 Text50002 : TextConst ESP='Solo es posible anular albaranes previamente recepcionados en FRI';
                               BEGIN
                                 //JAV 04/04/21: - QB 1.08.32 Se pasa la acci¢n a la CU de Pages
                               END;


}
    action("Action100000001")
    {
        Ellipsis=true;
                      CaptionML=ENU='&Print',ESP='&Imprimir';
                      ToolTipML=ENU='Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.',ESP='Preparar el documento para imprimirlo. Se abre una ventana de solicitud de informe para el documento, donde puede especificar qu‚ incluir en la impresi¢n.';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Image=Print;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                //  AlbaranCompra : Report 7207405;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(PurchRcptHeader);
                                 PurchRcptHeader.PrintRecords(TRUE);
                               END;


}
}

}

//trigger
trigger OnAfterGetRecord()    BEGIN
                       JobDescription := '';
                       IF Job.GET(Rec."Job No.") THEN
                         JobDescription := Job.Description;
                     END;


//trigger

var
      PurchRcptHeader : Record 120;
      FormatAddress : Codeunit 365;
      IsBuyFromCountyVisible : Boolean;
      IsPayToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      "------------------------------- QB" : Integer;
      Job : Record 167;
      JobDescription : Text;

    
    

//procedure
//Local procedure ActivateFields();
//    begin
//      IsBuyFromCountyVisible := FormatAddress.UseCounty(rec."Buy-from Country/Region Code");
//      IsPayToCountyVisible := FormatAddress.UseCounty(rec."Pay-to Country/Region Code");
//      IsShipToCountyVisible := FormatAddress.UseCounty(rec."Ship-to Country/Region Code");
//    end;

//procedure
}

