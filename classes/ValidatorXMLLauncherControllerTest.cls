/*
 Class Name:         ValidatorXMLLauncherControllerTest
 Author:             Prosenjit Saha
 Created Date:       06-June-2015
 Reason:             This is Test class of the ValidatorXMLLauncherController controller. 
 Change History:
 Author: Karna Shiva             
 Modified Date:     20-Apr-2016
 Reason:             02042016 - Adding Device details section.
 …….. 
 ……..
*/
@isTest(SeeAllData=false)

public Class ValidatorXMLLauncherControllerTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    } 
    /*
    * Method Name:     testXMLValidator
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method handle all the testing 
    */
    static testmethod void testXMLValidator(){   
        Apttus_Proposal__Proposal__c ConfigurationPT = new Apttus_Proposal__Proposal__c(
                                                                    Devices__c = 'D1 D2 D3',
                                                                    //02042016 - Adding Device details section - start
                                                                    Device_Description__c ='Test=>test test1=>test1'
                                                                    //02042016 - Adding Device details section - end
                                                                    /*, Mask_Set__c = 'M1 M2 M3' changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                                    , Mask_Set_Long__c = 'M1 M2 M3'
                                                                    , IPs__c  = 'I1<:>I2<:>I3'
                                                                    , APTPS_Primary__c = TRUE
                                                                    , Apttus_Proposal__Proposal_Name__c = 'Test' );        
        insert ConfigurationPT ;
        Base_IP__c testBaseIP = new Base_IP__c (
                                    name = 'I1'
                                    , IP_Number__c = 'I1');
        insert testBaseIP ; 
        IP__c testIPDK = new IP__c(
                                Name = 'I1'
                                , Latest_Version__c = 'I1'
                                , IP_Tagging_Information__c = 'Test'
                                , IPNumber__c = testBaseIP.id);
        insert testIPDK ;
        PageReference pageRef = Page.ValidatorXMLLauncher;
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Id', ConfigurationPT.Id);
        
        ValidatorXMLLauncherController xmlController = new ValidatorXMLLauncherController();
        xmlController.sendValidatorXML();
        
    }   
}