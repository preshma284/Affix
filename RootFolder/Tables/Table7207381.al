table 7207381 "Days Fixed Payment Job"
{


    CaptionML = ENU = 'Days Fixed Payment Job', ESP = 'D�as pago fijo proyecto';
    // LookupPageID=Page7022928;
    // DrillDownPageID=Page7022928;

    fields
    {
        field(1; "Rule Code"; Code[20])
        {
            TableRelation = "Rules Job Treasury"."Analytic Concept" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Rule Code', ESP = 'Concepto anal�tico';
            Description = 'QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(2; "Fact No."; Integer)
        {
            CaptionML = ENU = 'Fact No.', ESP = 'No. Pago';


        }
        field(3; "Payment day"; Integer)
        {
            InitValue = 1;
            CaptionML = ENU = 'Payment day', ESP = 'D�a de pago';
            MinValue = 1;
            MaxValue = 31;


        }
        field(4; "Payment Month"; Integer)
        {
            InitValue = 1;
            CaptionML = ENU = 'Payment Month', ESP = 'Mes de pago';
            MinValue = 1;
            MaxValue = 12;


        }
        field(5; "Since-Day"; Integer)
        {
            InitValue = 1;
            CaptionML = ENU = 'Since-Day', ESP = 'Desde d�a';
            MinValue = 1;
            MaxValue = 31;


        }
        field(6; "Since-Month"; Integer)
        {
            InitValue = 1;
            CaptionML = ENU = 'Since-Month', ESP = 'Desde mes';
            MinValue = 1;
            MaxValue = 12;


        }
        field(7; "Until-Day"; Integer)
        {
            InitValue = 1;
            CaptionML = ENU = 'Until-Day', ESP = 'Hasta d�a';
            MinValue = 1;
            MaxValue = 31;


        }
        field(8; "Until-Month"; Integer)
        {
            InitValue = 1;
            CaptionML = ENU = 'Until-Month', ESP = 'Hasta mes';
            MinValue = 1;
            MaxValue = 12;


        }
        field(9; "Application Method"; Option)
        {
            OptionMembers = "Back","Previous";
            CaptionML = ENU = 'Application Method', ESP = 'M�todo de liquidaci�n';
            OptionCaptionML = ENU = 'Back,Previous', ESP = 'Posterior,Anterior';



        }
        field(10; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';
            ;


        }
    }
    keys
    {
        key(key1; "Job No.", "Rule Code", "Fact No.", "Since-Month", "Since-Day")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }


    /*begin
    end.
  */
}







