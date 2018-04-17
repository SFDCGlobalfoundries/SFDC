/*
Type Name: clsUpdateAccDPProvisioningHandler Apex Class
Author: Prajnith Karra - GF
Created Date: 2-June-2017
Reason: code seperated to a separate class

*/

public class clsUpdateAccDPProvisioningHandler{        
/*Modified By Cognizant for CR # 15680 ends*/
    public static void handleDocProvisioningUpdate(list<account> newtrigger, list<account> oldtrigger){
        set<String> accidsNDAexpire=new set<String>(); //Modifiied By Cognizant for CR # 11872
        set<String> accidsNDAactivated=new set<String>();
        set<String> accidsTechexpire=new set<String>();
        set<String> accidsTechactivated=new set<String>();
        set<id> accidsTechGranted=new set<id>();
        set<String> accidsTechRemoved=new set<String>();
        set<String> accidsTechGrantedNew=new set<String>();
        map<id,document_provisioning__c> mapDocPro=new map<id,document_provisioning__c>();
        map<id,set<string>> mapAccTechExpire=new map<id,set<string>>();
        map<id,set<string>> mapAccTechActivated=new map<id,set<string>>();
        map<id,set<string>> mapAccTechRemoved=new map<id,set<string>>();
        map<id,set<string>> mapAccTechGranted=new map<id,set<string>>();
        map<ID,Account> mapAccASIC = new map<ID,Account>();         
        set<String> accidsASICActivated=new set<String>();
        set<String> accidsASICDeactivated=new set<String>(); 
        
        
        
         Map<Id,Set<Id>> wlPdkAccMap= new Map<Id,Set<Id>>(); //2nd nov
        System.Debug('handleDocProvisioningUpdate' +'List size'+newtrigger.size());
    // Process Valid Tech Geos via NDA
    for(integer i=0; i<newtrigger.size();i++){
        System.Debug('handleDocProvisioningUpdate for ');
        if(newtrigger[i].Has_Valid_NDA__c==false && oldtrigger[i].Has_Valid_NDA__c==true)
            accidsNDAexpire.add(String.valueOf(newtrigger[i].id));  //Modified By Cognizant for CR # 11872            
        if(newtrigger[i].Has_Valid_NDA__c==true && oldtrigger[i].Has_Valid_NDA__c==false)
            accidsNDAactivated.add(newtrigger[i].id);
              
        // ASIC    
                
        // !String.isEmpty(newtrigger[i].Authorized_for_ASIC_business__c)    
        boolean isASICBusinessChanged = newtrigger[i].Authorized_for_ASIC_business__c != oldtrigger[i].Authorized_for_ASIC_business__c;        
        
        if(isASICBusinessChanged ){
                            
                mapAccASIC.put(newtrigger[i].ID,newtrigger[i]); 
                  
                if(isASICBusinessChanged && newtrigger[i].Authorized_for_ASIC_business__c == 'Yes'){
                    accidsASICActivated.add(newtrigger[i].ID);
                }
                if(isASICBusinessChanged && newtrigger[i].Authorized_for_ASIC_business__c == 'No'){
                    accidsASICDeactivated.add(newtrigger[i].ID);
                }
                        
        }                                       
    system.debug('**mapAccASIC***'+mapAccASIC );

    system.debug('**accidsASICActivated***'+accidsASICActivated );
    system.debug('**accidsASICDeactivated***'+accidsASICDeactivated );
                            
            System.Debug('new val ---'+newtrigger[i].Valid_Tech_Geos__c);
            System.Debug('old val ---'+oldtrigger[i].Valid_Tech_Geos__c);
    
          System.Debug('Cond chck val---'+(newtrigger[i].Valid_Tech_Geos__c!=oldtrigger[i].Valid_Tech_Geos__c ));
        if(newtrigger[i].Valid_Tech_Geos__c!=oldtrigger[i].Valid_Tech_Geos__c){
            System.Debug('Inside outer if ---');
          if(newtrigger[i].Valid_Tech_Geos__c!=null && oldtrigger[i].Valid_Tech_Geos__c!=null){
            System.Debug('Inside first if ---');
            for(string s :newtrigger[i].Valid_Tech_Geos__c.split(';')){
                System.Debug('Inside new trigger for ---');
    
                if(s.length()>5 && oldtrigger[i].Valid_Tech_Geos__c!=null && !oldtrigger[i].Valid_Tech_Geos__c.contains(s.substring(0,6))){
                    System.Debug('Inside new trigger for if ---');
    
                    if(mapAccTechActivated!=null && mapAccTechActivated.containskey(newtrigger[i].id)){
                        System.Debug('Inside new trigger pop if ---');
                        set<string> temp=new set<string>();
                        temp=mapAccTechActivated.get(newtrigger[i].id);
                        temp.add(s.substring(0,6));
                        mapAccTechActivated.put(newtrigger[i].id,temp);
                        accidsTechactivated.add(newtrigger[i].id);
                    }
                    else{
                        System.Debug('Inside new trigger pop else---');
    
                        set<string> temp=new set<string>();
                        temp.add(s.substring(0,6));
                        mapAccTechActivated.put(newtrigger[i].id,temp);
                        accidsTechactivated.add(newtrigger[i].id);
                    }    
                }
            }
            for(string s :oldtrigger[i].Valid_Tech_Geos__c.split(';')){
                System.Debug('Inside new trigger for ---');
                if(s.length()>5 && newtrigger[i].Valid_Tech_Geos__c!=null && !newtrigger[i].Valid_Tech_Geos__c.contains(s.substring(0,6))){
                    if(mapAccTechExpire!=null && mapAccTechExpire.containskey(newtrigger[i].id)){
                       
                        set<string> temp=new set<string>();
                        temp=mapAccTechExpire.get(newtrigger[i].id);
                        temp.add(s.substring(0,6));
                        mapAccTechExpire.put(newtrigger[i].id,temp);
                        accidsTechexpire.add(newtrigger[i].id);
                    }
                    else{
                        set<string> temp=new set<string>();
                        temp.add(s.substring(0,6));
                        mapAccTechExpire.put(newtrigger[i].id,temp);
                        accidsTechexpire.add(newtrigger[i].id);
                    }    
                }
            }
          }
          else if(newtrigger[i].Valid_Tech_Geos__c!=null){
              System.Debug('Inside else if ---');
              set<string> temp=new set<string>();
              for(string s:newtrigger[i].Valid_Tech_Geos__c.split(';')){
                      if(s.length()>5)
                          temp.add(s.substring(0,6));
              } 
              mapAccTechActivated.put(newtrigger[i].id,temp);
              accidsTechactivated.add(newtrigger[i].id);   
          }
          else if(oldtrigger[i].Valid_Tech_Geos__c!=null){
              set<string> temp=new set<string>();
              for(string s:oldtrigger[i].Valid_Tech_Geos__c.split(';')){
                      if(s.length()>5)
                      temp.add(s.substring(0,6));
              } 
              mapAccTechExpire.put(oldtrigger[i].id,temp);
              accidsTechexpire.add(oldtrigger[i].id);   
          }
        } 
        
        // Process Manually granted tech geos at account
        if(newtrigger[i].Tech_Geo_Granted__c!=oldtrigger[i].Tech_Geo_Granted__c){
          if(newtrigger[i].Tech_Geo_Granted__c!=null && oldtrigger[i].Tech_Geo_Granted__c!=null){
            for(string s :newtrigger[i].Tech_Geo_Granted__c.split(';')){
                if(s.length()>5 && !oldtrigger[i].Tech_Geo_Granted__c.contains(s.substring(0,6))){
                    if(mapAccTechGranted!=null && mapAccTechGranted.containskey(newtrigger[i].id)){
                        set<string> temp=new set<string>();
                        temp=mapAccTechGranted.get(newtrigger[i].id);
                        temp.add(s.substring(0,6));
                        mapAccTechGranted.put(newtrigger[i].id,temp);
                        accidsTechGranted.add(newtrigger[i].id);
                    }
                    else{
                        set<string> temp=new set<string>();
                        temp.add(s.substring(0,6));
                        mapAccTechGranted.put(newtrigger[i].id,temp);
                        accidsTechGranted.add(newtrigger[i].id);
                    }    
                }
            }
            for(string s :oldtrigger[i].Tech_Geo_Granted__c.split(';')){
                if(s.length()>5 && !newtrigger[i].Tech_Geo_Granted__c.contains(s.substring(0,6))){
                    if(mapAccTechRemoved!=null && mapAccTechRemoved.containskey(newtrigger[i].id)){
                        set<string> temp=new set<string>();
                        temp=mapAccTechRemoved.get(newtrigger[i].id);
                        temp.add(s.substring(0,6));
                        mapAccTechRemoved.put(newtrigger[i].id,temp);
                        accidsTechRemoved.add(newtrigger[i].id);
                    }
                    else{
                        set<string> temp=new set<string>();
                        temp.add(s.substring(0,6));
                        mapAccTechRemoved.put(newtrigger[i].id,temp);
                        accidsTechRemoved.add(newtrigger[i].id);
                    }    
                }
            }
          }
          else if(newtrigger[i].Tech_Geo_Granted__c!=null){
              set<string> temp=new set<string>();
              for(string s:newtrigger[i].Tech_Geo_Granted__c.split(';')){
                  if(s.length()>5)
                  temp.add(s.substring(0,6));
              } 
              mapAccTechGranted.put(newtrigger[i].id,temp); 
              accidsTechGranted.add(newtrigger[i].id);  
          }
          else if(oldtrigger[i].Tech_Geo_Granted__c!=null){
              set<string> temp=new set<string>();
              for(string s:oldtrigger[i].Tech_Geo_Granted__c.split(';')){
                  if(s.length()>5)
                  temp.add(s.substring(0,6));
              } 
              mapAccTechRemoved.put(oldtrigger[i].id,temp);
              accidsTechRemoved.add(oldtrigger[i].id);   
          }
        } 
    }
/*-----------------------------account reprovsioning------------------------------------------------------------*/
  // List<Sub_PDK__c> lstPDKIds=new List<Sub_PDK__c>();
   Set<Id> setofPDKIds=new Set<Id>();
   
   List<Account> acclist1=new List<Account>();
   if(!accidsNDAactivated.isempty() || !accidsTechactivated.isempty() || !accidsTechGranted.isempty() || !mapAccASIC.isEmpty())
   {
   
   system.debug(' entr if$$$');
   List<document_provisioning__c > listOfDpRecordsnew=new List<document_provisioning__c >();
    for(document_provisioning__c dp: [select final_user_access__c,NDA_Coverage__c,status__c,Design_Spec__c,Design_Package__c,Sub_PDK__r.Id,Sub_PDK__r.Release_Status__c,
                                                 account__c,AccountID__c,Sub_PDK__c,isDeProUpdate__c,Design_Spec__r.technology_geometry__c,
                                                 Design_Package__r.Tech_Geometry__c
                                            from document_provisioning__c 
                                            where (account__c IN : accidsNDAactivated OR account__c IN : accidsTechactivated 
                                            OR account__c IN : accidsTechGranted OR account__c IN: mapAccASIC.keyset())
                                            and Sub_PDK__c!=''
                                        ]){
                                        //lstPDKIds.add(dp.PDK__c);
                                       
                                        setofPDKIds.add(dp.Sub_PDK__r.Id);
                                        listOfDpRecordsnew.add(dp);
                                        
                                        }  
   
   List<White_List__c> lstwl=new List<White_List__c>();
            for(White_List__c wl : [Select Id,Sub_PDK__c,Account__c 
                                    From White_List__c 
                                    where Sub_PDK__c IN : setofPDKIds]){
                 lstwl.add(wl);                                            
                
                }
  
  
   //prepare Map of spec as key and list of white list accounts associated with that spec 
   
        for(White_List__c wl :lstwl)
             {
              for(Document_Provisioning__c dp: listOfDpRecordsnew )
              {
               if(dp.sub_PDK__c==wl.sub_PDK__c)
               {
                  system.debug('!wlPdkAccMap.containsKey(wl.Sub_PDK__c )'+!wlPdkAccMap.containsKey(wl.Sub_PDK__c ));
                    if (!wlPdkAccMap.containsKey(wl.Sub_PDK__c )){
                            wlPdkAccMap.put(wl.Sub_PDK__c, new Set<Id>());
                            system.debug('entrif###'+wlPdkAccMap);
                     } 
                      
                      wlPdkAccMap.get(wl.Sub_PDK__c).add(wl.Account__c);
                      
                      
                }
                     
                    
               }
              
              }
              
        
                                                                                  
  if(accidsNDAactivated!=null || accidsTechactivated!=null || accidsTechGranted!=null || !accidsASICActivated.isEmpty())
  {
  
  acclist1=[Select Id , Name from account where (Id IN:accidsNDAactivated OR Id IN:accidsTechactivated OR Id IN:accidsTechGranted OR ID IN: accidsASICActivated)];
  
  
  }
   
   system.debug(' acclist$$$'+acclist1);
    system.debug(' setofPDKIds$$$'+setofPDKIds);
    
   FV_PDKProvisioningHandler.updateDeProvisionedDpforNDAactivate(acclist1,setofPDKIds);
  
 /*-----------------------------NDA activated for Design spec for RWL specs---------------------------------------------------------------*/
   
/*------------------------NDA activated for Design spec for RWL specs-----------------------------------------------------*/
   }
/*-----------------------------account reprovsioning------------------------------------------------------------*/
/*
ASIC Logic
*/
    if(!mapAccASIC.isempty()){
            
          if(!accidsASICDeactivated.isEmpty()){  
              // for Design Specs           
              for(document_provisioning__c dp: [select final_user_access__c,NDA_Coverage__c,status__c,Design_Spec__c,Design_Package__c,
                                                     account__c,AccountID__c,Sub_PDK__c,isDeProUpdate__c,Design_Spec__r.technology_geometry__c,
                                                     Design_Package__r.Tech_Geometry__c,Sub_PDK__r.Release_Status__c                                               
                                                from document_provisioning__c 
                                                where status__c NOT IN ('De-Provisioned')
                                                AND (Unique_Id__c IN :accidsASICDeactivated OR account__c IN : accidsASICDeactivated OR AccountID__c IN : accidsASICDeactivated)
                                                AND Design_Spec__c != null AND Design_Spec__r.Specification_ASIC_Flag__c =: TRUE and Design_Spec__r.RecordType.Name!='PDK Specs'])
                {                                                                                      
                    if(dp<>NULL && dp.Sub_PDK__c==NULL && dp.Design_Spec__c!=NULL){   
                        system.debug('enter Sub_PDK__c==NULL###');                                 
                        dp.final_user_access__c=false;                                     
                        dp.Status__c='De-Provisioning In Progress';//Spec account level changes
                        dp.isDeProUpdate__c = true;                        
                        mapDocPro.put(dp.id,dp);
                    }                                                                  
                }
          }// for design Specs
          
          
          if(!accidsASICActivated.isEmpty()){
                List<Document_Provisioning__c> lstDocProv= new List<Document_Provisioning__c>();
                List<String> accList=new List<String>();
                Map<Id,List<String>> MapOfDsandAccList=new Map<Id,List<String>>();
                        // for design specs
                        for(document_provisioning__c objDP:[select DP_Is_Parent_ASIC__c,DP_ASIC_Business__c,final_user_access__c,status__c,NDA_Coverage__c,Sub_PDK__r.Release_Status__c,Design_Spec__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c,
                                                 Tech_Geo_Granted_to_Account__c,Design_spec__r.Specification_Release_List_Long__c,account__c,Design_Spec__c,Design_Package__c,Design_Package__r.Tech_Geometry__c,
                                                 AccountID__c,Sub_PDK__c,Sub_PDK__r.Tech_Geometry__c,isProvUpdate__c,is_De_Prov_From_UI__c,Design_Spec__r.technology_geometry__c
                                            from document_provisioning__c 
                                            where status__c IN ('Provisioned','IPLAProvision','De-Provisioned','Provisioning In Progress','De-Provisioning In Progress') 
                                            AND final_user_access__c=false 
                                            AND (Unique_Id__c in :accidsASICActivated OR account__c IN:accidsASICActivated OR AccountID__c IN : accidsASICActivated) 
                                            AND Design_Spec__c!= null AND Design_Spec__r.Specification_ASIC_Flag__c =: TRUE AND Design_Spec__r.RecordType.Name!='PDK Specs']){ 
                                                
                                            lstDocProv.add(objDP);
                                            accList = new List<String>();
                                            if(!String.isEmpty(objDP.Design_spec__r.Specification_Release_List_Long__c))
                                            {
                                                if(objDP.Design_spec__r.Specification_Release_List_Long__c.contains(';')) {
                                                  accList.addAll(objDP.Design_spec__r.Specification_Release_List_Long__c.toLowerCase().split(';')); 
                                                }   
                                                else{
                                                 accList.add(objDP.Design_spec__r.Specification_Release_List_Long__c.toLowerCase());
                                                }
                                                 MapOfDsandAccList.put(objDP.Design_Spec__c,accList);
                                            }
                
                                            
                                        }
                                        for(document_provisioning__c dp:[select DP_Is_Parent_ASIC__c,DP_ASIC_Business__c,final_user_access__c,status__c,NDA_Coverage__c,Sub_PDK__r.Release_Status__c,Design_Spec__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c,
                                                 Tech_Geo_Granted_to_Account__c,Design_spec__r.Specification_Release_List_Long__c,account__c,Design_Spec__c,Design_Package__c,Design_Package__r.Tech_Geometry__c,
                                                 AccountID__c,Sub_PDK__c,AccountID__r.Short_Name__c,Sub_PDK__r.Tech_Geometry__c,isProvUpdate__c,is_De_Prov_From_UI__c,Design_Spec__r.technology_geometry__c
                                            from document_provisioning__c 
                                            where status__c IN ('Provisioned','IPLAProvision','De-Provisioned','Provisioning In Progress','De-Provisioning In Progress') 
                                            AND final_user_access__c=false 
                                            AND (Unique_Id__c in :accidsASICActivated OR account__c IN: accidsASICActivated OR AccountID__c IN : accidsASICActivated ) 
                                            AND Design_Spec__c!= null AND Design_Spec__r.Specification_ASIC_Flag__c =: TRUE AND Design_Spec__r.RecordType.Name!='PDK Specs'])
                                            {                              
                                                
                                                boolean accfound=false;
                                                if(MapOfDsandAccList!=null && MapOfDsandAccList.get(dp.Design_Spec__c)!=null)
                                                {
                                                   for(String acc :MapOfDsandAccList.get(dp.Design_Spec__c))
                                                        {
                                                         if(acc==dp.AccountID__r.Short_Name__c){
                                                            accfound = true;
                                                        }
                                                    
                                                        } 
                                                 }
                                              if(dp<>NULL && dp.Sub_PDK__c==NULL && dp.Design_Spec__c!=NULL && dp.DP_Is_Parent_ASIC__c ) {   
                                                if(!dp.is_De_Prov_From_UI__c && dp.Design_Spec__r.Release_Status__c!='Internal Use Only' && dp.Design_spec__r.Lifecycle_Phase__c!='OBSOLETE' && !dp.Design_spec__r.Release_Status__c.contains('Release to White list') ){
                                                    dp.Status__c='Provisioning In Progress';
                                                    dp.final_user_access__c=true;
                                                    dp.isProvUpdate__c = true;
                                                }
                                                else if(!dp.is_De_Prov_From_UI__c && accfound ==true && dp.Design_spec__r.Release_Status__c.contains('Release to White list') && dp.DP_Is_Parent_ASIC__c){
                                                    dp.Status__c='Provisioning In Progress';
                                                    dp.final_user_access__c=true;
                                                    dp.isProvUpdate__c = true;                                                    
                                                }
                                                mapDocPro.put(dp.id,dp);
                                            
                                           }
           
                                    } // end for loop
                                        
                                        
        
          } // end accidsASICActivated
        
         if(!accidsASICDeactivated.isEmpty()){
            // for PDK Bundle
            list<ID> accIDs = new list<ID>();
            set<ID> subPDKiDs = new set<ID>();

             for(document_provisioning__c dp: [select final_user_access__c,NDA_Coverage__c,status__c,Design_Spec__c,Design_Package__c,
                                                     account__c,AccountID__c,Sub_PDK__c,isDeProUpdate__c,Design_Spec__r.technology_geometry__c,
                                                     Design_Package__r.Tech_Geometry__c,Sub_PDK__r.Release_Status__c                                               
                                                from document_provisioning__c 
                                                where status__c NOT IN ('De-Provisioned')
                                                AND (Unique_Id__c IN :accidsASICDeactivated OR account__c IN : accidsASICDeactivated OR AccountID__c IN : accidsASICDeactivated)
                                                and Sub_PDK__c != NULL AND Sub_PDK__r.PDK_Bundle_ASIC__c =: TRUE ])
                 {                                                                                     
                    if(dp<>NULL && dp.Sub_PDK__c != NULL){
                        if(dp.accountID__C != null)
                           accIDs.add(dp.AccountID__c);   
                       subPDKiDs.add(dp.Sub_PDK__c); 
                    }                                                                  
                }
                
              FV_DocumentProvisioningUtil.deprovisionPDKBulk(subPDKiDs,accIDs);  
          }  
            
          
        
      } // end Map ASIC
      
        
    
/*
ASIC
*/
    
    if(!accidsNDAexpire.isempty()){
       /* for(document_provisioning__c dp: [select final_user_access__c,NDA_Coverage__c,status__c,
                                                 account__c,AccountID__c,Sub_PDK__c,isDeProUpdate__c
                                                
                                            from document_provisioning__c 
                                            where (Unique_Id__c IN :accidsNDAexpire OR account__c IN : accidsNDAexpire OR AccountID__c IN : accidsNDAexpire)
                                            and final_user_access__c=true
                                            and Design_Spec__r.RecordType.Name!='PDK Specs'
                                        ]){//Modified By Cognizant for CR # 11872*///sunita 19th march
         
          for(document_provisioning__c dp: [select final_user_access__c,NDA_Coverage__c,status__c,Design_Spec__c,Design_Package__c,
                                                 account__c,AccountID__c,Sub_PDK__c,isDeProUpdate__c,Design_Spec__r.technology_geometry__c,
                                                 Design_Package__r.Tech_Geometry__c,Sub_PDK__r.Release_Status__c
                                                
                                            from document_provisioning__c 
                                            where (Unique_Id__c IN :accidsNDAexpire OR account__c IN : accidsNDAexpire OR AccountID__c IN : accidsNDAexpire)
                                            and Design_Spec__r.RecordType.Name!='PDK Specs'
                                        ]){//sunita 19th march
/*-----sunita 19 mmatch------------------------------------------------------------*/                                            
            if(dp<>NULL && dp.Sub_PDK__c==NULL && dp.Design_Spec__c!=NULL && dp.Design_Spec__r.technology_geometry__c!=null && dp.Design_Spec__r.technology_geometry__c!='Not Applicable' && dp.Design_Spec__r.technology_geometry__c.length()>5 && mapAccTechExpire.get(dp.account__c)!=null && 
                        mapAccTechExpire.get(dp.account__c).contains(dp.Design_Spec__r.technology_geometry__c.substring(0,6))){   
            system.debug('enter Sub_PDK__c==NULL###');                                 
                dp.final_user_access__c=false;
                dp.NDA_Coverage__c=false;
                
                dp.Status__c='De-Provisioning In Progress';//Spec account level changes
                mapDocPro.put(dp.id,dp);
            } 
            else if(dp<>NULL && dp.Sub_PDK__c==NULL && dp.Design_Spec__c!=NULL && (dp.Design_Spec__r.technology_geometry__c==null || dp.Design_Spec__r.technology_geometry__c=='Not Applicable')){   
            system.debug('enter Sub_PDK__c==NULL');                                 
                dp.final_user_access__c=false;
                dp.NDA_Coverage__c=false;
                dp.Tech_Geo_Granted_to_Account__c=false;
                dp.Status__c='De-Provisioning In Progress';//Spec account level changes
                
                mapDocPro.put(dp.id,dp);
            
            
            }
            
           /* else if(dp<>NULL && dp.Design_Package__c!=NULL && dp.Design_Package__r.Tech_Geometry__c!=null && dp.Design_Package__r.Tech_Geometry__c.length()>5 && mapAccTechExpire.get(dp.account__c)!=null && 
                        mapAccTechExpire.get(dp.account__c).contains(dp.Design_Package__r.Tech_Geometry__c.substring(0,6))) {
               system.debug('enter else Sub_PDK__c==NULL');
                dp.final_user_access__c=false;
                dp.NDA_Coverage__c=false;
                dp.Status__c='De-Provisioned';
                
                mapDocPro.put(dp.id,dp);
            }*/
            
/*-----sunita 19 mmatch------------------------------------------------------------*/            
            else if(dp<>NULL && dp.Sub_PDK__c!=NULL) {
               system.debug('enter else Sub_PDK__c==NULL');
                dp.final_user_access__c=false;
                dp.NDA_Coverage__c=false;
                dp.Status__c='De-Provisioning In Progress';
                dp.isDeProUpdate__c=false;
                dp.PdkSpecs__c = 'NONE'; //added for case 48668
                mapDocPro.put(dp.id,dp);
            }
        }
    }
    
    if(!accidsNDAactivated.isempty()){
        system.debug('1st loop');
       /* for(document_provisioning__c dp:[select final_user_access__c,status__c,NDA_Coverage__c,
                                                Tech_Geo_Granted_to_Account__c,account__c,
                                                AccountID__c,Sub_PDK__c,isProvUpdate__c,is_De_Prov_From_UI__c 
                                            from document_provisioning__c 
                                            where status__c IN ('Provisioned','IPLAProvision','De-Provisioned','Provisioning In Progress','De-Provisioning In Progress') 
                                            AND final_user_access__c=false 
                                            AND (Unique_Id__c in :accidsNDAactivated OR account__c IN:accidsNDAactivated OR AccountID__c IN : accidsNDAactivated) 
                                            AND ((Design_Spec__r.technology_geometry__c=null OR Design_Spec__r.technology_geometry__c='') 
                                                OR (Sub_PDK__r.tech_geometry__c=null OR Sub_PDK__r.tech_geometry__c='') 
                                                OR (Design_package__r.tech_geometry__c=null OR Design_package__r.tech_geometry__c=''))
                                            AND Design_Spec__r.RecordType.Name!='PDK Specs'
                                            AND is_De_Prov_From_UI__c=false//Added By Navneet   
                                        ]){*/
/*---------------------rwl case for NDA activation in specs start-------------------------------*/    
        List<Document_Provisioning__c> lstDocProv= new List<Document_Provisioning__c>();
        List<String> accList=new List<String>();
        Map<Id,List<String>> MapOfDsandAccList=new Map<Id,List<String>>();
        
        for(document_provisioning__c dp:[select final_user_access__c,status__c,NDA_Coverage__c,Sub_PDK__r.Release_Status__c,Design_Spec__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c,
                                                 Tech_Geo_Granted_to_Account__c,Design_spec__r.Specification_Release_List_Long__c,account__c,Design_Spec__c,Design_Package__c,Design_Package__r.Tech_Geometry__c,
                                                 AccountID__c,Sub_PDK__c,Sub_PDK__r.Tech_Geometry__c,isProvUpdate__c,is_De_Prov_From_UI__c,Design_Spec__r.technology_geometry__c
                                            from document_provisioning__c 
                                            where status__c IN ('Provisioned','IPLAProvision','De-Provisioned','Provisioning In Progress','De-Provisioning In Progress') 
                                            AND final_user_access__c=false 
                                            AND (Unique_Id__c in :accidsNDAactivated OR account__c IN:accidsNDAactivated OR AccountID__c IN : accidsNDAactivated) 
                                            AND Design_Spec__c!=''
                                            //AND is_De_Prov_From_UI__c=false//Added By Navneet 
                                        ])
                                        {   
                                        lstDocProv.add(dp);
                                        
                                        } 
                                        
        if(lstDocProv!=null && lstDocProv.size()>0)
        {                                                                  
        for(Document_Provisioning__c objDP: lstDocProv)
            {
              accList = new List<String>();
              if( objDP.Design_spec__r.Specification_Release_List_Long__c!=null)
              {
                 if(objDP.Design_spec__r.Specification_Release_List_Long__c.contains(';')) // CR # 4562 ? Field replaced
                {
                    accList.addAll(objDP.Design_spec__r.Specification_Release_List_Long__c.toLowerCase().split(';')); // CR # 4562 ? Field replaced  
                }   
                else
                
                {
                    accList.add(objDP.Design_spec__r.Specification_Release_List_Long__c.toLowerCase()); // CR # 4562 ? Field replaced
                }
                MapOfDsandAccList.put(objDP.Design_Spec__c,accList);
                }
             }   
            }
/*---------------------rwl case for NDA activation in specs end-------------------------------*/  
                                            
         for(document_provisioning__c dp:[select final_user_access__c,status__c,NDA_Coverage__c,Sub_PDK__r.Release_Status__c,Design_Spec__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c,
                                                 Tech_Geo_Granted_to_Account__c,Design_spec__r.Specification_Release_List_Long__c,account__c,Design_Spec__c,Design_Package__c,Design_Package__r.Tech_Geometry__c,
                                                 AccountID__c,Sub_PDK__c,AccountID__r.Short_Name__c,Sub_PDK__r.Tech_Geometry__c,isProvUpdate__c,is_De_Prov_From_UI__c,Design_Spec__r.technology_geometry__c
                                            from document_provisioning__c 
                                            where status__c IN ('Provisioned','IPLAProvision','De-Provisioned','Provisioning In Progress','De-Provisioning In Progress') 
                                            AND final_user_access__c=false 
                                            AND (Unique_Id__c in :accidsNDAactivated OR account__c IN:accidsNDAactivated OR AccountID__c IN : accidsNDAactivated) 
                                            AND Design_Spec__r.RecordType.Name!='PDK Specs'
                                            //AND is_De_Prov_From_UI__c=false//Added By Navneet 
                                        ]){                              
             
/*--------------------rwl case start----------------------------------------*/             
            boolean accfound=false;
            if(MapOfDsandAccList!=null && MapOfDsandAccList.get(dp.Design_Spec__c)!=null)
            {
            for(String acc :MapOfDsandAccList.get(dp.Design_Spec__c))
                {
                 if(acc==dp.AccountID__r.Short_Name__c)
                 {
                  accfound = true;
                 }
                
                 } 
             }
/*--------------------rwl case end----------------------------------------*/                                                  
           if(dp<>NULL && dp.Sub_PDK__c==NULL && dp.Design_Spec__c!=NULL && dp.Design_Spec__r.technology_geometry__c!=null && dp.Design_Spec__r.technology_geometry__c!='Not Applicable' && dp.Design_Spec__r.technology_geometry__c.length()>5 && mapAccTechActivated.get(dp.account__c)!=null && 
                        mapAccTechActivated.get(dp.account__c).contains(dp.Design_Spec__r.technology_geometry__c.substring(0,6))){   
            
                system.debug('enter @@@Sub_PDK__c==NULL');
                dp.NDA_Coverage__c=true;
                //dp.Tech_Geo_Granted_to_Account__c=true;//sunita 19march
                //dp.final_user_access__c=true;
                if(!dp.is_De_Prov_From_UI__c && dp.Tech_Geo_Granted_to_Account__c && dp.Design_Spec__r.Release_Status__c!='Internal Use Only' && dp.Design_spec__r.Lifecycle_Phase__c!='OBSOLETE' && !dp.Design_spec__r.Release_Status__c.contains('Release to White list') ){//added on 31st by sunita for PDK internal use issue
                    dp.Status__c='Provisioning In Progress';
                    dp.final_user_access__c=true;
                }
                else if(!dp.is_De_Prov_From_UI__c && dp.Tech_Geo_Granted_to_Account__c && accfound ==true && dp.Design_spec__r.Release_Status__c.contains('Release to White list') ){//added on 31st by sunita for PDK internal use issue
                
                    dp.Status__c='Provisioning In Progress';//sunita
                    dp.final_user_access__c=true;
                }
                mapDocPro.put(dp.id,dp);
            
           } 
          else if(dp<>NULL && dp.Sub_PDK__c==NULL && dp.Design_Spec__c!=NULL && (dp.Design_Spec__r.technology_geometry__c==null || dp.Design_Spec__r.technology_geometry__c=='Not Applicable')){   
             
                system.debug('enter @@@Sub_PDK__c==NULL');
                dp.NDA_Coverage__c=true;
                dp.Tech_Geo_Granted_to_Account__c=true;//sunita 19march
                //dp.final_user_access__c=true;
                if(!dp.is_De_Prov_From_UI__c && dp.Tech_Geo_Granted_to_Account__c && dp.Design_Spec__r.Release_Status__c!=null && dp.Design_Spec__r.Release_Status__c!='Internal Use Only' && dp.Design_spec__r.Lifecycle_Phase__c!='OBSOLETE' && !dp.Design_spec__r.Release_Status__c.contains('Release to White list') ){//added on 31st by sunita for PDK internal use issue){
                    dp.Status__c='Provisioning In Progress';//sunita
                    dp.final_user_access__c=true;
                }
                else if(!dp.is_De_Prov_From_UI__c && dp.Tech_Geo_Granted_to_Account__c &&  accfound ==true && dp.Design_spec__r.Release_Status__c.contains('Release to White list')){//added on 31st by sunita for PDK internal use issue){
                    dp.Status__c='Provisioning In Progress';//sunita
                    dp.final_user_access__c=true;
                }
                mapDocPro.put(dp.id,dp);
            
           } 
          /* else if(dp<>NULL && dp.Design_Package__c!=NULL && dp.Design_Package__r.Tech_Geometry__c!=null && dp.Design_Package__r.Tech_Geometry__c.length()>5 && mapAccTechActivated.get(dp.account__c)!=null && 
                        mapAccTechActivated.get(dp.account__c).contains(dp.Design_Package__r.Tech_Geometry__c.substring(0,6)))  
              {
                system.debug('enter else@@@Sub_PDK__c==NULL');
                dp.NDA_Coverage__c=true;
                //dp.Tech_Geo_Granted_to_Account__c=true;
                //dp.final_user_access__c=true;
                 if(!dp.is_De_Prov_From_UI__c && dp.Tech_Geo_Granted_to_Account__c && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only' ){//added on 31st by sunita for PDK internal use issue){
                    dp.status__c='Provisioned';
                    dp.final_user_access__c=true; 
                 }
                
                mapDocPro.put(dp.id,dp);
           }*/
           else if(dp<>NULL && dp.Sub_PDK__c!=NULL && dp.Sub_PDK__r.Tech_Geometry__c!=null && 
                    dp.Sub_PDK__r.Tech_Geometry__c.length()>5 && mapAccTechActivated.get(dp.account__c)!=null && 
                    mapAccTechActivated.get(dp.account__c).contains(dp.Sub_PDK__r.Tech_Geometry__c.substring(0,6))){
                        
                system.debug('enter else@@@Sub_PDK__c==NULL');
                dp.NDA_Coverage__c=true;
                //dp.Tech_Geo_Granted_to_Account__c=true;
                //dp.final_user_access__c=true;
/*---------------------------------case 48673 NDA WL check for PDK start--------------------------------------*/
         if(!dp.is_De_Prov_From_UI__c && dp.Tech_Geo_Granted_to_Account__c && dp.Sub_PDK__r.Release_Status__c=='Release to White list' ){//added on 31st by sunita for PDK internal use issue){
                   
                 if(wlPdkAccMap<>Null && wlPdkAccMap.get(dp.Sub_PDK__c)<>NULL && wlPdkAccMap.get(dp.Sub_PDK__c).contains(dp.account__c))
                {
                 dp.status__c='Provisioning In Progress';//commented on 2nd NOV
                    dp.final_user_access__c=true;
                }
             }
/*----------------------------------case 48673 NDA WL check for PDK end----------------------*/                
               else  if(!dp.is_De_Prov_From_UI__c && dp.Tech_Geo_Granted_to_Account__c && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only'){//added on 31st by sunita for PDK internal use issue){
                    dp.status__c='Provisioning In Progress';//commented on 2nd NOV
                    dp.final_user_access__c=true; //commented on 2nd NOV
                 }
                dp.isProvUpdate__c=false;
                mapDocPro.put(dp.id,dp);
           }
        }
    }

    //Process all tech geometries expiring at account level.
    set<string> setTechExpiredAll=new set<string>();
    if(mapAccTechExpire!=null && !mapAccTechExpire.keyset().isEmpty()){
        for(string s:mapAccTechExpire.keyset()){
            setTechExpiredAll.addAll(mapAccTechExpire.get(s));
        }
    }
    system.debug('Krishanu ---- NDA ---- Test='+accidsTechexpire) ; 
    if(setTechExpiredAll!=null && !setTechExpiredAll.isEmpty()){
        system.debug('2nd loop');
        List<document_provisioning__c> docProvList= new List<document_provisioning__c>() ;
        docProvList = [SELECT id,account__c,status__c,final_user_access__c,Design_Spec__c,
                                Design_Spec__r.Id,Design_Spec__r.technology_geometry__c,Sub_PDK__r.Release_Status__c,
                                Sub_PDK__c,Sub_PDK__r.Id,Sub_PDK__r.tech_geometry__c,Design_package__c,
                                Design_package__r.Id,Design_package__r.tech_geometry__c,AccountID__c,isProvUpdate__c,isDeProUpdate__c 
                        FROM document_provisioning__c 
                        WHERE (status__c='Provisioned' OR status__c='IPLAProvision' OR status__c='IPLADeprovision' OR status__c='De-Provisioned' OR status__c='Provisioning In Progress' OR status__c='De-Provisioning In Progress') 
                        AND NDA_Coverage__c=true 
                        AND (Unique_Id__c IN : accidsTechexpire OR account__c IN : accidsTechexpire OR AccountID__c IN : accidsTechexpire)
                        AND Design_Spec__r.RecordType.Name!='PDK Specs'//Added By Navneet
                    ];//Krishanu
                        
        if(docProvList<>NULL && !docProvList.isEmpty()){
            for(document_provisioning__c dp:docProvList){ //Krishanu
                if(mapDocPro.containskey(dp.id)){
                    if(dp.Design_Spec__c!=null && dp.Design_Spec__r.technology_geometry__c!=null &&
                        dp.Design_Spec__r.technology_geometry__c.length()>5 && mapAccTechExpire.get(dp.account__c)!=null && 
                        mapAccTechExpire.get(dp.account__c).contains(dp.Design_Spec__r.technology_geometry__c.substring(0,6)))
                        {
                            
                       system.debug('enter @@@%%%Sub_PDK__c==NULL');
                        mapDocPro.get(dp.id).NDA_Coverage__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false; 
                        mapDocPro.get(dp.id).status__c='De-Provisioning In Progress';//sunita
                        
                    } 
                    
                 /*  if (dp.Design_package__c!=null && dp.Design_package__r.tech_geometry__c!=null && dp.Design_package__r.tech_geometry__c.length()>5  && 
                        mapAccTechExpire.get(dp.account__c)!=null && mapAccTechExpire.get(dp.account__c).contains(dp.Design_package__r.tech_geometry__c.substring(0,6)))
                        {
                        mapDocPro.get(dp.id).NDA_Coverage__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false; 
                        mapDocPro.get(dp.id).status__c='De-Provisioned';//sunita
                        
                        }*/
                            
                    // Seperated PDK code
                    if(dp.Sub_PDK__c!=null && dp.Sub_PDK__r.tech_geometry__c!=null && dp.Sub_PDK__r.tech_geometry__c.length()>5  && 
                        mapAccTechExpire.get(dp.account__c)!=null && 
                        mapAccTechExpire.get(dp.account__c).contains(dp.Sub_PDK__r.tech_geometry__c.substring(0,6))){
                        
                        system.debug('enter @@@%%%Sub_PDK!NULL');
                        mapDocPro.get(dp.id).NDA_Coverage__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false;
                        mapDocPro.get(dp.id).status__c='De-Provisioning In Progress';
                        mapDocPro.get(dp.id).isDeProUpdate__c=false;
                        mapDocPro.get(dp.id).PdkSpecs__c = 'NONE'; //added for case 48668
                    } 
                }
                else{
                    if(dp.Design_Spec__c!=null && dp.Design_Spec__r.technology_geometry__c!=null && 
                        dp.Design_Spec__r.technology_geometry__c.length()>5 && mapAccTechExpire.get(dp.account__c)!=null && 
                        mapAccTechExpire.get(dp.account__c).contains(dp.Design_Spec__r.technology_geometry__c.substring(0,6)))
                     {   
                       system.debug('enter @@@%%%NDA false');
                        mapDocPro.put(dp.id,dp);
                        mapDocPro.get(dp.id).NDA_Coverage__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false; 
                        mapDocPro.get(dp.id).status__c='De-Provisioning In Progress';//sunita
                        
                    } 
                    
                  /*  if(dp.Design_package__c!=null && dp.Design_package__r.tech_geometry__c!=null && dp.Design_package__r.tech_geometry__c.length()>5  && mapAccTechExpire.get(dp.account__c)!=null && mapAccTechExpire.get(dp.account__c).contains(dp.Design_package__r.tech_geometry__c.substring(0,6)))
                       
                    {
                        mapDocPro.put(dp.id,dp);
                        mapDocPro.get(dp.id).NDA_Coverage__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false; 
                        mapDocPro.get(dp.id).status__c='De-Provisioned';//sunita
                    }  */
                    if (dp.Sub_PDK__c!=null && dp.Sub_PDK__r.tech_geometry__c!=null && dp.Sub_PDK__r.tech_geometry__c.length()>5  && 
                        mapAccTechExpire.get(dp.account__c)!=null && mapAccTechExpire.get(dp.account__c).contains(dp.Sub_PDK__r.tech_geometry__c.substring(0,6))){
                        
                        system.debug('enter else@@@%%%NDA false');
                        mapDocPro.put(dp.id,dp);
                        mapDocPro.get(dp.id).NDA_Coverage__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false;
                        mapDocPro.get(dp.id).status__c='De-Provisioning In Progress';
                        mapDocPro.get(dp.id).isDeProUpdate__c=false;
                        mapDocPro.get(dp.id).PdkSpecs__c = 'NONE'; //added for case 48668
                    }     
                }
            }
        }  
    }

    //Process all tech geometries activated at account level.
    set<string> setTechActivatedAll=new set<string>();
    if(mapAccTechActivated!=null && !mapAccTechActivated.keyset().isEmpty()){
        for(string s :mapAccTechActivated.keyset()){
            setTechActivatedAll.addAll(mapAccTechActivated.get(s));
        }
    }
    system.debug('Krishanu ---- accidsTechactivated---'+accidsTechactivated) ; 
    
    if(setTechActivatedAll!=null && !setTechActivatedAll.isEmpty()){
       
        system.debug('3rd loop');
 /*---------------------rwl case for NDA activation in specs start-------------------------------*/    
        List<Document_Provisioning__c> lstDocProv1= new List<Document_Provisioning__c>();
        List<String> accList2=new List<String>();
        Map<Id,List<String>> MapOfDsandAccList1=new Map<Id,List<String>>();
        
         for(document_provisioning__c dp:[select id,account__c,status__c,Design_spec__r.Specification_Release_List_Long__c,final_user_access__c,Design_Spec__c,Sub_PDK__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c,
                                                Design_Spec__r.technology_geometry__c,Sub_PDK__c,AccountID__c,Unique_Id__c,Design_Spec__r.Release_Status__c,
                                                Sub_PDK__r.tech_geometry__c,Design_package__c,Design_package__r.tech_geometry__c,
                                                isProvUpdate__c,isDeProUpdate__c,is_De_Prov_From_UI__c,Tech_Geo_Granted_to_Account__c
                                            from document_provisioning__c where (status__c='Provisioned' OR status__c='IPLAProvision' OR status__c='De-Provisioned' OR status__c='Provisioning In Progress' OR status__c='De-Provisioning In Progress') 
                                            and NDA_Coverage__c=false 
                                            and (Unique_Id__c in :accidsTechactivated OR AccountID__c IN : accidsTechactivated OR account__c IN : accidsTechactivated)
                                            AND Design_Spec__c!=''
                                            //AND is_De_Prov_From_UI__c=false
                                        ]){
                                        lstDocProv1.add(dp);
                                        }
                                        
        if(lstDocProv1!=null && lstDocProv1.size()>0)
        {                                                                  
        for(Document_Provisioning__c objDP: lstDocProv1)
            {
              accList2 = new List<String>();
              if( objDP.Design_spec__r.Specification_Release_List_Long__c!=null)
              {
                 if(objDP.Design_spec__r.Specification_Release_List_Long__c.contains(';')) // CR # 4562 ? Field replaced
                {
                    accList2.addAll(objDP.Design_spec__r.Specification_Release_List_Long__c.toLowerCase().split(';')); // CR # 4562 ? Field replaced  
                }   
                else
                
                {
                    accList2.add(objDP.Design_spec__r.Specification_Release_List_Long__c.toLowerCase()); // CR # 4562 ? Field replaced
                }
                MapOfDsandAccList1.put(objDP.Design_Spec__c,accList2);
                }
             }   
            }
/*---------------------rwl case for NDA activation in specs end-------------------------------*/  
       
        
        for(document_provisioning__c dp:[select id,account__c,status__c,Design_spec__r.Specification_Release_List_Long__c,final_user_access__c,Design_Spec__c,Sub_PDK__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c,
                                                Design_Spec__r.technology_geometry__c,Sub_PDK__c,AccountID__c,Unique_Id__c,Design_Spec__r.Release_Status__c,
                                                Sub_PDK__r.tech_geometry__c,AccountID__r.Short_Name__c,Design_package__c,Design_package__r.tech_geometry__c,
                                                isProvUpdate__c,isDeProUpdate__c,is_De_Prov_From_UI__c,Tech_Geo_Granted_to_Account__c
                                            from document_provisioning__c where (status__c='Provisioned' OR status__c='IPLAProvision' OR status__c='De-Provisioned' OR status__c='Provisioning In Progress' OR status__c='De-Provisioning In Progress') 
                                            and NDA_Coverage__c=false 
                                            and (Unique_Id__c in :accidsTechactivated OR AccountID__c IN : accidsTechactivated OR account__c IN : accidsTechactivated)
                                            AND Design_Spec__r.RecordType.Name!='PDK Specs'//Added By Navneet
                                            //AND is_De_Prov_From_UI__c=false
                                        ]){

            
            
            if(dp<>NULL){  
            
            
/*--------------------rwl case start----------------------------------------*/             
            boolean accfound=false;
            if(MapOfDsandAccList1!=null && MapOfDsandAccList1.get(dp.Design_Spec__c)!=null)
            {
            for(String acc :MapOfDsandAccList1.get(dp.Design_Spec__c))
                {
                 if(acc==dp.AccountID__r.Short_Name__c)
                 {
                  accfound = true;
                 }
                
                 } 
             }
/*--------------------rwl case end----------------------------------------*/                                     
                if(mapDocPro.containskey(dp.id)){
                    if(dp.Design_Spec__c!=null && dp.Design_Spec__r.technology_geometry__c!=null && 
                        dp.Design_Spec__r.technology_geometry__c.length()>5 && mapAccTechActivated.get(dp.account__c)!=null && 
                        mapAccTechActivated.get(dp.account__c).contains(dp.Design_Spec__r.technology_geometry__c.substring(0,6)))
                        {
                        system.debug('enter @@@%%%NDA true');
                        mapDocPro.get(dp.id).NDA_Coverage__c=true; 
                         if(!dp.is_De_Prov_From_UI__c && dp.Design_Spec__r.Release_Status__c!=null && dp.Design_Spec__r.Release_Status__c!='Internal Use Only' && dp.Design_spec__r.Lifecycle_Phase__c!='OBSOLETE' && !dp.Design_spec__r.Release_Status__c.contains('Release to White list')){ 
                         
                         system.debug('enter @@@%%%NDA true1');
                            mapDocPro.get(dp.id).status__c='Provisioning In Progress';//sunita
                         }
                         else if(!dp.is_De_Prov_From_UI__c && accfound == true && dp.Design_spec__r.Release_Status__c.contains('Release to White list')){ 
                         
                         system.debug('enter @@@%%%NDA true1');
                            mapDocPro.get(dp.id).status__c='Provisioning In Progress';//sunita
                         }
                    }
                  /*  if(dp.Design_package__c!=null && dp.Design_package__r.tech_geometry__c!=null && dp.Design_package__r.tech_geometry__c.length()>5 && mapAccTechActivated.get(dp.account__c)!=null && mapAccTechActivated.get(dp.account__c).contains(dp.Design_package__r.tech_geometry__c.substring(0,6)))
                        
                    {
                      system.debug('enter @@@%%%NDA true');
                        mapDocPro.get(dp.id).NDA_Coverage__c=true; 
                         if(!dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only'){ 
                         
                         system.debug('enter @@@%%%NDA true1');
                            mapDocPro.get(dp.id).status__c='Provisioned';//sunita
                         }
                    
                    }*/
                    if(dp.Sub_PDK__c!=null && dp.Sub_PDK__r.tech_geometry__c!=null && dp.Sub_PDK__r.tech_geometry__c.length()>5 && 
                        mapAccTechActivated.get(dp.account__c)!=null && mapAccTechActivated.get(dp.account__c).contains(dp.Sub_PDK__r.tech_geometry__c.substring(0,6))){
                        system.debug('enter else @@@%%%NDA true');
                        mapDocPro.get(dp.id).NDA_Coverage__c=true;
  /*---------------------------------case 48673 NDA WL check for PDK start---------------------------------------*/
         if(!dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c=='Release to White list' ){
                   
                 if(wlPdkAccMap<>Null && wlPdkAccMap.get(dp.Sub_PDK__c)<>NULL && wlPdkAccMap.get(dp.Sub_PDK__c).contains(dp.account__c))
                {
                 mapDocPro.get(dp.id).status__c='Provisioning In Progress';//commented on 2nd NOV
                }
             }
/*----------------------------------case 48673 NDA WL check for PDK end-------------------------*/  
                       else  if(!dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only'){
                            mapDocPro.get(dp.id).status__c='Provisioning In Progress';//commented on 2nd NOV
                         }  
                        mapDocPro.get(dp.id).isProvUpdate__c=false;
                    }  
                }
                else{
                    if(dp.Design_Spec__c!=null && dp.Design_Spec__r.technology_geometry__c!=null && dp.Design_Spec__r.technology_geometry__c.length()>5 && 
                        mapAccTechActivated.get(dp.account__c)!=null && mapAccTechActivated.get(dp.account__c).contains(dp.Design_Spec__r.technology_geometry__c.substring(0,6)))
                     {   
                        system.debug('enter $$@@@%%%NDA false');
                        system.debug('Tech_Geo_Granted_to_Account__c$$'+dp.Tech_Geo_Granted_to_Account__c);
                        mapDocPro.put(dp.id,dp);
                        mapDocPro.get(dp.id).NDA_Coverage__c=true;
                       
                        if(dp.Tech_Geo_Granted_to_Account__c==true && !dp.is_De_Prov_From_UI__c  && dp.Design_Spec__r.Release_Status__c!=null && dp.Design_Spec__r.Release_Status__c!='Internal Use Only' && dp.Design_spec__r.Lifecycle_Phase__c!='OBSOLETE' && !dp.Design_spec__r.Release_Status__c.contains('Release to White list')){//added on 31st by sunita for PDK internal use issue)
                             
                            system.debug('enter $$@@@%%%NDA false1');
                               mapDocPro.get(dp.id).status__c = 'Provisioning In Progress'; //sunita 19thmarch
                             } 
                         else if(dp.Tech_Geo_Granted_to_Account__c==true && !dp.is_De_Prov_From_UI__c  &&  accfound == true && dp.Design_spec__r.Release_Status__c.contains('Release to White list')){//added on 31st by sunita for PDK internal use issue)
                             
                            system.debug('enter $$@@@%%%NDA false1');
                               mapDocPro.get(dp.id).status__c = 'Provisioning In Progress'; //sunita 19thmarch
                             } 
                    }
                  /*  if(dp.Design_package__c!=null && dp.Design_package__r.tech_geometry__c!=null && dp.Design_package__r.tech_geometry__c.length()>5 && mapAccTechActivated.get(dp.account__c)!=null && mapAccTechActivated.get(dp.account__c).contains(dp.Design_package__r.tech_geometry__c.substring(0,6)))
                      {  
                        system.debug('enter $$@@@%%%NDA false');
                        system.debug('Tech_Geo_Granted_to_Account__c$$'+dp.Tech_Geo_Granted_to_Account__c);
                        mapDocPro.put(dp.id,dp);
                        mapDocPro.get(dp.id).NDA_Coverage__c=true;
                       
                        if(dp.Tech_Geo_Granted_to_Account__c==true && !dp.is_De_Prov_From_UI__c  && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only' ){//added on 31st by sunita for PDK internal use issue)
                             
                            system.debug('enter $$@@@%%%NDA false1');
                               mapDocPro.get(dp.id).status__c = 'Provisioned'; //sunita 19thmarch
                             } 
                             else
                             {
                             
                             }    
                    }*/
                    
                    if(dp.Sub_PDK__c!=null && dp.Sub_PDK__r.tech_geometry__c!=null && dp.Sub_PDK__r.tech_geometry__c.length()>5  && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only' &&
                        mapAccTechActivated.get(dp.account__c)!=null && mapAccTechActivated.get(dp.account__c).contains(dp.Sub_PDK__r.tech_geometry__c.substring(0,6))){
                       system.debug('enter else$$@@@%%%NDA falseKunalPP');
                        mapDocPro.put(dp.id,dp);
                        mapDocPro.get(dp.id).NDA_Coverage__c=true;
   /*---------------------------------case 48673 NDA WL check for PDK start---------------------------------------*/
         if(!dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c=='Release to White list' ){
                   
                 if(wlPdkAccMap<>Null && wlPdkAccMap.get(dp.Sub_PDK__c)<>NULL && wlPdkAccMap.get(dp.Sub_PDK__c).contains(dp.account__c))
                {
                 mapDocPro.get(dp.id).status__c='Provisioning In Progress';//commented on 2nd NOV
                }
             }
/*-----------------------------------case 48673 NDA WL check for PDK end----------------------------*/  
                        if(!dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only'){
                            mapDocPro.get(dp.id).status__c='Provisioning In Progress';//commented on 2nd NOV
                        }
                        mapDocPro.get(dp.id).isProvUpdate__c=false;         
                    
                    }        
                }
            }    
        }
    }
    //Process all tech geometries manually removed at account level.
    set<string> setTechRemovedAll=new set<string>();
    if(mapAccTechRemoved!=null && !mapAccTechRemoved.isEmpty()){
        for(string s :mapAccTechRemoved.keyset()){
            setTechRemovedAll.addAll(mapAccTechRemoved.get(s));
        }
    }

    if(setTechRemovedAll!=null && !setTechRemovedAll.isEmpty()){

        system.debug('accidsTechRemoved:'+ accidsTechRemoved);
        system.debug('4rth loop');    
        for(document_provisioning__c dp:[select id,account__c,status__c,final_user_access__c,Design_Spec__c,AccountID__c,Unique_Id__c,Sub_PDK__r.Release_Status__c,
                                                Design_Spec__r.technology_geometry__c,Sub_PDK__c,Sub_PDK__r.tech_geometry__c,isProvUpdate__c,isDeProUpdate__c, 
                                                Design_package__c,Design_package__r.tech_geometry__c from document_provisioning__c
                                            where (status__c='Provisioned' OR status__c='IPLAProvision' OR status__c='De-Provisioned' OR status__c='Provisioning In Progress' OR status__c='De-Provisioning In Progress' OR status__c='IPLADeprovision') 
                                            and Tech_Geo_Granted_to_Account__c=true 
                                            and (Unique_Id__c in :accidsTechRemoved OR account__c IN : accidsTechRemoved OR AccountID__c IN : accidsTechRemoved)
                                            AND Design_Spec__r.RecordType.Name!='PDK Specs'//Added By Navneet
                                        ]){
            
            if(dp<>NULL){
                if(mapDocPro.containskey(dp.id)){
                    if(dp.Design_Spec__c!=null && dp.Design_Spec__r.technology_geometry__c!=null && 
                        dp.Design_Spec__r.technology_geometry__c.length()>5 && mapAccTechRemoved.get(dp.account__c)!=null && 
                        mapAccTechRemoved.get(dp.account__c).contains(dp.Design_Spec__r.technology_geometry__c.substring(0,6)))
                    {      
                        mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false; 
                        mapDocPro.get(dp.id).status__c='De-Provisioning In Progress';//added by sunita
                        
                    }  
                   /* if(dp.Design_package__c!=null && dp.Design_package__r.tech_geometry__c!=null && dp.Design_package__r.tech_geometry__c.length()>5 && mapAccTechRemoved.get(dp.account__c)!=null && mapAccTechRemoved.get(dp.account__c).contains(dp.Design_package__r.tech_geometry__c.substring(0,6)))
                    {    
                        mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false; 
                        mapDocPro.get(dp.id).status__c='De-Provisioned';//added by sunita
                        
                    }  */
                    
                    if(dp.Sub_PDK__c!=null && dp.Sub_PDK__r.tech_geometry__c!=null && dp.Sub_PDK__r.tech_geometry__c.length()>5 && 
                        mapAccTechRemoved.get(dp.account__c)!=null && mapAccTechRemoved.get(dp.account__c).contains(dp.Sub_PDK__r.tech_geometry__c.substring(0,6))){
                        
                        mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false;
                        mapDocPro.get(dp.id).status__c='De-Provisioning In Progress';
                        mapDocPro.get(dp.id).isDeProUpdate__c=false;
                        mapDocPro.get(dp.id).PdkSpecs__c = 'NONE'; //added for case 48668
                    }
                }
                else{
                    if(dp.Design_Spec__c!=null && dp.Design_Spec__r.technology_geometry__c!=null && 
                        dp.Design_Spec__r.technology_geometry__c.length()>5 && mapAccTechRemoved.get(dp.account__c)!=null && 
                        mapAccTechRemoved.get(dp.account__c).contains(dp.Design_Spec__r.technology_geometry__c.substring(0,6)))
                        {
                        mapDocPro.put(dp.id,dp);
                        mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false; 
                        mapDocPro.get(dp.id).status__c='De-Provisioning In Progress';//added by sunita
                        
                        //mapDocPro.get(dp.id).status__c='De-Provisioning In Progress';
                        
                    }
                    
                   /* if(dp.Design_package__c!=null && dp.Design_package__r.tech_geometry__c!=null && dp.Design_package__r.tech_geometry__c.length()>5 && mapAccTechRemoved.get(dp.account__c)!=null && mapAccTechRemoved.get(dp.account__c).contains(dp.Design_package__r.tech_geometry__c.substring(0,6))) 
                    {    
                        mapDocPro.put(dp.id,dp);
                        mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false; 
                        mapDocPro.get(dp.id).status__c='De-Provisioned';//added by sunita
                        //mapDocPro.get(dp.id).status__c='De-Provisioning In Progress';
                        
                    }*/
                    
                    if(dp.Sub_PDK__c!=null && dp.Sub_PDK__r.tech_geometry__c!=null && dp.Sub_PDK__r.tech_geometry__c.length()>5 && 
                        mapAccTechRemoved.get(dp.account__c)!=null && mapAccTechRemoved.get(dp.account__c).contains(dp.Sub_PDK__r.tech_geometry__c.substring(0,6))){
                        
                        mapDocPro.put(dp.id,dp);
                        mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=false;
                        mapDocPro.get(dp.id).final_user_access__c=false;
                        mapDocPro.get(dp.id).status__c='De-Provisioning In Progress';
                        mapDocPro.get(dp.id).isDeProUpdate__c=false;
                        mapDocPro.get(dp.id).PdkSpecs__c = 'NONE'; //added for case 48668
                    }        
                }
            }
        }
    }
    //Process all tech geometries manually granted at account level.
    set<string> setTechGrantedAll=new set<string>();
    if(mapAccTechGranted!=null && !mapAccTechGranted.isEmpty()){
        for(string s :mapAccTechGranted.keyset()){
            setTechGrantedAll.addAll(mapAccTechGranted.get(s));
        }
    }
    system.debug('krishanu--setTechGrantedAll:' + setTechGrantedAll);
    system.debug('krishanu--mapAccTechGranted:' + mapAccTechGranted);
    
    for(Id accId : mapAccTechGranted.keyset())
        accidsTechGrantedNew.add(String.valueof(accId ));
    
        if(setTechGrantedAll!=null && !setTechGrantedAll.isEmpty())
        {
/*---------------------rwl case for NDA activation in specs start-------------------------------*/    
        List<Document_Provisioning__c> lstDocProv2= new List<Document_Provisioning__c>();
        List<String> accList3=new List<String>();
        Map<Id,List<String>> MapOfDsandAccList2=new Map<Id,List<String>>();
        
        for(document_provisioning__c dp:[select id,account__c,status__c,final_user_access__c,Design_spec__r.Specification_Release_List_Long__c,Design_Spec__c,AccountID__c,Sub_PDK__r.Release_Status__c,
                                                    Design_Spec__r.technology_geometry__c,Design_Spec__r.Release_Status__c,Sub_PDK__c,Sub_PDK__r.tech_geometry__c,Design_package__c,
                                                    Design_package__r.tech_geometry__c,isProvUpdate__c,is_De_Prov_From_UI__c,NDA_Coverage__c,Design_spec__r.Lifecycle_Phase__c
                                                from document_provisioning__c 
                                                where (status__c='Provisioned' OR status__c='IPLAProvision' OR status__c='De-Provisioned' OR status__c='Provisioning In Progress' OR status__c='De-Provisioning In Progress')  
                                                and (Unique_Id__c in :accidsTechGrantedNew OR AccountID__c IN :accidsTechGrantedNew OR account__c IN : accidsTechGrantedNew) 
                                                and Tech_Geo_Granted_to_Account__c=false
                                                AND Design_Spec__c!=''//Added By Navneet
                                                //AND is_De_Prov_From_UI__c=false
                                            ]){  
                                        lstDocProv2.add(dp);
                                        
                                        } 
                                        
        if(lstDocProv2!=null && lstDocProv2.size()>0)
        {                                                                  
        for(Document_Provisioning__c objDP: lstDocProv2)
            {
              accList3 = new List<String>();
              if( objDP.Design_spec__r.Specification_Release_List_Long__c!=null)
              {
                 if(objDP.Design_spec__r.Specification_Release_List_Long__c.contains(';')) // CR # 4562 ? Field replaced
                {
                    accList3.addAll(objDP.Design_spec__r.Specification_Release_List_Long__c.toLowerCase().split(';')); // CR # 4562 ? Field replaced  
                }   
                else
                
                {
                    accList3.add(objDP.Design_spec__r.Specification_Release_List_Long__c.toLowerCase()); // CR # 4562 ? Field replaced
                }
                MapOfDsandAccList2.put(objDP.Design_Spec__c,accList3);
                }
             }   
            }
/*---------------------rwl case for NDA activation in specs end-------------------------------*/          
        
        system.debug('line 297');system.debug('mapAccTechGranted:' + mapAccTechGranted);
           system.debug('5th loop');
            for(document_provisioning__c dp:[select id,account__c,status__c,Design_spec__r.Specification_Release_List_Long__c,final_user_access__c,Design_Spec__c,AccountID__c,Sub_PDK__r.Release_Status__c,
                                                    Design_Spec__r.technology_geometry__c,AccountID__r.Short_Name__c,Design_Spec__r.Release_Status__c,Sub_PDK__c,Sub_PDK__r.tech_geometry__c,Design_package__c,
                                                    Design_package__r.tech_geometry__c,isProvUpdate__c,is_De_Prov_From_UI__c,NDA_Coverage__c,Design_spec__r.Lifecycle_Phase__c
                                                from document_provisioning__c 
                                                where (status__c='Provisioned' OR status__c='IPLAProvision' OR status__c='De-Provisioned' OR status__c='Provisioning In Progress' OR status__c='De-Provisioning In Progress')  
                                                and (Unique_Id__c in :accidsTechGrantedNew OR AccountID__c IN :accidsTechGrantedNew OR account__c IN : accidsTechGrantedNew) 
                                                and Tech_Geo_Granted_to_Account__c=false
                                                AND Design_Spec__r.RecordType.Name!='PDK Specs'//Added By Navneet
                                                //AND is_De_Prov_From_UI__c=false
                                            ]){  // Added field 'Id' for indexing purpose for CR-00015680
                
                if(dp<>NULL){
                
   /*--------------------rwl case start----------------------------------------*/             
            boolean accfound=false;
            if(MapOfDsandAccList2!=null && MapOfDsandAccList2.get(dp.Design_Spec__c)!=null)
            {
            for(String acc :MapOfDsandAccList2.get(dp.Design_Spec__c))
                {
                 if(acc==dp.AccountID__r.Short_Name__c)
                 {
                  accfound = true;
                 }
                
                 } 
             }
/*--------------------rwl case end----------------------------------------*/        
                    if(mapDocPro.containskey(dp.id)){
                        if(dp.Design_Spec__c!=null && dp.Design_Spec__r.technology_geometry__c!=null &&
                            dp.Design_Spec__r.technology_geometry__c.length()>5 && mapAccTechGranted.get(dp.account__c)!=null && 
                            mapAccTechGranted.get(dp.account__c).contains(dp.Design_Spec__r.technology_geometry__c.substring(0,6)))
                       {     
                            mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=true;
                            system.debug('enter Tech geo$$@@@%%%NDA true');
                             if(!dp.is_De_Prov_From_UI__c && dp.Design_Spec__r.Release_Status__c!=null && dp.Design_Spec__r.Release_Status__c!='Internal Use Only' && dp.Design_spec__r.Lifecycle_Phase__c!='OBSOLETE' && !dp.Design_spec__r.Release_Status__c.contains('Release to White list')) { 
                             system.debug('enter Tech geo$$@@@%%%NDA true1');
                                mapDocPro.get(dp.id).status__c = 'Provisioning In Progress'; //sunita  
                            } 
                            
                            else if(!dp.is_De_Prov_From_UI__c && accfound == true && dp.Design_spec__r.Release_Status__c.contains('Release to White list')) { 
                             system.debug('enter Tech geo$$@@@%%%NDA true1');
                                mapDocPro.get(dp.id).status__c = 'Provisioning In Progress'; //sunita  
                            }  
                        }
                      /*  if(dp.Design_package__c!=null && dp.Design_package__r.tech_geometry__c!=null && dp.Design_package__r.tech_geometry__c.length()>5 && mapAccTechGranted.get(dp.account__c)!=null && mapAccTechGranted.get(dp.account__c).contains(dp.Design_package__r.tech_geometry__c.substring(0,6))) 
                        {
                            
                            mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=true;
                            system.debug('enter Tech geo$$@@@%%%NDA true');
                             if(!dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only') { 
                             system.debug('enter Tech geo$$@@@%%%NDA true1');
                                mapDocPro.get(dp.id).status__c = 'Provisioned'; //sunita  
                            }   
                        }*/
                        
                        if(dp.Sub_PDK__c!=null && dp.Sub_PDK__r.tech_geometry__c!=null && dp.Sub_PDK__r.tech_geometry__c.length()>5 && 
                            mapAccTechGranted.get(dp.account__c)!=null && mapAccTechGranted.get(dp.account__c).contains(dp.Sub_PDK__r.tech_geometry__c.substring(0,6))){
                            
                            mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=true;
 /*---------------------------------case 48673 NDA WL check for PDK start---------------------------------------*/
         if(!dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c=='Release to White list' ){
                   
                 if(wlPdkAccMap<>Null && wlPdkAccMap.get(dp.Sub_PDK__c)<>NULL && wlPdkAccMap.get(dp.Sub_PDK__c).contains(dp.account__c))
                {
                 mapDocPro.get(dp.id).status__c='Provisioning In Progress';//commented on 2nd NOV
                }
             }
/*-----------------------------------case 48673 NDA WL check for PDK end----------------------*/                             
                           else  if(!dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only'){
                                mapDocPro.get(dp.id).status__c = 'Provisioning In Progress';
                             }  
                            mapDocPro.get(dp.id).isProvUpdate__c=false;
                        }  
                    }
                    else{
                        if(dp.Design_Spec__c!=null && dp.Design_Spec__r.technology_geometry__c!=null && 
                            dp.Design_Spec__r.technology_geometry__c.length()>5 && mapAccTechGranted.get(dp.account__c)!=null && 
                            mapAccTechGranted.get(dp.account__c).contains(dp.Design_Spec__r.technology_geometry__c.substring(0,6)))
                           
                           {
                            mapDocPro.put(dp.id,dp);
                            mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=true;
                            system.debug('enter Tech geo@@@%%%NDA true');
                           
                             if(dp.NDA_Coverage__c==true && !dp.is_De_Prov_From_UI__c && dp.Design_Spec__r.Release_Status__c!='Internal Use Only' && dp.Design_spec__r.Lifecycle_Phase__c!='OBSOLETE' && !dp.Design_spec__r.Release_Status__c.contains('Release to White list')){
                             
                             system.debug('enter Tech geo@@@%%%NDA true1');
                               mapDocPro.get(dp.id).status__c = 'Provisioning In Progress'; //sunita 19thmarch
                             } 
                             if(dp.NDA_Coverage__c==true && !dp.is_De_Prov_From_UI__c && accfound == true && dp.Design_spec__r.Release_Status__c.contains('Release to White list')){
                             
                             system.debug('enter Tech geo@@@%%%NDA true1');
                               mapDocPro.get(dp.id).status__c = 'Provisioning In Progress'; //sunita 19thmarch
                             }            
                        }
                        
                        /* if(dp.Design_package__c!=null && dp.Design_package__r.tech_geometry__c!=null && dp.Design_package__r.tech_geometry__c.length()>5 && mapAccTechGranted.get(dp.account__c)!=null && mapAccTechGranted.get(dp.account__c).contains(dp.Design_package__r.tech_geometry__c.substring(0,6))) 
                         {
                            
                            mapDocPro.put(dp.id,dp);
                            mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=true;
                            system.debug('enter Tech geo@@@%%%NDA true');
                           
                             if(dp.NDA_Coverage__c==true && !dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only'){
                             
                             system.debug('enter Tech geo@@@%%%NDA true1');
                               mapDocPro.get(dp.id).status__c = 'Provisioned'; //sunita 19thmarch
                             } 
                             else
                             {
                             
                             }               
                        }*/
                        if (dp.Sub_PDK__c!=null && dp.Sub_PDK__r.tech_geometry__c!=null && dp.Sub_PDK__r.tech_geometry__c.length()>5 && 
                            mapAccTechGranted.get(dp.account__c)!=null && mapAccTechGranted.get(dp.account__c).contains(dp.Sub_PDK__r.tech_geometry__c.substring(0,6))){
                            
                            mapDocPro.put(dp.id,dp);
                           system.debug('enter Tech geo activated@@@%%%NDA true1');
                            mapDocPro.get(dp.id).Tech_Geo_Granted_to_Account__c=true;
 /*---------------------------------case 00048673 NDA WL check for PDK start--------------------------------------*/
         if(!dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c=='Release to White list' ){
                   
                 if(wlPdkAccMap<>Null && wlPdkAccMap.get(dp.Sub_PDK__c)<>NULL && wlPdkAccMap.get(dp.Sub_PDK__c).contains(dp.account__c))
                {
                 mapDocPro.get(dp.id).status__c='Provisioning In Progress';//commented on 2nd NOV
                }
             }
/*-----------------------------------case 00048673 NDA WL check for PDK end------------------------*/                             
                         else   if(!dp.is_De_Prov_From_UI__c && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only'){
                                mapDocPro.get(dp.id).status__c = 'Provisioning In Progress';
                            }   
                            mapDocPro.get(dp.id).isProvUpdate__c=false;
                        } 
                               
                    }
                }
            }
        }
        system.debug('mapDocPro****'+mapDocPro);
        //Update affected document provisioning records
        if(mapDocPro!=null && mapDocPro.values().size()>0){        
            //update mapDocPro.values(); // commented by prajnith on 5/15/2017
        // Added by prajnith            
             set<ID> accIds = new set<ID>();
             set<ID> pdkBundleIDs = new set<ID>();
             map<string,ID> keymap = new map<String,ID>();
             set<ID> DPids = new set<ID>();
       
       // Iterate all DP records based on account and PDK combination
            for(Document_Provisioning__c dp: mapDocPro.values()){            
               if(dp.Sub_PDK__c != null){   
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
                     if(mapDocPro.containskey(keymap.get(key))){ // if DP matches
                            DPids.add(keymap.get(key));                         
                     }
                 }
         }  
         // now remove un nessary DP records.
         for(Document_Provisioning__c dp: mapDocPro.values()){   
             if(DPids.contains(dp.ID)){
                 mapDocPro.remove(dp.ID);                     
             }
         }
        //update mapDocPro.values();
        //handle exceptions
            Database.SaveResult[] db_update_res = Database.update(mapDocPro.values(),FALSE) ;
            if(db_update_res != null){
                for (Database.SaveResult result : db_update_res) {
                if (!result.isSuccess()) {
                    Database.Error[] errs = result.getErrors();
                    for(Database.Error err : errs){                        
                        FV_ErrorLogHandler.setErrorLogs('PDK Account DP Prov','clsUpdateDocProvisioningHandler','handleDocProvisioningUpdate', err.getStatusCode()+' - '+ err.getMessage());                        
                        }
                    }
                }
            }
        }
    }                            
}