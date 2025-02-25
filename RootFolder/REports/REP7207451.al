report 7207451 "QPR Bring Budget Template"
{
  
  
    ProcessingOnly=true;
    
  dataset
{

DataItem("QPR Budget Template  Line";"QPR Budget Template  Line")
{

               
                               ;
trigger OnPreDataItem();
    BEGIN 
                               "QPR Budget Template  Line".SETRANGE("QPR Budget Template  Line"."Template Code",opcSource);

                               CASE opcAction OF
                                 opcAction::" ":ERROR(Error0003);
                                 opcAction::Eliminar:  BEGIN 
                                   IF NOT CONFIRM(Text001,FALSE) THEN
                                     ERROR(Error0002);
                                   DeleteBudgetLine.RESET;
                                   DeleteBudgetLine.SETRANGE("Job No.",VJBudget);
                                   IF DeleteBudgetLine.FINDSET(TRUE,TRUE) THEN
                                     REPEAT
                                       DeleteBudgetLine.DeleteData(TRUE,TRUE);
                                       DeleteBudgetLine.DELETE(FALSE);
                                     UNTIL DeleteBudgetLine.NEXT = 0;
                                 END;
                                 opcAction::Mezclar: BEGIN 
                                   IF NOT CONFIRM(Text002,FALSE) THEN
                                     ERROR(Error0002);
                                 END;
                               END;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  NewBudgetLine.INIT;
                                  NewBudgetLine.TRANSFERFIELDS("QPR Budget Template  Line");
                                  NewBudgetLine."Job No." := VJBudget;

                                  IF NewBudgetLine.INSERT(TRUE) THEN
                                    BEGIN 
                                      NewBudgetLine.VALIDATE("Production Unit",TRUE);
                                      NewBudgetLine.VALIDATE("Unique Code");
                                      NewBudgetLine.MODIFY;
                                    END;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                MESSAGE('Proceso concluido');
                              END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group956")
{
        
                  CaptionML=ENU='Options';
    field("opcSource";"opcSource")
    {
        
                  CaptionML=ENU='Budget Template',ESP='Plantilla Presupuesto';
                  TableRelation="QPR Budget Template Header" ;
    }
    field("opcAction";"opcAction")
    {
        
                  CaptionML=ENU='Action',ESP='Acci¢n';
                  
                              

    ;trigger OnValidate()    BEGIN
                               CASE opcAction OF
                                 opcAction::Eliminar               : MESSAGE(Text001);
                                 opcAction::Mezclar                : MESSAGE(Text002);
                               END;
                             END;


    }

}

}
}
  }
  labels
{
}
  
    var
//       VJBudget@1100286007 :
      VJBudget: Code[20];
//       NewBudgetLine@1100286009 :
      NewBudgetLine: Record 7207386;
//       DeleteBudgetLine@1100286010 :
      DeleteBudgetLine: Record 7207386;
//       "------------------------------------------- Opciones"@1100286003 :
      "------------------------------------------- Opciones": Integer;
//       opcSource@1100286002 :
      opcSource: Code[20];
//       opcAction@1100286001 :
      opcAction: Option " ","Eliminar","Mezclar";
//       opcInitialValue@1100286000 :
      opcInitialValue: Code[20];
//       Text000@1100286006 :
      Text000: TextConst ENU='You must filter for a budget template.',ESP='Debe filtrar por una plantilla de presupuesto.';
//       Text001@1100286005 :
      Text001: TextConst ENU='The previous budget line and all related tables will be erased',ESP='Se borrar n las l¡neas de presupuesto existentes y todas las tablas relacionadas';
//       Text002@1100286004 :
      Text002: TextConst ENU='The budget lines will be updated',ESP='Se actualizar n las l¡neas de presupuesto existentes, mezcl ndolas con las nuevas';
//       Error0001@1100286008 :
      Error0001: TextConst ENU='El c¢digo de presupuesto destino no puede estar en blanco.';
//       Error0002@1100286011 :
      Error0002: TextConst ENU='Proceso cancelado por el usuario.';
//       Error0003@1100286012 :
      Error0003: TextConst ENU='You must select an Action',ESP='Debe seleccionar una accion.';

    

trigger OnInitReport();    begin
                   opcSource := '';
                   opcInitialValue := '';
                 end;

trigger OnPreReport();    begin
                  if (opcSource = '') then
                    ERROR(Text000);

                  if VJBudget  = '' then
                    ERROR(Error0001);
                end;



// procedure SetBudgetTarget (JobBadget@1100286000 :
procedure SetBudgetTarget (JobBadget: Code[20])
    begin
      VJBudget := JobBadget;
    end;

    /*begin
    //{
//      JAV 08/04/22: - QB 1.10.32 Se mejoran las plantillas de presupuestos, se cambian nombres y captios, se a¤ade activable
//    }
    end.
  */
  
}



