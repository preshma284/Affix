Codeunit 7207322 "Element Post.-Master-Entry"
{
  
  
    TableNo=7207352;
    trigger OnRun()
BEGIN
            RentalElementsEntries.SETCURRENTKEY("Transaction No.");
            RentalElementsEntries.SETRANGE("Transaction No.",rec."Transaction No.");
            PAGE.RUN(PAGE::"Rental Elements Entries List",RentalElementsEntries);
          END;
    VAR
      RentalElementsEntries : Record 7207345;

    /* /*BEGIN
END.*/
}







