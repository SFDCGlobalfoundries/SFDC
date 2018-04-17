<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CuSRImplementationSendNotificationtoAssignee</fullName>
        <description>CuSRImplementationSend NotificationtoAssignee</description>
        <protected>false</protected>
        <recipients>
            <field>Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CuSRImplementation_Send_Notification_to_Assignee_Template</template>
    </alerts>
    <rules>
        <fullName>CuSRImplementationSendNotificationtoAssignee</fullName>
        <actions>
            <name>CuSRImplementationSendNotificationtoAssignee</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CuSR_Implementation__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>GF Integration</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
