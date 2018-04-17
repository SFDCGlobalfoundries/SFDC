<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WR_Notification_for_adding_as_CClist_user</fullName>
        <description>WR Notification for adding as CClist user</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/WR_Email_Notification_for_Adding_CC_List</template>
    </alerts>
    <fieldUpdates>
        <fullName>WR_CCList_UniqueId_Update</fullName>
        <field>UniqueId__c</field>
        <formula>CASESAFEID( Bug_Work_Request__c )+CASESAFEID( User__c )</formula>
        <name>WR CCList UniqueId Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WR CC List%5CContributor Creation</fullName>
        <actions>
            <name>WR_Notification_for_adding_as_CClist_user</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WR_CCList_UniqueId_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will send an email notification to the user whenever the user will be added as a CClist user. Also it will update the UniqueId for CC List and is making sure it does not include same user twice.</description>
        <formula>And(  User__c != null, User__c != &apos;&apos;, NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
