<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Invitation_for_Meeting_Invitee</fullName>
        <description>Email Invitation for Meeting Invitee</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Notification_Template_for_GF_Meeting_Occurance</template>
    </alerts>
    <rules>
        <fullName>WFEmail Invitation for Meeting Invitee</fullName>
        <actions>
            <name>Email_Invitation_for_Meeting_Invitee</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>VF2:This workflow will send EMail to Meeting Invitees</description>
        <formula>GF_Meeting_Occurrence__r.Name  &lt;&gt; NULL</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
