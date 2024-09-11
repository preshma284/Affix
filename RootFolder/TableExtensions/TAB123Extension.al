tableextension 50139 "MyExtension50139" extends "Purch. Inv. Line"
{

    /*
  Permissions=TableData 32 r,
                  TableData 5802 r;
  */
    CaptionML = ENU = 'Purch. Inv. Line', ESP = 'Hist�rico l�n. factura compra';
    LookupPageID = "Posted Purchase Invoice Lines";
    DrillDownPageID = "Posted Purchase Invoice Lines";

    fields
    {
        field(50004; "Cod. Contrato"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Order to Cancel', ESP = 'N� Contrato';
            Description = 'BS::20484';

            trigger OnLookup();
            VAR
                //                                                               ContractsControl@1100286000 :
                ContractsControl: Record 7206912;
                //                                                               ContractsControlList@1100286001 :
                ContractsControlList: Page 7206922;
            BEGIN
                //-BS::20484
                ContractsControl.SETRANGE(Proyecto, "Job No.");
                ContractsControl.SETRANGE("Tipo Movimiento", ContractsControl."Tipo Movimiento"::IniProyecto);
                IF ContractsControl.FINDFIRST THEN BEGIN
                    ContractsControlList.SETTABLEVIEW(ContractsControl);
                    ContractsControlList.LOOKUPMODE(TRUE);
                    IF ACTION::LookupOK = ContractsControlList.RUNMODAL THEN BEGIN
                        ContractsControlList.GETRECORD(ContractsControl);
                        Rec."Cod. Contrato" := ContractsControl.Contrato;
                    END;
                END;
                //+BS::20484
            END;


        }
        field(7174360; "DP Apply Prorrata Type"; Option)
        {
            OptionMembers = "No","General","Especial";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Apply prorrata', ESP = 'Tipo de Prorrata Aplicable';
            OptionCaptionML = ENU = 'No,General,Special', ESP = 'No,General,Especial';

            Description = 'DP 1.00.00 PRORRATA';
            Editable = false;


        }
        field(7174361; "DP Prorrata %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'IVA Prorrata Percentage', ESP = 'Porcentaje IVA Prorrata';
            Description = 'DP 1.00.00 PRORRATA';
            Editable = false;


        }
        field(7174362; "DP VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total VAT Amount', ESP = 'Importe IVA';
            Description = 'DP 1.00.00 PRORRATA';
            Editable = false;


        }
        field(7174363; "DP Deductible VAT amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'IVA Original Base', ESP = 'IVA Deducible';
            Description = 'DP 1.00.00 JAV 21/06/22: [TT] Este campo informa del importe de IVA que es deducible de la l�nea al aplicar la regla de prorrata';
            Editable = false;


        }
        field(7174364; "DP Non Deductible VAT amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'IVA Original Percentage', ESP = 'IVA no deducible';
            Description = 'DP 1.00.00 JAV 21/06/22: [TT] Este campo informa del importe de IVA que no es deducible de la l�nea al aplicar la regla de prorrata';
            Editable = false;


        }
        field(7174365; "DP Deductible VAT Line"; Option)
        {
            OptionMembers = "NotUsed","Yes","No";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'IVA Original Percentage', ESP = 'L�nea Deducible';
            OptionCaptionML = ENU = 'Not Used,Yes,No', ESP = 'No interviene,Si,No';

            Description = 'DP 1.00.00 JAV 21/06/22: [TT] Este campo informa si la l�nea es o no deducible a efectos de la prorrata de IVA';
            Editable = false;


        }
        field(7174366; "DP Non Deductible VAT Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tiene no deducible';
            Description = 'DP 1.00.04 JAV 14/07/22: [TT] Este campo indica si la l�nea tiene una parte del IVA no deducible que aumentar� el improte del gasto';


        }
        field(7174367; "DP Non Deductible VAT %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '% No deducible';
            MinValue = 0;
            MaxValue = 100;
            Description = 'DP 1.00.04 JAV 14/07/22: [TT] Este campo indica el % no deducible de la l�nea que aumentar� el improte del gasto';


        }
        field(7207270; "QW % Withholding by GE"; Decimal)
        {
            CaptionML = ENU = '% Withholding by G.E.', ESP = '% retenci�n por B.E.';
            Description = 'QB 1.00 - QB22111';


        }
        field(7207271; "QW Withholding Amount by GE"; Decimal)
        {
            CaptionML = ENU = 'Withholding Amount by G.E', ESP = 'Importe retenci�n por B.E.';
            Description = 'QB 1.00 - QB22111';
            Editable = false;


        }
        field(7207272; "QW % Withholding by PIT"; Decimal)
        {
            CaptionML = ENU = '% Withholding by PIT', ESP = '% retenci�n IRPF';
            Description = 'QB 1.00 - QB22111';


        }
        field(7207273; "QW Withholding Amount by PIT"; Decimal)
        {
            CaptionML = ENU = 'Withholding Amount by PIT', ESP = 'Importe retenci�n por IRPF';
            Description = 'QB 1.00 - QB22111';
            Editable = false;


        }
        field(7207274; "Piecework No."; Text[30])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework No.', ESP = 'No. Unidad de obra';
            Description = 'QB 1.00 - QB2414';


        }
        field(7207275; "Qty. to Receive Origin"; Decimal)
        {
            CaptionML = ENU = 'Qty. to Receive Origin', ESP = 'Cantidad a recibir a origen';
            DecimalPlaces = 0 : 5;
            Description = 'QB 1.00 - QB2517';


        }
        field(7207276; "Accounted"; Boolean)
        {
            CaptionML = ENU = 'Accounted', ESP = 'Contabilizado';
            Description = 'QB 1.00 - QB2516';


        }
        field(7207278; "Updated budget"; Boolean)
        {
            CaptionML = ENU = 'Updated budget', ESP = 'Presupuesto actualizado';
            Description = 'QB 1.00 - QB2516';


        }
        field(7207283; "QW Not apply Withholding GE"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'Aplicar retenci�n por B.E.';
            Description = 'QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci�n por Buena Ejecuci�n a la linea';


        }
        field(7207284; "QW Not apply Withholding PIT"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by PIT', ESP = 'Aplicar retenci�n por IRPF';
            Description = 'QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci�n por IRPF a la l�nea';


        }
        field(7207285; "QW Base Withholding by GE"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Withholding by G.E', ESP = 'Base ret. B.E.';
            Description = 'QB 1.00 - JAV 11/08/19: - Base de c�lculo de la retenci�n por B.E.';
            Editable = false;


        }
        field(7207286; "QW Base Withholding by PIT"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Withholding by PIT', ESP = 'Base ret. IRPF';
            Description = 'QB 1.00 - JAV 11/08/19: - Base de c�lculo de la retenci�n por IRPF';
            Editable = false;


        }
        field(7207287; "QW Withholding by G.E Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'L�nea de retenci�n de B.E.';
            Description = 'QB 1.00 - JAV 18/08/19: - Si es la l�nea donde se calcula la retenci�n por Buena Ejecuci�n';


        }
        field(7207290; "Received on FRIÃ¯S"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Rcpt. Header"."Receive in FRIS" WHERE("No." = FIELD("Document No.")));
            CaptionML = ENU = 'Received on FRI�S', ESP = 'Recibido en FRI�S';
            Description = 'QB 1.00 - QB2411';
            Editable = false;


        }
        field(7207296; "Job Currency Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Currency Amount', ESP = 'Importe divisa proyecto';
            Description = 'QB 1.00 - GEN005-02';


        }
        field(7207297; "Job Currency Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Currency Exchange Rate', ESP = 'Tipo cambio divisa proyecto';
            Description = 'QB 1.00 - GEN005-02';


        }
        field(7207298; "Aditional Currency Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Aditional Currency Amount', ESP = 'Importe divisa adicional';
            Description = 'QB 1.00 - GEN005-02';


        }
        field(7207299; "Aditional Curr. Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Aditional Currency Exchange Rate', ESP = 'Tipo cambio divisa adicional';
            Description = 'QB 1.00 - GEN005-02';


        }
        field(7207313; "QB Framework Contr. No."; Code[20])
        {
            TableRelation = "QB Framework Contr. Header"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� Contrato Marco';
            Description = 'QB 1.06.20 - N� Contrato Marco';
            Editable = false;


        }
        field(7207314; "QB Framework Contr. Line"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� L�nea del Contrato Marco';
            Description = 'QB 1.08.18 - N� de l�nea del Contrato Marco';
            Editable = false;


        }
        field(7207351; "Comparative Quote No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative Quote No.', ESP = 'N� comparativo';
            Description = 'BS::18294 CSM 10/02/23 - Incorporar en est�ndar QB.';


        }
        field(7207352; "Comparative Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative Line No.', ESP = 'N� l�nea comparativo';
            Description = 'BS::18294 CSM 10/02/23 - Incorporar en est�ndar QB.';


        }
        field(7238177; "QB_Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Piecework No.', ESP = 'Partida presupuestaria';
            Description = 'QPR 0.00.02.15431';

            trigger OnValidate();
            VAR
                //                                                                 Job@1100286000 :
                Job: Record 167;
                //                                                                 Item@1100286001 :
                Item: Record 27;
                //                                                                 txtQB000@1100286002 :
                txtQB000: TextConst ESP = 'No ha seleccionado un proyecto';
                //                                                                 txtQB001@1100286003 :
                txtQB001: TextConst ESP = 'Solo puede comprar contra almac�mn productos';
                //                                                                 txtQB002@1100286004 :
                txtQB002: TextConst ESP = 'No existe el producto';
                //                                                                 txtQB003@1100286005 :
                txtQB003: TextConst ESP = 'Solo puede comprar contra almac�n productos de tipo inventario';
                //                                                                 InventoryPostingSetup@1100286006 :
                InventoryPostingSetup: Record 5813;
            BEGIN
            END;


        }
    }
    keys
    {
        // key(key1;"Document No.","Line No.")
        //  {
        /* MaintainSIFTIndex=false;
                                                    Clustered=true;
  */
        // }
        // key(key2;"Blanket Order No.","Blanket Order Line No.")
        //  {
        /* ;
  */
        // }
        // key(key3;"Type","No.","Variant Code")
        //  {
        /* ;
  */
        // }
        // key(key4;"Buy-from Vendor No.")
        //  {
        /* ;
  */
        // }
        // key(key5;"Order No.","Order Line No.","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key6;"Document No.","Location Code")
        //  {
        /* //SumIndexFields="Amount","Amount Including VAT"
                                                    MaintainSQLIndex=false;
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       DimMgt@1001 :
        DimMgt: Codeunit 408;
        //       DeferralUtilities@1000 :
        DeferralUtilities: Codeunit 1720;





    /*
    trigger OnDelete();    var
    //                PurchDocLineComments@1000 :
                   PurchDocLineComments: Record 43;
    //                PostedDeferralHeader@1001 :
                   PostedDeferralHeader: Record 1704;
                 begin
                   PurchDocLineComments.SETRANGE("Document Type",PurchDocLineComments."Document Type"::"Posted Invoice");
                   PurchDocLineComments.SETRANGE("No.","Document No.");
                   PurchDocLineComments.SETRANGE("Document Line No.","Line No.");
                   if not PurchDocLineComments.ISEMPTY then
                     PurchDocLineComments.DELETEALL;

                   PostedDeferralHeader.DeleteHeader(DeferralUtilities.GetPurchDeferralDocType,'','',
                     PurchDocLineComments."Document Type"::"Posted Invoice","Document No.","Line No.");
                 end;

    */




    /*
    procedure GetCurrencyCode () : Code[10];
        var
    //       PurchInvHeader@1000 :
          PurchInvHeader: Record 122;
        begin
          if "Document No." = PurchInvHeader."No." then
            exit(PurchInvHeader."Currency Code");
          if PurchInvHeader.GET("Document No.") then
            exit(PurchInvHeader."Currency Code");
          exit('');
        end;
    */




    /*
    procedure ShowDimensions ()
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Document No.","Line No."));
        end;
    */




    /*
    procedure ShowItemTrackingLines ()
        var
    //       ItemTrackingDocMgt@1000 :
          ItemTrackingDocMgt: Codeunit 6503;
        begin
          ItemTrackingDocMgt.ShowItemTrackingForInvoiceLine(RowID1);
        end;
    */



    //     procedure CalcVATAmountLines (PurchInvHeader@1000 : Record 122;var TempVATAmountLine@1001 :

    /*
    procedure CalcVATAmountLines (PurchInvHeader: Record 122;var TempVATAmountLine: Record 290 TEMPORARY)
        begin
          TempVATAmountLine.DELETEALL;
          SETRANGE("Document No.",PurchInvHeader."No.");
          if FIND('-') then
            repeat
              TempVATAmountLine.INIT;
              TempVATAmountLine.CopyFromPurchInvLine(Rec);
              if PurchInvHeader."Prices Including VAT" then
                TempVATAmountLine."Prices Including VAT" := TRUE;
              TempVATAmountLine.InsertLine;
            until NEXT = 0;
        end;
    */


    //     LOCAL procedure GetFieldCaption (FieldNumber@1000 :

    /*
    LOCAL procedure GetFieldCaption (FieldNumber: Integer) : Text[100];
        var
    //       Field@1001 :
          Field: Record 2000000041;
        begin
          Field.GET(DATABASE::"Purch. Inv. Line",FieldNumber);
          exit(Field."Field Caption");
        end;
    */



    //     procedure GetCaptionClass (FieldNumber@1000 :

    /*
    procedure GetCaptionClass (FieldNumber: Integer) : Text[80];
        var
    //       PurchInvHeader@1001 :
          PurchInvHeader: Record 122;
        begin
          if not PurchInvHeader.GET("Document No.") then
            PurchInvHeader.INIT;
          if PurchInvHeader."Prices Including VAT" then
            exit('2,1,' + GetFieldCaption(FieldNumber));

          exit('2,0,' + GetFieldCaption(FieldNumber));
        end;
    */




    /*
    procedure RowID1 () : Text[250];
        var
    //       ItemTrackingMgt@1000 :
          ItemTrackingMgt: Codeunit 6500;
        begin
          exit(ItemTrackingMgt.ComposeRowID(DATABASE::"Purch. Inv. Line",
              0,"Document No.",'',0,"Line No."));
        end;
    */



    //     procedure GetPurchRcptLines (var TempPurchRcptLine@1000 :

    /*
    procedure GetPurchRcptLines (var TempPurchRcptLine: Record 121 TEMPORARY)
        var
    //       PurchRcptLine@1003 :
          PurchRcptLine: Record 121;
    //       ItemLedgEntry@1002 :
          ItemLedgEntry: Record 32;
    //       ValueEntry@1001 :
          ValueEntry: Record 5802;
        begin
          TempPurchRcptLine.RESET;
          TempPurchRcptLine.DELETEALL;

          if Type <> Type::Item then
            exit;

          FilterPstdDocLineValueEntries(ValueEntry);
          ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
          if ValueEntry.FINDSET then
            repeat
              ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
              if ItemLedgEntry."Document Type" = ItemLedgEntry."Document Type"::"Purchase Receipt" then
                if PurchRcptLine.GET(ItemLedgEntry."Document No.",ItemLedgEntry."Document Line No.") then begin
                  TempPurchRcptLine.INIT;
                  TempPurchRcptLine := PurchRcptLine;
                  if TempPurchRcptLine.INSERT then;
                end;
            until ValueEntry.NEXT = 0;
        end;
    */



    //     procedure CalcReceivedPurchNotReturned (var RemainingQty@1006 : Decimal;var RevUnitCostLCY@1004 : Decimal;ExactCostReverse@1003 :

    /*
    procedure CalcReceivedPurchNotReturned (var RemainingQty: Decimal;var RevUnitCostLCY: Decimal;ExactCostReverse: Boolean)
        var
    //       TempItemLedgEntry@1002 :
          TempItemLedgEntry: Record 32 TEMPORARY;
    //       TotalCostLCY@1009 :
          TotalCostLCY: Decimal;
    //       TotalQtyBase@1007 :
          TotalQtyBase: Decimal;
        begin
          RemainingQty := 0;
          if (Type <> Type::Item) or (Quantity <= 0) then begin
            RevUnitCostLCY := "Unit Cost (LCY)";
            exit;
          end;

          RevUnitCostLCY := 0;
          GetItemLedgEntries(TempItemLedgEntry,FALSE);

          if TempItemLedgEntry.FINDSET then
            repeat
              RemainingQty := RemainingQty + TempItemLedgEntry."Remaining Quantity";
              if ExactCostReverse then begin
                TempItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
                TotalCostLCY :=
                  TotalCostLCY + TempItemLedgEntry."Cost Amount (Expected)" + TempItemLedgEntry."Cost Amount (Actual)";
                TotalQtyBase := TotalQtyBase + TempItemLedgEntry.Quantity;
              end;
            until TempItemLedgEntry.NEXT = 0;

          if ExactCostReverse and (RemainingQty <> 0) and (TotalQtyBase <> 0) then
            RevUnitCostLCY :=
              ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
          else
            RevUnitCostLCY := "Unit Cost (LCY)";
          RemainingQty := CalcQty(RemainingQty);

          if RemainingQty > Quantity then
            RemainingQty := Quantity;
        end;
    */


    //     LOCAL procedure CalcQty (QtyBase@1000 :

    /*
    LOCAL procedure CalcQty (QtyBase: Decimal) : Decimal;
        begin
          if "Qty. per Unit of Measure" = 0 then
            exit(QtyBase);
          exit(ROUND(QtyBase / "Qty. per Unit of Measure",0.00001));
        end;
    */



    //     procedure GetItemLedgEntries (var TempItemLedgEntry@1000 : TEMPORARY Record 32;SetQuantity@1003 :

    /*
    procedure GetItemLedgEntries (var TempItemLedgEntry: Record 32 TEMPORARY;SetQuantity: Boolean)
        var
    //       ItemLedgEntry@1002 :
          ItemLedgEntry: Record 32;
    //       ValueEntry@1001 :
          ValueEntry: Record 5802;
        begin
          if SetQuantity then begin
            TempItemLedgEntry.RESET;
            TempItemLedgEntry.DELETEALL;

            if Type <> Type::Item then
              exit;
            if "Work Center No." <> '' then
              exit;
          end;

          FilterPstdDocLineValueEntries(ValueEntry);
          ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
          if ValueEntry.FINDSET then
            repeat
              ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
              TempItemLedgEntry := ItemLedgEntry;
              if SetQuantity then begin
                TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
                if ABS(TempItemLedgEntry."Remaining Quantity") > ABS(TempItemLedgEntry.Quantity) then
                  TempItemLedgEntry."Remaining Quantity" := ABS(TempItemLedgEntry.Quantity);
              end;
              if TempItemLedgEntry.INSERT then;
            until ValueEntry.NEXT = 0;
        end;
    */


    //     LOCAL procedure FilterPstdDocLineValueEntries (var ValueEntry@1000 :

    /*
    LOCAL procedure FilterPstdDocLineValueEntries (var ValueEntry: Record 5802)
        begin
          ValueEntry.RESET;
          ValueEntry.SETCURRENTKEY("Document No.");
          ValueEntry.SETRANGE("Document No.","Document No.");
          ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Purchase Invoice");
          ValueEntry.SETRANGE("Document Line No.","Line No.");
        end;
    */




    /*
    procedure ShowItemReceiptLines ()
        var
    //       TempPurchRcptLine@1001 :
          TempPurchRcptLine: Record 121 TEMPORARY;
        begin
          if Type = Type::Item then begin
            GetPurchRcptLines(TempPurchRcptLine);
            PAGE.RUNMODAL(0,TempPurchRcptLine);
          end;
        end;
    */




    /*
    procedure ShowLineComments ()
        var
    //       PurchCommentLine@1000 :
          PurchCommentLine: Record 43;
        begin
          PurchCommentLine.ShowComments(PurchCommentLine."Document Type"::"Posted Invoice","Document No.","Line No.");
        end;
    */



    //     procedure InitFromPurchLine (PurchInvHeader@1001 : Record 122;PurchLine@1002 :

    /*
    procedure InitFromPurchLine (PurchInvHeader: Record 122;PurchLine: Record 39)
        begin
          INIT;
          TRANSFERFIELDS(PurchLine);
          if ("No." = '') and (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) then
            Type := Type::" ";
          "Posting Date" := PurchInvHeader."Posting Date";
          "Document No." := PurchInvHeader."No.";
          Quantity := PurchLine."Qty. to Invoice";
          "Quantity (Base)" := PurchLine."Qty. to Invoice (Base)";

          OnAfterInitFromPurchLine(PurchInvHeader,PurchLine,Rec);
        end;
    */




    /*
    procedure ShowDeferrals ()
        begin
          DeferralUtilities.OpenLineScheduleView(
            "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
            GetDocumentType,"Document No.","Line No.");
        end;
    */




    /*
    procedure GetDocumentType () : Integer;
        var
    //       PurchCommentLine@1000 :
          PurchCommentLine: Record 43;
        begin
          exit(PurchCommentLine."Document Type"::"Posted Invoice")
        end;
    */



    /*
    procedure HasTypeToFillMandatoryFields () : Boolean;
        begin
          exit(Type <> Type::" ");
        end;
    */




    /*
    procedure FormatType () : Text;
        var
    //       PurchaseLine@1000 :
          PurchaseLine: Record 39;
        begin
          if Type = Type::" " then
            exit(PurchaseLine.FormatType);

          exit(FORMAT(Type));
        end;
    */



    //     LOCAL procedure OnAfterInitFromPurchLine (PurchInvHeader@1000 : Record 122;PurchLine@1001 : Record 39;var PurchInvLine@1002 :

    /*
    LOCAL procedure OnAfterInitFromPurchLine (PurchInvHeader: Record 122;PurchLine: Record 39;var PurchInvLine: Record 123)
        begin
        end;
    */




    /*
    procedure IsCancellationSupported () : Boolean;
        begin
          exit(Type IN [Type::" ",Type::Item,Type::"G/L Account",Type::"Charge (Item)"]);
        end;

        /*begin
        //{
    //      JAV 21/06/22: - DP 1.00.00 Se a�aden los campos para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
    //                                    7174360 "DP Apply Prorrata Type"
    //                                    7174361 "DP Prorrata %"
    //                                    7174362 "DP VAT Amount"
    //                                    7174363 "DP Deductible VAT amount"
    //                                    7174364 "DP Non Deductible VAT amount"
    //                                    7174365 "DP Deductible VAT Line"
    //      JAV 14/07/22: - DP 1.00.04 Se a�aden campos para el manejo del IVA no deducible 7174366 "DP Non Deductible VAT Line" y 7174367 "DP Non Deductible VAT %"
    //
    //      18294 CSM 10/02/23 � Incorporar en est�ndar QB.  Modificada CALCFORMULA in Field: 7207293.   New Fields:
    //                                50090Comparative Quote No.(N� comparativo)
    //                                50091Comparative Line No.(N� l�nea comparativo)
    //      BS::20484 AML 15/11/23 - Contratos para facturas libres.
    //    }
        end.
      */
}




