tableextension 50211 "QBU SII Missing Entries StateExt" extends "SII Missing Entries State"
{
  
  
    CaptionML=ENU='SII Missing Entries State',ESP='Estado movs. SII que faltan';
  
  fields
{
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
  

    
/*
procedure Initialize ()
    begin
      if not GET then begin
        INIT;
        INSERT(TRUE);
      end;
    end;
*/


    
    
/*
procedure SIIEntryRecreated () : Boolean;
    begin
      if not GET then
        exit(FALSE);
      exit(
        ("Last CLE No." <> 0) or
        ("Last VLE No." <> 0) or
        ("Last DCLE No." <> 0) or
        ("Last DVLE No." <> 0));
    end;

    /*begin
    end.
  */
}





