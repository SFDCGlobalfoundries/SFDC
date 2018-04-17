<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_for_OOO</fullName>
        <description>Email Notification for OOO</description>
        <protected>false</protected>
        <recipients>
            <field>Delegate_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Out_Of_Office/Out_Of_Office_Email_Notification</template>
    </alerts>
    <rules>
        <fullName>Out Of Office Email Notification</fullName>
        <actions>
            <name>Email_Notification_for_OOO</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Out_Of_Office__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Email Notification for Out Of Office Creation and updation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
