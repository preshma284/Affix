pageextension 50241 MyExtension659 extends 659//456
{
layout
{


}

actions
{


}

//trigger

//trigger

var
      PostedRecordID : Text;

    
    

//procedure
procedure Setfilters(TableId : Integer;DocumentNo : Code[20]);
    begin
      if ( TableId <> 0  )then begin
        Rec.FILTERGROUP(2);
        Rec.SETRANGE("Table ID",TableId);
        if ( DocumentNo <> ''  )then
          Rec.SETRANGE("Document No.",DocumentNo);
        Rec.FILTERGROUP(0);
      end;
    end;

//procedure
}

