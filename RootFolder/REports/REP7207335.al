report 7207335 "Generate Shipping Document"
{
  
  
    CaptionML=ENU='Generate Shipping Document',ESP='Generar documento de env¡o';
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
                                 WHERE("Quantity to Send"=FILTER(<>0));
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

                                  IF "Element Contract Lines"."Send Date" = 0D THEN
                                    CurrReport.SKIP;

                                  IF VCreateHeader THEN
                                    CreateHeader("Element Contract Header");
                                  CreateLine("Element Contract Lines");

                                  ElementContractLines := "Element Contract Lines";
                                  ElementContractLines."Quantity to Send" := 0;
                                  ElementContractLines."Send Date" := 0D;
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
//       LineDeliveryReturnElement@7001102 :
      LineDeliveryReturnElement: Record 7207357;
//       LastFieldNo@7001103 :
      LastFieldNo: Integer;
//       RecordDeliveryReturnElement@7001104 :
      RecordDeliveryReturnElement: Codeunit 7207312;
//       Job@7001105 :
      Job: Record 167;
//       DataPieceworkForProduction@7001106 :
      DataPieceworkForProduction: Record 7207386;
//       Text001@7001107 :
      Text001: TextConst ENU='It is only possible to allocate piecework/cost of the lowest level',ESP='Solo es posible imputar a unidades de obra/coste del nivel mas bajo';
//       ElementContractLines@7001108 :
      ElementContractLines: Record 7207354;

//     procedure CreateHeader (ElementContractHeader@1100251000 :
    procedure CreateHeader (ElementContractHeader: Record 7207353)
    begin
      HeaderDeliveryReturnElement.INIT;
      HeaderDeliveryReturnElement."No." := '';
      HeaderDeliveryReturnElement.INSERT(TRUE);
      HeaderDeliveryReturnElement."Customer/Vendor No.":= "Element Contract Header"."Customer/Vendor No.";
      HeaderDeliveryReturnElement."Job No.":="Element Contract Header"."Job No.";
      HeaderDeliveryReturnElement.VALIDATE("Contract Code",ElementContractHeader."No.");
      HeaderDeliveryReturnElement.Description := ElementContractHeader.Description;
      HeaderDeliveryReturnElement."Description 2" := ElementContractHeader."Description 2";
      HeaderDeliveryReturnElement."Document Type" := HeaderDeliveryReturnElement."Document Type"::Delivery;
      HeaderDeliveryReturnElement."Order Date" := ElementContractHeader."Posting Date";
      HeaderDeliveryReturnElement."Posting Date" := ElementContractHeader."Posting Date";
      HeaderDeliveryReturnElement."Contract Type":=ElementContractHeader."Contract Type";
      HeaderDeliveryReturnElement.VALIDATE("Shortcut Dimension 1 Code",ElementContractHeader."Shortcut Dimension 1 Code");
      HeaderDeliveryReturnElement.VALIDATE("Shortcut Dimension 2 Code",ElementContractHeader."Shortcut Dimension 2 Code");
      HeaderDeliveryReturnElement.MODIFY(TRUE);
      VCreateHeader := FALSE;
    end;

//     procedure CreateLine (ElementContractLines@1100251000 :
    procedure CreateLine (ElementContractLines: Record 7207354)
    var
//       VLineDeliveryReturnElement@1100251001 :
      VLineDeliveryReturnElement: Record 7207357;
//       VLine@1100251002 :
      VLine: Integer;
    begin
      LineDeliveryReturnElement.INIT;
      LineDeliveryReturnElement."Document No.":= HeaderDeliveryReturnElement."No.";
      //Busco la l¡nea
      VLineDeliveryReturnElement.SETRANGE("Document No.",LineDeliveryReturnElement."Document No.");
      if VLineDeliveryReturnElement.FINDLAST then
        VLine := VLineDeliveryReturnElement."Line No." + 10000
      else
        VLine := 10000;

      LineDeliveryReturnElement."Contract Code" := HeaderDeliveryReturnElement."Contract Code";
      LineDeliveryReturnElement."Line No." := VLine;
      LineDeliveryReturnElement.VALIDATE("No.",ElementContractLines."No.");
      LineDeliveryReturnElement.VALIDATE("Location Code",ElementContractLines."Location Code");
      LineDeliveryReturnElement.VALIDATE("Unit of Measure",ElementContractLines."Unit of Measure");
      LineDeliveryReturnElement.VALIDATE("Variant Code",ElementContractLines."Variant Code");
      LineDeliveryReturnElement.VALIDATE(Quantity,ElementContractLines."Quantity to Send");
      LineDeliveryReturnElement.VALIDATE("Shortcut Dimensios 1 Code",ElementContractLines."Shortcut Dimension 1 Code");
      LineDeliveryReturnElement.VALIDATE("Shortcut Dimension 2 Code",ElementContractLines."Shortcut Dimension 2 Code");
      LineDeliveryReturnElement.VALIDATE("Amount to Manipulate",ElementContractLines."Quantity to Send");
      LineDeliveryReturnElement.VALIDATE(LineDeliveryReturnElement."Unit Price",ElementContractLines."Rent Price");
      LineDeliveryReturnElement."Job No." := ElementContractLines."Job No.";
      LineDeliveryReturnElement."Piecework Code" := ElementContractLines."Piecework Code";
      LineDeliveryReturnElement."Rent Effective Date" := ElementContractLines."Send Date";
      LineDeliveryReturnElement.INSERT;
    end;

    /*begin
    end.
  */
  
}



