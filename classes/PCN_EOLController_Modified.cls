/***************************************************************************************************************************
Class:         PCN_EOLController_Modified 
----------------------------------------------------------------------------------------------------------------------------
Author:        Dinesh M Suggala
Created Date:  25/11/2016
Reason:        This Class is used to search affected part numbers and save PCNEOL and  Shipline data for affected part numbers
Change Log:    Created     -     Dinesh     -     25/11/2016
               Updated     -     Sameera    -     21/2/2017  
***************************************************************************************************************************/
public without sharing class PCN_EOLController_Modified {    
    
    public List<Shipment_Line_Internal__c> results{get;set;}
    public PCN_EOL__c EOL{get;set;}
    public List<ShipmentWrapper> listwrapper{get;set;}
    public List<ShipmentWrapper> partrecords{get;set;}  
    public String searchtext{get;set;}   
    public Id shiplineId{get;set;}
    public boolean fetch{get;set;}
    public boolean edit{get;set;}
    public boolean SecondSearchHide{get;set;}
    public ApexPages.StandardController con;
    public Integer indCount = 0;
    Public String var;       
    public Map<String,Part_Customer_Infomation__c> partcustinfomap=new Map<String,Part_Customer_Infomation__c>();
    public List<Part_Customer_Infomation__c> partcustomerinfo=new List<Part_Customer_Infomation__c>();
    public List<ShipmentWrapper> mediatorlist=new List<ShipmentWrapper>();
    public List<String>  newlstString=new List<String>();
    public List<Part_Customer_Infomation__c> delpartlist=new List<Part_Customer_Infomation__c>();
    Public boolean InQueue{get; set;}     
    Public boolean LODValidate=false;
    Public Date ValidDate;
    Public DateTime CDate;
    //Constructor    
    public PCN_EOLController_Modified (ApexPages.StandardController controller) {
    con = controller;      
    listwrapper=new List<ShipmentWrapper>();  
    mediatorlist=new List<ShipmentWrapper>();       
    delpartlist=new List<Part_Customer_Infomation__c>();
    var=ApexPages.currentPage().getParameters().get('Id'); 
    List<GroupMember> ASIC_RF_group = [SELECT Group.Name,UserOrGroupId  FROM GroupMember WHERE Group.Name IN ('RF CE Queue','ASIC CE Queue','LMT ASIC Queue','LMT RF Queue') AND Group.Type = 'Queue' AND UserOrGroupId =:UserInfo.getUserId()];
    if(!ASIC_RF_group.isEmpty() &&  ASIC_RF_group!= null){
        InQueue=true;
    }else{
        InQueue=false;
    }    
    set<Id> UsersinQueueSet=new set<Id>();
    for(GroupMember gm:[SELECT Group.Name,UserOrGroupId  FROM GroupMember WHERE Group.Name IN ('RF CE Queue','ASIC CE Queue','LMT ASIC Queue','LMT RF Queue') AND Group.Type = 'Queue']){
    UsersinQueueSet.add(gm.UserOrGroupId);
    }
    
    if(UsersinQueueSet.Contains(UserInfo.getUserId())){
    LODValidate=true;
    system.debug('***LODValidate***'+LODValidate);
    }
    
    if(var!=null){
       EOL=[Select Id,Name,Affected_Part_Numbers__c,EOL_Stage__c,Fab__c,Last_Order_Date__c,Last_Ship_Date__c,LMT_Affected__c,Package_Type_Affected__c,PCN_Numbers__c,
            Reason_for_the_discontinuance__c,Technology_Affected__c,Technology_Node__c,End_of_Service_and_Support_Date__c,
            OwnerId,Method_to_contrl_discontinued_device_p_n__c,LODNotify1__c,LODNotify2__c,LODNotify3__c,Other_Package_Type_Affected__c,CreatedDate  from PCN_EOL__c where Id=:var];
        
        
        set<Id> accountset=new set<Id>();
        partrecords=new List<ShipmentWrapper>();
        partcustomerinfo=[Select Id,IBM_Part_Number__c,End_Of_Life__c,Shipment_Line_Internal__c,Account__c,Ultimate_Customer_Account__c,Shipment_Line_Internal__r.PO_Num__c,Account__r.Short_Name__c,Shipment_Line_Internal__r.Cust_Part_Num__c,Ultimate_Customer_Account__r.Name  from Part_Customer_Infomation__c where End_Of_Life__c=:EOL.Id Order By IBM_Part_Number__c]; 
       
        for(Part_Customer_Infomation__c pcinfo:partcustomerinfo){
              accountset.add(pcinfo.Account__c);
              partcustinfomap.put(pcinfo.Shipment_Line_Internal__c,pcinfo);
              mediatorlist.add(new ShipmentWrapper(pcinfo));
        }
        indCount = 0;
            for(ShipmentWrapper sr: mediatorlist){                
                 sr.counterWrap = indCount;
                 partrecords.add(sr);
                 indCount++;            
            }     
    //  ValidDate=EOL.Last_Order_Date__c;
        CDate=EOL.CreatedDate;
        edit=true;
        fetch=false;
        SecondSearchHide=true;
        
       }
        else{
          edit=false;
          SecondSearchHide=false;
         
          EOL =new PCN_EOL__c();   
          EOL.OwnerId=Userinfo.getUserId(); 
          Date DateNew=Date.today().addMonths(6).adddays(5);
          EOL.Last_Order_Date__c=DateNew;
          ValidDate=EOL.Last_Order_Date__c;
          EOL.Last_Ship_Date__c=DateNew.addYears(1);
          EOL.End_of_Service_and_Support_Date__c=DateNew.addYears(2);
        }
     }
           
     //This method is used to search affected part numbers and display the data in "Affected Accounts and Parts"   
      public PageReference search() { 
           newlstString=new List<String>();
           if(searchtext.contains(',')){
             List<String> searchcomma=searchtext.split(',');
              for(String s: searchcomma) {
                   newlstString.add(s.trim());   
                  } 
              }                             
          
       else if(searchtext.contains(';')){
        List<String> searchsemicolon=searchtext.split(';');
        for(String s: searchsemicolon){
             newlstString.add(s.trim());
        }
       }    
       
       else {
           searchtext= searchtext;
           newlstString.add(searchtext.trim()); 
       }     
       
      results= [Select Id,IBM_Part_Num__c,Cust_Part_Num__c,Shipment__r.Account__c,Shipment__r.Account__r.Short_Name__c,Ultimate_Customer_Account__c,PO_Num__c,Ultimate_Customer_Account__r.Name from Shipment_Line_Internal__c where IBM_Part_Num__c like:newlstString Order By IBM_Part_Num__c limit 1000];
      Map<String,Shipment_Line_Internal__c> UniqueIBMMap=new Map<String,Shipment_Line_Internal__c>();
      for(Shipment_Line_Internal__c shpmnt : results){
      if(!UniqueIBMMap.containsKey(shpmnt.IBM_Part_Num__c+'-'+shpmnt.Shipment__r.Account__c)){
         UniqueIBMMap.put(shpmnt.IBM_Part_Num__c+'-'+shpmnt.Shipment__r.Account__c,shpmnt);
       }
      }

      listwrapper=new List<ShipmentWrapper>();
      mediatorlist=new List<ShipmentWrapper>();
      set<ID> accountset=new set<Id>();       
      for(Shipment_Line_Internal__c s: UniqueIBMMap.Values()) 
      {
         mediatorlist.add(new ShipmentWrapper(s));
         accountset.add(s.Shipment__r.Account__c);
      }
     
      if(results.isEmpty()){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error: No Result Found for Desired Affected Part Number.');
          ApexPages.addMessage(myMsg);
      }
         
        indCount = 0;
            for(ShipmentWrapper sr: mediatorlist){
                   sr.counterWrap = indCount;
                   listwrapper.add(sr);
                   indCount++;
           }
        fetch=true;
        SecondSearchHide=false;
        return null;
   }
       //This method is used to remove row from "Affected Accounts and Parts" section in New Page 
        public PageReference removingRow(){ 
        String paramVal = Apexpages.currentpage().getParameters().get('index');
        if(paramVal != null){
            Integer param = Integer.valueOf(paramVal);
            for(Integer i=0;i<listwrapper.size();i++){
                if(listwrapper[i].counterWrap == param ){
                    listwrapper.remove(i);     
                }
            }
         }
        return null;  
        }
            
        //This method is used to remove row from "Delete Affected Accounts and Parts" in the edit Page
        public PageReference removingRow1(){          
        String paramVal1 = Apexpages.currentpage().getParameters().get('index1');
        if(paramVal1 != null){
            delpartlist=new List<Part_Customer_Infomation__c>();
            Integer param1 = Integer.valueOf(paramVal1);
            for(Integer i=0;i<partrecords.size();i++){
                if(partrecords[i].counterWrap == param1 ){
                    delpartlist.add(partrecords[i].partcustomerinfo);
                    partrecords.remove(i);   
                  }
               }
            }
        return null;  
        }
          
         //This method is used to store the PCNEOL  and  Shipline data for affected part numbers into Part Customer Information(Junction Object)
          public pageReference save(){
                String partnum='';     
                set<String> searchString=new set<String>();                    
                String removelastelement= searchtext.contains(',') ? searchtext.endsWithIgnoreCase(',') ?searchtext.removeEndIgnoreCase(',') : searchtext :searchtext;
                  if(removelastelement.contains(',')){
                  for(String s:removelastelement.split(',')){
                   searchString.add(s.trim());
                   }
                  }
                  else{
                   searchString.add(removelastelement.trim());
                  }
                 
                    if(searchString.size()>0){
                     for(String s: searchString){
                      partnum+=s.trim()+',';
                     }
                    }
                    else{
                      partnum=searchtext.trim()+',';
                    } 
                    
                    Datetime Dt=Datetime.now();
                    String ss=Dt.format('MM/dd/YY');       
                    String datestring='';
                    List<String> liststring=ss.split('/');
                    for(String s:liststring){
                    datestring+=s;
                    } 
                     String Tpartnum='';
                     integer count=0;
                     try{
                         if(!edit) {
                             List<PCN_EOL__c> pcnlist=[Select Id,Name,PCN_Numbers__c from PCN_EOL__c where CreatedDate=TODAY Order by CreatedDate desc limit 1]; 
                             String tempPCN='00';
                             if(pcnlist.size()>0)
                                {
                                 if(Integer.valueOf(pcnlist[0].PCN_Numbers__c.substringafterlast('-'))<10){
                                 tempPCN='0'+String.valueOf(Integer.valueOf(pcnlist[0].PCN_Numbers__c.substringafterlast('-'))+1);
                                 }
                                 else{
                                 tempPCN=String.valueOf(Integer.valueOf(pcnlist[0].PCN_Numbers__c.substringafterlast('-'))+1);
                                 }
                                }
                             EOL.PCN_Numbers__c='PCN'+'-'+datestring+'-'+EOL.Fab__c+'-'+ tempPCN;  
                             List<String> partnumlist=partnum.split(',');  
                                            
                             for(String s:partnumlist){
                                count++;
                                if(count==10){  
                                Tpartnum+=s+','+'\r\n ';
                                count=0;
                                }
                                else{
                                Tpartnum+=s+','+' ';
                                }     
                              }
                             EOL.Affected_Part_Numbers__c=Tpartnum;
                             if(!LODValidate && EOL.Last_Order_Date__c<ValidDate)
                             {
                              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error: Last Order Date should be greater than 6 Months from Today');
                              ApexPages.addMessage(myMsg);
                              return null;
                             }
                             else{
                             insert EOL;  
                             } 
                           }  
                             else{        
                                 if(EOL.Affected_Part_Numbers__c!='null'){  
                                  String EdiRemoveLastElement=EOL.Affected_Part_Numbers__c.contains(',') ? EOL.Affected_Part_Numbers__c.endsWithIgnoreCase(',') ?EOL.Affected_Part_Numbers__c.removeEndIgnoreCase(',') : EOL.Affected_Part_Numbers__c :EOL.Affected_Part_Numbers__c;
                                  if(EdiRemoveLastElement.contains(',')){
                                   for(String s:EdiRemoveLastElement.split(',')){
                                    searchString.add(s.trim());
                                    }
                                   }
                                   else{
                                   searchString.add(EdiRemoveLastElement.trim());
                                   }
                                  for(String s: searchString){
                                    system.debug('s&&&&&'+s);
                                    count++;
                                    if(count==10){  
                                    Tpartnum+=s.trim()+','+'\r\n ';
                                    count=0;
                                    }
                                    else{
                                    Tpartnum+=s.trim()+','+' ';
                                    }         
                                  }        
                                 
                                  EOL.Affected_Part_Numbers__c=Tpartnum;                    
                                  Date DateNew1=Date.today().addMonths(6).adddays(5);
                                  if(!LODValidate && (EOL.Last_Order_Date__c> CDate && EOL.Last_Order_Date__c<DateNew1)){
                                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error: Last Order Date should be greater than 6 Months from Today');
                                  ApexPages.addMessage(myMsg);
                                  return null;
                                  } 
                                  else if(EOL.Last_Order_Date__c<CDate){
                                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error: Last Order Date cannot be less than CreatedDate');
                                  ApexPages.addMessage(myMsg);
                                  return null;
                                  }
                                  else{        
                                  update EOL;
                                  }
                                 }
                                
                             }
                        }
                         Catch(Exception e){
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error: Please Contact your System Administrator.');
                         ApexPages.addMessage(myMsg);
                         //Adding code for exception framework
                         PCNEOL_EmaiHandler.ExceptionalHandlingMethod(PCN_EOLController_Modified.class.getName(),'save()',String.ValueOf(EOL.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
                         return null;    
                         }
                         Integer CountPCN=0;
                         List<Part_Customer_Infomation__c> listPCI =new List<Part_Customer_Infomation__c>();
                         for(ShipmentWrapper shipment: listwrapper){ 
                             if(!partcustinfomap.containsKey(shipment.shipline.Id))   {
                              Part_Customer_Infomation__c PCI=new Part_Customer_Infomation__c();       
                              PCI.End_Of_Life__c=EOL.Id;
                              PCI.Shipment_Line_Internal__c=shipment.shipline.Id;
                              PCI.Account__c=shipment.shipline.Shipment__r.Account__c;
                              PCI.IBM_Part_Number__c=shipment.shipline.IBM_Part_Num__c;
                              PCI.Ultimate_Customer_Account__c  = shipment.shipline.Ultimate_Customer_Account__c;
                              listPCI.add(PCI);
                              CountPCN++;
                             }
                             
                           }    
                                if(listPCI.size()>0){
                                EOL.Count_PCN__c=CountPCN;
                                } 
                                else{
                                EOL.Count_PCN__c=CountPCN;
                                }
                                
                                try{ 
                                     if(listPCI.size()>0){
                                     insert listPCI; 
                                     }
                                     if(!edit){
                                     Update EOL;
                                     }
                                     else if(edit && listPCI.size()>0){
                                     Update EOL;
                                     }
                                     if(delpartlist!=null && delpartlist.size()>0){
                                     delete delpartlist;
                                     }
                                }
                                Catch(Exception e){ 
                                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error: Please Contact your System Administrator .');
                                 ApexPages.addMessage(myMsg);
                                 //Adding code for Exception Handling Framework
                                 PCNEOL_EmaiHandler.ExceptionalHandlingMethod(PCN_EOLController_Modified.class.getName(),'save()',String.ValueOf(EOL.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
                                 return null;        
                                }
                                 PageReference redirectPage =  new PageReference('/'+EOL.Id);
                                 redirectPage.setRedirect(true);
                                 return redirectPage;  
                
                    } 
                 
              //Wrapper Class      
               public class ShipmentWrapper {
                        public Shipment_Line_Internal__c shipline{get;set;}
                        public boolean selected{get;set;}
                        public Part_Customer_Infomation__c partcustomerinfo{get;set;}
                        public Account_Team_Proxy__c AcctTeamProxy{get;set;}
                        public Integer counterWrap{get;set;}
                                
                        public ShipmentWrapper(Shipment_Line_Internal__c shpmntline){
                            this.shipline=shpmntline;
                            this.selected=false;
                            if(System.Label.MPO_DMEA.Contains(shipline.Shipment__r.Account__c)){
                            selected=true;
                            }
                            else{
                            selected=false;
                            }
                            
                        }
                        
                        public ShipmentWrapper(Part_Customer_Infomation__c pcinfo){
                           this.partcustomerinfo=pcinfo;
                           this.selected=false;
                            if(System.Label.MPO_DMEA.Contains(partcustomerinfo.Account__c)){
                            selected=true;
                            }
                            else{
                            selected=false;
                            }
                        }
                }
        }