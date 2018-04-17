<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_to_Business_Team_on_MLG_Error</fullName>
        <description>Notification to Business Team on MLG Error</description>
        <protected>false</protected>
        <recipients>
            <recipient>CPQ_MLGPLUS_Business_Users</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notification_for_MLGPLUS_Error_to_the_Business_Team</template>
    </alerts>
    <rules>
        <fullName>Notification to Business Team on MLG Error</fullName>
        <actions>
            <name>Notification_to_Business_Team_on_MLG_Error</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPQ_MLG_Error_Log__c.Error_Type__c</field>
            <operation>equals</operation>
            <value>Subject Line Error,File Format Error,Attachment Error</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
