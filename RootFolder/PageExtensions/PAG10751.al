pageextension 50104 MyExtension10751 extends 10751//10751
{
layout
{
// addafter("Auto Missing Entries Check")
// {
//     field("Include ImporteTotal";rec."Include ImporteTotal")
//     {
        
//                 ToolTipML=ENU='Specifies whether the ImporteTotal XML node must be exported to the XML file.',ESP='Especifica si el nodo ImporteTotal XML debe exportarse al archivo XML.';
//                 ApplicationArea=All;
// }
// } addafter("CollectionInCashEndpointUrl")
// {
//     field("SuministroInformacion Schema";rec."SuministroInformacion Schema")
//     {
        
//                 ToolTipML=ENU='Specifies the target URL to the SuministroInformacion XSD schema.',ESP='Especifica la direcci¢n URL de destino del esquema XSD de SuministroInformacion.';
//                 ApplicationArea=All;
// }
//     field("SuministroLR Schema";rec."SuministroLR Schema")
//     {
        
//                 ToolTipML=ENU='Specifies the target URL to the SuministroLR XSD schema.',ESP='Especifica la direcci¢n URL de destino del esquema XSD de SuministroLR.';
//                 ApplicationArea=All;
// }
// }


modify("Auto Missing Entries Check")
{
ToolTipML=ENU='Specifies that the system will detect whether SII entries are missing.',ESP='Especifica que el sistema detectar  si faltan movimientos de SII.';


}

}

actions
{
addafter("ShowRequestHistory")
{
    action("QB_Activate")
    {
        
                      CaptionML=ESP='Activar';
                      Visible=seeAdmin;
                      Image=Confirm;
                      
                                
    trigger OnAction()    VAR
                                 SIIProcesing : Codeunit 7174332;
                               BEGIN
                                 Rec.Enabled := TRUE;  //No puedo usar Validate porque solo funciona con un certificado asociado
                                 Rec.MODIFY(FALSE);

                                 SIIProcesing.T10751_ValidateEnabled(Rec);  //JAV 22/03/22: - QuoSII 1.06.05 Verificar si el QuoSII est  activo
                               END;


}
}

}

//trigger
trigger OnOpenPage()    BEGIN
                 Rec.RESET;
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT(TRUE);
                 END;
                 rec.SetDefaults;

                 //JAV 28/02/22: - QB 1.10.21 Activar el QuoSII sin certificado, solo para administradores de QB
                 seeAdmin := FunctionQB.IsQBAdmin;
               END;
trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       //JAV 28/02/22: - QB 1.10.21 Activar el QuoSII sin certificado, solo para administradores de QB
                       IF seeAdmin THEN
                         EXIT;

                       IF rec.IsEnabled AND (CloseAction = ACTION::OK) THEN
                         rec.ValidateCertificatePassword;
                     END;


//trigger

var
      CertificateHasValue : Boolean ;
      InitialUploadQst : TextConst ENU='Do you want to transmit all documents from the 1st of Janurary 2017 to the 30th of June 2017?',ESP='¨Desea transmitir todos los documentos desde el 1 de enero de 2017 al 30 de junio de 2017?';
      "----------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      seeAdmin : Boolean;

    

//procedure

//procedure
}

