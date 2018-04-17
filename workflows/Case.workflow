<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_to_Case_Owner_Manager</fullName>
        <description>Alert to Case Owner Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Escalation_to_Case_Owner_Manager</template>
    </alerts>
    <alerts>
        <fullName>CC_to_Case_Email_Notification_on_Case_Status_Change</fullName>
        <description>CC to Case Email Notification on Case Status Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Collaborator (External)</recipient>
            <type>caseTeam</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Case_Collaboration_Template_for_Case_Status_change</template>
    </alerts>
    <alerts>
        <fullName>Case_Close_Notification</fullName>
        <description>Case Close Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Email_Notification_for_Case_Closure</template>
    </alerts>
    <alerts>
        <fullName>Case_Closed_Feedback_Survey_for_Customer_Cases</fullName>
        <description>Case Closed Feedback Survey for Customer Cases</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Customer_Survey_for_Closed_Case</template>
    </alerts>
    <alerts>
        <fullName>Case_Comments_Notification</fullName>
        <description>Case Comments Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Collaborator (External)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Case_Comments_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Created_for_Owner_Notification_for_Portal_Users</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Case Created for Owner Notification for Portal Users</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>CaseOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Email_Notification_for_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Case_Creation_Email_Notification_for_ASIC_Cases</fullName>
        <description>Case Creation Email Notification for ASIC Cases</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASIC_Public_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Creation_Notification_for_ASIC_Support_Case</template>
    </alerts>
    <alerts>
        <fullName>Case_Creation_Notification_for_Internal_Case</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Case Creation Notification for Internal_Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Creation_Notification_for_Internal_Case</template>
    </alerts>
    <alerts>
        <fullName>Case_Email_Notification_for_Duplicate_Case</fullName>
        <description>Case Email Notification for Duplicate Case</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Case_Duplicate_Email_to_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Email_Notification_for_change_in_ASIC_Support</fullName>
        <description>Case Email Notification for change in ASIC Support</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Modification_Notification_for_ASIC_Support_Case</template>
    </alerts>
    <alerts>
        <fullName>Case_Ok_to_Close_Request</fullName>
        <description>Case Ok to Close Request</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Customer_Case_Ok_to_Close_Request</template>
    </alerts>
    <alerts>
        <fullName>Case_Ownership_Change_Notification_Email</fullName>
        <description>Case Ownership Change Notification Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Case_Ownership_Change_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Case_Ownership_Change_Notification_Email_for_Internal</fullName>
        <description>Case Ownership Change Notification Email for Internal</description>
        <protected>false</protected>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Ownership_Change_Notification_Email_for_Internal</template>
    </alerts>
    <alerts>
        <fullName>Case_Ownership_Change_Notification_Email_for_group_members</fullName>
        <description>Case Ownership Change Notification Email for group members</description>
        <protected>false</protected>
        <recipients>
            <recipient>L3_DE_QA</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Ownership_Change_Notification_Email_for_Group</template>
    </alerts>
    <alerts>
        <fullName>Case_Status_Changed_Alert</fullName>
        <description>Case Status Changed Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Email_Notification_for_Case_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>Case_Status_Changed_Alert_Acknowledge</fullName>
        <description>Case Status Changed Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Email_Notification_for_Case_Status_Changed_to_Acknowledged</template>
    </alerts>
    <alerts>
        <fullName>Case_Sub_Status_is_in_Pending_Implementation</fullName>
        <description>Case Sub Status is in Pending Implementation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Case_Sub_Status_is_in_Pending_Implementation</template>
    </alerts>
    <alerts>
        <fullName>Case_notification_to_CPQ_Team</fullName>
        <description>Case notification to CPQ Team</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Ownership_Change_Notification_Email_for_Internal</template>
    </alerts>
    <alerts>
        <fullName>Case_status_is_in_Acknowledged_In_Queue_status</fullName>
        <description>Case status is in Acknowledged In Queue status</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Status_Acknowledged_in_Queue_or_Reassigned</template>
    </alerts>
    <alerts>
        <fullName>Case_status_is_in_Reassigned_status</fullName>
        <description>Case status is in Reassigned status</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Status_Acknowledged_in_Queue_or_Reassigned</template>
    </alerts>
    <alerts>
        <fullName>Customer_Case_Re_open_Email_Alert</fullName>
        <description>Customer Case Re-open Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Customer_Case_Re_Opened</template>
    </alerts>
    <alerts>
        <fullName>Customer_Case_Re_open_Request_Accepted_Email_Alert</fullName>
        <description>Customer Case Re-open Request Accepted Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Customer_Case_Re_Open_Request_Accepted</template>
    </alerts>
    <alerts>
        <fullName>Customer_Case_Re_open_Request_Rejected_Email_Alert</fullName>
        <description>Customer Case Re-open Request Rejected Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Customer_Case_Re_Open_Request_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Customer_Case_Status_Change_Reminder</fullName>
        <description>Customer Case Status Change Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Case_Status_change_Alert_to_avoid_escalation</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_for_change_in_case_priority</fullName>
        <description>Email Notification for change in case priority</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Email_Notification_for_change_in_case_priority</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_Case_Owner</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Email notification to Case Owner</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Email_Notification_for_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Internal_Case_Closed_Notification</fullName>
        <description>Internal Case Closed Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Close_Template_for_Internal_Case</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Owner_of_New_Case_Comments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Case Owner of New Case Comments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_New_Comment_Notification_New_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Owner_of_New_Case_FeedComments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Case Owner of New Case FeedComments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Case_FeedComment</template>
    </alerts>
    <alerts>
        <fullName>Notify_Creator_for_New_Case_Attachments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Manager-Owner-Creator Attachments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Creator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Public_Case_Attachments</template>
    </alerts>
    <alerts>
        <fullName>Notify_Creator_for_New_Case_Comments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Manager-Owner-Creator Comments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Creator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Public_Case_Comments</template>
    </alerts>
    <alerts>
        <fullName>Notify_Portal_Users_for_New_Public_Case_Attachments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Manager-Owner-Creator-Contact-Collaborator Attachments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Collaborator (External)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Creator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Portal_Users_for_New_Public_Case_Attachments</template>
    </alerts>
    <alerts>
        <fullName>Notify_Portal_Users_for_New_Public_Case_Comments</fullName>
        <ccEmails>casecustomerresponse@n835qz7njzyctgvlw7zbmmbzc4yvwuoilg8sg9i916e7ato57.n-e3nrmak.cs6.apex.sandbox.salesforce.com</ccEmails>
        <description>Notify Manager-Owner-Creator-Contact-Collaborator Comments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Collaborator (External)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Creator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Creator (External)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Public_Case_Comments</template>
    </alerts>
    <alerts>
        <fullName>Notify_Users_for_New_Case_Feed_Comments_Status_Awaiting_Customer_Response</fullName>
        <description>Notify Users for New Case Feed Comments -Status(Awaiting Customer Response)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Notify_Users_for_Status_Awaiting_Customer_Response</template>
    </alerts>
    <alerts>
        <fullName>Notify_Users_for_New_Private_Case_FeedComment_Attachments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Users for New Private Case FeedComment Attachments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Creator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Case_FeedComment_Attachments</template>
    </alerts>
    <alerts>
        <fullName>Notify_Users_for_New_Private_Case_FeedComment_Attachments_Created_By_Customer</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Users for New Private Case FeedComment Attachments - Created By Customer</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Case_FeedComment_Attachments</template>
    </alerts>
    <alerts>
        <fullName>Notify_Users_for_New_Private_Case_Feed_Comments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Users for New Private Case Feed Comments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Creator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Case_FeedComment</template>
    </alerts>
    <alerts>
        <fullName>Notify_Users_for_New_Private_Case_Feed_Comments_Created_By_Customer</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Users for New Private Case Feed Comments - Created By Customer</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Case_FeedComment</template>
    </alerts>
    <alerts>
        <fullName>Notify_Users_for_New_Public_Case_Attachments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Manager-Owner Attachments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Public_Case_Attachments</template>
    </alerts>
    <alerts>
        <fullName>Notify_Users_for_New_Public_Case_Comments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Manager-Owner Comments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Portal_Users_for_New_Public_Case_Comments</template>
    </alerts>
    <alerts>
        <fullName>Notify_Users_for_New_Public_Case_FeedComment_Attachments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Users for New Public Case FeedComment Attachments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Collaborator (External)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Creator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Case_FeedComment_Public_Attachments</template>
    </alerts>
    <alerts>
        <fullName>Notify_Users_for_New_Public_Case_Feed_Comments</fullName>
        <ccEmails>casecustomerresponse@x8z5wa2r9xw9f5huq6yrmq7x5cfzf2gbjv60nwjzdoeimpucv.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Notify Users for New Public Case Feed Comments</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Collaborator (External)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Creator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Stakeholder (internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Notify_Users_for_New_Case_FeedComment</template>
    </alerts>
    <alerts>
        <fullName>Reminder1_to_Case_Owner</fullName>
        <description>Reminder1 to Case Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Case_Expected_Closed_Date_Alert</template>
    </alerts>
    <alerts>
        <fullName>Reminder2_to_Case_Owner</fullName>
        <description>Reminder2 to Case Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Case_Expected_Closed_Date_Alert</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Survey_external</fullName>
        <description>Send Email Survey - External</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Creator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/External_Support_Survey</template>
    </alerts>
    <fieldUpdates>
        <fullName>CalculateHoursNotInPendingPDKStatus</fullName>
        <description>This is to calculate case age except when case status is Resolved - Pending PDK release</description>
        <field>MinutesNotInWaitStatus__c</field>
        <formula>IF( Not(CONTAINS($Label.Case_Status_Not_Include_In_Age_Calculation,Text(PRIORVALUE(Status)))), IF(IsClosed=false,BLANKVALUE(MinutesNotInWaitStatus__c,0) + ((Now() - PRIORVALUE(LastStatusChangeTime__c))*1440), BLANKVALUE(MinutesNotInWaitStatus__c,0) + ((ClosedDate - PRIORVALUE(LastStatusChangeTime__c))*1440) ),BLANKVALUE(MinutesNotInWaitStatus__c,0) )</formula>
        <name>CalculateHoursNotInPendingPDKStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CaseStatusUpdate</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>CaseStatusUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_ASIC_Update_Internal_Use_Only</fullName>
        <field>Internal_or_external__c</field>
        <literalValue>0</literalValue>
        <name>Case ASIC Update Internal Use Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Actual_Approver</fullName>
        <description>This Field Update is used to get the User who actually Approved the Case Re-Open Request .</description>
        <field>Actual_Approver__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Case Actual Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Actual_Rejected_By</fullName>
        <description>This Field Update is used to get the User who actually Rejected the Case Re-Open Request .</description>
        <field>Actual_Approver__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Case Actual Rejected By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Close_Resolved</fullName>
        <description>Close case if &quot;Waiting on Requestor&quot; for more than 14 days</description>
        <field>Status</field>
        <literalValue>Closed - Resolved</literalValue>
        <name>Case - Close Resolved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Creation_Owner_Change_for_ASIC_Case</fullName>
        <field>OwnerId</field>
        <lookupValue>ASIC_Queue_Group</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Creation Owner Change for ASIC Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_Manager</fullName>
        <field>Case_Owner_Manager_Email__c</field>
        <formula>IF(Owner:User.Manager.IsActive,Owner:User.Manager.Email,&apos;&apos;)</formula>
        <name>Case Owner Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Ownership_Transfer_Count</fullName>
        <description>This Field Update will update the Ownership_Transfer_Count__c to store value no of time  ownership transferred.</description>
        <field>Ownership_Transfer_Count__c</field>
        <formula>IF(ISNULL(PRIORVALUE(Ownership_Transfer_Count__c)), 0, PRIORVALUE(Ownership_Transfer_Count__c) )+1</formula>
        <name>Case Ownership Transfer Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Re_Open_Count</fullName>
        <field>Re_Open_Count__c</field>
        <formula>IF(ISNULL(PRIORVALUE(Re_Open_Count__c)), 0, PRIORVALUE(Re_Open_Count__c) )+1</formula>
        <name>Case Re-Open Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reopen_Request_Accepted</fullName>
        <field>Reopen_Request_Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>Case Reopen Request Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reopen_Request_Rejected</fullName>
        <field>Reopen_Request_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Case Reopen Request Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reopen_Status_Update</fullName>
        <field>Status</field>
        <literalValue>Reopen</literalValue>
        <name>Case Reopen Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Update_PDK_Version</fullName>
        <description>This workflow will populate PDK Version when PDK Bundle is not blank</description>
        <field>PDK_VERSION__c</field>
        <formula>PDK_Bundle__r.Sub_PDK_Version__c</formula>
        <name>Case Update PDK Version</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Update_Specification_Revision</fullName>
        <description>This workflow will populate Specification Revision when Specification is not blank</description>
        <field>Specification_Revision__c</field>
        <formula>Specification__r.Revision__c</formula>
        <name>Case Update Specification Revision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_isReopenBySurvey_Field_Update_Close</fullName>
        <description>This Field Update will update the Field Update check box to false when Case is Closed.</description>
        <field>isReopenBySurvey__c</field>
        <literalValue>0</literalValue>
        <name>Case isReopenBySurvey Field Update Close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Portal_Cases_IsNew</fullName>
        <description>Customer Portal Cases  IsNew field update.</description>
        <field>IsNew__c</field>
        <literalValue>1</literalValue>
        <name>Customer Portal Cases IsNew</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DefaultValueForMinutesNotInWaitStatus</fullName>
        <description>This is to default value to 0 for field MinutesNotInWaitStatus</description>
        <field>MinutesNotInWaitStatus__c</field>
        <formula>BLANKVALUE(MinutesNotInWaitStatus__c,0)</formula>
        <name>DefaultValueForMinutesNotInWaitStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateLastStatusChangeDate</fullName>
        <description>This is to update LastStatusChangeDate/Time field to track when status is changed.</description>
        <field>LastStatusChangeTime__c</field>
        <formula>NOW()</formula>
        <name>UpdateLastStatusChangeDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CC to Case Email Notification on Case Status Change</fullName>
        <actions>
            <name>CC_to_Case_Email_Notification_on_Case_Status_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the email when a Case Status changes to the CCtoCase users.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( Status), NOT(IsClosed), Case_Record_Type_API__c = &apos;External_System&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case ASIC Update Internal Use Only To False</fullName>
        <actions>
            <name>Case_ASIC_Update_Internal_Use_Only</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),Case_Record_Type_API__c = &apos;ASIC_Support&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Close after 14 day waiting</fullName>
        <active>false</active>
        <description>Close the case after 14 days with the status &quot;Waiting on Requestor&quot;</description>
        <formula>AND(  NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), ISPICKVAL(Status,&apos;Waiting on Requestor&apos;), Case_Record_Type_API__c = &apos;Internal_Case&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Close_Resolved</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Closed</fullName>
        <actions>
            <name>Case_Closed_Feedback_Survey_for_Customer_Cases</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Internal_Case_Closed_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the email when a case is closed with Latest comment and Survey.</description>
        <formula>AND(  NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), (IsClosed),NOT( DuplicateEmailtoCase__c ), Case_Record_Type_API__c = &apos;Internal_Case&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Closed Survey for Customer</fullName>
        <actions>
            <name>Case_Closed_Feedback_Survey_for_Customer_Cases</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the  Feedback Survey for Customer when a case is closed.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( Status),  (IsClosed), ( Send_Customer_Survey__c ), Case_Record_Type_API__c = &apos;External_System&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Comments Notification</fullName>
        <actions>
            <name>Case_Comments_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the email when a case is closed with all public comments..</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( Status),  (IsClosed),  OR(      Case_Record_Type_API__c = &apos;Logistics&apos;,      Case_Record_Type_API__c = &apos;External_System&apos;,      Case_Record_Type_API__c = &apos;TechnicalPDK&apos;,Case_Record_Type_API__c=&apos;ASIC_Support&apos; )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Created for Owner Notification</fullName>
        <actions>
            <name>Email_notification_to_Case_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the email when a case is created by Standard users.</description>
        <formula>AND(  NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  UserLicense__c ==&apos;Standard&apos;, OR( Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos; ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Created for Owner Notification for Portal Users</fullName>
        <actions>
            <name>Case_Created_for_Owner_Notification_for_Portal_Users</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the email when a case is created by Portal users.</description>
        <formula>AND(  NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  UserLicense__c !=&apos;Standard&apos;, OR( Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos; ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Creation Notification for ASIC Support Case</fullName>
        <actions>
            <name>Case_Creation_Email_Notification_for_ASIC_Cases</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_Creation_Owner_Change_for_ASIC_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Case_Record_Type_API__c</field>
            <operation>equals</operation>
            <value>ASIC_Support</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Creation Notification for Internal_Case</fullName>
        <actions>
            <name>Case_Creation_Notification_for_Internal_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the email when a case is Created in Internal_Case.</description>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  NOT(IsClosed), Case_Record_Type_API__c = &apos;Internal_Case&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Customer Portal Cases</fullName>
        <actions>
            <name>Customer_Portal_Cases_IsNew</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow will update the IsNew field which is used for Custom Case Assignment Process execution.</description>
        <formula>IF( AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  OR(AND(IsAssignmentProcess__c=true, ISPICKVAL(Status,&apos;New&apos;), IsClosed=false, isAssignment__c=false),ISCHANGED(AccountId)), 	OR(Case_Record_Type_API__c = &apos;Logistics&apos;,Case_Record_Type_API__c = &apos;External_System&apos;,Case_Record_Type_API__c = &apos;TechnicalPDK&apos;) 	) ,true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Email Notification for Duplicate Case</fullName>
        <actions>
            <name>Case_Email_Notification_for_Duplicate_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Duplicate case will be updated as “Closed – Duplicate” and an email will be sent to the Case Requestor and providing a link back to the original case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  (DuplicateEmailtoCase__c) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Email Notification for change in ASIC Support</fullName>
        <actions>
            <name>Case_Email_Notification_for_change_in_ASIC_Support</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>This workflow will send the email when a case is updated in ASIC Support.</description>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),ISCHANGED( LastModifiedDate),Case_Record_Type_API__c = &apos;ASIC_Support&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Email Notification for change in case priority</fullName>
        <actions>
            <name>Email_Notification_for_change_in_case_priority</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the email when a Case priority changes.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( Priority_stakeholder_Priority__c), OR( ISPICKVAL(Priority_stakeholder_Priority__c, &quot;High&quot;), ISPICKVAL(Priority_stakeholder_Priority__c, &quot;Medium&quot;), ISPICKVAL(Priority_stakeholder_Priority__c, &quot;Low&quot;) ), Case_Record_Type_API__c  = &apos;External_System&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Notification To CPQ Team</fullName>
        <actions>
            <name>Case_notification_to_CPQ_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>startsWith</operation>
            <value>Configuration Error</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Ok to Close Request</fullName>
        <actions>
            <name>Case_Ok_to_Close_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If the submitter &lt;&gt; case requestor then only send the notification asking the case owner to close.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  (CreatedById  &lt;&gt;  $User.Id), NOT(ISBLANK(Close_Requested_Date__c )), ISCHANGED(Close_Requested_Date__c ),  OR( Case_Record_Type_API__c  = &apos;Logistics&apos;, Case_Record_Type_API__c  = &apos;External_System&apos;, Case_Record_Type_API__c  = &apos;TechnicalPDK&apos; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Owner Manager Update</fullName>
        <actions>
            <name>Case_Owner_Manager</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update manager email field with case owner manager&apos;s email</description>
        <formula>AND(  NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  NOT(ISBLANK(OwnerId)),  OR(isChanged(OwnerId), ISNEW() ) ,  OR(  Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Ownership Change Notification</fullName>
        <actions>
            <name>Case_Ownership_Change_Notification_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This is used to Send email notification to the case owner.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( OwnerId),   OR( Case_Record_Type_API__c = &apos;Logistics&apos;,      Case_Record_Type_API__c = &apos;External_System&apos;,      Case_Record_Type_API__c = &apos;TechnicalPDK&apos; ),GroupOwner__c = false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Ownership Change Notification Email for Group</fullName>
        <actions>
            <name>Case_Ownership_Change_Notification_Email_for_group_members</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case Ownership Change Notification Email for group members</description>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),GroupOwner__c = true,OR(isChanged(OwnerId),ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Ownership Change Notification for Internal Case</fullName>
        <actions>
            <name>Case_Ownership_Change_Notification_Email_for_Internal</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This is used to Send email notification to the case owner.</description>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), ISCHANGED( OwnerId),GroupOwner__c == false,Case_Record_Type_API__c = &apos;Internal_Case&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Ownership Transfer Count</fullName>
        <actions>
            <name>Case_Ownership_Transfer_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow will update the Ownership_Transfer_Count__c field which is used for Counting no of time ownership transferred.</description>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),ISCHANGED(OwnerId))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Re-Open Count</fullName>
        <actions>
            <name>Case_Re_Open_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow will update the Re_Open_Count__c field which is used for Counting no of time Case reopened.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), IsClosed=false,PRIORVALUE(IsClosed)=True )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Status Acknowledged in Queue</fullName>
        <active>true</active>
        <description>This workflow rule will send a reminder if case is in Acknowledged in Queue state for more than 3 days.</description>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISPICKVAL(Status,&apos;Acknowledged-In Queue&apos;), NOT(IsClosed),Case_Record_Type_API__c = &apos;External_System&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_status_is_in_Acknowledged_In_Queue_status</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Status Change Reminder</fullName>
        <active>true</active>
        <description>This workflow rule will send a reminder if case is in New state for more than 24 hours .</description>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISPICKVAL(Status,&apos;New&apos;), NOT(IsClosed), Case_Record_Type_API__c = &apos;External_System&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Customer_Case_Status_Change_Reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Status Changed to Acknowledge</fullName>
        <actions>
            <name>Case_Status_Changed_Alert_Acknowledge</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the email when a Case status changes to Acknowledged-In Queue.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISPICKVAL(Status,&apos;Acknowledged-In Queue&apos;), NOT(IsClosed),Case_Record_Type_API__c = &apos;External_System&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Status Changed to In progress</fullName>
        <actions>
            <name>Case_Status_Changed_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the email when a Case status changes to In Progress.</description>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISPICKVAL(Status,&apos;In Progress&apos;),Case_Record_Type_API__c = &apos;External_System&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Status Reassigned</fullName>
        <active>true</active>
        <description>This workflow rule will send a reminder if case is in Acknowledged in Queue state for more than 3 days.</description>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISPICKVAL(Status,&apos;Reassigned&apos;), NOT(IsClosed), OR( Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_status_is_in_Reassigned_status</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Status Update to InProgress</fullName>
        <actions>
            <name>CaseStatusUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),NOT(ISNEW()),  Ownership_Transfer_Count__c  &gt; 0, ISBLANK(OwnerQueueName__c), NOT(ISCHANGED(OwnerId)),NOT(ISCHANGED(	Support_Level__c)),OR(ISPICKVAL(Status,&apos;Acknowledged-In Queue&apos;),ISPICKVAL(Status,&apos;Reassigned&apos;)), NOT(IsClosed), OR( Case_Record_Type_API__c = &apos;Logistics&apos;,Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos; ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Sub Status Pending Implementation</fullName>
        <active>true</active>
        <description>This workflow rule will send a reminder if case is in sub status &quot;Pending Implementation&quot; one day in advanced of target date.</description>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), NOT(ISNULL(Target_Release_Date__c)),  NOT(IsClosed))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Sub_Status_is_in_Pending_Implementation</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Target_Release_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Update PDK Version</fullName>
        <actions>
            <name>Case_Update_PDK_Version</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will populate PDK Version when PDK Bundle is not blank</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  NOT(ISBLANK(PDK_Bundle__c )), ISBLANK(PDK_VERSION__c), OR(isChanged(PDK_Bundle__c), ISNEW() ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Update Specification Revision</fullName>
        <actions>
            <name>Case_Update_Specification_Revision</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will populate Specification Revision  when Specification is not blank</description>
        <formula>AND(  NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), NOT( ISBLANK(Specification__c )), ISBLANK(Specification_Revision__c), OR(isChanged(Specification__c), ISNEW() ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CaseCalculateAgeofCase</fullName>
        <actions>
            <name>CalculateHoursNotInPendingPDKStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DefaultValueForMinutesNotInWaitStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateLastStatusChangeDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is to calculate Age of Case except when case is in status &apos;Resolved - Pending PDK release&apos;</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), OR( ISNEW(), ISCHANGED( Status ) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Case Re-Opened</fullName>
        <actions>
            <name>Customer_Case_Re_open_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send an Email Alert to the Case Owner and Case Manager with all the Details about the Re Opened Case .</description>
        <formula>AND(  NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( Status ), ISPICKVAL(Status , &apos;Reopen&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Case Owner of New Case Comments</fullName>
        <actions>
            <name>Notify_Case_Owner_of_New_Case_Comments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Use this workflow rule to notify case owner when a comment is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( LastCaseCommentId__c ), Case_Record_Type_API__c = &apos;Internal_Case&apos; ,  PRIORVALUE(IsClosed)  =  IsClosed)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Case Owner of New Case FeedComments</fullName>
        <actions>
            <name>Notify_Case_Owner_of_New_Case_FeedComments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Use this workflow rule to notify case owner when a Feed comment is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), ISCHANGED( LastCaseFeedCommentId__c ),  Case_Record_Type_API__c = &apos;Internal_Case&apos; , PRIORVALUE(IsClosed) = IsClosed)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Owner to Check Expected Closed Date</fullName>
        <active>true</active>
        <description>This is to remind user to change or close case as per Expected closed date value.</description>
        <formula>AND(  NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  NOT(OR(ISPICKVAL(Status,&apos;Resolved - Pending PDK release&apos;),ISPICKVAL(Status,&apos;Awaiting customer response&apos;))), NOT(IsClosed),  OR(  Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;  ) ,  NOT(ISBLANK(Expected_Close_Date__c))  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder1_to_Case_Owner</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Expected_Close_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder2_to_Case_Owner</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Expected_Close_Date__c</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Alert_to_Case_Owner_Manager</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Expected_Close_Date__c</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Notify Users for New Case Feed Comments -Status%28Awaiting Customer Response%29</fullName>
        <actions>
            <name>Notify_Users_for_New_Case_Feed_Comments_Status_Awaiting_Customer_Response</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),OR(ISCHANGED( LastCaseFeedCommentId__c),ISCHANGED( LastCaseCommentId__c )),ISPICKVAL(Status,&apos;Awaiting customer response&apos;),OR( Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Private Case Attachments</fullName>
        <actions>
            <name>Notify_Creator_for_New_Case_Attachments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Creator and Owner when a private Attachments is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED(  Last_Attachment_Id__c ), UserLicense__c =&apos;Standard&apos;, Last_Attachment_IsPrivate__c  =true,OR( Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;,Case_Record_Type_API__c=&apos;ASIC_Support&apos; ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Private Case Attachments - Created By Customer</fullName>
        <actions>
            <name>Notify_Users_for_New_Public_Case_Attachments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Creator and Owner when a private Attachments is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED(  Last_Attachment_Id__c ), UserLicense__c !=&apos;Standard&apos;, Last_Attachment_IsPrivate__c  =true,OR( Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;,Case_Record_Type_API__c=&apos;ASIC_Support&apos; ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Private Case Comments</fullName>
        <actions>
            <name>Notify_Creator_for_New_Case_Comments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Creator and Owner when a Private comment is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( LastCaseCommentId__c ), UserLicense__c =&apos;Standard&apos;, Last_Comment_IsPublished__c =false, OR(   Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;,Case_Record_Type_API__c=&apos;ASIC_Support&apos; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Private Case Comments - Created By Customer</fullName>
        <actions>
            <name>Notify_Users_for_New_Public_Case_Comments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Creator and Owner when a Private comment is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( LastCaseCommentId__c ), UserLicense__c !=&apos;Standard&apos;, Last_Comment_IsPublished__c =false, OR(   Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;,Case_Record_Type_API__c=&apos;ASIC_Support&apos; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Private Case Feed Comments</fullName>
        <actions>
            <name>Notify_Users_for_New_Private_Case_Feed_Comments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Creator and Owner when a Private Feed comment is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( LastCaseFeedCommentId__c ), UserLicense__c =&apos;Standard&apos;, Last_FeedComment_IsPublished__c =false,  OR( Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;,Case_Record_Type_API__c=&apos;ASIC_Support&apos; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Private Case Feed Comments - Created By Customer</fullName>
        <actions>
            <name>Notify_Users_for_New_Private_Case_Feed_Comments_Created_By_Customer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Creator and Owner when a Private Feed comment is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( LastCaseFeedCommentId__c ), UserLicense__c !=&apos;Standard&apos;, Last_FeedComment_IsPublished__c =false,  OR( Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;,Case_Record_Type_API__c=&apos;ASIC_Support&apos; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Private Case FeedComment Attachments</fullName>
        <actions>
            <name>Notify_Users_for_New_Private_Case_FeedComment_Attachments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Creator and Owner when a private FeedComment Attachments is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), ISCHANGED( Last_FeedAttachment_Id__c ),  UserLicense__c =&apos;Standard&apos;, Last_FeedAttachment_IsPrivate__c =true,Case_Record_Type_API__c = &apos;External_System&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Private Case FeedComment Attachments - Created By Customer</fullName>
        <actions>
            <name>Notify_Users_for_New_Private_Case_FeedComment_Attachments_Created_By_Customer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Creator and Owner when a private Feed Comment Attachments is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( Last_FeedAttachment_Id__c ), UserLicense__c !=&apos;Standard&apos;, Last_FeedAttachment_IsPrivate__c =true,Case_Record_Type_API__c = &apos;External_System&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Public Case Attachments</fullName>
        <actions>
            <name>Notify_Portal_Users_for_New_Public_Case_Attachments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Contacts, Creator and Owner when a public Attachments is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), ISCHANGED( Last_Attachment_Id__c ), Last_Attachment_IsPrivate__c =false, OR( Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;,Case_Record_Type_API__c=&apos;ASIC_Support&apos; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Public Case Comments</fullName>
        <actions>
            <name>Notify_Portal_Users_for_New_Public_Case_Comments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Contacts, Creator and Owner when a public comment is added to a case.</description>
        <formula>AND( OR(AND(NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),ISCHANGED( LastCaseCommentId__c),Last_Comment_IsPublished__c =true),AND(Bulk_Update__c=true,ISCHANGED(Bulk_Update__c))), OR( Case_Record_Type_API__c = &apos;External_System&apos;, Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;,Case_Record_Type_API__c=&apos;ASIC_Support&apos; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Public Case Feed Comments</fullName>
        <actions>
            <name>Notify_Users_for_New_Public_Case_Feed_Comments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Contacts, Creator and Owner when a public Feed comment is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), ISCHANGED( LastCaseFeedCommentId__c ), Last_FeedComment_IsPublished__c =true, OR( Case_Record_Type_API__c = &apos;External_System&apos;,  Case_Record_Type_API__c = &apos;Logistics&apos;, Case_Record_Type_API__c = &apos;TechnicalPDK&apos;,Case_Record_Type_API__c=&apos;ASIC_Support&apos; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users for New Public Case FeedComment Attachments</fullName>
        <actions>
            <name>Notify_Users_for_New_Public_Case_FeedComment_Attachments</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule to notify Contacts, Creator and Owner when a public Feed Comment Attachments is added to a case.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED( Last_FeedAttachment_Id__c ), Last_FeedAttachment_IsPrivate__c =false,Case_Record_Type_API__c = &apos;External_System&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
