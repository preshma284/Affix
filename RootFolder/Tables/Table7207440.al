table 7207440 "TAux Jobs Status"
{


    CaptionML = ENU = 'Internal Status', ESP = 'Estados internos';
    LookupPageID = "Jobs Status List";
    DrillDownPageID = "Jobs Status List";

    fields
    {
        field(1; "Usage"; Option)
        {
            OptionMembers = " ","Estudio","Proyecto operativo","Promocion","Presupuesto";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Usage', ESP = 'Uso';
            OptionCaptionML = ENU = '" ,Planning,Project,Real State,Budget"', ESP = '" ,Estudio,Proyecto operativo,Promoci�n,Presupuesto"';



        }
        field(2; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code', ESP = 'C�digo';


        }
        field(3; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Description', ESP = 'Descripción';


        }
        field(4; "Order"; Integer)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Order', ESP = 'Orden';

            trigger OnValidate();
            VAR
                //                                                                 nOrder@1100286000 :
                nOrder: Integer;
            BEGIN
                nOrder := Order;

                InternalStatus.RESET;
                InternalStatus.SETCURRENTKEY(Order);
                InternalStatus.SETRANGE(Usage, Rec.Usage);
                InternalStatus.SETFILTER(Order, '>=%1', Order);
                IF InternalStatus.FINDSET(TRUE) THEN
                    REPEAT
                        nOrder += 1;
                        InternalStatus.Order := nOrder;
                        InternalStatus.MODIFY;
                    UNTIL InternalStatus.NEXT = 0;
            END;


        }
        field(5; "Editable Card"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Editable Card', ESP = 'Ficha editable';


        }
        field(6; "Change Date"; Option)
        {
            OptionMembers = " ","1","2","3","4","5","envio";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cambiar Fecha';
            OptionCaptionML = ESP = '" ,1,2,3,4,5,env�o"';



        }
        field(8; "Date Caption"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Descripción Fecha';


        }
        field(9; "Operative"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Operativo';


        }
        field(11; "Date 1 editable"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha 1 Editable';


        }
        field(12; "Date 2 editable"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha 2 Editable';


        }
        field(13; "Date 3 editable"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha 3 Editable';


        }
        field(14; "Date 4 editable"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha 4 Editable';


        }
        field(15; "Date 5 editable"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha 5 Editable';


        }
        field(16; "Date E editable"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha E Editable';


        }
        field(50; "Activation"; Option)
        {
            OptionMembers = "  ","Management","Financial","Finished";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Capitalizable expenses', ESP = 'Estado Activaci�n';
            OptionCaptionML = ENU = '" Land,Under Construction,Completed"', ESP = '" ,Suelo,En Construcci�n,Finalizado"';

            Description = 'QB 1.10.31 JAV 06/04/22 se a�ade  JAV 04/10/22 Se cambia a tipo Option [TT] Indica si el proyecto en este estado puede generar los movimientos de activaci�n de los gastos. Solo es v�lido en proyectos de Real Estate';

            trigger OnValidate();
            BEGIN
                CASE Rec.Activation OF
                    Rec.Activation::"  ":
                        BEGIN
                            "Activation Account" := '';
                            "Activation Account BalGes" := '';
                            "Activation Account BalFin" := '';
                        END;
                    Rec.Activation::Management:
                        BEGIN
                            "Activation Account BalFin" := '';
                        END;
                END;
            END;


        }
        field(51; "Activation Account"; Code[20])
        {
            TableRelation = "G/L Account";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Activation Account', ESP = 'Cta. Debe Activaci�n';
            Description = 'QB 1.12.00 JAV 24/10/22: [TT] Cuenta al debe para los movimientos de la activaci�n del proyecto (grupo 3)';

            trigger OnValidate();
            BEGIN
                CheckGLAcc("Activation Account BalFin");
            END;


        }
        field(52; "Activation Account BalGes"; Code[20])
        {
            TableRelation = "G/L Account";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Activation Account Fin.', ESP = 'Cta. Haber Var. Exist.';
            Description = 'QB 1.12.00 JAV 24/10/22: [TT] Cuenta al haber para los movimientos de la activaci�n del proyecto en estado de gesti�n';

            trigger OnValidate();
            BEGIN
                CheckGLAcc("Activation Account BalGes");
            END;


        }
        field(53; "Activation Account BalFin"; Code[20])
        {
            TableRelation = "G/L Account";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Activation Account Ges.', ESP = 'Cta. Haber Act.Finan.';
            Description = 'QB 1.12.00 JAV 24/10/22: [TT] Cuenta al haber para los movimientos de la activaci�n del proyecto en estado de comercialziaci�n';

            trigger OnValidate();
            BEGIN
                CheckGLAcc("Activation Account");
            END;


        }
        field(54; "Desactivation Account"; Code[20])
        {
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cta. Debe Desactivaci�n';
            Description = 'QB 1.12.00 JAV 10/11/22: [TT] Cuenta al debe para los movimientos de la desactivaci�n del proyecto';


        }
    }
    keys
    {
        key(key1; "Usage", "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       InternalStatus@100000000 :
        InternalStatus: Record 7207440;



    trigger OnInsert();
    begin
        if (Order = 0) then begin
            InternalStatus.RESET;
            InternalStatus.SETCURRENTKEY(Order);
            InternalStatus.SETRANGE(Usage, Rec.Usage);
            if InternalStatus.FINDLAST then
                Order := InternalStatus.Order + 1
            else
                Order := 1;
        end;
    end;



    // procedure setDates (CardType@1100286011 : Option;InternalStatusCode@1100286013 : Code[20];InternalStatusEditable@1100286016 : Boolean;var txtFecha1@1100286007 : Text;var txtFecha2@1100286006 : Text;var txtFecha3@1100286005 : Text;var txtFecha4@1100286003 : Text;var txtFecha5@1100286002 : Text;var verFecha1@1100286019 : Boolean;var verFecha2@1100286018 : Boolean;var verFecha3@1100286015 : Boolean;var verFecha4@1100286008 : Boolean;var verFecha5@1100286004 : Boolean;var editFecha1@1100286024 : Boolean;var editFecha2@1100286023 : Boolean;var editFecha3@1100286022 : Boolean;var editFecha4@1100286021 : Boolean;var editFecha5@1100286020 : Boolean;var editFechaE@1100286000 :
    procedure setDates(CardType: Option; InternalStatusCode: Code[20]; InternalStatusEditable: Boolean; var txtFecha1: Text; var txtFecha2: Text; var txtFecha3: Text; var txtFecha4: Text; var txtFecha5: Text; var verFecha1: Boolean; var verFecha2: Boolean; var verFecha3: Boolean; var verFecha4: Boolean; var verFecha5: Boolean; var editFecha1: Boolean; var editFecha2: Boolean; var editFecha3: Boolean; var editFecha4: Boolean; var editFecha5: Boolean; var editFechaE: Boolean)
    var
        //       QuoBuildingSetup@1100286010 :
        QuoBuildingSetup: Record 7207278;
        //       editable@1100286014 :
        editable: Boolean;
    begin
        //JAV 12/06/19: - Cambio para usar las 5 fechas auxiliares m�s la de env�o al cliente
        QuoBuildingSetup.GET();

        txtFecha1 := GetDateName(CardType, 1);
        txtFecha2 := GetDateName(CardType, 2);
        txtFecha3 := GetDateName(CardType, 3);
        txtFecha4 := GetDateName(CardType, 4);
        txtFecha5 := GetDateName(CardType, 5);

        verFecha1 := (txtFecha1 <> '');
        verFecha2 := (txtFecha2 <> '');
        verFecha3 := (txtFecha3 <> '');
        verFecha4 := (txtFecha4 <> '');
        verFecha5 := (txtFecha5 <> '');

        editable := IfInternalStatusEditable(CardType) and InternalStatusEditable;
        editFecha1 := editable;
        editFecha2 := editable;
        editFecha3 := editable;
        editFecha4 := editable;
        editFecha5 := editable;
        editFechaE := editable;

        if (InternalStatus.GET(CardType, InternalStatusCode)) then begin
            editFecha1 := InternalStatus."Date 1 editable" and editable;
            editFecha2 := InternalStatus."Date 2 editable" and editable;
            editFecha3 := InternalStatus."Date 3 editable" and editable;
            editFecha4 := InternalStatus."Date 4 editable" and editable;
            editFecha5 := InternalStatus."Date 5 editable" and editable;
            editFechaE := InternalStatus."Date E editable" and editable;
        end;
    end;

    //     procedure GetInternalStatusEditable (CardType@1100286002 : Option;InternalStatusCode@1100286003 :
    procedure GetInternalStatusEditable(CardType: Option; InternalStatusCode: Code[20]): Boolean;
    var
        //       UserSetup@1100286000 :
        UserSetup: Record 91;
        //       Job@1100286004 :
        Job: Record 167;
        //       InternalStatusEditable@1100286001 :
        InternalStatusEditable: Boolean;
    begin
        //JAV 01/06/19: - Se pasa a una funci�n el que sea editable
        //-QCPM_GAP05

        //Si no tiene estado, se puede cambiar siempre
        InternalStatusEditable := TRUE;
        if InternalStatus.GET(CardType, InternalStatusCode) then
            InternalStatusEditable := InternalStatus."Editable Card";

        if not UserSetup.GET(USERID) then
            InternalStatusEditable := FALSE;

        CASE CardType OF
            Job."Card Type"::Estudio:
                InternalStatusEditable := (InternalStatusEditable and UserSetup."Modify Quote");
            Job."Card Type"::"Proyecto operativo":
                InternalStatusEditable := (InternalStatusEditable and UserSetup."Modify Job");
        end;

        exit(InternalStatusEditable);
    end;

    //     procedure IfInternalStatusEditable (CardType@1100286002 :
    procedure IfInternalStatusEditable(CardType: Option): Boolean;
    var
        //       UserSetup@1100286000 :
        UserSetup: Record 91;
        //       Job@1100286004 :
        Job: Record 167;
        //       InternalStatusEditable@1100286001 :
        InternalStatusEditable: Boolean;
    begin
        //JAV 01/06/19: - Si el campo que cambia el estado es o no editable por el usuario
        InternalStatusEditable := UserSetup.GET(USERID);

        CASE CardType OF
            Job."Card Type"::Estudio:
                InternalStatusEditable := (InternalStatusEditable and UserSetup."Modify Quote");
            Job."Card Type"::"Proyecto operativo":
                InternalStatusEditable := (InternalStatusEditable and UserSetup."Modify Job");
            Job."Card Type"::Presupuesto:
                InternalStatusEditable := (InternalStatusEditable and UserSetup."QPR Modify Budgets Status");
        end;

        exit(InternalStatusEditable);
    end;

    //     procedure GetDateName (pCardType@1100286004 : Option;pNro@1100286000 :
    procedure GetDateName(pCardType: Option; pNro: Integer): Text;
    var
        //       nro1@1100286002 :
        nro1: Integer;
        //       nro2@1100286003 :
        nro2: Integer;
        //       Texto@1100286001 :
        Texto: Text;
    begin
        InternalStatus.RESET;
        InternalStatus.SETRANGE(Usage, pCardType);
        InternalStatus.SETRANGE("Change Date", pNro);
        if InternalStatus.FINDFIRST then
            exit(InternalStatus."Date Caption")
        else
            exit('');
    end;

    //     LOCAL procedure CheckGLAcc (AccNo@1000 :
    LOCAL procedure CheckGLAcc(AccNo: Code[20])
    var
        //       GLAcc@1001 :
        GLAcc: Record 15;
    begin
        if AccNo <> '' then begin
            GLAcc.GET(AccNo);
            GLAcc.CheckGLAcc;
        end;
    end;

    /*begin
    //{
//      PEL 25/04/19: - GAP05
//      JAV 11/12/19: - Se a�ade el estado editable de la ficha al control de fechas
//      JAV 08/04/22: - Se a�ade el campo 10 "Activable" para los Gastos Activables
//      JAV 04/10/22: - Se cambia el campo 10 a tipo Option
//    }
    end.
  */
}







