/*
*@ Author       :- Navneet Rajput 
*@ Company      :- Cognizant technology
*@ Date         :- 30/10/2014
*@ Description  :- #CR : Batch will execute after every 1 hr and it will process all DP (document provisioning) records 
                        which will not be skipped by document provisioning trigger
                        Criteria :- If DP status is Provisioned and TechGeo Granted is false and Valid NDA false and Final User 
                        Access is false 
*@ History      :- 
*/


global class FV_PDKProvisioningRetriggerBatchCls implements Database.Batchable<sObject>{

    public String pdkId = ''; 
    
    public FV_PDKProvisioningRetriggerBatchCls(String pId){
        this.pdkId = pId;
    } 
     
    public FV_PDKProvisioningRetriggerBatchCls(){
    
     }      

    global Database.querylocator start(Database.BatchableContext BC){
       /* 
        if(pdkId!=null && pdkId!=''){        
            return Database.getQueryLocator([SELECT ID,
                                                    Status__c,
                                                    NDA_Coverage__c,
                                                    Final_User_Access__c,
                                                    Tech_Geo_Granted_to_Account__c,
                                                    Design_Spec__c,
                                                    Sub_PDK__c,
                                                    Design_Package__c,
                                                    Account__c,
                                                    Account_Short_Name__c,
                                                    Approval_Process_Comments__c,
                                                    Approval_Status__c
                                             FROM   Document_Provisioning__c
                                             WHERE  Status__c='Provisioned'
                                             AND    Sub_PDK__c =: pdkId                                                 
                                             AND    NDA_Coverage__c=false
                                             AND    Final_User_Access__c=false
                                             AND    Tech_Geo_Granted_to_Account__c=false]);
       }  else {
        */    
             return Database.getQueryLocator([SELECT ID,
                                                    Status__c,
                                                    NDA_Coverage__c,
                                                    Final_User_Access__c,
                                                    Tech_Geo_Granted_to_Account__c,
                                                    Design_Spec__c,
                                                    Sub_PDK__c,
                                                    Design_Package__c,
                                                    Account__c,
                                                    Account_Short_Name__c,
                                                    Approval_Process_Comments__c,
                                                    Approval_Status__c
                                             FROM   Document_Provisioning__c
                                             WHERE  Status__c='Provisioned'
                                             AND    NDA_Coverage__c=false
                                             AND    Final_User_Access__c=false
                                             AND    Tech_Geo_Granted_to_Account__c=false]);
       
         //}                                  
    }

    // Execute document provisioning request
    global void execute(Database.BatchableContext BC, List<sObject> listOfDPRecords){
        
        system.debug('Inside execute >>>>>>>');        
        set<id> accIds=new set<id>();
        set<id> specIds=new set<id>();
        set<id> pdkIds=new set<id>();
        set<id> packageIds=new set<id>();
        map<id,account> mapacc=new map<id,account>();
        map<id,design_spec__c> mapSpec=new map<id,design_spec__c>();
        map<id,sub_pdk__c> mapPDK=new map<id,sub_pdk__c>();
        map<id,package__c> mapPackage=new map<id,package__c>();
        List<Document_Provisioning__c> listOfDpToUpdate = new List<Document_Provisioning__c>();
            
        if (listOfDPRecords!= null && !listOfDPRecords.isEmpty()){
            for(Document_Provisioning__c dp : (List<Document_Provisioning__c>)listOfDPRecords){
                if(dp.account__c!=null)
                    accids.add(dp.account__c);
                if(dp.Design_Spec__c!=null)
                    specIds.add(dp.Design_Spec__c);    
                if(dp.Sub_PDK__c!=null)
                    pdkIds.add(dp.Sub_PDK__c);
                /*if(dp.Design_package__c!=null)
                    packageIds.add(dp.Design_package__c);*/
            }
            
            if(accids!=null && !accids.isEmpty()){
            for(account acc:[select id,Tech_Geo_Granted__c,Valid_Tech_Geos__c,Has_Valid_NDA__c from account where id in :accids]){
                mapacc.put(acc.id,acc);        
            }
            }
            if(!specIds.isEmpty()){
                for(design_spec__c ds:[select id,technology_geometry__c,specification_type__c from design_spec__c where id in :specIds]){
                    mapSpec.put(ds.id,ds);            
                }
            }
            if(!pdkIds.isEmpty()){
                for(sub_pdk__c pdk:[select id,tech_geometry__c from sub_pdk__c where id in :pdkIds]){
                    mappdk.put(pdk.id,pdk);            
                }
            }
           /* if(!packageIds.isEmpty()){
                for(package__c pkg:[select id,tech_geometry__c from package__c where id in :packageIds]){
                    mappackage.put(pkg.id,pkg);            
                }
            }*/
            
            for(Document_Provisioning__c dp : (List<Document_Provisioning__c>)listOfDPRecords){
            // Check for NDA coverage of Technology geometries                
                if(dp.Design_Spec__c!=null){ 
                    //Asolito - bypass NDA check if spec type is white papers
                    if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).specification_type__c == 'White Papers'){
                        dp.NDA_Coverage__c=true;    
                    } else {                  
                        if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).technology_geometry__c!=null ){
                            for(string s:mapSpec.get(dp.Design_Spec__c).technology_geometry__c.split(';')){
                                if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Valid_Tech_Geos__c!=null && (mapacc.get(dp.account__c).Valid_Tech_Geos__c.contains(s)|| mapacc.get(dp.account__c).Valid_Tech_Geos__c.contains(s.substring(0,6)))){
                                    dp.NDA_Coverage__c=true;    
                                }
                                
                            }
                        }
                        else if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).technology_geometry__c==null){
                            if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Has_Valid_NDA__c==true){
                                dp.NDA_Coverage__c=true;    
                            }  
                       } 
                   }                     
                }
                else if(dp.sub_pdk__c!=null){
                    if(mappdk!=null && mappdk.containskey(dp.sub_pdk__c) && mappdk.get(dp.sub_pdk__c).tech_geometry__c!=null ){
                        for(string s:mappdk.get(dp.sub_pdk__c).tech_geometry__c.split(';')){
                            if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Valid_Tech_Geos__c!=null && (mapacc.get(dp.account__c).Valid_Tech_Geos__c.contains(s) || mapacc.get(dp.account__c).Valid_Tech_Geos__c.contains(s.substring(0,6)))){
                                dp.NDA_Coverage__c=true;    
                            }                           
                        }
                    }
                    else if(mappdk!=null && mappdk.containskey(dp.sub_pdk__c) && mappdk.get(dp.sub_pdk__c).tech_geometry__c==null){
                        if(mapacc!=null && mapacc.containskey(dp.account__c)  && mapacc.get(dp.account__c).Has_Valid_NDA__c==true){
                            dp.NDA_Coverage__c=true;    
                        }  
                   }  
                    
                }
                // Check TechGeo Granted flag
                // Check if Technology geometries is manually granted at account level.
                if(dp.Design_Spec__c!=null){
                    //Asolito - bypass NDA check if spec type is white papers
                    if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).specification_type__c == 'White Papers'){
                        dp.Tech_Geo_Granted_to_Account__c=true;    
                    } else {
                        if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).technology_geometry__c!=null ){
                            for(string s:mapSpec.get(dp.Design_Spec__c).technology_geometry__c.split(';')){
                                if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Tech_Geo_Granted__c!=null && (mapacc.get(dp.account__c).Tech_Geo_Granted__c.contains(s) || mapacc.get(dp.account__c).Tech_Geo_Granted__c.contains(s.substring(0,6)))){
                                    dp.Tech_Geo_Granted_to_Account__c=true;    
                                }
                                
                            }
                        }
                        else if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).technology_geometry__c==null){
                            if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Has_Valid_NDA__c==true){
                                dp.Tech_Geo_Granted_to_Account__c=true;    
                            }  
                       } 
                   }                     
                }
                else if(dp.sub_pdk__c!=null){
                    if(mappdk!=null && mappdk.containskey(dp.sub_pdk__c) && mappdk.get(dp.sub_pdk__c).tech_geometry__c!=null ){
                        for(string s:mappdk.get(dp.sub_pdk__c).tech_geometry__c.split(';')){
                            if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Tech_Geo_Granted__c!=null && (mapacc.get(dp.account__c).Tech_Geo_Granted__c.contains(s) || mapacc.get(dp.account__c).Tech_Geo_Granted__c.contains(s.substring(0,6)))){
                                dp.Tech_Geo_Granted_to_Account__c=true;    
                            }                           
                        }
                    }
                    else if(mappdk!=null && mappdk.containskey(dp.sub_pdk__c) && mappdk.get(dp.sub_pdk__c).tech_geometry__c==null){
                        if(mapacc!=null && mapacc.containskey(dp.account__c)  && mapacc.get(dp.account__c).Has_Valid_NDA__c==true){
                            dp.Tech_Geo_Granted_to_Account__c=true;    
                        }  
                   }  
                    
                }
                system.debug('DP Record >>>>>>>>>'+dp);                
                // Add DP records to update
                if(dp.NDA_Coverage__c || dp.Tech_Geo_Granted_to_Account__c){                
                    listOfDpToUpdate.add(dp);
                }
                system.debug('listOfDpToUpdate>>>>>>>>>>>'+listOfDpToUpdate);                
            } // End of second for loop
            
            if(listOfDpToUpdate!=null && listOfDpToUpdate.size()>0){
                try{
                    update listOfDpToUpdate;
                    //DesignSpecTriggerHandler.addAccountProvisionedTo(listOfDpToUpdate);
                } catch (Exception e){
                    system.debug('Exception :: '+e.getMessage());
                }
            }
        }
    }
    // Send email notification as well as track failures of document provisioning   
    global void finish(Database.BatchableContext BC){
        
    }
        
}