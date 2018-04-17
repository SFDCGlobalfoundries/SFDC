/*
    Company:        Cognizant Technology Solution
    Description:    Batch Class to recalculate sharing for CSrs and Customers when the Reticle Status is Notify or Feedback   
    History:
    
    Ankit Singhal   28112013    Class Creation
    Sameer Matale   04032014    Sharing with FTA and FAS
    NJain           02042014    Removed portal user sharing logic
    NJain           24072014    Changed the queryLocator query to fetch Reticles based on new filters(Account or ROS Cycle)
                                Created new methods ReCalculateSharing(), checkRunningJobStatus(), returnToReticleSearch()
    
*/
global class ROS_ReCalculateSharing implements Database.Batchable<sObject>{
    
    global Reticle__c reticleRecord{get;set;}
    global String whereClause;
    global boolean IsRecalculationRunning{get;set;}
    
    global ROS_ReCalculateSharing(){
        reticleRecord = new Reticle__C();
    }
      
    global ROS_ReCalculateSharing(String whereCls){           
        this.whereClause = whereCls;       
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){    
        String query;
        if(Test.isRunningTest()){
            query='Select Id,IsActive__c,Name,Account__c,Reticle_workflow_Status__c from Reticle__c limit 1';
        }else{
            system.debug('###whereClause###'+whereClause);
            if(whereClause != NULL && whereClause != ''){
                query='Select Id,IsActive__c,Name,Account__c,Reticle_workflow_Status__c from Reticle__c where ' + whereClause;
            }else{
                query='Select Id,IsActive__c,Name,Account__c,Reticle_workflow_Status__c from Reticle__c ';
            }
        }   
        system.debug('#########Query String#####'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC ,List<Reticle__c> scope){
    
        Map<Id,Id> MAccountIds = new Map<Id,Id>();  
        for(Reticle__c ret : scope) {
            MAccountIds.put(ret.Id,ret.Account__c);
        }  
        //Map<Id,List<Contact>> MRetIdContacts = new Map<Id,List<Contact>>();
        //Map<Id,Set<Id>> MRetIdPortalUsers = new Map<Id,Set<Id>>();
        Map<Id,Account> MAccountATPContactlist = new Map<Id,Account>([SELECT Id, Name
                                                                          ,(SELECT Id,Team_Role__c,User__c 
                                                                              FROM Account_Team_Proxy__r 
                                                                              WHERE User__r.IsActive = true
                                                                                AND ( Team_Role__c IN ( 'Primary Customer Service Rep',
                                                                                                        'Backup Customer Service Rep',
                                                                                                        'Customer Service Rep',
                                                                                                        'Primary Field Technical Support',
                                                                                                        'Primary Field Application Engineer',
                                                                                                        'Field Technical Support',
                                                                                                        'Field Application Engineer',
                                                                                                        'Customer Engineer')
                                                                                    OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                                                    OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                                                            )
                                                                      FROM Account 
                                                                      WHERE Id in : MAccountIds.values()]);
        //Nikhil-- Removing portal sharing logic                                                               
        /*for(Reticle__c ret : scope){                                                            
            MRetIdContacts.put(ret.Id,MAccountATPContactlist.get(MAccountIds.get(ret.Id)).Contacts);
        }
        
        MRetIdPortalUsers = ROS_ReticleDatawarehousehelper.createMapIdPortalUsers(MRetIdContacts);
        */
        List<Reticle__Share> lReticleShare = new List<Reticle__Share>();
        
        for(Reticle__c eachRet : scope) {
           //if(eachRet.Reticle_workflow_Status__c == 'Pending for Customer Feedback' || eachRet.Reticle_workflow_Status__c == 'Pending to Notify Customer'){
               lReticleShare.addAll(ROS_ReticleDatawareHouseBatchHelper.shareReticleAtp(eachRet.Id, MAccountATPContactlist.get(MAccountIds.get(eachRet.Id)).Account_Team_Proxy__r));
           //}
           //Nikhil--Commenting the unnecessary if else loops and portal sharing
           /*
           if(eachRet.Reticle_workflow_Status__c == 'Pending for Customer Feedback'){  
                lReticleShare.addAll(ROS_ReticleDatawareHouseBatchHelper.shareReticleAtp(eachRet.Id, MAccountATPContactlist.get(MAccountIds.get(eachRet.Id)).Account_Team_Proxy__r));      
                //Nikhil-- Removing portal sharing logic
                //for(Reticle__Share res : ROS_ReticleDatawarehousehelper.SharingRecordswithCSRs_1(eachRet.Id,MRetIdPortalUsers.get(eachRet.Id),'edit',''+Schema.Reticle__Share.RowCause.Sharing_Reticle_Contacts__c+'')){
                //    lReticleShare.add(res);
                //}
           }
           else{
                if(eachRet.Reticle_workflow_Status__c =='Pending to Notify Customer' && eachret.Isactive__c==false){
                    lReticleShare.addAll(ROS_ReticleDatawareHouseBatchHelper.shareReticleAtp(eachRet.Id, MAccountATPContactlist.get(MAccountIds.get(eachRet.Id)).Account_Team_Proxy__r));
                }
                else if(eachRet.Reticle_workflow_Status__c =='Pending to Notify Customer' && eachret.Isactive__c==true){
                    lReticleShare.addAll(ROS_ReticleDatawareHouseBatchHelper.shareReticleAtp(eachRet.Id, MAccountATPContactlist.get(MAccountIds.get(eachRet.Id)).Account_Team_Proxy__r));
                    //Nikhil-- Removing portal sharing logic
                    //for(Reticle__Share res : ROS_ReticleDatawarehousehelper.SharingRecordswithCSRs_1(eachRet.Id,MRetIdPortalUsers.get(eachRet.Id),'edit',''+Schema.Reticle__Share.RowCause.Sharing_Reticle_Contacts__c+'')){
                    //    lReticleShare.add(res);
                    //}
                } 
            }*/ 
        }
        List<Reticle__Share> LShare = new List<Reticle__Share>([Select Id from Reticle__Share 
                                                                where ParentId in :MAccountIds.keyset() 
                                                                      and RowCause = :Schema.Reticle__Share.RowCause.Sharing_with_CSR__c]);
        if(!LShare.isEmpty()){
            Database.DeleteResult[] delrs=Database.delete(LShare,false);
        }
        if(!lReticleShare.isEmpty()){
            Database.SaveResult[] lsr = Database.insert(lReticleShare,false);
        }
   }
   
    global void finish(Database.BatchableContext BC){      
        system.debug('####Batch Job Completed####');
    }
    
    global PageReference ReCalculateSharing() {
        if(!checkRunningJobStatus()){
        
            String whereClauseInner = ' Name != NULL ';
            if(reticleRecord.Account__c != NULL){
                whereClauseInner += ' AND Account__c = \''+reticleRecord.Account__c+'\' ';
            }
            if(reticleRecord.ROS_Cycle__c != NULL){
                whereClauseInner += ' AND ROS_Cycle__c= \''+reticleRecord.ROS_Cycle__c+'\' ';
            }
            system.debug('####whereClauseInner ####'+ whereClauseInner );
            try{
                if(Test.isRunningTest()){
                    ROS_ReCalculateSharing DWB2 = new ROS_ReCalculateSharing(whereClauseInner);
                    database.executeBatch(DWB2,1);
                }else{
                    database.executeBatch(new ROS_ReCalculateSharing(whereClauseInner),20);
                }
            }
            catch(Exception ex){
                ROS_Util.insertException(ex, 'ROS_ControllerSearchReticleGFForm','ROS');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Recalculation of Sharing failed,Please try again later.'));
                return null;
            }
        }
        return NULL;
    }
    
    global boolean checkRunningJobStatus(){
        List<AsyncApexJob> BatchJob = new List<AsyncApexJob>([SELECT Id, Status, ApexClass.Name 
                                                              FROM AsyncApexJob 
                                                                  WHERE  
                                                                      ApexClass.Name = 'ROS_ReCalculateSharing'
                                                                      AND Status in ('Processing','Preparing','Queued','Holding') 
                                                              LIMIT 1]);
        if(BatchJob != NULL && !BatchJob.isEmpty()){
            IsRecalculationRunning=true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Recalculation of Sharing is already running. Please try again later.'));
            return true;
        }else{
            IsRecalculationRunning=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Recalculation of Sharing started.'));
            return false;
        }
    }
    
    public Pagereference returnToReticleSearch(){    
        pagereference BacktoReticleSearch=page.ROSVF_SearchReticlesGFForm;
        BacktoReticleSearch.setRedirect(true); 
        return BacktoReticleSearch;  
    }
}