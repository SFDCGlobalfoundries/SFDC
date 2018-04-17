<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>eWSR_Email_Alert_for_F7</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com</ccEmails>
        <description>eWSR Email Alert for F7</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab7_F7</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_Alert_for_TD</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com</ccEmails>
        <description>eWSR Email Alert for TD</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab7_TD</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_on_Approval</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email on Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Lot_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_on_Rejection</fullName>
        <description>eWSR Email on Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Rejected_Notification</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Authorized_Personnel</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Authorized Personnel</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_Auth_Personnel_For_Fab2</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Authorized_Personnel_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Budget_Manager</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Budget Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Budget_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Budget_Manager_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Department_Director</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Department Director</description>
        <protected>false</protected>
        <recipients>
            <field>Department_Director_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Department_Director_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Department_Director_3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Department_Director_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Fab_Execution_for_Fab_2</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Fab Execution for Fab 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab2</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Fab_Execution_for_Fab_3</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Fab Execution for Fab 3</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab3</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Fab_Execution_for_Fab_3E</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Fab Execution for Fab 3E</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab3E</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Fab_Execution_for_Fab_5</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Fab Execution for Fab 5</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab5</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Fab_Execution_for_Fab_5JV</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Fab Execution for Fab 5JV</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab5JV</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Fab_Execution_for_Fab_6</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Fab Execution for Fab 6</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab6</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Fab_Execution_for_Fab_7</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Fab Execution for Fab 7</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab7_F7</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Fab_Execution_for_Fab_7_F7</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Fab Execution for Fab 7(F7)</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab7_F7</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Fab_Execution_for_Fab_7_TD</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Fab Execution for Fab 7(TD)</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_FAB_Execution_For_Fab7_TD</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Fab_Execution_Planner_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_HOD</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to HOD</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>HOD__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_HOD_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Manager</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Manager_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Manager_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Manager_3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Supervisor_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Production_Control_for_Fab_2</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Production Control for Fab 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_Prod_Control_For_Fab2</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Production_Control_Department_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Production_Control_for_Fab_3</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Production Control for Fab 3</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_Prod_Control_For_Fab3</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Production_Control_Department_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Production_Control_for_Fab_3E</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Production Control for Fab 3E</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_Prod_Control_For_Fab3E</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Production_Control_Department_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Production_Control_for_Fab_5</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Production Control for Fab 5</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_Prod_Control_For_Fab5</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Production_Control_Department_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Production_Control_for_Fab_5JV</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Production Control for Fab 5JV</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_Prod_Control_For_Fab5JV</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Production_Control_Department_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Production_Control_for_Fab_6</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Production Control for Fab 6</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_Prod_Control_For_Fab6</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Production_Control_Department_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Production_Control_for_Fab_7</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Production Control for Fab 7</description>
        <protected>false</protected>
        <recipients>
            <recipient>eWSR_Prod_Control_For_Fab7</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Production_Control_Department_Template</template>
    </alerts>
    <alerts>
        <fullName>eWSR_Email_to_Program_Manager</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com;</ccEmails>
        <description>eWSR Email to Program Manager</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Program_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/eWSR_Pending_Program_Manager_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>eWSRE_Status_field_Update</fullName>
        <field>Status__c</field>
        <literalValue>Pending with Planner Approval</literalValue>
        <name>eWSR Status field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSRE_Status_field_Update_for_F7</fullName>
        <field>Status__c</field>
        <literalValue>Pending with PC Department</literalValue>
        <name>eWSR Status field Update for F7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Change_Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>eWSR Change Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Change_Status_to_Auth_Personnel</fullName>
        <field>Status__c</field>
        <literalValue>Pending with Authorized Personnel</literalValue>
        <name>eWSR Change Status to Auth Personnel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Change_Status_to_Budget_Manager</fullName>
        <field>Status__c</field>
        <literalValue>Pending with Budget Manager</literalValue>
        <name>eWSR Change Status to Budget Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Change_Status_to_Dept_Director</fullName>
        <field>Status__c</field>
        <literalValue>Pending with Department Director Approval</literalValue>
        <name>eWSR Change Status to Dept Director</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Change_Status_to_HOD</fullName>
        <field>Status__c</field>
        <literalValue>Pending with HOD</literalValue>
        <name>eWSR Change Status to HOD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Change_Status_to_Planning_Execution</fullName>
        <field>Status__c</field>
        <literalValue>Pending with Planner Approval</literalValue>
        <name>eWSR Change Status to Planning Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Change_Status_to_Prod_Control</fullName>
        <field>Status__c</field>
        <literalValue>Pending with PC Department</literalValue>
        <name>eWSR Change Status to Prod Control</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Change_Status_to_Program_Manager</fullName>
        <field>Status__c</field>
        <literalValue>Pending with Program Manager</literalValue>
        <name>eWSR Change Status to Program Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Change_Status_to_Supervisor</fullName>
        <field>Status__c</field>
        <literalValue>Pending with Supervisor</literalValue>
        <name>eWSR Change Status to Supervisor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Status_field_Update_for_TD</fullName>
        <field>Status__c</field>
        <literalValue>Pending with PC Department</literalValue>
        <name>eWSR Status field Update for TD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Update_RemQuan_on_Approval_False</fullName>
        <field>UpdateRemQuanOnApproval__c</field>
        <literalValue>0</literalValue>
        <name>eWSR Update RemQuan on Approval False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Update_Remaining_Quan_on_Rej_False</fullName>
        <field>UpdateRemQuanOnRejection__c</field>
        <literalValue>0</literalValue>
        <name>eWSR Update Remaining Quan on Rej False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Update_Remaining_Quan_on_Rejection</fullName>
        <field>UpdateRemQuanOnRejection__c</field>
        <literalValue>1</literalValue>
        <name>eWSR Update Remaining Quan on Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Update_Remaining_Quant_on_Approval</fullName>
        <field>UpdateRemQuanOnApproval__c</field>
        <literalValue>1</literalValue>
        <name>eWSR Update Remaining Quant on Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Update_Status_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>eWSR Update Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eWSR_Update_Status_to_New</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>eWSR Update Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>eWSR Update Status Field for F7</fullName>
        <actions>
            <name>eWSR_Email_Alert_for_F7</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>eWSRE_Status_field_Update_for_F7</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( Status__c , &apos;Pending with PC Department&apos;) &amp;&amp; (Equivalent_Quantity__c &lt;= Remaining_Quantity__c) &amp;&amp; (RecordType.DeveloperName == &apos;FAB_7&apos;) &amp;&amp; ISPICKVAL( Module__c , &apos;F7&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eWSR Update Status Field for TD</fullName>
        <actions>
            <name>eWSR_Email_Alert_for_TD</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>eWSR_Status_field_Update_for_TD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( Status__c , &apos;Pending with PC Department&apos;) &amp;&amp; (Equivalent_Quantity__c &lt;= Remaining_Quantity__c) &amp;&amp; (RecordType.DeveloperName == &apos;FAB_7&apos;) &amp;&amp; ISPICKVAL( Module__c , &apos;TD&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
