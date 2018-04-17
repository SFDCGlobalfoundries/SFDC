public class LMSUtil
{

   
   
   
   
   public static String createNotificationMessage(String userFullName,List<LMSUtil.IdAndName> modules)
   {
      String s = '<html><style>p{margin-top:0px; margin-bottom:0px;}</style>';
      s += '<body class=\"setupTab\"  style=\" background-color:#FFFFFF; bLabel:body; bEditID:b1st1;\">';
      s += '<center><table id=\"topTable\" height=\"450\" width=\"500\" cellpadding=\"0\" cellspacing=\"0\">';
      s += '<tr valign=\"top\">';
      s += '<td style=\" vertical-align:top; height:100; text-align:left; background-color:#FFFFFF; bLabel:header; bEditID:r1st1;\">';
      //s += '<img id=\"r1sp1\" bLabel=\"headerImage\" border=\"0\" bEditID=\"r1sp1\" src=\"https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=01590000000fHf1&oid=00D90000000hFnD\" ></img>';
      s += '<img id=\"r1sp1\" bLabel=\"headerImage\" border=\"0\" bEditID=\"r1sp1\" src=\"' + Label.Salesforce_Org_URL_PROD + '/servlet/servlet.ImageServer?id=01590000000fHf1&oid=00D90000000hFnD\" ></img>';
      s += '</td></tr>';
      s += '<tr valign=\"top\"><td  style=\" height:3; background-color:#FF9900; bLabel:accent1; bEditID:r2st1;\"></td></tr>';
      s += '<tr valign=\"top\" ><td styleInsert=\"1\" height=\"300\"  style=\" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;\">';
      s += '<table height=\"400\" width=\"550\" cellpadding=\"5\" border=\"0\" cellspacing=\"5\" >';
      s += '<tr height=\"400\" valign=\"top\" >';
      s += '<td style=\" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;\" tEditID=\"c1r1\" aEditID=\"c1r1\" locked=\"0\" >';
      s += '<div>Dear&nbsp;<span>';
      s += userFullName;
      s += '</span></div><div><br></div>You have been enrolled in new training.<div><br></div>';
      s += '<div><br></div>';   
      s += '<div style=\'font-weight:bold;\'>The modules available for this training are:</div><div><br></div>';  
      for(LMSUtil.IdAndName module:modules)
      {
          s += '<div>&nbsp;&nbsp;&nbsp;' + module.Name + '</div>';
      }
      
      s += '<div><br></div><div><br></div>';
      s += '<div>To access your new training assignment, please go to <a href=\"';
      s += URL.getSalesforceBaseUrl().toExternalForm() +'/apex/MyTraining\">';
      s += 'My Training tab</a></div>';
  
      s += '<div><br></div><div>Thank you,</div><div>SaM Training</div>';
      s += '</td></tr></table></td></tr><tr valign=\"top\" >';
      s += '<td  style=\" height:3; background-color:#FF9900; bLabel:accent2; bEditID:r4st1;\"></td></tr>';
      s += '<tr valign=\"top\" ><td  style=\" vertical-align:top; height:100; text-align:left; background-color:#FFFFFF; bLabel:footer; bEditID:r5st1;\"></td>';
      s += '</tr><tr valign=\"top\" ><td  style=\" height:0; background-color:#FF9900; bLabel:accent3; bEditID:r6st1;\"></td></tr></table>';
      s += '</center><br><br></body></html>';

      return s;
   
   }

   public class IdAndName
   {
       public String Id {get;set;}
       public String Name {get;set;}
   }


}