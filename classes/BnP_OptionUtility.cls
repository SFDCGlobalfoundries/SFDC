/**
   @Author <Cognizant Technology Solutions>
   @name <BnP_OptionUtility >
   @CreateDate <06/10/2016>
   @Description <>
   @Version <>
   @reference <>
  */
public Class  BnP_OptionUtility 
{            
    /**
    *  The Purpose of this method is update Option Stage based upon input 
    *  @name <updateOptionStages>
    *  @param <List of Id, OptionStage> 
    *  @return <boolean>
    *  @throws exception-<NA>
    */
    public boolean updateOptionStages(List<Id> optionId , string strStage)
    {
        try
        {
            List<Customer_Requirement__c> lstOption = new List<Customer_Requirement__c>();
            for(Id RecordId : optionId)
            {
                Customer_Requirement__c objOption = new Customer_Requirement__c();
                objOption.Id = RecordId;
                objOption.Option_Stage__c = strStage;
                lstOption.add(objOption); 
            }
            update lstOption; 
            return true;
        }
        catch(Exception excp)
        {           
            GlobalUtility.logMessage('Error','BnP_OptionUtility','updateOptionStages','','Exception while updating Option Stages from Generic Class',String.valueof(excp.getMessage()),'','BnP',excp,0);
            return false;
        }
    }   
    
    /**
    *  The Purpose of this method is update Customer Design Specification CDS Status based upon input 
    *  @name <updateCDSStatus>
    *  @param <List of Id, CDSStatus> 
    *  @return <boolean>
    *  @throws exception-<NA>
    */
    public boolean updateCDSStatus(List<Id> cdsId , string strStage)
    {
        try
        {
            List<Custom_Design__c> lstCDS = new List<Custom_Design__c>();
            for(Id RecordId : cdsId)
            {
                Custom_Design__c objCDS = new Custom_Design__c();
                objCDS.Id = RecordId;
                objCDS.CDS_Status__c = strStage;
                lstCDS.add(objCDS); 
            }
            update lstCDS; 
            return true;
        }
        catch(Exception excp)
        {           
            GlobalUtility.logMessage('Error','BnP_OptionUtility','updateCDSStatus','','Exception while updating Option Stages from Generic Class',String.valueof(excp.getMessage()),'','CDS',excp,0);
            return false;
        }
    }   
}