Codeunit 7206906 "Job Attribute Management"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        DeleteAttributesInheritedFromOldCategoryQst: TextConst ENU = 'Do you want to delete the attributes that are inherited from Job category ''%1''?', ESP = '¨Desea eliminar los atributos que se heredan de la categor¡a de proyecto/estudio ''%1''?';
        DeleteJobInheritedParentCategoryAttributesQst: TextConst ENU = 'One or more Jobs belong to Job category ''''%1'''', which is a child of Job category ''''%2''''.\\Do you want to delete the inherited Job attributes for the Jobs in question?', ESP = 'Uno o varios proyecto/estudios pertenecen a la categor¡a de proyecto/estudio ''''%1'''', que es un elemento secundario de la categor¡a de proyecto/estudio ''''%2''''.\\¨Desea eliminar los atributos de proyecto/estudio heredados para los proyecto/estudios en cuesti¢n?';

    PROCEDURE FindJobsByAttribute(VAR FilterJobAttributesBuffer: Record 7206911) JobFilter: Text;
    VAR
        JobAttributeValueMapping: Record 7206910;
        JobAttribute: Record 7206905;
        AttributeValueIDFilter: Text;
        CurrentJobFilter: Text;
    BEGIN
        IF NOT FilterJobAttributesBuffer.FINDSET THEN
            EXIT;

        JobFilter := '<>*';

        JobAttributeValueMapping.SETRANGE("Table ID", DATABASE::Job);
        CurrentJobFilter := '*';

        REPEAT
            JobAttribute.SETRANGE(Name, FilterJobAttributesBuffer.Attribute);
            IF JobAttribute.FINDFIRST THEN BEGIN
                JobAttributeValueMapping.SETRANGE("Job Attribute ID", JobAttribute.ID);
                AttributeValueIDFilter := GetJobAttributeValueFilter(FilterJobAttributesBuffer, JobAttribute);
                IF AttributeValueIDFilter = '' THEN
                    EXIT;

                CurrentJobFilter := GetJobNoFilter(JobAttributeValueMapping, CurrentJobFilter, AttributeValueIDFilter);
                IF CurrentJobFilter = '' THEN
                    EXIT;
            END;
        UNTIL FilterJobAttributesBuffer.NEXT = 0;

        JobFilter := CurrentJobFilter;
    END;

    //[External]
    PROCEDURE FindJobsByAttributes(VAR FilterJobAttributesBuffer: Record 7206911; VAR TempFilteredJob: Record 167 TEMPORARY);
    VAR
        JobAttributeValueMapping: Record 7206910;
        JobAttribute: Record 7206905;
        AttributeValueIDFilter: Text;
    BEGIN
        IF NOT FilterJobAttributesBuffer.FINDSET THEN
            EXIT;

        JobAttributeValueMapping.SETRANGE("Table ID", DATABASE::Job);

        REPEAT
            JobAttribute.SETRANGE(Name, FilterJobAttributesBuffer.Attribute);
            IF JobAttribute.FINDFIRST THEN BEGIN
                JobAttributeValueMapping.SETRANGE("Job Attribute ID", JobAttribute.ID);
                AttributeValueIDFilter := GetJobAttributeValueFilter(FilterJobAttributesBuffer, JobAttribute);
                IF AttributeValueIDFilter = '' THEN BEGIN
                    TempFilteredJob.DELETEALL;
                    EXIT;
                END;

                GetFilteredJobs(JobAttributeValueMapping, TempFilteredJob, AttributeValueIDFilter);
                IF TempFilteredJob.ISEMPTY THEN
                    EXIT;
            END;
        UNTIL FilterJobAttributesBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE GetJobAttributeValueFilter(VAR FilterJobAttributesBuffer: Record 7206911; VAR JobAttribute: Record 7206905) AttributeFilter: Text;
    VAR
        JobAttributeValue: Record 7206906;
    BEGIN
        JobAttributeValue.SETRANGE("Attribute ID", JobAttribute.ID);
        JobAttributeValue.SetValueFilter(JobAttribute, FilterJobAttributesBuffer.Value);

        IF NOT JobAttributeValue.FINDSET THEN
            EXIT;

        REPEAT
            AttributeFilter += STRSUBSTNO('%1|', JobAttributeValue.ID);
        UNTIL JobAttributeValue.NEXT = 0;

        EXIT(COPYSTR(AttributeFilter, 1, STRLEN(AttributeFilter) - 1));
    END;

    LOCAL PROCEDURE GetJobNoFilter(VAR JobAttributeValueMapping: Record 7206910; PreviousJobNoFilter: Text; AttributeValueIDFilter: Text) JobNoFilter: Text;
    BEGIN
        JobAttributeValueMapping.SETFILTER("No.", PreviousJobNoFilter);
        JobAttributeValueMapping.SETFILTER("Job Attribute Value ID", AttributeValueIDFilter);

        IF NOT JobAttributeValueMapping.FINDSET THEN
            EXIT;

        REPEAT
            JobNoFilter += STRSUBSTNO('%1|', JobAttributeValueMapping."No.");
        UNTIL JobAttributeValueMapping.NEXT = 0;

        EXIT(COPYSTR(JobNoFilter, 1, STRLEN(JobNoFilter) - 1));
    END;

    LOCAL PROCEDURE GetFilteredJobs(VAR JobAttributeValueMapping: Record 7206910; VAR TempFilteredJob: Record 167 TEMPORARY; AttributeValueIDFilter: Text);
    VAR
        Job: Record 167;
    BEGIN
        JobAttributeValueMapping.SETFILTER("Job Attribute Value ID", AttributeValueIDFilter);

        IF JobAttributeValueMapping.ISEMPTY THEN BEGIN
            TempFilteredJob.RESET;
            TempFilteredJob.DELETEALL;
            EXIT;
        END;

        IF NOT TempFilteredJob.FINDSET THEN BEGIN
            IF JobAttributeValueMapping.FINDSET THEN
                REPEAT
                    Job.GET(JobAttributeValueMapping."No.");
                    TempFilteredJob.TRANSFERFIELDS(Job);
                    TempFilteredJob.INSERT;
                UNTIL JobAttributeValueMapping.NEXT = 0;
            EXIT;
        END;

        REPEAT
            JobAttributeValueMapping.SETRANGE("No.", TempFilteredJob."No.");
            IF JobAttributeValueMapping.ISEMPTY THEN
                TempFilteredJob.DELETE;
        UNTIL TempFilteredJob.NEXT = 0;
        JobAttributeValueMapping.SETRANGE("No.");
    END;

    //[External]
    PROCEDURE GetJobNoFilterText(VAR TempFilteredJob: Record 167 TEMPORARY; VAR ParameterCount: Integer) FilterText: Text;
    VAR
        NextJob: Record 167;
        PreviousNo: Code[20];
        FilterRangeStarted: Boolean;
    BEGIN
        IF NOT TempFilteredJob.FINDSET THEN BEGIN
            FilterText := '<>*';
            EXIT;
        END;

        REPEAT
            IF FilterText = '' THEN BEGIN
                FilterText := TempFilteredJob."No.";
                NextJob."No." := TempFilteredJob."No.";
                ParameterCount += 1;
            END ELSE BEGIN
                IF NextJob.NEXT = 0 THEN
                    NextJob."No." := '';
                IF TempFilteredJob."No." = NextJob."No." THEN BEGIN
                    IF NOT FilterRangeStarted THEN
                        FilterText += '..';
                    FilterRangeStarted := TRUE;
                END ELSE BEGIN
                    IF NOT FilterRangeStarted THEN BEGIN
                        FilterText += STRSUBSTNO('|%1', TempFilteredJob."No.");
                        ParameterCount += 1;
                    END ELSE BEGIN
                        FilterText += STRSUBSTNO('%1|%2', PreviousNo, TempFilteredJob."No.");
                        FilterRangeStarted := FALSE;
                        ParameterCount += 2;
                    END;
                    NextJob := TempFilteredJob;
                END;
            END;
            PreviousNo := TempFilteredJob."No.";
        UNTIL TempFilteredJob.NEXT = 0;

        // close range if needed
        IF FilterRangeStarted THEN BEGIN
            FilterText += STRSUBSTNO('%1', PreviousNo);
            ParameterCount += 1;
        END;
    END;

    //[External]
    PROCEDURE InheritAttributesFromJobCategory(Job: Record 167; NewJobCategoryCode: Code[20]; OldJobCategoryCode: Code[20]);
    VAR
        TempJobAttributeValueToInsert: Record 7206906 TEMPORARY;
        TempJobAttributeValueToDelete: Record 7206906 TEMPORARY;
    BEGIN
        GenerateAttributesToInsertAndToDelete(
          TempJobAttributeValueToInsert, TempJobAttributeValueToDelete, NewJobCategoryCode, OldJobCategoryCode);

        IF NOT TempJobAttributeValueToDelete.ISEMPTY THEN
            IF NOT GUIALLOWED THEN
                DeleteJobAttributeValueMapping(Job, TempJobAttributeValueToDelete)
            ELSE
                IF CONFIRM(STRSUBSTNO(DeleteAttributesInheritedFromOldCategoryQst, OldJobCategoryCode)) THEN
                    DeleteJobAttributeValueMapping(Job, TempJobAttributeValueToDelete);

        IF NOT TempJobAttributeValueToInsert.ISEMPTY THEN
            InsertJobAttributeValueMapping(Job, TempJobAttributeValueToInsert);
    END;

    //[External]
    PROCEDURE UpdateCategoryAttributesAfterChangingParentCategory(JobCategoryCode: Code[20]; NewParentJobCategory: Code[20]; OldParentJobCategory: Code[20]);
    VAR
        TempNewParentJobAttributeValue: Record 7206906 TEMPORARY;
        TempOldParentJobAttributeValue: Record 7206906 TEMPORARY;
    BEGIN
        TempNewParentJobAttributeValue.LoadCategoryAttributesFactBoxData(NewParentJobCategory);
        TempOldParentJobAttributeValue.LoadCategoryAttributesFactBoxData(OldParentJobCategory);
        UpdateCategoryJobsAttributeValueMapping(
          TempNewParentJobAttributeValue, TempOldParentJobAttributeValue, JobCategoryCode, OldParentJobCategory);
    END;

    LOCAL PROCEDURE GenerateAttributesToInsertAndToDelete(VAR TempJobAttributeValueToInsert: Record 7206906 TEMPORARY; VAR TempJobAttributeValueToDelete: Record 7206906 TEMPORARY; NewJobCategoryCode: Code[20]; OldJobCategoryCode: Code[20]);
    VAR
        TempNewCategJobAttributeValue: Record 7206906 TEMPORARY;
        TempOldCategJobAttributeValue: Record 7206906 TEMPORARY;
    BEGIN
        TempNewCategJobAttributeValue.LoadCategoryAttributesFactBoxData(NewJobCategoryCode);
        TempOldCategJobAttributeValue.LoadCategoryAttributesFactBoxData(OldJobCategoryCode);
        GenerateAttributeDifference(TempNewCategJobAttributeValue, TempOldCategJobAttributeValue, TempJobAttributeValueToInsert);
        GenerateAttributeDifference(TempOldCategJobAttributeValue, TempNewCategJobAttributeValue, TempJobAttributeValueToDelete);
    END;

    LOCAL PROCEDURE GenerateAttributeDifference(VAR TempFirstJobAttributeValue: Record 7206906 TEMPORARY; VAR TempSecondJobAttributeValue: Record 7206906 TEMPORARY; VAR TempResultingJobAttributeValue: Record 7206906 TEMPORARY);
    BEGIN
        IF TempFirstJobAttributeValue.FINDFIRST THEN
            REPEAT
                TempSecondJobAttributeValue.SETRANGE("Attribute ID", TempFirstJobAttributeValue."Attribute ID");
                IF TempSecondJobAttributeValue.ISEMPTY THEN BEGIN
                    TempResultingJobAttributeValue.TRANSFERFIELDS(TempFirstJobAttributeValue);
                    TempResultingJobAttributeValue.INSERT;
                END;
                TempSecondJobAttributeValue.RESET;
            UNTIL TempFirstJobAttributeValue.NEXT = 0;
    END;

    //[External]
    PROCEDURE DeleteJobAttributeValueMapping(Job: Record 167; VAR TempJobAttributeValueToRemove: Record 7206906 TEMPORARY);
    BEGIN
        DeleteJobAttributeValueMappingWithTriggerOption(Job, TempJobAttributeValueToRemove, TRUE);
    END;

    LOCAL PROCEDURE DeleteJobAttributeValueMappingWithTriggerOption(Job: Record 167; VAR TempJobAttributeValueToRemove: Record 7206906 TEMPORARY; RunTrigger: Boolean);
    VAR
        JobAttributeValueMapping: Record 7206910;
        JobAttributeValuesToRemoveTxt: Text;
    BEGIN
        JobAttributeValueMapping.SETRANGE("Table ID", DATABASE::Job);
        JobAttributeValueMapping.SETRANGE("No.", Job."No.");
        IF TempJobAttributeValueToRemove.FINDFIRST THEN BEGIN
            REPEAT
                IF JobAttributeValuesToRemoveTxt <> '' THEN
                    JobAttributeValuesToRemoveTxt += STRSUBSTNO('|%1', TempJobAttributeValueToRemove."Attribute ID")
                ELSE
                    JobAttributeValuesToRemoveTxt := FORMAT(TempJobAttributeValueToRemove."Attribute ID");
            UNTIL TempJobAttributeValueToRemove.NEXT = 0;
            JobAttributeValueMapping.SETFILTER("Job Attribute ID", JobAttributeValuesToRemoveTxt);
            JobAttributeValueMapping.DELETEALL(RunTrigger);
        END;
    END;

    LOCAL PROCEDURE InsertJobAttributeValueMapping(Job: Record 167; VAR TempJobAttributeValueToInsert: Record 7206906 TEMPORARY);
    VAR
        JobAttributeValueMapping: Record 7206910;
    BEGIN
        IF TempJobAttributeValueToInsert.FINDFIRST THEN
            REPEAT
                JobAttributeValueMapping."Table ID" := DATABASE::Job;
                JobAttributeValueMapping."No." := Job."No.";
                JobAttributeValueMapping."Job Attribute ID" := TempJobAttributeValueToInsert."Attribute ID";
                JobAttributeValueMapping."Job Attribute Value ID" := TempJobAttributeValueToInsert.ID;
                IF JobAttributeValueMapping.INSERT(TRUE) THEN;
            UNTIL TempJobAttributeValueToInsert.NEXT = 0;
    END;

    //[External]
    PROCEDURE UpdateCategoryJobsAttributeValueMapping(VAR TempNewJobAttributeValue: Record 7206906 TEMPORARY; VAR TempOldJobAttributeValue: Record 7206906 TEMPORARY; JobCategoryCode: Code[20]; OldJobCategoryCode: Code[20]);
    VAR
        TempJobAttributeValueToInsert: Record 7206906 TEMPORARY;
        TempJobAttributeValueToDelete: Record 7206906 TEMPORARY;
    BEGIN
        GenerateAttributeDifference(TempNewJobAttributeValue, TempOldJobAttributeValue, TempJobAttributeValueToInsert);
        GenerateAttributeDifference(TempOldJobAttributeValue, TempNewJobAttributeValue, TempJobAttributeValueToDelete);

        IF NOT TempJobAttributeValueToDelete.ISEMPTY THEN
            IF NOT GUIALLOWED THEN
                DeleteCategoryJobsAttributeValueMapping(TempJobAttributeValueToDelete, JobCategoryCode)
            ELSE
                IF CONFIRM(STRSUBSTNO(DeleteJobInheritedParentCategoryAttributesQst, JobCategoryCode, OldJobCategoryCode)) THEN
                    DeleteCategoryJobsAttributeValueMapping(TempJobAttributeValueToDelete, JobCategoryCode);

        IF NOT TempJobAttributeValueToInsert.ISEMPTY THEN
            InsertCategoryJobsAttributeValueMapping(TempJobAttributeValueToInsert, JobCategoryCode);
    END;

    //[External]
    PROCEDURE DeleteCategoryJobsAttributeValueMapping(VAR TempJobAttributeValueToRemove: Record 7206906 TEMPORARY; CategoryCode: Code[20]);
    VAR
        Job: Record 167;
        JobCategory: Record 5722;
        JobAttributeValueMapping: Record 7206910;
        JobAttributeValue: Record 7206906;
    BEGIN
        //++Job.SETRANGE("Job Category Code",CategoryCode);
        IF Job.FINDSET THEN
            REPEAT
                DeleteJobAttributeValueMappingWithTriggerOption(Job, TempJobAttributeValueToRemove, FALSE);
            UNTIL Job.NEXT = 0;

        JobCategory.SETRANGE("Parent Category", CategoryCode);
        IF JobCategory.FINDSET THEN
            REPEAT
                DeleteCategoryJobsAttributeValueMapping(TempJobAttributeValueToRemove, JobCategory.Code);
            UNTIL JobCategory.NEXT = 0;

        IF TempJobAttributeValueToRemove.FINDSET THEN
            REPEAT
                JobAttributeValueMapping.SETRANGE("Job Attribute ID", TempJobAttributeValueToRemove."Attribute ID");
                JobAttributeValueMapping.SETRANGE("Job Attribute Value ID", TempJobAttributeValueToRemove.ID);
                IF JobAttributeValueMapping.ISEMPTY THEN
                    IF JobAttributeValue.GET(TempJobAttributeValueToRemove."Attribute ID", TempJobAttributeValueToRemove.ID) THEN
                        JobAttributeValue.DELETE;
            UNTIL TempJobAttributeValueToRemove.NEXT = 0;
    END;

    //[External]
    PROCEDURE InsertCategoryJobsAttributeValueMapping(VAR TempJobAttributeValueToInsert: Record 7206906 TEMPORARY; CategoryCode: Code[20]);
    VAR
        Job: Record 167;
        JobCategory: Record 5722;
    BEGIN
        //++Job.SETRANGE("Job Category Code",CategoryCode);
        IF Job.FINDSET THEN
            REPEAT
                InsertJobAttributeValueMapping(Job, TempJobAttributeValueToInsert);
            UNTIL Job.NEXT = 0;

        JobCategory.SETRANGE("Parent Category", CategoryCode);
        IF JobCategory.FINDSET THEN
            REPEAT
                InsertCategoryJobsAttributeValueMapping(TempJobAttributeValueToInsert, JobCategory.Code);
            UNTIL JobCategory.NEXT = 0;
    END;

    //[External]
    PROCEDURE InsertCategoryJobsBufferedAttributeValueMapping(VAR TempJobAttributeValueToInsert: Record 7206906 TEMPORARY; VAR TempInsertedJobAttributeValueMapping: Record 7206906 TEMPORARY; CategoryCode: Code[20]);
    VAR
        Job: Record 167;
        JobCategory: Record 5722;
    BEGIN
        //++Job.SETRANGE("Job Category Code",CategoryCode);
        IF Job.FINDSET THEN
            REPEAT
                InsertBufferedJobAttributeValueMapping(Job, TempJobAttributeValueToInsert, TempInsertedJobAttributeValueMapping);
            UNTIL Job.NEXT = 0;

        JobCategory.SETRANGE("Parent Category", CategoryCode);
        IF JobCategory.FINDSET THEN
            REPEAT
                InsertCategoryJobsBufferedAttributeValueMapping(
                  TempJobAttributeValueToInsert, TempInsertedJobAttributeValueMapping, JobCategory.Code);
            UNTIL JobCategory.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertBufferedJobAttributeValueMapping(Job: Record 167; VAR TempJobAttributeValueToInsert: Record 7206906 TEMPORARY; VAR TempInsertedJobAttributeValueMapping: Record 7206906 TEMPORARY);
    VAR
        JobAttributeValueMapping: Record 7206910;
    BEGIN
        IF TempJobAttributeValueToInsert.FINDFIRST THEN
            REPEAT
                JobAttributeValueMapping."Table ID" := DATABASE::Job;
                JobAttributeValueMapping."No." := Job."No.";
                JobAttributeValueMapping."Job Attribute ID" := TempJobAttributeValueToInsert."Attribute ID";
                JobAttributeValueMapping."Job Attribute Value ID" := TempJobAttributeValueToInsert.ID;
                IF JobAttributeValueMapping.INSERT(TRUE) THEN BEGIN
                    TempInsertedJobAttributeValueMapping.TRANSFERFIELDS(JobAttributeValueMapping);
                    TempInsertedJobAttributeValueMapping.INSERT;
                END;
            UNTIL TempJobAttributeValueToInsert.NEXT = 0;
    END;

    //[External]
    PROCEDURE SearchCategoryJobsForAttribute(CategoryCode: Code[20]; AttributeID: Integer): Boolean;
    VAR
        Job: Record 167;
        JobCategory: Record 5722;
        JobAttributeValueMapping: Record 7206910;
    BEGIN
        //++Job.SETRANGE("Job Category Code",CategoryCode);
        IF Job.FINDSET THEN
            REPEAT
                JobAttributeValueMapping.SETRANGE("Table ID", DATABASE::Job);
                JobAttributeValueMapping.SETRANGE("No.", Job."No.");
                JobAttributeValueMapping.SETRANGE("Job Attribute ID", AttributeID);
                IF JobAttributeValueMapping.FINDFIRST THEN
                    EXIT(TRUE);
            UNTIL Job.NEXT = 0;

        JobCategory.SETRANGE("Parent Category", CategoryCode);
        IF JobCategory.FINDSET THEN
            REPEAT
                IF SearchCategoryJobsForAttribute(JobCategory.Code, AttributeID) THEN
                    EXIT(TRUE);
            UNTIL JobCategory.NEXT = 0;
    END;

    //[External]
    PROCEDURE DoesValueExistInJobAttributeValues(Text: Text[250]; VAR JobAttributeValue: Record 7206906): Boolean;
    BEGIN
        JobAttributeValue.RESET;
        JobAttributeValue.SETFILTER(Value, '@' + Text);
        EXIT(JobAttributeValue.FINDSET);
    END;


    /*BEGIN
    /*{
          JAV 13/02/20: - Gesti¢n de atributos para proyectos
        }
    END.*/
}









