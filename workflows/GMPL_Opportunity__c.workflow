<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GMPLOpportunityAssociation_Send_Reminder_to_Mainstream_BCCB_after_Approval_by_PL</fullName>
        <description>GMPL Opportunity Association: Send Reminder to Mainstream BCCB after Approval by PLM/PPM</description>
        <protected>false</protected>
        <recipients>
            <recipient>Mainstream_BCCB_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_Opportunity_Association_Send_Reminder_after_Approval_by_PLM_PPM</template>
    </alerts>
    <alerts>
        <fullName>GMPL_Opportunity_Association_Email_Alert_after_Approval_by_PLM_PPM</fullName>
        <description>GMPL Opportunity Association: Email Alert after Approval by PLM/PPM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_Opportunity_Association_Approval_by_PLM_PPM</template>
    </alerts>
    <alerts>
        <fullName>GMPL_Opportunity_Association_Email_Alert_after_Rejection_by_PLM_PPM</fullName>
        <description>GMPL Opportunity Association: Email Alert after Rejection by PLM/PPM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_Opportunity_Association_Rejection_by_PLM_PPM</template>
    </alerts>
    <alerts>
        <fullName>GMPL_Opportunity_Association_Send_Reminder_to_Leading_Edge_Fab_1_BCCB_after_Appr</fullName>
        <description>GMPL Opportunity Association: Send Reminder to Leading Edge Fab 1 BCCB after Approval by PLM/PPM</description>
        <protected>false</protected>
        <recipients>
            <recipient>Leading_Edge_Fab_1_BCCB_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_Opportunity_Association_Send_Reminder_after_Approval_by_PLM_PPM</template>
    </alerts>
    <alerts>
        <fullName>GMPL_Opportunity_Association_Send_Reminder_to_Leading_Edge_Fab_8_BCCB_after_Appr</fullName>
        <description>GMPL Opportunity Association: Send Reminder to Leading Edge Fab 8 BCCB after Approval by PLM/PPM</description>
        <protected>false</protected>
        <recipients>
            <recipient>Leading_Edge_Fab_8_BCCB_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_Opportunity_Association_Send_Reminder_after_Approval_by_PLM_PPM</template>
    </alerts>
    <fieldUpdates>
        <fullName>Clear_Request_Status</fullName>
        <description>Clear Request Status</description>
        <field>Request_Status__c</field>
        <name>Clear Request Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_Opp_Association_Update_GMPL_Oppor</fullName>
        <field>GMPL_Opportunity_Id__c</field>
        <formula>GMPL_Opportunity__c</formula>
        <name>GMPL Opp Association - Update GMPL Oppor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Request_Status_Approved</fullName>
        <field>Request_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Request Status = Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Request_Status_GMPL_Assigned</fullName>
        <field>Request_Status__c</field>
        <literalValue>GMPL Assigned</literalValue>
        <name>Update Request Status = GMPL Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Request_Status_Rejected</fullName>
        <field>Request_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Request Status = Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Request_Status_Submitted</fullName>
        <description>Update Request Status = Submitted</description>
        <field>Request_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Update Request Status = Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GMPL Opp Association - Update GMPL Opportunity Id</fullName>
        <actions>
            <name>GMPL_Opp_Association_Update_GMPL_Oppor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule executes every time a record is created or updated to populate the GMPL_Opportunity_Id__c field with a unique value.</description>
        <formula>NOT(ISBLANK(GMPL_Opportunity__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GMPL Opportunity Association%3A Send Reminder to Leading Edge Fab 1 BCCB after Approval by PLM%2FPPM</fullName>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_Opportunity__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>GMPL_Opportunity__c.Primary_GF_Fab__c</field>
            <operation>equals</operation>
            <value>FAB 1</value>
        </criteriaItems>
        <description>This workflow will send mail to Leading Edge Fab 1 BCCB Group when Request Status is &apos;Approved&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GMPL_Opportunity_Association_Send_Reminder_to_Leading_Edge_Fab_1_BCCB_after_Appr</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GMPL Opportunity Association%3A Send Reminder to Leading Edge Fab 8 BCCB after Approval by PLM%2FPPM</fullName>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_Opportunity__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>GMPL_Opportunity__c.Primary_GF_Fab__c</field>
            <operation>equals</operation>
            <value>FAB 8</value>
        </criteriaItems>
        <description>This workflow will send mail to Leading Edge Fab 8 BCCB Group when Request Status is &apos;Approved&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GMPL_Opportunity_Association_Send_Reminder_to_Leading_Edge_Fab_8_BCCB_after_Appr</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GMPL Opportunity Association%3A Send Reminder to Mainstream BCCB after Approval by PLM%2FPPM</fullName>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_Opportunity__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>GMPL_Opportunity__c.Primary_GF_Fab__c</field>
            <operation>notEqual</operation>
            <value>FAB 1,FAB 8</value>
        </criteriaItems>
        <description>This workflow will send mail to Mainstream BCCB Group when Request Status is &apos;Approved&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GMPLOpportunityAssociation_Send_Reminder_to_Mainstream_BCCB_after_Approval_by_PL</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Request Status %3D GMPL Assigned</fullName>
        <actions>
            <name>Update_Request_Status_GMPL_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_Opportunity__c.GMPL_BX009_Record_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Request Status = GMPL Assigned after GMPL assigned in junction object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
