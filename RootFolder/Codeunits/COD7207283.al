Codeunit 7207283 "Bring Posted Measurements"
{
  
  
    TableNo=7207337;
    Permissions=TableData 7207338=r;
    trigger OnRun()
VAR
            PageBringPostedMeasure : Page 7207369;
          BEGIN
          END;

    PROCEDURE GetMeditions(pDocNo : Code[20];pJob : Code[20];pCustomer : Code[20]);
    VAR
      MeasurementHeader : Record 7207336;
      MeasurementLines : Record 7207337;
      HistMeasurements : Record 7207338;
      MeasurePostList : Page 7207308;
    BEGIN
      //Traer una medici�n a la certificaci�n
      MeasurementLines.RESET;
      MeasurementLines.SETRANGE("Document No.", pDocNo);
      IF (NOT MeasurementLines.ISEMPTY) THEN
        IF (CONFIRM('La certificaci�n ya tiene l�neas, �desea eliminarlas antes de cargar una nueva medici�n?', TRUE)) THEN BEGIN
          MeasurementLines.DELETEALL;
          COMMIT;
        END;

      HistMeasurements.RESET;
      HistMeasurements.SETRANGE("Job No.", pJob);
      HistMeasurements.SETRANGE("Customer No.", pCustomer);
      HistMeasurements.SETRANGE("Certification Completed", FALSE);
      HistMeasurements.SETFILTER("Cancel By", '=%1', '');
      HistMeasurements.SETFILTER("Cancel No.", '=%1', '');

      CLEAR(MeasurePostList);
      MeasurePostList.SETTABLEVIEW(HistMeasurements);
      MeasurePostList.LOOKUPMODE(TRUE);
      IF (MeasurePostList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
        MeasurePostList.GETRECORD(HistMeasurements);
        MeasurePostList.SETSELECTIONFILTER(HistMeasurements);
        //-Q19892
        //IF (HistMeasurements.FINDSET(FALSE)) THEN
        IF (HistMeasurements.FINDSET(FALSE)) THEN BEGIN
         MeasurementHeader.GET(pDocNo);
         MeasurementHeader."Cert Measurement Date" := HistMeasurements."Posting Date";
         IF MeasurementHeader."Posting Date" < MeasurementHeader."Cert Measurement Date" THEN MeasurementHeader."Posting Date" := MeasurementHeader."Cert Measurement Date";
         IF MeasurementHeader."Certification Date" < MeasurementHeader."Cert Measurement Date" THEN MeasurementHeader."Certification Date" := MeasurementHeader."Cert Measurement Date";
         MeasurementHeader.MODIFY;
        //+Q19892
          REPEAT
            CreateLines(pDocNo, HistMeasurements);
            //-Q19892
            MeasurementHeader.GET(pDocNo);
            IF MeasurementHeader."Cert Measurement Date" > HistMeasurements."Posting Date" THEN  MeasurementHeader."Cert Measurement Date" := HistMeasurements."Posting Date";  //Recojo la fecha menor.
            IF MeasurementHeader."Posting Date" < MeasurementHeader."Cert Measurement Date" THEN MeasurementHeader."Posting Date" := MeasurementHeader."Cert Measurement Date";
            IF MeasurementHeader."Certification Date" < MeasurementHeader."Cert Measurement Date" THEN MeasurementHeader."Certification Date" := MeasurementHeader."Cert Measurement Date";
            MeasurementHeader.MODIFY;
            //-Q19892
          UNTIL (HistMeasurements.NEXT = 0);
        //-Q19892
        END;
        //+Q19892
      END;

      MeasurementHeader.GET(pDocNo);
      MeasurementHeader.CalculateTotals;
    END;

    PROCEDURE CreateLines(pDocNo : Code[20];HistMeasurements : Record 7207338);
    VAR
      HistMeasureLines : Record 7207339;
      MeasurementLines : Record 7207337;
      NextLineNo : Integer;
    BEGIN
      //Traer las l�neas de una medici�n a las de una certificaci�n
      MeasurementLines.RESET;
      MeasurementLines.SETRANGE("Document No.", pDocNo);
      IF MeasurementLines.FINDLAST THEN
        NextLineNo := MeasurementLines."Line No."
      ELSE
        NextLineNo := 0;


      NextLineNo += 10000;
      MeasurementLines.INIT;
      MeasurementLines."Document No." := pDocNo;
      MeasurementLines."Line No." := NextLineNo;
      MeasurementLines."Document type" := MeasurementLines."Document type"::Certification;
      MeasurementLines.Description := HistMeasurements."Text Measure" + ' (Doc: Option "+ HistMeasurements."No." +")';
      MeasurementLines.INSERT;


      HistMeasureLines.RESET;
      HistMeasureLines.SETRANGE("Document No.", HistMeasurements."No.");
      IF HistMeasureLines.FINDSET(FALSE) THEN
        REPEAT
          NextLineNo += 10000;
          MeasurementLines.INIT;
          MeasurementLines."Document No." := pDocNo;
          MeasurementLines."Line No." := NextLineNo;
          MeasurementLines."Document type" := MeasurementLines."Document type"::Certification;
          MeasurementLines.VALIDATE("Job No.", HistMeasurements."Job No.");
          MeasurementLines.VALIDATE("Piecework No.",HistMeasureLines."Piecework No.");
          MeasurementLines.Description:= HistMeasureLines.Description;
          MeasurementLines."Med. Measured Quantity" := HistMeasureLines."Med. Term Measure";

          //JAV 18/03/21: - QB 1.08.24 Pasamos datos a los nuevos campos de certificaci�n
          MeasurementLines."Cert Medition No." := HistMeasureLines."Document No.";
          MeasurementLines."Cert Medition Line No." := HistMeasureLines."Line No.";
          MeasurementLines."Cert Pend. Medition Term" := HistMeasureLines."Quantity Measure Not Cert";
          MeasurementLines."Cert Pend. Medition Origin" := HistMeasureLines."Med. Source Measure";

          //JAV 28/09/21: - QB 1.09.20 Precios con sus Nuevos campos
          MeasurementLines."Sales Price" := HistMeasureLines."Sale Price";          //No se estaba pasando ++
          MeasurementLines."Contract Price" := HistMeasureLines."Contract Price";
          MeasurementLines."Term PEC Price" := HistMeasureLines."Term PEC Price";
          MeasurementLines."Term PEM Price" := HistMeasureLines."Term PEM Price";

          //JAV 01/10/21: - QB 1.09.20 Informo estos campos para tener las referencia de la medici�n original cuando el precio es cero pero tienen importe
          MeasurementLines."Med. Term PEM Amount"   := HistMeasureLines."Med. Term Amount";
          MeasurementLines."Med. Term PEC Amount"   := HistMeasureLines."Med. Term Amount";
          MeasurementLines."Med. Source PEM Amount" := HistMeasureLines."Med. Source Amount PEM";
          MeasurementLines."Med. Source PEC Amount" := HistMeasureLines."Med. Source Amount PEM";


          MeasurementLines.VALIDATE("Cert % to Certificate", 100);

          //JAV 22/06/22: - QB 1.10.52 Se recalculan estos importes a PEC porque dan problemas
          MeasurementLines."Cert Term PEC amount"   := ROUND(MeasurementLines."Cert Quantity to Term"   * MeasurementLines."Contract Price", 0.01);
          MeasurementLines."Cert Source PEC amount" := ROUND(MeasurementLines."Cert Quantity to Origin" * MeasurementLines."Contract Price", 0.01);

          MeasurementLines.INSERT;
        UNTIL HistMeasureLines.NEXT = 0;
    END;

    /*BEGIN
/*{
      JAV 22/06/22: - QB 1.10.52 Se recalculan estos importes a PEC porque dan problemas
      AML 23/08/23: - Q19892 Recoger la fecha de la medicion
    }
END.*/
}







