Codeunit 50859 "Outlook Synch. Setup Defaults"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        OutlookSynchEntity: Record 51280;
        OutlookSynchField: Record 51284;
        OutlookSynchFilter: Record 51283;
        Text012: TextConst ENU = 'Reset to defaults...', ESP = 'Restaurar valores predeterminados...';
        Text013: TextConst ENU = '%1 of the %2 entity must be %3 not %4.', ESP = '%1 de la entidad %2 debe ser %3 no %4.';
        Text102: TextConst ENU = '%1 Contacts of the Person type', ESP = 'Contactos del tipo Persona de %1';
        OutlookSynchEntityElement: Record 51281;
        OutlookSynchDependency: Record 51289;
        OutlookSynchOptionCorrel: Record 51287;
        Field: Record 2000000041;
        OutlookSynchSetupMgt: Codeunit 50849;
        OutlookSynchTypeConv: Codeunit 5302;
        Text100: TextConst ENU = '%1 Meetings', ESP = 'Reuniones de %1';
        Text101: TextConst ENU = '%1 Tasks', ESP = 'Tareas de %1';
        Text103: TextConst ENU = '%1 Contacts of the Company type', ESP = 'Contactos del tipo Empresa de %1';
        Text104: TextConst ENU = '%1 Salespeople', ESP = 'Vendedores de %1';
        Text110: TextConst ENU = 'CONT_PERS', ESP = 'CONT_PERS';
        Text111: TextConst ENU = 'CONT_COMP', ESP = 'CONT_COMP';
        Text112: TextConst ENU = 'CONT_SP', ESP = 'CONT_SP';
        Text130: TextConst ENU = 'APP', ESP = 'APP';
        Text131: TextConst ENU = 'TASK', ESP = 'TASK';

    //[External]
    PROCEDURE ResetEntity(SynchEntityCode: Code[10]);
    VAR
        Window: Dialog;
        Selected: Integer;
    BEGIN
        Selected :=
          STRMENU(
            STRSUBSTNO(
              '%1,%2,%3,%4,%5', STRSUBSTNO(Text100, PRODUCTNAME.FULL), STRSUBSTNO(Text101, PRODUCTNAME.FULL),
              STRSUBSTNO(Text103, PRODUCTNAME.FULL), STRSUBSTNO(Text102, PRODUCTNAME.FULL), STRSUBSTNO(Text104, PRODUCTNAME.FULL)));

        IF Selected = 0 THEN
            EXIT;

        OutlookSynchEntity.GET(SynchEntityCode);
        Window.OPEN(Text012);
        OutlookSynchEntity.DELETE(TRUE);

        CASE Selected OF
            1:
                CreateDefaultApp(SynchEntityCode);
            2:
                CreateDefaultTask(SynchEntityCode);
            3:
                CreateDefaultContComp(SynchEntityCode);
            4:
                CreateDefaultContPers(SynchEntityCode);
            5:
                CreateDefaultContSp(SynchEntityCode);
        END;

        Window.CLOSE;
    END;

    //[External]
    PROCEDURE InsertOSynchDefaults();
    VAR
        OutlookSynchEntity: Record 51280;
        WebService: Record 2000000076;
        WebServiceManagement: Codeunit 9750;
        FieldLength: Integer;
    BEGIN
        IF NOT OutlookSynchEntity.ISEMPTY THEN
            EXIT;

        FieldLength := MAXSTRLEN(OutlookSynchEntity.Code);

        CreateDefaultContPers(COPYSTR(Text110, 1, FieldLength));

        CreateDefaultContComp(COPYSTR(Text111, 1, FieldLength));

        CreateDefaultContSp(COPYSTR(Text112, 1, FieldLength));

        CreateDefaultApp(COPYSTR(Text130, 1, FieldLength));

        CreateDefaultTask(COPYSTR(Text131, 1, FieldLength));

        // WebServiceManagement.CreateWebService(
        //   WebService."Object Type"::Codeunit,CODEUNIT::"Outlook Synch. Dispatcher",'DynamicsNAVsynchOutlook',FALSE);
    END;

    LOCAL PROCEDURE CreateDefaultContPers(SynchEntityCodeIn: Code[10]);
    VAR
        Contact: Record 5050;
        OptionCaption: Text;
    BEGIN
        InsertOSynchEntity(SynchEntityCodeIn, STRSUBSTNO(Text102, PRODUCTNAME.FULL), 5050, 'ContactItem');

        WITH OutlookSynchEntity DO BEGIN
            InsertConstConditionFilter(SynchEntityCodeIn, '1');

            OptionCaption := OutlookSynchTypeConv.FieldOptionValueToText(Contact.Type::Person.AsInteger(), "Table No.", Contact.FIELDNO(Type));
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", '', FALSE, FALSE, 0, Contact.FIELDNO(Type), OptionCaption, 1);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'CompanyName', FALSE, FALSE, 5050, 5052, '', 0);
        END;

        WITH OutlookSynchField DO BEGIN
            RESET;
            SETRANGE("Synch. Entity Code", OutlookSynchEntity.Code);
            SETRANGE("Element No.", 0);
            IF FINDLAST THEN BEGIN
                InsertOSynchTableRelationFilter("Record GUID", "Table No.", 1, OutlookSynchFilter.Type::FIELD, "Master Table No.", 5051, '');
                InsertOSynchTableRelationFilter("Record GUID", "Table No.", 5050, OutlookSynchFilter.Type::CONST, 0, 0, '0');
                "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 1);
                MODIFY;
            END;
        END;

        WITH OutlookSynchEntity DO BEGIN
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'FullName', FALSE, FALSE, 0, 2, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'FirstName', FALSE, FALSE, 0, 5054, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'MiddleName', FALSE, FALSE, 0, 5055, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'LastName', FALSE, FALSE, 0, 5056, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'JobTitle', FALSE, FALSE, 0, 5058, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessAddressStreet', FALSE, FALSE, 0, 5, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessAddressCity', FALSE, FALSE, 0, 7, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessAddressPostalCode', FALSE, FALSE, 0, 91, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessAddressCountry', FALSE, FALSE, 9, 2, '', 0);
        END;

        InsertFieldTableRelationFilter(OutlookSynchEntity.Code, 1, 35);

        WITH OutlookSynchEntity DO BEGIN
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessTelephoneNumber', FALSE, FALSE, 0, 9, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessFaxNumber', FALSE, FALSE, 0, 84, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessHomePage', FALSE, FALSE, 0, 103, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Email1Address', FALSE, FALSE, 0, 102, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Email2Address', FALSE, FALSE, 0, 5105, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'MobileTelephoneNumber', FALSE, FALSE, 0, 5061, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'PagerNumber', FALSE, FALSE, 0, 5062, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'TelexNumber', FALSE, FALSE, 0, 10, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Salesperson Code', TRUE, FALSE, 0, 29, '', 0);
        END;

        InsertDefaultDependency(OutlookSynchEntity, Text130, 'Recipients');
        InsertDefaultDependency(OutlookSynchEntity, Text130, 'Links');
        InsertDefaultDependency(OutlookSynchEntity, Text131, 'Links');
    END;

    LOCAL PROCEDURE CreateDefaultContComp(SynchEntityCodeIn: Code[10]);
    VAR
        Contact: Record 5050;
        OptionCaption: Text;
    BEGIN
        InsertOSynchEntity(SynchEntityCodeIn, STRSUBSTNO(Text103, PRODUCTNAME.FULL), 5050, 'ContactItem');

        WITH OutlookSynchEntity DO BEGIN
            InsertConstConditionFilter(SynchEntityCodeIn, '0');

            OptionCaption := OutlookSynchTypeConv.FieldOptionValueToText(Contact.Type::Company.AsInteger(), "Table No.", Contact.FIELDNO(Type));
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", '', FALSE, FALSE, 0, Contact.FIELDNO(Type), OptionCaption, 1);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessAddressStreet', FALSE, FALSE, 0, 5, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessAddressCity', FALSE, FALSE, 225, 2, '', 0);
        END;

        WITH OutlookSynchField DO BEGIN
            InsertFieldTableRelationFilter(OutlookSynchEntity.Code, 2, 7);

            InsertOutlookSynchField(
              OutlookSynchEntity.Code, 0, OutlookSynchEntity."Table No.", OutlookSynchEntity."Outlook Item", 'BusinessAddressPostalCode',
              FALSE, FALSE, 225, 1, '', 0);

            InsertFieldTableRelationFilter(OutlookSynchEntity.Code, 1, 91);

            InsertOutlookSynchField(
              OutlookSynchEntity.Code, 0, OutlookSynchEntity."Table No.", OutlookSynchEntity."Outlook Item", 'BusinessAddressCountry', FALSE,
              FALSE, 9, 2, '', 0);

            InsertFieldTableRelationFilter(OutlookSynchEntity.Code, 1, 35);
        END;

        WITH OutlookSynchEntity DO BEGIN
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessTelephoneNumber', FALSE, FALSE, 0, 9, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'CompanyName', FALSE, FALSE, 0, 2, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessFaxNumber', FALSE, FALSE, 0, 84, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Email1Address', FALSE, FALSE, 0, 102, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Email2Address', FALSE, FALSE, 0, 5105, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessHomePage', FALSE, FALSE, 0, 103, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'MobileTelephoneNumber', FALSE, FALSE, 0, 5061, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'PagerNumber', FALSE, FALSE, 0, 5062, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'TelexNumber', FALSE, FALSE, 0, 10, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Salesperson Code', TRUE, FALSE, 0, 29, '', 0);
        END;

        InsertDefaultDependency(OutlookSynchEntity, Text130, 'Recipients');
        InsertDefaultDependency(OutlookSynchEntity, Text130, 'Links');
        InsertDefaultDependency(OutlookSynchEntity, Text131, 'Links');
    END;

    LOCAL PROCEDURE CreateDefaultContSp(SynchEntityCodeIn: Code[10]);
    BEGIN
        InsertOSynchEntity(SynchEntityCodeIn, STRSUBSTNO(Text104, PRODUCTNAME.FULL), 13, 'ContactItem');

        WITH OutlookSynchEntity DO BEGIN
            GET(SynchEntityCodeIn);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'FullName', FALSE, FALSE, 0, 2, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'JobTitle', FALSE, FALSE, 0, 5062, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Email1Address', FALSE, FALSE, 0, 5052, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Email2Address', FALSE, FALSE, 0, 5086, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'BusinessTelephoneNumber', FALSE, FALSE, 0, 5053, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Salesperson Code', TRUE, FALSE, 0, 1, '', 1);
        END;

        InsertDefaultDependency(OutlookSynchEntity, Text130, 'Recipients');
        InsertDefaultDependency(OutlookSynchEntity, Text130, 'Links');
    END;

    LOCAL PROCEDURE CreateDefaultTask(SynchEntityCodeIn: Code[10]);
    VAR
        OutlookSynchEntity1: Record 51280;
    BEGIN
        WITH OutlookSynchEntity DO BEGIN
            IF GET(Text110) THEN
                IF "Table No." <> 5050 THEN
                    ERROR(Text013, FIELDCAPTION("Table No."), Text110, 5050, "Table No.");

            IF GET(Text111) THEN
                IF "Table No." <> 5050 THEN
                    ERROR(Text013, FIELDCAPTION("Table No."), Text111, 5050, "Table No.");

            InsertOSynchEntity(SynchEntityCodeIn, STRSUBSTNO(Text101, PRODUCTNAME.FULL), 5080, 'TaskItem');

            GET(SynchEntityCodeIn);
            InsertOSynchConditionFilter("Record GUID", "Table No.", 8, OutlookSynchFilter.Type::FILTER, 0, 0, '<>1');
            InsertOSynchConditionFilter("Record GUID", "Table No.", 45, OutlookSynchFilter.Type::CONST, 0, 0, '0');
            InsertOSynchConditionFilter("Record GUID", "Table No.", 2, OutlookSynchFilter.Type::CONST, 0, 0, '');
            Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 0);
            MODIFY;

            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", '', FALSE, FALSE, 0, 8, '', 1);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'StartDate', FALSE, FALSE, 0, 9, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'StartDate', FALSE, FALSE, 0, 28, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'DueDate', FALSE, FALSE, 0, 47, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'DueDate', FALSE, FALSE, 0, 48, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Subject', FALSE, FALSE, 0, 12, '', 0);
        END;

        WITH OutlookSynchField DO BEGIN
            InsertOutlookSynchField(
              OutlookSynchEntity.Code, 0, OutlookSynchEntity."Table No.", OutlookSynchEntity."Outlook Item", 'Importance', FALSE, FALSE, 0, 11,
              '', 0);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olImportanceLow', 0, 0);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olImportanceNormal', 1, 1);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olImportanceHigh', 2, 2);

            InsertOutlookSynchField(
              OutlookSynchEntity.Code, 0, OutlookSynchEntity."Table No.", OutlookSynchEntity."Outlook Item", 'Status', FALSE, FALSE, 0, 10, '', 0);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olTaskNotStarted', 0, 0);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olTaskInProgress', 1, 1);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olTaskComplete', 2, 2);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olTaskWaiting', 3, 3);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olTaskDeferred', 4, 4);

            InsertOutlookSynchField(
              OutlookSynchEntity.Code, 0, OutlookSynchEntity."Table No.", OutlookSynchEntity."Outlook Item", 'Owner', FALSE, FALSE, 13, 2, '', 0);
            InsertFieldTableRelationFilter(OutlookSynchEntity.Code, 1, 3);
        END;

        WITH OutlookSynchEntityElement DO BEGIN
            InsertOutlookSynchEntityElement(OutlookSynchEntity.Code, 5080, 'Links');
            InsertGroupTableRelationFilter(OutlookSynchEntity.Code, 5, OutlookSynchFilter.Type::FILTER, '<>''''');
            InsertODependency("Synch. Entity Code", "Element No.", Text110);
            OutlookSynchDependency.GET("Synch. Entity Code", "Element No.", Text110);
            OutlookSynchEntity1.GET(OutlookSynchDependency."Depend. Synch. Entity Code");
            InsertOSynchTableRelationFilter(
              OutlookSynchDependency."Record GUID", OutlookSynchEntity1."Table No.", 1, OutlookSynchFilter.Type::FIELD, "Table No.", 5, '');
            OutlookSynchDependency."Table Relation" :=
              OutlookSynchSetupMgt.ComposeFilterExpression(OutlookSynchDependency."Record GUID", 1);
            OutlookSynchDependency.MODIFY;

            InsertODependency("Synch. Entity Code", "Element No.", Text111);
            OutlookSynchDependency.GET("Synch. Entity Code", "Element No.", Text111);
            OutlookSynchEntity1.GET(OutlookSynchDependency."Depend. Synch. Entity Code");
            InsertOSynchTableRelationFilter(
              OutlookSynchDependency."Record GUID", OutlookSynchEntity1."Table No.", 1, OutlookSynchFilter.Type::FIELD,
              OutlookSynchField."Master Table No.", 5, '');
            OutlookSynchDependency."Table Relation" :=
              OutlookSynchSetupMgt.ComposeFilterExpression(OutlookSynchDependency."Record GUID", 1);
            OutlookSynchDependency.MODIFY;

            InsertOutlookSynchField("Synch. Entity Code", "Element No.", "Table No.", "Outlook Collection", 'Name', FALSE, TRUE, 5050, 2, '', 2);
        END;

        WITH OutlookSynchField DO BEGIN
            RESET;
            SETRANGE("Synch. Entity Code", OutlookSynchEntity.Code);
            SETRANGE("Element No.", OutlookSynchEntityElement."Element No.");
            IF FINDLAST THEN BEGIN
                OutlookSynchEntityElement.CALCFIELDS("Master Table No.");
                InsertOSynchTableRelationFilter("Record GUID", "Table No.", 1, OutlookSynchFilter.Type::FIELD, "Master Table No.", 5, '');
                "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 1);
                MODIFY;
            END;
        END;
    END;

    LOCAL PROCEDURE CreateDefaultApp(SynchEntityCodeIn: Code[10]);
    VAR
        Task: Record 5080;
        OptionCaption: Text;
    BEGIN
        WITH OutlookSynchEntity DO BEGIN
            IF GET(Text110) THEN
                IF "Table No." <> 5050 THEN
                    ERROR(Text013, FIELDCAPTION("Table No."), Text110, 5050, "Table No.");

            IF GET(Text111) THEN
                IF "Table No." <> 5050 THEN
                    ERROR(Text013, FIELDCAPTION("Table No."), Text111, 5050, "Table No.");

            IF GET(Text112) THEN
                IF "Table No." <> 13 THEN
                    ERROR(Text013, FIELDCAPTION("Table No."), Text112, 13, "Table No.");

            InsertOSynchEntity(SynchEntityCodeIn, STRSUBSTNO(Text100, PRODUCTNAME.FULL), 5080, 'AppointmentItem');

            GET(SynchEntityCodeIn);
            InsertOSynchConditionFilter("Record GUID", "Table No.", 8, OutlookSynchFilter.Type::CONST, 0, 0, '1');
            InsertOSynchConditionFilter("Record GUID", "Table No.", 17, OutlookSynchFilter.Type::CONST, 0, 0, '0');
            InsertOSynchConditionFilter("Record GUID", "Table No.", 45, OutlookSynchFilter.Type::CONST, 0, 0, '0');
            InsertOSynchConditionFilter("Record GUID", "Table No.", 2, OutlookSynchFilter.Type::CONST, 0, 0, '');
            Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 0);
            MODIFY;

            OptionCaption := OutlookSynchTypeConv.FieldOptionValueToText(Task.Type::Meeting.AsInteger(), "Table No.", Task.FIELDNO(Type));
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", '', FALSE, FALSE, 0, Task.FIELDNO(Type), OptionCaption, 1);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Start', FALSE, FALSE, 0, 9, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Start', FALSE, FALSE, 0, 28, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Subject', FALSE, FALSE, 0, 12, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'Location', FALSE, FALSE, 0, 35, '', 0);
            InsertOutlookSynchField(Code, 0, "Table No.", "Outlook Item", 'AllDayEvent', FALSE, FALSE, 0, 34, '', 0);
        END;

        WITH OutlookSynchField DO BEGIN
            InsertOutlookSynchField(
              OutlookSynchEntity.Code, 0, OutlookSynchEntity."Table No.", OutlookSynchEntity."Outlook Item", 'Importance', FALSE, FALSE, 0, 11,
              '', 0);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olImportanceLow', 0, 0);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olImportanceNormal', 1, 1);
            InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olImportanceHigh', 2, 2);

            InsertOutlookSynchField(
              OutlookSynchEntity.Code, 0, OutlookSynchEntity."Table No.", OutlookSynchEntity."Outlook Item", 'Duration', FALSE, FALSE, 0, 29, '', 0);
            InsertOutlookSynchField(
              OutlookSynchEntity.Code, 0, OutlookSynchEntity."Table No.", OutlookSynchEntity."Outlook Item", 'Organizer', FALSE, FALSE, 13, 2, '',
              2);
            InsertFieldTableRelationFilter(OutlookSynchEntity.Code, 1, 3);
        END;

        WITH OutlookSynchEntityElement DO BEGIN
            InsertOutlookSynchEntityElement(OutlookSynchEntity.Code, 5199, 'Recipients');
            RESET;
            SETRANGE("Synch. Entity Code", OutlookSynchEntity.Code);
            IF FINDLAST THEN BEGIN
                CALCFIELDS("Master Table No.");
                InsertOSynchTableRelationFilter("Record GUID", "Table No.", 1, OutlookSynchFilter.Type::FIELD, "Master Table No.", 1, '');
                InsertOSynchTableRelationFilter("Record GUID", "Table No.", 7, OutlookSynchFilter.Type::CONST, "Master Table No.", 0, '1');

                "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 1);
                MODIFY;
            END;
        END;

        InsertOutlookSyncDependencies;

        InsertOutlookSynchField(
          OutlookSynchEntityElement."Synch. Entity Code", OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement."Table No.",
          OutlookSynchEntityElement."Outlook Collection", '', FALSE, FALSE, 0, 7, FORMAT(TRUE), 1);
        InsertOutlookSynchField(
          OutlookSynchEntityElement."Synch. Entity Code", OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement."Table No.",
          OutlookSynchEntityElement."Outlook Collection", 'Type', FALSE, FALSE, 0, 3, '', 0);
        InsertOOptionCorrelation(
          OutlookSynchField."Synch. Entity Code", OutlookSynchField."Element No.", OutlookSynchField."Line No.", '0', 2, 0);
        InsertOOptionCorrelation(
          OutlookSynchField."Synch. Entity Code", OutlookSynchField."Element No.", OutlookSynchField."Line No.", '1', 0, 1);
        InsertOOptionCorrelation(
          OutlookSynchField."Synch. Entity Code", OutlookSynchField."Element No.", OutlookSynchField."Line No.", '2', 1, 2);

        WITH OutlookSynchField DO BEGIN
            InsertOutlookSynchField(
              OutlookSynchEntityElement."Synch. Entity Code", OutlookSynchEntityElement."Element No.",
              OutlookSynchEntityElement."Table No.", OutlookSynchEntityElement."Outlook Collection", 'Address', FALSE, TRUE, 5050, 102, '', 2);
            UpdateOutlookSynchField(
              OutlookSynchEntity.Code, OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement, '0');

            InsertOutlookSynchField(
              OutlookSynchEntity.Code, OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement."Table No.",
              OutlookSynchEntityElement."Outlook Collection", 'Address', FALSE, TRUE, 13, 5052, '', 2);
            UpdateOutlookSynchField(
              OutlookSynchEntity.Code, OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement, '1');

            InsertOutlookSynchField(
              OutlookSynchEntity.Code, OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement."Table No.",
              OutlookSynchEntityElement."Outlook Collection", 'MeetingResponseStatus', FALSE, FALSE, 0, 8, '', 2);
            RESET;
            SETRANGE("Synch. Entity Code", OutlookSynchEntityElement."Synch. Entity Code");
            SETRANGE("Element No.", OutlookSynchEntityElement."Element No.");
            IF FINDLAST THEN BEGIN
                InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olResponseNone', 0, 0);
                InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olResponseAccepted', 1, 3);
                InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olResponseDeclined', 2, 4);
                InsertOOptionCorrelation("Synch. Entity Code", "Element No.", "Line No.", 'olResponseTentative', 3, 2);
            END;
        END;

        InsertOutlookSynchEntityElement(OutlookSynchEntity.Code, 5199, 'Links');
        InsertGroupTableRelationFilter(OutlookSynchEntity.Code, 7, OutlookSynchFilter.Type::CONST, '0');
        InsertOutlookSyncDependencies;

        InsertOutlookSynchField(
          OutlookSynchEntity.Code, OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement."Table No.",
          OutlookSynchEntityElement."Outlook Collection", '', FALSE, FALSE, 0, 7, FORMAT(FALSE), 1);
        InsertOutlookSynchField(
          OutlookSynchEntity.Code, OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement."Table No.",
          OutlookSynchEntityElement."Outlook Collection", 'Name', FALSE, TRUE, 5050, 2, '', 2);
        UpdateOutlookSynchField(
          OutlookSynchEntity.Code, OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement, '0');

        InsertOutlookSynchField(
          OutlookSynchEntity.Code, OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement."Table No.",
          OutlookSynchEntityElement."Outlook Collection", 'Name', FALSE, TRUE, 13, 2, '', 2);
        UpdateOutlookSynchField(
          OutlookSynchEntity.Code, OutlookSynchEntityElement."Element No.", OutlookSynchEntityElement, '1');
    END;

    LOCAL PROCEDURE InsertOSynchEntity(SynchEntityCode: Code[10]; DescriptionString: Text; TableID: Integer; OutlookItem: Text);
    BEGIN
        WITH OutlookSynchEntity DO BEGIN
            INIT;
            Code := SynchEntityCode;
            Description := COPYSTR(DescriptionString, 1, MAXSTRLEN(Description));
            "Table No." := TableID;
            "Outlook Item" := COPYSTR(OutlookItem, 1, MAXSTRLEN("Outlook Item"));
            CALCFIELDS("Table Caption");
            INSERT(TRUE);
        END;
    END;

    LOCAL PROCEDURE InsertOutlookSynchEntityElement(SynchEntityCode: Code[10]; TableID: Integer; OutlookCollection: Text);
    BEGIN
        WITH OutlookSynchEntityElement DO BEGIN
            INIT;
            "Synch. Entity Code" := SynchEntityCode;
            "Element No." := "Element No." + 10000;
            "Table No." := TableID;
            "Outlook Collection" := COPYSTR(OutlookCollection, 1, MAXSTRLEN("Outlook Collection"));
            "Record GUID" := CREATEGUID;
            INSERT;
        END;
    END;

    LOCAL PROCEDURE InsertOSynchFilter(RecordGUID: GUID; FlterType: Integer; TableID: Integer; FieldID: Integer; CaseType: Integer; MasterTableID: Integer; MasterFieldID: Integer; ValueString: Text[250]);
    BEGIN
        WITH OutlookSynchFilter DO BEGIN
            INIT;
            "Record GUID" := RecordGUID;
            "Filter Type" := FlterType;
            "Line No." := "Line No." + 10000;
            "Table No." := TableID;
            VALIDATE("Field No.", FieldID);
            Type := CaseType;
            "Master Table No." := MasterTableID;

            IF MasterFieldID <> 0 THEN
                VALIDATE("Master Table Field No.", MasterFieldID)
            ELSE
                VALIDATE(Value, COPYSTR(ValueString, 1, MAXSTRLEN(Value)));

            UpdateFilterExpression;

            INSERT;
        END;
    END;

    LOCAL PROCEDURE InsertOSynchTableRelationFilter(RecordGUID: GUID; TableID: Integer; FieldID: Integer; CaseType: Integer; MasterTableID: Integer; MasterFieldID: Integer; ValueString: Text[250]);
    BEGIN
        InsertOSynchFilter(
          RecordGUID,
          OutlookSynchFilter."Filter Type"::"Table Relation",
          TableID,
          FieldID,
          CaseType,
          MasterTableID,
          MasterFieldID,
          ValueString);
    END;

    LOCAL PROCEDURE InsertOSynchConditionFilter(RecordGUID: GUID; TableID: Integer; FieldID: Integer; CaseType: Integer; MasterTableID: Integer; MasterFieldID: Integer; ValueString: Text[250]);
    BEGIN
        InsertOSynchFilter(
          RecordGUID,
          OutlookSynchFilter."Filter Type"::Condition,
          TableID,
          FieldID,
          CaseType,
          MasterTableID,
          MasterFieldID,
          ValueString);
    END;

    LOCAL PROCEDURE InsertOutlookSyncDependencies();
    BEGIN
        InsertOutlookSyncDependency(OutlookSynchDependency, Text110, '0');
        InsertOutlookSyncDependency(OutlookSynchDependency, Text111, '0');
        InsertOutlookSyncDependency(OutlookSynchDependency, Text112, '1');
    END;

    LOCAL PROCEDURE InsertOutlookSyncDependency(VAR OutlookSynchDependency: Record 51289; DependentEntityCode: Code[10]; FilterValueString: Text[250]);
    VAR
        OutlookSynchEntity1: Record 51280;
    BEGIN
        WITH OutlookSynchDependency DO BEGIN
            InsertODependency(
              OutlookSynchEntityElement."Synch. Entity Code", OutlookSynchEntityElement."Element No.", DependentEntityCode);
            GET(OutlookSynchEntityElement."Synch. Entity Code", OutlookSynchEntityElement."Element No.", DependentEntityCode);
            OutlookSynchEntity1.GET("Depend. Synch. Entity Code");
            InsertOSynchConditionFilter(
              "Record GUID", OutlookSynchEntityElement."Table No.", 4, OutlookSynchFilter.Type::CONST, 0, 0, FilterValueString);
            InsertOSynchTableRelationFilter(
              "Record GUID", OutlookSynchEntity1."Table No.", 1, OutlookSynchFilter.Type::FIELD, OutlookSynchEntityElement."Table No.", 5, '');
            Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 0);
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 1);
            MODIFY;
        END;
    END;

    LOCAL PROCEDURE InsertOutlookSynchField(SynchEntityCode: Code[10]; ElementNo: Integer; MasterTableID: Integer; OutlookObject: Text; OutlookProperty: Text; UserDefined: Boolean; SearchField: Boolean; TableID: Integer; FieldID: Integer; DefaulfValue: Text; ReadOnlyStatus: Integer);
    BEGIN
        WITH OutlookSynchField DO BEGIN
            INIT;
            "Synch. Entity Code" := SynchEntityCode;
            "Element No." := ElementNo;
            "Line No." := "Line No." + 10000;
            "Master Table No." := MasterTableID;
            "Table No." := TableID;
            "Outlook Object" := COPYSTR(OutlookObject, 1, MAXSTRLEN("Outlook Object"));
            "User-Defined" := UserDefined;
            "Search Field" := SearchField;
            "Field No." := FieldID;
            "Record GUID" := CREATEGUID;
            VALIDATE("Field Default Value", COPYSTR(DefaulfValue, 1, MAXSTRLEN("Field Default Value")));
            IF TableID = 0 THEN
                Field.GET(MasterTableID, FieldID)
            ELSE
                Field.GET(TableID, FieldID);
            "Outlook Property" := COPYSTR(OutlookProperty, 1, MAXSTRLEN("Outlook Property"));
            "Read-Only Status" := ReadOnlyStatus;
            INSERT;
        END;
    END;

    LOCAL PROCEDURE InsertOOptionCorrelation(SynchEntityCode: Code[10]; ElementNo: Integer; FieldLineNo: Integer; OutlookValue: Text; OptionID: Integer; EnumerationID: Integer);
    BEGIN
        WITH OutlookSynchOptionCorrel DO BEGIN
            INIT;
            "Element No." := ElementNo;
            "Field Line No." := FieldLineNo;
            "Line No." := "Line No." + 10000;
            VALIDATE("Synch. Entity Code", SynchEntityCode);
            VALIDATE("Outlook Value", COPYSTR(OutlookValue, 1, MAXSTRLEN("Outlook Value")));
            VALIDATE("Option No.", OptionID);
            "Enumeration No." := EnumerationID;
            INSERT;
        END;
    END;

    LOCAL PROCEDURE InsertODependency(SynchEntityCode: Code[10]; ElementNo: Integer; DependentEntityCode: Code[10]);
    VAR
        OutlookSynchEntity1: Record 51280;
    BEGIN
        WITH OutlookSynchDependency DO BEGIN
            IF NOT OutlookSynchEntity1.GET(DependentEntityCode) THEN BEGIN
                CASE DependentEntityCode OF
                    Text111:
                        CreateDefaultContComp(DependentEntityCode);
                    Text110:
                        CreateDefaultContPers(DependentEntityCode);
                    Text112:
                        CreateDefaultContSp(DependentEntityCode);
                END;
                OutlookSynchEntity.GET(SynchEntityCode);
            END;
            INIT;
            "Synch. Entity Code" := SynchEntityCode;
            "Element No." := ElementNo;
            VALIDATE("Depend. Synch. Entity Code", DependentEntityCode);
            "Record GUID" := CREATEGUID;
            INSERT;
        END;
    END;

    LOCAL PROCEDURE InsertDefaultDependency(OutlookSynchEntity1: Record 51280; DependEntityElemCode: Code[10]; DependEntityElemOCollection: Text);
    BEGIN
        OutlookSynchEntityElement.RESET;
        OutlookSynchEntityElement.SETRANGE("Synch. Entity Code", DependEntityElemCode);
        OutlookSynchEntityElement.SETRANGE("Outlook Collection", DependEntityElemOCollection);
        IF OutlookSynchEntityElement.FINDFIRST THEN BEGIN
            InsertODependency(
              OutlookSynchEntityElement."Synch. Entity Code", OutlookSynchEntityElement."Element No.", OutlookSynchEntity1.Code);
            OutlookSynchDependency.GET(
              OutlookSynchEntityElement."Synch. Entity Code", OutlookSynchEntityElement."Element No.", OutlookSynchEntity1.Code);
            IF DependEntityElemCode <> Text131 THEN
                IF OutlookSynchEntity1.Code = Text112 THEN
                    InsertOSynchConditionFilter(
                      OutlookSynchDependency."Record GUID", OutlookSynchEntityElement."Table No.", 4, OutlookSynchFilter.Type::CONST, 0, 0, '1')
                ELSE
                    InsertOSynchConditionFilter(
                      OutlookSynchDependency."Record GUID", OutlookSynchEntityElement."Table No.", 4, OutlookSynchFilter.Type::CONST, 0, 0, '0');

            InsertOSynchTableRelationFilter(
              OutlookSynchDependency."Record GUID", OutlookSynchEntity1."Table No.", 1, OutlookSynchFilter.Type::FIELD,
              OutlookSynchEntityElement."Table No.", 5, '');

            IF DependEntityElemCode <> Text131 THEN
                OutlookSynchDependency.Condition := OutlookSynchSetupMgt.ComposeFilterExpression(OutlookSynchDependency."Record GUID", 0);
            OutlookSynchDependency."Table Relation" :=
              OutlookSynchSetupMgt.ComposeFilterExpression(OutlookSynchDependency."Record GUID", 1);
            OutlookSynchDependency.MODIFY;
        END
    END;

    LOCAL PROCEDURE UpdateOutlookSynchField(EntityCode: Code[10]; ElementNo: Integer; OutlookSynchEntityElement: Record 51281; Value: Text[250]);
    BEGIN
        WITH OutlookSynchField DO BEGIN
            RESET;
            SETRANGE("Synch. Entity Code", EntityCode);
            SETRANGE("Element No.", ElementNo);
            IF FINDLAST THEN BEGIN
                OutlookSynchEntityElement.CALCFIELDS("Master Table No.");
                InsertOSynchTableRelationFilter("Record GUID", "Table No.", 1, OutlookSynchFilter.Type::FIELD, "Master Table No.", 5, '');
                InsertOSynchConditionFilter("Record GUID", OutlookSynchEntityElement."Table No.", 4, OutlookSynchFilter.Type::CONST, 0, 0, Value);
                "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 1);
                Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 0);
                MODIFY;
            END;
        END;
    END;

    LOCAL PROCEDURE InsertFieldTableRelationFilter(OutlookSynchEntityCode: Code[10]; FieldId: Integer; MasterFieldId: Integer);
    VAR
        OutlookSynchField: Record 51284;
        OutlookSynchFilter: Record 51283;
    BEGIN
        WITH OutlookSynchField DO BEGIN
            RESET;
            SETRANGE("Synch. Entity Code", OutlookSynchEntityCode);
            SETRANGE("Element No.", 0);
            IF FINDLAST THEN BEGIN
                InsertOSynchTableRelationFilter(
                  "Record GUID", "Table No.", FieldId, OutlookSynchFilter.Type::FIELD, "Master Table No.", MasterFieldId, '');
                "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 1);
                MODIFY;
            END;
        END;
    END;

    LOCAL PROCEDURE InsertConstConditionFilter(OutlookSynchEntityCode: Code[10]; FilterValue: Text[250]);
    BEGIN
        WITH OutlookSynchEntity DO BEGIN
            GET(OutlookSynchEntityCode);
            InsertOSynchConditionFilter("Record GUID", "Table No.", 5050, OutlookSynchFilter.Type::CONST, 0, 0, FilterValue);
            Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 0);
            MODIFY;
        END;
    END;

    LOCAL PROCEDURE InsertGroupTableRelationFilter(OutlookSynchEntityCode: Code[10]; FieldId: Integer; FilterType: Option; FilterValue: Text[250]);
    VAR
        OutlookSynchEntityElement: Record 51281;
        OutlookSynchFilter: Record 51283;
    BEGIN
        WITH OutlookSynchEntityElement DO BEGIN
            RESET;
            SETRANGE("Synch. Entity Code", OutlookSynchEntityCode);
            IF FINDLAST THEN BEGIN
                CALCFIELDS("Master Table No.");
                InsertOSynchTableRelationFilter(
                  "Record GUID", "Table No.", 1, OutlookSynchFilter.Type::FIELD, "Master Table No.", 1, '');
                InsertOSynchTableRelationFilter(
                  "Record GUID", "Table No.", FieldId, FilterType, "Master Table No.", 0, FilterValue);
                "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID", 1);
                MODIFY;
            END;
        END;
    END;

    /* /*BEGIN
END.*/
}







