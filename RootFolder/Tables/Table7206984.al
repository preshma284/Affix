table 7206984 "QB Certification Planning"
{
  
  
    CaptionML=ENU='Certification Planning',ESP='Planificaci¢n de certificaciones';
  
  fields
{
    field(1;"QB_Job No.";Code[20])
    {
        TableRelation="Job"."No.";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';
                                                   Description='QB16219';


    }
    field(2;"QB_Record No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Record No.',ESP='N§ Expediente';
                                                   Description='QB16219';


    }
    field(3;"QB_Expected Date";Date)
    {
        CaptionML=ENU='Expected Date',ESP='Fecha Prevista';
                                                   Description='QB16219';


    }
    field(4;"QB_Initial Planning Amount";Decimal)
    {
        CaptionML=ENU='Initial Planning Amount',ESP='Importe Planificaci¢n Inicial';
                                                   Description='QB16219';


    }
    field(5;"QB_Performed Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Performed Amount',ESP='Importe Certificado';
                                                   Description='QB16219';


    }
    field(6;"QB_Pending Planning Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Pending Planning Amount',ESP='Importe Planificaci¢n Pendiente';
                                                   Description='QB16219' ;


    }
}
  keys
{
    key(key1;"QB_Job No.","QB_Record No.","QB_Expected Date")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       JobCurrencyExchangeFunction@100000003 :
      JobCurrencyExchangeFunction: Codeunit 7207332;
//       Job@100000002 :
      Job: Record 167;

    procedure GetCertificationPerformed () : Decimal;
    var
//       HistCertificationLines@1100286000 :
      HistCertificationLines: Record 7207342;
//       RcdDate@1100286001 :
      RcdDate: Record 2000000007;
//       TotalCertifAmount@1100286002 :
      TotalCertifAmount: Decimal;
    begin
      TotalCertifAmount := 0;
      if RcdDate.GET(RcdDate."Period Type"::Month,Rec."QB_Expected Date") then begin
        HistCertificationLines.RESET;
        HistCertificationLines.SETRANGE("Job No.","QB_Job No.");
        //-
        if "QB_Record No." <> '' then
        //+
          HistCertificationLines.SETRANGE(Record,"QB_Record No.");
        HistCertificationLines.SETFILTER("Certification Date",'%1..%2',RcdDate."Period Start",RcdDate."Period end");
        //HistCertificationLines.CALCSUMS("Cert Term PEM amount");
        //TotalCertifAmount := HistCertificationLines."Cert Term PEM amount";
        HistCertificationLines.CALCSUMS("Cert Term PEC amount");
        TotalCertifAmount := HistCertificationLines."Cert Term PEC amount";
      end;
      exit(TotalCertifAmount);
    end;

//     procedure GetJobCertificationPerformed (P_JobCode@1100286003 : Code[20];P_ExpCode@1100286006 : Code[20];InitDate@1100286004 : Date;EndDate@1100286005 : Date;var P_LastPerfDate@1100286007 :
    procedure GetJobCertificationPerformed (P_JobCode: Code[20];P_ExpCode: Code[20];InitDate: Date;EndDate: Date;var P_LastPerfDate: Date) : Decimal;
    var
//       HistCertificationLines@1100286000 :
      HistCertificationLines: Record 7207342;
//       RcdDate@1100286001 :
      RcdDate: Record 2000000007;
//       TotalCertifAmount@1100286002 :
      TotalCertifAmount: Decimal;
    begin
      P_LastPerfDate := 0D;
      TotalCertifAmount := 0;
      HistCertificationLines.RESET;
      HistCertificationLines.SETRANGE("Job No.",P_JobCode);
      if P_ExpCode <> '' then
        HistCertificationLines.SETRANGE(Record,P_ExpCode);
      HistCertificationLines.SETFILTER("Certification Date",'%1..%2',InitDate,EndDate);
      HistCertificationLines.CALCSUMS("Cert Term PEC amount");
      TotalCertifAmount := HistCertificationLines."Cert Term PEC amount";
      P_LastPerfDate := HistCertificationLines.GETRANGEMAX("Certification Date");
      exit(TotalCertifAmount);
    end;

    /*begin
    //{
//      16216 01/02/22 DGG - Creaci¢n de la TABLA
//    }
    end.
  */
}







