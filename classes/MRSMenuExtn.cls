/*
Type Name: MRSMenuExtn
Author: Cognizant 
Created Date: 24-April-2014
Reason: This will be the controller class behind the Visualforce Page VFMRSMenu.
Change History:
- 16-June-2015: SWIFT Team refactor if/else statement, reduce code statement executed
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
��..
��..
*/

public with sharing class MRSMenuExtn {
    
    public Boolean showdetailsection {get;set;}
    public String  Page{get; set;}
    public String respectiveLevel {get;set;}
    public String  OpenPageURL {get; set;}
    //---------------------Flags for rendering the links--------------------------------------//
    public Boolean showRemoteJobviewLink {get; private set;}
    public Boolean showFrameMockupLink {get; private set;}
    public Boolean showGDSOUTReviewLink {get; private set;}
    public Boolean showMEBBESLink {get; private set;}
    public Boolean showSendData{get; private set;}
    public Boolean showHoldAndResume{get; private set;}
    public Boolean showFoundryFrameMockupLink {get; private set;}
    public Boolean showFoundryGDSOUTReview {get; private set;}
    public Boolean showFoundryMEBBESReviewLink {get; private set;}
    public Boolean showTapeOutCenterReviewLink {get; private set;}
    public Boolean showTapeOutApplicationReviewLink {get; private set;}
    public Boolean showGlobalShuttleReviewLINK { get; private set;}
    public Boolean showMDPReviewLink {get; private set;}
    public Boolean showTDTIReviewLink {get; private set;}
    public Boolean showFrameSendData {get; private set;}
    public Boolean showPrimeSendData {get; private set;}
    public Boolean showHoldResumeButton { get; private set;}
    public static Cookie account;
    public static Cookie mst;
    public String  parameter{get;set;}
    public List<GroupMember>  groupMemberlst {get;set;} {groupMemberlst = new List<GroupMember>();}
    public Map<Id,GroupMember> groupIdAndGroupMemberMap {get;set;} {groupIdAndGroupMemberMap = new Map<Id,GroupMember>(); }
    public Map<String,MRS_Fields_Permission_Config__c> mrsFieldPermissionConfig {get;set;} { mrsFieldPermissionConfig  = MRS_Fields_Permission_Config__c.getAll(); }
    /** This is the constructor of the class **/
    
    public MRSMenuExtn(){
        User  userObj = [SELECT accountId,Portal_Login__c,UserType,Parent_Account_Short_Name__c,FederationIdentifier,Id FROM User WHERE Id =:userInfo.getUserId()];
        
        groupMemberlst = [Select Id,UserOrGroupId,GroupId FROM GroupMember WHERE UserOrGroupId =:userObj.Id];
        
        if(groupMemberlst != null)
        {
          for(GroupMember groupObj : groupMemberlst  )
          {
              groupIdAndGroupMemberMap.put(groupObj.GroupId,groupObj);
          }
        }
       
       //System.debug(':::::::mrsFieldPermissionConfig  ::'+mrsFieldPermissionConfig  );
       if(mrsFieldPermissionConfig != null )
       {
         //system.debug('%%%%mrsFieldPermissionConfig %%%');
         List<String> lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
           Profile profileObj =[SELECT Name, Id FROM Profile WHERE Id =:UserInfo.getProfileId()];
           //system.debug('$$$lstTeamRoles $$'+lstTeamRoles );
           List<Account_Team_Proxy__c> accountTeamProxy = [SELECT Account__c,User__c FROM Account_Team_Proxy__c WHERE User__c =:UserInfo.getUserId() AND Team_Role__c IN :lstTeamRoles];
           
           if(profileObj.Name=='System Administrator')
           {
           //system.debug('admin:');
               showFrameMockupLink = true;
               showGDSOUTReviewLink = true;
               showMEBBESLink  = true;
               showSendData = true;
               showHoldAndResume = true;
               showFoundryFrameMockupLink = true;
               showFoundryGDSOUTReview = true;
               showFoundryMEBBESReviewLink = true;
               showTapeOutCenterReviewLink = true;
               showTapeOutApplicationReviewLink = false;//swgp-859
               showGlobalShuttleReviewLINK = true;
               showMDPReviewLink =true;
               showTDTIReviewLink =true;
               showPrimeSendData = true;
               showFrameSendData = true;
               showHoldResumeButton = true;
           }
           else if(groupIdAndGroupMemberMap != null && groupIdAndGroupMemberMap.size()>0)
           {
           //system.debug('group:');
               List<Group> grouplst =[Select Id,DeveloperName from Group where Id =:groupIdAndGroupMemberMap.keySet() 
                                      and DeveloperName IN :mrsFieldPermissionConfig.keySet()];
               Map<String,Group> groupNameMap = new Map<String,Group>();
               
               if(grouplst !=null && grouplst.size() > 0)
               {
                   for(Group groupObj : grouplst )
                   {
                       groupNameMap.put(groupObj.DeveloperName,groupObj);
                   }
               
               if(groupNameMap!= null && groupNameMap.size()>0)
               {
                  
                   for(String groupName : groupNameMap.keySet())
                   
                   {
                   //system.debug('groupname:' + groupName);
                   
                        if(groupName.equalsIgnoreCase('SWIFT_Admin'))
                        {
                            groupName ='SWIFT_Admin';
                        }
                         if(mrsFieldPermissionConfig.get(groupName) != null)
                         {
                           if(mrsFieldPermissionConfig.get(groupName).FrameMockupCustomer__c== true)
                           {
                              showFrameMockupLink = true; 
                           }
                       
                           if(mrsFieldPermissionConfig.get(groupName).FrameMockupFoundry__c== true)
                           {
                               showFoundryFrameMockupLink = true;
                           }
                      
                           if(mrsFieldPermissionConfig.get(groupName).GDSOUTReviewCustomer__c == true)
                           {
                               showGDSOUTReviewLink = true;
                           }
                      
                           if(mrsFieldPermissionConfig.get(groupName).GDSOUTReviewFoundry__c == true)
                           {
                               showFoundryGDSOUTReview = true;
                           }
                       
                           if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewCustomer__c == true)
                           {
                               showMEBBESLink  = true;
                           }
                      
                           if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewFoundry__c == true)
                           {
                               showFoundryMEBBESReviewLink = true;
                           }
                     
                           if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewGlobalShuttle__c == true)
                           {
                               showGlobalShuttleReviewLINK = true;
                           }
                      
                           if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewMDP__c == true)
                           {
                               showMDPReviewLink = true;
                           }
                       
                      
                           if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewTapeoutAPPLICATIONS__c == true)
                           {
                               showTapeOutApplicationReviewLink = false;//swgp-859
                           }
                       
                      
                           if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewTapeoutCenter__c == true)
                           {
                               showTapeOutCenterReviewLink = true;
                           }
                       
                       
                          if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewTDTIMPW__c == true)
                          {
                               showTDTIReviewLink = true;
                          }
                     
                          if(mrsFieldPermissionConfig.get(groupName).SendDataFrame__c == true)
                          {
                              showSendData = true;
                              showFrameSendData  = true;
                          }
                      
                         if(mrsFieldPermissionConfig.get(groupName).SendDataPrime__c == true)
                         {
                              showSendData = true;
                              showPrimeSendData  = true;
                         }
                      }
                  }
               }
             } if(accountTeamProxy != null && accountTeamProxy.size()>0){
                   Map<String,MRS_Fields_Permission_Config__c> swiftFEMap = MRS_Fields_Permission_Config__c.getAll();
                   //system.debug('fe1:' + swiftFEMap);
                   if(swiftFEMap.get('SWIFT_FE').FrameMockupCustomer__c){
                       showFrameMockupLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').FrameMockupFoundry__c){
                       showFoundryFrameMockupLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').GDSOUTReviewCustomer__c){
                       showGDSOUTReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').GDSOUTReviewFoundry__c){
                       showFoundryGDSOUTReview = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').SendDataPrime__c){
                       showSendData = true;
                       showPrimeSendData = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').SendDataFrame__c){
                       showSendData = true;
                       showFrameSendData = true;
                   } 
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewCustomer__c){
                       showMEBBESLink  = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewFoundry__c){
                        showFoundryMEBBESReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewGlobalShuttle__c){
                          showGlobalShuttleReviewLINK = true;
                   }
                    if(swiftFEMap.get('SWIFT_FE').MEBESJobviewMDP__c){
                          showMDPReviewLink =true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTapeoutAPPLICATIONS__c){
                          showTapeOutApplicationReviewLink = false;//swgp-859
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTapeoutCenter__c){
                          showTapeOutCenterReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTDTIMPW__c){
                           showTDTIReviewLink =true;
                   }     
             } else
               {
                 
                       showFrameMockupLink = true;
                       showGDSOUTReviewLink = true;
                       showMEBBESLink  = true;
                       showSendData = true;
                       showHoldAndResume = true;
                       showFoundryFrameMockupLink = true;
                       showFoundryGDSOUTReview = true;
                       showFoundryMEBBESReviewLink = true;
                       showTapeOutCenterReviewLink = true;
                       showTapeOutApplicationReviewLink = false;//swgp-859
                       showGlobalShuttleReviewLINK = true;
                       showMDPReviewLink =true;
                       showTDTIReviewLink =true;
                       showPrimeSendData = true;
                       showFrameSendData = true;
                       showHoldResumeButton = true;
                   
                   
                   
               }
             showHoldResumeButton = true;
           }
           else if(accountTeamProxy != null && accountTeamProxy.size()>0)
           {
                   
                   Map<String,MRS_Fields_Permission_Config__c> swiftFEMap = MRS_Fields_Permission_Config__c.getAll();
                    //system.debug('fe2:' + swiftFEMap);
                   if(swiftFEMap.get('SWIFT_FE').FrameMockupCustomer__c){
                       showFrameMockupLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').FrameMockupFoundry__c){
                       showFoundryFrameMockupLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').GDSOUTReviewCustomer__c){
                       showGDSOUTReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').GDSOUTReviewFoundry__c){
                       showFoundryGDSOUTReview = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').SendDataPrime__c){
                       showSendData = true;
                       showPrimeSendData = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').SendDataFrame__c){
                       showSendData = true;
                       showFrameSendData = true;
                   } 
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewCustomer__c){
                       showMEBBESLink  = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewFoundry__c){
                        showFoundryMEBBESReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewGlobalShuttle__c){
                          showGlobalShuttleReviewLINK = true;
                   }
                    if(swiftFEMap.get('SWIFT_FE').MEBESJobviewMDP__c){
                          showMDPReviewLink =true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTapeoutAPPLICATIONS__c){
                          showTapeOutApplicationReviewLink = false;//swgp-859
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTapeoutCenter__c){
                          showTapeOutCenterReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTDTIMPW__c){
                           showTDTIReviewLink =true;
                   }   
                   showHoldResumeButton = true;  
           }
           else
           {
             
                   showFrameMockupLink = true;
                   showGDSOUTReviewLink = true;
                   showMEBBESLink  = true;
                   showSendData = true;
                   showHoldAndResume = true;
                   showFoundryFrameMockupLink = true;
                   showFoundryGDSOUTReview = true;
                   showFoundryMEBBESReviewLink = true;
                   showTapeOutCenterReviewLink = true;
                   showTapeOutApplicationReviewLink = false;//swgp-859
                   showGlobalShuttleReviewLINK = true;
                   showMDPReviewLink =true;
                   showTDTIReviewLink =true;
                   showPrimeSendData = true;
                   showFrameSendData = true;
                   showHoldResumeButton = true;
               
               
               
           }
       }
       account = new Cookie('account',null,null,0,false);
       ApexPages.currentPage().setCookies(new Cookie[]{account});
       mst = new Cookie('mst',null,null,0,false);
       ApexPages.currentPage().setCookies(new Cookie[]{mst});
    }
    
    /**
        This method redirects the User to the appropriate page in the iFrame in the middle. 
        @method name: redirect
        @parameter:   None.
        @return :     The page to which the control is redirected.
    **/ 
    
    public PageReference redirect(){
        if( null != parameter  && parameter.trim() != '' ){
            String customer = parameter.substringBetween('Customer=','&');
            String mstName = parameter.substringBetween('&mst=','&');
            
            if( null != customer ){
                account = new Cookie('account',customer.trim(),null,-1,false);
                ApexPages.currentPage().setCookies(new Cookie[]{account});
                if(mstName  == null){
                  mstName = parameter.substringAfterLast('&mst=');
                }
                mst = new Cookie('mst',mstName,null,-1,false);
                ApexPages.currentPage().setCookies(new Cookie[]{mst});
            }
        }
        
        showdetailsection = true;
        respectiveLevel = 'Mask Release System';
            
        if(Page == 'Layer Summary')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSLayerSummary';
        }
        else if(Page == 'GDSOUTReview-Customer')
        { 
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSGDSOUTReview?type=Customer';
        }
        else if(Page == 'GDSOUTReview-Foundry')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSGDSOUTReview?type=Foundry';
        }
        else if(Page == 'FrameMockupReview-Customer')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSFrameMockupReview?type=Customer';
        }
        else if(Page == 'FrameMockupReview-Foundry')
        {
            //system.debug('::parameter:::'+parameter);
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSFrameMockupReview?type=Foundry';
        }
        else if(Page == 'SendData-Prime')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSSendPrimeData';
        }
        else if(Page == 'SendData-Frame')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSSendDataFrame?type=Foundry';
        }
        else if(Page == 'MEBESJobview-Customer')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSMEBESJobview?jobview=Customer';
        }
        else if(Page == 'MEBESJobview-Foundry')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';            
            OpenPageURL = System.Label.Internal_URL + 'VFMRSMEBESJobview?jobview=Foundry';
        }
        else if(Page == 'MEBESJobview-TapeoutCentre')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSMEBESJobview?jobview=TapeoutCentre';
        }
        else if(Page == 'MEBESJobview-TapeoutApp')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSMEBESJobview?jobview=TapeoutApp';
        }
        else if(Page == 'MEBESJobview-GlobalShuttle')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSMEBESJobview?jobview=GlobalShuttle';
        }
        else if(Page == 'MEBESJobview-MDP')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSMEBESJobview?jobview=MDP';
        }
        else if(Page == 'MEBESJobview-MPWTDTI')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSMEBESJobview?jobview=MPWTDTI';
        }
        else if(Page == 'Hole/Resume Layer')
        {
            //showdetailsection = true;
            //respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.Internal_URL + 'VFMRSResumeHold';
        }
        return null;
    }
}