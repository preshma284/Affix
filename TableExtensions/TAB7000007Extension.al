tableextension 50227 "QBU Closed Bill GroupExt" extends "Closed Bill Group"
{
  
  
    CaptionML=ENU='Closed Bill Group',ESP='Remesa cerrada';
    LookupPageID="Closed Bill Groups List";
    DrillDownPageID="Closed Bill Groups List";
  
  fields
{
    field(7207271;"QBU Bill Group Confirming";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Bill Group Confirming',ESP='Remesa Confirming';
                                                   Description='QB 1.10.09 JAV 13/01/22: - [TT] Indica si esta remesa es de Confirmnig';


    }
    field(7207290;"QBU Factoring Line";Code[20])
    {
        TableRelation="QB Confirming Lines";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='L¡nea de Factoring';
                                                   Description='QB 1.06.15 - JAV 23/09/20: L¡nea de Factoring asociada al banco de la remesa' ;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Bank Account No.","Posting Date")
  //  {
       /* SumIndexFields="Collection Expenses Amt.","Discount Expenses Amt.","Discount Interests Amt.","Rejection Expenses Amt.","Risked Factoring Exp. Amt.","Unrisked Factoring Exp. Amt.";
 */
   // }
   // key(key3;"Bank Account No.","Posting Date","Factoring")
  //  {
       /* SumIndexFields="Collection Expenses Amt.","Discount Expenses Amt.","Discount Interests Amt.","Rejection Expenses Amt.","Risked Factoring Exp. Amt.","Unrisked Factoring Exp. Amt.";
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text1100000@1000 :
      Text1100000: TextConst ENU='untitled',ESP='sin t¡tulo';
//       ClosedDoc@1100001 :
      ClosedDoc: Record 7000004;
//       BGPOCommentLine@1100002 :
      BGPOCommentLine: Record 7000008;

    


/*
trigger OnDelete();    begin
               ClosedDoc.SETRANGE("Bill Gr./Pmt. Order No.","No.");
               ClosedDoc.DELETEALL;

               BGPOCommentLine.SETRANGE("BG/PO No.","No.");
               BGPOCommentLine.DELETEALL;
             end;

*/




/*
procedure Caption () : Text[100];
    begin
      if "No." = '' then
        exit(Text1100000);
      CALCFIELDS("Bank Account Name");
      exit(STRSUBSTNO('%1 %2',"No.","Bank Account Name"));
    end;

    /*begin
    end.
  */
}





