Codeunit 7207350 "QB - Report - Publisher"
{


    trigger OnRun()
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE TestJobFieldsRepGeneralJournal(VAR GenJournalLine: Record 81);
    BEGIN
    END;

    LOCAL PROCEDURE "//CPA 13/01/22: - Q18722.Begin"();
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE OnAfterProcessPurchJournalLineEvent(ComparativeQuoteHeader: Record 7207412; ComparativeQuoteLines: Record 7207413);
    BEGIN
    END;

    LOCAL PROCEDURE "//CPA 13/01/22: - Q18722.End"();
    BEGIN
    END;

    /*BEGIN
/*{
      PEL 21/05/18: - QVE_1853 A�adidas parametros a funci�n OnAfterGetRecordFixedAssetRepCalculateDepreciation
      JAV 16/10/20: - Se eliminan los eventos de activos, en su lugar se llama directamente a la funci�n que es mas r�pido
                         - OnAfterGetRecordFixedAssetRepCalculateDepreciation
                         - OnPostDataItemFixedAsset1RepCalculateDepreciation
                         - OnPostDataItemFixedAsset2RepCalculateDepreciation
      JAV 15/11/21: - QB 1.09.27 Se eliminan los eventos que no se utilizan: OnAfterGetRecordPrintCheckRepCheck, SetInitRepChangeGlobalDimensions, SetDefaultDimRepChangeGlobalDimensions
      JAV 05/07/22: - QB 1.10.59 Se eliminan las funciones SetGLBudgetNameRepImportBudToExcel que realmente no funciona ni es necesaria
                                                           OnInitReportRepPostInventoryCosttoGL que realmente no funciona ni es necesaria

      CPA 13/01/22: - Q18722 Creado un Event Publisher: OnAfterProcessPurchJournalLineEvent
    }
END.*/
}







