<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notifying_the_Administrator</fullName>
        <description>Notifying the Administrator</description>
        <protected>false</protected>
        <recipients>
            <recipient>doug.dreibelbis@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Communicator/Notifying_Administrator</template>
    </alerts>
    <alerts>
        <fullName>Publishing_Alert_News_Internally</fullName>
        <description>Publishing Alert / News Internally</description>
        <protected>false</protected>
        <recipients>
            <recipient>Internal_Users_for_Communicator</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Communicator/Communicator_Email_final</template>
    </alerts>
    <alerts>
        <fullName>Publishing_Alert_News_to_Interested_Group</fullName>
        <description>Publishing Alert / News to Interested Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>Interested_Users_for_Communicator</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Communicator/Communicator_Email_final</template>
    </alerts>
    <fieldUpdates>
        <fullName>Making_the_sent_date_to_null</fullName>
        <field>Sent_Date__c</field>
        <name>Making the sent date to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sent_Date</fullName>
        <field>Sent_Date__c</field>
        <formula>Today()</formula>
        <name>Update Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Emails Sent Date Internally</fullName>
        <actions>
            <name>Publishing_Alert_News_Internally</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Mail_Alert_sent_on_Active_SI_to_internal_users_of_ASIC_App</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Section_Information__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Section_Information__c.Internal_Only__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>This workflow will trigger alerts to a group of internal users using the ASIC App.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mail notification to ASIC interested group</fullName>
        <actions>
            <name>Publishing_Alert_News_to_Interested_Group</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Mail_Alert_sent_on_Active_SI_to_interested_users</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Section_Information__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>This workflow will trigger alerts to a group containing users interested for ASIC alerts.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Making the sent date to null</fullName>
        <actions>
            <name>Making_the_sent_date_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Section_Information__c.Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notifying Administrator</fullName>
        <actions>
            <name>Notifying_the_Administrator</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Section_Information__c.Notify_Administrator__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Mail_Alert_sent_on_Active_SI_to_interested_users</fullName>
        <assignedTo>doug.dreibelbis@globalfoundries.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>This task is created to track that a mail has been triggered on an active SI to interested users in the group &apos;Interested users for ASIC communicator&apos;.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Mail Alert sent on Active SI to interested users</subject>
    </tasks>
    <tasks>
        <fullName>Mail_Alert_sent_on_Active_SI_to_internal_users_of_ASIC_App</fullName>
        <assignedTo>doug.dreibelbis@globalfoundries.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>This task is created to track that a mail has been triggered on an active SI to interested users in the group &apos;Internal users for ASIC communicator&apos;.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Mail Alert sent on Active SI to internal users of ASIC App</subject>
    </tasks>
</Workflow>
