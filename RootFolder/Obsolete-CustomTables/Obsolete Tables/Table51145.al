table 51145 "Business Setup1"
{


    DataPerCompany = false;
    CaptionML = ENU = 'Business Setup', ESP = 'Configuraci�n de negocio';

    fields
    {
        field(1; "Name"; Text[50])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';


        }
        field(2; "Description"; Text[250])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(3; "Keywords"; Text[250])
        {
            CaptionML = ENU = 'Keywords', ESP = 'Palabras clave';


        }
        field(4; "Setup Page ID"; Integer)
        {
            CaptionML = ENU = 'Setup Page ID', ESP = 'Configurar id. de p�gina';


        }
        field(5; "Area"; Option)
        {
            OptionMembers = "General","Finance","Sales","Jobs","Fixed Assets","Purchasing","Reference Data","HR","Inventory","Service","System","Relationship Mngt","Intercompany";
            CaptionML = ENU = 'Area', ESP = '�rea';
            OptionCaptionML = ENU = ',General,Finance,Sales,Jobs,Fixed Assets,Purchasing,Reference Data,HR,Inventory,Service,System,Relationship Mngt,Intercompany', ESP = ',General,Finanzas,Ventas,Trabajos,Activos fijos,Compras,Datos de referencia,RR. HH.,Inventario,Servicio,Sistema,Gest. relaciones,Empresas vinculadas';



        }
        field(7; "Icon"; Media)
        {
            CaptionML = ENU = 'Icon', ESP = 'Icono';
            ;


        }
    }
    keys
    {
        key(key1; "Name")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "Description", "Name", "Icon")
        {

        }
    }




    // procedure OnRegisterBusinessSetup (var TempBusinessSetup@1000 :
    procedure OnRegisterBusinessSetup(var TempBusinessSetup: Record 51145 TEMPORARY)
    begin
    end;



    //     procedure OnOpenBusinessSetupPage (var TempBusinessSetup@1000 : TEMPORARY Record 51145;var Handled@1001 :
    procedure OnOpenBusinessSetupPage(var TempBusinessSetup: Record 51145 TEMPORARY; var Handled: Boolean)
    begin
    end;


    //     procedure InsertBusinessSetup (var TempBusinessSetup@1003 : TEMPORARY Record 51145;BusinessSetupName@1001 : Text[50];BusinessSetupDescription@1000 : Text[250];BusinessSetupKeywords@1002 : Text[250];BusinessSetupArea@1004 : Option;BusinessSetupRunPage@1006 : Integer;BusinessSetupIconFileName@1005 :
    procedure InsertBusinessSetup(var TempBusinessSetup: Record 51145 TEMPORARY; BusinessSetupName: Text[50]; BusinessSetupDescription: Text[250]; BusinessSetupKeywords: Text[250]; BusinessSetupArea: Option; BusinessSetupRunPage: Integer; BusinessSetupIconFileName: Text[50])
    var
        //       BusinessSetupIcon@1007 :
        BusinessSetupIcon: Record "Business Setup Icon 1";
    begin
        if TempBusinessSetup.GET(BusinessSetupName) then
            exit;

        TempBusinessSetup.INIT;
        TempBusinessSetup.Name := BusinessSetupName;
        TempBusinessSetup.Description := BusinessSetupDescription;
        TempBusinessSetup.Keywords := BusinessSetupKeywords;
        TempBusinessSetup."Setup Page ID" := BusinessSetupRunPage;
        TempBusinessSetup.Area := BusinessSetupArea;
        TempBusinessSetup.INSERT(TRUE);

        if BusinessSetupIcon.GET(BusinessSetupIconFileName) then
            BusinessSetupIcon.GetIcon(TempBusinessSetup);
    end;


    //     procedure InsertExtensionBusinessSetup (var TempBusinessSetup@1003 : TEMPORARY Record 51145;BusinessSetupName@1001 : Text[50];BusinessSetupDescription@1000 : Text[250];BusinessSetupKeywords@1002 : Text[250];BusinessSetupArea@1004 : Option;BusinessSetupRunPage@1006 : Integer;ExtensionName@1005 :
    procedure InsertExtensionBusinessSetup(var TempBusinessSetup: Record 51145 TEMPORARY; BusinessSetupName: Text[50]; BusinessSetupDescription: Text[250]; BusinessSetupKeywords: Text[250]; BusinessSetupArea: Option; BusinessSetupRunPage: Integer; ExtensionName: Text[250])
    begin
        if TempBusinessSetup.GET(BusinessSetupName) then
            exit;

        TempBusinessSetup.INIT;
        TempBusinessSetup.Name := BusinessSetupName;
        TempBusinessSetup.Description := BusinessSetupDescription;
        TempBusinessSetup.Keywords := BusinessSetupKeywords;
        TempBusinessSetup."Setup Page ID" := BusinessSetupRunPage;
        TempBusinessSetup.Area := BusinessSetupArea;
        TempBusinessSetup.INSERT(TRUE);

        AddExtensionIconToBusinessSetup(TempBusinessSetup, ExtensionName);
    end;


    //     procedure SetBusinessSetupIcon (var TempBusinessSetup@1001 : TEMPORARY Record 51145;IconInStream@1000 :
    procedure SetBusinessSetupIcon(var TempBusinessSetup: Record 51145 TEMPORARY; IconInStream: InStream)
    var
        //       BusinessSetupIcon@1002 :
        BusinessSetupIcon: Record "Business Setup Icon 1";
    begin
        if not BusinessSetupIcon.GET(TempBusinessSetup.Name) then begin
            BusinessSetupIcon.INIT;
            BusinessSetupIcon."Business Setup Name" := TempBusinessSetup.Name;
            BusinessSetupIcon.INSERT(TRUE);
            BusinessSetupIcon.SetIconFromInstream(TempBusinessSetup.Name, IconInStream);
        end;

        BusinessSetupIcon.GetIcon(TempBusinessSetup);
    end;

    //     LOCAL procedure AddExtensionIconToBusinessSetup (var TempBusinessSetup@1001 : TEMPORARY Record 51145;ExtensionName@1002 :
    LOCAL procedure AddExtensionIconToBusinessSetup(var TempBusinessSetup: Record 51145 TEMPORARY; ExtensionName: Text)
    var
        //       BusinessSetupIcon@1005 :
        BusinessSetupIcon: Record "Business Setup Icon 1";
        //       NAVApp@1003 :
        //NAVApp: Record 2000000160;
        //       Media@1006 :
        Media: Record 2000000181;
        //       IconInStream@1000 :
        IconInStream: InStream;
    begin
        if not BusinessSetupIcon.GET(TempBusinessSetup.Name) then begin
            // NAVApp.SETRANGE(Name, ExtensionName);
            // if not NAVApp.FINDFIRST then
            //     exit;
            // Media.SETRANGE(ID, NAVApp.Logo.MEDIAID);
            // if not Media.FINDFIRST then
            //     exit;
            Media.CALCFIELDS(Content);
            Media.Content.CREATEINSTREAM(IconInStream);

            BusinessSetupIcon.INIT;
            BusinessSetupIcon."Business Setup Name" := TempBusinessSetup.Name;
            BusinessSetupIcon.Icon.IMPORTSTREAM(IconInStream, TempBusinessSetup.Name);
            if BusinessSetupIcon.INSERT(TRUE) then;
        end;

        TempBusinessSetup.Icon := BusinessSetupIcon.Icon;
        if TempBusinessSetup.MODIFY(TRUE) then;
    end;

    /*begin
    end.
  */
}



