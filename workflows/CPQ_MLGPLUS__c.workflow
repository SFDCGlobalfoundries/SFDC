<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CPQ_MLGPLUS_Datamart_notification</fullName>
        <description>CPQ MLGPLUS Datamart notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>devappa.shenoy@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zia.ahmed@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CPQ_MLGPLUS_Datamart</template>
    </alerts>
    <fieldUpdates>
        <fullName>CPQ_MLGPLUS_RecordType_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CPQ_MLGPLUS_Editable</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPQ_MLGPLUS_RecordType_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CPQ_MLGPLUS_RecordType_Update</fullName>
        <actions>
            <name>CPQ_MLGPLUS_RecordType_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPQ_MLGPLUS__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Maintenance Jobs,Processed,Under Process,Unprocessed</value>
        </criteriaItems>
        <description>CPQ MLGPLUS record will be made editable once status changes to Pending Maintenance Jobs, so that admin team can update the record after running maintenance jobs.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Alert For Datamart data</fullName>
        <actions>
            <name>CPQ_MLGPLUS_Datamart_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPQ_MLGPLUS__c.From_Datamart__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
