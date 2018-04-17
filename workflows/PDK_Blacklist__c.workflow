<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Fire_an_Email_Alert_to_PDKBlackList_Admin</fullName>
        <description>Fire an Email Alert to PDKBlackList Admin</description>
        <protected>false</protected>
        <recipients>
            <recipient>PDK_BlackList_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PDK_BlackList_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Record_Key_Field</fullName>
        <field>Unique_Record_Key__c</field>
        <formula>Account__c&amp;PDK__c</formula>
        <name>Update Record Key Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PDK Black List Update Record Key</fullName>
        <actions>
            <name>Update_Record_Key_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Account__c !=null &amp;&amp;  PDK__c !=null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rule to Fire When PDK BlackList is modified</fullName>
        <actions>
            <name>Fire_an_Email_Alert_to_PDKBlackList_Admin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
