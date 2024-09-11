controladdin "DropAreaControl" {
EVENT ControlAddInReady();
EVENT FileDropBegin(filename : Text);
EVENT FileDrop(data : Text);
EVENT FileDropEnd();
procedure ReadyForData(filename : Text)
}
page 7174655 "Drop Area"
{
Permissions=TableData 7174653=rimd;
    CaptionML=ENU='Upload To Sharepoint',ESP='Subir a Sharepoint';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7174654;
    PageType=CardPart;
    
  layout
{
area(content)
{
    usercontrol("DropArea";"DropAreaControl")
    {
        trigger ControlAddInReady();
    BEGIN
    END;

    trigger FileDropBegin(filename : Text);
    BEGIN
      CLEAR(DropAreaMgt);
      DropAreaMgt.FileDropBegin(filename);
      CurrPage.DropArea.ReadyForData(filename);
    END;

    trigger FileDrop(data : Text);
    BEGIN
      DropAreaMgt.FileDrop(data);
      CurrPage.DropArea.ReadyForData(DropAreaMgt.GetCurrentFilename());
    END;

    trigger FileDropEnd();
    VAR
      vBigTxt : BigText;
      pIdMetadata : Code[20];
      vTitle : Text;
    BEGIN
      //Se informa todo lo necesario para SP
      CLEAR(vBigTxt);
      SendValues(vBigTxt,IdMetadata,vTitle);
      //Proceso de envio:
      DropAreaMgt.FileDropEnd(vTitle,IdMetadata,vBigTxt,pRecordID);

      CurrPage.UPDATE(FALSE);
    END;

        }

}
}actions
{
area(Processing)
{

    action("PreviewListFiles")
    {
        
                      CaptionML=ENU='Preview List Files',ESP='Lista ficheros SP';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Account;
                      PromotedCategory=Process;
                      PromotedOnly=true;
                      
                                trigger OnAction()    VAR
                                 FilesSPlist : Page 7174660;
                                 xRecRefv1 : RecordRef;
                                 RecRefv1 : RecordRef;
                                 DragDropFileFactBox : Record 7174657;
                               BEGIN

                                 xRecRefv1.GETTABLE(vVariant);
                                 RecRefv1.OPEN(xRecRefv1.NUMBER);
                                 IF NOT RecRefv1.GET(xRecRefv1.RECORDID) THEN
                                   EXIT;

                                 CLEAR(FilesSPlist);
                                 DragDropFileFactBox.RESET;
                                 DragDropFileFactBox.SETRANGE("PK RecordID",xRecRefv1.RECORDID);
                                 IF DragDropFileFactBox.FINDSET THEN;
                                 FilesSPlist.fncSetRecordID(xRecRefv1.RECORDID,xRecRefv1.NUMBER);
                                 FilesSPlist.SETTABLEVIEW(DragDropFileFactBox);
                                 FilesSPlist.RUN;
                               END;


    }
    action("OpenSP")
    {
        
                      CaptionML=ENU='Open Sharepoint',ESP='Abrir SP';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Web;
                      PromotedCategory=Process;
                      PromotedOnly=true;
                      
                                
    trigger OnAction()    VAR
                                 FilesSPlist : Page 7174660;
                                 xRecRefv1 : RecordRef;
                                 RecRefv1 : RecordRef;
                                 DragDropFileFactBox : Record 7174657;
                                 SpSiteDef : Record 7174651;
                                 cduDropArea : Codeunit 7174650;
                                 SiteLibrary : Text;
                                 TxtLink : Text;
                                 SPSetup : Record 7174650;
                               BEGIN

                                 xRecRefv1.GETTABLE(vVariant);
                                 RecRefv1.OPEN(xRecRefv1.NUMBER);
                                 IF NOT RecRefv1.GET(xRecRefv1.RECORDID) THEN
                                   EXIT;

                                 SpSiteDef.RESET;
                                 SpSiteDef.SETRANGE(IdTable,xRecRefv1.NUMBER);
                                 SpSiteDef.SETRANGE(Status,SpSiteDef.Status::Released);
                                 SpSiteDef.FINDFIRST;

                                 SiteLibrary := cduDropArea.GetTitleLibrary(SpSiteDef."No.",RecRefv1);

                                 SPSetup.GET;
                                 IF SiteLibrary = '' THEN
                                   SiteLibrary := SPSetup."Library Name Default";

                                 TxtLink := SPSetup."Url Sharepoint" + '/' + SpSiteDef."Main Url" +'/' + SiteLibrary + '/Forms/AllItems.aspx';
                                 HYPERLINK(TxtLink);
                               END;


    }

}
}
  



trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       //EXIT(NOT DropAreaMgt.IsFileDropInProgress());
                     END;



    var
      DropAreaMgt : Codeunit 7174650;
      // AddiInMgt : DotNet "'DropAreaControlAddIn, Version=1.0.0.0, Culture=neutral, PublicKeyToken=b33780e0a1cf8256'.DropAreaControlAddIn.SharepointAddIn";
      vVariant : Variant;
      IdMetadata : Code[20];
      FilterValuesCurrentLibrary : Text;
      TEXT50000 : TextConst ENU='Error, only one option can be selected per Sharepoint tag.',ESP='Error, solo se puede seleccionar una opci�n por etiqueta de Sharepoint.';
      pRecordID : RecordID;
      TEXTOPENLIST : TextConst ENU='"Preview list files                                   "',ESP='"Ver lista ficheros                                  "';

    procedure SETFILTER(vVar : Variant) : Boolean;
    begin
      //Se recoge el par�metro rec de la pagina que vamos a integrar.
      vVariant := vVar;
      FilterValuesCurrentLibrary := '';
    end;

    LOCAL procedure SendValues(var vBigText : BigText;var pIdMetadata : Code[20];var pTitle : Text);
    var
      xRecRef : RecordRef;
      RecRef : RecordRef;
      i : Integer;
      FldRef : FieldRef;
      IsReadable : Boolean;
    begin
      //Proceso que selecciona la definici�n del site SP y rellena una variable con toda la informaci�n del registro en cuesti�n.
      if vVariant.ISRECORD then
        xRecRef.GETTABLE(vVariant)
      ELSE
        xRecRef := vVariant;

      if xRecRef.ISTEMPORARY then
        exit;


      RecRef.OPEN(xRecRef.NUMBER);
      if RecRef.READPERMISSION then begin
        IsReadable := TRUE;
        if not RecRef.GET(xRecRef.RECORDID) then
          exit;
      end;

      pRecordID := RecRef.RECORDID;

      ///Selecci�n estructura site
      SelectIDMetadata(pIdMetadata,RecRef);
      ///T�tulo del site debido a que puede ser un texto fijo o algo variable ("c�digo del cliente, proyecto....")
      pTitle := GetTitleLibrary(pIdMetadata,RecRef);
      ///Se informan los metadatos con el registro seleccionado.
      CreateMetadata(pIdMetadata,vBigText,RecRef,FALSE);
    end;

    LOCAL procedure SelectIDMetadata(var vIdMetadata : Code[20];var xRecRef : RecordRef);
    var
      SPSiteDefinition : Record 7174651;
      xFieldRef : FieldRef;
      Job : Record 167;
    begin
      ///Con el n�mero de tabla ya tenemos la definici�n a utilizar.
      SPSiteDefinition.RESET;
      SPSiteDefinition.SETRANGE(IdTable,xRecRef.NUMBER);
      SPSiteDefinition.SETRANGE(Status,SPSiteDefinition.Status::Released);
      //Q7357 -
      if xRecRef.NUMBER = DATABASE::Job then begin
        Job.GET(xRecRef.RECORDID);
        SPSiteDefinition.SETRANGE("Job Card Type",Job."Card Type");
      end;
      //Q7357 +

      SPSiteDefinition.FINDFIRST;
      vIdMetadata := SPSiteDefinition."No.";
    end;

    procedure CreateMetadata(pNoMetadata : Code[20];var pDicc : BigText;var xRecRef : RecordRef;pBoolTesting : Boolean);
    var
      SPSiteMetadataDefs : Record 7174652;
      LibraryTypesSP : Record 7174654;
      LibraryTypesValuesSP : Record 7174655;
      PagLibraryValues : Page 7174661;
      CurrentLibraryTypeValuesFilter : Text;
      FldRef : FieldRef;
      intField : Integer;
      TxtField : Text[250];
      TxtName : Text[100];
      IntNumberOpt : Integer;
      intno : Boolean;
      dt : Date;
    begin
      //Creaci�n de los metadatos en funci�n del tipo de campo (fijo o variable) indicado en las l�neas.
      SPSiteMetadataDefs.RESET;
      SPSiteMetadataDefs.SETRANGE("Metadata Site Definition", pNoMetadata);
      if SPSiteMetadataDefs.FINDSET then
        repeat
            if SPSiteMetadataDefs."Value Type" = SPSiteMetadataDefs."Value Type"::"Fixed Value" then begin
             IntNumberOpt := SPSiteMetadataDefs."Type Field Sharepoint";
             TxtField :=SPSiteMetadataDefs.Value;

             if SPSiteMetadataDefs."Type Field Sharepoint" =
               SPSiteMetadataDefs."Type Field Sharepoint"::"Short Date" then begin
               if EVALUATE(dt,FORMAT(FldRef.VALUE))then
                 TxtField := FORMAT(dt,0,'<Month,2>/<Day,2>/<Year4>')
               ELSE
                 TxtField := '01/01/2018';
             end;

             if SPSiteMetadataDefs."Type Field Sharepoint" =
               SPSiteMetadataDefs."Type Field Sharepoint"::Boolean then begin
               if EVALUATE(intno,SPSiteMetadataDefs.Value) then begin
                 if intno then
                   TxtField := '1'
                 ELSE
                   TxtField := '0';
               end ELSE
                 TxtField := '0';
             end;

             pDicc.ADDTEXT('[/*/*{' + SPSiteMetadataDefs."Internal Name" + '}*/*/,/*/*{' +SPSiteMetadataDefs.Name + '}*/*/,/*/*{' + TxtField +'}*/*/,/*/*{'+ FORMAT(IntNumberOpt)+'}*/*/]|');
          end ELSE begin
             EVALUATE(intField,SPSiteMetadataDefs.Value);
             FldRef := xRecRef.FIELD(intField);

             ///Necesario para los campos calculados.
             if SPSiteMetadataDefs."Calculate Field" then
               FldRef.CALCFIELD;

             TxtField := FORMAT(FldRef.VALUE);
             if SPSiteMetadataDefs."Type Field Sharepoint" =
               SPSiteMetadataDefs."Type Field Sharepoint"::"Short Date" then begin
               if EVALUATE(dt,FORMAT(FldRef.VALUE))then
                 TxtField := FORMAT(dt,0,'<Month,2>/<Day,2>/<Year4>')
               ELSE
                 TxtField := '01/01/2018';
             end;

             if SPSiteMetadataDefs."Type Field Sharepoint" =
               SPSiteMetadataDefs."Type Field Sharepoint"::Boolean then begin
               if EVALUATE(intno,FORMAT(FldRef.VALUE)) then begin
                 if intno then
                   TxtField := '1'
                 ELSE
                   TxtField := '0';
               end ELSE
                 TxtField := '0';
             end;

             if TxtField <> '' then begin
               IntNumberOpt := SPSiteMetadataDefs."Type Field Sharepoint";
               pDicc.ADDTEXT('[/*/*{' + SPSiteMetadataDefs."Internal Name" + '}*/*/,/*/*{' +SPSiteMetadataDefs.Name + '}*/*/,/*/*{' + TxtField +'}*/*/,/*/*{'+ FORMAT(IntNumberOpt)+'}*/*/]|')
             end;
          end;

        until SPSiteMetadataDefs.NEXT = 0;

      ///Posibilidad de selecci�n de metadatos en funci�n del tipo de documento que se quiere enviar.
      ///Hay metadatos a seleccionar?
      LibraryTypesValuesSP.RESET;
      LibraryTypesValuesSP.SETRANGE("Metadata Site Defs",pNoMetadata);
      LibraryTypesValuesSP.SETFILTER(Value,'<>%1','');
      if LibraryTypesValuesSP.FINDFIRST then begin

        if FilterValuesCurrentLibrary = '' then begin
          ///Se muestra la pagina, solo aparece una vez cuando se suben varios ficheros en una tanda
         CLEAR(PagLibraryValues);
         PagLibraryValues.LOOKUPMODE := TRUE;
         PagLibraryValues.EDITABLE(FALSE);
         PagLibraryValues.SETTABLEVIEW(LibraryTypesValuesSP);
         if PagLibraryValues.RUNMODAL = ACTION::LookupOK then
            CurrentLibraryTypeValuesFilter := PagLibraryValues.GetSelectionFilter;

        end ELSE begin
          CurrentLibraryTypeValuesFilter := FilterValuesCurrentLibrary;
        end;

         ///Siempre que se seleccione uno..
         if CurrentLibraryTypeValuesFilter <> '' then begin
           LibraryTypesValuesSP.RESET;
           LibraryTypesValuesSP.SETRANGE("Metadata Site Defs",pNoMetadata);
           LibraryTypesValuesSP.SETFILTER(Value,CurrentLibraryTypeValuesFilter);
           if LibraryTypesValuesSP.FINDSET then
              repeat

                if (TxtName <> '') and (TxtName = LibraryTypesValuesSP.Name) then
                  ERROR(TEXT50000);

                ///Se busca el campo internal_name
                LibraryTypesSP.RESET;
                LibraryTypesSP.SETRANGE("Metadata Site Defs",pNoMetadata);
                LibraryTypesSP.SETRANGE(Name,LibraryTypesValuesSP.Name);
                LibraryTypesSP.FINDFIRST;

                pDicc.ADDTEXT('[/*{' + LibraryTypesSP."Internal Name" + '}*/,/*{' + LibraryTypesValuesSP.Name + '}*/,/*{' + LibraryTypesValuesSP.Value + '}*/,/*{' + '0' +'}*/]|');

                TxtName := LibraryTypesValuesSP.Name;

              until LibraryTypesValuesSP.NEXT = 0;
              FilterValuesCurrentLibrary := CurrentLibraryTypeValuesFilter;

         end;
      end;

      pDicc.ADDTEXT('|');
    end;

    LOCAL procedure GetTitleLibrary(pNoMetadata : Code[20];var xRecRef : RecordRef) : Text;
    var
      SPSiteDefinition : Record 7174651;
      FldRef : FieldRef;
      intField : Integer;
      TxtField : Text[250];
    begin
      ///T�tulo de la libreria.
      SPSiteDefinition.GET(pNoMetadata);
      if (SPSiteDefinition."Library Title Type" = SPSiteDefinition."Library Title Type"::"Fixed Value") then begin
        exit(SPSiteDefinition."Library Title");
      end ELSE begin
        if SPSiteDefinition."Library Title Type" = SPSiteDefinition."Library Title Type"::"Field Value" then begin
          EVALUATE(intField,SPSiteDefinition."Library Title");
          FldRef := xRecRef.FIELD(intField);
          TxtField := FORMAT(FldRef.VALUE);
          if TxtField <> '' then
            exit(TxtField)
          ELSE
            exit('TEST');
        end;
      end;
    end;

    // begin
    /*{
      QUONEXT 20.07.17 DRAG&DROP. Add-ins para subida de ficheros en Sharepoint.
              Para poder visualizar el control hay que realizar los siguientes pasos:
              Registro en la tabla "Complementos de control" con los siguientes datos - DropAreaControl - b33780e0a1cf8256
              Importar en esa tabla el fichero zip adjunto.
              Subir la libreria a la carpeta addins en el servicio de NAV.
              Probablemente requiera reinicio de servicio NAV.

      Q7357 JDC 13/11/19 - Modified function "SelectIDMetadata"
    }*///end
}








