page 7207028 "QB Job Task Data Setup"
{
CaptionML=ENU='Job Task Data',ESP='Datos de la Tarea';
    SourceTable=7206927;
    
  layout
{
area(content)
{
group("group26")
{
        
                CaptionML=ENU='Task',ESP='General';
group("group27")
{
        
                CaptionML=ENU='Task',ESP='Tarea';
    field("Job";rec."Job")
    {
        
                Editable=false ;
    }
    field("Period";rec."Period")
    {
        
                Editable=false ;
    }
    field("Task";rec."Task")
    {
        
                Editable=false ;
    }

}
group("group31")
{
        
                CaptionML=ENU='Data',ESP='Ejecuci�n';
    field("ActionType";ActionType)
    {
        
                CaptionML=ENU='Data',ESP='Proceso';
                Editable=false;
                StyleExpr=stActionType ;
    }
    field("RunType";RunType)
    {
        
                CaptionML=ESP='Tipo';
                Editable=false ;
    }
    field("RunObject";RunObject)
    {
        
                CaptionML=ESP='Objeto';
                BlankZero=true;
                Editable=false ;
    }

}

}
group("group35")
{
        
                CaptionML=ENU='Data',ESP='Datos';
    field("Date";rec."Date")
    {
        
                Editable=false ;
    }
    field("User";rec."User")
    {
        
                Editable=false ;
    }
    field("Comment";rec."Comment")
    {
        
                Editable=Perform 

  ;
    }

}

}
}
  

trigger OnAfterGetRecord()    BEGIN
                       QBJobTask.GET(Rec.Task);
                       IF (Perform) THEN BEGIN
                         ActionType := 'Ejecutar';
                         stActionType := 'Strong';
                         RunType := FORMAT(QBJobTask."Perform Type");
                         RunObject := QBJobTask."Perform Object";
                       END ELSE BEGIN
                         ActionType := 'Cancelar';
                         stActionType := 'Unfavorable';
                         RunType := FORMAT(QBJobTask."Cancel Type");
                         RunObject := QBJobTask."Cancel Object";
                       END;
                     END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF (CloseAction = ACTION::LookupOK) THEN BEGIN
                         IF (Perform) THEN BEGIN
                           CASE QBJobTask."Perform Type" OF
                             QBJobTask."Perform Type"::Check : rec.Performed := TRUE;
                             QBJobTask."Perform Type"::CU : CODEUNIT.RUN(QBJobTask."Perform Object");
                             QBJobTask."Perform Type"::RP : REPORT.RUN(QBJobTask."Perform Object");
                           END;
                         END ELSE BEGIN
                           CASE QBJobTask."Cancel Type" OF
                             QBJobTask."Cancel Type"::Check : rec.Performed := FALSE;
                             QBJobTask."Cancel Type"::CU : CODEUNIT.RUN(QBJobTask."Cancel Object");
                             QBJobTask."Cancel Type"::RP : REPORT.RUN(QBJobTask."Cancel Object");
                           END;
                         END;
                       END;
                     END;



    var
      QBJobTask : Record 7206902;
      Perform : Boolean;
      ActionType : Text;
      stActionType : Text;
      RunType : Text;
      RunObject : Integer;

    procedure SetType(pPerform : Boolean);
    begin
      Perform := pPerform;
    end;

    // begin//end
}







