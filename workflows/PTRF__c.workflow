<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_To_CRM_PLM_SWIFT_Teams</fullName>
        <ccEmails>swift@globalfoundries.com.preprod</ccEmails>
        <ccEmails>plmsupport@globalfoundries.com.preprod</ccEmails>
        <ccEmails>dl.IT.Salesforce_Support@globalfoundries.com.preprod</ccEmails>
        <description>Send Email To CRM/PLM/SWIFT Teams</description>
        <protected>false</protected>
        <recipients>
            <recipient>rodrigo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/PTRF_Mail_to_CRM_PLM_SWIFT_Teams</template>
    </alerts>
    <fieldUpdates>
        <fullName>PTRF_FU_Update_EXternal_ID</fullName>
        <field>PTRF_External_ID__c</field>
        <formula>Name</formula>
        <name>PTRF FU Update EXternal ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PTRF - Send Email</fullName>
        <actions>
            <name>Send_Email_To_CRM_PLM_SWIFT_Teams</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>PTRF__c.CRMDID_Request__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PTRF__c.Base_CRMDID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PTRF__c.Transaction_Type__c</field>
            <operation>notEqual</operation>
            <value>CANCEL</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PTRF Populate External ID</fullName>
        <actions>
            <name>PTRF_FU_Update_EXternal_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISNEW() ,ischanged( Name ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
