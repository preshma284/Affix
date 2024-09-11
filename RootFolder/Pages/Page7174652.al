page 7174652 "Definition Metadata Sharepoint"
{
CaptionML=ENU='Definition Metadata Sharepoint',ESP='Definici�n Sitio Sharepoint';
    SourceTable=7174651;
    DataCaptionExpression='No.' + ' ' + 'Name Site Sharepoint';
    PageType=Document;
  layout
{
area(content)
{
group("General")
{
        
    field("No.";rec."No.")
    {
        
                
                              ;trigger OnAssistEdit()    BEGIN
                               IF rec.AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;


    }
    field("Description";rec."Description")
    {
        
    }
group("group11")
{
        
grid("group12")
{
        
                GridLayout=Rows ;
group("group13")
{
        
    field("IdTable";rec."IdTable")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Name Table";rec."Name Table")
    {
        
                Style=AttentionAccent;
                StyleExpr=TRUE ;
    }
    field("Main Url";rec."Main Url")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Job Card Type";rec."Job Card Type")
    {
        
    }
    field("Sharepoint folder Path";rec."Sharepoint folder Path")
    {
        
    }

}
group("group19")
{
        
    field("Library Title Type";rec."Library Title Type")
    {
        
    }
    field("Library Title";rec."Library Title")
    {
        
                Style=Strong;
                StyleExpr=TRUE;
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Field Name Title";rec."Field Name Title")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }

}

}

}
    field("Name Site Sharepoint";rec."Name Site Sharepoint")
    {
        
                Style=AttentionAccent;
                StyleExpr=TRUE ;
    }
    field("Status";rec."Status")
    {
        
                Editable=false;
                Style=Favorable;
                StyleExpr=TRUE ;
    }

}
    part("part1";7174653)
    {
        SubPageLink="Metadata Site Definition"=FIELD("No.");
                UpdatePropagation=Both ;
    }

}
area(FactBoxes)
{
    systempart(Notes;Notes)
    {
        ;
    }
    systempart(Links;Links)
    {
        ;
    }

}
}actions
{
area(Processing)
{

    action("Check Metadata")
    {
        
                      CaptionML=ENU='Check configuration',ESP='Comprobar configuraci�n';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Check;
                      PromotedCategory=Process;
                      PromotedOnly=true;
                      
                                trigger OnAction()    BEGIN
                                 rec.FncCheckMetadataSP(rec."No.");
                               END;


    }
    action("Reopen")
    {
        
                      CaptionML=ENU='Re&open',ESP='&Volver a abrir';
                      ToolTipML=ENU='Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.',ESP='Permite volver a abrir el documento para cambiarlo una vez que se haya aprobado. Los documentos aprobados tienen el estado Lanzado y se deben abrir para poder cambiarlos.';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Enabled=rec.Status <> rec.Status::Open;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      PromotedOnly=true;
                      
                                trigger OnAction()    VAR
                                 ReleaseSalesDoc : Codeunit 414;
                               BEGIN
                                 rec.Status := rec.Status::Open;
                               END;


    }
    action("Library Type")
    {
        
                      CaptionML=ENU='Library Type',ESP='Tipo de librer�a';
                      RunObject=Page 7174659;
                      RunPageView=SORTING("Metadata Site Defs","Entry No.");
RunPageLink="Metadata Site Defs"=FIELD("No.");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Tools;
                      PromotedCategory=Process;
                      PromotedOnly=true ;
    }
    separator("separator4")
    {
        
    }
    action("History Sites")
    {
        
                      CaptionML=ENU='History Sites',ESP='Hist�rico sitios creados';
                      RunObject=Page 7174662;
                      RunPageView=SORTING("Metadata Site Definition","Line No.");
RunPageLink="Metadata Site Definition"=FIELD("No.");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=History;
                      PromotedCategory=Process;
                      PromotedOnly=true 
    ;
    }

}
}
  /*

    begin
    {
      QUONEXT 20.07.17. DRAG&DROP. Configuraci�n de los datos b�sicos del site de Sharepoint donde se subiran los ficheros.
      Q7357 JDC 13/11/19 - Added field 50000 rec."Job Card Type"
      CPA 17/06/22 - Q17567 A�adir configuraci�n en la definici�n de los sitios para permitir carpetas
    }
    end.*/
  

}








