Codeunit 60000 "AML No tocar"
{
  
  
    trigger OnRun()
BEGIN
          END;

    [EventSubscriber(ObjectType::Table, 7207277, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T7207277_OnInsert(VAR Rec : Record 7207277;RunTrigger : Boolean);
    BEGIN
      IF Rec."No." = '0812' THEN BEGIN
        Rec."No." := Rec."No.";
      END;
    END;

    [EventSubscriber(ObjectType::Table, 7207277, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T7207277_OnModify(VAR Rec : Record 7207277;VAR xRec : Record 7207277;RunTrigger : Boolean);
    BEGIN
      IF (Rec."No." = '0812') AND (Rec."Price Cost" < 15.28) THEN BEGIN
        Rec."No." := Rec."No.";
      END;
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T7207386_OnInsert(VAR Rec : Record 7207386;RunTrigger : Boolean);
    BEGIN
      IF Rec."Piecework Code" = '010101' THEN BEGIN
      Rec."Piecework Code"   := Rec."Piecework Code";
      END;
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T7207386_OnModify(VAR Rec : Record 7207386;VAR xRec : Record 7207386;RunTrigger : Boolean);
    BEGIN
      IF Rec."Piecework Code" = '010101' THEN BEGIN
      Rec."Piecework Code"   := Rec."Piecework Code";
      END;
    END;

    [EventSubscriber(ObjectType::Table, 17, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T17_OnInsert(VAR Rec : Record 17;RunTrigger : Boolean);
    BEGIN
      Rec."Entry No." := Rec."Entry No.";
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "QB Line Proformable", true, true)]
    LOCAL PROCEDURE T39_QBLineProformable(VAR Rec : Record 39;VAR xRec : Record 39;CurrFieldNo : Integer);
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 169, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T169_OnInsert(VAR Rec : Record 169;RunTrigger : Boolean);
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7207392, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T7207392_OnInsert(VAR Rec : Record 7207392;RunTrigger : Boolean);
    BEGIN
      Rec."Entry No." := Rec."Entry No.";
    END;

    [EventSubscriber(ObjectType::Table, 7207392, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T7207392_OnModify(VAR Rec : Record 7207392;VAR xRec : Record 7207392;RunTrigger : Boolean);
    BEGIN
      Rec."Entry No." := Rec."Entry No.";
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeValidateEvent, "Piecework No.", true, true)]
    LOCAL PROCEDURE T39_Piecework(VAR Rec : Record 39;VAR xRec : Record 39;CurrFieldNo : Integer);
    BEGIN
      Rec."Document Type" := Rec."Document Type";
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnInsert(VAR Rec : Record 39;RunTrigger : Boolean);
    BEGIN
      Rec."Document Type" := Rec."Document Type";
    END;

    /* BEGIN
END.*/
}









