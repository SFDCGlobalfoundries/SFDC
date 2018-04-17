/*
Type Name: ClsPdkDesignDoc
Author: Cognizant Technology Solutions
Created Date: 19-April-2013
Reason: This class is responsible for showing the PDK & Design Documents for portal user.
Change History:Case-4331
Author: Cognizant FV Team
Modified Date: Jan-08-2014
Reason: Replacing Portal Login ID with Federation ID
Modified Date: Aug-04-2015
Reason: showdesignspecLink = False so that Design Specification Packages is not visible on GFV
Modified Date: Oct-13-2015
Reason: Included logic for New link PDK FTP Inbox on GFV for case # 00047919.
Modified Date: 1/10/2017 Dinesh
Reason: ncluded logic for New Link PDK Installation Guide and PDK Installation Quick OverView on GFV.

…….. 
……..
*/

public with sharing class ClsPdkDesignDoc 
{
    
    /**

Variable Declaration

*/
    
    public String Page {get; set;}
    public String OpenPageURL {get; set;}
    public String OpenTextLoginServerURL {get; set;}
    public String  respectiveLevel{get; set;}
    public Boolean showdesignspecLink {get;set;}
    public Boolean showdesigntechLink {get;set;}
    public Boolean showcreationformLink{get;set;}
    public Boolean showptrfLink{get;set;}
    public Boolean showpdkLink{get;set;}
    public Boolean showpdkftpLink {get;set;}
    public Boolean showipplmLink {get;set;}
    public String portalLoginUser;
    public Boolean showwelcomesection{get;set;}
    public Boolean showdetailsection{get;set;}
    public Boolean showpageBlock{get;set;}
    public Boolean showASICnewsandalertsLink {get;set;}
    public Boolean showASICdkdesignkitsLink {get;set;}
    public Boolean showASICdocumentationLink {get;set;}
    public Boolean showASIC {get;set;}
    
    public List<Portal_Tab_Access__c> portaltabaccessList = new List<Portal_Tab_Access__c>();
    User userObj = new User();
    
    
    /**
This method controls to showing the Links in the left hand panel and to
create the Pageblock table where showing the PDK & Design documents list.

@method name: ClsPdkDesignDoc
@return : Boolean variables are set to true according to the Portal Tab Access record and 
returns the test data in the respective pageblock table.
*/
    
    
    public ClsPdkDesignDoc ()
    {
        
        //Case-4331:Adding Federation ID in query:Change-001
        userObj = [SELECT accountId,FederationIdentifier,Portal_Login__c,userType,Contact.AccountId FROM User WHERE Id =:userInfo.getUserId()];
        portaltabaccessList = [Select p.Design_Specification_Packages__c, 
                               p.Design_Technology_Documents__c, 
                               p.New_Part_Creation_after_Proto_form__c, 
                               p.PDK__c, 
                               p.IP_PLM__c,
                               p.PDK_FTP_Inbox__c,
                               p.PTRF__c ,
                               Access_Setup_News_Alerts_ASIC__c,
                               Access_Setup_Design_Kits_ASIC_DK__c,
                               Access_Setup_Documentation_ASIC__c,
                               Account__r.ASIC_Business_Flag__c
                               from Portal_Tab_Access__c p
                               WHERE p.User__c = :userInfo.getUserId()
                               AND p.Account__c =:userObj.accountId ];
        
        if(userObj.userType == System.Label.Standard)
        {
            showdesigntechLink = showcreationformLink = showpdkLink = showptrfLink = showipplmLink = showASICnewsandalertsLink = showASICdkdesignkitsLink = showASICdocumentationLink= showASIC = TRUE;
            showdesignspecLink = False;
            // Inluded logic for PDF FTP Link for Case # 00047919.
            showpdkftpLink = TRUE;
        }
        
        else if(portaltabaccessList.size()>0)
        {
            for(Portal_Tab_Access__c portaltabaccessObj : portaltabaccessList)
            {
                if(portaltabaccessObj.Design_Specification_Packages__c == TRUE)
                    showdesignspecLink = TRUE;
                else
                    showdesignspecLink = FALSE;
                
                if(portaltabaccessObj.Design_Technology_Documents__c == TRUE)
                    showdesigntechLink = TRUE;
                else
                    showdesigntechLink = FALSE;
                
                if(portaltabaccessObj.New_Part_Creation_after_Proto_form__c == TRUE)
                    showcreationformLink = TRUE;
                else
                    showcreationformLink = FALSE;
                
                if(portaltabaccessObj.PDK__c == TRUE)
                    showpdkLink = TRUE;
                else
                    showpdkLink = FALSE;
                // Inluded logic for PDF FTP Link for Case # 00047919.
                if(portaltabaccessObj.PDK_FTP_Inbox__c == TRUE)
                    showpdkftpLink = TRUE;
                else
                    showpdkftpLink = FALSE;
                // Inluded logic for PDF FTP Link for Case # 00047919.
                
                if(portaltabaccessObj.PTRF__c == TRUE)
                    showptrfLink = TRUE;
                else
                    showptrfLink = FALSE;
                
                if(portaltabaccessObj.IP_PLM__c== TRUE)
                    showipplmLink = TRUE;
                else
                    showipplmLink = FALSE;
                if(portaltabaccessObj.Access_Setup_News_Alerts_ASIC__c == TRUE)
                    showASICnewsandalertsLink = TRUE;
                else
                    showASICnewsandalertsLink = FALSE;    
                if(portaltabaccessObj.Access_Setup_Design_Kits_ASIC_DK__c == TRUE)
                    showASICdkdesignkitsLink = TRUE;
                else
                    showASICdkdesignkitsLink = FALSE;
                if(portaltabaccessObj.Access_Setup_Documentation_ASIC__c == TRUE)
                    showASICdocumentationLink = TRUE;
                else
                    showASICdocumentationLink = FALSE;
                if(portaltabaccessObj.Account__r.ASIC_Business_Flag__c == TRUE)
                    showASIC = TRUE;
                else
                    showASIC = FALSE;
            }
        }
        
        Page = '' ;
        OpenPageURL = '' ;
        showwelcomesection = True;
        showdetailsection = False;
        //Case-4331:Replacing Portal Login ID with Federation ID:Change-002
        //portalLoginUser = userObj.Portal_Login__c;
        if(userInfo.getusertype()=='CustomerSuccess' || userInfo.getusertype()=='PowerCustomerSuccess')
            portalLoginUser = userObj.Federationidentifier ;   
        else 
            portalLoginUser = null;        
        OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;
        respectiveLevel = System.Label.PDK_Design_Doc;
    }
    
    /**
This method is used to redirect the new web page according to the links are specified .

@method name: redirect
@return : returns the new web site according to the links

*/
    
    public PageReference redirect()
    {
        if(Page == 'designspec')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.Design_Spec_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.Design_Spec;
            
        }
        if(Page == 'designtechdoc')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.Design_Tech_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.Design_Tech_Doc;
            
        }
        
        if(Page == 'pdk')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.PDK_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.PDK;
            
        }
        
        if(Page == 'ipkit')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.IP_PLM_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.IP_PLM;
            
        }
        
        
        if(Page == 'new_part_creation')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL =System.Label.New_Part_Create_PDK_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.New_Part_Create;
            
        }
        
        if(Page == 'ptrf')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL =System.Label.PTRF_PDK_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.PTRF;
            
        }
        //Added by Sameera  (START)
        
        if(Page == 'ASICnewsalerts')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.ASIC_News_and_Alerts_URL;
            respectiveLevel = System.Label.ASIC_News_and_Alerts;
            
        }
        
        if(Page == 'ASICdkdesignkits')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.ASIC_DK_Design_Kits_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.ASIC_DK_Design_Kits;
            
        }
        if(Page == 'ASICdocumentation')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            OpenPageURL = System.Label.ASIC_Documentation_URL+'&username='+portalLoginUser;
            respectiveLevel = System.Label.ASIC_Documentation;
            
        }
        //Added by Ravikiran Nadella
        if(Page == 'PDK910Outlook'){
            
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True; 
            Environment_Variable__c PDK  = Environment_Variable__c.getInstance('PDK Outlook');
            if(PDK<>null){
                OpenPageURL = PDK.value__c;
            }
            Environment_Variable__c PDKR  = Environment_Variable__c.getInstance('PDK respective');
            if(PDKR<>null){
                respectiveLevel = PDKR.value__c;    
            }
            
            
        }
        system.debug('****pagenamePK***'+page);
        system.debug('****OpenPageURLPK***'+OpenPageURL);
        system.debug('****respectiveLevelPK***'+respectiveLevel);
        
        //Added by Sameera (STOP)
        return null;
    }
    public pageReference FTPswitch() {
        
        showwelcomesection = False;
        showdetailsection = True;
        showpageBlock= True; 
        OpenPageURL =System.Label.PDK_FTP_Inbox_URL+'&username='+portalLoginUser;
        PageReference pageRef = new PageReference(OpenPageURL );
        pageRef.setRedirect(true);
        return pageRef;
    }    
    
    /****Added by Dinesh 10/01/2017****/
    
    public pageReference PDKInstallation() {
        
        showwelcomesection = False;
        showdetailsection = True;
        showpageBlock= True; 
        OpenPageURL =System.Label.PDK_Installation_Guide_URL;
        PageReference pageRef = new PageReference(OpenPageURL );
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    public pageReference PDKInstallationQuick() {
        
        showwelcomesection = False;
        showdetailsection = True;
        showpageBlock= True; 
        OpenPageURL =System.Label.PDK_Installation_Quick_Overview_URL;
        PageReference pageRef = new PageReference(OpenPageURL );
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    
    // This blank method is called by action poller method on corresponding VF page in order to maintain session for longer period.
    public pageReference maintainSession(){
        return null;
    }
}