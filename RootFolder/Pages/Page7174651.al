page 7174651 "Definition Sharepoint List"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Definition Sharepoint List',ESP='Definici�n Sitio Sharepoint Lista';
    SourceTable=7174651;
    PageType=List;
    CardPageID="Definition Metadata Sharepoint";
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
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
    field("Name Site Sharepoint";rec."Name Site Sharepoint")
    {
        
    }
    field("Status";rec."Status")
    {
        
                Style=Favorable;
                StyleExpr=TRUE ;
    }

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
    separator("separator3")
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
      QUONEXT 20.07.17. DRAG&DROP. Configuraci�n del site de Sharepoint donde se subiran los ficheros.
    }
    end.*/
  

}









