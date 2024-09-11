Codeunit 7207351 "QB - Report - Subscriber"
{


    trigger OnRun()
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207350, TestJobFieldsRepGeneralJournal, '', true, true)]
    LOCAL PROCEDURE TestJobFieldsRepGeneralJournal(VAR GenJournalLine: Record 81);
    VAR
        FunctionQB: Codeunit 7207272;
        LGLAccount: Record 15;
        GeneralJournalTest: Report 2;
        Text000: TextConst ENU = '%1 must be specified.', ESP = 'Se debe indicar %1.';
        Text001: TextConst ESP = 'No existe el proyecto %1';
        Text002: TextConst ESP = 'El proyecto %1 no puede estar en estado %2';
        Job: Record 167;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") THEN BEGIN
                LGLAccount.GET(GenJournalLine."Account No.");
                IF LGLAccount."Income/Balance" = LGLAccount."Income/Balance"::"Income Statement" THEN BEGIN
                    IF (GenJournalLine."Job No." = '') THEN BEGIN
                        // IF GenJournalLine."Job Task No." = '' THEN
                        //     GeneralJournalTest.QB_AddError(STRSUBSTNO(Text000, GenJournalLine.FIELDCAPTION("Job No.")));
                        // IF NOT Job.GET(GenJournalLine."Job No.") THEN
                        //     GeneralJournalTest.QB_AddError(STRSUBSTNO(Text001, GenJournalLine."Job No."));
                        // IF Job.Blocked.AsInteger() > Job.Blocked::" ".AsInteger() THEN
                        //     GeneralJournalTest.QB_AddError(STRSUBSTNO(Text002, Job, Job.Blocked));
                    END;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------ Compras"();
    BEGIN
    END;

    PROCEDURE CalcPurchaseAmounts(Rec: Record 38; VAR AmTotal: Decimal; VAR AmPend: Decimal; VAR AmWith: Decimal);
    VAR
        PurchaseLine: Record 39;
        Currency: Record 4;
    BEGIN
        AmTotal := 0;
        AmPend := 0;
        AmWith := 0;

        Currency.InitRoundingPrecision;

        Rec.CALCFIELDS("QW Total Withholding GE", "QW Total Withholding GE Before");
        AmWith := Rec."QW Total Withholding GE" + Rec."QW Total Withholding GE Before";

        //Calcular Importes
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        IF (PurchaseLine.FINDSET(FALSE)) THEN
            REPEAT
                AmTotal += PurchaseLine."Line Amount";
                AmPend += ROUND((PurchaseLine.Quantity - PurchaseLine."Quantity Received") * PurchaseLine."Direct Unit Cost" * PurchaseLine."Line Discount %" / 100,
                                 Currency."Amount Rounding Precision");
            UNTIL (PurchaseLine.NEXT = 0);
    END;

    /*BEGIN
/*{
      PEL 21/05/18: - QVE_1853 A�adidas parametros a funci�n OnAfterGetRecordFixedAssetRepCalculateDepreciation
      JAV 16/10/20: - Se eliminan como respuesta a eventos de activos, en su lugar son directamente una funci�n que es mas r�pido
                         - OnAfterGetRecordFixedAssetRepCalculateDepreciation
                         - OnPostDataItemFixedAsset1RepCalculateDepreciation
                         - OnPostDataItemFixedAsset2RepCalculateDepreciation
      JAV 15/11/21: - QB 1.09.27 Se eliminan los eventos que no se utilizan: OnAfterGetRecordPrintCheckRepCheck, SetInitRepChangeGlobalDimensions, SetDefaultDimRepChangeGlobalDimensions
      JAV 05/07/22: - QB 1.10.58 (Q17292) cambiamos el uso de las variables del libro al propio activo
      JAV 05/07/22: - QB 1.10.58 Se eliminan las funciones que no se usan OnAfterGetRecordFixedAssetRepCalculateDepreciation, OnPostDataItemFixedAsset1RepCalculateDepreciation,
                                 OnPostDataItemFixedAsset2RepCalculateDepreciation
      JAV 05/07/22: - QB 1.10.59 Se eliminan las funciones SetGLBudgetNameRepImportBudToExcel que realmente no funciona ni es necesaria
                                                           OnInitReportRepPostInventoryCosttoGL que realmente no funciona ni es necesaria
    }
END.*/
}







