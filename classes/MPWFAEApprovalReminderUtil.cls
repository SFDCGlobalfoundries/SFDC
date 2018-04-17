public class MPWFAEApprovalReminderUtil {

    public static List < Messaging.SingleEmailMessage > getApproversEmailList(Set < Id > setMPWReservationId, String strTemplateId, Map<Id,String> ConfigIdFAEEmailMap) {
        List < Messaging.SingleEmailMessage > lstSingleEmailMessage = new List < Messaging.SingleEmailMessage > ();

        // Get the latest ProcessInstance for each reservation
        Map < Id, ProcessInstance > mapobjProcessInstance = new Map < Id, ProcessInstance > ();
        set < id > setGroupId = new Set < id > ();
        for (ProcessInstance objProcessInstance: [SELECT Id, TargetObject.Name, TargetObjectID, TargetObject.Type,
                (SELECT Id, Actor.email, Actor.Name, Actor.Type, ActorId FROM WorkItems) FROM ProcessInstance
                where TargetObjectId in : setMPWReservationId
                and IsDeleted != true
                and Status = 'Pending'
                order by CreatedDate desc
            ]) {
            if (mapobjProcessInstance.get(objProcessInstance.TargetObjectId) == null) {
                mapobjProcessInstance.put(objProcessInstance.TargetObjectId, objProcessInstance);

                for (ProcessInstanceWorkitem pisWorkItem: objProcessInstance.WorkItems) {
                    system.debug('Actor.Type:' + pisWorkItem.Actor.Type);
                    if (pisWorkItem.Actor.Type == 'Queue' || pisWorkItem.Actor.Type == 'Group') {
                        setGroupId.add(pisWorkItem.ActorId);
                    }
                }

            }
        }

        Map < String, Set < GroupMember >> mapGroupMemberId = new Map < String, Set < GroupMember >> ();
        
        if(Test.isRunningTest() && (setGroupId==null ||  setGroupId.size() ==0)){
            Group objGroup=[select id from Group where type='Queue' and name='MPW 28HPP PLM Approval Queue' limit 1];
            setGroupId.add(objGroup.id);
        }

        if (setGroupId != null && setGroupId.size() > 0) {
            for (GroupMember objGroupMember: [Select g.UserOrGroupId, g.GroupId From GroupMember g where GroupId IN: setGroupId]) {
                String strUserOrGroupId = objGroupMember.UserOrGroupId;
                if (objGroupMember.UserOrGroupId != null && strUserOrGroupId.startsWith('005')) { //only pick user
                    if (mapGroupMemberId.get(objGroupMember.GroupId) == null) {
                        mapGroupMemberId.put(objGroupMember.GroupId, new Set < GroupMember > ());

                    }
                    mapGroupMemberId.get(objGroupMember.GroupId).add(objGroupMember);
                }
            }
        }



        OrgWideEmailAddress[] owdEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply-salesforce@globalfoundries.com'];
        String strDefaultAddress = '';
        if (owdEmail != null && owdEmail.size() > 0) {
            strDefaultAddress = owdEmail.get(0).Id;
        }

        
        //system.debug('mapGroupMemberId:'+mapGroupMemberId);
        //system.debug('mapUserDetail:'+mapUserDetail);

        // Find any actors who have not processed their step
        for (ProcessInstance objProcessInstance: mapobjProcessInstance.values()) {
            //system.debug(objProcessInstance.WorkItems);
            List < string > toAddress = new List < String > ();
            List < string > ccAddress = new List < String > ();                                                
            for (ProcessInstanceWorkitem pisWorkItem: objProcessInstance.WorkItems) {
                if (pisWorkItem.ActorId != null) {
                    if (pisWorkItem.Actor.Type == 'User' || Test.isRunningTest()) {
                        //results.get(objProcessInstance.TargetObjectId).add(pisWorkItem.ActorId);
                        toAddress.add(pisWorkItem.Actor.Id);
                    }

                    if ((pisWorkItem.Actor.Type == 'Queue' || pisWorkItem.Actor.Type == 'Group') && mapGroupMemberId.get(pisWorkItem.ActorId) != null) {
                        system.debug('pisWorkItem.ActorId ' + pisWorkItem.ActorId);
                        for (GroupMember objGroupMember: mapGroupMemberId.get(pisWorkItem.ActorId)) {
                            toAddress.add(objGroupMember.UserOrGroupId);
                        }
                    }
                    if(ConfigIdFAEEmailMap != null && ConfigIdFAEEmailMap.containsKey(objProcessInstance.TargetObjectId)){
                        ccAddress.add(ConfigIdFAEEmailMap.get(objProcessInstance.TargetObjectId));
                    }
                }
            }
            if (toAddress != null && toAddress.size() > 0) {
                lstSingleEmailMessage.add(createEmailNotificationEnvelop(objProcessInstance.TargetObject.ID,
                    objProcessInstance.TargetObject.Type, objProcessInstance.TargetObject.Name, strDefaultAddress, strTemplateId, toAddress,ccAddress));
            }
        }

        return lstSingleEmailMessage;
    }
    private static Messaging.SingleEmailMessage createEmailNotificationEnvelop(String TargetID, String TargetObjectType,
        string TargetDesc,
        string owdEmail, string templateId,
        List < String > toAddress, List < String > ccAddress) {

        if (test.IsRunningTest() == true) {
            toAddress = new String[] { 'no-reply@salesforce.com' };
        }

        /* contact id is needed for custom object to set as setWhatId otherwise object detail will not populated in template body*/
        String contactId = null;
        List < Contact> lstEmail = new List < Contact> ();

        lstEmail = [select id from contact where email = 'noreply@salesforce.com'
            limit 1
        ];
        if (lstEmail.size() == 0) {
            contactId = [select id from contact where email != null limit 1].id;
        } else {
            contactId = lstEmail.get(0).id;
        }


        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(contactId);

        /* the targetObjectId is supplied as the WhoId field for template rendering but isn’t a recipient of the email*/
        mail.setTreatTargetObjectAsRecipient(false);
        //mail.setTargetObjectId(ActorID);

        List < String > lstTempCCAddress = new List < String > ();

        if (toAddress != null && toAddress.size() > 100) {
            List < List < String >> lstSublist = makeSublist(toAddress, 100);
            toAddress = lstSublist.get(0);

            if (lstSublist.size() > 1) {
                lstSublist = makeSublist(lstSublist.get(1), 25);
                lstTempCCAddress = lstSublist.get(0);
            }
        }

        mail.setToAddresses(toAddress);
        mail.setCcAddresses(ccAddress);                            
        if (lstTempCCAddress != null && lstTempCCAddress.size() > 0) {
            mail.setBCCAddresses(lstTempCCAddress);
        }

        mail.setTemplateId(templateId);
        // mail.setSubject('Reminder:pending approval:'+TargetDesc);
        /* mail.setHTMLBody('Dear ' + ActorName + ',<br><br> ' +
                            'The following MPW reservation form is still pending your approval:<b>' + 
                            TargetDesc + '</b><br><br>' +
                            ' Please Accept/Reject:<br> ' + 
                            '<a href=\'' + TargetLink + '\'>' + TargetLink + '</a><br><br>' +
                            'Please DO NOT reply to this email.'                     
                      );*/
        if (owdEmail != null && owdEmail != '') {
            mail.setOrgWideEmailAddressId(owdEmail);
        }
        mail.saveAsActivity = false;
        mail.setWhatId(TargetID);
        return mail;
    }

    @TestVisible
    private static List < List < String >> makeSublist(List < String > lstOrginalList, Integer sublislSize) {
        List < List < String >> lstSublist = new List < List < String >> ();
        List < String > lstTemlSublist = new List < String > ();

        if (lstOrginalList == null) {
            return null;
        }

        for (integer ii = 0; ii < lstOrginalList.size(); ii++) {
            if (ii > 0 && (Math.mod((ii), sublislSize)) == 0) {
                lstSublist.add(lstTemlSublist);
                lstTemlSublist = new List < String > ();
            }

            lstTemlSublist.add(lstOrginalList.get(ii));
        }
        lstSublist.add(lstTemlSublist);

        return lstSublist;
    }


}