tableextension 50129 "QBU General Ledger SetupExt" extends "General Ledger Setup"
{


    CaptionML = ENU = 'General Ledger Setup', ESP = 'Configuraci�n contabilidad';

    fields
    {
        field(7174331; "QuoSII Default SII Entity"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SIIEntity"),
                                                                                                   "SII Entity" = CONST(''));
            CaptionML = ENU = 'SII Entity', ESP = 'Entidad SII Predet.';
            Description = 'QuoSII_1.4.2.042';


        }
        field(7207270; "OLD_Dimensions for CA Code"; Code[20])
        {
            TableRelation = "Dimension";
            CaptionML = ENU = 'Dimensions for CA Code', ESP = 'Cod. Dimensi�n para CA';
            Description = '### ELIMINAR ### no se usa';


        }
        field(7207272; "OLD_Dimension Jobs Code"; Code[20])
        {
            TableRelation = "Dimension";
            CaptionML = ENU = 'Dimension Jobs Code', ESP = 'Cod. Dimensi�n proyectos';
            Description = '### ELIMINAR ### no se usa';


        }
        field(7207273; "OLD_Dimensions Dptos Code"; Code[20])
        {
            TableRelation = "Dimension";
            CaptionML = ENU = 'Dimensions Dptos Code', ESP = 'Cod. dimensi�n Dptos.';
            Description = '### ELIMINAR ### no se usa';


        }
        field(7207274; "OLD_Jobs Budget"; Code[10])
        {
            TableRelation = "G/L Budget Name";
            CaptionML = ENU = 'Jobs Budget', ESP = 'Presupuesto para proyectos';
            Description = '### ELIMINAR ### no se usa';


        }
        field(7207275; "OLD_Dimension JV Code"; Code[20])
        {
            TableRelation = "Dimension";
            CaptionML = ENU = 'Dimension JV Code', ESP = 'Cod. Dimension UTE';
            Description = '### ELIMINAR ### no se usa';


        }
        field(7207276; "OLD_Dimension Reestim. Code"; Code[20])
        {
            TableRelation = "Dimension";
            CaptionML = ENU = 'Dimension Reestimation Code', ESP = 'Cod. dimensi�n reestimaci�n';
            Description = '### ELIMINAR ### no se usa';


        }
        field(7207277; "OLD_Job Analyti View Code"; Code[10])
        {
            TableRelation = "Analysis View";
            CaptionML = ESP = 'Cod. vista anal�sis proyecto';
            Description = '### ELIMINAR ### no se usa';


        }
        field(7207278; "OLD_Acc. Sched. Name for Job"; Code[10])
        {
            TableRelation = "Acc. Schedule Name";
            CaptionML = ESP = 'Nombre cta. esq. para proyecto';
            Description = '### ELIMINAR ### no se usa';


        }
        field(7207279; "OLD_Job Dim. Default Value"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Dimension Code" = FIELD("OLD_Dimension Jobs Code"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Dimension Default Value', ESP = 'Valor dimensi�n proyecto por defecto';
            Description = '### ELIMINAR ### no se usa';


        }
    }
    keys
    {
        // key(key1;"Primary Key")
        //  {
        /* Clustered=true;
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       Text000@1000 :
        Text000: TextConst ENU = '%1 %2 %3 have %4 to %5.', ESP = '%1 %2 %3 tiene %4 a %5.';
        //       Text001@1001 :
        Text001: TextConst ENU = '%1 %2 have %3 to %4.', ESP = '%1 %2 tiene %3 a %4.';
        //       Text002@1002 :
        Text002: TextConst ENU = '%1 %2 %3 use %4.', ESP = '%1 %2 %3 utilice %4.';
        //       Text003@1003 :
        Text003: TextConst ENU = '%1 %2 use %3.', ESP = '%1 %2 utiliza %3.';
        //       Text004@1004 :
        Text004: TextConst ENU = '%1 must be rounded to the nearest %2.', ESP = 'Se debe redondear %1 al m�s cercano %2.';
        //       Text016@1013 :
        Text016: TextConst ENU = 'Enter one number or two numbers separated by a colon. ', ESP = 'Introduzca uno o dos n�meros separados por dos puntos. ';
        //       Text017@1014 :
        Text017: TextConst ENU = 'The online Help for this field describes how you can fill in the field.', ESP = 'La ayuda en l�nea describe c�mo utilizar este campo.';
        //       Text018@1015 :
        Text018: TextConst ENU = 'You cannot change the contents of the %1 field because there are posted ledger entries.', ESP = 'No se puede cambiar el contenido del campo %1 ya que hay movs. registrados.';
        //       Text021@1018 :
        Text021: TextConst ENU = 'You must close the program and start again in order to activate the amount-rounding feature.', ESP = 'Debe cerrar el programa y entrar de nuevo para activar la prop. de redondeo-importe.';
        //       Text022@1019 :
        Text022: TextConst ENU = 'You must close the program and start again in order to activate the unit-amount rounding feature.', ESP = 'Debe cerrar el programa y entrar de nuevo para activar la prop. de redondeo precio-producto.';
        //       Text023@1020 :
        Text023: TextConst ENU = '%1\You cannot use the same dimension twice in the same setup.', ESP = '%1\No puede usar la misma dim. dos veces en la misma config.';
        //       Dim@1021 :
        Dim: Record 348;
        //       GLEntry@1022 :
        GLEntry: Record 17;
        //       ItemLedgerEntry@1023 :
        ItemLedgerEntry: Record 32;
        //       JobLedgEntry@1024 :
        JobLedgEntry: Record 169;
        //       ResLedgEntry@1025 :
        ResLedgEntry: Record 203;
        //       FALedgerEntry@1026 :
        FALedgerEntry: Record 5601;
        //       MaintenanceLedgerEntry@1027 :
        MaintenanceLedgerEntry: Record 5625;
        //       InsCoverageLedgerEntry@1028 :
        InsCoverageLedgerEntry: Record 5629;
        //       VATPostingSetup@1029 :
        VATPostingSetup: Record 325;
        //       TaxJurisdiction@1030 :
        TaxJurisdiction: Record 320;
        //       AnalysisView@1032 :
        AnalysisView: Record 363;
        //       AnalysisViewEntry@1033 :
        AnalysisViewEntry: Record 365;
        //       AnalysisViewBudgetEntry@1034 :
        AnalysisViewBudgetEntry: Record 366;
        //       AdjAddReportingCurr@1005 :
        AdjAddReportingCurr: Report 86;
        //       UserSetupManagement@1007 :
        UserSetupManagement: Codeunit 5700;
        //       ErrorMessage@1036 :
        ErrorMessage: Boolean;
        //       DependentFieldActivatedErr@1009 :
        DependentFieldActivatedErr: TextConst ENU = 'You cannot change %1 because %2 is selected.', ESP = 'No puede cambiar %1 porque se ha seleccionado %2.';
        //       Text025@1016 :
        Text025: TextConst ENU = 'The field %1 should not be set to %2 if field %3 in %4 table is set to %5 because deadlocks can occur.', ESP = 'El campo %1 no debe estar establecido en %2 si el campo %3 de la tabla %4 est� definido en %5 porque pueden producirse bloqueos.';
        //       ObsoleteErr@1617 :
        ObsoleteErr: TextConst ENU = 'This field is obsolete, it has been replaced by Table 248 VAT Reg. No. Srv Config.', ESP = 'Este campo est� obsoleto, se ha sustituido por la configuraci�n del servicio del CIF/NIF de la tabla 248.';
        //       RecordHasBeenRead@1006 :
        RecordHasBeenRead: Boolean;


    //     procedure CheckDecimalPlacesFormat (var DecimalPlaces@1000 :

    /*
    procedure CheckDecimalPlacesFormat (var DecimalPlaces: Text[5])
        var
    //       OK@1001 :
          OK: Boolean;
    //       ColonPlace@1002 :
          ColonPlace: Integer;
    //       DecimalPlacesPart1@1003 :
          DecimalPlacesPart1: Integer;
    //       DecimalPlacesPart2@1004 :
          DecimalPlacesPart2: Integer;
    //       Check@1005 :
          Check: Text[5];
        begin
          OK := TRUE;
          ColonPlace := STRPOS(DecimalPlaces,':');

          if ColonPlace = 0 then begin
            if not EVALUATE(DecimalPlacesPart1,DecimalPlaces) then
              OK := FALSE;
            if (DecimalPlacesPart1 < 0) or (DecimalPlacesPart1 > 9) then
              OK := FALSE;
          end else begin
            Check := COPYSTR(DecimalPlaces,1,ColonPlace - 1);
            if Check = '' then
              OK := FALSE;
            if not EVALUATE(DecimalPlacesPart1,Check) then
              OK := FALSE;
            Check := COPYSTR(DecimalPlaces,ColonPlace + 1,STRLEN(DecimalPlaces));
            if Check = '' then
              OK := FALSE;
            if not EVALUATE(DecimalPlacesPart2,Check) then
              OK := FALSE;
            if DecimalPlacesPart1 > DecimalPlacesPart2 then
              OK := FALSE;
            if (DecimalPlacesPart1 < 0) or (DecimalPlacesPart1 > 9) then
              OK := FALSE;
            if (DecimalPlacesPart2 < 0) or (DecimalPlacesPart2 > 9) then
              OK := FALSE;
          end;

          if not OK then
            ERROR(
              Text016 +
              Text017);

          if ColonPlace = 0 then
            DecimalPlaces := FORMAT(DecimalPlacesPart1)
          else
            DecimalPlaces := STRSUBSTNO('%1:%2',DecimalPlacesPart1,DecimalPlacesPart2);
        end;
    */



    //     procedure GetCurrencyCode (CurrencyCode@1000 :

    /*
    procedure GetCurrencyCode (CurrencyCode: Code[10]) : Code[10];
        begin
          CASE CurrencyCode OF
            '':
              exit("LCY Code");
            "LCY Code":
              exit('');
            else
              exit(CurrencyCode);
          end;
        end;
    */




    /*
    procedure GetCurrencySymbol () : Text[10];
        begin
          if "Local Currency Symbol" <> '' then
            exit("Local Currency Symbol");

          exit("LCY Code");
        end;
    */




    /*
    procedure GetRecordOnce ()
        begin
          if RecordHasBeenRead then
            exit;
          GET;
          RecordHasBeenRead := TRUE;
        end;
    */


    //     LOCAL procedure RoundingErrorCheck (NameOfField@1000 :

    /*
    LOCAL procedure RoundingErrorCheck (NameOfField: Text[100])
        begin
          ErrorMessage := FALSE;
          if GLEntry.FINDFIRST then
            ErrorMessage := TRUE;
          if ItemLedgerEntry.FINDFIRST then
            ErrorMessage := TRUE;
          if JobLedgEntry.FINDFIRST then
            ErrorMessage := TRUE;
          if ResLedgEntry.FINDFIRST then
            ErrorMessage := TRUE;
          if FALedgerEntry.FINDFIRST then
            ErrorMessage := TRUE;
          if MaintenanceLedgerEntry.FINDFIRST then
            ErrorMessage := TRUE;
          if InsCoverageLedgerEntry.FINDFIRST then
            ErrorMessage := TRUE;
          if ErrorMessage then
            ERROR(
              Text018,
              NameOfField);
        end;
    */



    /*
    LOCAL procedure DeleteIntrastatJnl ()
        var
    //       IntrastatJnlBatch@1000 :
          IntrastatJnlBatch: Record 262;
    //       IntrastatJnlLine@1001 :
          IntrastatJnlLine: Record 263;
        begin
          if not IntrastatJnlBatch.READPERMISSION then
            exit;
          if not IntrastatJnlLine.READPERMISSION then
            exit;
          IntrastatJnlBatch.SETRANGE(Reported,FALSE);
          IntrastatJnlBatch.SETRANGE("Amounts in Add. Currency",TRUE);
          if IntrastatJnlBatch.FIND('-') then
            repeat
              IntrastatJnlLine.SETRANGE("Journal Template Name",IntrastatJnlBatch."Journal Template Name");
              IntrastatJnlLine.SETRANGE("Journal Batch Name",IntrastatJnlBatch.Name);
              IntrastatJnlLine.DELETEALL;
            until IntrastatJnlBatch.NEXT = 0;
        end;
    */



    /*
    LOCAL procedure DeleteAnalysisView ()
        begin
          if AnalysisView.FIND('-') then
            repeat
              if AnalysisView.Blocked = FALSE then begin
                AnalysisViewEntry.SETRANGE("Analysis View Code",AnalysisView.Code);
                AnalysisViewEntry.DELETEALL;
                AnalysisViewBudgetEntry.SETRANGE("Analysis View Code",AnalysisView.Code);
                AnalysisViewBudgetEntry.DELETEALL;
                AnalysisView."Last Entry No." := 0;
                AnalysisView."Last Budget Entry No." := 0;
                AnalysisView."Last Date Updated" := 0D;
                AnalysisView.MODIFY;
              end else begin
                AnalysisView."Refresh When Unblocked" := TRUE;
                AnalysisView.MODIFY;
              end;
            until AnalysisView.NEXT = 0;
        end;
    */



    //     procedure IsPostingAllowed (PostingDate@1000 :

    /*
    procedure IsPostingAllowed (PostingDate: Date) : Boolean;
        begin
          exit(PostingDate >= "Allow Posting From");
        end;
    */





    procedure OptimGLEntLockForMultiuserEnv(): Boolean;
    var
        //       InventorySetup@1000 :
        InventorySetup: Record 313;
    begin
        //To be refactore by EU Team
        // if "Use Legacy G/L Entry Locking" then
        //     exit(FALSE);

        if InventorySetup.GET then
            if InventorySetup."Automatic Cost Posting" then
                exit(FALSE);

        exit(TRUE);
    end;





    /*
    procedure FirstAllowedPostingDate () AllowedPostingDate : Date;
        var
    //       InvtPeriod@1000 :
          InvtPeriod: Record 5814;
        begin
          AllowedPostingDate := "Allow Posting From";
          if not InvtPeriod.IsValidDate(AllowedPostingDate) then
            AllowedPostingDate := CALCDATE('<+1D>',AllowedPostingDate);
        end;
    */



    /*
    procedure CheckAdjustForPaymentDisc ()
        begin
          VATPostingSetup.SETRANGE("Adjust for Payment Discount",TRUE);
          if VATPostingSetup.FINDFIRST then
            ERROR(
              '%1 %2 %3 use %4.',VATPostingSetup.TABLENAME,
              VATPostingSetup."VAT Bus. Posting Group",VATPostingSetup."VAT Prod. Posting Group",
              VATPostingSetup.FIELDNAME("Adjust for Payment Discount"));
          TaxJurisdiction.SETRANGE("Adjust for Payment Discount",TRUE);
          if TaxJurisdiction.FINDFIRST then
            ERROR(
              '%1 %2 use %3.',TaxJurisdiction.TABLENAME,
              TaxJurisdiction.Code,TaxJurisdiction.FIELDNAME("Adjust for Payment Discount"));
        end;
    */



    //     procedure UpdateDimValueGlobalDimNo (xDimCode@1001 : Code[20];DimCode@1002 : Code[20];ShortcutDimNo@1003 :

    /*
    procedure UpdateDimValueGlobalDimNo (xDimCode: Code[20];DimCode: Code[20];ShortcutDimNo: Integer)
        var
    //       DimensionValue@1000 :
          DimensionValue: Record 349;
        begin
          if Dim.CheckIfDimUsed(DimCode,ShortcutDimNo,'','',0) then
            ERROR(Text023,Dim.GetCheckDimErr);
          if xDimCode <> '' then begin
            DimensionValue.SETRANGE("Dimension Code",xDimCode);
            DimensionValue.MODIFYALL("Global Dimension No.",0);
          end;
          if DimCode <> '' then begin
            DimensionValue.SETRANGE("Dimension Code",DimCode);
            DimensionValue.MODIFYALL("Global Dimension No.",ShortcutDimNo);
          end;
          MODIFY;
        end;
    */



    /*
    LOCAL procedure HideDialog () : Boolean;
        begin
          exit((CurrFieldNo = 0) or not GUIALLOWED);
        end;
    */




    /*
    procedure UseVat () : Boolean;
        var
    //       GeneralLedgerSetupRecordRef@1000 :
          GeneralLedgerSetupRecordRef: RecordRef;
    //       UseVATFieldRef@1001 :
          UseVATFieldRef: FieldRef;
    //       UseVATFieldNo@1002 :
          UseVATFieldNo: Integer;
        begin
          GeneralLedgerSetupRecordRef.OPEN(DATABASE::"General Ledger Setup",FALSE);

          UseVATFieldNo := 10001;

          if not GeneralLedgerSetupRecordRef.FIELDEXIST(UseVATFieldNo) then
            exit(TRUE);

          if not GeneralLedgerSetupRecordRef.FINDFIRST then
            exit(FALSE);

          UseVATFieldRef := GeneralLedgerSetupRecordRef.FIELD(UseVATFieldNo);
          exit(UseVATFieldRef.VALUE);
        end;
    */



    //     procedure CheckAllowedPostingDates (NotificationType@1000 :

    /*
    procedure CheckAllowedPostingDates (NotificationType: Option "Error","Notificatio")
        begin
          UserSetupManagement.CheckAllowedPostingDatesRange("Allow Posting From",
            "Allow Posting To",NotificationType,DATABASE::"General Ledger Setup");
        end;
    */




    /*
    procedure GetPmtToleranceVisible () : Boolean;
        begin
          exit(("Payment Tolerance %" > 0) or ("Max. Payment Tolerance Amount" <> 0));
        end;

        /*begin
        //{
    //      JAV 12/06/19: - Se a�aden los campos con las dimensiones obligatorias para QB
    //      JAV 24/08/19: - Se elimina el campo "Job Dimension Default Value" que ahora est�r� en "QuoBuilding Setup" junto a otro campo
    //    }
        end.
      */
}





