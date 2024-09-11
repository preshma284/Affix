tableextension 50106 "QBU G/L EntryExt" extends "G/L Entry"
{


    CaptionML = ENU = 'G/L Entry', ESP = 'Mov. contabilidad';
    LookupPageID = "General Ledger Entries";
    DrillDownPageID = "General Ledger Entries";

    fields
    {
        field(50000; "Internal"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Internal', ESP = 'Interno';
            Description = '19975';


        }
        field(7174331; "QiuoSII Entity"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SIIEntity"),
                                                                                                   "SII Entity" = CONST(''));
            CaptionML = ENU = 'SII Entity', ESP = 'Entidad SII';
            Description = 'QuoSII_1.4.2.042';


        }
        field(7174390; "DP Original VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Original VAT Amount', ESP = 'Importe IVA Original';
            BlankZero = true;
            Description = 'DP 1.00.00 JAV 23/06/22 y DP 1.00.04 JAV 14/07/22';
            AutoFormatType = 1;


        }
        field(7174391; "DP Non Deductible %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '% IVA no deducible';
            BlankZero = true;
            Description = 'DP 1.00.04 JAV 14/07/22';


        }
        field(7174392; "DP Non Deductible Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe IVA no deducible';
            BlankZero = true;
            Description = 'DP 1.00.04 JAV 14/07/22';


        }
        field(7174393; "DP Prorrata Type"; Option)
        {
            OptionMembers = " ","Provisional","Definitiva";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prorrata Type', ESP = 'Tipo de Prorrata';
            OptionCaptionML = ENU = '" ,Provisional,Final"', ESP = '" ,Provisional,Definitiva"';

            Description = 'DP 1.00.00 JAV 23/06/22';


        }
        field(7174394; "DP Prov. Prorrata %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prov. Prorrata %', ESP = '% Prorrata provisional';
            BlankZero = true;
            Description = 'DP 1.00.00 JAV 23/06/22';


        }
        field(7207270; "QB Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'N� unidad de obra';
            Description = 'QB';


        }
        field(7207271; "QB Expense Note Code"; Code[20])
        {
            CaptionML = ENU = 'Expense Note Code', ESP = 'C�d. Nota gasto';
            Description = 'QB22110';
            Editable = false;


        }
        field(7207272; "QB Destination Entry JV"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";
            CaptionML = ENU = 'Destination Entry JV', ESP = 'UTE mov. destino';
            Description = 'QB';


        }
        field(7207700; "QB Stocks Document Type"; Option)
        {
            OptionMembers = " ","Receipt","Invoice","Return Receipt","Credit Memo","Output Shipment";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type stocks', ESP = 'Stock Tipo Documento';
            OptionCaptionML = ENU = '" ,Receipt,Invoice,Return Receipt,Credit Memo,Output Shipment No."', ESP = '" ,Albaran compra, Factura Compra,Devoluci�n Compra, Abono Compra,Albar�n Salida"';

            Description = 'QB_ST01';


        }
        field(7207701; "QB Stocks Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document No Stocks', ESP = 'Stock Num. Documento';
            Description = 'QB_ST01';


        }
        field(7207702; "QB Stocks Output Shipment Line"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Line Stocks', ESP = 'Stock Linea Documento';
            Description = 'QB_ST01';


        }
        field(7207703; "QB Stocks Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Item No.', ESP = 'No. Producto';
            Description = 'QB_ST01';


        }
        field(7207704; "QB Stocks Output Shipment No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Output Shipment No.', ESP = 'Albar�n de Salida';
            Description = 'QB_ST01';


        }
        field(7207705; "QB Stocks Document Line"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'QB_ST01';


        }
        field(7207706; "QB Activation Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Activado con el C�digo';
            Description = 'QB 1.11.04 En que registro se ha activado';


        }
        field(7207707; "QB Activation Financial Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Activado como Financiero con el C�digo';
            Description = 'QB 1.11.04 Si el registro es el destino de la activaci�n financiera de una general, indica en que registro se ha activado';


        }
    }
    keys
    {
        // key(key1;"Entry No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"G/L Account No.","Posting Date")
        //  {
        /* SumIndexFields="Amount","Debit Amount","Credit Amount","Additional-Currency Amount","Add.-Currency Debit Amount","Add.-Currency Credit Amount","VAT Amount";
  */
        // }
        // key(key3;"G/L Account No.","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date")
        //  {
        /* SumIndexFields="Amount","Debit Amount","Credit Amount","Additional-Currency Amount","Add.-Currency Debit Amount","Add.-Currency Credit Amount","VAT Amount";
  */
        // }
        // key(No4;"G/L Account No.","Business Unit Code","Posting Date")
        // {
        /* SumIndexFields="Amount","Debit Amount","Credit Amount","Additional-Currency Amount","Add.-Currency Debit Amount","Add.-Currency Credit Amount";
  */
        // }
        // key(No5;"G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date")
        // {
        /* SumIndexFields="Amount","Debit Amount","Credit Amount","Additional-Currency Amount","Add.-Currency Debit Amount","Add.-Currency Credit Amount";
  */
        // }
        // key(key6;"Document No.","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key7;"Transaction No.")
        //  {
        /* ;
  */
        // }
        // key(key8;"IC Partner Code")
        //  {
        /* ;
  */
        // }
        // key(key9;"G/L Account No.","Job No.","Posting Date")
        //  {
        /* SumIndexFields="Amount";
  */
        // }
        // key(key10;"Posting Date","G/L Account No.","Dimension Set ID")
        //  {
        /* SumIndexFields="Amount","Additional-Currency Amount";
  */
        // }
        // key(key11;"Gen. Bus. Posting Group","Gen. Prod. Posting Group")
        //  {
        /* ;
  */
        // }
        // key(key12;"VAT Bus. Posting Group","VAT Prod. Posting Group")
        //  {
        /* ;
  */
        // }
        // key(key13;"G/L Account No.","Document No.","Bill No.")
        //  {
        /* SumIndexFields="Amount","Additional-Currency Amount";
  */
        // }
        // key(key14;"G/L Account No.","Description")
        //  {
        /* SumIndexFields="Amount","Additional-Currency Amount";
  */
        // }
        // key(key15;"Document Date","Document Type","Source Type","Source No.")
        //  {
        /* ;
  */
        // }
        // key(key16;"Document No.","Document Date")
        //  {
        /* ;
  */
        // }
        // key(key17;"Posting Date","Transaction No.")
        //  {
        /* ;
  */
        // }
        // key(key18;"Posting Date","Period Trans. No.")
        //  {
        /* ;
  */
        // }
        key(Extkey19; "G/L Account No.", "Global Dimension 2 Code", "Job No.", "Posting Date")
        {
            SumIndexFields = "Amount";
        }
        //key(Extkey20;"QB Activation Code","Job No.","QB Piecework Code","G/L Account No.")
        // {
        /*  SumIndexFields="Amount";
 */
        // }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"Entry No.","Description","G/L Account No.","Posting Date","Document Type","Document No.")
        // {
        // 
        // }
    }

    var
        //       GLSetup@1000 :
        GLSetup: Record 98;
        //       GLSetupRead@1002 :
        GLSetupRead: Boolean;





    /*
    trigger OnInsert();    begin
                   "Last Modified DateTime" := CURRENTDATETIME;
                 end;


    */

    /*
    trigger OnModify();    begin
                   "Last Modified DateTime" := CURRENTDATETIME;
                 end;


    */

    /*
    trigger OnRename();    begin
                   "Last Modified DateTime" := CURRENTDATETIME;
                 end;

    */




    /*
    procedure GetCurrencyCode () : Code[10];
        begin
          if not GLSetupRead then begin
            GLSetup.GET;
            GLSetupRead := TRUE;
          end;
          exit(GLSetup."Additional Reporting Currency");
        end;
    */




    /*
    procedure ShowValueEntries ()
        var
    //       GLItemLedgRelation@1000 :
          GLItemLedgRelation: Record 5823;
    //       ValueEntry@1002 :
          ValueEntry: Record 5802;
    //       TempValueEntry@1001 :
          TempValueEntry: Record 5802 TEMPORARY;
        begin
          GLItemLedgRelation.SETRANGE("G/L Entry No.","Entry No.");
          if GLItemLedgRelation.FINDSET then
            repeat
              ValueEntry.GET(GLItemLedgRelation."Value Entry No.");
              TempValueEntry.INIT;
              TempValueEntry := ValueEntry;
              TempValueEntry.INSERT;
            until GLItemLedgRelation.NEXT = 0;

          PAGE.RUNMODAL(0,TempValueEntry);
        end;
    */




    /*
    procedure ShowDimensions ()
        var
    //       DimMgt@1000 :
          DimMgt: Codeunit 408;
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
        end;
    */



    //     procedure UpdateDebitCredit (Correction@1000 :

    /*
    procedure UpdateDebitCredit (Correction: Boolean)
        begin
          if ((Amount > 0) and (not Correction)) or
             ((Amount < 0) and Correction)
          then begin
            "Debit Amount" := Amount;
            "Credit Amount" := 0
          end else begin
            "Debit Amount" := 0;
            "Credit Amount" := -Amount;
          end;

          if (("Additional-Currency Amount" > 0) and (not Correction)) or
             (("Additional-Currency Amount" < 0) and Correction)
          then begin
            "Add.-Currency Debit Amount" := "Additional-Currency Amount";
            "Add.-Currency Credit Amount" := 0
          end else begin
            "Add.-Currency Debit Amount" := 0;
            "Add.-Currency Credit Amount" := -"Additional-Currency Amount";
          end;
        end;
    */



    //     procedure CopyFromGenJnlLine (GenJnlLine@1000 :

    /*
    procedure CopyFromGenJnlLine (GenJnlLine: Record 81)
        begin
          "Posting Date" := GenJnlLine."Posting Date";
          "Document Date" := GenJnlLine."Document Date";
          "Document Type" := GenJnlLine."Document Type";
          "Document No." := GenJnlLine."Document No.";
          "External Document No." := GenJnlLine."External Document No.";
          Description := GenJnlLine.Description;
          "Business Unit Code" := GenJnlLine."Business Unit Code";
          "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
          "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
          "Dimension Set ID" := GenJnlLine."Dimension Set ID";
          "Source Code" := GenJnlLine."Source Code";
          if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" then begin
            if GenJnlLine."Source Type" = GenJnlLine."Source Type"::Employee then
              "Source Type" := "Source Type"::Employee
            else
              "Source Type" := GenJnlLine."Source Type";
            "Source No." := GenJnlLine."Source No.";
          end else begin
            if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee then
              "Source Type" := "Source Type"::Employee
            else
              "Source Type" := GenJnlLine."Account Type";
            "Source No." := GenJnlLine."Account No.";
          end;
          if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"IC Partner") or
             (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"IC Partner")
          then
            "Source Type" := "Source Type"::" ";
          "Job No." := GenJnlLine."Job No.";
          Quantity := GenJnlLine.Quantity;
          "Journal Batch Name" := GenJnlLine."Journal Batch Name";
          "Reason Code" := GenJnlLine."Reason Code";
          "User ID" := USERID;
          "No. Series" := GenJnlLine."Posting No. Series";
          "IC Partner Code" := GenJnlLine."IC Partner Code";
          "Bill No." := GenJnlLine."Bill No.";

          OnAfterCopyGLEntryFromGenJnlLine(Rec,GenJnlLine);
        end;
    */



    //     procedure CopyPostingGroupsFromGLEntry (GLEntry@1000 :

    /*
    procedure CopyPostingGroupsFromGLEntry (GLEntry: Record 17)
        begin
          "Gen. Posting Type" := GLEntry."Gen. Posting Type";
          "Gen. Bus. Posting Group" := GLEntry."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := GLEntry."Gen. Prod. Posting Group";
          "VAT Bus. Posting Group" := GLEntry."VAT Bus. Posting Group";
          "VAT Prod. Posting Group" := GLEntry."VAT Prod. Posting Group";
          "Tax Area Code" := GLEntry."Tax Area Code";
          "Tax Liable" := GLEntry."Tax Liable";
          "Tax Group Code" := GLEntry."Tax Group Code";
          "Use Tax" := GLEntry."Use Tax";
        end;
    */



    //     procedure CopyPostingGroupsFromVATEntry (VATEntry@1001 :

    /*
    procedure CopyPostingGroupsFromVATEntry (VATEntry: Record 254)
        begin
          "Gen. Posting Type" := VATEntry.Type;
          "Gen. Bus. Posting Group" := VATEntry."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := VATEntry."Gen. Prod. Posting Group";
          "VAT Bus. Posting Group" := VATEntry."VAT Bus. Posting Group";
          "VAT Prod. Posting Group" := VATEntry."VAT Prod. Posting Group";
          "Tax Area Code" := VATEntry."Tax Area Code";
          "Tax Liable" := VATEntry."Tax Liable";
          "Tax Group Code" := VATEntry."Tax Group Code";
          "Use Tax" := VATEntry."Use Tax";
        end;
    */



    //     procedure CopyPostingGroupsFromGenJnlLine (GenJnlLine@1000 :

    /*
    procedure CopyPostingGroupsFromGenJnlLine (GenJnlLine: Record 81)
        begin
          "Gen. Posting Type" := GenJnlLine."Gen. Posting Type";
          "Gen. Bus. Posting Group" := GenJnlLine."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := GenJnlLine."Gen. Prod. Posting Group";
          "VAT Bus. Posting Group" := GenJnlLine."VAT Bus. Posting Group";
          "VAT Prod. Posting Group" := GenJnlLine."VAT Prod. Posting Group";
          "Tax Area Code" := GenJnlLine."Tax Area Code";
          "Tax Liable" := GenJnlLine."Tax Liable";
          "Tax Group Code" := GenJnlLine."Tax Group Code";
          "Use Tax" := GenJnlLine."Use Tax";
        end;
    */



    //     procedure CopyPostingGroupsFromDtldCVBuf (DtldCVLedgEntryBuf@1001 : Record 383;GenPostingType@1002 :

    /*
    procedure CopyPostingGroupsFromDtldCVBuf (DtldCVLedgEntryBuf: Record 383;GenPostingType: Option " ","Purchase","Sale","Settlemen")
        begin
          "Gen. Posting Type" := GenPostingType;
          "Gen. Bus. Posting Group" := DtldCVLedgEntryBuf."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := DtldCVLedgEntryBuf."Gen. Prod. Posting Group";
          "VAT Bus. Posting Group" := DtldCVLedgEntryBuf."VAT Bus. Posting Group";
          "VAT Prod. Posting Group" := DtldCVLedgEntryBuf."VAT Prod. Posting Group";
          "Tax Area Code" := DtldCVLedgEntryBuf."Tax Area Code";
          "Tax Liable" := DtldCVLedgEntryBuf."Tax Liable";
          "Tax Group Code" := DtldCVLedgEntryBuf."Tax Group Code";
          "Use Tax" := DtldCVLedgEntryBuf."Use Tax";
        end;
    */



    //     LOCAL procedure OnAfterCopyGLEntryFromGenJnlLine (var GLEntry@1000 : Record 17;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnAfterCopyGLEntryFromGenJnlLine (var GLEntry: Record 17;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     procedure CopyFromDeferralPostBuffer (DeferralPostBuffer@1001 :

    /*
    procedure CopyFromDeferralPostBuffer (DeferralPostBuffer: Record 1706)
        begin
          "System-Created Entry" := DeferralPostBuffer."System-Created Entry";
          "Gen. Posting Type" := DeferralPostBuffer."Gen. Posting Type";
          "Gen. Bus. Posting Group" := DeferralPostBuffer."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := DeferralPostBuffer."Gen. Prod. Posting Group";
          "VAT Bus. Posting Group" := DeferralPostBuffer."VAT Bus. Posting Group";
          "VAT Prod. Posting Group" := DeferralPostBuffer."VAT Prod. Posting Group";
          "Tax Area Code" := DeferralPostBuffer."Tax Area Code";
          "Tax Liable" := DeferralPostBuffer."Tax Liable";
          "Tax Group Code" := DeferralPostBuffer."Tax Group Code";
          "Use Tax" := DeferralPostBuffer."Use Tax";
        end;
    */




    /*
    procedure UpdateAccountID ()
        var
    //       GLAccount@1000 :
          GLAccount: Record 15;
        begin
          if "G/L Account No." = '' then begin
            CLEAR("Account Id");
            exit;
          end;

          if not GLAccount.GET("G/L Account No.") then
            exit;

          "Account Id" := GLAccount.Id;
        end;
    */



    /*
    LOCAL procedure UpdateAccountNo ()
        var
    //       GLAccount@1001 :
          GLAccount: Record 15;
        begin
          if ISNULLGUID("Account Id") then
            exit;

          GLAccount.SETRANGE(Id,"Account Id");
          if not GLAccount.FINDFIRST then
            exit;

          "G/L Account No." := GLAccount."No.";
        end;
    */




    procedure GetName(): Text[50];
    var
        //       Cust@1000000000 :
        Cust: Record 18;
        //       Vend@1000000001 :
        Vend: Record 23;
        //       Bank@1000000002 :
        Bank: Record 270;
        //       Nombre@1000000003 :
        Nombre: Text[50];
    begin
        //JMMA 02/10/20: Retorna el nombre del cliente, proveedor o banco asociado al movimiento
        Nombre := '';
        CASE Rec."Source Type" OF
            Rec."Source Type"::Customer:
                if Cust.GET("Source No.") then
                    Nombre := Cust.Name;
            Rec."Source Type"::Vendor:
                if Vend.GET("Source No.") then
                    Nombre := Vend.Name;
            Rec."Source Type"::"Bank Account":
                if Bank.GET("Source No.") then
                    Nombre := Bank.Name;
        end;
        exit(Nombre)
    end;

    /*begin
    //{
//      AML         : - QB_ST01 A�adidos campos para controlar la variaci�n de existencias.
//      CPA 29/03/22: - (Q16867) Mejora de rendimiento. Nueva clave: "G/L Account No.,Global Dimension 2 Code,Job No.,Posting Date"
//      JAV 21/06/22: - DP 1.00.00 Se a�aden los campos para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
//                                    7174390 "DP Prorrata"
//                                    7174391 "DP Prov. Prorrata %"
//                                    7174392 "DP Prorrata Orig. VAT Amount"
//      JAV 14/07/22: - DP 1.00.04 Se cambia el caption del campo 7174392 por "DP Orig. VAT Amount" para que sea com�n a Prorrata y No deducible
//                                 Se a�aden los campos 7174395 y 7174396
//      JAV 06/10/22: - QB 1.12.00 Se a�aden campos "QB Activation Code" y "QB Activation Financial".
//                                 15/11/22 Se a�ade la key "QB Activation Code","Job No.","QB Piecework Code","G/L Account No." para acelerar b�squedas.
//                                 18/11/22 Se cambia el campo 7207707 "QB Activation Financial" de boolean a code para guardar en que mes pas� de gesti� a financiero
//    }
    end.
  */
}





