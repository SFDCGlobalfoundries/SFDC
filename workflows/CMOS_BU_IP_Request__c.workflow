<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_IP_Request_Owner_that_IP_Project_State_Type_has_changed</fullName>
        <description>Alert IP Request Owner that IP Project State Type has changed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>IP_Management</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMOS_BU_IP_Request/Alert_IP_Requester_IP_Project_Stage_Type_has_Change</template>
    </alerts>
    <alerts>
        <fullName>Alert_IP_Request_Owner_that_Stage_has_changed</fullName>
        <description>Alert IP Request Owner that Stage has changed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>IP_Management</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMOS_BU_IP_Request/IP_Request_Stage_Change_Notification</template>
    </alerts>
    <alerts>
        <fullName>IPRD_Accepted_Notification</fullName>
        <description>IPRD Accepted Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IPRD_Templates/IPRD_Accepted_Template</template>
    </alerts>
    <alerts>
        <fullName>IPRD_Approval_Notification</fullName>
        <description>IPRD Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IPRD_Templates/IPRD_Approval_Template</template>
    </alerts>
    <alerts>
        <fullName>IPRD_Rejection_Notification</fullName>
        <description>IPRD Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IPRD_Templates/IPRD_Rejection_Template</template>
    </alerts>
    <alerts>
        <fullName>IPRD_Submission_Notification</fullName>
        <description>IPRD Submission Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CMOS_BU_IP_Request/IPRD_Submission_Template</template>
    </alerts>
    <alerts>
        <fullName>IP_Request_Approval_Request_Reminder</fullName>
        <description>IP Request Approval - Request Reminder</description>
        <protected>false</protected>
        <recipients>
            <recipient>IP_Management</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CMOS_BU_IP_Request/IP_Request_Approval_Request_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Notify_IP_Management_Team_that_CMOS_IP_Request_is_cancelled</fullName>
        <description>Notify IP Management Team that CMOS IP Request is cancelled</description>
        <protected>false</protected>
        <recipients>
            <recipient>IP_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMOS_BU_IP_Request/Notification_when_CMOS_IP_is_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_To_IPRD_Owner</fullName>
        <description>Send Email To IPRD Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IPRD_Templates/IPRD_Notify_Owner_On_IP_Project_Association</template>
    </alerts>
    <fieldUpdates>
        <fullName>CMOS_BU_IP_Request_has_been_cancelled</fullName>
        <field>Stage__c</field>
        <literalValue>Cancelled</literalValue>
        <name>CMOS BU IP Request  has been cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPRD_Stage_Accepted</fullName>
        <field>Stage__c</field>
        <literalValue>Accepted</literalValue>
        <name>IPRD Stage Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPRD_Stage_Approved</fullName>
        <field>Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>IPRD Stage Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPRD_Stage_Draft</fullName>
        <field>Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>IPRD Stage Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPRD_Stage_Rejected</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>IPRD Stage Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPRD_Stage_Submitted</fullName>
        <field>Stage__c</field>
        <literalValue>Submitted</literalValue>
        <name>IPRD Stage Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Approval_Date</fullName>
        <field>Request_Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>Request Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Submit_Date</fullName>
        <field>Request_Submit_Date__c</field>
        <formula>NOW()</formula>
        <name>Request Submit Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Store_Approve_Date</fullName>
        <field>Request_Approval_Date__c</field>
        <formula>Today()</formula>
        <name>Store Approve Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Alert IP Requester of IP Project Stage Type Changes</fullName>
        <actions>
            <name>Alert_IP_Request_Owner_that_IP_Project_State_Type_has_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( Stage__c ,&quot;Procurement Decision&quot;)&amp;&amp; (ISPICKVAL( IP_Project__r.Stage_Type__c , &quot;ASIC Opportunity&quot;) &amp;&amp; ISPICKVAL( IP_Project__r.Stage_Type__c , &quot;Enabled IP Project&quot;) &amp;&amp; ISPICKVAL( IP_Project__r.Stage_Type__c , &quot;Internal Development Project&quot;) &amp;&amp; ISPICKVAL( IP_Project__r.Stage_Type__c , &quot;Pricing Team - Approved&quot;) &amp;&amp; ISPICKVAL( IP_Project__r.Stage_Type__c , &quot;CapEx Team - Approved&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alert IP Requestor of Status Change</fullName>
        <actions>
            <name>Alert_IP_Request_Owner_that_Stage_has_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CMOS_BU_IP_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Rejected,Accepted,Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CMOS BU IP Request has been cancelled</fullName>
        <actions>
            <name>Alert_IP_Request_Owner_that_Stage_has_changed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CMOS_BU_IP_Request_has_been_cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Not(ISBLANK(Reason_Why_Cancelled__c)), Cancel__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification when CMOS IP is Cancelled</fullName>
        <actions>
            <name>Notify_IP_Management_Team_that_CMOS_IP_Request_is_cancelled</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CMOS_BU_IP_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify IPRD Owner</fullName>
        <actions>
            <name>Send_Email_To_IPRD_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(   NOT(ISBLANK(IP_Project__c)),   ISCHANGED(IP_Project__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reminder for Approval Process</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL(Stage__c, &quot;Submitted&quot;),   ISBLANK(Request_Approval_Date__c), Not(ISBLANK( Request_Submit_Date__c)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>IP_Request_Approval_Request_Reminder</name>
                <type>Alert</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
