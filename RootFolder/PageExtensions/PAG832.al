pageextension 50279 MyExtension832 extends 832//832
{
layout
{
addafter("Response")
{
    field("QB_CustVendNo";"CustVendNo")
    {
        
                CaptionML=ENU='Cust/Vend Name',ESP='Cliente/Proveedor';
}
    field("QB_CustVendName";"CustVendName")
    {
        
                CaptionML=ENU='Cust/Vend Name',ESP='Nombre Cliente/Proveedor';
}
}

}

actions
{


}

//trigger
trigger OnAfterGetRecord()    BEGIN
                       RecordIDText := FORMAT(rec."Record ID",0,1);

                       //CPA 16/03/22: Q16730 - Agregar una columna con el n£mero y nombre del proveedor en las pantallas de aprobaciones.
                       ApprovalMgmt.GetCustVendFromRecRef(Rec."Record ID", CustVendNo, CustVendName);
                     END;


//trigger

var
      RecordIDText : Text;
      "--------------------------------------------- QB" : Integer;
      CustVendNo : Text;
      CustVendName : Text;
      ApprovalMgmt : Codeunit 7207354;

    

//procedure
//procedure Setfilters(RecordIDValue : RecordID);
//    begin
//      Rec.SETRANGE("Record ID",RecordIDValue);
//    end;

//procedure
}

