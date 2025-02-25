report 7207401 "Conf. Certification Units."
{
  
  
    CaptionML=ENU='Conf.CertificationUnits',ESP='Conf. unidades certificaci¢n';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Piecework";"Piecework")
{

               DataItemTableView=SORTING("Base Price Sales","No.");
               
                               ;
trigger OnPreDataItem();
    BEGIN 
                               IF IntNivel = 0 THEN
                                 ERROR(Text001);

                               Piecework.MODIFYALL("Certification Unit", FALSE);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF Piecework.Identation <= IntNivel THEN BEGIN 
                                    Piecework."Certification Unit" := TRUE;
                                    Piecework.MODIFY;
                                  END ELSE BEGIN 
                                    Piecework."Certification Unit" := FALSE;
                                    Piecework.MODIFY;
                                  END;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                MESSAGE(Text002);
                              END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group740")
{
        
                  CaptionML=ENU='Option',ESP='Opciones';
    field("IntNivel";"IntNivel")
    {
        
                  CaptionML=ENU='File Costs Cost Database External',ESP='Marcar los del nivel inferior o iguial a';
    }

}

}
}
  }
  labels
{
}
  
    var
//       IntNivel@7207272 :
      IntNivel: Integer;
//       Text001@7207273 :
      Text001: TextConst ENU='You must indicate a level to set the certification units',ESP='Debe indicar un nivel para fijar las unidades de certificaci¢n';
//       Text002@7207274 :
      Text002: TextConst ENU='Pricess completed',ESP='Proceso concluido';

    /*begin
    end.
  */
  
}



