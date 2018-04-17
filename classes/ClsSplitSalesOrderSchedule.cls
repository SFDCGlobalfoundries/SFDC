/*
 Type Name: ClsSplitSalesOrderSchedule
 Author: Cognizant Technology Solutions
 Created Date: 3-Nov-2016
 Reason: This class is used for splitting the sales order schedule records and creating early warning
 Change History: 
 */

Public without sharing class ClsSplitSalesOrderSchedule
{ 
    
    public Sales_Order_Schedule__c salesOrder {get;set;}
    public List<Early_Warning_Status__c> Earlywarninglist {get;set;}
    public Map<String, String> mapofreasoncodes {get;set;} 
    private List<Early_Warning_Status__c> del_EWS = new List<Early_Warning_Status__c>();
    public List<Early_Warning_Status__c> upsertEarlywarninglist = new List<Early_Warning_Status__c>();
    private String soID;
    public Boolean isEditable {get;set;}
    Map<Id, Early_Warning_Status__c> mapID_To_CurrentEarlyWarning = new Map<Id, Early_Warning_Status__c>();
    Decimal decHighestVersion;
    
    public ClsSplitSalesOrderSchedule()
    {
        isEditable = false;
        
        for (GroupMember gm : [SELECT Id, group.id, group.name, group.type FROM GroupMember where UserOrGroupId = :UserInfo.getUserId() AND group.developername = 'Fab_9_10_Supply_Analysts'])
        {
            isEditable = true;
        }
        
        soID = ApexPages.currentPage().getParameters().get('id');
        salesOrder = [SELECT Name,SalesOrder_Account__c,Confirmed_Date__c,Cum_Cf_Qty__c,EWS_FLAG__c FROM Sales_Order_Schedule__c where id=:soID];
                                                               
        mapofreasoncodes = new Map<String, String>();
        Earlywarninglist = new List<Early_Warning_Status__c>();
        
        for(Early_Warning_REASON_CODES__c codes : [Select id, Name,EXT_REASON__c,INT_REASON__c from Early_Warning_REASON_CODES__c]) 
        {
            mapofreasoncodes.put(codes.INT_REASON__c,codes.EXT_REASON__c);
        } 
        
        for(Early_Warning_Status__c ews : [SELECT name,Sales_Order1__c,EW_Status__c, Version_id__c, EWS_FLAG__c,Available_Quantity__c,Is_Delivered__c,AVAIL_DATE__c,REASON_CODE__c,
                                           Internal_Reason_Code__c,Extrnal_Reason_Code__c,Internal_Comments__c,External_Comments__c,Sales_Order1__r.Confirmed_Date__c
                                           FROM Early_Warning_Status__c WHERE Sales_Order1__c =:soID ORDER BY Version_Id__c DESC])
        {
            if(decHighestVersion != null && ews.Version_Id__c < decHighestVersion)
                continue;
                
            decHighestVersion = ews.Version_Id__c;
            
            
            Earlywarninglist.add(ews);
            Early_Warning_Status__c ews_currentVersion = new Early_Warning_Status__c(Version_id__c = ews.Version_Id__c, 
                                                                                     Available_Quantity__c = ews.Available_Quantity__c,
                                                                                     AVAIL_DATE__c = ews.AVAIL_DATE__c,
                                                                                     EWS_FLAG__c = ews.EWS_FLAG__c,
                                                                                     Internal_Reason_Code__c = ews.Internal_Reason_Code__c,
                                                                                     Internal_Comments__c = ews.Internal_Comments__c,
                                                                                     External_Comments__c = ews.External_Comments__c,
                                                                                     Extrnal_Reason_Code__c = ews.Extrnal_Reason_Code__c,
                                                                                     Sales_Order1__c = ews.Sales_Order1__c,
                                                                                     EW_Status__c = ews.EW_Status__c);
            mapID_To_CurrentEarlyWarning.put(ews.id,  ews_currentVersion);
        }
    }
    
   
    public List<SelectOption> getInternalComments()
    {
        List<SelectOption> lstSO = new List<SelectOption>();
        lstSO.add(new SelectOption('', '--None--'));
        for(String s : mapofreasoncodes.keyset())
        {
            lstSO.add(new SelectOption(s, s));
        }
        
        return lstSO;
    }
    
    public void findExternalReasonCode()
    {
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));
        Earlywarninglist[indexVal].Extrnal_Reason_Code__c = mapofreasoncodes.get(Earlywarninglist[indexVal].Internal_Reason_Code__c);
    }
    
    
    public void AddRow() 
    {
        Early_Warning_Status__c erecord= new Early_Warning_Status__c();
        erecord.Sales_Order1__c = soID;
        erecord.Internal_Reason_Code__c = '';
        Earlywarninglist.add(erecord);
    }
    
    public PageReference cancel() 
    {
        PageReference pg = new PageReference('/'+soID);
        return pg;
    }


    public void DelRow() 
    {
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));
        del_EWS.add(Earlywarninglist[indexVal]);
        Earlywarninglist.remove(indexVal);
    }
 
    
    
    public PageReference save() 
    {
        
       Decimal total=0;
       Boolean error=false;
       Boolean errorforReasonCode=false;
       string EWname='';
       
        for(Early_Warning_Status__c rec: Earlywarninglist)
        {
            if(rec.Available_Quantity__c != null)
            {
                total = total+rec.Available_Quantity__c;
            }
            
            if(rec.EWS_FLAG__c=='L' && (rec.Internal_Reason_Code__c == null || rec.Internal_Reason_Code__c == ''))
            {
                errorforReasonCode = True;
            }
        }
        
        if(total != salesOrder.Cum_Cf_Qty__c)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Early Warning Total Available Quantity should be equal to Sales Order Confirmed Quantity'));
            return null;
        }
        else if(errorforReasonCode)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'For every EWS Flag=L,Internal Reason Code should be entered'));
            return null;
        }
        
        
        List<Early_Warning_Status__c> insert_EWS = new List<Early_Warning_Status__c>();
        //List<Early_Warning_Status__c> updateEWS = new List<Early_Warning_Status__c>();
        
        //mapID_To_CurrentEarlyWarning
        //List<Early_Warning_Status__c> lst_EWS_NewVersion = new List<Early_Warning_Status__c>();
        //Set<Id> set_NewVersion_EWS_IDs = new Set<Id>();
        
        Decimal newVersion; 
        
        for(Early_Warning_Status__c rec: Earlywarninglist)
        {
            if((rec.id != null && 
               (rec.Available_Quantity__c != mapID_To_CurrentEarlyWarning.get(rec.id).Available_Quantity__c ||
               rec.AVAIL_DATE__c != mapID_To_CurrentEarlyWarning.get(rec.id).AVAIL_DATE__c ||
               rec.EWS_FLAG__c != mapID_To_CurrentEarlyWarning.get(rec.id).EWS_FLAG__c ||
               rec.Internal_Reason_Code__c != mapID_To_CurrentEarlyWarning.get(rec.id).Internal_Reason_Code__c ||
               rec.Internal_Comments__c != mapID_To_CurrentEarlyWarning.get(rec.id).Internal_Comments__c ||
               rec.External_Comments__c != mapID_To_CurrentEarlyWarning.get(rec.id).External_Comments__c)) ||
               rec.id == null)
            {
                newVersion = decHighestVersion != null ? decHighestVersion + 1 : 1; 
                break;
                
                /*Early_Warning_Status__c ews_newVersion = new Early_Warning_Status__c(Version_id__c = newVersion, 
                                                                                     Available_Quantity__c = rec.Available_Quantity__c,
                                                                                     AVAIL_DATE__c = rec.AVAIL_DATE__c,
                                                                                     EWS_FLAG__c = rec.EWS_FLAG__c,
                                                                                     Internal_Reason_Code__c = rec.Internal_Reason_Code__c,
                                                                                     Internal_Comments__c = rec.Internal_Comments__c,
                                                                                     External_Comments__c = rec.External_Comments__c,
                                                                                     Extrnal_Reason_Code__c = rec.Extrnal_Reason_Code__c,
                                                                                     Sales_Order1__c = rec.Sales_Order1__c,
                                                                                     EW_Status__c = rec.EW_Status__c);
                lst_EWS_NewVersion.add(ews_newVersion);
                system.debug('-----------added to list-------'+ews_newVersion);
                set_NewVersion_EWS_IDs.add(rec.id);*/
            }
        }
        
        if(newVersion != null)
        {
            for(Early_Warning_Status__c rec: Earlywarninglist)
            {
                if(rec.id != null)
                {
                    Early_Warning_Status__c ews_newVersion = new Early_Warning_Status__c(Version_id__c = newVersion, 
                                                                                         Available_Quantity__c = rec.Available_Quantity__c,
                                                                                         AVAIL_DATE__c = rec.AVAIL_DATE__c,
                                                                                         EWS_FLAG__c = rec.EWS_FLAG__c,
                                                                                         Internal_Reason_Code__c = rec.Internal_Reason_Code__c,
                                                                                         Internal_Comments__c = rec.Internal_Comments__c,
                                                                                         External_Comments__c = rec.External_Comments__c,
                                                                                         Extrnal_Reason_Code__c = rec.Extrnal_Reason_Code__c,
                                                                                         Sales_Order1__c = rec.Sales_Order1__c,
                                                                                         EW_Status__c = rec.EW_Status__c);
                    insert_EWS.add(ews_newVersion);
                }
                else if(rec.id == null)
                {
                    rec.Version_id__c = decHighestVersion == null ? 1 : newVersion;
                    Early_Warning_Status__c ews_newVersion = new Early_Warning_Status__c(Version_id__c = rec.Version_id__c, 
                                                                                         Available_Quantity__c = rec.Available_Quantity__c,
                                                                                         AVAIL_DATE__c = rec.AVAIL_DATE__c,
                                                                                         EWS_FLAG__c = rec.EWS_FLAG__c,
                                                                                         Internal_Reason_Code__c = rec.Internal_Reason_Code__c,
                                                                                         Internal_Comments__c = rec.Internal_Comments__c,
                                                                                         External_Comments__c = rec.External_Comments__c,
                                                                                         Extrnal_Reason_Code__c = rec.Extrnal_Reason_Code__c,
                                                                                         Sales_Order1__c = rec.Sales_Order1__c,
                                                                                         EW_Status__c = rec.EW_Status__c);
                    insert_EWS.add(rec);
                }
            }
        }
    
        
        if(!insert_EWS.isEmpty())   insert insert_EWS;
        //if(!updateEWS.isEmpty())   update updateEWS;
        
        List<Early_Warning_Status__c> lstDel = new List<Early_Warning_Status__c>();
        for(Early_Warning_Status__c ews : del_EWS)
        {
            if(ews.id != null)
            {
                lstDel.add(ews);
            }
        }
        
        //if(!lstDel.isEmpty())   delete lstDel;
        
        return new PageReference('/'+soID);
    }

    

    
    
    
}