report 7207283 "Production Daily Calculate"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Calculate Production Jobs', ESP = 'Calcular producci¢n proyectos';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.")
                                 ORDER(Ascending)
                                 WHERE("Production Calculate Mode" = FILTER("Lump Sums" | "Production by Piecework" | "Administration" | "Free"), "Blocked" = CONST(" "), "Job Type" = FILTER(<> 'Deviations'));


            RequestFilterFields = "No.", "Job Posting Group", "Status";
            trigger OnPreDataItem();
            BEGIN
                Job.SETRANGE("Job Type", Job."Job Type"::Operative);
                Job.SETRANGE("Card Type", Job."Card Type"::"Proyecto operativo");
            END;

            trigger OnAfterGetRecord();
            BEGIN
                Window.UPDATE(1, "No." + ' ' + Description);

                ProductionDailyLine.INIT;
                ProductionDailyLine.VALIDATE("Daily Book Name", opcBook);
                ProductionDailyLine.SetUpNewLine(opcBook);
                ProductionDailyLine.VALIDATE("Posting Date", opcPostingDate);
                ProductionDailyLine.VALIDATE("Job No.", Job."No.");

                IF (opcNumDoc <> '') THEN
                    ProductionDailyLine."Document No." := opcNumDoc;

                IF (ProductionDailyLine."Job in Progress" <> 0) THEN
                    ProductionDailyLine.INSERT(TRUE);

                LastProductionDailyLine := ProductionDailyLine;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group404")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("opcBook"; "opcBook")
                    {

                        CaptionML = ENU = 'Book', ESP = 'Libro';

                        ; trigger OnValidate()
                        BEGIN
                            IF NOT DailyBookProduction.GET(opcBook) THEN
                                ERROR(Text001, opcBook);
                        END;

                        trigger OnLookup(var Text: Text): Boolean
                        BEGIN
                            CLEAR(ProductionDailyBook);
                            IF DailyBookProduction.GET(opcBook) THEN;
                            ProductionDailyBook.SETRECORD(DailyBookProduction);
                            ProductionDailyBook.LOOKUPMODE(TRUE);
                            IF ProductionDailyBook.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                ProductionDailyBook.GETRECORD(DailyBookProduction);
                                Text := DailyBookProduction.Name;
                                EXIT(TRUE);
                            END ELSE
                                EXIT(FALSE);
                        END;


                    }
                    field("opcPostingDate"; "opcPostingDate")
                    {

                        CaptionML = ENU = 'Posting Date', ESP = 'Fecha de registro';
                    }
                    field("opcNumDoc"; "opcNumDoc")
                    {

                        CaptionML = ENU = 'No. Document', ESP = 'N§ de documento';
                    }
                    field("opcPosting"; "opcPosting")
                    {

                        CaptionML = ENU = 'Register Daily', ESP = 'Registrar diario';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       ProductionDailyLine@1100286005 :
        ProductionDailyLine: Record 7207327;
        //       LastProductionDailyLine@1100286004 :
        LastProductionDailyLine: Record 7207327;
        //       DailyBookProduction@1100286001 :
        DailyBookProduction: Record 7207326;
        //       ProductionDailySection@1100286000 :
        ProductionDailySection: Page 7207326;
        //       ProductionDailyBook@1100286002 :
        ProductionDailyBook: Page 7207327;
        //       ProductionDayManagement@1100286006 :
        ProductionDayManagement: Codeunit 7207280;
        //       DayProductionRegister@1100286003 :
        DayProductionRegister: Codeunit 7207285;
        //       Text003@7001104 :
        Text003: TextConst ENU = 'You must select a Production Book.', ESP = 'Debe seleccionar un Libro de Producci¢n.';
        //       Text005@7001102 :
        Text005: TextConst ENU = 'You must specify the registration date.', ESP = 'Debe especificar la fecha de registro.';
        //       Text006@7001101 :
        Text006: TextConst ENU = 'Specify Document No..', ESP = 'Especifique N§ de Documento.';
        //       Text000@7001105 :
        Text000: TextConst ENU = 'Calculated Production', ESP = 'Calculando Producci¢n';
        //       Window@7001110 :
        Window: Dialog;
        //       NumberLine@7001113 :
        NumberLine: Integer;
        //       Text001@7001119 :
        Text001: TextConst ENU = 'There is no Production Book %1.', ESP = 'No existe el Libro de Producci¢n %1.';
        //       Text002@7001120 :
        Text002: TextConst ENU = 'There is no section %1 for Production Book %2.', ESP = 'No existe la secci¢n %1 para el Libro de Producci¢n %2.';
        //       "------------------------------- Opciones"@1100286008 :
        "------------------------------- Opciones": Integer;
        //       opcBook@1100286009 :
        opcBook: Code[20];
        //       opcPostingDate@1100286010 :
        opcPostingDate: Date;
        //       opcNumDoc@1100286011 :
        opcNumDoc: Code[20];
        //       opcPosting@1100286012 :
        opcPosting: Boolean;



    trigger OnInitReport();
    begin
        opcBook := ProductionDayManagement.SelectBook(ProductionDailyLine);
        opcPostingDate := CALCDATE('-1m+pm', TODAY);
        COMMIT;  //JAV 03/02/21 - QB 1.07.08 Para evitar un error de runmodal que no se porque se produce
    end;

    trigger OnPreReport();
    begin
        if opcBook = '' then
            ERROR(Text003);

        if opcPostingDate = 0D then
            ERROR(Text005);

        DailyBookProduction.GET(opcBook);
        if ((opcNumDoc = '') and (DailyBookProduction."Serie No." = '')) then
            ERROR(Text006);

        NumberLine := FindNumber;

        Window.OPEN(Text000 + ' #1################');
    end;

    trigger OnPostReport();
    begin
        COMMIT;
        if opcPosting then
            DayProductionRegister.RUN(ProductionDailyLine);
    end;



    procedure FindNumber(): Integer;
    var
        //       ProductionDailyLine@1000000000 :
        ProductionDailyLine: Record 7207327;
    begin
        ProductionDailyLine.RESET;
        ProductionDailyLine.SETRANGE("Daily Book Name", opcBook);
        if ProductionDailyLine.FINDFIRST then
            exit(ProductionDailyLine."Line No.")
        else
            exit(0);
    end;

    /*begin
    end.
  */

}




