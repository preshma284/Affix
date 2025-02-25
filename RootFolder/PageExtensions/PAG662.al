pageextension 50243 MyExtension662 extends 662//454
{
layout
{
addfirst("factboxes")
{}

}

actions
{


}

//trigger
trigger OnAfterGetRecord()    BEGIN
                       Overdue := Overdue::" ";
                       IF FormatField(Rec) THEN
                         Overdue := Overdue::Yes;

                       RecordIDText := FORMAT(rec."Record ID to Approve",0,1);

                       //CPA 16/03/22: - QB 1.10.27 (Q16730 Roig) Agregar una columna con el n£mero y nombre del proveedor en las pantallas de aprobaciones.
                       ApprovalMgmt.GetCustVendFromRecRef(Rec."Record ID to Approve", CustVendNo, CustVendName);
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           RecRef : RecordRef;
                         BEGIN
                           ShowRecCommentsEnabled := RecRef.GET(rec."Record ID to Approve");
                         END;


//trigger

var
      Usersetup : Record 91;
      Overdue: Option "Yes"," ";
      RecordIDText : Text;
      ShowRecCommentsEnabled : Boolean;
      "--------------------------------------------- QB" : Integer;
      CustVendNo : Text;
      CustVendName : Text;
      ApprovalMgmt : Codeunit 7207354;

    
    

//procedure
Local procedure FormatField(Rec : Record 454) : Boolean;
   begin
     if ( rec.Status IN [rec."Status"::Created,rec."Status"::Open]  )then begin
       if ( Rec."Due Date" < TODAY  )then
         exit(TRUE);

       exit(FALSE);
     end;
   end;

//procedure
}

