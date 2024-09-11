page 7207271 "QB Worksheet List"
{
  ApplicationArea=All;

CaptionML=ENU='Worksheet List',ESP='Lista partes de trabajo';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7207290;
    SourceTableView=SORTING("No.");
    PageType=List;
    CardPageID="QB Worksheet Header";
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
    }
    field("Sheet Type";rec."Sheet Type")
    {
        
    }
    field("No. Resource /Job";rec."No. Resource /Job")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Description 2";rec."Description 2")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }

}

}
area(FactBoxes)
{
    part("part1";7207505)
    {
        SubPageLink="No."=FIELD("No.");
                Visible=TRUE;
    }
    systempart(Links;Links)
    {
        ;
    }
    systempart(Notes;Notes)
    {
        ;
    }

}
}actions
{
area(Navigation)
{
//Name=<Action7001113>;
                      //CaptionML=ESP='<Action7001113>';
group("<Action7001114>")
{
        
                      CaptionML=ENU='&Line',ESP='Ficha';
    action("action1")
    {
        ShortCutKey='Shift+F5';
                      CaptionML=ENU='Resource Card',ESP='Ficha Recurso';
                      Enabled=enResource;
                      Image=Resource;
                      
                                trigger OnAction()    VAR
                                 Resource : Record 156;
                                 ResourceCard : Page 76;
                               BEGIN
                                 IF rec."Sheet Type" = rec."Sheet Type"::"By Resource" THEN BEGIN
                                   Resource.GET(rec."No. Resource /Job");

                                   CLEAR(ResourceCard);
                                   ResourceCard.SETRECORD(Resource);
                                   ResourceCard.RUN;
                                 END;
                               END;


    }
    action("action2")
    {
        CaptionML=ENU='Job Card',ESP='Ficha Proyecto';
                      Enabled=enJob;
                      Image=Job;
                      
                                
    trigger OnAction()    VAR
                                 Job : Record 167;
                                 OperativeJobsCard : Page 7207478;
                               BEGIN
                                 IF rec."Sheet Type" = rec."Sheet Type"::"By Job" THEN BEGIN
                                   Job.GET(rec."No. Resource /Job");

                                   CLEAR(OperativeJobsCard);
                                   OperativeJobsCard.SETRECORD(Job);
                                   OperativeJobsCard.RUN;
                                 END;
                               END;


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
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
}
  trigger OnAfterGetRecord()    BEGIN
                       enResource := (rec."Sheet Type" = rec."Sheet Type"::"By Resource");
                       enJob := (rec."Sheet Type" = rec."Sheet Type"::"By Job");
                     END;



    var
      Option : Integer;
      CJob : Code[20];
      enResource : Boolean;
      enJob : Boolean;

    procedure SETFILTER(PTypeSheet : Integer;PCJob : Code[20]);
    begin
      Option := PTypeSheet;
      CJob := PCJob;
    end;

    // begin//end
}








