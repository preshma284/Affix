table 7206995 "QBU Expenses Activation"
{
  
  
    Permissions=TableData 17=rmd,
                TableData 45=rmd,
                TableData 169=rmd;
    
  fields
{
    field(1;"Period";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Periodo';


    }
    field(2;"Job Code";Code[20])
    {
        TableRelation="Job";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Proyecto';

trigger OnValidate();
    BEGIN 
                                                                Rec.VALIDATE("Document No.");
                                                              END;


    }
    field(3;"Piecework";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job Code"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Partida';


    }
    field(10;"Period End Date";Date)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha Fin Periodo';
                                                   Editable=false;

trigger OnValidate();
    BEGIN 
                                                                Rec.Period := FORMAT(Rec."Period End Date", 0, '<Year4>-<Month,2>');
                                                                Rec."Period Ini Date" := DMY2DATE(1, DATE2DMY(Rec."Period End Date", 2), DATE2DMY(Rec."Period End Date", 3));
                                                                Rec.VALIDATE("Document No.");
                                                              END;


    }
    field(11;"Period Ini Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha Inicio Periodo';
                                                   Description='JAV 10/11/22 Fecha de inicio del periodo';
                                                   Editable=false;


    }
    field(12;"Index";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='index';


    }
    field(14;"Status";Option)
    {
        OptionMembers="Created","Calculated","Posted";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Estado';
                                                   OptionCaptionML=ENU='Created,Calculated,Generated',ESP='Creado,Calculado,Registrado';
                                                   


    }
    field(15;"Document No.";Code[20])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Documento';

trigger OnValidate();
    BEGIN 
                                                                IF (NOT QBActivableExpensesSetup.GET()) THEN
                                                                  QBActivableExpensesSetup."Serie for Activables Expenses" := 'ACT-%1-%2';

                                                                Rec."Document No." := COPYSTR(STRSUBSTNO(QBActivableExpensesSetup."Serie for Activables Expenses", Rec.Period, Rec."Job Code"), 1, MAXSTRLEN(Rec."Document No." ));
                                                              END;


    }
    field(16;"Job Status Type";Option)
    {
        OptionMembers=" ","Estudio","Proyecto operativo","Promocion","Presupuesto";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Usage',ESP='Tipo de proyecto';
                                                   OptionCaptionML=ENU='" ,Planning,Project,Real State,Budget"',ESP='" ,Estudio,Proyecto operativo,Promoci¢n,Presupuesto"';
                                                   
                                                   Description='Tipo de proyecto seg£n la tabla de estados';


    }
    field(17;"Job Status Code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Estado del Proyecto';
                                                   Description='Estado del proyecto seg£n la tabla de estados';


    }
    field(20;"Amount G6";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("G/L Entry"."Amount" WHERE ("QB Activation Code"=FIELD("Period"),
                                                                                             "Job No."=FIELD(FILTER("Job Code")),
                                                                                             "QB Piecework Code"=FIELD(FILTER("Piecework")),
                                                                                             "G/L Account No."=FILTER(6..7)));
                                                   CaptionML=ESP='Importe G6';


    }
    field(21;"Amount G7";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("G/L Entry"."Amount" WHERE ("QB Activation Code"=FIELD("Period"),
                                                                                             "Job No."=FIELD(FILTER("Job Code")),
                                                                                             "QB Piecework Code"=FIELD(FILTER("Piecework")),
                                                                                             "G/L Account No."=FILTER(7..8)));
                                                   CaptionML=ESP='Importe G7';


    }
    field(22;"Activation Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("G/L Entry"."Amount" WHERE ("QB Activation Code"=FIELD("Period"),
                                                                                             "Job No."=FIELD(FILTER("Job Code")),
                                                                                             "QB Piecework Code"=FIELD(FILTER("Piecework")),
                                                                                             "G/L Account No."=FILTER(6..8)));
                                                   CaptionML=ESP='Importe a Activar';


    }
    field(23;"Activation Management";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Imp. Activado Gesti¢n';


    }
    field(24;"Activation Financial";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Imp. Activado Financiero';


    }
    field(25;"Activation Managemen to Finan.";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Imp. de Gesti¢n a financiero';
                                                   Description='JAV 17/11/22 Importe pasado de gesti¢n a financiero';


    }
    field(30;"Total Management";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Expenses Activation"."Activation Management" WHERE ("Period"=FIELD("Period"),
                                                                                                                           "Job Code"=FIELD(FILTER("Job Code")),
                                                                                                                           "Piecework"=FIELD(FILTER("Piecework"))));
                                                   CaptionML=ESP='Activado Gesti¢n';
                                                   Description='JAV 18/11/22 Importe total para los c lculos';
                                                   Editable=false;


    }
    field(31;"Total Financial";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Expenses Activation"."Activation Financial" WHERE ("Period"=FIELD("Period"),
                                                                                                                          "Job Code"=FIELD(FILTER("Job Code")),
                                                                                                                          "Piecework"=FIELD(FILTER("Piecework"))));
                                                   CaptionML=ESP='Activado Financiero';
                                                   Description='JAV 18/11/22 Importe total para los c lculos';
                                                   Editable=false;


    }
    field(32;"Total Managemen to Finan.";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Expenses Activation"."Activation Managemen to Finan." WHERE ("Period"=FIELD("Period"),
                                                                                                                                    "Job Code"=FIELD(FILTER("Job Code")),
                                                                                                                                    "Piecework"=FIELD(FILTER("Piecework"))));
                                                   CaptionML=ESP='De Gesti¢n a financiero';
                                                   Description='JAV 18/11/22 Importe total para los c lculos';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Period","Job Code","Piecework")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       GLEntry@1100286000 :
      GLEntry: Record 17;
//       QBExpensesActivation2@1100286001 :
      QBExpensesActivation2: Record 7206995;
//       QBActivableExpensesSetup@1100286002 :
      QBActivableExpensesSetup: Record 7206997;

    

trigger OnInsert();    begin
               Rec.VALIDATE("Document No.");
             end;

trigger OnModify();    begin
               Rec.VALIDATE("Document No.");
             end;

trigger OnDelete();    begin
               //No eliminar si tiene hijos
               if (Rec.Piecework = '') then begin
                 QBExpensesActivation2.RESET;
                 QBExpensesActivation2.SETRANGE(Period, Rec.Period);
                 if (Rec."Job Code" <> '') then
                   QBExpensesActivation2.SETRANGE("Job Code", Rec."Job Code");
                 if (QBExpensesActivation2.COUNT <> 1) then
                   ERROR('No puede eliminar el padre sin eliminar sus hijos');
               end;

               //Al eliminar desmarcamos las l¡neas de la contabilidad para que vueltan a estar activas
               GLEntry.RESET;
               GLEntry.SETCURRENTKEY("QB Activation Code","Job No.","QB Piecework Code","G/L Account No.");
               GLEntry.SETRANGE("QB Activation Code", Rec.Period);
               GLEntry.SETRANGE("Job No.", Rec."Job Code");
               GLEntry.SETRANGE("QB Piecework Code", Rec.Piecework);
               GLEntry.MODIFYALL("QB Activation Code", '');
             end;



/*begin
    {
      JAV 10/10/22: - QB 1.12.00 Nueva tabla para activaciones, unifica las tres que se pensaron inicialmente
    }
    end.
  */
}







