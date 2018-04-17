/*
Type Name: FV_ClsOverrideNewButton class
Author: Cognizant 
Created Date: 13-Nov-2014
Reason: Case 34665 - IPDK enhancement
……..
……..
*/

public class FV_ClsOverrideNewButton 
{
    public boolean isDSGroup{get;set;}
    public boolean accpresent{get;set;}
 
    public boolean isIPDesignKit{get;set;}
    private final IPDK_License_Information__c IPLA;

    private String parentId;
    private String spectype;

 
    public FV_ClsOverrideNewButton(ApexPages.StandardController stdController)
     {
        this.IPLA = (IPDK_License_Information__c )stdController.getRecord();
        
        this.parentId = IPLA .Specification__r.Id ;
        this.spectype= IPLA .Specification__r.Specification_type__c ;
        isDSGroup =false;
        isIPDesignKit=false;
        accpresent=false;
        getParentId();
        getspectype();
        
        getGroup();
       // getaccountlist();
     }
     
      public String getParentId()
    {
    
       system.debug('parentId $$$'+parentId );
        if(IPLA.Specification__c!= null)
        {
            parentId = [SELECT Name FROM Design_spec__c WHERE Id = :IPLA .Specification__c].Id;
        }
        
        return parentId ;
        
        
    }
    
     public String getspectype()
    {
    
    system.debug('spectype$$$'+spectype);
        if(IPLA .Specification__c!= null)
        {
            spectype= [SELECT Specification_type__c FROM Design_spec__c WHERE Id = :IPLA .Specification__c].Specification_type__c ;
       }
       
        return spectype;
    }
   
       public pageReference getGroup()
        {
         //retURL = retURL.Substring(1,retURL.length());
         //system.debug('retURL $$$'+retURL);
             SET<id> SetofUserId=new SET<id>();
             List<GroupMember> lstmember=[Select GroupId,UserOrGroupId from GroupMember where GroupId =:System.label.DS_Group_Id];
             system.debug('lstmember$$$'+lstmember);
             for(GroupMember objmember:lstmember)
             {
              SetofUserId.add(objmember.UserOrGroupId);
             }
            
             
              system.debug('enter user1'+SetofUserId);
              system.debug('enter user2'+UserInfo.getUserId());
               
               
             
               if(!(SetofUserId.contains(UserInfo.getUserId())))
               {
               system.debug('enter else$$$');
               isIPDesignKit =true;
               isDSGroup=false;
               
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Only DS Group members are allowed to create IPDK Licence Information record.');
               ApexPages.addMessage(myMsg);
               return null;
               }
               else
                
               {
                isIPDesignKit =true;
               isDSGroup=true;
              
               return null ;
               
               }
            
           }
         
        public PageReference save() 
        {
        system.debug('enter save2');
        system.debug('spectype$$$'+spectype);
            Set<Id> SetofaccId=new Set<Id>();
          
           List<IPDK_License_Information__c> lstIPLA=[Select id,
                                                     account__c,
                                                     Specification__c,
                                                     Effective_Date__c
                                                     from IPDK_License_Information__c 
                                                     where Specification__c =:IPLA.Specification__c];
                                                     
           Design_spec__c ds=[Select id,Specification_type__c from Design_Spec__c where Id=:IPLA.Specification__c];
            system.debug('ds%%%'+ds);                                 
             system.debug('lstIPLA%%%'+lstIPLA);                                      
            if(lstIPLA<>Null &&!lstIPLA.isEmpty())
               { 
               for(IPDK_License_Information__c obj: lstIPLA)
               {
               SetofaccId.add(obj.account__c);
               }
              }

        system.debug('accpresent$$'+accpresent);
        //system.debug('IPLA.Specification__r.Specification_type__c$$'+IPLA.Specification__r.Specification_type__c);
        system.debug('IPLA.account__c$$'+IPLA.account__c);
        if(ds.Specification_type__c !='Ip Design Kit')
           {
           isIPDesignKit =false;
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'IPDK License Information can be created only for IP Design KIT specifications.');
           ApexPages.addMessage(myMsg);
           system.debug('enter save1');
           return null;
           }
        else if(SetofaccId.contains(IPLA.account__c)==true)
           {
           accpresent=true;
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Account Already Added.');
           ApexPages.addMessage(myMsg);
           system.debug('enter save2');
           return null;
           }
       else 
       {
       system.debug('enter save3');
        isIPDesignKit =true;
        upsert IPLA;
       // PageReference p = apexPages.currentPage();
        if(parentId!=null)
        {
        system.debug('enter parent!=null');
        PageReference pr= new PageReference('/'+ parentId);
        return pr;
        }
        else
        {
        system.debug('enter parent==null');
        
       // PageReference p = apexPages.currentPage();
        PageReference p=new PageReference('/'+IPLA.Id);
        system.debug('p$$$l'+p);
        return p;
        }

        }
        
     
        }
    
           
      
     public PageReference cancel() {
        if(parentId!=null)
        {
        PageReference p= new PageReference('/'+ parentId);
        return p;
        }
        else
        {
        PageReference p = apexPages.currentPage();
        //PageReference p=new PageReference('/'+IPLA.Id);
        return p;
        }
        
    }
   


}