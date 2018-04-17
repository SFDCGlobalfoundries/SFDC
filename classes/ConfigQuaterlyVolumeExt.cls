/*
  Author: Akash Aggarwal
  Description: This is the controller class for the ConfigQuarterlyVolume for Configurator.
  
  Kanishk:Case Number 00074948:Enhancement - PCM Quarterly Volume update
  sSharma1: Case #00080403 - null pointer exception and other enhancements related to logic    
*/
public  class ConfigQuaterlyVolumeExt {

  Apttus_Proposal__Proposal__c proposal{get;set;}
  public Integer currentYear{get;set;}
  public Integer thisQuarter{get;set;}
  public Id configReqId;
  public id prodConfigId;
  public id proposalId;
  String params = '';
  PCM_Administration__c pcmAdminSetting = PCM_Administration__c.getInstance('CURRENT_SETTING'); 
  public ConfigQuaterlyVolumeExt() {
    prodConfigId = ApexPages.currentPage().getParameters().get('Id');
    configReqId = ApexPages.currentPage().getParameters().get('configRequestId');
    proposalId = ApexPages.currentPage().getParameters().get('retId');
    proposal = [Select Id,Product_Type__c, FMS_Proposal__c,Actual_Tapeout_Date_FAB_9_and_FAB_10__c,Fab_Name__c,Apttus_Proposal__Opportunity__c,deliverable_part_type__c FROM Apttus_Proposal__Proposal__c WHERE Id =:proposalId];
        
    if(proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c != NULL) {
		currentYearQuarter();
		fetchQuaterlyVolume();
	}
    
      Map<String,String> mpParameters = ApexPages.currentPage().getParameters();
      Integer count = 0;
      for(String key : mpParameters.keySet()) {
        count++;
        if(key.containsIgnorecase('visualforce') || key.containsIgnorecase('frm')) {
          continue;
        }
        if(count == mpParameters.size()) {
          params += key+'='+ mpParameters.get(key);
        }
        else {
          params += key+'='+ mpParameters.get(key) + '&';
        }               
      }
  }
  
	public void currentYearQuarter() {
		currentYear = proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c.year();
		
		Integer month = proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c.month();
		if(month >= 1 && month <=3) {thisQuarter = 1;}
		if(month >= 4 && month <=6) {thisQuarter = 2;}
		if(month >= 7 && month <=9) {thisQuarter = 3;}
		if(month >= 10 && month <=12) {thisQuarter = 4;}
	}
  public pagereference gotoPostFabPage() {
    if(proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c == NULL) {
      delete [Select Id from Config_Quarterly_Volume__c where Quote_Proposal__c  = :proposalId];
    }
    if(proposal.FMS_Proposal__c<>null){
        PageReference pr = new PageReference('/apex/ProposalSummary?'+params);
        pr.setredirect(true);
        return pr;
    }
  
    String fab = proposal.Fab_Name__c != NULL ? proposal.Fab_Name__c.toLowercase() : proposal.Fab_Name__c;
    String fabs = pcmAdminSetting.PCM_Fabs__c != NULL ? pcmAdminSetting.PCM_Fabs__c.toLowercase() : pcmAdminSetting.PCM_Fabs__c;
    Set<String> stFabs = new Set<String>();
    if(fabs != NULL) {
      stFabs.addAll(fabs.split(','));
    }
    if(fab == NULL || fabs == NULL || !stFabs.contains(fab)) {
      String targetURL = '/apex/ProposalSummary?='+params;
      targetURL = targetURL+'&toCart=1';
      PageReference pr = new PageReference(targetURL);
      pr.setredirect(true);
      return pr;
    }
    
    if(proposal.Product_Type__c == 'Wafer' && proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c == NULL) {
      String currentUrl = ApexPages.currentPage().getURL();  
      String targetURL = '/apex/ProposalSummary?='+params;
      targetURL = targetURL+'&toCart=1';
      PageReference pr = new PageReference(targetURL);
      pr.setredirect(true);
      return pr;
    }
   
    if(proposal.Product_Type__c == NULL || proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c == NULL) {
      String currentUrl = ApexPages.currentPage().getURL();  
      String targetURL = '/apex/CPQConfigPostFabServices?='+params;
      targetURL = targetURL+'&toCart=1';
      PageReference pr = new PageReference(targetURL);
      pr.setredirect(true);
      return pr;
    }
    
    if(proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c != NULL) {
      delete [Select Id from Config_Quarterly_Volume__c where Year__c <: currentYear AND Quote_Proposal__c  = :proposalId];
    }
    return NULL;
  }
  
  public list<WrapperQuaterly> lstWrapperQuaterly{get;set;}
  public Decimal lastRecordedYear {get; set;}
  	
	public void fetchQuaterlyVolume() {
		lstWrapperQuaterly = new List<WrapperQuaterly>();
    
		Boolean qVolDataAlreadyExistsFlag = false;
		Map<Integer,Map<String,Quarterly_Revenue_Object__c>> mpQuarterlyRevenue = getQuarterlyRevenueDetail(proposal.Apttus_Proposal__Opportunity__c);

		lastRecordedYear = proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c.year() - 1;
		
		for(Config_Quarterly_Volume__c v : [Select Id,Q1_Volume__c,Q2_Volume__c,Q3_Volume__c,Q4_Volume__c, Year__c,Quote_Proposal__c 
								FROM Config_Quarterly_Volume__c 
								WHERE Quote_Proposal__c  = :proposalId AND Year__c >=:currentYear 
								ORDER BY Year__c ASC]) {
		  
		  qVolDataAlreadyExistsFlag = true;
		  
		  while(v.year__c > (lastRecordedYear+1)){
			lastRecordedYear++;
			lstWrapperQuaterly.add(new WrapperQuaterly(new Config_Quarterly_Volume__c(year__c = lastRecordedYear ))); 
		  }
		  if(v.year__c == currentYear) {
			if(thisQuarter == 2) {v.Q1_Volume__c = NULL;}
			if(thisQuarter == 3) {v.Q2_Volume__c = NULL;v.Q1_Volume__c = NULL;}
			if(thisQuarter == 4) {v.Q3_Volume__c = NULL;v.Q2_Volume__c = NULL;v.Q1_Volume__c = NULL;}
		  }
		  lstWrapperQuaterly.add(new WrapperQuaterly(v));
		  lastRecordedYear = v.year__c;
		}
		if(!qVolDataAlreadyExistsFlag)
			while(lstWrapperQuaterly.size() < 7) {
			  lastRecordedYear++;
			  lstWrapperQuaterly.add(getDefaultValue(Integer.valueOf(lastRecordedYear),mpQuarterlyRevenue));             
			}
	} 
  
	//Kanishk: get default value to show on grid
	private WrapperQuaterly getDefaultValue(integer year, map<Integer,map<String,Quarterly_Revenue_Object__c>> mpQuarterlyRevenue){

		WrapperQuaterly objWrapperQuaterly=new WrapperQuaterly(new Config_Quarterly_Volume__c(year__c=year));
		for(integer ii=1;ii<=4;ii++){
		  String strQuarterkey='Q'+ii;
		  if(mpQuarterlyRevenue!=null && mpQuarterlyRevenue.get(year)!=null && mpQuarterlyRevenue.get(year).get(strQuarterkey)!=null){
			objWrapperQuaterly.quaterlyVolume.put(strQuarterkey+'_Volume__c',mpQuarterlyRevenue.get(year).get(strQuarterkey).Volume__c);
		  }
		}
		if(year == currentYear) {
			if(thisQuarter >= 2) {objWrapperQuaterly.quaterlyVolume.Q1_Volume__c = NULL;}
			if(thisQuarter >= 3) {objWrapperQuaterly.quaterlyVolume.Q2_Volume__c = NULL;}
			if(thisQuarter == 4) {objWrapperQuaterly.quaterlyVolume.Q3_Volume__c = NULL;}
		}
		return objWrapperQuaterly;
	}
  
	//Kanishk: get Quarterly Revenue details from opportunity 
	private Map<Integer, Map<String, Quarterly_Revenue_Object__c>> getQuarterlyRevenueDetail(String oppId) {

		Map<Integer, Map<String, Quarterly_Revenue_Object__c>> mpQuarterlyRevenue = new Map<Integer, Map<String, Quarterly_Revenue_Object__c>>();

		for (Quarterly_Revenue_Object__c rev: [select id, Year__c, Volume__c, Month_Year__c, Fiscal_Quarter__c, Adjusted_Volume__c 
												from Quarterly_Revenue_Object__c
												WHERE Opportunity__c =: oppId AND Volume__c != 0]) {
			if (rev.Fiscal_Quarter__c == NULL){
				continue;
			}
			List<String> lstYearQu = rev.Fiscal_Quarter__c.split('-');
			Integer year = 0;
			String strQuarter = 'NA';

			if (lstYearQu.size() > 0) {
				year = Integer.valueOf(lstYearQu[0]);
			}
			if (lstYearQu.size() > 1) {
				strQuarter = (lstYearQu[1]);
			}
			if (!mpQuarterlyRevenue.containsKey(year)) {
				mpQuarterlyRevenue.put(Integer.valueOf(year), new Map<String, Quarterly_Revenue_Object__c>());
			}

			mpQuarterlyRevenue.get(year).put(strQuarter, rev);
		}
		return mpQuarterlyRevenue;
	}
  
  public pagereference addRow() {
    lastRecordedYear += 1;
    lstWrapperQuaterly.add(new WrapperQuaterly(new Config_Quarterly_Volume__c(year__c = lastRecordedYear )));
    return NULL;
  }
  
  public pagereference deleteRows() {
    List<WrapperQuaterly > tempLstWrapVol = new list<WrapperQuaterly >();
    List<Config_Quarterly_Volume__c > tempLstVolDel = new list<Config_Quarterly_Volume__c >();
    for(WrapperQuaterly vol : lstWrapperQuaterly) {
      if(vol.toDelete) {
        if(vol.quaterlyVolume.id != NULL) {
          tempLstVolDel.add(vol.quaterlyVolume);
        }
        continue;
      }
      tempLstWrapVol.add(vol);
    }
    lastRecordedYear = proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c.year() - 1;
    lstWrapperQuaterly = tempLstWrapVol;
    for(WrapperQuaterly vol : lstWrapperQuaterly) {
      lastRecordedYear += 1;
      vol.quaterlyVolume.year__c = lastRecordedYear;
    }
    if(!tempLstVolDel.isEmpty()) {
      delete tempLstVolDel;
    }
    return NULL;
  }
  
  public class WrapperQuaterly {
    public Config_Quarterly_Volume__c quaterlyVolume{get;set;}
    public boolean toDelete{get;set;}
    public WrapperQuaterly(Config_Quarterly_Volume__c vol) {
      quaterlyVolume = vol;
      toDelete = false;
    }
  }
  
  public pagereference saveAndNext() {
    
    try {
        list<Config_Quarterly_Volume__c> lstSaveVol = new list<Config_Quarterly_Volume__c>();
        list<Config_Quarterly_Volume__c> lstDelVol = new list<Config_Quarterly_Volume__c>();
        if(lstWrapperQuaterly.isEmpty()) {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please add the volume for atleast current quarter'));return null;
        }
        list<Decimal> lstVolumes = new list<Decimal>();
        
        for(WrapperQuaterly vol : lstWrapperQuaterly) {
          if(vol.quaterlyVolume.Id == NULL) {
            vol.quaterlyVolume.Quote_Proposal__c = proposalId;
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
            if(vol.quaterlyVolume.Q4_Volume__c == NULL && vol.quaterlyVolume.Q2_Volume__c == NULL && vol.quaterlyVolume.Q3_Volume__c == NULL && vol.quaterlyVolume.Q1_Volume__c == NULL) { 
              if(vol.quaterlyVolume.Id != NULL) {
                lstDelVol.add(vol.quaterlyVolume);
              }
              continue;
            }
            lstSaveVol.add(vol.quaterlyVolume);    
            continue;
          }
          
          lstVolumes.add(vol.quaterlyVolume.Q1_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q2_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q3_Volume__c);lstVolumes.add(vol.quaterlyVolume.Q4_Volume__c);
          
		  if((vol.quaterlyVolume.Q1_Volume__c == NULL || vol.quaterlyVolume.Q1_Volume__c == 0) &&
			 (vol.quaterlyVolume.Q2_Volume__c == NULL || vol.quaterlyVolume.Q2_Volume__c == 0) &&
			 (vol.quaterlyVolume.Q3_Volume__c == NULL || vol.quaterlyVolume.Q3_Volume__c == 0) &&
			 (vol.quaterlyVolume.Q4_Volume__c == NULL || vol.quaterlyVolume.Q4_Volume__c == 0)){
			if(vol.quaterlyVolume.Id != NULL) {
			  lstDelVol.add(vol.quaterlyVolume);
			}
            continue; 
          }
          lstSaveVol.add(vol.quaterlyVolume);      
        }
        Integer nulIndex = -1;
        for(Integer i=0 ; i < lstVolumes.size(); i++) {
          if(lstVolumes[i] == NULL) {nulIndex = i;break;}
        }
        if(nulIndex != -1) {
            for(Integer i=nulIndex+1 ; i < lstVolumes.size(); i++) { if(lstVolumes[i] != NULL) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please completely fill the volumes for the consecutive quarters, cannot skip quarters')); return null;
              }
            }
        }   
      upsert lstSaveVol;
      if(!lstDelVol.isEmpty())delete lstDelVol;      
    }
    catch(Exception e) {
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ConfigQuaterlyVolumeExt.class.getName();
            alw.sourceFunction ='saveAndNext()';alw.ApplicationName='CPQ';
            alw.referenceId = proposalId;alw.referenceInfo='Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';alw.logCode =e.getTypeName();alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
    }
    return new pagereference('/apex/CPQConfigPostFabServices');
  }
  
    // This method takes the user to the option page for modification in the configuration.
    public pagereference redirectToCatalog(){   
      PageReference pr;
      if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){          
        pr = new PageReference('/GlobalfoundryView/apex/Cart?callerPage=cart&configRequestId='+configReqId+'&id='+prodConfigId+'&flow=GFFlow#/configure/10002');
      }else{
        pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm().replace('--c','--apttus-config2')+'/apex/Cart?callerPage=cart&configRequestId='+configReqId+'&id='+prodConfigId+'&flow=GFFlow#/configure/10002');
      }
      return pr;
    }
    
    public pagereference goToNextPage(){ 
      try {
        Pagereference pg1 = saveAndNext();
        if(pg1 == NULL) {
          return NULL;
        }
      }
      catch(DMLException de) {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,de.getDMLMessage(0)));
         return null;
      }
      PageReference pr;
      String currentUrl = ApexPages.currentPage().getURL();      
      String targetURL;
      if(proposal.Product_Type__c == 'Wafer') {
        targetURL = '/apex/ProposalSummary?='+params;
        pr = new PageReference(targetURL);
        return pr;
      }
      targetURL = '/apex/CPQConfigPostFabServices?='+params;
      pr = new PageReference(targetURL);
      return pr;
    }
}