/* Author :- Suvajit Majumder
 * ID0489 P2 : Opportunity set to Lost/Dropped/Void. Set Device Status to Inactive if device is at On hold status
 
   VijayVemuru 08122016    - Added method for Deal Grading Clip Level Implementation as the field value is updated on Opportunity .  
 * */
public with sharing class UpdDeviceOpptyHelper{

public static List<Opportunity> Find_LOST_DROPPED_VOID_OPPTY_UPDATE(List<Opportunity> UpdatedOpptyList,Map<Id,Opportunity> OldOpptyMap)

{
    List<String> List_Of_Stages=new List<String>{'Lost','Dropped','Void'};
    
    List<Opportunity> ListToProcess =new List<Opportunity>();
    
for (Opportunity OpptyUpd :UpdatedOpptyList)
{
    Opportunity OpptyOld=OldOpptyMap.get(OpptyUpd.Id);
    
    if(!String.isEmpty(OpptyUpd.StageName) && !String.isEmpty(OpptyOld.StageName)){
        if(OpptyUpd.StageName!=OpptyOld.StageName){
                for(Integer i=0;i<List_Of_Stages.size();i++){
                    if(OpptyUpd.StageName.containsIgnoreCase(List_Of_Stages[i]))
                        ListToProcess.add(OpptyUpd);
                }
        }
    }
                              
}
return  ListToProcess;
}
public static List<Opportunity> Find_LOST_DROPPED_VOID_OPPTY_INSERT(List<Opportunity> UpdatedOpptyList)
{
    List<String> List_Of_Stages=new List<String>{'Lost','Dropped','Void'};
    
    List<Opportunity> ListToProcess =new List<Opportunity>();

for (Opportunity OpptyUpd :UpdatedOpptyList)
{
        for(Integer i=0;i<List_Of_Stages.size();i++)
                if(OpptyUpd.StageName.containsIgnoreCase(List_Of_Stages[i]))
                    ListToProcess.add(OpptyUpd);                      
}
return  ListToProcess;
}
public static void DeviceStatusUpd(List<Opportunity> Li,String NewStatus)
{   
    List<Device__c>DeviceUpdList=new List<Device__c>();
    for(Device__c dev: [Select Id,Status__c from Device__c where Opportunity2__c in : Li and Status__c='On Hold'])
    {
        dev.Status__c=NewStatus;
        DeviceUpdList.add(dev);
    }   
if(DeviceUpdList.size() > 0){
    update  DeviceUpdList;
}    
}
public static void ControllerMethod(List<Opportunity> UpdatedOpptyList,Map<Id,Opportunity> OldOpptyMap)
{
    List<Opportunity> Li=Find_LOST_DROPPED_VOID_OPPTY_UPDATE(UpdatedOpptyList,OldOpptyMap);
    DeviceStatusUpd(Li,'Inactive');    
}
public static void ControllerMethod(List<Opportunity> NewOpptyList)
{
    List<Opportunity> Li=Find_LOST_DROPPED_VOID_OPPTY_INSERT(NewOpptyList);
    DeviceStatusUpd(Li,'Inactive');  
}
public static void beforeUpdateMethod(List<Opportunity> UpdatedOpptyList,Map<Id,Opportunity> OldOpptyMap){
    Set<id> accountids = new set<id>();
    for(Opportunity opp : UpdatedOpptyList) {
        if(OldOpptyMap == null || opp.accountid != OldOpptyMap.get(opp.id).accountid || 
            opp.Target_Process_Node__c != OldOpptyMap.get(opp.id).Target_Process_Node__c ||
            opp.Product_Line__c != OldOpptyMap.get(opp.id).Product_Line__c ||
            opp.LTR_Rev_M__c != OldOpptyMap.get(opp.id).LTR_Rev_M__c 
            ) {
            accountids.add(opp.accountid); 
        }
    }   
    // Deal Grading Clip/Client Level Implementation
    List<Clip_Level_Exemption__c> rules =  new List<Clip_Level_Exemption__c>();
    set<string> typeOfException =  new set<string>{'Clip level','Client Exemption'};
    rules = [SELECT id,Target_Process_Node__c,Brand__c,Type_of_Exception__c,LTR_Min__c,Account__c FROM  Clip_Level_Exemption__c 
                WHERE Account__c IN: accountids AND  Type_of_Exception__c IN: typeOfException];
    
    for(opportunity dg:UpdatedOpptyList){
        
        String dg_Combination = dg.Target_Process_Node__c+dg.Product_Line__c;
        for(Clip_Level_Exemption__c rule1 : rules){
            String Rule_Combination = rule1.Target_Process_Node__c+rule1.Brand__c;
            
            //Clip Level Implementation                
            if( (dg_Combination == rule_Combination) && (rule1.Type_of_Exception__c=='Clip level')  && (dg.LTR_Rev_M__c>rule1.LTR_Min__c)){
                    dg.Deal_Grading_Result__c   =   'Deal Grading Not Required';   
                    dg.Deal_Grading_Status__c   =   'Bid - Review Not Required';                             
            }     
            //Client Level Implementation
              if(rule1.Type_of_Exception__c=='Client Exemption' && dg.AccountId  ==  Rule1.Account__c){ 
                dg.Deal_Grading_Result__c   =   'Deal Grading Not Required';   
                dg.Deal_Grading_Status__c   =   'Bid - Review Not Required';   
                
              }               
         }  
          
      }
    
   }
        
}