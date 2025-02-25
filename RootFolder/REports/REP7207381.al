report 7207381 "Annex Purchase Lines"
{


    CaptionML = ENU = 'Annex Purchase Lines', ESP = 'Anexo l¡neas compra';

    dataset
    {

        DataItem("Purchase Line"; "Purchase Line")
        {

            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
            RequestFilterFields = "Document Type", "Document No.";
            Column(N__Contrato_____Document_No__; 'N§ Contrato: ' + "Document No.")
            {
                //SourceExpr='N§ Contrato: '+"Document No.";
            }
            Column(VendAddr_1_; VendAddr[1])
            {
                //SourceExpr=VendAddr[1];
            }
            Column(VendAddr_2_; VendAddr[2])
            {
                //SourceExpr=VendAddr[2];
            }
            Column(VendAddr_3_; VendAddr[3])
            {
                //SourceExpr=VendAddr[3];
            }
            Column(VendAddr_4_; VendAddr[4])
            {
                //SourceExpr=VendAddr[4];
            }
            Column(VendAddr_5_; VendAddr[5])
            {
                //SourceExpr=VendAddr[5];
            }
            Column(VendAddr_6_; VendAddr[6])
            {
                //SourceExpr=VendAddr[6];
            }
            Column(VendAddr_7_; VendAddr[7])
            {
                //SourceExpr=VendAddr[7];
            }
            Column(VendAddr_8_; VendAddr[8])
            {
                //SourceExpr=VendAddr[8];
            }
            Column(OBRA______recJob_Description_________recJob__Description_2_; JobLbl + Job.Description + ' ' + Job."Description 2")
            {
                //SourceExpr=JobLbl + Job.Description + ' ' +Job."Description 2";
            }
            Column(Purchase_Line_Amount; Amount)
            {
                //SourceExpr=Amount;
            }
            Column(Purchase_Line_Quantity; Quantity)
            {
                //SourceExpr=Quantity;
            }
            Column(Purchase_Line__Unit_of_Measure_; "Unit of Measure")
            {
                //SourceExpr="Unit of Measure";
            }
            Column(Purchase_Line_Description; Description)
            {
                //SourceExpr=Description;
            }
            Column(Purchase_Line__Direct_Unit_Cost_; "Direct Unit Cost")
            {
                //SourceExpr="Direct Unit Cost";
            }
            Column(Purchase_Line_Amount_Control10; Amount)
            {
                //SourceExpr=Amount;
            }
            Column(Purchase_Line_Amount_Control17; Amount)
            {
                //SourceExpr=Amount;
            }
            Column(Purchase_Line_Amount_Control12; Amount)
            {
                //SourceExpr=Amount;
            }
            Column(ANEXO_I_Caption; ANNEX_I_CaptionLbl)
            {
                //SourceExpr=ANNEX_I_CaptionLbl;
            }
            Column(Udad__medidaCaption; "Measuring_ UnitCaptionLbl")
            {
                //SourceExpr="Measuring_ UnitCaptionLbl";
            }
            Column(DescripcionCaption; DescriptionCaptionLbl)
            {
                //SourceExpr=DescriptionCaptionLbl;
            }
            Column(Precio_unitarioCaption; Unit_PriiceCaptionLbl)
            {
                //SourceExpr=Unit_PriiceCaptionLbl;
            }
            Column(ImporteCaption; AmountCaptionLbl)
            {
                //SourceExpr=AmountCaptionLbl;
            }
            Column(CantidadCaption; QuantityCaptionLbl)
            {
                //SourceExpr=QuantityCaptionLbl;
            }
            Column(SumaCaption; SumCaptionLbl)
            {
                //SourceExpr=SumCaptionLbl;
            }
            Column(SumaCaption_Control18; SumCaption_Control18Lbl)
            {
                //SourceExpr=SumCaption_Control18Lbl;
            }
            Column(IMPORTE_TOTALCaption; TOTALCaptionLbl)
            {
                //SourceExpr=TOTALCaptionLbl;
            }
            Column(Purchase_Line_Document_Type; "Document Type")
            {
                //SourceExpr="Document Type";
            }
            Column(Purchase_Line_Document_No_; "Document No.")
            {
                //SourceExpr="Document No.";
            }
            Column(Purchase_Line_Line_No_; "Line No.")
            {
                //SourceExpr="Line No." ;
            }
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
        //       PurchaseHeader@7001101 :
        PurchaseHeader: Record 38;
        //       Job@7001100 :
        Job: Record 167;
        //       FormatAddr@7001102 :
        FormatAddr: Codeunit 365;
        //       VendAddr@1100000 :
        VendAddr: ARRAY[8] OF Text[50];
        //       ANNEX_I_CaptionLbl@6623 :
        ANNEX_I_CaptionLbl: TextConst ENU = 'ANNEX I', ESP = '"ANEXO I "';
        //       "Measuring_ UnitCaptionLbl"@8426 :
        "Measuring_ UnitCaptionLbl": TextConst ENU = 'Measuring Unit', ESP = 'Udad. medida';
        //       DescriptionCaptionLbl@2524 :
        DescriptionCaptionLbl: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       Unit_PriiceCaptionLbl@9203 :
        Unit_PriiceCaptionLbl: TextConst ENU = 'Unit Price', ESP = 'Precio unitario';
        //       AmountCaptionLbl@6568 :
        AmountCaptionLbl: TextConst ENU = 'Importe', ESP = 'Amount';
        //       QuantityCaptionLbl@6334 :
        QuantityCaptionLbl: TextConst ENU = 'Quantity', ESP = 'Cantidad';
        //       SumCaptionLbl@5202 :
        SumCaptionLbl: TextConst ENU = 'Sum', ESP = 'Suma';
        //       SumCaption_Control18Lbl@4525 :
        SumCaption_Control18Lbl: TextConst ENU = 'Sum', ESP = 'Suma';
        //       TOTALCaptionLbl@4669 :
        TOTALCaptionLbl: TextConst ENU = 'TOTAL', ESP = 'IMPORTE TOTAL';
        //       JobLbl@7001104 :
        JobLbl: TextConst ENU = 'Job: ', ESP = 'Obra: ';

    /*begin
    end.
  */

}



