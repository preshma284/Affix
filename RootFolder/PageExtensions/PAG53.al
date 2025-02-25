pageextension 50223 MyExtension53 extends 53//38
{
layout
{
addfirst("Control1")
{
    field("QB Job No.";rec."QB Job No.")
    {
        
}
    field("JobDescription";"JobDescription")
    {
        
                CaptionML=ESP='Nombre proyecto';
}
    field("Comment";rec."Comment")
    {
        
}
    field("QB Contract";rec."QB Contract")
    {
        
}
} addafter("Assigned User ID")
{
    field("Amount";rec."Amount")
    {
        
                Style=Strong;
                StyleExpr=DifIVA ;
}
    field("Amount Including VAT";rec."Amount Including VAT")
    {
        
}
} addafter("Currency Code")
{
}

}

actions
{
addafter("Card")
{
    action("Action1100286000")
    {
        CaptionML=ENU='Card',ESP='Nuevo';
                      ToolTipML=ENU='New document in Job.',ESP='Permite crear un nuevo documento en el proyecto.';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Visible=bNew;
                      PromotedIsBig=true;
                      Image=NewDocument;
                      
                                trigger OnAction()    VAR
                                 PageManagement : Codeunit 700;
                                 PurchaseHeader : Record 38;
                               BEGIN
                                 //JAV 02/04/19: - Nuevo bot¢n de acci¢n para crear un nuevo documento de compra en el proyecto
                                 PurchaseHeader.INIT;
                                 PurchaseHeader."Document Type" := DocType;
                                 PurchaseHeader."No." := '';
                                 PurchaseHeader.INSERT(TRUE);
                                 PurchaseHeader.VALIDATE("QB Job No.", JobNo);
                                 PurchaseHeader.MODIFY;

                                 PageManagement.PageRun(PurchaseHeader);
                               END;


}
}


modify("Card")
{
Promoted=true;
PromotedIsBig=true;


}

}

//trigger
trigger OnOpenPage()    BEGIN
                 rec.CopyBuyFromVendorFilter;

                 //JAV 02/04/19: - Guardar el tipo de documento y el proyecto en la entrada
                 Rec.FILTERGROUP(2);
                 IF Rec.GETFILTER("Document Type") <> '' THEN
                   IF Rec.GETRANGEMIN("Document Type") = Rec.GETRANGEMAX("Document Type") THEN BEGIN
                     DocType := Rec.GETRANGEMIN("Document Type");
                     Rec.SETRANGE("Document Type", DocType);
                   END;

                 txtFilter := Rec.GETFILTER("QB Job No.");

                 //JAV 25/05/21: - QB 1.08.45 mejora en el filtro
                 JobNo := '';
                 IF txtFilter <> '' THEN BEGIN
                   IF STRLEN(txtFilter) <= MAXSTRLEN(Job."No.") THEN BEGIN
                     IF Job.GET(txtFilter) THEN BEGIN
                       Rec.SETRANGE("QB Job No.", txtFilter);
                       JobNo := Job."No.";
                     END;
                   END;
                 END;

                 Rec.FILTERGROUP(0);
                 bNew := (JobNo <> '');  //Si el bot¢n de nuevo estar  activo o no
                 //JAV 02/04/19 fin
               END;
trigger OnAfterGetRecord()    BEGIN
                       JobDescription := '';
                       IF Job.GET(Rec."QB Job No.") THEN
                         JobDescription := Job.Description;

                       //JAV 14/03/19: - Remarcar si hay diferencias en el IVA
                       Rec.CALCFIELDS("Amount Including VAT", "Amount");
                       DifIVA := rec."Amount Including VAT" <> rec."Amount";
                     END;
trigger OnAfterGetCurrRecord()    BEGIN

                           JobDescription := '';
                           IF Job.GET(Rec."QB Job No.") THEN
                             JobDescription := Job.Description;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;


//trigger

var
      JobDescription : Text;
      Job : Record 167;
      DifIVA : Boolean ;
      // DocType : Option;
      DocType : Enum "Purchase Document Type";
      JobNo : Text;
      bNew : Boolean ;
      txtFilter : Text;

    
    

//procedure
procedure GetResult(var PPurchaseHeader : Record 38);
    begin
      // QB.begin
      CurrPage.SETSELECTIONFILTER(PPurchaseHeader);
      if ( PPurchaseHeader.FINDFIRST  )then;
      // QB.end
    end;

//procedure
}

