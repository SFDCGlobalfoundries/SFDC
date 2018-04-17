/*************************************************************************************************************************************************************
@ Class:          QMXBoxTriggerHelper
@ Version:        1.0
@ Author:         Pradosh Samal
@ Purpose:        This Helper class consists of logics used in QMX Box trigger.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 11.23.2017 / Pradosh Samal / Created the class.
**************************************************************************************************************************************************************/
public class QMXBoxTriggerHelper{

    /*Global Variables*/
    
    public  Map<Id, Box__c>         triggerOldMap           { get; set; } //Map to store old record values of Work Order object
    public  Map<Id, Box__c>         triggerNewMap           { get; set; } //Map to store New record values of Work Order object 
    
    /*********************************************************************************************************************************************************
    @ Constructor:    QMXBoxTriggerHelper
    @ Version:        1.0
    @ Author:         Pradosh Samal 
    @ Purpose:        Initialises the class for controller instance.
    **********************************************************************************************************************************************************/ 
    public QMXBoxTriggerHelper(){
        
        triggerOldMap = ((Map<Id, Box__c>)Trigger.oldMap);
        triggerNewMap = ((Map<Id, Box__c>)Trigger.newMap);   
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         calculateBoxNumber
    @ Version:        1.0
    @ Author:         Pradosh Samal
    @ Purpose:        Calculate the box number.
    **********************************************************************************************************************************************************/ 
    public void calculateBoxNumber(){
        
        Set<Id> workOrderIdSet = new Set<Id>();
        Map<Id, Set<String>> workOrderBoxNameMap = new Map<Id, Set<String>>();
        
        for(Box__c box : (List<Box__c>)Trigger.new){
            
            workOrderIdSet.add(box.Work_Order__c);
        }
        
        Map<Id, Work_Order__c> workOrderMap = new Map<Id, Work_Order__c>([SELECT Id, Name, (SELECT Id, Calculated_Box_Number__c FROM Boxes__r) From Work_Order__c WHERE Id IN : workOrderIdSet]);
        
        for(Id workOrderId : workOrderMap.keySet()){
            
            for(Box__c box : workOrderMap.get(workOrderId).Boxes__r){
                
                if(workOrderBoxNameMap.get(workOrderId) != NULL){
                    
                    workOrderBoxNameMap.get(workOrderId).add(box.Calculated_Box_Number__c);
                }
                else{
                    
                    workOrderBoxNameMap.put(workOrderId, new Set<String>{box.Calculated_Box_Number__c});
                }
            }
        }
        System.debug('workOrderBoxNameMap : ' + workOrderBoxNameMap);
        
        Integer tempSlNo;
        
        for(Box__c box : (List<Box__c>)Trigger.new){
            
            tempSlNo = 1;
            
            while(workOrderBoxNameMap.get(box.Work_Order__c) != NULL && workOrderBoxNameMap.get(box.Work_Order__c).contains( workOrderMap.get(box.Work_Order__c).Name + ' Box -' + (workOrderMap.get(box.Work_Order__c).Boxes__r.size() + tempSlNo) ) ){
                
                tempSlNo++;
            }
            
            box.Calculated_Box_Number__c = workOrderMap.get(box.Work_Order__c).Name + ' Box -' + (workOrderMap.get(box.Work_Order__c).Boxes__r.size() + tempSlNo);
            
            if(workOrderBoxNameMap.get(box.Work_Order__c) != NULL){
                    
                    workOrderBoxNameMap.get(box.Work_Order__c).add( workOrderMap.get(box.Work_Order__c).Name + ' Box -' + (workOrderMap.get(box.Work_Order__c).Boxes__r.size() + tempSlNo));
            }
            else{
                
                workOrderBoxNameMap.put(box.Work_Order__c, new Set<String>{workOrderMap.get(box.Work_Order__c).Name + ' Box -' + (workOrderMap.get(box.Work_Order__c).Boxes__r.size() + tempSlNo)});
            }
        }
    }
}