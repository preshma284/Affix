tableextension 50146 "MyExtension50146" extends "Job Ledger Entry"
{


    CaptionML = ENU = 'Job Ledger Entry', ESP = 'Mov. proyecto';
    LookupPageID = "Job Ledger Entries";
    DrillDownPageID = "Job Ledger Entries";

    fields
    {
        field(60004; "QB TMP Rastreado"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.10.56 Temporal, solo para arreglar el problema de las facturas no imputadas a proyecto';


        }
        field(60005; "Regenera C.A."; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Regenera C.A.', ESP = 'Regenera C.A.';
            Description = 'BS::22214 CSM 20/05/24 - Fecha en la que se informa CA desde cd 60500.';


        }
        field(7207270; "Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework No.', ESP = 'C�d. Unidad de Obra';
            Description = 'QB 1.0 - QB2413';


        }
        field(7207271; "Job in progress"; Boolean)
        {
            CaptionML = ESP = 'Obra en curso';
            Description = 'QB 1.0 - QB2411';


        }
        field(7207272; "Job Sale Doc. Type"; Option)
        {
            OptionMembers = "Standar","Eqipament Advance","Advance by Store","Price Review";
            CaptionML = ESP = 'Tipo doc. venta proyecto';
            OptionCaptionML = ENU = 'Standar,Eqipament Advance,Advance by Store,Price Review', ESP = 'Estandar,Anticipo de maquinar�a,Anticipo por acopios,Revisi�n precios';

            Description = 'QB 1.0 - QB2411';


        }
        field(7207273; "Job Deviation Mov."; Boolean)
        {
            CaptionML = ENU = 'Job Deviation Mov.', ESP = 'Mov. Proyecto Desviaci�n';
            Description = 'QB 1.0 - QB2517';


        }
        field(7207274; "Compute for hours"; Boolean)
        {
            CaptionML = ENU = 'Compute for hours', ESP = 'Computa para horas';
            Description = 'QB 1.0 - QB2517';


        }
        field(7207275; "Piecework Indirect Type"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Data Piecework For Production" WHERE("Job No." = FIELD("Job No."),
                                                                                                            "Piecework Code" = FIELD("Piecework No."),
                                                                                                            "Type" = CONST("Cost Unit")));
            CaptionML = ESP = 'U.O. de indirectos';
            Description = 'QB 1.06 : - Tipo de unidad de obra';


        }
        field(7207276; "Related Item Entry No."; Integer)
        {
            CaptionML = ENU = 'Related Item Entry No.', ESP = 'N�  mov. producto relacionado';
            Description = 'QB 1.0 - QB2517';


        }
        field(7207277; "Movement of Closing of Job"; Boolean)
        {
            CaptionML = ENU = 'Movement of Closing of Job', ESP = 'Movimiento de cierre de obra';
            Description = 'QB 1.0 - QB2517';


        }
        field(7207278; "Plant Depreciation Sheet"; Boolean)
        {
            CaptionML = ENU = 'Plant Depreciation Sheet', ESP = 'Parte amortizaci�n planta';
            Description = 'QB 1.0 - QB2517';


        }
        field(7207279; "Expense Notes Code"; Code[20])
        {
            CaptionML = ENU = 'Expense Notes Code', ESP = 'C�d. Nota gasto';
            Description = 'QB 1.0 - QB2517';
            Editable = false;


        }
        field(7207281; "OLD_QB Activate Expense No"; Code[20])
        {
            TableRelation = "QB Expenses Activation";
            CaptionML = ENU = 'Activate',
                                                              ESP = 'Nï¿½ Doc. Activaciï¿½n de Gastos';
            Description = ' ELIMINAR ### no se usa';
            Editable = False;
        }

        field(7207282; "OLD_QB Activate Expense Line"; Integer)
        {
            CaptionML = ENU = 'Activate',
                                                              ESP = 'Nï¿½ Doc. Activaciï¿½n de Gastos';
            Description = ' ELIMINAR ### no se usa';
            Editable = False;
        }
        field(7207284; "Exchange Rate (JC)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Exchange Rate (JC)', ESP = 'Tipo cambio (DC)';
            Description = 'QB 1.0 - ELECNOR GEN005-02';


        }
        field(7207285; "Total Price (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total Price (RC)', ESP = 'Precio total (DR)';
            Description = 'QB 1.0 - ELECNOR GEN005-02';


        }
        field(7207286; "Exchange Rate (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Exchange Rate (RC)', ESP = 'Tipo cambio (DR)';
            Description = 'QB 1.0 - ELECNOR GEN005-02';


        }
        field(7207287; "Unit Cost (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Unit Cost (ACY)', ESP = 'Coste unitario (DR)';
            Description = 'QB 1.0 - ELECNOR Q7861';
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";


        }
        field(7207288; "Original Unit Cost (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Original Unit Cost (ACY)', ESP = 'Coste unitario original (DR)';
            Description = 'QB 1.0 - ELECNOR Q7861';
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";


        }
        field(7207289; "Original Total Cost (Job ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Original Total Cost (Job ACY)', ESP = 'Coste total original (Proy. DR)';
            Description = 'QB 1.0 - ELECNOR Q7861';


        }
        field(7207290; "Total Cost (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total Cost (ACY)', ESP = 'Coste total (DR)';
            Description = 'QB 1.0 - ELECNOR Q7861';


        }
        field(7207291; "Unit Price (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Unit Price (ACY)', ESP = 'Precio venta (DR)';
            Description = 'QB 1.0 - ELECNOR Q7950';


        }
        field(7207292; "Line Amount (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Line Amount (ACY)', ESP = 'Importe l�nea (DR)';
            Description = 'QB 1.0 - ELECNOR Q7950';


        }
        field(7207293; "WIP Pending Amount (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Detailed Job Ledger Entry"."Amount" WHERE("Job Ledger Entry No." = FIELD("Entry No.")));
            CaptionML = ESP = 'Importe OEC pte.';
            Description = 'QB 1.07.08 - JAV 27/11/20: - Importe del WIP pendiente de liquidar en la Divisa del Proyecto';


        }
        field(7207294; "WIP Pending Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Detailed Job Ledger Entry"."Amount (LCY)" WHERE("Job Ledger Entry No." = FIELD("Entry No.")));
            CaptionML = ESP = 'Importe OEC pte. (DL)';
            Description = 'QB 1.07.08 - JAV 27/11/20: - Importe del WIP pendiente de liquidar en Divisa Local';


        }
        field(7207295; "Currency Adjust"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ajustes de Divisas';
            Description = 'QB 1.07.10 JAV 03/12/20: - Si es por un ajuste de cambios de divisas';


        }
        field(7207296; "Related G/L Entry"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Movimiento Contable Relacionado';
            Description = 'QB 1.07.10 JAV 03/12/20: - Que movimiento contable est� relacionado con este';


        }
        field(7207300; "Source Type"; Option)
        {
            OptionMembers = " ","Customer","Vendor";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Type', ESP = 'Tipo origen';
            OptionCaptionML = ENU = '" ,Customer,Vendor"', ESP = '" ,Cliente,Proveedor"';

            Description = 'GAP888';


        }
        field(7207301; "Source Document Type"; Option)
        {
            OptionMembers = " ","Shipping","Invoice","Credit Memo","Journal","Worksheet";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Document Type', ESP = 'Tipo documento origen';
            OptionCaptionML = ENU = '" ,Shipping,Invoice,Credit Memo,Journal,Worksheet"', ESP = '" ,Albar�n,Factura,Abono,Diario,Parte de trabajo"';

            Description = 'GAP888';


        }
        field(7207302; "Source No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source No.', ESP = 'N� origen';
            Description = 'GAP888';


        }
        field(7207303; "Source Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source No.', ESP = 'Nombre origen';
            Description = 'GAP888';


        }
        field(7207304; "Provision"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Provision', ESP = 'Provisi�n';
            Description = 'GAP888';


        }
        field(7207305; "Unprovision"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Unrovision', ESP = 'Desprovisi�n';
            Description = 'GAP888';


        }
        field(7207315; "Piecework Type"; Option)
        {
            OptionMembers = "Piecework","Cost Unit","Investment Unit","Assistant Unit";
            FieldClass = FlowField;
            CalcFormula = Lookup("Data Piecework For Production"."Type" WHERE("Job No." = FIELD("Job No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework No.")));
            CaptionML = ENU = 'Type', ESP = 'Tipo Unidad de obra';
            OptionCaptionML = ENU = 'Piecework,Cost Unit,Investment Unit,Assistant Unit', ESP = 'Unidad de obra,Unidad de coste,Unidad de inversi�n,Unidad Auxiliar';



        }
        field(7207320; "Transaction Currency"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Transaction Currency', ESP = 'Divisa Transacci�n';
            Description = 'JMMA: C�digo de divisa de la transacci�n original. OJO no es la de proyecto.';


        }
        field(7207321; "Total Cost (FC)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total Cost (FC)', ESP = 'Coste Total (DF)';
            Description = 'JMMA: Importe de coste valorado al cambio fijado en el proyecto, no al tipo de la transacci�n';


        }
        field(7207322; "Total Cost (TC)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total Cost (TC)', ESP = 'Coste Total (DT)';
            Description = 'JMMA: Importe de coste en la divisa de la transacci�n';


        }
        field(7207323; "Correction"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Correction', ESP = 'Correcci�n';
            Description = 'Q17138. CPA 06/06/22. Funcionalidad de productos prestados';


        }
    }
    keys
    {
        // key(key1;"Entry No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Job No.","Job Task No.","Entry Type","Posting Date")
        //  {
        /* SumIndexFields="Total Cost (LCY)","Line Amount (LCY)","Total Cost","Line Amount";
  */
        // }
        // key(key3;"Document No.","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key4;"Job No.","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key5;"Entry Type","Type","No.","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key6;"Service Order No.","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key7;"Job No.","Entry Type","Type","No.")
        //  {
        /* ;
  */
        // }
        // key(key8;"Type","Entry Type","Country/Region Code","Source Code","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key9;"Job No.","Entry Type","Type","Posting Date")
        //  {
        /* //SumIndexFields="Total Cost (LCY)","Line Amount (LCY)","Total Cost","Line Amount","Total Price (LCY)"
                                                    MaintainSQLIndex=false;
  */
        // }
        key(Extkey10; "Entry Type", "Job No.")
        {
            SumIndexFields = "Line Amount (LCY)", "Total Cost (LCY)";
        }
        //key(Extkey11;"Entry Type","Job No.","Job in progress")
        // {
        /*  SumIndexFields="Line Amount (LCY)";
 */
        // }
        //key(Extkey12;"Entry Type","Job No.","Type","Posting Date","Piecework No.")
        // {
        /*  SumIndexFields="Total Cost (LCY)","Total Price";
 */
        // }
        //key(Extkey13;"Entry Type","Job No.","Job in progress","Job Sale Doc. Type")
        // {
        /*  SumIndexFields="Line Amount (LCY)";
 */
        // }
        //key(Extkey14;"Entry Type","Job No.","Type","Posting Date","Job in progress")
        // {
        /*  SumIndexFields="Line Amount (LCY)";
 */
        // }
        //key(Extkey15;"Job No.","Piecework No.","Entry Type","Posting Date","Global Dimension 2 Code")
        // {
        /*  SumIndexFields="Total Cost";
 */
        // }
        key(Extkey16; "Ledger Entry No.", "Ledger Entry Type")
        {
            ;
        }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"Entry No.","Job No.","Posting Date","Document No.")
        // {
        // 
        // }
    }

    var
        //       Job@1001 :
        Job: Record 167;
        //       DimMgt@1000 :
        DimMgt: Codeunit 408;





    /*
    trigger OnInsert();    begin
                   Job.UpdateOverBudgetValue("Job No.",TRUE,"Total Cost (LCY)");
                 end;


    */

    /*
    trigger OnModify();    begin
                   Job.UpdateOverBudgetValue("Job No.",TRUE,"Total Cost (LCY)");
                 end;


    */

    /*
    trigger OnDelete();    begin
                   Job.UpdateOverBudgetValue("Job No.",TRUE,"Total Cost (LCY)");
                 end;

    */




    /*
    procedure ShowDimensions ()
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
        end;

        /*begin
        //{
    //      JAV 30/11/20: - QB 1.07.17 Se elimina el campo 7207283 "Total Price (JC)" pues el campo "Total Priece" ya va en la divisa del proyecto
    //
    //      CPA 29/03/22: Q16867 - Mejora de rendimiento
    //          - Nueva Clave: Entry Type,Job No.,Type,Posting Date
    //          - Nueva Clave: Entry Type,Job No.
    //          - Nueva clave: Entry Type,Job No.,Job in progress
    //          - Nueva clave: Entry Type,Job No.,Type,Posting Date,Piecework No.
    //          - Nueva clave: Entry Type,Job No.,Job in progress,Job Sale Doc. Type
    //          - Nueva clave: Entry Type,Job No.,Type,Posting Date,Job in progress
    //      JAV 02/06/22: - QB 1.10.46 Se a�ade la key "Ledger Entry No.,Ledger Entry Type" para mejorar la velocidad
    //
    //      CPA 06-06-22: - Q17138.Funcionalidad de productos prestados.
    //          - Nuevo campo: Correction
    //          - Nueva clave: Document No.,Posting Date,Correction
    //      JAV 10/10/22: - QB 1.12.00 Se elimina el campo 7207280, 7207281 y 7207282 que no se usan.
    //      BS::22214 CSM 20/05/24 � Error en c�lculo ppto anal�tico.  New Field.
    //    }
        end.
      */
}




