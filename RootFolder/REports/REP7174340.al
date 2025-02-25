report 7174340 "DP Update def. Prorrata"
{


    Permissions = TableData 254 = rm;
    CaptionML = ENU = 'Update def. Prorrata', ESP = 'Actualizar prorrata definitiva';
    ProcessingOnly = true;

    dataset
    {

        DataItem("VAT Entry"; "VAT Entry")
        {

            DataItemTableView = SORTING("Document No.", "Posting Date");

            ;
            trigger OnPreDataItem();
            BEGIN

                SETRANGE("Posting Date", FechaInicioEjercicio, FechaFinEjercicio);

                Window.OPEN('Calculando prorrata definitiva\' +
                            '#2############################\' +
                            '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                TotalRecNo := COUNT;
                RecNo := 0;
            END;

            trigger OnAfterGetRecord();
            BEGIN

                RecNo := RecNo + 1;
                Window.UPDATE(2, "Entry No.");
                Window.UPDATE(3, ROUND(RecNo / TotalRecNo * 10000, 1));

                VATPostSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                IF "DP Prorrata Type" <> "DP Prorrata Type"::" " THEN BEGIN
                    CASE "VAT Entry".Type OF
                        "VAT Entry".Type::Purchase:
                            BEGIN
                                IF VATPostSetup."VAT Calculation Type" = VATPostSetup."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                                    "DP Def. Prorrata %" := ProrrataDefinitiva;
                                    "DP Prorrata Def. VAT Amount" := 0;
                                    "DP Prorrata Type" := "DP Prorrata Type"::Definitiva;
                                END ELSE BEGIN
                                    "DP Def. Prorrata %" := ProrrataDefinitiva;
                                    "DP Prorrata Def. VAT Amount" := ROUND("DP Original VAT Amount" * (ProrrataDefinitiva / 100), 0.01);
                                    "DP Prorrata Type" := "DP Prorrata Type"::Definitiva;
                                END;
                            END
                        ELSE BEGIN
                            "DP Def. Prorrata %" := ProrrataDefinitiva;
                            "DP Prorrata Def. VAT Amount" := 0;
                            "DP Prorrata Type" := "DP Prorrata Type"::Definitiva;
                        END;
                    END;
                    MODIFY;
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
                group("group307")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("Ejercicio"; "Ejercicio")
                    {

                        CaptionML = ESP = 'Ejercicio';

                        ; trigger OnValidate()
                        BEGIN
                            ValidateEjercicio;
                        END;


                    }
                    field("ProrrataDefinitiva"; "ProrrataDefinitiva")
                    {

                        CaptionML = ESP = 'Prorrata definitiva';
                        Editable = FALSE

    ;
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Txt001@1100286002 :
        Txt001: TextConst ESP = 'Se va a calcular la prorrata definitiva para el ejercicio %1.\¨Confirma que desea continuar?';
        //       Txt002@1100286001 :
        Txt002: TextConst ESP = 'Debe informar un ejercicio para poder ejecutar el proceso';
        //       Txt003@1100286000 :
        Txt003: TextConst ESP = 'La prorrata definitiva para el ejercicio %1 ya se ha calculado. \¨Confirma que desea volver a calcular la prorrata definitiva y sobreescribir los valores anteriores?';
        //       VATPostSetup@1100286014 :
        VATPostSetup: Record 325;
        //       ProrrataDefinitiva@1100286013 :
        ProrrataDefinitiva: Decimal;
        //       Ejercicio@1100286012 :
        Ejercicio: Integer;
        //       FechaInicioEjercicio@1100286011 :
        FechaInicioEjercicio: Date;
        //       FechaFinEjercicio@1100286010 :
        FechaFinEjercicio: Date;
        //       DPProrrataManagement@1100286009 :
        DPProrrataManagement: Codeunit 7174414;
        //       Window@1100286007 :
        Window: Dialog;
        //       TotalRecNo@1100286006 :
        TotalRecNo: Integer;
        //       RecNo@1100286005 :
        RecNo: Integer;
        //       "//20120723GLF - V"@1100286004 :
        "//20120723GLF - V": Integer;
        //       PeriodType@1100286003 :
        PeriodType: Option "A¤o natural","Ejercicio";

    procedure ValidateEjercicio()
    begin
        //DPProrrataManagement.BuscarInicioFinEjercicio(Ejercicio, FechaInicioEjercicio, FechaFinEjercicio);
        //ProrrataDefinitiva := DPProrrataManagement.GetFinalProrrataPercentage(FechaFinEjercicio);
    end;

    procedure ProrrataDefYaCalculada(): Boolean;
    var
        //       VATEntry@1000000000 :
        VATEntry: Record 254;
    begin
        Window.OPEN('Comprobando c lculo prorrata definitiva\' +
                 '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

        VATEntry.SETCURRENTKEY("Document No.", "Posting Date");
        VATEntry.SETRANGE("Posting Date", FechaInicioEjercicio, FechaFinEjercicio);
        VATEntry.SETRANGE("DP Prorrata Type", VATEntry."DP Prorrata Type"::Definitiva);
        if VATEntry.FINDFIRST then begin
            Window.CLOSE;
            exit(TRUE);
        end else begin
            Window.CLOSE;
            exit(FALSE);
        end;
    end;

    /*begin
    //{
//      JAV 21/06/22: - DP 1.00.00 Se a¤ade nuevo report para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
//    }
    end.
  */

}



