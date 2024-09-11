report 7207323 "Guarantee Register Expenses"
{
    ApplicationArea = All;



    CaptionML = ENU = 'Guarantee Register Expenses', ESP = 'Registro de gastos de Garant�as';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Guarantee"; "Guarantee")
        {



            RequestFilterFields = "No.";
            trigger OnAfterGetRecord();
            BEGIN
                Date := Guarantee."Date of last expenses calc";
                IF (Date = 0D) THEN
                    Date := Guarantee."Definitive Date of Issue";
                IF (Date = 0D) THEN
                    Date := Guarantee."Provisional Date of Issue";

                IF (Guarantee."Provisional Status" = Guarantee."Provisional Status"::Deposited) THEN BEGIN
                    Formula := Guarantee."Provisional Months payment";
                    Amount := Guarantee."Provisional Amount";
                    LineType := 0;
                END ELSE BEGIN
                    Formula := Guarantee."Definitive Months payment";
                    Amount := Guarantee."Definitive Amount";
                    LineType := 1;
                END;

                IF (FORMAT(Formula) <> '') AND (Amount <> 0) THEN BEGIN
                    REPEAT
                        Date := CALCDATE(Formula, Date);
                        IF (Date <= LastCalcDate) THEN BEGIN
                            CrearLineas(Guarantee, LineType, Date);
                            Guarantee."Date of last expenses calc" := Date;
                            Guarantee.MODIFY;
                        END;
                    UNTIL (Date > LastCalcDate);
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
                group("group493")
                {

                    CaptionML = ESP = 'Opciones';
                    field("LastCalcDate"; "LastCalcDate")
                    {

                        CaptionML = ESP = 'Hasta que fecha se calculan';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       LastCalcDate@1100286002 :
        LastCalcDate: Date;
        //       QuoBuildingSetup@1100286011 :
        QuoBuildingSetup: Record 7207278;
        //       GuaranteeLines@1100286010 :
        GuaranteeLines: Record 7207442;
        //       GuaranteeType@1100286009 :
        GuaranteeType: Record 7207443;
        //       GenJournalLine@1100286008 :
        GenJournalLine: Record 81;
        //       cuGuarantees@1100286000 :
        cuGuarantees: Codeunit 7207355;
        //       JobGLJournal@1100286013 :
        JobGLJournal: Page 1020;
        //       Date@1100286005 :
        Date: Date;
        //       Formula@1100286003 :
        Formula: DateFormula;
        //       Amount@1100286001 :
        Amount: Decimal;
        //       LineType@1100286006 :
        LineType: Option;
        //       Job@1100286007 :
        Job: Record 167;
        //       Line@1100286004 :
        Line: Integer;
        //       Txt010@1100286012 :
        Txt010: TextConst ESP = 'Existen %3 l�neas en el diario %1 secci�n %2, �desea eliminarlas?';
        //       Txt001@1100286014 :
        Txt001: TextConst ESP = 'No se han generado l�neas de intereses';



    trigger OnInitReport();
    begin
        LastCalcDate := TODAY;
    end;

    trigger OnPreReport();
    begin
        QuoBuildingSetup.GET();

        //Miro si hay l�neas en el diario, si solo hay una asumo que es la creada autom�ticamente al registrar el diario
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Jobs Book");
        GenJournalLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Jobs Batch Book");
        if (GenJournalLine.COUNT > 1) then
            if (not CONFIRM(Txt010, TRUE, QuoBuildingSetup."Jobs Book", QuoBuildingSetup."Jobs Batch Book", GenJournalLine.COUNT)) then
                ERROR('');
        GenJournalLine.DELETEALL;

        Line := 0;
    end;

    trigger OnPostReport();
    begin
        //Registrar el diario
        if (Line = 0) then
            MESSAGE(Txt001)
        else
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJournalLine);
    end;



    // procedure CrearLineas (var pGuarantee@1100286002 : Record 7207441;pTipo@1100286000 : 'Provisional,Definitivo';pPostingDate@1100286001 :
    procedure CrearLineas(var pGuarantee: Record 7207441; pTipo: Option "Provisional","Definitivo"; pPostingDate: Date)
    begin
        GuaranteeType.GET(pGuarantee.Type);

        //Creo la l�nea de la garant�a donde se refleja
        GuaranteeLines.INIT;
        GuaranteeLines."No." := pGuarantee."No.";
        GuaranteeLines.INSERT(TRUE);

        CASE pTipo OF
            pTipo::Provisional:
                begin
                    Job.GET(pGuarantee."Quote No.");
                    GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::ProvGastos;
                    GuaranteeLines."Financial Amount" := pGuarantee."Provisional Amount per period";
                end;
            pTipo::Definitivo:
                begin
                    Job.GET(pGuarantee."Job No.");
                    GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::DefGastos;
                    GuaranteeLines."Financial Amount" := pGuarantee."Definitive Amount per period";
                end;
        end;
        GuaranteeLines.Descripción := 'Gastos peri�dicos de la garant�a ' + pGuarantee."No.";
        GuaranteeLines.Date := pPostingDate;
        GuaranteeLines.User := USERID;
        GuaranteeLines."Document No." := pGuarantee."No." + '-' + FORMAT(GuaranteeLines."Line No.");
        GuaranteeLines.MODIFY;

        //Creo la unidad de obra para registrar la l�nea
        cuGuarantees.AddPieceworkCnt(Job."No.", QuoBuildingSetup."Guarantee Piecework Unit");

        //Creo la l�nea del banco
        Line += 10000;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := QuoBuildingSetup."Jobs Book";
        GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Jobs Batch Book";
        GenJournalLine."Line No." := Line;

        GenJournalLine."Posting Date" := GuaranteeLines.Date;
        GenJournalLine."Document No." := GuaranteeLines."Document No.";
        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"Bank Account");
        GenJournalLine.VALIDATE("Account No.", GuaranteeType."Bank Account No.");
        GenJournalLine.VALIDATE(Description, GuaranteeLines.Descripción);
        GenJournalLine.VALIDATE(Amount, -GuaranteeLines."Financial Amount");
        GenJournalLine.VALIDATE("Dimension Set ID", cuGuarantees.GetIdDimension(Job."No.", QuoBuildingSetup."Guarantee Analitical Concept"));
        GenJournalLine.INSERT;

        //Contrapartida por el gasto
        Line += 10000;
        GenJournalLine."Line No." := Line;
        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.VALIDATE("Account No.", GuaranteeType."Account for Expenses");
        GenJournalLine.VALIDATE(Description, GuaranteeLines.Descripción);
        GenJournalLine.VALIDATE(Amount, GuaranteeLines."Financial Amount");
        GenJournalLine.VALIDATE("Job No.", Job."No.");
        GenJournalLine.VALIDATE("Piecework Code", QuoBuildingSetup."Guarantee Piecework Unit");
        GenJournalLine.VALIDATE("Dimension Set ID", cuGuarantees.GetIdDimension(Job."No.", QuoBuildingSetup."Guarantee Analitical Concept"));
        GenJournalLine.INSERT;

        //Descontar de la previsi�n
        cuGuarantees.AddForecast(Job, GuaranteeType, 3, -GuaranteeLines."Financial Amount");
    end;

    /*begin
    end.
  */

}




