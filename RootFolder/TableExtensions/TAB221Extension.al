tableextension 50155 "MyExtension50155" extends "Gen. Jnl. Allocation"
{


    CaptionML = ENU = 'Gen. Jnl. Allocation', ESP = 'Diario gen. distribuci�n';

    fields
    {
        field(7207270; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';
            Description = 'QB 1.00';


        }
        field(7207271; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'N� unidad de obra';
            Description = 'QB 1.00';


        }
    }
    keys
    {
    }
    fieldgroups
    {
    }

    var
        //       Text000@1000 :
        Text000: TextConst ENU = '%1 cannot be used in allocations when they are completed on the general journal line.', ESP = 'No se puede utilizar %1 en distribuciones cuando estan rellenados en la l�neas del diario general.';
        //       GLAcc@1001 :
        GLAcc: Record 15;
        //       GenJnlLine@1002 :
        GenJnlLine: Record 81;
        //       GenBusPostingGrp@1003 :
        GenBusPostingGrp: Record 250;
        //       GenProdPostingGrp@1004 :
        GenProdPostingGrp: Record 251;
        //       DimMgt@1005 :
        DimMgt: Codeunit 408;





    /*
    trigger OnInsert();    begin
                   LOCKTABLE;
                   GenJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.");

                   ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                   ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                 end;


    */

    /*
    trigger OnDelete();    begin
                   VALIDATE(Amount,0);
                 end;

    */



    // procedure UpdateAllocations (var GenJnlLine@1000 :

    /*
    procedure UpdateAllocations (var GenJnlLine: Record 81)
        var
    //       GenJnlAlloc@1001 :
          GenJnlAlloc: Record 221;
    //       GenJnlAlloc2@1002 :
          GenJnlAlloc2: Record 221;
    //       FromAllocations@1003 :
          FromAllocations: Boolean;
    //       TotalQty@1004 :
          TotalQty: Decimal;
    //       TotalPct@1005 :
          TotalPct: Decimal;
    //       TotalPctRnded@1006 :
          TotalPctRnded: Decimal;
    //       TotalAmountLCY@1007 :
          TotalAmountLCY: Decimal;
    //       TotalAmountLCY2@1008 :
          TotalAmountLCY2: Decimal;
    //       TotalAmountLCYRnded@1009 :
          TotalAmountLCYRnded: Decimal;
    //       TotalAmountLCYRnded2@1010 :
          TotalAmountLCYRnded2: Decimal;
    //       UpdateGenJnlLine@1011 :
          UpdateGenJnlLine: Boolean;
        begin
          if "Line No." <> 0 then begin
            FromAllocations := TRUE;
            GenJnlAlloc.UpdateVAT(GenJnlLine);
            MODIFY;
            GenJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.");
            CheckVAT(GenJnlLine);
          end;

          GenJnlAlloc.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
          GenJnlAlloc.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
          GenJnlAlloc.SETRANGE("Journal Line No.",GenJnlLine."Line No.");
          if FromAllocations then
            UpdateGenJnlLine := TRUE
          else
            if not GenJnlAlloc.ISEMPTY then begin
              GenJnlAlloc.LOCKTABLE;
              UpdateGenJnlLine := TRUE;
            end;

          if GenJnlAlloc.FINDSET then
            repeat
              if (GenJnlAlloc."Allocation Quantity" <> 0) or (GenJnlAlloc."Allocation %" <> 0) then begin
                if not FromAllocations then
                  GenJnlAlloc.CheckVAT(GenJnlLine);
                if GenJnlAlloc."Allocation Quantity" = 0 then begin
                  TotalAmountLCY2 := TotalAmountLCY2 - GenJnlLine."Amount (LCY)" * GenJnlAlloc."Allocation %" / 100;
                  GenJnlAlloc.Amount := ROUND(TotalAmountLCY2) - TotalAmountLCYRnded2;
                  TotalAmountLCYRnded2 := TotalAmountLCYRnded2 + GenJnlAlloc.Amount;
                end else begin
                  if TotalQty = 0 then begin
                    GenJnlAlloc2.COPY(GenJnlAlloc);
                    GenJnlAlloc2.SETFILTER("Allocation Quantity",'<>0');
                    GenJnlAlloc2.CALCSUMS("Allocation Quantity");
                    TotalQty := GenJnlAlloc2."Allocation Quantity";
                    if TotalQty = 0 then
                      TotalQty := 1;
                  end;
                  TotalPct := TotalPct + GenJnlAlloc."Allocation Quantity" / TotalQty * 100;
                  GenJnlAlloc."Allocation %" := ROUND(TotalPct,0.01) - TotalPctRnded;
                  TotalPctRnded := TotalPctRnded + GenJnlAlloc."Allocation %";
                  TotalAmountLCY := TotalAmountLCY - GenJnlLine."Amount (LCY)" * GenJnlAlloc."Allocation Quantity" / TotalQty;
                  GenJnlAlloc.Amount := ROUND(TotalAmountLCY) - TotalAmountLCYRnded;
                  TotalAmountLCYRnded := TotalAmountLCYRnded + GenJnlAlloc.Amount;
                end;
                GenJnlAlloc.UpdateVAT(GenJnlLine);
                GenJnlAlloc.MODIFY;
              end;
            until GenJnlAlloc.NEXT = 0;

          if UpdateGenJnlLine then
            UpdateJnlBalance(GenJnlLine);

          if FromAllocations then
            FIND;
        end;
    */



    //     procedure UpdateAllocationsAddCurr (var GenJnlLine@1000 : Record 81;AddCurrAmount@1001 :

    /*
    procedure UpdateAllocationsAddCurr (var GenJnlLine: Record 81;AddCurrAmount: Decimal)
        var
    //       GenJnlAlloc@1002 :
          GenJnlAlloc: Record 221;
    //       GenJnlAlloc2@1003 :
          GenJnlAlloc2: Record 221;
    //       GLSetup@1004 :
          GLSetup: Record 98;
    //       Currency@1005 :
          Currency: Record 4;
    //       TotalQty@1006 :
          TotalQty: Decimal;
    //       TotalPct@1007 :
          TotalPct: Decimal;
    //       TotalPctRnded@1008 :
          TotalPctRnded: Decimal;
    //       TotalAmountAddCurr@1009 :
          TotalAmountAddCurr: Decimal;
    //       TotalAmountAddCurr2@1010 :
          TotalAmountAddCurr2: Decimal;
    //       TotalAmountAddCurrRnded@1011 :
          TotalAmountAddCurrRnded: Decimal;
    //       TotalAmountAddCurrRnded2@1012 :
          TotalAmountAddCurrRnded2: Decimal;
        begin
          GenJnlAlloc.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
          GenJnlAlloc.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
          GenJnlAlloc.SETRANGE("Journal Line No.",GenJnlLine."Line No.");
          GenJnlAlloc.LOCKTABLE;
          if GenJnlAlloc.FINDSET then begin
            GLSetup.GET;
            Currency.GET(GLSetup."Additional Reporting Currency");
            Currency.TESTFIELD("Amount Rounding Precision");
            repeat
              if (GenJnlAlloc."Allocation Quantity" <> 0) or (GenJnlAlloc."Allocation %" <> 0) then begin
                if GenJnlAlloc."Allocation Quantity" = 0 then begin
                  TotalAmountAddCurr2 :=
                    TotalAmountAddCurr2 - AddCurrAmount * GenJnlAlloc."Allocation %" / 100;
                  GenJnlAlloc."Additional-Currency Amount" :=
                    ROUND(TotalAmountAddCurr2,Currency."Amount Rounding Precision") -
                    TotalAmountAddCurrRnded2;
                  TotalAmountAddCurrRnded2 :=
                    TotalAmountAddCurrRnded2 + GenJnlAlloc."Additional-Currency Amount";
                end else begin
                  if TotalQty = 0 then begin
                    GenJnlAlloc2.COPY(GenJnlAlloc);
                    GenJnlAlloc2.SETFILTER("Allocation Quantity",'<>0');
                    repeat
                      TotalQty := TotalQty + GenJnlAlloc2."Allocation Quantity";
                    until GenJnlAlloc2.NEXT = 0;
                    if TotalQty = 0 then
                      TotalQty := 1;
                  end;
                  TotalPct := TotalPct + GenJnlAlloc."Allocation Quantity" / TotalQty * 100;
                  GenJnlAlloc."Allocation %" := ROUND(TotalPct,0.01) - TotalPctRnded;
                  TotalPctRnded := TotalPctRnded + GenJnlAlloc."Allocation %";
                  TotalAmountAddCurr :=
                    TotalAmountAddCurr -
                    AddCurrAmount * GenJnlAlloc."Allocation Quantity" / TotalQty;
                  GenJnlAlloc."Additional-Currency Amount" :=
                    ROUND(TotalAmountAddCurr,Currency."Amount Rounding Precision") -
                    TotalAmountAddCurrRnded;
                  TotalAmountAddCurrRnded :=
                    TotalAmountAddCurrRnded + GenJnlAlloc."Additional-Currency Amount";
                end;
                GenJnlAlloc.MODIFY;
              end;
            until GenJnlAlloc.NEXT = 0;
          end;
        end;
    */


    //     LOCAL procedure UpdateJnlBalance (var GenJnlLine@1000 :

    /*
    LOCAL procedure UpdateJnlBalance (var GenJnlLine: Record 81)
        begin
          GenJnlLine.CALCFIELDS("Allocated Amt. (LCY)");
          if GenJnlLine."Bal. Account No." = '' then
            GenJnlLine."Balance (LCY)" := GenJnlLine."Amount (LCY)" + GenJnlLine."Allocated Amt. (LCY)"
          else
            GenJnlLine."Balance (LCY)" := GenJnlLine."Allocated Amt. (LCY)";
          GenJnlLine.MODIFY;
        end;
    */



    //     procedure CheckVAT (var GenJnlLine@1000 :

    /*
    procedure CheckVAT (var GenJnlLine: Record 81)
        begin
          if ("Gen. Posting Type" <> 0) and (GenJnlLine."Gen. Posting Type" <> 0) then
            ERROR(
              Text000,
              GenJnlLine.FIELDCAPTION("Gen. Posting Type"));
        end;
    */



    //     procedure UpdateVAT (var GenJnlLine@1000 :

    /*
    procedure UpdateVAT (var GenJnlLine: Record 81)
        var
    //       GenJnlLine2@1001 :
          GenJnlLine2: Record 81;
        begin
          GenJnlLine2.CopyFromGenJnlAllocation(Rec);
          GenJnlLine2."Posting Date" := GenJnlLine."Posting Date";
          GenJnlLine2.VALIDATE("VAT Prod. Posting Group");
          Amount := GenJnlLine2."Amount (LCY)";
          "VAT Calculation Type" := GenJnlLine2."VAT Calculation Type";
          "VAT Amount" := GenJnlLine2."VAT Amount";
          "VAT %" := GenJnlLine2."VAT %";
        end;
    */




    /*
    procedure GetCurrencyCode () : Code[10];
        var
    //       GenJnlLine3@1000 :
          GenJnlLine3: Record 81;
        begin
          GenJnlLine3.SETRANGE("Journal Template Name","Journal Template Name");
          GenJnlLine3.SETRANGE("Journal Batch Name","Journal Batch Name");
          GenJnlLine3.SETRANGE("Line No.","Journal Line No.");
          if GenJnlLine3.FINDFIRST then
            exit(GenJnlLine3."Currency Code");

          exit('');
        end;
    */



    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 :


    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        //       TableID@1002 :
        TableID: ARRAY[10] OF Integer;
        //       No@1003 :
        No: ARRAY[10] OF Code[20];
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        OnAfterCreateDimTableIDs(Rec, CurrFieldNo, TableID, No);

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(Rec, CurrFieldNo, DefaultDimSource, '', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;




    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
          DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        end;
    */



    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure LookupShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
          DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
          DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        end;
    */



    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :

    /*
    procedure ShowShortcutDimCode (var ShortcutDimCode: ARRAY [8] OF Code[20])
        begin
          DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
        end;
    */




    /*
    procedure ShowDimensions ()
        begin
          "Dimension Set ID" :=
            DimMgt.EditDimensionSet2("Dimension Set ID",
              STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Journal Line No."),
              "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        end;
    */



    //     LOCAL procedure OnAfterCreateDimTableIDs (var GenJnlAllocation@1000 : Record 221;var FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :


    LOCAL procedure OnAfterCreateDimTableIDs(var GenJnlAllocation: Record 221; var FieldNo: Integer; var TableID: ARRAY[10] OF Integer; var No: ARRAY[10] OF Code[20])
    begin
    end;

    /*begin
    end.
  */
}




