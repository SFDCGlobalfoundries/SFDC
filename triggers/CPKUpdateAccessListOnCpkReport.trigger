/**
 * Author: 
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a CPKUpdateAccessListOnCpkReport trigger. It handles trigger events before insert, update, delete and after insert.
 *            
 * History:
 * <Vijay>     22042014 - commented code from Line No.108 to Line No.131. Commented CPK Report Sharing functionality. Now it is shared with all 
                          users with read only access and record  visibility is handled on FV page for customer portal user based on certain criteria.
                          
 */
trigger CPKUpdateAccessListOnCpkReport on CPK_Report_Access_List__c (before insert,before delete,before update,after insert) {
ClsNewCPKReport clsNewCpkIns = new ClsNewCPKReport();

        if(Trigger.isBefore){
            if(Trigger.isInsert || Trigger.isUpdate){
                  
                Set<Id> accountIdSet = new Set<Id>();
                Set<ID> cpkReportIdSet = new Set<Id>();
                Map<Id, CPK_Report__c> cpkReportMap = new Map<Id, CPK_Report__c>();
                List<Account_Team_Proxy__c> accountTeamProxyList = new List<Account_Team_Proxy__c>();
                Map<String, List<Account_Team_Proxy__c>> accountTeamProxyListMap = new Map<String, List<Account_Team_Proxy__c>>();
                List<CPK_Report_Access_List__c> cpkaccessList = new List<CPK_Report_Access_List__c>();
                
                for(CPK_Report_Access_List__c associatedCustomer : Trigger.new){
                    accountIdSet.add(associatedCustomer.Account__c);
                    cpkReportIdSet.add(associatedCustomer.CPK_Report__c);
                }
                cpkaccessList = [SELECT id,CPK_Report__c,Account__c FROM CPK_Report_Access_List__c WHERE CPK_Report__c IN : cpkReportIdSet AND                  Account__c IN: accountIdSet];
                //AmarSmrutipattanaik-11072016
                //Logic for Duplicate Check and Show Error Message
                Set<String> uniqueCpkAccStr = new Set<String>(); 
                if(cpkaccessList.size() > 0){
                    for(CPK_Report_Access_List__c cpk: cpkaccessList ){
                        string str1 = cpk.CPK_Report__c;
                        string str2 = cpk.Account__c;
                        string struniqueCpkAccStr = str1 + str2;
                        if(struniqueCpkAccStr != null){
                        uniqueCpkAccStr.add(struniqueCpkAccStr);
                        }
                    }
                }
                
                if(!cpkReportIdSet.isEmpty()){
                    cpkReportMap = new Map<Id, CPK_Report__c>([Select Id, Name, Stage__c From CPK_Report__c where Id IN :cpkReportIdSet]);
                }
                
                if(!accountIdSet.isEmpty()){
                    accountTeamProxyList = [Select  Id, Name, Account__r.Id, user__c,user__r.Id,
                                                    user__r.Fab_Assigned__c 
                                            From    Account_Team_Proxy__c 
                                            where   Account__c IN : accountIdSet AND Team_Role__C = 'Customer Engineer'];
                    
                 
                    
                }
                
                if(accountTeamProxyList != null && !accountTeamProxyList.isEmpty()){
                    for(Account_Team_Proxy__c accountTeamProxy : accountTeamProxyList){
                        if(!accountTeamProxyListMap.containsKey(accountTeamProxy.Account__c)){
                            accountTeamProxyListMap.put(accountTeamProxy.Account__c, new List<Account_Team_Proxy__c>());
                        }
                        accountTeamProxyListMap.get(accountTeamProxy.Account__c).add(accountTeamProxy);
                    }
                }
                
                for(CPK_Report_Access_List__c associatedCustomer : Trigger.new){
                    ClsUpdateCPKReportOnReportUpload.UpdateAccessList(associatedCustomer, accountTeamProxyListMap);
                    if(Trigger.isUpdate){
                        //[Amit Kumar Ojha] Resolved the Null Pointer Exception - 16102017
                        if(cpkReportMap != null && (cpkReportMap.get(associatedCustomer.Account__c).Stage__c != null && cpkReportMap.get(associatedCustomer.Account__c).Stage__c != '' 
                            && (cpkReportMap.get(associatedCustomer.Account__c).Stage__c == 'Pending QA Approval' || 
                            cpkReportMap.get(associatedCustomer.Account__c).Stage__c == 'Approved' || 
                            cpkReportMap.get(associatedCustomer.Account__c).Stage__c =='Pending PI Approval'))){
                             //System.debug('Display error');
                             associatedCustomer.addError('Customers cannot be edited once QA or PI approvals are done');
                        }
                    }
                    //AmarSmrutipattanaik-11072016
                    if(Trigger.isInsert){
                    string tempstr1 = associatedCustomer.CPK_Report__c;
                    string tempstr2 = associatedCustomer.Account__c;
                        String tempstring = tempstr1 + tempstr2;
                        //System.debug('tempstring--->'+tempstring);
                         if(tempstring != null){
                            if(uniqueCpkAccStr.contains(tempstring)){ 
                                associatedCustomer.addError(Label.Associate_Customer);
                            }
                         } 

                    }
                }
            }
             
             
          if(Trigger.IsDelete && Utility.CPK_ACCESS_LIST_TRIGGER_RUNNING == false){

              Map<Id,Id> MIdCPKIddel = new Map<Id,Id>();
              for(CPK_Report_Access_List__c accList : Trigger.old){
                  MIdCPKIddel.put(accList.Id,accList.CPK_Report__c);
              }
              Map<Id,CPK_Report__c> MCPKReports ;
            
            if(!MIdCPKIddel.values().isEmpty()){
                MCPKReports = new Map<Id,CPK_Report__c>([Select Id,Stage__c,ASIC_Report__c from CPK_Report__c where Id in :(MIdCPKIddel.values())]);
            }
            Map<Id,CPK_Report__c> MCustIdCPKReportDel=new Map<Id,CPK_Report__c>();
            for(CPK_Report_Access_List__c accList : Trigger.old){
                MCustIdCPKReportDel.put(accList.Id,MCPKReports.get(accList.CPK_Report__c));    
            }
              for(CPK_Report_Access_List__c accList : Trigger.old){
                  if(MCustIdCPKReportDel.get(accList.Id).Stage__c=='Pending QA Approval' || MCustIdCPKReportDel.get(accList.Id).Stage__c=='Approved' || MCustIdCPKReportDel.get(accList.Id).Stage__c=='Pending PI Approval' ){            
                     
                    accList.addError('Customers cannot be deleted once QA or PI approvals are done');  
                  }
              }
          }   
         }
           if(Trigger.isDelete && Utility.CPK_ACCESS_LIST_TRIGGER_RUNNING == false)
            {
            Map<String,String> mapId = new Map<String,String>();
            for(CPK_Report_Access_List__c accList : Trigger.old)
            {
             mapId.put(accList.CPK_Report__c,accList.Short_Name__c);
            }
            DeleteAssociateCustoer.CreateDeleteObject(mapId,'CPK');
            
            }
            
}