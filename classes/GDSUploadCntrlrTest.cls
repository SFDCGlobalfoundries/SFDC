/*
    Author: Ariz Solito
    Description: Apex test class for the GDSUpload
    History: 
        Asolito     20102014    - Code creation.
*/

@isTest
private class GDSUploadCntrlrTest {
	@testSetup static void testdata() {
            DataUtilTest.loadEnvironmentVariables();
        }
    static testMethod void testFileUpload(){
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        /*Apttus_Proposal__Proposal__c rec = [SELECT id 
                                              FROM Apttus_Proposal__Proposal__c
                                              WHERE mask_set__c <> null
                                              AND Multi_Source_Tapeout_Approval_Stage__c = 'Draft'
                                              LIMIT 1];*/
        Id accId = DeviceUtilTest.createAccount();
        
         Apttus_Proposal__Proposal__c rec = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c='Test Config', Apttus_Proposal__Account__c = accId, Multi_Source_Tapeout_Approval_Stage__c  = 'Draft', mask_set_long__c = 'RS BV XP');
         insert rec;
                                                    
         /*for(Apttus_Proposal__Proposal__c recLst : [SELECT id,mask_set_long__c FROM Apttus_Proposal__Proposal__c WHERE Multi_Source_Tapeout_Approval_Stage__c = 'Draft']){
            if(recLst.mask_set_long__c <> null && recLst.mask_set_long__c.length() > 0)
                rec = recLst;
            break;
         }*/
        test.startTest();
                
        PageReference pageRef = Page.GDSUpload;                 
        pageRef.getParameters().put('id',rec.id);
        Test.setCurrentPageReference(pageRef);
        
        GDSUploadCntrlr ctrl = new GDSUploadCntrlr();
        ctrl.init();   
        
        //create dummy GDS data wrong format
        String data = 'Stream File\n';
        ctrl.contentFile = Blob.valueOf(data);
        ctrl.uploadGDS();
        
        //create dummy GDS data with validation errors
        String data2 = 'Stream File\n' +
                      '=============================== \n' +
                      'File Name:        DUMMY_FILE_NAME.strm.gz \n' +
                      'Format:           gds \n' +
                      'Layout Information (Pre-Shrink) \n' +
                      '=============================== \n' +
                      'Top Cell Name:    DUMMY_TOP \n' +
                      'Cell Lower-Left:  0.000000,0.000000 \n' +
                      'Layer Information \n' +
                      '=============================== \n' +
                      'LAYER   DATATYPE                 NAME              PURPOSE \n' +
                      '1                          DWL                drawing \n' +
                      '2          0                NWELL              drawing \n' +
                      '2          0                NWELL              drawing \n' +
                      '3          0                NWELL              drawing \n' +
                      'a          0                NWELL              drawing \n' +
                      'Waived Errors \n'+
                      '===============================';
        
        ctrl.contentFile = Blob.valueOf(data2);
        ctrl.uploadGDS();
        
        
        //create dummy GDS data with correct data     
        String data3 = 'Stream File\n' +
                      '=============================== \n' +
                      'File Name:        DUMMY_FILE_NAME.strm.gz \n' +
                      'Format:           gds \n' +
                      'Layout Information (Pre-Shrink) \n' +
                      '=============================== \n' +
                      'Top Cell Name:    DUMMY_TOP \n' +
                      'Cell Lower-Left:  0.000000,0.000000 \n' +
                      'Layer Information \n' +
                      '=============================== \n' +
                      'LAYER   DATATYPE                 NAME              PURPOSE \n' +
                      '1          0                DWL                drawing \n' +
                      '2          0                NWELL              drawing \n' +
                      'Waived Errors \n'+
                      '===============================';
        
        ctrl.contentFile = Blob.valueOf(data3);
        ctrl.uploadGDS();                       
        
        test.stopTest();                                                                    
    }
    
    static testMethod void testGDSCreation(){                
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        /*Apttus_Proposal__Proposal__c rec = [SELECT id 
                                              FROM Apttus_Proposal__Proposal__c
                                              WHERE mask_set__c <> null
                                              AND Multi_Source_Tapeout_Approval_Stage__c = 'Draft'
                                              LIMIT 1];*/
                                                      
         Id accId = DeviceUtilTest.createAccount();
         
         Apttus_Proposal__Proposal__c rec = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c='Test Config', Apttus_Proposal__Account__c = accId, Multi_Source_Tapeout_Approval_Stage__c  = 'Draft', mask_set_long__c = 'RS BV XP');
         insert rec;
                                                  
         /*(for(Apttus_Proposal__Proposal__c recLst : [SELECT id,mask_set_long__c FROM Apttus_Proposal__Proposal__c WHERE Multi_Source_Tapeout_Approval_Stage__c = 'Draft']){
            if(recLst.mask_set_long__c <> null && recLst.mask_set_long__c.length() > 0)
                rec = recLst;
            break;
         }*/
         
        test.startTest();
                
        PageReference pageRef = Page.GDSUpload;                 
        pageRef.getParameters().put('id',rec.id);
        Test.setCurrentPageReference(pageRef);
        
        GDSUploadCntrlr ctrl = new GDSUploadCntrlr();
        ctrl.init();                   
                
        //create dummy GDS data with correct data     
        String data = 'Stream File\n' +
                      '=============================== \n' +
                      'File Name:        DUMMY_FILE_NAME.strm.gz \n' +
                      'Format:           gds \n' +
                      'Layout Information (Pre-Shrink) \n' +
                      '=============================== \n' +
                      'Top Cell Name:    DUMMY_TOP \n' +
                      'Cell Lower-Left:  0.000000,0.000000 \n' +
                      'Layer Information \n' +
                      '=============================== \n' +
                      'LAYER   DATATYPE                 NAME              PURPOSE \n' +
                      '1          0                DWL                drawing \n' +
                      '2          0                NWELL              drawing \n' +
                      'Waived Errors \n'+
                      '===============================';
        
        ctrl.contentFile = Blob.valueOf(data);
        ctrl.uploadGDS();
        
        //move page
        ctrl.pageNum = 1;
        ctrl.movePage();
        
        //add new layer2
        ctrl.addLayer();
        ctrl.addLayer();        
        
        //delete added layer
        ctrl.deleteNewRow = '1';
        ctrl.deleteNewLayer();
        
        //delete loaded layer
        ctrl.deleteRow = '1';
        ctrl.deleteLayer();
        
        
        ctrl.masterlist.addedLayers[0].layerNumber = '10';
        ctrl.masterlist.addedLayers[0].layerDataType = 'a';
        ctrl.masterlist.addedLayers[0].name = 'QWE';
        ctrl.masterlist.addedLayers[0].purpose = 'fill';
        
        //save new GDS with new Layer row validation error
        ctrl.save();
        
        //save new GDS with no errors
        ctrl.masterlist.addedLayers[0].layerDataType = '0';
        ctrl.save();
        
        //load a new GDS with existing data
        //create dummy GDS data with correct data     
        String data2 ='Stream File\n' +
                      '=============================== \n' +
                      'File Name:        DUMMY_FILE_NAME.strm.gz \n' +
                      'Format:           gds \n' +
                      'Layout Information (Pre-Shrink) \n' +
                      '=============================== \n' +
                      'Top Cell Name:    DUMMY_TOP \n' +
                      'Cell Lower-Left:  0.000000,0.000000 \n' +
                      'Layer Information \n' +
                      '=============================== \n' +
                      'LAYER   DATATYPE                 NAME              PURPOSE \n' +
                      '1          0                DWL                drawing \n' +
                      '2          0                NWELL              drawing \n' +
                      'Waived Errors \n'+
                      '===============================';
        
        ctrl.contentFile = Blob.valueOf(data2);
        ctrl.uploadGDS();
        
        //overwrite old GDS with the new upload
        ctrl.save();
        ctrl.cancel();
        String stat  = ctrl.status;
        String filName = ctrl.fileName;
        String topCelName = ctrl.topCellName;
        String GDSUploadStep = ctrl.GDSUploadStep;
        String GDSApproveStep = ctrl.GDSApproveStep;
        String id2  = ctrl.id2;
        String id3  = ctrl.id3;
        String id4  = ctrl.id4;   
        String translatedRowCount  = ctrl.translatedRowCount;
        
        //translate the GDS
        ctrl.translate();
        
        PageReference pg = ctrl.back();
        
        pg = ctrl.backtoGDS();
        
        pg = ctrl.backtoTranslate(); 
        
        test.stopTest();                                                                    
    }
    
}