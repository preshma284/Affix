Codeunit 7207346 "QB - Table - Publisher"
{


    trigger OnRun()
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE ValidateShortCutDimCodeResource(VAR ShortcutDimCode: Code[20]; VAR recResource: Record 156);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE AssignJobDesviationTDefaultDimension(VAR recResource: Record 156; recDefaultDimension: Record 352);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnLookupDepartamentCode(VAR Location: Record 14);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnLookupJVDimensionCode(VAR Vendor: Record 23);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnValidateAccountNo1TGenJournalLine(GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE GetCustomerAccountTGenJournalLine(GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE GetVendorAccountTGenJournalLine(GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE GetBankAccountTGenJournalLine(GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnLookupJVDimensionCodeTCustomer(Customer: Record 18);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE GetCustomerBalAccountTGenJournalLine(GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE GetVendorBalAccountTGenJournalLine(GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE GetBankBalAccountTGenJournalLine(GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnValidateJobNo2TGenJournalLine(GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE UpdateCountryCodeAndVATRegNoTGenJournalLine(GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE "OnValidateUnitCost(LCY)TJobJournalLine"(JobJournalLine: Record 210);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnValidateNo1TJobPlanningLine(JobPlanningLine: Record 1003);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnValidateNo2TJobPlanningLine(JobPlanningLine: Record 1003);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnValidateNo3TJobPlanningLine(JobPlanningLine: Record 1003);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnDeleteTContact(Contact: Record 5050);
    BEGIN
    END;

    /*BEGIN
/*{
      RSH 02/05/19: - QX7105 A�adir evento ChangeBillToTJob para usar en el page action "Cambiar N� Cliente" de la pagina Quotes Card.
      JAV 03/09/19: - Se a�ade el evento GetWithholdingsSalesHeader que faltaba
      JAV 23/10/19: - Se eliminan los eventos de retenciones que ya no se utilizan
                        ValidateWithholdingPercentagesPurchaseLines
                        GetPercentageInAmountOnValidatePurchaseLines
                        CalculateWithholdingAmountsAfterReleaseDocumentPurchaseLines
                        modifyWithholdingsAmountToZero
                        UpdateVATOnLinesTSalesLine
                        UpdateVATOnLines2TSalesLine
                        InsertInvLineFromRcptLineTPurchRcptLine
      JAV 24/10/19: - Se traspasan los eventos de retenciones a su CU
                        GetWithholdingsSalesHeader
                        GetWithholdingsPurchaseHeader
      JAV 10/03/20: - Se elimina el evento que no se utiliza:
      JAV 19/03/20: - Se eliminan eventos que no se utilizan:
                        * OnCreateStartingBudget
                        * CopyFromGenJnlLineTVendorLedgerEntry
                        * OnLookupAnalyticConceptTInventoryPostingSetup
                        * OnLookupAppAccountAnalyticConceptTInventoryPostingSetup

      JAV 29/10/20: - QB 1.07.02 Se eliminan los eventos que no se usan: OnLookupNo, OnValidateNoPurchaseLine, GetPercentageFromHeaderPurchaseLines, OnDeleteTVendor, CheckGLAccTGenJournalLine,
                                                                         UpdateGlobalDimCodeTDefaultDimension, OnValidateNoTRequisitionLine, InsertInvLineFromRetShptLineTReturnShipmentLine
      JAV 29/10/21: - QB 1.09.26 Se eliminan los eventos que no se usan:   CalAmountPendingPurchaseInterimTPurRcLine, CalcAmountPendingPurchaseTPurRcLine y CalculateAmountPourchaseTPurchRcptLine
                                 Estas no son evento y se pasan a funci�n: OnValidateCompleteJob, ReturnMarginDirectTJob, ReturnCostIndirectTJob, OnLookupReestimationFilterTJob,
                                                                           OnLookupLastestReestimationCodeTJob, OnLookupInitialReestimationCodeTJob, OnLookupDimensionsJVCodeTJob,
                                                                           OnLookupAcceptedVersionNoTJob, ControlJobTJob, CalMarginRealizedTJob, CalMarginRealizedPercentageTJob,
                                                                           AmountGeneralExpensesTJob, AmountIndustrialBenefitTJob, AmountLowTJob, AmountQualityDeductionTJob,
                                                                           RefillContractTJob, ControlMilestoneTJob, AcceptTJob, RejectTJob, ReopenTJob, CreateJobTJob,
                                                                           ProductionTheoricalProcessTJob, ProductionBudgetWithoutProcessTJob
      JAV 06/07/22: - QB 1.10.59 Se eliminan los eventos CreateAccountWorkTJob y CreateAccountVersionsTJob que no tienen sentido que lo sean, son funciones locales a la CU 7207347
                                 Se elimina el evento GetCurrency que no se emplea en ningun lugar
    }
END.*/
}







