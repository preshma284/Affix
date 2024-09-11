tableextension 50163 "QBU Bank Account Posting GroupExt" extends "Bank Account Posting Group"
{


    CaptionML = ENU = 'Bank Account Posting Group', ESP = 'Grupo registro cuenta bancaria';
    LookupPageID = "Bank Account Posting Groups";
    DrillDownPageID = "Bank Account Posting Groups";

    fields
    {
        field(7207272; "QB Confirming Discount Acc."; Code[20])
        {
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Confirming Discount Acc.', ESP = 'Cta. confirming descuento';
            Description = 'QB 1.10.09 JAV 13/01/22: - [TT: Indica la cuenta de registro si la operaci�n ha provenido de un confirming al descuento]';


        }
    }
    keys
    {
        // key(key1;"Code")
        //  {
        /* Clustered=true;
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"Code","G/L Bank Account No.")
        // {
        // 
        // }
        // fieldgroup(Brick;"Code")
        // {
        // 
        // }
    }


    //LOCAL  procedure CheckGLAcc (AccNo@1000 :

    /*
    procedure CheckGLAcc (AccNo: Code[20])
        var
    //       GLAcc@1001 :
          GLAcc: Record 15;
        begin
          if AccNo <> '' then begin
            GLAcc.GET(AccNo);
            GLAcc.CheckGLAcc;
          end;
        end;
    */




    /*
    procedure GetGLBankAccountNo () : Code[20];
        begin
          TESTFIELD("G/L Bank Account No.");
          exit("G/L Bank Account No.");
        end;

        /*begin
        end.
      */
}





