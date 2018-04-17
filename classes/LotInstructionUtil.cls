/**
* Author        :   Ravikiran Nadella
* Description   :  this class has Logic to exceute when Lot id is 
changed  on lot instructions by planners  .
* History       :
Initials        Date                Description
-----------------------------------------------------------------------------------------

RNadella        27/11/2015          Created the class                                   
**/
public class LotInstructionUtil{

/*This Method is used to update the Changed lot information on the
     Lot instructions */
    public static void updateLotId(Map<id,Lot_Instruction__c>linstNewMap,Map<id,Lot_Instruction__c>linstOldMap){
        
        List<String> lotIDList = new List<String>();
        list<string> cLotidList = new List<String>();
        Set<Id> lotInstIds = new Set<Id> ();
        
        for(Lot_Instruction__c linst:linstNewMap.values()){
             
        if(linst.Stage__c=='Pending Planner Response' && (linst.Manufacturing_Lot__c != linstOldMap.get(linst.id).Manufacturing_Lot__c) ){
            lotInstIds.add(linst.Manufacturing_Lot__c);
            lotInstIds.add(linstOldMap.get(linst.id).Manufacturing_Lot__c);
            }
        }
        
       
        Map<id,Manufacturing_Lot__c>NameMap = new Map<id,Manufacturing_Lot__c>([select id,name from Manufacturing_Lot__c 
                                                                                  where id in :lotInstIds ]);
        
        
        for(Lot_Instruction__c linst:linstNewMap.values()){
            if(null<>NameMap.get(linst.Manufacturing_Lot__c)){
                if(NameMap.get(linst.Manufacturing_Lot__c).name.contains('.')){
                lotIDList=NameMap.get(linst.Manufacturing_Lot__c).name.split('\\.');
                }else{
                
                lotIDList.add(NameMap.get(linst.Manufacturing_Lot__c).name);
                }
                 id oldId = linstOldMap.get(linst.id).Manufacturing_Lot__c;
                if(NameMap.get(oldId).name.contains('.')){
                 cLotidList=NameMap.get(oldId).name.split('\\.');
                 system.debug('cLotidList split' +cLotidList);
                }else{
                
                cLotidList.add(NameMap.get(oldId).name);
                }
                
                system.debug('lotIDList' +lotIDList);
                system.debug('cLotidList' +cLotidList);
                
                if(lotIDList[0]!=cLotidList[0]){
                    linst.addError(system.label.Changed_Manufacturing_Lot);
                    
                }
                
            }
        }
        
    }


}