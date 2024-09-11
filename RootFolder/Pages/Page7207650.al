page 7207650 "RC Quotes Activities"
{
CaptionML=ENU='Activities',ESP='Activities';
    SourceTable=7206916;
    PageType=CardPart;
    
  layout
{
area(content)
{
group("group64")
{
        
                CaptionML=ENU='Invoicing',ESP='Estudios';
    field("My Quotes";rec."My Quotes")
    {
        
                DrillDownPageID="Quotes List" ;
    }
    field("My Quotes in Process";rec."My Quotes in Process")
    {
        
                DrillDownPageID="Quotes List" ;
    }
    field("My Quotes Presented";rec."My Quotes Presented")
    {
        
                DrillDownPageID="Quotes List" ;
    }
    field("Proyectos ptes. de crear";rec."Proyectos ptes. de crear")
    {
        
    }
    field("My pending approvals";rec."My pending approvals")
    {
        
                DrillDownPageID="Requests to Approve" ;
    }
    field("Movements pending approval";rec."Movements pending approval")
    {
        
                DrillDownPageID="Approval Entries" 

  ;
    }

}

}
}
  
trigger OnOpenPage()    BEGIN
                 Rec.RESET;
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;

                 ApplyGlobalFilters;
                 UpdateActivities;
               END;

trigger OnAfterGetRecord()    BEGIN
                       UpdateActivities;
                     END;



    var
      MyJob : Record 9154;
      i : Integer;
      JobsSelected : Code[250];

    procedure ApplyGlobalFilters();
    begin
      CLEAR(Rec);
      Rec.SETFILTER("Date Filter",'>=%1',WORKDATE);
      Rec.SETFILTER("Date Filter2",'<%1',WORKDATE);
      Rec.SETFILTER("User ID Filter",'=%1',USERID);
    end;

    procedure UpdateActivities();
    begin
      i := 1;
      JobsSelected := '';
      CLEAR(MyJob);
      MyJob.SETRANGE("User ID",USERID);
      if MyJob.FINDFIRST then begin
        repeat
          if i = 1 then begin
            JobsSelected := MyJob."Job No.";
          end ELSE if i < 13 then
            JobsSelected := JobsSelected + '|' + MyJob."Job No.";
          i := i + 1;
        until MyJob.NEXT = 0;
        Rec.SETFILTER(JobFilter,JobsSelected);
        CalcFieldsActivities;
      end ELSE begin
        ApplyGlobalFilters;
        CalcFieldsActivities;
      end;
    end;

    procedure CalcFieldsActivities();
    begin
      Rec.CALCFIELDS("My Quotes in Process", "My Quotes Presented","Proyectos ptes. de crear","My Quotes");
      Rec.CALCFIELDS("My pending approvals", "Movements pending approval");
    end;

    // begin//end
}







