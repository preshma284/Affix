page 7207604 "Contact Creation Wizard"
{
    CaptionML = ENU = 'Contact Creation Wizard', ESP = 'Asistente creaci�n contacto';
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    SourceTable = 5050;
    PageType = NavigatePage;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group("Step2")
            {

                Visible = Step2Visible;
                Enabled = TRUE;
                field("Text19071456"; Text19071456)
                {

                    CaptionClass = Text19071456;
                    MultiLine = true;
                }
                field("VAT Registration No."; rec."VAT Registration No.")
                {

                }
                field("Text19006328"; Text19006328)
                {

                    CaptionClass = Text19006328;
                }
                field("Activity Filter"; rec."Activity Filter")
                {

                }

            }
            group("Step1")
            {

                Visible = Step1Visible;
                Enabled = TRUE;
                field("Text19054172_1"; Text19054172)
                {

                    CaptionClass = Text19054172;
                    MultiLine = true;
                }
                field("Text19054172_2"; Text19054172)
                {

                    CaptionClass = Text19054172;
                }
                field("Name"; rec."Name")
                {

                }
                field("Name 2"; rec."Name 2")
                {

                }
                field("Text19042688"; Text19042688)
                {

                    CaptionClass = Text19042688;
                }
                field("Address"; rec."Address")
                {

                }
                field("Address 2"; rec."Address 2")
                {

                }
                field("Post Code"; rec."Post Code")
                {

                }
                field("City"; rec."City")
                {

                }
                field("County"; rec."County")
                {

                }
                field("Country/Region Code"; rec."Country/Region Code")
                {

                }
                field("Phone No."; rec."Phone No.")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("Back")
            {

                CaptionML = ENU = '&Back', ESP = 'At&r�s';
                Promoted = true;
                Enabled = BackEnable;
                Image = PreviousSet;
                PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    SetSubMenu(CurrMenu - 1);
                END;


            }
            action("Next")
            {

                CaptionML = ENU = '&Rec.NEXT', ESP = 'A&delante';
                Promoted = true;
                Enabled = NextEnable;
                Image = NextSet;
                PromotedCategory = Process;

                trigger OnAction()
                VAR
                    SalutationFormula: Record 5069;
                    Text001: TextConst ENU = 'You must fill in the %1 field.', ESP = 'Debe rellenar el campo %1.';
                BEGIN
                    SetSubMenu(CurrMenu + 1);
                END;


            }
            action("Finish")
            {

                CaptionML = ENU = '&Finish', ESP = '&Crear';
                Promoted = true;
                Enabled = FinishEnable;
                PromotedIsBig = true;
                Image = Approve;
                PromotedCategory = Process;

                trigger OnAction()
                VAR
                    Send: Boolean;
                    CreatingContacts: Codeunit 7207335;
                    Text50001: TextConst ENU = 'Contact %1 was created', ESP = 'Se ha creado el contacto %1';
                    Text001: TextConst ENU = 'You must fill in the %1 field.', ESP = 'Debe rellenar el campo %1.';
                BEGIN
                    IF (rec.Name = '') THEN
                        ERROR(Text001, rec.FIELDCAPTION(Name));
                    IF (rec."Activity Filter" = '') THEN
                        ERROR(Text001, rec.FIELDCAPTION("Activity Filter"));

                    Contact := Rec;
                    Contact.INSERT(TRUE);
                    CLEAR(CreatingContacts);
                    CreatingContacts.InsertActivitiesOnly(Contact);

                    MESSAGE(Text50001, Contact."No.");
                    CurrPage.CLOSE;
                END;


            }

        }
        area(Creation)
        {

            action("Clean")
            {

                CaptionML = ENU = 'Clean', ESP = '&Limpiar';
                Promoted = true;
                PromotedIsBig = true;
                Image = Start;


                trigger OnAction()
                VAR
                    MarketingSetup: Record 5079;
                    NoSeriesMgt: Codeunit 396;
                BEGIN
                    Initialize;
                END;


            }

        }
    }

    trigger OnOpenPage()
    BEGIN
        MaxMenu := 2;
        Initialize;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    VAR
        MarketingSetup: Record 5079;
        NoSeriesMgt: Codeunit 396;
    BEGIN
    END;



    var
        Contact: Record 5050;
        ActivityFilter: Code[250];
        CurrMenu: Integer;
        MaxMenu: Integer;
        BackEnable: Boolean;
        NextEnable: Boolean;
        CancelEnable: Boolean;
        FinishEnable: Boolean;
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        Text19071456: TextConst ENU = 'The following fields are optional. if you want to log your interaction now, click Finish.', ESP = 'Los siguientes campos son opcionales. Si desea archivar su interacci�n, pulse Terminar.';
        Text19006328: TextConst ENU = 'What is your activity?', ESP = '�Cual es su actividad/es?';
        Text19054172: TextConst ENU = 'This wizard helps you create contacts and information related to your activities', ESP = 'Este asistente le ayuda a crear contactos e informaci�n relativa a sus actividades';
        Text19026362: TextConst ENU = 'Contact name?', ESP = '�Nombre del contacto?';
        Text19042688: TextConst ENU = 'What is your address?', ESP = '�Cu�l es su direcci�n?';

    LOCAL procedure SetSubMenu(newMenu: Integer);
    begin
        CurrMenu := newMenu;
        if (CurrMenu < 1) then
            CurrMenu := 1;
        if (CurrMenu > MaxMenu) then
            CurrMenu := MaxMenu;

        Step1Visible := (CurrMenu = 1);
        Step2Visible := (CurrMenu = 2);
        BackEnable := (CurrMenu > 1);
        NextEnable := (CurrMenu < MaxMenu);
        FinishEnable := (CurrMenu = MaxMenu);
    end;

    LOCAL procedure Initialize();
    var
        locConfContactos: Record 5079;
        MarketingSetup: Record 5079;
    begin
        Rec.INIT;
        rec."No." := '';
        rec."Activity Filter" := ActivityFilter;
        if not Rec.INSERT then;

        CLEAR(Contact);

        SetSubMenu(0);
    end;

    procedure PassActivity(ActivityFilterPass: Code[250]);
    begin
        ActivityFilter := ActivityFilterPass;
    end;

    procedure GetContact(): Code[20];
    begin
        //JAV 25/07/19: - Cuando creas un contacto, retorna el contacto creado
        exit(Contact."No.");
    end;

    // begin
    /*{
      JAV 26/12/18: - Se cambia a tabla temporal para que se pueda cancelar sin crear nada
                    - Se mejoran y simplifican todos los procesos de la p�gina
      JAV 25/07/19: - Cuando creas un contacto, retorna el contacto creado
    }*///end
}







