Codeunit 7207340 "Initialize redetermination"
{
  
  
    TableNo=7207437;
    trigger OnRun()
VAR
            DataPieceworkForProduction : Record 7207386;
            CertUnitRedetermination : Record 7207438;
            CertUnitLastRedetermination : Record 7207438;
            Job : Record 167;
            Currency : Record 4;
            DayWindow : Dialog;
          BEGIN
            DayWindow.OPEN(Text001);
            rec.TESTFIELD("Aplication Date");
            rec.TESTFIELD(Validated,FALSE);
            Job.GET(rec."Job No.");
            CLEAR(Currency);
            IF Job."Currency Code" <> '' THEN
              Currency.GET(Job."Currency Code");
            Currency.InitRoundingPrecision;

            rec.LoadUnitCertification;
            DataPieceworkForProduction.SETRANGE("Job No.",rec."Job No.");
            DataPieceworkForProduction.SETRANGE("Customer Certification Unit",TRUE);
            IF DataPieceworkForProduction.FINDSET THEN
              REPEAT
                DayWindow.UPDATE(1,DataPieceworkForProduction."Piecework Code");
                CertUnitRedetermination.GET(rec."Job No.",rec.Code,DataPieceworkForProduction."Piecework Code");
                IF DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit THEN BEGIN
                  DataPieceworkForProduction.SETRANGE("Filter Date",0D,rec."Aplication Date"-1);
                  DataPieceworkForProduction.CALCFIELDS("Certified Quantity");
                  CertUnitRedetermination."Previous certified Quantity" := DataPieceworkForProduction."Certified Quantity";
                  DataPieceworkForProduction.SETRANGE("Filter Date");
                  DataPieceworkForProduction.CALCFIELDS("Certified Quantity","Certified Amount");
                  CertUnitRedetermination."Certified Quantity to Adjust" := DataPieceworkForProduction."Certified Quantity" - CertUnitRedetermination."Previous certified Quantity";
                  CertUnitRedetermination."Outstading Quantity to Cert." := DataPieceworkForProduction."Sale Quantity (base)" - DataPieceworkForProduction."Certified Quantity";

                  IF Job."Last Redetermination" = '' THEN
                    CertUnitRedetermination."Previous Unit Price" := DataPieceworkForProduction."Unit Price Sale (base)"
                  ELSE BEGIN
                    CertUnitLastRedetermination.GET(rec."Job No.",Job."Last Redetermination",DataPieceworkForProduction."Piecework Code");
                    CertUnitRedetermination."Previous Unit Price" := CertUnitLastRedetermination."Unit Price Redetermined";
                  END;
                  CertUnitRedetermination."Unit Price Redetermined" := ROUND(CertUnitRedetermination."Previous Unit Price" *
                                                                             CertUnitRedetermination."Factor applied",
                                                                             Currency."Unit-Amount Rounding Precision");
                  CertUnitRedetermination."Unit Increase" := CertUnitRedetermination."Unit Price Redetermined" -
                                                             CertUnitRedetermination."Previous Unit Price";
                  CertUnitRedetermination."Amount Executed" := DataPieceworkForProduction."Certified Amount";
                  CertUnitRedetermination."Amount Pending Execution" :=
                                ROUND(CertUnitRedetermination."Outstading Quantity to Cert." *
                                      CertUnitRedetermination."Unit Price Redetermined",
                                      Currency."Amount Rounding Precision");

                  CertUnitRedetermination."Amount Sales Increase" :=
                                ROUND(CertUnitRedetermination."Outstading Quantity to Cert." *
                                      CertUnitRedetermination."Unit Increase",
                                      Currency."Amount Rounding Precision");
                  CertUnitRedetermination."Last Sales Amount" := DataPieceworkForProduction."Sale Amount";
                  CertUnitRedetermination."Amount to Adjust" := ROUND(CertUnitRedetermination."Certified Quantity to Adjust" *
                                                                CertUnitRedetermination."Unit Increase",
                                                                Currency."Amount Rounding Precision");
                  CertUnitRedetermination."New Sales Amount" := CertUnitRedetermination."Last Sales Amount" +
                                                                CertUnitRedetermination."Amount Sales Increase";
                  CertUnitRedetermination.MODIFY;
                END ELSE BEGIN
                  CertUnitRedetermination."Previous certified Quantity" := 0;
                  CertUnitRedetermination."Certified Quantity to Adjust" := 0;
                  CertUnitRedetermination."Outstading Quantity to Cert." := 0;
                  CertUnitRedetermination."Previous Unit Price" := 0;
                  CertUnitRedetermination."Unit Price Redetermined" := 0;
                  CertUnitRedetermination."Unit Increase" := 0;
                  CertUnitRedetermination."Amount Executed" := 0;
                  CertUnitRedetermination."Amount Pending Execution" := 0;
                  CertUnitRedetermination."Amount Sales Increase" := 0;
                  CertUnitRedetermination."Last Sales Amount" := 0;
                  CertUnitRedetermination."New Sales Amount" := 0;
                  CertUnitRedetermination."Amount to Adjust" := 0;
                  CertUnitRedetermination.MODIFY;
                END;
              UNTIL DataPieceworkForProduction.NEXT = 0;
          END;
    VAR
      Text001 : TextConst ENU='Initialize unit: #1###################',ESP='Inicialiazando unidad: #1###################';

    PROCEDURE ActRedeterminations(DataPieceworkForProduction : Record 7207386);
    VAR
      Jobredetermination : Record 7207437;
      Job : Record 167;
      Currency : Record 4;
      CertUnitRedetermination : Record 7207438;
      CertUnitLastRedetermination : Record 7207438;
    BEGIN
      //JAV 23/08/19: - Si lo acaban de borrar da un error, me lo salto
      //Job.GET(DataPieceworkForProduction."Job No.");
      IF (NOT Job.GET(DataPieceworkForProduction."Job No.")) THEN
        EXIT;
      //JAV fin

      CLEAR(Currency);
      IF Job."Currency Code" <> '' THEN
        Currency.GET(Job."Currency Code");
      Currency.InitRoundingPrecision;

      Jobredetermination.SETRANGE("Job No.",DataPieceworkForProduction."Job No.");
      Jobredetermination.SETRANGE(Validated,FALSE);
      IF Jobredetermination.FINDSET THEN
        REPEAT
          IF CertUnitRedetermination.GET(DataPieceworkForProduction."Job No.",
                                         Jobredetermination.Code,
                                         DataPieceworkForProduction."Piecework Code") THEN BEGIN
            IF DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit THEN BEGIN
              DataPieceworkForProduction.SETRANGE("Filter Date",0D,Jobredetermination."Aplication Date"-1);
              DataPieceworkForProduction.CALCFIELDS("Certified Quantity");
              CertUnitRedetermination."Previous certified Quantity" := DataPieceworkForProduction."Certified Quantity";
              DataPieceworkForProduction.SETRANGE("Filter Date");
              DataPieceworkForProduction.CALCFIELDS("Certified Quantity","Certified Amount");
              CertUnitRedetermination."Certified Quantity to Adjust" := DataPieceworkForProduction."Certified Quantity" -
                                                                        CertUnitRedetermination."Previous certified Quantity";
              CertUnitRedetermination."Outstading Quantity to Cert." := DataPieceworkForProduction."Sale Quantity (base)" -
                                                                        DataPieceworkForProduction."Certified Quantity";
      // Si hay redeterminaciones previas no se como hacerlo aun
              IF Job."Last Redetermination" = '' THEN
                CertUnitRedetermination."Previous Unit Price" := DataPieceworkForProduction."Unit Price Sale (base)";

              CertUnitRedetermination."Unit Price Redetermined" := ROUND(CertUnitRedetermination."Previous Unit Price" *
                                                                         CertUnitRedetermination."Factor applied",
                                                                         Currency."Unit-Amount Rounding Precision");
              CertUnitRedetermination."Unit Increase" := CertUnitRedetermination."Unit Price Redetermined" -
                                                         CertUnitRedetermination."Previous Unit Price";
              CertUnitRedetermination."Amount Executed" := DataPieceworkForProduction."Certified Amount";
              CertUnitRedetermination."Amount Pending Execution" :=
                          ROUND(CertUnitRedetermination."Outstading Quantity to Cert." *
                                CertUnitRedetermination."Unit Price Redetermined",
                                Currency."Amount Rounding Precision");

              CertUnitRedetermination."Amount Sales Increase" :=
                          ROUND(CertUnitRedetermination."Outstading Quantity to Cert." *
                                CertUnitRedetermination."Unit Increase",
                                Currency."Amount Rounding Precision") +
                          ROUND(CertUnitRedetermination."Certified Quantity to Adjust" *
                                CertUnitRedetermination."Unit Increase",
                                Currency."Amount Rounding Precision");

              CertUnitRedetermination."Last Sales Amount" := DataPieceworkForProduction."Sale Amount";
              CertUnitRedetermination."Amount to Adjust" := ROUND(CertUnitRedetermination."Certified Quantity to Adjust" *
                                                                  CertUnitRedetermination."Unit Increase",
                                                                  Currency."Amount Rounding Precision");
              CertUnitRedetermination."New Sales Amount" := CertUnitRedetermination."Last Sales Amount" +
                                                            CertUnitRedetermination."Amount Sales Increase";
                CertUnitRedetermination.MODIFY;
              END;
            END;
          UNTIL CertUnitRedetermination.NEXT = 0;
    END;

    /*BEGIN
/*{
      JAV 23/08/19: - Si lo acaban de borrar da un error, me lo salto
    }
END.*/
}







