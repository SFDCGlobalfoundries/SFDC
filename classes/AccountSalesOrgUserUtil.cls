/*
  Author: Mallika Seth
  Description: This is a utility class to skip trigger run for data loading specificaly for Account Sales Org
  History:
    MSETH            03022017    - code creation.                     
*/

public class AccountSalesOrgUserUtil {
    
    public static boolean isSkipTrigger(){
        boolean isSkipTrigger = false;      
        List<GroupMember> PGList= new List<GroupMember>();
        PGList=[select id,group.name from GroupMember where group.type='Regular' and group.name='AccountSalesORG' and UserOrGroupId = :UserInfo.getUserId()];
        System.debug('@@@123'+PGList.size());
        if(PGList.size()>0 && PGList!= null){
            isSkipTrigger = true;
             System.debug('@@@123Yes');
        }
        return isSkipTrigger;
    }
    
}