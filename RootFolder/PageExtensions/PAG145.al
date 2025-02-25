pageextension 50137 MyExtension145 extends 145//120
{
layout
{
addafter("No.")
{
    field("QB_VendorShipmentNo";rec."Vendor Shipment No.")
    {
        
}
} addafter("Shipment Method Code")
{
    field("QB_JobNo";rec."Job No.")
    {
        
                CaptionML=ENU='Job',ESP='Proyecto';
                ToolTipML=;
                Visible=TRUE ;
}
    field("QB_JobDescription";"JobDescription")
    {
        
                CaptionML=ENU='Description',ESP='Descripci¢n Proyecto';
}
    field("QB_ReceiveInFRIS";rec."Receive in FRIS")
    {
        
}
    field("QB Have Proforms";rec."QB Have Proforms")
    {
        
}
    field("QB_Cancelled";rec."Cancelled")
    {
        
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 OfficeMgt : Codeunit 1630;
                 HasFilters : Boolean;
               BEGIN
                 HasFilters := Rec.GETFILTERS <> '';
                 rec.SetSecurityFilterOnRespCenter;
                 IF HasFilters THEN
                   IF Rec.FINDFIRST THEN;
                 IsOfficeAddin := OfficeMgt.IsAvailable;

                 //JAV 06/07/19: - Se filtran los cancelados por defecto
                 Rec.SETRANGE("Cancelled", FALSE);
               END;
trigger OnAfterGetRecord()    BEGIN
                       JobDescription := '';
                       IF Job.GET(Rec."Job No.") THEN
                         JobDescription := Job.Description;
                     END;


//trigger

var
      IsOfficeAddin : Boolean;
      "-------------------------- QB" : Integer;
      Job : Record 167;
      JobDescription : Text;

    

//procedure

//procedure
}

