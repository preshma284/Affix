page 7174340 "SII Configuration"
{
  ApplicationArea=All;

CaptionML=ENU='SII Configuration',ESP='Configuraci�n QuoSII';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=79;
    PageType=Card;
    UsageCategory=Tasks;
    
  layout
{
area(content)
{
group("group22")
{
        
                CaptionML=ENU='QuoSII',ESP='QuoSII';
group("group23")
{
        
                CaptionML=ENU='QuoSII',ESP='General';
    field("QuoSII Activate";rec."QuoSII Activate")
    {
        
    }
    field("QuoSII First date";rec."QuoSII First date")
    {
        
                ToolTipML=ESP='Si se informa, indica la minima fecha de registro de los documentos que se pueden incluir en los documentos a enviar al SII';
    }
    field("QuoSII Nos. Serie SII";rec."QuoSII Nos. Serie SII")
    {
        
                CaptionML=ENU='Nos. Serie SII';
    }
    field("QuoSII VAT Reg. No. Repres.";rec."QuoSII VAT Reg. No. Repres.")
    {
        
    }
    field("QuoSII VAT Type";rec."QuoSII VAT Type")
    {
        
    }
    field("QuoSII REAGYP %";rec."QuoSII REAGYP %")
    {
        
    }
    field("QuoSII Email From";rec."QuoSII Email From")
    {
        
                CaptionML=ENU='Email From',ESP='Correo electr�nico emisor';
    }
    field("QuoSII Email To";rec."QuoSII Email To")
    {
        
                CaptionML=ENU='Email To',ESP='Correo electr�nico receptor';
    }
    field("QuoSII Purch. Invoices Period";rec."QuoSII Purch. Invoices Period")
    {
        
    }
    field("QuoSII Day Periodo Purchase";rec."QuoSII Day Periodo Purchase")
    {
        
    }
    field("QuoSII Not Use Shipment Date";rec."QuoSII Not Use Shipment Date")
    {
        
    }
    field("QuoSII Ignore Messages";rec."QuoSII Ignore Messages")
    {
        
    }
    field("QuoSII Purch.Operation Date";rec."QuoSII Purch.Operation Date")
    {
        
                ToolTipML=ESP='Indica que fecha se usar� como fecha de operaci�n en documentos de compra';
    }
    field("QuoSII Use Auto Date";rec."QuoSII Use Auto Date")
    {
        
    }
    field("Entidad";Entidad)
    {
        
                CaptionML=ESP='Entidad Predeterminada';
                TableRelation="SII Type List Value".Code WHERE ("Type"=CONST("SIIEntity"),"SII Entity"=CONST(''));
                
                            ;trigger OnValidate()    BEGIN
                             IF NOT GeneralLedgerSetup.GET THEN BEGIN
                               GeneralLedgerSetup.INIT;
                               GeneralLedgerSetup.INSERT;
                             END;
                             GeneralLedgerSetup."QuoSII Default SII Entity" := Entidad;
                             GeneralLedgerSetup.MODIFY;
                           END;


    }
    field("QuoSII Send Default Type";rec."QuoSII Send Default Type")
    {
        
    }
    field("QuoSII Send Queue Type";rec."QuoSII Send Queue Type")
    {
        
    }
    field("QuoSII Version";rec."QuoSII Version")
    {
        
    }

}
group("group42")
{
        
                CaptionML=ESP='Enlace AEAT';
    field("QuoSII Use SSL";rec."QuoSII Use SSL")
    {
        
    }
    field("QuoSII Export SII Path";rec."QuoSII Export SII Path")
    {
        
    }
    field("QuoSII Server WS";rec."QuoSII Server WS")
    {
        
    }
    field("QuoSII Port WS";rec."QuoSII Port WS")
    {
        
    }
    field("QuoSII Instance WS";rec."QuoSII Instance WS")
    {
        
    }
    field("QuoSII User WS";rec."QuoSII User WS")
    {
        
    }
    field("QuoSII Pass WS";rec."QuoSII Pass WS")
    {
        
    }
    field("QuoSII Domain WS";rec."QuoSII Domain WS")
    {
        
    }
    field("QuoSII Use Server DLL";rec."QuoSII Use Server DLL")
    {
        
    }
    field("QuoSII Certificate";rec."QuoSII Certificate")
    {
        
                CaptionML=ENU='SII Certificate',ESP='Certificado SII';
                Visible=FALSE ;
    }
    field("ExisteCert";rec."QuoSII Certificate".HASVALUE)
    {
        
                CaptionML=ENU='Exists Cert.',ESP='Existe Certificado';
                Enabled=TRUE;
                Editable=FALSE ;
    }
    field("txtPassCert";txtPassCert)
    {
        
                ExtendedDatatype=Masked;
                CaptionML=ENU='SII Certificate Password',ESP='Contrase�a Certificado SII';
                
                            ;trigger OnValidate()    VAR
                             btPassCert : BigText;
                             outsSIICertPass : OutStream;
                             textEncoded : BigText;
                             convert : DotNet "Convert";
                           BEGIN
                             IF txtPassCert <> '' THEN BEGIN
                               CLEAR(btPassCert);
                               btPassCert.ADDTEXT(txtPassCert);
                               Rec."QuoSII Certificate Password".CREATEOUTSTREAM(outsSIICertPass);
                               btPassCert.WRITE(outsSIICertPass);
                               Rec.MODIFY;
                             END;
                           END;


    }
    field("ExisteFirma";rec."QuoSII Certificate Password".HASVALUE)
    {
        
                CaptionML=ENU='Exists Cert.',ESP='Existe Firma Certificado';
                Enabled=TRUE;
                Editable=FALSE ;
    }

}
group("group56")
{
        
                CaptionML=ESP='Especiales';
    field("QuoSII Admin";rec."QuoSII Admin")
    {
        
    }
    field("QuoSII Dimension Job";rec."QuoSII Dimension Job")
    {
        
    }

}

}

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='P&ayments',ESP='Certificado';
                      Image=Payment ;
    action("ImportCert")
    {
        
                      CaptionML=ENU='Import certificate',ESP='Importar certificado';
                      ToolTipML=ENU='Choose your digital certificate file, and import it. You will need it to send the SII document.',ESP='Elija el archivo de certificado digital e imp�rtelo. Tendr� que enviar el documento SII.';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=UserCertificate;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 ImportCertificate;
                               END;


    }
    action("DeleteCert")
    {
        
                      CaptionML=ENU='Delete certificate',ESP='Eliminar certificado';
                      ToolTipML=ENU='Delete your digital certificate file. SII will be disabled.',ESP='Borre su archivo de certificado digital. Se deshabilitar� SII.';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Delete;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 DeleteCertificate;
                               END;


    }

}
group("group5")
{
        CaptionML=ESP='Configuraci�n B�sica';
                      // ActionContainerType=NewDocumentItems ;
    action("action3")
    {
        CaptionML=ESP='Cargar SII Tipos';
                      Promoted=true;
                      Image=AddAction;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 SIIManagementQS : Codeunit 7174331;
                               BEGIN
                                 SIIManagementQS.CreateSIIType;
                               END;


    }
    action("action4")
    {
        CaptionML=ESP='Activar las Colas';
                      Promoted=true;
                      Image=NewTimesheet;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 //JAV 18/03/22: - QuoSII 1.06.04 Crear y Activar o desactivar las colas
                                 ActivateQueue(FALSE);
                               END;


    }
    action("action5")
    {
        CaptionML=ESP='Configurar SMTP';
                      // RunObject=Page 409;
                      Image=MailSetup ;
    }

}
group("group9")
{
        CaptionML=ESP='Conf. Auxiliares';
                      // ActionContainerType=NewDocumentItems ;
    action("action6")
    {
        CaptionML=ESP='Paises';
                      RunObject=Page 10;
                      Image=CountryRegion ;
    }
    action("action7")
    {
        CaptionML=ESP='Formas de Pago';
                      RunObject=Page 427;
                      Image=Payment ;
    }
    action("action8")
    {
        CaptionML=ESP='Gr.Reg.Cliente';
                      RunObject=Page 110;
                      Image=CustomerGroup ;
    }
    action("action9")
    {
        CaptionML=ESP='Gr.Reg.Proveedor';
                      RunObject=Page 111;
                      Image=IndustryGroups ;
    }
    action("action10")
    {
        CaptionML=ESP='Gr.Reg.IVA neg.';
                      RunObject=Page 470;
                      Image=NumberGroup ;
    }
    action("action11")
    {
        CaptionML=ESP='Gr.Reg.IVA conf.';
                      RunObject=Page 472;
                      Image=PostedVoucherGroup ;
    }
    action("action12")
    {
        CaptionML=ESP='Gr.Reg.Producto';
                      RunObject=Page 313;
                      Image=ItemGroup ;
    }

}
group("group17")
{
        CaptionML=ESP='Conf. Maestros';
                      // ActionContainerType=NewDocumentItems ;
    action("action13")
    {
        CaptionML=ESP='Clientes';
                      RunObject=Page 22;
                      Image=Customer ;
    }
    action("action14")
    {
        CaptionML=ESP='Proveedores';
                      RunObject=Page 27;
                      Image=Vendor ;
    }
    action("action15")
    {
        CaptionML=ESP='Plan Ctas.';
                      RunObject=Page 18;
                      Image=Accounts 
    ;
    }

}

}
}
  trigger OnInit()    VAR
             ApplicationAreaMgmtFacade : Codeunit 9179;
           BEGIN
           END;

trigger OnOpenPage()    VAR
                 ApplicationAreaMgmtFacade : Codeunit 9179;
               BEGIN
                 Rec.RESET;
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;

                 IF GeneralLedgerSetup.GET THEN
                   Entidad := GeneralLedgerSetup."QuoSII Default SII Entity";
               END;

trigger OnClosePage()    VAR
                  ApplicationAreaMgmtFacade : Codeunit 9179;
                BEGIN
                END;



    var
      txtPassCert : Text[300];
      Entidad : Code[20];
      GeneralLedgerSetup : Record 98;
      CATCODE : TextConst ESP='QuoSII';
      CATDESCR : TextConst ESP='Tareas QuoSII';

    procedure ImportCertificate();
    var
      TempBlob : Codeunit "Temp Blob";
      EmptyTempBlob : Codeunit "Temp Blob";
      Instr: InStream;
      Blob: OutStream;
      FileManagement : Codeunit 419;
      TaxpayerCertificateImportedMsg : TextConst ENU='The taxpayer certificate has been successfully imported.',ESP='El certificado de contribuyente se ha importado correctamente.';
      CerFileFilterExtensionTxt : TextConst ENU='All Files (*.*)|*.*',ESP='Todos los archivos (*.*)|*.*';
      CerFileFilterTxt : TextConst ENU='cer p12 crt pfx',ESP='cer p12 crt pfx';
      ImportFileTxt : TextConst ENU='Select a file to import',ESP='Seleccionar un archivo para importar';
      ImportCertificate : Boolean;
      TaxpayerCertificateDuplicatedMsg : TextConst ENU='There is already a certificate loaded on the system. Do you want to overwrite it?',ESP='Existe un certificado cargado en el sistema. �Desea sobreescribirlo?';
    begin
      if FileManagement.BLOBImportWithFilter(TempBlob,ImportFileTxt,'',CerFileFilterExtensionTxt,CerFileFilterTxt) = '' then
        exit;
      //QuoSII.B9.begin
      ImportCertificate := TRUE;
      if rec."QuoSII Certificate".HASVALUE then
        if not CONFIRM(TaxpayerCertificateDuplicatedMsg) then
          ImportCertificate := FALSE;

      if ImportCertificate then begin
        if rec."QuoSII Certificate".HASVALUE then begin
          // EmptyTempBlob.INIT;
          Clear(EmptyTempBlob);
          // rec."QuoSII Certificate" := EmptyTempBlob.Blob;
          EmptyTempBlob.CREATEINSTREAM(InStr, TextEncoding::Windows);
            InStr.Read(rec."QuoSII Certificate");
          Rec.MODIFY(TRUE);
        end;
        
        // rec."QuoSII Certificate" := TempBlob.Blob;
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        Instr.Read(rec."QuoSII Certificate");  

        Rec.CALCFIELDS("QuoSII Certificate");
        Rec.MODIFY(TRUE);

        MESSAGE(TaxpayerCertificateImportedMsg);
      end;
      //QuoSII.B9.end
    end;

    procedure DeleteCertificate();
    var
      EmptyTempBlob : Codeunit "Temp Blob";
      Blob: OutStream;
      InStr: InStream;
      TaxpayerCertificateDeletedMsg : TextConst ENU='Certificate was deleted',ESP='El certificado se elimin� del sistema';
    begin
      if rec."QuoSII Certificate".HASVALUE then begin
        // EmptyTempBlob.INIT;
        Clear(EmptyTempBlob);
        // rec."QuoSII Certificate" := EmptyTempBlob.Blob;
        EmptyTempBlob.CREATEINSTREAM(InStr, TextEncoding::Windows);
            InStr.Read(rec."QuoSII Certificate");
        Rec.MODIFY(TRUE);
      end;
      if rec."QuoSII Certificate Password".HASVALUE then begin
        Clear(EmptyTempBlob);
        // EmptyTempBlob.INIT;
        // rec."QuoSII Certificate Password" := EmptyTempBlob.Blob;
        EmptyTempBlob.CREATEINSTREAM(InStr, TextEncoding::Windows);
            InStr.Read(rec."QuoSII Certificate Password");
        Rec.MODIFY(TRUE);
      end;
      //QuoSII.B9.begin
      MESSAGE(TaxpayerCertificateDeletedMsg);
      //QuoSII.B9.end
    end;

    procedure ActivateQueue(ForceStop : Boolean);
    var
      JobQueueEntry : Record 472;
      ForceStart : Boolean;
    begin
      //JAV 18/03/22: - QuoSII 1.06.04 Crear y Activar o desactivar las colas
      ForceStart := FALSE;
      ForceStart := ForceStart or CreateOne(7174334, 040000T);
      ForceStart := ForceStart or CreateOne(7174335, 050000T);

      JobQueueEntry.RESET;
      JobQueueEntry.SETRANGE("Job Queue Category Code", CATCODE);
      if (JobQueueEntry.FINDSET(TRUE)) then
        repeat
          //Tiene prioridad el parar las colas, luego activarlas, luego cambiar seg�n su estado
          if (ForceStop) then
            JobQueueEntry.SetStatus(JobQueueEntry.Status::"On Hold")
          ELSE if (ForceStart) then
            JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready)
          ELSE if (JobQueueEntry.Status = JobQueueEntry.Status::Ready) then begin
            JobQueueEntry.SetStatus(JobQueueEntry.Status::"On Hold");
            ForceStop := TRUE;       //Pararlas todas
          end ELSE if (JobQueueEntry.Status = JobQueueEntry.Status::"On Hold") then begin
            JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
            ForceStart := TRUE;      //Activarlas todas
          end;

          JobQueueEntry.MODIFY(FALSE);
        until (JobQueueEntry.NEXT = 0);

      if (ForceStop) then
        MESSAGE('Colas de env�o al SII Desactivadas')
      ELSE
        MESSAGE('Colas de env�o al SII Activadas');
    end;

    LOCAL procedure CreateOne(pNro : Integer;pTime : Time) : Boolean;
    var
      JobQueueEntry : Record 472;
      JobQueueCategory : Record 471;
    begin
      //JAV 18/03/22: - QB 1.10.25 Crear una entrada en la cola de proyecto para el QuoSII

      //Crear la categor�a si no existe
      if (not JobQueueCategory.GET(CATCODE)) then begin
        JobQueueCategory.Code := CATCODE;
        JobQueueCategory.Description := CATDESCR;
        JobQueueCategory.INSERT;
      end;

      //Crear la entrada
      if not JobQueueEntry.FindJobQueueEntry(JobQueueEntry."Object Type to Run"::Report, pNro) then begin
        JobQueueEntry.InitRecurringJob(24 * 60); //Esto es una vez al d�a

        JobQueueEntry."User ID" := USERID;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Report;
        JobQueueEntry.VALIDATE("Object ID to Run", pNro);
        JobQueueEntry."Job Queue Category Code" := CATCODE;
        JobQueueEntry."Report Output Type" := JobQueueEntry."Report Output Type"::"None (Processing only)";
        JobQueueEntry."Starting Time" := pTime;
        exit(JobQueueEntry.INSERT(TRUE));
      end;

      exit(FALSE);
    end;

    // begin
    /*{
      QuoSII_1.3.03.006 21/11/17 MCM - Se incluye el campo para importarlo como Fecha de Registro contable
      QuoSII_1.4.92.999 21/08/19 QMD - Controles del QuoSII en BBDD que no lo necesitan --> A�adir nuevo campo.
      2002 09/06/20 CHP: QuoSII PBI 14603, se a�ade el campo "Use SSL"
      JAV 15/09/21: - QuoSII 1.5z Se a�ade el capo rec."QuoSII Dimension Job"


      To-Do: Pasar el campo de configuraci�n de contabilidad para que est� junto al resto de la configuraci�n
    }*///end
}









