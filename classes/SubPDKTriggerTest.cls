/*
Type Name: ClsCloneSubPDKTest.
Author: Cognizant
Created Date: 16-Aug-2013
Reason: This is the Test class for class ClsCloneSubPDK. 
Change History:
Author: Cognizant 
Modified Date:28/03/2014
Reason: Field change corresponding to CR # 4562
��..
��..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
*/
@isTest
public class SubPDKTriggerTest
{    
    
    static testMethod void SubPDKTriggerTestMethod()
    {
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        objPDK.PDK_DocTitle__c = 'Master PDK Doc Title';
        objPDK.Tech_Geometry__c ='0.11UM;0.13UM;'; 
        insert objPDK;
        
        //Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Specific Account Release', pdk, 'Demo B1');
        PDK_Patch__c patch = FV_PDKTestDataTest.getPdkPatch(objPDK.id);
        patch.PDK_Version__c = 'V0.0';
        update patch;
        //PDK_Patch__c patch1 = FV_PDKTestDataTest.getPdkPatch(objPDK.id);
        
        List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
        Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', null, 11111, '0.11UM');
        Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2', objPDK.id, 12121, '0.11UM');
        Design_Spec__c dSpec3 = FV_PDKTestDataTest.getPDKPatchSpec('Specific Account Release', 'abc', 'Spec 2', patch.Id, 88, '0.11UM');
        listOfDSpec.add(dSpec1);
        listOfDSpec.add(dSpec2);
        listOfDSpec.add(dSpec3);
        insert listOfDSpec;
        
        Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', objPDK.id, 'Demo B1');
        
        List<Sub_PDK_Spec__c> listSPS = new List<Sub_PDK_Spec__c>();
        Sub_PDK_Spec__c objsps = new Sub_PDK_Spec__c();
        objsps.Sub_PDK__c = sPdk.Id;
        objsps.Design_Spec__c = dSpec1.Id;
        Sub_PDK_Spec__c objsps2 = new Sub_PDK_Spec__c();
        objsps2.Sub_PDK__c = sPdk.Id;
        objsps2.Design_Spec__c = dSpec2.Id;
        Sub_PDK_Spec__c objsps3 = new Sub_PDK_Spec__c();
        objsps3.Sub_PDK__c = sPdk.Id;
        objsps3.Design_Spec__c = dSpec3.Id;
        listSPS.add(objsps);
        listSPS.add(objsps2);
        listSPS.add(objsps3);
        insert listSPS;
        
        sPdk.Bundle_Name__c = sPdk.Bundle_Name__c.remove(':');
        sPdk.Bundle_Name__c  = 'Demo B123';
        update sPdk;
        objPDK.PDK_DocTitle__c = '';
        update objPDK;
        sPdk.Bundle_Name__c  = 'Demo B1234';
        update sPdk;
        objPDK.PDK_DocTitle__c = 'PDK Doc Title';
        update objPDK;
        patch.PDK_Version__c = '';
        update patch;
        sPdk.Bundle_Name__c  = 'Demo B12345';
        update sPdk;
    }
}