page 7207054 "QB Service Order Types"
{
  ApplicationArea=All;

CaptionML=ENU='Service Order Types',ESP='Tipos pedido servicio';
    SourceTable=7206974;
    PageType=List;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Code";rec."Code")
    {
        
                ToolTipML=ENU='Specifies a code for the service order type.',ESP='Especifica un c�digo para el tipo de pedido de servicio.';
                ApplicationArea=Service;
    }
    field("Description";rec."Description")
    {
        
                ToolTipML=ENU='Specifies a description of the service order type.',ESP='Especifica una descripci�n del tipo de pedido de servicio.';
                ApplicationArea=Service;
    }

}

}
area(FactBoxes)
{
    systempart(Links;Links)
    {
        
                Visible=FALSE;
    }
    systempart(Notes;Notes)
    {
        
                Visible=FALSE;
    }

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='Service Order Type',ESP='Tipo pedido servicio';
                      Image=ServiceCode ;
group("group3")
{
        CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      Image=Dimensions ;
    action("action1")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions-Single',ESP='Dimensiones-Individual';
                      ToolTipML=ENU='View or edit the single set of dimensions that are set up for the selected record.',ESP='Permite ver o editar el grupo �nico de dimensiones configuradas para el registro seleccionado.';
                      ApplicationArea=Dimensions;
                      RunObject=Page 540;
RunPageLink="Table ID"=CONST(7206974), "No."=FIELD("Code");
                      Image=Dimensions ;
    }
    action("action2")
    {
        AccessByPermission=TableData 348=R;
                      CaptionML=ENU='Dimensions-&Multiple',ESP='Dimensiones-&M�ltiple';
                      ToolTipML=ENU='View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.',ESP='Permite ver o editar dimensiones para un grupo de registros. Se pueden asignar c�digos de dimensi�n a transacciones para distribuir los costes y analizar la informaci�n hist�rica.';
                      ApplicationArea=Dimensions;
                      Image=DimensionSets;
                      
                                
    trigger OnAction()    VAR
                                 ServiceOrderType : Record 7206974;
                                 DefaultDimMultiple : Page 542;
                               begin
                                /*{
                                 SE COMENTA. PREGUNTAR
                                 CurrPage.SETSELECTIONFILTER(ServiceOrderType);
                                 DefaultDimMultiple.SetMultiServiceOrderType(ServiceOrderType);
                                 DefaultDimMultiple.RUNMODAL;
                                 }*/
                               END;


    }

}

}

}
}
  trigger OnInit()    BEGIN
             FunctionQB.AccessToServiceOrder(TRUE);
           END;



    var
      FunctionQB : Codeunit 7207272;

    /*begin
    end.
  
*/
}








