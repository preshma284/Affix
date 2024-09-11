table 7207437 "Job Redetermination"
{
  
  
    CaptionML=ENU='Job redetermination',ESP='Redeterminaciones de proyecto';
    LookupPageID="Redetermination List";
    DrillDownPageID="Redetermination List";
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='No. proyecto';


    }
    field(2;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';
                                                   NotBlank=true;


    }
    field(3;"Description";Text[50])
    {
        CaptionML=ENU='Descriction',ESP='Descripci¢n';


    }
    field(4;"Aplication Date";Date)
    {
        

                                                   CaptionML=ENU='Aplication Date',ESP='Fecha aplicaci¢n';

trigger OnValidate();
    BEGIN 
                                                                TESTFIELD(Validated,FALSE);
                                                                TESTFIELD(Adjusted,FALSE);
                                                                ActAplicationDate;
                                                              END;


    }
    field(5;"Default redetermination factor";Decimal)
    {
        

                                                   CaptionML=ENU='Default redetermination factor',ESP='Indice redeterminaci¢n por defecto';

trigger OnValidate();
    BEGIN 
                                                                TESTFIELD(Validated,FALSE);
                                                                TESTFIELD(Adjusted,FALSE);
                                                                ActDefIncrease;
                                                              END;


    }
    field(6;"Adjusted";Boolean)
    {
        CaptionML=ENU='Adjusted',ESP='Ajuste';
                                                   Editable=false;


    }
    field(7;"Validated";Boolean)
    {
        CaptionML=ENU='Validated',ESP='Validar'; ;


    }
}
  keys
{
    key(key1;"Job No.","Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       CertUnitRedetermination@7001100 :
      CertUnitRedetermination: Record 7207438;

    

trigger OnModify();    begin
               TESTFIELD(Validated,FALSE);
               TESTFIELD(Adjusted,FALSE);
             end;

trigger OnDelete();    begin
               TESTFIELD(Validated,FALSE);
               TESTFIELD(Adjusted,FALSE);
               CertUnitRedetermination.SETRANGE("Job No.","Job No.");
               CertUnitRedetermination.SETRANGE("Redetermination Code",Code);
               CertUnitRedetermination.DELETEALL;
             end;



procedure ActAplicationDate ()
    var
//       CertUnitRedetermination@7001100 :
      CertUnitRedetermination: Record 7207438;
    begin
      CertUnitRedetermination.SETRANGE("Job No.","Job No.");
      CertUnitRedetermination.SETRANGE("Redetermination Code",Code);
      if CertUnitRedetermination.FINDSET then
        CertUnitRedetermination.MODIFYALL("Aplication Date","Aplication Date");
    end;

    procedure ActDefIncrease ()
    var
//       CertUnitRedetermination@7001100 :
      CertUnitRedetermination: Record 7207438;
    begin
      CertUnitRedetermination.SETRANGE("Job No.","Job No.");
      CertUnitRedetermination.SETRANGE("Redetermination Code",Code);
      if CertUnitRedetermination.FINDSET then
        CertUnitRedetermination.MODIFYALL("Factor applied","Default redetermination factor");
    end;

    procedure LoadUnitCertification ()
    var
//       CertUnitRedetermination@7001100 :
      CertUnitRedetermination: Record 7207438;
//       DataPieceworkForProduction@7001101 :
      DataPieceworkForProduction: Record 7207386;
    begin
      DataPieceworkForProduction.SETRANGE("Job No.","Job No.");
      DataPieceworkForProduction.SETRANGE("Customer Certification Unit",TRUE);
      if DataPieceworkForProduction.FINDSET then
        repeat
          CLEAR(CertUnitRedetermination);
          CertUnitRedetermination.VALIDATE("Job No.","Job No.");
          CertUnitRedetermination."Redetermination Code" := Code;
          CertUnitRedetermination.VALIDATE("Piecework Code",DataPieceworkForProduction."Piecework Code");
          CertUnitRedetermination.VALIDATE("Account Type",DataPieceworkForProduction."Account Type");
          CertUnitRedetermination."Aplication Date" := "Aplication Date";
          if CertUnitRedetermination."Account Type" = CertUnitRedetermination."Account Type"::Unit then
            CertUnitRedetermination.VALIDATE("Factor applied","Default redetermination factor");
          if not CertUnitRedetermination.INSERT(TRUE) then
            CertUnitRedetermination.MODIFY(TRUE)
        until DataPieceworkForProduction.NEXT = 0;
    end;

    /*begin
    end.
  */
}







