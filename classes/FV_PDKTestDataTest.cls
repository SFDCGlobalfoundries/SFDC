/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class FV_PDKTestDataTest {

     public static Package__c getPackage(Account accntObj){
        
        Package__c objPck = new Package__c();
        objPck.Name = 'Test Name';
        objPck.Package_Release_Status__c = 'Release To White List';   
        objPck.Accounts_Provisioned_To__c = accntObj.Name;
        objPck.Tech_Geometry__c='0.11UM;0.13UM;';                                  
        insert objPck;
        
        return objPck;
    }
    
    // Prepare designSpec
    public static Design_Spec__c getDesignSpec(String rStatus,String sType,String name,Id pdkID,Integer otId,String techGeo){
        
        Design_Spec__c objDesignSpec = new Design_Spec__c(); 
              
        objDesignSpec.OpenText_ID__c =otId;
        objDesignSpec.Name =name+system.now();
        objDesignSpec.Document_Title__c = 'Test Title'+system.now();
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum'+system.now();       
        objDesignSpec.Revision__c = 'test rev'+system.now();
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c= 'abc';
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c =sType;// 'DRC';White Papers
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c =techGeo;
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';       
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = rStatus;
        objDesignSpec.pdk__c = pdkID;    
        
        //insert objDesignSpec;
         
        return objDesignSpec;
    }
    
    public static Design_Spec__c getPDKPatchSpec(String rStatus,String sType,String name,Id patchId,Integer otId,String techGeo){
        
        Design_Spec__c objDesignSpec = new Design_Spec__c(); 
              
        objDesignSpec.OpenText_ID__c =otId;
        objDesignSpec.Name =name+system.now();
        objDesignSpec.Document_Title__c = 'Test Title'+system.now();
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum'+system.now();       
        objDesignSpec.Revision__c = 'test rev'+system.now();
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c= 'abc;is';
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c =sType;// 'DRC';White Papers
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c =techGeo;
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';       
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = rStatus;
        objDesignSpec.PDK_Patch__c = patchId;    
        
        //insert objDesignSpec;
         
        return objDesignSpec;
    }
    
    // Prepare Account 
    
    public static Account getAccount(){
         Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('Short_Name__c', 'TAC');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'department for test class');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Austria');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Austria');  
        fieldValueMap.put('Has_Valid_NDA__c', true);
        fieldValueMap.put('Tech_Geo_Granted__c', '0.11UM;0.13UM;');
        fieldValueMap.put('Valid_Tech_Geos__c', '0.11UM; 0.13UM;');      
        fieldValueMap.put('Fab_9_10__c','No');

        return AccountDataFactory.createAccount(fieldValueMap);
        
    }
    
    // Prepare Contact
    public static Contact getContact(Account accID){
        
        Contact contact = new Contact(FirstName='Con1',
                                    LastName='Testcon1',
                                    AccountId=accID.Id,
                                    Email='con1@gf.com',
                                    Department__c='Design');
        insert contact;
        return contact;                         
    }
    
    //prepare  Master PDK
    public static Id getPdk(){
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        objPDK.PDK_DocTitle__c = '';
        objPDK.Tech_Geometry__c ='0.11UM;0.13UM;'; 
        insert objPDK;
        
        return objPDK.id;
    }
    
    // Prepare SubPDK
    public static Sub_PDK__c getSubPdk(String name, String rStatus,Id mPdkId,String bName){
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = name;
        objSubPDK.Release_Status__c = rStatus;
        objSubPDK.PDK__c = mPdkId;
        objSubPDK.Bundle_Name__c = bName+system.Now();
        //objSubPDK.tech_geometry__c = '0.11UM;0.13UM;';
        objSubPDK.Sub_PDK_OpenText_Id__c =45454545;                             
        insert objSubPDK;
        
        return objSubPDK;
    }
    
    // Prepare Document Provisioning Records
    public static document_provisioning__c getDocumentProvisioningRecords(Id pkgId,Id pdkId,Id designSpecId,Id AccId,Id userId,String status){
        
        document_provisioning__c dProvObj = new document_provisioning__c(sub_pdk__c = pdkId,status__c=status,
                                                                         Design_Spec__c=designSpecId,AccountID__c =AccId,
                                                                         NDA_Coverage__c=true,Tech_Geo_Granted_to_Account__c=true,
                                                                         design_package__c = pkgId,PdkSpecs__c='001:002;003:004',
                                                                         PDK_Provisoin_To_Updated_Specs__c='100:110',
                                                                         PDK_Failure_Specs__c='1211:222222&&errorMessage',PDK_Failure_DeProSpecs__c='1511:23332&&errorMessage1'
                                                                        );
        //insert dProvObj;                                                                 
        return dProvObj;   
    }
    
   public static White_List__c getWhiteList(Id dSpec, Id acc){
        White_List__c wl = new White_List__c();
        wl.Account__c = acc;
        wl.Design_Spec__c = dSpec;
        
        insert wl;
        return wl;
   } 
   
   public static Sub_PDK_Spec__c getSubPdkSpec(Id subPdkId,Id dSpecId, String otId){
    
        Sub_PDK_Spec__c subPdkSpec = new Sub_PDK_Spec__c();
        subPdkSpec.Design_Spec__c = dSpecId;
        subPdkSpec.Sub_PDK__c = subPdkId;
        subPdkSpec.OTID__c = otId;
        
        return subPdkSpec;
   }
   
   public static PDK_Patch__c getPdkPatch(Id pdkId){
    
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 66555;
        objPatch.PDK__c = pdkId;
        
        insert objPatch;
        
        return objPatch;
   }
}