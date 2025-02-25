pageextension 50286 MyExtension9154 extends 9154//9154
{
layout
{



//modify("Job No.")
//{
//
//
//}
//
}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 Rec.SETRANGE("User ID",USERID);

                 //JAV 25/07/19: - Eliminar los que ya no puede ver el usuario
                 RevisarProyectosUsuario;
               END;


//trigger

var
      Job : Record 167;
      "----------------------------- QB" : Integer;
      MyJobs : Record 9154;
      Jobs : Record 167;
      QBJobResponsible : Record 7206992;
      JobList : Page 89;
      FunctionQB : Codeunit 7207272;
      err01 : TextConst ESP='El proyecto no existe o no est  asociado al usuario';
      JobNo : Code[20];

    
    

//procedure
//Local procedure GetJob();
//    begin
//      CLEAR(Job);
//
//      if ( Job.GET(rec."Job No.")  )then begin
//        rec."Description" := Job.Description;
//        rec."Status" := Job.Status;
//        rec."Bill-to Name" := Job."Bill-to Name";
//        rec."Percent Completed" := Job.PercentCompleted;
//        rec."Percent Invoiced" := Job.PercentInvoiced;
//      end;
//    end;
procedure RevisarProyectosUsuario();
    begin
      //JAV 28/02/20: - Se mejora el manejo de los proyectos por usuario
      if ( not FunctionQB.UserAccessToAllJobs  )then begin
        MyJobs.RESET;
        MyJobs.SETRANGE("User ID", USERID);
        if ( (MyJobs.FINDSET(TRUE))  )then
          repeat
            QBJobResponsible.RESET;
            QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);    //JAV 23/10/20 - QB 1.07.00 Se a¤ade que es para proyectos
            QBJobResponsible.SETRANGE("Table Code", MyJobs."Job No.");
            QBJobResponsible.SETRANGE("User ID", MyJobs."User ID");
            if ( (QBJobResponsible.ISEMPTY)  )then
              MyJobs.DELETE;
          until (MyJobs.NEXT = 0);
      end;
    end;

//procedure
}

