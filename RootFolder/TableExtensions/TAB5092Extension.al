tableextension 50188 "MyExtension50188" extends "Opportunity"
{
  
  DataCaptionFields="No.","Description";
    CaptionML=ENU='Opportunity',ESP='Oportunidad';
    LookupPageID="Opportunity List";
    DrillDownPageID="Opportunity List";
  
  fields
{
    field(7207270;"Quote No.";Code[20])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Quote No.',ESP='No. oferta';
                                                   Description='QB 1.00' ;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Contact Company No.","Contact No.","Closed")
  //  {
       /* ;
 */
   // }
   // key(key3;"Salesperson Code","Closed")
  //  {
       /* ;
 */
   // }
   // key(key4;"Campaign No.","Closed")
  //  {
       /* ;
 */
   // }
   // key(key5;"Segment No.","Closed")
  //  {
       /* ;
 */
   // }
   // key(key6;"Sales Document Type","Sales Document No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"No.","Description","Creation Date","Status")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='You cannot delete this opportunity while it is active.',ESP='No puede borrar esta oportunidad mientras est‚ activa.';
//       Text001@1001 :
      Text001: TextConst ENU='You cannot create opportunities on an empty segment.',ESP='No puede crear oportunidades en un segmento cerrado.';
//       Text002@1002 :
      Text002: TextConst ENU='Do you want to create an opportunity for all contacts in the %1 segment?',ESP='¨Desea crear una oportunidad en todos los contactos del segmento %1?';
//       Text003@1009 :
      Text003: TextConst ENU='There is no sales quote that is assigned to this opportunity.',ESP='No hay ofertas de venta asignadas a esta oportunidad.';
//       Text004@1003 :
      Text004: TextConst ENU='Sales quote %1 does not exist.',ESP='La oferta de venta %1 no existe.';
//       Text005@1005 :
      Text005: TextConst ENU='You cannot assign a sales quote to the %2 record of the %1 while the %2 record of the %1 has no contact company assigned.',ESP='No puede asignar oferta venta al registro %2 de %1 cuando el registro %2 no tiene asignado contacto empresa.';
//       RMSetup@1011 :
      RMSetup: Record 5079;
//       Opp@1012 :
      Opp: Record 5092;
//       RMCommentLine@1013 :
      RMCommentLine: Record 5061;
//       SegHeader@1018 :
      SegHeader: Record 5076;
//       OppEntry@1020 :
      OppEntry: Record 5093;
//       RMCommentLineTmp@1022 :
      RMCommentLineTmp: Record 5061 TEMPORARY;
//       NoSeriesMgt@1014 :
      NoSeriesMgt: Codeunit 396;
//       Text006@1004 :
      Text006: TextConst ENU='Sales %1 %2 is already assigned to opportunity %3.',ESP='%1 %2 venta ya est  asignada a la oportunidad %3.';
//       ChangeConfirmQst@1007 :
      ChangeConfirmQst: 
// "%1 = Field Caption"
TextConst ENU='Do you want to change %1 on the related open tasks with the same %1?',ESP='¨Desea cambiar %1 en las tareas abiertas relacionadas con el mismo %1?';
//       Text009@1008 :
      Text009: TextConst ENU='Contact %1 %2 is related to another company.',ESP='Contacto %1 %2 est  relacionado con otra empresa.';
//       Text011@1010 :
      Text011: TextConst ENU='A sales quote has already been assigned to this opportunity.',ESP='Ya se ha asignado una oferta de venta a esta oportunidad.';
//       Text012@1017 :
      Text012: TextConst ENU='Current process @1@@@@@@@@@@@@@@@\',ESP='Proceso actual @1@@@@@@@@@@@@@@@\';
//       Text013@1016 :
      Text013: TextConst ENU='Current status  #2###############',ESP='Estado actual  #2###############';
//       Text014@1015 :
      Text014: TextConst ENU='Updating Tasks',ESP='Actualizando tareas';
//       Text022@1026 :
      Text022: TextConst ENU='You must fill in the %1 field.',ESP='Debe rellenar el campo %1.';
//       Text023@1025 :
      Text023: TextConst ENU='You must fill in the contact that is involved in the opportunity.',ESP='Debe seleccionar el contacto que est  relacionado con la oportunidad.';
//       Text024@1024 :
      Text024: TextConst ENU='%1 must be greater than 0.',ESP='%1 debe ser mayor que 0.';
//       Text025@1023 :
      Text025: TextConst ENU='The Estimated closing date has to be later than this change',ESP='La fecha estimada de cierre debe ser posterior a la fecha de esta modificaci¢n';
//       ActivateFirstStageQst@1021 :
      ActivateFirstStageQst: TextConst ENU='Would you like to activate first stage for this opportunity?',ESP='¨Desea activar la primera etapa para esta oportunidad?';
//       SalesCycleNotFoundErr@1019 :
      SalesCycleNotFoundErr: TextConst ENU='Sales Cycle Stage not found.',ESP='No se encontr¢ la etapa de ciclo de ventas.';
//       UpdateSalesQuoteWithCustTemplateQst@1006 :
      UpdateSalesQuoteWithCustTemplateQst: TextConst ENU='Do you want to update the sales quote with a customer template?',ESP='¨Desea actualizar la oferta de venta con una plantilla de cliente?';

    
    


/*
trigger OnInsert();    begin
               if "No." = '' then begin
                 RMSetup.GET;
                 RMSetup.TESTFIELD("Opportunity Nos.");
                 NoSeriesMgt.InitSeries(RMSetup."Opportunity Nos.",xRec."No. Series",0D,"No.","No. Series");
               end;

               if "Salesperson Code" = '' then
                 SetDefaultSalesperson;

               "Creation Date" := WORKDATE;
             end;


*/

/*
trigger OnDelete();    var
//                OppEntry@1000 :
               OppEntry: Record 5093;
             begin
               if Status = Status::"In Progress" then
                 ERROR(Text000);

               RMCommentLine.SETRANGE("Table Name",RMCommentLine."Table Name"::Opportunity);
               RMCommentLine.SETRANGE("No.","No.");
               RMCommentLine.DELETEALL;

               OppEntry.SETCURRENTKEY("Opportunity No.");
               OppEntry.SETRANGE("Opportunity No.","No.");
               OppEntry.DELETEALL;
             end;

*/



// procedure CreateFromInteractionLogEntry (InteractionLogEntry@1000 :

/*
procedure CreateFromInteractionLogEntry (InteractionLogEntry: Record 5065)
    begin
      INIT;
      "No." := '';
      "Creation Date" := WORKDATE;
      Description := InteractionLogEntry.Description;
      "Segment No." := InteractionLogEntry."Segment No.";
      "Segment Description" := InteractionLogEntry.Description;
      "Campaign No." := InteractionLogEntry."Campaign No.";
      "Salesperson Code" := InteractionLogEntry."Salesperson Code";
      "Contact No." := InteractionLogEntry."Contact No.";
      "Contact Company No." := InteractionLogEntry."Contact Company No.";
      SetDefaultSalesCycle;
      INSERT(TRUE);
      CopyCommentLinesFromIntLogEntry(InteractionLogEntry);
    end;
*/


    
//     procedure CreateFromSegmentLine (SegmentLine@1000 :
    
/*
procedure CreateFromSegmentLine (SegmentLine: Record 5077)
    begin
      INIT;
      "No." := '';
      "Creation Date" := WORKDATE;
      Description := SegmentLine.Description;
      "Segment No." := SegmentLine."Segment No.";
      "Segment Description" := SegmentLine.Description;
      "Campaign No." := SegmentLine."Campaign No.";
      "Salesperson Code" := SegmentLine."Salesperson Code";
      "Contact No." := SegmentLine."Contact No.";
      "Contact Company No." := SegmentLine."Contact Company No.";
      SetDefaultSalesCycle;
      INSERT(TRUE);
    end;
*/


    
//     procedure CreateOppFromOpp (var Opp@1007 :
    
/*
procedure CreateOppFromOpp (var Opp: Record 5092)
    var
//       Cont@1001 :
      Cont: Record 5050;
//       SalesPurchPerson@1002 :
      SalesPurchPerson: Record 13;
//       Campaign@1003 :
      Campaign: Record 5071;
//       SegHeader@1004 :
      SegHeader: Record 5076;
//       SegLine@1005 :
      SegLine: Record 5077;
    begin
      DELETEALL;
      INIT;
      "Creation Date" := WORKDATE;
      SetDefaultSalesCycle;
      if Cont.GET(Opp.GETFILTER("Contact Company No.")) then begin
        VALIDATE("Contact No.",Cont."No.");
        "Salesperson Code" := Cont."Salesperson Code";
        SETRANGE("Contact Company No.","Contact No.");
      end;
      if Cont.GET(Opp.GETFILTER("Contact No.")) then begin
        VALIDATE("Contact No.",Cont."No.");
        "Salesperson Code" := Cont."Salesperson Code";
        SETRANGE("Contact No.","Contact No.");
      end;
      if SalesPurchPerson.GET(Opp.GETFILTER("Salesperson Code")) then begin
        "Salesperson Code" := SalesPurchPerson.Code;
        SETRANGE("Salesperson Code","Salesperson Code");
      end;
      if Campaign.GET(Opp.GETFILTER("Campaign No.")) then begin
        "Campaign No." := Campaign."No.";
        "Salesperson Code" := Campaign."Salesperson Code";
        SETRANGE("Campaign No.","Campaign No.");
      end;
      if SegHeader.GET(Opp.GETFILTER("Segment No.")) then begin
        SegLine.SETRANGE("Segment No.",SegHeader."No.");
        if SegLine.COUNT = 0 then
          ERROR(Text001);
        "Segment No." := SegHeader."No.";
        "Campaign No." := SegHeader."Campaign No.";
        "Salesperson Code" := SegHeader."Salesperson Code";
        SETRANGE("Segment No.","Segment No.");
      end;

      StartWizard;
    end;
*/


//     LOCAL procedure InsertOpportunity (var Opp2@1000 : Record 5092;OppEntry2@1004 : Record 5093;var RMCommentLineTmp@1007 : Record 5061;ActivateFirstStage@1006 :
    
/*
LOCAL procedure InsertOpportunity (var Opp2: Record 5092;OppEntry2: Record 5093;var RMCommentLineTmp: Record 5061;ActivateFirstStage: Boolean)
    var
//       SegHeader@1001 :
      SegHeader: Record 5076;
//       SegLine@1002 :
      SegLine: Record 5077;
//       SalesCycleStage@1003 :
      SalesCycleStage: Record 5091;
//       OppEntry@1005 :
      OppEntry: Record 5093;
    begin
      Opp := Opp2;

      if ActivateFirstStage then begin
        SalesCycleStage.RESET;
        SalesCycleStage.SETRANGE("Sales Cycle Code",Opp."Sales Cycle Code");
        if SalesCycleStage.FINDFIRST then
          OppEntry2."Sales Cycle Stage" := SalesCycleStage.Stage;
      end;

      if SegHeader.GET(GETFILTER("Segment No.")) then begin
        SegLine.SETRANGE("Segment No.",SegHeader."No.");
        SegLine.SETFILTER("Contact No.",'<>%1','');
        if SegLine.FIND('-') then begin
          if CONFIRM(Text002,TRUE,SegHeader."No.") then
            repeat
              Opp."Contact No." := SegLine."Contact No.";
              Opp."Contact Company No." := SegLine."Contact Company No.";
              CLEAR(Opp."No.");
              Opp.INSERT(TRUE);
              CreateCommentLines(RMCommentLineTmp,Opp."No.");
              if ActivateFirstStage then begin
                OppEntry.INIT;
                OppEntry := OppEntry2;
                OppEntry.InitOpportunityEntry(Opp);
                OppEntry.InsertEntry(OppEntry,FALSE,TRUE);
                OppEntry.UpdateEstimates;
              end;
            until SegLine.NEXT = 0;
        end;
      end else begin
        Opp.INSERT(TRUE);
        CreateCommentLines(RMCommentLineTmp,Opp."No.");
        if ActivateFirstStage then begin
          OppEntry.INIT;
          OppEntry := OppEntry2;
          OppEntry.InitOpportunityEntry(Opp);
          OppEntry.InsertEntry(OppEntry,FALSE,TRUE);
          OppEntry.UpdateEstimates;
        end;
      end;
    end;
*/


    
    
/*
procedure UpdateOpportunity ()
    var
//       TempOppEntry@1000 :
      TempOppEntry: Record 5093 TEMPORARY;
    begin
      if "No." <> '' then
        TempOppEntry.UpdateOppFromOpp(Rec);
    end;
*/


    
    
/*
procedure CloseOpportunity ()
    var
//       TempOppEntry@1000 :
      TempOppEntry: Record 5093 TEMPORARY;
    begin
      if "No." <> '' then
        TempOppEntry.CloseOppFromOpp(Rec);
    end;
*/


    
    
/*
procedure CreateQuote ()
    var
//       Cont@1001 :
      Cont: Record 5050;
//       ContactBusinessRelation@1002 :
      ContactBusinessRelation: Record 5054;
//       SalesHeader@1000 :
      SalesHeader: Record 36;
//       CustTemplate@1004 :
      CustTemplate: Record 5105;
//       CustTemplateCode@1003 :
      CustTemplateCode: Code[10];
    begin
      Cont.GET("Contact No.");

      if (Cont.Type = Cont.Type::Person) and (Cont."Company No." = '') then
        ERROR(
          Text005,
          Cont.TABLECAPTION,Cont."No.");

      if SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") then
        ERROR(Text011);

      if Cont.Type = Cont.Type::Person then
        Cont.GET(Cont."Company No.");

      if Cont.Type = Cont.Type::Company then begin
        ContactBusinessRelation.SETRANGE("Contact No.",Cont."No.");
        ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
        if ContactBusinessRelation.ISEMPTY then
          if GUIALLOWED then begin
            CustTemplateCode := Cont.ChooseCustomerTemplate;
            if CustTemplateCode <> '' then
              Cont.CreateCustomer(CustTemplateCode)
            else
              if CONFIRM(UpdateSalesQuoteWithCustTemplateQst) then
                if PAGE.RUNMODAL(0,CustTemplate) = ACTION::LookupOK then
                  CustTemplateCode := CustTemplate.Code;
          end;
      end;

      TESTFIELD(Status,Status::"In Progress");

      SalesHeader.SETRANGE("Sell-to Contact No.","Contact No.");
      SalesHeader.INIT;
      SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
      SalesHeader.INSERT(TRUE);
      SalesHeader.VALIDATE("Salesperson Code","Salesperson Code");
      SalesHeader.VALIDATE("Campaign No.","Campaign No.");
      SalesHeader."Opportunity No." := "No.";
      SalesHeader."Order Date" := GetEstimatedClosingDate;
      SalesHeader."Shipment Date" := SalesHeader."Order Date";
      if CustTemplateCode <> '' then
        SalesHeader.VALIDATE("Sell-to Customer Template Code",CustTemplateCode);
      SalesHeader.MODIFY;
      "Sales Document Type" := "Sales Document Type"::Quote;
      "Sales Document No." := SalesHeader."No.";
      MODIFY;

      PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
    end;
*/


    
/*
LOCAL procedure GetEstimatedClosingDate () : Date;
    var
//       OppEntry@1000 :
      OppEntry: Record 5093;
    begin
      OppEntry.SETCURRENTKEY(Active,"Opportunity No.");
      OppEntry.SETRANGE(Active,TRUE);
      OppEntry.SETRANGE("Opportunity No.","No.");
      if OppEntry.FINDFIRST then
        exit(OppEntry."Estimated Close Date");
    end;
*/


    
    
/*
procedure ShowQuote ()
    var
//       SalesHeader@1000 :
      SalesHeader: Record 36;
    begin
      if SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") then
        PAGE.RUNMODAL(PAGE::"Sales Quote",SalesHeader);
    end;
*/


//     LOCAL procedure CreateCommentLines (var RMCommentLineTmp@1001 : Record 5061;OppNo@1000 :
    
/*
LOCAL procedure CreateCommentLines (var RMCommentLineTmp: Record 5061;OppNo: Code[20])
    begin
      if RMCommentLineTmp.FIND('-') then
        repeat
          RMCommentLine.INIT;
          RMCommentLine := RMCommentLineTmp;
          RMCommentLine."No." := OppNo;
          RMCommentLine.INSERT;
        until RMCommentLineTmp.NEXT = 0;
    end;
*/


//     LOCAL procedure CopyCommentLinesFromIntLogEntry (InteractionLogEntry@1000 :
    
/*
LOCAL procedure CopyCommentLinesFromIntLogEntry (InteractionLogEntry: Record 5065)
    var
//       RlshpMgtCommentLine@1001 :
      RlshpMgtCommentLine: Record 5061;
//       InterLogEntryCommentLine@1002 :
      InterLogEntryCommentLine: Record 5123;
    begin
      InterLogEntryCommentLine.SETRANGE("Entry No.",InteractionLogEntry."Entry No.");
      if InterLogEntryCommentLine.FINDSET then
        repeat
          RlshpMgtCommentLine.INIT;
          RlshpMgtCommentLine."Table Name" := RlshpMgtCommentLine."Table Name"::Opportunity;
          RlshpMgtCommentLine."No." := "No.";
          RlshpMgtCommentLine."Line No." := InterLogEntryCommentLine."Line No.";
          RlshpMgtCommentLine.Date := InterLogEntryCommentLine.Date;
          RlshpMgtCommentLine.Code := InterLogEntryCommentLine.Code;
          RlshpMgtCommentLine.Comment := InterLogEntryCommentLine.Comment;
          RlshpMgtCommentLine."Last Date Modified" := InterLogEntryCommentLine."Last Date Modified";
          RlshpMgtCommentLine.INSERT;
        until InterLogEntryCommentLine.NEXT = 0;
    end;
*/


    
/*
LOCAL procedure StartWizard ()
    var
//       Cont@1000 :
      Cont: Record 5050;
//       Campaign@1001 :
      Campaign: Record 5071;
//       SegHeader@1002 :
      SegHeader: Record 5076;
    begin
      "Wizard Step" := "Wizard Step"::"1";

      if Cont.GET(GETFILTER("Contact No.")) then
        "Wizard Contact Name" := Cont.Name
      else
        if Cont.GET(GETFILTER("Contact Company No.")) then
          "Wizard Contact Name" := Cont.Name;

      if Campaign.GET(GETFILTER("Campaign No.")) then
        "Wizard Campaign Description" := Campaign.Description;
      if SegHeader.GET(GETFILTER("Segment No.")) then
        "Segment Description" := SegHeader.Description;

      INSERT;
      if PAGE.RUNMODAL(PAGE::"Create Opportunity",Rec) = ACTION::OK then;
    end;
*/


    
    
/*
procedure CheckStatus ()
    begin
      if "Creation Date" = 0D then
        ErrorMessage(FIELDCAPTION("Creation Date"));
      if Description = '' then
        ErrorMessage(FIELDCAPTION(Description));

      if not SegHeader.GET(GETFILTER("Segment No.")) then
        if "Contact No." = '' then
          ERROR(Text023);
      if "Salesperson Code" = '' then
        ErrorMessage(FIELDCAPTION("Salesperson Code"));
      if "Sales Cycle Code" = '' then
        ErrorMessage(FIELDCAPTION("Sales Cycle Code"));

      if "Activate First Stage" then begin
        if "Wizard Estimated Value (LCY)" <= 0 then
          ERROR(Text024,FIELDCAPTION("Wizard Estimated Value (LCY)"));
        if "Wizard Chances of Success %" <= 0 then
          ERROR(Text024,FIELDCAPTION("Wizard Chances of Success %"));
        if "Wizard Estimated Closing Date" = 0D then
          ErrorMessage(FIELDCAPTION("Wizard Estimated Closing Date"));
        if "Wizard Estimated Closing Date" < OppEntry."Date of Change" then
          ERROR(Text025);
      end;
    end;
*/


    
    
/*
procedure FinishWizard ()
    var
//       ActivateFirstStage@1000 :
      ActivateFirstStage: Boolean;
    begin
      "Wizard Step" := Opp."Wizard Step"::" ";
      ActivateFirstStage := "Activate First Stage";
      "Activate First Stage" := FALSE;
      OppEntry."Chances of Success %" := "Wizard Chances of Success %";
      OppEntry."Estimated Close Date" := "Wizard Estimated Closing Date";
      OppEntry."Estimated Value (LCY)" := "Wizard Estimated Value (LCY)";

      "Wizard Chances of Success %" := 0;
      "Wizard Estimated Closing Date" := 0D;
      "Wizard Estimated Value (LCY)" := 0;
      "Segment Description" := '';
      "Wizard Contact Name" := '';
      "Wizard Campaign Description" := '';

      InsertOpportunity(Rec,OppEntry,RMCommentLineTmp,ActivateFirstStage);
      DELETE;
    end;
*/


//     LOCAL procedure ErrorMessage (FieldName@1000 :
    
/*
LOCAL procedure ErrorMessage (FieldName: Text[1024])
    begin
      ERROR(Text022,FieldName);
    end;
*/


    
//     procedure SetComments (var RMCommentLine@1001 :
    
/*
procedure SetComments (var RMCommentLine: Record 5061)
    begin
      RMCommentLineTmp.DELETEALL;

      if RMCommentLine.FINDSET then
        repeat
          RMCommentLineTmp := RMCommentLine;
          RMCommentLineTmp.INSERT;
        until RMCommentLine.NEXT = 0;
    end;
*/


    
    
/*
procedure ShowSalesQuoteWithCheck ()
    var
//       SalesHeader@1000 :
      SalesHeader: Record 36;
    begin
      if ("Sales Document Type" <> "Sales Document Type"::Quote) or
         ("Sales Document No." = '')
      then
        ERROR(Text003);

      if not SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") then
        ERROR(Text004,"Sales Document No.");
      PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
    end;
*/


    
    
/*
procedure SetSegmentFromFilter ()
    var
//       SegmentNo@1000 :
      SegmentNo: Code[20];
    begin
      SegmentNo := GetFilterSegmentNo;
      if SegmentNo = '' then begin
        FILTERGROUP(2);
        SegmentNo := GetFilterSegmentNo;
        FILTERGROUP(0);
      end;
      if SegmentNo <> '' then
        VALIDATE("Segment No.",SegmentNo);
    end;
*/


    
/*
LOCAL procedure GetFilterSegmentNo () : Code[20];
    begin
      if GETFILTER("Segment No.") <> '' then
        if GETRANGEMIN("Segment No.") = GETRANGEMAX("Segment No.") then
          exit(GETRANGEMAX("Segment No."));
    end;
*/


    
    
/*
procedure SetContactFromFilter ()
    var
//       ContactNo@1000 :
      ContactNo: Code[20];
    begin
      ContactNo := GetFilterContactNo;
      if ContactNo = '' then begin
        FILTERGROUP(2);
        ContactNo := GetFilterContactNo;
        FILTERGROUP(0);
      end;
      if ContactNo <> '' then
        VALIDATE("Contact No.",ContactNo);
    end;
*/


    
/*
LOCAL procedure GetFilterContactNo () : Code[20];
    begin
      if (GETFILTER("Contact No.") <> '') and (GETFILTER("Contact No.") <> '<>''''') then
        if GETRANGEMIN("Contact No.") = GETRANGEMAX("Contact No.") then
          exit(GETRANGEMAX("Contact No."));
      if GETFILTER("Contact Company No.") <> '' then
        if GETRANGEMIN("Contact Company No.") = GETRANGEMAX("Contact Company No.") then
          exit(GETRANGEMAX("Contact Company No."));
    end;
*/


    
    
/*
procedure StartActivateFirstStage ()
    var
//       SalesCycleStage@1000 :
      SalesCycleStage: Record 5091;
//       OpportunityEntry@1001 :
      OpportunityEntry: Record 5093;
    begin
      if CONFIRM(ActivateFirstStageQst) then begin
        TESTFIELD("Sales Cycle Code");
        TESTFIELD(Status,Status::"not Started");
        SalesCycleStage.SETRANGE("Sales Cycle Code","Sales Cycle Code");
        if SalesCycleStage.FINDFIRST then begin
          OpportunityEntry.INIT;
          OpportunityEntry."Sales Cycle Stage" := SalesCycleStage.Stage;
          OpportunityEntry."Sales Cycle Stage Description" := SalesCycleStage.Description;
          OpportunityEntry.InitOpportunityEntry(Rec);
          OpportunityEntry.InsertEntry(OpportunityEntry,FALSE,TRUE);
          OpportunityEntry.UpdateEstimates;
        end else
          ERROR(SalesCycleNotFoundErr);
      end;
    end;
*/


    
    
/*
procedure SetDefaultSalesCycle ()
    var
//       SalesCycle@1000 :
      SalesCycle: Record 5090;
    begin
      RMSetup.GET;
      if RMSetup."Default Sales Cycle Code" <> '' then
        if SalesCycle.GET(RMSetup."Default Sales Cycle Code") then
          if not SalesCycle.Blocked then
            "Sales Cycle Code" := RMSetup."Default Sales Cycle Code";
    end;
*/


    
/*
LOCAL procedure SetDefaultSalesperson ()
    var
//       UserSetup@1000 :
      UserSetup: Record 91;
    begin
      if not UserSetup.GET(USERID) then
        exit;

      if UserSetup."Salespers./Purch. Code" <> '' then
        VALIDATE("Salesperson Code",UserSetup."Salespers./Purch. Code");
    end;
*/


    
/*
LOCAL procedure LookupCampaigns ()
    var
//       Campaign@1000 :
      Campaign: Record 5071;
//       Opportunity@1001 :
      Opportunity: Record 5092;
    begin
      Campaign.SETFILTER("Starting Date",'..%1',"Creation Date");
      Campaign.SETFILTER("Ending Date",'%1..',"Creation Date");
      Campaign.CALCFIELDS(Activated);
      Campaign.SETRANGE(Activated,TRUE);
      if PAGE.RUNMODAL(0,Campaign) = ACTION::LookupOK then begin
        Opportunity := Rec;
        Opportunity.VALIDATE("Campaign No.",Campaign."No.");
        Rec := Opportunity;
      end;
    end;
*/


    
/*
LOCAL procedure LookupSegments ()
    var
//       SegmentHeader@1000 :
      SegmentHeader: Record 5076;
    begin
      if "Campaign No." <> '' then
        SegmentHeader.SETRANGE("Campaign No.","Campaign No.");
      if PAGE.RUNMODAL(0,SegmentHeader) = ACTION::LookupOK then
        VALIDATE("Segment No.",SegmentHeader."No.");
    end;
*/


    
/*
LOCAL procedure CheckCampaign ()
    var
//       Campaign@1000 :
      Campaign: Record 5071;
    begin
      if "Campaign No." <> '' then begin
        Campaign.GET("Campaign No.");
        if (Campaign."Starting Date" > "Creation Date") or (Campaign."Ending Date" < "Creation Date") then
          FIELDERROR("Campaign No.");
        Campaign.CALCFIELDS(Activated);
        Campaign.TESTFIELD(Activated,TRUE);
      end;
    end;
*/


    
/*
LOCAL procedure CheckSegmentCampaignNo ()
    var
//       SegmentHeader@1000 :
      SegmentHeader: Record 5076;
    begin
      SegmentHeader.GET("Segment No.");
      if SegmentHeader."Campaign No." <> '' then
        SegmentHeader.TESTFIELD("Campaign No.","Campaign No.");
    end;
*/


    
/*
LOCAL procedure SetDefaultSegmentNo ()
    var
//       SegmentHeader@1000 :
      SegmentHeader: Record 5076;
    begin
      "Segment No." := '';
      if "Campaign No." <> '' then begin
        SegmentHeader.SETRANGE("Campaign No.","Campaign No.");
        if SegmentHeader.FINDFIRST and (SegmentHeader.COUNT = 1) then
          "Segment No." := SegmentHeader."No."
      end;
    end;
*/


    
    
/*
procedure SetCampaignFromFilter ()
    var
//       CampaignNo@1000 :
      CampaignNo: Code[20];
    begin
      CampaignNo := GetFilterCampaignNo;
      if CampaignNo = '' then begin
        FILTERGROUP(2);
        CampaignNo := GetFilterCampaignNo;
        FILTERGROUP(0);
      end;
      if CampaignNo <> '' then
        VALIDATE("Campaign No.",CampaignNo);
    end;
*/


    
/*
LOCAL procedure GetFilterCampaignNo () : Code[20];
    begin
      if GETFILTER("Campaign No.") <> '' then
        if GETRANGEMIN("Campaign No.") = GETRANGEMAX("Campaign No.") then
          exit(GETRANGEMAX("Campaign No."));
    end;

    /*begin
    end.
  */
}




