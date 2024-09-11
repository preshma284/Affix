page 7174337 "SII Document Ship Card"
{
CaptionML=ENU='SII Document Ship Card',ESP='SII Ficha Env�os';
    SourceTable=7174335;
    PageType=Document;
    RefreshOnActivate=true;
    PromotedActionCategoriesML=ESP='Nuevo,Proceso,Informe,4,5,6,7,8,Errores,SII';
    
  layout
{
area(content)
{
group("General")
{
        
    field("Ship No.";rec."Ship No.")
    {
        
    }
    field("Shipment DateTime";rec."Shipment DateTime")
    {
        
    }
    field("Shipment Status";rec."Shipment Status")
    {
        
    }
    field("AEAT Status";rec."AEAT Status")
    {
        
                Editable=FALSE ;
    }
    field("Document Type";rec."Document Type")
    {
        
    }
    field("Shipment Type";rec."Shipment Type")
    {
        
                CaptionML=ENU='Shipment Type',ESP='Tipo Env�o';
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Base Imponible Total";"BaseImponibleTotal")
    {
        
                Editable=False ;
    }
    field("Importe IVA Total";"ImporteIVATotal")
    {
        
                Editable=FALSE ;
    }
    field("Tipo Entorno";rec."Tipo Entorno")
    {
        
    }
    field("SII Entity";rec."SII Entity")
    {
        
    }

}
    part("SIIDocumentShipLine";7174335)
    {
        SubPageLink="Ship No."=FIELD("Ship No.");
    }

}
area(FactBoxes)
{
    part("part2";7174338)
    {
        SubPageLink="Ship No."=FIELD("Ship No.");
    }

}
}actions
{
area(Processing)
{
//CaptionML=ESP='SII Actions';
    action("action1")
    {
        CaptionML=ENU='Answers Log',ESP='Hist�rico de respuestas';
                      RunObject=Page 7174338;
RunPageLink="Ship No."=FIELD("Ship No.");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=ErrorLog;
                      PromotedCategory=Category10 ;
    }
    action("action2")
    {
        CaptionML=ENU='Obtener Documentos',ESP='Obtener Documentos';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 SIIDocumentsLines : Page 7174339;
                                 SIIDocuments : Record 7174333;
                               BEGIN
                                 //QuoSII1.4.04.begin
                                 IF rec."Document Type" = rec."Document Type"::" " THEN
                                   ERROR(Text001,Rec.FIELDCAPTION("Document Type"));

                                 IF rec."Shipment Type" = '' THEN
                                   ERROR(Text001,Rec.FIELDCAPTION("Shipment Type"));
                                 //QuoSII1.4.04.end
                                 CLEAR(SIIDocumentsLines);
                                 SIIDocuments.RESET;
                                 SIIDocuments.SETCURRENTKEY("Document Type","Is Emited");
                                 SIIDocuments.SETRANGE("Document Type",Rec."Document Type");
                                 //QuoSII1.4.04.begin
                                 SIIDocuments.SETRANGE("Is Emited",Rec."Shipment Type" IN ['A1','B0']); //A1 es la clave para modificar facturas
                                 IF Rec."Shipment Type" = 'B0' THEN
                                   SIIDocuments.SETRANGE("AEAT Status", 'CORRECTO');
                                 //QuoSII1.4.04.end
                                 SIIDocuments.SETRANGE("SII Entity",Rec."SII Entity");//QuoSII_1.4.02.042

                                 //JAV 08/09/22: - QuoSII 1.06.12 No incluyo cancelaciones de operaciones de Reg.Esp. 15 en los env�os normales
                                 SIIDocuments.FILTERGROUP(2);
                                 SIIDocuments.SETFILTER("OTS Type", '<>%1', SIIDocuments."OTS Type"::Cancelation);
                                 SIIDocuments.FILTERGROUP(0);

                                 SIIDocumentsLines.LOOKUPMODE := TRUE;
                                 SIIDocumentsLines.SETTABLEVIEW(SIIDocuments);
                                 SIIDocumentsLines.SetShipNo(Rec."Ship No.");
                                 IF SIIDocumentsLines.RUNMODAL IN [ACTION::OK,ACTION::LookupOK,ACTION::Yes] THEN;
                               END;


    }
    action("action3")
    {
        CaptionML=ENU='Obtener Documentos',ESP='Env�o C-14/T-15';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 SIIDocumentsLines : Page 7174339;
                                 SIIDocuments : Record 7174333;
                               BEGIN
                                 //JAV 29/06/21 Nuevo bot�n para incluir documentos C-14 en los env�os
                                 rec."Document Type" := rec."Document Type"::CE;
                                 rec."Shipment Type" := 'A0';        //El documento no se ha enviado nunca, por tanto para los filtros debe ser un A0.
                                 Rec.MODIFY;                         //La pantalla lo vuelve a leer por lo que tengo que guardalo
                                 COMMIT;                         //Por el Rec.MODIFY y el RunModal

                                 SIIDocuments.RESET;
                                 SIIDocuments.SETCURRENTKEY("Document Type","Is Emited");
                                 SIIDocuments.SETRANGE("Is Emited", FALSE);
                                 SIIDocuments.SETRANGE("AEAT Status", '');
                                 SIIDocuments.SETRANGE("SII Entity",Rec."SII Entity");

                                 //JAV 08/09/22: - QuoSII 1.06.12 Incluyo cancelaciones de operaciones de Reg.Esp. 14 en este tipo de env�o
                                 SIIDocuments.SETRANGE("Document Type", rec."Document Type"::CE);
                                 IF (SIIDocuments.FINDSET) THEN
                                   REPEAT
                                     SIIDocuments.MARK(TRUE);
                                   UNTIL (SIIDocuments.NEXT = 0);

                                 //JAV 08/09/22: - QuoSII 1.06.12 Incluyo cancelaciones de operaciones de Reg.Esp. 15 en este tipo de env�o
                                 SIIDocuments.SETRANGE("OTS Type", SIIDocuments."OTS Type"::Cancelation);
                                 SIIDocuments.SETRANGE("Document Type", rec."Document Type"::FE);
                                 IF (SIIDocuments.FINDSET) THEN
                                   REPEAT
                                     SIIDocuments.MARK(TRUE);
                                   UNTIL (SIIDocuments.NEXT = 0);

                                 //Eliminar los filtros de cada tipo y sacar todos los marcados
                                 SIIDocuments.SETRANGE("OTS Type");
                                 SIIDocuments.SETRANGE("Document Type");
                                 SIIDocuments.MARKEDONLY(TRUE);

                                 CLEAR(SIIDocumentsLines);
                                 SIIDocumentsLines.LOOKUPMODE := TRUE;
                                 SIIDocumentsLines.SETTABLEVIEW(SIIDocuments);
                                 SIIDocumentsLines.SetShipNo(Rec."Ship No.");
                                 IF SIIDocumentsLines.RUNMODAL IN [ACTION::OK,ACTION::LookupOK,ACTION::Yes] THEN;

                                 rec."Document Type" := rec."Document Type"::FE;   //JAV 22/07/21 - QuoSII 1.5w Debe ser de tipo Factura Emitida
                                 rec."Shipment Type" := 'A1';                  //Tras meter los documentos, lo paso a un A1 que es lo necesario para subir al SII.
                                 Rec.MODIFY;

                                 //JAV 08/07/21: - QuoSII 1.5v Al incluir l�neas de tipo C-14, el estado debe ser correcto para que se env�en como A1.
                                 SIIDocumentShipmentLine.RESET;
                                 SIIDocumentShipmentLine.SETRANGE("Ship No.", rec."Ship No.");
                                 SIIDocumentShipmentLine.SETFILTER("AEAT Status", '%1', '');
                                 SIIDocumentShipmentLine.MODIFYALL("AEAT Status", 'CORRECTO');
                               END;


    }
group("group5")
{
        CaptionML=ENU='Env�o',ESP='Env�o';
                      // ActionContainerType=NewDocumentItems ;
    action("action4")
    {
        CaptionML=ENU='Exporta Fichero SII',ESP='Exporta Fichero SII';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=ExportElectronicDocument;
                      PromotedCategory=Category10;
                      
                                trigger OnAction()    VAR
                                 SIIManagement : Codeunit 7174331;
                               BEGIN
                                 //IF UPPERCASE(Rec."AEAT Status") <> 'CORRECTO' THEN
                                 //QuoSII1.4.04.begin
                                 IF rec."Document Type" = rec."Document Type"::" " THEN
                                   ERROR(Text001,Rec.FIELDCAPTION("Document Type"));

                                 IF rec."Shipment Type" = '' THEN
                                   ERROR(Text001,Rec.FIELDCAPTION("Shipment Type"));
                                 //QuoSII1.4.04.end

                                 SIIManagement.ExportShipmentFile(Rec."Ship No.");
                               END;


    }
    action("Procesar")
    {
        
                      CaptionML=ENU='Procesar',ESP='Procesar';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=TransmitElectronicDoc;
                      PromotedCategory=Category10;
                      
                                trigger OnAction()    VAR
                                 SIIManagement : Codeunit 7174331;
                               BEGIN
                                 //QuoSII1.4.04.begin
                                 IF rec."Document Type" = rec."Document Type"::" " THEN
                                   ERROR(Text001,Rec.FIELDCAPTION("Document Type"));

                                 IF rec."Shipment Type" = '' THEN
                                   ERROR(Text001,Rec.FIELDCAPTION("Shipment Type"));
                                 //QuoSII1.4.04.end

                                 SIIManagement.ProcessShipment(Rec."Ship No.", 0, rec."Tipo Entorno");
                                 CurrPage.UPDATE;
                                 CurrPage.SIIDocumentShipLine.PAGE.ACTIVATE;
                               END;


    }
    action("Validar")
    {
        
                      Promoted=false;
                      Image=ValidateEmailLoggingSetup;
                      
                                
    trigger OnAction()    VAR
                                 SIIManagement : Codeunit 7174331;
                               BEGIN
                                 SIIManagement.FieldsValidations(rec."Ship No.");
                               END;


    }

}

}
}
  trigger OnAfterGetRecord()    begin
                       /*{IF rec."Shipment Type" = 'A0' THEN
                         SendEditable := UPPERCASE(rec."AEAT Status") <> 'CORRECTO'
                       ELSE
                         SendEditable := UPPERCASE(rec."AEAT Status") <> 'INCORRECTO';}*/

                       //QUOSII.Envios
                       CLEAR(BaseImponibleTotal);
                       CLEAR(ImporteIVATotal);
                       SIIDocumentShipmentLine.SETRANGE("Ship No.",rec."Ship No.");
                       IF SIIDocumentShipmentLine.FINDSET THEN
                         REPEAT
                           SIIDocumentShipmentLine.CALCFIELDS("Base Imponible","Importe IVA");
                           BaseImponibleTotal += SIIDocumentShipmentLine."Base Imponible";
                           ImporteIVATotal += SIIDocumentShipmentLine."Importe IVA";
                         UNTIL SIIDocumentShipmentLine.NEXT = 0;
                       //QUOSII.Envios
                     END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  //JAV 14/05/21: - QuoSII 1.5l El entorno por defecto para el env�o ser� el configurado
                  SIISetup.GET;
                  rec."Tipo Entorno" := SIISetup."QuoSII Send Default Type";
                  rec."Shipment Type":= 'A0';
                  rec."Shipment Type Name" := SIITypeListValue.GetDocumentName(1,rec."Shipment Type");
                END;



    var
      SIISetup : Record 79;
      SendEditable : Boolean ;
      BaseImponibleTotal : Decimal;
      ImporteIVATotal : Decimal;
      SIIDocumentShipmentLine : Record 7174336;
      Text001 : TextConst ESP='Debe seleccionar un valor en el campo %1.';
      SIITypeListValue : Record 7174331;/*

    begin
    {
      QuoSII1.4.04 18/04/2018 MCM
      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci�n de enviar a la ATCN
      JAV 08/09/22: - QuoSII 1.06.12 No incluyo cancelaciones de operaciones de Reg.Esp. 15 en los env�os normales
                                     Cambio la forma de incluir operaciones de cancelaci�n para Reg.Esp. 14 e incluyo los del 15 en los env�os de cancelaci�n
    }
    end.*/
  

}








