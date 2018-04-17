<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Opportunity_Survey_Result</fullName>
        <description>Opportunity Survey Result</description>
        <protected>false</protected>
        <recipients>
            <recipient>Opportunity_Survey_Result_Subscriber</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Email_Templates/Opportunity_Survey_Result</template>
    </alerts>
    <rules>
        <fullName>Opportunity Survey Result</fullName>
        <actions>
            <name>Opportunity_Survey_Result</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Email notification with Survey Result to Opportunity Survey Public Groups.</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
