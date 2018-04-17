/*
    Author: Ariz Solito
    Description: Apex class controller for the VF IPRequestList
    History: 
        Asolito     03282014    - Code creation.
*/
public with sharing class IPRequestListCntrlr {
    public RecordList recordList{get; set;}
    public RecordChart recordChart {get; set;}    
    
    public IPRequestListCntrlr(){
        this.recordList = new RecordList();
        this.recordChart = new RecordChart();
    }
    
    public class RecordList {
        public List<IP_Request__c> IPs {get; set;}
           
        public RecordList(){
            this.IPs = new List<IP_Request__c>();
            
            String query = 'SELECT ';
            
            for(Schema.FieldSetMember f : SObjectType.IP_Request__c.FieldSets.IP_Request_List.getFields()) {
                query += f.getFieldPath() +', ';
            }  
            
            query = query.substring(0,query.lastIndexOf(','));
            
            query += ' FROM IP_Request__c '+
                     ' ORDER BY name';
            
            this.IPs = Database.query(query);  
        }
    }
    
    public class RecordChart {
        public List<Data> dataList {get; set;}
        
        public RecordChart(){
            this.dataList = new List<Data>();
            Schema.DescribeFieldResult fieldResult = IP_Request__c.status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            //create initial list and value for the status
            for( Schema.PicklistEntry f : ple){
                this.dataList.add(new Data(f.getValue(),0));
            }
                                            
            
            List<AggregateResult> aggre = [SELECT count(id) recCount,status__c
                                             FROM IP_Request__c
                                             GROUP BY status__c];                                             
            for(AggregateResult a: aggre){
                for(Data d: this.dataList){
                    if(d.name == a.get('status__c')){
                        d.counter = Integer.valueOf(a.get('recCount'));
                    } 
                }               
            }                                                                                          
        }
    }
    
    public class Data {
        public String name {get; set;}
        public Integer counter {get; set;}
        
        public Data(String name,Integer counter){
            this.name = name;
            this.counter = counter;
        }
    }
}