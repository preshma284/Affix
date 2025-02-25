pageextension 50197 MyExtension45 extends 45//36
{
layout
{


}

actions
{
addafter("Card")
{
    action("Action100000000")
    {
        CaptionML=ESP='Nuevo';
                      Promoted=true;
                      Visible=verNew;
                      Image=NewDocument;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 PageManagement : Codeunit 700;
                                 Job : Record 167;
                                 SalesHeader : Record 36;
                               BEGIN
                                 IF Job.GET(fJob) THEN BEGIN
                                   SalesHeader.INIT;
                                   CASE fTipo OF
                                     FORMAT(rec."Document Type"::"Invoice") : SalesHeader."Document Type" := rec."Document Type"::"Invoice";
                                   END;
                                   SalesHeader."No." := '';
                                   SalesHeader.INSERT(TRUE);
                                   SalesHeader.VALIDATE("Sell-to Customer No.", Job."Bill-to Customer No.");
                                   SalesHeader.VALIDATE("QB Job No.", Job."No.");
                                   SalesHeader.MODIFY;
                                   PageManagement.PageRun(SalesHeader);
                                 END;
                               END;


}
}

}

//trigger
trigger OnOpenPage()    BEGIN
                 rec.CopySellToCustomerFilter;

                 Rec.FILTERGROUP(2);
                 fTipo := Rec.GETFILTER("Document Type");
                 fJob  := Rec.GETFILTER("QB Job No.");
                 Rec.FILTERGROUP(0);
                 verNew := (fJob <> '');
               END;


//trigger

var
      fJob : Text;
      fTipo : Text;
      verNew : Boolean;

    

//procedure

//procedure
}

