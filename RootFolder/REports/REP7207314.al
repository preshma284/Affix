report 7207314 "PIT Withholdings"
{



    dataset
    {

        DataItem("Withholding Movements"; "Withholding Movements")
        {

            DataItemTableView = SORTING("Withholding Code", "No.", "Posting Date")
                                 WHERE("Type" = CONST("Vendor"), "Withholding Type" = CONST("PIT"));


            RequestFilterFields = "Withholding Code", "No.", "Posting Date";
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
                //SourceExpr=FORMAT(TODAY,0,4);
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(txtFiltro; txtFilter)
            {
                //SourceExpr=txtFilter;
            }
            Column(recTipoRetencion_Descripcion; recWithholdingType.Description)
            {
                //SourceExpr=recWithholdingType.Description;
            }
            Column(intContador; intCount)
            {
                //SourceExpr=intCount;
            }
            Column(recProveedor__VAT_Registration_No__; recVendor."VAT Registration No.")
            {
                //SourceExpr=recVendor."VAT Registration No.";
            }
            Column(recProveedor_Name; recVendor.Name)
            {
                //SourceExpr=recVendor.Name;
            }
            Column(Mov__retencion__Amount__LCY__; "Amount (LCY)")
            {
                //SourceExpr="Amount (LCY)";
            }
            Column(recProveedor__Country_Region_Code_; recVendor."Country/Region Code")
            {
                //SourceExpr=recVendor."Country/Region Code";
            }
            Column(Mov__retencion_Amount; Amount)
            {
                //SourceExpr=Amount;
            }
            Column(Mov__retencion__Base_de_retencion__DL__; "Withholding Movements"."Withholding Base (LCY)")
            {
                //SourceExpr="Withholding Movements"."Withholding Base (LCY)";
            }
            Column(Mov__retencion__Base_de_retencion_; "Withholding Movements"."Withholding Base")
            {
                //SourceExpr="Withholding Movements"."Withholding Base";
            }
            Column(Total_____recTipoRetencion_Descripcion; 'Total ' + recWithholdingType.Description)
            {
                //SourceExpr='Total ' + recWithholdingType.Description;
            }
            Column(Mov__retencion__Amount__LCY___Control1100229023; "Amount (LCY)")
            {
                //SourceExpr="Amount (LCY)";
            }
            Column(Mov__retencion__Base_de_retencion__DL___Control1000000005; "Withholding Movements"."Withholding Base (LCY)")
            {
                //SourceExpr="Withholding Movements"."Withholding Base (LCY)";
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(Withholding_PITCaption; Withholding_PITCaptionLbl)
            {
                //SourceExpr=Withholding_PITCaptionLbl;
            }
            Column(N_Caption; N_CaptionLbl)
            {
                //SourceExpr=N_CaptionLbl;
            }
            Column(CIFCaption; CIFCaptionLbl)
            {
                //SourceExpr=CIFCaptionLbl;
            }
            Column(NameCaption; NameCaptionLbl)
            {
                //SourceExpr=NameCaptionLbl;
            }
            Column(Withholding_EurosCaption; Withholding_EurosCaptionLbl)
            {
                //SourceExpr=Withholding_EurosCaptionLbl;
            }
            Column(CountryCaption; CountryCaptionLbl)
            {
                //SourceExpr=CountryCaptionLbl;
            }
            Column(Withholding_CurrencyCaption; Withholding_CurrencyCaptionLbl)
            {
                //SourceExpr=Withholding_CurrencyCaptionLbl;
            }
            Column(Base_EurosCaption; Base_EurosCaptionLbl)
            {
                //SourceExpr=Base_EurosCaptionLbl;
            }
            Column(Base_CurrencyCaption; Base_CurrencyCaptionLbl)
            {
                //SourceExpr=Base_CurrencyCaptionLbl;
            }
            Column(Mov__Withholding_Entry_No_; "Entry No.")
            {
                //SourceExpr="Entry No.";
            }
            Column(Mov__Withholding_Cod_Withholding; "Withholding Movements"."Withholding Code")
            {
                //SourceExpr="Withholding Movements"."Withholding Code";
            }
            Column(Mov__Withholding_No_; "No.")
            {
                //SourceExpr="No." ;
            }
            trigger OnPreDataItem();
            BEGIN
                CurrReport.CREATETOTALS("Withholding Base", "Withholding Base (LCY)", Amount, "Amount (LCY)");
                CurrReport.CREATETOTALS(decVar);
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
        //       recWithholdingType@7001104 :
        recWithholdingType: Record 7207330;
        //       recVendor@7001103 :
        recVendor: Record 23;
        //       intCount@7001102 :
        intCount: Integer;
        //       txtFilter@7001101 :
        txtFilter: Text[250];
        //       decVar@7001100 :
        decVar: Decimal;
        //       CurrReport_PAGENOCaptionLbl@7001114 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P g.';
        //       Withholding_PITCaptionLbl@7001113 :
        Withholding_PITCaptionLbl: TextConst ENU = 'PIT Withholdings', ESP = 'Retenciones IRPF';
        //       N_CaptionLbl@7001112 :
        N_CaptionLbl: TextConst ENU = 'No.', ESP = 'N§';
        //       CIFCaptionLbl@7001111 :
        CIFCaptionLbl: TextConst ESP = 'CIF';
        //       NameCaptionLbl@7001110 :
        NameCaptionLbl: TextConst ENU = 'Name', ESP = 'Nombre';
        //       Withholding_EurosCaptionLbl@7001109 :
        Withholding_EurosCaptionLbl: TextConst ENU = 'Withholding Dollar', ESP = 'Retenci¢n Euros';
        //       CountryCaptionLbl@7001108 :
        CountryCaptionLbl: TextConst ENU = 'Country', ESP = 'Pa¡s';
        //       Withholding_CurrencyCaptionLbl@7001107 :
        Withholding_CurrencyCaptionLbl: TextConst ENU = 'Currency Withholding', ESP = 'Retenci¢n divisa';
        //       Base_EurosCaptionLbl@7001106 :
        Base_EurosCaptionLbl: TextConst ENU = 'Base', ESP = 'Base Euros';
        //       Base_CurrencyCaptionLbl@7001105 :
        Base_CurrencyCaptionLbl: TextConst ENU = 'Currency Base', ESP = 'Base Divisa';



    trigger OnPreReport();
    begin
        txtFilter := '';
        if "Withholding Movements".GETFILTERS <> '' then
            txtFilter := 'Filtros: ' + "Withholding Movements".GETFILTERS;
    end;



    /*begin
        end.
      */

}



