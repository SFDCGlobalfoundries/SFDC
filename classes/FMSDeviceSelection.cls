/* 
  @Author <Ram Rai>
   @name <FMSDeviceSelection>
   @CreateDate <27/05/2017>
   @Description <Select the Device at the time of Copy> 
   @Version <1.0>
   
   @ Change History :-  
        Date            Name    Reason
        ----            ----    ------
        06/28/2017      RRai    Modified the code to remove hardcoding. 
        07/14/2017      ARoy    Modified code for device sharing issue(Issue 495) - added 'with sharing' in class and line no : 42, 63-67. 
        09/25/2017      ARoy    Modified query for Design Partner addition in DMEA/TFA flow
		1-FEB-2018         Devendra -Tapeout process changes
*/
public with sharing class FMSDeviceSelection{

public List<Device__c> lstDvd{get;set;}
public List<Device__c> lstAllDvce{get;set;}
public Form_Management_System__c formObj {get;set;}
public Id deviceId;
public boolean shwmssg1{get;set;}
public boolean shwmssg2{get;set;}
public boolean shwmssg3{get;set;}
public Id frmId{get;set;}
public string fab9;
public string fab10;
//public string Geometry;
//public string ProcessFamily;
public string Account;
public list<wrapperClass> wrapperList{get;set;}
private final String FMS_DEV_LITE_SOLD_TO = EnvironmentVariable.get('FMS_DEV_LITE_SOLD_TO');
    
    public FMSDeviceSelection(){
    
        lstDvd = new List<Device__c>();
        map<id,id> devMap = new map<id,id>();
        set<id> devId = new set<id>();
        lstAllDvce = new List<Device__c>();
        frmId=  ApexPages.currentPage().getParameters().get('id');   
        formObj = [SELECT id, name,Device__c FROM Form_Management_System__c WHERE id = :frmId];    
        wrapperList = new list<wrapperClass>();
        lstDvd = [select Fab__c,Status__c,Stage__c,Account__c from Device__c where id=:formObj.Device__c ];
        User u = [select accountid from User where id=:UserInfo.getUserId()]; // Added for Device sharing issue by Anirban on 7/10/2017
              

        fab9 = EnvironmentVariable.get('FMS_FAB_9');
        fab10 = EnvironmentVariable.get('FMS_FAB_10');
        
        shwmssg1 = true;
        shwmssg2 = false;
        shwmssg3 = false;
        
        for(Device__c dvd: lstAllDvce ){
            
            devId.add(dvd.id);        
        }
        
        for(Form_Management_System__c fm: [select id,device__c from Form_Management_System__c ]){
            
            devMap.put(fm.device__c,fm.id);        
        }
        
        // Modified for Device sharing issue by Anirban on 7/10/2017 - Start 
        /*Geometry = lstDvd[0].Geometry__c;
        ProcessFamily = lstDvd[0].Process_Family__c ;*/
        Account = (lstDvd!=null && lstDvd.size()>0)?lstDvd[0].Account__c:u.AccountId ;
        // Account Hierarchy Query to get the account for correct SAP Account Number
        retrieveAccountHierarchy rah = new retrieveAccountHierarchy();
        for(Account_Hierarchy__c accH : rah.accHierList(Account)){
            if(accH.Account_Id__r.SAP_Account_Number__c != null && accH.Account_Id__r.SAP_Account_Number__c != '' && FMS_DEV_LITE_SOLD_TO.contains(accH.Account_Id__r.SAP_Account_Number__c)) {
                Account = accH.Account_Id__c;
                break; 
            }
        }
        // Aroy    9/25/2017    Modified query for Design Partner addition in DMEA/TFA flow 
        lstAllDvce = [select id,name,Fab__c,Status__c,Stage__c,Account__c,tapeout_process__c,CRMDID__c,Tapeout_Type__c from Device__c where ( tapeout_process__c='FMS 2.0' ) and (Account__c=:Account or (Design_Partner__c!=null and Design_Partner__c=:u.AccountId)) and Status__c='Active' and Stage__c='Design In' and Tapeout_Type__c!= 'Retrofit'  ];
        // Modified for Device sharing issue by Anirban on 7/10/2017 - End
        for(Device__c dvd: lstAllDvce ){
            if(devMap.get(dvd.id)==null){
                wrapperClass dvWrap = new wrapperClass(dvd);
                dvWrap.checkDevice= false;
                wrapperList.add(dvWrap); 
            }                       
        }
        
       if(wrapperList.size()== 0){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No matching device found. Please create a device and proceed for copy operation.'));
           shwmssg1 =false;
           shwmssg3 = true;
       }
       if(shwmssg1 ) 
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Select Any Device from List'));  
    }
    
   /*************************************    
   @ Name -  Wrapper Class
   @ Description - 
   @ Parameter - 
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */  
   public class wrapperClass{
        
        public Device__c wrapDevObj{get;set;}
        public Boolean checkDevice{get;set;}
       
   public wrapperClass(Device__c  WrapDevObj) {
            
            this.wrapDevObj = WrapDevObj ; 
            this.checkDevice= false;  
                
        }                      
    }
    
    public without sharing class retrieveAccountHierarchy{
    
        public List<Account_Hierarchy__c> accHierList(String account){
            return [Select Account_Id__c, Account_Id__r.SAP_Account_Number__c from Account_Hierarchy__c where Parent_Id__c =: account];    
        }
    }
    
    
   public PageReference canCel(){
   
       PageReference pgRef = new PageReference('/apex/FMSmainFormViewPage');
        pgRef.getParameters().put('id', frmId);     
        pgRef.setRedirect(true);
       
        return pgRef;
        
   }
    
      public PageReference contW(){
   
          PageReference pgRef = new PageReference('/apex/FMSmainFormCreation');
          
          
          for(wrapperClass wr:wrapperList){
           
               shwmssg1 = false;
               shwmssg2 = true; 
              if(wr.checkDevice){               
                  deviceId = wr.wrapDevObj.Id;
                  
                   shwmssg2 = false; 
                   break;
              }
          }  
          
         if(shwmssg2 )
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select Any Device'));
          if(!shwmssg2){
          pgRef.getParameters().put('id', formObj.id);
          pgRef.getParameters().put('tranx', 'Copy');
          pgRef.getParameters().put('deviceId', deviceId );
          pgRef.getParameters().put('Type', 'Main');
          pgRef.setRedirect(true);
          
          return pgRef;   
          }
          else
          return null;     
     }
}