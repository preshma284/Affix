table 51351 "Graph Contact1"
{


    TableType = MicrosoftGraph;
    CaptionML = ENU = 'Graph Contact', ESP = 'Contacto de Graph';

    fields
    {
        field(1; "Id"; Text[250])
        {
            ExternalName = 'Id';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'Id', ESP = 'Id';


        }
        field(2; "CreatedDateTime"; DateTime)
        {
            ExternalName = 'CreatedDateTime';
            ExternalType = 'Edm.DateTimeOffset';
            CaptionML =//@@@='{Locked}',
ENU = 'CreatedDateTime', ESP = 'CreatedDateTime';


        }
        field(3; "LastModifiedDateTime"; DateTime)
        {
            ExternalName = 'LastModifiedDateTime';
            ExternalType = 'Edm.DateTimeOffset';
            CaptionML =//@@@='{Locked}',
ENU = 'LastModifiedDateTime', ESP = 'LastModifiedDateTime';


        }
        field(4; "ChangeKey"; Text[250])
        {
            ExternalName = '@odata.etag';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'ChangeKey', ESP = 'ChangeKey';


        }
        field(5; "Categories"; BLOB)
        {
            ExternalName = 'Categories';
            ExternalType = 'Collection(Edm.String)';
            CaptionML =//@@@='{Locked}',
ENU = 'Categories', ESP = 'Categories';
            SubType = Json;


        }
        field(6; "ParentFolderId"; Text[250])
        {
            ExternalName = 'ParentFolderId';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'ParentFolderId', ESP = 'ParentFolderId';


        }
        field(7; "Birthday"; DateTime)
        {
            ExternalName = 'Birthday';
            ExternalType = 'Edm.DateTimeOffset';
            CaptionML =//@@@='{Locked}',
ENU = 'Birthday', ESP = 'Birthday';


        }
        field(8; "FileAs"; Text[250])
        {
            ExternalName = 'FileAs';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'FileAs', ESP = 'FileAs';


        }
        field(9; "DisplayName"; Text[250])
        {
            ExternalName = 'DisplayName';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'DisplayName', ESP = 'DisplayName';


        }
        field(10; "GivenName"; Text[250])
        {
            InitValue = '[ ]';
            ExternalName = 'GivenName';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'GivenName', ESP = 'GivenName';
            Description = 'GivenName is mandatory. InitValue must be a space (=[ ] in the .txt format)';


        }
        field(11; "Initials"; Text[250])
        {
            ExternalName = 'Initials';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'Initials', ESP = 'Initials';


        }
        field(12; "MiddleName"; Text[250])
        {
            ExternalName = 'MiddleName';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'MiddleName', ESP = 'MiddleName';


        }
        field(13; "NickName"; Text[250])
        {
            ExternalName = 'NickName';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'NickName', ESP = 'NickName';


        }
        field(14; "Surname"; Text[250])
        {
            ExternalName = 'Surname';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'Surname', ESP = 'Surname';


        }
        field(15; "Title"; Text[250])
        {
            ExternalName = 'Title';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'Title', ESP = 'Title';


        }
        field(16; "YomiGivenName"; Text[250])
        {
            ExternalName = 'YomiGivenName';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'YomiGivenName', ESP = 'YomiGivenName';


        }
        field(17; "YomiSurname"; Text[250])
        {
            ExternalName = 'YomiSurname';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'YomiSurname', ESP = 'YomiSurname';


        }
        field(18; "YomiCompanyName"; Text[250])
        {
            ExternalName = 'YomiCompanyName';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'YomiCompanyName', ESP = 'YomiCompanyName';


        }
        field(19; "Generation"; Text[250])
        {
            ExternalName = 'Generation';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'Generation', ESP = 'Generation';


        }
        field(20; "EmailAddresses"; BLOB)
        {
            ExternalName = 'EmailAddresses';
            ExternalType = 'Collection(Microsoft.OutlookServices.EmailAddress)';
            CaptionML =//@@@='{Locked}',
ENU = 'EmailAddresses', ESP = 'EmailAddresses';
            SubType = Json;


        }
        field(21; "Websites"; BLOB)
        {
            ExternalName = 'Websites';
            ExternalType = 'Collection(Microsoft.OutlookServices.Website)';
            CaptionML =//@@@='{Locked}',
ENU = 'Websites', ESP = 'Websites';
            SubType = Json;


        }
        field(22; "ImAddresses"; BLOB)
        {
            ExternalName = 'ImAddresses';
            ExternalType = 'Collection(Edm.String)';
            CaptionML =//@@@='{Locked}',
ENU = 'ImAddresses', ESP = 'ImAddresses';
            SubType = Json;


        }
        field(23; "JobTitle"; Text[250])
        {
            ExternalName = 'JobTitle';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'JobTitle', ESP = 'JobTitle';


        }
        field(24; "CompanyName"; Text[250])
        {
            ExternalName = 'CompanyName';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'CompanyName', ESP = 'CompanyName';


        }
        field(25; "Department"; Text[250])
        {
            ExternalName = 'Department';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'Department', ESP = 'Department';


        }
        field(26; "OfficeLocation"; Text[250])
        {
            ExternalName = 'OfficeLocation';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'OfficeLocation', ESP = 'OfficeLocation';


        }
        field(27; "Profession"; Text[250])
        {
            ExternalName = 'Profession';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'Profession', ESP = 'Profession';


        }
        field(28; "AssistantName"; Text[250])
        {
            ExternalName = 'AssistantName';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'AssistantName', ESP = 'AssistantName';


        }
        field(29; "Manager"; Text[250])
        {
            ExternalName = 'Manager';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'Manager', ESP = 'Manager';


        }
        field(30; "Phones"; BLOB)
        {
            ExternalName = 'Phones';
            ExternalType = 'Collection(Microsoft.OutlookServices.Phone)';
            CaptionML =//@@@='{Locked}',
ENU = 'Phones', ESP = 'Phones';
            SubType = Json;


        }
        field(31; "PostalAddresses"; BLOB)
        {
            ExternalName = 'PostalAddresses';
            ExternalType = 'Collection(Microsoft.OutlookServices.PhysicalAddress)';
            CaptionML =//@@@='{Locked}',
ENU = 'PostalAddresses', ESP = 'PostalAddresses';
            SubType = Json;


        }
        field(32; "SpouseName"; Text[250])
        {
            ExternalName = 'SpouseName';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'SpouseName', ESP = 'SpouseName';


        }
        field(33; "PersonalNotes"; BLOB)
        {
            ExternalName = 'PersonalNotes';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'PersonalNotes', ESP = 'PersonalNotes';
            SubType = Memo;


        }
        field(34; "Children"; BLOB)
        {
            ExternalName = 'Children';
            ExternalType = 'Collection(Edm.String)';
            CaptionML =//@@@='{Locked}',
ENU = 'Children', ESP = 'Children';
            SubType = Json;


        }
        field(35; "WeddingAnniversary"; DateTime)
        {
            ExternalName = 'WeddingAnniversary';
            ExternalType = 'Edm.Date';
            CaptionML =//@@@='{Locked}',
ENU = 'WeddingAnniversary', ESP = 'WeddingAnniversary';


        }
        field(36; "Gender"; Text[250])
        {
            ExternalName = 'Gender';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'Gender', ESP = 'Gender';


        }
        field(37; "IsFavorite"; Boolean)
        {
            ExternalName = 'IsFavorite';
            ExternalType = 'Edm.Boolean';
            CaptionML =//@@@='{Locked}',
ENU = 'IsFavorite', ESP = 'IsFavorite';


        }
        field(38; "Flag"; BLOB)
        {
            ExternalName = 'Flag';
            ExternalType = 'Microsoft.OutlookServices.FollowupFlag';
            CaptionML =//@@@='{Locked}',
ENU = 'Flag', ESP = 'Flag';
            SubType = Json;


        }
        field(40; "DeltaToken"; Text[250])
        {
            ExternalName = 'DeltaToken';
            ExternalType = 'Edm.String';
            CaptionML =//@@@='{Locked}',
ENU = 'DeltaToken', ESP = 'DeltaToken';


        }
        field(41; "BusinessType"; BLOB)
        {
            ExternalName = '[String {bdba944b-fc2b-47a1-8ba4-cafc4ae13ea2} Name BusinessType]';
            ExternalType = 'SingleValueExtendedProperties';
            CaptionML =//@@@='{Locked}',
ENU = 'BusinessType', ESP = 'BusinessType';
            SubType = Json;


        }
        field(42; "IsBank"; BLOB)
        {
            ExternalName = '[Integer {a8ef117a-16d9-4cc6-965a-d2fbe0177e61} Name IsBank]';
            ExternalType = 'SingleValueExtendedProperties';
            CaptionML =//@@@='{Locked}',
ENU = 'IsBank', ESP = 'IsBank';
            SubType = Json;


        }
        field(43; "IsContact"; BLOB)
        {
            ExternalName = '[Integer {f4be2302-782e-483d-8ba4-26fb6535f665} Name IsContact]';
            ExternalType = 'SingleValueExtendedProperties';
            CaptionML =//@@@='{Locked}',
ENU = 'IsContact', ESP = 'IsContact';
            SubType = Json;


        }
        field(44; "IsCustomer"; BLOB)
        {
            ExternalName = '[Integer {47ac1412-279b-41cb-891e-58904a94a48b} Name IsCustomer]';
            ExternalType = 'SingleValueExtendedProperties';
            CaptionML =//@@@='{Locked}',
ENU = 'IsCustomer', ESP = 'IsCustomer';
            SubType = Json;


        }
        field(45; "IsLead"; BLOB)
        {
            ExternalName = '[Integer {37829b75-e5e4-4582-ae12-36f754e4bd7b} Name IsLead]';
            ExternalType = 'SingleValueExtendedProperties';
            CaptionML =//@@@='{Locked}',
ENU = 'IsLead', ESP = 'IsLead';
            SubType = Json;


        }
        field(46; "IsPartner"; BLOB)
        {
            ExternalName = '[Integer {65ebabde-6946-455f-b918-a88ee36182a9} Name IsPartner]';
            ExternalType = 'SingleValueExtendedProperties';
            CaptionML =//@@@='{Locked}',
ENU = 'IsPartner', ESP = 'IsPartner';
            SubType = Json;


        }
        field(47; "IsVendor"; BLOB)
        {
            ExternalName = '[Integer {ccf57c46-c10e-41bb-b8c5-362b185d2f98} Name IsVendor]';
            ExternalType = 'SingleValueExtendedProperties';
            CaptionML =//@@@='{Locked}',
ENU = 'IsVendor', ESP = 'IsVendor';
            SubType = Json;


        }
        field(48; "IsNavCreated"; BLOB)
        {
            ExternalName = '[Integer {6023a623-3b6c-492d-9ef5-811850c088ac} Name IsNavCreated]';
            ExternalType = 'SingleValueExtendedProperties';
            CaptionML =//@@@='{Locked}',
ENU = 'IsNavCreated', ESP = 'IsNavCreated';
            SubType = Json;


        }
        field(49; "NavIntegrationId"; BLOB)
        {
            ExternalName = '[String {d048f561-4dd0-443c-a8d8-f397fb74f1df} Name NavIntegrationId]';
            ExternalType = 'SingleValueExtendedProperties';
            CaptionML =//@@@='{Locked}',
ENU = 'NavIntegrationId', ESP = 'NavIntegrationId';
            SubType = Json;


        }
        field(50; "XrmId"; BLOB)
        {
            ExternalName = '[clsid {1a417774-4779-47c1-9851-e42057495fca Name XrmId]';
            ExternalType = 'SingleValueExtendedProperties';
            CaptionML =//@@@='{Locked',
ENU = 'XrmId', ESP = 'XrmId';
            SubType = Json;


        }
    }
    keys
    {
        key(key1; "Id")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }


    procedure GetCategoriesString(): Text;
    begin
        exit(GetBlobString(FIELDNO(Categories)));
    end;

    //     procedure SetCategoriesString (CategoriesString@1000 :
    procedure SetCategoriesString(CategoriesString: Text)
    begin
        SetBlobString(FIELDNO(Categories), CategoriesString);
    end;

    procedure GetEmailAddressesString(): Text;
    begin
        exit(GetBlobString(FIELDNO(EmailAddresses)));
    end;

    //     procedure SetEmailAddressesString (EmailAddressesString@1000 :
    procedure SetEmailAddressesString(EmailAddressesString: Text)
    begin
        SetBlobString(FIELDNO(EmailAddresses), EmailAddressesString);
    end;

    procedure GetWebsitesString(): Text;
    begin
        exit(GetBlobString(FIELDNO(Websites)));
    end;

    //     procedure SetWebsitesString (WebsitesString@1000 :
    procedure SetWebsitesString(WebsitesString: Text)
    begin
        SetBlobString(FIELDNO(Websites), WebsitesString);
    end;

    procedure GetImAddressesString(): Text;
    begin
        exit(GetBlobString(FIELDNO(ImAddresses)));
    end;

    //     procedure SetImAddressesString (ImAddressesString@1000 :
    procedure SetImAddressesString(ImAddressesString: Text)
    begin
        SetBlobString(FIELDNO(ImAddresses), ImAddressesString);
    end;

    procedure GetPhonesString(): Text;
    begin
        exit(GetBlobString(FIELDNO(Phones)));
    end;

    //     procedure SetPhonesString (PhonesString@1000 :
    procedure SetPhonesString(PhonesString: Text)
    begin
        SetBlobString(FIELDNO(Phones), PhonesString);
    end;

    procedure GetPostalAddressesString(): Text;
    begin
        exit(GetBlobString(FIELDNO(PostalAddresses)));
    end;

    //     procedure SetPostalAddressesString (PostalAddressesString@1000 :
    procedure SetPostalAddressesString(PostalAddressesString: Text)
    begin
        SetBlobString(FIELDNO(PostalAddresses), PostalAddressesString);
    end;

    procedure GetPersonalNotesString(): Text;
    begin
        exit(GetBlobString(FIELDNO(PersonalNotes)));
    end;

    //     procedure SetPersonalNotesString (PersonalNotesString@1000 :
    procedure SetPersonalNotesString(PersonalNotesString: Text)
    begin
        SetBlobString(FIELDNO(PersonalNotes), PersonalNotesString);
    end;

    procedure GetChildrenString(): Text;
    begin
        exit(GetBlobString(FIELDNO(Children)));
    end;

    //     procedure SetChildrenString (ChildrenString@1000 :
    procedure SetChildrenString(ChildrenString: Text)
    begin
        SetBlobString(FIELDNO(Children), ChildrenString);
    end;

    procedure GetFlagString(): Text;
    begin
        exit(GetBlobString(FIELDNO(Flag)));
    end;

    //     procedure SetFlagString (FlagString@1000 :
    procedure SetFlagString(FlagString: Text)
    begin
        SetBlobString(FIELDNO(Flag), FlagString);
    end;

    procedure GetBusinessTypeString(): Text;
    begin
        exit(GetBlobString(FIELDNO(BusinessType)));
    end;

    //     procedure SetBusinessTypeString (BusinessTypeString@1000 :
    procedure SetBusinessTypeString(BusinessTypeString: Text)
    begin
        SetBlobString(FIELDNO(BusinessType), BusinessTypeString);
    end;

    procedure GetIsCustomerString(): Text;
    begin
        exit(GetBlobString(FIELDNO(IsCustomer)));
    end;

    //     procedure SetIsCustomerString (IsCustomerString@1000 :
    procedure SetIsCustomerString(IsCustomerString: Text)
    begin
        SetBlobString(FIELDNO(IsCustomer), IsCustomerString);
    end;

    procedure GetIsVendorString(): Text;
    begin
        exit(GetBlobString(FIELDNO(IsVendor)));
    end;

    //     procedure SetIsVendorString (IsVendorString@1000 :
    procedure SetIsVendorString(IsVendorString: Text)
    begin
        SetBlobString(FIELDNO(IsVendor), IsVendorString);
    end;

    procedure GetIsBankString(): Text;
    begin
        exit(GetBlobString(FIELDNO(IsBank)));
    end;

    //     procedure SetIsBankString (IsBankString@1000 :
    procedure SetIsBankString(IsBankString: Text)
    begin
        SetBlobString(FIELDNO(IsBank), IsBankString);
    end;

    procedure GetIsContactString(): Text;
    begin
        exit(GetBlobString(FIELDNO(IsContact)));
    end;

    //     procedure SetIsContactString (IsContactString@1000 :
    procedure SetIsContactString(IsContactString: Text)
    begin
        SetBlobString(FIELDNO(IsContact), IsContactString);
    end;

    procedure GetIsLeadString(): Text;
    begin
        exit(GetBlobString(FIELDNO(IsLead)));
    end;

    procedure GetIsPartnerString(): Text;
    begin
        exit(GetBlobString(FIELDNO(IsPartner)));
    end;

    procedure GetIsNavCreatedString(): Text;
    begin
        exit(GetBlobString(FIELDNO(IsNavCreated)));
    end;

    //     procedure SetIsNavCreatedString (IsNavCreatedString@1000 :
    procedure SetIsNavCreatedString(IsNavCreatedString: Text)
    begin
        SetBlobString(FIELDNO(IsNavCreated), IsNavCreatedString);
    end;

    procedure GetNavIntegrationIdString(): Text;
    begin
        exit(GetBlobString(FIELDNO(NavIntegrationId)));
    end;

    //     procedure SetNavIntegrationIdString (NavIntegrationIdString@1000 :
    procedure SetNavIntegrationIdString(NavIntegrationIdString: Text)
    begin
        SetBlobString(FIELDNO(NavIntegrationId), NavIntegrationIdString);
    end;

    //     LOCAL procedure GetBlobString (FieldNo@1000 :
    LOCAL procedure GetBlobString(FieldNo: Integer): Text;
    var
        //       TypeHelper@1003 :
        TypeHelper: Codeunit 10;
        TypeHelper1: Codeunit "Type Helper 1";
    begin
        exit(TypeHelper1.GetBlobString(Rec, FieldNo));
    end;

    //     LOCAL procedure SetBlobString (FieldNo@1004 : Integer;NewContent@1003 :
    LOCAL procedure SetBlobString(FieldNo: Integer; NewContent: Text)
    var
        //       TypeHelper@1002 :
        TypeHelper: Codeunit 10;
        TypeHelper1: Codeunit "Type Helper 1";
        //       RecordRef@1001 :
        RecordRef: RecordRef;
    begin
        RecordRef.GETTABLE(Rec);
        TypeHelper1.SetBlobString(RecordRef, FieldNo, NewContent);
        RecordRef.SETTABLE(Rec);
    end;

    //     procedure GetXrmId (var XrmID@1003 :
    // procedure GetXrmId(var XrmID: GUID): Boolean;
    // var
    //     //       JSONManagement@1004 :
    //     JSONManagement: Codeunit 5459;
    //     //       JsonObject@1002 :
    //     JsonObject: DotNet "JObject";
    //     //       XrmIDJSonString@1001 :
    //     XrmIDJSonString: Text;
    //     //       XrmIDValue@1000 :
    //     XrmIDValue: Text;
    // begin
    //     CLEAR(XrmID);

    //     XrmIDJSonString := GetBlobString(FIELDNO(XrmId));
    //     if XrmIDJSonString = '' then
    //         exit(FALSE);

    //     JSONManagement.InitializeObject(XrmIDJSonString);
    //     JSONManagement.GetJSONObject(JsonObject);
    //     JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject, 'Value', XrmIDValue);
    //     exit(EVALUATE(XrmID, XrmIDValue));
    // end;


    procedure HasNameDetailsForQuestionnaire(): Boolean;
    begin
        exit((NickName <> '') or (Generation <> ''));
    end;


    procedure HasAnniversariesForQuestionnaire(): Boolean;
    begin
        exit((Birthday <> 0DT) or (WeddingAnniversary <> 0DT) or (SpouseName <> ''));
    end;


    procedure HasPhoneticNameDetailsForQuestionnaire(): Boolean;
    begin
        exit((YomiGivenName <> '') or (YomiSurname <> ''));
    end;


    procedure HasWorkDetailsForQuestionnaire(): Boolean;
    begin
        exit((Profession <> '') or (Department <> '') or (OfficeLocation <> '') or (AssistantName <> '') or (Manager <> ''));
    end;

    /*begin
    end.
  */
}



