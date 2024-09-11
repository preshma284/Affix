report 7207449 "QB Item Unit Cost"
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='Item Unit Cost',ESP='Coste unitario Producto';
    
  dataset
{

DataItem("Item";"Item")
{

               DataItemTableView=WHERE("QB Plant Item"=CONST(true));
               

               RequestFilterFields="No.";
Column(No_Item;Item."No.")
{
//SourceExpr=Item."No.";
}Column(Description_Item;Item.Description)
{
//SourceExpr=Item.Description;
}Column(QtyA;QtyA)
{
//SourceExpr=QtyA;
}Column(QtyB;QtyB)
{
//SourceExpr=QtyB;
}Column(QtyQA;QtyQA)
{
//SourceExpr=QtyQA;
}Column(MainLocationCost_Item;Item."QB Main Location Cost")
{
//SourceExpr=Item."QB Main Location Cost";
}Column(Name_CompanyInformation;CompanyInformation.Name)
{
//SourceExpr=CompanyInformation.Name;
}Column(ValorInventario;ValorInventario)
{
//SourceExpr=ValorInventario;
}Column(QtyA_to_B;QtyA_to_B)
{
//SourceExpr=QtyA_to_B;
}Column(QtyB_to_A;QtyB_to_A)
{
//SourceExpr=QtyB_to_A;
}Column(QtyQA_to_A;QtyQA_to_A)
{
//SourceExpr=QtyQA_to_A;
}Column(ShowCededValue;ShowCededValue)
{
//SourceExpr=ShowCededValue;
}Column(CostesPrestadosA_to_B;CostesPrestadosA_to_B)
{
//SourceExpr=CostesPrestadosA_to_B;
}Column(CostesPrestadosB_to_A;CostesPrestadosB_to_A)
{
//SourceExpr=CostesPrestadosB_to_A;
}Column(CostesPrestadosQA_to_A;CostesPrestadosQA_to_A)
{
//SourceExpr=CostesPrestadosQA_to_A;
}Column(CostesPrestadosTotal;CostesPrestadosTotal )
{
//SourceExpr=CostesPrestadosTotal ;
}trigger OnPreDataItem();
    BEGIN 

                               Item.CALCFIELDS("QB Main Location Cost");
                               StockkeepingUnit.CALCFIELDS(Inventory);

                               FncSetLocation;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  // Location.RESET;
                                  // Location.SETRANGE("Main Location",TRUE);
                                  // IF Location.FINDFIRST THEN BEGIN 
                                  //  StockkeepingUnit.RESET;
                                  //  StockkeepingUnit.SETRANGE("Location Code",Location.Code);
                                  //  StockkeepingUnit.SETRANGE("Item No.",Item."No.");
                                  //  IF StockkeepingUnit.FINDFIRST THEN BEGIN 
                                  //    StockkeepingUnit.CALCFIELDS(Inventory);
                                  //    ValorInventario := StockkeepingUnit.Inventory * Item."Main Location Cost";
                                  //  END;
                                  // END ELSE
                                  //  ERROR('No existe ning£n almac‚n principal');


                                  QtyA := FncGetLocationInventory(AlmA);
                                  QtyB := FncGetLocationInventory(AlmB);
                                  QtyQA := FncGetLocationInventory(AlmQA);

                                  ValorInventario := QtyA * Item."QB Main Location Cost";

                                  FncSetCalcLocationCeded;

                                  IF ShowCededValue THEN BEGIN 
                                    CostesPrestadosA_to_B := QtyA_to_B * Item."QB Main Location Cost";
                                    CostesPrestadosB_to_A := QtyB_to_A * Item."QB Main Location Cost";
                                    CostesPrestadosQA_to_A := QtyQA_to_A * Item."QB Main Location Cost";
                                    CostesPrestadosTotal := CostesPrestadosA_to_B + CostesPrestadosB_to_A + CostesPrestadosQA_to_A;
                                  END;
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group949")
{
        
                  CaptionML=ENU='Filters',ESP='Filtros';
    field("ShowCededValue";"ShowCededValue")
    {
        
                  CaptionML=ENU='Show ceded values',ESP='Mostrar valor prestados';
    }

}

}
}
  }
  labels
{
LblUnitCost='Unit Cost/ Coste unitario/';
LblItemNo='Item No./ C¢d. producto/';
LblDescripcion='Description/ Descripci¢n/';
LblUnitCostItem='Unit Cost/ Coste unitario/';
LblValorInventario='Stock Value/ Valor inventario/';
LblQtyA='Qty. A/ Cant. A/';
LblQtyB='Qty. B/ Cant. B/';
LblQtyQA='Qty. QA/ Cant. QA/';
LblAtoB='Ceded A to B/ Prest. A a B/';
LblBtoA='Ceded B to A/ Prest. B a A/';
LblQAtoA='Ceded QA to A/ Prest. QA a A/';
LblCostePrestadoAtoB='Ceded Costs A to B/ Costes prestados A a B/';
LblCostePrestadoBtoA='Ceded Costs B to A/ Costes prestados B a A/';
LblCostePrestadoQAtoA='Ceded Costs QA to A/ Costes prestados QA a A/';
LblCostePrestado='Ceded Costs/ Costes prestados/';
LblValorInventarioTotal='Total Stock Value/ Valor inventario total/';
LblPage='Page/ P g./';
LblTotales='Totals.../ Totales.../';
}
  
    var
//       CompanyInformation@1100286000 :
      CompanyInformation: Record 79;
//       Location@1100286001 :
      Location: Record 14;
//       StockkeepingUnit@1100286002 :
      StockkeepingUnit: Record 5700;
//       ValorInventario@1100286003 :
      ValorInventario: Decimal;
//       ItemAux@1100286004 :
      ItemAux: Record 27;
//       AlmA@1100286007 :
      AlmA: Code[20];
//       AlmB@1100286006 :
      AlmB: Code[20];
//       AlmQA@1100286005 :
      AlmQA: Code[20];
//       QtyA@1100286014 :
      QtyA: Decimal;
//       QtyB@1100286015 :
      QtyB: Decimal;
//       QtyQA@1100286016 :
      QtyQA: Decimal;
//       QtyA_to_B@1100286011 :
      QtyA_to_B: Decimal;
//       QtyB_to_A@1100286010 :
      QtyB_to_A: Decimal;
//       QtyA_to_QA@1100286009 :
      QtyA_to_QA: Decimal;
//       QtyQA_to_A@1100286008 :
      QtyQA_to_A: Decimal;
//       CostesPrestadosA_to_B@1100286020 :
      CostesPrestadosA_to_B: Decimal;
//       CostesPrestadosB_to_A@1100286019 :
      CostesPrestadosB_to_A: Decimal;
//       CostesPrestadosQA_to_A@1100286018 :
      CostesPrestadosQA_to_A: Decimal;
//       CostesPrestadosTotal@1100286012 :
      CostesPrestadosTotal: Decimal;
//       ValorInventarioTotal@1100286013 :
      ValorInventarioTotal: Decimal;
//       ShowCededValue@1100286017 :
      ShowCededValue: Boolean;

    

trigger OnInitReport();    begin
                   CompanyInformation.GET;
                 end;



LOCAL procedure FncSetLocation ()
    var
//       rLocation@1100286000 :
      rLocation: Record 14;
    begin

      rLocation.RESET;

      rLocation.SETRANGE("QB Main Location",TRUE);
      if rLocation.FINDFIRST then
         AlmA := rLocation.Code
      else
        ERROR('No existe ning£n almac‚n principal');

      rLocation.RESET;
      rLocation.SETRANGE("QB Allow Ceded",TRUE);
      if rLocation.FINDFIRST then
         AlmB := rLocation.Code;

      rLocation.RESET;
      rLocation.SETRANGE("QB Allow Deposit",TRUE);
      if rLocation.FINDFIRST then
         AlmQA := rLocation.Code;
    end;

//     LOCAL procedure FncGetLocationInventory (LocationCode@1100286000 :
    LOCAL procedure FncGetLocationInventory (LocationCode: Code[20]) : Decimal;
    begin

      StockkeepingUnit.RESET;
      StockkeepingUnit.SETRANGE("Location Code",LocationCode);
      StockkeepingUnit.SETRANGE("Item No.",Item."No.");
      if StockkeepingUnit.FINDFIRST then begin
        StockkeepingUnit.CALCFIELDS(Inventory);
        exit(StockkeepingUnit.Inventory);
      end;
    end;

    LOCAL procedure FncSetCalcLocationCeded ()
    var
//       TempItem2@1100286001 :
      TempItem2: Record 27 TEMPORARY;
    begin
      QtyA_to_B := 0;
      QtyB_to_A := 0;
      QtyA_to_QA := 0;
      QtyQA_to_A := 0;

      TempItem2.COPY(Item);
      TempItem2.SETRANGE("No.",Item."No.");

      TempItem2.SETRANGE("QB Origen Location Filter",AlmA);
      TempItem2.SETRANGE("QB Destination Location Filter",AlmB);
      TempItem2.CALCFIELDS("QB Qty. Ceded");
      QtyA_to_B := TempItem2."QB Qty. Ceded";


      TempItem2.COPY(Item);
      TempItem2.SETRANGE("No.",Item."No.");
      TempItem2.SETRANGE("QB Origen Location Filter",AlmB);
      TempItem2.SETRANGE("QB Destination Location Filter",AlmA);
      TempItem2.CALCFIELDS("QB Qty. Ceded");
      QtyB_to_A  := TempItem2."QB Qty. Ceded";

      TempItem2.COPY(Item);
      TempItem2.SETRANGE("No.",Item."No.");
      TempItem2.SETRANGE("QB Origen Location Filter",AlmA);
      TempItem2.SETRANGE("QB Destination Location Filter",AlmQA);
      TempItem2.CALCFIELDS("QB Qty. Ceded");
      QtyA_to_QA  := TempItem2."QB Qty. Ceded";

      TempItem2.COPY(Item);
      TempItem2.SETRANGE("No.",Item."No.");
      TempItem2.SETRANGE("QB Origen Location Filter",AlmQA);
      TempItem2.SETRANGE("QB Destination Location Filter",AlmA);
      TempItem2.CALCFIELDS("QB Qty. Ceded");
      QtyQA_to_A  := TempItem2."QB Qty. Ceded";
    end;

    /*begin
    end.
  */
  
}




