// query 50211 "Users in Plans 1"
// {


//     CaptionML = ENU = 'Users in Plans', ESP = 'Usuarios en los planes';
//Properties in the base query
// InherentEntitlements = X;
// InherentPermissions = X;
// Permissions = tabledata Plan = r,
//               tabledata User = r,
//               tabledata "User Plan" = r;
// elements
// {

// DataItem("User_Plan"; "User Plan")
// {

//     SqlJoinType = InnerJoin;
//     //DataItemLinkType=Exclude Row If No Match;
//     Column("User_Security_ID"; "User Security ID")
//     {

//     }
//     Column("User_Name"; "User Name")
//     {

//     }
//     Column("Plan_ID"; "Plan ID")
//     {

//     }
//     Column("Plan_Name"; "Plan Name")
//     {

//     }
//     DataItem("User"; "User")
//     {

//         DataItemLink = "User Security ID" = "User_Plan"."User Security ID";
//         Column(User_State; "State")
//         {
//             CaptionML = ENU = 'User State', ESP = 'Estado del usuario';
//         }
//     }
// }
// }


/*begin
end.
*/
// }




