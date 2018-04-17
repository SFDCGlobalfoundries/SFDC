<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GMPL_BX009_Creation_of_new_GMPL</fullName>
        <description>GMPL/ BX009: Creation of new GMPL</description>
        <protected>false</protected>
        <recipients>
            <recipient>PPM_Team_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Creation_of_new_GMPL</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_after_Approval_by_Regional_Head_Marketing_VP</fullName>
        <description>GMPL/BX009: Email Alert after Approval by Regional Head/ Marketing VP</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Approval_by_Regional_Head_Marketing_VP</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_after_BX009_Submission_to_Mkt_VP</fullName>
        <description>GMPL/BX009: Email Alert after BX009 Submission to Mkt VP</description>
        <protected>false</protected>
        <recipients>
            <recipient>Marketing_VP_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Approval_Request_by_Regional_Head_Marketing_VP</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_after_BX009_Submission_to_Region_Head_Backup_Head</fullName>
        <description>GMPL/BX009: Email Alert after BX009 Submission to Region Head/Backup Head</description>
        <protected>false</protected>
        <recipients>
            <field>Region_Head_Backup__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Region_Head__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Approval_Request_by_Regional_Head_Marketing_VP</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_after_Rejection_by_Regional_Head_Marketing_VP</fullName>
        <description>GMPL/BX009: Email Alert after Rejection by Regional Head/ Marketing VP</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Rejection_by_Regional_Head_Marketing_VP</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_after_all_essential_fields_are_completed_on_BX009</fullName>
        <description>GMPL/BX009: Email Alert after all essential fields are completed on BX009</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Completion_of_all_fields_before_submission_for_first_level_approval</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_as_a_Courtesy_Email_when_Product_Marketing_VP_apprv_rej</fullName>
        <description>GMPL/BX009: Email Alert as a Courtesy Email when Product Marketing VP approves/ rejects</description>
        <protected>false</protected>
        <recipients>
            <recipient>Marketing_VP_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Courtesy_email_to_Prod_Mktng_VP_Queue_after_action_has_been_taken</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_for_Creation_of_New_BX009</fullName>
        <description>GMPL/BX009: Email Alert for Creation of New BX009</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>PPM_Team_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Creation_of_new_BX009</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_to_CE_Admin_after_BX009_Status_becomes_Completed</fullName>
        <description>GMPL/BX009: Email Alert to CE Admin after BX009 Status becomes Completed</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_BX009_that_has_been_completed</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_to_CE_Admin_for_BX009_Status_Change_to_Project_Kick_Off</fullName>
        <description>GMPL/BX009: Email Alert to CE Admin for BX009 Status Change to Project Kick Off</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_BX009_that_has_been_Kicked_Off</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_to_CE_Section_after_30_days</fullName>
        <description>GMPL/BX009: Email Alert to CE Section after 30 days</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_CE_Section_to_be_updated_1_month_after_RTR_Commit</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_to_Finance_Team_to_associate_PA_Code</fullName>
        <description>GMPL/BX009: Email Alert to Finance Team to associate PA Code</description>
        <protected>false</protected>
        <recipients>
            <recipient>Finance_Team_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Finance_Team_to_associate_a_PA_Code</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_to_PPM_Team_for_Product_Start_Date_Change</fullName>
        <description>GMPL/BX009: Email Alert to PPM Team for Product Start Date Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>PPM_Team_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_BX009_whose_Product_Start_Date_has_been_updated</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_to_PPM_Team_for_Revenue_Forecast_Change</fullName>
        <description>GMPL/BX009: Email Alert to PPM Team for Revenue Forecast Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>PPM_Team_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_BX009_whose_Revenue_Forecast_has_been_updated</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_to_SQE_Group_for_Consigned_Wafer_Checkbox_Selection</fullName>
        <description>GMPL/BX009: Email Alert to SQE Group for Consigned Wafer Checkbox Selection</description>
        <protected>false</protected>
        <recipients>
            <recipient>GMPL_BX009_SQE_Role_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_BX009_having_SQE_Service_Type</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_to_Turnkey_Group_for_Turnkey_Checkbox_Selection</fullName>
        <description>GMPL/BX009: Email Alert to Turnkey Group for Turnkey Checkbox Selection</description>
        <protected>false</protected>
        <recipients>
            <recipient>GMPL_BX009_TK_Role_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_BX009_having_Turnkey_Service_Type</template>
    </alerts>
    <alerts>
        <fullName>GMPL_BX009_Email_Alert_when_AM_completes_discussion_with_Customer</fullName>
        <description>GMPL/BX009 - Email Alert when AM completes discussion with Customer</description>
        <protected>false</protected>
        <recipients>
            <recipient>CE_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/GMPL_BX009_Completion_of_Account_Managers_discussion_with_Customer</template>
    </alerts>
    <fieldUpdates>
        <fullName>GMPL_BX009_PLC_Next_Gate_Update_BCCB</fullName>
        <description>PLC Next Gate is updated to BCCB.</description>
        <field>PLC_Next_Gate__c</field>
        <literalValue>BCCB</literalValue>
        <name>GMPL/BX009:PLC Next Gate Update BCCB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_PLC_Next_Gate_Update_PC0</fullName>
        <description>PLC Next Gate is updated to PC0.</description>
        <field>PLC_Next_Gate__c</field>
        <literalValue>PC0</literalValue>
        <name>GMPL/BX009:PLC Next Gate Update PC0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_PLC_Next_Gate_Update_PC1</fullName>
        <description>PLC Next Gate is updated to PC1.</description>
        <field>PLC_Next_Gate__c</field>
        <literalValue>PC1</literalValue>
        <name>GMPL/BX009:PLC Next Gate Update PC1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_PLC_Next_Gate_Update_PC2</fullName>
        <description>PLC Next Gate is updated to PC2.</description>
        <field>PLC_Next_Gate__c</field>
        <literalValue>PC2</literalValue>
        <name>GMPL/BX009:PLC Next Gate Update PC2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_PLC_Next_Gate_Update_PLR</fullName>
        <description>PLC Next Gate is updated to PLR.</description>
        <field>PLC_Next_Gate__c</field>
        <literalValue>PLR</literalValue>
        <name>GMPL/BX009:PLC Next Gate Update PLR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_PLC_Next_Gate_Update_PRR</fullName>
        <description>PLC Next Gate is updated to PRR.</description>
        <field>PLC_Next_Gate__c</field>
        <literalValue>PRR</literalValue>
        <name>GMPL/BX009:PLC Next Gate Update PRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_Status_field_update_Approval</fullName>
        <description>BX009 Status field should be updated after first level approval</description>
        <field>BX009_Status__c</field>
        <literalValue>BRB Review</literalValue>
        <name>GMPL/BX009:Status field update_ Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_Status_field_update_Rejected</fullName>
        <description>BX009 Status field to be updated after first level rejection</description>
        <field>BX009_Status__c</field>
        <literalValue>BCCB Approved</literalValue>
        <name>GMPL/BX009:Status field update_ Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_Status_field_update_Submtd</fullName>
        <description>Status update after the field has been submitted for Approval by Regional Manager/ Marketing VP</description>
        <field>BX009_Status__c</field>
        <literalValue>Regional / Marketing Business Analysis</literalValue>
        <name>GMPL/BX009:Status field update_ Submtd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_Upd_Rec_Typ_BX009_Read</fullName>
        <description>This field update changes the record type of BX009 to Read-Only when BX009 Status equals &apos;BRB Approved&apos; or &apos;Project Kick Off&apos;.</description>
        <field>RecordTypeId</field>
        <lookupValue>BX009_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>GMPL/BX009 - Upd Rec Typ - BX009 Read</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_Upd_Rec_Typ_BX009_Void</fullName>
        <description>This field update changes the record type of BX009 to Void Read-Only when BX009 Status equals &apos;Void&apos;.</description>
        <field>RecordTypeId</field>
        <lookupValue>BX009_Void_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>GMPL/BX009 - Upd Rec Typ - BX009 Void</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GMPL_BX009_Update_Record_Type_BX009</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BX009</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>GMPL/BX009 - Update Record Type - BX009</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GMPL%2F BX009%3A Email Alert on creation of GMPL</fullName>
        <actions>
            <name>GMPL_BX009_Creation_of_new_GMPL</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>GMPL</value>
        </criteriaItems>
        <description>This workflow will send an email notification to PPM Team whenever a GMPL is created by a user</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Email Alert after BX009 Status becomes Completed</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_to_CE_Admin_after_BX009_Status_becomes_Completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.BX009_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Workflow to facilitate notification when system automatically changes the BX009 Status to &apos;Completed&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Email Alert after BX009 Submission to Mkt VP</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_after_BX009_Submission_to_Mkt_VP</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.Project_Type__c</field>
            <operation>equals</operation>
            <value>Market</value>
        </criteriaItems>
        <criteriaItems>
            <field>GMPL_BX009__c.BX009_Status__c</field>
            <operation>equals</operation>
            <value>Regional / Marketing Business Analysis</value>
        </criteriaItems>
        <description>Workflow to facilitate notification on submission of BX009 for first level of approval by Marketing VP.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Email Alert after BX009 Submission to Region Head%2FBackup Head</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_after_BX009_Submission_to_Region_Head_Backup_Head</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>GMPL_BX009__c.Project_Type__c</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>GMPL_BX009__c.BX009_Status__c</field>
            <operation>equals</operation>
            <value>Regional / Marketing Business Analysis</value>
        </criteriaItems>
        <description>Workflow to facilitate notification on submission of BX009 for first level of approval by Regional Territory Head/ Backup Head.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Email Alert when AM completes discussion with Customer</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_when_AM_completes_discussion_with_Customer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Has_customer_agreed_with_GLOBALFOUNDRIES__c),NOT(ISPICKVAL(Has_customer_agreed_with_GLOBALFOUNDRIES__c,&apos;&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Record Type - BX009</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_for_Creation_of_New_BX009</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>GMPL_BX009_Update_Record_Type_BX009</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will change the record type to &apos;BX009&apos; on change of &apos;BCCB Disposition&apos; field value to &apos;Approved to BX009&apos;.</description>
        <formula>AND(ISCHANGED(BCCB_Disposition__c),ISPICKVAL(BCCB_Disposition__c,&apos;Approved to BX009&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Update PLC Next Gate To PC0</fullName>
        <actions>
            <name>GMPL_BX009_PLC_Next_Gate_Update_PC0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.BCCB_Disposition__c</field>
            <operation>equals</operation>
            <value>Approved to PC0</value>
        </criteriaItems>
        <description>This workflow rule checks the BCCB Disposition Status as Approved to PC0 and updates the PLC Next Gate to PC0.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Update PLC Next Gate To PC1</fullName>
        <actions>
            <name>GMPL_BX009_PLC_Next_Gate_Update_PC1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.G0_Disposition__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>This workflow rule checks the PC0 Disposition Status as Approved and updates the PLC Next Gate to PC1.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Update PLC Next Gate To PC2</fullName>
        <actions>
            <name>GMPL_BX009_PLC_Next_Gate_Update_PC2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.G1_Disposition__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>This workflow rule checks the PC1 Disposition Status as Approved and updates the PLC Next Gate to PC2.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Update PLC Next Gate To PLR</fullName>
        <actions>
            <name>GMPL_BX009_PLC_Next_Gate_Update_PLR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.G3_Disposition__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>This workflow rule checks the PC2 Disposition Status as Approved and updates the PLC Next Gate to PLR.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Update PLC Next Gate To PRR</fullName>
        <actions>
            <name>GMPL_BX009_PLC_Next_Gate_Update_PRR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.G6_Disposition__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>This workflow rule checks the PLR Disposition Status as Approved and updates the PLC Next Gate to PRR.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Update Record Type - BX009 Read-Only</fullName>
        <actions>
            <name>GMPL_BX009_Upd_Rec_Typ_BX009_Read</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>GMPL_BX009__c.BX009_Status__c</field>
            <operation>equals</operation>
            <value>BRB Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>GMPL_BX009__c.BX009_Status__c</field>
            <operation>equals</operation>
            <value>Project Kick Off</value>
        </criteriaItems>
        <description>This workflow updates the record type of BX009 to &apos;BX009 Read-Only&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Update Record Type - BX009 Void Read-Only</fullName>
        <actions>
            <name>GMPL_BX009_Upd_Rec_Typ_BX009_Void</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>GMPL_BX009__c.BX009_Status__c</field>
            <operation>equals</operation>
            <value>Void</value>
        </criteriaItems>
        <criteriaItems>
            <field>GMPL_BX009__c.BX009_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>This workflow updates the record type of BX009 to &apos;BX009 Void Read-Only&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009 - Update Record Type - BX009 on BX009 Status Update</fullName>
        <actions>
            <name>GMPL_BX009_Update_Record_Type_BX009</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow will update the BX009 record type from Read Only to BX009.</description>
        <formula>AND( 	ISPICKVAL(PRIORVALUE(BX009_Status__c),&apos;BRB Approved&apos;), 	NOT( 		OR( 			ISPICKVAL(BX009_Status__c,&apos;Project Kick Off&apos;), 			ISPICKVAL(BX009_Status__c,&apos;Completed&apos;), 			ISPICKVAL(BX009_Status__c,&apos;Void&apos;) 		) 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009%3A Email Alert after all essential fields are completed on BX009</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_after_all_essential_fields_are_completed_on_BX009</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow Rule to facilitate notification after all essential fields are completed on BX009 and it is ready to be sent for Regional Territory Head/ Marketing VP Approval</description>
        <formula>AND(  	OR(  		Consigned_Wafer__c,  		Productization__c,  		Product_Process__c,  		Turnkey__c  	), 	AND( 		IF(!Consigned_Wafer__c, TRUE, SQE_Acknowledgement__c), 		IF(!Product_Process__c, TRUE, Process_Acknowledgement__c), 		IF(!Productization__c, TRUE, Productization_Acknowledgement__c),  		IF(!Turnkey__c, TRUE, Turnkey_Acknowledgement__c) 	) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009%3A Email Alert to CE Admin for BX009 Status Change to Project Kick Off</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_to_CE_Admin_for_BX009_Status_Change_to_Project_Kick_Off</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.BX009_Status__c</field>
            <operation>equals</operation>
            <value>Project Kick Off</value>
        </criteriaItems>
        <description>Workflow to facilitate notification when system automatically changes the BX009 status to Project Kick Off.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009%3A Email Alert to CE Section after 30 days</fullName>
        <active>true</active>
        <description>Workflow to facilitate Notification to be generated to update the CE Section, 1 month (30 days) after the ‘Risk Product Start (RTR) - Commit’ date, asking him/her to update the CE Section</description>
        <formula>AND(NOT(ISBLANK(Risk_Production_Start_RTR_Commit__c)),  RecordType.DeveloperName = &apos;BX009&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GMPL_BX009_Email_Alert_to_CE_Section_after_30_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>GMPL_BX009__c.Risk_Production_Start_RTR_Commit__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009%3A Email Alert to Finance Team to associate PA Code</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_to_Finance_Team_to_associate_PA_Code</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.BX009_Status__c</field>
            <operation>equals</operation>
            <value>BRB Approved</value>
        </criteriaItems>
        <description>Workflow to facilitate notification after BX009 Status is set to &apos;BRB Approved&apos; and Finance Team needs to associate PA Code to the Project.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009%3A Email Alert to PPM Team for Product Start Date Change</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_to_PPM_Team_for_Product_Start_Date_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow to facilitate notification generation whenever user updates the Product Start Date on GMPL/ BX009.</description>
        <formula>AND(NOT(ISPICKVAL(Product_Start_Date__c,&apos;&apos;)), ISCHANGED(Product_Start_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009%3A Email Alert to PPM Team for Revenue Forecast Change</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_to_PPM_Team_for_Revenue_Forecast_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow to facilitate notification whenever user updates the Quantity OR Average Sales Price for any year on &apos;Revenue Forecasting&apos;.</description>
        <formula>OR( ISCHANGED(Total_Quantity_Forecasted__c), ISCHANGED(Total_Revenue_Forecasted__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009%3A Email Alert to SQE Group for Consigned Wafer Checkbox Selection</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_to_SQE_Group_for_Consigned_Wafer_Checkbox_Selection</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.Consigned_Wafer__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow will send mail to SQE Public Group when Consigned Wafer checkbox is selected.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GMPL%2FBX009%3A Email Alert to Turnkey Group for Turnkey Checkbox Selection</fullName>
        <actions>
            <name>GMPL_BX009_Email_Alert_to_Turnkey_Group_for_Turnkey_Checkbox_Selection</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GMPL_BX009__c.Turnkey__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow will send mail to Turnkey Public Group when Turnkey checkbox is selected.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
