/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: Before insert Trigger on MRS Layer Association
History:
created:     30/6/2014     
*/



trigger MRS_Layer_Association_SWIFT_BINS on MRS_Layer_Association__c (before insert) {
    
    if(!IntegrationUserUtil.isSkipTrigger()){
       map<string,string> mapmstlyrName = new map<string,string>();
       set<string>  setmst = new set<string>();
       set<string> setlyr = new set<string>();
       for(MRS_Layer_Association__c lyr :Trigger.new){
        if(lyr.layer_name__c==null ||  lyr.layer_name__c==''){
           
            setmst.add(lyr.Mask_Set_Title_Name__c);
            setlyr.add(lyr.Name); 
        }
    }
    for(Mask_Layer__c ml: [select name,Mask_Layer_Number__c,Mask_Set_Title__r.Name from Mask_Layer__c  where Mask_Set_Title__r.Name in :setmst and Mask_Layer_Number__c in :setlyr ]){
        mapmstlyrName.put(ml.Mask_Set_Title__r.Name+'|'+ml.Mask_Layer_Number__c, ml.Name);
    }
    for(MRS_Layer_Association__c lyr :Trigger.new){
        if(lyr.layer_name__c==null   && mapmstlyrName.keyset()!=null && mapmstlyrName.containskey(lyr.Mask_Set_Title_Name__c+'|'+lyr.Name)){
            lyr.Layer_Name__c = mapmstlyrName.get(lyr.Mask_Set_Title_Name__c+'|'+lyr.Name);
        }
    }
    
    }
    MRSHandlerUtility.setTimeStampForLayers(trigger.new,null);

}