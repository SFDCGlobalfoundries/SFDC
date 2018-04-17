/*
* @ Author :- SUHAS BARGI
* @ Date :- 4 MAR 2016
* @ Description :- Suhas bargi - Added Mail templates - 10/08/2016
* @ History:- Mohan : added NonMatching email template.
*/




public without sharing class DRCEmailImplementation {
    
    private static Set<Id> PIYE_Users; 
    private static Set<Id> QA_Users;
    
    
    public DRCEmailImplementation(){ 
    }
    
    
    // get chip details related to waiver collaborator
    public static List<Waiver_Rule_List__c> getWaiverRuleList(Id drcId1){
        List<Waiver_Rule_List__c> waiverRuleList= [SELECT Account_Manager_Approver__c,Rule_Type__c,Prime_Die_Name__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c FROM Waiver_Rule_List__c WHERE Waiver_Collaborator__c  =:drcId1 and Rule_Type__c !='' order by LastModifiedDate desc];        
        
        return waiverRuleList;           
    }
    
    
    public static void setUpPiyeAndQAUsers(Wavier_Collaborator__c collaborator){
        //system.debug('Inside setUpPiyeAndQAUsers ########## ');
        // collaborator = getWaiverCollaborator(drcId);
        // prepare To addresses   
        if (collaborator.FAB__c.contains('1')){
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB1').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1').keySet():NULL;      
            
        } else if (collaborator.FAB__c.contains('8')){
            
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB8')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB8').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB8')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB8').keySet():NULL;
        }  else if (collaborator.FAB__c.contains('7')){
            
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB7')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB7').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB7')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB7').keySet():NULL;
        }  else if (collaborator.FAB__c.contains('9')){
            
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB9').keySet():NULL;
        } 
        
        
    }
    public static void  getDRCRuleListPendingApprovals(List<Waiver_Rule_List__c> waiverRuleList){  
        Id collaboratorId=null;
        if(waiverRuleList <> null && !waiverRuleList.isEmpty()){
        collaboratorId = waiverRuleList.get(0).Waiver_Collaborator__c;
        }
        List<Id> workItemIds = new List<Id>();
        List<Id> userIDs = new List<Id>();
       
        
        String pIYErulesListString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td><td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        String qArulesListString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        String dErulesListString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        String aMrulesListString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        //System.debug('========setOfWaiverCollaboratorIdsForTemplate8=======collaborator'+ setOfWaiverCollaboratorIdsForTemplate8 + '>>>>>>>>'+collaboratorId);
      
            
            Integer aMruleList=0;
            Integer pIYEruleList=0;
            Integer qAruleList=0;
            Integer dEruleList=0; 
            String counts;
            
           /*
            for(Waiver_Rule_List__c wcRule : waiverRuleList){
                
                
                
                if(GroupWrkList.get(wcRule.Id)<>null){
                    //System.debug('========gotMatches=======collaborator'+ collaboratorId + '=== ruleRecordID'+ wcRule.Id);
                    String grpName = GroupWrkList.get(wcRule.Id);
                    if(grpName <> null && !String.isEmpty(grpName) && wcRule<>null && wcRule.Final_Stage__c!='PI' 
                       && wcRule.Final_Stage__c!='PW' && wcRule.Final_Stage__c!='PWA' &&  wcRule.Final_Stage__c!='PWO' && wcRule.Final_Stage__c!='POC'){
                           if(!(pIYEruleList>9) && (grpName.contains('PI'))){
                               pIYErulesListString+='<tr>';
                               if(wcRule.Design_Rule_Name__c <>null){
                                   pIYErulesListString+='<td bgcolor="white"> '+wcRule.Design_Rule_Name__c+ '  </td>   ' ;
                               }else{
                                   pIYErulesListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               if(wcRule.Rule_Description__c <>null){
                                   pIYErulesListString+='<td bgcolor="white"> '+wcRule.Rule_Description__c+ '  </td>   ' ;
                               }else{
                                   pIYErulesListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               if(wcRule.Stage__c<>null){
                                   pIYErulesListString+='<td bgcolor="white"> '+wcRule.Stage__c+'</td>  ';
                               }else{
                                   pIYErulesListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               
                               if(wcRule.Final_Stage__c <> null){
                                   pIYErulesListString+='<td bgcolor="white"> '+wcRule.Final_Stage__c+'</td> '; 
                               }else{
                                   pIYErulesListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               pIYErulesListString+='</tr>';
                               pIYEruleList++;
                           }else if(!(qAruleList>9) &&(grpName.contains('QA'))){ 
                               qArulesListString +='<tr>';
                               if(wcRule.Design_Rule_Name__c <>null){
                                   qArulesListString +='<td bgcolor="white"> '+wcRule.Design_Rule_Name__c+ '  </td>   ' ;
                               }else{
                                   qArulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               if(wcRule.Rule_Description__c <>null){
                                   qArulesListString +='<td bgcolor="white"> '+wcRule.Rule_Description__c+ '  </td>   ' ;
                               }else{
                                   qArulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               if(wcRule.Stage__c<>null){
                                   qArulesListString +='<td bgcolor="white"> '+wcRule.Stage__c+'</td>  ';
                               }else{
                                   qArulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               
                               if(wcRule.Final_Stage__c <> null){
                                   qArulesListString +='<td bgcolor="white"> '+wcRule.Final_Stage__c+'</td> '; 
                               }else{
                                   qArulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               qArulesListString +='</tr>';
                           qAruleList++;
                           }else if(!(dEruleList>9) &&(grpName.contains('DE'))){
                               dErulesListString +='<tr>';
                               if(wcRule.Design_Rule_Name__c <>null){
                                   dErulesListString +='<td bgcolor="white"> '+wcRule.Design_Rule_Name__c+ '  </td>   ' ;
                               }else{
                                   dErulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               if(wcRule.Rule_Description__c <>null){
                                   dErulesListString +='<td bgcolor="white"> '+wcRule.Rule_Description__c+ '  </td>   ' ;
                               }else{
                                   dErulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               if(wcRule.Stage__c<>null){
                                   dErulesListString +='<td bgcolor="white"> '+wcRule.Stage__c+'</td>  ';
                               }else{
                                   dErulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               
                               if(wcRule.Final_Stage__c <> null){
                                   dErulesListString +='<td bgcolor="white"> '+wcRule.Final_Stage__c+'</td> '; 
                               }else{
                                   dErulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               dErulesListString +='</tr>';
                           dEruleList++;
                           }else if(!(aMruleList>9) && !(grpName.contains('PI') || grpName.contains('DE') || grpName.contains('QA')  )){
                               aMrulesListString +='<tr>';
                               if(wcRule.Design_Rule_Name__c <>null){
                                   aMrulesListString +='<td bgcolor="white"> '+wcRule.Design_Rule_Name__c+ '  </td>   ' ;
                               }else{
                                   aMrulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               if(wcRule.Rule_Description__c <>null){
                                   aMrulesListString +='<td bgcolor="white"> '+wcRule.Rule_Description__c+ '  </td>   ' ;
                               }else{
                                   aMrulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               if(wcRule.Stage__c<>null){
                                   aMrulesListString +='<td bgcolor="white"> '+wcRule.Stage__c+'</td>  ';
                               }else{
                                   aMrulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               
                               if(wcRule.Final_Stage__c <> null){
                                   aMrulesListString +='<td bgcolor="white"> '+wcRule.Final_Stage__c+'</td> '; 
                               }else{
                                   aMrulesListString +='<td bgcolor="white"> '+''+ '  </td>   ' ;
                               }
                               aMrulesListString +='</tr>';
                           aMruleList++;
                           }
                    } 
                    
                    
                }
            }
            */
            pIYErulesListString +='</table>';
            qArulesListString +='</table>';
            dErulesListString +='</table>';
            aMrulesListString +='</table>';
           
            
           //Template 8 construction - start
           
            Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
            String drbGrp = collaborator.DRB_Group_uIds__c;
            List<String> fab1_DRC_ALLN_DRB = DfmUtilityCls.drbEmailIDs(drbGrp);
            List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
            setUpPiyeAndQAUsers(collaborator);
            Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
            Transient Set<Id> setOfAllApprovers = new Set<Id>();
            Transient Set<Id> setOfAllApprovers2 = new Set<Id>();
            Transient Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
            
            List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
                Transient Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
            
            if (PIYE_Users<>NULL && !PIYE_Users.isEmpty() && pIYEruleList>0){
                setOfAllApprovers.addAll(PIYE_Users);
            }
            if (QA_Users<>NULL && !QA_Users.isEmpty() && qAruleList>0){
                setOfAllApprovers.addAll(QA_Users);
            }
            if (DE_Users<>NULL && !DE_Users.isEmpty() && dEruleList>0){
                setOfAllApprovers.addAll(DE_Users);
            }
            if (AM_Users<>NULL && !AM_Users.isEmpty() && aMruleList>0){
                setOfAllApprovers.addAll(AM_Users);
            } 
            
            
            if (setOfFAEs<>NULL && !setOfFAEs.isEmpty()){
                setOfAllApprovers2.addAll(setOfFAEs);
            }
            
            if(collaborator.PTSR_Service_Type__c.contains('DRC')){
            List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfAllApprovers);
            List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfAllApprovers2);
            if(ccAddresses<>null && !ccAddresses.isEmpty() && fab1_DRC_ALLN_DRB <> null && !fab1_DRC_ALLN_DRB.isEmpty()){
                ccAddresses.addAll(fab1_DRC_ALLN_DRB);
            }else if(fab1_DRC_ALLN_DRB <> null && !fab1_DRC_ALLN_DRB.isEmpty()){
                ccAddresses = fab1_DRC_ALLN_DRB;
            }
            List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'}; 
            bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
            DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
            
            String waiverCollaboratorURL = '';
            if (UserInfo.getUserType()!='Standard'){
                waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
            } else {
                waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
            }
            
            Transient  String subject='Update is required:  '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c;
            
            
            Transient String body = '<html>'
                +'<h3> <b>Title:</b>Notification of foundry-to-risk open approval</h3><br><br>'
                +'There are open approvals pending for '
                + collaborator.FAB__c
                +' Foundry-to-risk (TIER2) approval for  '
                + collaborator.Mask_Set_Title__c
                +'  for the following approvers <br><br>';
            if(pIYEruleList>0){
                body +='<br>For the following Rules, no decision was made by TIER2 approver Group PI/YE:<br><br>';
                body += pIYErulesListString;
            }
            if(qAruleList>0){
                body +='<br><br>For the following Rules, no decision was made by TIER2 approver Group QA:<br><br>';
                body += qArulesListString;
            }
            if(dEruleList>0){
                body +='<br><br>For the following Rules, no decision was made by TIER2 approver Group DE:<br><br>';
                body += dErulesListString;
            }
            if(aMruleList>0){
                body +='<br><br>For the following Rules, no decision was made by TIER2 approver Group AM:<br><br>';
                body += aMrulesListString;
            }
            body +='<br><br><b> To Proceed </b>Please check in Collaborator <br>'
                + waiverCollaboratorURL + collaborator.Id+'<br><br>'
                +' and dispose the open rules for closing TIER2 approval<br><br>'
                
                +'<b>Issue Title:</b> DRC Waiver Collaboration File '+collaborator.Name+'<br>'
                
                +'<b>Collaborator Workflow Status:</b> '+ ' Pending For Foundry '+'<br><br>'
                +'Access the following URL to login to the Design Waiver Collaborator for the DRC Review Results:<br>'
                +waiverCollaboratorURL + collaborator.Id+'<br>'
                
                
                +'</html>';
            //send plain text body
            //System.debug('body>>>>'+body);
            try{
            emailUtil.htmlBody(body)
                .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
                .subject(subject)
                .sendEmail(); 
                }
            catch (Exception e) { GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'getDRCRuleListPendingApprovals()', ' String.valueOf(collaborator.Id)', 'DRC email ', 'this is error message', 'payLoad','Other SFDC',e, 2300); } 
            //Template 8 construction - End 
            }else{ //DFM Enhancements - Template L9
                Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL; 
                Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
                Set<Id> FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
                Set<Id> dwcAllEmails1= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
                List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfAllApprovers);
                List<String> ccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);
                ccAddresses.addAll(DfmUtilityCls.getEmailIds(setOfFAEs));//TODO
                
                List<String> bccAddresses = new List<String>();
                bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));
                bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
                bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails1));
                //bccAddresses.addAll(DWC_All_Emails);
                
                DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
                
                List<String> uRoles1 = new List<String>{'Primary Field Application Engineer'};
                Set<Id> setOfFAEs1 = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles1);
                List<String> primaryFAEs = DfmUtilityCls.getEmailIds(setOfFAEs1);
                String primaryFAE;
                if(primaryFAEs <> null && !primaryFAEs.isEmpty()){
                    primaryFAE = primaryFAEs.get(0);
                }
                
                List<String> atpManagers1 = new List<String>{'Primary Account Manager'};
                    Set<Id> AM_Users1 = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers1);
                List<String> primaryAMs = DfmUtilityCls.getEmailIds(AM_Users1);
                String primaryAM;
                if(primaryAMs <> null && !primaryAMs.isEmpty()){
                    primaryAM = primaryAMs.get(0);
                }
                
                
                waiverRuleList = getWaiverRuleList(collaborator.Id);     
                
                Integer fccCount =0;
                Transient String ruleListString = '<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
                    +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
                    +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
                Integer count = 0;
                for(Waiver_Rule_List__c rules : waiverRuleList) {
                    if((rules.Final_Stage__c=='FCD' ||rules.Stage__c=='iFD' ||rules.Stage__c=='IFD' ||rules.Stage__c=='FCC')&& (fccCount<9)){
                        ruleListString+='<tr>';
                        if(rules.Design_Rule_Name__c <>null){
                            ruleListString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                        }else{
                            ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Rule_Description__c<>null){
                            ruleListString+='<td bgcolor="white"> '+rules.Rule_Description__c+'</td>  ';
                        }else{
                            ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                         if(rules.Prime_Die_Name__c<>null){
                            ruleListString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+'</td>  ';
                        }else{
                            ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Stage__c <> null){
                            ruleListString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                        }else{
                            ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Final_Stage__c <> null){
                            ruleListString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                        }else{
                            ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        ruleListString+='</tr>';
                        fccCount++;
                        
                    }
                }
                ruleListString+=' </table>'; 
                
                
                String waiverCollaboratorURL = '';
                if (UserInfo.getUserType()!='Standard'){
                    waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
                } else {
                    waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
                }
                
                
                Transient String subject='Your Approval is required:   '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c+', DFM Waiver Collaboration ';
                
                // Prepare email body
                Transient String body = '<html>'
                    
                    +'<h3> <b>Title: </b>Request Foundry-to-risk Approval  </h3><br>'
                    
                    +'Not all violations in DFM waiver Request for '+collaborator.Mask_Set_Title__c+' have been waived by '+collaborator.FAB__c+' '
                    +'Waiver Review Board and customer has declined to design fixes or to accept risk for all non-waived rules. <br>'
                    +'Your approval is required for foundry to accept risk for the below mentioned rules '
                    +'(Will communicate as <b> Exceptional Arrangement </b> to the customer once a member from each of the approval groups approves):<br><br>'
                    +ruleListString
                    +'<br><br>Note: Only top 10 rules will be displayed. To view ALL rules, please access the URL indicated below. <br><br>'
                    +'<br><br> 1)  Approve /Reject for all Open rules :  <br>'
                    +'• <b>Approve</b>= Foundry to accept risk due to no customer action possible on mitigating DRC violations<br>'
                    +'• <b>Reject</b>= Foundry reject the device tapeout submission due to unacceptable non-compliance to Design Manual.<br><br>'
                    +'<b>Please contact FAE '+primaryFAE+' and Account Manager '+primaryAM+' before you choose to reject.</b><br><br> '
                    +'2) If you need detailed disposition, please open Collaborator<br>'
                    + waiverCollaboratorURL + collaborator.Id+'<br><br>'
                    +' for approval.<br><br>'
                    +'Note:<br> Final Foundry-to-Risk Approval status= <b>Approve</b> when <b>all</b> 4 groups (PIYE, DE, QA, AM) approve.<br>'
                    +'Final Foundry-to-Risk Approval status= <b>Reject</b> when <b>either one</b> of the 4 groups (PIYE, DE, QA, AM) reject<br><br>'            
                    +'Collaborator Workflow Status: '+' Pending For Foundry '+' <br><br>'
                    +'Access the following URL to login to the Design Waiver Collaborator for DFM Review Report details: <br>' //TODO
                    + waiverCollaboratorURL + collaborator.Id+'<br><br>'
                    
                    +'</html>';
                //send plain text body
                try{
                emailUtil.htmlBody(body)
                    .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
                    .subject(subject)
                    .sendEmail();
                     }
            catch (Exception e) { GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'getDRCRuleListPendingApprovals()', ' String.valueOf(collaborator.Id)', 'DRC email ', 'this is error message', 'payLoad','Other SFDC',e, 2300); } 
            }
        }
        
    
    
    
    
    
    
    // retrive customer specific waiver collaborator records
    public static Wavier_Collaborator__c getWaiverCollaborator(Id drcId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : getFields()) {
            query += f.getFieldPath() + ', ';
        }
        
        
        
        query +=  'Account_Manager_Approver1__c,Account_Manager_Approver2__c,Account_Manager_Approver3__c,Account_Manager__c,Account_Name__c,Account_Short_Name__c,'
            +'Approval_Field_Engineer__c,CreatedById,CreatedDate,Customer_Full_Name__c,'           
            +'DRB_Group_uIds__c,Selected_Customers__c,'       
            +'Id,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,IsCustomerAgreeToFix__c,Is_releasedToCustomer__c,'
            +'LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,MantisId__c,'
            +'Prime_Die_Name__c  '
            +' FROM Wavier_Collaborator__c WHERE Id =:drcId LIMIT 1';
        
        return Database.query(query);
    }
    
    
    
    // get waiver collaborator field information from respective field sets
    public static List<Schema.FieldSetMember> getFields() {
        boolean isStandardUser;
        boolean isPortalUser ;
        boolean isDfmUser ;
        boolean isDfmManager;
        if (UserInfo.getUserType()!='Standard'){
            isStandardUser = false;
            isPortalUser = true;
            return SObjectType.Wavier_Collaborator__c.FieldSets.DFM_Custome_View.getFields();
            
        } else {
            //system.debug('String.ValueOf(UserInfo.getUserId()) >>>>>>>>> '+String.ValueOf(UserInfo.getUserId()));
            //system.debug('Condition satisfied Its portal User >>>>>>>>>>');
            isStandardUser = true;
            isPortalUser = false;
            
        }
        return SObjectType.Wavier_Collaborator__c.FieldSets.DFM_FAE_View.getFields();
    }
    
    
    
    // send email to FAE regarding release of DRC Report to Customer
    //Item1a Template – Release of DRC Report to Customer to be sent-out in case of all violations are PW     
    //Item1b Template – Release of DRC Report to Customer to be sent-out in case of all violations are PI
    //Item1c Template – Release of DRC Report to Customer to be sent-out in case of one of the rules is not waived
    
    public static void drcReleaseReportToCustomer(Id  drcId){
        
        Wavier_Collaborator__c collaborator = DRCEmailImplementation.getWaiverCollaborator(drcId)     ;  
        //collaborator = getWaiverCollaborator(drcId);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL;     
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> ccAddresses= DfmUtilityCls.drbEmailIDs(drbGrp);
        
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        
        List<String> bccAddresses = new List<String>(); 
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));    
            DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient boolean isPWCase = FALSE;
        Transient boolean isFCCiFDCase = FALSE;
        Transient boolean isPICase = FALSE;
        Transient Set<String> setOfGFReviewStatus = new Set<String>();
        List<Waiver_Rule_List__c> waiverRuleList = new List<Waiver_Rule_List__c>();
        waiverRuleList = DRCEmailImplementation.getWaiverRuleList(collaborator.Id);
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            setOfGFReviewStatus.add(rules.Stage__c);
           }
        if(setOfGFReviewStatus <> null && setOfGFReviewStatus.size()>0){
            if(setOfGFReviewStatus.size()==1 && (setOfGFReviewStatus.contains('PI') )){
                isPICase=TRUE;   
                
            }else if((setOfGFReviewStatus.contains('PW') || setOfGFReviewStatus.contains('PI') || setOfGFReviewStatus.contains('PA') || setOfGFReviewStatus.contains('POC') 
                     || setOfGFReviewStatus.contains('WCR') || setOfGFReviewStatus.contains('WEA') || setOfGFReviewStatus.contains('POF')) 
                     && !( setOfGFReviewStatus.contains('FCC') || setOfGFReviewStatus.contains('iFD') || setOfGFReviewStatus.contains('IFD'))){
                     isPWCase=TRUE; 
                     }else {
                         isFCCiFDCase = TRUE;
                     }
        }
        
        if(isPWCase){//pw
            Transient String subject=' Your Approval is required : '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
            // Prepare email body
            Transient String body = '<html>'
                
                +'<h3> <b>Title:</b> Release of DRC Report to Customer  </h3><br><br>'
                +'<p>The DRC Report for  '+collaborator.Mask_Set_Title__c+' <font color="#009900"><b>  was waived.</b></font> </p> <br><br>'
                +'Action Required: Waiver report is pending your review and approval for release to customer in the DRC Waiver Collaborator <br>'                        
                + waiverCollaboratorURL + collaborator.Id+'<br>'                     
                +'Please select respective Customer and Account Manager in Collaborator. <br>'
                +'You can use Chatter in Collaborator if updates are required from '+collaborator.FAB__C+' Design Review Board.<br><br>'
                
                +'<p><font color="#FF0000"><b> Proceed to release =</b></font> Release DRC report in Collaborator to notify customer to take respective action. </p> '
                +'<br>'
                +'<p><b>Issue Title:</b> DRC Waiver Collaboration File <font color="#FF0000">'+collaborator.Name+'</font></p><br>'
                
                +'<p>Collaborator Workflow Status: <font color="#0099ff">'+ ' Pending For FAE' +'</font></p><br><br>'
                +'Access the following URL to login to the Design Waiver Collaborator for the DRC Review Results:<br>'
                + waiverCollaboratorURL + collaborator.Id+'<br>'
                +'<br><br>'
                
                
                +'</html>';
            //send plain text body
            try{
            emailUtil.htmlBody(body)
                .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
                .subject(subject)
                .sendEmail();
            }catch (Exception e) { GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcReleaseReportToCustomer()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);}  
        }else if(isPICase){//pi
            Transient String subject=' Your Approval is required : '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
            // Prepare email body
            Transient String body = '<html>'
                
                +'<h3> <b>Title:</b> Release of DRC Report to Customer</h3><br><br>'
                +'<p>The DRC Report for  '+collaborator.Mask_Set_Title__c+'  was closed with <font color="#ff9933">none of the rules reviewed.</font></p><br><br> '
                +'Action Required: DRC Report can be release to customer in the DRC Waiver Collaborator <br>'                        
                + waiverCollaboratorURL + collaborator.Id+'<br><br>'
                +'Please select respective Customer and Account Manager in Collaborator. <br>'
                +'You can use Chatter in Collaborator if updates are required from '+collaborator.FAB__C+' Design Review Board.<br><br>'                    
                
                +'<p><b>Issue Title:</b> DRC Waiver Collaboration File <font color="#FF0000">'+collaborator.Name+'</font></p><br>'
                
                +'<p>Collaborator Workflow Status: <font color="#0099ff">'+ ' Pending For FAE' +'</font></p><br><br>'
                +'Access the following URL to login to the Design Waiver Collaborator for the DRC Review Results:<br>'
                + waiverCollaboratorURL + collaborator.Id+'<br>'
                
                
                +'</html>';
            //send plain text body
            try{
            emailUtil.htmlBody(body)
                .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
                .subject(subject)
                .sendEmail();
                 }catch (Exception e) { GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcReleaseReportToCustomer()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300); }  
        }else if(isFCCiFDCase) {
            
            Transient String ruleListString = '<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
                +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
                +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
            Integer count = 0;
            for(Waiver_Rule_List__c rules : waiverRuleList) {
                if(count<9 && (rules.Stage__c<>null && (rules.Stage__c=='FCC' ||rules.Stage__c=='iFD'||rules.Stage__c=='IFD'  ))){
                    ruleListString+='<tr>';
                    if(rules.Design_Rule_Name__c <>null){
                        ruleListString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                    }else{
                        ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Rule_Description__c<>null){
                        ruleListString+='<td bgcolor="white"> '+rules.Rule_Description__c+'</td>  ';
                    }else{
                        ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Prime_Die_Name__c<>null){
                        ruleListString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+'</td>  ';
                    }else{
                        ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Stage__c <> null){
                        ruleListString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                    }else{
                        ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Final_Stage__c <> null){
                        ruleListString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                    }else{
                        ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    ruleListString+='</tr>';
                    count++;
                    
                }
            }
            ruleListString+=' </table>'; 
            
            Transient String subject=' Your Approval is required : '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
            // Prepare email body
            Transient String body = '<html>'
                
                +'<h3> <b>Title:</b> Release of DRC Report to Customer</h3><br>'
                +'<p> The DRC Report for  '+collaborator.Mask_Set_Title__c+'  has following <font color="#FF0000"><b> not waived rules </b></font></p><br><br>';
                
            if(count>0){
                body +=  ruleListString;
            }
            body +='<br><br>Note: Only top 10 rules will be displayed. To view ALL rules, please access the URL indicated below. <br><br>'
                +'<br><br>Action Required: Waiver report is pending your review and approval for release to customer in the DRC Waiver Collaborator <br>'                        
                + waiverCollaboratorURL + collaborator.Id+'<br><br>'
                +'Please select respective Customer and Account Manager in Collaborator.<br>'
                +'You can use Chatter in Collaborator if updates are required from '+collaborator.FAB__C+' Design Review Board.</br>' 
                
                +'<p><font color="#FF0000"><b> Proceed to release =</b></font>  Release DRC report in Collaborator to notify customer to take respective action. </p> <br>'
                +'<br>'
                
                +'<p><b>Issue Title:</b> DRC Waiver Collaboration File <font color="#FF0000">'+collaborator.Name+'</font></p><br>'
                
                +'<p>Collaborator Workflow Status: <font color="#0099ff">'+ ' Pending For FAE' +'</font></p><br><br>'
                +'Access the following URL to login to the Design Waiver Collaborator for the DRC Review Results:<br>'
                + waiverCollaboratorURL + collaborator.Id+'<br><br>'
                
                
                
                +'</html>';
            //send plain text body
            try{
            emailUtil.htmlBody(body)
                .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
                .subject(subject)
                .sendEmail();
                 }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcReleaseReportToCustomer()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }  
        }
        
    }
    //Template 2 - Reminder for: Release of DRC Report to Customer
    //scheduled batch to trigger this mail
    public static void drcReminderReleaseReportToCustomer(Wavier_Collaborator__c collaborator){
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL;     
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> ccAddresses = DfmUtilityCls.drbEmailIDs(drbGrp);
        //bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        //Transient String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient String subject='Reminder: Your Approval is required :'+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c;
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title:</b>Reminder for Release of DRC Report to Customer</h3><br>'
            +'The DRC Report for  '+collaborator.Mask_Set_Title__c+'  has not been released to Customer for 2 days  <br><br>'
            
            
            +'Action Required: Waiver report is pending your review and approval for release to customer for design fixes / accepting risk in the DRC Waiver Collaborator <br>'                        
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            +'<p><font color="#FF0000"><b> Proceed to release =</b></font>  Trigger Collaborator to release DRC report and notify customer to take respective action.</p> '
            +'<br><br>'
            
            +'<b>Issue Title:</b>  DRC Waiver Collaboration File '+collaborator.Name+'<br>'
            
            +'<b>Collaborator Workflow Status: </b> '+ ' Pending For FAE' +'<br><br>'
            
            +'Access the following URL to login to the Design Waiver Collaborator for the DRC Review Results:<br>'
            +waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();  
             }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcReminderReleaseReportToCustomer()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }  
        
    }
    
    //Template 3 - Response Required for DRC Report - to be sent-out in case of one of the rules is not waived
    
    public static void drcResponseRequiredReport(Wavier_Collaborator__c collaborator){
        //system.debug('selectedcustomers >>>>>>>>>> '+collaborator.DRB_Group_uIds__c);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        Transient Set<Id> ccUserIds = new Set<Id>();
        Transient Set<Id> custIds = new Set<Id>();//= DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        } 
        Transient List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
            Transient Set<Id> atpManagerUIds = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        if (setOfFAEs<>NULL && !setOfFAEs.isEmpty()){
            ccUserIds.addAll(setOfFAEs);
        }
        if (atpManagerUIds<>NULL && !atpManagerUIds.isEmpty()){
            ccUserIds.addAll(atpManagerUIds);
        }
        
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(ccUserIds);
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> bccAddresses = DfmUtilityCls.drbEmailIDs(drbGrp);
        if(bccAddresses==null || bccAddresses.isEmpty())
            bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
            bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));    
                //Transient List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
                DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient String subject='Your Response is required: '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title:</b>Response Required for DRC Report</h3><br><br>'
            +'DRC Review according to your waiver request per '+collaborator.PTSR_Number__c+'  has been closed <br>'
            +'Your request of DRC waiver for  '+collaborator.Mask_Set_Title__c+' can not be accepted completely. <br><br>'
            
            +'Your prompt choice of action is required in the Design Waiver Collaborator <br>'                        
            + waiverCollaboratorURL+ collaborator.Id+'<br><br>'
            
            +'<b>Issue Title:</b> DRC Waiver Collaboration File '+collaborator.Name+'<br>'
            
            +'<b>Collaborator Workflow Status:</b> '+' Pending For Customer'+'<br><br>'
            
            +'<br>Access the following URL to see Customer DRC Waiver Request: <br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail(); 
            }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcResponseRequiredReport()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
    }
    
    //Template 4 - Reminder for: Response Required for DRC Report - to be sent-out in case of one of the rules is not waived
    
    public static void drcReminderResponseRequiredReport(Id collaboratorId){
        Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient  Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        Transient Set<Id> custIds = new Set<Id>();//= DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str)); 
            }
        }
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL;  
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = new List<String>();
        //bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));    
        
            
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        //Transient String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient String subject='Reminder :Your Response is required: '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title:</b>Reminder for Response Required for DRC Report</h3><br><br>'
            
            +'DRC Review according to your waiver request per '+collaborator.PTSR_Number__c+'  has been closed <br>'
            +'Your request of DRC waiver for  '+collaborator.Mask_Set_Title__c+'  can not be accepted completely. <br><br>'
            
            +'Please be reminded that your choice of action is required in the Design Waiver Collaborator <br> '                        
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            +'Decision is open for 2 days..<br> <br>'
            
            +'<b>Issue Title:</b> DRC Waiver Collaboration File '+collaborator.Name+'<br>'
            
            +'<b>Collaborator Workflow Status:</b> '+' Pending For Customer'+'<br><br>'
            
            +'<br>Access the following URL to see Customer DRC Waiver Request: <br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail(); 
           }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcReminderResponseRequiredReport()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
    }
    
    //Template 5 - Notification of Customer Decision for DRC Report - consolidated mail to be sent-out in case of decision made by customer
    
    public static void drcDecisionMadeByCustReport(Wavier_Collaborator__c collaborator){
        //collaborator = getWaiverCollaborator(drcId);
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> fab1_DRC_ALLN_DRB = DfmUtilityCls.drbEmailIDs(drbGrp);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
                Transient Set<Id> atpManagerUIds = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        Transient Set<Id> ccUserIds = new Set<Id>();
        
        if (atpManagerUIds<>NULL && !atpManagerUIds.isEmpty()){
            ccUserIds.addAll(atpManagerUIds);
        }
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(ccUserIds);
        if(ccAddresses<>null && !ccAddresses.isEmpty() && fab1_DRC_ALLN_DRB <> null && !fab1_DRC_ALLN_DRB.isEmpty()){
            ccAddresses.addAll(fab1_DRC_ALLN_DRB);
        }else if(fab1_DRC_ALLN_DRB <> null && !fab1_DRC_ALLN_DRB.isEmpty()){
            ccAddresses = fab1_DRC_ALLN_DRB;
        }
        //bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));    
            
            DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        Transient String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
        Transient String fCFString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td><td bgcolor="#E6E6E6"><b>Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Transient String wCRString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td><td bgcolor="#E6E6E6"><b>Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Transient String fDCCfDiString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td>'
            +'<td bgcolor="#E6E6E6"><b>Prime Die</b> </td><td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Transient String DisAgreeString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td><td bgcolor="#E6E6E6"><b>Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id);     
        // System.debug('>>>>>>>> getWaiverRuleList is getting called with >>>  '+waiverRuleList.size());
        Integer fCFCount =0;
        Integer wCRCount=0;
        Integer fCCCount =0;
        Integer DisAgree =0;
        for(Waiver_Rule_List__c rules : waiverRuleList) {
        system.debug('test'+rules.Final_Stage__c);
            if(rules.Final_Stage__c=='FCF' && !(fCFCount>4)){
                
                fCFString+='<tr>';
                if(rules.Design_Rule_Name__c <>null){
                    fCFString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    fCFString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    fCFString+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    fCFString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    fCFString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    fCFString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c<>null){
                    fCFString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                }else{
                    fCFString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                
                if(rules.Final_Stage__c <> null){
                    fCFString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                }else{
                    fCFString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                fCFString+='</tr>';        
                fCFCount++;
                
            }else if(rules.Final_Stage__c=='WCR' && !(wCRCount>4)){
                
               
                wCRString+='<tr>';
                if(rules.Design_Rule_Name__c <>null){
                    wCRString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    wCRString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    wCRString+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    wCRString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    wCRString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    wCRString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c<>null){
                    wCRString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                }else{
                    wCRString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                
                if(rules.Final_Stage__c <> null){
                    wCRString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                }else{
                    wCRString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                wCRString+='</tr>';
                wCRCount++;
                
            }else if(rules.Disagree__c && (DisAgree<4) && 
            (rules.Final_Stage__c!='WCR' && rules.Final_Stage__c!='FCF' && rules.Final_Stage__c!='PI'  && rules.Final_Stage__c!='PWA' && rules.Final_Stage__c!='PW' && rules.Final_Stage__c!='PWO' && rules.Final_Stage__c!='POC' && !rules.IsGfAcceptsRisk__c)){                
                
                DisAgreeString+='<tr>';
                if(rules.Design_Rule_Name__c <>null){
                    DisAgreeString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    DisAgreeString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    DisAgreeString+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    DisAgreeString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    DisAgreeString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    DisAgreeString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c<>null){
                    DisAgreeString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                }else{
                    DisAgreeString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                
                if(rules.Final_Stage__c <> null){
                    DisAgreeString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                }else{
                    DisAgreeString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                DisAgreeString+='</tr>';
                DisAgree++;
            } else if(!(fCCCount>4) && (rules.Final_Stage__c<>null && rules.Final_Stage__c!='PW' && rules.Final_Stage__c!='PI' && rules.Final_Stage__c!='PA' && rules.Final_Stage__c!='PWA' 
                                        && rules.Final_Stage__c!='PWO' && rules.Final_Stage__c!='POC' && rules.Final_Stage__c!='FCF' && rules.Final_Stage__c!='WCR' && rules.Final_Stage__c!='WEA')){                
                system.debug('test'+rules.Final_Stage__c);
                fDCCfDiString+='<tr>';
                if(rules.Design_Rule_Name__c <>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c<>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                
                if(rules.Final_Stage__c <> null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                fDCCfDiString+='</tr>';
                fCCCount++;
            }   
        }
         system.debug('test@@'+wCRCount);
        fCFString = fCFString+ '</table>';
        wCRString = wCRString+ '</table>';
        fDCCfDiString = fDCCfDiString+ '</table>';
        DisAgreeString= DisAgreeString+ '</table>';
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        if(collaborator.PTSR_Service_Type__c.toUpperCase().contains('DRC')){
        Transient String subject='Notification of Customer response for: '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title:</b>Notification of Customer-Decision for DRC Report for  '+collaborator.Mask_Set_Title__c+' </h3><br><br>';
        if(fCFCount>0){
            body +='Customer agrees to fix all non-waived violations in the following rules and resubmit fixed design for tapeout:<br><br>';
            body +=fCFString;
        }
        if(wCRCount>0){
            body +='<br><br> Customer agrees to waive all violations in the following rules assuming all related risk liability <br><br>'  ;                      
            body +=wCRString;
        }
         if(DisAgree>0){
            body +='<br><br> Customer disagrees to fix / take-risk on the following rules: <br><br>'  ;                      
            body +=DisAgreeString;
        }
        
        body +='<br><br>Note : Only Top 5 rules will be displayed. To view all rules, please access the URL indicated below. <br><br>'
             
             +'<br><br><br>Action Required: : Discuss with customer for design fixes / accepting risk in the DRC Waiver Report for the FCD rules and trigger Fab internal TIER2 approval for the rules, customer has chosen Option 3-Customer does not agree to fix or to take risk.<br><br>'
            
            +'<p><font color="#FF0000"><b> Proceed to release =</b></font> Trigger Collaborator to start TIER2 internal approval or customer to take respective action. </p> '
            +'<br><br>'
            
            +'<b>Issue Title:</b> DRC Waiver Collaboration File '+collaborator.Name+'<br><br>'
            
            +'<b>Collaborator Workflow Status:</b> '+'collaborator.Progressbar_staus__c '+'<br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator for the DRC Review Results:<br>'
            +System.Label.DFM_Internal_URL+ '/' + collaborator.Id+'<br><br>'
            
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail(); 
         }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcDecisionMadeByCustReport()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
        }
    }
    
    //Template 6 - FAE Action Notification for Customer Discussion / Foundry-to-Risk approval
    //to be sent-out in case of not all decision made by customer 
    
    public static void drcNotAllDecisionMadebyCust(Id collaboratorId){
        Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> ccAddresses = DfmUtilityCls.drbEmailIDs(drbGrp);
        //bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
            
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
            
            DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        Transient String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
        Transient String fDCCfDiString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td><td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Transient String disAgreeString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id); 
        Integer fCCCount=0;
        Integer DisAgree=0;
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            
            if(rules.Final_Stage__c!='WCR' && rules.Final_Stage__c!='FCF' && rules.Final_Stage__c!='PI'  && rules.Final_Stage__c!='PWA' && rules.Final_Stage__c!='PW' && rules.Final_Stage__c!='PWO' && rules.Final_Stage__c!='POC' && !rules.IsGfAcceptsRisk__c){
                fDCCfDiString+= '<tr>';                 
                if(rules.Design_Rule_Name__c <>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c <>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Final_Stage__c <>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                fDCCfDiString+='</tr>';
                
                
                fCCCount++;
                if(fCCCount>9){
                    break;
                }
            }
                if((rules.Disagree__c && 
                (rules.Final_Stage__c!='WCR' && rules.Final_Stage__c!='FCF' && rules.Final_Stage__c!='PI'  && rules.Final_Stage__c!='PWA' && rules.Final_Stage__c!='PW' && rules.Final_Stage__c!='PWO' && rules.Final_Stage__c!='POC' && !rules.IsGfAcceptsRisk__c && rules.Final_Stage__c!='WEA'))
                 || Test.isRunningTest() ){
                disAgreeString+= '<tr>';                 
                if(rules.Design_Rule_Name__c <>null){
                    disAgreeString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    disAgreeString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    disAgreeString+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    disAgreeString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    disAgreeString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    disAgreeString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c <>null){
                    disAgreeString+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                }else{
                    disAgreeString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Final_Stage__c <>null){
                    disAgreeString+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                }else{
                    disAgreeString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                disAgreeString+='</tr>';
                
                
                DisAgree++;
                if(DisAgree>9){
                    break;
                }
            }               
        }
        fDCCfDiString = fDCCfDiString+ '</table>';
        disAgreeString=disAgreeString+ '</table>';
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient String subject='Your Action is required:  '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
        // Prepare email body
        Transient String body = '<html>' 
            
            +'<h3> <b>Title:</b>FAE Action Reminder for Customer Response and Triggering TIER2 approval </h3><br><br>'
            +'The DRC waiver Request for  '+collaborator.Mask_Set_Title__c+'  has been rejected and customer has not been responding to agree to design fixes or accepting risk. Please proceed to discuss with Account-Manager and the customer. If no positive response, you may trigger for foundry-to-risk approval in the Design Waiver Collaborator <br>'
            +collaborator.PTSR_Number__c;
            if(DisAgree>0){
            
            body += '<br><br>Customer disagrees to fix / take-risk on the following rules:<br><br>';
            body +=disAgreeString;
        }
            
        
        body +='<br><br>Note : Only Top 10 rules will be displayed. To view all rules, please access the URL indicated below. <br><br>'
            +'<br><br><br><p><font color="#FF0000"><b> Proceed to release =</b></font> '            
            +'Discuss with customer for design fixes / accepting risk in the DRC Waiver Report and trigger Fab internal TIER2 approval for the rules, customer has chosen Option 4.</p><br><br><br>'
            +'<b>Issue Title:</b> DRC Waiver Collaboration File '+collaborator.Name+'<br><br>'
            
            
            +'<b>Collaborator Workflow Status:</b> '+' Pending For Customer'+'<br><br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator for the DRC Review Results:<br>'
            +waiverCollaboratorURL + collaborator.Id+'<br>'
            
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail(); 
         }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcNotAllDecisionMadebyCust()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    //Template 7 - Foundry-to-Risk Approval - only one template and one condition to trigger
    // 7a - FAE triggers TIER2 approval and >10 open rules 
    // 7b - to be sent-out in case of FAE triggers TIER2 approval and <10 open rules
    
    
    public static void drcFoundryToRiskApproval(Wavier_Collaborator__c collaborator,Set<Id> waiverRuleSet){
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        setUpPiyeAndQAUsers(collaborator);
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        Transient Set<Id> setOfAllApprovers = new Set<Id>();        
        Transient Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
        //Set<Id> AM_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_AM')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_AM').keySet():NULL;
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Transient Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        
        if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers.addAll(PIYE_Users);
        }
        if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers.addAll(QA_Users);
        }
        if (DE_Users<>NULL && !DE_Users.isEmpty()){
            setOfAllApprovers.addAll(DE_Users);
        }
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfAllApprovers);
        List<String> ccAddresses = new List<String>();
        if(setOfFAEs<>null && !setOfFAEs.isEmpty()){
        ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        }
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> ccAddresses1 = DfmUtilityCls.drbEmailIDs(drbGrp);
        if(ccAddresses1 <>null){
        ccAddresses.addAll(ccAddresses1); 
        }
        //bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);        
        Transient String fDCCfDiString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td><td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id); 
        Integer fCCCount=0;
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            
            if(((waiverRuleSet.contains(rules.Id)) && rules.Final_Stage__c!='WCR' && rules.Final_Stage__c!='FCF' && rules.Final_Stage__c!='PI' && rules.Final_Stage__c!='PW' && rules.Final_Stage__c!='PWO' && rules.Final_Stage__c!='POC' && rules.Final_Stage__c!='PWA') ||  Test.isRunningTest()){
                
                fDCCfDiString+= '<tr>';                 
                if(rules.Design_Rule_Name__c <>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c <>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Final_Stage__c <>null){
                    fDCCfDiString+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                }else{
                    fDCCfDiString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                fDCCfDiString+='</tr>';
                
                fCCCount++;
                if(fCCCount>9){
                    break;
                }
            }   
        
    }
        fDCCfDiString = fDCCfDiString+ '</table>';
        Transient String subject='Your Approval is required: '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c;
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title:</b>Foundry-to-Risk Approval from PI/YE, DE, QA, AM</h3><br>'
            +'Not all violations in  DRC waiver Request for  '+collaborator.Mask_Set_Title__c
            +' have been waived by '+collaborator.FAB__c +' Waiver Review Board and customer has declined to design fixes or to accept risk for all non-waived rules.<br>' 
            +'<br> Your approval is required for foundry to accept risk for the below mentioned rules (Will communicate as'
            +'<b> Exceptional Arrangement </b>'
            +' to the customer once a member from each of the approval groups approves):<br><br>' ;
        
        if(fCCCount>0){
            body += fDCCfDiString  ; 
        }
        body +='<br><br>Note : Only Top 10 rules will be displayed. To view all rules, please access the URL indicated below. <br><br>'
             +'<br><br><br>Not all rules shown, please open Collaborator <br>'                        
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            +'<b>Issue Title:</b> DRC Waiver Collaboration File '+collaborator.Name+'<br>'
            
            +'<b>Collaborator Workflow Status:</b> '+' Pending For Foundry'+'<br><br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator for the DRC Review Results:<br>'
            +System.Label.DFM_Internal_URL+ '/04i'+ '<br>'
            
            
            +'</html>';
        //send plain text body
        
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail(); 
          }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcFoundryToRiskApproval()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
   
    //Template 9a - DRC Review Summary Notification ... This method invoked when Collaborator WF is closed & 9a to be sent-out in if Collaborator is close and no  WEA or FD
    
    public static void drcReviewSummaryNotification9a(Wavier_Collaborator__c collaborator){
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfAllApprovers = new Set<Id>();
        Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        Transient Set<Id> custIds = new Set<Id>();//= DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Transient Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        
        if (setOfFAEs<>NULL && !setOfFAEs.isEmpty()){
            setOfAllApprovers.addAll(setOfFAEs);
        }       
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
         
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfAllApprovers);
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> bccAddresses = DfmUtilityCls.drbEmailIDs(drbGrp);
        
        if(bccAddresses==null || bccAddresses.isEmpty())
            bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
            bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));   
                
                //Transient List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
                DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        Transient String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
        
        Transient Integer waiverRuleListPW=0;
        Transient Integer waiverRuleListPI=0;
        Transient String waiverRuleListFCF='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td><td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Transient String waiverRuleListWCR='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Transient String waiverRuleListWEA='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
                            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
                            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id);
        
        Integer ruleListFCFCount=0;
        Integer ruleListWCRCount=0;
        Integer ruleListWEACount=0;
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            if(rules.Final_Stage__c!='FD' || rules.Final_Stage__c!='IFD'){
                
                if(rules.Final_Stage__c=='FCF' && !(ruleListFCFCount>9)){
                    
                    
                    waiverRuleListFCF+= '<tr>';                 
                    if(rules.Design_Rule_Name__c <>null){
                        waiverRuleListFCF+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListFCF+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Rule_Description__c <>null){
                        waiverRuleListFCF+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListFCF+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Prime_Die_Name__c<>null){
                        waiverRuleListFCF+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListFCF+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Stage__c <>null){
                        waiverRuleListFCF+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListFCF+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Final_Stage__c <>null){
                        waiverRuleListFCF+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListFCF+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    waiverRuleListFCF+='</tr>';
                    
                    
                    
                    
                    ruleListFCFCount++;
                }else if(rules.Final_Stage__c=='WCR' && !(ruleListWCRCount>9)){
                    
                    waiverRuleListWCR+= '<tr>';                 
                    if(rules.Design_Rule_Name__c <>null){
                        waiverRuleListWCR+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListWCR+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Rule_Description__c <>null){
                        waiverRuleListWCR+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListWCR+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Prime_Die_Name__c<>null){
                        waiverRuleListWCR+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListWCR+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Stage__c <>null){
                        waiverRuleListWCR+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListWCR+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Final_Stage__c <>null){
                        waiverRuleListWCR+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListWCR+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    waiverRuleListWCR+='</tr>';
                    
                    
                    
                    ruleListWCRCount++;
                }else if(rules.Final_Stage__c=='WEA' && !(ruleListWEACount>9)){
                    
                    waiverRuleListWEA+= '<tr>';                 
                    if(rules.Design_Rule_Name__c <>null){
                        waiverRuleListWEA+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListWEA+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Rule_Description__c <>null){
                        waiverRuleListWEA+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListWEA+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                     if(rules.Prime_Die_Name__c<>null){
                        waiverRuleListWEA+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListWEA+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Stage__c <>null){
                        waiverRuleListWEA+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListWEA+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    if(rules.Final_Stage__c <>null){
                        waiverRuleListWEA+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                    }else{
                        waiverRuleListWEA+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                    }
                    waiverRuleListWEA+='</tr>';
                    
                    ruleListWEACount++;
                    
                }else if(rules.Final_Stage__c=='PW' || rules.Final_Stage__c=='PWO'){
                    waiverRuleListPW++;
                }else if(rules.Final_Stage__c=='PI' || rules.Final_Stage__c=='POC'){
                    waiverRuleListPI++;
                }
                
            }   
        }
        waiverRuleListFCF = waiverRuleListFCF+ '</table>';
        waiverRuleListWCR = waiverRuleListWCR+ '</table>';
        waiverRuleListWEA = waiverRuleListWEA+ '</table>';
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient  String subject='Notification: '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
        
        // Prepare email body
        Transient  String body = '<html>'
            
            +'<h3> <b>Title: DRC Review Summary</b></h3><br><br>'
            +'Your request for DRC waiver in <br>'
            + waiverCollaboratorURL+ collaborator.Id+'<br>'
            +'  for  '+collaborator.Mask_Set_Title__c+'  has been closed.<br><br>'
            
            
            
            +waiverRuleListPW+' rules have been reviewed and have been confirmed as waived by GLOBALFOUNDRIES for the scope of the respective request.<br><br> '
            +waiverRuleListPI+' rules have not been reviewed in accordance to your Waiver Request. GLOBALFOUNDRIES expectation is that these violations are absent in final tape-out design.<br><br>';
            
        if(ruleListFCFCount>0){
            body += '<p>All violations for following rules are <b> <font color="#FF0000">agreed by Customer to be fixed </font></b> in tape-out database:</p><br><br>';
            body += waiverRuleListFCF;
        }
        if(ruleListWCRCount>0){
            body += '<br><br><p>All violations for following rules are <b><font color="#ff9933"> waived by Customer assuming all related risk</font></b>:</p><br><br>';
            body += waiverRuleListWCR;
        }
         if(ruleListWEACount>0){
            body += '<br><br><p>All violations for following rules are <b><font color="#ff9933"> waived with exceptional agreement by GLOBALFOUNDRIES: </font></b>:</p><br><br>';
            body += waiverRuleListWEA;
        }
        
        
        
        body +='<br><br>Note : Only Top 10 rules will be displayed. To view all rules, please access the URL indicated below. <br><br>'
            +'<br><br><p><b>Issue Title:</b> DRC Waiver Collaboration File <font color="#FF0000">'+collaborator.Name+'</font></p><br>'
            
            +'<b>Aggregated Waiver Review Status:</b> '+collaborator.Waiver_Status__c+'<br>'
            +'<b>Collaborator Workflow Status:</b> '+collaborator.Workflow_Status__c+'<br><br>'
            
            +'Access the following URL to see Customer DRC Waiver Request:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            +'<br><br><br>'
            
            
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail(); 
         }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcReviewSummaryNotification9a()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    //Template 9b - DRC Review Summary Notification  ... This method invoked when Collaborator WF is closed & 9b - to be sent-out in if Collaborator is close and at least one rule is CustomerFinalStatus = (WEA)
    public static void drcReviewSummaryNotification9b(Wavier_Collaborator__c collaborator){
        
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfAllApprovers = new Set<Id>();
        Transient Set<Id> setOfAllApprovers2 = new Set<Id>();
        Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        Transient Set<Id> custIds = new Set<Id>();//= DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        Transient Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Transient Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        setUpPiyeAndQAUsers(collaborator); 
        if (setOfFAEs<>NULL && !setOfFAEs.isEmpty()){
            setOfAllApprovers.addAll(setOfFAEs);
        }       
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers2.addAll(PIYE_Users);
        }
        if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers2.addAll(QA_Users);
        }
        if (DE_Users<>NULL && !DE_Users.isEmpty()){
            setOfAllApprovers2.addAll(DE_Users);
        }
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        } 
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfAllApprovers);
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> fab1_DRC_ALLN_DRB = DfmUtilityCls.drbEmailIDs(drbGrp); 
        List<String> bccAddresses = new List<String>();
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(setOfAllApprovers2));
        
        if(bccAddresses<>null && !bccAddresses.isEmpty() && fab1_DRC_ALLN_DRB <> null && !fab1_DRC_ALLN_DRB.isEmpty()){
            bccAddresses.addAll(fab1_DRC_ALLN_DRB); 
        }else if(fab1_DRC_ALLN_DRB <> null && !fab1_DRC_ALLN_DRB.isEmpty()){
            bccAddresses = fab1_DRC_ALLN_DRB;
        }
        
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        
        Transient Integer waiverRuleListPW=0;
        Transient Integer waiverRuleListPI=0;
        Transient String waiverRuleListFCF='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Transient String waiverRuleListWCR='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Transient String waiverRuleListWEA='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id); 
        Boolean iSWEACase = false;
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            if(rules.Final_Stage__c=='WEA'){
                iSWEACase = TRUE;
                break;
            }
        }
        
        Integer ruleListFCFCount=0;
        Integer ruleListWCRCount=0;
        Integer ruleListWEACount=0;
        if(iSWEACase){
            for(Waiver_Rule_List__c rules : waiverRuleList) {
                if(rules.Final_Stage__c!='FD' && rules.Final_Stage__c!='IFD'){
                    if(rules.Final_Stage__c=='FCF' && !(ruleListFCFCount>9)){
                        
                        
                        waiverRuleListFCF+= '<tr>';                 
                        if(rules.Design_Rule_Name__c <>null){
                            waiverRuleListFCF+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListFCF+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Rule_Description__c <>null){
                            waiverRuleListFCF+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListFCF+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Prime_Die_Name__c<>null){
                            waiverRuleListFCF+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListFCF+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Stage__c <>null){
                            waiverRuleListFCF+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListFCF+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Final_Stage__c <>null){
                            waiverRuleListFCF+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListFCF+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        waiverRuleListFCF+='</tr>';
                        
                        
                        ruleListFCFCount++;
                    }else if(rules.Final_Stage__c=='WCR' && !(ruleListWCRCount>9)){
                        
                        
                        waiverRuleListWCR+= '<tr>';                 
                        if(rules.Design_Rule_Name__c <>null){
                            waiverRuleListWCR+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListWCR+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Rule_Description__c <>null){
                            waiverRuleListWCR+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListWCR+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Prime_Die_Name__c<>null){
                            waiverRuleListWCR+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListWCR+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Stage__c <>null){
                            waiverRuleListWCR+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListWCR+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Final_Stage__c <>null){
                            waiverRuleListWCR+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListWCR+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        waiverRuleListWCR+='</tr>';
                        
                        
                        
                        ruleListWCRCount++;
                    }else if(rules.Final_Stage__c=='WEA' && !(ruleListWEACount>9)){
                        
                        
                        waiverRuleListWEA+= '<tr>';                 
                        if(rules.Design_Rule_Name__c <>null){
                            waiverRuleListWEA+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListWEA+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Rule_Description__c <>null){
                            waiverRuleListWEA+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListWEA+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Prime_Die_Name__c<>null){
                            waiverRuleListWEA+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListWEA+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Stage__c <>null){
                            waiverRuleListWEA+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListWEA+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        if(rules.Final_Stage__c <>null){
                            waiverRuleListWEA+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                        }else{
                            waiverRuleListWEA+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                        }
                        waiverRuleListWEA+='</tr>';
                        
                        ruleListWEACount++;
                    }else if(rules.Final_Stage__c=='PW' || rules.Final_Stage__c=='PWO'){
                        waiverRuleListPW++;
                    }else if(rules.Final_Stage__c=='PI' || rules.Final_Stage__c=='POC'){
                        waiverRuleListPI++;
                    }
                    
                }   
            }
            waiverRuleListFCF = waiverRuleListFCF+ '</table>';
            waiverRuleListWCR = waiverRuleListWCR+ '</table>';
            waiverRuleListWEA = waiverRuleListWEA+ '</table>';
        }else{
            waiverRuleListFCF = '';
            waiverRuleListWCR = '';
            waiverRuleListWEA = '';
        }
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient  String subject='Notification:  '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
        
        Transient  String body = '<html>'
            
            +'<h3> <b>Title: DRC Review Summary</b></h3><br>'
            +'Your request for DRC waiver in <br>'
            + waiverCollaboratorURL + collaborator.Id+'<br>'
            +'  for  '+collaborator.Mask_Set_Title__c+' has been closed.<br>' 
            +waiverRuleListPW+' rules have been reviewed and have been confirmed as waived by GLOBALFOUNDRIES for the scope of the respective request.<br> '
            +waiverRuleListPI+' rules have not been reviewed in accordance to your Waiver Request. GLOBALFOUNDRIES expectation is that these violations are absent in final tape-out design.<br><br>';
            
        
        //+'<p>All violations for following rules are <b> <font color="#FF0000">agreed by Customer to be fixed </font></b> in tape-out database:</p><br><br>'
        //+waiverRuleListFCF
        //+'<br><br><p>All violations for following rules are <b><font color="#ff9933"> waived by Customer assuming all related risk</font></b>:</p><br><br>'
        //+waiverRuleListWCR
        if(ruleListWEACount>0){
            body += '<br><br><p>All violations for following rules are <b><font color="#ff9933"> waived with exceptional agreement by GLOBALFOUNDRIES</font></b>:</p><br>';
            body += waiverRuleListWEA;
        }
        body +='<br><br>Note : Only Top 10 rules will be displayed. To view all rules, please access the URL indicated below. <br><br>' 
            +'<br><br><p><b>Issue Title:</b> DRC Waiver Collaboration File <font color="#FF0000">'+collaborator.Name+'</font></p><br>'
            
            +'<b>Aggregated Waiver Review Status:</b> '+collaborator.Waiver_Status__c+'<br>'
            +'<b>Collaborator Workflow Status:</b> '+collaborator.Workflow_Status__c+'<br><br>'
            +'Access the following URL to see Customer DRC Waiver Request:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            
            + '</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail(); 
          }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcReviewSummaryNotification9b()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    //Template 10 - Customer Design Rejected - to be sent-out in if Collaborator is close and at least one rule is CustomerFinalStatus = (FD)  
    
    public static void drcDesignRejectNotification(Wavier_Collaborator__c collaborator){
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> fab1_DRC_ALLN_DRB = DfmUtilityCls.drbEmailIDs(drbGrp);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        Transient Set<Id> setOfAllApprovers = new Set<Id>();
        Transient Set<Id> setOfAllApprovers2 = new Set<Id>();
        
        Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        Transient Set<Id> custIds = new Set<Id>();//= DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        Transient Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
        Transient Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        setUpPiyeAndQAUsers(collaborator);
        
        if (setOfFAEs<>NULL && !setOfFAEs.isEmpty()){ 
            setOfAllApprovers.addAll(setOfFAEs);
        }       
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers2.addAll(PIYE_Users);
        }
        
        if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers2.addAll(QA_Users);
        }
        if (DE_Users<>NULL && !DE_Users.isEmpty()){
            setOfAllApprovers2.addAll(DE_Users);
        }
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        } 
        
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        List<String> toAddresses = new List<String>();//DfmUtilityCls.getEmailIds(setOfAllApprovers);
        List<String> ccAddresses = new List<String>();
        List<String> bccAddresses = new List<String>();
        
        toAddresses.addAll(DfmUtilityCls.getEmailIds(setOfAllApprovers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(setOfAllApprovers2));
        
        if(bccAddresses<>null && !bccAddresses.isEmpty() && fab1_DRC_ALLN_DRB <> null && !fab1_DRC_ALLN_DRB.isEmpty()){
            bccAddresses.addAll(fab1_DRC_ALLN_DRB); 
        }else if(fab1_DRC_ALLN_DRB <> null && !fab1_DRC_ALLN_DRB.isEmpty()){
            bccAddresses = fab1_DRC_ALLN_DRB;
        }
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        Transient String waiverRuleListFD='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> Prime Die </b></td><td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id); 
        Integer fDruleCount =0;
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            if((rules.Final_Stage__c=='FD' || rules.Final_Stage__c=='IFD')&& !(fDruleCount>9)){
                
                
                waiverRuleListFD+= '<tr>';                 
                if(rules.Design_Rule_Name__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Prime_Die_Name__c + '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Final_Stage__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                
                waiverRuleListFD+='</tr>';
                
                
                
                fDruleCount++;       
            }   
        }
        
        waiverRuleListFD += '</table>';
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient  String subject='Notification: '+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
        // Prepare email body
        Transient  String body = '<html>'
            
            +'<h3> <b>Title: Customer Design Rejected</b></h3><br><br>'
            +'<p>'+collaborator.Account_Name__c +' design in '+collaborator.PTSR_Number__c+'  for  '+collaborator.Mask_Set_Title__c+' has been <font color="#FF0000"> rejected </font> for following rules.</p><br><br>'
            
            + waiverRuleListFD
            +'<br><br>Note : Only top 10 rules will be displayed. To view all rules, please access the URL indicated below. <br><br>'
            +'<br><br>Please contact Customer <CustomerName> and align on further procedure. <br><br>'
            +'Details are summarized in DRC Waiver Collaboration File  '
            + waiverCollaboratorURL + collaborator.Id+'<br>' 
            +'<br><p><b>Issue Title:</b> DRC Waiver Collaboration File <font color="#FF0000">'+collaborator.Name+'</font></p><br>'
            
            +'<b>Aggregated Waiver Review Status:</b> '+collaborator.Waiver_Status__c+'<br>'
            +'<b>Collaborator Workflow Status:</b> '+collaborator.Workflow_Status__c+'<br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator for the DRC Review Results:<br>'
            +waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            
            + '</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail(); 
        }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcDesignRejectNotification()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    
    
    // Template 11 – Collaborator Job Cancelled - to be sent-out in if Collaborator is cancelled  
    
    public static void jobCancelledNotification(Wavier_Collaborator__c collaborator){
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> fab1_DRC_ALLN_DRB = DfmUtilityCls.drbEmailIDs(drbGrp);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            
            Transient Set<Id> setOfAllApprovers = new Set<Id>();
        Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        Transient Set<Id> custIds = new Set<Id>();       
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Transient Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        
        if (setOfFAEs<>NULL && !setOfFAEs.isEmpty()){
            setOfAllApprovers.addAll(setOfFAEs);
        }       
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        
        if (custIds<>NULL && !custIds.isEmpty()){
            setOfAllApprovers.addAll(custIds);
        }
        
        
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfAllApprovers);
        
        if(toAddresses<>null && !toAddresses.isEmpty() && fab1_DRC_ALLN_DRB <> null && !fab1_DRC_ALLN_DRB.isEmpty()){
            toAddresses.addAll(fab1_DRC_ALLN_DRB);
        }else if(fab1_DRC_ALLN_DRB <> null && !fab1_DRC_ALLN_DRB.isEmpty()){
            toAddresses = fab1_DRC_ALLN_DRB;
        }
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        List<String> ccAddresses = new List<String>();
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));    
            
            
            DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        
        Transient String subject=' Notification:  '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration, '+collaborator.Account_Name__c;
        // Prepare email body
        Transient String body = '<html>' 
            
            +'<h3>  <b>Title:  Collaborator Job Cancelled</b>   </h3><br>' 
            +'Collaborator Job for '
            +collaborator.Account_Name__c
            +' design in '
            +collaborator.PTSR_Number__c
            +' for  '+collaborator.Mask_Set_Title__c+' has been '            
            +'<p><font color="#FF0000"><b> Cancelled </b></font></p><br><br> '           
            +'Access the following URL to see Customer DRC Waiver Request:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();   
        }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'jobCancelledNotification()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    } 
    
    
    //Template 9c - Item9c Template – DRC Review Summary Notification
    
    public static void drcPIPWClosureNotification(Wavier_Collaborator__c collaborator){
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        Transient Set<Id> ccUserIds = new Set<Id>();
        
        Transient List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
            Transient Set<Id> atpManagerUIds = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        if (setOfFAEs<>NULL && !setOfFAEs.isEmpty()){
            ccUserIds.addAll(setOfFAEs);
        }
        if (atpManagerUIds<>NULL && !atpManagerUIds.isEmpty()){
            ccUserIds.addAll(atpManagerUIds);
        }
        List<String> toAddresses = new List<String>();
        if(collaborator.Created_By_Shortname__c <>null){          
            List<User>  users = [SELECT Id,Name,FederationIdentifier,HCM_Employee_ID__c,HCM_Login_ID__c, Email
                                FROM User
                                WHERE FederationIdentifier =: collaborator.Created_By_Shortname__c
                                OR HCM_Employee_ID__c =: collaborator.Created_By_Shortname__c
                                OR HCM_Login_ID__c =: collaborator.Created_By_Shortname__c];
            for(User usr : users){
                 toAddresses.add(usr.Email);
            }
            
        }
        if(collaborator.Submitted_By_Shortname__c<>null ){
            List<User>  users =[SELECT Id,Name,FederationIdentifier,HCM_Employee_ID__c,HCM_Login_ID__c, Email 
                                FROM User
                                WHERE FederationIdentifier =: collaborator.Submitted_By_Shortname__c
                                OR HCM_Employee_ID__c =: collaborator.Submitted_By_Shortname__c
                                OR HCM_Login_ID__c =: collaborator.Submitted_By_Shortname__c];
            for(User usr : users){
                 toAddresses.add(usr.Email);
            }
        }
        system.debug('ccUserIds@@'+ccUserIds);
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
          
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(ccUserIds);
        List<String> bccAddresses=DfmUtilityCls.getEmailIds(dwcAllEmails);
        String drbGrp;
        if(collaborator.DRB_Group_uIds__c<>null) drbGrp = collaborator.DRB_Group_uIds__c;
        
        if(drbGrp <>null)bccAddresses .addAll(DfmUtilityCls.drbEmailIDs(drbGrp));
        system.debug('ccUserIds@@'+ccUserIds+'bccAddresses##'+DfmUtilityCls.getEmailIds(dwcAllEmails));
        //if(dwcAllEmails <>null)bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        system.debug('ccUserIds@@'+ccUserIds+'bccAddresses##'+bccAddresses);
        if(bccAddresses==null || bccAddresses.isEmpty()) bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
                
                //Transient List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
                system.debug('bccAddresses dwc all  ##'+DfmUtilityCls.getEmailIds(dwcAllEmails)+'drbgroup'+DfmUtilityCls.drbEmailIDs(drbGrp));
                DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id); 
        Transient Integer waiverRuleListPW=0;
        Transient Integer waiverRuleListPI=0;
        
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            if(rules.Final_Stage__c=='PW' || rules.Final_Stage__c=='PWO'){
                waiverRuleListPW++;
            }else if(rules.Final_Stage__c=='PI' || rules.Final_Stage__c=='POC'){
                waiverRuleListPI++;
            }
            
        }   
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient String subject='Notification : '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c;
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title:</b> DRC Review Summary </h3><br><br>'
            +'Your request for DRC waiver in  '+collaborator.PTSR_Number__c+'  for '+collaborator.Mask_Set_Title__c+'  has been closed.<br>'
            +' <br>All your requested violations have been addressed and have been waived by Globalfoundries.<br><br>'
            
            +waiverRuleListPW+' rules have been reviewed and have been confirmed as waived by GLOBALFOUNDRIES for the scope of the respective request.<br> '
            +waiverRuleListPI+' rules have not been reviewed in accordance to your Waiver Request. GLOBALFOUNDRIES expectation is that these violations are absent in final tape-out design.<br><br>'
            
            
            +'<p><b>Issue Title:</b> DRC Waiver Collaboration File <font color="#FF0000">'+collaborator.Name+'</font></p><br><br>'
            +'<b>Aggregated Waiver Review Status:</b> '+collaborator.Waiver_Status__c+'<br><br>'
            +'<b>Collaborator Workflow Status:</b> '+collaborator.Workflow_Status__c+'<br><br>'
            
            +'<br>Access the following URL to see Customer DRC Waiver Request: <br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail(); 
         }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcPIPWClosureNotification()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    // Template 12 Foundry-to-Risk Approval Cancelled by Customer
 public static void foundrytoRiskApprovalCancelledbyCustomer(Id collaboratorId){
        Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);       
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> ccAddresses = DfmUtilityCls.drbEmailIDs(drbGrp);
        //bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));    
            
            DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        Transient String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
          Transient String fCFString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Transient String wCRString='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
            
            List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id);     
        // System.debug('>>>>>>>> getWaiverRuleList is getting called with >>>  '+waiverRuleList.size());
        
             Integer fCFCount =0;
             Integer wCRCount=0;
             for(Waiver_Rule_List__c rules : waiverRuleList) {
            if(rules.Final_Stage__c=='FCF' && (fCFCount<9)){
                
                fCFString+='<tr>';
                if(rules.Design_Rule_Name__c <>null){
                    fCFString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    fCFString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    fCFString+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    fCFString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    fCFString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    fCFString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c<>null){
                    fCFString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                }else{
                    fCFString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                
                if(rules.Final_Stage__c <> null){
                    fCFString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                }else{
                    fCFString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                fCFString+='</tr>';        
                fCFCount++;
                
            }else if(rules.Final_Stage__c=='WCR' && (wCRCount<9)){
                
                
                wCRString+='<tr>';
                if(rules.Design_Rule_Name__c <>null){
                    wCRString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    wCRString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    wCRString+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    wCRString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    wCRString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    wCRString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c<>null){
                    wCRString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                }else{
                    wCRString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                
                if(rules.Final_Stage__c <> null){
                    wCRString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                }else{
                    wCRString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                wCRString+='</tr>';
                wCRCount++;
            }
             }
             
               fCFString += '</table>';
                 wCRString += '</table>';
             
             String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        }
         Transient String subject='Your Approval is not required any more:'+collaborator.Name+' , '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c+'';
            // Prepare email body
            Transient String body = '<html>'
                
                +'<h3> <b>Title:</b>Foundry-to-Risk Approval from PIYE, DE, QA, AM not required any more.</h3><br><br>'
                +'<p>Your approval is <b>not required any more </b> for foundry to accept risk as customer has agreed to take risk or for the below mentioned rules:</p> <br><br>';
                
                
                 if(fCFCount>0){
                     body +='All violations for following rules are agreed by Customer to be fixed in tape-out database: <br><br>';
                     body +=fCFString;  
                 }
                 if(wCRCount>0){
                     body +='<br><br> All violations for following rules are waived by Customer assuming all related risk: <br><br>'  ;                      
                     body +=wCRString;
                 }              
                  body +='<br><br>Note :Only Top 10 rules will be displayed. To view all rules, please access the URL indicated below. <br><br>'
                  
                      +'<p><b>Issue Title:</b> DRC Waiver Collaboration File <font color="#FF0000">'+collaborator.Name+'</font></p><br><br>'               
                      +'<p>Collaborator Workflow Status: <font color="#0099ff">'+collaborator.Workflow_Status__c+'</font></p><br><br>'
                      +'Access the following URL to login to the Design Waiver Collaborator for the DRC Review Results:<br>'
                      +System.Label.DFM_Internal_URL+ '/' + collaborator.Id+'<br><br>'
                      +'<br><br>'
                
                
                +'</html>';
            //send plain text body
            try{
            emailUtil.htmlBody(body)
                .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
                .subject(subject)
                .sendEmail();  
              }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'foundrytoRiskApprovalCancelledbyCustomer()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    
    
    //L0: Collaborator is triggered by PTSR to initiate a long flow : Acknowledgement of DFM Review Request 
    public static void collaboratorAcknowledgementForDRC(Id collaboratorId){
         Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        
        Set<Id> custIds = DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
         String drbGrp = collaborator.DRB_Group_uIds__c;
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        Set<Id> contactIds = new Set<Id>();
        List<Portal_Tab_Access__c> accessSetup = [SELECT Id,User__c FROM Portal_Tab_Access__c where PTRF__c=true and Account__r.Short_Name__c=:collaborator.Account_Short_Name__c]; 
        for(Portal_Tab_Access__c accessSetupObj:accessSetup ){
            contactIds.add(accessSetupObj.User__c);
        }
        
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dwcAllEmails);
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds); 
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        if(contactIds<>null && !contactIds.isEmpty()){
        toAddresses.addAll(DfmUtilityCls.getEmailIds(contactIds)); 
        }
        //system.debug('dwcAllEmails'+drbGrp);
        if(drbGrp<>null && !Test.isRunningTest()) {
        bccAddresses.addAll(DfmUtilityCls.drbEmailIDs(drbGrp));  
        }
        //system.debug('dwcAllEmails'+drbGrp);  
       // if(!Test.isRunningTest()){
        //bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        
        //system.debug('bccAddresses'+bccAddresses);
       
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        List<Chip__c> chiplist=[select id,Chip_Name__c from Chip__c where Wavier_Collaborator__c=:collaborator.id];
        Transient String subject='Notification: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c+', DRC Waiver Collaboration ';
            
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title:</b> Acknowledgement of DRC Review Request </h3><br><br>'
            
            +'This is to acknowledge your request for DRC Review.  A Collaboration number '   +collaborator.Name+' has been created for your design :<br><br>';
            
            body+= '<table border=1 cellspacing="0" cellpadding="3" >';
            body+='<tr> <th>Prime Die</th> ';
            integer count=0;
            if(chiplist.size()>0) {
           for(Chip__c chipname : chiplist)  {
            if(count<=10){
               body+='<tr> <td>'+chipname.Chip_Name__c +' </td> ';
                    count++;
            } 
            }
            }
           body+='</table> <br/>' ;
            
             body+=' You may visit the following link to check the flow status of your request:<br><br>'                    
            
             +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
             
             +'Access to above links is provided for respective salesforce.com users only. In case you do not have access, please contact your GLOBALFOUNDRIES representative (e.g. Field Application Engineer).'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
          } catch (Exception e) {  GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'collaboratorAcknowledgementForLongFlow()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);   }
    }
    //Email Template for Non Matching rules when rules are inserted into the Collaborator.
    Public static void nonMatchingRulesForDRC(Id collaboratorId){
        Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
         
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        
        //Set<Id> custIds = DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        List<String> toAddresses = new List<String>();
        if(collaborator.Submitted_By_Shortname__c<>null ){
            List<User>  users =[SELECT Id,Name,FederationIdentifier,HCM_Employee_ID__c,HCM_Login_ID__c, Email 
                                FROM User
                                WHERE FederationIdentifier =: collaborator.Submitted_By_Shortname__c
                                OR HCM_Employee_ID__c =: collaborator.Submitted_By_Shortname__c
                                OR HCM_Login_ID__c =: collaborator.Submitted_By_Shortname__c];
            for(User usr : users){
                 toAddresses.add(usr.Email);
            }
        }
        
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
         String drbGrp = collaborator.DRB_Group_uIds__c;
        
        Set<Id> contactIds = new Set<Id>();
        List<Portal_Tab_Access__c> accessSetup = [SELECT Id,User__c FROM Portal_Tab_Access__c where PTRF__c=true and Account__r.Short_Name__c=:collaborator.Account_Short_Name__c]; 
        for(Portal_Tab_Access__c accessSetupObj:accessSetup ){
            contactIds.add(accessSetupObj.User__c);
        }
         Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        //List<String> bccAddresses = DfmUtilityCls.drbEmailIDs(drbGrp);
        List<String> bccAddresses = new List<String>(); 
        //bccAddresses.add('gandhapumohan.charapalli@globalfoundries.com');  
       // List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
         DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
       List<Waiver_Rule_List__c> waiverRuleList = [SELECT Account_Manager_Approver__c,Rule_Type__c,Prime_Die_Name__c,Prime_Die_Comment__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c FROM Waiver_Rule_List__c WHERE Waiver_Collaborator__c  =:collaboratorId and Rule_Type__c =:'' order by LastModifiedDate desc];   
         
        system.debug('waiverRuleList '+waiverRuleList );
        Transient String subject='DRC Service Request Design Waiver Request Non-Match Rules found:  '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c+', DRC Waiver Collaboration ';
            
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title:</b> Non-Match Rules found in PTSR </h3><br>'
            
            +'Rule(s) entered at PTSR DRC Rule Violation section not found in DRC result.<br>'
            +'Please check the PTSR DRC Rule Violation entry.<br><br>'; 
            body+= '<table border=1 cellspacing="0" cellpadding="3" >';
            body+='<tr> <th>Rule Name </th> <th>Prime Die</th> <th> comment </th> <th> Reason for Non-Matching</th><th> Review Status</th> <th> GF Review Comments</th>';
            integer count=0;
            String reasonForNonMatch;
            String reviewComment;
            
            for(Waiver_Rule_List__c rules : waiverRuleList) {
            reviewComment='';
            reasonForNonMatch='';
              if(!Test.isRunningTest() && rules.Prime_Die_Comment__c<>null) { // rules.Prime_Die_Comment__c.split(':', 2);
              integer count1 =0;
               list<string>stList = new list<string>();
               
               stList=rules.Prime_Die_Comment__c.split(':');
               reasonForNonMatch=stList[0];
               reviewComment=rules.Prime_Die_Comment__c.substring(reasonForNonMatch.length());
               reviewComment=reviewComment.removeStart(':'); 
               system.debug('reasonForNonMatch '+reasonForNonMatch +'reviewComment'+reviewComment);
              
               
               }
               
           //reasonForNonMatch =rules.Prime_Die_Comment__c.split(':')[0];
          //if(!Test.isRunningTest() && rules.Prime_Die_Comment__c<>null) reviewComment=rules.Prime_Die_Comment__c.split(':')[1];  
               
                if(count<10){
               body+='<tr> <td>'+rules.Design_Rule_Name__c+' </td> <td>'+rules.Prime_Die_Name__c+'</td>  <td>'+rules.Rule_Description__c+'</td>  <td>'+reasonForNonMatch+'</td> <td>'+rules.Final_Stage__c+'</td><td>'+reviewComment+'</td> ';
                    count++;
            }
            }
        
            body+='</table> <br/>'
                +'Note : Only Top 10 rules will be displayed. To view all rules, please access the URL indicated below.<br><br>'
                +'Access the following URL to login to the Design Waiver Collaborator job:<br>' 
                +waiverCollaboratorURL + collaborator.Id+'<br>'
            
                +'</html>';
                
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
          } catch (Exception e) {  GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'nonMatchingRulesForDRC()', String.valueOf(collaborator.Id), 'DRC email', 'this is error message', 'payLoad','Other SFDC',e, 2300);   }
    }
    
  }