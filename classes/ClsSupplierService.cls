/*
 Type Name: ClsSupplierServiceDoc
 Author: Cognizant Technology Solutions
 Created Date: 04-Sep-2013
 Reason: This class is responsible for showing Supplier Service tab for portal user.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/

public with sharing class ClsSupplierService 
{
    
    /**
    
    Variable Declaration
    
    */
    
    public String Page {get; set;}
    public String OpenPageURL {get; set;}
    public String OpenTextLoginServerURL {get; set;}
    public String  respectiveLevel{get; set;}
    public String portalLoginUser;
    public Boolean showwelcomesection{get;set;}
    public Boolean showdetailsection{get;set;}
    public Boolean showpageBlock{get;set;}
    public boolean showmsqsLink{get;set;}
    public boolean showsesLink{get;set;}
    public boolean showpraLink{get;set;}
    public boolean showwdsLink{get;set;}
    public boolean showsimiLink{get;set;}
    public boolean showtirLink{get;set;}
    public boolean showprocLink{get;set;}
    public boolean showsaoLink{get;set;}
    public boolean showEHSLink{get;set;}
    public boolean showiCNLink{get;set;}    
    public boolean showASLink{get;set;}

    public List<Portal_Tab_Access__c> portaltabaccessList = new List<Portal_Tab_Access__c>();
    User userObj = new User();
    
     
    public ClsSupplierService ()
    {
    
         userObj = [SELECT accountId,FederationIdentifier,userType FROM User WHERE Id =:userInfo.getUserId()];
         portaltabaccessList = [Select Material_Selection_Qualififcation__c, 
                                       Supplier_eCOA_Submission__c, 
                                       Procedure_Review_Acceptance__c, 
                                       Wafer_Disposition_System__c,
                                       Turnkey_Incident_Report__c,
                                       Supplier_Procedure__c,
                                       SQE_Applications_Overview__c,
                                       EHS_Policy__c,   
                                       Change_Notification__c, 
                                       Specs_Acknowledgement__c
                                       from Portal_Tab_Access__c p
                                       WHERE p.User__c = :userInfo.getUserId()
                                           AND p.Account__c =:userObj.accountId order by createddate desc limit 1 ];
                                           
          if(userObj.UserType == System.Label.Standard)
        {
           showmsqsLink = showsesLink =showpraLink = showwdsLink = showtirLink = showprocLink = 
           showsaoLink = showEHSLink = showASLink = showsimiLink =showiCNLink=TRUE;
            
        }
        else if(portaltabaccessList.size()>0)
        {   showsimiLink =TRUE;
            for(Portal_Tab_Access__c portaltabaccessObj : portaltabaccessList)
            {
                if(portaltabaccessObj.Material_Selection_Qualififcation__c){
                  showmsqsLink = True;
                }
                else 
                  showmsqsLink = False;
                if(portaltabaccessObj.Supplier_eCOA_Submission__c){
                  showsesLink = True;
                }
                else 
                  showsesLink = False;
                if(portaltabaccessObj.Procedure_Review_Acceptance__c){
                  showpraLink = True;
                }
                else 
                  showpraLink = False;
                if(portaltabaccessObj.Wafer_Disposition_System__c){
                  showwdsLink = True;
                }
                else 
                  showwdsLink = False;
                if(portaltabaccessObj.Turnkey_Incident_Report__c){
                  showtirLink = True;
                }
                else 
                  showtirLink = False;
                if(portaltabaccessObj.Supplier_Procedure__c){
                  showprocLink = True;
                }
                else 
                  showprocLink = False;
                if(portaltabaccessObj.SQE_Applications_Overview__c){
                  showsaoLink = True;
                }
                else 
                  showsaoLink = False;
                if(portaltabaccessObj.EHS_Policy__c){
                  showEHSLink = True;
                }
                else 
                  showEHSLink = False;
                if(portaltabaccessObj.Specs_Acknowledgement__c){
                  showASLink = True;
                }
                else 
                  showASLink = False;
                if(portaltabaccessObj.Change_Notification__c){
                  showiCNLink = True;
                }
                else 
                  showiCNLink = False;
            }
        }
          
        Page = '' ;
        OpenPageURL = '' ;
        showwelcomesection = True;
        showdetailsection = False;
        if(userInfo.getusertype()=='CustomerSuccess' || userInfo.getusertype()=='PowerCustomerSuccess')
            portalLoginUser = userObj.Federationidentifier ;   
        else 
            portalLoginUser = null;        
        OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;
        respectiveLevel = System.Label.Supplier_Service_Doc;
    }
    
    /**
        This method is used to redirect the new web page according to the links are specified .
        
        @method name: redirect
        @return : returns the new web site according to the links
         
     */
    
    public PageReference redirect()
    {
        if(Page == 'msqs')
        {
            showwelcomesection = True;
            showdetailsection = False;
            showpageBlock= False; 
            OpenPageURL = System.Label.Material_Selection_Qualification_SystemUrl;
            respectiveLevel = System.Label.Material_Selection_Qualification_System;
            
        }
        if(Page == 'ses')
        {
            showwelcomesection = True;
            showdetailsection = False;
            showpageBlock= False;
            OpenPageURL = System.Label.Supplier_eCOA_SubmissionUrl;
            respectiveLevel = System.Label.Supplier_eCOA_Submission;
        
        }

        if(Page == 'pra')
        {
            showwelcomesection = True;
            showdetailsection = False;
            showpageBlock= False;
            OpenPageURL = System.Label.Procedure_Review_AcceptanceURL;
            respectiveLevel = System.Label.Procedure_Review_Acceptance;
        
        }

              if(Page == 'wds')
        {
            showwelcomesection = True;
            showdetailsection = False;
            showpageBlock= False; 
            OpenPageURL = System.Label.Wafer_Disposition_ReportUrl;
            respectiveLevel = System.Label.Wafer_Disposition_Report;
        
        }
                if(Page == 'simi')
        {
            showwelcomesection = True;
            showdetailsection = False;
            showpageBlock= False; 
            OpenPageURL = System.Label.Supplier_Incoming_Material_Incidents_IMI_URL;
            respectiveLevel = System.Label.Supplier_Incoming_Material_Incidents_IMI;
        
        }
        
        if(Page == 'tir')
        {
            showwelcomesection = True;
            showdetailsection = False;
            showpageBlock= False;
            OpenPageURL = System.Label.Turnkey_Incident_ReportUrl;
            respectiveLevel = System.Label.Turnkey_Incident_Report;
        
        }
        
         if(Page == 'proc')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.Procedure_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.Procedure;
        
        }

     if(Page == 'sao')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.SQE_Applications_OverviewUrl+'&username='+portalLoginUser;
            respectiveLevel = System.Label.SQE_Applications_Overview;
        
        }
     if(Page == 'ehs')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.EHS_Policy_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.EHS_Policy;
        
        }
        if(Page == 'sal')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.Specs_AcknowledgementURL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.Specs_Acknowledgement;
        
        }
         if(Page == 'iCN')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.Change_Notification_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.Change_Notification;
        
        }

        return null;
    }
}