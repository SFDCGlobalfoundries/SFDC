<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Release_Task_bug_fix_ready_to_test</fullName>
        <description>Release Task bug fix ready to test</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Release_Task_Bugs</template>
    </alerts>
    <fieldUpdates>
        <fullName>Release_Task_Assign_to_Eric</fullName>
        <field>OwnerId</field>
        <lookupValue>rodrigo@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Release Task - Assign to Eric</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release_Task_Assign_to_Richard</fullName>
        <field>OwnerId</field>
        <lookupValue>rodrigo@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Release Task - Assign to Richard</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email - In Review In Progress</fullName>
        <actions>
            <name>Release_Task_bug_fix_ready_to_test</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Release_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>In Review / In Progress</value>
        </criteriaItems>
        <description>Send an email when the task is ready to test..</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email ready for UAT</fullName>
        <actions>
            <name>Release_Task_bug_fix_ready_to_test</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Release_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>Ready for UAT,Ready for Production,Closed (Working As Designed),Closed (Question Answered),Closed (Verified),Closed (Duplicate),Closed (Not An Issue)</value>
        </criteriaItems>
        <description>Send an email when the task is ready to test..</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Release Task - Assign SFDC Bugs</fullName>
        <actions>
            <name>Release_Task_Assign_to_Richard</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Release_Task__c.Task_Area__c</field>
            <operation>equals</operation>
            <value>Salesforce</value>
        </criteriaItems>
        <criteriaItems>
            <field>Release_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>New (unassigned)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Release Task - Assign Siebel Bugs</fullName>
        <actions>
            <name>Release_Task_Assign_to_Eric</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Release_Task__c.Task_Area__c</field>
            <operation>equals</operation>
            <value>Siebel,AIA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Release_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>New (unassigned)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
