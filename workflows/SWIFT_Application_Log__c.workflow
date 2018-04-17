<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Swift_Email_Exception_Alert</fullName>
        <description>Swift Email Exception Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>swift.support@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SWIFT_Email_Exception_Log_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Invoke_Trigger</fullName>
        <field>Retry_Status__c</field>
        <literalValue>In Queue</literalValue>
        <name>Invoke Trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Swift Email Exception Workflow</fullName>
        <actions>
            <name>Swift_Email_Exception_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SWIFT_Application_Log__c.Trigger_Exception_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Time-based Retry</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SWIFT_Application_Log__c.Is_Auto_Retry__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWIFT_Application_Log__c.Retry_Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Invoke_Trigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>SWIFT_Application_Log__c.Time_Before_Created_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
