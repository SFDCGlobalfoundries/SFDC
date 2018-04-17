/*
This is the before insert trigger based on the Fab Distribution Table object.
The main purpose of this trigger is to perform duplicate checking as well as
blocking public domain email addresses in the distribution list.
*/
trigger Fab_Distribution_Table_SWIFT_BINS on Fab_Distribution_Table__c (before insert) {

        Map<String, MRS_Invalid_Email_Extension__c> mapMRSIE = MRS_Invalid_Email_Extension__c.getAll();  
       
        set<string> setFDTAll=new set<string>();
        
        for(Fab_Distribution_Table__c objFDT:[select Fab_No__c from Fab_Distribution_Table__c]){
            setFDTAll.add(objFDT.Fab_No__c);
        }      
        for (Fab_Distribution_Table__c objFDT : Trigger.new){
            if(objFDT.Fab_No__c != null && objFDT.Fab_No__c != '' && objFDT.Distribution_List__c != null && objFDT.Distribution_List__c != ''){  
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
                 if(setFDTAll!=null && objFDT.Fab_No__c!=null)
                 {
                    if(setFDTAll.contains(objFDT.Fab_No__c))
                    {
                        objFDT.addError('Error: Fab No (' + objFDT.Fab_No__c + ') exists in Fab Distribution List Table. Please re-specify');
                    }
                 }
             }
             else{
                 objFDT.addError('Error: Blank values are not allowed');
             }
     }     
}