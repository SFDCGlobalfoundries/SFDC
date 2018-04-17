<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_to_new_member_on_addition_to_PPE_Team</fullName>
        <description>GMPL/BX009: Email Alert to new member on addition to PPE Team</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Addition_of_PPE_Team_member</template>
    </alerts>
    <fieldUpdates>
        <fullName>PPE_Team_Update_Record_Type_To_Edit</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PPE_Team_Edit</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PPE Team - Update Record Type To Edit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GMPL%2FBX009%3A Email for addition of PPE Team member</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_to_new_member_on_addition_to_PPE_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow sends an email whenever a PPE Team member is added to PPE Team</description>
        <formula>NOT(ISPICKVAL(Access_Level__c, &apos;&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PPE Team - Update Record Type To Edit</fullName>
        <actions>
            <name>PPE_Team_Update_Record_Type_To_Edit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PPE_Team__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PPE Team New</value>
        </criteriaItems>
        <description>This workflow rule will change the record type to &apos;PPE Team Edit&apos; on creation of PPE Team member.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
