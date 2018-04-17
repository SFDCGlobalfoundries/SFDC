<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DR_Notify_Admin_Of_Approval</fullName>
        <description>DR - Notify Admin Of Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>ashwathi.jayakumar@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>asimkumar.pandey@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>prabhukiran.shivaiah@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>saurabh.mishra@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deployment_Request_Templates/Deployment_Approval_Request_Approved_Email_to_Admin</template>
    </alerts>
    <alerts>
        <fullName>DR_Notify_Owner_Of_Approval</fullName>
        <description>DR - Notify Owner Of Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deployment_Request_Templates/Deployment_Approval_Request_Approved_Email</template>
    </alerts>
    <alerts>
        <fullName>DR_Send_Rejection_Email</fullName>
        <description>DR - Send Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deployment_Request_Templates/Deployment_Approval_Request_Rejected_Email</template>
    </alerts>
    <alerts>
        <fullName>DR_Send_Rejection_Email_To_SDM</fullName>
        <description>DR - Send Rejection Email To SDM</description>
        <protected>false</protected>
        <recipients>
            <recipient>angela.lim@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yang.li@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Deployment_Approval_Request_Rejected_Email_to_SDM</template>
    </alerts>
    <alerts>
        <fullName>Send_Approval_Email_Reminder_RM</fullName>
        <description>Send Approval Email Reminder (RM)</description>
        <protected>false</protected>
        <recipients>
            <recipient>bhanu@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>brathour@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deployment_Request_Templates/Deployment_Approval_Reminder_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_Approval_Email_Reminder_SDM</fullName>
        <description>Send Approval Email Reminder (SDM)</description>
        <protected>false</protected>
        <recipients>
            <recipient>angela.lim@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ds.srinivas@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.ho@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>leeeng.lim@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mohammedshahid.ahmed@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shivakumar.patil@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yang.li@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deployment_Request_Templates/Deployment_Approval_Reminder_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_DR_Status_Email</fullName>
        <description>Send DR Status Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deployment_Request_Templates/Deployment_Request_Status_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>DR_Notify_Owner_of_Rejection</fullName>
        <field>RM_Review_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>DR - Notify Owner of Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Admin_To_Deploy</fullName>
        <field>Administrator_to_Deploy__c</field>
        <lookupValue>asimkumar.pandey@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>DR - Update Admin To Deploy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Admin_To_Deploy_Swift</fullName>
        <field>Administrator_to_Deploy__c</field>
        <lookupValue>andrew.sia@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>DR - Update Admin To Deploy (Swift)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Approval_Date</fullName>
        <field>Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>DR - Update Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Approval_Date_Recall</fullName>
        <field>Approval_Date__c</field>
        <name>DR - Update Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_RM_Approval_Date</fullName>
        <field>RM_Approval_Date__c</field>
        <formula>Now()</formula>
        <name>DR - Update RM Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_RM_Status_to_SDM_Approval</fullName>
        <field>RM_Review_Status__c</field>
        <literalValue>SDM Approval</literalValue>
        <name>DR - Update RM Status to SDM Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Record_Type_to_Locked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DR_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>DR - Update Record Type to Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Record_Type_to_Unlocked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DR_Unlocked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>DR - Update Record Type to Unlocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Review_Status_To_RM_Approval</fullName>
        <field>RM_Review_Status__c</field>
        <literalValue>RM Approval</literalValue>
        <name>DR - Update Review Status To RM Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Review_Status_to_Approved</fullName>
        <field>RM_Review_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>DR - Update Review Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Review_Status_to_Not_Started</fullName>
        <field>RM_Review_Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>DR - Update Review Status to Not Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Review_Status_to_Rejected</fullName>
        <field>RM_Review_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>DR - Update Review Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_SDM_Approval_Date</fullName>
        <field>SDM_Approval_Date__c</field>
        <formula>Now()</formula>
        <name>DR - Update SDM Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DR_Update_Submitted_Date</fullName>
        <field>Submitted_Date__c</field>
        <formula>NOW()</formula>
        <name>DR - Update Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Administrator_to_Deploy</fullName>
        <field>Administrator_to_Deploy__c</field>
        <lookupValue>andrew.sia@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Administrator to Deploy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Date</fullName>
        <field>Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>DR - Update Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submitted_Date</fullName>
        <field>Submitted_Date__c</field>
        <formula>NOW()</formula>
        <name>DR - Update Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DR - Change Record Type to Locked</fullName>
        <actions>
            <name>DR_Update_Record_Type_to_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Deployment_Status__c)  , ISPICKVAL(Deployment_Status__c, &apos;Deployed&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DR - Change Record Type to Unlocked</fullName>
        <actions>
            <name>DR_Update_Record_Type_to_Unlocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISCHANGED(Deployment_Status__c)  , NOT(ISPICKVAL(Deployment_Status__c, &apos;Deployed&apos;)) , ISPICKVAL(PRIORVALUE(Deployment_Status__c), &apos;Deployed&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DR - Send Email Reminder %28RM%29</fullName>
        <active>true</active>
        <formula>ISPICKVAL(RM_Review_Status__c, &apos;RM Approval&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Approval_Email_Reminder_RM</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Approval_Email_Reminder_RM</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Approval_Email_Reminder_RM</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DR - Send Email Reminder %28SDM%29</fullName>
        <active>true</active>
        <formula>ISPICKVAL(RM_Review_Status__c, &apos;SDM Approval&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Approval_Email_Reminder_SDM</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Approval_Email_Reminder_SDM</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Approval_Email_Reminder_SDM</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DR - Send Status Email</fullName>
        <actions>
            <name>Send_DR_Status_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Deployment_Status__c) , OR( ISPICKVAL(Deployment_Status__c, &apos;Deployed&apos;) , ISPICKVAL(Deployment_Status__c, &apos;Failed&apos;) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DR - Set Administrator to Deploy</fullName>
        <actions>
            <name>Set_Administrator_to_Deploy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Deployment_Request__c.Application_Name__c</field>
            <operation>equals</operation>
            <value>Swift</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
