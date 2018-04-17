/*
    Author: Shyam Ravindra Nair
    Description: This serves as the controller for MPWGMPLProjectNameCustomLookupVF.
    History: 
        SNair   06102015    - Code creation.
*/
public class MPWGMPLProjectNameCustomLookupController {
    public String geometry{get;set;}
    public String geometryId{get;set;}
    public String sSearchInput{get;set;}
    public String searchStr{get;set;}
    public List<GMPL_BX009__c> gmplList{get;set;}
    public List<MPW_Geometry_Mapping__c> mpwgmList{get;set;}
    public Map<String, MPW_Geometry_Mapping__c> mpwgmMap{get;set;}
    public UtilClassToGetAllFields util{get;set;}
    public boolean b_DisplayMinSearchCharacterMessage {get;set;}
    public boolean b_DisplayZeroSearchResultMessage {get;set;}
    public boolean b_DisplayGMPLRecords {get;set;}
    public boolean b_DisplayRecentRecords {get;set;}
    public String s_PageBlockTableTitle {get; set;}
    public static final String TABLE_TITLE_1 = 'Recent GMPL Project Name';
    public static final String TABLE_TITLE_2 = 'Search GMPL Project Name';
    
    public MPWGMPLProjectNameCustomLookupController(){
        b_DisplayMinSearchCharacterMessage = false;
        b_DisplayZeroSearchResultMessage = false;
        b_DisplayGMPLRecords = false;
        b_DisplayRecentRecords = false;
        s_PageBlockTableTitle = TABLE_TITLE_1;
        geometry = ApexPages.currentPage().getParameters().get('geo');
        searchStr = ApexPages.currentPage().getParameters().get('sear');
        this.mpwgmList = new List<MPW_Geometry_Mapping__c>();
        this.mpwgmMap = new Map<String, MPW_Geometry_Mapping__c>();
        String soql = 'select Name, Geometry_ID__c, Sequence_No__c, Active__c, Use_Process_Type__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc';
        this.mpwgmList = database.query(soql);
        for(MPW_Geometry_Mapping__c mpwgm: this.mpwgmList){
            this.mpwgmMap.put(mpwgm.Name, mpwgm);
        }
        geometryId = this.mpwgmMap.get(geometry).Geometry_ID__c;
        if(searchStr != null){
            sSearchInput = searchStr;
            searchGMPL();
        }
        else{
            List<Id> recentlyViewedGMPLList = new List<Id>(new Map<Id,RecentlyViewed>([select Id from RecentlyViewed where Type = 'GMPL_BX009__c' 
                                                            order by LastReferencedDate desc limit 5]).keySet());
            String recentlyViewedQuery = 'select Id, Name, Geometry__c from GMPL_BX009__c where Id IN : recentlyViewedGMPLList order by Name desc limit 5';
            gmplList = database.query(recentlyViewedQuery);
            if(!gmplList.isEmpty()){
                b_DisplayRecentRecords = true;
                s_PageBlockTableTitle = TABLE_TITLE_1;  
            }
        }
    }
    
    public pageReference searchGMPL(){
        b_DisplayRecentRecords = false;
        b_DisplayMinSearchCharacterMessage = false;
        b_DisplayZeroSearchResultMessage = false;
        gmplList = new List<GMPL_BX009__c>();
        if(sSearchInput!=null){
            sSearchInput = sSearchInput.replace('*','');
        }
        else{
            b_DisplayMinSearchCharacterMessage = true;
            return null;
        }
        
        if(sSearchInput.trim()==''|| sSearchInput==null){
            b_DisplayMinSearchCharacterMessage = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'Error: Please enter a search string at least 2 characters long.'));
        }
        else if (sSearchInput.trim().length()<2){
            b_DisplayMinSearchCharacterMessage=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'Error: Please enter a search string at least 2 characters long.'));
        }
        else{
            b_DisplayMinSearchCharacterMessage = false;
            sSearchInput = '%'+sSearchInput.trim()+'%';
            String geo = '';
            geo = geometryId.removeEnd('UM');
            Decimal geoInt = Decimal.valueOf(geo);
            geoInt = geoInt * 1000;
            Integer geoInt2 = Integer.valueOf(geoInt);
            String finalgeo = String.valueOf(geoInt2);
            String searchQuery = '';
            /*searchQuery = 'select Id, Name, Geometry__c from GMPL_BX009__c where Geometry__c LIKE: finalgeo';
            if(sSearchInput != '' || sSearchInput != null){
                searchQuery += ' and Name LIKE : sSearchInput order by Name desc';
            }*/
            searchQuery = 'select Id, Name, Geometry__c from GMPL_BX009__c ';
            if(sSearchInput != '' || sSearchInput != null){
                searchQuery += 'where Name LIKE : sSearchInput ';
            }
            searchQuery += 'order by Name, Geometry__c desc';
            gmplList = database.query(searchQuery);
            if(gmplList.size()>0){
                b_DisplayGMPLRecords = true;
                s_PageBlockTableTitle = TABLE_TITLE_2;
                b_DisplayZeroSearchResultMessage = false;
            }
            else{
                b_DisplayGMPLRecords = false;
                b_DisplayZeroSearchResultMessage = true;
            }
        }
        if(sSearchInput!=null){
            sSearchInput = sSearchInput.replace('%','');
        }
        return null;
    }

}