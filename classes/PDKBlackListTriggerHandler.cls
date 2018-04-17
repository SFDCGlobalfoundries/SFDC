/*
* @ Author :- Prajnith Karra
* @ Company :- GF
* @ Description :- Trigger to validate any existing DPs are present
* @ Date :- 11/10/2014
* @ Change History :- 
* @ Created Date: 5/6/2017
**/
public class PDKBlackListTriggerHandler
{

    public static void onBeforeInsertUpdate(list<PDK_Blacklist__c> triggernew)
    {
        set<ID> bundleIDs = new set<ID>();
        set<ID> accIds = new set<ID>();
        map<string,list<String>> accPDKids =  new map<string,list<String>>();
        set<String> DPStatus = new set<String>();
        DPStatus.add('De-Provisioned');
        DPStatus.add('Rejected');        
        
        for(PDK_Blacklist__c oPDKblacklist : triggernew){
                 bundleIDs.add(oPDKblacklist.PDK__c);
                 accIds.add(oPDKblacklist.Account__c);                
        }          
              
        // query DP reocrds with status Provisioned and with combination of account and pdk bundle ids
        for(Document_Provisioning__c oDP : [SELECT ID,Name,AccountID__c,Sub_PDK__c FROM Document_Provisioning__c WHERE 
                                            AccountID__c IN: accIds 
                                            AND Sub_PDK__c IN: bundleIDs
                                            AND Status__c NOT IN: DPStatus])
        {
                string key = ''+oDP.AccountID__c + oDP.Sub_PDK__c;   
                string linktoRecord  = '<a href=/'+ oDP.ID +'>'+ oDP.Name+ '</a>';                                                     
                if(accPDKids.containsKey(key)){
                   accPDKids.get(key).add(linktoRecord  ); 
                }
                else{
                    accPDKids.put(key,new list<string>()); 
                    accPDKids.get(key).add(linktoRecord  );                 
                }                        
        }
        
        // throw error message if account and PDK combination is found
        for(PDK_Blacklist__c oPDKblacklist : triggernew){     
            string key = ''+oPDKblacklist.Account__c+oPDKblacklist.PDK__c;
            if(accPDKids.containsKey(key)) {                
                oPDKblacklist.addError('Please DeProvision Existing DP records'+accPDKids.get(key),false);
            }            
        }       
    }
    
    public static void onDPUpdate(Map<Id,Document_Provisioning__c> newMap, Map<Id,Document_Provisioning__c> oldMap){
        set<ID> accIds = new set<ID>();
        set<ID> pdkBundleIDs = new set<ID>();
        map<string,ID> keymap = new map<String,ID>();
        
        // Query All DP records based on account and PDK combination
        for(Document_Provisioning__c dp: newMap.values()){                          
                if(dp.Sub_PDK__c != null && ( trigger.isInsert ||oldMap.get(dp.ID).Status__c != dp.Status__c)){                  
                     if((dp.Status__c == 'De-Provisioning In Progress' || dp.Status__c == 'Provisioned' || dp.Status__c == 'Provisioning In Progress' || dp.Status__c == 'Sent For Approval')){                                             
                            accIds.add(dp.AccountID__c); 
                            pdkBundleIDs.add(dp.Sub_PDK__c);
                            keymap.put(''+dp.AccountID__c+dp.Sub_PDK__c,dp.ID);  
                        }                                  
                  }
             }               
                            
         // Query PDK Blacklist reocrds based on account and pdk records filterted above
         for(PDK_Blacklist__c oPDKblacklist : [SELECT ID,Name,Account__c,PDK__c FROM PDK_Blacklist__c WHERE Account__c IN: accIds AND PDK__c IN: pdkBundleIDs AND BlackList_Activated__c =: TRUE]){                                
                 string key =  ''+oPDKblacklist.Account__c+ oPDKblacklist.PDK__c;
                 if(keymap.containsKey(key)){ // if combination matches
                     if(newMap.containskey(keymap.get(key))){ // if DP matches
                        string linktoRecord  = '<a href=/'+ oPDKblacklist.Id +'>'+ oPDKblacklist.Name+ '</a>';  
                        newMap.get(keymap.get(key)).addError('Error: DP Status cannot be updated, becase this PDK Bundle and Account is Blacklisted '+linktoRecord,false  );                                              
                     }
                 }
         }
    
    }           
}