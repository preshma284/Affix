report 7207445 "Import Journal from XRT"
{
  
  
    ProcessingOnly=true;
    UseRequestPage=false;
  
  dataset
{

DataItem("Table2000000026";"2000000026")
{

               MaxIteration=1;
               
                                 ;
trigger OnAfterGetRecord();
    BEGIN 
                                  QBGenericImport.Setrequestpage('IMP001',0);
                                  QBGenericImport.RUN;
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
  
    var
//       QBGenericImport@1100286000 :
      QBGenericImport: Report 7207443;

    /*begin
    end.
  */
  
}



