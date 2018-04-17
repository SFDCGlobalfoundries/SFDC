/*Type Name: DealGrading_IP
Author: Vijay Vemuru
Description: This class for populating and storing the menu IP information for Deal Grading. This is the Controller for Deal Grading IP Page
History:  7/22/2016  code creation
*/            
public with sharing class DealGrading_IP {
    id dealGrading_Id;
    public Map<integer,Deal_Grading_IP__c> dealGradingIps{get;set;}
    public integer removeRow{get;set;}
    public boolean disableAdd{get;set;} 
    public DealGrading_IP(ApexPages.StandardController con){
        dealGrading_Id = con.getId();
    }    
    public void onLoadDealGrading() {
        disableAdd = false;
        try{
            Deal_Grading__c dealGrade = [Select id,opportunity1__r.Process_Geometry__c  FROM Deal_Grading__c WHERE id=:dealGrading_Id LIMIT 1];
            if(dealGrade != null) {
                dealGradingIps  =   new map<integer,Deal_Grading_IP__c>();
                Integer row = 0;
                for(Deal_Grading_IP__c dgip: [SELECT IP_Master__c,DealGrading__c,Non_Menu_IP__c,IP_Master__r.Name,IP_Master__r.IP_Technology__c,
                                                     IP_Master__r.Ip_Type__c,IP_Master__r.Ip_Type_Category__c,IP_Master__r.Ip_Vendor__c 
                                                    FROM Deal_Grading_IP__c 
                                                    WHERE DealGrading__c=:dealGrading_Id ]){
                    dealGradingIps.put(row,dgip);
                    row=row+1;       
                }       
            }
        }catch(Exception excp){GlobalUtility.logMessage('Error','DealGrading_IP','onLoadDealGrading','','Exception while getting the Deal Grading related data',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);}
        
    } 
    public void AddIp(){
        integer dgSize = dealGradingIps.size();
        dealGradingIps.put(dgSize,new Deal_Grading_IP__c(DealGrading__c=dealGrading_Id));
        disableAdd = true;
    }  
    public void removeIp(){
        map<integer,Deal_Grading_IP__c> tempMap  =      new map<integer,Deal_Grading_IP__c>();
        tempMap.putAll(dealGradingIps);
        dealGradingIps  =   new map<integer,Deal_Grading_IP__c>();
        List<Deal_Grading_IP__c> delList = new List<Deal_Grading_IP__c>();
        integer count =0;
        for(integer each : tempmap.keySet()) {
            if(removeRow != each) {
                dealGradingIps.put(count, tempmap.get(each));
                count=count+1;
            } else {
                if(tempmap.get(each).id != null){
                    delList.add(tempmap.get(each));
                }
            }
        }
        if(delList.size() >0){
            try{
                delete delList;
            }catch(Exception excp){GlobalUtility.logMessage('Error','DealGrading_IP','removeIp','','Exception while deleting the Deal Grading ip records',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);}
        }
    }
    public void saveIp(){
        integer size = dealGradingIps.size()-1;
        if(dealGradingIps.get(size) != null) {
            try{
                upsert dealGradingIps.get(size);
            }catch(Exception excp){GlobalUtility.logMessage('Error','DealGrading_IP','saveIp','','Exception while updating the Deal Grading ip records',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);}
            onLoadDealGrading();            
        }
        disableAdd = false;
    } 
}