/*
This is the before update trigger based on the Fab Distribution Table object.
The main purpose of this trigger is to block public domain email addresses in the distribution list.
*/
trigger Fab_Distribution_Table_SWIFT_BUPD on Fab_Distribution_Table__c (before update) {
        Map<String, MRS_Invalid_Email_Extension__c> mapMRSIE = MRS_Invalid_Email_Extension__c.getAll(); 
  
        for (Fab_Distribution_Table__c objFDT : Trigger.new){   
        if(mapMRSIE!=null && objFDT.Distribution_List__c!=null)
        {
           List<String> DLList = new List<String>();
           DLList = objFDT.Distribution_List__c.split(';');
           for(String str : DLList){
               if (mapMRSIE.keySet().contains(str.subStringAfter('@').trim())){
                    objFDT.addError('Error: Public email address is not allowed');
               }  
           }                   
        }
        if(objFDT.Fab_No__c!=null)
        {
            if(Trigger.oldMap.get(objFDT.Id).Fab_No__c!=Trigger.newMap.get(objFDT.Id).Fab_No__c)
            {
                objFDT.addError('Error: Fab No (' + objFDT.Fab_No__c + ') can not be modified in Fab Distribution List Table.');
            }
        }
    }  
}