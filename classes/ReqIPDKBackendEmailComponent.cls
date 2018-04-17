/*
* @ Author :- Sandesh
* @ Company :- IBM
* @ Description :- Class help to send email while creating document Provisioning
* @ Date :- 03/02/2018
* @ History :- 
**/
global class ReqIPDKBackendEmailComponent {
    global String desSpId {get;set;}
    global String accShortName {get;set;}
    global String desSpName {get;set;}
    global String justification {get;set;}
    
    /**
        This method collect Document Provisioning which has created by loggeg in user at same time

        @method name: getLstDP
        @parameter:   None
        @return :     List<Document_Provisioning__c>, list of Document Provisioning. 
     **/
    private List<Document_Provisioning__c> getLstDP(){
      Map<Id,Document_Provisioning__c> mapDPs = new Map<Id,Document_Provisioning__c>();  
      String specificationId;
		for(Document_Provisioning__c dp : [Select Id,Name,AccountID__c, AccountID__r.Short_Name__c,Design_Spec__c,
                                                 Design_Spec__r.Name,BE_Region__c,BE_Justification__c
                                                 From Document_Provisioning__c
                                                 Where Design_Spec__c =:desSpId 
                                                 AND RecordType.DeveloperName ='IP_DK_Record_Type'
                                                 AND SystemModstamp > :Datetime.now().addMinutes(-1)
                                                 AND CreatedById =:UserInfo.getUserId()]){
        	mapDPs.put(dp.AccountID__c, dp); 
            specificationId = (specificationId !='') ?dp.Design_Spec__c : '';                                            
       }
        
       //get Account Id from AAP
       for(IPDK_License_Information__c aap :[Select Id,Name,Account__c,Specification__c 
                                                From IPDK_License_Information__c 
                                             	Where Account__c IN :mapDPs.keySet()
                                                And Specification__c =:specificationId]){
          mapDPs.remove(aap.Account__c);                                       
       } 
       return mapDPs.values(); 
    }  
    
    /**
        This Veriable collect Region & create String for All assosiate Account with Document Provisioning as a , seprator

        @Variable name: region
        @parameter:   None
        @return :     String, region field from DP 
     **/
    global String region{
        get{
            accShortName = '';
            String regionTemp ='';
            List<Document_Provisioning__c> lstDP = getLstDP();
            
            for(Document_Provisioning__c dp :lstDP){
               accShortName = ((dp.AccountID__c !=null || dp.AccountID__c !='')? accShortName + ',' + dp.AccountID__r.Short_Name__c:'');
            }
            
            if(accShortName !=''){
                accShortName = accShortName.removeStart(',');	
            }
            if(lstDP !=null && !lstDP.isEmpty()){
                regionTemp = lstDP[0].BE_Region__c;
                justification = lstDP[0].BE_Justification__c;
            }
            
            return regionTemp;
        }
        set;
    }
    
    }