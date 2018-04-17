@isTest
private class CloneIPRwithSizingTest  {

    @TestSetup static void testdata() 
    {
    DataUtilTest.loadEnvironmentVariables();
    }

    static testMethod void testPOCloneController() {
        PageReference pref = Page.clone_IPRwithSizing;
        Test.setCurrentPage(pref);
        
     
        Map<String,Object> fieldValueIPRMap = new Map<String,Object>();
        IP_Request__c ipr = IPRDataFactory.createIPR(fieldValueIPRMap);
       
        Map<String,Object> fieldValueIPSIZ = new Map<String,Object>();
        fieldValueIPSIZ.put('IP_Request__c',ipr.id); 
        IP_Sizing__c ipSiz = IPRDataFactory.createIPSizing(fieldValueIPSIZ);
        
        ApexPages.StandardController con = new ApexPages.StandardController(ipr);
        CloneIPRwithSizing  ext = new CloneIPRwithSizing(con);
        
        Test.startTest();
        try{
        PageReference ref = ext.cloning();
        
        PageReference redir = new PageReference('/'+ext.newRecordId +'/e?retURL=%2F'+ext.newRecordId);
        System.assertEquals(ref.getUrl(),redir.getUrl());
       
        Test.stopTest();
        }catch (Exception excp) {
                 
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','CloneIPRwithSizing','cloning','','Exception while cloning IpSizingOptions records',String.valueof(excp.getMessage()),'','IP Request',excp,0);
                  
        } 
        

    }

}