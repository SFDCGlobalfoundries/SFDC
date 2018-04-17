/**********************************************************************************************************************************
    Class:         CPQProcessDataButtonController 
    -----------------------------------------------------------------------------------------------------------------------------------
    Author:         Prosenjit Saha
    Description:    action to update configurator data. 
    History:
    PS              04202015    - Code Creation
***********************************************************************************************************************************/
public class CPQProcessDataButtonController {

    public CPQProcessDataButtonController(ApexPages.StandardSetController controller) {

    }

    public pageReference callBatchProcessData(){
        String query = 'select id, name, Status__c, Process_Technology__c, Processed_Version__c, Parent_Product_Name__c, Bundle_Product__c, Catalog_Type__c, Geometry__c from CPQ_MLGPLUS__c where Status__c = \'Ready to Load\'';
        String [] emails ; 
        List<String> UserIDs = new List<String>();
        emails = new String[]{};
        for(GroupMember GrpMem : [select    id
                                            , GroupId
                                            , Group.name 
                                            , UserOrGroupId
                                  from      GroupMember
                                  where     Group.name = 'CPQ MLGPLUS Admin Users']){
            UserIDs.add(GrpMem.UserOrGroupId);   
            system.debug('[debug: UserID-->]'+GrpMem.UserOrGroupId);                       
        }
        
        for(User useremail : [select    id
                                        , email
                              from      User
                              where     id 
                              IN        :UserIDs]){
            system.debug('[debug: User-->]'+useremail );    
            if(useremail.email!= null ){
                emails.add(useremail.email);
            }
        }
        //String email = 'Prosenjit.saha@cognizant.com' ; 
        CPQConfigDataHandlerBatch BatchConfigData = new CPQConfigDataHandlerBatch (query, emails);
        Id batchprocessId = Database.executeBatch(BatchConfigData ,1);
        return (new pageReference('/apex/CPQUpdateMonitor?PageType=ConfigDataUpdate'));

    }
}