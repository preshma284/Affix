Codeunit 7206985 "QB FA Analitical Distribution"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        GLSetup: Record 98;

    PROCEDURE OnAfterInsertGenJnlLineTmp(VAR GenJnlLineTmp: Record 81 TEMPORARY; FixedAsset: Record 5600);
    VAR
        LineNo: Integer;
        TotalAmount: Decimal;
        GenJournalLineAux: Record 81;
        AnaliticalDistrbution: Record 7206999;
        DefaultDimension: Record 352;
        TempDimensionSetEntry: Record 480 TEMPORARY;
        TempDimensionSetEntry_Distribution: Record 480 TEMPORARY;
        DimensionManagement: Codeunit 408;
        DimensionValue: Record 349;
        FASetup: Record 5603;
        FAJournalSetup: Record 5605;
        AmountDistributed: Decimal;
    BEGIN
        GLSetup.GET;

        //Q5566
        //Subcripci�n al momento en que se crea la linea de diario general tipo Activo Fijo.
        //Aqui creamos el resto de lineas de distribuci�n

        //Solo los que est�n al 100% se pueden repartir
        AnaliticalDistrbution.RESET();
        AnaliticalDistrbution.SETRANGE("AF Code", FixedAsset."No.");
        AnaliticalDistrbution.CALCSUMS("Distribution %");
        IF (AnaliticalDistrbution."Distribution %" <> 100) THEN
            EXIT;

        AnaliticalDistrbution.RESET;
        AnaliticalDistrbution.SETRANGE("AF Code", FixedAsset."No.");
        IF AnaliticalDistrbution.FINDSET THEN BEGIN

            FASetup.GET();
            FAJournalSetup.GET(FASetup."Default Depr. Book", '');

            //Copiamos el original porque esta en una tabla temporal y vamos a crear las lineas ahi.
            GenJournalLineAux := GenJnlLineTmp;

            //Obtenemos la linea
            LineNo := GenJournalLineAux."Line No.";

            //Borramos el estandar
            GenJnlLineTmp.DELETE;

            TotalAmount := 0;

            REPEAT

                GenJnlLineTmp.INIT;
                GenJnlLineTmp := GenJournalLineAux;

                GenJnlLineTmp."Journal Template Name" := FAJournalSetup."FA Jnl. Template Name";
                GenJnlLineTmp."Journal Batch Name" := FAJournalSetup."FA Jnl. Batch Name";

                GenJnlLineTmp."Line No." := LineNo;
                GenJnlLineTmp.Amount := ROUND(GenJnlLineTmp.Amount * (AnaliticalDistrbution."Distribution %" / 100), GLSetup."Amount Rounding Precision");

                TotalAmount += GenJnlLineTmp.Amount;

                //CPA 22/06/22 Q17292.Begin
                GenJnlLineTmp.VALIDATE("Job No.", AnaliticalDistrbution."Job No.");
                GenJnlLineTmp.VALIDATE("Piecework Code", AnaliticalDistrbution."Piecework Code");
                //CPA 22/06/22 Q17292.End

                CLEAR(TempDimensionSetEntry);
                TempDimensionSetEntry.DELETEALL();

                DimensionManagement.GetDimensionSet(TempDimensionSetEntry, GenJnlLineTmp."Dimension Set ID");


                //CPA 22/06/22. No es necesario meter las dimensiones del activo pues ya vienen en las l�neas del reparto
                /*{
                          //Metemos las dimensiones del AF
                          DefaultDimension.RESET();
                          DefaultDimension.SETRANGE("Table ID", DATABASE::"Fixed Asset");
                          DefaultDimension.SETRANGE("No.", FixedAsset."No.");
                          //DefaultDimension.SETFILTER("Dimension Code", '<>%1', AnaliticalDistrbution."Dimension Code 1");
                          //DefaultDimension.SETFILTER("Dimension Code", '<>%1&<>%2', AnaliticalDistrbution."Dimension Code 1", AnaliticalDistrbution."Dimension Code 2"); //Q5566_2
                          DefaultDimension.SETFILTER("Dimension Code", '<>%1&<>%2&<>%3', AnaliticalDistrbution."Entry No.", AnaliticalDistrbution."Dimension Code 2", AnaliticalDistrbution."Dimension Code 3"); //Q5566_3
                          IF DefaultDimension.FINDSET THEN BEGIN
                            REPEAT
                              IF DimensionValue.GET(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") THEN BEGIN
                                IF NOT TempDimensionSetEntry.GET(GenJnlLineTmp."Dimension Set ID", DimensionValue."Dimension Code") THEN BEGIN
                                  TempDimensionSetEntry.INIT();
                                  TempDimensionSetEntry."Dimension Set ID" := GenJnlLineTmp."Dimension Set ID";
                                  TempDimensionSetEntry."Dimension Code" := DimensionValue."Dimension Code";
                                  TempDimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
                                  TempDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                                  TempDimensionSetEntry.INSERT;
                                END;
                              END;
                            UNTIL DefaultDimension.NEXT = 0;
                          END;
                          }*/

                TempDimensionSetEntry_Distribution.RESET;
                TempDimensionSetEntry_Distribution.DELETEALL;
                DimensionManagement.GetDimensionSet(TempDimensionSetEntry_Distribution, AnaliticalDistrbution."Dimension Set ID");
                IF TempDimensionSetEntry_Distribution.FINDSET THEN
                    REPEAT
                        UpdatetempDimensionSetEntry(TempDimensionSetEntry_Distribution, GenJnlLineTmp."Dimension Set ID", TempDimensionSetEntry);
                    UNTIL TempDimensionSetEntry_Distribution.NEXT = 0;
                /*{
                          //A�adimos la dimensi�n de distribuci�n 1
                          IF DimensionValue.GET(AnaliticalDistrbution."Entry No.", AnaliticalDistrbution."Dimension Value Code 1") THEN BEGIN
                            IF NOT TempDimensionSetEntry.GET(GenJnlLineTmp."Dimension Set ID", DimensionValue."Dimension Code") THEN BEGIN
                              TempDimensionSetEntry.INIT();
                              TempDimensionSetEntry."Dimension Set ID" := GenJnlLineTmp."Dimension Set ID";
                              TempDimensionSetEntry."Dimension Code" := DimensionValue."Dimension Code";
                              TempDimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
                              TempDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                              TempDimensionSetEntry.INSERT;
                            END ELSE BEGIN
                              TempDimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
                              TempDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                              TempDimensionSetEntry.MODIFY;
                            END;
                          END;

                          //A�adimos la dimensi�n de distribuci�n 2 //Q5566_2
                          IF DimensionValue.GET(AnaliticalDistrbution."Dimension Code 2", AnaliticalDistrbution."Dimension Value Code 2") THEN BEGIN
                            IF NOT TempDimensionSetEntry.GET(GenJnlLineTmp."Dimension Set ID", DimensionValue."Dimension Code") THEN BEGIN
                              TempDimensionSetEntry.INIT();
                              TempDimensionSetEntry."Dimension Set ID" := GenJnlLineTmp."Dimension Set ID";
                              TempDimensionSetEntry."Dimension Code" := DimensionValue."Dimension Code";
                              TempDimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
                              TempDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                              TempDimensionSetEntry.INSERT;
                            END ELSE BEGIN
                              TempDimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
                              TempDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                              TempDimensionSetEntry.MODIFY;
                            END;
                          END;

                          //A�adimos la dimensi�n de distribuci�n 3 //Q5566_3
                          IF DimensionValue.GET(AnaliticalDistrbution."Dimension Code 3", AnaliticalDistrbution."Dimension Value Code 3") THEN BEGIN
                            IF NOT TempDimensionSetEntry.GET(GenJnlLineTmp."Dimension Set ID", DimensionValue."Dimension Code") THEN BEGIN
                              TempDimensionSetEntry.INIT();
                              TempDimensionSetEntry."Dimension Set ID" := GenJnlLineTmp."Dimension Set ID";
                              TempDimensionSetEntry."Dimension Code" := DimensionValue."Dimension Code";
                              TempDimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
                              TempDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                              TempDimensionSetEntry.INSERT;
                            END ELSE BEGIN;
                              TempDimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
                              TempDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                              TempDimensionSetEntry.MODIFY;
                            END;
                          END;
                          }*/

                //Obtenemos el nuevo Dim Set ID
                //GenJnlLineTmp."Dimension Set ID" := DimensionManagement.GetDimensionSetID(TempDimensionSetEntry);
                GenJnlLineTmp.VALIDATE("Dimension Set ID", DimensionManagement.GetDimensionSetID(TempDimensionSetEntry));


                //    TempDimensionSetEntry.RESET;
                //    TempDimensionSetEntry.SETRANGE("Dimension Code", GeneralLedgerSetup."Dimension Jobs Code");
                //    IF TempDimensionSetEntry.FINDFIRST THEN
                //      GenJnlLineTmp."Job No." := TempDimensionSetEntry."Dimension Value Code";

                GenJnlLineTmp.INSERT(TRUE);

                LineNo += 10000;

            UNTIL AnaliticalDistrbution.NEXT = 0;

            IF GenJournalLineAux.Amount <> TotalAmount THEN BEGIN
                GenJnlLineTmp.VALIDATE(Amount, GenJnlLineTmp.Amount + GenJournalLineAux.Amount - TotalAmount);
                GenJnlLineTmp.MODIFY(TRUE);
                //CPA. 27/10/22 - Q18216.Begin
            END ELSE BEGIN
                GenJnlLineTmp.VALIDATE("Job No.", FixedAsset."Asset Allocation Job");
                GenJnlLineTmp.VALIDATE("Piecework Code", FixedAsset."Piecework Code");
                //CPA. 27/10/22 - Q18216.End
            END;
        END;
    END;

    PROCEDURE OnAfterInsertGenJnlLine(VAR GenJnlLine: Record 81; VAR GenJnlLineTmp: Record 81 TEMPORARY);
    VAR
        AnaliticalDistrbution: Record 7206999;
        FixedAsset: Record 5600;
    BEGIN
        //5566
        //Pasar las dimensiones

        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" THEN BEGIN
            FixedAsset.GET(GenJnlLine."Account No.");


            //CPA. 27/10/22 - Q18216.Begin
            //GenJnlLine."Job No." := GenJnlLineTmp."Job No.";
            GenJnlLine."QB Job No." := GenJnlLineTmp."Job No.";
            //CPA. 27/10/22 - Q18216.End

            //CPA 22/06/22 Q17292.Begin
            GenJnlLine."Piecework Code" := GenJnlLineTmp."Piecework Code";
            //CPA 22/06/22 Q17292.End


            AnaliticalDistrbution.RESET;
            AnaliticalDistrbution.SETRANGE("AF Code", FixedAsset."No.");
            IF AnaliticalDistrbution.FINDSET THEN
                GenJnlLine.VALIDATE("Dimension Set ID", GenJnlLineTmp."Dimension Set ID");

            GenJnlLine.MODIFY(TRUE);
            //CPA. 27/10/22 - Q18216.Begin
        END ELSE IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" THEN BEGIN
            GenJnlLine."Job No." := GenJnlLineTmp."Job No.";
            GenJnlLine."Piecework Code" := GenJnlLineTmp."Piecework Code";
            GenJnlLine.MODIFY(TRUE);
            ;
            //CPA. 27/10/22 - Q18216.End
        END;
    END;

    PROCEDURE OnAfterGetRecordFixedAsset(VAR GenJournalLine: Record 81; FixedAsset: Record 5600; DepreciationBook: Record 5611);
    VAR
        FunctionQB: Codeunit 7207272;
        FADepreciationBook: Record 5612;
        FA: Record 5600;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF GenJournalLine."Account Type" <> GenJournalLine."Account Type"::"Fixed Asset" THEN BEGIN
                //CPA Q17292.Begin
                //FADepreciationBook.GET(FixedAsset."No.",DepreciationBook.Code);
                //GenJournalLine."Job No." := FADepreciationBook."OLD_Asset Allocation Job";
                GenJournalLine."Job No." := FixedAsset."Asset Allocation Job";
                //CPA Q17292.End

                GenJournalLine.VALIDATE("Job No.");
                //CPA Q17292.Begin
                //GenJournalLine."Piecework Code" := FADepreciationBook."OLD_Piecework Code";
                GenJournalLine."Piecework Code" := FixedAsset."Piecework Code";
                //CPA Q17292.End
                GenJournalLine.MODIFY;
            END;
        END;
    END;

    PROCEDURE OnPostDataItemFixedAsset1(GenJournalLine: Record 81);
    VAR
        FunctionQB: Codeunit 7207272;
        GenJnlLineTmp: Record 81;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            GenJournalLine."Job No." := GenJnlLineTmp."Job No.";
            GenJournalLine.VALIDATE("Job No.");
            GenJournalLine."Piecework Code" := GenJnlLineTmp."Piecework Code";
        END;
    END;

    PROCEDURE OnPostDataItemFixedAsset2(GenJournalLine: Record 81);
    VAR
        FunctionQB: Codeunit 7207272;
        GenJnlLineTmp: Record 81;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF GenJournalLine."Account Type" <> GenJournalLine."Account Type"::"Fixed Asset" THEN BEGIN
                GenJournalLine."Job No." := GenJnlLineTmp."Job No.";
                GenJournalLine.VALIDATE("Job No.");
                GenJournalLine."Piecework Code" := GenJnlLineTmp."Piecework Code";
            END ELSE BEGIN
                GenJournalLine."Job No." := '';
                GenJournalLine."Piecework Code" := '';
            END;
            GenJournalLine.MODIFY(TRUE);
        END;
    END;

    LOCAL PROCEDURE UpdatetempDimensionSetEntry(TempDimensionSetEntry_Source: Record 480 TEMPORARY; newDimensionSetEntry: Integer; VAR tempDimensionSetEntry_Dest: Record 480 TEMPORARY);
    VAR
        DefaultDimension: Record 352;
    BEGIN
        IF NOT tempDimensionSetEntry_Dest.GET(newDimensionSetEntry, TempDimensionSetEntry_Source."Dimension Code") THEN BEGIN
            tempDimensionSetEntry_Dest.INIT;
            tempDimensionSetEntry_Dest.VALIDATE("Dimension Set ID", newDimensionSetEntry);
            tempDimensionSetEntry_Dest.VALIDATE("Dimension Code", TempDimensionSetEntry_Source."Dimension Code");
            tempDimensionSetEntry_Dest.VALIDATE("Dimension Value Code", TempDimensionSetEntry_Source."Dimension Value Code");
            tempDimensionSetEntry_Dest.INSERT(TRUE);
        END ELSE BEGIN
            tempDimensionSetEntry_Dest.VALIDATE("Dimension Value Code", TempDimensionSetEntry_Source."Dimension Value Code");
            tempDimensionSetEntry_Dest.MODIFY(TRUE);
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 50018, cdu5601_OnAfterRun, '', true, true)]
    LOCAL PROCEDURE cdu5601_OnAfterRun(VAR Rec: Record 5601; VAR TempFAGLPostBuf: Record 5637 TEMPORARY; NumberOfEntries: Integer; OrgGenJnlLine: Boolean; NetDisp: Boolean; FAGLPostBuf: Record 5637; DisposalEntry: Boolean; BookValueEntry: Boolean; NextEntryNo: Integer; GLEntryNo: Integer; DisposalEntryNo: Integer; DisposalAmount: Decimal; GainLossAmount: Decimal; FAPostingGr2: Record 5606);
    VAR
        QBFAAnaliticalDistribution: Record 7206999;
        RecordNumber: Integer;
        Total: Decimal;
        k: Integer;
        TempFAGLPostBuf2: Record 5637 TEMPORARY;
        GeneralLedgerSetup: Record 98;
    BEGIN
        //-Q20269
        GeneralLedgerSetup.GET;
        QBFAAnaliticalDistribution.SETRANGE("AF Code", Rec."FA No.");
        RecordNumber := QBFAAnaliticalDistribution.COUNT;
        IF RecordNumber = 0 THEN EXIT; //No hay reparto
        Total := TempFAGLPostBuf.Amount;
        k := 0;
        TempFAGLPostBuf2 := TempFAGLPostBuf;
        TempFAGLPostBuf.DELETE;
        IF QBFAAnaliticalDistribution.FINDSET THEN
            REPEAT
                k += 1;
                TempFAGLPostBuf := TempFAGLPostBuf2;
                TempFAGLPostBuf."Entry No." := TempFAGLPostBuf."Entry No." + k - 1;
                TempFAGLPostBuf."Job No." := QBFAAnaliticalDistribution."Job No.";
                TempFAGLPostBuf."Piecework Code" := QBFAAnaliticalDistribution."Piecework Code";
                TempFAGLPostBuf."Global Dimension 1 Code" := QBFAAnaliticalDistribution."Shortcut Dimension 1 Code";
                TempFAGLPostBuf."Global Dimension 2 Code" := QBFAAnaliticalDistribution."Shortcut Dimension 2 Code";
                TempFAGLPostBuf."Dimension Set ID" := QBFAAnaliticalDistribution."Dimension Set ID";
                IF k <> RecordNumber THEN BEGIN
                    TempFAGLPostBuf.Amount := ROUND(TempFAGLPostBuf2.Amount * (QBFAAnaliticalDistribution."Distribution %" / 100), GeneralLedgerSetup."Amount Rounding Precision");
                    Total := Total - TempFAGLPostBuf.Amount;
                END
                ELSE BEGIN
                    TempFAGLPostBuf.Amount := Total;
                END;
                TempFAGLPostBuf.INSERT;
            UNTIL QBFAAnaliticalDistribution.NEXT = 0;
        TempFAGLPostBuf.FINDSET;
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnPostFixedAssetOnBeforeInsertGLEntry, '', true, true)]
    LOCAL PROCEDURE cdu12_OnPostFixedAssetOnBeforeInsertGLEntry(VAR GenJournalLine: Record 81; VAR GLEntry: Record 17; VAR IsHandled: Boolean; VAR TempFAGLPostBuf: Record 5637 TEMPORARY);
    BEGIN
        //-Q20269
        GenJournalLine."Piecework Code" := TempFAGLPostBuf."Piecework Code"
    END;

    /*BEGIN
/*{
      PEL 30/01/19: - Q5566 Distribuci�n Activos Fijos
      PEL 21/03/19: - Q5566_2 Dimensi�n 2
      PEL 21/03/19: - Q5566_3 Dimensi�n 3
      JAV 31/05/22: - QB 1.10.46 (Q5566) Se incorpora la funcionalidad de distribuir importes desde INESCO. Revisar si hace falta algo o sobran funciones
    }
END.*/
}









