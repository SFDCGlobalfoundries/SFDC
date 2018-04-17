public class AccountMmsController {
    
    public  map<string,map<string,string[]>> mmsMap {get; set;}
    public  list<String> groupList {get; set;}
    public  list<String> yearList {get; set;}
    public  boolean readonly {get;set;}
    public  map<string, string> fsName2LabelMap {get; set;}
    public  Account_MMS__c acctMmsDetail {get; set;}
    public  Id acctId {get; set;}
    public  Id recId {get;set;}
    public  map<String,string> mmsFieldApi2ValueMap {get; set;}
    public AccountMmsController(ApexPages.StandardController stdController){
       
        this.recId = stdController.getId();
        readonly = false;
        if(recId.getSobjectType() == Schema.Account.SObjectType) {readonly = true;acctId =recId;}
        
        groupList = new list<String>();
        fsName2LabelMap = new map<string, string>();
        for(Account_MMS_Setting__c setting : [select Active__c,name,Field_Set_API__c,Readonly__c from Account_MMS_Setting__c where Active__c = true order by seq__c]){
            if(readonly == false && setting.Readonly__c ) continue;
            groupList.add(setting.Field_Set_API__c);
            fsName2LabelMap.put(setting.Field_Set_API__c,setting.name);
            
        }
        
        mmsMap = new map<string,map<string,string[]>>();
        String queryStr = 'select Dependent_on_IOS_products__c, ';
        Map<String, Schema.FieldSet> FsMap = Schema.SObjectType.Account_MMS__c.fieldSets.getMap();
        for(Schema.FieldSet fs : FsMap.values()){
            if(!fsName2LabelMap.containskey(fs.getName())) continue;
            map<string,string[]> row = new map<string,string[]>();
            //row.put('RowName',fs.getLabel());
            for(Schema.FieldSetMember f :fs.getFields()){
                queryStr = queryStr + f.getFieldPath() +',';
                String year = f.getLabel().replace(' ($M)', '').replace(' (%)', '').right(4);
                row.put(year,new list<string>{f.getFieldPath()});
            }
            mmsMap.put(fs.getName(),row);
            
        }
        
        if(readonly) queryStr = queryStr + 'id from Account_MMS__c where account__c = \'' + recId + '\'';
        else queryStr = queryStr + 'id,account__c from Account_MMS__c where id = \'' + recId + '\'';
        list<Account_MMS__c > acctMMSList = Database.query(queryStr);
        
        if(acctMMSList.size() > 0) acctMmsDetail = acctMMSList[0];
        else return;
        
        yearList = new list<string>();
        for(Account_MMS_Year_Setting__c setting: [select Active__c,name from Account_MMS_Year_Setting__c where Active__c = true order by seq__c]){
            yearList.add(setting.name);
        }
        
        system.debug('acctMMSList ================> ' + acctMMSList);
        
        
        for(string fs : mmsMap.keyset()){
            if(!fsName2LabelMap.containskey(fs)) continue;
            map<string,string[]> row = mmsMap.get(fs);
            for(String year : row.keyset()){
                list<string> pair = row.get(year);
                String fieldAPI = pair[0];
                Decimal fieldValue = (Decimal)acctMmsDetail.get(fieldAPI);                
                String fieldValueStr = fieldValue==null?'0':String.valueOf(fieldValue);
                pair.add(fieldValueStr );                
                
                
                
            }
        }
        system.debug('mmsMap ========================> ' + mmsMap);
        system.debug('yearList =========================> ' + yearList);
        system.debug('groupList =========================> ' + groupList);
        system.debug('fsName2LabelMap =========================> ' + fsName2LabelMap);
    }
   
        
    public PageReference Save(){
        
        for(map<string,string[]> rowMap : mmsMap.values()){
            for(list<string> pair : rowMap.values()){
                system.debug(pair[0] + '=>' + pair[1]);
                if(String.isEmpty(pair[1])){pair[1] = '0';}
                acctMmsDetail.put(pair[0],Decimal.ValueOf(pair[1]).setScale(2, RoundingMode.HALF_UP));
            }           
        }
              
        update acctMmsDetail;
        
        PageReference pageRef = new PageReference('/'+acctMmsDetail.account__c);
        return pageRef;
    }
    
    public pagereference newMMS(){        
        Account_MMS__c actMMS = new Account_MMS__c(name=system.now().formatlong(), account__c = acctId );
        insert actMMS;
        pagereference pf = Page.AccountMMSEdit;//new pagereference ('/apex/AccountMMSEdit?id=' + actMMS.id );
        pf.getParameters().put('id',actMMS.id);
        return pf;   
    }
    
    public pageReference cancel(){
        PageReference pageRef = new PageReference('/'+acctMmsDetail.account__c);
        return pageRef;
    }
    
    public Account getAccountInfo() {
        string tempId;
        if (this.readonly) {
            tempId = this.recId;    
        } else {
            Account_MMS__c a = [
                SELECT    Account__c
                FROM      Account_MMS__c
                WHERE     Id = :this.recId
            ];
            
            tempId = a.Account__c;
        }
        
        return [
            SELECT      Id
                        , Name
                        , Short_Name__c
                        , Region__c
                        , Financial_Territory__c
            FROM        Account
            WHERE       Id = :tempId
        ];
    }
}