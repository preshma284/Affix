table 7207391 "QBU Document Data Contracts"
{
  
  
    CaptionML=ENU='Document Data Contracts',ESP='Datos de documentos contratos';
  
  fields
{
    field(2;"Contract No.";Code[20])
    {
        CaptionML=ENU='Contract No.',ESP='N§ de contrato';
                                                   Description='Key 2';


    }
    field(3;"Job No.";Code[20])
    {
        CaptionML=ENU='Job No.',ESP='N§ de proyecto';
                                                   Description='Key 1';


    }
    field(30;"Job Name";Text[100])
    {
        CaptionML=ENU='Name of the Job',ESP='Nombre de la obra';


    }
    field(31;"Work Objetive of the Contract";Text[100])
    {
        CaptionML=ENU='Objetive of the Contract',ESP='Objetivo del contrato';


    }
    field(33;"Work Testing Term";Text[50])
    {
        CaptionML=ENU='Testing Term',ESP='Plazo de comprobaci¢n';


    }
    field(34;"Work Payment Document Due";Text[50])
    {
        CaptionML=ENU='Payment Document Expiration',ESP='Vto. del documento de pago';


    }
    field(35;"Work Start Date";Date)
    {
        CaptionML=ENU='Start Date',ESP='Fecha de inicio';


    }
    field(36;"Work First Installment Penalty";Text[50])
    {
        CaptionML=ENU='First Installment of Penalty',ESP='Primer tramo de penalizaci¢n';


    }
    field(37;"Work Second Installment Pen.";Text[50])
    {
        CaptionML=ENU='Second Installment of Penalty',ESP='Segundo tramo de penalizaci¢n';


    }
    field(38;"Work % Of amount";Decimal)
    {
        CaptionML=ENU='% Of amount',ESP='% del importe';


    }
    field(39;"Work Duration";Text[30])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Duraci¢n';
                                                   Description='QB 1.9.13 - JAV 22/07/21: - Nuevo campo';


    }
    field(43;"Work Provisional Receipt Date";Date)
    {
        CaptionML=ENU='Provisional Receipt Date',ESP='Fecha de recepci¢n provisional';


    }
    field(55;"Work Finish Date";Date)
    {
        CaptionML=ENU='Finish Date',ESP='Fecha de terminaci¢n';


    }
    field(60;"Work Redesign Date";Date)
    {
        CaptionML=ENU='Redesign Date',ESP='Fecha replanteo';


    }
    field(61;"Work Redesign Hour";Time)
    {
        CaptionML=ENU='Redesign Hour',ESP='Hora replanteo';


    }
    field(62;"Work Fax Reason";Text[80])
    {
        CaptionML=ENU='Fax Reason',ESP='Motivo del fax';


    }
    field(72;"Work Return Time";Date)
    {
        CaptionML=ENU='Return Time',ESP='Plazo de devoluci¢n';


    }
    field(73;"Work Term Expiration Return";DateFormula)
    {
        CaptionML=ENU='Term Expiration Return',ESP='Plazo Vto. devoluci¢n';


    }
    field(74;"Work Secure Amount";Decimal)
    {
        CaptionML=ENU='Secure Amount',ESP='Importe seguro';


    }
    field(75;"Work Max Franchise";Decimal)
    {
        CaptionML=ENU='Max Franchise',ESP='Franquicia m xima';


    }
    field(76;"Work Amt. Employer Liability";Decimal)
    {
        CaptionML=ENU='Amount of Employer''s Liability',ESP='Imp. responsabilidad patronal';


    }
    field(77;"Work Penalty for Breach";Decimal)
    {
        CaptionML=ENU='Penalty for Breach',ESP='Sanci¢n por incumplimiento';


    }
    field(78;"Work Import Material Transport";Decimal)
    {
        CaptionML=ENU='Import Material Transport',ESP='Imp. transporte material';


    }
    field(79;"Work Minimum Period Contract";DateFormula)
    {
        CaptionML=ENU='Minimum Period of Contract',ESP='Per¡odo m¡nimo del contrato';


    }
    field(80;"Work Import Contract";Decimal)
    {
        CaptionML=ENU='Import Contract',ESP='Importe contrato';


    }
    field(83;"Vendor No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo del Proveedor';


    }
    field(86;"Work Delay";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Delay',ESP='Retraso';
                                                   Description='Q12932';


    }
    field(87;"Work Performance";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Performance',ESP='Rendimiento';
                                                   Description='Q12932';


    }
    field(89;"Work Work Type";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Work Type',ESP='Tipo de trabajo';
                                                   Description='Q12932';


    }
    field(90;"Work End Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='End Date',ESP='Fecha final';
                                                   Description='Q12932';


    }
    field(91;"Work % Withholding Aditional";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding Warranty',ESP='% retenci¢n garantia adicional';
                                                   Description='QB 1.08.28 - JAV 25/03/21: - Nuevo campo';


    }
    field(93;"Work Billing Milestones";Text[100])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Billing Milestones',ESP='Hitos de facturaci¢n'; ;


    }
}
  keys
{
    key(key1;"Job No.","Contract No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       PaymentTerms@1100286001 :
      PaymentTerms: Record 3;
//       PaymentMethod@1100286000 :
      PaymentMethod: Record 289;
//       PostCode@7001101 :
      PostCode: Record 225;
//       CountryCode@7001100 :
      CountryCode: Code[10];

    /*begin
    {
      HAN 09/03/21: - Q12932 Added new fields for contract reports
      JAV 30/10/21: - QB 1.09.26 Se elimina el campo "1" del contador de registros, la nueva clave es JOB + N§Documento que es mas sencilla de buscar
      PSM 10/01/22: - Q16120 Se a¤ade el campo "Work Billing Milestones"
    }
    end.
  */
}







