<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PCN_Email_Alert_on_Rejection</fullName>
        <description>PCN Email Alert on Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PCN_End_of_Life_Templates/PCN_EOL_Rejected_Template_by_LMT</template>
    </alerts>
    <alerts>
        <fullName>PCN_Reminder_Email_Send_to_CE_Approver_for_ASIC</fullName>
        <description>PCN Reminder Email Send to CE Approver for ASIC</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_ASIC_PG</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PCN_End_of_Life_Templates/PCN_Reminder_Emails</template>
    </alerts>
    <alerts>
        <fullName>PCN_Reminder_Email_Send_to_CE_Approver_for_RF</fullName>
        <description>PCN Reminder Email Send to CE Approver for RF</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_RF_PG</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PCN_End_of_Life_Templates/PCN_Reminder_Emails</template>
    </alerts>
    <alerts>
        <fullName>PCN_Reminder_Email_Send_to_LMT_Approver_for_ASIC</fullName>
        <description>PCN Reminder Email Send to LMT Approver for ASIC</description>
        <protected>false</protected>
        <recipients>
            <recipient>LMT_ASIC_PG</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PCN_End_of_Life_Templates/PCN_Reminder_Emails</template>
    </alerts>
    <alerts>
        <fullName>PCN_Reminder_Email_Send_to_LMT_Approver_for_RF</fullName>
        <description>PCN Reminder Email Send to LMT Approver for RF</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_RF_PG</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PCN_End_of_Life_Templates/PCN_Reminder_Emails</template>
    </alerts>
    <alerts>
        <fullName>PCN_Send_Email_Alert_to_MD_Part_Admin</fullName>
        <description>PCN Send Email Alert to  MD Part Admin</description>
        <protected>false</protected>
        <recipients>
            <recipient>MD_Part_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PCN_End_of_Life_Templates/PCN_MD_Part_Admin_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>PCN_UpdateCheck</fullName>
        <field>LODNotify1__c</field>
        <literalValue>1</literalValue>
        <name>PCN UpdateCheck1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCN_UpdateCheck2</fullName>
        <field>LODNotify2__c</field>
        <literalValue>1</literalValue>
        <name>PCN UpdateCheck2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCN_Update_Check3</fullName>
        <field>LODNotify3__c</field>
        <literalValue>1</literalValue>
        <name>PCN Update Check3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCN_Update_EOL_Date_with_Today</fullName>
        <field>EOL_Date__c</field>
        <formula>today()</formula>
        <name>PCN Update EOL Date with Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCN_Update_Record_Type_to_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Approved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PCN Update Record Type to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCN_Update_Stage_Approved_by_LMT</fullName>
        <field>EOL_Stage__c</field>
        <literalValue>Awaiting BU Program Mgr Approval</literalValue>
        <name>PCN Update Stage Approved by  LMT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCN_Update_Stage_to_CE_Approved</fullName>
        <field>EOL_Stage__c</field>
        <literalValue>Sent to Customers</literalValue>
        <name>PCN Update Stage to CE Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCN_Update_Stage_to_PCN_Closed</fullName>
        <field>EOL_Stage__c</field>
        <literalValue>Closed</literalValue>
        <name>PCN Update Stage to PCN Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCN_Update_Stage_to_Rejected</fullName>
        <field>EOL_Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>PCN Update Stage to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCN_Update_Stage_to_Submitted_by_EOL_Req</fullName>
        <field>EOL_Stage__c</field>
        <literalValue>Submitted, Awaiting LMT Approval</literalValue>
        <name>PCN Update Stage to Submitted by EOL Req</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PCN EOL Last Order Date Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Stage__c</field>
            <operation>equals</operation>
            <value>Sent to Customers</value>
        </criteriaItems>
        <criteriaItems>
            <field>PCN_EOL__c.Last_Order_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PCN_Update_Check3</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>PCN_EOL__c.Last_Order_Date__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PCN_UpdateCheck</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>PCN_EOL__c.Last_Order_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PCN_UpdateCheck2</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>PCN_EOL__c.Last_Order_Date__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PCN Reminder Email to CE Approvers ASIC</fullName>
        <active>true</active>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Stage__c</field>
            <operation>equals</operation>
            <value>Awaiting BU Program Mgr Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>PCN_EOL__c.LMT_Affected__c</field>
            <operation>equals</operation>
            <value>ASIC</value>
        </criteriaItems>
        <description>This rule is used to send an reminder Email to CE Approvers after 2 days for BU ASIC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PCN_Reminder_Email_Send_to_CE_Approver_for_ASIC</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>PCN_EOL__c.EOL_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PCN Reminder Email to CE Approvers RF</fullName>
        <active>true</active>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PCN_EOL__c.LMT_Affected__c</field>
            <operation>equals</operation>
            <value>RF</value>
        </criteriaItems>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Stage__c</field>
            <operation>equals</operation>
            <value>Awaiting BU Program Mgr Approval</value>
        </criteriaItems>
        <description>This rule is used to send an reminder Email to CE Approvers after 2 days for BU ASIC BU RF</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PCN_Reminder_Email_Send_to_CE_Approver_for_RF</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>PCN_EOL__c.EOL_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PCN Reminder Email to LMT Approver RF</fullName>
        <active>true</active>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PCN_EOL__c.LMT_Affected__c</field>
            <operation>equals</operation>
            <value>RF</value>
        </criteriaItems>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Stage__c</field>
            <operation>equals</operation>
            <value>&quot;Submitted, Awaiting LMT Approval&quot;</value>
        </criteriaItems>
        <description>This rule is used to send an reminder Email to LMT Approvers after 2 days for BU RF</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PCN_Reminder_Email_Send_to_LMT_Approver_for_RF</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>PCN_EOL__c.EOL_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PCN Reminder Email to LMT Approvers ASIC</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Stage__c</field>
            <operation>equals</operation>
            <value>&quot;Submitted, Awaiting LMT Approval&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>PCN_EOL__c.LMT_Affected__c</field>
            <operation>equals</operation>
            <value>ASIC</value>
        </criteriaItems>
        <description>This rule is used to send an reminder Email to LMT Approvers after 2 days for BU ASIC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PCN_Reminder_Email_Send_to_LMT_Approver_for_ASIC</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>PCN_EOL__c.EOL_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PCN Rule to Send Email Alert When Stage is EOL Closed</fullName>
        <actions>
            <name>PCN_Send_Email_Alert_to_MD_Part_Admin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Stage__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>This rule is used to notify Email Alert to MD Part Admin when EOL Stage is Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PCN Rule to Update EOL Status When LOD Expires</fullName>
        <active>true</active>
        <criteriaItems>
            <field>PCN_EOL__c.Last_Order_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Stage__c</field>
            <operation>equals</operation>
            <value>Sent to Customers</value>
        </criteriaItems>
        <description>This rule is used to update the EOL Status field when LOD is getting expired.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PCN_Update_Stage_to_PCN_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>PCN_EOL__c.Last_Order_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PCN Update the Record Type to Approved</fullName>
        <actions>
            <name>PCN_Update_Record_Type_to_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PCN_EOL__c.EOL_Stage__c</field>
            <operation>equals</operation>
            <value>Sent to Customers</value>
        </criteriaItems>
        <description>This rule is used to update the record type of the record to &quot;Approved&quot; which is having &quot;End of Life Layout-Customer &quot; Page Layout</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
