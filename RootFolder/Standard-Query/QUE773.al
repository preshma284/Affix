query 50210 "Users in User Groups 1"
{


    CaptionML = ENU = 'Users in User Groups', ESP = 'Usuarios en grupos de usuarios';

    elements
    {

        DataItem("User_Group_Member"; "User Group Member")
        {

            Column(UserGroupCode; "User Group Code")
            {

            }
            Column(NumberOfUsers)
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




