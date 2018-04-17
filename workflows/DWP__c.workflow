<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approved</fullName>
        <description>Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DWP_Email_Templates/X02_Submission_Approved</template>
    </alerts>
    <alerts>
        <fullName>DWP_Renewal_Request</fullName>
        <description>DWP Renewal Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DWP_Email_Templates/X05_Submit_for_Renewal</template>
    </alerts>
    <alerts>
        <fullName>DWP_created</fullName>
        <description>DWP created</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DWP_Email_Templates/X01_Submission_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Recall_notice</fullName>
        <description>Recall notice</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DWP_Email_Templates/X03_Recall_Submitted_DWP_Request</template>
    </alerts>
    <alerts>
        <fullName>Rejected</fullName>
        <ccEmails>risk.start@globalfoundries.com.preprod</ccEmails>
        <description>Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DWP_Email_Templates/X02_Submission_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Renewal_Approved</fullName>
        <description>Renewal Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DWP_Email_Templates/X06_Renewal_Approved</template>
    </alerts>
    <alerts>
        <fullName>Renewal_Rejected</fullName>
        <description>Renewal Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DWP_Email_Templates/X06_Renewal_Rejected</template>
    </alerts>
    <alerts>
        <fullName>X7_day_warning_notice</fullName>
        <ccEmails>tarek.mohamed@globalfoundries.com, charles.derby@globalfoundries.com, dl.fc8.protocol.enforcement@globalfoundries.com</ccEmails>
        <description>7 day warning notice</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DWP_Email_Templates/X04_Approved_DWP_7_Day_Warning_about_to_Expire</template>
    </alerts>
    <alerts>
        <fullName>X7_day_warning_notice_part_2</fullName>
        <ccEmails>tarek.mohamed@globalfoundries.com, charles.derby@globalfoundries.com</ccEmails>
        <description>7 day warning notice part 2</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DWP_Email_Templates/X04a_Renewed_DWP_7_Day_Warning_about_to_Expire</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_DWP_Status_Expired_to_Closed_pt_2</fullName>
        <field>DWP_Status__c</field>
        <literalValue>8.0 31-60 Day Permit Close Out Completed</literalValue>
        <name>Change DWP Status Expired to Closed pt 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_DWP_Status_to_2nd_Expiration</fullName>
        <field>DWP_Status__c</field>
        <literalValue>8.1 31-60 Day Permit Expired (Close Out Missing)</literalValue>
        <name>Change DWP Status to 2nd Expiration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_DWP_Status_to_Expired</fullName>
        <field>DWP_Status__c</field>
        <literalValue>3.1 30-Day Permit Expired (Close Out Missing)</literalValue>
        <name>Change DWP Status to Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Request_Renewal</fullName>
        <field>DWP_Status__c</field>
        <literalValue>5.0 Submitted for Renewal (1st Close Out Approved)</literalValue>
        <name>Change Status to Submitted for Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Submitted</fullName>
        <field>DWP_Status__c</field>
        <literalValue>1.0 Submitted for Approval</literalValue>
        <name>Change Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_to_Draft</fullName>
        <field>DWP_Status__c</field>
        <literalValue>0.0 Draft</literalValue>
        <name>Reset to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Rejected</fullName>
        <field>DWP_Status__c</field>
        <literalValue>2.1 30-Day Permit Rejected</literalValue>
        <name>Set Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_renewal_approved</fullName>
        <field>DWP_Status__c</field>
        <literalValue>6.0 31-60 Day Permit Approved</literalValue>
        <name>Set Status to renewal approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_status_back_to_1st_approval</fullName>
        <field>DWP_Status__c</field>
        <literalValue>4.0 30-Day Permit Close Out Completed</literalValue>
        <name>Set status back to 1st approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_status_to_renewal_rejected</fullName>
        <field>DWP_Status__c</field>
        <literalValue>6.1 31-60 Day Permit Rejected</literalValue>
        <name>Set status to ren rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_to_Approved</fullName>
        <field>DWP_Status__c</field>
        <literalValue>2.0 30-Day Permit Approved</literalValue>
        <name>Set to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DWP_Status_from_expired_to_closed</fullName>
        <field>DWP_Status__c</field>
        <literalValue>4.0 30-Day Permit Close Out Completed</literalValue>
        <name>Update DWP Status from expired to closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to</fullName>
        <field>DWP_Status__c</field>
        <literalValue>3.0 30-Day Permit Submitted for Close Out</literalValue>
        <name>Update status to 3.0 Close Out Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_4_0_Close_Out_Approved</fullName>
        <field>DWP_Status__c</field>
        <literalValue>4.0 30-Day Permit Close Out Completed</literalValue>
        <name>Update status to 4.0 Close Out Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_7_0_Submitted_to_Close</fullName>
        <field>DWP_Status__c</field>
        <literalValue>7.0 31-60 Day Permit Submitted for Close Out</literalValue>
        <name>Update status to 7.0 Submitted to Close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_8_0_Closed_Out</fullName>
        <field>DWP_Status__c</field>
        <literalValue>8.0 31-60 Day Permit Close Out Completed</literalValue>
        <name>Update status to 8.0 Closed Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change DWP Status from Expired to Closed</fullName>
        <actions>
            <name>Update_DWP_Status_from_expired_to_closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>0.0 Draft,1.0 Submitted for Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>2.0 30-Day Permit Approved,2.1 30-Day Permit Rejected,3.0 30-Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>4.0 30-Day Permit Close Out Completed,5.0 Submitted for Renewal (1st Close Out Approved)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>5.0 Submitted for Renewal (1st Close Out Approved),6.0 31-60 Day Permit Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>6.1 31-60 Day Permit Rejected,7.0 31-60 Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>8.0 31-60 Day Permit Close Out Completed,8.1 31-60 Day Permit Expired (Close Out Missing)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.Close_Out_Approvals__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change DWP Status from Expired to Closed part 2</fullName>
        <actions>
            <name>Change_DWP_Status_Expired_to_Closed_pt_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>0.0 Draft,1.0 Submitted for Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>2.0 30-Day Permit Approved,2.1 30-Day Permit Rejected,3.0 30-Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>4.0 30-Day Permit Close Out Completed,5.0 Submitted for Renewal (1st Close Out Approved)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>5.0 Submitted for Renewal (1st Close Out Approved),6.0 31-60 Day Permit Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>6.1 31-60 Day Permit Rejected,7.0 31-60 Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>8.0 31-60 Day Permit Close Out Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>3.1 30-Day Permit Expired (Close Out Missing)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.Close_Out_Approvals__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DWP 7 day warning</fullName>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6</booleanFilter>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>0.0 Draft,1.0 Submitted for Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>2.1 30-Day Permit Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>3.0 30-Day Permit Submitted for Close Out,3.1 30-Day Permit Expired (Close Out Missing)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>4.0 30-Day Permit Close Out Completed,5.0 Submitted for Renewal (1st Close Out Approved)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>6.0 31-60 Day Permit Approved,6.1 31-60 Day Permit Rejected,7.0 31-60 Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>8.0 31-60 Day Permit Close Out Completed,8.1 31-60 Day Permit Expired (Close Out Missing)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X7_day_warning_notice</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>DWP__c.End_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DWP 7 day warning part 2</fullName>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11 OR 12</booleanFilter>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>0.0 Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>1.0 Submitted for Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>2.0 30-Day Permit Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>2.1 30-Day Permit Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>3.0 30-Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>3.1 30-Day Permit Expired (Close Out Missing)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>4.0 30-Day Permit Close Out Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>5.0 Submitted for Renewal (1st Close Out Approved)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>6.1 31-60 Day Permit Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>7.0 31-60 Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>8.0 31-60 Day Permit Close Out Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>8.1 31-60 Day Permit Expired (Close Out Missing)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X7_day_warning_notice_part_2</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>DWP__c.End_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DWP Expire after 30 days</fullName>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11 OR 12</booleanFilter>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>0.0 Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>1.0 Submitted for Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>2.1 30-Day Permit Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>3.0 30-Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>3.1 30-Day Permit Expired (Close Out Missing)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>4.0 30-Day Permit Close Out Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>5.0 Submitted for Renewal (1st Close Out Approved)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>6.0 31-60 Day Permit Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>6.1 31-60 Day Permit Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>7.0 31-60 Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>8.0 31-60 Day Permit Close Out Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>8.1 31-60 Day Permit Expired (Close Out Missing)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Change_DWP_Status_to_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>DWP__c.End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DWP Expire after 60 days</fullName>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7</booleanFilter>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>0.0 Draft,1.0 Submitted for Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>2.0 30-Day Permit Approved,2.1 30-Day Permit Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>3.0 30-Day Permit Submitted for Close Out,3.1 30-Day Permit Expired (Close Out Missing)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>4.0 30-Day Permit Close Out Completed,5.0 Submitted for Renewal (1st Close Out Approved)</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>6.1 31-60 Day Permit Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>7.0 31-60 Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>notEqual</operation>
            <value>8.0 31-60 Day Permit Close Out Completed,8.1 31-60 Day Permit Expired (Close Out Missing)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Change_DWP_Status_to_2nd_Expiration</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>DWP__c.End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update DWP status on 1st Close Out</fullName>
        <actions>
            <name>Update_status_to</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>equals</operation>
            <value>2.0 30-Day Permit Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.Close_Out_Requests_Submitted__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update DWP status on 2nd Close Out</fullName>
        <actions>
            <name>Update_status_to_7_0_Submitted_to_Close</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>equals</operation>
            <value>6.0 31-60 Day Permit Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.Close_Out_Requests_Created__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.Close_Out_Requests_Submitted__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update DWP status to approved on 1st Close Out</fullName>
        <actions>
            <name>Update_status_to_4_0_Close_Out_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>equals</operation>
            <value>3.0 30-Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.Close_Out_Approvals__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update DWP status to approved on 2nd Close Out</fullName>
        <actions>
            <name>Update_status_to_8_0_Closed_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DWP__c.DWP_Status__c</field>
            <operation>equals</operation>
            <value>7.0 31-60 Day Permit Submitted for Close Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>DWP__c.Close_Out_Approvals__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
