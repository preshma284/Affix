pageextension 50115 MyExtension118 extends 118//98
{
layout
{
addafter("General")
{
group("QuoSII_Group")
{
        
                CaptionML=ENU='QuoBuilding',ESP='QuoSII';
                Visible=vQuoSII;
    field("QuoSII Default SII Entity";rec."QuoSII Default SII Entity")
    {
        
                Visible=vQuoSII ;
}
}
} addafter("Discount Calculation")
{
    field("Unit-Amount Rounding Precision";rec."Unit-Amount Rounding Precision")
    {
        
                ApplicationArea=Basic,Suite;
}
    field("Amount Rounding Precision";rec."Amount Rounding Precision")
    {
        
                ApplicationArea=Basic,Suite;
}
}

}

actions
{


}

//trigger

//trigger

var
      Text001 : TextConst ENU='Do you want to change all open entries for every customer and vendor that are not blocked?',ESP='¨Quiere cambiar todos los movs. pend. de cada cliente y proveedor que no est‚n bloqueados?';
      Text002 : TextConst ENU='if you delete the additional reporting currency, future general ledger entries are posted in LCY only. Deleting the additional reporting currency does not affect already posted general ledger entries.\\Are you sure that you want to delete the additional reporting currency?',ESP='Si elimina la divisa adicional, los movimientos futuros se registrar n solo en la divisa local. Si elimina la divisa adicional, no se ven afectados los movimientos ya registrados.\\¨Est  seguro de que desea eliminar la divisa adicional?';
      Text003 : TextConst ENU='if you change the additional reporting currency, future general ledger entries are posted in the new reporting currency and in LCY. To enable the additional reporting currency, a batch job opens, and running the batch job recalculates already posted general ledger entries in the new additional reporting currency.\Entries will be deleted in the Analysis View if it is unblocked, and an update will be necessary.\\Are you sure that you want to change the additional reporting currency?',ESP='Si cambia la divisa adicional, los movimientos futuros se registran en la divisa nueva y en la divisa local. Para habilitar la divisa adicional, se abre un trabajo por lotes y si ejecuta este trabajo por lotes, se recalculan los movimientos de contabilidad ya registrados en la nueva divisa adicional.\Los movimientos se eliminar n de la vista de an lisis si esta est  desbloqueada y ser  necesario realizar una actualizaci¢n.\\¨Est  seguro de que desea cambiar la divisa adicional?';
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    

//procedure

//procedure
}

