page 7207012 "QB Item by Location Matrix"
{
Editable=false;
    CaptionML=ENU='Items by Location Matrix',ESP='Matriz art�culos por ubic.';
    LinksAllowed=false;
    SourceTable=27;
    SourceTableView=WHERE("QB Plant Item"=CONST(true));
    PageType=ListPart;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("No.";rec."No.")
    {
        
                ToolTipML=ENU='Specifies the number of the involved entry or record, according to the specified number series.',ESP='Especifica el n�mero de la entrada o el registro relacionado, seg�n la serie num�rica especificada.';
                ApplicationArea=Location;
    }
    field("Description";rec."Description")
    {
        
                ToolTipML=ENU='Specifies a description of the item.',ESP='Especifica una descripci�n del producto.';
                ApplicationArea=Location;
    }
    field("QtyA_to_B";QtyA_to_B)
    {
        
                CaptionML=ENU='Ceded A to B',ESP='Prestados de A a B';
                DecimalPlaces=0:5;
                BlankZero=true;
                Editable=false;
                
                             ;trigger OnDrillDown()    BEGIN
                              DrillDownCeded(AlmA,AlmB);
                            END;


    }
    field("QtyB_to_A";QtyB_to_A)
    {
        
                CaptionML=ENU='Ceded B to A',ESP='Prestados de B a A';
                DecimalPlaces=0:5;
                BlankZero=true;
                Editable=false;
                
                             ;trigger OnDrillDown()    BEGIN
                              DrillDownCeded(AlmB,AlmA);
                            END;


    }
    field("QtyA_to_QA";QtyA_to_QA)
    {
        
                CaptionML=ENU='Ceded A to QA',ESP='Prestados de A a QA';
                DecimalPlaces=0:5;
                BlankZero=true;
                Editable=false;
                
                             ;trigger OnDrillDown()    BEGIN
                              DrillDownCeded(AlmA,AlmQA);
                            END;


    }
    field("QtyQA_to_A";QtyQA_to_A)
    {
        
                CaptionML=ENU='Ceded QA to A',ESP='Prestados de QA a A';
                DecimalPlaces=0:5;
                BlankZero=true;
                Editable=false;
                
                             ;trigger OnDrillDown()    BEGIN
                              //  Q16299 CEI EUROPE (EPV) 09/02/2022: Error en el filtrado de movimientos enntre almacenes
                              //DrillDownCeded(AlmQA,AlmQA);
                              DrillDownCeded(AlmQA,AlmA);
                              //--> Q16299
                            END;


    }
    field("Field1";MATRIX_CellData[1])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[1];
                Visible=Field1Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(1);
                            END;


    }
    field("Field2";MATRIX_CellData[2])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[2];
                Visible=Field2Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(2);
                            END;


    }
    field("Field3";MATRIX_CellData[3])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[3];
                Visible=Field3Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(3);
                            END;


    }
    field("Field4";MATRIX_CellData[4])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[4];
                Visible=Field4Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(4);
                            END;


    }
    field("Field5";MATRIX_CellData[5])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[5];
                Visible=Field5Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(5);
                            END;


    }
    field("Field6";MATRIX_CellData[6])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[6];
                Visible=Field6Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(6);
                            END;


    }
    field("Field7";MATRIX_CellData[7])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[7];
                Visible=Field7Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(7);
                            END;


    }
    field("Field8";MATRIX_CellData[8])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[8];
                Visible=Field8Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(8);
                            END;


    }
    field("Field9";MATRIX_CellData[9])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[9];
                Visible=Field9Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(9);
                            END;


    }
    field("Field10";MATRIX_CellData[10])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[10];
                Visible=Field10Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(10);
                            END;


    }
    field("Field11";MATRIX_CellData[11])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[11];
                Visible=Field11Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(11);
                            END;


    }
    field("Field12";MATRIX_CellData[12])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[12];
                Visible=Field12Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(12);
                            END;


    }
    field("Field13";MATRIX_CellData[13])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[13];
                Visible=Field13Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(13);
                            END;


    }
    field("Field14";MATRIX_CellData[14])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[14];
                Visible=Field14Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(14);
                            END;


    }
    field("Field15";MATRIX_CellData[15])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[15];
                Visible=Field15Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(15);
                            END;


    }
    field("Field16";MATRIX_CellData[16])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[16];
                Visible=Field16Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(16);
                            END;


    }
    field("Field17";MATRIX_CellData[17])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[17];
                Visible=Field17Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(17);
                            END;


    }
    field("Field18";MATRIX_CellData[18])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[18];
                Visible=Field18Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(18);
                            END;


    }
    field("Field19";MATRIX_CellData[19])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[19];
                Visible=Field19Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(19);
                            END;


    }
    field("Field20";MATRIX_CellData[20])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[20];
                Visible=Field20Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(20);
                            END;


    }
    field("Field21";MATRIX_CellData[21])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[21];
                Visible=Field21Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(21);
                            END;


    }
    field("Field22";MATRIX_CellData[22])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[22];
                Visible=Field22Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(22);
                            END;


    }
    field("Field23";MATRIX_CellData[23])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[23];
                Visible=Field23Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(23);
                            END;


    }
    field("Field24";MATRIX_CellData[24])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[24];
                Visible=Field24Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(24);
                            END;


    }
    field("Field25";MATRIX_CellData[25])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[25];
                Visible=Field25Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(25);
                            END;


    }
    field("Field26";MATRIX_CellData[26])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[26];
                Visible=Field26Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(26);
                            END;


    }
    field("Field27";MATRIX_CellData[27])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[27];
                Visible=Field27Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(27);
                            END;


    }
    field("Field28";MATRIX_CellData[28])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[28];
                Visible=Field28Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(28);
                            END;


    }
    field("Field29";MATRIX_CellData[29])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[29];
                Visible=Field29Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(29);
                            END;


    }
    field("Field30";MATRIX_CellData[30])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[30];
                Visible=Field30Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(30);
                            END;


    }
    field("Field31";MATRIX_CellData[31])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[31];
                Visible=Field31Visible;
                
                             ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(31);
                            END;


    }
    field("Field32";MATRIX_CellData[32])
    {
        
                ApplicationArea=Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                CaptionClass='3,' + MATRIX_ColumnCaption[32];
                Visible=Field32Visible;
                
                             

  ;trigger OnDrillDown()    BEGIN
                              MatrixOnDrillDown(32);
                            END;


    }

}

}
}actions
{
area(Processing)
{

group("group2")
{
        CaptionML=ENU='&Item',ESP='&Producto';
                      Image=Item ;
group("group3")
{
        CaptionML=ENU='&Item Availability by',ESP='&Disponibilidad prod. por';
                      Image=ItemAvailability ;
    action("<Action3>")
    {
        
                      CaptionML=ENU='Event',ESP='Evento';
                      ToolTipML=ENU='View how the actual and the projected available balance of an item will develop over time according to supply and demand events.',ESP='Permite ver c�mo el saldo disponible real y previsto de un art�culo se desarrollar� a lo largo del tiempo seg�n los eventos de oferta y demanda.';
                      ApplicationArea=Location;
                      Image=Event;
                      
                                trigger OnAction()    BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
                               END;


    }
    action("action2")
    {
        CaptionML=ENU='Period',ESP='Periodo';
                      ToolTipML=ENU='Show the projected quantity of the item over time according to time periods, such as day, week, or month.',ESP='Muestra la cantidad proyectada del producto a lo largo de los periodos de tiempo, como d�as, semanas o meses.';
                      ApplicationArea=Location;
                      RunObject=Page 157;
RunPageLink="No."=FIELD("No."), "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter"), "Location Filter"=FIELD("Location Filter"), "Drop Shipment Filter"=FIELD("Drop Shipment Filter"), "Variant Filter"=FIELD("Variant Filter");
                      Image=Period ;
    }
    action("action3")
    {
        CaptionML=ENU='Variant',ESP='Variante';
                      ToolTipML=ENU='View or edit the items variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.',ESP='Permite ver o editar las variantes del art�culo. En lugar de configurar cada color de un art�culo como un art�culo diferente, puede configurar varios colores como variantes del art�culo.';
                      ApplicationArea=Advanced;
                      RunObject=Page 5414;
RunPageLink="No."=FIELD("No."), "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter"), "Location Filter"=FIELD("Location Filter"), "Drop Shipment Filter"=FIELD("Drop Shipment Filter"), "Variant Filter"=FIELD("Variant Filter");
                      Image=ItemVariant ;
    }
    action("action4")
    {
        CaptionML=ENU='Location',ESP='Almac�n';
                      ToolTipML=ENU='View the actual and projected quantity of the item per location.',ESP='Permite ver la cantidad real y proyectada del producto por ubicaci�n.';
                      ApplicationArea=Location;
                      RunObject=Page 492;
RunPageLink="No."=FIELD("No."), "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter"), "Location Filter"=FIELD("Location Filter"), "Drop Shipment Filter"=FIELD("Drop Shipment Filter"), "Variant Filter"=FIELD("Variant Filter");
                      Image=Warehouse ;
    }
    action("action5")
    {
        CaptionML=ENU='BOM Level',ESP='Nivel L.M.';
                      ToolTipML=ENU='View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.',ESP='Permite ver las cifras correspondientes a los productos en listas de materiales que indican cu�ntas unidades de un producto principal puede producir seg�n la disponibilidad de productos secundarios.';
                      ApplicationArea=Advanced;
                      Image=BOMLevel;
                      
                                
    trigger OnAction()    BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
                               END;


    }

}

}

}
}
  trigger OnInit()    BEGIN
             Field32Visible := TRUE;
             Field31Visible := TRUE;
             Field30Visible := TRUE;
             Field29Visible := TRUE;
             Field28Visible := TRUE;
             Field27Visible := TRUE;
             Field26Visible := TRUE;
             Field25Visible := TRUE;
             Field24Visible := TRUE;
             Field23Visible := TRUE;
             Field22Visible := TRUE;
             Field21Visible := TRUE;
             Field20Visible := TRUE;
             Field19Visible := TRUE;
             Field18Visible := TRUE;
             Field17Visible := TRUE;
             Field16Visible := TRUE;
             Field15Visible := TRUE;
             Field14Visible := TRUE;
             Field13Visible := TRUE;
             Field12Visible := TRUE;
             Field11Visible := TRUE;
             Field10Visible := TRUE;
             Field9Visible := TRUE;
             Field8Visible := TRUE;
             Field7Visible := TRUE;
             Field6Visible := TRUE;
             Field5Visible := TRUE;
             Field4Visible := TRUE;
             Field3Visible := TRUE;
             Field2Visible := TRUE;
             Field1Visible := TRUE;

             //QUONEXT PER 12.03.19 Calculos almacenes varios.
             FncSetLocation;
             //FIN QUONEXT PER 12.03.19
           END;

trigger OnOpenPage()    BEGIN
                 MATRIX_NoOfMatrixColumns := ARRAYLEN(MATRIX_CellData);
               END;

trigger OnAfterGetRecord()    VAR
                       MATRIX_CurrentColumnOrdinal : Integer;
                     BEGIN
                       MATRIX_CurrentColumnOrdinal := 0;
                       IF TempMatrixLocation.FINDSET THEN
                         REPEAT
                           MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
                           MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
                         UNTIL (TempMatrixLocation.NEXT = 0) OR (MATRIX_CurrentColumnOrdinal = MATRIX_NoOfMatrixColumns);


                       //QUONEXT PER 12.03.19 Calculos almacenes varios.
                       FncSetCalcLocationCeded(rec."No.");
                       //FIN QUONEXT PER 12.03.19
                     END;



    var
      ItemLedgerEntry : Record 32;
      MatrixRecords : ARRAY 

[32] OF Record 14;
      TempMatrixLocation : Record 14 TEMPORARY;
      ItemAvailFormsMgt : Codeunit 353;
      MATRIX_NoOfMatrixColumns : Integer;
      MATRIX_CellData : ARRAY [32] OF Decimal;
      MATRIX_ColumnCaption : ARRAY [32] OF Text[1024];
      MATRIX_CurrSetLength : Integer;
      Field1Visible : Boolean ;
      Field2Visible : Boolean ;
      Field3Visible : Boolean ;
      Field4Visible : Boolean ;
      Field5Visible : Boolean ;
      Field6Visible : Boolean ;
      Field7Visible : Boolean ;
      Field8Visible : Boolean ;
      Field9Visible : Boolean ;
      Field10Visible : Boolean ;
      Field11Visible : Boolean ;
      Field12Visible : Boolean ;
      Field13Visible : Boolean ;
      Field14Visible : Boolean ;
      Field15Visible : Boolean ;
      Field16Visible : Boolean ;
      Field17Visible : Boolean ;
      Field18Visible : Boolean ;
      Field19Visible : Boolean ;
      Field20Visible : Boolean ;
      Field21Visible : Boolean ;
      Field22Visible : Boolean ;
      Field23Visible : Boolean ;
      Field24Visible : Boolean ;
      Field25Visible : Boolean ;
      Field26Visible : Boolean ;
      Field27Visible : Boolean ;
      Field28Visible : Boolean ;
      Field29Visible : Boolean ;
      Field30Visible : Boolean ;
      Field31Visible : Boolean ;
      Field32Visible : Boolean ;
      QtyA_to_B : Decimal;
      QtyB_to_A : Decimal;
      QtyA_to_QA : Decimal;
      QtyQA_to_A : Decimal;
      AlmA : Code[20];
      AlmB : Code[20];
      AlmQA : Code[20];

    LOCAL procedure MATRIX_OnAfterGetRecord(ColumnID : Integer);
    var
      TempItem : Record 27 TEMPORARY;
    begin
      TempItem.COPY(Rec);
      TempItem.SETRANGE("Location Filter",MatrixRecords[ColumnID].Code);
      TempItem.CALCFIELDS(Inventory);
      MATRIX_CellData[ColumnID] := TempItem.Inventory;
      SetVisible;
    end;

    //[External]
    procedure Load(MatrixColumns1 : ARRAY [32] OF Text[1024];var MatrixRecords1 : ARRAY [32] OF Record 14;var MatrixRecord1 : Record 14;CurrSetLength : Integer);
    begin
      MATRIX_CurrSetLength := CurrSetLength;
      COPYARRAY(MATRIX_ColumnCaption,MatrixColumns1,1);
      COPYARRAY(MatrixRecords,MatrixRecords1,1);
      TempMatrixLocation.COPY(MatrixRecord1,TRUE);
    end;

    LOCAL procedure MatrixOnDrillDown(ColumnID : Integer);
    begin
      ItemLedgerEntry.SETCURRENTKEY(
        "Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
      ItemLedgerEntry.SETRANGE("Item No.",rec."No.");
      ItemLedgerEntry.SETRANGE("Location Code",MatrixRecords[ColumnID].Code);
      PAGE.RUN(0,ItemLedgerEntry);
    end;

    //[External]
    procedure SetVisible();
    begin
      Field1Visible := MATRIX_CurrSetLength > 0;
      Field2Visible := MATRIX_CurrSetLength > 1;
      Field3Visible := MATRIX_CurrSetLength > 2;
      Field4Visible := MATRIX_CurrSetLength > 3;
      Field5Visible := MATRIX_CurrSetLength > 4;
      Field6Visible := MATRIX_CurrSetLength > 5;
      Field7Visible := MATRIX_CurrSetLength > 6;
      Field8Visible := MATRIX_CurrSetLength > 7;
      Field9Visible := MATRIX_CurrSetLength > 8;
      Field10Visible := MATRIX_CurrSetLength > 9;
      Field11Visible := MATRIX_CurrSetLength > 10;
      Field12Visible := MATRIX_CurrSetLength > 11;
      Field13Visible := MATRIX_CurrSetLength > 12;
      Field14Visible := MATRIX_CurrSetLength > 13;
      Field15Visible := MATRIX_CurrSetLength > 14;
      Field16Visible := MATRIX_CurrSetLength > 15;
      Field17Visible := MATRIX_CurrSetLength > 16;
      Field18Visible := MATRIX_CurrSetLength > 17;
      Field19Visible := MATRIX_CurrSetLength > 18;
      Field20Visible := MATRIX_CurrSetLength > 19;
      Field21Visible := MATRIX_CurrSetLength > 20;
      Field22Visible := MATRIX_CurrSetLength > 21;
      Field23Visible := MATRIX_CurrSetLength > 22;
      Field24Visible := MATRIX_CurrSetLength > 23;
      Field25Visible := MATRIX_CurrSetLength > 24;
      Field26Visible := MATRIX_CurrSetLength > 25;
      Field27Visible := MATRIX_CurrSetLength > 26;
      Field28Visible := MATRIX_CurrSetLength > 27;
      Field29Visible := MATRIX_CurrSetLength > 28;
      Field30Visible := MATRIX_CurrSetLength > 29;
      Field31Visible := MATRIX_CurrSetLength > 30;
      Field32Visible := MATRIX_CurrSetLength > 31;
    end;

    LOCAL procedure FncSetCalcLocationCeded(pItem : Code[20]);
    var
      TempItem2 : Record 27 TEMPORARY;
    begin
      QtyA_to_B := 0;
      QtyB_to_A := 0;
      QtyA_to_QA := 0;
      QtyQA_to_A := 0;

      TempItem2.COPY(Rec);
      TempItem2.SETRANGE("No.", rec."No.");
      TempItem2.SETRANGE("QB Origen Location Filter",AlmA);
      TempItem2.SETRANGE("QB Destination Location Filter",AlmB);
      TempItem2.CALCFIELDS("QB Qty. Ceded");
      QtyA_to_B := TempItem2."QB Qty. Ceded";


      TempItem2.COPY(Rec);
      TempItem2.SETRANGE("No.", rec."No.");
      TempItem2.SETRANGE("QB Origen Location Filter",AlmB);
      TempItem2.SETRANGE("QB Destination Location Filter",AlmA);
      TempItem2.CALCFIELDS("QB Qty. Ceded");
      QtyB_to_A  := TempItem2."QB Qty. Ceded";

      TempItem2.COPY(Rec);
      TempItem2.SETRANGE("No.", rec."No.");
      TempItem2.SETRANGE("QB Origen Location Filter",AlmA);
      TempItem2.SETRANGE("QB Destination Location Filter",AlmQA);
      TempItem2.CALCFIELDS("QB Qty. Ceded");
      QtyA_to_QA  := TempItem2."QB Qty. Ceded";

      TempItem2.COPY(Rec);
      TempItem2.SETRANGE("No.", rec."No.");


      TempItem2.CALCFIELDS("QB Qty. Ceded");
      QtyQA_to_A  := TempItem2."QB Qty. Ceded";
    end;

    LOCAL procedure FncSetLocation();
    var
      rLocation : Record 14;
    begin
      rLocation.RESET;
      rLocation.SETRANGE("QB Main Location",TRUE);
      if rLocation.FINDFIRST then
         AlmA := rLocation.Code;

      rLocation.RESET;
      rLocation.SETRANGE("QB Allow Ceded",TRUE);
      if rLocation.FINDFIRST then
         AlmB := rLocation.Code;

      rLocation.RESET;
      rLocation.SETRANGE("QB Allow Deposit",TRUE);
      if rLocation.FINDFIRST then
         AlmQA := rLocation.Code;
    end;

    LOCAL procedure DrillDownCeded(pAlmOrigen : Code[20];pAlmDestino : Code[20]);
    var
      CededEntry : Record 7206976;
    begin
      CLEAR(CededEntry);
      CededEntry.SETRANGE("Item No.",rec."No.");
      CededEntry.SETRANGE("Origin Location",pAlmOrigen);
      CededEntry.SETRANGE("Destination Location",pAlmDestino);
      PAGE.RUN(0,CededEntry);
    end;

    // begin
    /*{
      //  Q16299 CEI EUROPE (EPV) 09/02/2022: Error en el filtrado de movimientos enntre almacenes
    }*///end
}







