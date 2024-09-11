page 7206944 "QB Payment Phases List"
{
  ApplicationArea=All;

CaptionML=ENU='Payment Phases List',ESP='Lista de Fases de Pago';
    SourceTable=7206929;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
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
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Line',ESP='&L�nea';
    action("action1")
    {
        ShortCutKey='Shift+F5';
                      CaptionML=ENU='Lines',ESP='L�neas';
                      RunObject=Page 7206945;
RunPageLink="Code"=FIELD("Code");
                      Image=Line;
    }

}

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
}
  

    /*begin
    end.
  
*/
}









