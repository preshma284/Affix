Codeunit 7207348 "QB - Page - Publisher"
{
  
  
    trigger OnRun()
BEGIN
          END;

    [IntegrationEvent(true,false)]
    PROCEDURE DimensionFilterEnablePageAccountSchedule(VAR filter1dimension : Boolean;VAR filter2dimension : Boolean;VAR filter3dimension : Boolean;VAR filter4dimension : Boolean);
    BEGIN
    END;

    [IntegrationEvent(true,false)]
    PROCEDURE ActualFiltersPageAccountSchedule(VAR AccScheduleLine : Record 85;VAR DimensionFilter1 : Boolean;VAR DimensionFilter2 : Boolean;VAR DimensionFilter3 : Boolean;VAR DimensionFilter4 : Boolean;currentSchedName : Code[10]);
    BEGIN
    END;

    [IntegrationEvent(true,false)]
    PROCEDURE LookUpDimFilterPageAccountSchedule(AccScheduleLine : Record 85;DimNo : Integer;VAR Text : Text[250];VAR booldimension : Boolean);
    BEGIN
    END;

    [IntegrationEvent(true,false)]
    PROCEDURE ShowPurchaseJobPItemAvailabilityLines(VAR Item : Record 27);
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE InitializeVATStatementPreviewLine(VAR VATStatement : Report 12;VAR VATStmtName : Record 257;VAR VATStatementLine : Record 256;Selection: Option "Open","Closed","Open and Closed";PeriodSelection: Option "Open","Closed","Open and Closed";NewPrintInIntegers : Boolean;NewUseAmtsInAddCurr : Boolean);
    BEGIN
    END;

    [IntegrationEvent(true,false)]
    PROCEDURE DimensionFilterSetRangePageAccScheduleOverview(VAR AccScheduleLine : Record 85;codeJobFilter : Code[20];AnalysisView : Record 363);
    BEGIN
    END;

    [IntegrationEvent(true,false)]
    PROCEDURE PurchaseContractPrint(DocumentType : Enum "Purchase Document Type";DocumentNo : Code[20]);
    BEGIN
      //JAV 22/03/19: - Evento PurchaseContractPrint para imprimir pedidos de compra como contratos
    END;

    [IntegrationEvent(true,false)]
    PROCEDURE CopyTextToJob(JobNo : Code[20]);
    BEGIN
      //JAV 22/03/19: - Nueva acci�n para cargar los textos desde el preciario de nuevo
    END;

    [IntegrationEvent(true,false)]
    PROCEDURE SetJobPageEditable(job : Record 167;VAR InternalStatusEditable : Boolean;VAR ChangeInternalStatus : Boolean);
    BEGIN
      //JAV 08/08/19: - Evento SetJobPageEditable para establecer os estados de edici�n de una p�gina
    END;

    /*BEGIN
/*{
      PEL 13/06/18: - QB2395 Funciones nuevas  --> Se eliminan con las nueva aprobaciones
      JAV 22/03/19: - Evento PurchaseContractPrint para imprimir pedidos de compra como contratos
                    - Eventos HistMeasurementsCancel para cancelar una medici�n registrada y PostCertificationsCancel para cancelar una certificaci�n registrada
      JAV 08/04/19: - Nuevo evento CopyTextToJob para copiar l�neas del preciario al proyecto o estudio
      JAV 25/07/19: - Evento HistProdMeasureCancel para cancelar una relaci�n valorada registrada
      JAV 11/10/19: - Se elimina la funci�n "OpenClosePurchaseOrder" y sus relacionadas, pues no hace nada �til
                          OpenClosePurchaseOrderPagePurchOrder
                          OpenClosePurchaseOrderPagePurchQuote
                          OpenClosePurchaseOrderPagePurchInvoice
                          OpenClosePurchaseOrderPagePurchCreditMemo
                          OpenClosePurchaseOrderPagePurchBlanketOrder
                          OpenClosePurchaseOrderPagePurchReturnOrder
                          OpenOrClosePurchaseOrderPagePurchaseOrder
      JAV 23/10/19: - Se eliminan funciones de c�lculos de las retenciones que no se utilizan ya
                          ValidateTotalReceivableWithholdings
                          ValidateTotalReceivableGetVATWithholdingsPurchaseStatistics
                          ValidateTotalReceivableGetVATWithholdingsSalesInvoiceStatistics
                          ValidateTotalReceivableGetVATWithholdingsSalesCrMemoStatistics
                          ValidateTotalReceivableGetVATWithholdingsPurchaseInvoiceStatistics
                          ValidateTotalReceivableGetVATWithholdingsPurchaseCrMemoStatistics
                          ValidateTotalReceivableGetVATWithholdingsSalesOrderStatistics
                          ValidateTotalReceivableGetVATWithholdingsPurchaseOrderStatistics
      JAV 24/10/19:  - Se elimina el evento RunWithholdingsMovsPageNavigate que no se utiliza
      JAV 29/10/20: - QB 1.07.02 Se eliminan los eventos que no se usan: OnOpenPagePJobTaskLines, ShowShortcutDimCodeJobNoPageSalesOrderSubform, SetTextDecimalsAndFormatText
      JAV 30/11/20: - QB 1.07.08 Se eliminan los eventos de manejo de la Page 344 Navigate, pues es mas r�pido usar la funci�n directamente:
                          IncludeQuobuildingDocumentsPageNavigateName
                          ShowGLEntriesFromExpenseNoteCodePageNavigate
                          ShowVendorLedgEntriesFromExpenseNoteCodePageNavigate
                          ShowDTLVendorLedgEntriesFromExpenseNoteCodePageNavigate
                          IncludeQuobuildingRentalElementEntriesPageNavigate
                          CalculateQuobuildingNoOfRecordsPageNavigate
                          VendorLedgerEntrySetSourcePageNavigate
                          DtlVendorLedgerEntrySetSourcePageNavigate
                          RentalElementEntriesSetSourcePageNavigate
                          ShowJobLedgerEntryFromExpenseNoteCodePageNavigate
                          RunPostedOutputShipmentHeaderPageNavigate
                          RunGLEntryPageNavigate
                          RunVendLedgEntryPageNavigate
                          RunDtldVendorLedgEntryPageNavigate
                          RunJobLedgerEntryPageNavigate
      JAV 10/04/22: - QB 1.10.34 Se eliminan las funciones que no se usan:
                          RecordInvoicePurchase, ValidateFilterDate, ValidateFilterDateOnOpen
                          OnSetMultipleJUCostsJob, OnSetMultJobUnits
    }
END.*/
}







