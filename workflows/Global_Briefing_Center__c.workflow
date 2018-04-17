<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GlobalBriefing_Center_Request_Submission</fullName>
        <description>Global Briefing Center Request Submission</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Santa_Clara_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Global_Briefing_Center/Global_Briefing_Center_Request_Submission</template>
    </alerts>
    <alerts>
        <fullName>Global_Briefing_Center_Request_Approved</fullName>
        <description>Global Briefing Center Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Santa_Clara_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Global_Briefing_Center/Global_Briefing_Center_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Global_Briefing_Center_Request_Rejected</fullName>
        <description>Global Briefing Center Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Santa_Clara_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Global_Briefing_Center/Global_Briefing_Center_Request_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Inform_GBC_Submitter_and_Santa_Clara_Admins_that_the_GBC_has_been_recalled</fullName>
        <description>Inform GBC Submitter and Santa Clara Admins that the GBC has been recalled</description>
        <protected>false</protected>
        <recipients>
            <recipient>Santa_Clara_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Global_Briefing_Center/GBC_has_been_recalled</template>
    </alerts>
    <alerts>
        <fullName>Send_Global_Briefing_Center_Cancellation_Notice</fullName>
        <description>Send Global Briefing Center Cancellation Notice</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Santa_Clara_Admins</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Global_Briefing_Center/Global_Briefing_Center_Request_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>Send_Global_Briefing_Center_Reservation_Notice</fullName>
        <description>Send Global Briefing Center Reservation Notice</description>
        <protected>false</protected>
        <recipients>
            <recipient>Santa_Clara_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Global_Briefing_Center/Global_Briefing_Center_Request_Submission</template>
    </alerts>
    <fieldUpdates>
        <fullName>GBC_Stage_to_New</fullName>
        <description>Used to set the GBC stage back to New if the submission was recalled.</description>
        <field>Stage__c</field>
        <literalValue>New</literalValue>
        <name>GBC Stage to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GBC_Stage_to_Submitted</fullName>
        <description>Set Global Briefing Center Stage to Submitted</description>
        <field>Stage__c</field>
        <literalValue>Submitted</literalValue>
        <name>GBC Stage to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Global_Briefing_Center_Cancelled</fullName>
        <field>Stage__c</field>
        <literalValue>Closed - Cancelled</literalValue>
        <name>Global Briefing Center Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Submission_Time_to_now</fullName>
        <description>Time Stamp the submission time.</description>
        <field>Time_Submitted__c</field>
        <formula>NOW()</formula>
        <name>Set Submission Time to now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sets_Time_Responded</fullName>
        <description>Sets the time when approved or rejected.</description>
        <field>Time_Responded__c</field>
        <formula>NOW()</formula>
        <name>Sets Time Responded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Updated_to_Closed_Approved</fullName>
        <description>Stage updated to Closed-Approved when Approver approves.</description>
        <field>Stage__c</field>
        <literalValue>Closed - Approved</literalValue>
        <name>Stage Updated to Closed-Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Updated_to_Closed_Rejected</fullName>
        <description>Stage updated to Closed-Rejected. It can still be resubmitted.</description>
        <field>Stage__c</field>
        <literalValue>Closed - Rejected</literalValue>
        <name>Stage Updated to Closed-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Global Briefing Center Cancellation</fullName>
        <actions>
            <name>Send_Global_Briefing_Center_Cancellation_Notice</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Global_Briefing_Center_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Global_Briefing_Center__c.Cancel_Reservation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Cancel the Global Briefing Center Reservation. Cancellation can only be performed on Open Reservations</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
