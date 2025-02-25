pageextension 50276 MyExtension72 extends 72//152
{
layout
{
addafter("Name")
{
    field("Cod. C.A. Direct Cost";rec."Cod. C.A. Direct Cost")
    {
        
}
    field("Cod. C.A. Indirect Cost";rec."Cod. C.A. Indirect Cost")
    {
        
}
}


modify("No.")
{
ToolTipML=ENU='Specifies the number of the involved entry or record, according to the specified number series.',ESP='Especifica el número de la entrada o el registro relacionado, según la serie numérica especificada.';


}


modify("Name")
{
ToolTipML=ENU='Specifies a short description of the resource group.',ESP='Especifica una descripción breve del grupo de recursos.';


}

}

actions
{
addafter("Prices")
{
    action("QB_GetTransferCost")
    {
        CaptionML=ENU='Transfer Cost',ESP='Precios cesión';
                      Visible=FALSE;
                      Image=CalculateCost;
                      Promoted =true;
                      PromotedCategory=Process;
}
}


modify("Statistics")
{
ToolTipML=ENU='View statistical information, such as the value of posted entries, for the record.',ESP='Permite ver información estadística del registro, como el valor de los movimientos registrados.';


}


modify("Dimensions-Single")
{
ToolTipML=ENU='View or edit the single set of dimensions that are set up for the selected record.',ESP='Permite ver o editar el grupo único de dimensiones configuradas para el registro seleccionado.';


}


modify("Dimensions-&Multiple")
{
ToolTipML=ENU='View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.',ESP='Permite ver o editar dimensiones para un grupo de registros. Se pueden asignar códigos de dimensión a transacciones para distribuir los costes y analizar la información histórica.';


}


modify("Costs")
{
ToolTipML=ENU='View or change detailed information about costs for the resource.',ESP='Permite ver o cambiar la información detallada sobre los costes del recurso.';


}


modify("Res. Group All&ocated per Job")
{
CaptionML=ENU='Res. Group All&ocated per Job',ESP='A&signación fams. recursos';


}


modify("Res. Group Allocated per Service &Order")
{
ToolTipML=ENU='View the service order allocations of the resource group.',ESP='Permite ver la asignación de pedidos de servicio del grupo de recursos.';


}

}

//trigger

//trigger

var


//procedure

//procedure
}

