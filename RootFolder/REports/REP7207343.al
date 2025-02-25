report 7207343 "Set Target Prices"
{
  
  
    CaptionML=ENU='Set Target Prices',ESP='Fijar Precios Objetivos';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Purchase Journal Line";"Purchase Journal Line")
{

               DataItemTableView=SORTING("Job No.","Line No.")
                                 WHERE("Line No."=FILTER(<>0));
               

               RequestFilterFields="Activity Code","Type","No.";
trigger OnPreDataItem();
    BEGIN 
                               IF (TargetPrice = 0) AND (DecreaseFactor = 0)  THEN
                                 ERROR(Text001);

                               Window.OPEN(Text002);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  PurchaseJournalLine.RESET;
                                  PurchaseJournalLine.SETRANGE("Job No.","Job No.");
                                  PurchaseJournalLine.SETFILTER(Type,'%1',Type);
                                  PurchaseJournalLine.SETRANGE("No.","No.");
                                  IF PurchaseJournalLine.FINDSET THEN
                                    REPEAT
                                      IF TargetPrice <> 0 THEN
                                        PurchaseJournalLine.VALIDATE("Target Price", TargetPrice)
                                      ELSE
                                        PurchaseJournalLine.VALIDATE("Target Price", PurchaseJournalLine."Estimated Price" * DecreaseFactor);

                                      PurchaseJournalLine.MODIFY(TRUE);
                                    UNTIL PurchaseJournalLine.NEXT = 0;
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group555")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("TargetPrice";"TargetPrice")
    {
        
                  CaptionML=ENU='Target Price',ESP='Precio objetivo';
                  
                              ;trigger OnValidate()    BEGIN
                               IF DecreaseFactor <> 0 THEN
                                 DecreaseFactor := 0;
                             END;


    }
    field("DecreaseFactor";"DecreaseFactor")
    {
        
                  CaptionML=ENU='Decrease Factor',ESP='k';
                  
                              

    ;trigger OnValidate()    BEGIN
                               IF TargetPrice <> 0 THEN
                                 TargetPrice := 0;
                             END;


    }

}

}
}
  }
  labels
{
}
  
    var
//       PurchaseJournalLine@7001105 :
      PurchaseJournalLine: Record 7207281;
//       TargetPrice@7001101 :
      TargetPrice: Decimal;
//       DecreaseFactor@7001100 :
      DecreaseFactor: Decimal;
//       Text001@7001103 :
      Text001: TextConst ENU='if you are going to execute this process set a price or assign a % increase to calculate the Target Amount',ESP='Si va a ejecutar este proceso fije un precio o asigne un % para calcular el Imp.Objetivo';
//       Text002@7001102 :
      Text002: TextConst ENU='Running process',ESP='Ejecutando proceso';
//       Window@7001104 :
      Window: Dialog;

    /*begin
    end.
  */
  
}



