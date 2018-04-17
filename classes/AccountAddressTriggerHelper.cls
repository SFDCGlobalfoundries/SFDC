public class AccountAddressTriggerHelper{

    public static void updateAccOnPrimaryAddrChange(List<Account_Address__c> newList, Map<Id,Account_Address__c> oldmap){
        List<Account_Address__c> addrList = new List<Account_Address__c>();
        List<Account_Address__c> addrToUpdate = new List<Account_Address__c>();
        List<Account_Address__c> addrListToUpdate = new List<Account_Address__c>();
        List<Account> accToUpdate = new List<Account>();
        Set<Id> accId = new Set<Id>();
        Map<Id,Set<String>> mapAccApprovalReq = new Map<Id,Set<String>>();
        
        for(Account_Address__c addr : newList){
            if(addr.type__c == 'Bill To Address'){
                accId.add(addr.account__c);
            }
        }
        
        for(Account acc : [Select id, stage__c, approval_request__c, approval_status__c from Account where id in: accId]){
            mapAccApprovalReq.put(acc.id,new Set<String>());
            if(mapAccApprovalReq.get(acc.id) != null){
                mapAccApprovalReq.get(acc.id).add(acc.stage__c);                             
            }
        }
       
        for(Account_Address__c addr : newList){
        
            if(addr.Is_Primary_Address__c && addr.type__c == 'Bill To Address' && (addr.Address_1__c != oldmap.get(addr.id).Address_1__c || addr.Address_2__c != oldmap.get(addr.id).Address_2__c
                || addr.Address_3__c != oldmap.get(addr.id).Address_3__c || addr.Address_4__c != oldmap.get(addr.id).Address_4__c
                || addr.City__c != oldmap.get(addr.id).City__c || addr.Country__c != oldmap.get(addr.id).Country__c || addr.State__c != oldmap.get(addr.id).State__c
                || addr.Postal_Zip_Code__c != oldmap.get(addr.id).Postal_Zip_Code__c || addr.Location__c != oldmap.get(addr.id).Location__c || addr.Bill_To_Attention__c != oldmap.get(addr.id).Bill_To_Attention__c 
                || addr.name != oldmap.get(addr.id).name)){ 
                           
                 /* if(mapAccApprovalReq.get(addr.account__c).contains('Authorized') && (addr.New_Status__c!='Approved' || addr.New_Status__c!='Rejected') && addr.status__c == oldmap.get(addr.id).status__c){
                      addr.addError('After Account is authorized Primary Bill To Address Details cannot be changed. Please create new Bill To Address and make it primary through Account Details Change.');
                  }
                  else{*/  
                 
                        addrList.add(addr);
               
                Account_Address__c accAddr= new Account_Address__c(id = addr.id);                
                    accAddr.New_Status__c = Null;
                    addrListToUpdate.add(accAddr);           
             //}
            }
        }
        
        
        if(!addrList.isEmpty()){
            for(Account_Address__c addr : addrList){
                Account acc = new Account(id=addr.account__c);
                acc.Account_Details_Change_By_Trigger__c = System.Now();
                acc.Bill_To_Address_1__c = addr.Address_1__c;
                acc.Bill_To_Address_2__c = addr.Address_2__c;
                acc.Bill_To_Address_3__c = addr.Address_3__c;
                acc.Bill_To_Address_4__c = addr.Address_4__c;
                acc.Bill_To_City__c = addr.City__c;
                acc.Bill_To_Country__c = addr.Country__c;
                acc.Bill_To_Location__c = addr.Location__c;
                acc.Bill_To_State__c = addr.State__c;
                acc.Bill_To_Postal_Zip_Code__c = addr.Postal_Zip_Code__c;
                acc.Bill_To_Attention__c = addr.Bill_To_Attention__c;
                acc.Primary_Bill_To_Address__c = addr.name;
                accToUpdate.add(acc);
            }
            
            if(!accToUpdate.isEmpty()){
                try{
                    update accToUpdate;
                   
                }
                catch(Exception e){
                    system.debug(e.getMessage());
                }
            }
          if(!addrListToUpdate.isEmpty()){
                try{
                     update addrListToUpdate;
                }
                catch(Exception e){
                    system.debug(e.getMessage());
                }
            }
        }
    }
    
    public static void validateExistAddress(List<Account_Address__c> addrList,Map<Id,Account_Address__c> oldmap){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,List<Account_Address__c>> accAddressMap = new Map<Id,List<Account_Address__c>>();
        
        for(Account_Address__c addr : addrList){
            if(addr.location__c != oldmap.get(addr.id).location__c || addr.Address_1__c != oldmap.get(addr.id).Address_1__c 
                  || addr.Country__c != oldmap.get(addr.id).Country__c || addr.Postal_Zip_Code__c != oldmap.get(addr.id).Postal_Zip_Code__c){
                        accIdSet.add(addr.account__c);
            }
        }
        
         For(Account_Address__c addr : [Select account__c,location__c,Address_1__c,Country__c,Postal_Zip_Code__c from Account_address__c where account__c in : accIdSet and type__c = 'Bill To Address']){
               if(accAddressMap.get(addr.account__c) == null){
                   accAddressMap.put(addr.account__c,new List<Account_Address__c>());
               }
               accAddressMap.get(addr.account__c).add(addr);
        } 
        
        for(Account_Address__c addr : addrList){
            if(accAddressMap.get(addr.account__c) != null){
                for(Account_Address__c ad : accAddressMap.get(addr.account__c)){
                   if(addr.id != ad.id){
	                   if(addr.location__c == ad.location__c){
	                       addr.addError('Bill To Location should be unique for this account.'); 
	                   }
	                   if(addr.Address_1__c == ad.Address_1__c 
	                       && addr.Country__c == ad.Country__c && addr.Postal_Zip_Code__c == ad.Postal_Zip_Code__c){
	                        addr.addError('Bill To Address already exists i.e. Combination of Address Line 1, Country and Bill To Postal/Zip Code already exists with this account.');    
	                   }
                   }
                }
            }
        }
        
        Set<Id> accIdSet2 = new Set<Id>();
        Map<Id,List<Account_Address__c>> accAddressMap2 = new Map<Id,List<Account_Address__c>>();
        
        for(Account_Address__c addr : addrList){
            If (addr.Status__c =='Approved' && addr.New_Status__c =='Approved' && addr.Type__c =='Bill To Address' && addr.Account_Address_Change_request__c){
                 if(addr.New_Address_Line_1__c != Null){
                    addr.Address_1__c = addr.New_Address_Line_1__c;
                 }
                 if(addr.New_Address_Line_2__c != Null){
                    addr.Address_2__c = addr.New_Address_Line_2__c;
                 }
                 
                 if(addr.New_Address_Line_3__c != Null){
                    addr.Address_3__c = addr.New_Address_Line_3__c;
                 }
                 if(addr.New_Address_Line_4__c!= Null){
                    addr.Address_4__c = addr.New_Address_Line_4__c;
                 }
                 if(addr.New_Bill_To_Attention__c!= Null){
                    addr.Bill_To_Attention__c = addr.New_Bill_To_Attention__c;               
                 }
                 
                 if(addr.New_City__c!= Null){
                    addr.City__c = addr.New_City__c;                 
                 }
                 
                 if(addr.New_Location__c!= Null){
                   addr.Location__c = addr.New_Location__c;              
                 }
                 
                 if(addr.New_Postal_Zip_Code__c!= Null){
                   addr.Postal_Zip_Code__c = addr.New_Postal_Zip_Code__c ;       
                 }
                 if(addr.New_Country__c!= Null){
                   addr.Country__c = addr.New_Country__c; 
                 }
                  if(addr.New_State__c!= Null){
                    addr.State__c = addr.New_State__c;               
                 }
                 
                 if(addr.New_Location__c != oldmap.get(addr.id).Location__c || addr.New_Address_Line_1__c != oldmap.get(addr.id).Address_1__c 
                  || addr.New_Country__c != oldmap.get(addr.id).Country__c || addr.New_Postal_Zip_Code__c != oldmap.get(addr.id).Postal_Zip_Code__c){
                        accIdSet2.add(addr.account__c);
                 }
                 
                 addr.New_Address_Line_1__c = Null;
                 addr.New_Address_Line_2__c = Null;
                 addr.New_Address_Line_3__c = Null;
                 addr.New_Address_Line_4__c = Null;
                 addr.New_Bill_To_Attention__c = Null;
                 addr.New_City__c = Null;
                 addr.New_Location__c = Null;
                 addr.New_Postal_Zip_Code__c = Null ;
                 addr.New_Country__c = Null;
                 addr.New_State__c = Null;
                 addr.Account_Address_Change_request__c = False;
                 addr.New_Status__c = Null;
            }
            
        }
        
         For(Account_Address__c addr : [Select account__c,Location__c ,Address_1__c,Country__c ,Postal_Zip_Code__c,New_Location__c,New_Address_Line_1__c,New_Country__c,New_Postal_Zip_Code__c from Account_address__c where account__c in : accIdSet2 and type__c = 'Bill To Address']){
               if(accAddressMap2.get(addr.account__c) == null){
                   accAddressMap2.put(addr.account__c,new List<Account_Address__c>());
               }
               accAddressMap2.get(addr.account__c).add(addr);
        } 
        
        for(Account_Address__c addr : addrList){
            if(accAddressMap2.get(addr.account__c) != null){
                for(Account_Address__c ad : accAddressMap2.get(addr.account__c)){
                   if(addr.id != ad.id){
                       if(addr.location__c == ad.location__c){
                           addr.addError('Bill To Location should be unique for this account.'); 
                       }
                       if(addr.New_Address_Line_1__c == ad.Address_1__c 
                           && addr.Account_Address_Change_request__c && addr.New_Country__c == ad.Country__c && addr.New_Postal_Zip_Code__c == ad.Postal_Zip_Code__c && addr.New_Location__c!= Null && addr.New_Postal_Zip_Code__c!= Null && addr.New_Country__c != '' && addr.New_Address_Line_1__c!= Null  ){
                            addr.addError('Bill To Address already exists i.e. Combination of Address Line 1, Country and Bill To Postal/Zip Code already exists with this account.');    
                       }
                   }
                }
            }
        }
    }
    
    public static void sendAddressToERPOnApproved(List<Account_Address__c> addApproved, Map<Id,Account_Address__c> oldmap){
        List<Account> accSendToERP = new List<Account>();
        Map<Id,Account_Address__c> addIdMap = new Map<Id,Account_Address__c>();
        
        for(Account_Address__c add: addApproved){
            if(add.status__c == 'Approved' && add.status__c != oldmap.get(add.id).status__c){
                addIdMap.put(add.id,add);                
            }
        }
        
        for(ProcessInstance pi : [Select ID, Status, TargetObject.Name, TargetObjectID From ProcessInstance Where TargetObjectID in : addIdMap.keySet() and status = 'Approved']){
            Account acc = new Account(id = addIdMap.get(pi.TargetObjectID).account__c);
            accSendToERP.add(acc);
        }
        
        for(Account acc : accSendToERP){
            AccountDetailChange.send(acc);
        }
    }
    
     public static void resetSendSAPFormFlag(List<Account_Address__c> newList, Map<Id,Account_Address__c> oldmap){
        Set<Id> accId = new Set<Id>();
        List<Account> accToUpdate = new List<Account>();
        Map<Id,Account_Address__c> addIdMap = new Map<Id,Account_Address__c>();
        
        for(Account_Address__c add: newList){
            if(add.status__c == 'Approved' && add.status__c != oldmap.get(add.id).status__c && add.type__c == 'Bill To Address'){
                accId.add(add.account__c); 
                addIdMap.put(add.account__c,add);               
            }
        }
        
        if(!accId.isEmpty()){
            for(Id acc : accId){
                Account accnt = new Account(id=acc);
                accnt.SAP_Form_Sent_To_OM__c = false;
                if(addIdMap.get(acc).Address_Sent_To_OM__c == false){
                    accnt.Bill_To_Address_Change__c = true;
                }
                accToUpdate.add(accnt);
            }
        }
        
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }
}