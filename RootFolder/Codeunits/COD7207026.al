Codeunit 7207026 "QB Customizations"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      FunctionQB : Codeunit 7207272;

    [EventSubscriber(ObjectType::Codeunit, 7206913, OnAfterReleaseDocument, '', true, true)]
    LOCAL PROCEDURE INESCO_OnBeforePerformManualRelease(VAR Rec : Record 38);
    VAR
      PurchSetup : Record 312;
      NoSeriesMgt : Codeunit 396;
    BEGIN
      // Q7420 INESCO (EPV) 21/02/22 Asignar n� registro al lanzar
      IF (FunctionQB.IsClient('INE')) THEN BEGIN
        IF Rec."Posting No." = '' THEN BEGIN
          IF Rec."Posting No. Series" <> '' THEN BEGIN
            PurchSetup.GET;
            NoSeriesMgt.SetDefaultSeries(Rec."Posting No. Series",PurchSetup."Posted Invoice Nos.");
          END;
          Rec."Posting No." := NoSeriesMgt.GetNextNo(Rec."Posting No. Series",Rec."Posting Date",TRUE);
          Rec.MODIFY(TRUE);
        END;
      END;
    END;

    /*BEGIN
/*{
      JAV 04/03/22: - QB 1.10.23 En esta CU se crean las funciones que sean propias de los clientes

      Q7420 INESCO (EPV) 21/02/22 Asignar n� registro al lanzar
    }
END.*/
}









