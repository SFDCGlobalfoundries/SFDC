/*
Type Name: UpdateSpecificationReleaseList Trigger
Author: Cognizant 
Created Date: 16-Oct-2013
Reason: 
Change History:
Author: Cognizant 
Modified Date:28/03/2014
Reason: Field change corresponding to CR # 4562
Author: Cognizant 
Modified Date:22/07/2014
Reason: Case 43990 -Specification release list updated wrongly when spec is inserted from PLM
??..
??..
*/

trigger UpdateSpecificationReleaseList on Design_Spec__c (before insert,before update) {

  List<String> accList = new List<String>();
  List<Design_Spec__c> listSTFmodified = new List<Design_Spec__c>();
  Set<String> setAllAccIds = new Set<String>();
  Map<Decimal, List<String>> mapDSIdToAccLists = new Map<Decimal, List<String>>();
  Map<Id,String> mapOfDsSFDCIdToAccLists = new Map<Id,String>();
  Map<String, String> mapAccSNToAccNames = new Map<String, String>();
  List<Document_Provisioning__c> lstDeprovisionedDp = new List<Document_Provisioning__c>();
 
  for(Design_Spec__c objDS: trigger.new)
  {
   if(objDS.Specification_Release_List_Long__c!=null && objDS.Release_Status__c!='Release to White list')
   {
    objDS.Accounts_Auto_Provisioned_To__c=objDS.Specification_Release_List_Long__c;
   }
   else if(objDS.Specification_Release_List_Long__c==null && objDS.Release_Status__c!='Release to White list')
   {
    objDS.Accounts_Auto_Provisioned_To__c='';
   }
   else if(objDS.Release_Status__c=='Release to White list')
   {
   objDS.Accounts_Auto_Provisioned_To__c='';
   }
  }
  
  for(Design_Spec__c objDS: trigger.new){
          accList = new List<String>();
           if(objDS.Specification_Release_List_Long__c!=null){ // CR # 4562 ? Field replaced
                if(objDS.Specification_Release_List_Long__c.contains(';')) // CR # 4562 ? Field replaced
                {
                    accList.addAll(objDS.Specification_Release_List_Long__c.toLowerCase().split(';')); // CR # 4562 ? Field replaced  
                }   
                else
                
                {
                    accList.add(objDS.Specification_Release_List_Long__c.toLowerCase()); // CR # 4562 ? Field replaced
                }
                String designSpecId = objDS.id;
                if(designSpecId != null && designSpecId != ' ' && objDS.Release_Status__c=='Release to White list' && trigger.oldmap!=null && trigger.oldmap.get(designSpecId).Specification_Release_List_Long__c != trigger.newmap.get(designSpecId).Specification_Release_List_Long__c)
                    mapOfDsSFDCIdToAccLists.put(objDS.id,objDS.Specification_Release_List_Long__c);
            }
/*-----------------------added by cognizant for Case 4562 starts------------------------------------------------------------*/            
            else if(objDS.Specification_Release_List_Long__c==null){
            
            objDS.Specification_Release_List_updated__c=null;
            }
/*-----------------------added by cognizant for Case 4562 ends--------------------------------------------------------------*/            
          /*  if(accList!=null && accList.size()>0){
                setAllAccIds.addAll(accList);
                mapDSIdToAccLists.put(objDS.OpenText_ID__c,accList);
            }
            system.debug('accList$$'+accList);
            system.debug('mapDSIdToAccLists$$'+mapDSIdToAccLists);
            system.debug('setAllAccIds$$'+setAllAccIds);*/
        }
        
      /*  if(setAllAccIds!=null && setAllAccIds.size()>0){
           for(Account objAcc:[Select Id, Name, Short_Name__c from Account where Short_Name__c IN:setAllAccIds])
           { 
           system.debug('objAcc$$'+objAcc);                
           mapAccSNToAccNames.put(objAcc.Short_Name__c,objAcc.Name);  
           system.debug('mapAccSNToAccNames6666'+mapAccSNToAccNames);  
           }   
        }  
      system.debug('mapDSIdToAccLists###$$'+mapDSIdToAccLists);
      system.debug('mapAccSNToAccNames###$$'+mapAccSNToAccNames);*/
     
    
  /*  for(Design_Spec__c objDS: trigger.new){
                String str = '';
                
                if(mapDSIdToAccLists.get(objDS.OpenText_ID__c)!=null)
                {                  
                    for(String accShortName: mapDSIdToAccLists.get(objDS.OpenText_ID__c)){
                        if(mapAccSNToAccNames!=null && mapAccSNToAccNames.containsKey(accShortName)){
                            if(str==''){
                                str = mapAccSNToAccNames.get(accShortName);
                            }
                            else
                            {
                                str = str + ';' + mapAccSNToAccNames.get(accShortName); 
                            }                           
                        }  
                        else
                        {
                         if(str=='')
                         {
                                str = accShortName;
                            }
                            else
                            {
                                str = str + ';' +accShortName; 
                            }  
                        }
                    }
                    system.debug('str $$'+str );
                    objDS.Specification_Release_List_updated__c= str;
                    //listSTFmodified.add(objDS);   
                  }
                  
            }*/
       if(mapOfDsSFDCIdToAccLists!=null && mapOfDsSFDCIdToAccLists.size()>0){
        List<Document_Provisioning__c> lstDp = [Select id,Acc_Short_Name__c,Design_Spec__c from Document_Provisioning__c where 
                                                (Status__c='Provisioned' OR Status__c='IPLAProvision' OR Status__c='IPLADeprovision') AND Design_Spec__c IN:mapOfDsSFDCIdToAccLists.keyset() AND Sub_PDK__c=null ];
        if(lstDp!=null && lstDp.size()>0){
            for(Document_Provisioning__c dp :lstDp){
                if(dp!=null && dp.Acc_Short_Name__c!=null  && mapOfDsSFDCIdToAccLists.get(dp.Design_Spec__c)!=null && !mapOfDsSFDCIdToAccLists.get(dp.Design_Spec__c).contains(dp.Acc_Short_Name__c))
                    lstDeprovisionedDp.add(dp);
            }
            if(lstDeprovisionedDp!=null && lstDeprovisionedDp.size()>0){
                for(Document_Provisioning__c dp :lstDeprovisionedDp){
                    DP.Status__c = 'De-Provisioning In Progress';
                    dp.is_De_Prov_From_UI__c = false;
                }
            update  lstDeprovisionedDp;
            }                                                           
            }
       }     
       //update lstofSpecsInsertUpdate;  
    }