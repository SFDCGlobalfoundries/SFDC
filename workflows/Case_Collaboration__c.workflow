<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CC_to_Case_Send_Email</fullName>
        <description>CC to Case Send Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Case_Collaboration_Template_for_Case_Subscription</template>
    </alerts>
    <rules>
        <fullName>CC to Case Add</fullName>
        <actions>
            <name>CC_to_Case_Send_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send the email when a CCtoCase record created.</description>
        <formula>IF( Is_Subscribed__c,TRUE,FALSE )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
