<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Deal_Grading_Admin_Approval</fullName>
        <description>Deal Grading Admin Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>Deal_Grading_Admins</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deal_Grading_Email_Template/Business_Assessment_Template</template>
    </alerts>
    <alerts>
        <fullName>Deal_Grading_Communication</fullName>
        <description>Deal Grading Communication</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deal_Grading_Email_Template/Deal_Grading_Communication</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_BA_Team</fullName>
        <description>Notification to BA Team</description>
        <protected>false</protected>
        <recipients>
            <field>Business_Assessor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Business_Assessment_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deal_Grading_Email_Template/Business_Assessment_Template</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_the_Requester_that_the_DG_is_approved</fullName>
        <description>Notification to the Requester that the DG is approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>Deal_Grading_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deal_Grading_Email_Template/Approved_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Back_to_Draft</fullName>
        <field>Deal_Grading_status__c</field>
        <literalValue>Draft</literalValue>
        <name>Back to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_to_DG_Review</fullName>
        <description>Initially submitted for review.</description>
        <field>Deal_Grading_status__c</field>
        <literalValue>Deal Grading Review</literalValue>
        <name>Change to DG Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DG_Grad_Status</fullName>
        <field>Deal_Grading_status__c</field>
        <literalValue>Complete - Proceed to Quote</literalValue>
        <name>Deal Grad Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DG_Meeting_Required</fullName>
        <field>Is_submitting_for_approval__c</field>
        <literalValue>1</literalValue>
        <name>DG Meeting Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DG_Status</fullName>
        <field>Deal_Grading_status__c</field>
        <literalValue>Complete - Proceed to Quote</literalValue>
        <name>DG Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Grading_ASIC_Update</fullName>
        <field>Approval_Steps__c</field>
        <literalValue>Product Line Approved</literalValue>
        <name>Deal Grading ASIC Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Grading_Decision_Pending</fullName>
        <field>Result__c</field>
        <literalValue>Proceed to Bid</literalValue>
        <name>Deal Grading Decision Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Grading_Graded_Date</fullName>
        <field>Graded_Date__c</field>
        <formula>TODAY()</formula>
        <name>Deal Grading Graded Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Grading_Result_Rejected</fullName>
        <field>Result__c</field>
        <literalValue>No Bid - Business Rejected</literalValue>
        <name>Deal Grading Result Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Grading_SiPh</fullName>
        <field>Result__c</field>
        <literalValue>Proceed to Bid</literalValue>
        <name>Deal Grading SiPh</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Grading_Status</fullName>
        <field>Deal_Grading_status__c</field>
        <literalValue>Complete - Proceed to Quote</literalValue>
        <name>Deal Grading Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finally_Approved</fullName>
        <field>Deal_Grading_status__c</field>
        <literalValue>Complete - Proceed to Quote</literalValue>
        <name>Finally Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finnaly_No_Bid</fullName>
        <field>Deal_Grading_status__c</field>
        <literalValue>Complete - No Bid</literalValue>
        <name>Finnaly No Bid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NotBlank_Uni_Req_Module_Component_IP_Req</fullName>
        <field>NotBlank_Uni_Req_Module_Component_IP_Req__c</field>
        <literalValue>1</literalValue>
        <name>NotBlank Uni Req/Module Component/IP Req</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email</fullName>
        <field>Business_Assessor_Email__c</field>
        <formula>Business_Assessment_Done_by__r.Email</formula>
        <name>Update Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>uncheck_Notify</fullName>
        <field>Notify_Business_Assessor__c</field>
        <literalValue>0</literalValue>
        <name>uncheck Notify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>DIW NotBlank Uni Req%2FModule Component%2FIP Req</fullName>
        <actions>
            <name>NotBlank_Uni_Req_Module_Component_IP_Req</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( UniqRequirement_Module_Component_IP_Req__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Grading Graded Date</fullName>
        <actions>
            <name>Deal_Grading_Graded_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Deal_Grading__c.Deal_Grading_status__c</field>
            <operation>equals</operation>
            <value>Complete - Proceed to Quote</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deal_Grading__c.Meeting_Required1__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <description>Deal Grading Graded Date is updated after it is approved by PL for non meeting</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deal Grading Result Communication</fullName>
        <actions>
            <name>Deal_Grading_Communication</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Deal_Grading__c.Result__c</field>
            <operation>equals</operation>
            <value>Proceed to Bid,No Bid - Business Rejected,Proceed to Sizing / Review with Brand Prior to Release</value>
        </criteriaItems>
        <description>Communicates result after admin approves or rejects Deal Grading</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Business Assessment Team</fullName>
        <actions>
            <name>Notification_to_BA_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>uncheck_Notify</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Deal_Grading__c.Notify_Business_Assessor__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deal_Grading__c.Meeting_Required__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Email</fullName>
        <actions>
            <name>Update_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Deal_Grading__c.Business_Assessment_Done_by__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
