tableextension 50104 "MyExtension50104" extends "Location"
{
  
  DataCaptionFields="Code","Name";
    CaptionML=ENU='Location',ESP='Almac‚n';
    LookupPageID="Location List";
    DrillDownPageID="Location List";
  
  fields
{
    field(7207270;"QB Departament Code";Code[20])
    {
        

                                                   CaptionML=ENU='Departament Code',ESP='C¢d. Departamento';
                                                   Description='QB2517';

trigger OnLookup();
    VAR
//                                                               QBTablePublisher@100000000 :
                                                              QBTablePublisher: Codeunit 7207346;
                                                            BEGIN 
                                                              QBTablePublisher.OnLookupDepartamentCode(Rec);
                                                            END;


    }
    field(7207271;"QB Job Location";Boolean)
    {
        CaptionML=ENU='Average Cost by Shipment',ESP='Almac‚n de Obra';
                                                   Description='QB 1.08.07 JAV 01/02/21 Se cambia el nombre y el caption para que sea mas intuitivo';


    }
    field(7207272;"QB Allow Deposit";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Deposit',ESP='Permite dep¢sito';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';

trigger OnValidate();
    BEGIN 
                                                                IF "QB Allow Deposit" THEN BEGIN 
                                                                  Location.RESET;
                                                                  Location.SETFILTER(Code, '<>%1', Rec.Code);  //No miro si es en el actual pues ya lo tiene marcado
                                                                  Location.SETRANGE("QB Allow Deposit", TRUE);
                                                                  IF (NOT Location.ISEMPTY) THEN
                                                                    ERROR(Error001, TABLECAPTION, FIELDCAPTION("QB Allow Deposit"), Location.Code);
                                                                END;
                                                              END;


    }
    field(7207273;"QB Allow Ceded";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Ceded',ESP='Permite cedidos';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';

trigger OnValidate();
    BEGIN 
                                                                IF "QB Allow Ceded" THEN BEGIN 
                                                                  Location.RESET;
                                                                  Location.SETFILTER(Code, '<>%1', Rec.Code);  //No miro si es en el actual pues ya lo tiene marcado
                                                                  Location.SETRANGE("QB Allow Ceded", TRUE);
                                                                  IF (NOT Location.ISEMPTY) THEN
                                                                    ERROR(Error001, TABLECAPTION, FIELDCAPTION("QB Allow Ceded"), Location.Code);
                                                                END;
                                                              END;


    }
    field(7207274;"QB Main Location";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Main Location',ESP='Almac‚n principal';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL';

trigger OnValidate();
    VAR
//                                                                 Location@1100286000 :
                                                                Location: Record 14;
                                                              BEGIN 
                                                                IF "QB Main Location" THEN BEGIN 
                                                                  Location.RESET;
                                                                  Location.SETFILTER(Code, '<>%1', Rec.Code);  //No miro si es en el actual pues ya lo tiene marcado
                                                                  Location.SETRANGE("QB Main Location", TRUE);
                                                                  IF (NOT Location.ISEMPTY) THEN
                                                                    ERROR(Error001, TABLECAPTION, FIELDCAPTION("QB Main Location"), Location.Code);
                                                                END;
                                                              END;


    }
    field(7207275;"QB View Item Disponibility";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='View Item Disponibility',ESP='Ver disponibilidad producto';
                                                   Description='QB 1.09.21 - ALMACENCENTRAL' ;


    }
}
  keys
{
   // key(key1;"Code")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Name")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Bin@1000 :
      Bin: Record 7354;
//       PostCode@1001 :
      PostCode: Record 225;
//       WhseSetup@1002 :
      WhseSetup: Record 5769;
//       InvtSetup@1003 :
      InvtSetup: Record 313;
//       Location@1004 :
      Location: Record 14;
//       CustomizedCalendarChange@1023 :
      CustomizedCalendarChange: Record 7602;
//       Text000@100000008 :
      Text000: TextConst ENU='You cannot delete the %1 %2, because they contain items.',ESP='No puede borrar el %1 %2, porque contienen productos.';
//       Text001@100000007 :
      Text001: TextConst ENU='You cannot delete the %1 %2, because one or more Warehouse Activity Lines exist for this %1.',ESP='No puede borrar el %1 %2 , porque existen una o m s l¡ns. actividad almac‚n para este %1.';
//       Text002@100000006 :
      Text002: TextConst ENU='%1 must be Yes, because the bins contain items.',ESP='%1 tiene que ser s¡, porque las ubic. contienen prods.';
//       Text003@100000005 :
      Text003: TextConst ENU='Cancelled.',ESP='Cancelado.';
//       Text004@100000004 :
      Text004: TextConst ENU='The total quantity of items in the warehouse is 0, but the Adjustment Bin contains a negative quantity and other bins contain a positive quantity.\',ESP='La cant. total de prods. en el alm. es 0, pero la ubic. de ajuste contiene una cantidad negativa y otras ubic. contienen una cantidad positiva.\';
//       Text005@100000003 :
      Text005: TextConst ENU='Do you still want to delete this %1?',ESP='¨Quiere todav¡a borrar este %1?';
//       Text006@100000002 :
      Text006: TextConst ENU='You cannot change the %1 until the inventory stored in %2 %3 is 0.',ESP='No puede cambiar el %1 hasta que el invent. almacenado en %2 %3 sea 0.';
//       Text007@100000001 :
      Text007: TextConst ENU='You have to delete all Adjustment Warehouse Journal Lines first before you can change the %1.',ESP='Primero debe eliminar todos los ajustes de l¡neas diario almac‚n para poder cambiar el %1.';
//       Text008@1008 :
      Text008: TextConst ENU='%1 must be %2, because one or more %3 exist.',ESP='%1 tiene que ser %2, porque uno o m s %3 existen.';
//       Text009@1014 :
      Text009: TextConst ENU='You cannot change %1 because there are one or more open ledger entries on this location.',ESP='No puede cambiar %1 por que hay uno ¢ m s movs. abiertos en este almac‚n.';
//       Text010@1015 :
      Text010: TextConst ENU='Checking item ledger entries for open entries...',ESP='Chequear movs. contab. para movs. abiertos...';
//       Text011@1016 :
      Text011: TextConst ENU='You cannot change the %1 to %2 until the inventory stored in this bin is 0.',ESP='No puede cambiar %1 a %2 hasta que el valor del inventario almacenado en esta ubicaci¢n sea 0.';
//       Text012@1017 :
      Text012: TextConst ENU='Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.',ESP='Para poder usar Online Map, primero debe rellenar la ventana Configuraci¢n Online Map.\Consulte Configuraci¢n de Online Map en la Ayuda.';
//       Text013@1018 :
      Text013: TextConst ENU='You cannot delete %1 because there are one or more ledger entries on this location.',ESP='No puede eliminar %1 porque hay uno o m s movimientos en este almac‚n.';
//       Text014@1019 :
      Text014: TextConst ENU='You cannot change %1 because one or more %2 exist.',ESP='No puede cambiar %1 porque existen uno o m s %2.';
//       CannotDeleteLocSKUExistErr@1021 :
      CannotDeleteLocSKUExistErr: 
// %1: Field(Code)
TextConst ENU='You cannot delete %1 because one or more stockkeeping units exist at this location',ESP='No se puede eliminar %1 porque existen una o varias unidades de alamcenamiento en esta ubicaci¢n';
//       UnspecifiedLocationLbl@1020 :
      UnspecifiedLocationLbl: TextConst ENU='(Unspecified Location)',ESP='(Ubicaci¢n sin especificar)';
//       Error001@1100286000 :
      Error001: TextConst ENU='Can''t be more than one %1 marked as %2. Marked in %1 %3.',ESP='No puede haber mas de un %1 marcado como %2. Marcado en el %1 %3.';

    
    


/*
trigger OnDelete();    var
//                TransferRoute@1000 :
               TransferRoute: Record 5742;
//                WhseEmployee@1003 :
               WhseEmployee: Record 7301;
//                WorkCenter@1004 :
               WorkCenter: Record 99000754;
//                StockkeepingUnit@1001 :
               StockkeepingUnit: Record 5700;
             begin
               StockkeepingUnit.SETRANGE("Location Code",Code);
               if not StockkeepingUnit.ISEMPTY then
                 ERROR(CannotDeleteLocSKUExistErr,Code);

               WMSCheckWarehouse;

               TransferRoute.SETRANGE("Transfer-from Code",Code);
               TransferRoute.DELETEALL;
               TransferRoute.RESET;
               TransferRoute.SETRANGE("Transfer-to Code",Code);
               TransferRoute.DELETEALL;

               WhseEmployee.SETRANGE("Location Code",Code);
               WhseEmployee.DELETEALL(TRUE);

               WorkCenter.SETRANGE("Location Code",Code);
               if WorkCenter.FINDSET(TRUE) then
                 repeat
                   WorkCenter.VALIDATE("Location Code",'');
                   WorkCenter.MODIFY(TRUE);
                 until WorkCenter.NEXT = 0;
             end;

*/



// procedure RequireShipment (LocationCode@1000 :

/*
procedure RequireShipment (LocationCode: Code[10]) : Boolean;
    begin
      if Location.GET(LocationCode) then
        exit(Location."Require Shipment");
      WhseSetup.GET;
      exit(WhseSetup."Require Shipment");
    end;
*/


    
//     procedure RequirePicking (LocationCode@1000 :
    
/*
procedure RequirePicking (LocationCode: Code[10]) : Boolean;
    begin
      if Location.GET(LocationCode) then
        exit(Location."Require Pick");
      WhseSetup.GET;
      exit(WhseSetup."Require Pick");
    end;
*/


    
//     procedure RequireReceive (LocationCode@1000 :
    
/*
procedure RequireReceive (LocationCode: Code[10]) : Boolean;
    begin
      if Location.GET(LocationCode) then
        exit(Location."Require Receive");
      WhseSetup.GET;
      exit(WhseSetup."Require Receive");
    end;
*/


    
//     procedure RequirePutaway (LocationCode@1000 :
    
/*
procedure RequirePutaway (LocationCode: Code[10]) : Boolean;
    begin
      if Location.GET(LocationCode) then
        exit(Location."Require Put-away");
      WhseSetup.GET;
      exit(WhseSetup."Require Put-away");
    end;
*/


    
//     procedure GetLocationSetup (LocationCode@1000 : Code[10];var Location2@1001 :
    
/*
procedure GetLocationSetup (LocationCode: Code[10];var Location2: Record 14) : Boolean;
    begin
      if not GET(LocationCode) then
        WITH Location2 DO begin
          INIT;
          WhseSetup.GET;
          InvtSetup.GET;
          Code := LocationCode;
          "Use As In-Transit" := FALSE;
          "Require Put-away" := WhseSetup."Require Put-away";
          "Require Pick" := WhseSetup."Require Pick";
          "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
          "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
          "Require Receive" := WhseSetup."Require Receive";
          "Require Shipment" := WhseSetup."Require Shipment";
          exit(FALSE);
        end;

      Location2 := Rec;
      exit(TRUE);
    end;
*/


    
/*
LOCAL procedure WMSCheckWarehouse ()
    var
//       Zone@1005 :
      Zone: Record 7300;
//       Bin@1006 :
      Bin: Record 7354;
//       BinContent@1004 :
      BinContent: Record 7302;
//       WhseActivLine@1003 :
      WhseActivLine: Record 5767;
//       WarehouseEntry@1002 :
      WarehouseEntry: Record 7312;
//       WarehouseEntry2@1001 :
      WarehouseEntry2: Record 7312;
//       WhseJnlLine@1000 :
      WhseJnlLine: Record 7311;
//       ItemLedgerEntry@1007 :
      ItemLedgerEntry: Record 32;
    begin
      ItemLedgerEntry.SETRANGE("Location Code",Code);
      ItemLedgerEntry.SETRANGE(Open,TRUE);
      if not ItemLedgerEntry.ISEMPTY then
        ERROR(Text013,Code);

      WarehouseEntry.SETRANGE("Location Code",Code);
      WarehouseEntry.CALCSUMS("Qty. (Base)");
      if WarehouseEntry."Qty. (Base)" = 0 then begin
        if "Adjustment Bin Code" <> '' then begin
          WarehouseEntry2.SETRANGE("Bin Code","Adjustment Bin Code");
          WarehouseEntry2.SETRANGE("Location Code",Code);
          WarehouseEntry2.CALCSUMS("Qty. (Base)");
          if WarehouseEntry2."Qty. (Base)" < 0 then
            if not CONFIRM(Text004 + Text005,FALSE,TABLECAPTION) then
              ERROR(Text003)
        end;
      end else
        ERROR(Text000,TABLECAPTION,Code);

      WhseActivLine.SETRANGE("Location Code",Code);
      WhseActivLine.SETRANGE("Activity Type",WhseActivLine."Activity Type"::Movement);
      WhseActivLine.SETFILTER("Qty. Outstanding",'<>0');
      if not WhseActivLine.ISEMPTY then
        ERROR(Text001,TABLECAPTION,Code);

      WhseJnlLine.SETRANGE("Location Code",Code);
      WhseJnlLine.SETFILTER(Quantity,'<>0');
      if not WhseJnlLine.ISEMPTY then
        ERROR(Text001,TABLECAPTION,Code);

      Zone.SETRANGE("Location Code",Code);
      Zone.DELETEALL;
      Bin.SETRANGE("Location Code",Code);
      Bin.DELETEALL;
      BinContent.SETRANGE("Location Code",Code);
      BinContent.DELETEALL;
    end;
*/


//     LOCAL procedure CheckEmptyBin (BinCode@1001 : Code[20];CaptionOfField@1002 :
    
/*
LOCAL procedure CheckEmptyBin (BinCode: Code[20];CaptionOfField: Text[30])
    var
//       WarehouseEntry@1003 :
      WarehouseEntry: Record 7312;
//       WhseEntry2@1000 :
      WhseEntry2: Record 7312;
    begin
      WarehouseEntry.SETCURRENTKEY("Bin Code","Location Code","Item No.");
      WarehouseEntry.SETRANGE("Bin Code",BinCode);
      WarehouseEntry.SETRANGE("Location Code",Code);
      if WarehouseEntry.FINDFIRST then
        repeat
          WarehouseEntry.SETRANGE("Item No.",WarehouseEntry."Item No.");

          WhseEntry2.SETCURRENTKEY("Item No.","Bin Code","Location Code");
          WhseEntry2.COPYFILTERS(WarehouseEntry);
          WhseEntry2.CALCSUMS("Qty. (Base)");
          if WhseEntry2."Qty. (Base)" <> 0 then begin
            if (BinCode = "Adjustment Bin Code") and (xRec."Adjustment Bin Code" = '') then
              ERROR(Text011,CaptionOfField,BinCode);

            ERROR(Text006,CaptionOfField,Bin.TABLECAPTION,BinCode);
          end;

          WarehouseEntry.FINDLAST;
          WarehouseEntry.SETRANGE("Item No.");
        until WarehouseEntry.NEXT = 0;
    end;
*/


    
/*
LOCAL procedure CheckWhseAdjmtJnl ()
    var
//       WhseJnlTemplate@1002 :
      WhseJnlTemplate: Record 7309;
//       WhseJnlLine@1003 :
      WhseJnlLine: Record 7311;
    begin
      WhseJnlTemplate.SETRANGE(Type,WhseJnlTemplate.Type::Item);
      if WhseJnlTemplate.FIND('-') then
        repeat
          WhseJnlLine.SETRANGE("Journal Template Name",WhseJnlTemplate.Name);
          WhseJnlLine.SETRANGE("Location Code",Code);
          if not WhseJnlLine.ISEMPTY then
            ERROR(
              Text007,
              FIELDCAPTION("Adjustment Bin Code"));
        until WhseJnlTemplate.NEXT = 0;
    end;
*/


    
//     procedure GetRequirementText (FieldNumber@1000 :
    
/*
procedure GetRequirementText (FieldNumber: Integer) : Text[50];
    var
//       Text000@1002 :
      Text000: TextConst ENU='Shipment,Receive,Pick,Put-Away',ESP='Env¡o,Recibir,Picking,Ubicar';
    begin
      CASE FieldNumber OF
        FIELDNO("Require Shipment"):
          exit(SELECTSTR(1,Text000));
        FIELDNO("Require Receive"):
          exit(SELECTSTR(2,Text000));
        FIELDNO("Require Pick"):
          exit(SELECTSTR(3,Text000));
        FIELDNO("Require Put-away"):
          exit(SELECTSTR(4,Text000));
      end;
    end;
*/


    
    
/*
procedure DisplayMap ()
    var
//       MapPoint@1001 :
      MapPoint: Record 800;
//       MapMgt@1000 :
      MapMgt: Codeunit 802;
    begin
      if MapPoint.FINDFIRST then
        MapMgt.MakeSelection(DATABASE::Location,GETPOSITION)
      else
        MESSAGE(Text012);
    end;
*/


    
    
/*
procedure IsBWReceive () : Boolean;
    begin
      exit("Bin Mandatory" and (not "Directed Put-away and Pick") and "Require Receive");
    end;
*/


    
    
/*
procedure IsBWShip () : Boolean;
    begin
      exit("Bin Mandatory" and (not "Directed Put-away and Pick") and "Require Shipment");
    end;
*/


    
//     procedure IsBinBWReceiveOrShip (BinCode@1000 :
    
/*
procedure IsBinBWReceiveOrShip (BinCode: Code[20]) : Boolean;
    begin
      exit(("Receipt Bin Code" <> '') and (BinCode = "Receipt Bin Code") or
        ("Shipment Bin Code" <> '') and (BinCode = "Shipment Bin Code"));
    end;
*/


    
//     procedure IsInTransit (LocationCode@1000 :
    
/*
procedure IsInTransit (LocationCode: Code[10]) : Boolean;
    begin
      if Location.GET(LocationCode) then
        exit(Location."Use As In-Transit");
      exit(FALSE);
    end;
*/


    
/*
LOCAL procedure CreateInboundWhseRequest ()
    var
//       TransferHeader@1002 :
      TransferHeader: Record 5740;
//       TransferLine@1004 :
      TransferLine: Record 5741;
//       WarehouseRequest@1000 :
      WarehouseRequest: Record 5765;
//       WhseTransferRelease@1003 :
      WhseTransferRelease: Codeunit 5773;
    begin
      TransferLine.SETRANGE("Transfer-to Code",Code);
      if TransferLine.FINDSET then
        repeat
          if TransferLine."Quantity Received" <> TransferLine."Quantity Shipped" then begin
            TransferHeader.GET(TransferLine."Document No.");
            WhseTransferRelease.InitializeWhseRequest(WarehouseRequest,TransferHeader,TransferHeader.Status);
            WhseTransferRelease.CreateInboundWhseRequest(WarehouseRequest,TransferHeader);

            TransferLine.SETRANGE("Document No.",TransferLine."Document No.");
            TransferLine.FINDLAST;
            TransferLine.SETRANGE("Document No.");
          end;
        until TransferLine.NEXT = 0;
    end;
*/


    
//     procedure GetLocationsIncludingUnspecifiedLocation (IncludeOnlyUnspecifiedLocation@1001 : Boolean;ExcludeInTransitLocations@1000 :
    
/*
procedure GetLocationsIncludingUnspecifiedLocation (IncludeOnlyUnspecifiedLocation: Boolean;ExcludeInTransitLocations: Boolean)
    var
//       Location@1002 :
      Location: Record 14;
    begin
      INIT;
      VALIDATE(Name,UnspecifiedLocationLbl);
      INSERT;

      if not IncludeOnlyUnspecifiedLocation then begin
        if ExcludeInTransitLocations then
          Location.SETRANGE("Use As In-Transit",FALSE);

        if Location.FINDSET then
          repeat
            INIT;
            COPY(Location);
            INSERT;
          until Location.NEXT = 0;
      end;

      FINDFIRST;
    end;

    /*begin
    //{
//      QB 1.09.21 DGG 06/10/21- Added fields 7207272Allow Deposit
//                                          7207273Allow CededAllow Ceded
//                                          7207274Main LocationMain Location
//    }
    end.
  */
}




