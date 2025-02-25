pageextension 50215 MyExtension5116 extends 5116//13
{
layout
{
addafter("Privacy Blocked")
{
    field("QB_VATRegistrationNo";rec."QB VAT Registration No.")
    {
        
                ToolTipML=ENU='Indicates the VAT Registration No. for use in contrats print',ESP='El NIF del vendedor para poder incluirlo en la impresi¢n de los contratos de venta.';
}
} addafter("Invoicing")
{
group("Control1100286000")
{
        
                CaptionML=ESP='Real Estate';
                Visible=seeRE;
group("Control1100286001")
{
        
                CaptionML=ESP='Direcci¢n';
    field("QB_Initials";rec."QB_Initials")
    {
        
}
    field("QB_Address";rec."QB_Address")
    {
        
}
    field("QB_Numero";rec."QB_Numero")
    {
        
}
    field("QB_Escalera";rec."QB_Escalera")
    {
        
}
    field("QB_Piso";rec."QB_Piso")
    {
        
}
    field("QB_Puerta";rec."QB_Puerta")
    {
        
}
    field("QB_Address 2";rec."QB_Address 2")
    {
        
}
    field("QB_Post Code";rec."QB_Post Code")
    {
        
}
    field("QB_City";rec."QB_City")
    {
        
}
    field("QB_County";rec."QB_County")
    {
        
}
    field("QB_Country/Region Code";rec."QB_Country/Region Code")
    {
        
}
}
group("Control1100286029")
{
        
                CaptionML=ESP='Datos Personales';
    field("QB_Apellido 1";rec."QB_Apellido 1")
    {
        
}
    field("QB_Apellido 2";rec."QB_Apellido 2")
    {
        
}
    field("QB_Mobile Phone No.";rec."QB_Mobile Phone No.")
    {
        
}
    field("QB_Mobile Phone No. 2";rec."QB_Mobile Phone No. 2")
    {
        
}
}
group("Control1100286028")
{
        
                CaptionML=ESP='Otros Datos';
    field("QB_Clave de Negocio";rec."QB_Clave de Negocio")
    {
        
}
    field("QB_SalesPerson Type";rec."QB_SalesPerson Type")
    {
        
}
    field("QB_Integration Id";rec."QB_Integration Id")
    {
        
}
    field("QB_Nacionalidad";rec."QB_Nacionalidad")
    {
        
}
    field("QB_Extern Salesperson Type";rec."QB_Extern Salesperson Type")
    {
        
}
    field("QB_Vendor No.";rec."QB_Vendor No.")
    {
        
}
    field("QB_Id CRM";rec."QB_Id CRM")
    {
        
}
    field("QB_trademark";rec."QB_trademark")
    {
        
}
    field("QB_ErrorAdministrator";rec."QB_ErrorAdministrator")
    {
        
}
}
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

                 seeRE := FunctionQB.AccessToRealEstate;
               END;


//trigger

var
      CRMIntegrationManagement : Codeunit 5330;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      "-------------------------------------- RE" : Integer;
      FunctionQB : Codeunit 7207272;
      seeRE : Boolean;

    

//procedure

//procedure
}

