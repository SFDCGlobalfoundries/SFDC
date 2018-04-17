/*
Type Name: FV_deassociateSpecFromSubPDK
Author: Cognizant 
Created Date: 12/11/2014
Reason: 
*/
public class FV_deassociateSpecFromSubPDK
{

 public static void deassociateSpecFromSubPDK(List<Sub_PDK_Spec__c>  lstSubPDKSpec){
        
        Map<String, String> mapSpecToSubPDK = new Map<String, String>();
        Map<String, List<Document_Provisioning__c>> mapSpecToDocProv = new Map<String,List<Document_Provisioning__c>>(); 
        Set<String> setSpecIds = new Set<String>();
        List<Document_Provisioning__c> lstDocProvUpdate = new List<Document_Provisioning__c>();
        
        

        System.Debug('List size---'+lstSubPDKSpec.size());
        System.Debug('List val ---'+lstSubPDKSpec);        
            
            if(lstSubPDKSpec!=null && lstSubPDKSpec.size()>0){
            for(Sub_PDK_Spec__c sps: lstSubPDKSpec){
                mapSpecToSubPDK.put(sps.Design_Spec__c,sps.Sub_PDK__c); 
                setSpecIds.add(sps.Design_Spec__c); 
            }

        System.Debug('Dspec set ---'+setSpecIds);        
        System.Debug('Spec sub pdk map ---'+mapSpecToSubPDK);
        
           
 
            if(setSpecIds!=null && setSpecIds.size()>0){
                for(Document_Provisioning__c objDP:[Select Id,name,Sub_PDK__c,Design_Package__c,Sub_PDK_Provisioned_for__c,Design_Spec__c FROM Document_Provisioning__c WHERE (Design_Spec__c IN:setSpecIds and Design_Package__c=null and  Sub_PDK__c=null and Unique_Id__c!=null and Design_Spec__c !=null)]){//modified by cognizant for Case 00036067
                    {
                        if(!mapSpecToDocProv.containsKey(objDP.Design_Spec__c))
                            mapSpecToDocProv.put(objDP.Design_Spec__c,new List<Document_Provisioning__c>{objDP});       
                        else
                            mapSpecToDocProv.get(objDP.Design_Spec__c).add(objDP);      
                    }
                }

         
        System.Debug('Spec doc prov map ---'+mapSpecToDocProv);
        
                
                if(mapSpecToDocProv!=null && mapSpecToDocProv.size()>0){
            System.Debug('Inside mthd if---');
                    for(String specId:mapSpecToDocProv.keySet()){ 
                        System.Debug('Inside for ---');
            
                        for(Document_Provisioning__c objDP : mapSpecToDocProv.get(specId)) 
            {
            String str = '';
            System.Debug('Doc prov rec ---'+objDP );
                        Set<String> nameSubPDKs = new Set<String>();
                        if(objDP.Sub_PDK_Provisioned_for__c!=null && objDP.Sub_PDK_Provisioned_for__c.contains(';')){
                            System.Debug('Inside Sub_PDK_Provisioned_for__c check ---');
                nameSubPDKs.addAll(objDP.Sub_PDK_Provisioned_for__c.split(';'));
                            objDP.Status__c = 'Provisioned';    
                        }
                        else{
                System.Debug('Inside else ---');
                            nameSubPDKs.add(objDP.Sub_PDK_Provisioned_for__c);
                            objDP.Status__c = 'De-Provisioned';
                        }

            System.Debug('Inside Sub_PDK_Provisioned_for  ---'+nameSubPDKs);
                        if(nameSubPDKs!=null && nameSubPDKs.size()>1){

            System.Debug('Inside nameSubPDKs check---');
                            for(String name:nameSubPDKs){
                                if(mapSpecToSubPDK.get(specId)!=name){
                                    if(str == ''){
                                        str = name;
                                    }
                                    else{
                                        str = str + ';' + name;
                                    }   
                                }   
                            }
                System.Debug('str val---'+str);
                            objDP.Sub_PDK_Provisioned_for__c = str; 
                        }
                        else{
                            System.Debug('Inside nameSubPDKs else---');                        
                            objDP.Sub_PDK_Provisioned_for__c = '';
                        }
                        lstDocProvUpdate.add(objDP);
            }
                    }
                 
       

           
                    if(lstDocProvUpdate!=null && lstDocProvUpdate.size()>0){
                    
                         try{
                             update lstDocProvUpdate;
                         }
                         catch(DmlException ex){
                             System.debug('***Exception faced in Provisioning Update Is** ' + ex);
                         }
                     }
                }
                
            }
        }   
    }
  }