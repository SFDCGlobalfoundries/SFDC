/*
    Author: Anirban Roy
    Description: Apex class for sending email notification during GMPL/BX009 operations.
    History: 
        ARoy      03282014    - Apex code created
        ARoy      05162014    - code modified to include the mail functionality on task completion.
        ARoy	  05292014	  - modified code to replace PC0 Disposition to BCCB Disposition.
*/

public class GMPLBX009NotificationEmail {    
    
    private static final string TEMPLATE1 = EnvironmentVariable.get('BX009_MAIL_ON_CREATION');
    private static final string TEMPLATE2 = EnvironmentVariable.get('BX009_MAIL_BEFORE_SUBMISSION');
    private static final string TEMPLATE3 = EnvironmentVariable.get('BX009_MAIL_ON_APPROVAL');
    private static final string TEMPLATE4 = EnvironmentVariable.get('BX009_MAIL_ON_REJECTION');
    private static final string TEMPLATE5 = EnvironmentVariable.get('BX009_MAIL_TO_ASSOCIATE_PROCESS_ID');
    private static final string TEMPLATE6 = EnvironmentVariable.get('BX009_MAIL_ON_COMPLETION');
    private static final string TEMPLATE7 = EnvironmentVariable.get('BX009_MAIL_ON_UPDATION_PROD_START_DATE');
    private static final string TEMPLATE8 = EnvironmentVariable.get('BX009_MAIL_ON_UPDATION_PRCS_SER_TYP');
    private static final string TEMPLATE9 = EnvironmentVariable.get('BX009_MAIL_ON_UPDATION_PRDT_SER_TYP');
    private static final string TEMPLATE10 = EnvironmentVariable.get('BX009_MAIL_ON_UPDATION_REV_FRCST');
    private static final string TEMPLATE11 = EnvironmentVariable.get('BX009_MAIL_ON_UPDATION_SQE_SER_TYP');
    private static final string TEMPLATE12 = EnvironmentVariable.get('BX009_MAIL_ON_UPDATION_TK_SER_TYP');
    private static final string TEMPLATE13 = EnvironmentVariable.get('BX009_MAIL_ON_CMPLTE_DIS_WITH_CUST');
    
    private static final string G0_DISPOSITION_STATUS = EnvironmentVariable.get('BX009_G0_DISP_APPROVED_STATUS');
    
    private static final string PPE_ROLE_PM = EnvironmentVariable.get('PPE_TEAM_ROLE_PMBX009');
    private static final string PPE_ROLE_PL = EnvironmentVariable.get('PPE_TEAM_ROLE_PLBX009');
    private static final string PPE_ROLE_AM = EnvironmentVariable.get('PPE_TEAM_ROLE_AMBX009');
    private static final string PPE_ROLE_TKBX009 = EnvironmentVariable.get('PPE_TEAM_ROLE_TKBX009');
    private static final string PPE_ROLE_SQEBX009 = EnvironmentVariable.get('PPE_TEAM_ROLE_SQEBX009');
    private static final string PPE_TEAM_ROLE_PROCESSBX009 = EnvironmentVariable.get('PPE_TEAM_ROLE_PROCESSBX009');
    private static final string PPE_TEAM_ROLE_PRDTBX009 = EnvironmentVariable.get('PPE_TEAM_ROLE_PRDTBX009');
    
    private static final string BX009_STATUS_BRB_REVIEW = EnvironmentVariable.get('BX009_STATUS_BRB_REVIEW');
    private static final string BX009_STATUS_G0_APPROVED = EnvironmentVariable.get('BX009_STATUS_G0_APPROVED');
    private static final string BX009_STATUS_BRB_APPROVED = EnvironmentVariable.get('BX009_STATUS_BRB_APPROVED');
    private static final string BX009_STATUS_COMPLETE = EnvironmentVariable.get('BX009_STATUS_COMPLETE');    

    public static Boolean hasRun = false; 
    
    // Return the list of PPE Team Users with specific roles as per GMPL record.
    public static Map<Id, List<PPE_Team__c>> getGMPLPPETeamUserMap(List<String> gmplIds){
        
        Map<Id, List<PPE_Team__c>> gmplPPEUserMap = new Map<Id, List<PPE_Team__c>>();
        for(PPE_Team__c ppe : [select   Id
                                        , PPE_Role__c
                                        , User__c
                                        , User__r.Email
                                        , GMPL_BX009__c
                               from     PPE_Team__c
                               where    GMPL_BX009__c in :gmplIds   
                              ]){        
            if(gmplPPEUserMap.containsKey(ppe.GMPL_BX009__c)){
                gmplPPEUserMap.get(ppe.GMPL_BX009__c).add(ppe);
            }else{
                gmplPPEUserMap.put(ppe.GMPL_BX009__c, new List<PPE_Team__c>{ppe});
            }           
        }        
        return  gmplPPEUserMap;     
    }
    
    public static List<String> getGmplUserList(Map<Id, List<PPE_Team__c>> gmplPPEMap, Set<String> ppeRoles,Id gmplId){
        List<String> ppmUserList = new List<String>();
        if(!gmplPPEMap.isEmpty() && gmplPPEMap.containsKey(gmplId)){
            List<PPE_Team__c> ppeTeamList = gmplPPEMap.get(gmplId);
            for(PPE_Team__c ppe : ppeTeamList){
                if(ppeRoles==null){
                    ppmUserList.add(ppe.User__r.Email);
                }else{
                    if(ppeRoles.contains(ppe.PPE_Role__c)){
                        ppmUserList.add(ppe.User__r.Email);
                    }
                }
            }
        }            
        return ppmUserList;
    }
    
    
    public static void sendMail(List<GMPL_BX009__c> gmplList,Map<ID,GMPL_BX009__c> oldGMPLBx009Map){
        
        List<String> gmplIds = new List<String>();
        for(GMPL_BX009__c gmpl : gmplList){
            gmplIds.add(gmpl.Id);                                      
        }
        
        Map<Id, List<PPE_Team__c>> gmplPPEMap = getGMPLPPETeamUserMap(gmplIds);        
        
        //send emails
        List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
        Map<String,String> emailMap = new Map<String,String>();        
        
        //=====Email Template retrieval for GMPL======// 
        for( EmailTemplate e: [ SELECT  name,
                                        id 
                                FROM 
                                EmailTemplate 
                                WHERE name IN (:TEMPLATE1, :TEMPLATE2, :TEMPLATE3, :TEMPLATE4, :TEMPLATE5, :TEMPLATE6, 
                                               :TEMPLATE7, :TEMPLATE8, :TEMPLATE9, :TEMPLATE10, :TEMPLATE11, :TEMPLATE12, :TEMPLATE13)]){
            emailMap.put(e.name,e.id);
        }
        //=====================================================//                                                       
                
        for(GMPL_BX009__c currRec: gmplList){
            GMPL_BX009__c oldRec = oldGMPLBx009Map.get(currRec.id);
            
            // Email when GMPL becomes a BX009
            //****************************************************************************//
            if(currRec.BCCB_Disposition__c != oldRec.BCCB_Disposition__c 
                    && currRec.BCCB_Disposition__c == G0_DISPOSITION_STATUS){
                List<String> userList = getGmplUserList(gmplPPEMap,null,currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE1),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //****************************************************************************//
            
            // Email on completion of all fields before submit to Approval for first level approval
            //****************************************************************************//
            if(currRec.Consigned_Wafer__c || currRec.Productization__c 
                    || currRec.Product_Process__c || currRec.Turnkey__c){
                
                Boolean isValid = false;                
                    
                if(currRec.Consigned_Wafer__c){
                    if(currRec.SQE_Acknowledgement__c && currRec.SQE_Acknowledgement__c != oldRec.SQE_Acknowledgement__c){
                        isValid = true;
                    }
                }
                if(currRec.Product_Process__c){
                    if(currRec.Process_Acknowledgement__c && currRec.Process_Acknowledgement__c != oldRec.Process_Acknowledgement__c){
                        isValid = true;
                    }
                }
                if(currRec.Productization__c){
                    if(currRec.Productization_Acknowledgement__c && currRec.Productization_Acknowledgement__c != oldRec.Productization_Acknowledgement__c){
                        isValid = true;
                    }
                }
                if(currRec.Turnkey__c){
                    if(currRec.Turnkey_Acknowledgement__c && currRec.Turnkey_Acknowledgement__c != oldRec.Turnkey_Acknowledgement__c){
                        isValid = true;
                    }
                }
                
                if(isValid){
                    List<String> userList = getGmplUserList(gmplPPEMap,new Set<String>{PPE_ROLE_AM,PPE_ROLE_PM,PPE_ROLE_PL},currRec.id);
                    if(userList.size()>0){
                        try {                                                
                            
                            Messaging.reserveSingleEmailCapacity(userList.size());
                                 
                            Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE2),
                                                                                               currRec.id,
                                                                                               null,
                                                                                               userList,
                                                                                               null,
                                                                                               null);
                            if(msg != null){
                                msgs.add(msg);                                                                                                                              
                            }   
                        } catch (Exception e) {
                            system.debug('Error ==========> ' + e.getMessage());
                        }        
                    }               
                }
            }
            //****************************************************************************//
            
            // Email when Regional Head or Marketing VP Queue approves the approval.
            //****************************************************************************//
            if(currRec.BX009_Status__c != oldRec.BX009_Status__c && currRec.BX009_Status__c == BX009_STATUS_BRB_REVIEW){
                List<String> userList = getGmplUserList(gmplPPEMap,null,currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE3),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //****************************************************************************//
            
            // Email when Regional Head or Marketing VP Queue rejects the approval.
            //****************************************************************************//
            if(currRec.BX009_Status__c != oldRec.BX009_Status__c && currRec.BX009_Status__c == BX009_STATUS_G0_APPROVED
                    && currRec.BCCB_Disposition__c == oldRec.BCCB_Disposition__c && currRec.BCCB_Disposition__c == G0_DISPOSITION_STATUS){
                List<String> userList = getGmplUserList(gmplPPEMap,null,currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE4),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //****************************************************************************//                        
            
            // Email when BX009 Status is set to 'BRB Approved' and PL needs to associate a Process ID
            //****************************************************************************//
            if(currRec.BX009_Status__c != oldRec.BX009_Status__c && currRec.BX009_Status__c == BX009_STATUS_BRB_APPROVED){
                List<String> userList = getGmplUserList(gmplPPEMap,new Set<String>{PPE_ROLE_PL},currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE5),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //****************************************************************************//
            
            // Email when system automatically changes the BX009 Status to 'Completed'
            //****************************************************************************//
            if(currRec.BX009_Status__c != oldRec.BX009_Status__c && currRec.BX009_Status__c == BX009_STATUS_COMPLETE){
                List<String> userList = getGmplUserList(gmplPPEMap,null,currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE6),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //****************************************************************************//            
            
            // Email whenever user updates the Product Start Date on GMPL/ BX009.
            //****************************************************************************//
            if(currRec.Product_Start_Date__c != oldRec.Product_Start_Date__c){
                List<String> userList = getGmplUserList(gmplPPEMap,null,currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE7),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //****************************************************************************//
            
            // Email when 'Process/ Product' checkbox is selected.
            //****************************************************************************//
            if(currRec.Product_Process__c != oldRec.Product_Process__c && currRec.Product_Process__c){
                List<String> userList = getGmplUserList(gmplPPEMap,new Set<String>{PPE_TEAM_ROLE_PROCESSBX009},currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE8),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //****************************************************************************//
            
            // Email when 'Productization' checkbox is selected.
            //****************************************************************************//
            if(currRec.Productization__c != oldRec.Productization__c && currRec.Productization__c){
                List<String> userList = getGmplUserList(gmplPPEMap,new Set<String>{PPE_TEAM_ROLE_PRDTBX009},currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE9),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //****************************************************************************//
            
            // Email whenver user updates the Quantity OR Average Sales Price for any year on 'Revenue Forecasting'
            //******************************************************************************************************//
            if((currRec.Total_Quantity_Forecasted__c != oldRec.Total_Quantity_Forecasted__c) 
                    || (currRec.Total_Revenue_Forecasted__c != oldRec.Total_Revenue_Forecasted__c)){
                List<String> userList = getGmplUserList(gmplPPEMap,null,currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE10),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //******************************************************************************************************//
            
            // Email to Users in PPE Team having role of 'SQE BX009' when 'Consigned Wafer' checkbox is selected
            //******************************************************************************************************//
            if(currRec.Consigned_Wafer__c != oldRec.Consigned_Wafer__c && currRec.Consigned_Wafer__c){
                List<String> userList = getGmplUserList(gmplPPEMap,new Set<String>{PPE_ROLE_SQEBX009},currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE11),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //******************************************************************************************************//
            
            // Email to Users in PPE Team having role of 'Turnkey BX009' when 'Turnkey' checkbox is selected
            //******************************************************************************************************//
            if(currRec.Turnkey__c != oldRec.Turnkey__c && currRec.Turnkey__c){
                List<String> userList = getGmplUserList(gmplPPEMap,new Set<String>{PPE_ROLE_TKBX009},currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE12),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //******************************************************************************************************//
                      
            // Email when Account Manager updates the picklist specific to completion of his/her discussion with Customer
            //******************************************************************************************************//
            if(currRec.Has_customer_agreed_with_GLOBALFOUNDRIES__c != oldRec.Has_customer_agreed_with_GLOBALFOUNDRIES__c 
                    && currRec.Has_customer_agreed_with_GLOBALFOUNDRIES__c != null){
                List<String> userList = getGmplUserList(gmplPPEMap,new Set<String>{PPE_ROLE_PM,PPE_ROLE_PL},currRec.id);
                if(userList.size()>0){
                    try {                                                
                        
                        Messaging.reserveSingleEmailCapacity(userList.size());
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE13),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           userList,
                                                                                           null,
                                                                                           null);
                        if(msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }    
            }
            //*****************************************************************************************************//                                                                                 
        }
        
        if(msgs.size() > 0){
            if (!Test.isRunningTest()) {
                Messaging.sendEmail(msgs);
            }  
        }
    }
    
    // Send email on Task completion to PL/PM/CE Admin
    public static void sendEmailOnTask(Map<Id,Id> gmplAssigneeIdMap){
        
        List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
        Map<Id, List<PPE_Team__c>> gmplPPEMap = getGMPLPPETeamUserMap(new List<Id>(gmplAssigneeIdMap.keySet()));
        List<String> userIds = new List<String>();
        List<String> userEmailIds = new List<String>();       
        
        // Get the email template
        EmailTemplate emailTemp = [ SELECT      id 
                                    FROM        EmailTemplate 
                                    WHERE       name = :EnvironmentVariable.get('BX009_MAIL_ON_TASK_COMPLETION')
                                  ];        
                                        
        
        // Get the CE Admin Group members
        for(GroupMember gm : [select     UserOrGroupId
                              from       GroupMember
                              where      group.developername = :EnvironmentVariable.get('CE_ADMIN_GROUP')]){
            userIds.add(String.valueOf(gm.UserOrGroupId));
        }
        
        // Get the CE Admin Group members email ids
        if(userIds.size()>0){
            for(User u : [select    id
                                    , email 
                          from      User 
                          where     id in :userIds]){
                userEmailIds.add(u.email);        
            }
        }       
        
        // Iterate through the gmpl Assignee list to create the email message
        for(Id gmplId : gmplAssigneeIdMap.keySet()){
            List<String> userList = getGmplUserList(gmplPPEMap,new Set<String>{PPE_ROLE_PM,PPE_ROLE_PL},gmplId);
            if(userEmailIds.size()>0){
                userList.addAll(userEmailIds);
            }
            if(userList.size()>0){
                try {                                                
                    
                    Messaging.reserveSingleEmailCapacity(userList.size());
                         
                    Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailTemp.id,
                                                                                       gmplId,
                                                                                       null,
                                                                                       userList,
                                                                                       null,
                                                                                       null);
                    if(msg != null){
                        msgs.add(msg);                                                                                                                              
                    }   
                } catch (Exception e) {
                    system.debug('Error ==========> ' + e.getMessage());
                }        
            } 
        }
        
        // Send the email
        if(msgs.size() > 0){
            if (!Test.isRunningTest()) {
                Messaging.sendEmail(msgs);
            }  
        }
        
    } 
}