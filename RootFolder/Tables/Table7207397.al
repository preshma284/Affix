table 7207397 "Rel. Certification/Product."
{


    CaptionML = ENU = 'Rel. Certification/Product.', ESP = 'Relaci�n Certificaci�n/producc';
    LookupPageID = "Relation Certification/Product";
    DrillDownPageID = "Relation Certification/Product";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(2; "Production Unit Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Type" = CONST("Piecework"),
                                                                                                                         "Production Unit" = CONST(true));


            CaptionML = ENU = 'Production Unit Code', ESP = 'C�d. unidad producci�n';

            trigger OnValidate();
            BEGIN
                Job.GET("Job No.");
                IF (NOT Job."Separation Job Unit/Cert. Unit") THEN
                    ERROR(Text002);

                IF ("Certification Unit Code" <> '') THEN
                    VALIDATE("Percentage Of Assignment", 100 - CheckPercentage);
            END;


        }
        field(3; "Certification Unit Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Type" = CONST("Piecework"),
                                                                                                                         "Account Type" = CONST("Unit"),
                                                                                                                         "Customer Certification Unit" = CONST(true));


            CaptionML = ENU = 'Certification Unit Code', ESP = 'C�d. unidad certificaci�n';

            trigger OnValidate();
            BEGIN
                Job.GET("Job No.");
                IF (NOT Job."Separation Job Unit/Cert. Unit") THEN
                    ERROR(Text002);

                IF ("Production Unit Code" <> '') THEN
                    VALIDATE("Percentage Of Assignment", 100 - CheckPercentage);
            END;


        }
        field(4; "Percentage Of Assignment"; Decimal)
        {


            CaptionML = ENU = 'Percentage Of Assignment', ESP = '% asignaci�n Cert/Prod';
            DecimalPlaces = 0 : 8;

            trigger OnValidate();
            BEGIN
                PreviousPercentage := CheckPercentage;
                IF (PreviousPercentage + "Percentage Of Assignment" - xRec."Percentage Of Assignment" > 100) THEN
                    "Percentage Of Assignment" := 100 - PreviousPercentage + xRec."Percentage Of Assignment";
                //ERROR(Text001, 100 - PreviousPercentage + xRec."Percentage Of Assignment");
                IF NOT MODIFY THEN;
                VALIDATE("Assignment Cost Percentage");
            END;


        }
        field(5; "Assignment Cost Percentage"; Decimal)
        {


            CaptionML = ENU = 'Assignment Cost Percentage', ESP = '% asignaci�n Prod/Cert';
            DecimalPlaces = 0 : 6;
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 TotalVenta@1100286000 :
                TotalVenta: Decimal;
                //                                                                 Perc@1100286001 :
                Perc: Decimal;
            BEGIN
                TotalVenta := CalcTotalSaleAmount("Job No.", "Production Unit Code");

                RelCertificationProduct.RESET;
                RelCertificationProduct.SETRANGE("Job No.", "Job No.");
                RelCertificationProduct.SETRANGE("Production Unit Code", "Production Unit Code");
                IF (RelCertificationProduct.FINDSET(TRUE)) THEN
                    REPEAT
                        IF (TotalVenta <> 0) THEN
                            Perc := RelCertificationProduct.ShowSaleAmount * 100 / TotalVenta
                        ELSE
                            Perc := 0;

                        IF (Rec.RECORDID = RelCertificationProduct.RECORDID) THEN BEGIN
                            "Assignment Cost Percentage" := Perc;
                            IF NOT MODIFY THEN;
                        END ELSE BEGIN
                            RelCertificationProduct."Assignment Cost Percentage" := Perc;
                            RelCertificationProduct.MODIFY;
                        END;
                    UNTIL (RelCertificationProduct.NEXT = 0);
            END;


        }
        field(6; "Total Asigned Percentage"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rel. Certification/Product."."Percentage Of Assignment" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                   "Certification Unit Code" = FIELD("Certification Unit Code")));
            CaptionML = ESP = 'Total % U.O. venta asignado';
            Description = 'Q8462';
            Editable = false;


        }
        field(7; "Total Asigned Percentage Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rel. Certification/Product."."Assignment Cost Percentage" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                     "Production Unit Code" = FIELD("Production Unit Code")));
            CaptionML = ESP = 'Total % U.O. coste asignado';
            Description = 'Q8462';
            Editable = false;


        }
    }
    keys
    {
        key(key1;"Job No.","Production Unit Code","Certification Unit Code")
        {
                SumIndexFields="Assignment Cost Percentage";
                Clustered=true;
        }
        key(key2; "Job No.", "Certification Unit Code")
        {
            SumIndexFields = "Percentage Of Assignment";
        }
    }
    fieldgroups
    {
    }

    var
        //       Job@7207772 :
        Job: Record 167;
        //       JobDataUnitforProduction@7207773 :
        JobDataUnitforProduction: Record 7207386;
        //       Text001@7207774 :
        Text001: TextConst ENU = 'It''s only possible assign a max of %1', ESP = 'S�lo es posible asignar un m�zimo de %1';
        //       Text002@7207775 :
        Text002: TextConst ENU = 'In jobs without units separation you can''t assign certification units', ESP = 'En proyectos sin separaci�n de unidades no se pueden asignar Unid. Certificaci�n';
        //       Text003@7207776 :
        Text003: TextConst ENU = 'Job unit can''t be added ', ESP = 'La unidad de obra no puede ser agregada';
        //       PreviousPercentage@7207771 :
        PreviousPercentage: Decimal;
        //       RelCertificationProduct@7001100 :
        RelCertificationProduct: Record 7207397;

    procedure CheckPercentage(): Decimal;
    var
        //       RelCertificationProduct@7207771 :
        RelCertificationProduct: Record 7207397;
        //       VPercentageAssigned@7207772 :
        VPercentageAssigned: Decimal;
    begin
        RelCertificationProduct.SETRANGE("Job No.", "Job No.");
        RelCertificationProduct.SETRANGE("Certification Unit Code", "Certification Unit Code");
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        // if RelCertificationProduct.FINDSET(FALSE,FALSE) then
        if RelCertificationProduct.FINDSET(FALSE) then
            repeat
                VPercentageAssigned := VPercentageAssigned + RelCertificationProduct."Percentage Of Assignment";
            until RelCertificationProduct.NEXT = 0;

        exit(VPercentageAssigned);
    end;

    procedure DescCertificationUnit(): Text[50];
    var
        //       JobDataUnitforProduction@7207771 :
        JobDataUnitforProduction: Record 7207386;
    begin
        if JobDataUnitforProduction.GET("Job No.", "Certification Unit Code") then
            exit(JobDataUnitforProduction.Description)
        else
            exit('');
    end;

    procedure ShowSaleAmount(): Decimal;
    var
        //       JobDataUnitforProduction@7207771 :
        JobDataUnitforProduction: Record 7207386;
    begin
        if JobDataUnitforProduction.GET("Job No.", "Certification Unit Code") then
            exit(ROUND(JobDataUnitforProduction."Sale Amount" * "Percentage Of Assignment" / 100, 0.01))
        else
            exit(0);
    end;

    //     procedure CalcTotalSaleAmount (pJob@1100286001 : Code[20];pUO@1100286002 :
    procedure CalcTotalSaleAmount(pJob: Code[20]; pUO: Code[20]): Decimal;
    var
        //       TotalVenta@1100286000 :
        TotalVenta: Decimal;
    begin
        TotalVenta := 0;
        RelCertificationProduct.RESET;
        RelCertificationProduct.SETRANGE("Job No.", pJob);
        RelCertificationProduct.SETRANGE("Production Unit Code", pUO);
        if (RelCertificationProduct.FINDSET(FALSE)) then
            repeat
                TotalVenta += RelCertificationProduct.ShowSaleAmount;
            until (RelCertificationProduct.NEXT = 0);

        exit(TotalVenta);
    end;

    /*begin
    //{
//      QMD 26/12/19: Q8462: GAP07 - Nuevo campo para avisos en agrupaci�n de costes
//    }
    end.
  */
}







