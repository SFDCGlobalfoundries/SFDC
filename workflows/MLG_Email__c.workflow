<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_to_Business_Team_on_new_MLG_file</fullName>
        <description>Notification to Business Team on new MLG+ file</description>
        <protected>false</protected>
        <recipients>
            <recipient>CPQ_MLGPLUS_Business_Users</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notification_to_Business_Team_for_New_MLG</template>
    </alerts>
    <rules>
        <fullName>Notification to Business Team for New MLG%2B</fullName>
        <actions>
            <name>Notification_to_Business_Team_on_new_MLG_file</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPQ_MLGPLUS__c.Status__c</field>
            <operation>equals</operation>
            <value>Unprocessed</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
