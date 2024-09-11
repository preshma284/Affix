page 7206927 "Jobs Change status Card"
{
CaptionML=ENU='Change status',ESP='Cambiar Estado';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    PageType=Worksheet;
  layout
{
area(content)
{
group("General")
{
        
    field("Status";Status)
    {
        
                CaptionML=ESP='Estado';
    }

}

}
}actions
{
area(Navigation)
{
//CaptionML=ESP='Acciones';

}
}
  
    var
      JobsStatus1 : Record 7207440;
      JobsStatus2 : Record 7207440;
      Status : Text;
      Type : Option;

    procedure SetStatus(pType : Option;pStatus : Text);
    begin
      Type := pType;
      Status := pStatus;

      if not JobsStatus1.GET(Type,Status) then begin
        JobsStatus2.RESET;
        JobsStatus2.SETCURRENTKEY(Usage,Order);
        JobsStatus2.SETRANGE(Usage, Type);
        if JobsStatus2.FINDFIRST then
          Status := JobsStatus2.Code;
      end;
    end;

    procedure GetStatus() : Text;
    begin
      exit(Status);
    end;

    // begin//end
}








