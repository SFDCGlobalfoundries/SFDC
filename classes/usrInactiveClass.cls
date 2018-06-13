public class usrInactiveClass{

    
    public void inactiveUsr(List<User> usrLst,List<User> usLst){
        
        List<GFSDR__Application_Approver__c> gfsAApprovLst = new List<GFSDR__Application_Approver__c>();
        Map<Id,User> usMap = new Map<Id,User>();
        Map<Id,GFSDR__Application_Approver__c> gfApprvMap = new Map<Id,GFSDR__Application_Approver__c>();
        Set<Id> usId = new Set<Id>();
        
        gfsAApprovLst = [select GFSDR__Application_Name__c,GFSDR__Role__c,GFSDR__User__c from GFSDR__Application_Approver__c limit 50000];
        
        
        for(GFSDR__Application_Approver__c  gfApp : gfsAApprovLst ){
        
            usId.add(gfApp.GFSDR__User__c);
            gfApprvMap.put(gfApp.GFSDR__User__c, gfApp);
        }
        
        for(User uss : usLst){
            
            usMap.put(uss.id,uss);            
        }
        
        system.debug('-ins-'+usId);
        
        for(User us : usrLst){
             if(usId.contains(us.id)){
                 if(!us.isactive && usMap.get(us.id).isactive){
                     
                    // String strLink = '<a href='+https://ap5.salesforce.com+'/'+gfApprvMap.get(us.id).id+' >'+ gfApprvMap.get(us.id).GFSDR__Application_Name__c+'</a> <br/>'; 
                     us.addError('ERROR: There is already an Identical Record: <a href=\'https://ap5.salesforce.com/a037F00000SaBgX\'>Go to Dupe Record</a>', false);
                                    
                }
             }  
        }
    }    
}