report 50047 "ROIG Proforma"
{


    UseSystemPrinter = true;

    dataset
    {

        DataItem("QB Proform Header"; "QB Proform Header")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.";
            Column(CAB_Logo; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(CAB_VendorName; Vendor.Name)
            {
                //SourceExpr=Vendor.Name;
            }
            Column(CAB_JobDescription; rJob.Description)
            {
                //SourceExpr=rJob.Description;
            }
            Column(CAB_PostingDate; "QB Proform Header"."Posting Date")
            {
                //SourceExpr="QB Proform Header"."Posting Date";
            }
            Column(CAB_OrderNo; "QB Proform Header"."Order No.")
            {
                //SourceExpr="QB Proform Header"."Order No.";
            }
            DataItem("QB Proform Line"; "QB Proform Line")
            {

                DataItemTableView = SORTING("Document No.", "Line No.");
                DataItemLink = "Document No." = FIELD("No.");
                Column(LIN_Part; "QB Proform Line"."Piecework Nº")
                {
                    //SourceExpr="QB Proform Line"."Piecework N§";
                }
                Column(LIN_Code; "QB Proform Line"."No.")
                {
                    //SourceExpr="QB Proform Line"."No.";
                }
                Column(LIN_MeasureUnit; "QB Proform Line"."Unit of Measure")
                {
                    //SourceExpr="QB Proform Line"."Unit of Measure";
                }
                Column(LIN_ShortDescription; "QB Proform Line".Description)
                {
                    //SourceExpr="QB Proform Line".Description;
                }
                Column(LIN_LargeDescription; LargeDescription)
                {
                    //SourceExpr=LargeDescription;
                }
                Column(LIN_HaveLargeDescription; HaveLargeDescription)
                {
                    //SourceExpr=HaveLargeDescription;
                }
                Column(LIN_UnitPrice; "QB Proform Line"."Direct Unit Cost")
                {
                    //SourceExpr="QB Proform Line"."Direct Unit Cost";
                }
                Column(LIN_ContractMeasure; PurchaseLine.Quantity)
                {
                    //SourceExpr=PurchaseLine.Quantity;
                }
                Column(LIN_ContractAmount; PurchaseLine.Amount)
                {
                    //SourceExpr=PurchaseLine.Amount;
                }
                Column(LIN_MeasOrigin; "QB Proform Line"."QB Qty. Proformed Origin")
                {
                    //SourceExpr="QB Proform Line"."QB Qty. Proformed Origin";
                }
                Column(LIN_MeasBefore; "QB Proform Line".Quantity)
                {
                    //SourceExpr="QB Proform Line".Quantity;
                }
                Column(LIN_MeasMonth; "QB Proform Line"."QB Qty. Proformed Origin" - "QB Proform Line".Quantity)
                {
                    //SourceExpr="QB Proform Line"."QB Qty. Proformed Origin" - "QB Proform Line".Quantity;
                }
                Column(LIN_ImportOrigin; ImportOrigin)
                {
                    //SourceExpr=ImportOrigin;
                }
                Column(LIN_ImportBefore; ImportBefore)
                {
                    //SourceExpr=ImportBefore;
                }
                Column(LIN_ImportMonth; ImportMonth)
                {
                    //SourceExpr=ImportMonth;
                }
                Column(LIN_WorkMeasure; WorkMeasure)
                {
                    //SourceExpr=WorkMeasure;
                }
                Column(LIN_WorkAmount; WorkAmount)
                {
                    //SourceExpr=WorkAmount ;
                }
                trigger OnAfterGetRecord();
                BEGIN
                    QBProform.RecalculateLineOrigin("QB Proform Line", "QB Proform Line".Quantity);  //Esto recalcula los importes de la l¡nea

                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE("Document No.", "QB Proform Line"."Order No.");
                    PurchaseLine.SETRANGE("Line No.", "QB Proform Line"."Order Line No.");
                    IF NOT PurchaseLine.FINDFIRST THEN
                        PurchaseLine.INIT;

                    ImportOrigin := ROUND("QB Proform Line"."QB Qty. Proformed Origin" * "QB Proform Line"."Direct Unit Cost", 0.01);
                    ImportMonth := ROUND("QB Proform Line".Quantity * "QB Proform Line"."Direct Unit Cost", 0.01);
                    ImportBefore := ROUND(ImportOrigin - ImportMonth);
                    WorkMeasure := PurchaseLine.Quantity - "QB Proform Line"."QB Qty. Proformed Origin";
                    WorkAmount := PurchaseLine.Amount - ImportOrigin;

                    LargeDescription := '';
                    QBText.RESET;
                    QBText.SETRANGE(Table, QBText.Table::Contrato);
                    QBText.SETRANGE(Key1, "QB Proform Line"."Document No.");
                    QBText.SETRANGE(Key2, FORMAT("QB Proform Line"."Line No."));
                    IF QBText.FINDFIRST THEN BEGIN
                        LargeDescription := QBText.GetCostText();
                    END ELSE BEGIN
                        QBText.RESET;
                        QBText.SETRANGE(Table, QBText.Table::Job);
                        QBText.SETRANGE(Key1, "QB Proform Line"."Job No.");
                        QBText.SETRANGE(Key2, "QB Proform Line"."Piecework Nº");
                        IF QBText.FINDFIRST THEN BEGIN
                            LargeDescription := QBText.GetCostText();
                        END;
                    END;
                    HaveLargeDescription := (LargeDescription <> '');
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN
                IF NOT rJob.GET("QB Proform Header"."Job No.") THEN
                    rJob.INIT;

                IF NOT Vendor.GET("QB Proform Header"."Buy-from Vendor No.") THEN
                    Vendor.INIT;
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
        LBLPartida = 'PART/ PARTIDA/';
        LBLCodigo = 'CODE/ CàDIGO/';
        LBLUM = 'U.M./ U.M./';
        LBLDescription = 'DESCRIPTION/ DESCRIPCIàN/';
        LBLPrice1 = 'UNIT PRICE/ PRECIO/';
        LBLPrice2 = 'UNIT PRICE/ UNITARIO/';
        LBLContrating = 'CONTRATING/ CONTRATACIàN/';
        LBLMedicion = 'MEASUREMENT/ MEDICIàN/';
        LBLImporte = 'AMOUNT/ IMPORTE/';
        LBLPendingWork = 'PENDING WORK/ OBRA PENDIENTE/';
        LBLOrigen = 'ORIGIN/ ORIGEN/';
        LBLAnterior = 'BEFORE/ ANTERIOR/';
        LBLMes = 'MONTH/ MES/';
        LBLWork = 'Work/ Obra/';
        LBLSubContract = 'Subcontract Name/ Subcontratista/';
        LBLContractDate = 'Contract Date/ Fecha contrato/';
        LBLContract = 'Contract/ Contrato/';
        LBLRelationTitle = 'SUB CONTRACT PRE INVOICE RELATION/ RELACIàN PROFORMA DE SUBCONTRATISTA/';
        LBLTotals = 'TOTALS/ TOTALES/';
        LBLSignWorkChief = '"Sign of Wrk Chief: "/ "Firma del jefe de obra: "/';
    }

    var
        //       PurchaseHeader@1100286009 :
        PurchaseHeader: Record 38;
        //       PurchaseLine@1100286008 :
        PurchaseLine: Record 39;
        //       QBText@1100286007 :
        QBText: Record 7206918;
        //       Vendor@1100286006 :
        Vendor: Record 23;
        //       CompanyInformation@1100286005 :
        CompanyInformation: Record 79;
        //       rJob@1100286000 :
        rJob: Record 167;
        //       QBProform@1100286010 :
        QBProform: Codeunit 7207345;
        //       LargeDescription@1000000004 :
        LargeDescription: Text;
        //       HaveLargeDescription@1100286001 :
        HaveLargeDescription: Boolean;
        //       ImportOrigin@1000000009 :
        ImportOrigin: Decimal;
        //       ImportBefore@1000000015 :
        ImportBefore: Decimal;
        //       ImportMonth@1000000014 :
        ImportMonth: Decimal;
        //       WorkMeasure@1000000013 :
        WorkMeasure: Decimal;
        //       WorkAmount@1000000012 :
        WorkAmount: Decimal;



    trigger OnPreReport();
    begin
        if CompanyInformation.GET then
            CompanyInformation.CALCFIELDS(Picture);
    end;



    /*begin
        {
          JAV 13/01/21: - QB 1.10.09 Nuevo formato para proformas basado en el 50009 que es para albaranes
        }
        end.
      */

}



