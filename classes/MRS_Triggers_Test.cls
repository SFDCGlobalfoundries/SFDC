@isTest(seeAllData = true)
public class MRS_Triggers_Test{

// Test method for MRS_TECN_SWIFT_BINS trigger
Public static TestMethod void testMRS_TECN_SWIFT_BINS(){
      
     User IntegrationUser = [SELECT Id,Name,profileid FROM User WHERE Profile.Name like '%integration%' and isActive=true].get(0);   
    System.runAs(IntegrationUser){
    TECN__c tecn = new TECN__c(Name='testTECN',Affected_Doc__c='YI;28N;GR004',Doc_Type_ECN_Info__c='Generation;Rules;Test',
                            Originator__c='testOriginator',Related_TECN_No__c='TECN-008664',TECN_Doc_Info__c='testTECN Doc Info',
                            TECN_Mask_Layers_Number__c='OP',TECN_Mask_Set_Title__c='BAGERA1',TECN_No__c='TECN-008664',
                            TECN_Prime_Die_Name__c='All prime',TECN_Status__c='Approval Stage 1');
                            
    insert tecn;
    
    TECN__c tecn2 = new TECN__c(Name='testTECN',Affected_Doc__c='YI;28N;GR004',Doc_Type_ECN_Info__c='Generation;Rules;Test',
Originator__c='testOriginator',Related_TECN_No__c='TECN-008664',TECN_Doc_Info__c='testTECN Doc Info2',
TECN_Mask_Layers_Number__c='OP',TECN_Mask_Set_Title__c='BAGERA1',TECN_No__c='TECN-008664',
TECN_Prime_Die_Name__c='All prime',TECN_Status__c='Approval Stage 1');

insert tecn2;
    
        }
    }
// Test method for MaskWIP_SWIFT_BINS trigger
Public static TestMethod void testMaskWIP_SWIFT_BINS(){
    Mask_Set_Title__c mst1 = SwiftDataUtilityTest.createMST('MPWMST');
    insert mst1;
    Mask_WIP__c maskWIP = new Mask_WIP__c(Name='1029-52AZVIB1',Mask_Title__c='1029-52AVZqIB1',Mask_Set_Title_Text__c='MYMST',
                                          Mask_Set_Title__c=mst1.Id,Status__c='Completed');
     
    insert maskWIP;
    }                               
}