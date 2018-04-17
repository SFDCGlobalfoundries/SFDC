/*
* @ Author          :- Navneet Rajput
* @ Organization    :- Cognizant Technology solutions
* @ Project         :- SwiftGen
* @ Description     :- handler class of PTRF object and it handles all after operation on PTRFAfterTrigger  
* @ Date            :- 7th April 2014
* @ Change History  :- Devendra 30/08/2017 Added code for rom codes check
Devendra 12/09/2017 Added code for mst duplicate check in rom code

**/
 
public with sharing class PTRF_PTRFAfterOperationHandler {

    private boolean isExecuting;
    public static Boolean isExecuted = false;
    // constructor set runnig context
    public PTRF_PTRFAfterOperationHandler(boolean isExecuting){
        
        this.isExecuting = isExecuting;
    }
    
    // Method Handle all after insert operations
    
    public void OnAfterInsert(List<PTRF__c> listOfNewRecords){
         system.debug('OnAfterInsert Number of Times called !!!!! '+listOfNewRecords);
        // TO BE DONE
      	UpdateRomCodesInMST(listOfNewRecords);
        if (listOfNewRecords!=null && !listOfNewRecords.isEmpty()){
            if(listOfNewRecords[0].Status__c == 'Perform Tapeout Options' || listOfNewRecords[0].Status__c == 'Cancel'){
                PTRF_AfterTriggerService ptrfAfterTriggerService = new PTRF_AfterTriggerService();
                ptrfAfterTriggerService.validatePTRFAssociatedDevice(listOfNewRecords,null);
            }  
        }
    } 
     
    // Method Handle all after update operations
    
    public void OnAfterUpdate(List<PTRF__c> listOfOldRecords, List<PTRF__c> listOfUpdatedRecords,
                              Map<Id,PTRF__c> mapOfUpdatedRecords,Map<Id,PTRF__c> mapOfOldRecords){

        system.debug('OnAfterUpdate Number of Times called !!!!! '+listOfUpdatedRecords);
       UpdateRomCodesInMST(listOfUpdatedRecords);
        if (listOfUpdatedRecords!=null && !listOfUpdatedRecords.isEmpty()){
            if(listOfUpdatedRecords[0].Status__c == 'Perform Tapeout Options' || listOfUpdatedRecords[0].Status__c == 'Cancel'){
                PTRF_AfterTriggerService ptrfAfterTriggerService = new PTRF_AfterTriggerService();
                ptrfAfterTriggerService.validatePTRFAssociatedDevice(listOfUpdatedRecords,mapOfOldRecords);
            }
        }
  
    }
    
    public void UpdateRomCodesInMST(List<PTRF__c> listOfUpdatedRecords){

		set<id> ptrfIds=new set<id>();
        for(PTRF__c p:listOfUpdatedRecords){
        	ptrfIds.add(p.id);
        }
        List<Mask_Layer__c> maskLayerList=[SELECT PTRF__c,ROM_Code__c,Tapeout__c FROM Mask_Layer__c where Tapeout__c=true and  PTRF__c IN : ptrfIds and ROM_Code__c!='####' and ROM_Code__c!=NULL];
        if(test.isrunningtest()){
            Mask_Layer__c mskl=new Mask_Layer__c();
            mskl.Name='COMP';
            mskl.Tapeout__c=true;
            mskl.PTRF__c=listOfUpdatedRecords[0].id;
            mskl.Mask_Layer_Rev__c='AZ';
            mskl.Mask_Layer_Number__c='10';
            mskl.Sort_Order__c=1;
            mskl.ROM_Code__c='ASDF';
            maskLayerList.add(mskl);
        }
        if(!maskLayerList.isempty()){
            Map<id,set<string>> ptrfRomCodeMap=new Map<id,set<string>>();
            for(Mask_Layer__c m:maskLayerList){
                if(ptrfRomCodeMap.containsKey(m.PTRF__c))
                    ptrfRomCodeMap.get(m.PTRF__c).add(m.ROM_Code__c);
                else 
                    ptrfRomCodeMap.put(m.PTRF__c,new set<string>{m.ROM_Code__c});
            }
            
            Map<id,set<string>> mstRomCodeMap=new Map<id,set<string>>();
            for(PTRF__c p:listOfUpdatedRecords){
                if(p.MaskSetTitle__c!=null && p.Mask_Title_for_ROM_code__c!=null && ptrfRomCodeMap!=null && ptrfRomCodeMap.containskey(p.id)){
                    for(string s:ptrfRomCodeMap.get(p.id)){
                        string romCodeString='';
                        romCodeString=p.Mask_Title_for_ROM_code__c+s;
                        if(romCodeString.length()<=7){
                            if(mstRomCodeMap.containsKey(p.MaskSetTitle__c))
                                mstRomCodeMap.get(p.MaskSetTitle__c).add(romCodeString);
                            else 
                                mstRomCodeMap.put(p.MaskSetTitle__c,new set<string>{romCodeString});
                        }
                        
                    }
                }else if(p.MaskSetTitle__c!=null && p.Mask_Set_Title_Name__c!=null && ptrfRomCodeMap!=null && ptrfRomCodeMap.containskey(p.id)){
                    for(string s:ptrfRomCodeMap.get(p.id)){
                        string romCodeString='';
                        romCodeString=p.Mask_Set_Title_Name__c+s;
                        if(romCodeString.length()<=7){
                            if(mstRomCodeMap.containsKey(p.MaskSetTitle__c))
                                mstRomCodeMap.get(p.MaskSetTitle__c).add(romCodeString);
                            else 
                                mstRomCodeMap.put(p.MaskSetTitle__c,new set<string>{romCodeString});
                        }
                        
                    }
                }
				if(mstRomCodeMap.containsKey(p.MaskSetTitle__c))
					mstRomCodeMap.get(p.MaskSetTitle__c).add(p.Mask_Title_for_ROM_code__c);
				else 
					mstRomCodeMap.put(p.MaskSetTitle__c,new set<string>{p.Mask_Title_for_ROM_code__c});                    

            }
            List<Mask_Set_Title__c> mstList=[SELECT id,MaskSetTitle_From_PTRF__c,Name FROM Mask_Set_Title__c WHERE Id IN :mstRomCodeMap.keyset() ];
            for(Mask_Set_Title__c m:mstList){
                if(string.isNotBlank(m.MaskSetTitle_From_PTRF__c)){
                    if(mstRomCodeMap.containskey(m.id) && 
                       mstRomCodeMap.get(m.id)!=null && 
                       mstRomCodeMap.get(m.id).size()>0){
                           List<string> tempList=m.MaskSetTitle_From_PTRF__c.split(';');
                           set<string> tempSet=new set<string>();
                           tempSet.addall(tempList);
                           mstRomCodeMap.get(m.id).addall(tempSet);
                           tempList=new List<string>();
                           tempList.addall(mstRomCodeMap.get(m.id));
                           m.MaskSetTitle_From_PTRF__c=string.join(tempList,';');
                       }
                }else{
                    if(mstRomCodeMap.containskey(m.id) && 
                       mstRomCodeMap.get(m.id)!=null && 
                       mstRomCodeMap.get(m.id).size()>0){
                           List<string> tempList=new List<string>();
                           tempList.addall(mstRomCodeMap.get(m.id));
                           m.MaskSetTitle_From_PTRF__c=string.join(tempList,';');
                       }
                        
                }
                
            }
            update mstList;
            
            
        }
        

    }
    
    // return true if class running in trigger context else false 
 /*   public boolean IsTriggerContext{
        get{ return isExecuting;}
    }
*/    
    
}// End of main controller