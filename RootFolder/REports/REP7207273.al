report 7207273 "Calculate Job Unit Cost"
{
  
  
    CaptionML=ENU='Calculate Job Unit Cost',ESP='Calcular coste unidad de obra';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Cost Database";"Cost Database")
{

               DataItemTableView=SORTING("Code");
               
                                 ;
trigger OnAfterGetRecord();
    BEGIN 
                                  CalculateCost;
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
//       BillofItemData@7207270 :
      BillofItemData: Record 7207384;
//       Currency@7207271 :
      Currency: Record 4;
//       TCost@7207272 :
      TCost: Decimal;
//       TSale@1100286000 :
      TSale: Decimal;
//       ECost@1100286002 :
      ECost: Boolean;
//       ESale@1100286001 :
      ESale: Boolean;
//       GrossProfit@7207273 :
      GrossProfit: Decimal;

    procedure CalculateCost ()
    var
//       Piecework@1100286003 :
      Piecework: Record 7207277;
//       PieceworkHeading@1100286000 :
      PieceworkHeading: Record 7207277;
//       NewCost@1100286001 :
      NewCost: Decimal;
//       NewSale@1100286002 :
      NewSale: Decimal;
    begin
      //Ajustamos precio de todas las partidas
      Piecework.RESET;
      Piecework.SETRANGE("Cost Database Default", "Cost Database".Code);
      Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
      if Piecework.FINDSET(TRUE,FALSE) then
        repeat
          Piecework.CalculateUnit;

          if Piecework."Proposed Sale Price" <> 0 then
            GrossProfit := ROUND(100 * (1 - Piecework."Price Cost" / Piecework."Proposed Sale Price"),0.00001)
          else
            GrossProfit := 0;

          Piecework.VALIDATE("% Margin");
          Piecework.VALIDATE("Gross Profit Percentage",GrossProfit);
          Piecework.MODIFY;
        until Piecework.NEXT = 0;

      //Ajustamos precio de los cap¡tulos y subcap¡tulos
      PieceworkHeading.RESET;
      PieceworkHeading.SETRANGE("Cost Database Default","Cost Database".Code);
      PieceworkHeading.SETRANGE("Account Type",Piecework."Account Type"::Heading);
      if PieceworkHeading.FINDSET then
        repeat
          NewCost := 0;
          NewSale := 0;

          Piecework.RESET;
          Piecework.SETRANGE("Cost Database Default",PieceworkHeading."Cost Database Default");
          Piecework.SETFILTER("No.",PieceworkHeading.Totaling);
          Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
          if Piecework.FINDSET(TRUE,FALSE) then
            repeat
              NewCost += Piecework."Total Amount Cost";
              NewSale += Piecework."Total Amount Sales";
            until Piecework.NEXT = 0;
          PieceworkHeading.VALIDATE("Price Cost",NewCost);
          PieceworkHeading.VALIDATE("Proposed Sale Price",NewSale);
          PieceworkHeading."Total Amount Cost"  := ROUND(PieceworkHeading."Price Cost", Currency."Amount Rounding Precision");
          PieceworkHeading."Total Amount Sales" := ROUND(PieceworkHeading."Proposed Sale Price", Currency."Amount Rounding Precision");

          PieceworkHeading.MODIFY;
        until PieceworkHeading.NEXT = 0;
    end;

    /*begin
    end.
  */
  
}



