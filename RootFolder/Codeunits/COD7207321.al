Codeunit 7207321 "Journal. (Element)-Show Entry"
{
  
  
    TableNo=7207350;
    trigger OnRun()
BEGIN
            RentalElementsEntries.SETCURRENTKEY("Element No.","Posting Date");
            RentalElementsEntries.SETRANGE("Element No.",rec."Element No.");
            IF RentalElementsEntries.FINDLAST THEN;
            PAGE.RUN(PAGE::"Rental Elements Entries List",RentalElementsEntries);
          END;
    VAR
      RentalElementsEntries : Record 7207345;

    /* /*BEGIN
END.*/
}







