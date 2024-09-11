table 7207430 "QBU Contact Activities QB"
{
  
  
    CaptionML=ENU='Contact Activities QB',ESP='Actividades de contactos HP';
    LookupPageID="Contact Creation Wizard";
    DrillDownPageID="Contact Creation Wizard";
  
  fields
{
    field(1;"Contact No.";Code[20])
    {
        TableRelation="Contact";
                                                   CaptionML=ENU='Contact No.',ESP='N§ Contacto';


    }
    field(2;"Activity Code";Code[20])
    {
        TableRelation="Activity QB"."Activity Code";
                                                   CaptionML=ENU='Activity Code',ESP='C¢d. actividad';


    }
    field(3;"Area Activity";Option)
    {
        OptionMembers="Local","Autonomous","National";CaptionML=ENU='Area Activity',ESP='µmbito actividad';
                                                   OptionCaptionML=ENU='Local,Autonomous,National',ESP='Local,Auton¢mico,Nacional';
                                                   
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Contact No.","Activity Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    procedure GetDescriptionActivity () : Text[50];
    var
//       ActivityQB@1100286000 :
      ActivityQB: Record 7207280;
    begin
      if not ActivityQB.GET("Activity Code") then
        CLEAR(ActivityQB);

      exit(ActivityQB.Description);
    end;

    procedure GetDescriptionContact () : Text[50];
    var
//       Contact@7001100 :
      Contact: Record 5050;
    begin
      if not Contact.GET("Contact No.") then
        CLEAR(Contact);

      exit(Contact.Name);
    end;

    procedure RelationshipBusinessCreated () : Code[20];
    var
//       locConfContactos@1100251000 :
      locConfContactos: Record 5079;
//       MarketingSetup@7001100 :
      MarketingSetup: Record 5079;
//       locrecContactBussines@1100251001 :
      locrecContactBussines: Record 5054;
//       ContactBusinessRelation@7001101 :
      ContactBusinessRelation: Record 5054;
    begin
      if "Contact No." = '' then
        exit('');

      MarketingSetup.GET;
      ContactBusinessRelation.SETRANGE("Contact No.","Contact No.");
      ContactBusinessRelation.SETRANGE("Business Relation Code",MarketingSetup."Bus. Rel. Code for Vendors");
      ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Vendor);
      if ContactBusinessRelation.FINDFIRST then
        exit(ContactBusinessRelation."No.")
      else
        exit('');
    end;

    /*begin
    end.
  */
}







