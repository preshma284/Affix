Codeunit 7207315 "Day. (Element)-Test Line"
{
  
  
    TableNo=7207350;
    trigger OnRun()
BEGIN
            GeneralLedgerSetup.GET;
            RunCheck(Rec);
          END;
    VAR
      GeneralLedgerSetup : Record 98;
      GenJnlTemplateFound : Boolean;
      GenJournalTemplate : Record 80;
      Text001 : TextConst ENU='Is not within your range of allowed posting dates',ESP='No est� dentro del periodo de fechas de registro permitidas';
      Text000 : TextConst ENU='Can only be a closing date for G/L entries',ESP='S�lo puede ser una fecha �ltima para movs. de cuentas';
      RentalElements : Record 7207344;
      DimensionManagement : Codeunit 408;
      Text011 : TextConst ENU='The combination of dimensions used in %1 %2, %3, %4 is blocked. %5',ESP='La combin. de dimensiones utilizada en %1 %2, %3, %4 est� bloq. %5';
      Text012 : TextConst ENU='A dimension used in %1 %2, %3, %4 has caused an error. %5',ESP='La dimensi�n util. en %1 %2, %3, %4 ha causado error. %5';
      AllowPostingFrom : Date;
      AllowPostingTo : Date;
      UserSetup : Record 91;
      Text007 : TextConst ENU='Must be positive',ESP='Debe ser positivo';
      Text008 : TextConst ENU='must be negative',ESP='debe ser negativo';

    PROCEDURE RunCheck(VAR PElementJournalLine : Record 7207350);
    VAR
      TableID : ARRAY [10] OF Integer;
      No : ARRAY [10] OF Code[20];
      Item : Record 27;
      RentalElements : Record 7207344;
    BEGIN
      WITH PElementJournalLine DO BEGIN
        IF EmptyLine THEN
          EXIT;
        IF NOT GenJnlTemplateFound THEN BEGIN
          IF GenJournalTemplate.GET("Journal Template Name") THEN;
          GenJnlTemplateFound := TRUE;
        END;

      //Metemos las comprobaciones de los campos a comprobar
        TESTFIELD("Posting Date");

        IF DateNotAllowed("Posting Date") THEN
          FIELDERROR("Posting Date",Text001);

        IF ("Document Date" <> 0D) THEN
          IF ("Document Date" <> NORMALDATE("Document Date"))
          THEN
            FIELDERROR("Document Date",Text000);
      // Comprobamos que algunos campos est�n rellenos

        TESTFIELD(PElementJournalLine."Contract No.");
        TESTFIELD(PElementJournalLine."Customer No.");
        TESTFIELD(PElementJournalLine."Job No.");
        TESTFIELD("Document No.");
        TESTFIELD(Quantity);
        TESTFIELD("Unit of Measure");
        TESTFIELD("Location Code");
        TESTFIELD("Element No.");
        IF PElementJournalLine."Entry Type" = PElementJournalLine."Entry Type"::Return THEN
          PElementJournalLine.TESTFIELD(PElementJournalLine."Applied Entry No.");

        // Si el elemento tiene producto asociado hay que pedir la variante de tipo alquiler
        RentalElements.GET(PElementJournalLine."Element No.");
        IF RentalElements."Related Product" <> '' THEN BEGIN
         PElementJournalLine.TESTFIELD(PElementJournalLine."Variante Code");
        // si se est� liquidado se controla la cantidad
        Pending(PElementJournalLine."Applied Entry No.",PElementJournalLine.Quantity);

        END;

        IF NOT DimensionManagement.CheckDimIDComb("Dimensions Set ID") THEN
          ERROR(
            Text011,
            TABLECAPTION,"Journal Template Name","Journal Batch Name","Line No.",
            DimensionManagement.GetDimCombErr);

        IF NOT DimensionManagement.CheckDimValuePosting(TableID,No,"Dimensions Set ID") THEN
          IF "Line No." <> 0 THEN
            ERROR(
              Text012,
              TABLECAPTION,"Journal Template Name","Journal Batch Name","Line No.",
              DimensionManagement.GetDimValuePostingErr)
          ELSE
            ERROR(DimensionManagement.GetDimValuePostingErr);
      END;
    END;

    PROCEDURE DateNotAllowed(PostingDate : Date) : Boolean;
    BEGIN
      IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
        IF USERID <> '' THEN
          IF UserSetup.GET(USERID) THEN BEGIN
            AllowPostingFrom := UserSetup."Allow Posting From";
            AllowPostingTo := UserSetup."Allow Posting To";
          END;
        IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
          GeneralLedgerSetup.GET;
          AllowPostingFrom := GeneralLedgerSetup."Allow Posting From";
          AllowPostingTo := GeneralLedgerSetup."Allow Posting To";
        END;
        IF AllowPostingTo = 0D THEN
          AllowPostingTo := 19991231D;
      END;
      EXIT((PostingDate < AllowPostingFrom) OR (PostingDate > AllowPostingTo));
    END;

    PROCEDURE Pending(PEntry : Integer;PQuantity : Decimal);
    VAR
      RentalElementsEntries : Record 7207345;
      Loctexto7021503 : TextConst ESP='La cantidad a manipular no puede ser superior a la cantidad pendiente %1';
    BEGIN
      IF PEntry = 0 THEN
        EXIT;

      RentalElementsEntries.GET(PEntry);
      RentalElementsEntries.CALCFIELDS(RentalElementsEntries."Return Quantity");
      IF PQuantity > (RentalElementsEntries.Quantity-RentalElementsEntries."Return Quantity") THEN
        ERROR(Loctexto7021503,RentalElementsEntries.Quantity-RentalElementsEntries."Return Quantity");
    END;

    PROCEDURE ErrorIfPositiveAmt(GenJournalLine : Record 81);
    BEGIN
      IF GenJournalLine.Amount > 0 THEN
        GenJournalLine.FIELDERROR(Amount,Text008);
    END;

    PROCEDURE ErrorIfNegativeAmt(GenJournalLine : Record 81);
    BEGIN
      IF GenJournalLine.Amount < 0 THEN
        GenJournalLine.FIELDERROR(Amount,Text007);
    END;

    /* /*BEGIN
END.*/
}







