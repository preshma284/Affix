page 7207469 "Milestone Planning Determinati"
{
CaptionML=ENU='Milestone Planning Determination',ESP='Det. planificaci¢n hitos';
    SourceTable=7207376;
    PageType=ListPart;
    AutoSplitKey=true;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Planning Milestone Code";rec."Planning Milestone Code")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Percentage";rec."Percentage")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Term";rec."Term")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("ShowDateMilestone";rec."ShowDateMilestone")
    {
        
                CaptionML=ENU='Date',ESP='Fecha';
                Style=Strong;
                StyleExpr=TRUE 

  ;
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 Rec.SETRANGE("Job No.",CJob);
                 Rec.SETRANGE("Account Schedule Code",CScheme);
                   OnActivateForm;
               END;



    var
      CJob : Code[20];
      CScheme : Code[20];

    procedure PlanMilestoneModel(PDimensionValue : Record 349);
    var
      ModelsTempory : Record 7207377;
      MilestoneCostsPlanning : Record 7207376;
      TemporyModelDecide : Record 7207378;
      Contlin : Integer;
      Milestone : Code[10];
      TemporyModelsList : Page 7207472;
    begin
      TemporyModelsList.SETTABLEVIEW(ModelsTempory);
      TemporyModelsList.LOOKUPMODE:=TRUE;
      if TemporyModelsList.RUNMODAL=ACTION::LookupOK then
        TemporyModelsList.GETRECORD(ModelsTempory)
      ELSE
        exit;

      Milestone := rec."Planning Milestone Code";
      MilestoneCostsPlanning.SETRANGE("Job No.",CJob);
      MilestoneCostsPlanning.SETRANGE("Concept Code",PDimensionValue.Code);
      MilestoneCostsPlanning.SETRANGE( "Planning Milestone Code", rec. "Planning Milestone Code");

      MilestoneCostsPlanning.DELETEALL;
      TemporyModelDecide.SETRANGE("Model Code",ModelsTempory.Code);
      Contlin:=0;
      if TemporyModelDecide.FINDSET then
        repeat
          MilestoneCostsPlanning."Job No." := CJob;
          MilestoneCostsPlanning."Planning Milestone Code" := Milestone;
          MilestoneCostsPlanning."Concept Code" := PDimensionValue.Code;
          Contlin += 10000;
          MilestoneCostsPlanning.Account := Contlin;
          MilestoneCostsPlanning.Percentage := TemporyModelDecide."%To Applied";
          MilestoneCostsPlanning.Term := TemporyModelDecide."Term Formula";
          MilestoneCostsPlanning.INSERT;
        until TemporyModelDecide.NEXT=0
    end;

    procedure SetPromotion(PJob : Code[20]);
    begin
      CJob := PJob;
    end;

    procedure SetScheme(PScheme : Code[20]);
    begin
      CScheme := PScheme;
    end;

    LOCAL procedure OnActivateForm();
    begin
      Rec.SETRANGE("Job No.",CJob);
      Rec.SETRANGE("Account Schedule Code",CScheme);
    end;

    // begin//end
}







