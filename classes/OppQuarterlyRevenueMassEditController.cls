/*
    Author: 
    Description:
    History:
        YKumar  21012014    - Add 4 fields(High Vol,LoW Vol) in the select query (getSelectedSorted()).
        ZAmbat  06112013    - Updated code as per CASE 12202.
*/
public class OppQuarterlyRevenueMassEditController
{
     ApexPages.StandardSetController stdSetController;
     public String OpportunityId{get;set;}
     public String OpportunityName{get;set;}
     public String AccountName{get;set;}
     public String Deliverabletype{get;set;}     
     public Boolean CanEdit{get;set;}
     public Boolean NoRecordsSelected{get;set;}
     public Id userId = Userinfo.getUserId();
     public Boolean EditMode{get;set;}
     public Boolean ReadMode{get;set;}
     Map<String,Environment_Variable__c> RolePermission = new Map<String,Environment_Variable__c>();
     User u = [Select u.Name, u.Profile.Name From User u where id=:userId limit 1];
     public id currentUserRoleId= userInfo.getUserRoleId();
     
     
    
     
     public OppQuarterlyRevenueMassEditController(ApexPages.StandardSetController stdSetController) 
     {
        this.stdSetController = stdSetController;
        this.stdSetController.setSelected(getSelectedSorted());
        ReadMode=true;
        EditMode=false;
        if(currentUserRoleId !=null)
        {
            UserRole r= [Select r.Name From UserRole r where id=:currentUserRoleId limit 1];
            RolePermission=Environment_Variable__c.getall();
            system.debug('@@@@@@@@@@@@@@RolePermission@@@@@@@@'+r.Name + '>>>>>>>>>>' +RolePermission);
            if(RolePermission.containsKey(r.name))
            {
                checkVisibility(r.Name);
            }
        }
        checkAccess();
        
     }
    public void checkVisibility(string RoleName)
    {
        System.debug('@@@@>>>>>>>>>@@@@@@@@'+RolePermission.get(RoleName).Value__c+'>>>>>>>>'+RoleName);
        if(RolePermission.get(RoleName).Value__c=='E')
        {
            ReadMode=false;
            EditMode=true;
            
        }
       
        else
        {
            ReadMode=true;
            EditMode=false;
            
        }
    
     }
     public void checkAccess()
     {
       List<OpportunityShare> oppShares = [select Id,OpportunityId,UserOrGroupId,OpportunityAccessLevel,RowCause from OpportunityShare where OpportunityId = :OpportunityId and UserOrGroupId = :UserInfo.getUserId() ];
       String al = null;
       Boolean write = false;
       for(OpportunityShare oppShare:oppShares)
       {
           al = oppShare.OpportunityAccessLevel;
           if((al == 'Edit')||(al == 'All'))
           {
             write = true;
             break;
           }
       }
       
       CanEdit = write;
       
        // ZAmbat 05092014
        // Check if current user is a member of the Quarterly Revenue Users Public Group
        if (CanEdit == false) {
            Group qrGroup = [
                SELECT      Id
                FROM        Group
                WHERE       Name = :Environment_Variable__c.getInstance('QUARTERLY_REVENUE_GROUP').Value__c
                LIMIT 1
            ];
            
            boolean isMember = false;
            for (GroupMember gm : [SELECT   UserOrGroupId
                                   FROM     GroupMember
                                   WHERE    GroupId = :qrGroup.Id]) {
                if (gm.UserOrGroupId == UserInfo.getUserId()) {
                    isMember = true;
                    break;
                }
            }
            
            if (isMember) {
                CanEdit = true;
            }     
        }
        
        system.debug('>>>>>>CanEdit<<<<<<<<'+CanEdit);
     }
     
    public List<Quarterly_Revenue_Object__c> getSelectedSorted()
    {
       List<Quarterly_Revenue_Object__c> ulist = (List<Quarterly_Revenue_Object__c>)stdSetController.getSelected();
       
       Id qtrId = (Id)ApexPages.currentPage().getParameters().get('id');
       
           List<Quarterly_Revenue_Object__c> qlist;       

       if (ulist!=null && !(ulist.isEmpty()))
       {
                qlist = [SELECT id, Wafer_ASP__c,Net_Parts_Per_Wafer__c , ASP_Module_Chip__c,Post_Wafer_ASP_Module_ASP__c,Volume_Module_Chip__c,Wafer_Vol__c, Module_Die_ASP__c,Module_Die_Vol__c,Opportunity__r.Net_Parts_Per_Wafer__c,CreatedDate, name, Fiscal_Quarter__c, ASP__c, Volume__c,Revenue__c, Date__c, Count__c, Opportunity__c, Opportunity__r.Name, Opportunity__r.Deliverable_Type__c, Opportunity__r.Account.Name,RMT_Volume__c,SVP_ASP__c,SVP_Volume__c,RMT_ASP__c,Turnkey_ASP__c from Quarterly_Revenue_Object__c where id in :ulist];
       }else
       {
                qlist = [SELECT id, Wafer_ASP__c,Net_Parts_Per_Wafer__c ,ASP_Module_Chip__c,Post_Wafer_ASP_Module_ASP__c,Volume_Module_Chip__c, Wafer_Vol__c,Module_Die_ASP__c,   Module_Die_Vol__c,Opportunity__r.Net_Parts_Per_Wafer__c,CreatedDate, name, Fiscal_Quarter__c, ASP__c, Volume__c,Revenue__c, Date__c, Count__c, Opportunity__c, Opportunity__r.Name, Opportunity__r.Deliverable_Type__c, Opportunity__r.Account.Name,RMT_Volume__c,SVP_ASP__c,SVP_Volume__c,RMT_ASP__c,Turnkey_ASP__c from Quarterly_Revenue_Object__c where id =:qtrId];
       }     
         
       NoRecordsSelected = (qList.size() == 0);
       

        List< QRWrapper> tlist = new List< QRWrapper>();
       List<Quarterly_Revenue_Object__c> slist = new List<Quarterly_Revenue_Object__c>();
       
       for(Quarterly_Revenue_Object__c qr:qlist)
       {
          OpportunityId = qr.Opportunity__c;
          OpportunityName = qr.Opportunity__r.Name;
          AccountName = qr.Opportunity__r.Account.Name;
          Deliverabletype = qr.Opportunity__r.Deliverable_Type__c;
          tlist.add(new QRWrapper(qr));
       }
       
       
       tlist.sort();
       for(QRWrapper qrw: tlist)
       {
          slist.add(qrw.getQuarterlyRevenue());
       }
       
       
      system.debug('>>>>>>NoRecordsSelected()<<<<<<<<'+NoRecordsSelected);
       return slist;
    }
    
    public class QRWrapper implements Comparable
    {
        Quarterly_Revenue_Object__c qr = null;
        QRWrapper(Quarterly_Revenue_Object__c qr)
        {
            this.qr = qr;
        }
        
        public Quarterly_Revenue_Object__c getQuarterlyRevenue()
        {
           return this.qr;
        }
        
        public Integer compareTo(Object compareTo) {
           QRWrapper otherWrapper = (QRWrapper)compareTo;       
           Quarterly_Revenue_Object__c other = otherWrapper.getQuarterlyRevenue();
           
           if((qr.Date__c!=null)&&(other.Date__c!=null)&&(qr.Date__c > other.Date__c))
           {
               return 1;
           }
           
         
     
           return -1;
        }
    }
    
}