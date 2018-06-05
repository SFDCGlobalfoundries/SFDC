<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Deployment_Task_Email_to_Admin</fullName>
        <description>Send Deployment Task Email to Admin</description>
        <protected>false</protected>
        <recipients>
            <field>Admin_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deployment_Request_Templates/Deployment_Task_email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Post_Deployment_Review_Task_to_DR_Owner</fullName>
        <description>Send Post Deployment Review Task to DR Owner</description>
        <protected>false</protected>
        <recipients>
            <field>Admin_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deployment_Request_Templates/Post_Deployment_Review_Task_Notification_Template</template>
    </alerts>
    <rules>
        <fullName>Notify Admin to Deploy DR</fullName>
        <actions>
            <name>Send_Deployment_Task_Email_to_Admin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DR_Task__c.Subject__c</field>
            <operation>equals</operation>
            <value>Deployment Task</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify DR owner for Post Deployment Review</fullName>
        <actions>
            <name>Send_Post_Deployment_Review_Task_to_DR_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DR_Task__c.Subject__c</field>
            <operation>equals</operation>
            <value>Post Deployment Review</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
