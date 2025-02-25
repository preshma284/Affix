report 7238281 "InsertDateToJobBudget"
{
  
  
    CaptionML=ESP='Insertar fechas';
    ProcessingOnly=true;
    
  dataset
{

}
  requestpage
  {

    layout
{
area(content)
{
    field("StartingDate";"StartingDate")
    {
        
                  CaptionML=ESP='Fecha presupuesto';
    }
    field("EndingDate";"EndingDate")
    {
        
                  CaptionML=ESP='Fecha Fin';
                  Editable=FALSE 

    ;
    }

}
}trigger OnOpenPage()    BEGIN
                   Job.GET(JobBudget."Job No.");
                   EndingDate := Job."Ending Date";
                 END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                         IF CloseAction IN [ACTION::OK,ACTION::LookupOK] THEN
                           IF StartingDate = 0D THEN
                             ERROR(StartingDateNotInformedErr);
                       END;


  }
  labels
{
}
  
    var
//       Job@1100286002 :
      Job: Record 167;
//       JobBudget@1100286003 :
      JobBudget: Record 7207407;
//       StartingDate@1100286000 :
      StartingDate: Date;
//       EndingDate@1100286001 :
      EndingDate: Date;
//       StartingDateNotInformedErr@1100286004 :
      StartingDateNotInformedErr: TextConst ESP='La fecha inicio no est  informada.';

    

trigger OnPreReport();    begin

                  JobBudget."Budget Date" := StartingDate;
                  JobBudget."QPR end Date" := EndingDate;
                  JobBudget.MODIFY;
                end;



// procedure SetJobBudget (JobNo@1100286000 : Code[20];BudgetNo@1100286001 :
procedure SetJobBudget (JobNo: Code[20];BudgetNo: Code[20])
    begin
      JobBudget.RESET();
      JobBudget.SETRANGE("Job No.",JobNo);
      JobBudget.SETRANGE("Cod. Budget",BudgetNo);
      JobBudget.FINDFIRST;
    end;

    /*begin
    //{
//      RE16257-LCG-010222 Insertar fecha inicio para promociones.
//    }
    end.
  */
  
}



