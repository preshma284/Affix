report 50098 "Regenera Control Contratos"
{
  
  
    ProcessingOnly=true;
    UseRequestPage=false;
  
  dataset
{

DataItem("Contracts Control";"Contracts Control")
{

               DataItemTableView=SORTING("Linea");
               
                                 ;
trigger OnAfterGetRecord();
    BEGIN 
                                  IF "Contracts Control".Contrato <> '' THEN
                                    BEGIN 

                                      CASE "Contracts Control".Orden1 OF
                                        'C1': "Contracts Control".Orden2 := 'A';
                                        'C2': "Contracts Control".Orden2 := 'B';
                                        'C3': "Contracts Control".Orden2 := 'C';
                                      END;

                                      "Contracts Control".Orden1 := 'C-'+ "Contracts Control".Contrato;
                                      "Contracts Control".MODIFY;
                                    END
                                  ELSE
                                    BEGIN 
                                      IF "Contracts Control".Proveedor <> '' THEN
                                        BEGIN 
                                          CASE "Contracts Control".Orden1 OF
                                            'P1': "Contracts Control".Orden2 := 'A';
                                            'P2': "Contracts Control".Orden2 := 'B';
                                            'P3': "Contracts Control".Orden2 := 'C';
                                          END;

                                          "Contracts Control".Orden1 := 'P-'+ "Contracts Control".Proveedor;
                                          "Contracts Control".MODIFY;
                                        END;
                                    END;
                                END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
}
  

    

trigger OnPostReport();    begin
                   MESSAGE('Se ha ejecutado correctamente el proceso.');
                 end;



/*begin
    end.
  */
  
}



