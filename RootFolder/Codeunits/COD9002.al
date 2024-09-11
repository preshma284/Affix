Codeunit 51256 "Permission Manager 1"
{
  
  
    Permissions=TableData 1805=r,
                TableData 9007=rimd;
                // TableData 9008=rimd;
    SingleInstance=true;
    trigger OnRun()
BEGIN
          END;
    VAR
      OfficePortalUserAdministrationUrlTxt : TextConst ENU='https://portal.office.com/admin/default.aspx#ActiveUsersPage',ESP='https://portal.office.com/admin/default.aspx#ActiveUsersPage';
      TestabilityPreview : Boolean;
      TestabilitySoftwareAsAService : Boolean;
      SUPERPermissionSetTxt : TextConst ENU='SUPER',ESP='SUPER';
      SUPERPermissionErr : TextConst ENU='At least one user must be a member of the ''SUPER'' group in all companies.',ESP='Al menos un usuario debe ser miembro del grupo "SUPER" en todas la empresas.';
      SECURITYPermissionSetTxt : TextConst ENU='SECURITY',ESP='SECURITY';
      IncorrectCalculatedHashErr : TextConst ENU='Hash calculated for permission set %1 is ''%2''.',ESP='El hash calculado para el conjunto de permisos %1 es ''%2''.';
      IntelligentCloudTok : TextConst ENU='INTELLIGENT CLOUD',ESP='INTELLIGENT CLOUD';
      TestabilityIntelligentCloud : Boolean;
      LocalTok : TextConst ENU='LOCAL',ESP='LOCAL';

    //[External]
    PROCEDURE AddUserToUserGroup(UserSecurityID : GUID;UserGroupCode : Code[20];Company : Text[30]);
    VAR
      UserGroupMember : Record 9001;
    BEGIN
      IF NOT UserGroupMember.GET(UserGroupCode,UserSecurityID,Company) THEN BEGIN
        UserGroupMember.INIT;
        UserGroupMember."Company Name" := Company;
        UserGroupMember."User Security ID" := UserSecurityID;
        UserGroupMember."User Group Code" := UserGroupCode;
        UserGroupMember.INSERT(TRUE);
      END;
    END;

    //[External]
    PROCEDURE AddUserToDefaultUserGroups(UserSecurityID : GUID) : Boolean;
    BEGIN
      EXIT(AddUserToDefaultUserGroupsForCompany(UserSecurityID,COMPANYNAME));
    END;

    //[External]
    PROCEDURE AddUserToDefaultUserGroupsForCompany(UserSecurityID : GUID;Company : Text[30]) UserGroupsAdded : Boolean;
    VAR
      // UserPlan : Record 9005;
    BEGIN
      // Add the new user to all user groups of the plan

      // No plan is assigned to this user
      // UserPlan.SETRANGE("User Security ID",UserSecurityID);
      // IF NOT UserPlan.FINDSET THEN BEGIN
      //   UserGroupsAdded := FALSE;
      //   EXIT;
      // END;

      // There is at least a plan assigned (and probably only one)
      // REPEAT
      //   IF AddUserToAllUserGroupsOfThePlanForCompany(UserSecurityID,UserPlan."Plan ID",Company) THEN
      //     UserGroupsAdded := TRUE;
      // UNTIL UserPlan.NEXT = 0;
    END;

    LOCAL PROCEDURE AddUserToAllUserGroupsOfThePlanForCompany(UserSecurityID : GUID;PlanID : GUID;Company : Text[30]) : Boolean;
    VAR
      UserGroupPlan : Record 9007;
    BEGIN
      // Get all User Groups in plan
      UserGroupPlan.SETRANGE("Plan ID",PlanID);
      IF NOT UserGroupPlan.FINDSET THEN
        EXIT(FALSE); // nothing to add

      // Assign groups to the current user (if not assigned already)
      REPEAT
        AddUserToUserGroup(UserSecurityID,UserGroupPlan."User Group Code",Company);
      UNTIL UserGroupPlan.NEXT = 0;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE RemoveUserFromAllPermissionSets(UserSecurityID : GUID);
    VAR
      AccessControl : Record 2000000053;
    BEGIN
      AccessControl.SETRANGE("User Security ID",UserSecurityID);
      AccessControl.DELETEALL(TRUE);
    END;

    LOCAL PROCEDURE RemoveUserFromAllUserGroups(UserSecurityID : GUID);
    VAR
      UserGroupMember : Record 9001;
    BEGIN
      UserGroupMember.SETRANGE("User Security ID",UserSecurityID);
      UserGroupMember.DELETEALL(TRUE);
    END;

    //[External]
    PROCEDURE ResetUserToDefaultUserGroups(UserSecurityID : GUID);
    BEGIN
      // Remove the user from all assigned user groups and their related permission sets
      RemoveUserFromAllUserGroups(UserSecurityID);

      // Remove the user from any additional, manually assigned permission sets
      RemoveUserFromAllPermissionSets(UserSecurityID);

      // Add the user to all the user groups (and their permission sets) which are
      // defined in the user's assigned subscription plan
      AddUserToDefaultUserGroups(UserSecurityID);
    END;


    //[External]
    PROCEDURE SetTestabilityPreview(EnablePreviewForTest : Boolean);
    BEGIN
      TestabilityPreview := EnablePreviewForTest;
    END;

    //[External]
    PROCEDURE IsPreview() : Boolean;
    BEGIN
      IF TestabilityPreview THEN
        EXIT(TRUE);

      // temporary fix until platform implements correct solution
      EXIT(FALSE);
    END;

    //[External]
    PROCEDURE IsSandboxConfiguration() : Boolean;
    VAR
      TenantManagementHelper : Codeunit 417;
      TenantManagementHelper1 : Codeunit 50370;
      IsSandbox : Boolean;
    BEGIN
      IsSandbox := TenantManagementHelper1.IsSandbox;
      EXIT(IsSandbox);
    END;

    //[External]
    PROCEDURE SetTestabilitySoftwareAsAService(EnableSoftwareAsAServiceForTest : Boolean);
    BEGIN
      TestabilitySoftwareAsAService := EnableSoftwareAsAServiceForTest;
    END;

    //[External]
    PROCEDURE SoftwareAsAService() : Boolean;
    VAR
      MembershipEntitlement : Record 2000000195;
    BEGIN
      IF TestabilitySoftwareAsAService THEN
        EXIT(TRUE);

      EXIT(NOT MembershipEntitlement.ISEMPTY);
    END;

    //[External]
    PROCEDURE UpdateUserAccessForSaaS(UserSID : GUID);
    BEGIN
      IF NOT AllowUpdateUserAccessForSaaS(UserSID) THEN
        EXIT;

      // Only remove SUPER if other permissions are granted (to avoid user lockout)
      IF AddUserToDefaultUserGroups(UserSID) THEN BEGIN
        AssignDefaultRoleCenterToUser(UserSID);
        RemoveSUPERPermissionSetFromUserIfMoreSupersExist(UserSID);
        StoreUserFirstLogin(UserSID);
      END;

      IF IsIntelligentCloud AND NOT IsSuper(UserSID) THEN
        RemoveExistingPermissionsAndAddIntelligentCloud(UserSID,COMPANYNAME);
    END;

    LOCAL PROCEDURE AllowUpdateUserAccessForSaaS(UserSID : GUID) : Boolean;
    VAR
      User : Record 2000000120;
      // UserPlan : Record 9005;
      // Plan : Record 9004;
    BEGIN
      IF NOT SoftwareAsAService THEN
        EXIT(FALSE);

      IF ISNULLGUID(UserSID) THEN
        EXIT(FALSE);

      // Don't demote external users (like the sync daemon)
      User.GET(UserSID);
      IF User."License Type" = User."License Type"::"External User" THEN
        EXIT(FALSE);

      // Don't demote users which don't come from Office365 (have no plans assigned)
      // Note: all users who come from O365, if they don't have a plan, they don't get a license (hence, no SUPER role)
      // UserPlan.SETRANGE("User Security ID",User."User Security ID");
      // IF NOT UserPlan.FINDFIRST THEN
      //   EXIT(FALSE);

      // Don't demote users then have a invalid plan likely comming from 1.5
      // IF NOT Plan.GET(UserPlan."Plan ID") THEN
      //   EXIT(FALSE);
      // IF Plan."Role Center ID" = 0 THEN
      //   EXIT(FALSE);

      EXIT(TRUE);
    END;



    LOCAL PROCEDURE DeleteSuperFromUser(UserSID : GUID);
    VAR
      AccessControl : Record 2000000053;
    BEGIN
      AccessControl.SETRANGE("Role ID",SUPERPermissionSetTxt);
      AccessControl.SETRANGE("Company Name",'');
      AccessControl.SETRANGE("User Security ID",UserSID);
      AccessControl.DELETEALL(TRUE);
    END;

    LOCAL PROCEDURE IsExternalUser(UserSID : GUID) : Boolean;
    VAR
      User : Record 2000000120;
    BEGIN
      IF User.GET(UserSID) THEN
        EXIT(User."License Type" = User."License Type"::"External User");

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsEnabledUser(UserSID : GUID) : Boolean;
    VAR
      User : Record 2000000120;
    BEGIN
      IF User.GET(UserSID) THEN
        EXIT(User.State = User.State::Enabled);

      EXIT(FALSE);
    END;

    //[External]
    PROCEDURE IsSuper(UserSID : GUID) : Boolean;
    VAR
      AccessControl : Record 2000000053;
      User : Record 2000000120;
    BEGIN
      IF User.ISEMPTY THEN
        EXIT(TRUE);

      AccessControl.SETRANGE("Role ID",SUPERPermissionSetTxt);
      AccessControl.SETFILTER("Company Name",'%1|%2','',COMPANYNAME);
      AccessControl.SETRANGE("User Security ID",UserSID);
      EXIT(NOT AccessControl.ISEMPTY);
    END;

    LOCAL PROCEDURE IsSomeoneElseSuper(UserSID : GUID) : Boolean;
    VAR
      AccessControl : Record 2000000053;
      User : Record 2000000120;
    BEGIN
      IF User.ISEMPTY THEN
        EXIT(TRUE);

      AccessControl.LOCKTABLE;
      AccessControl.SETRANGE("Role ID",SUPERPermissionSetTxt);
      AccessControl.SETRANGE("Company Name",'');
      AccessControl.SETFILTER("User Security ID",'<>%1',UserSID);

      IF NOT AccessControl.FINDSET THEN // no other user is SUPER
        EXIT(FALSE);

      REPEAT
        // Sync Deamon should not count as a super user and he has a external license
        IF NOT IsExternalUser(AccessControl."User Security ID") THEN
          EXIT(TRUE);
      UNTIL AccessControl.NEXT = 0;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsSomeoneElseEnabledSuper(UserSID : GUID) : Boolean;
    VAR
      AccessControl : Record 2000000053;
      User : Record 2000000120;
    BEGIN
      IF User.ISEMPTY THEN
        EXIT(TRUE);

      AccessControl.LOCKTABLE;
      AccessControl.SETRANGE("Role ID",SUPERPermissionSetTxt);
      AccessControl.SETRANGE("Company Name",'');
      AccessControl.SETFILTER("User Security ID",'<>%1',UserSID);

      IF NOT AccessControl.FINDSET THEN // no other user is SUPER
        EXIT(FALSE);

      REPEAT
        // Sync Deamon should not count as a super user and he has a external license
        IF IsEnabledUser(AccessControl."User Security ID") AND NOT IsExternalUser(AccessControl."User Security ID") THEN
          EXIT(TRUE);
      UNTIL AccessControl.NEXT = 0;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE RemoveSUPERPermissionSetFromUserIfMoreSupersExist(UserSID : GUID);
    BEGIN
      IF IsUserAdmin(UserSID) THEN
        EXIT;

      IF IsSomeoneElseSuper(UserSID) THEN
        DeleteSuperFromUser(UserSID);
    END;

    //[External]
    PROCEDURE IsFirstLogin(UserSecurityID : GUID) : Boolean;
    VAR
      // UserLogin : Record 9008;
    BEGIN
      // Only update first-time login users
      // IF UserLogin.GET(UserSecurityID) THEN
      //   EXIT(FALSE); // This user logged in before

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE StoreUserFirstLogin(UserSecurityID : GUID);
    VAR
      // UserLogin : Record 9008;
    BEGIN
      // IF UserLogin.GET(UserSecurityID) THEN
      //   EXIT; // the user has already been logged in before
      // UserLogin.INIT;
      // UserLogin.VALIDATE("User SID",UserSecurityID);
      // UserLogin.VALIDATE("First Login Date",TODAY);
      // UserLogin.INSERT;
    END;

    LOCAL PROCEDURE AssignDefaultRoleCenterToUser(UserSecurityID : GUID);
    VAR
      // UserPlan : Record 9005;
      UserPersonalization : Record 2000000073;
      // Plan : Record 9004;
      Profile : Record 2000000178;
    BEGIN
      // UserPlan.SETRANGE("User Security ID",UserSecurityID);

      // IF NOT UserPlan.FINDFIRST THEN
      //   EXIT; // this user has no plans assigned, so they'll get the app-wide default role center

      // Plan.GET(UserPlan."Plan ID");
      // Profile.SETRANGE("Role Center ID",Plan."Role Center ID");

      IF NOT Profile.FINDFIRST THEN
        EXIT; // the plan does not have a role center, so they'll get the app-wide default role center

      // Create the user personalization record
      IF NOT UserPersonalization.GET(UserSecurityID) THEN BEGIN
        UserPersonalization.INIT;
        UserPersonalization.VALIDATE("User SID",UserSecurityID);
        UserPersonalization.VALIDATE("Profile ID",Profile."Profile ID");
        UserPersonalization.VALIDATE("App ID",Profile."App ID");
        UserPersonalization.VALIDATE(Scope,Profile.Scope);
        UserPersonalization.INSERT;
        EXIT;
      END;
    END;

    //[Internal]
    PROCEDURE GetDefaultProfileID(UserSecurityID : GUID;VAR Profile : Record 2000000178);
    VAR
      // UserPlan : Record 9005;
      // Plan : Record 9004;
      ConfPersonalizationMgt : Codeunit 9170;
      IdentityManagement : Codeunit 9801;
      IdentityManagement1 : Codeunit 51289;
    BEGIN
      // UserPlan.SETRANGE("User Security ID",UserSecurityID);
      // IF UserPlan.FINDSET THEN
      //   REPEAT
      //     IF Plan.GET(UserPlan."Plan ID") THEN
      //       // Get profile only if (it's invoice client and plan is invoice) or (NOT invoice client and plan NOT plan is invoice)
      //       // That's because there can be 2 plans; One Invoice-plan only to be used by Invoice-app, and One BC-plan only for BC-client.
      //       IF NOT (IdentityManagement1.IsInvAppId XOR (STRPOS(Plan.Name,'INVOIC') > 0)) THEN BEGIN
      //         Profile.SETRANGE("Role Center ID",Plan."Role Center ID");
      //         IF Profile.FINDFIRST THEN
      //           EXIT;
      //       END;
      //   UNTIL UserPlan.NEXT = 0;

      Profile.RESET;
      Profile.SETRANGE("Default Role Center",TRUE);
      IF Profile.FINDFIRST THEN
        EXIT;

      Profile.RESET;
      Profile.SETRANGE("Role Center ID",ConfPersonalizationMgt.DefaultRoleCenterID);
      IF Profile.FINDFIRST THEN
        EXIT;

      Profile.RESET;
      IF Profile.FINDFIRST THEN
        EXIT;
    END;

    //[External]
    PROCEDURE CanCurrentUserManagePlansAndGroups() : Boolean;
    VAR
      // UserPlan : Record 9005;
      UserGroupMember : Record 9001;
      AccessControl : Record 2000000053;
      UserGroupAccessControl : Record 9002;
      UserGroupPermissionSet : Record 9003;
    BEGIN
      // EXIT(
      //   UserPlan.WRITEPERMISSION AND UserGroupMember.WRITEPERMISSION AND
      //   AccessControl.WRITEPERMISSION AND UserGroupAccessControl.WRITEPERMISSION AND
      //   UserGroupPermissionSet.WRITEPERMISSION);
    END;

    [EventSubscriber(ObjectType::Table, 2000000053, OnBeforeRenameEvent, '', true, true)]
    LOCAL PROCEDURE CheckSuperPermissionsOnBeforeRenameAccessControl(VAR Rec : Record 2000000053;VAR xRec : Record 2000000053;RunTrigger : Boolean);
    BEGIN
      IF NOT SoftwareAsAService THEN
        EXIT;

      IF xRec."Role ID" <> SUPERPermissionSetTxt THEN
        EXIT;

      IF (Rec."Role ID" <> SUPERPermissionSetTxt) AND (NOT IsSomeoneElseSuper(Rec."User Security ID")) THEN
        ERROR(SUPERPermissionErr);

      IF (Rec."Company Name" <> '') AND (NOT IsSomeoneElseSuper(Rec."User Security ID")) THEN
        ERROR(SUPERPermissionErr)
    END;

    [EventSubscriber(ObjectType::Table, 2000000053, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE CheckSuperPermissionsOnBeforeDeleteAccessControl(VAR Rec : Record 2000000053;RunTrigger : Boolean);
    VAR
      EmptyGUID : GUID;
    BEGIN
      IF NOT SoftwareAsAService THEN
        EXIT;

      IF NOT RunTrigger THEN
        EXIT;

      IF Rec."Role ID" <> SUPERPermissionSetTxt THEN
        EXIT;

      IF (Rec."Company Name" <> '') AND IsSuper(Rec."User Security ID") THEN
        EXIT;

      // If nobody was SUPER in all companies before, the delete is not going to make it worse
      IF NOT IsSomeoneElseSuper(EmptyGUID) THEN
        EXIT;

      IF NOT IsSomeoneElseSuper(Rec."User Security ID") THEN
        ERROR(SUPERPermissionErr)
    END;

    [EventSubscriber(ObjectType::Table, 2000000120, OnBeforeModifyEvent, '', true, true)]
    LOCAL PROCEDURE CheckSuperPermissionsOnDisableUser(VAR Rec : Record 2000000120;VAR xRec : Record 2000000120;RunTrigger : Boolean);
    BEGIN
      IF NOT IsSuper(Rec."User Security ID") THEN
        EXIT;
      IF IsSomeoneElseEnabledSuper(Rec."User Security ID") THEN
        EXIT;
      IF (Rec.State = Rec.State::Disabled) AND (xRec.State = xRec.State::Enabled) THEN
        ERROR(SUPERPermissionErr);
    END;

    [EventSubscriber(ObjectType::Table, 2000000120, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE CheckSuperPermissionsOnDeleteUser(VAR Rec : Record 2000000120;RunTrigger : Boolean);
    BEGIN
      IF Rec.ISTEMPORARY THEN
        EXIT;
      IF NOT IsSuper(Rec."User Security ID") THEN
        EXIT;
      IF IsSomeoneElseEnabledSuper(Rec."User Security ID") THEN
        EXIT;
      ERROR(SUPERPermissionErr);
    END;

    //[External]
    PROCEDURE CanManageUsersOnTenant(UserSID : GUID) : Boolean;
    VAR
      AccessControl : Record 2000000053;
      User : Record 2000000120;
    BEGIN
      IF User.ISEMPTY THEN
        EXIT(TRUE);

      IF IsSuper(UserSID) THEN
        EXIT(TRUE);

      AccessControl.SETRANGE("Role ID",SECURITYPermissionSetTxt);
      AccessControl.SETFILTER("Company Name",'%1|%2','',COMPANYNAME);
      AccessControl.SETRANGE("User Security ID",UserSID);
      EXIT(NOT AccessControl.ISEMPTY);
    END;

    LOCAL PROCEDURE IsUserAdmin(SecurityID : GUID) : Boolean;
    VAR
      // Plan : Record 9004;
      // UserPlan : Record 9005;
    BEGIN
      // UserPlan.SETRANGE("User Security ID",SecurityID);
      // // UserPlan.SETFILTER("Plan ID",'%1|%2',Plan.GetInternalAdminPlanId,Plan.GetDelegatedAdminPlanId);
      // EXIT(NOT UserPlan.ISEMPTY);
    END;

    //[External]
    PROCEDURE GenerateHashForPermissionSet(PermissionSetId : Code[20]) : Text[250];
    VAR
      Permission : Record 2000000005;
      EncryptionManagement : Codeunit 1266;
      InputText : Text;
      ObjectType : Integer;
    BEGIN
      InputText += PermissionSetId;
      Permission.SETRANGE("Role ID",PermissionSetId);
      IF Permission.FINDSET THEN
        REPEAT
          ObjectType := Permission."Object Type";
          InputText += FORMAT(ObjectType);
          InputText += FORMAT(Permission."Object ID");
          IF ObjectType = Permission."Object Type"::"Table Data" THEN BEGIN
            InputText += GetCharRepresentationOfPermission(Permission."Read Permission");
            InputText += GetCharRepresentationOfPermission(Permission."Insert Permission");
            InputText += GetCharRepresentationOfPermission(Permission."Modify Permission");
            InputText += GetCharRepresentationOfPermission(Permission."Delete Permission");
          END ELSE
            InputText += GetCharRepresentationOfPermission(Permission."Execute Permission");
          InputText += FORMAT(Permission."Security Filter",0,9);
        UNTIL Permission.NEXT = 0;

      EXIT(COPYSTR(EncryptionManagement.GenerateHash(InputText,2),1,250)); // 2 corresponds to SHA256
    END;

    //[External]
    PROCEDURE UpdateHashForPermissionSet(PermissionSetId : Code[20]);
    VAR
      PermissionSet : Record 2000000004;
    BEGIN
      PermissionSet.GET(PermissionSetId);
      PermissionSet.Hash := GenerateHashForPermissionSet(PermissionSetId);
      IF PermissionSet.Hash = '' THEN
        ERROR(IncorrectCalculatedHashErr,PermissionSetId,PermissionSet.Hash);
      PermissionSet.MODIFY;
    END;

    LOCAL PROCEDURE GetCharRepresentationOfPermission(PermissionOption : Integer) : Text[1];
    BEGIN
      EXIT(STRSUBSTNO('%1',PermissionOption));
    END;

    //[External]
    PROCEDURE IsFirstPermissionHigherThanSecond(First : Option;Second : Option) : Boolean;
    VAR
      Permission : Record "Metadata Permission";
    BEGIN
      CASE First OF
        Permission."Read Permission"::" ":
          EXIT(FALSE);
        Permission."Read Permission"::Indirect:
          EXIT(Second = Permission."Read Permission"::" ");
        Permission."Read Permission"::Yes:
          EXIT(Second IN [Permission."Read Permission"::Indirect,Permission."Read Permission"::" "]);
      END;
    END;

    //[External]
    PROCEDURE ResetUsersToIntelligentCloudUserGroup();
    VAR
      User : Record 2000000120;
      AccessControl : Record 2000000053;
      IntelligentCloud : Record 2000000146;
    BEGIN
      IF NOT SoftwareAsAService THEN
        EXIT;

      IF NOT IntelligentCloud.GET THEN
        EXIT;

      IF IntelligentCloud.Enabled THEN BEGIN
        User.SETFILTER("License Type",'<>%1',User."License Type"::"External User");
        User.SETFILTER("Windows Security ID",'=''''');

        IF User.COUNT = 0 THEN
          EXIT;

        REPEAT
          IF NOT IsSuper(User."User Security ID") AND NOT ISNULLGUID(User."User Security ID") THEN BEGIN
            AccessControl.SETRANGE("User Security ID",User."User Security ID");
            IF AccessControl.FINDSET THEN
              REPEAT
                RemoveExistingPermissionsAndAddIntelligentCloud(AccessControl."User Security ID",AccessControl."Company Name");
              UNTIL AccessControl.NEXT = 0;
          END;
        UNTIL User.NEXT = 0;
      END;
    END;

    //[External]
    PROCEDURE IsIntelligentCloud() : Boolean;
    VAR
      IntelligentCloud : Record 2000000146;
    BEGIN
      IF TestabilityIntelligentCloud THEN
        EXIT(TRUE);

      IF IntelligentCloud.GET THEN
        EXIT(IntelligentCloud.Enabled);
    END;

    //[External]
    PROCEDURE GetIntelligentCloudTok() : Text;
    BEGIN
      EXIT(IntelligentCloudTok);
    END;

    LOCAL PROCEDURE RemoveExistingPermissionsAndAddIntelligentCloud(UserSecurityID : GUID;CompanyName : Text[30]);
    VAR
      AccessControl : Record 2000000053;
      UserGroupMember : Record 9001;
    BEGIN
      // Remove User from all Permission Sets for the company
      AccessControl.SETRANGE("User Security ID",UserSecurityID);
      AccessControl.SETRANGE("Company Name",CompanyName);
      AccessControl.SETRANGE(Scope,AccessControl.Scope::System);
      AccessControl.SETFILTER("Role ID",'<>%1',IntelligentCloudTok);
      AccessControl.SETFILTER("Role ID",'<>%1',LocalTok);
      AccessControl.DELETEALL(TRUE);

      // Remove User from all User Groups for the company
      UserGroupMember.SETRANGE("User Security ID",UserSecurityID);
      UserGroupMember.SETRANGE("Company Name",CompanyName);
      UserGroupMember.SETFILTER("User Group Code",'<>%1',IntelligentCloudTok);
      IF NOT UserGroupMember.ISEMPTY THEN BEGIN
        UserGroupMember.DELETEALL(TRUE);
        AddUserToUserGroup(UserSecurityID,IntelligentCloudTok,CompanyName)
      END ELSE
        AddPermissionSetToUser(UserSecurityID,IntelligentCloudTok,CompanyName);
    END;

    
    LOCAL PROCEDURE AddPermissionSetToUser(UserSecurityID : GUID;RoleID : Code[20];Company : Text[30]);
    VAR
      AccessControl : Record 2000000053;
    BEGIN
      AccessControl.SETRANGE("User Security ID",UserSecurityID);
      AccessControl.SETRANGE("Role ID",RoleID);
      AccessControl.SETRANGE("Company Name",Company);

      IF NOT AccessControl.ISEMPTY THEN
        EXIT;

      AccessControl.INIT;
      AccessControl."Company Name" := Company;
      AccessControl."User Security ID" := UserSecurityID;
      AccessControl."Role ID" := RoleID;
      AccessControl.INSERT(TRUE);
    END;

    /* /*BEGIN
END.*/
}







