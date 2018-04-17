/*
    Author: Ariz Solito
    Description: Test class for DatamartMLGPlusService 
    History: 
    Asolito      09/07/2016    - Apex code created
*/

@isTest(SeeAllData=false)
public class DatamartMLGPlusServiceTest {

    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();        
    }    

    static testMethod void testClass(){
        DatamartMLGPlusService.MLGPlus header = new DatamartMLGPlusService.MLGPlus();
        header.geometry = '0.28UM';
        header.parentProductName = '28TEST';
        header.parentProductName = '28TEST';
        header.status = 'Unprocessed';
        header.catalogType = 'First Source';
        header.fromDatamart = true;
        header.isFinal = true;
        header.processedVersion = '2.0';
        header.parentProductExternalID = '28TEST';
        
        DatamartMLGPlusService.MLGRecord feature1 = new DatamartMLGPlusService.MLGRecord();
        feature1.serialNumber = 1;
        feature1.modelName = 'f1';
        feature1.version = '#2.0#';
        feature1.featureGroup = 'CAPACITOR';
        feature1.featureDescription = 'desc';
        feature1.additionalMasks = 'AM';
        feature1.FEOLBEOL = 'FEOL';
        feature1.voltage = '1.2';
        
        DatamartMLGPlusService.MLGRecord feature2 = new DatamartMLGPlusService.MLGRecord();
        feature1.serialNumber = 2;
        feature1.modelName = 'f2';
        feature1.version = '#2.0#';
        feature1.featureGroup = 'IO FET';
        feature1.featureDescription = 'desc';
        feature1.additionalMasks = 'BA';
        feature1.FEOLBEOL = 'FEOL';
        feature1.voltage = '1.2';
        
        List<DatamartMLGPlusService.MLGRecord> feaures = new list<DatamartMLGPlusService.MLGRecord>{
            feature1,feature2 
        };     
        
        //call inbound method for new MLG PLus record
        DatamartMLGPlusService.syncDatamart(header,feaures);
        DatamartMLGPlusService.logError('test','test');
                
        CPQ_MLGPlus__c rec = new CPQ_MLGPlus__c(
            geometry__c = '0.28UM',
            parent_product_name__c = '28TEST',
            process_technology__c = '28TEST',
            status__c = 'Unprocessed',
            catalog_type__c = 'First Source',
            from_datamart__c = true,
            final__c = true,
            processed_version__c = '2.0',
            parent_product_external_ID__c = '28TEST'
        );
        upsert rec parent_product_external_ID__c;
        
        MLG_Record__c r = new MLG_Record__c(
            feature_group__c = 'CAPACITOR',
            IO_voltage_v__c = '1.2',            
            feature_description__c = 'desc',
            model_name__c = 'f1',
            additional_mask_s__c = 'AM',
            FEOL_BEOL__c = 'FEOL',
            CPQ_MLGPlus__c = rec.id,
            version__c = '#1.0#',
            serial_number__c = 1   
        );
        insert r;
        
        //update on existing MLG PLus record
        DatamartMLGPlusService.syncDatamart(header,feaures);
        
    }
}