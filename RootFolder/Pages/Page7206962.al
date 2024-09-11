page 7206962 "QB Replacements"
{
  ApplicationArea=All;

SourceTable=7206943;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Replacement Code";rec."Replacement Code")
    {
        
    }

}

}
area(FactBoxes)
{
    systempart(MyNotes;MyNotes)
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
area(Creation)
{
//Name=General;
    action("Setup")
    {
        
                      CaptionML=ENU='Setup',ESP='Configurar';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Setup;
                      PromotedCategory=Process;
                      PromotedOnly=true;
                      
                                
    trigger OnAction()    VAR
                                 QBReplacementHeader : Record 7206943;
                                 QBReplacementLine : Record 7206944;
                                 QBReplacementsSetup : Page 7206963;
                               BEGIN
                                 QBReplacementHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(QBReplacementHeader);
                                 QBReplacementLine.RESET;
                                 QBReplacementLine.SETRANGE("Replacement Code",QBReplacementHeader."Replacement Code");
                                 //IF QBReplacementLine.FINDSET THEN BEGIN
                                 QBReplacementsSetup.SETTABLEVIEW(QBReplacementLine);
                                 QBReplacementsSetup.RUNMODAL;
                                 //END;
                               END;


    }

}
}
  

    /*begin
    end.
  
*/
}









