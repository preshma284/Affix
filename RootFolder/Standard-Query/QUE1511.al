query 50219 "UserIDsby Notification Type 1"
{


    CaptionML = ENU = 'User IDs by Notification Type', ESP = 'Id. de usuario por tipo de notificaci�n';

    elements
    {

        DataItem("Notification_Entry"; "Notification Entry")
        {

            Column("Recipient_User_ID"; "Recipient User ID")
            {

            }
            Column(Type; "Type")
            {

            }
            Column(Count_)
            {
                //MethodType=Totals;
                Method = Count;
            }
        }
    }


    /*begin
    end.
  */
}




