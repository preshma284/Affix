report 7207313 "Relation Expense Notes"
{


    ;
    dataset
    {

        DataItem("Hist. Expense Notes Header"; "Hist. Expense Notes Header")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.", "Employee", "Posting Date";
            Column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
                //SourceExpr=FORMAT(TODAY,0,4);
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(Hist__Cab__notas_gastos__N__; "No.")
            {
                //SourceExpr="No.";
            }
            Column(Hist__Cab__notas_gastos__Fecha_registro_; "Posting Date")
            {
                //SourceExpr="Posting Date";
            }
            Column(Hist__Cab__notas_gastos__Descripcion_gasto_; "Hist. Expense Notes Header"."Expense Description")
            {
                //SourceExpr="Hist. Expense Notes Header"."Expense Description";
            }
            Column(Hist__Cab__notas_gastos__Texto_de_registro_; "Posting Description")
            {
                //SourceExpr="Posting Description";
            }
            Column(Hist__Cab__notas_gastos__Shortcut_Dimension_1_Code_; "Shortcut Dimension 1 Code")
            {
                //SourceExpr="Shortcut Dimension 1 Code";
            }
            Column(Nombre; RecEmpleado.Name)
            {
                //SourceExpr=RecEmpleado.Name;
            }
            Column(DecImporte; DecImporte)
            {
                //SourceExpr=DecImporte;
                AutoFormatType = 1;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(Nota_de_gastos_de_viajes_para_eventosCaption; Nota_de_gastos_de_viajes_para_eventosCaptionLbl)
            {
                //SourceExpr=Nota_de_gastos_de_viajes_para_eventosCaptionLbl;
            }
            Column(Hist__Cab__notas_gastos__N__Caption; FIELDCAPTION("No."))
            {
                //SourceExpr=FIELDCAPTION("No.");
            }
            Column(Hist__Cab__notas_gastos__Fecha_registro_Caption; FIELDCAPTION("Posting Date"))
            {
                //SourceExpr=FIELDCAPTION("Posting Date");
            }
            Column(Hist__Cab__notas_gastos__Descripcion_gasto_Caption; FIELDCAPTION("Expense Description"))
            {
                //SourceExpr=FIELDCAPTION("Expense Description");
            }
            Column(Hist__Cab__notas_gastos__Texto_de_registro_Caption; FIELDCAPTION("Posting Description"))
            {
                //SourceExpr=FIELDCAPTION("Posting Description");
            }
            Column(Hist__Cab__notas_gastos__Shortcut_Dimension_1_Code_Caption; FIELDCAPTION("Shortcut Dimension 1 Code"))
            {
                //SourceExpr=FIELDCAPTION("Shortcut Dimension 1 Code");
            }
            Column(EmpleadoCaption; EmpleadoCaptionLbl)
            {
                //SourceExpr=EmpleadoCaptionLbl;
            }
            Column(Importe_totalCaption; Importe_totalCaptionLbl)
            {
                //SourceExpr=Importe_totalCaptionLbl ;
            }
            trigger OnAfterGetRecord();
            BEGIN
                RecEmpleado.GET(Employee);
                DecImporte := 0;
                RecLinNotaGastos.SETRANGE("Document No.", "No.");
                IF RecLinNotaGastos.FINDSET(FALSE, FALSE) THEN
                    REPEAT
                        DecImporte := DecImporte + RecLinNotaGastos."Total Amount";
                    UNTIL RecLinNotaGastos.NEXT = 0;
            END;


        }
    }
    requestpage
    {

        layout
        {
        }
    }
    labels
    {
    }

    var
        //       RecEmpleado@7001100 :
        RecEmpleado: Record 5200;
        //       RecLinNotaGastos@7001102 :
        RecLinNotaGastos: Record 7207324;
        //       DecImporte@7001101 :
        DecImporte: Decimal;
        //       TotalImporte@7001103 :
        TotalImporte: Decimal;
        //       CurrReport_PAGENOCaptionLbl@7001104 :
        CurrReport_PAGENOCaptionLbl: TextConst ESP = 'P gina';
        //       Nota_de_gastos_de_viajes_para_eventosCaptionLbl@7001105 :
        Nota_de_gastos_de_viajes_para_eventosCaptionLbl: TextConst ESP = 'Nota de gastos de viajes para eventos';
        //       EmpleadoCaptionLbl@7001106 :
        EmpleadoCaptionLbl: TextConst ESP = 'Empleado';
        //       Importe_totalCaptionLbl@7001107 :
        Importe_totalCaptionLbl: TextConst ESP = 'Total';

    /*begin
    {
      JAV 26/03/19: - Se ponen las variables y constantes globales y se cambian variables para que al menos compile
    }
    end.
  */

}



