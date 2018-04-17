/*
* @ Author          :- Navneet Rajput
* @ Organization    :- Cognizant Technology solutions
* @ Project         :- GMPL/RX009
* @ Description     :- Class helps to predict revenue forcastig  
* @ Date            :-18th March 2014
* @ Change History  :- 
**/

public class  GMPL_RevenueForcastCls {
    
    public Integer rowIndex {get;set;}
    public Boolean isEditable {get;set;}
    Revenue_Forecast__c revenueForcastObj;
    public List<Revenue_Forecast__c> listOfRevenueForcastRecords {get;set;}
    public List<Revenue_Forecast__c> listOfSelectedIds = new List<Revenue_Forecast__c>();    
    public Id gmplId;
    public String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
    public String ctsDev = EnvironmentVariable.get('CTS_DEVELOPER');
    public String gfDev = EnvironmentVariable.get('GF_DEVELOPER');
    public String gfSysAdmin = EnvironmentVariable.get('GF_SYSTEM_ADMIN');
    public String gfGlbAdmin = EnvironmentVariable.get('GF_GLOBAL_ADMIN');
    public String gfInt = EnvironmentVariable.get('GF_INTEGRATION');
    //public List<Id> listOfDeletedItems;
    
    // StandardSetController returns list of Revenueforcasting records on the basis of GMPL id
    public GMPL_RevenueForcastCls(ApexPages.StandardSetController stdSetController){
        //listOfSelectedIds = (List<Revenue_Forecast__c>)stdSetController.getSelected();
        //listOfDeletedItems = new List<Id>();
        if (ApexPages.currentPage().getParameters().get('id')!=null &&
            ApexPages.currentPage().getParameters().get('id')!=''){
                
            gmplId = ApexPages.currentPage().getParameters().get('id');
        }
        
        if (gmplId!=null){
            
            isEditable = true;
            
            List<GMPL_BX009__Share> gmplList = new List<GMPL_BX009__Share>();
            
            Profile prof = PPETeamHelper.getUserProfile();
            
            if(!(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt)){
	            gmplList =  PPETeamHelper.getGMPLBX009ShareUser(gmplId);
            }
            
            if((gmplList != null && gmplList.size()>0)||(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt)){
            
	            listOfRevenueForcastRecords = [SELECT Id,
	                                                  Year__c,
	                                                  Average_Sales_Price__c,
	                                                  Quantity__c,
	                                                  Revenue__c
	                                           FROM   Revenue_Forecast__c
	                                           WHERE  GMPL_BX009__c =: gmplId
	                                           ORDER BY Year__c ASC]; 
            }else{
            	isEditable = false;
            	ApexPages.Message userValidMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'User is having Read Only access on GMPL/BX009 record.');
                ApexPages.addMessage(userValidMsg);
            } 
        }    
                                                          
    }
    // Method all new row in ro list
    public void addNewRow(){
        revenueForcastObj = new Revenue_Forecast__c();
        revenueForcastObj.GMPL_BX009__c = gmplId;
        if (listOfRevenueForcastRecords!=null && listOfRevenueForcastRecords.size()>0){
            revenueForcastObj.Year__c = String.valueOf(Integer.valueOf(listOfRevenueForcastRecords[listOfRevenueForcastRecords.size()-1].Year__c)+1) ;
        } else {
            revenueForcastObj.Year__c = String.valueOf(System.today().year());
        }
        listOfRevenueForcastRecords.add(revenueForcastObj);
    }
    
    // Method use to delete last year record
    
    public pageReference deleteLastYear(){
        try {
            boolean isTrue;
            
            if (listOfRevenueForcastRecords!=null && listOfRevenueForcastRecords.size()>0){
                
                if(listOfRevenueForcastRecords[listOfRevenueForcastRecords.size()-1].Id!=null){
                  delete(listOfRevenueForcastRecords[listOfRevenueForcastRecords.size()-1]);
                } 
                listOfRevenueForcastRecords.remove(listOfRevenueForcastRecords.size()-1);
                ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.INFO,'INFO: Last Year Deleted Successfully.');
                ApexPages.addMessage(infoMsg);
                return null;
                
            } else {
                ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'ERROR: No last year record found to delete.');
                ApexPages.addMessage(infoMsg);
                return null;
            }
            return null;
            
        } catch(Exception e){
                ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: '+e.getMessage());
                ApexPages.addMessage(infoMsg);
                return null;
        }         
    }
    
    // Method saves actual forcastRevenue records of specific GMPL records
    public pageReference SaverevenueForcastingInfo(){
        
        try {       
             if (listOfRevenueForcastRecords!=null && !listOfRevenueForcastRecords.isEmpty()){
                if (!isDuplicateYear(listOfRevenueForcastRecords)){
                    upsert listOfRevenueForcastRecords;
                } else {
                     ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: Year need not be blank or duplicate.');
                     ApexPages.addMessage(infoMsg);
                     return null;
               }
                
            }
            PageReference page = new PageReference('/' + gmplId);
            page.setRedirect(true);
            return page;
                   
           } catch (Exception e){
            ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Record not saved successfully. Please contact System Administrator.');
            ApexPages.addMessage(infoMsg);
            return null;
        }   
    }
    
    // Method use to check duplicate year in list of revenueforcast records
    public boolean isDuplicateYear(List <Revenue_Forecast__c> listOfRevenueForcastRecords){
        Set<String> setOfYear = new Set<String>();
        
        for (Revenue_Forecast__c revRecord: listOfRevenueForcastRecords){
            if (setOfYear!=null && !setOfYear.isEmpty()){
                if (revRecord.year__c!=null && revRecord.year__c!=''){
                    if (setOfYear.contains(revRecord.year__c)){
                        setOfYear.clear();
                        return true;
                    } else {
                        setOfYear.add(revRecord.year__c);
                    }
                } else {
                    return true;
                }   
                
            } else {
                if (revRecord.year__c!=null && revRecord.year__c!=''){
                    setOfYear.add(revRecord.year__c);
                } else {
                    return true;
                }
            }
        }
        return false;
    }
    
    // Method perform Cancle operation and redirect on parent page
    public pageReference cancel(){
        PageReference page = new PageReference('/' + gmplId);
        page.setRedirect(true);
        return page;    
    }

}