// query 50216 "Product Videos with Category 1"
// {


//     CaptionML = ENU = 'Product Videos with Category', ESP = 'V�deos del producto con categor�a';
//     OrderBy = Ascending(Category);

//     elements
//     {

//         DataItem("Product_Video_Category"; "Product Video Category")
//         {

//             Column("Category"; "Category")
//             {

//             }
//             Column("Alternate_Title"; "Alternate Title")
//             {

//             }
//             Column("Assisted_Setup_ID"; "Assisted Setup ID")
//             {

//             }
//             DataItem("Assisted_Setup"; "Assisted Setup")
//             {

//                 DataItemTableFilter = "Video Url" = FILTER(<> '');
//                 DataItemLink = "Page ID" = "Product_Video_Category"."Assisted Setup ID";
//                 SqlJoinType = InnerJoin;
//                 //DataItemLinkType=Exclude Row If No Match;
//                 Column("Name"; "Name")
//                 {

//                 }
//                 Column("Video_Url"; "Video Url")
//                 {

//                 }
//             }
//         }
//     }


//     /*begin
//     end.
//   */
// }




