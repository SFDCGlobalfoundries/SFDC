/**
* Author: Bhupesh Mukhija
* Description: This class serves as ManageMembers Controller.
* History:
*     BMukhija     03122013       Code Creation.

**/
public class TeamRoomHelper {

    public static void sendEmailToTeamMembers(List<Id> lTeamMembers, Team_Room__c teamRoom) {
        String[] toAddresses = new List<String>();
        
        // Prepare To Email Addresses.
        if (lTeamMembers != null && !lTeamMembers.isEmpty()) {
            for (User eachUser: [SELECT Email FROM User WHERE Id IN: lTeamMembers]) {
                if (eachUser != null) {
                    toAddresses.add(eachUser.Email);
                }
            }
            
            // Send Mail to Newly added Team Members.
            if (!toAddresses.isEmpty() && !toAddresses.isEmpty()) {            
                Messaging.reserveSingleEmailCapacity(20);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                EmailTemplate emailTemplate = [SELECT Id, DeveloperName, Body, Subject, HtmlValue FROM EmailTemplate 
                                               WHERE IsActive = true AND DeveloperName =: TeamRoomConstants.TEAM_ROOM_TEMPLATE_NAME LIMIT 1];
    
                if (mail != null && emailTemplate != null && teamRoom != null) {
                    List<User> lTeamRoomOwner = [SELECT Id, Name FROM User WHERE Id =: teamRoom.OwnerId];
                    // String bodyText = emailTemplate.HtmlValue;
                    String bodyText = emailTemplate.Body;
                    String subjectText = emailTemplate.Subject;
                    
                    bodyText = bodyText.replace('Merge.TeamRoomName', teamRoom.Name);
                    bodyText = bodyText.replace('Merge.TeamRoomDescription', teamRoom.Team_Room_Description__c);
                    // bodyText = bodyText.replace('Merge.TeamRoomOwner', teamRoom.Owner.Name);
                    string URLTEXT=URL.getSalesforceBaseUrl().toExternalForm();
                   // bodyText = bodyText.replace('Merge.TeamRoomLink', 'https://ap1.salesforce.com/' + teamRoom.Id);
                    bodyText = bodyText.replace('Merge.TeamRoomLink', URLTEXT+ '/' + teamRoom.Id);
                   
                                        
                    if (lTeamRoomOwner != null && !lTeamRoomOwner.isEmpty() && lTeamRoomOwner.get(0).Name != null) {
                        bodyText = bodyText.replace('Merge.TeamRoomOwner', lTeamRoomOwner.get(0).Name);
                    }

                    mail.setTargetObjectId(lTeamMembers.get(0));
                    mail.setToAddresses(toAddresses);
                    mail.setReplyTo(UserInfo.getUserEmail());       
                    mail.setSenderDisplayName(UserInfo.getName());
                    mail.setBccSender(false);
                    mail.setUseSignature(false);
                    mail.saveAsActivity = false;
                    mail.setHtmlBody(bodyText);
                    mail.setSubject(subjectText);
    
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   
                }                
            }
        }
    }
}