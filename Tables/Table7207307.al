table 7207307 "QBU Competition/Quote"
{
  
  
    CaptionML=ENU='List of competitors in the offer',ESP='Lista de competidores en la oferta';
    LookupPageID="Competition/Quote";
    DrillDownPageID="Competition/Quote";
  
  fields
{
    field(1;"Quote Code";Code[20])
    {
        TableRelation="Job"."No.";
                                                   CaptionML=ENU='Quote Code',ESP='Cod. oferta';


    }
    field(2;"Competitor Code";Code[20])
    {
        TableRelation=Contact."No." WHERE ("Type"=CONST("Company"));
                                                   

                                                   CaptionML=ENU='Competition Code',ESP='Cod. competidor';
                                                   NotBlank=true;
                                                   Description='JAV 13/08/19: - Se cambia nombre y caption para hacerlos mas adecuados  QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';

trigger OnValidate();
    BEGIN 
                                                                Contact.GET("Competitor Code");
                                                                "Competitor Name" := Contact.Name;

                                                                //JAV 13/08/19: - A¤adimos los criterios definidos en el estudio al competidor y eliminamos si ha cambiado
                                                                IF ("Competitor Code" <> xRec."Competitor Code") THEN
                                                                  DeleteStandardCompetition("Quote Code", xRec."Competitor Code");

                                                                SetStandardCompetition("Quote Code", "Competitor Code");
                                                              END;


    }
    field(3;"% of Low";Decimal)
    {
        CaptionML=ENU='% of Low',ESP='% de baja';
                                                   DecimalPlaces=5:5;


    }
    field(4;"Contratista Amount";Decimal)
    {
        

                                                   CaptionML=ENU='Contratista Amount',ESP='Importe contratista';

trigger OnValidate();
    BEGIN 
                                                                CALCFIELDS("Bidding Bases Budget");
                                                                IF ("Bidding Bases Budget" <> 0) THEN
                                                                  "% of Low" := ROUND(("Bidding Bases Budget" - "Contratista Amount") * 100 / "Bidding Bases Budget", 0.00001)
                                                                ELSE
                                                                  "% of Low" := 0;
                                                              END;


    }
    field(5;"Competitor Name";Text[50])
    {
        CaptionML=ENU='Competition Name',ESP='Nombre competidor';
                                                   Description='JAV 13/08/19: - Se cambia nombre y caption para hacerlos mas adecuados';


    }
    field(6;"Score High";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Standard/Competition"."Score" WHERE ("Quote Code"=FIELD("Quote Code"),
                                                                                                     "Competitor Code"=FIELD("Competitor Code")));
                                                   CaptionML=ENU='Score High',ESP='Suma puntuaci¢n';
                                                   Editable=false;


    }
    field(7;"Opening Result";Option)
    {
        OptionMembers=" ","Accepted","Outcast";

                                                   CaptionML=ENU='Opening Result',ESP='Resultado de apertura';
                                                   OptionCaptionML=ENU='" ,Accepted,Outcast"',ESP='" ,Aceptada,Rechazada"';
                                                   
                                                   Description='El estado por defecto ser  en blanco';

trigger OnValidate();
    BEGIN 
                                                                //JAV 28/02/22: - QB 1.10.21 Si marcamos uno como aceptado, quitamos la marca del resto si existe
                                                                IF ("Opening Result" = "Opening Result"::Accepted) THEN BEGIN 
                                                                  CompetitionQuote.RESET;
                                                                  CompetitionQuote.SETRANGE("Quote Code", "Quote Code");
                                                                  CompetitionQuote.SETFILTER("Competitor Code", '<>%1', Rec."Competitor Code");
                                                                  CompetitionQuote.SETRANGE("Opening Result", Rec."Opening Result"::Accepted);
                                                                  CompetitionQuote.MODIFYALL("Opening Result", Rec."Opening Result"::" ");
                                                                END;
                                                              END;


    }
    field(8;"Reason for Rejection";Text[30])
    {
        CaptionML=ENU='Reason for Rejection',ESP='Motivo rechazo';


    }
    field(9;"Evaluated";Boolean)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Exist("Standard/Competition" WHERE ("Quote Code"=FIELD("Quote Code"),
                                                                                                 "Competitor Code"=FIELD("Competitor Code"),
                                                                                                 "Score"=FILTER(<>0)));
                                                   CaptionML=ESP='Evaluado';
                                                   Description='JAV 23/10/19: - Si ha sido evaluado';
                                                   Editable=false;


    }
    field(10;"My Score";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Standard/Competition"."Score" WHERE ("Quote Code"=FIELD("Quote Code"),
                                                                                                     "Competitor Code"=CONST('')));
                                                   CaptionML=ENU='My Score',ESP='Puntuaci¢n Propia';
                                                   Description='JAV 13/08/19: - Suma de la puntuaci¢n propia';
                                                   Editable=false;


    }
    field(11;"Bidding Bases Budget";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Job"."Bidding Bases Budget" WHERE ("No."=FIELD("Quote Code")));
                                                   CaptionML=ESP='Ppto. base licitaci¢n';
                                                   Description='JAV 23/09/19: - Campo calculado que indica el importe de salida del proyecto';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Quote Code","Competitor Code")
    {
        SumIndexFields="% of Low","Contratista Amount";
                                                   Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Contact@7001100 :
      Contact: Record 5050;
//       CompetitionQuote@1100286000 :
      CompetitionQuote: Record 7207307;

    

trigger OnDelete();    begin
               //JAV 13/08/19: - Modificamos el delete para eliminar los criterios definidos en el estudio al competidor
               DeleteStandardCompetition("Quote Code", "Competitor Code");
             end;



// procedure SetStandardCompetition (Quote@1100286002 : Code[20];Competitor@1100286003 :
procedure SetStandardCompetition (Quote: Code[20];Competitor: Code[20])
    var
//       StandardQuote@1100286001 :
      StandardQuote: Record 7207305;
//       StandardCompetition@1100286000 :
      StandardCompetition: Record 7207306;
    begin
      StandardQuote.RESET;
      StandardQuote.SETRANGE("Quote Code", Quote);
      if (StandardQuote.FINDSET) then
        repeat
          StandardCompetition.INIT;
          StandardCompetition."Quote Code" := Quote;
          StandardCompetition."Competitor Code" := Competitor;
          StandardCompetition."Standard Code" := StandardQuote."Standard Code";
          if (not StandardCompetition.INSERT) then ;
        until (StandardQuote.NEXT = 0);
    end;

//     procedure DeleteStandardCompetition (Quote@1100286002 : Code[20];Competitor@1100286003 :
    procedure DeleteStandardCompetition (Quote: Code[20];Competitor: Code[20])
    var
//       StandardCompetition@1100286000 :
      StandardCompetition: Record 7207306;
    begin
      if (Competitor <> '') then begin
        StandardCompetition.RESET;
        StandardCompetition.SETRANGE("Quote Code", Quote);
        StandardCompetition.SETRANGE("Competitor Code", Competitor);
        StandardCompetition.DELETEALL;
      end;
    end;

//     procedure UpdateCompany (Quote@1100286000 :
    procedure UpdateCompany (Quote: Code[20])
    var
//       CompetitionQuote@1100286001 :
      CompetitionQuote: Record 7207307;
//       Job@1100286002 :
      Job: Record 167;
    begin
      Job.GET(Quote);
      if not Job.GET(Job."Presented Version") then
        Job.INIT;
      Job.CALCFIELDS("Amou Piecework Meas./Certifi.");

      if (not CompetitionQuote.GET(Quote,'')) then begin
        CompetitionQuote.INIT;
        CompetitionQuote."Quote Code"   := Quote;
        CompetitionQuote."Competitor Code" := '';
        CompetitionQuote."% of Low" := Job."Low Coefficient";
        CompetitionQuote.VALIDATE("Contratista Amount", Job."Amou Piecework Meas./Certifi.");
        CompetitionQuote."Competitor Name" := COMPANYNAME;
        CompetitionQuote.INSERT;
      end;

      CompetitionQuote."% of Low" := Job."Low Coefficient";
      CompetitionQuote.VALIDATE("Contratista Amount", Job."Amou Piecework Meas./Certifi.");
      CompetitionQuote.MODIFY;
      CompetitionQuote.SetStandardCompetition(Quote, '');
    end;

    /*begin
    //{
//      JAV 13/08/19: - A¤adimos los criterios definidos en el estudio al competidor
//                    - Modificamos el delete para eliminar los criterios definidos en el estudio al competidor
//      JAV 23/09/19: - Se cambia el caption de la tabla para que sea mas significativo
//                    - Se a¤ade el campo 9 "Evaluated" que indica si ha sido puntuado el competidor
//                    - Se a¤ade el campo 11 "Job Amount" Campo calculado que indica el importe de salida del proyecto
//                    - Se calcula la baja al introducir el importe de la oferta del competidor
//      JAV 19/12/19: - Si se acepta una oferta, se rechazan las otras y se informa la empresa en el estudio
//    }
    end.
  */
}







