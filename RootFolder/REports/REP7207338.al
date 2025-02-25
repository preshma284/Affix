report 7207338 "Generate Document Retreat"
{
  
  
    CaptionML=ENU='Generate Document Retreat',ESP='Generar documento retiradad';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Element Contract Header";"Element Contract Header")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.";
DataItem("Element Contract Lines";"Element Contract Lines")
{

               DataItemTableView=SORTING("Document No.","Line No.")
                                 WHERE("Retreat Quantity"=FILTER(<>0));
DataItemLink="Document No."= FIELD("No.") ;
trigger OnAfterGetRecord();
    BEGIN 
                                  Job.GET("Element Contract Lines"."Job No.");
                                  IF Job."Mandatory Allocation Term By" = Job."Mandatory Allocation Term By"::"AT Any Level" THEN BEGIN 
                                    TESTFIELD("Element Contract Lines"."Piecework Code");
                                  END;
                                  IF Job."Mandatory Allocation Term By" = Job."Mandatory Allocation Term By"::"Only Per Piecework" THEN BEGIN 
                                    TESTFIELD("Element Contract Lines"."Piecework Code");
                                    DataPieceworkForProduction.GET("Element Contract Lines"."Job No.","Element Contract Lines"."Piecework Code");
                                    IF DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading THEN
                                      ERROR(Text001);
                                  END;

                                  IF "Element Contract Lines"."Retreat Date" = 0D THEN
                                    CurrReport.SKIP;

                                  IF VCreateHeader THEN
                                    CretaeHeader("Element Contract Header");
                                  CreateLine("Element Contract Lines");

                                  ElementContractLines := "Element Contract Lines";
                                  ElementContractLines."Retreat Quantity" := 0;
                                  ElementContractLines."Retreat Date" := 0D;
                                  ElementContractLines.MODIFY;
                                END;


}
trigger OnPreDataItem();
    BEGIN 
                               LastFieldNo := FIELDNO("No.");
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  VCreateHeader := TRUE;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                RecordDeliveryReturnElement.RUN(HeaderDeliveryReturnElement);
                              END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
}
  
    var
//       HeaderDeliveryReturnElement@7001100 :
      HeaderDeliveryReturnElement: Record 7207356;
//       VCreateHeader@7001101 :
      VCreateHeader: Boolean;
//       RentalElementsEntries@7001102 :
      RentalElementsEntries: Record 7207345;
//       LineDeliveryReturnElement@7001103 :
      LineDeliveryReturnElement: Record 7207357;
//       LastFieldNo@7001104 :
      LastFieldNo: Integer;
//       RecordDeliveryReturnElement@7001105 :
      RecordDeliveryReturnElement: Codeunit 7207312;
//       Job@7001106 :
      Job: Record 167;
//       DataPieceworkForProduction@7001107 :
      DataPieceworkForProduction: Record 7207386;
//       Text001@7001108 :
      Text001: TextConst ENU='You can only assign lower-level piecework/Cost units',ESP='Solo es posible imputar a unidades de Obra/Coste de nivel inferior';
//       ElementContractLines@7001109 :
      ElementContractLines: Record 7207354;

//     procedure CretaeHeader (PElementContractHeader@1100251000 :
    procedure CretaeHeader (PElementContractHeader: Record 7207353)
    begin
      HeaderDeliveryReturnElement.INIT;
      HeaderDeliveryReturnElement."Document Type" := HeaderDeliveryReturnElement."Document Type"::Return;
      HeaderDeliveryReturnElement."No." := '';
      HeaderDeliveryReturnElement.INSERT(TRUE);
      HeaderDeliveryReturnElement."Customer/Vendor No.":="Element Contract Header"."Customer/Vendor No.";
      HeaderDeliveryReturnElement."Job No.":="Element Contract Header"."Job No.";
      HeaderDeliveryReturnElement.VALIDATE("Contract Code",PElementContractHeader."No.");
      HeaderDeliveryReturnElement.Description := PElementContractHeader.Description;
      HeaderDeliveryReturnElement."Description 2" := PElementContractHeader."Description 2";
      HeaderDeliveryReturnElement."Document Type" := HeaderDeliveryReturnElement."Document Type"::Return;
      HeaderDeliveryReturnElement."Order Date" := PElementContractHeader."Posting Date";
      HeaderDeliveryReturnElement."Posting Date" := PElementContractHeader."Posting Date";
      HeaderDeliveryReturnElement."Contract Type" :=PElementContractHeader."Contract Type";
      HeaderDeliveryReturnElement.VALIDATE("Shortcut Dimension 1 Code",PElementContractHeader."Shortcut Dimension 1 Code");
      HeaderDeliveryReturnElement.VALIDATE("Shortcut Dimension 2 Code",PElementContractHeader."Shortcut Dimension 2 Code");
      HeaderDeliveryReturnElement.MODIFY(TRUE);
      VCreateHeader := FALSE;
    end;

//     procedure CreateLine (PElementContractLines@1100251000 :
    procedure CreateLine (PElementContractLines: Record 7207354)
    var
//       VLineDeliveryReturnElement@1100251001 :
      VLineDeliveryReturnElement: Record 7207357;
//       VLine@1100251002 :
      VLine: Integer;
//       AmountPendingtoReturn@1100000 :
      AmountPendingtoReturn: Decimal;
    begin
      AmountPendingtoReturn := PElementContractLines."Retreat Quantity";

      RentalElementsEntries.SETCURRENTKEY("Contract No.","Entry Type","Element No.","Job No.",
                                   "Variant Code","Location code","Piecework Code");
      RentalElementsEntries.SETRANGE("Contract No.",PElementContractLines."Contract Code");
      RentalElementsEntries.SETRANGE("Entry Type",RentalElementsEntries."Entry Type"::Delivery);
      RentalElementsEntries.SETRANGE("Element No.",PElementContractLines."No.");
      RentalElementsEntries.SETFILTER("Rent effective Date",'<=%1',PElementContractLines."Retreat Date");
      RentalElementsEntries.SETRANGE(Pending,TRUE);
      RentalElementsEntries.SETRANGE("Job No.",PElementContractLines."Job No.");
      RentalElementsEntries.SETRANGE("Piecework Code",PElementContractLines."Piecework Code");
      RentalElementsEntries.SETRANGE("Location code",PElementContractLines."Location Code");
      RentalElementsEntries.SETRANGE("Variant Code",PElementContractLines."Variant Code");
      if not RentalElementsEntries.FINDSET then
        exit
      else begin
        VLineDeliveryReturnElement.SETRANGE("Document No.",LineDeliveryReturnElement."Document No.");
        if VLineDeliveryReturnElement.FINDLAST then
          VLine := VLineDeliveryReturnElement."Line No."
        else
          VLine := 0;

        repeat
          RentalElementsEntries.CALCFIELDS("Return Quantity");
          if (RentalElementsEntries.Quantity - RentalElementsEntries."Return Quantity") >= AmountPendingtoReturn then begin
            LineDeliveryReturnElement.INIT;
            LineDeliveryReturnElement."Document No.":= HeaderDeliveryReturnElement."No.";
            LineDeliveryReturnElement."Contract Code" := HeaderDeliveryReturnElement."Contract Code";
            VLine := VLine + 10000;
            LineDeliveryReturnElement."Line No." := VLine;
            LineDeliveryReturnElement.VALIDATE("No.",PElementContractLines."No.");
            LineDeliveryReturnElement.VALIDATE("Location Code",PElementContractLines."Location Code");
            LineDeliveryReturnElement.VALIDATE("Unit of Measure",PElementContractLines."Unit of Measure");
            LineDeliveryReturnElement.VALIDATE("Variant Code",PElementContractLines."Variant Code");
            LineDeliveryReturnElement.VALIDATE(Quantity,PElementContractLines."Quantity to Send");
            LineDeliveryReturnElement.VALIDATE("Shortcut Dimensios 1 Code",PElementContractLines."Shortcut Dimension 1 Code");
            LineDeliveryReturnElement.VALIDATE("Shortcut Dimension 2 Code",PElementContractLines."Shortcut Dimension 2 Code");
            LineDeliveryReturnElement.VALIDATE("Amount to Manipulate",AmountPendingtoReturn);
            LineDeliveryReturnElement.VALIDATE(LineDeliveryReturnElement."Unit Price",PElementContractLines."Rent Price");
            LineDeliveryReturnElement."Job No." := PElementContractLines."Job No.";
            LineDeliveryReturnElement."Piecework Code" := PElementContractLines."Piecework Code";
            LineDeliveryReturnElement."Rent Effective Date" := PElementContractLines."Retreat Date";
            LineDeliveryReturnElement."Applicated Entry No." := RentalElementsEntries."Entry No.";
            LineDeliveryReturnElement.INSERT;
            AmountPendingtoReturn := 0;
          end else begin
            LineDeliveryReturnElement.INIT;
            LineDeliveryReturnElement."Document No.":= HeaderDeliveryReturnElement."No.";
            LineDeliveryReturnElement."Contract Code" := HeaderDeliveryReturnElement."Contract Code";
            VLine := VLine + 10000;
            LineDeliveryReturnElement."Line No." := VLine;
            LineDeliveryReturnElement.VALIDATE("No.",PElementContractLines."No.");
            LineDeliveryReturnElement.VALIDATE("Location Code",PElementContractLines."Location Code");
            LineDeliveryReturnElement.VALIDATE("Unit of Measure",PElementContractLines."Unit of Measure");
            LineDeliveryReturnElement.VALIDATE("Variant Code",PElementContractLines."Variant Code");
            LineDeliveryReturnElement.VALIDATE(Quantity,RentalElementsEntries.Quantity - RentalElementsEntries."Return Quantity");
            LineDeliveryReturnElement.VALIDATE("Shortcut Dimensios 1 Code",PElementContractLines."Shortcut Dimension 1 Code");
            LineDeliveryReturnElement.VALIDATE("Shortcut Dimension 2 Code",PElementContractLines."Shortcut Dimension 2 Code");
            LineDeliveryReturnElement.VALIDATE("Amount to Manipulate",RentalElementsEntries.Quantity - RentalElementsEntries."Return Quantity");
            LineDeliveryReturnElement.VALIDATE(LineDeliveryReturnElement."Unit Price",PElementContractLines."Rent Price");
            LineDeliveryReturnElement."Job No." := PElementContractLines."Job No.";
            LineDeliveryReturnElement."Piecework Code" := PElementContractLines."Piecework Code";
            LineDeliveryReturnElement."Rent Effective Date" := PElementContractLines."Retreat Date";
            LineDeliveryReturnElement."Applicated Entry No." := RentalElementsEntries."Entry No.";
            LineDeliveryReturnElement.INSERT;
            AmountPendingtoReturn := AmountPendingtoReturn - (RentalElementsEntries.Quantity - RentalElementsEntries."Return Quantity");
          end;
        until (RentalElementsEntries.NEXT = 0) or (AmountPendingtoReturn = 0);
      end;
    end;

    /*begin
    end.
  */
  
}



