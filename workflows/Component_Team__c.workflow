<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WR_Email_Notification_for_adding_a_Componet_Team_Member</fullName>
        <description>WR Email Notification for adding a Componet Team Member</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/WR_Email_Notification_for_Adding_Component_Team_Member</template>
    </alerts>
    <fieldUpdates>
        <fullName>WR_Component_Team_UniqueId_Update</fullName>
        <field>UniqueId__c</field>
        <formula>CASESAFEID( Bug_Work_Request__c )+CASESAFEID( User__c )+ CASESAFEID(PDK_Component__c)</formula>
        <name>WR Component Team UniqueId Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WR Component Team Creation</fullName>
        <actions>
            <name>WR_Email_Notification_for_adding_a_Componet_Team_Member</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WR_Component_Team_UniqueId_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will be used for sending email notification to the user whenever user is added into Component Team. Also, it will update the UniqueId for Component Team and is making sure it does not include same user twice.</description>
        <formula>And( User__c != null, User__c != &apos;&apos;, NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
