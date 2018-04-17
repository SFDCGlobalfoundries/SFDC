/*****************************************************
*   Author: Amrita Agarwala
*   Description: Test class for CPQFeatureDescriptionSearchController

*   History:
*       Aagarwala          10/27/2016     - code creation.
*     
*****************************************************/
@isTest(SeeAllData=false)
private class CPQFeatureDescSearchControllerTest{
    @testSetup
     static void testDataSetup(){
          CPQFeatureDescSearchControllerTest.createBundleProduct( );
          CPQFeatureDescSearchControllerTest.createProduct('nfet', 'Regular-Vt NFET' );
          CPQFeatureDescSearchControllerTest.createProduct('pfet', 'Regular-Vt PFET' );
          CPQFeatureDescSearchControllerTest.createProduct('RF_pfet', 'RF_Regular-Vt PFET' );
     }
      
      static String testPT = 'PT001010';
      
      static Process_Technology__c createPT(){
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'PT001010';
        pt.IP_Geometry_Technology__c = '14G;14LPP'; 
        pt.Tech_Geometry__c ='0.014UM';
        insert pt;
        return pt;   
    }
    
    static Product2 createBundleProduct(){
       Product2 p = new Product2 ();
       p.Name = '14LPP - Low Power ';
       
       p.family = 'PTs';
       p.geometry__c = '0.014UM';
       p.PT_Number__c = 'PT001010';
       p.ProductCode = '14LPP_' + testPt ;
       p.Product_External_ID__c = p.ProductCode ;
       
       insert p;
       return p;
    }
    
    
    static Product2 createProduct( String model , String Name ){
       Product2 p = new Product2 ();
       p.Name = Name  ; 
       p.description = model;
       p.family = 'devices';
       p.ProductCode = '14LPP_' + testPt + '_'+ model;
       p.Product_External_ID__c = p.ProductCode ;
       
       insert p;
       return p;
    }
    static testMethod void testClearDataButton(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
            
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.modelNameInput = 'nfet';
           testFeature.getSearchResult();
           testFeature.clearData();
           Integer size = testFeature.searchResult.size();
           System.assertEquals(size, 0);
           test.stopTest();
    
    }
     static testMethod void testGetSearchResultForEmptyInput(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
            
           testFeature.selectedPT = '14LPP_' + testPT ;
           testFeature.getSearchResult();
           integer len = testFeature.searchResult.size();
           system.assertEquals(len>0, true);
        
           test.stopTest();
    
    }
    static testMethod void testGetSearchResultForInvalidInput(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
            
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.modelNameInput = 'cmos';
           testFeature.getSearchResult();
            
           Integer size = testFeature.searchResult.size();
           System.assertEquals(size, 0);
        
           test.stopTest();
    
    }
    
    
    static testMethod void testGetSearchResultForModelNameInput(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
            
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.modelNameInput = 'nfet';
           testFeature.getSearchResult();
           integer len = testFeature.searchResult.size();
           system.assertEquals(len == 1, true);
       
           test.stopTest();
    
    }
    static testMethod void testGetSearchResultForMultipleModelNameAdd(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
            
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.modelNameInput = 'nfet';
           testFeature.getSearchResult();
           testFeature.modelNameInput = 'pfet';
           testFeature.getSearchResult();
           integer len = testFeature.searchResult.size();
           system.assertEquals(len == 3, true);
           test.stopTest();
    
    }
    static testMethod void testGetSearchResultForSpecialCharacters(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
            
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.modelNameInput = '_P';
           testFeature.getSearchResult();
           integer len = testFeature.searchResult.size();
           system.assertEquals(len>0, true);
           
           testFeature.cleardata();
           testFeature.modelNameInput = '\\P';
           testFeature.getSearchResult();
           len = testFeature.searchResult.size();
           system.assertEquals(len>0, false);
           
           testFeature.cleardata();
           testFeature.modelNameInput = '%P';
           testFeature.getSearchResult();
           len = testFeature.searchResult.size();
           system.assertEquals(len>0, false);
        
           test.stopTest();
    
    }
    
    static testMethod void testGetSearchResultForXMLInput(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
           String myString = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Package xmlns="http://soap.sforce.com/2006/04/metadata">    <devices>         <device>nfet</device>        <device>lvtnfet</device>        <device>lvtpfet</device>    </devices></Package>';
           Blob myBlob = Blob.valueof(myString);
           
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.body = myBlob;
           testFeature.filename = 'sample.xml';
           testFeature.getSearchResult();
           integer len = testFeature.searchResult.size();
           system.assertEquals(len>0, true);
           
           test.stopTest();
    
    }
    static testMethod void testFirstbtn(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
           String myString = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Package xmlns="http://soap.sforce.com/2006/04/metadata">    <devices>         <device>nfet</device>        <device>lvtnfet</device>        <device>lvtpfet</device>    </devices></Package>';
           Blob myBlob = Blob.valueof(myString);
           
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.body = myBlob;
           testFeature.filename = 'sample.xml';
           testFeature.getSearchResult();
           
           testFeature.Firstbtn();
           System.assertEquals(testFeature.paginationSearchResults.size(), 3);
       
           test.stopTest();
    
    }
    static testMethod void testGeneratePDF(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
           String myString = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Package xmlns="http://soap.sforce.com/2006/04/metadata">    <devices>         <device>nfet</device>        <device>lvtnfet</device>        <device>lvtpfet</device>    </devices></Package>';
           Blob myBlob = Blob.valueof(myString);
           
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.body = myBlob;
           testFeature.filename = 'sample.xml';
           testFeature.getSearchResult();
           
           testFeature.SearchResult[0].isSelected  = true;
           
           PageReference pageRef = Page.CPQFeatureDescriptionSearchPage;
           Test.setCurrentPage(pageRef);
           testFeature.generatePDF();
           test.stopTest();
    
    }
    
      static testMethod void testSelectAllButton(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
           String myString = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Package xmlns="http://soap.sforce.com/2006/04/metadata">    <devices>         <device>nfet</device>        <device>lvtnfet</device>        <device>lvtpfet</device>    </devices></Package>';
           Blob myBlob = Blob.valueof(myString);
           
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.body = myBlob;
           testFeature.filename = 'sample.xml'; 
           testFeature.getSearchResult();
           
           testFeature.selectAllcheckbox = true;
           testFeature.selectall();
           
           system.assertEquals(testFeature.SearchResult[0].isSelected , true);
           system.assertEquals(testFeature.SearchResult[1].isSelected , true);
           system.assertEquals(testFeature.SearchResult[2].isSelected , true);
           
           testFeature.selectAllcheckbox = false;
           testFeature.selectall();
           
           system.assertEquals(testFeature.SearchResult[0].isSelected , false);
           system.assertEquals(testFeature.SearchResult[1].isSelected , false);
           system.assertEquals(testFeature.SearchResult[2].isSelected , false);
           test.stopTest();
    
    }
    static testMethod void testonSelectedGeometry(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
            
           testFeature.selectedGeometry = '0.014UM' ; 
           testFeature.onSelectedGeometry();
           integer len = testFeature.items.size();
           system.debug('>>>len  = '+len );
           system.assertEquals(len >0 , true);
           test.stopTest();
    
    }
     static testMethod void testGetNext(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
           String myString = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Package xmlns="http://soap.sforce.com/2006/04/metadata">    <devices>         <device>nfet</device>        <device>lvtnfet</device>        <device>lvtpfet</device>    </devices></Package>';
           Blob myBlob = Blob.valueof(myString);
           
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.body = myBlob;
           testFeature.filename = 'sample.xml';
           testFeature.getSearchResult();
           boolean res = testFeature.getnext();
           system.assertEquals(res , true);
       
           test.stopTest();
    
    }
    static testMethod void testgetprev(){
           test.startTest();
           CPQFeatureDescriptionSearchController testFeature= new CPQFeatureDescriptionSearchController();
           String myString = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Package xmlns="http://soap.sforce.com/2006/04/metadata">    <devices>         <device>nfet</device>        <device>lvtnfet</device>        <device>lvtpfet</device>    </devices></Package>';
           Blob myBlob = Blob.valueof(myString);
           
           testFeature.selectedPT = '14LPP_' + testPT ;       
           testFeature.body = myBlob;
           testFeature.filename = 'sample.xml';
           testFeature.getSearchResult();
           boolean res = testFeature.getprev();
           system.assertEquals(res , true);
       
           test.stopTest();
    
    }
    
    

}