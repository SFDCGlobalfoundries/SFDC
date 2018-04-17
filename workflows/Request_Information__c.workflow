<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_RFI_Request_Creation_Email_Alert</fullName>
        <description>New RFI Request Creation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Primary_Request_Catcher__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/New_RFI_Request_Creation_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>BnP_RI_Skip_Validation_Field_Update</fullName>
        <field>Skip_Validation__c</field>
        <literalValue>0</literalValue>
        <name>BnP RI Skip Validation Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BnP RI Skip Validation</fullName>
        <actions>
            <name>BnP_RI_Skip_Validation_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request_Information__c.Skip_Validation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New RFI Request Created</fullName>
        <actions>
            <name>New_RFI_Request_Creation_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request_Information__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Request For Information(RFI)</value>
        </criteriaItems>
        <description>New RFI Request Created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
