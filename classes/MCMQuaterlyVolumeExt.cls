public class MCMQuaterlyVolumeExt {
    
    public PCM_MCM_Detail__c mcmDetailObj {get;set;}
    public Integer currentYear{get;set;}
    public Integer thisYear{get;set;}
    public Id deviceId;
  
    public  id mcmId;
   
    
      public Integer thisQuarter{get;set;}
    String params = '';
    PCM_Administration__c pcmAdminSetting = PCM_Administration__c.getInstance('CURRENT_SETTING'); 
    
    public MCMQuaterlyVolumeExt() 
    {
       deviceId = ApexPages.currentPage().getParameters().get('Id');

    
        mcmDetailObj = [Select Id, Actual_Tapeout_Date__c,Actual_Tapeout_Date_FAB_9_and_FAB_10__c,Device__r.Fab__c From PCM_MCM_Detail__c where Device__c =:deviceId] ;
        
        
        if(mcmDetailObj!=null){
        mcmId= mcmDetailObj.Id;
  
        }
        //new actual tapeout date field replacement 
   //Commented by Ravindra - Start
   /*
        if(mcmDetailObj.Device__r.Fab__c != 'FAB 9' && mcmDetailObj.Device__r.Fab__c != 'FAB 10') 
       {
           mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c = mcmDetailObj.Actual_Tapeout_Date__c;
        }
    */
        
       lstWrapperQuaterly = new list<WrapperQuaterly>();
        
        if(mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c != NULL) 
        {
          currentYear = mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c.year();
        }   
        
        thisYear = date.today().year();
        currentYearQuarter();
        fetchQuaterlyVolume();
        
    
        map<String,String> mpParameters = ApexPages.currentPage().getParameters();
        Integer count = 0;
        for(String key : mpParameters.keySet()) 
        {
          count++;
          if(key.containsIgnorecase('visualforce') || key.containsIgnorecase('frm')) 
          {
            continue;
          }
         if(count == mpParameters.size()) 
         {
           params += key+'='+ mpParameters.get(key);
         }
        else {
           params += key+'='+ mpParameters.get(key) + '&';
        }               
      }
  }
    
    public pagereference currentYearQuarter()
     {
            if(mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c == NULL) {
              return NULL;
            }
            integer month = mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c.month();
            if(month >= 1 && month <=3) {thisQuarter = 1;}
            if(month >= 4 && month <=6) {thisQuarter = 2;}
            if(month >= 7 && month <=9) {thisQuarter = 3;}
            if(month >= 10 && month <=12) {thisQuarter = 4;}
            return NULL;
    }
    
     public list<WrapperQuaterly> lstWrapperQuaterly{get;set;}
     Decimal lastRecordedYear;
     List<MCM_Quarterly_Volume__c> lstQuaterlyVol = new List<MCM_Quarterly_Volume__c>(); 
  
    public PageReference fetchQuaterlyVolume() {
            if(mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c == NULL) {
              return NULL;
            }
            lastRecordedYear = mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c.year() - 1;
            List<MCM_Quarterly_Volume__c> lstQuaterlyVol = [Select Id,Q1_Volume__c,Q2_Volume__c,Q3_Volume__c,Q4_Volume__c,
                                                                Year__c,PCM_MCM_Detail__c FROM MCM_Quarterly_Volume__c WHERE PCM_MCM_Detail__c  = :mcmDetailObj.Id AND Year__c >:lastRecordedYear ORDER BY Year__c ASC];
            
            for(MCM_Quarterly_Volume__c v : lstQuaterlyVol) {
              
              while(lastRecordedYear+1 < v.year__c) {
                lastRecordedYear++;
                lstWrapperQuaterly.add(new WrapperQuaterly(new MCM_Quarterly_Volume__c(year__c = lastRecordedYear ))); 
              }
              if(v.year__c == mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c.year()) {
                if(thisQuarter == 2) {v.Q1_Volume__c = NULL;}
                if(thisQuarter == 3) {v.Q2_Volume__c = NULL;v.Q1_Volume__c = NULL;}
                if(thisQuarter == 4) {v.Q3_Volume__c = NULL;v.Q2_Volume__c = NULL;v.Q1_Volume__c = NULL;}
              }
              
              lstWrapperQuaterly.add(new WrapperQuaterly(v));
              lastRecordedYear = v.year__c;
            }
            while(lstWrapperQuaterly.size() < 4) {
              lastRecordedYear += 1;
              lstWrapperQuaterly.add(new WrapperQuaterly(new MCM_Quarterly_Volume__c(year__c = lastRecordedYear )));            
            }
            return NULL;
          } 
    
    public class WrapperQuaterly {
        public MCM_Quarterly_Volume__c quaterlyVolume{get;set;}
        public boolean toDelete{get;set;}
        public WrapperQuaterly(MCM_Quarterly_Volume__c vol) {
          quaterlyVolume = vol;
          toDelete = false;
        }
  }
    
     
    // This method takes the user to MCM Detail page.
    public pagereference redirectToMCMDetail(){   
      PageReference pr;
      if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){          
        pr = new PageReference('/GlobalfoundryView/apex/MCMDetailPage?id='+deviceId);
      }else{
        pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/MCMDetailPage?id='+deviceId);
      }
      return pr;
    } 
    
      public pagereference addRow() {
    lastRecordedYear += 1;
    lstWrapperQuaterly.add(new WrapperQuaterly(new MCM_Quarterly_Volume__c(year__c = lastRecordedYear )));
    return NULL;
  }
  
  public pagereference deleteRows() {
    list<MCM_Quarterly_Volume__c> lstDeleteVol = new list<MCM_Quarterly_Volume__c>();
    list<WrapperQuaterly > tempLstWrapVol = new list<WrapperQuaterly >();
    list<MCM_Quarterly_Volume__c > tempLstVolDel = new list<MCM_Quarterly_Volume__c >();
    for(WrapperQuaterly vol : lstWrapperQuaterly) {
      if(vol.toDelete) {
        if(vol.quaterlyVolume.id != NULL) {
          tempLstVolDel.add(vol.quaterlyVolume);
        }
        continue;
      }
      tempLstWrapVol.add(vol);
    }
   lastRecordedYear = mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c.year() - 1;
    lstWrapperQuaterly = tempLstWrapVol;
    for(WrapperQuaterly vol : lstWrapperQuaterly) {
      lastRecordedYear += 1;
      vol.quaterlyVolume.year__c = lastRecordedYear;
    }
    if(!tempLstVolDel.isEmpty()) {
      delete tempLstVolDel;
         createSubstrateRecords();  
    }
    return NULL;
  }
    
    public pagereference SaveQuarterlyVolume(){
        
    try {
        list<MCM_Quarterly_Volume__c> lstSaveVol = new list<MCM_Quarterly_Volume__c>();
        if(lstWrapperQuaterly.isEmpty()) {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please add the volume for atleast current quarter')) ; return null;
        }
        list<Decimal> lstVolumes = new list<Decimal>();
              
        for(WrapperQuaterly vol : lstWrapperQuaterly) {
          if(vol.quaterlyVolume.Id == NULL) {
            vol.quaterlyVolume.PCM_MCM_Detail__c = mcmId;
          }
          if(vol.quaterlyVolume.Year__c == currentYear) {
            if(thisQuarter == 1) {
              lstVolumes.add(vol.quaterlyVolume.Q1_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q2_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q3_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q4_Volume__c);
            }
            if(thisQuarter == 2) {
              lstVolumes.clear();lstVolumes.add(vol.quaterlyVolume.Q2_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q3_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q4_Volume__c);
            }
            if(thisQuarter == 3) {
              lstVolumes.clear();lstVolumes.add(vol.quaterlyVolume.Q3_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q4_Volume__c);
            }
            if(thisQuarter == 4) {
              lstVolumes.clear();lstVolumes.add(vol.quaterlyVolume.Q4_Volume__c);
            }
           
             lstSaveVol.add(vol.quaterlyVolume);    
             continue;
          }
          
          lstVolumes.add(vol.quaterlyVolume.Q1_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q2_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q3_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q4_Volume__c);
          
          if(vol.quaterlyVolume.Q4_Volume__c == NULL && vol.quaterlyVolume.Q2_Volume__c == NULL && vol.quaterlyVolume.Q3_Volume__c == NULL && vol.quaterlyVolume.Q1_Volume__c == NULL) { continue; }
          lstSaveVol.add(vol.quaterlyVolume);      
        }
        Integer nulIndex = -1;
        for(Integer i=0 ; i < lstVolumes.size(); i++) {
          if(lstVolumes[i] == NULL) {nulIndex = i;break;}
        }
        if(nulIndex != -1) {
            for(Integer i=nulIndex+1 ; i < lstVolumes.size(); i++) { if(lstVolumes[i] != NULL) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please completely fill the volumes for the consecutive quarters, cannot skip quaters')); return null;
              }
            }
        }   
      upsert lstSaveVol;
      createSubstrateRecords();  
        
    }
    catch(Exception e) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please completely fill the volumes for the consecutive quarters, cannot skip quaters' +e.getMessage() + e.getStackTraceString())); return null;
        
    }
     
       Pagereference pf = redirectToMCMDetail()  ;
       return pf;
  
    } 
        
    public  void createSubstrateRecords(){
        Map<String, ID> mapSbstUpdate = new Map<string,ID>();
        List<MCM_Quarterly_Volume__c> qData = [Select Id,year__c,Q1_Volume__c,Q2_Volume__c,Q3_Volume__c,Q4_Volume__c from MCM_Quarterly_Volume__c where PCM_MCM_Detail__c=:mcmId];
        List<MCM_Reporting_Data__c>  sbstCost = [Select id, year__c,quarter__c,cost_type__c,cost__C from MCM_Reporting_Data__c where mcm__c=:mcmId and cost_Type__c='Assembly & Substrate Cost (before Yield)'];
        MCM_Reporting_Data__c temp,tempQ1,tempQ2,tempQ3,tempQ4,newtempQ1,newtempQ2,newtempQ3,newtempQ4  ;
        List<MCM_Reporting_Data__c>  newSbst = new   List<MCM_Reporting_Data__c> ();  
        List<MCM_Reporting_Data__c>  deleteSbst = new   List<MCM_Reporting_Data__c> ();  
        List<MCM_Reporting_Data__c>  addSbst = new   List<MCM_Reporting_Data__c> ();  
        Id qtrAvail;
        integer qtrCount=0;
        
        for(Mcm_Reporting_Data__c c:sbstCost){
            mapSbstUpdate.put(c.year__c +'-' +c.quarter__c, c.id);
            
        }
        
      
        for(MCM_QUArTERLY_VOLUME__c q:qData){
            tempQ1 = new MCM_Reporting_Data__c();
            tempQ2 = new MCM_Reporting_Data__c();
            tempQ3 = new MCM_Reporting_Data__c();
            tempQ4 = new MCM_Reporting_Data__c();
            newtempQ1 = new MCM_Reporting_Data__c();
            newtempQ2 = new MCM_Reporting_Data__c();
            newtempQ3 = new MCM_Reporting_Data__c();
            newtempQ4 = new MCM_Reporting_Data__c();
            
            if(q.q1_volume__c!=null) {
                qtrCount++;
                tempQ1.quarter__c = 'Q1';
                tempQ1.year__c = string.valueof(q.year__c);
                tempQ1.cost_type__c ='Assembly & Substrate Cost (before Yield)';
                tempQ1.mcm__c = mcmId;
                newSbst.add(tempQ1);
                qtrAvail= mapSbstUpdate.remove(q.year__c+'-Q1');
                 if(qtrAvail==null){
                   newtempQ1.quarter__c = 'Q1';
                newtempQ1.year__c = string.valueof(q.year__c);
                newtempQ1.cost_type__c ='Assembly & Substrate Cost (before Yield)';
                newtempQ1.mcm__c = mcmId;
                addSbst.add(newtempQ1);
                }
            }
            if(q.q2_volume__c!=null) {
                qtrCount++;
                tempQ2.quarter__c = 'Q2';
                tempQ2.year__c = string.valueof(q.year__c);
                tempQ2.cost_type__c ='Assembly & Substrate Cost (before Yield)';
                tempQ2.mcm__c = mcmId;
                newSbst.add(tempQ2);
                qtrAvail= mapSbstUpdate.remove(q.year__c+'-Q2');
                 if(qtrAvail==null){
                   newtempQ2.quarter__c = 'Q2';
                newtempQ2.year__c = string.valueof(q.year__c);
                newtempQ2.cost_type__c ='Assembly & Substrate Cost (before Yield)';
                newtempQ2.mcm__c = mcmId;
                addSbst.add(newtempQ2);
                }
            }
            if(q.q3_volume__c!=null){
                qtrCount++;
                tempQ3.quarter__c = 'Q3';
                tempQ3.year__c = string.valueof(q.year__c);
                tempQ3.cost_type__c ='Assembly & Substrate Cost (before Yield)';
                tempQ3.mcm__c = mcmId;
                newSbst.add(tempQ3);
                qtrAvail= mapSbstUpdate.remove(q.year__c+'-Q3');
                if(qtrAvail==null){
                   newtempQ3.quarter__c = 'Q3';
                newtempQ3.year__c = string.valueof(q.year__c);
                newtempQ3.cost_type__c ='Assembly & Substrate Cost (before Yield)';
                newtempQ3.mcm__c = mcmId;
                addSbst.add(newtempQ3);
                }
            }    
            if(q.q4_volume__c!=null)    {
                qtrCount++;
                tempQ4.quarter__c = 'Q4';
                tempQ4.year__c = string.valueof(q.year__c);
                tempQ4.cost_type__c ='Assembly & Substrate Cost (before Yield)';
                tempQ4.mcm__c = mcmId;
                newSbst.add(tempQ4);
                qtrAvail= mapSbstUpdate.remove(q.year__c+'-Q4');
                 if(qtrAvail==null){
                   newtempQ4.quarter__c = 'Q4';
                newtempQ4.year__c =string.valueof(q.year__c);
                newtempQ4.cost_type__c ='Assembly & Substrate Cost (before Yield)';
                newtempQ4.mcm__c = mcmId;
                addSbst.add(newtempQ4);
                }
                
            }
        }
        if(sbstCost.size()==0 && qData.size()>0){
            upsert newSbst;
        }
        else if (sbstCost.size()>qtrCount){            
            deleteSbst.clear();           
            
            for(ID id:mapSbstUpdate.values()){
                temp = new MCM_Reporting_Data__c();
                temp.id=id;
                
                deleteSbst.add(temp);
            }
            
            
            if (deleteSbst!=null)   delete deleteSbst;
            
        }
        else if (sbstCost.size()<qtrCount){
            insert addSbst;
        }
        
    }
      
    
}