/*
    Author: Ariz Solito
    Description: Webservice class for SO Number sync from ERP
    History: 
        Asolito    9/21/2015 - Code created
*/
global class MPWSaveSONumberToFormWebServiceClass {

    webservice static List<SalesOrder> saveSONumber(List<SalesOrder> salesOrderList){
        
        //Store the passed data in a Map
        Map<String,List<SalesOrder>> SOMap = new Map<String,List<SalesOrder>>();
        Set<String> MPWNoNotFound = new Set<String>();
        for(SalesOrder s: salesOrderList){
            if(SOMap.containsKey(s.MPWNo)){
                SOMap.get(s.MPWNo).add(s);
            } else {
                SOMap.put(s.MPWNo,new List<SalesOrder>{s}); 
                MPWNoNotFound.add(s.MPWNo);  
            }            
        }  
        
        //Get the MPW # from the list for query
        List<String> MPWNolist = new List<String>();
        MPWNolist.addAll(SOMap.keyset());              
                                                                
        List<MPW_Reservation__c> updateList = [SELECT id,name,sales_order__c
                                                 FROM MPW_Reservation__c
                                                 WHERE name IN: MPWNoList];
        
                
        //Update the SO number field of the mpw reservation                                         
        Map<String,String> SOIDMap = new Map<String,String>();
        for(MPW_Reservation__c u: updateList){
            //check if queried mpw # is found in the map
            if(SOMap.containsKey(u.name)){
                MPWNoNotFound.remove(u.name);
                for(SalesOrder s: SOMap.get(u.name)){
                    //if SO number is not blank, concatenate with comma
                    if(UtilsString.isNotBlank(u.sales_order__c)){
                        if(!u.sales_order__c.contains(s.SONumber)){
                            u.sales_order__c += ',' + s.SONumber;
                        }
                    //blank SO number                        
                    } else {
                        u.sales_order__c = s.SONumber;    
                    }
                    SOIDMap.put(u.id,u.name);                            
                }
            }
        }                       
                    
        //do partial update of the list
        //to return SUCCESS or ERROR to ERP
        List<Database.SaveResult> res = Database.update(updateList,false);                                                 
        for(Database.SaveResult r: res){
            String recId = r.getID();            
            if(SOIDMap.containsKey(recId)){
                if(r.isSuccess()){
                    for(SalesOrder s: SOMap.get(SOIDMap.get(recId))){
                        s.Status = 'SUCCESS';                        
                    }        
                } else {
                    for(SalesOrder s: SOMap.get(SOIDMap.get(recId))){
                        s.Status = 'ERROR';
                        s.statusMessage = 'Error updating the SO number';
                    }    
                }
            }
        }
        
        //MPW no does not exist in SFDC flag as ERROR     
        for(String s: MPWNoNotFound){
            for(SalesOrder o: SOMap.get(s)){
                o.status = 'ERROR'; 
                o.statusMessage = 'MPW form number not found';                                
            }
        }                          
         
        System.debug(salesOrderList);
                                                                                                                 
        return salesOrderList;    
    }
        
    global class SalesOrder {
        webService String IFaceID;
        webService String Status;
        webService String StatusMessage;
        webService String MPWNo;
        webService String SONumber;
    }      
}