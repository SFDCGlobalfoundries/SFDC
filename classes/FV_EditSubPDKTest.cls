/*
Type Name: FV_EditSubPDKTest 
Author:  
Created Date: 
Reason: 
Change History:
Author:  Dinesh Suggala
Modified Date:5/9/2017
Modified by :- Dinesh Suggala(Global Foundries)
Description :- Added the code to cover the code coverage for Pagination
Modified Date: 14/9/2017
Modified By:- Dinesh Suggala(Global Foundries)
Description:- Added the code to cover Custom Setting in Class
??..
??..
*/
@isTest
private class FV_EditSubPDKTest {
    
     @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }

     static testMethod void subPDKTest(){
       
              User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
        System.runAs(runningUser) { 
        
        List<Account> listOfAcc = new List<Account>();  
        List<Id> listOfAccIds = new List<Id>();
        List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
        
       // Calling AccountData Factory class for populating 
        Account acc = getAccount('MYTEST ACCOUNT1');
      
        listOfAcc.add(acc);
        listOfAccIds.add(acc.Id);
       
        ID pdk = FV_PDKTestDataTest.getPdk();
        //Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Specific Account Release', pdk, 'Demo B1');
        Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', pdk, 'Demo B1');
        sPdk.Bundle_Name__c = sPdk.Bundle_Name__c.remove(':');
        sPdk.Bundle_Name__c  = 'Demo B123';
        update sPdk;
        
        /*White_List__c wl = new White_List__c();
        wl.Account__c = acc.id;
        wl.Sub_PDK__c = sPdk.id;
        insert wl;*/
        
        PDK_Patch__c patch = FV_PDKTestDataTest.getPdkPatch(pdk);
        Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdk, 11111, '0.11UM');
        Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2', pdk, 12121, '0.11UM');
        Design_Spec__c dSpec3 = FV_PDKTestDataTest.getPDKPatchSpec('Specific Account Release', 'abc', 'Spec 2', patch.Id, 88, '0.11UM');

        //Added by Dinesh 5/9/2017
        Design_Spec__c dSpec4 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 4', pdk, 59, '0.11UM');       
        Design_Spec__c dSpec5 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'DWR', 'Spec 5', pdk, 89, '0.11UM');
        Design_Spec__c dSpec6 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'cde', 'Spec 6', pdk, 90, '0.11UM');
        Design_Spec__c dSpec7 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'fgd', 'Spec 7', pdk, 91, '0.11UM');
        Design_Spec__c dSpec8 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'rgf', 'Spec 8', pdk, 92, '0.11UM');
        Design_Spec__c dSpec9 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'hgn', 'Spec 9', pdk, 93, '0.11UM');
        Design_Spec__c dSpec10 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'yjh', 'Spec 10', pdk, 94, '0.11UM');
        Design_Spec__c dSpec11 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'ujn', 'Spec 11', pdk, 95, '0.11UM');
        Design_Spec__c dSpec12 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'ujn1', 'Spec 12', pdk, 96, '0.11UM');
        Design_Spec__c dSpec13 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'ujn2', 'Spec 13', pdk, 97, '0.11UM');
        //Ended by Dinesh 5/9/2017
        listOfDSpec.add(dSpec1);
        listOfDSpec.add(dSpec2);
        listOfDSpec.add(dSpec3);
        //Added by Dinesh 5/9/2017
        listOfDSpec.add(dSpec4);
        listOfDSpec.add(dSpec5);
        listOfDSpec.add(dSpec6);
        listOfDSpec.add(dSpec7);
        listOfDSpec.add(dSpec8);
        listOfDSpec.add(dSpec9);
        listOfDSpec.add(dSpec10);
        listOfDSpec.add(dSpec11);
        listOfDSpec.add(dSpec12);
        listOfDSpec.add(dSpec13);
        //Ended by Dinesh 5/9/2017
        insert listOfDSpec;
        system.assertEquals(listOfDSpec,listOfDSpec);
        White_List__c wList = FV_PDKTestDataTest.getWhiteList(listOfDSpec[1].Id, acc.Id);
        List<Sub_PDK_Spec__c> listOfSPdkSpecs = new List<Sub_PDK_Spec__c>();
        Sub_PDK_Spec__c sps1 = FV_PDKTestDataTest.getSubPdkSpec(sPdk.Id,listOfDSpec[0].Id,'5555');
        Sub_PDK_Spec__c sps2 = FV_PDKTestDataTest.getSubPdkSpec(sPdk.Id,listOfDSpec[1].Id,'11');
        listOfSPdkSpecs.add(sps1);
        listOfSPdkSpecs.add(sps2);
        
        insert listOfSPdkSpecs;
        
        Test.startTest();
            Package__c objPkg = FV_PDKTestDataTest.getPackage(acc);
            List<document_provisioning__c> dProLst = new List<document_provisioning__c>();
            document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[0].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
          //  document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[1].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'De-Provisioned');
           
            dProLst.add(dp1); 
           // dProLst.add(dp2);
           
            insert dProLst;
			
		    //Added by Dinesh 14/9/2017
            PDKPagination__c pdkrecords=new PDKPagination__c();
            pdkrecords.Name='1';
            pdkrecords.RecordsPerPage__c='10';
           
            insert pdkrecords;
            //Ended the Code by Dinesh
           
            ApexPages.currentPage().getParameters().put('Id',sPdk.id); 
            FV_EditSubPDK controller = new FV_EditSubPDK(new ApexPages.StandardController(sPdk));
            controller.subPdkWhiteList.add(new FV_EditSubPDK.accountWrapper(true,acc));
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(false,listOfDSpec[0]));
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[1]));
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[2]));

            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[3]));               //Added by Dinesh
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[4]));               //Added by Dinesh
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[5]));               //Added by Dinesh
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[6]));               //Added by Dinesh
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[7]));               //Added by Dinesh
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[8]));               //Added by Dinesh
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[9]));               //Added by Dinesh
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[10]));              //Added by Dinesh
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[11]));              //Added by Dinesh
            controller.PDKDesignSpec.add(new FV_EditSubPDK.designSpecWrapper(true,listOfDSpec[12]));              //Added by Dinesh
            controller.createQueryString('sub_pdk__c','InputFields');
            controller.showPDKDesignSpec.addAll(controller.PDKDesignSpec);
            controller.validateStatus();
            controller.searchString ='Acc1';
            controller.addSelectedAccounts();
            controller.cancelAddAccount();
            controller.clearSearch();
            controller.findDesignSpec();
            controller.getWhiteList();
            controller.searchString ='Acc1';//added by sunita
            controller.searchAccount();
            controller.showWLAccountSection();
            controller.saveSubPdk();
            controller.SubPDK.Release_Status__c = 'Release to White list';
            controller.searchString ='acc';
            controller.addSelectedAccounts();
            controller.searchAccount();//added by sunita
            controller.cancelAddAccount();
            controller.clearSearch();
            controller.findDesignSpec();
            controller.getWhiteList();
            controller.searchAccount();
            controller.showWLAccountSection();
            controller.saveSubPdk();
            controller.SubPDK.Release_Status__c = 'Specific Account Release';
            controller.saveSubPdk();
            controller.SubPDK.Release_Status__c = 'Internal Use Only';//added by kunal
            controller.saveSubPdk();// added by kunal
            controller.SubPDK.Release_Status__c = 'General Release';//added by kunal
            controller.saveSubPdk();// added by kunal
            controller.SubPDK.Bundle_Name__c = null;
            controller.saveSubPdk();
            controller.SubPDK.Release_Status__c = null;
            controller.saveSubPdk();
            controller.SubPDK.Bundle_Name__c = 'test:';
            controller.saveSubPdk();
            //Added by Dinesh
            controller.counter=0;
            controller.limitSize=10;
            controller.beginning();
            controller.next();
            controller.previous();
            controller.last();
            controller.getDisableNext();
            controller.getDisablePrevious();
            controller.getTotalPages();
            //Ended by Dinesh
            /*Map<Id,Id> accMap = new Map<Id,Id>();
            accMap.put(acc.id,acc.id);
            controller.statusChangeToWL(sPdk,accMap);*/
            //controller.validateStatus();
        Test.stopTest();        
     }
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                        Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
}