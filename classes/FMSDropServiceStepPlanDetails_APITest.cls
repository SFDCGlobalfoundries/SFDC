/*
 @class: FMSDropServiceStepPlanDetails_APITest
 @CreatedBy: FMS Dev Team
 @CreatedDate: 09/06/2017
 @Description: Test class for FMSDropServiceStepPlanDetails_API
 @Modifications-
 *	** Inshu Misra      03/07/2017    Changed the logic of test classes according code review Comments
 */
@isTest
public class FMSDropServiceStepPlanDetails_APITest {
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();               
    }
    
    @isTest
    static void testMethod1() {
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        
        System.runAs(FMSDataFactory.testUser){
            FMSDropServiceStepPlanDetails_API dropAPI = new FMSDropServiceStepPlanDetails_API();
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FMSMockHttpResponseGenerator());
            dropAPI.FMSStepPlaApproval_API(1111, '2222', '200', 'Test Approval');
            Map<string, string> mpresponse = FMSDropServiceStepPlanDetails_API.GetTechnologyDefault('BiCMOS 5PAe (SiGe 5PAe)');
            FMSDropServiceStepPlanDetails_API fmsAPIObj = new FMSDropServiceStepPlanDetails_API();
            FMSDropServiceStepPlanDetails_API.Dropbox dropbx = new FMSDropServiceStepPlanDetails_API.Dropbox();
            dropbx.statusCode = '200';
            dropbx.message = 'OK';
            dropbx.data = new FMSDropServiceStepPlanDetails_API.Data();
            dropbx.data.packages = null;
            dropbx.data.packages_To_User = null;            
            FMSDropServiceStepPlanDetails_API.Packages_to_user pkgUsr = new FMSDropServiceStepPlanDetails_API.Packages_to_user();
            pkgUsr.id='Test';
            pkgUsr.files = null;
            pkgUsr.packageName = 'testpkg';
            pkgUsr.expireDate = '22/02/2017';
            pkgUsr.sentDate = '22/02/2017';
            pkgUsr.pkgSenderEmail = 'abc@gmail.com';
            pkgUsr.pkgReceiversEmail = new List<String>{'xyz@gmail.com'};
            FMSDropServiceStepPlanDetails_API.Packages pkg = new FMSDropServiceStepPlanDetails_API.Packages();
            pkg.id = 'testId';
            pkg.files = null;
            pkg.packageName = 'testpkg';
            pkg.expireDate = '22/02/2017';
            pkg.sentDate = '22/02/2017';
            pkg.pkgSenderEmail = 'abc@gmail.com';
            pkg.pkgReceiversEmail = new List<String>{'xyz@gmail.com'}; 
            FMSDropServiceStepPlanDetails_API.File file = new FMSDropServiceStepPlanDetails_API.File();
            file.fileId = 'testId';
            file.fileName = 'test';
            file.fileSize = '30KB';
            
            System.assert(mpresponse != null);
          Test.stopTest();
        }
    }
    
    @isTest
    static void testMethod2() {
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        System.runAs(FMSDataFactory.testUser){
          Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FMSMockHttpResponseGeneratorDropBox());
            System.assertNotEquals(null, FMSDropServiceStepPlanDetails_API.dropBoxService('abc@gmail.com')) ;
          Test.stopTest();
        }
    }
}