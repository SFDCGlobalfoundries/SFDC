/********************************************************************************************************
    Class Name:    BX041_processInfoPDF 
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   This Class helps in generating the PDF and excel for process information.
    Created Date: 
      PS           Code creation.
    Change History:
      Author: 
      Modified Date: 
      Reason:
      
      Pradosh         29/06/2016  Case-00056072
*********************************************************************************************************/



public class BX041_processInfoPDF {
    public Id bx041ID; 
    public device__c deviceobj {get; set;}
    public BX_041__c bx041 {get;set;}
    public List<id> QstnMetaData ;
    public List<wrapperPI> ListWrapper {get;set;}
    public List<BX041_IP__c> bx041IpList {get;set;}
    //========================== start: defining wrapper ========================//
    public class wrapperPI{
        public String question {get; set;}
        public String FEinfo {get; set;}
        public String PiyeInfo {get; set;}
        public String Comments {get; set;}
        public String value {get; set;}

    }
    //========================== end: defining wrapper ========================//
    
    /******************************************************************************************************
    @Method Name:    Constructor ( BX041_processInfoPDF )
    @Return Type:    NA
    @parameter:      ApexPages.StandardController controller
    @Reason:         Constructor of the VF page VF_ProcessInfoPDF
    *******************************************************************************************************/ 
    public BX041_processInfoPDF (ApexPages.StandardController controller) {
        ListWrapper  = new List<wrapperPI>();
        bx041ID = ApexPages.currentPage().getParameters().get('ID');
        //making the query to get the BX041 record.        
        bx041 = [SELECT id,
                        Device__c,
                        Device__r.Requested_Process_ID__c,
                        Device__r.Assigned_Process_ID__c,
                        BX_041_Status__c,
                        CRMDID__c,
                        Opportunity_Program__c,
                        CRMDID_Fromula__c,
                        Need_MEMS_informaton__c,
                        Need_PowerMOS__c,
                        Need_eDRAM__c,
                        Need_High_Voltage__c,
                        Need_NVM__c,
                        Need_RF__c,
                        Need_Turnkey__c,
                        Need_IP_information__c,
                        Need_IP_Merge_information__c
                FROM    BX_041__c 
                WHERE   id = :bx041ID];
        //making query to get all the process information  records
        for(Process_Information__c pi : [SELECT    id,
                                                   BX_041__c,
                                                   Comments__c,
                                                   Customer_Comment__c,
                                                   Customer_Request__c,
                                                   FE_Requested_Information__c,
                                                   PIYE__c,
                                                   Question__c,
                                                   Question_Metadata__c,
                                                   Question_Metadata__r.sequence__c,
                                                   Question_to_Display__c,
                                                   Requirement_Gaps__c
                                        FROM       Process_Information__c
                                        WHERE      BX_041__c = :bx041ID
                                        ORDER BY   Question_Metadata__r.sequence__c]){
            wrapperPI tempwrap = new wrapperPI();
            tempwrap.question  = pi.Question__c;
            tempwrap.FEinfo    = pi.FE_Requested_Information__c;
            tempwrap.PiyeInfo  = pi.PIYE__c;
            tempwrap.value     = pi.Customer_Request__c;
            tempwrap.comments  = pi.Customer_Comment__c;
            ListWrapper.add(tempwrap);
        }
        
        if(bx041ID != null){
            bx041IpList = [SELECT Id, Name, IP_Master__c, IP_Type__c, Version__c, IP_Catg__c, Lib_Nm__c, IP_Device_List__c, Vendor__c, Cust_Rqmt__c, Addl_Rqmt__c, Remarks__c FROM BX041_IP__c WHERE BX_041__c =: bx041ID];
        }
    }//end of constructor.

}//end of class.