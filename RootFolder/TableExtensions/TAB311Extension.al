tableextension 50746 "MyExtension50746" extends "Sales & Receivables Setup"
{
  
  
    CaptionML=ENU='Sales & Receivables Setup',ESP='Conf. ventas y cobros';
    LookupPageID="Sales & Receivables Setup";
    DrillDownPageID="Sales & Receivables Setup";
  
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
  
    var
//       Text001@1000 :
      Text001: TextConst ENU='Job Queue Priority must be zero or positive.',ESP='La prioridad de la cola de proyecto debe ser cero o positiva.';
//       GLSetup@1100000 :
      GLSetup: Record 98;
//       RecordHasBeenRead@1001 :
      RecordHasBeenRead: Boolean;

    
    
/*
procedure GetRecordOnce ()
    begin
      if RecordHasBeenRead then
        exit;
      GET;
      RecordHasBeenRead := TRUE;
    end;
*/


    
    
/*
procedure GetLegalStatement () : Text;
    begin
      exit('');
    end;
*/


    
    
/*
procedure JobQueueActive () : Boolean;
    begin
      GET;
      exit("Post with Job Queue" or "Post & Print with Job Queue");
    end;
*/


//     LOCAL procedure CheckGLAccPostingTypeBlockedAndGenProdPostingType (AccNo@1000 :
    
/*
LOCAL procedure CheckGLAccPostingTypeBlockedAndGenProdPostingType (AccNo: Code[20])
    var
//       GLAcc@1002 :
      GLAcc: Record 15;
    begin
      if AccNo <> '' then begin
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
        GLAcc.TESTFIELD("Gen. Prod. Posting Group");
      end;
    end;

    /*begin
    //{
//      BS19773 CSM 19/10/23 Í Permitir fecha emisi¢n superior.
//    }
    end.
  */
}




