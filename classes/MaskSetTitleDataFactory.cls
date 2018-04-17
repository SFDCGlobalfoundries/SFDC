/**
* Author: GF
* Project: Test Class Automation  
* Description: This data factory class will be used to create MaskSetTitle data in different Test classes
**/

@isTest
public class MaskSetTitleDataFactory
{
    /* Method to create MaskSetTitle Test Data record Dynamically*/
    public static List<Mask_Set_Title__c> createMaskSetTitles(List<Map<String,Object>> fieldValueMaps,Integer numMSTs)    
    {
        // Validate parameters
        if (fieldValueMaps != null && fieldValueMaps.size() != numMSTs)
        {
            throw new DataFactoryException ('FieldValueMap Size must be equal to number of MSTs you want to create.');
        }
        
        List<Mask_Set_Title__c> mstList = new List<Mask_Set_Title__c>();
        
        for(Integer i=0;i<numMSTs;i++)                    
        {
            Mask_Set_Title__c mst = new Mask_Set_Title__c(Reticle_Type__c='IT',
                    Description__c = 'Test Description for MST'+i,
                    Synced_with_Oracle_DB__c = false,
                    Status__c = 'Active',
                    Is_Available_For_Use__c = true,
                    Manual_Creation__c = false
                    );    
            if (fieldValueMaps != null)
            {      
                Map<String,Object> fieldValueMap = fieldValueMaps.get(i);
                for(String fieldName: fieldValueMap.keySet())
                {
                    mst.put(fieldName, fieldValueMap.get(fieldName));        
                }
            }
            mstList.add(mst);    
        }
        
        insert mstList;
        
        return mstList;
    }
          
    /* Method to create one MaskSetTitle Test Data record Dynamically*/
    public static Mask_Set_Title__c createMaskSetTitle(Map<String,Object> fieldValueMap)
    {
        // Create MaskSetTitle with default data that is required, this will handle cases where required fields are not set
        Mask_Set_Title__c mst = new Mask_Set_Title__c(Reticle_Type__c='IT',
                    Description__c = 'Test Description for MST',
                    Synced_with_Oracle_DB__c = false,
                    Status__c = 'Active',
                    Is_Available_For_Use__c = true,
                    Manual_Creation__c = false
                    );         
              
        for(String fieldName: fieldValueMap.keySet())
        {
            mst.put(fieldName, fieldValueMap.get(fieldName));        
        }

        insert mst;
            
        return mst;
    }

    /* Method to create one MaskSetTitle Test Data record Dynamically*/
    public static Mask_Set_Title__c createMaskSetTitle1(Map<String,Object> fieldValueMap){
        
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        
        for(String fieldName: fieldValueMap.keySet()){
        
            mst.put(fieldName, fieldValueMap.get(fieldName));        
        }

        insert mst;
            
        return mst;
    }
    
    /* Method to create one MaskSetTitle Test Data record Dynamically with given Mask Set Title name*/
    public static Mask_Set_Title__c createMaskSetTitle(String mstName) { 
        
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = mstName;
        mst.Description__c = 'Test Description for MST';
        mst.Synced_with_Oracle_DB__c = false;
        mst.Status__c = 'Active';
        mst.Is_Available_For_Use__c = true;
        mst.Manual_Creation__c = false;
        mst.Reticle_Type__c = 'Single Layer Reticle (SLR)';
        
        insert mst;
        
        return mst;
    }
    
    public static List < Mask_Set_Title__c > maskSetTitleList(integer iNumberOfMST) {
        
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        List < Mask_Set_Title__c > mstList = new List < Mask_Set_Title__c > ();
        for (Integer iCount = 0; iCount < iNumberOfMST; iCount++) {
            mst = new Mask_Set_Title__c(Name = 'MYMST0' + String.valueOf(iCount),
                Description__c = 'Test Description for MST',
                Status__c = 'Active',
                Is_Available_For_Use__c = true,
                Reticle_Type__c = 'Single Layer Reticle (SLR)');
            mstList.add(mst);
        }
        insert mstList;
        
        return mstList;
    }
}