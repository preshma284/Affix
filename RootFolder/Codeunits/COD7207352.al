Codeunit 7207352 "QB - Codeunit - Publisher"
{


    trigger OnRun()
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE ItemOutputCheckLine(VAR OutboundWarehouseLines: Record 7207309; ItemCheckAvail: Codeunit 311);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnTestPurchLinePurchPost(PurchaseLine: Record 39);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnPostItemTrackingPurchPost(VAR PurchRcptLine: Record 121; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; VAR TempPurchRcptLine: Record 121 TEMPORARY);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnPostItemTrackingPurchShipment(VAR ReturnShptLine: Record 6651; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; VAR TempReturnShptLine: Record 6651 TEMPORARY);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnPostItemResourceLine(VAR PurchHeader: Record 38; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHeader: Record 124; PurchLine: Record 39; Sourcecode: Code[10]);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnRunPurchPostPurchaseRcpt(VAR PurchaseHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR TempPurchRcptLine: Record 121 TEMPORARY);
    BEGIN
        //Q15921
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnRunPurchPostReturnShipment(VAR PurchaseHeader: Record 38; VAR ReturnShipmentHeader: Record 6650; VAR TempReturnShipmentLine: Record 6651 TEMPORARY; VAR PurchCrMemoHeader: Record 124);
    BEGIN
        //Q15921
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnRunWithCheckJobJnlPostLine(JobJournalLine: Record 210; VAR ExitBool: Boolean);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnGetJobConsumptionValueEntryJobJnlPostLine(VAR ValueEntry: Record 5802);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnInitCreateJobLedgEntryJobJnlPostLine(VAR JobLedgEntry: Record 169; JobJnlLine2: Record 210);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnTypeSaleCreateJobLedgEntryJobJnlPostLine(VAR JobLedgEntry: Record 169);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnJobEntryCreateJobLedgEntryJobJnlPostLine(JobJnlLine2: Record 210; VAR JobLedgEntry: Record 169);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnGetFieldsTempInvoicePostBuffer(VAR GenJnlLine: Record 81; TempInvoicePostBuffer: Record 55 TEMPORARY);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnPostItemJnlLinePurchPost(PurchaseLine: Record 39; VAR ItemJournalLine: Record 83; QtyToBeReceivedBase: Decimal);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE AdditionalControlGenJnlCheckLine(recLinJnlGen: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE CreateActiveDimGenJnlPostLine(VAR GenJnlLine: Record 81; TempFAGLPostBuff: Record 5637);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE ReturnDimensionesFinishPostingGenJnlPostLine(VAR GenJnlLineQB: Record 81; VAR boolReturnDim: Boolean; GlobalGLEntry: Record 17; DimensionSetID: Integer);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE InheritFieldsGLEntryGenJnlPostLine(VAR GLEntry: Record 17; VAR GenJnlLine: Record 81; GLAccNo: Code[20]);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE CheckRemainingUnrealizedVATGenJnlPostLine(VATPostingSetup: Record 325; VATEntry2: Record 254; VAR VATPart: Decimal; CustLedgerEntryDocNo: Code[20]);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE CheckRemainingUnrealizedVATVendorLedgerGenJnlPostLine(VATPostingSetup: Record 325; VATEntry2: Record 254; VAR VATPart: Decimal; VendLedgerEntryDocNo: Code[20]);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE ResetLedgerEntryGenJnlPostLine(VAR NextEntryNo: Integer);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnSaveStatusBlanketPurchOrdertoOrder(VAR PurchaseHeader: Record 38; VAR PurchHeader_Status: Record 38);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnFindResPriceNewResourceFindPrice(ResPrice: Record 201; VAR ResPrice2: Record 201; VAR AnswerPar: Boolean);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE TestLinDiaproyCJobJnlCheckLine(VAR JobJnlLine: Record 210);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE ExistsPurchaseJournalLineCUCalcItemPlanWksh(Item: Record 27; VAR ExistsPurchJnLine: Boolean);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE GetSourceReferencesCUCalcItemAvailabiity(VAR SourceType: Integer; VAR SourceID: Code[20]; VAR SourceBatchName: Code[10]; VAR SourceRefNo: Integer);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE ShowDocumentCUCacItemAvailability(CalcItemAvailability: Codeunit 5530);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnRunCUFAInsertGLAccount(VAR FALedgerEntry: Record 5601);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE InsertMaintenanceAccNoCUFAInsertGLAccount(VAR MaintenanceLedgerEntry: Record 5625);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE InsertBufferBalAccCUFAInsertGLAccount(FAPostingType: Option "Acquisition","Depr","WriteDown","Appr","Custom1","Custom2","Disposal","Maintenance","Gain","Loss","Book Value Gain","Book Value Loss"; AllocAmount: Decimal; DeprBookCode: Code[20]; PostingGrCode: Code[20]; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; DimSetID: Integer; AutomaticEntry: Boolean; Correction: Boolean);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE InsertBufferBalAcc2CUFAInsertGLAccount(FAPostingType: Option "Acquisition","Depr","WriteDown","Appr","Custom1","Custom2","Disposal","Maintenance","Gain","Loss","Book Value Gain","Book Value Loss"; AllocAmount: Decimal; DeprBookCode: Code[20]; PostingGrCode: Code[20]; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; DimSetID: Integer; AutomaticEntry: Boolean; Correction: Boolean; GLAccNo: Code[20]);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE InsertBalAccCUFAInsertGLAccount(VAR FALedgerEntry: Record 5601);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE PostUpdateWhseDocumentsCUWhsePostReceipt(VAR WarehouseReceiptHeader: Record 7316);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE PostInvtPostBufCUInventoryPostingToGL(GenJournalLine: Record 81; InvtPostingBuffer: Record 48);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE FindSalesLinePriceCUSalesPriceCalcMgt(SalesHeader: Record 36; VAR SalesLine: Record 37);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE FindServLinePriceCUSalesPriceCalcMgt(ServiceHeader: Record 5900; VAR ServiceLine: Record 5902);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE FindJobPlanningLinePriceCUSalesPriceCalcMgt(VAR JobPlanningLine: Record 1003; CalledByFieldNo: Integer);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE FindJobJbLinePriceCUSalesPriceCalcMgt(VAR JobJnlLine: Record 210; CalledByFieldNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE OnBeforeMountTextForConfirmPost(PurchaseHeader: Record 38; VAR Text: Text; VAR Option: Integer);
    BEGIN
        //JAV 18/02/22: - QB 1.10.20 Evento tras montar la lista de opciones para confirmar el registro en compras
    END;

    /*BEGIN
/*{
      PEL 21/05/18: - QVE_1853 A�adido GLAccNo a InsertBufferBalAcc2CUFAInsertGLAccount
      PEL 13/06/18: - QB2395 RunGenJnlPostLine --> Se elimina con las nuevas aprobaciones
      PEL 03/09/18: - QB3257 Error SII. Filtrar los movs de retenciones.
      JAV 11/10/19: - Se elimina la funci�n "OpenClosePurchaseOrder" y sus llamadas pues no hace nada �til
      JAV 21/10/19: - Se trasladan las funciones relacionadas con las retenciones a la CU de retenciones
                                          GenerateCustomerWithholdingMovs
                                          GenerateVendorWithholdingMovs
                                          GenerateWithholdingMovsSalesPost
                                          AddTotalWithholdingLCYSalesPost
                                          GenerateWithholdingMovsPurchasePost
                                          AddOrSubtractTotalWithholdingPurchasePost
                                          AdjustWithholdingsSalesPost
                                          AdjustWithholdingsPurchasePost
                                          GetNotApplicableAmountApliccSalesPost
                                          AddOrSubtractTotalWithholdingSalesPost
                                          GetNotApplicableAmountApliccPurchasePost
                                          OnReopenATOsReleaseSalesDoc   ->  InitWithholdingFieldsOnReopenATOsReleaseSalesDoc
                                          UpdateSalesLineCUCopyDocumentMgt
                                          UpdatePurchLineCUCopyDocumentMgt
                                          OnAfterInitVendLedgEntry -> Cod12_OnAfterInitVendLedgEntry
                                          OnAfterInitCustLedgEntry -> Cod12_OnAfterInitCustLedgEntry
      JAV 16/03/20: - Se pasa el evento OnBeforeRunModalCUCarteraManagement a la CU de aprobaci�n de pagos
      JAV 09/10/20: - QB 1.06.20 Elimino el evento "InheritFieldsDetailedVendorGenJnlPostLine", en su lugar se usa el evento est�ndar de la CU 12
      JAV 17/10/20: - QB 1.06.21 Se elimina la funci�n "GetBalAccCUAFInsertGLAccount" que no hace nada
      JAV 20/11/20: - QB 1.07.06 Se elimina la funci�n "AddFromGenJnlLineToJnlLineCJobTransferLine" que se reemplaza por la est�ndar
      JAV 10/12/20: - QB 1.07.11 Se eliminan los eventos de la CU80, en su lugar se llama a las funciones directamente que es mas rapido
                                          EmptyJobEntryCUSalesPost
                                          ExitIfExistJobNoCUSalesPost
                                          UpdateInvoicedCertAndMilestoneCUSalesPost
                                          UpdateInvoicedCertCUSalesPost
                                          PostJobManualCUSalesPost
                                          GenerateConsumptionOfJobCUSalesPost
                                          ModifyGenJnlLineCUSalesPost
                                          ExitIfExistJobNoSalesHeaderCUSalesPost (Esta no se usa)
      JAV 07/01/21: - QB 1.07.19 Se elimina el evento "InheritFieldsVATGenJnlPostLine" que no se usa
      DGG 21/12/21:   QRE16040:En las funciones:InsertBufferBalAccCUFAInsertGLAccount, InsertBufferBalAcc2CUFAInsertGLAccount, se amplia el tama�o del parametro PostingGrCode de 10 a 20.
      CPA 22/12/21: - QRE16076 Nuevo evento publicador: OnPurchPostCUOnAfterCreateBills
      CPA 25/01/22: - QB 1.10.23 (Q15921) Errores detectados en almacenes de obras Nueva funci�n: OnRunPurchPostReturnShipment
      JAV 10/04/22: - QB 1.10.34 Se elimina la funci�n RunGenJnlPostLine que no se utiliza ya
      JAV 27/04/22: - QB 1.10.37 Se eliminan las funciones OnTestfieldLocationCodeReleasePurchDoc y OnRestrictionsReleasePurchDoc que no tienen mucho sentido
      JAV 25/05/22: - QB 1.10.44 Se elimina la funci�n InheritFieldVendor, en su lugar se captura el evento OnAfterInitVendLedgEntry de la CU 12
      JAV 04/07/22: - QB 1.10.58 Se elimina el evento AddFromPurchaseLineToJnlLineCJobTransferLine, su c�digo pasa a la CU 1004 evento OnAfterFromPurchaseLineToJnlLine
                                 Se elimina el evento ConvertPriceToVATCUPurchPriceCalcMgt , no tiene sentido lo que hac�a por lo que se retorna la CU 7010 a la est�ndar
                                 Se eliminan los eventos ConvertPriceToVAT1CUSalesPriceCalcMgt, ConvertPriceToVAT2CUSalesPriceCalcMgt, ConvertPriceToVAT3CUSalesPriceCalcMgt que no tienen sentido
                                 Se elimina el evento CopyPurchLineCUCopyDocumentMgt que est� mal y no hace nada necesario
                                 Se elimina el evento OnCalcNewFieldsItemAvailabilityFormsMgt, en su lugar se usa el evento OnAfterCalcItemPlanningFields de la CU 353
                                 Se elimina el evento OnCalcNeedFieldsItemAvailabilityFormsMgt, en su lugar se usa el evento OnAfterCalculateNeed de la CU 353
                                 Se elimina el evento OnUpdateActivitiesContact, en su lugar se usa el evento est�ndar OnAfterUpdateVendor de la CU 5055
                                 Se elimina el evento TryGetPurchJournalLineCUCalcItemAvailability, en su lugar se usa el evento est�ndar OnAfterGetDocumentEntries de la CU 5530
                                 Se elimina el evento ItemLineOutputShowWarning que no se emplea
                                 Se elimina el evento trackingFRISReceiptNoAndReceiptLineNo que no hace nada
                                 Se elimina el evento OnRunGenJnlPostLinePurchPost, se cambia por el evento OnBeforePostInvPostBuffer de la CU 90 que es mas apropiado
                                 Se eliminan los eventos que no se usan FunSaveDimensionGenJnlPostLine, AutoTextResourceTransferExtendedText
                                                                        RunGenJnlPostLine, OnPurchPostCUOnAfterCreateBills, OnPostItemJnlLineJobConsumption
      JAV 13/07/22: - QB 1.11.00 Se elimina la funci�n CreateDimensionAllocationsGenJnlPostBatch que no es necesaria
    }
END.*/
}







