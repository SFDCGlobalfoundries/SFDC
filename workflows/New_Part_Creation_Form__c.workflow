<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NPC_Mail_To_CE_System_Pending_Execution_For_More_Than_1_Day</fullName>
        <description>NPC Form - Mail To CE System Pending Execution For More Than 1 Day</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/NPC_Mail_Pending_Exec_More_Than_1_Day_VF</template>
    </alerts>
    <alerts>
        <fullName>NPC_Mail_To_Originator_FE_CSR_CE_for_Rejection</fullName>
        <description>NPC Mail To Originator, FE, CSR, CE for Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/NPC_Mail_for_Rejection_VF</template>
    </alerts>
    <alerts>
        <fullName>NPC_Mail_To_Originator_FE_CSR_CE_on_Completion</fullName>
        <description>NPC Form - Mail To Originator, FE, CSR, CE on Completion</description>
        <protected>false</protected>
        <recipients>
            <field>Additional_Recipient_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/NPC_Mail_on_Completion_VF</template>
    </alerts>
    <alerts>
        <fullName>NPC_Mail_To_Originator_WWMS_for_Fab_2_3_5_6_on_Completion</fullName>
        <description>NPC Mail To Originator, WWMS for Fab 2,3,5,6 on Completion</description>
        <protected>false</protected>
        <recipients>
            <recipient>chengbee.quah@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>omathanu.magesh@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>peigin.ho@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/NPC_Mail_To_Origin_Fab_on_Complete_VF</template>
    </alerts>
    <alerts>
        <fullName>NPC_Mail_To_Originator_WWMS_on_Completion</fullName>
        <description>NPC Mail To Originator, WWMS on Completion</description>
        <protected>false</protected>
        <recipients>
            <field>Additional_Recipient_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/NPC_Mail_To_Origin_Fab_on_Complete_VF</template>
    </alerts>
    <alerts>
        <fullName>NPC_Mail_to_Assignee</fullName>
        <description>NPC Mail to Assignee</description>
        <protected>false</protected>
        <recipients>
            <field>Assignee_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Assignee_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/NPC_Mail_to_Assignee_for_Approval</template>
    </alerts>
    <alerts>
        <fullName>NPC_Mail_to_CE_Supervisor_CE_has_not_approved_more_than_1_working_day</fullName>
        <description>NPC Form - Mail to CE Supervisor CE has not approved more than 1 working day</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/NPC_Mail_not_approved_more_than_1_day_VF</template>
    </alerts>
    <alerts>
        <fullName>NPC_Mail_to_Originator_FE_CSR_CE_CE_Systems_after_Approval</fullName>
        <description>NPC Form - Mail to Originator, FE, CSR, CE, CE Systems after Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Additional_Recipient_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/NPC_Mail_after_Approval_VF</template>
    </alerts>
    <alerts>
        <fullName>NPC_Mail_to_Originator_WWMS_CE_when_Device_Staged_Tapeout</fullName>
        <ccEmails>Gfv.do.not.reply@globalfoundries.com</ccEmails>
        <description>NPC Mail to Originator, WWMS, CE when Device staged Tapeout</description>
        <protected>false</protected>
        <recipients>
            <field>Additional_Recipient_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLOBALFOUNDRIES/NPC_Mail_to_Orig_Fab_CE_when_Tapeout_VF</template>
    </alerts>
    <alerts>
        <fullName>NPC_Mail_to_Originator_WWMS_after_Approval</fullName>
        <description>NPC Mail to Originator, WWMS after Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Additional_Recipient_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Recipient_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PIYE_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/NPC_Mail_to_Origin_Fab_after_Approval_VF</template>
    </alerts>
    <alerts>
        <fullName>NPC_Mail_to_Originator_WWMS_for_Fab_2_3_5_6_after_Approval</fullName>
        <description>NPC Mail to Originator, WWMS for Fab 2,3,5,6 after Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>chengbee.quah@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>omathanu.magesh@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>peigin.ho@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/NPC_Mail_to_Origin_Fab_after_Approval_VF</template>
    </alerts>
    <fieldUpdates>
        <fullName>NPC_Device_Tapeout_Flag_False</fullName>
        <field>Generated_Device_Tapeout_Flag__c</field>
        <literalValue>0</literalValue>
        <name>NPC - Device Tapeout Flag - False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_Approval_Status_Accepted</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>NPC Form - Approval Status Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_Approval_Status_Accepted_ReEv</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>NPC Form - Approval Status Accepted ReEv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_Approval_Status_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>NPC Form - Approval Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_Approval_Status_Recalled</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>NPC Form - Approval Status Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_Approval_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>NPC Form - Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_CSR_Req_Action_Empty</fullName>
        <field>CSR_Required_Action__c</field>
        <name>NPC Form - CSR Req Action Empty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_CSR_Req_Action_fill</fullName>
        <field>CSR_Required_Action__c</field>
        <formula>&quot;Required Action:  Click on Approve/Reject button to enter reticle ship back date&quot;</formula>
        <name>NPC Form - CSR Req Action fill</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_Litho_Status</fullName>
        <field>Litho_Status__c</field>
        <literalValue>Yes</literalValue>
        <name>NPC Form - Litho Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_Status_Draft</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>NPC Form Status Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_Status_Litho_Verification</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Pending Litho Verification</literalValue>
        <name>NPC Form Status Litho Verification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_Update_By_Pass_Validation</fullName>
        <field>ByPassValidation__c</field>
        <literalValue>0</literalValue>
        <name>NPC Form - Update By Pass Validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Form_Yes_at_Customer_Skip</fullName>
        <field>Skip_Final_Step__c</field>
        <literalValue>1</literalValue>
        <name>NPC Form Yes at Customer Skip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_PLM_Last_Sync_Status_Now</fullName>
        <field>Last_Sync_to_PLM_Status__c</field>
        <formula>TEXT(NOW())</formula>
        <name>NPC - PLM Last Sync Status - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_PLM_Sync_Status_Sent</fullName>
        <field>PLM_Sync_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>NPC - PLM Sync Status - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Pending_AM_Approval</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Pending AM Approval</literalValue>
        <name>NPC Pending AM Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Update_Device_Status</fullName>
        <field>Status__c</field>
        <literalValue>Void</literalValue>
        <name>NPC - Update Device Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>BASE_Device__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Update_PIYE_Approver_1</fullName>
        <field>PIYE_Approver_1__c</field>
        <name>NPC - Update PIYE Approver 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Update_PIYE_Approver_2</fullName>
        <field>PIYE_Approver_2__c</field>
        <name>NPC - Update PIYE Approver 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Update_PIYE_Approver_3</fullName>
        <field>PIYE_Approver_3__c</field>
        <name>NPC - Update PIYE Approver 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPC_Update_PIYE_Approver_4</fullName>
        <field>PIYE_Approver_4__c</field>
        <name>NPC - Update PIYE Approver 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PI_YE_Field_Update_2</fullName>
        <field>PI_YE_Update_Status__c</field>
        <literalValue>Status 2</literalValue>
        <name>PI/YE Field Update 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetNPC_Form_Status_to_Executed</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Executed</literalValue>
        <name>Set NPC Form Status to Executed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Assignee_1_as_Blank</fullName>
        <field>Assignee_1__c</field>
        <name>Set Assignee 1 as Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Assignee_2_as_Blank</fullName>
        <field>Assignee_2__c</field>
        <name>Set Assignee 2 as Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Assignee_3_as_Blank</fullName>
        <field>Assignee_3__c</field>
        <name>Set Assignee 3 as Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPCStatus_to_Pending_Resubmission</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Pending Resubmission</literalValue>
        <name>Set NPC Status to Pending Resubmission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Device_Status_to_Void</fullName>
        <field>Device_Status__c</field>
        <formula>&quot;Void&quot;</formula>
        <name>Set NPC Device Status to Void</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_Executed</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Executed</literalValue>
        <name>Set NPC Form Status to Executed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution1</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution10</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution2</fullName>
        <description>Set NPC Form Status to In Execution</description>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution3</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution4</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution5</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution6</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution7</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution8</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_In_Execution9</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Set NPC Form Status to In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_Not_Executed</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Not Executed</literalValue>
        <name>Set NPC Form Status to Not Executed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_Not_Executed10</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Not Executed</literalValue>
        <name>Set NPC Form Status to Not Executed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_Pending_FAE</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Pending Mask Layer Addition by FE</literalValue>
        <name>Set NPC Form Status to Pending FAE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_Pending_PID_Reas</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Pending PID Reassignment</literalValue>
        <name>Set NPC Form Status to Pending PID Reas</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_Pending_Sub</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Pending Submission</literalValue>
        <name>Set NPC Form Status to Pending Sub</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Status_to_Submitted</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Pending CE Approval</literalValue>
        <name>Set NPC Form Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Form_Submitted_Date</fullName>
        <field>NPC_Form_Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set NPC Form Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Rec_Type_to_StatusNotSubmitted</fullName>
        <field>RecordTypeId</field>
        <lookupValue>StatusNotSubmitted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set NPC Rec Type to StatusNotSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Rec_Type_to_StatusRejected</fullName>
        <field>RecordTypeId</field>
        <lookupValue>StatusRejected</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set NPC Rec Type to StatusRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Rec_Type_to_StatusSubmitted</fullName>
        <field>RecordTypeId</field>
        <lookupValue>StatusSubmitted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set NPC Rec Type to StatusSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_STF_Activation_Steps_to_Step_1</fullName>
        <field>STF_Activation_Steps__c</field>
        <literalValue>Step 1</literalValue>
        <name>Set NPC STF Activation Steps to Step 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_STF_Activation_Steps_to_Step_2</fullName>
        <field>STF_Activation_Steps__c</field>
        <literalValue>Step 2</literalValue>
        <name>Set NPC STF Activation Steps to Step 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NPC_Status_to_Pending_Resubmission</fullName>
        <field>NPC_Form_Status__c</field>
        <literalValue>Pending Resubmission</literalValue>
        <name>Set NPC Status to Pending Resubmission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateSend_Reject_Email_Flag</fullName>
        <field>Send_Reject_Email_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Update Send Reject Email Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_STF_Activation_Steps</fullName>
        <field>STF_Activation_Steps__c</field>
        <literalValue>Step 1</literalValue>
        <name>Update STF Activation Steps</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_STF_Activation_Steps1</fullName>
        <field>STF_Activation_Steps__c</field>
        <literalValue>Step 1</literalValue>
        <name>Update STF Activation Steps1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_STF_Activation_Steps2</fullName>
        <field>STF_Activation_Steps__c</field>
        <literalValue>Step 1</literalValue>
        <name>Update STF Activation Steps2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_STF_Activation_Steps3</fullName>
        <field>STF_Activation_Steps__c</field>
        <literalValue>Step 1</literalValue>
        <name>Update STF Activation Steps3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_STF_Activation_Steps4</fullName>
        <field>STF_Activation_Steps__c</field>
        <literalValue>Step 1</literalValue>
        <name>Update STF Activation Steps4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_STF_Activation_Steps5</fullName>
        <field>STF_Activation_Steps__c</field>
        <literalValue>Step 1</literalValue>
        <name>Update STF Activation Steps5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Recall_Email_Flag</fullName>
        <field>Send_Recall_Email_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Update Send Recall Email Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Reject_Email_Flag</fullName>
        <field>Send_Reject_Email_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Update Send Reject Email Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>New_Part_Creation_Device_Reactivation_OB</fullName>
        <apiVersion>38.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFNPCPLMService/SFNPCPLMService_client</endpointUrl>
        <fields>Account_Short_Name__c</fields>
        <fields>CRM_DID__c</fields>
        <fields>Device_Status__c</fields>
        <fields>Geometry__c</fields>
        <fields>Id</fields>
        <fields>Mask_Set_Title__c</fields>
        <fields>New_Part_ID__c</fields>
        <fields>Secure_Device__c</fields>
        <fields>Tapeout_Type__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>New Part Creation Device Reactivation OB</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>New_Part_Retrofit_Outbound_Message_to_A</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFNPCPLMService/SFNPCPLMService_client</endpointUrl>
        <fields>Account_Short_Name__c</fields>
        <fields>CRM_DID__c</fields>
        <fields>Device_Status__c</fields>
        <fields>Geometry__c</fields>
        <fields>Id</fields>
        <fields>Mask_Set_Title__c</fields>
        <fields>New_Part_ID__c</fields>
        <fields>Secure_Device__c</fields>
        <fields>Tapeout_Type__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>New Part Retrofit: Outbound Message to A</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>NPC Form - Mail To Assignee</fullName>
        <actions>
            <name>NPC_Mail_to_Assignee</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Reason_for_New_Part__c</field>
            <operation>equals</operation>
            <value>Device Reactivation</value>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Assignee_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Assignee_2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.NPC_Form_Status__c</field>
            <operation>equals</operation>
            <value>In Execution</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NPC Form - Mail To CE System Pending Execution For More Than 1 Day</fullName>
        <active>true</active>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.NPC_Form_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>NPC Mail To CE System Pending Execution For More Than 1 Day</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NPC_Mail_To_CE_System_Pending_Execution_For_More_Than_1_Day</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>New_Part_Creation_Form__c.NPC_Form_Submitted_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NPC Form - Mail To Originator%2C FE%2C CSR%2C CE for Rejection</fullName>
        <actions>
            <name>NPC_Mail_To_Originator_FE_CSR_CE_for_Rejection</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.NPC_Form_Status__c</field>
            <operation>equals</operation>
            <value>Pending Resubmission</value>
        </criteriaItems>
        <description>NPC Mail To Originator, FE, CSR, CE for Rejection</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NPC Form - Mail To Originator%2C FE%2C CSR%2C CE on Completion</fullName>
        <actions>
            <name>NPC_Mail_To_Originator_FE_CSR_CE_on_Completion</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.NPC_Form_Status__c</field>
            <operation>equals</operation>
            <value>Executed</value>
        </criteriaItems>
        <description>NPC Mail To Originator, FE, CSR, CE on Completion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NPC Form - Mail to CE Supervisor - CE has not approved more than 1 working day</fullName>
        <active>false</active>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.NPC_Form_Status__c</field>
            <operation>equals</operation>
            <value>Pending CE Approval</value>
        </criteriaItems>
        <description>NPC Mail to CE Supervisor - CE has not approved more than 1 working day</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NPC_Mail_to_CE_Supervisor_CE_has_not_approved_more_than_1_working_day</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>New_Part_Creation_Form__c.NPC_Form_Submitted_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NPC Form - Mail to Originator%2C FE%2C CSR%2C CE%2C CE Systems after Approval</fullName>
        <actions>
            <name>NPC_Mail_to_Originator_FE_CSR_CE_CE_Systems_after_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.NPC_Form_Status__c</field>
            <operation>equals</operation>
            <value>In Execution</value>
        </criteriaItems>
        <description>NPC Mail to Originator, FE, CSR, CE, CE Systems after Approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NPC Form - Update By Pass Validation field</fullName>
        <actions>
            <name>NPC_Form_Update_By_Pass_Validation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Device_Status__c  = &apos;Active&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NPC Mail To Originator%2C WWMS for Fab 2%2C3%2C5%2C6 on Completion</fullName>
        <actions>
            <name>NPC_Mail_To_Originator_WWMS_for_Fab_2_3_5_6_on_Completion</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.NPC_Form_Status__c</field>
            <operation>equals</operation>
            <value>Executed</value>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Fab__c</field>
            <operation>equals</operation>
            <value>FAB 2</value>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Fab__c</field>
            <operation>equals</operation>
            <value>FAB 3</value>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Fab__c</field>
            <operation>equals</operation>
            <value>FAB 5</value>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Fab__c</field>
            <operation>equals</operation>
            <value>FAB 6</value>
        </criteriaItems>
        <description>NPC Mail To Originator, WWMS for Fab 2,3,5,6 on Completion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NPC Mail To Originator%2C WWMS on Completion</fullName>
        <actions>
            <name>NPC_Mail_To_Originator_WWMS_on_Completion</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.NPC_Form_Status__c</field>
            <operation>equals</operation>
            <value>Executed</value>
        </criteriaItems>
        <description>NPC Mail To Originator, WWMS on Completion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NPC Mail to Originator%2C WWMS after Approval</fullName>
        <actions>
            <name>NPC_Mail_to_Originator_WWMS_after_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.NPC_Form_Status__c</field>
            <operation>equals</operation>
            <value>In Execution</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NPC Mail to Originator%2C WWMS for Fab 2%2C3%2C5%2C6 after Approval</fullName>
        <actions>
            <name>NPC_Mail_to_Originator_WWMS_for_Fab_2_3_5_6_after_Approval</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.NPC_Form_Status__c</field>
            <operation>equals</operation>
            <value>In Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Fab__c</field>
            <operation>equals</operation>
            <value>FAB 2</value>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Fab__c</field>
            <operation>equals</operation>
            <value>FAB 3</value>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Fab__c</field>
            <operation>equals</operation>
            <value>FAB 5</value>
        </criteriaItems>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Fab__c</field>
            <operation>equals</operation>
            <value>FAB 6</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NPC Mail to Originator%2C WWMS%2C CE when device Staged Tapeout</fullName>
        <actions>
            <name>NPC_Mail_to_Originator_WWMS_CE_when_Device_Staged_Tapeout</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NPC_Device_Tapeout_Flag_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>New_Part_Creation_Form__c.Generated_Device_Tapeout_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>NPC Mail to Originator, WWMS, CE when device move to Tapeout from Design-in.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Part Creation Form - Form Status is moved to Void</fullName>
        <actions>
            <name>NPC_Update_Device_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(NPC_Form_Status__c) , ISPICKVAL(NPC_Form_Status__c, &apos;Void&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Part Creation Form - Outbound Message - To AIA</fullName>
        <actions>
            <name>NPC_PLM_Last_Sync_Status_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NPC_PLM_Sync_Status_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>New_Part_Retrofit_Outbound_Message_to_A</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND( OR(  		AND( ISCHANGED(NPC_Form_Status__c), ISPICKVAL(NPC_Form_Status__c, &apos;In Execution&apos;) ),  		AND( ISCHANGED(NPC_Form_Status__c), ISPICKVAL(NPC_Form_Status__c, &apos;Not Executed&apos;) ), 		AND( 			OR(BASE_Device__r.RecordType.DeveloperName == &apos;Internal_Device&apos;, 
BASE_Device__r.RecordType.DeveloperName == &apos;Internal_Device_Read_Only&apos;), 			AND(ISCHANGED(NPC_Form_Status__c), ISPICKVAL(NPC_Form_Status__c, &apos;Executed&apos;)) 		) 	 ),  	ISPICKVAL(Tapeout_Required__c,&apos;No&apos;),  	OR( 		ISPICKVAL(Reason_for_New_Part__c,&apos;Retrofit&apos;), ISPICKVAL(Reason_for_New_Part__c,&apos;Retrofit + Add ROM Code&apos;),  		ISPICKVAL(Reason_for_New_Part__c,&apos;New Probe Card Flow&apos;),  		ISPICKVAL(Reason_for_New_Part__c,&apos;Fab to Fab Transfer&apos;),  		ISPICKVAL(Reason_for_New_Part__c,&apos;StartingMaterialChange&apos;),  		ISPICKVAL(Reason_for_New_Part__c,&apos;BackgrindThicknessChange&apos;),  		ISPICKVAL(Reason_for_New_Part__c,&apos;Change in PID&apos;), ISPICKVAL(Reason_for_New_Part__c,&apos;ShortLoop Flow&apos;), 		AND(ISPICKVAL(Reason_for_New_Part__c,&apos;Others&apos;), ISPICKVAL(Require_To_Create_The_New_Part__c,&apos;Yes&apos;)) 	)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Part Creation Form Device Re activation</fullName>
        <actions>
            <name>NPC_PLM_Last_Sync_Status_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NPC_PLM_Sync_Status_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>New_Part_Creation_Device_Reactivation_OB</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND( OR(ISPICKVAL(Reason_for_New_Part__c,&apos;Device Reactivation&apos;)), ISBLANK(Originating_Device__r.PLM_Device_ID__c), $Profile.Name != &apos;GF Integration&apos;,  NOT(ISBLANK(Actual_Implementation_Date__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
