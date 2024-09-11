table 7207272 "QBU Job Customers"
{


    CaptionML = ENU = 'Job Customers', ESP = 'Clientes del proyecto';

    fields
    {
        field(1; "Job no."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'Proyecto';


        }
        field(2; "Customer No."; Code[20])
        {
            TableRelation = "Customer";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cliente';


        }
        field(10; "Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Customer"."Name" WHERE("No." = FIELD("Customer No.")));
            CaptionML = ESP = 'Nombre';
            Editable = false;


        }
        field(11; "Percentaje"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Porcentaje';


        }
        field(12; "Total Percentaje"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Job Customers"."Percentaje" WHERE("Job no." = FIELD("Job no.")));
            CaptionML = ESP = 'Porcentaje Total';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Job no.", "Customer No.")
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







