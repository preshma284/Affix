table 7238753 "QBU Budget Item Control"
{


    // LookupPageID=Page7220330;
    // DrillDownPageID=Page7220330;

    fields
    {
        field(1; "QB_Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Proyecto';


        }
        field(2; "QB_PieceWork No."; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Partida presupuestaria';


        }
        field(3; "QB_Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� L�nea';


        }
        field(4; "QB_Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Documento';


        }
        field(5; "QB_Budget Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�digo Presupuesto';


        }
        field(10; "QB_Type"; Option)
        {
            OptionMembers = "Budget","Order","Receipt","Receipt Invoice","Direct Invoice","Return","Return Shipment","Return Shipment Credit Memo","Direct Credit Memo","Journal Line";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo';
            OptionCaptionML = ESP = 'Presupuesto,Pedido,Albar�n,Factura albar�n,Factura directa,Devoluci�n,Env�o devoluci�n,Abono env�o devoluci�n,Abono directo,Diario';



        }
        field(11; "QB_Budget Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Presupuesto';


        }
        field(12; "QB_Not Committed"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'No comprometido';


        }
        field(13; "QB_Committed Not Realized"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comprometido no realizado';


        }
        field(14; "QB_Realized Not Invoiced"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Realizado no facturado';


        }
        field(15; "QB_Executed"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ejecutado';


        }
        field(20; "QB_Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Mov.';


        }
    }
    keys
    {
        key(key1; "QB_Entry No.")
        {
            ;
        }
        key(key2; "QB_Job No.", "QB_Budget Code", "QB_PieceWork No.", "QB_Line No.")
        {
            Clustered = true;
        }
        key(key3; "QB_Job No.", "QB_Budget Code", "QB_PieceWork No.", "QB_Type")
        {
            SumIndexFields = "QB_Committed Not Realized", "QB_Realized Not Invoiced", "QB_Executed";
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "QB_Job No.", "QB_Budget Code", "QB_PieceWork No.")
        {

        }
        fieldgroup(Brick; "QB_Job No.", "QB_Budget Code", "QB_PieceWork No.")
        {

        }
    }

    var
        //       BudgetItemControl@1100286000 :
        BudgetItemControl: Record 7238753;
        //       QREFunctions@1100286001 :
        QREFunctions: Codeunit 7238197;



    trigger OnInsert();
    begin
        BudgetItemControl.RESET();
        BudgetItemControl.SETRANGE("QB_Job No.", Rec."QB_Job No.");
        BudgetItemControl.SETRANGE("QB_PieceWork No.", Rec."QB_PieceWork No.");
        //RE15469-LCG-210122-INI
        BudgetItemControl.SETRANGE("QB_Budget Code", Rec."QB_Budget Code");
        //RE15469-LCG-210122-FIN
        if BudgetItemControl.FINDLAST then
            Rec."QB_Line No." := BudgetItemControl."QB_Line No." + 10000
        else
            Rec."QB_Line No." := 10000;

        Rec."QB_Not Committed" := Rec."QB_Budget Amount" - (Rec."QB_Committed not Realized" + Rec."QB_Realized not Invoiced" + Rec.QB_Executed);

        if Rec."QB_Entry No." = 0 then begin
            BudgetItemControl.RESET;
            if BudgetItemControl.FINDLAST then
                Rec."QB_Entry No." := BudgetItemControl."QB_Entry No." + 1
            else
                Rec."QB_Entry No." := 1;
        end;
        //Insertamos una l�nea en QPR Amounts si es tipo Budget, para que siga la funcionalidad desarrollada en QB.
        if Rec.QB_Type = Rec.QB_Type::Budget then
            InsertCostLineNo(Rec);
    end;

    trigger OnModify();
    var
        //                liBudgetItemControl@1100286000 :
        liBudgetItemControl: Record 7238753;
    begin
        if Rec.QB_Type <> Rec.QB_Type::Budget then begin
            BudgetItemControl.RESET();
            BudgetItemControl.SETCURRENTKEY("QB_Job No.", "QB_Budget Code", "QB_PieceWork No.", QB_Type);
            BudgetItemControl.SETRANGE("QB_Job No.", Rec."QB_Job No.");
            BudgetItemControl.SETRANGE("QB_Budget Code", Rec."QB_Budget Code");
            BudgetItemControl.SETRANGE("QB_PieceWork No.", Rec."QB_PieceWork No.");
            BudgetItemControl.SETFILTER(QB_Type, '<>%1', BudgetItemControl.QB_Type::Budget);
            //if BudgetItemControl.FINDSET then;
            BudgetItemControl.CALCSUMS("QB_Committed not Realized", "QB_Realized not Invoiced", QB_Executed);

            liBudgetItemControl.RESET();
            liBudgetItemControl.SETRANGE("QB_Job No.", BudgetItemControl."QB_Job No.");
            liBudgetItemControl.SETRANGE("QB_Budget Code", Rec."QB_Budget Code");
            liBudgetItemControl.SETRANGE("QB_PieceWork No.", BudgetItemControl."QB_PieceWork No.");
            liBudgetItemControl.SETRANGE(QB_Type, liBudgetItemControl.QB_Type::Budget);
            if liBudgetItemControl.FINDFIRST then begin
                liBudgetItemControl."QB_Committed not Realized" := BudgetItemControl."QB_Committed not Realized" + Rec."QB_Committed not Realized";
                liBudgetItemControl."QB_Realized not Invoiced" := BudgetItemControl."QB_Realized not Invoiced" + Rec."QB_Realized not Invoiced";
                liBudgetItemControl.QB_Executed := BudgetItemControl.QB_Executed + Rec.QB_Executed;
                liBudgetItemControl."QB_Not Committed" := liBudgetItemControl."QB_Budget Amount" - (liBudgetItemControl."QB_Committed not Realized" + liBudgetItemControl."QB_Realized not Invoiced"
                + liBudgetItemControl.QB_Executed);
                liBudgetItemControl.MODIFY();
            end;
        end;
    end;



    // LOCAL procedure InsertCostLineNo (Rec@1100286000 :
    LOCAL procedure InsertCostLineNo(Rec: Record 7238753)
    var
        //       lBudgetItemControl@1100286001 :
        lBudgetItemControl: Record 7238753;
        //       QPRAmounts@1100286002 :
        QPRAmounts: Record 7207383;
        //       LastQPRAmounts@1100286003 :
        LastQPRAmounts: Record 7207383;
    begin
        QPRAmounts.RESET();
        QPRAmounts.SETRANGE("Job No.", Rec."QB_Job No.");
        QPRAmounts.SETRANGE("Budget Code", Rec."QB_Budget Code");
        QPRAmounts.SETRANGE("Piecework code", "QB_PieceWork No.");
        QPRAmounts.SETRANGE(Type, QPRAmounts.Type::Cost);
        if not QPRAmounts.ISEMPTY then
            QPRAmounts.DELETEALL();

        QPRAmounts.INIT;
        QPRAmounts."Job No." := Rec."QB_Job No.";
        QPRAmounts."Budget Code" := Rec."QB_Budget Code";

        LastQPRAmounts.RESET;
        LastQPRAmounts.SETCURRENTKEY("Entry No.");
        if LastQPRAmounts.FINDLAST then
            QPRAmounts."Entry No." := LastQPRAmounts."Entry No." + 1
        else
            QPRAmounts."Entry No." := 1;

        QPRAmounts."Piecework code" := Rec."QB_PieceWork No.";
        QPRAmounts.Type := QPRAmounts.Type::Cost;
        QPRAmounts."Cost Amount" := Rec."QB_Budget Amount";
        QPRAmounts."Expected Date" := WORKDATE;
        QPRAmounts.INSERT();
    end;

    /*begin
    //{
//      RE15469-LCG-210122- Insertar n� l�nea por proyecto, partida y c�d. presupuesto.
//    }
    end.
  */
}







