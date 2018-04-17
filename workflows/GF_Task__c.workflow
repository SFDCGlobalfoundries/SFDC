<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_notification_to_Externaluser_assgined</fullName>
        <description>Email_notification_to_Externaluser_assgined</description>
        <protected>false</protected>
        <recipients>
            <field>assignTo__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Notification_Template_for_assigning_task_to_external_user</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_user_assgined</fullName>
        <description>Email notification to user assgined</description>
        <protected>false</protected>
        <recipients>
            <field>assignTo__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Notification_Template_for_assigning_task</template>
    </alerts>
    <fieldUpdates>
        <fullName>GF_FieldUpdate_After_DueDate</fullName>
        <description>FV2:Task Status value will be automatically updated to ‘Overdue’ through Time Trigger when due date is reached.</description>
        <field>Status__c</field>
        <literalValue>Overdue</literalValue>
        <name>GF_FieldUpdate_After_DueDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GF_FieldUpdate_Before_DueDate</fullName>
        <description>FV2:Task Status value will be automatically updated to ‘In Progress’.</description>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>GF_FieldUpdate_Before_DueDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>GF_Task_Assignment_MailNotification</fullName>
        <actions>
            <name>Email_notification_to_user_assgined</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>FV2:When a task record will be created with ‘Send Notification Email’ as checked a mail will be sent to the user who is assigned.</description>
        <formula>send_email__c =True &amp;&amp; ISPICKVAL(assignTo__r.UserType,&apos;Standard&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GF_Task_Assignment_MailNotification_to_ExternalUser</fullName>
        <actions>
            <name>Email_notification_to_Externaluser_assgined</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>FV2:When a task record will be created with ‘Send Notification Email’ as checked a mail will be sent to the user who is assigned.</description>
        <formula>send_email__c =True &amp;&amp; NOT(ISPICKVAL(assignTo__r.UserType,&apos;Standard&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GF_Task_Set_Status_After_DueDate</fullName>
        <active>true</active>
        <criteriaItems>
            <field>GF_Task__c.send_email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>FV2:Task Status value will be automatically updated to ‘Overdue’ through Time Trigger when due date is reached.</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GF_FieldUpdate_After_DueDate</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>GF_Task__c.Due_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GF_Task_Set_Status_Before_DueDate</fullName>
        <actions>
            <name>GF_FieldUpdate_Before_DueDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GF_Task__c.send_email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>FV2:When a GF Task record will be created with future due date, then the Task Status value will be automatically updated to ‘In Progress’</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
