report 7207460 "QB Job Cost by Vendor"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Job Cost by Vendor', ESP = 'Costes imputados por proveedores';

    dataset
    {

        DataItem("Job Ledger Entry"; "Job Ledger Entry")
        {

            DataItemTableView = SORTING("Entry Type", "Job No.", "Type", "Posting Date", "Piecework No.")
                                 WHERE("Entry Type" = CONST("Usage"), "Source Type" = FILTER(" " | "Vendor"));


            RequestFilterFields = "Job No.";
            Column(JLE_Filters; "Job Ledger Entry".GETFILTERS)
            {
                //SourceExpr="Job Ledger Entry".GETFILTERS;
            }
            Column(JLE_TableCaption; "Job Ledger Entry".TABLECAPTION)
            {
                //SourceExpr="Job Ledger Entry".TABLECAPTION;
            }
            Column(COMPANYNAME_; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(MonthProcess; MonthProcess)
            {
                //SourceExpr=MonthProcess;
            }
            Column(YearProcess; YearProcess)
            {
                //SourceExpr=YearProcess;
            }
            Column(Job_Caption; Job_Caption)
            {
                //SourceExpr=Job_Caption;
            }
            Column(JLE_JobNo; "Job Ledger Entry"."Job No.")
            {
                //SourceExpr="Job Ledger Entry"."Job No.";
            }
            Column(JobDescrip; JobDescription)
            {
                //SourceExpr=JobDescription;
            }
            Column(Vendor_Caption; Vendor_Caption)
            {
                //SourceExpr=Vendor_Caption;
            }
            Column(JLE_SourceNo; "Job Ledger Entry"."Source No.")
            {
                //SourceExpr="Job Ledger Entry"."Source No.";
            }
            Column(VendorName; VendorName)
            {
                //SourceExpr=VendorName;
            }
            Column(JLE_TotalCost; "Job Ledger Entry"."Total Cost (LCY)")
            {
                //SourceExpr="Job Ledger Entry"."Total Cost (LCY)";
            }
            Column(JLE_PostingDate; "Job Ledger Entry"."Posting Date")
            {
                //SourceExpr="Job Ledger Entry"."Posting Date";
            }
            Column(ActualAmount; ActualAmount)
            {
                //SourceExpr=ActualAmount;
            }
            Column(YearAmount; YearAmount)
            {
                //SourceExpr=YearAmount;
            }
            Column(AcumAmount; AcumAmount)
            {
                //SourceExpr=AcumAmount ;
            }
            trigger OnPreDataItem();
            BEGIN
                InitYear := DMY2DATE(1, 1, YearProcess);
                EndMonthYear := CALCDATE('PM', DMY2DATE(1, MonthProcess, YearProcess));
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF NOT (vgJob.GET("Job Ledger Entry"."Job No.")) THEN
                    CLEAR(vgJob);
                JobDescription := vgJob.Description + vgJob."Description 2";

                IF NOT (vgVendor.GET("Job Ledger Entry"."Source No.")) THEN
                    CLEAR(vgVendor);
                VendorName := vgVendor.Name + vgVendor."Name 2";


                ActualAmount := 0;
                YearAmount := 0;
                AcumAmount := 0;
                IF DATE2DMY("Job Ledger Entry"."Posting Date", 3) = YearProcess THEN BEGIN
                    IF DATE2DMY("Job Ledger Entry"."Posting Date", 2) = MonthProcess THEN BEGIN
                        ActualAmount := "Job Ledger Entry"."Total Cost (LCY)";
                        AcumAmount := "Job Ledger Entry"."Total Cost (LCY)";
                        YearAmount := "Job Ledger Entry"."Total Cost (LCY)";
                    END ELSE
                        IF DATE2DMY("Job Ledger Entry"."Posting Date", 2) < MonthProcess THEN BEGIN
                            IF ("Job Ledger Entry"."Posting Date" >= InitYear) THEN BEGIN
                                YearAmount := "Job Ledger Entry"."Total Cost (LCY)";
                                AcumAmount := "Job Ledger Entry"."Total Cost (LCY)";
                            END ELSE
                                AcumAmount := "Job Ledger Entry"."Total Cost (LCY)";
                        END;
                END ELSE
                    IF DATE2DMY("Job Ledger Entry"."Posting Date", 3) < YearProcess THEN BEGIN
                        AcumAmount := "Job Ledger Entry"."Total Cost (LCY)";
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
                field("MonthProcess"; "MonthProcess")
                {

                    CaptionML = ENU = 'Month Process', ESP = 'Mes del proceso';
                }
                field("YearProcess"; "YearProcess")
                {

                    CaptionML = ENU = 'Year Process', ESP = 'A¤o del proceso';
                }

            }
        }
    }
    labels
    {
        ReportName = 'Costs charged by suppliers/ Costes imputados por proveedores/';
    }

    var
        //       vgJob@1100286000 :
        vgJob: Record 167;
        //       JobDescription@1100286001 :
        JobDescription: Text[100];
        //       MonthProcess@1100286002 :
        MonthProcess: Integer;
        //       YearProcess@1100286003 :
        YearProcess: Integer;
        //       vgVendor@1100286005 :
        vgVendor: Record 23;
        //       VendorName@1100286004 :
        VendorName: Text[100];
        //       ActualAmount@1100286006 :
        ActualAmount: Decimal;
        //       YearAmount@1100286007 :
        YearAmount: Decimal;
        //       AcumAmount@1100286008 :
        AcumAmount: Decimal;
        //       Job_Caption@1100286010 :
        Job_Caption: TextConst ENU = 'Job', ESP = 'Proyecto';
        //       Vendor_Caption@1100286009 :
        Vendor_Caption: TextConst ENU = 'Vendor', ESP = 'Proveedor';
        //       InitYear@1100286011 :
        InitYear: Date;
        //       EndMonthYear@1100286012 :
        EndMonthYear: Date;



    trigger OnInitReport();
    begin
        MonthProcess := DATE2DMY(WORKDATE, 2);
        YearProcess := DATE2DMY(WORKDATE, 3);
    end;



    /*begin
        {
          Q17285 CSM 14/07/22 Í Nuevo informe coste.  Suma de movimientos de proyecto del proyecto y proveedor con fecha de registro:
              - ActualAmount (en el mes y a¤o indicado)
              - YearAmount (desde el 1 de enero del a¤o indicado hasta el £ltimo d¡a del mes y a¤o indicado)
              - AcumAmount (sin fecha de inicio y hasta el £ltimo d¡a del mes y a¤o indicado)
        }
        end.
      */

}




