/*
    Author: Pradosh Samal
    Description: Apex class for PickAllKerfMapPage
    History: 
        Psamal      03302017    - Apex coded created
        Psamal      04122017    - Changes for Kerf map
        Psamal      05032017    - Changes for Part number and EC number filter
        Psamal      05082017    - Changes for Error message
*/
public with sharing class PickAllKerfMapController{
    
    public String pickAllPartNumber                  {get;set;}
    public String pickAllECNumber                    {get;set;}
    public Boolean showPickAllMapDownloadLink        {get;set;}
    public ContentDocument pickAllMapContentDocument {get;set;}

    public String kerfMapPartNumber    {get;set;}
    public String kerfMapECNumber      {get;set;}
    public Boolean showKerfMap  {get;set;}
    public List<List<Integer>> xyCoordinateList {get;set;}
    
    public PickAllKerfMapController(){
        
        showPickAllMapDownloadLink = FALSE;
        showKerfMap = FALSE;
    }
    
    public PageReference downloadPickAllMap(){
        try{
            showPickAllMapDownloadLink = FALSE;
            pickAllMapContentDocument = NULL;
            
            Boolean isError = FALSE;
            
            if(pickAllPartNumber == NULL || (pickAllPartNumber != NULL && pickAllPartNumber.trim().length() < 1)){
                
                isError = TRUE;
                Error_Codes__c errorCodes = Error_Codes__c.getInstance('PICK_ALL_MAP_PART_NUMBER_VALIDATION');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorCodes.Message__c));
            }
            
            if(pickAllECNumber == null || (pickAllECNumber != NULL && pickAllECNumber.trim().length() < 1)){
                
                isError = TRUE;
                Error_Codes__c errorCodes = Error_Codes__c.getInstance('PICK_ALL_MAP_EC_NUMBER_VALIDATION');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorCodes.Message__c));
            }
            
            if(isError){
                return NULL;
            }
            
            String query = 'SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument USING SCOPE EVERYTHING WHERE Title = \'PickAll_' + pickAllPartNumber + '_' + pickAllECNumber + '\' OR Title = \'00000' + pickAllPartNumber + '.' + pickAllECNumber + '\' OR Title = \'00000' + pickAllPartNumber + '_' + pickAllECNumber + '\'';
            
            List<ContentDocument> kerfMapList = (List<ContentDocument>)Database.query(query);
            if(kerfMapList.size() > 0){
                pickAllMapContentDocument = kerfMapList.get(0);
                showPickAllMapDownloadLink = TRUE;
            }
            else{
                Error_Codes__c errorCodes = Error_Codes__c.getInstance('PICK_ALL_MAP_NOT_FOUND');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, errorCodes.Message__c));
                return NULL;
            }
        }
        catch(Exception e){
            GlobalUtility.logMessage('Error', 'PickAllKerfMapController', 'downloadPickAllMap', '', '', e.getMessage(), '', 'Pick All Map', e, 0);
            Error_Codes__c errorCodes = Error_Codes__c.getInstance('PICK_ALL_MAP_EXCEPTION');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorCodes.Message__c));
        }
        return NULL;
    }
    
    public PageReference showKerfMap() {
        try{
            showKerfMap = FALSE;
            xyCoordinateList = new List<List<Integer>>();
            
            Boolean isError = FALSE;
            
            if(kerfMapPartNumber == null || (kerfMapPartNumber != NULL && kerfMapPartNumber.trim().length() < 1)){
                
                isError = TRUE;
                Error_Codes__c errorCodes = Error_Codes__c.getInstance('KERF_MAP_PART_NUMBER_VALIDATION');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorCodes.Message__c));
            }
            
            if(kerfMapECNumber == null || (kerfMapECNumber != NULL && kerfMapECNumber.trim().length() < 1)){
                
                isError = TRUE;
                Error_Codes__c errorCodes = Error_Codes__c.getInstance('KERF_MAP_EC_NUMBER_VALIDATION');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorCodes.Message__c));
            }
            
            if(isError){
                return NULL;
            }
            
            String validPartNumber;
            String validECNumber;
            
            if(kerfMapPartNumber.length() < 12){
                validPartNumber = '00000' + kerfMapPartNumber;
            }
            else{
                validPartNumber = kerfMapPartNumber;
            }
            
            if(kerfMapECNumber.length() < 11){
                validECNumber = '10000' + kerfMapECNumber;
            }
            else{
                validECNumber = kerfMapECNumber;
            }
            
            String query = 'SELECT Id, Mask_Set_Id__c, Kerf_Die_X__c, Kerf_Die_Y__c FROM KERF_Map__c WHERE Mask_Set_Id__c = \'' + validPartNumber + '.' + validECNumber + '\'';
            
            List<KERF_Map__c> kerfMapList = (List<KERF_Map__c>)Database.query(query);
            
            if(kerfMapList.size() > 0){
                
                List<Integer> tempList;
                for(KERF_Map__c obj : kerfMapList){
                    
                    tempList = new List<Integer>();
                    tempList.add(Integer.valueOf(obj.Kerf_Die_X__c));
                    tempList.add(Integer.valueOf(obj.Kerf_Die_Y__c));
                    tempList.add(0);
                    
                    xyCoordinateList.add(tempList);
                }
                showKerfMap = TRUE;
            }
            else{
                Error_Codes__c errorCodes = Error_Codes__c.getInstance('KERF_MAP_NO_COORDINATES');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorCodes.Message__c));
                return NULL;
            }
        }
        catch(Exception e){
            GlobalUtility.logMessage('Error', 'PickAllKerfMapController', 'showKerfMap', '', '', e.getMessage(), '', 'Kerf Map', e, 0);
            Error_Codes__c errorCodes = Error_Codes__c.getInstance('KERF_MAP_EXCEPTION');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorCodes.Message__c));
        }
        return NULL;
    }
}