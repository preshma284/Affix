pageextension 50106 MyExtension10753 extends 10753//10750
{
layout
{


}

actions
{


}

//trigger

//trigger

var
      TempVendorLedgerEntry : Record 25 TEMPORARY ;
      TempCustLedgEntry : Record 21 TEMPORARY ;
      TempDetailedVendorLedgEntry : Record 380 TEMPORARY ;
      TempDetailedCustLedgEntry : Record 379 TEMPORARY ;
      FromDate : Date;
      SIISetupNotEnabledErr : TextConst ENU='The Enabled check box in the SII Setup window must be selected before you can recreate missing SII entries.',ESP='Debe activar la casilla Habilitado en la ventana Configuraci¢n de SII para poder volver a crear los movimientos de SII que faltan.';
      AllowRecreateAll : Boolean;
      SomeEntriesAreNotConsideredLbl : TextConst ENU='The entries that have already been scanned will be skipped. Learn why, and what to do.',ESP='Se omitir n los movimientos que ya se han examinado. Descubra por qu‚ y qu‚ debe hacer.';
      EntriesToBeConsideredMsg : TextConst ENU='To speed up the scanning for missing SII entries, the entries that have already been scanned will be skipped.\\To scan all the entries from the starting date, choose Scan All Entries.',ESP='Para acelerar la b£squeda de movimientos SII que faltan se omitir n los movimientos que ya se han examinado.\\Para buscar todos los movimientos desde la fecha de inicio, seleccione Buscar todos los movs.';
      ScanAllEntriesLbl : TextConst ENU='Scan All Entries',ESP='Buscar todos los movs.';

    
    

//procedure
//Local procedure GetSourceEntries(AllEntries : Boolean);
//    var
//      SIIMissingEntriesState : Record 10754;
//      SIIRecreateMissingEntries : Codeunit 10757;
//    begin
//      AllowRecreateAll := SIIMissingEntriesState.SIIEntryRecreated;
//      SIIRecreateMissingEntries.GetSourceEntries(
//        TempVendorLedgerEntry,TempCustLedgEntry,TempDetailedVendorLedgEntry,TempDetailedCustLedgEntry,AllEntries,FromDate);
//    end;

//procedure
}

