// report 50086 "Fix invoices"
// {


//     Permissions = TableData 169 = rimd;
//     ProcessingOnly = true;

//     dataset
//     {

//         DataItem("Job Ledger Entry"; "Job Ledger Entry")
//         {



//             RequestFilterFields = "Entry No.";
//             DataItem("Purch. Inv. Header"; "Purch. Inv. Header")
//             {



//                 RequestFilterFields = "Document No.";
//                 DataItem("Purch. Inv. Line"; "Purch. Inv. Line")
//                 {



//                     RequestFilterFields = "Document No.";
//                     DataItemLink = "Document No." = FIELD("No.");
//                     trigger OnPreDataItem();
//                     BEGIN
//                         "Purch. Inv. Line".SETRANGE("Posting Date", 050122D, 123122D);
//                         "Purch. Inv. Line".SETRANGE(Type, "Purch. Inv. Line".Type::Item);
//                         FechaMinima := 20221231D;
//                     END;

//                     trigger OnAfterGetRecord();
//                     BEGIN
//                         IF "Purch. Inv. Line"."Job No." = '' THEN CurrReport.SKIP;

//                         IF "Purch. Inv. Line".Quantity <> 0 THEN BEGIN
//                             JobLedgerEntry.SETRANGE("Document No.", "Purch. Inv. Line"."Document No.");
//                             JobLedgerEntry.SETRANGE(Type, JobLedgerEntry.Type::Item);
//                             JobLedgerEntry.SETRANGE("No.", "Purch. Inv. Line"."No.");
//                             JobLedgerEntry.SETRANGE(Quantity, "Purch. Inv. Line".Quantity);
//                             //JobLedgerEntry.SETRANGE("Total Cost (LCY)","Purch. Inv. Line".Amount);
//                             Total := ROUND(ROUND("Purch. Inv. Line"."Unit Cost (LCY)", 0.01) * "Purch. Inv. Line".Quantity, 0.01);
//                             //////JobLedgerEntry.SETFILTER("Total Cost (LCY)",'%1 | %2',Total,"Purch. Inv. Line".Amount);
//                             JobLedgerEntry.SETRANGE("Piecework No.", "Purch. Inv. Line"."Piecework No.");
//                             JobLedgerEntry.SETRANGE("QB TMP Rastreado", FALSE);
//                             IF JobLedgerEntry.FINDSET THEN BEGIN
//                                 JobLedgerEntry2.GET(JobLedgerEntry."Entry No.");
//                                 JobLedgerEntry2."QB TMP Rastreado" := TRUE;
//                                 JobLedgerEntry2.MODIFY;
//                                 CurrReport.SKIP;
//                             END
//                             ELSE BEGIN
//                                 IF FechaMinima > "Purch. Inv. Line"."Posting Date" THEN FechaMinima := "Purch. Inv. Line"."Posting Date";
//                                 GenerateJobEntries;
//                                 Counter += 1;
//                             END;

//                         END;
//                     END;


//                 }
//                 trigger OnPreDataItem();
//                 BEGIN
//                     IF GETFILTER("Posting Date") = '' THEN SETRANGE("Posting Date", 050122D, 123122D);
//                 END;

//                 trigger OnAfterGetRecord();
//                 VAR
//                     //                                   PurchInvLine@1100286000 :
//                     PurchInvLine: Record 123;
//                     //                                   TotalInv@1100286001 :
//                     TotalInv: Decimal;
//                     //                                   TotalJob@1100286002 :
//                     TotalJob: Decimal;
//                 BEGIN
//                     TotalInv := 0;
//                     TotalJob := 0;
//                     PurchInvLine.RESET;
//                     PurchInvLine.SETRANGE("Document No.", "Purch. Inv. Header"."No.");
//                     PurchInvLine.SETRANGE(Type, PurchInvLine.Type::Item);
//                     PurchInvLine.SETFILTER("Job No.", '<> %1', '');
//                     IF PurchInvLine.FINDSET THEN
//                         REPEAT
//                             TotalInv += PurchInvLine.Amount;
//                         UNTIL PurchInvLine.NEXT = 0;

//                     JobLedgerEntry.RESET;
//                     JobLedgerEntry.SETRANGE("Document No.", "Purch. Inv. Header"."No.");
//                     JobLedgerEntry.SETRANGE(Type, JobLedgerEntry.Type::Item);
//                     IF JobLedgerEntry.FINDSET THEN
//                         REPEAT
//                             TotalJob += JobLedgerEntry."Total Cost (LCY)";
//                         UNTIL JobLedgerEntry.NEXT = 0;

//                     //IF TotalInv = TotalJob THEN CurrReport.SKIP ELSE
//                     //IF (TotalInv > (TotalJob -3)) AND (TotalInv < (TotalJob + 3)) THEN CurrReport.SKIP;

//                     IF JobLedgerEntry.COUNT >= PurchInvLine.COUNT THEN CurrReport.SKIP;
//                 END;


//             }
//             trigger OnAfterGetRecord();
//             BEGIN
//                 IF "QB TMP Rastreado" THEN BEGIN
//                     "QB TMP Rastreado" := FALSE;
//                     MODIFY;
//                 END;
//             END;


//         }
//     }
//     requestpage
//     {

//         layout
//         {
//         }
//     }
//     labels
//     {
//     }

//     var
//         //       JobLedgerEntry@1000000000 :
//         JobLedgerEntry: Record 169;
//         //       JobLedgerEntry2@1000000001 :
//         JobLedgerEntry2: Record 169;
//         //       SourceCodeSetup@1100286001 :
//         SourceCodeSetup: Record 242;
//         //       SrcCode@1100286000 :
//         SrcCode: Code[20];
//         //       Item@1100286002 :
//         Item: Record 27;
//         //       Job@1100286003 :
//         Job: Record 167;
//         //       JobJnlPostLine@1100286004 :
//         JobJnlPostLine: Codeunit 1012;
//         //       InventoryPostingSetup@1100286005 :
//         InventoryPostingSetup: Record 5813;
//         //       Location@1100286006 :
//         Location: Record 14;
//         //       FechaMinima@1100286007 :
//         FechaMinima: Date;
//         //       tPurchInvHeader@1100286008 :
//         tPurchInvHeader: Record 122 TEMPORARY;
//         //       Counter@1100286009 :
//         Counter: Integer;
//         //       Total@1100286010 :
//         Total: Decimal;

//     procedure GenerateJobEntries()
//     var
//         //       PostDate@1100286001 :
//         PostDate: Date;
//         //       JobJournalLine@1100286002 :
//         JobJournalLine: Record 210;
//         //       LineaJob@1100286003 :
//         LineaJob: Integer;
//         //       PurchInvHeader@1100286004 :
//         PurchInvHeader: Record 122;
//     begin
//         //Crear el movimiento de proyecto asociado a la entrada, tanto en el proyecto actual como en el de desviaciones de almac‚n
//         SourceCodeSetup.GET;
//         SrcCode := 'MANUALC';
//         PurchInvHeader.GET("Purch. Inv. Line"."Document No.");
//         //Crear el movimiento de proyecto que cancela el anterior
//         JobJournalLine.INIT;
//         LineaJob := 10000;
//         PostDate := "Purch. Inv. Line"."Posting Date";
//         JobJournalLine."Journal Template Name" := 'PROYECTO';
//         JobJournalLine."Journal Batch Name" := 'GENERICO';
//         JobJournalLine."Line No." := LineaJob;
//         JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
//         JobJournalLine."Job No." := "Purch. Inv. Line"."Job No.";
//         JobJournalLine."Job Task No." := "Purch. Inv. Line"."Job Task No.";
//         JobJournalLine."Posting Date" := PostDate;
//         JobJournalLine."Document Date" := "Purch. Inv. Line"."Posting Date";
//         JobJournalLine."Document No." := "Purch. Inv. Line"."Document No.";
//         JobJournalLine."External Document No." := PurchInvHeader."Vendor Invoice No.";
//         JobJournalLine.Type := JobJournalLine.Type::Item;
//         JobJournalLine."No." := "Purch. Inv. Line"."No.";
//         JobJournalLine.Description := "Purch. Inv. Line".Description;
//         JobJournalLine.VALIDATE("Location Code", "Purch. Inv. Line"."Location Code");
//         JobJournalLine.VALIDATE("Unit of Measure Code", "Purch. Inv. Line"."Unit of Measure Code");
//         JobJournalLine.VALIDATE(Quantity, "Purch. Inv. Line".Quantity);
//         JobJournalLine.VALIDATE("Unit Cost (LCY)", "Purch. Inv. Line"."Unit Cost (LCY)");
//         //JobJournalLine."Total Cost" := JobJournalLine."Total Cost (LCY)";
//         JobJournalLine."Shortcut Dimension 1 Code" := "Purch. Inv. Line"."Shortcut Dimension 1 Code";
//         JobJournalLine."Shortcut Dimension 2 Code" := "Purch. Inv. Line"."Shortcut Dimension 2 Code";
//         JobJournalLine."Source Code" := SrcCode;
//         Item.GET("Purch. Inv. Line"."No.");
//         JobJournalLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
//         Job.GET("Purch. Inv. Line"."Job No.");
//         if Job."Job Posting Group" <> '' then
//             JobJournalLine."Posting Group" := Job."Job Posting Group";
//         JobJournalLine."Posting No. Series" := PurchInvHeader."No.";
//         JobJournalLine."Post Job Entry Only" := TRUE;
//         JobJournalLine."Serial No." := PurchInvHeader."No. Series";
//         JobJournalLine."Posting No. Series" := PurchInvHeader."No.";
//         JobJournalLine."Piecework Code" := "Purch. Inv. Line"."Piecework No.";
//         JobJournalLine."Variant Code" := "Purch. Inv. Line"."Variant Code";
//         /////////////////////////////////////ENCONTRAR JobJournalLine."Related Item Entry No." := ItemJournalLine."Item Shpt. Entry No.";
//         JobJournalLine."Job Posting Only" := TRUE;
//         JobJournalLine."Activation Entry" := TRUE;
//         JobJournalLine."Dimension Set ID" := "Purch. Inv. Line"."Dimension Set ID";
//         //if OutputShipmentLines."Job Line Type" = OutputShipmentLines."Job Line Type"::" " then
//         //JobJournalLine."Line Type" := OutputShipmentLines."Job Line Type"::"Both Budget and Billable"
//         //else
//         //JobJournalLine."Line Type" := OutputShipmentLines."Job Line Type";
//         JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable";

//         JobJournalLine."Source Type" := JobJournalLine."Source Type"::Vendor;
//         JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Invoice;
//         JobJournalLine."Source No." := PurchInvHeader."Buy-from Vendor No.";
//         JobJournalLine."Source Name" := PurchInvHeader."Buy-from Vendor Name";

//         JobJnlPostLine.ResetJobLedgEntry();

//         JobJnlPostLine.RunWithCheck(JobJournalLine);
//     end;

//     /*begin
//     //{
// //      AML 28/06/22: - Temporal, solo para reparar el tema de las facturas sin movimiento de proyecto
// //    }
//     end.
//   */

// }



// // RequestFilterFields="Document No.";
