page 7207050 "QB Service Order List"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='"Service Order "',ESP='Pedidos Sevicio';
    SourceTable=7206966;
    SourceTableView=WHERE("Status"=FILTER(<>Invoiced&<>Finished));
    PageType=List;
    CardPageID="QB Service Order";
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
repeater("Group")
{
        
                Editable=FALSE;
    field("No.";rec."No.")
    {
        
    }
    field("Job Description";rec."Job Description")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Customer No.";rec."Customer No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Service Date";rec."Service Date")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Expenses/Investment";rec."Expenses/Investment")
    {
        
    }
    field("Service Order Type";rec."Service Order Type")
    {
        
    }
    field("Grouping Criteria";rec."Grouping Criteria")
    {
        
    }
    field("Total Cost";rec."Total Cost")
    {
        
    }
    field("Total Sale";rec."Total Sale")
    {
        
    }
    field("Status";rec."Status")
    {
        
    }
    field("Ext order service";rec."Ext order service")
    {
        
    }
    field("Invoicing Date";rec."Invoicing Date")
    {
        
    }

}

}
area(FactBoxes)
{
    part("part1";7207056)
    {
        
                CaptionML=ENU='Service Order Statistics',ESP='Estad�stica Pedido Servicio';SubPageLink="No."=FIELD("No.");
                Visible=TRUE;
    }
    systempart(Links;Links)
    {
        
                Visible=TRUE;
    }
    systempart(Notes;Notes)
    {
        
                Visible=TRUE;
    }

}
}actions
{
area(Creation)
{
//Name=General;
    action("action1")
    {
        ShortCutKey='F9';
                      CaptionML=ENU='P&ost',ESP='Registrar';
                      Image=Post;
                      
                                
    trigger OnAction()    VAR
                                 MeasureHD : Record 7206966;
                                 PostMeasurementYesNo : Codeunit 7207275;
                                 QBServiceOrderProcesing : Codeunit 7206911;
                               BEGIN
                                 // 02/02/2022 (EPV) - Error al registrar
                                 // No se estaba refrescando la variable QBServiceOrderHeader
                                 CLEAR(QBServiceOrderHeader);
                                 //-->
                                 QBServiceOrderHeader.RESET;
                                 CurrPage.SETSELECTIONFILTER(QBServiceOrderHeader);
                                 QBServiceOrderProcesing.Post(QBServiceOrderHeader);
                                 /*{
                                 SE COMENTA. NO EXISTE FUNCION RegServOrderPage7207050
                                 CurrPage.SETSELECTIONFILTER(MeasureHD);
                                 PostMeasurementYesNo.RegServOrderPage7207050(MeasureHD);
                                 }*/
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.AccessToServiceOrder(TRUE);

                 rec.FunFilterResponsibility(Rec);
                 /*{SE COMENTA. NO EXISTE FUNCION FilterLevel
                 UserMgt.FilterLevel(codeFilterLevel);

                 Rec.FILTERGROUP(2);
                 Rec.SETFILTER("Access Level",codeFilterLevel);

                 optType:= optType::Certification;
                 IF Rec.GETFILTER("Document Type") = FORMAT(optType,0,0) THEN
                   booVisible := TRUE
                 ELSE
                   booVisible := FALSE;

                 Rec.FILTERGROUP(0);
                 }*/
               END;



    var
      DimMgt : Codeunit 408;
      UserMgt : Codeunit 5700;
      codeFilterLevel : Code[250];
      booVisible : Boolean;
      optType: Option "Measuring","Certification";
      QBServiceOrderHeader : Record 7206966;
      FunctionQB : Codeunit 7207272;/*

    begin
    {
      Q16212 02/02/2022 (EPV) - Error al registrar de manera consecutiva dos pedidos de servicio sin salir de la p�gina
    }
    end.*/
  

}








