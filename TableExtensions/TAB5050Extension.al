tableextension 50187 "QBU ContactExt" extends "Contact"
{

    /*
  Permissions=TableData 36 rm,
                  TableData 5051 rd,
                  TableData 5052 rd,
                  TableData 5054 rd,
                  TableData 5056 rd,
                  TableData 5058 rd,
                  TableData 5060 rd,
                  TableData 5061 rd,
                  TableData 5065 rm,
                  TableData 5067 rd,
                  TableData 5080 rm,
                  TableData 5089 rd,
                  TableData 5092 rm,
                  TableData 5093 rm;
  */
    DataCaptionFields = "No.", "Name";
    CaptionML = ENU = 'Contact', ESP = 'Contacto';
    LookupPageID = "Contact List";
    DrillDownPageID = "Contact List";

    fields
    {
        field(7207400; "Category"; Code[20])
        {
            TableRelation = "TAux General Categories" WHERE("Use In" = FILTER('All' | 'Contacts'));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Category', ESP = 'Categor�a';
            Description = 'QB 1-0 - KALAM GAP006  OJO- Hace un transferfields de vendor a contact, hay que respetar las numeraciones, reservamos 720740..7207459 para campos de contacto';


        }
        field(7207401; "Tipo Referente"; Code[10])
        {
            TableRelation = "Referent Types";


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo de Referente';
            Description = 'QB 1-0 - QBA 18/02/19 JAV - Campo de tipo de contacto    JAV 21/09/19: - pasa de option a una tabla aparte';

            trigger OnValidate();
            BEGIN
                //JAV 18/02/19: - Campo de tipo de contacto
                //JAV 19/09/19: - Si no se ha definido una dimensi�n para los referentes, no se procesan las mismas
                //JAV 21/09/19: - Mejora en el uso de la dimensi�n asociada al referente

                IF (FunctionQB.QB_UseReferents) AND (FunctionQB.ReturnDimReferents <> '') THEN BEGIN
                    IF (xRec."Tipo Referente" <> "Tipo Referente") THEN BEGIN
                        IF (Type = Type::Company) THEN BEGIN
                            DimensionValue.RESET;
                            DimensionValue.SETRANGE("Dimension Code", FunctionQB.ReturnDimReferents);
                            DimensionValue.SETRANGE(Code, "Tipo Referente", "Tipo Referente" + '-999');
                            DimensionValue.DELETEALL(TRUE);
                        END ELSE BEGIN
                            IF (DimensionValue.GET(FunctionQB.ReturnDimReferents, "Valor Dimension")) THEN
                                DimensionValue.DELETE(TRUE);
                        END;
                        VALIDATE("Valor Dimension", '')
                    END ELSE
                        VALIDATE("Valor Dimension");
                END;
            END;


        }
        field(7207402; "Valor Dimension"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Dimension Code" = CONST('CLIENTES'),
                                                                                               "Dimension Value Type" = CONST("Standard"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Valor Dimensi�n';
            Description = 'QB 1-0 - QBA 18/02/19 JAV - Campo de valor de dimensi�n asociada';

            trigger OnValidate();
            VAR
                //                                                                 newCode@1100286000 :
                newCode: Code[20];
            BEGIN
                //JAV 18/02/19: - Campo de valor de dimensi�n asociada
                //JAV 19/09/19: - Si no se ha definido una dimensi�n para los referentes, no se procesan las mismas
                //JAV 21/09/19: - Mejora en el uso de la dimensi�n asociada al referente

                IF (NOT FunctionQB.QB_UseReferents) OR (FunctionQB.ReturnDimReferents = '') THEN
                    "Valor Dimension" := ''
                ELSE BEGIN
                    IF ("Tipo Referente" = '') THEN
                        "Valor Dimension" := ''
                    ELSE BEGIN
                        IF ("Valor Dimension" = '') THEN BEGIN
                            //Tipo empresa, crea valores para inicio y totales de la empresa
                            IF (Type = Type::Company) THEN BEGIN
                                DimensionValue.RESET;
                                DimensionValue.SETRANGE("Dimension Code", FunctionQB.ReturnDimReferents);
                                DimensionValue.SETRANGE("Dimension Value Type", DimensionValue."Dimension Value Type"::"Begin-Total");
                                DimensionValue.SETRANGE(Code, "Tipo Referente" + '000', "Tipo Referente" + '999');
                                IF (DimensionValue.FINDLAST) THEN
                                    newCode := INCSTR(DimensionValue.Code)
                                ELSE
                                    newCode := "Tipo Referente" + '001';

                                DimensionValue.INIT;
                                DimensionValue."Dimension Code" := FunctionQB.ReturnDimReferents;
                                DimensionValue.Code := newCode;
                                DimensionValue.Name := COPYSTR(Name, 1, MAXSTRLEN(DimensionValue.Name));
                                DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::"Begin-Total";
                                DimensionValue.Indentation := 1;
                                DimensionValue.Blocked := TRUE;
                                DimensionValue.INSERT;

                                DimensionValue.Code := newCode + '-00';
                                DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
                                DimensionValue.Indentation := 2;
                                DimensionValue.Blocked := FALSE;
                                DimensionValue.INSERT;

                                DimensionValue.Code := newCode + '-99';
                                DimensionValue.Name := COPYSTR(txtQB001 + ' ' + Name, 1, MAXSTRLEN(DimensionValue.Name));
                                DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::"End-Total";
                                DimensionValue.Totaling := newCode + '..' + newCode + '-99';
                                DimensionValue.Blocked := TRUE;
                                DimensionValue.INSERT;

                                "Valor Dimension" := newCode + '-00';

                            END ELSE BEGIN
                                //Tipo persona, crea valores para la persona dentro de la empresa
                                Contacto.GET("Company No.");
                                newCode := COPYSTR(Contacto."Valor Dimension", 1, STRLEN(Contacto."Valor Dimension") - 3);
                                DimensionValue.RESET;
                                DimensionValue.SETRANGE("Dimension Code", FunctionQB.ReturnDimReferents);
                                DimensionValue.SETRANGE("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
                                DimensionValue.SETRANGE(Code, newCode + '-00', newCode + '-99');
                                IF (DimensionValue.FINDLAST) THEN
                                    "Valor Dimension" := INCSTR(DimensionValue.Code)
                                ELSE
                                    "Valor Dimension" := newCode + '-01';

                                DimensionValue.INIT;
                                DimensionValue."Dimension Code" := FunctionQB.ReturnDimReferents;
                                DimensionValue.Code := "Valor Dimension";
                                DimensionValue.Name := COPYSTR(Name + ' (' + Contacto.Name + ')', 1, MAXSTRLEN(DimensionValue.Name));
                                DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
                                DimensionValue.Indentation := 2;
                                DimensionValue.INSERT;
                            END;
                        END;
                    END;

                    //Crear las globales de suma generales
                    ReferentTypes.GET("Tipo Referente");

                    DimensionValue.INIT;
                    DimensionValue."Dimension Code" := FunctionQB.ReturnDimReferents;
                    DimensionValue.Blocked := TRUE;

                    DimensionValue.Code := "Tipo Referente";
                    DimensionValue.Name := txtQB000 + ' ' + ReferentTypes.Description;
                    DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::"Begin-Total";
                    DimensionValue.Totaling := '';
                    IF NOT DimensionValue.INSERT THEN;

                    DimensionValue.Code := "Tipo Referente" + '999';
                    DimensionValue.Name := txtQB001 + ' ' + ReferentTypes.Description;
                    DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::"End-Total";
                    DimensionValue.Totaling := "Tipo Referente" + '..' + "Tipo Referente" + '999';
                    IF NOT DimensionValue.INSERT THEN;
                END;
            END;


        }
        field(7207403; "Bloqueado"; Boolean)
        {


            DataClassification = ToBeClassified;
            Description = 'QB 1-0 - QBA 18/02/19 JAV - Bloqueado';

            trigger OnValidate();
            BEGIN
                //JAV 18/02/19: - Campo de bloqueo, se pasa a todos los contactos de la empresa y a la dimensi�n asociada
                //JAV 19/09/19: - Si no se ha definido una dimensi�n para los referentes, no se procesan las mismas
                //JAV 21/09/19: - Mejora en el uso de la dimensi�n asociada al referente

                IF (FunctionQB.QB_UseReferents) AND (Type = Type::Company) THEN BEGIN
                    Contacto.SETRANGE("Company No.", "Company No.");
                    Contacto.SETRANGE(Type, Contacto.Type::Person);
                    Contacto.MODIFYALL(Bloqueado, Bloqueado);
                END;

                IF (FunctionQB.QB_UseReferents) AND (FunctionQB.ReturnDimReferents <> '') THEN BEGIN
                    IF (Type = Type::Company) THEN BEGIN
                        DimensionValue.RESET;
                        DimensionValue.SETRANGE("Dimension Code", FunctionQB.ReturnDimReferents);
                        DimensionValue.SETRANGE("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
                        DimensionValue.SETRANGE(Code, "Valor Dimension" + '-00', "Valor Dimension" + '-99');
                        DimensionValue.MODIFYALL(Blocked, Bloqueado);
                    END ELSE BEGIN
                        DimensionValue.GET(FunctionQB.ReturnDimReferents, "Valor Dimension");
                        DimensionValue.Blocked := Bloqueado;
                        DimensionValue.MODIFY;
                    END;
                END;
            END;


        }
        field(7207404; "Activity Filter"; Code[250])
        {
            TableRelation = "Activity QB";
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Activity Filter', ESP = 'Filtro de actividad';
            Description = 'QB 1-0';


        }
        field(7207405; "Area Activity"; Option)
        {
            OptionMembers = "Local","Autonomous","National";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Area Activity', ESP = 'Ambito de actividad';
            OptionCaptionML = ENU = 'Local,Autonomous,National', ESP = 'Local,Auton�mico,Nacional';

            Description = 'QB 1-0';


        }
        field(7207410; "QB Is the company Attorney"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Es el apoderado de la empresa';
            Description = 'QB 1.08.28 JAV 24/03/21: - Nuevos campos para apoderados';


        }
        field(7207411; "QB Attorney Marital status"; Text[15])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Apoderado: Estado civil';
            Description = 'QB 1.08.28 JAV 24/03/21: - Nuevos campos para apoderados';


        }
        field(7207412; "QB Attorney seizure date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Apoderado: Fecha del poder';
            Description = 'QB 1.08.28 JAV 24/03/21: - Nuevos campos para apoderados';


        }
        field(7207413; "QB Attorney notary"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Apoderado: Ante el notario';
            Description = 'QB 1.08.28 JAV 24/03/21: - Nuevos campos para apoderados';


        }
        field(7207414; "QB Attorney notary City"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Apoderado: Ciudad del notario';
            Description = 'QB 1.08.28 JAV 24/03/21: - Nuevos campos para apoderados';


        }
        field(7207415; "QB Attorney protocol No."; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Apoderado: Nro de protocolo';
            Description = 'QB 1.08.28 JAV 24/03/21: - Nuevos campos para apoderados';


        }
        field(7207416; "QB Attorney Type"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Apoderado: En calidad de';
            Description = 'QB 1.09.13 JAV 24/03/21: - Nuevos campos para apoderados';


        }
    }
    keys
    {
        // key(key1;"No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Search Name")
        //  {
        /* ;
  */
        // }
        // key(key3;"Company Name","Company No.","Type","Name")
        //  {
        /* ;
  */
        // }
        // key(key4;"Company No.")
        //  {
        /* ;
  */
        // }
        // key(key5;"Territory Code")
        //  {
        /* ;
  */
        // }
        // key(key6;"Salesperson Code")
        //  {
        /* ;
  */
        // }
        // key(key7;"VAT Registration No.")
        //  {
        /* ;
  */
        // }
        // key(key8;"Search E-Mail")
        //  {
        /* ;
  */
        // }
        // key(key9;"Name")
        //  {
        /* ;
  */
        // }
        // key(key10;"City")
        //  {
        /* ;
  */
        // }
        // key(key11;"Post Code")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"No.","Name","Type","City","Post Code","Phone No.")
        // {
        // 
        // }
        // fieldgroup(Brick;"No.","Name","Type","City","Phone No.","Image")
        // {
        // 
        // }
    }

    var
        //       CannotDeleteWithOpenTasksErr@1000 :
        CannotDeleteWithOpenTasksErr:
// "%1 = Contact No."
TextConst ENU = 'You cannot delete contact %1 because there are one or more tasks open.', ESP = 'No se puede eliminar el contacto %1 porque no hay uno o m�s proyectos abiertos.';
        //       Text001@1001 :
        Text001: TextConst ENU = 'You cannot delete the %2 record of the %1 because the contact is assigned one or more unlogged segments.', ESP = 'No puede eliminar el registro %2 porque de %1 porque el contacto est� asignado a uno o m�s segmentos sin archivar.';
        //       Text002@1002 :
        Text002: TextConst ENU = 'You cannot delete the %2 record of the %1 because one or more opportunities are in not started or progress.', ESP = 'No puede eliminar el registro %2 de %1 porque existen una o m�s oportunidades en progreso o no iniciadas.';
        //       Text003@1003 :
        Text003: TextConst ENU = '%1 cannot be changed because one or more interaction log entries are linked to the contact.', ESP = 'No se puede cambiar %1 porque uno o m�s movs. log interacci�n est�n relacionados con el contacto.';
        //       CannotChangeWithOpenTasksErr@1005 :
        CannotChangeWithOpenTasksErr:
// "%1 = Contact No."
TextConst ENU = '%1 cannot be changed because one or more tasks are linked to the contact.', ESP = 'No se puede cambiar %1 porque una o m�s tareas est�n relacionadas con el contacto.';
        //       Text006@1006 :
        Text006: TextConst ENU = '%1 cannot be changed because one or more opportunities are linked to the contact.', ESP = 'No se puede cambiar %1 porque una o m�s oportunidades est�n relacionadas con el contacto.';
        //       Text007@1007 :
        Text007: TextConst ENU = '%1 cannot be changed because there are one or more related people linked to the contact.', ESP = 'No se puede cambiar %1 porque existen una o m�s personas relacionadas con el contacto.';
        //       RelatedRecordIsCreatedMsg@1009 :
        RelatedRecordIsCreatedMsg:
// The Customer record has been created.
TextConst ENU = 'The %1 record has been created.', ESP = 'Se ha creado el registro %1.';
        //       Text010@1010 :
        Text010: TextConst ENU = 'The %2 record of the %1 is not linked with any other table.', ESP = 'El registro %2 de %1 no est� relacionado con otra tabla.';
        //       RMSetup@1012 :
        RMSetup: Record 5079;
        //       Salesperson@1927 :
        Salesperson: Record 13;
        //       PostCode@1028 :
        PostCode: Record 225;
        //       DuplMgt@1015 :
        DuplMgt: Codeunit 5060;
        //       NoSeriesMgt@1016 :
        NoSeriesMgt: Codeunit 396;
        //       UpdateCustVendBank@1017 :
        UpdateCustVendBank: Codeunit 5055;
        //       CampaignMgt@1050 :
        CampaignMgt: Codeunit 7030;
        //       ContChanged@1018 :
        ContChanged: Boolean;
        //       SkipDefaults@1019 :
        SkipDefaults: Boolean;
        //       Text012@1020 :
        Text012: TextConst ENU = 'You cannot change %1 because one or more unlogged segments are assigned to the contact.', ESP = 'No puede cambiar %1 porque hay uno o m�s segmentos sin archivar asignados al contacto.';
        //       Text019@1022 :
        Text019: TextConst ENU = 'The %2 record of the %1 already has the %3 with %4 %5.', ESP = 'El registro %1 de %2 ya tiene %3 con %4 %5.';
        //       CreateCustomerFromContactQst@1021 :
        CreateCustomerFromContactQst: TextConst ENU = 'Do you want to create a contact as a customer using a customer template?', ESP = '�Desea crear un contacto como cliente utilizando una plantilla de cliente?';
        //       Text021@1023 :
        Text021: TextConst ENU = 'You have to set up formal and informal salutation formulas in %1  language for the %2 contact.', ESP = 'Debe configurar f�rmulas de saludo formales e informales en %1 para el contacto %2.';
        //       Text022@1034 :
        Text022: TextConst ENU = 'The creation of the customer has been aborted.', ESP = 'Se cancel� la creaci�n del cliente.';
        //       Text033@1008 :
        Text033: TextConst ENU = 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.', ESP = 'Para poder usar Online Map, primero debe rellenar la ventana Configuraci�n Online Map.\Consulte Configuraci�n de Online Map en la Ayuda.';
        //       SelectContactErr@1004 :
        SelectContactErr: TextConst ENU = 'You must select an existing contact.', ESP = 'Debe seleccionar un contacto existente.';
        //       AlreadyExistErr@1024 :
        AlreadyExistErr:
// "%1=Contact table caption;%2=Contact number;%3=Contact Business Relation table caption;%4=Contact Business Relation Link to Table value;%5=Contact Business Relation number"
TextConst ENU = '%1 %2 already has a %3 with %4 %5.', ESP = '%1 %2 tiene ya un %3 con %4 %5.';
        //       HideValidationDialog@1025 :
        HideValidationDialog: Boolean;
        //       PrivacyBlockedPostErr@1013 :
        PrivacyBlockedPostErr:
// "%1=contact no."
TextConst ENU = 'You cannot post this type of document because contact %1 is blocked due to privacy.', ESP = 'No puede registrar este tipo de documento porque el contacto %1 est� bloqueado por motivos de privacidad.';
        //       PrivacyBlockedCreateErr@1011 :
        PrivacyBlockedCreateErr:
// "%1=contact no."
TextConst ENU = 'You cannot create this type of document because contact %1 is blocked due to privacy.', ESP = 'No puede crear este tipo de documento porque el contacto %1 est� bloqueado por motivos de privacidad.';
        //       PrivacyBlockedGenericErr@1014 :
        PrivacyBlockedGenericErr:
// "%1=contact no."
TextConst ENU = 'You cannot use contact %1 because they are marked as blocked due to privacy.', ESP = 'No puede usar el contacto %1 porque est� marcado como bloqueado por motivos de privacidad.';
        //       ParentalConsentReceivedErr@1026 :
        ParentalConsentReceivedErr:
// "%1=contact no."
TextConst ENU = 'Privacy Blocked cannot be cleared until Parental Consent Received is set to true for minor contact %1.', ESP = 'No se puede borrar la opci�n Privacidad bloqueada porque Autorizaci�n parental recibida se ha establecido en true para el contacto del menor %1.';
        //       ProfileForMinorErr@1027 :
        ProfileForMinorErr: TextConst ENU = 'You cannot use profiles for contacts marked as Minor.', ESP = 'No puede utilizar los perfiles de los contactos que est�n marcados como menores.';
        //       "------------------------------------- QB"@1100286004 :
        "------------------------------------- QB": Integer;
        //       QBTablePublisher@7001100 :
        QBTablePublisher: Codeunit 7207346;
        //       DimensionValue@1100286003 :
        DimensionValue: Record 349;
        //       Contacto@1100286002 :
        Contacto: Record 5050;
        //       ReferentTypes@1100286005 :
        ReferentTypes: Record 7207444;
        //       "--------------------------- QB"@1100286000 :
        "--------------------------- QB": TextConst;
        //       txtQB000@1100286006 :
        txtQB000: TextConst ESP = 'INICIO';
        //       txtQB001@1100286001 :
        txtQB001: TextConst ESP = 'TOTAL';
        //       FunctionQB@1100286007 :
        FunctionQB: Codeunit 7207272;





    /*
    trigger OnInsert();    begin
                   RMSetup.GET;

                   if "No." = '' then begin
                     RMSetup.TESTFIELD("Contact Nos.");
                     NoSeriesMgt.InitSeries(RMSetup."Contact Nos.",xRec."No. Series",0D,"No.","No. Series");
                   end;

                   if not SkipDefaults then begin
                     if "Salesperson Code" = '' then begin
                       "Salesperson Code" := RMSetup."Default Salesperson Code";
                       SetDefaultSalesperson;
                     end;
                     if "Territory Code" = '' then
                       "Territory Code" := RMSetup."Default Territory Code";
                     if "Country/Region Code" = '' then
                       "Country/Region Code" := RMSetup."Default Country/Region Code";
                     if "Language Code" = '' then
                       "Language Code" := RMSetup."Default Language Code";
                     if "Correspondence Type" = "Correspondence Type"::" " then
                       "Correspondence Type" := RMSetup."Default Correspondence Type";
                     if "Salutation Code" = '' then
                       if Type = Type::Company then
                         "Salutation Code" := RMSetup."Def. Company Salutation Code"
                       else
                         "Salutation Code" := RMSetup."Default Person Salutation Code";
                   end;

                   TypeChange;
                   SetLastDateTimeModified;
                 end;


    */

    /*
    trigger OnModify();    begin
                   // if the modify is called from code, Rec and xRec are the same,
                   // so find the xRec
                   if FORMAT(xRec) = FORMAT(Rec) then
                     xRec.FIND;
                   OnModify(xRec);
                 end;


    */

    /*
    trigger OnDelete();    var
    //                Task@1000 :
                   Task: Record 5080;
    //                SegLine@1001 :
                   SegLine: Record 5077;
    //                ContIndustGrp@1002 :
                   ContIndustGrp: Record 5058;
    //                ContactWebSource@1003 :
                   ContactWebSource: Record 5060;
    //                ContJobResp@1004 :
                   ContJobResp: Record 5067;
    //                ContMailingGrp@1005 :
                   ContMailingGrp: Record 5056;
    //                ContProfileAnswer@1006 :
                   ContProfileAnswer: Record 5089;
    //                RMCommentLine@1007 :
                   RMCommentLine: Record 5061;
    //                ContAltAddr@1008 :
                   ContAltAddr: Record 5051;
    //                ContAltAddrDateRange@1009 :
                   ContAltAddrDateRange: Record 5052;
    //                InteractLogEntry@1010 :
                   InteractLogEntry: Record 5065;
    //                Opp@1011 :
                   Opp: Record 5092;
    //                Cont@1015 :
                   Cont: Record 5050;
    //                ContBusRel@1014 :
                   ContBusRel: Record 5054;
    //                IntrastatSetup@1013 :
                   IntrastatSetup: Record 247;
    //                CampaignTargetGrMgt@1016 :
                   CampaignTargetGrMgt: Codeunit 7030;
    //                VATRegistrationLogMgt@1012 :
                   VATRegistrationLogMgt: Codeunit 249;
                 begin
                   Task.SETCURRENTKEY("Contact Company No.","Contact No.",Closed,Date);
                   Task.SETRANGE("Contact Company No.","Company No.");
                   Task.SETRANGE("Contact No.","No.");
                   Task.SETRANGE(Closed,FALSE);
                   if Task.FIND('-') then
                     ERROR(CannotDeleteWithOpenTasksErr,"No.");

                   SegLine.SETRANGE("Contact No.","No.");
                   if not SegLine.ISEMPTY then
                     ERROR(Text001,TABLECAPTION,"No.");

                   Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                   Opp.SETRANGE("Contact Company No.","Company No.");
                   Opp.SETRANGE("Contact No.","No.");
                   Opp.SETRANGE(Status,Opp.Status::"not Started",Opp.Status::"In Progress");
                   if Opp.FIND('-') then
                     ERROR(Text002,TABLECAPTION,"No.");

                   ContBusRel.SETRANGE("Contact No.","No.");
                   ContBusRel.DELETEALL;
                   CASE Type OF
                     Type::Company:
                       begin
                         ContIndustGrp.SETRANGE("Contact No.","No.");
                         ContIndustGrp.DELETEALL;
                         ContactWebSource.SETRANGE("Contact No.","No.");
                         ContactWebSource.DELETEALL;
                         DuplMgt.RemoveContIndex(Rec,FALSE);
                         InteractLogEntry.SETCURRENTKEY("Contact Company No.");
                         InteractLogEntry.SETRANGE("Contact Company No.","No.");
                         if InteractLogEntry.FIND('-') then
                           repeat
                             CampaignTargetGrMgt.DeleteContfromTargetGr(InteractLogEntry);
                             CLEAR(InteractLogEntry."Contact Company No.");
                             CLEAR(InteractLogEntry."Contact No.");
                             InteractLogEntry.MODIFY;
                           until InteractLogEntry.NEXT = 0;

                         Cont.RESET;
                         Cont.SETCURRENTKEY("Company No.");
                         Cont.SETRANGE("Company No.","No.");
                         Cont.SETRANGE(Type,Type::Person);
                         if Cont.FIND('-') then
                           repeat
                             Cont.DELETE(TRUE);
                           until Cont.NEXT = 0;

                         Opp.RESET;
                         Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                         Opp.SETRANGE("Contact Company No.","Company No.");
                         Opp.SETRANGE("Contact No.","No.");
                         if Opp.FIND('-') then
                           repeat
                             CLEAR(Opp."Contact No.");
                             CLEAR(Opp."Contact Company No.");
                             Opp.MODIFY;
                           until Opp.NEXT = 0;

                         Task.RESET;
                         Task.SETCURRENTKEY("Contact Company No.");
                         Task.SETRANGE("Contact Company No.","Company No.");
                         if Task.FIND('-') then
                           repeat
                             CLEAR(Task."Contact No.");
                             CLEAR(Task."Contact Company No.");
                             Task.MODIFY;
                           until Task.NEXT = 0;
                       end;
                     Type::Person:
                       begin
                         ContJobResp.SETRANGE("Contact No.","No.");
                         if not ContJobResp.ISEMPTY then
                           ContJobResp.DELETEALL;

                         InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                         InteractLogEntry.SETRANGE("Contact Company No.","Company No.");
                         InteractLogEntry.SETRANGE("Contact No.","No.");
                         if not InteractLogEntry.ISEMPTY then
                           InteractLogEntry.MODIFYALL("Contact No.","Company No.");

                         Opp.RESET;
                         Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                         Opp.SETRANGE("Contact Company No.","Company No.");
                         Opp.SETRANGE("Contact No.","No.");
                         if not Opp.ISEMPTY then
                           Opp.MODIFYALL("Contact No.","Company No.");

                         Task.RESET;
                         Task.SETCURRENTKEY("Contact Company No.","Contact No.");
                         Task.SETRANGE("Contact Company No.","Company No.");
                         Task.SETRANGE("Contact No.","No.");
                         if not Task.ISEMPTY then
                           Task.MODIFYALL("Contact No.","Company No.");
                       end;
                   end;

                   ContMailingGrp.SETRANGE("Contact No.","No.");
                   if not ContMailingGrp.ISEMPTY then
                     ContMailingGrp.DELETEALL;

                   ContProfileAnswer.SETRANGE("Contact No.","No.");
                   if not ContProfileAnswer.ISEMPTY then
                     ContProfileAnswer.DELETEALL;

                   RMCommentLine.SETRANGE("Table Name",RMCommentLine."Table Name"::Contact);
                   RMCommentLine.SETRANGE("No.","No.");
                   RMCommentLine.SETRANGE("Sub No.",0);
                   if not RMCommentLine.ISEMPTY then
                     RMCommentLine.DELETEALL;

                   ContAltAddr.SETRANGE("Contact No.","No.");
                   if not ContAltAddr.ISEMPTY then
                     ContAltAddr.DELETEALL;

                   ContAltAddrDateRange.SETRANGE("Contact No.","No.");
                   if not ContAltAddrDateRange.ISEMPTY then
                     ContAltAddrDateRange.DELETEALL;

                   QBTablePublisher.OnDeleteTContact(Rec);   //QB

                   VATRegistrationLogMgt.DeleteContactLog(Rec);

                   IntrastatSetup.CheckDeleteIntrastatContact(IntrastatSetup."Intrastat Contact Type"::Contact,"No.");
                 end;


    */

    /*
    trigger OnRename();    begin
                   VALIDATE("Lookup Contact No.");
                 end;

    */



    // procedure OnModify (xRec@1005 :

    /*
    procedure OnModify (xRec: Record 5050)
        var
    //       OldCont@1001 :
          OldCont: Record 5050;
    //       Cont@1003 :
          Cont: Record 5050;
    //       IsDuplicateCheckNeeded@1000 :
          IsDuplicateCheckNeeded: Boolean;
        begin
          SetLastDateTimeModified;

          if "No." <> '' then
            if IsUpdateNeeded then
              UpdateCustVendBank.RUN(Rec);

          if Type = Type::Company then begin
            RMSetup.GET;
            Cont.RESET;
            Cont.SETCURRENTKEY("Company No.");
            Cont.SETRANGE("Company No.","No.");
            Cont.SETRANGE(Type,Type::Person);
            Cont.SETFILTER("No.",'<>%1',"No.");
            if Cont.FIND('-') then
              repeat
                ContChanged := FALSE;
                OldCont := Cont;
                if Name <> xRec.Name then begin
                  Cont."Company Name" := Name;
                  ContChanged := TRUE;
                end;
                if RMSetup."Inherit Salesperson Code" and
                   (xRec."Salesperson Code" <> "Salesperson Code") and
                   (xRec."Salesperson Code" = Cont."Salesperson Code")
                then begin
                  Cont."Salesperson Code" := "Salesperson Code";
                  ContChanged := TRUE;
                end;
                if RMSetup."Inherit Territory Code" and
                   (xRec."Territory Code" <> "Territory Code") and
                   (xRec."Territory Code" = Cont."Territory Code")
                then begin
                  Cont."Territory Code" := "Territory Code";
                  ContChanged := TRUE;
                end;
                if RMSetup."Inherit Country/Region Code" and
                   (xRec."Country/Region Code" <> "Country/Region Code") and
                   (xRec."Country/Region Code" = Cont."Country/Region Code")
                then begin
                  Cont."Country/Region Code" := "Country/Region Code";
                  ContChanged := TRUE;
                end;
                if RMSetup."Inherit Language Code" and
                   (xRec."Language Code" <> "Language Code") and
                   (xRec."Language Code" = Cont."Language Code")
                then begin
                  Cont."Language Code" := "Language Code";
                  ContChanged := TRUE;
                end;
                if RMSetup."Inherit Address Details" then
                  if xRec.IdenticalAddress(Cont) then begin
                    if xRec.Address <> Address then begin
                      Cont.Address := Address;
                      ContChanged := TRUE;
                    end;
                    if xRec."Address 2" <> "Address 2" then begin
                      Cont."Address 2" := "Address 2";
                      ContChanged := TRUE;
                    end;
                    if xRec."Post Code" <> "Post Code" then begin
                      Cont."Post Code" := "Post Code";
                      ContChanged := TRUE;
                    end;
                    if xRec.City <> City then begin
                      Cont.City := City;
                      ContChanged := TRUE;
                    end;
                    if xRec.County <> County then begin
                      Cont.County := County;
                      ContChanged := TRUE;
                    end;
                  end;
                if RMSetup."Inherit Communication Details" then begin
                  if (xRec."Phone No." <> "Phone No.") and (xRec."Phone No." = Cont."Phone No.") then begin
                    Cont."Phone No." := "Phone No.";
                    ContChanged := TRUE;
                  end;
                  if (xRec."Telex No." <> "Telex No.") and (xRec."Telex No." = Cont."Telex No.") then begin
                    Cont."Telex No." := "Telex No.";
                    ContChanged := TRUE;
                  end;
                  if (xRec."Fax No." <> "Fax No.") and (xRec."Fax No." = Cont."Fax No.") then begin
                    Cont."Fax No." := "Fax No.";
                    ContChanged := TRUE;
                  end;
                  if (xRec."Telex Answer Back" <> "Telex Answer Back") and (xRec."Telex Answer Back" = Cont."Telex Answer Back") then begin
                    Cont."Telex Answer Back" := "Telex Answer Back";
                    ContChanged := TRUE;
                  end;
                  if (xRec."E-Mail" <> "E-Mail") and (xRec."E-Mail" = Cont."E-Mail") then begin
                    Cont.VALIDATE("E-Mail","E-Mail");
                    ContChanged := TRUE;
                  end;
                  if (xRec."Home Page" <> "Home Page") and (xRec."Home Page" = Cont."Home Page") then begin
                    Cont."Home Page" := "Home Page";
                    ContChanged := TRUE;
                  end;
                  if (xRec."Extension No." <> "Extension No.") and (xRec."Extension No." = Cont."Extension No.") then begin
                    Cont."Extension No." := "Extension No.";
                    ContChanged := TRUE;
                  end;
                  if (xRec."Mobile Phone No." <> "Mobile Phone No.") and (xRec."Mobile Phone No." = Cont."Mobile Phone No.") then begin
                    Cont."Mobile Phone No." := "Mobile Phone No.";
                    ContChanged := TRUE;
                  end;
                  if (xRec.Pager <> Pager) and (xRec.Pager = Cont.Pager) then begin
                    Cont.Pager := Pager;
                    ContChanged := TRUE;
                  end;
                end;

                OnBeforeApplyCompanyChangeToPerson(Cont,Rec,xRec,ContChanged);
                if ContChanged then begin
                  Cont.OnModify(OldCont);
                  Cont.MODIFY;
                end;
              until Cont.NEXT = 0;

            IsDuplicateCheckNeeded :=
              (Name <> xRec.Name) or
              ("Name 2" <> xRec."Name 2") or
              (Address <> xRec.Address) or
              ("Address 2" <> xRec."Address 2") or
              (City <> xRec.City) or
              ("Post Code" <> xRec."Post Code") or
              ("VAT Registration No." <> xRec."VAT Registration No.") or
              ("Phone No." <> xRec."Phone No.");

            OnBeforeDuplicateCheck(Rec,xRec,IsDuplicateCheckNeeded);

            if IsDuplicateCheckNeeded then
              CheckDupl;
          end;
        end;
    */




    /*
    procedure TypeChange ()
        var
    //       InteractLogEntry@1000 :
          InteractLogEntry: Record 5065;
    //       Opp@1001 :
          Opp: Record 5092;
    //       Task@1002 :
          Task: Record 5080;
    //       Cont@1006 :
          Cont: Record 5050;
    //       CampaignTargetGrMgt@1003 :
          CampaignTargetGrMgt: Codeunit 7030;
        begin
          RMSetup.GET;

          if Type <> xRec.Type then begin
            InteractLogEntry.LOCKTABLE;
            Cont.LOCKTABLE;
            InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
            InteractLogEntry.SETRANGE("Contact Company No.","Company No.");
            InteractLogEntry.SETRANGE("Contact No.","No.");
            if InteractLogEntry.FINDFIRST then
              ERROR(Text003,FIELDCAPTION(Type));
            Task.SETRANGE("Contact Company No.","Company No.");
            Task.SETRANGE("Contact No.","No.");
            if not Task.ISEMPTY then
              ERROR(CannotChangeWithOpenTasksErr,FIELDCAPTION(Type));
            Opp.SETRANGE("Contact Company No.","Company No.");
            Opp.SETRANGE("Contact No.","No.");
            if not Opp.ISEMPTY then
              ERROR(Text006,FIELDCAPTION(Type));
          end;

          CASE Type OF
            Type::Company:
              begin
                if Type <> xRec.Type then begin
                  TESTFIELD("Organizational Level Code",'');
                  TESTFIELD("No. of Job Responsibilities",0);
                end;
                "First Name" := '';
                "Middle Name" := '';
                Surname := '';
                "Job Title" := '';
                "Company No." := "No.";
                "Company Name" := Name;
                "Salutation Code" := RMSetup."Def. Company Salutation Code";
              end;
            Type::Person:
              begin
                CampaignTargetGrMgt.DeleteContfromTargetGr(InteractLogEntry);
                Cont.RESET;
                Cont.SETCURRENTKEY("Company No.");
                Cont.SETRANGE("Company No.","No.");
                Cont.SETRANGE(Type,Type::Person);
                if Cont.FINDFIRST then
                  ERROR(Text007,FIELDCAPTION(Type));
                if Type <> xRec.Type then begin
                  CALCFIELDS("No. of Business Relations","No. of Industry Groups");
                  TESTFIELD("No. of Business Relations",0);
                  TESTFIELD("No. of Industry Groups",0);
                  TESTFIELD("Currency Code",'');
                  TESTFIELD("VAT Registration No.",'');
                end;
                if "Company No." = "No." then begin
                  "Company No." := '';
                  "Company Name" := '';
                  "Salutation Code" := RMSetup."Default Person Salutation Code";
                  NameBreakdown;
                end;
              end;
          end;
          VALIDATE("Lookup Contact No.");

          if Cont.GET("No.") then begin
            if Type = Type::Company then
              CheckDupl
            else
              DuplMgt.RemoveContIndex(Rec,FALSE);
          end;
        end;
    */



    //     procedure AssistEdit (OldCont@1000 :

    /*
    procedure AssistEdit (OldCont: Record 5050) : Boolean;
        var
    //       Cont@1003 :
          Cont: Record 5050;
        begin
          WITH Cont DO begin
            Cont := Rec;
            RMSetup.GET;
            RMSetup.TESTFIELD("Contact Nos.");
            if NoSeriesMgt.SelectSeries(RMSetup."Contact Nos.",OldCont."No. Series","No. Series") then begin
              RMSetup.GET;
              RMSetup.TESTFIELD("Contact Nos.");
              NoSeriesMgt.SetSeries("No.");
              Rec := Cont;
              exit(TRUE);
            end;
          end;
        end;
    */



    //     procedure CreateCustomer (CustomerTemplate@1006 :

    /*
    procedure CreateCustomer (CustomerTemplate: Code[10])
        var
    //       Cust@1000 :
          Cust: Record 18;
    //       CustTemplate@1003 :
          CustTemplate: Record 5105;
    //       DefaultDim@1005 :
          DefaultDim: Record 352;
    //       DefaultDim2@1004 :
          DefaultDim2: Record 352;
    //       ContBusRel@1008 :
          ContBusRel: Record 5054;
    //       OfficeMgt@1002 :
          OfficeMgt: Codeunit 1630;
        begin
          CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
          CheckIfPrivacyBlockedGeneric;
          RMSetup.GET;
          RMSetup.TESTFIELD("Bus. Rel. Code for Customers");

          if CustomerTemplate <> '' then
            if CustTemplate.GET(CustomerTemplate) then;

          CLEAR(Cust);
          Cust.SetInsertFromContact(TRUE);
          Cust."Contact Type" := Type;
          OnBeforeCustomerInsert(Cust,CustomerTemplate);
          Cust.INSERT(TRUE);
          Cust.SetInsertFromContact(FALSE);

          ContBusRel."Contact No." := "No.";
          ContBusRel."Business Relation Code" := RMSetup."Bus. Rel. Code for Customers";
          ContBusRel."Link to Table" := ContBusRel."Link to Table"::Customer;
          ContBusRel."No." := Cust."No.";
          ContBusRel.INSERT(TRUE);

          UpdateCustVendBank.UpdateCustomer(Rec,ContBusRel);

          Cust.GET(ContBusRel."No.");
          if Type = Type::Company then
            Cust.VALIDATE(Name,"Company Name");

          OnCreateCustomerOnBeforeCustomerModify(Cust,Rec);
          Cust.MODIFY;

          if CustTemplate.Code <> '' then begin
            if "Territory Code" = '' then
              Cust."Territory Code" := CustTemplate."Territory Code"
            else
              Cust."Territory Code" := "Territory Code";
            if "Currency Code" = '' then
              Cust."Currency Code" := CustTemplate."Currency Code"
            else
              Cust."Currency Code" := "Currency Code";
            if "Country/Region Code" = '' then
              Cust."Country/Region Code" := CustTemplate."Country/Region Code"
            else
              Cust."Country/Region Code" := "Country/Region Code";
            Cust."Customer Posting Group" := CustTemplate."Customer Posting Group";
            Cust."Customer Price Group" := CustTemplate."Customer Price Group";
            if CustTemplate."Invoice Disc. Code" <> '' then
              Cust."Invoice Disc. Code" := CustTemplate."Invoice Disc. Code";
            Cust."Customer Disc. Group" := CustTemplate."Customer Disc. Group";
            Cust."Allow Line Disc." := CustTemplate."Allow Line Disc.";
            Cust."Gen. Bus. Posting Group" := CustTemplate."Gen. Bus. Posting Group";
            Cust."VAT Bus. Posting Group" := CustTemplate."VAT Bus. Posting Group";
            Cust."Payment Terms Code" := CustTemplate."Payment Terms Code";
            Cust."Payment Method Code" := CustTemplate."Payment Method Code";
            Cust."Prices Including VAT" := CustTemplate."Prices Including VAT";
            Cust."Shipment Method Code" := CustTemplate."Shipment Method Code";
            Cust.UpdateReferencedIds;
            OnCreateCustomerOnTransferFieldsFromTemplate(Cust,CustTemplate);
            Cust.MODIFY;

            DefaultDim.SETRANGE("Table ID",DATABASE::"Customer Template");
            DefaultDim.SETRANGE("No.",CustTemplate.Code);
            if DefaultDim.FIND('-') then
              repeat
                CLEAR(DefaultDim2);
                DefaultDim2.INIT;
                DefaultDim2.VALIDATE("Table ID",DATABASE::Customer);
                DefaultDim2."No." := Cust."No.";
                DefaultDim2.VALIDATE("Dimension Code",DefaultDim."Dimension Code");
                DefaultDim2.VALIDATE("Dimension Value Code",DefaultDim."Dimension Value Code");
                DefaultDim2."Value Posting" := DefaultDim."Value Posting";
                DefaultDim2.INSERT(TRUE);
              until DefaultDim.NEXT = 0;
          end;

          UpdateQuotes(Cust);
          CampaignMgt.ConverttoCustomer(Rec,Cust);
          if OfficeMgt.IsAvailable then
            PAGE.RUN(PAGE::"Customer Card",Cust)
          else
            if not HideValidationDialog then
              MESSAGE(RelatedRecordIsCreatedMsg,Cust.TABLECAPTION);
        end;
    */



    procedure CreateVendor()
    var
        //       ContBusRel@1004 :
        ContBusRel: Record 5054;
        //       Vend@1000 :
        Vend: Record 23;
        //       ContComp@1001 :
        ContComp: Record 5050;
        //       OfficeMgt@1002 :
        OfficeMgt: Codeunit 1630;
    begin
        CheckForExistingRelationships(ContBusRel."Link to Table"::Vendor);
        CheckIfPrivacyBlockedGeneric;
        //JAV 09/07/19: - Al crear el proveedor del contacto no tiene sentido validar que tenga empresa asociada, debe ser una empresa
        //              - Luego actua seg�n sea o no empresa correctamente
        //TESTFIELD("Company No.");
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Vendors");

        CLEAR(Vend);
        Vend.SetInsertFromContact(TRUE);
        OnBeforeVendorInsert(Vend);
        Vend.INSERT(TRUE);
        Vend.SetInsertFromContact(FALSE);

        if Type = Type::Company then
            ContComp := Rec
        else
            ContComp.GET("Company No.");

        ContBusRel."Contact No." := ContComp."No.";
        ContBusRel."Business Relation Code" := RMSetup."Bus. Rel. Code for Vendors";
        ContBusRel."Link to Table" := ContBusRel."Link to Table"::Vendor;
        ContBusRel."No." := Vend."No.";
        ContBusRel.INSERT(TRUE);

        OnAfterVendorInsert(Vend, Rec);

        UpdateCustVendBank.UpdateVendor(ContComp, ContBusRel);

        if OfficeMgt.IsAvailable then
            PAGE.RUN(PAGE::"Vendor Card", Vend)
        else
            if not HideValidationDialog then
                MESSAGE(RelatedRecordIsCreatedMsg, Vend.TABLECAPTION);
    end;



    /*
    procedure CreateVendor2 ()
        begin
          CreateVendor;
        end;
    */




    /*
    procedure CreateBankAccount ()
        var
    //       BankAcc@1000 :
          BankAcc: Record 270;
    //       ContComp@1001 :
          ContComp: Record 5050;
    //       ContBusRel@1003 :
          ContBusRel: Record 5054;
        begin
          TESTFIELD("Company No.");
          RMSetup.GET;
          RMSetup.TESTFIELD("Bus. Rel. Code for Bank Accs.");

          CLEAR(BankAcc);
          BankAcc.SetInsertFromContact(TRUE);
          BankAcc.INSERT(TRUE);
          BankAcc.SetInsertFromContact(FALSE);

          if Type = Type::Company then
            ContComp := Rec
          else
            ContComp.GET("Company No.");

          ContBusRel."Contact No." := ContComp."No.";
          ContBusRel."Business Relation Code" := RMSetup."Bus. Rel. Code for Bank Accs.";
          ContBusRel."Link to Table" := ContBusRel."Link to Table"::"Bank Account";
          ContBusRel."No." := BankAcc."No.";
          ContBusRel.INSERT(TRUE);

          CheckIfPrivacyBlockedGeneric;

          UpdateCustVendBank.UpdateBankAccount(ContComp,ContBusRel);

          if not HideValidationDialog then
            MESSAGE(RelatedRecordIsCreatedMsg,BankAcc.TABLECAPTION);
        end;
    */




    /*
    procedure CreateCustomerLink ()
        var
    //       Cust@1001 :
          Cust: Record 18;
    //       ContBusRel@1000 :
          ContBusRel: Record 5054;
        begin
          CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
          CheckIfPrivacyBlockedGeneric;
          RMSetup.GET;
          RMSetup.TESTFIELD("Bus. Rel. Code for Customers");
          CreateLink(
            PAGE::"Customer Link",
            RMSetup."Bus. Rel. Code for Customers",
            ContBusRel."Link to Table"::Customer);

          ContBusRel.SETCURRENTKEY("Link to Table","No.");
          ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
          ContBusRel.SETRANGE("Contact No.","Company No.");
          if ContBusRel.FINDFIRST then
            if Cust.GET(ContBusRel."No.") then
              UpdateQuotes(Cust);
        end;
    */




    /*
    procedure CreateVendorLink ()
        var
    //       ContBusRel@1001 :
          ContBusRel: Record 5054;
        begin
          CheckForExistingRelationships(ContBusRel."Link to Table"::Vendor);
          CheckIfPrivacyBlockedGeneric;
          TESTFIELD("Company No.");
          RMSetup.GET;
          RMSetup.TESTFIELD("Bus. Rel. Code for Vendors");
          CreateLink(
            PAGE::"Vendor Link",
            RMSetup."Bus. Rel. Code for Vendors",
            ContBusRel."Link to Table"::Vendor);
        end;
    */




    /*
    procedure CreateBankAccountLink ()
        var
    //       ContBusRel@1001 :
          ContBusRel: Record 5054;
        begin
          CheckIfPrivacyBlockedGeneric;
          TESTFIELD("Company No.");
          RMSetup.GET;
          RMSetup.TESTFIELD("Bus. Rel. Code for Bank Accs.");
          CreateLink(
            PAGE::"Bank Account Link",
            RMSetup."Bus. Rel. Code for Bank Accs.",
            ContBusRel."Link to Table"::"Bank Account");
        end;
    */


    //     LOCAL procedure CreateLink (CreateForm@1000 : Integer;BusRelCode@1001 : Code[10];Table@1002 :

    /*
    LOCAL procedure CreateLink (CreateForm: Integer;BusRelCode: Code[10];Table: Option " ","Customer","Vendor","Bank Accoun")
        var
    //       TempContBusRel@1003 :
          TempContBusRel: Record 5054 TEMPORARY;
        begin
          TempContBusRel."Contact No." := "No.";
          TempContBusRel."Business Relation Code" := BusRelCode;
          TempContBusRel."Link to Table" := Table;
          TempContBusRel.INSERT;
          if PAGE.RUNMODAL(CreateForm,TempContBusRel) = ACTION::LookupOK then; // enforce look up mode dialog
          TempContBusRel.DELETEALL;
        end;
    */




    /*
    procedure CreateInteraction ()
        var
    //       TempSegmentLine@1000 :
          TempSegmentLine: Record 5077 TEMPORARY;
        begin
          CheckIfPrivacyBlockedGeneric;
          TempSegmentLine.CreateInteractionFromContact(Rec);
        end;
    */




    /*
    procedure GetDefaultPhoneNo () : Text[30];
        var
    //       ClientTypeManagement@1000 :
          ClientTypeManagement: Codeunit 4;
        begin
          if ClientTypeManagement.IsClientType(CLIENTTYPE::Phone) then begin
            if "Mobile Phone No." = '' then
              exit("Phone No.");
            exit("Mobile Phone No.");
          end;
          if "Phone No." = '' then
            exit("Mobile Phone No.");
          exit("Phone No.");
        end;
    */




    /*
    procedure ShowCustVendBank ()
        var
    //       ContBusRel@1000 :
          ContBusRel: Record 5054;
    //       Cust@1002 :
          Cust: Record 18;
    //       Vend@1003 :
          Vend: Record 23;
    //       BankAcc@1004 :
          BankAcc: Record 270;
    //       FormSelected@1001 :
          FormSelected: Boolean;
        begin
          FormSelected := TRUE;

          ContBusRel.RESET;

          if "Company No." <> '' then
            ContBusRel.SETFILTER("Contact No.",'%1|%2',"No.","Company No.")
          else
            ContBusRel.SETRANGE("Contact No.","No.");
          ContBusRel.SETFILTER("No.",'<>''''');

          CASE ContBusRel.COUNT OF
            0:
              ERROR(Text010,TABLECAPTION,"No.");
            1:
              ContBusRel.FINDFIRST;
            else
              FormSelected := PAGE.RUNMODAL(PAGE::"Contact Business Relations",ContBusRel) = ACTION::LookupOK;
          end;

          if FormSelected then
            CASE ContBusRel."Link to Table" OF
              ContBusRel."Link to Table"::Customer:
                begin
                  Cust.GET(ContBusRel."No.");
                  PAGE.RUN(PAGE::"Customer Card",Cust);
                end;
              ContBusRel."Link to Table"::Vendor:
                begin
                  Vend.GET(ContBusRel."No.");
                  PAGE.RUN(PAGE::"Vendor Card",Vend);
                end;
              ContBusRel."Link to Table"::"Bank Account":
                begin
                  BankAcc.GET(ContBusRel."No.");
                  PAGE.RUN(PAGE::"Bank Account Card",BankAcc);
                end;
            end;
        end;
    */



    /*
    LOCAL procedure NameBreakdown ()
        var
    //       NamePart@1000 :
          NamePart: ARRAY [30] OF Text[250];
    //       TempName@1001 :
          TempName: Text[250];
    //       FirstName250@1004 :
          FirstName250: Text[250];
    //       i@1002 :
          i: Integer;
    //       NoOfParts@1003 :
          NoOfParts: Integer;
        begin
          if Type = Type::Company then
            exit;

          TempName := Name;
          WHILE STRPOS(TempName,' ') > 0 DO begin
            if STRPOS(TempName,' ') > 1 then begin
              i := i + 1;
              NamePart[i] := COPYSTR(TempName,1,STRPOS(TempName,' ') - 1);
            end;
            TempName := COPYSTR(TempName,STRPOS(TempName,' ') + 1);
          end;
          i := i + 1;
          NamePart[i] := TempName;
          NoOfParts := i;

          "First Name" := '';
          "Middle Name" := '';
          Surname := '';
          FOR i := 1 TO NoOfParts DO
            if (i = NoOfParts) and (NoOfParts > 1) then
              Surname := COPYSTR(NamePart[i],1,MAXSTRLEN(Surname))
            else
              if (i = NoOfParts - 1) and (NoOfParts > 2) then
                "Middle Name" := COPYSTR(NamePart[i],1,MAXSTRLEN("Middle Name"))
              else begin
                FirstName250 := DELCHR("First Name" + ' ' + NamePart[i],'<',' ');
                "First Name" := COPYSTR(FirstName250,1,MAXSTRLEN("First Name"));
              end;
        end;
    */




    /*
    procedure SetSkipDefault ()
        begin
          SkipDefaults := TRUE;
        end;
    */



    //     procedure IdenticalAddress (var Cont@1000 :

    /*
    procedure IdenticalAddress (var Cont: Record 5050) : Boolean;
        begin
          exit(
            (Address = Cont.Address) and
            ("Address 2" = Cont."Address 2") and
            ("Post Code" = Cont."Post Code") and
            (City = Cont.City))
        end;
    */



    //     procedure ActiveAltAddress (ActiveDate@1000 :

    /*
    procedure ActiveAltAddress (ActiveDate: Date) : Code[10];
        var
    //       ContAltAddrDateRange@1001 :
          ContAltAddrDateRange: Record 5052;
        begin
          ContAltAddrDateRange.SETCURRENTKEY("Contact No.","Starting Date");
          ContAltAddrDateRange.SETRANGE("Contact No.","No.");
          ContAltAddrDateRange.SETRANGE("Starting Date",0D,ActiveDate);
          ContAltAddrDateRange.SETFILTER("Ending Date",'>=%1|%2',ActiveDate,0D);
          if ContAltAddrDateRange.FINDLAST then
            exit(ContAltAddrDateRange."Contact Alt. Address Code");

          exit('');
        end;
    */


    //     LOCAL procedure CalculatedName () NewName@1000 :

    /*
    LOCAL procedure CalculatedName () NewName: Text[50];
        var
    //       NewName92@1001 :
          NewName92: Text[92];
        begin
          if "First Name" <> '' then
            NewName92 := "First Name";
          if "Middle Name" <> '' then
            NewName92 := NewName92 + ' ' + "Middle Name";
          if Surname <> '' then
            NewName92 := NewName92 + ' ' + Surname;

          NewName92 := DELCHR(NewName92,'<',' ');
          NewName := COPYSTR(NewName92,1,MAXSTRLEN(NewName));
        end;
    */



    /*
    LOCAL procedure UpdateSearchName ()
        begin
          if ("Search Name" = UPPERCASE(xRec.Name)) or ("Search Name" = '') then
            "Search Name" := Name;
        end;
    */



    /*
    LOCAL procedure CheckDupl ()
        begin
          if RMSetup."Maintain Dupl. Search Strings" then
            DuplMgt.MakeContIndex(Rec);
          if GUIALLOWED then
            if DuplMgt.DuplicateExist(Rec) then begin
              MODIFY;
              COMMIT;
              DuplMgt.LaunchDuplicateForm(Rec);
            end;
        end;
    */





    procedure FindCustomerTemplate(): Code[10];
    var
        //       CustTemplate@1003 :
        CustTemplate: Record "Customer Templ.";
        //       ContCompany@1002 :
        ContCompany: Record 5050;
    begin
        CustTemplate.RESET;
        CustTemplate.SETRANGE("Territory Code", "Territory Code");
        CustTemplate.SETRANGE("Country/Region Code", "Country/Region Code");
        CustTemplate.SETRANGE("Contact Type", Type);
        if ContCompany.GET("Company No.") then
            CustTemplate.SETRANGE("Currency Code", ContCompany."Currency Code");

        if CustTemplate.COUNT = 1 then begin
            CustTemplate.FINDFIRST;
            exit(CustTemplate.Code);
        end;
    end;




    /*
    procedure ChooseCustomerTemplate () : Code[10];
        var
    //       CustTemplate@1000 :
          CustTemplate: Record 5105;
    //       ContBusRel@1002 :
          ContBusRel: Record 5054;
        begin
          CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
          ContBusRel.RESET;
          ContBusRel.SETRANGE("Contact No.","No.");
          ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
          if ContBusRel.FINDFIRST then
            ERROR(
              Text019,
              TABLECAPTION,"No.",ContBusRel.TABLECAPTION,ContBusRel."Link to Table",ContBusRel."No.");

          if CONFIRM(CreateCustomerFromContactQst,TRUE) then begin
            CustTemplate.SETRANGE("Contact Type",Type);
            if PAGE.RUNMODAL(0,CustTemplate) = ACTION::LookupOK then
              exit(CustTemplate.Code);

            ERROR(Text022);
          end;
        end;
    */


    //     LOCAL procedure UpdateQuotes (Customer@1000 :

    /*
    LOCAL procedure UpdateQuotes (Customer: Record 18)
        var
    //       SalesHeader@1003 :
          SalesHeader: Record 36;
    //       SalesHeader2@1005 :
          SalesHeader2: Record 36;
    //       Cont@1004 :
          Cont: Record 5050;
    //       SalesLine@1001 :
          SalesLine: Record 37;
        begin
          if "Company No." <> '' then
            Cont.SETRANGE("Company No.","Company No.")
          else
            Cont.SETRANGE("No.","No.");

          if Cont.FINDSET then
            repeat
              SalesHeader.RESET;
              SalesHeader.SETRANGE("Sell-to Customer No.",'');
              SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Quote);
              SalesHeader.SETRANGE("Sell-to Contact No.",Cont."No.");
              if SalesHeader.FINDSET then
                repeat
                  SalesHeader2.GET(SalesHeader."Document Type",SalesHeader."No.");
                  SalesHeader2."Sell-to Customer No." := Customer."No.";
                  SalesHeader2."Sell-to Customer Name" := Customer.Name;
                  SalesHeader2."Sell-to Customer Template Code" := '';
                  if SalesHeader2."Sell-to Contact No." = SalesHeader2."Bill-to Contact No." then begin
                    SalesHeader2."Bill-to Customer No." := Customer."No.";
                    SalesHeader2."Bill-to Name" := Customer.Name;
                    SalesHeader2."Bill-to Customer Template Code" := '';
                    SalesHeader2."Salesperson Code" := Customer."Salesperson Code";
                  end;
                  SalesHeader2.MODIFY;
                  SalesLine.SETRANGE("Document Type",SalesHeader2."Document Type");
                  SalesLine.SETRANGE("Document No.",SalesHeader2."No.");
                  SalesLine.MODIFYALL("Sell-to Customer No.",SalesHeader2."Sell-to Customer No.");
                  if SalesHeader2."Sell-to Contact No." = SalesHeader2."Bill-to Contact No." then
                    SalesLine.MODIFYALL("Bill-to Customer No.",SalesHeader2."Bill-to Customer No.");
                  OnAfterModifySellToCustomerNo(SalesHeader2,SalesLine);
                until SalesHeader.NEXT = 0;

              SalesHeader.RESET;
              SalesHeader.SETRANGE("Bill-to Customer No.",'');
              SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Quote);
              SalesHeader.SETRANGE("Bill-to Contact No.",Cont."No.");
              if SalesHeader.FINDSET then
                repeat
                  SalesHeader2.GET(SalesHeader."Document Type",SalesHeader."No.");
                  SalesHeader2."Bill-to Customer No." := Customer."No.";
                  SalesHeader2."Bill-to Customer Template Code" := '';
                  SalesHeader2."Salesperson Code" := Customer."Salesperson Code";
                  SalesHeader2.MODIFY;
                  SalesLine.SETRANGE("Document Type",SalesHeader2."Document Type");
                  SalesLine.SETRANGE("Document No.",SalesHeader2."No.");
                  SalesLine.MODIFYALL("Bill-to Customer No.",SalesHeader2."Bill-to Customer No.");
                  OnAfterModifyBillToCustomerNo(SalesHeader2,SalesLine);
                until SalesHeader.NEXT = 0;
              OnAfterUpdateQuotesForContact(Cont,Customer);
            until Cont.NEXT = 0;
        end;
    */



    //     procedure GetSalutation (SalutationType@1001 : 'Formal,Informal';LanguageCode@1000 :

    /*
    procedure GetSalutation (SalutationType: Option "Formal","Informal";LanguageCode: Code[10]) : Text[260];
        var
    //       SalutationFormula@1005 :
          SalutationFormula: Record 5069;
    //       NamePart@1004 :
          NamePart: ARRAY [5] OF Text[50];
    //       SubStr@1003 :
          SubStr: Text[30];
    //       i@1002 :
          i: Integer;
        begin
          if not SalutationFormula.GET("Salutation Code",LanguageCode,SalutationType) then
            ERROR(Text021,LanguageCode,"No.");
          SalutationFormula.TESTFIELD(Salutation);

          CASE SalutationFormula."Name 1" OF
            SalutationFormula."Name 1"::"Job Title":
              NamePart[1] := "Job Title";
            SalutationFormula."Name 1"::"First Name":
              NamePart[1] := "First Name";
            SalutationFormula."Name 1"::"Middle Name":
              NamePart[1] := "Middle Name";
            SalutationFormula."Name 1"::Surname:
              NamePart[1] := Surname;
            SalutationFormula."Name 1"::Initials:
              NamePart[1] := Initials;
            SalutationFormula."Name 1"::"Company Name":
              NamePart[1] := "Company Name";
          end;

          CASE SalutationFormula."Name 2" OF
            SalutationFormula."Name 2"::"Job Title":
              NamePart[2] := "Job Title";
            SalutationFormula."Name 2"::"First Name":
              NamePart[2] := "First Name";
            SalutationFormula."Name 2"::"Middle Name":
              NamePart[2] := "Middle Name";
            SalutationFormula."Name 2"::Surname:
              NamePart[2] := Surname;
            SalutationFormula."Name 2"::Initials:
              NamePart[2] := Initials;
            SalutationFormula."Name 2"::"Company Name":
              NamePart[2] := "Company Name";
          end;

          CASE SalutationFormula."Name 3" OF
            SalutationFormula."Name 3"::"Job Title":
              NamePart[3] := "Job Title";
            SalutationFormula."Name 3"::"First Name":
              NamePart[3] := "First Name";
            SalutationFormula."Name 3"::"Middle Name":
              NamePart[3] := "Middle Name";
            SalutationFormula."Name 3"::Surname:
              NamePart[3] := Surname;
            SalutationFormula."Name 3"::Initials:
              NamePart[3] := Initials;
            SalutationFormula."Name 3"::"Company Name":
              NamePart[3] := "Company Name";
          end;

          CASE SalutationFormula."Name 4" OF
            SalutationFormula."Name 4"::"Job Title":
              NamePart[4] := "Job Title";
            SalutationFormula."Name 4"::"First Name":
              NamePart[4] := "First Name";
            SalutationFormula."Name 4"::"Middle Name":
              NamePart[4] := "Middle Name";
            SalutationFormula."Name 4"::Surname:
              NamePart[4] := Surname;
            SalutationFormula."Name 4"::Initials:
              NamePart[4] := Initials;
            SalutationFormula."Name 4"::"Company Name":
              NamePart[4] := "Company Name";
          end;

          CASE SalutationFormula."Name 5" OF
            SalutationFormula."Name 5"::"Job Title":
              NamePart[5] := "Job Title";
            SalutationFormula."Name 5"::"First Name":
              NamePart[5] := "First Name";
            SalutationFormula."Name 5"::"Middle Name":
              NamePart[5] := "Middle Name";
            SalutationFormula."Name 5"::Surname:
              NamePart[5] := Surname;
            SalutationFormula."Name 5"::Initials:
              NamePart[5] := Initials;
            SalutationFormula."Name 5"::"Company Name":
              NamePart[5] := "Company Name";
          end;

          OnAfterGetSalutation(SalutationType,LanguageCode,NamePart);

          FOR i := 1 TO 5 DO
            if NamePart[i] = '' then begin
              SubStr := '%' + FORMAT(i) + ' ';
              if STRPOS(SalutationFormula.Salutation,SubStr) > 0 then
                SalutationFormula.Salutation :=
                  DELSTR(SalutationFormula.Salutation,STRPOS(SalutationFormula.Salutation,SubStr),3);
            end;

          exit(STRSUBSTNO(SalutationFormula.Salutation,NamePart[1],NamePart[2],NamePart[3],NamePart[4],NamePart[5]))
        end;
    */



    //     procedure InheritCompanyToPersonData (NewCompanyContact@1000 :

    /*
    procedure InheritCompanyToPersonData (NewCompanyContact: Record 5050)
        begin
          "Company Name" := NewCompanyContact.Name;

          RMSetup.GET;
          if RMSetup."Inherit Salesperson Code" then
            "Salesperson Code" := NewCompanyContact."Salesperson Code";
          if RMSetup."Inherit Territory Code" then
            "Territory Code" := NewCompanyContact."Territory Code";
          if RMSetup."Inherit Country/Region Code" then
            "Country/Region Code" := NewCompanyContact."Country/Region Code";
          if RMSetup."Inherit Language Code" then
            "Language Code" := NewCompanyContact."Language Code";
          if RMSetup."Inherit Address Details" and StaleAddress then begin
            Address := NewCompanyContact.Address;
            "Address 2" := NewCompanyContact."Address 2";
            "Post Code" := NewCompanyContact."Post Code";
            City := NewCompanyContact.City;
            County := NewCompanyContact.County;
          end;
          if RMSetup."Inherit Communication Details" then begin
            UpdateFieldForNewCompany(FIELDNO("Phone No."));
            UpdateFieldForNewCompany(FIELDNO("Telex No."));
            UpdateFieldForNewCompany(FIELDNO("Fax No."));
            UpdateFieldForNewCompany(FIELDNO("Telex Answer Back"));
            UpdateFieldForNewCompany(FIELDNO("E-Mail"));
            UpdateFieldForNewCompany(FIELDNO("Home Page"));
            UpdateFieldForNewCompany(FIELDNO("Extension No."));
            UpdateFieldForNewCompany(FIELDNO("Mobile Phone No."));
            UpdateFieldForNewCompany(FIELDNO(Pager));
            UpdateFieldForNewCompany(FIELDNO("Correspondence Type"));
          end;
          CALCFIELDS("No. of Industry Groups","No. of Business Relations");

          OnAfterInheritCompanyToPersonData(Rec,xRec,NewCompanyContact);
        end;
    */



    /*
    LOCAL procedure StaleAddress () Stale : Boolean;
        var
    //       OldCompanyContact@1000 :
          OldCompanyContact: Record 5050;
    //       DummyContact@1001 :
          DummyContact: Record 5050;
        begin
          if OldCompanyContact.GET(xRec."Company No.") then
            Stale := IdenticalAddress(OldCompanyContact);
          Stale := Stale or IdenticalAddress(DummyContact);
        end;
    */


    //     LOCAL procedure UpdateFieldForNewCompany (FieldNo@1001 :

    /*
    LOCAL procedure UpdateFieldForNewCompany (FieldNo: Integer)
        var
    //       OldCompanyContact@1000 :
          OldCompanyContact: Record 5050;
    //       NewCompanyContact@1005 :
          NewCompanyContact: Record 5050;
    //       OldCompanyRecRef@1002 :
          OldCompanyRecRef: RecordRef;
    //       NewCompanyRecRef@1007 :
          NewCompanyRecRef: RecordRef;
    //       ContactRecRef@1003 :
          ContactRecRef: RecordRef;
    //       ContactFieldRef@1008 :
          ContactFieldRef: FieldRef;
    //       OldCompanyFieldValue@1004 :
          OldCompanyFieldValue: Text;
    //       ContactFieldValue@1006 :
          ContactFieldValue: Text;
    //       Stale@1009 :
          Stale: Boolean;
        begin
          ContactRecRef.GETTABLE(Rec);
          ContactFieldRef := ContactRecRef.FIELD(FieldNo);
          ContactFieldValue := FORMAT(ContactFieldRef.VALUE);

          if NewCompanyContact.GET("Company No.") then begin
            NewCompanyRecRef.GETTABLE(NewCompanyContact);
            if OldCompanyContact.GET(xRec."Company No.") then begin
              OldCompanyRecRef.GETTABLE(OldCompanyContact);
              OldCompanyFieldValue := FORMAT(OldCompanyRecRef.FIELD(FieldNo).VALUE);
              Stale := ContactFieldValue = OldCompanyFieldValue;
            end;
            if Stale or (ContactFieldValue = '') then begin
              ContactFieldRef.VALIDATE(NewCompanyRecRef.FIELD(FieldNo).VALUE);
              ContactRecRef.SETTABLE(Rec);
            end;
          end;
        end;
    */



    //     procedure SetHideValidationDialog (NewHideValidationDialog@1000 :

    /*
    procedure SetHideValidationDialog (NewHideValidationDialog: Boolean)
        begin
          HideValidationDialog := NewHideValidationDialog;
        end;
    */




    /*
    procedure GetHideValidationDialog () : Boolean;
        var
    //       IdentityManagement@1000 :
          IdentityManagement: Codeunit 9801;
        begin
          exit(HideValidationDialog or IdentityManagement.IsInvAppId);
        end;
    */




    /*
    procedure DisplayMap ()
        var
    //       MapPoint@1001 :
          MapPoint: Record 800;
    //       MapMgt@1000 :
          MapMgt: Codeunit 802;
        begin
          if MapPoint.FINDFIRST then
            MapMgt.MakeSelection(DATABASE::Contact,GETPOSITION)
          else
            MESSAGE(Text033);
        end;
    */



    /*
    LOCAL procedure ProcessNameChange ()
        var
    //       ContBusRel@1000 :
          ContBusRel: Record 5054;
    //       Cust@1001 :
          Cust: Record 18;
    //       Vend@1002 :
          Vend: Record 23;
        begin
          UpdateSearchName;

          if Type = Type::Company then
            "Company Name" := Name;

          if Type = Type::Person then begin
            ContBusRel.RESET;
            ContBusRel.SETCURRENTKEY("Link to Table","Contact No.");
            ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
            ContBusRel.SETRANGE("Contact No.","Company No.");
            if ContBusRel.FINDFIRST then
              if Cust.GET(ContBusRel."No.") then
                if Cust."Primary Contact No." = "No." then begin
                  Cust.Contact := Name;
                  Cust.MODIFY;
                end;

            ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
            if ContBusRel.FINDFIRST then
              if Vend.GET(ContBusRel."No.") then
                if Vend."Primary Contact No." = "No." then begin
                  Vend.Contact := Name;
                  Vend.MODIFY;
                end;
          end;
        end;
    */


    //     LOCAL procedure GetCompNo (ContactText@1000 :

    /*
    LOCAL procedure GetCompNo (ContactText: Text) : Text;
        var
    //       Contact@1001 :
          Contact: Record 5050;
    //       ContactWithoutQuote@1002 :
          ContactWithoutQuote: Text;
    //       ContactFilterFromStart@1003 :
          ContactFilterFromStart: Text;
    //       ContactFilterContains@1004 :
          ContactFilterContains: Text;
    //       ContactNo@1005 :
          ContactNo: Code[20];
        begin
          if ContactText = '' then
            exit('');

          if STRLEN(ContactText) <= MAXSTRLEN(Contact."Company No.") then
            if Contact.GET(COPYSTR(ContactText,1,MAXSTRLEN(Contact."Company No."))) then
              exit(Contact."No.");

          ContactWithoutQuote := CONVERTSTR(ContactText,'''','?');

          Contact.SETRANGE(Type,Contact.Type::Company);

          Contact.SETFILTER(Name,'''@' + ContactWithoutQuote + '''');
          if Contact.FINDFIRST then
            exit(Contact."No.");
          Contact.SETRANGE(Name);
          ContactFilterFromStart := '''@' + ContactWithoutQuote + '*''';
          Contact.FILTERGROUP := -1;
          Contact.SETFILTER("No.",ContactFilterFromStart);
          Contact.SETFILTER(Name,ContactFilterFromStart);
          if Contact.FINDFIRST then
            exit(Contact."No.");
          ContactFilterContains := '''@*' + ContactWithoutQuote + '*''';
          Contact.SETFILTER("No.",ContactFilterContains);
          Contact.SETFILTER(Name,ContactFilterContains);
          Contact.SETFILTER(City,ContactFilterContains);
          Contact.SETFILTER("Phone No.",ContactFilterContains);
          Contact.SETFILTER("Post Code",ContactFilterContains);
          CASE Contact.COUNT OF
            1:
              begin
                Contact.FINDFIRST;
                exit(Contact."No.");
              end;
            else begin
              if not GUIALLOWED then
                ERROR(SelectContactErr);
              ContactNo := SelectContact(Contact);
              if ContactNo <> '' then
                exit(ContactNo);
            end;
          end;
          ERROR(SelectContactErr);
        end;
    */


    //     LOCAL procedure SelectContact (var Contact@1000 :

    /*
    LOCAL procedure SelectContact (var Contact: Record 5050) : Code[20];
        var
    //       ContactList@1001 :
          ContactList: Page 5052;
        begin
          if Contact.FINDSET then
            repeat
              Contact.MARK(TRUE);
            until Contact.NEXT = 0;
          if Contact.FINDFIRST then;
          Contact.MARKEDONLY := TRUE;

          ContactList.SETTABLEVIEW(Contact);
          ContactList.SETRECORD(Contact);
          ContactList.LOOKUPMODE := TRUE;
          if ContactList.RUNMODAL = ACTION::LookupOK then
            ContactList.GETRECORD(Contact)
          else
            CLEAR(Contact);

          exit(Contact."No.");
        end;
    */




    /*
    procedure LookupCompany ()
        var
    //       Contact@1001 :
          Contact: Record 5050;
    //       CompanyDetails@1000 :
          CompanyDetails: Page 5054;
        begin
          if "Company No." = '' then
            exit;

          Contact.GET("Company No.");
          CompanyDetails.SETRECORD(Contact);
          CompanyDetails.EDITABLE := FALSE;
          CompanyDetails.RUNMODAL;
        end;
    */




    /*
    procedure LookupCustomerTemplate () : Code[20];
        var
    //       CustomerTemplate@1001 :
          CustomerTemplate: Record 5105;
    //       CustomerTemplateList@1000 :
          CustomerTemplateList: Page 5156;
        begin
          CustomerTemplate.FILTERGROUP(2);
          CustomerTemplate.SETRANGE("Contact Type",Type);
          CustomerTemplate.FILTERGROUP(0);
          CustomerTemplateList.LOOKUPMODE := TRUE;
          CustomerTemplateList.SETTABLEVIEW(CustomerTemplate);
          if CustomerTemplateList.RUNMODAL = ACTION::LookupOK then begin
            CustomerTemplateList.GETRECORD(CustomerTemplate);
            exit(CustomerTemplate.Code);
          end;
        end;
    */



    //     procedure CheckForExistingRelationships (LinkToTable@1000 :

    /*
    procedure CheckForExistingRelationships (LinkToTable: Option " ","Customer","Vendor","Bank Accoun")
        var
    //       Contact@1001 :
          Contact: Record 5050;
    //       ContBusRel@1003 :
          ContBusRel: Record 5054;
        begin
          Contact := Rec;
          ContBusRel."Link to Table" := LinkToTable;

          if "No." <> '' then begin
            if ContBusRel.FindByContact(LinkToTable,Contact."No.") then
              ERROR(
                AlreadyExistErr,
                Contact.TABLECAPTION,"No.",ContBusRel.TABLECAPTION,ContBusRel."Link to Table",ContBusRel."No.");
          end;
        end;
    */




    /*
    procedure SetLastDateTimeModified ()
        var
    //       DotNet_DateTimeOffset@1000 :
          DotNet_DateTimeOffset: Codeunit 3006;
    //       UtcNow@1001 :
          UtcNow: DateTime;
        begin
          UtcNow := DotNet_DateTimeOffset.ConvertToUtcDateTime(CURRENTDATETIME);
          "Last Date Modified" := DT2DATE(UtcNow);
          "Last Time Modified" := DT2TIME(UtcNow);
        end;
    */




    /*
    procedure GetLastDateTimeModified () : DateTime;
        var
    //       DotNet_DateTime@1001 :
          DotNet_DateTime: Codeunit 3003;
    //       TypeHelper@1005 :
          TypeHelper: Codeunit 10;
    //       Hour@1002 :
          Hour: Integer;
    //       Minute@1003 :
          Minute: Integer;
    //       Second@1004 :
          Second: Integer;
        begin
          if "Last Date Modified" = 0D then
            exit(0DT);

          TypeHelper.GetHMSFromTime(Hour,Minute,Second,"Last Time Modified");

          DotNet_DateTime.CreateUTC(
            DATE2DMY("Last Date Modified",3),
            DATE2DMY("Last Date Modified",2),
            DATE2DMY("Last Date Modified",1),
            Hour,Minute,Second);
          exit(DotNet_DateTime.ToDateTime);
        end;
    */



    //     procedure SetLastDateTimeFilter (DateFilter@1001 :

    /*
    procedure SetLastDateTimeFilter (DateFilter: DateTime)
        var
    //       DotNet_DateTimeOffset@1004 :
          DotNet_DateTimeOffset: Codeunit 3006;
    //       SyncDateTimeUtc@1002 :
          SyncDateTimeUtc: DateTime;
    //       CurrentFilterGroup@1003 :
          CurrentFilterGroup: Integer;
        begin
          SyncDateTimeUtc := DotNet_DateTimeOffset.ConvertToUtcDateTime(DateFilter);
          CurrentFilterGroup := FILTERGROUP;
          SETFILTER("Last Date Modified",'>=%1',DT2DATE(SyncDateTimeUtc));
          FILTERGROUP(-1);
          SETFILTER("Last Date Modified",'>%1',DT2DATE(SyncDateTimeUtc));
          SETFILTER("Last Time Modified",'>%1',DT2TIME(SyncDateTimeUtc));
          FILTERGROUP(CurrentFilterGroup);
        end;
    */



    //     procedure TouchContact (ContactNo@1000 :

    /*
    procedure TouchContact (ContactNo: Code[20])
        var
    //       Cont@1001 :
          Cont: Record 5050;
        begin
          Cont.LOCKTABLE;
          if Cont.GET(ContactNo) then begin
            Cont.SetLastDateTimeModified;
            Cont.MODIFY;
          end;
        end;
    */




    /*
    procedure CountNoOfBusinessRelations () : Integer;
        var
    //       ContactBusinessRelation@1000 :
          ContactBusinessRelation: Record 5054;
        begin
          if "Company No." <> '' then
            ContactBusinessRelation.SETFILTER("Contact No.",'%1|%2',"No.","Company No.")
          else
            ContactBusinessRelation.SETRANGE("Contact No.","No.");
          exit(ContactBusinessRelation.COUNT);
        end;
    */




    /*
    procedure CreateSalesQuoteFromContact ()
        var
    //       SalesHeader@1001 :
          SalesHeader: Record 36;
        begin
          CheckIfPrivacyBlockedGeneric;
          SalesHeader.INIT;
          SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::Quote);
          SalesHeader.INSERT(TRUE);
          SalesHeader.VALIDATE("Document Date",WORKDATE);
          SalesHeader.VALIDATE("Sell-to Contact No.","No.");
          SalesHeader.MODIFY;
          PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
        end;
    */




    /*
    procedure ContactToCustBusinessRelationExist () : Boolean;
        var
    //       ContBusRel@1000 :
          ContBusRel: Record 5054;
        begin
          ContBusRel.RESET;
          ContBusRel.SETRANGE("Contact No.","No.");
          ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
          exit(ContBusRel.FINDFIRST);
        end;
    */




    /*
    procedure CheckIfMinorForProfiles ()
        begin
          if Minor then
            ERROR(ProfileForMinorErr);
        end;
    */



    //     procedure CheckIfPrivacyBlocked (IsPosting@1000 :

    /*
    procedure CheckIfPrivacyBlocked (IsPosting: Boolean)
        begin
          if "Privacy Blocked" then begin
            if IsPosting then
              ERROR(PrivacyBlockedPostErr,"No.");
            ERROR(PrivacyBlockedCreateErr,"No.");
          end;
        end;
    */




    /*
    procedure CheckIfPrivacyBlockedGeneric ()
        begin
          if "Privacy Blocked" then
            ERROR(PrivacyBlockedGenericErr,"No.");
        end;
    */



    /*
    LOCAL procedure ValidateSalesPerson ()
        begin
          if "Salesperson Code" <> '' then
            if Salesperson.GET("Salesperson Code") then
              if Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) then
                ERROR(Salesperson.GetPrivacyBlockedGenericText(Salesperson,TRUE))
        end;
    */



    //     LOCAL procedure OnAfterGetSalutation (var SalutationType@1001 : 'Formal,Informal';var LanguageCode@1000 : Code[10];var NamePart@1002 :

    /*
    LOCAL procedure OnAfterGetSalutation (var SalutationType: Option "Formal","Informal";var LanguageCode: Code[10];var NamePart: ARRAY [5] OF Text[50])
        begin
        end;
    */



    //     LOCAL procedure OnAfterInheritCompanyToPersonData (var Contact@1000 : Record 5050;xContact@1001 : Record 5050;NewCompanyContact@1002 :

    /*
    LOCAL procedure OnAfterInheritCompanyToPersonData (var Contact: Record 5050;xContact: Record 5050;NewCompanyContact: Record 5050)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateQuotesForContact (Contact@1000 : Record 5050;Customer@1001 :

    /*
    LOCAL procedure OnAfterUpdateQuotesForContact (Contact: Record 5050;Customer: Record 18)
        begin
        end;
    */



    //     LOCAL procedure OnAfterVendorInsert (var Vendor@1000 : Record 23;Contact@1001 :


    LOCAL procedure OnAfterVendorInsert(var Vendor: Record 23; Contact: Record 5050)
    begin
    end;




    //     LOCAL procedure OnBeforeVendorInsert (var Vend@1000 :

    [IntegrationEvent(TRUE, TRUE)]
    LOCAL procedure OnBeforeVendorInsert(var Vend: Record 23)
    begin
    end;

    //  [Integration(TRUE)]


    //     LOCAL procedure OnBeforeCustomerInsert (var Cust@1000 : Record 18;CustomerTemplate@1001 :

    /*
    LOCAL procedure OnBeforeCustomerInsert (var Cust: Record 18;CustomerTemplate: Code[10])
        begin
        end;
    */



    //     LOCAL procedure OnBeforeIsUpdateNeeded (Contact@1000 : Record 5050;xContact@1001 : Record 5050;var UpdateNeeded@1002 :

    /*
    LOCAL procedure OnBeforeIsUpdateNeeded (Contact: Record 5050;xContact: Record 5050;var UpdateNeeded: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnCreateCustomerOnBeforeCustomerModify (var Customer@1000 : Record 18;Contact@1001 :

    /*
    LOCAL procedure OnCreateCustomerOnBeforeCustomerModify (var Customer: Record 18;Contact: Record 5050)
        begin
        end;
    */



    //     LOCAL procedure OnCreateCustomerOnTransferFieldsFromTemplate (var Customer@1000 : Record 18;CustomerTemplate@1001 :

    /*
    LOCAL procedure OnCreateCustomerOnTransferFieldsFromTemplate (var Customer: Record 18;CustomerTemplate: Record 5105)
        begin
        end;
    */



    /*
    LOCAL procedure SetDefaultSalesperson ()
        var
    //       UserSetup@1000 :
          UserSetup: Record 91;
        begin
          if UserSetup.GET(USERID) and (UserSetup."Salespers./Purch. Code" <> '') then
            "Salesperson Code" := UserSetup."Salespers./Purch. Code";
        end;
    */



    /*
    LOCAL procedure VATRegistrationValidation ()
        var
    //       VATRegistrationNoFormat@1005 :
          VATRegistrationNoFormat: Record 381;
    //       VATRegistrationLog@1004 :
          VATRegistrationLog: Record 249;
    //       VATRegNoSrvConfig@1003 :
          VATRegNoSrvConfig: Record 248;
    //       VATRegistrationLogMgt@1002 :
          VATRegistrationLogMgt: Codeunit 249;
    //       ResultRecordRef@1001 :
          ResultRecordRef: RecordRef;
    //       ApplicableCountryCode@1000 :
          ApplicableCountryCode: Code[10];
        begin
          if not VATRegistrationNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Contact) then
            exit;

          VATRegistrationLogMgt.LogContact(Rec);

          if ("Country/Region Code" = '') and (VATRegistrationNoFormat."Country/Region Code" = '') then
            exit;
          ApplicableCountryCode := "Country/Region Code";
          if ApplicableCountryCode = '' then
            ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";

          if VATRegNoSrvConfig.VATRegNoSrvIsEnabled then begin
            VATRegistrationLogMgt.ValidateVATRegNoWithVIES(ResultRecordRef,Rec,"No.",
              VATRegistrationLog."Account Type"::Contact,ApplicableCountryCode);
            ResultRecordRef.SETTABLE(Rec);
          end;
        end;
    */



    //     procedure GetContNo (ContactText@1000 :

    /*
    procedure GetContNo (ContactText: Text) : Code[20];
        var
    //       Contact@1001 :
          Contact: Record 5050;
    //       ContactWithoutQuote@1005 :
          ContactWithoutQuote: Text;
    //       ContactFilterFromStart@1004 :
          ContactFilterFromStart: Text;
    //       ContactFilterContains@1003 :
          ContactFilterContains: Text;
        begin
          if ContactText = '' then
            exit('');

          if STRLEN(ContactText) <= MAXSTRLEN(Contact."No.") then
            if Contact.GET(COPYSTR(ContactText,1,MAXSTRLEN(Contact."No."))) then
              exit(Contact."No.");

          Contact.SETRANGE(Name,ContactText);
          if Contact.FINDFIRST then
            exit(Contact."No.");

          Contact.SETCURRENTKEY(Name);

          ContactWithoutQuote := CONVERTSTR(ContactText,'''','?');
          Contact.SETFILTER(Name,'''@' + ContactWithoutQuote + '''');
          if Contact.FINDFIRST then
            exit(Contact."No.");

          Contact.SETRANGE(Name);

          ContactFilterFromStart := '''@' + ContactWithoutQuote + '*''';
          Contact.FILTERGROUP := -1;
          Contact.SETFILTER("No.",ContactFilterFromStart);
          Contact.SETFILTER(Name,ContactFilterFromStart);
          if Contact.FINDFIRST then
            exit(Contact."No.");

          ContactFilterContains := '''@*' + ContactWithoutQuote + '*''';
          Contact.SETFILTER("No.",ContactFilterContains);
          Contact.SETFILTER(Name,ContactFilterContains);
          Contact.SETFILTER(City,ContactFilterContains);
          Contact.SETFILTER("Phone No.",ContactFilterContains);
          Contact.SETFILTER("Post Code",ContactFilterContains);
          if Contact.COUNT = 0 then
            MarkContactsWithSimilarName(Contact,ContactText);

          if Contact.COUNT = 1 then begin
            Contact.FINDFIRST;
            exit(Contact."No.");
          end;

          exit('');
        end;
    */


    //     LOCAL procedure MarkContactsWithSimilarName (var Contact@1001 : Record 5050;ContactText@1000 :

    /*
    LOCAL procedure MarkContactsWithSimilarName (var Contact: Record 5050;ContactText: Text)
        var
    //       TypeHelper@1002 :
          TypeHelper: Codeunit 10;
    //       ContactCount@1003 :
          ContactCount: Integer;
    //       ContactTextLength@1004 :
          ContactTextLength: Integer;
    //       Treshold@1005 :
          Treshold: Integer;
        begin
          if ContactText = '' then
            exit;
          if STRLEN(ContactText) > MAXSTRLEN(Contact.Name) then
            exit;

          ContactTextLength := STRLEN(ContactText);
          Treshold := ContactTextLength DIV 5;
          if Treshold = 0 then
            exit;

          Contact.RESET;
          Contact.ASCENDING(FALSE); // most likely to search for newest contacts
          if Contact.FINDSET then
            repeat
              ContactCount += 1;
              if ABS(ContactTextLength - STRLEN(Contact.Name)) <= Treshold then
                if TypeHelper.TextDistance(UPPERCASE(ContactText),UPPERCASE(Contact.Name)) <= Treshold then
                  Contact.MARK(TRUE);
            until Contact.MARK or (Contact.NEXT = 0) or (ContactCount > 1000);
          Contact.MARKEDONLY(TRUE);
        end;
    */



    /*
    LOCAL procedure IsUpdateNeeded () : Boolean;
        var
    //       UpdateNeeded@1000 :
          UpdateNeeded: Boolean;
        begin
          UpdateNeeded :=
            (Name <> xRec.Name) or
            ("Search Name" <> xRec."Search Name") or
            ("Name 2" <> xRec."Name 2") or
            (Address <> xRec.Address) or
            ("Address 2" <> xRec."Address 2") or
            (City <> xRec.City) or
            ("Phone No." <> xRec."Phone No.") or
            ("Telex No." <> xRec."Telex No.") or
            ("Territory Code" <> xRec."Territory Code") or
            ("Currency Code" <> xRec."Currency Code") or
            ("Language Code" <> xRec."Language Code") or
            ("Salesperson Code" <> xRec."Salesperson Code") or
            ("Country/Region Code" <> xRec."Country/Region Code") or
            ("Fax No." <> xRec."Fax No.") or
            ("Telex Answer Back" <> xRec."Telex Answer Back") or
            ("VAT Registration No." <> xRec."VAT Registration No.") or
            ("Post Code" <> xRec."Post Code") or
            (County <> xRec.County) or
            ("E-Mail" <> xRec."E-Mail") or
            ("Home Page" <> xRec."Home Page") or
            (Type <> xRec.Type);

          OnBeforeIsUpdateNeeded(Rec,xRec,UpdateNeeded);
          exit(UpdateNeeded);
        end;
    */



    //     LOCAL procedure OnAfterModifySellToCustomerNo (var SalesHeader@1000 : Record 36;var SalesLine@1001 :

    /*
    LOCAL procedure OnAfterModifySellToCustomerNo (var SalesHeader: Record 36;var SalesLine: Record 37)
        begin
        end;
    */



    //     LOCAL procedure OnAfterModifyBillToCustomerNo (var SalesHeader@1000 : Record 36;var SalesLine@1001 :

    /*
    LOCAL procedure OnAfterModifyBillToCustomerNo (var SalesHeader: Record 36;var SalesLine: Record 37)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeApplyCompanyChangeToPerson (var PersonContact@1000 : Record 5050;Contact@1001 : Record 5050;xContact@1002 : Record 5050;var ContChanged@1003 :

    /*
    LOCAL procedure OnBeforeApplyCompanyChangeToPerson (var PersonContact: Record 5050;Contact: Record 5050;xContact: Record 5050;var ContChanged: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeDuplicateCheck (Contact@1000 : Record 5050;xContact@1001 : Record 5050;var IsDuplicateCheckNeeded@1002 :

    /*
    LOCAL procedure OnBeforeDuplicateCheck (Contact: Record 5050;xContact: Record 5050;var IsDuplicateCheckNeeded: Boolean)
        begin
        end;

        /*begin
        //{
    //      JAV 18/02/19: - Nuevos campos para tipo de contacto (" ",Administrador,Arquitecto,Varios) y valor de dimensi�n asociada
    //      JAV 18/02/19: - Al a�adir un contacto a una empresa, validar dimensi�n asociada
    //      JAV 09/07/19: - Al crear el proveedor del contacto no tiene sentido validar que tenga empresa asociada, debe ser una empresa
    //                    - Luego actua seg�n sea o no empresa correctamente
    //      JAV 19/09/19: - Si no se ha definido una dimensi�n para los referentes, no se procesan las mismas
    //      JAV 21/09/19: - Cambio del tipo de referente de option a una tabla, Mejora en el uso de la dimensi�n asociada al referente
    //      GAP006 PGM 12/07/2019 - Creado el campo Category asociado a la tabla Contact Categories
    //    }
        end.
      */
}





