@isTest(seeAllData=false)
public with sharing class RMA_Edit_Extension_Test {
    @TestSetup
    static void loadTestData(){
        DataUtilTest.loadEnvironmentVariables();
        Account acc = RMA_TestDataUtility.createAccount();
    }
    
    static testMethod void myTestMethod1(){
        Account acc = [select Id from Account limit 1][0];
        RMA_TestDataUtility.createInvoices(1, acc);
        test.startTest();
        RMA_Edit_Extension con = new RMA_Edit_Extension(new ApexPages.StandardController(new RMA__c()));
        con.RMArecord.Customer__c = acc.Id;
        con.checkAccTeamProxy();
        con.RMArecord.Fab__c = 'FAB 2';
        con.checkFab();
        con.RMArecord.Customer_Request_Date__c = System.TODAY()-1;
        con.RMArecord.RMA_By__c = 'Wafer';
        con.CreateRMA();
        con.RMArecord.Customer__c = acc.Id;
        con.checkAccTeamProxy();
        con.RMArecord.Fab__c = 'FAB 1';
        con.RMArecord.Customer_Request_Date__c = System.TODAY()-1;
        con.RMArecord.RMA_By__c = 'Wafer';
        con.CreateRMA();
        
        RMA_Edit_Extension con1 = new RMA_Edit_Extension(new ApexPages.Standardcontroller(new RMA__c()));
        con1.RMArecord.Customer__c = acc.Id;
        con1.checkAccTeamProxy();
        con1.RMArecord.Fab__c = 'FAB 1';
        con1.RMArecord.RMA_By__c = 'Wafer';
        con1.CreateRMA();
        con1.RMArecord.Customer__c = acc.Id;
        con1.checkAccTeamProxy();
        con1.RMArecord.Fab__c = 'FAB 1';
        con1.RMArecord.Customer_Request_Date__c = System.TODAY()-1;
        con1.RMArecord.RMA_By__c = 'Wafer';
        con1.CreateRMA();
        
        test.stopTest();    
    }
    
    static testMethod void myTestMethod2(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        test.startTest();
        List<RMA_Return_Invoice__c> invlist = RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        RMA_TestDataUtility.createRMAAttachment(rmaRec); 
        
        //updating RMA with mandatory fields
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Status__c = 'Draft';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        update rmaRec;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef1 = Page.RMA_view;
        pageRef1.getParameters().put('id', String.valueOf(rmaRec.Id));
        Test.setCurrentPage(pageRef1);
        RMA_Edit_Extension obj1 = new RMA_Edit_Extension(sc1);
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef2 = Page.RMA_Edit;
        pageRef2.getParameters().put('id', String.valueOf(rmaRec.Id));
        pageRef2.getParameters().put('selTab', 'RMA_Information');
        Test.setCurrentPage(pageRef2);
        RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
        Test.setCurrentPage(pageRef2);
        
        obj2.AddReturnInvoice();
        obj2.MassUpload();
        obj2.checkDuplicateDNCN();
        obj2.LineItemToEdit = invlist[0].Id;
        obj2.ExportLineItem();
        obj2.EditLineItem();
        obj2.UpdateLineItem();
        obj2.CancelPopup();
        obj2.RMArecord.Potential_Impact_Wafers__c =1;
        obj2.RMArecord.RMA_Category__c = 'Technical/ Turnkey';
        obj2.validateRMACategory();
        obj2.RMArecord.Assign_To__c = 'Fab';
        obj2.RMArecord.RMA_due_to_Field_reliability_Failure__c = obj2.RMArecord.RMA_related_to_Waiver_Issue__c = 
        obj2.RMArecord.Risk_Production__c = obj2.RMArecord.Is_the_RMA_lot_s_related_to_PRF__c = obj2.RMArecord.Customer_CAR_Raised__c = true;
        obj2.RMArecord.Remarks_Field_Reliability_Failure__c = obj2.RMArecord.Remarks_Waiver_Issue__c = 
        obj2.RMArecord.Remarks_Risk_Production__c = 'test';
        obj2.cancelPRFCARPopup();
        obj2.showCARPopup();
        obj2.showPrfPopup();
        obj2.carParticular.Car__c = 'testcar';
        obj2.rightOptionsCAR.add(new selectOption('testLot1','testLot1'));
        obj2.prfParticular.PRF__c = 'testprf';
        obj2.prfParticular.Lot__c = 'testLot1';
        obj2.addPRF();
        obj2.addCAR();
        obj2.getLotNumbers();
        obj2.getPRFParticulars();
        obj2.getCARParticulars();
        pageRef2.getParameters().put('prfId', obj2.getPRFParticulars()[0].Id);
        obj2.removePRFCAR();
        obj2.carParticular.Car__c = 'testcar';
        obj2.rightOptionsCAR.add(new selectOption('testLot1','testLot1'));
        obj2.prfParticular.PRF__c = 'testprf';
        obj2.prfParticular.Lot__c = 'testLot1';
        obj2.addPRF();
        obj2.addCAR();
        obj2.deletePrfParticulars();
        obj2.deleteCarParticulars();
        obj2.rightOptionsFRF.add(new SelectOption(invlist[0].Lot_Number__c,invlist[0].Lot_Number__c));
        obj2.rightOptionsDRW.add(new SelectOption(invlist[0].Lot_Number__c,invlist[0].Lot_Number__c));
        obj2.rightOptionsETW.add(new SelectOption(invlist[0].Lot_Number__c,invlist[0].Lot_Number__c));
        obj2.rightOptionsRP.add(new SelectOption(invlist[0].Lot_Number__c,invlist[0].Lot_Number__c));
        obj2.RMArecord.Access_Impact__c = 'Safety Impact';
        obj2.RMArecord.Description_of_Reason_s__c = 'test';
        obj2.RMArecord.Disposition_of_Wafers__c = 'Return to GF';
        obj2.dispDisposition();
        obj2.rightOptionsReturn.add(new SelectOption(invlist[0].Lot_Number__c,invlist[0].Lot_Number__c));
        obj2.RMArecord.Return_Estimated_Date__c = system.today() + 2;
        obj2.cancelWaferPopUp();
        obj2.showWaferPopUp();
        obj2.searchWaferUser = [select Name from User where Id =: userInfo.getUserId() limit 1].Name;
        obj2.SearchWaferUser();
        obj2.leftSelectedUsersForWafer.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
        obj2.selectWaferUserClick();
        obj2.addNotifyUsersToField();
        obj2.SaveRMA();
        obj2.searchWaferUser = [select Name from User where Id =: userInfo.getUserId() limit 1].Name;
        obj2.SearchWaferUser();
        obj2.rightSelectedUsersForWafer.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
        obj2.unselectWaferUserClick();
        obj2.getunselectedWaferUserValues();
        obj2.getSelectedWaferUserValues();
        obj2.addWaferUsersToField();
        obj2.SaveRMA();
        obj2.cancelNotifyPopUp();
        obj2.showNotifyPopUp();
        obj2.searchNotifyUser = [select Name from User where Id =: userInfo.getUserId() limit 1].Name;
        obj2.SearchNotifyUser();
        obj2.leftSelectedUsersForNotify.add(obj2.searchNotifyUser);
        obj2.selectNotifyUserClick();
        obj2.SaveRMA();
        obj2.searchNotifyUser = [select Name from User where Id =: userInfo.getUserId() limit 1].Name;
        obj2.SearchNotifyUser();
        obj2.rightSelectedUsersForNotify.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
        obj2.unselectNotifyUserClick();
        obj2.getunselectedNotifyUserValues();
        obj2.getSelectedNotifyUserValues();
        obj2.addNotifyUsersToField();
        obj2.RMArecord.Acknowledged_Wafer_Return__c = true;
        obj2.RMArecord.Date_of_Wafer_Receipt__c = system.today();
        obj2.RMArecord.Air_way_Bill_No__c = 'AAA';
        obj2.RMArecord.Quantity_Received__c = 1;
        obj2.RMArecord.Remarks_Reason_Wafer_Receipt__c = 'test';
        obj2.RMArecord.Return_Category__c = 'Fab';
        obj2.RMArecord.Return_Classes__c = 'Fab - Bonding issue due to bondpad, not assembly related';
        obj2.SaveRMA();
        
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String f = util.getAllFields('RMA__c');
        String query = 'select '+f+' from RMA__c limit 1';
        List<RMA__c> rmalist = database.query(query);
        RMA__c rmaRec1 = rmaList[0];
                
        ApexPages.StandardController sc3 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef3 = Page.RMA_view;
        pageRef3.getParameters().put('id', String.valueOf(rmaRec1.Id));
        Test.setCurrentPage(pageRef3);
        RMA_Edit_Extension obj3 = new RMA_Edit_Extension(sc3);
        Test.setCurrentPage(pageRef3);
        
        test.stopTest();                                                
    }
    
     static testMethod void myTestMethod3() {
           Account acc = [Select id from account limit 1][0];
           RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
           test.startTest();
           RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc); 
           
            //updating RMA with mandatory fields
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
            rmaRec.Lot_Device_FRF__c = 'testLot1';
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            //rmaRec.Remarks__c = 'Test';
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            update rmaRec;
            obj.sumbitForApproval();
            
            List<RMA__c> rmalist2 = database.query(query);
            RMA__c rmaRec2 = rmaList2[0];
            
            rmaRec2.Lot_Comments__c = 'test';
            update rmaRec2;
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec2);
            PageReference pageRef2 = Page.RMA_Edit;
            pageRef2.getParameters().put('id', String.valueOf(rmaRec2.Id));
            Test.setCurrentPage(pageRef2);
            RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
            Test.setCurrentPage(pageRef2);
            obj2.reAssign = 'Assign to Non-Fab';
            obj2.cancelNonFabPopUp();
            obj2.cancelNonFabPopUp();
            obj2.showNonFabPopUp();
            obj2.searchNonFabUser = [select Name from User where Id =: userInfo.getUserId() limit 1].Name;
            obj2.SearchNonFabUser();
            obj2.leftSelectedUsersForNonFab.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
            obj2.selectNonFabUserClick();
            obj2.rightSelectedUsersForNonFab.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
            obj2.unselectNonFabUserClick();
            obj2.leftSelectedUsersForNonFab.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
            obj2.selectNonFabUserClick();
            obj2.getunselectedNonFabUserValues();
            obj2.getselectedNonFabUserValues();
            obj2.addNonFabUsersToField();
            obj2.saveRMA();
            
            List<RMA__c> rmalist3 = database.query(query);
            RMA__c rmaRec3 = rmaList3[0];
            
            ApexPages.StandardController sc3 = new ApexPages.StandardController(rmaRec3);
            PageReference pageRef3 = Page.RMA_Edit;
            pageRef3.getParameters().put('id', String.valueOf(rmaRec3.Id));
            Test.setCurrentPage(pageRef3);
            RMA_Edit_Extension obj3 = new RMA_Edit_Extension(sc3);
            Test.setCurrentPage(pageRef3);
            obj3.RMArecord.Extension_for_Fab_validation_required__c = true;
            obj3.RMArecord.Extension_Reason__c = 'test';
            obj3.saveRMA();
            obj3.sendRequestForExtension();
            obj3.RMArecord.Extension_for_Fab_validation_required__c = true;
            obj3.RMArecord.Extension_Reason__c = 'test';
            obj3.RMArecord.Number_of_Days__c = 2;
            obj3.saveRMA();
            obj3.sendRequestForExtension();
            obj3.approveExtension();
            obj3.showExtensionReason();
            obj3.hideExtensionReason();
            
            obj3.cancelFabPopUp();
            obj3.showFabPopUp();
            obj3.searchFabUser = [select Name from User where Id =: userInfo.getUserId() limit 1].Name;
            obj3.SearchFabUser();
            obj3.leftSelectedUsersForFab.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
            obj3.selectFabUserClick();
            obj3.rightSelectedUsersForFab.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
            obj3.unselectFabUserClick();
            obj3.leftSelectedUsersForFab.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
            obj3.selectFabUserClick();
            obj3.getunselectedFabUserValues();
            obj3.getselectedFabUserValues();
            obj3.addFabUsersToField();
            obj3.saveRMA();
            
            obj3.cancelTurnkeyPopUp();
            obj3.showTurnkeyPopUp();
            obj3.searchTurnkeyUser = [select Name from User where Id =: userInfo.getUserId() limit 1].Name;
            obj3.SearchTurnkeyUser();
            obj3.leftSelectedUsersForTurnkey.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
            obj3.selectTurnkeyUserClick();
            obj3.rightSelectedUsersForTurnkey.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
            obj3.unselectTurnkeyUserClick();
            obj3.leftSelectedUsersForTurnkey.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
            obj3.selectTurnkeyUserClick();
            obj3.getunselectedTurnkeyUserValues();
            obj3.getselectedTurnkeyUserValues();
            obj3.addTurnkeyUsersToField();
            obj3.saveRMA();
                        
           Test.stopTest();
    }
    
    static testMethod void myTestMethod4(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        test.startTest();
        List<RMA_Return_Invoice__c> invlist = RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        
        //updating RMA with mandatory fields
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Status__c = 'Draft';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        update rmaRec;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef1 = Page.RMA_view;
        pageRef1.getParameters().put('id', String.valueOf(rmaRec.Id));
        Test.setCurrentPage(pageRef1);
        RMA_Edit_Extension obj1 = new RMA_Edit_Extension(sc1);
        Test.setCurrentPage(pageRef1);
        obj1.checkCSR();
        obj1.enableVoid();
        obj1.cancelVoid();
        obj1.voidRMA();
        obj1.rmaRecord.Reason_to_Void__c = 'test';
        obj1.voidRMA();
        obj1.checkVoided();
        obj1.dispSectFRF();
        obj1.dispSectWaiverIssue();
        obj1.dispSectRiskProd();
        obj1.dispSectOthers();
        obj1.dispSectCAR();
        obj1.dispSectPRF();
        
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String f = util.getAllFields('RMA__c');
        String query = 'select '+f+' from RMA__c limit 1';
        List<RMA__c> rmalist = database.query(query);
        RMA__c rmaRec1 = rmaList[0];
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef2 = Page.RMA_view;
        pageRef2.getParameters().put('id', String.valueOf(rmaRec.Id));
        Test.setCurrentPage(pageRef2);
        RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
        Test.setCurrentPage(pageRef2);
        
        test.stopTest();                                                
    }
    
    static testMethod void myTestMethod5(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        test.startTest();
        List<RMA_Return_Invoice__c> invlist = RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        RMA_TestDataUtility.createRMAAttachment(rmaRec);
        
        //updating RMA with mandatory fields
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        update rmaRec;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef1 = Page.RMA_view;
        pageRef1.getParameters().put('id', String.valueOf(rmaRec.Id));
        Test.setCurrentPage(pageRef1);
        RMA_Edit_Extension obj1 = new RMA_Edit_Extension(sc1);
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef2 = Page.RMA_Edit;
        pageRef2.getParameters().put('id', String.valueOf(rmaRec.Id));
        pageRef2.getParameters().put('selTab', 'RMA_Information');
        Test.setCurrentPage(pageRef2);
        RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
        Test.setCurrentPage(pageRef2);
        
        obj2.AddReturnInvoice();
        obj2.MassUpload();
        obj2.RMArecord.Potential_Impact_Wafers__c =1;
        obj2.RMArecord.RMA_Category__c = 'Technical/ Turnkey';
        obj2.validateRMACategory();
        obj2.RMArecord.Assign_To__c = 'Turnkey';
        obj2.RMArecord.RMA_due_to_Field_reliability_Failure__c = obj2.RMArecord.RMA_related_to_Waiver_Issue__c = 
        obj2.RMArecord.Risk_Production__c = true;
        obj2.RMArecord.Remarks_Field_Reliability_Failure__c = obj2.RMArecord.Remarks_Waiver_Issue__c = 
        obj2.RMArecord.Remarks_Risk_Production__c = 'test';
        obj2.rightOptionsFRF.add(new SelectOption(invlist[0].Lot_Number__c,invlist[0].Lot_Number__c));
        obj2.rightOptionsDRW.add(new SelectOption(invlist[0].Lot_Number__c,invlist[0].Lot_Number__c));
        obj2.rightOptionsETW.add(new SelectOption(invlist[0].Lot_Number__c,invlist[0].Lot_Number__c));
        obj2.rightOptionsRP.add(new SelectOption(invlist[0].Lot_Number__c,invlist[0].Lot_Number__c));
        obj2.RMArecord.Access_Impact__c = 'Safety Impact';
        obj2.RMArecord.Description_of_Reason_s__c = 'test';
        obj2.RMArecord.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
        obj2.dispDisposition();
        obj2.rightOptionsScrapReturn.add(new SelectOption(invlist[0].Lot_Number__c,invlist[0].Lot_Number__c));
        obj2.RMArecord.Certificate_Received_Date__c = system.today() + 2;
        obj2.RMArecord.Certificate_No__c = 'AAA';
        obj2.RMArecord.Remarks_Disposition__c = 'test';
        obj2.cancelScrapPopUp();
        obj2.showScrapPopUp();
        obj2.searchScrapUser = [select Name from User where Id =: userInfo.getUserId() limit 1].Name;
        obj2.SearchScrapUser();
        obj2.getSelectedScrapUserValues();
        obj2.leftSelectedUsersForScrap.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
        obj2.selectScrapUserClick();
        obj2.addScrapUsersToField();
        obj2.SaveRMA();
        obj2.searchScrapUser = [select Name from User where Id =: userInfo.getUserId() limit 1].Name;
        obj2.SearchScrapUser();
        obj2.rightSelectedUsersForScrap.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
        obj2.unselectScrapUserClick();
        obj2.getunselectedScrapUserValues();
        obj2.getSelectedScrapUserValues();
        obj2.searchScrapUser = [select Name from User where Id =: userInfo.getUserId() limit 1].Name;
        obj2.SearchScrapUser();
        obj2.getSelectedScrapUserValues();
        obj2.leftSelectedUsersForScrap.add([select Name from User where Id =: userInfo.getUserId() limit 1].Name);
        obj2.selectScrapUserClick();
        obj2.addScrapUsersToField();
        obj2.RMArecord.Acknowledged_Wafer_Scrap__c = true;
        obj2.RMArecord.Remarks_Reason_Wafer_Scrap__c = 'test';
        obj2.SaveRMA();
        
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String f = util.getAllFields('RMA__c');
        String query = 'select '+f+' from RMA__c limit 1';
        List<RMA__c> rmalist = database.query(query);
        RMA__c rmaRec1 = rmaList[0];
                
        ApexPages.StandardController sc3 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef3 = Page.RMA_view;
        pageRef3.getParameters().put('id', String.valueOf(rmaRec1.Id));
        pageRef3.getParameters().put('currentTab', 'RMA_Information');
        Test.setCurrentPage(pageRef3);
        RMA_Edit_Extension obj3 = new RMA_Edit_Extension(sc3);
        Test.setCurrentPage(pageRef3);
        obj3.setCurrenTabNameMethod();
        
        test.stopTest();                                                
    }
    
    static testMethod void myTestMethod6(){
        Account acc = [select Id from Account limit 1][0];
        test.startTest();
        RMA_Edit_Extension con = new RMA_Edit_Extension(new ApexPages.StandardController(new RMA__c()));
        con.CreateRMA();
        test.stopTest();    
    }
    
    static testMethod void myTestMethod7(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        test.startTest();
        List<RMA_Return_Invoice__c> invlist = RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        
        //updating RMA with mandatory fields
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Status__c = 'Draft';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        update rmaRec;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef1 = Page.RMA_view;
        pageRef1.getParameters().put('id', String.valueOf(rmaRec.Id));
        Test.setCurrentPage(pageRef1);
        RMA_Edit_Extension obj1 = new RMA_Edit_Extension(sc1);
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef2 = Page.RMA_Edit;
        pageRef2.getParameters().put('id', String.valueOf(rmaRec.Id));
        pageRef2.getParameters().put('selTab', 'RMA_Information');
        Test.setCurrentPage(pageRef2);
        RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
        Test.setCurrentPage(pageRef2);
        
        obj2.onChangeOfRMABy();
        
        test.stopTest();                                                
    }
    
    static testMethod void myTestMethod8() {
           Account acc = [Select id from account limit 1][0];
           RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
           test.startTest();
           RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc); 
           
            //updating RMA with mandatory fields
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
            rmaRec.Lot_Device_FRF__c = 'testLot1';
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Assign_To__c = 'Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec1.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            update rmaRec;
            obj.sumbitForApproval();
            
            List<RMA__c> rmalist2 = database.query(query);
            RMA__c rmaRec2 = rmaList2[0];
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec2);
            PageReference pageRef2 = Page.RMA_Edit;
            pageRef2.getParameters().put('id', String.valueOf(rmaRec2.Id));
            Test.setCurrentPage(pageRef2);
            RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
            Test.setCurrentPage(pageRef2);
            obj2.RMArecord.Extension_for_Fab_validation_required__c = true;
            obj2.RMArecord.Extension_Reason__c = 'test';
            obj2.RMArecord.Number_of_Days__c = 2;
            obj2.saveRMA();
            obj2.sendRequestForExtension();
            obj2.rejectExtension();
            obj2.rejectAcknowledgement();
            
            Test.stopTest();
    }
    
    static testMethod void myTestMethod9() {
           Account acc = [Select id from account limit 1][0];
           RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
           test.startTest();
           RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc); 
           
            //updating RMA with mandatory fields
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
            rmaRec.Lot_Device_FRF__c = 'testLot1';
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Failure Analysis';
            rmaRec.Compensation_Type__c = 'No Compensation';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec1.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            update rmaRec;
            obj.sumbitForApproval();
            
            Test.stopTest();
    }
    
    static testMethod void myTestMethod10() {
           Account acc = [Select id from account limit 1][0];
           RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
           test.startTest();
           RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc); 
           
            //updating RMA with mandatory fields
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
            rmaRec.Lot_Device_FRF__c = 'testLot1';
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Failure Analysis';
            rmaRec.Compensation_Type__c = 'No Compensation';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec1.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c  = 'testLot1;';
            rmaRec.Certificate_Received_Date__c = system.today() + 2;
            rmaRec.Certificate_No__c = 'AAA';
            rmaRec.Remarks_Disposition__c = 'test';
            update rmaRec;
            obj.sumbitForApproval();
            
            Test.stopTest();
    }
    
    static testMethod void myTestMethod11() {
       Account acc = [Select id from account limit 1][0];
       RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
       test.startTest();
       RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc); 
       
       RMA_Failure_Code__c  failurecode = new RMA_Failure_Code__c();
       failurecode.Fab_Group__c = 'FAB 1';
       failurecode.Obsolete_Flag__c = false;
       failurecode.Org_Id__c = 1;
       failurecode.Scrap_Code__c = 'testcode';
       failurecode.Scrap_Description__c = 'descr';
       failurecode.Unique_Field__c = 'testcode-FAB 1';
       insert failurecode;
       
        //updating RMA with mandatory fields
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
        rmaRec.Lot_Device_FRF__c = 'testLot1';
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Business';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Status__c = 'Draft';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        update rmaRec;
        
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String f = util.getAllFields('RMA__c');
        String query = 'select '+f+' from RMA__c limit 1';
        List<RMA__c> rmalist = database.query(query);
        RMA__c rmaRec1 = rmaList[0];
        
        //Submitting RMA for Approval
        ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
        PageReference pageRef = Page.RMA_view;
        pageRef.getParameters().put('id', String.valueOf(rmaRec1.Id));
        Test.setCurrentPage(pageRef);
        RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
        Test.setCurrentPage(pageRef);
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Assign_to__c = 'Fab';
        rmaRec.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
        rmaRec.Lot_Device_Requires_Scrap_Certificate__c  = 'testLot1;';
        rmaRec.Certificate_Received_Date__c = system.today() + 2;
        rmaRec.Certificate_No__c = 'AAA';
        rmaRec.Remarks_Disposition__c = 'test';
        update rmaRec;
        obj.sumbitForApproval();
        
        List<RMA__c> rmalist2 = database.query(query);
        RMA__c rmaRec2 = rmaList2[0];
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec2);
        PageReference pageRef2 = Page.RMA_Edit;
        pageRef2.getParameters().put('id', String.valueOf(rmaRec2.Id));
        Test.setCurrentPage(pageRef2);
        RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
        Test.setCurrentPage(pageRef2);
        obj2.addFailureMode();
        obj2.hideAddFailureModeSection();
        obj2.searchTextForFailureMode = 'testcode';
        obj2.searchFailureMode();
        obj2.rmaFailureCode.Failure_Mode__c = 'testcode-descr';
        obj2.rightOptionForFailureMode.add(new SelectOption('testLot1','testLot1'));
        obj2.saveFailureMode(); 
        obj2.failureModeId = obj2.failureModeList[0].Id;
        obj2.editFailureModeLineItem();
        obj2.failureModeId = obj2.failureModeList[0].Id;
        obj2.deleteFailureModeLineItem();
        
        Test.stopTest();
    }
    
    static testMethod void myTestMethod12() {
       Account acc = [Select id from account limit 1][0];
       RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab7(1, acc); 
       test.startTest();
       List<RMA_Return_Invoice__c> lstRMAInvoice = RMA_TestDataUtility.createRMAReturnInvoiceForFab7(rmaRec, acc); 
       RMA_TestDataUtility.createRMAVendorCode(lstRMAInvoice[0].Lot_Number__c);
       
        //updating RMA with mandatory fields
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
        rmaRec.Lot_Device_FRF__c = 'testLot1';
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Business';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Status__c = 'Draft';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        update rmaRec;
        
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String f = util.getAllFields('RMA__c');
        String query = 'select '+f+' from RMA__c limit 1';
        List<RMA__c> rmalist1 = database.query(query);
        RMA__c rmaRec1 = rmaList1[0];
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(rmaRec1);
        PageReference pageRef1 = Page.RMA_view;
        pageRef1.getParameters().put('id', String.valueOf(rmaRec1.Id));
        Test.setCurrentPage(pageRef1);
        RMA_Edit_Extension obj1 = new RMA_Edit_Extension(sc1);
        Test.setCurrentPage(pageRef1);
        obj1.getVendorCodes();
        
        rmaRec1.Status__c = 'Submitted';
        rmaRec1.Workflow_Stage__c = 'Pending for Fab Validation';
        update rmaRec1;
        
        List<RMA__c> rmalist2 = database.query(query);
        RMA__c rmaRec2 = rmaList2[0];
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec2);
        PageReference pageRef2 = Page.RMA_view;
        pageRef2.getParameters().put('id', String.valueOf(rmaRec2.Id));
        Test.setCurrentPage(pageRef2);
        RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
        Test.setCurrentPage(pageRef2);
        obj2.getVendorCodes();
        
        rmaRec2.Workflow_Stage__c = 'Pending for CN Issue';
        update rmaRec2;
        
        List<RMA__c> rmalist3 = database.query(query);
        RMA__c rmaRec3 = rmaList3[0];
        
        ApexPages.StandardController sc3 = new ApexPages.StandardController(rmaRec3);
        PageReference pageRef3 = Page.RMA_view;
        pageRef3.getParameters().put('id', String.valueOf(rmaRec3.Id));
        Test.setCurrentPage(pageRef3);
        RMA_Edit_Extension obj3 = new RMA_Edit_Extension(sc3);
        Test.setCurrentPage(pageRef3);
        obj3.getVendorCodes();
        
        rmaRec3.Workflow_Stage__c = 'Voided';
        rmaRec3.Status__c = 'Voided RMA';
        update rmaRec3;
        
        List<RMA__c> rmalist4 = database.query(query);
        RMA__c rmaRec4 = rmaList4[0];
        
        ApexPages.StandardController sc4 = new ApexPages.StandardController(rmaRec4);
        PageReference pageRef4 = Page.RMA_view;
        pageRef4.getParameters().put('id', String.valueOf(rmaRec4.Id));
        Test.setCurrentPage(pageRef4);
        RMA_Edit_Extension obj4 = new RMA_Edit_Extension(sc4);
        Test.setCurrentPage(pageRef4);
        obj4.getVendorCodes();
        
        Test.stopTest();
    }    
    
    static testMethod void myTestMethod14(){
        Account acc = [select Id from Account limit 1][0];
        test.startTest();
        RMA_TestDataUtility.createInvoicesForFab9(1, acc);
        RMA_Edit_Extension con = new RMA_Edit_Extension(new ApexPages.StandardController(new RMA__c()));
        con.RMArecord.Customer__c = acc.Id;
        con.checkAccTeamProxy();
        con.RMArecord.Fab__c = 'FAB 9';
        con.checkFab();
        con.RMArecord.Customer_Request_Date__c = System.TODAY()-1;
        con.RMArecord.RMA_By__c = 'Wafer';
        con.RMArecord.Business_Unit__c = 'ASIC';
        con.RMArecord.Product_Line__c = 'ASICS';
        con.calculateBusinessCategory();
        con.RMArecord.Business_Unit__c = 'CMOS Platform';
        con.RMArecord.Product_Line__c = 'IBM Server';
        con.calculateBusinessCategory();
        con.RMArecord.Business_Unit__c = 'RF';
        con.RMArecord.Product_Line__c = 'RF';
        con.calculateBusinessCategory();
        con.RMArecord.RMA_Category__c = 'Rework';
        con.checkWarrantyForFA();
        con.RMArecord.ReasonCode__c = 'R25';
        con.CreateRMA();
        
        RMA_Edit_Extension con1 = new RMA_Edit_Extension(new ApexPages.StandardController(new RMA__c()));
        con1.RMArecord.Customer__c = acc.Id;
        con1.checkAccTeamProxy();
        con1.RMArecord.Fab__c = 'FAB 9';
        con1.checkFab();
        con1.RMArecord.Customer_Request_Date__c = System.TODAY()-1;
        con1.RMArecord.RMA_By__c = 'Module';
        con1.RMArecord.Business_Unit__c = 'ASIC';
        con1.RMArecord.Product_Line__c = 'ASICS';
        con1.calculateBusinessCategory();
        con1.RMArecord.RMA_Category__c = 'Failure Analysis';
        con1.RMArecord.Compensation_Type__c = 'No Compensation';
        con1.checkWarrantyForFA();
        con1.RMArecord.ReasonCode__c = 'R81';
        con1.isFab9or10 = true;
        con1.CreateRMA();
        test.stopTest();    
    }
    
    static testMethod void myTestMethod15(){
        Account acc = [select Id from Account limit 1][0];
        test.startTest();
        RMA_TestDataUtility.createInvoicesForFab9(1, acc);
        RMA_Edit_Extension con1 = new RMA_Edit_Extension(new ApexPages.StandardController(new RMA__c()));
        con1.RMArecord.Customer__c = acc.Id;
        con1.checkAccTeamProxy();
        con1.RMArecord.Fab__c = 'FAB 9';
        con1.checkFab();
        con1.RMArecord.Customer_Request_Date__c = System.TODAY()-1;
        con1.RMArecord.RMA_By__c = 'Module';
        con1.RMArecord.Business_Unit__c = 'ASIC';
        con1.RMArecord.Product_Line__c = 'ASICS';
        con1.calculateBusinessCategory();
        con1.RMArecord.RMA_Category__c = 'Failure Analysis';
        con1.RMArecord.Compensation_Type__c = 'No Compensation';
        con1.checkWarrantyForFA();
        con1.RMArecord.ReasonCode__c = 'R81';
        con1.CreateRMA();
        test.stopTest();    
    }
    
    static testMethod void myTestMethod16(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(1, acc); 
        test.startTest();
        List<RMA_Return_Invoice__c> invlist = RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
         
        //updating RMA with mandatory fields
        rmaRec.Compensation_Type__c = 'Credit';
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Status__c = 'Draft';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        rmaRec.Business_Unit__c = 'ASIC';
        rmaRec.Product_Line__c = 'ASIC';
        rmaRec.ReasonCode__c = 'R20';
        rmaRec.Return_Location__c = 'Burlington';
        rmaRec.Warranty__c = 12;
        update rmaRec;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef1 = Page.RMA_view;
        pageRef1.getParameters().put('id', String.valueOf(rmaRec.Id));
        Test.setCurrentPage(pageRef1);
        RMA_Edit_Extension obj1 = new RMA_Edit_Extension(sc1);
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec);
        PageReference pageRef2 = Page.RMA_Edit;
        pageRef2.getParameters().put('id', String.valueOf(rmaRec.Id));
        pageRef2.getParameters().put('selTab', 'RMA_Information');
        Test.setCurrentPage(pageRef2);
        RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
        Test.setCurrentPage(pageRef2);
        
        obj2.reportDevName = 'RMA_with_Mail_logs';
        obj2.getReportUrl();
        obj2.AddReturnInvoice();
        obj2.MassUpload();
        obj2.setReturnLocation();
        obj2.clearCarrierFields();
        obj2.RMARecord.Return_Location__c = 'APLC';
        obj2.setReturnLocation();
        obj2.dispDisposition();
        
        test.stopTest();                                                
    }
    
    static testMethod void myTestMethod17() {
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        test.startTest();
        RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc); 
        
            rmaRec.RMA_by__c = 'Module';
            update rmaRec;
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(rmaRec);
            PageReference pageRef1 = Page.RMA_view;
            pageRef1.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef1);
            RMA_Edit_Extension obj1 = new RMA_Edit_Extension(sc1);
            Test.setCurrentPage(pageRef1);
            
            List<RMA_Return_Invoice__c> invlist = [select id from RMA_Return_Invoice__c limit 1];
            obj1.LineItemToEdit = invlist[0].Id;
                                    
            obj1.EditLineItem();
            
            obj1.waferYield = '1';
            obj1.scrapLimit = '1';
            obj1.adjustedPrice = '1';
            obj1.modQuantity = '1';
            
            obj1.UpdateLineItem();
            obj1.DeleteLineItem();
        Test.stopTest();
    }
    
    static testmethod void testmethod18(){
        Account acc = [select id from account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            //updating RMA with mandatory fields
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Turnkey';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.Lot_Comments__c = 'Test Comments';
            update rmaRec;
            
            RMA_Access_User__c ra = new RMA_Access_User__c();
            ra.Category__c = 'Notify/Circulate';
            ra.RMA__c = rmaRec.Id;
            ra.User__c = UserInfo.getUserId();
            insert ra;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c where FAB__c not in (\'FAB 9\',\'FAB 10\') limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec1.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
            
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec2.Id));
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec4);
            PageReference pageRef2 = Page.RMA_view;
            pageRef2.getParameters().put('id', String.valueOf(rmaRec4.Id));
            Test.setCurrentPage(pageRef2);
            
            
        Test.stopTest();
    }
    
    static testmethod void testmethod19(){
        Account acc = [select id from account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            //updating RMA with mandatory fields
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Turnkey';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.Lot_Comments__c = 'Test Comments';
            update rmaRec;
            
            RMA_Access_User__c ra = new RMA_Access_User__c();
            ra.Category__c = 'Notify/Circulate';
            ra.RMA__c = rmaRec.Id;
            ra.User__c = UserInfo.getUserId();
            insert ra;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c where FAB__c not in (\'FAB 9\',\'FAB 10\') limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec1.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
            obj.LineItemToEditForFab = obj.lstLineItemWrapper[0].RIrec.Id;
            obj.EditLineItemForFabValidation();
            obj.UpdateLineItemForFabValidation();
            obj.CancelPopupForFab();
            
            obj.LineItemToEditForReg = obj.lstLineItemWrapper[0].RIrec.Id;
            obj.EditLineItemForRegValidation();
            obj.UpdateLineItemForRegValidation();
            obj.CancelPopupForReg();
            
            obj.showRejectionPopUp();
            obj.CancelRejection();
        
        Test.stopTest();
    }
}