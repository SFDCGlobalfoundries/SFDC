/*
     @class: FMS_HierarchyLogic
     @CreatedBy: Inshu Misra
     @CreatedDate: 15 Sep, 2016
     @Description: To display the FMS document links...#IM
     @Modifications-
     * 17/10/2016 - Abhita Bansal - Added the code for training Material on main page.
     * 28/11/2016 - Inshu Misra - Modified to have the file link instead of document link for training material on Main page and optimized the code...#IM
 */
public class FMS_HierarchyLogic{
    
    public FMS_HierarchyLogic(ApexPages.StandardController controller){
        
    }
    
    public static List<String> getDependentFieldsToReset(String parentAPI,Form_Management_System__c formObj,String formType){
        if(parentAPI != NULL && parentAPI != '' && formObj!=null && formType!=null && formType!=''){
            Set<String> dependentFields = new Set<String>();
            Map<String,String> mapAPIvsVariable = new Map<String,String>();
            List<String> lstVariablesToReset = new List<String>();
            dependentFields.add(parentAPI);
            for(FMS_Control_Table__c cr: [SELECT Id,Controlling_Field_1_API__c,Dependent_Field_1_API__c,Level__c
                                         FROM FMS_Control_Table__c 
                                         WHERE   Type__c = 'Field Hierarchy'
                                         AND Type_of_Form__c = :formType
                                         ORDER BY Level__c ASC]){
                if(dependentFields.contains(cr.Controlling_Field_1_API__c)){
                    dependentFields.add(cr.Dependent_Field_1_API__c);
                }
            }
            
            dependentFields.remove(parentAPI);            
            
            //for re-setting the field values
            for(FMS_Control_Table__c ct: [SELECT Id,Controlling_Field_1_API__c,Controlling_Field_1_Value__c
                                          FROM FMS_Control_Table__c WHERE Type__c = 'Variable Mapping']){
                mapAPIvsVariable.put(ct.Controlling_Field_1_API__c,ct.Controlling_Field_1_Value__c);
            }
            for (String fieldToReset: dependentFields){
                formObj.put(fieldToReset,NULL);
                if(mapAPIvsVariable != NULL && mapAPIvsVariable.get(fieldToReset) != NULL && mapAPIvsVariable.get(fieldToReset) != ''){
                    lstVariablesToReset.add(mapAPIvsVariable.get(fieldToReset));
                }
            }
            return lstVariablesToReset;
        }else{
            return NULL;
        }
    }
    
}