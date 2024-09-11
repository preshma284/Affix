page 7206925 "Obralia Log Entry"
{
Editable=false;
    CaptionML=ENU='Obralia Log Entry',ESP='Log Obralia';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7206904;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Datetime Process";rec."Datetime Process")
    {
        
    }
    field("User";rec."User")
    {
        
    }
    field("Obralia";rec."Obralia")
    {
        
    }
    field("Filter";rec."Filter")
    {
        
    }
    field("Vendor";rec."Vendor")
    {
        
    }
    field("Result";rec."Result")
    {
        
    }
    field("Text Error";rec."Text Error")
    {
        
    }
    field("Correct";rec.Correct)
    {
        
    }
    field("Datetime Result Process";rec."Datetime Result Process")
    {
        
    }
    field("semaforoEmpresa";rec."semaforoEmpresa")
    {
        
    }
    field("semaforoTotal";rec."semaforoTotal")
    {
        
    }
    field("semaforoPagos";rec."semaforoPagos")
    {
        
                CaptionML=ESP='Semaforo pagos';
    }
    field("urlConsulta";rec."urlConsulta")
    {
        
    }

}

}
area(FactBoxes)
{
    systempart(Notes;Notes)
    {
        ;
    }
    systempart(Links;Links)
    {
        ;
    }

}
}actions
{
area(Creation)
{
//Name=acions;
    action("ShowRequestXML")
    {
        
                      CaptionML=ENU='Show Request XML',ESP='Mostrar petici�n XML';
                      Image=XMLFile;
                      
                                trigger OnAction()    VAR
                                 XML : Text;
                               BEGIN
                                 XML := Rec.GetRequestXml();
                                 MESSAGE(XML);
                               END;


    }
    action("ShowResponseXML")
    {
        
                      CaptionML=ENU='Show Response XML',ESP='Mostrar respuesta XML';
                      Image=XMLFile;
                      
                                
    trigger OnAction()    VAR
                                 XML : Text;
                               BEGIN
                                 XML := Rec.GetResponseXml();
                                 MESSAGE(XML);
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ShowRequestXML_Promoted; ShowRequestXML)
                {
                }
                actionref(ShowResponseXML_Promoted; ShowResponseXML)
                {
                }
            }
        }
}
  /*

    begin
    {
      Q19458 PSM 22/05/23 A�adir campo SemaforoPagos
    }
    end.*/
  

}








