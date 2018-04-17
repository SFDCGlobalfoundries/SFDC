<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ROS_Active_Reticle_Initial_WF_Status</fullName>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Pending for STF Obsolescence</literalValue>
        <name>ROS_Active_Reticle_Initial_WF_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Clear_Contact_Name</fullName>
        <field>Contact_Name__c</field>
        <name>ROS Clear Contact Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Clear_Forwarder_Account_Number</fullName>
        <field>Account_Number__c</field>
        <name>ROS Clear Forwarder Account Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Clear_Forwarder_Name</fullName>
        <field>Forwarder_Name__c</field>
        <name>ROS Clear Forwarder Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Clear_HS_Code</fullName>
        <field>HS_Code__c</field>
        <name>ROS_Clear HS Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Clear_Item</fullName>
        <field>Item__c</field>
        <name>ROS_Clear Item #</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Customer_Remind_Date</fullName>
        <field>Customer_Remind_Date__c</field>
        <formula>DATE(YEAR(Customer_Notify_Date__c),MONTH(Customer_Notify_Date__c),DAY(Customer_Notify_Date__c) +  ROS_Cycle__r.First_Reminder__c)</formula>
        <name>ROS Customer Remind Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Debit_Note_Wf_Status_Update</fullName>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>ROS Debit Note Wf Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Dispostion_Date_Update</fullName>
        <description>Update disposition date on Reticle Disposition.</description>
        <field>Disposition_Date__c</field>
        <formula>TODAY()</formula>
        <name>ROS_Dispostion_Date_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Dispostion_Date_Update_On_Keep</fullName>
        <field>Disposition_Date__c</field>
        <formula>Today()</formula>
        <name>ROS_Dispostion_Date_Update_On_Keep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_FIELD_UPDATE_WF_CLOSE_DATE</fullName>
        <description>Field update for Workflow status closed date.</description>
        <field>Workflow_End_Date__c</field>
        <formula>TODAY()</formula>
        <name>ROS_FIELD_UPDATE_WF_CLOSE_DATE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_FU_INVALID_ACTIVE_RETICLE</fullName>
        <description>Update invalid checkbox for invalid Active Reticle.</description>
        <field>Invalid__c</field>
        <literalValue>1</literalValue>
        <name>ROS_FU_INVALID_ACTIVE_RETICLE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Field_Update_on_ROS_Status_Change</fullName>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Pending for STF obsolescence</literalValue>
        <name>ROS_Field Update on ROS Status Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Field_Update_on_Reticle_Confirmation</fullName>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Pending to Notify Customer</literalValue>
        <name>ROS_Field Update on Reticle Confirmation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Invalid_Reason_on_Reticle</fullName>
        <field>Invalid_Reason__c</field>
        <formula>(IF(Account__c==null,&apos;Account is missing.&apos;+BR(),&apos;&apos;))+ 
IF(ISBLANK(FabStr__c),&apos;One of the Fabs is missing.&apos;+BR(),&apos;&apos;)</formula>
        <name>ROS_Invalid Reason on Reticle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Notify_to_customer_date_update</fullName>
        <field>Customer_Notify_Date__c</field>
        <formula>TODAY()</formula>
        <name>ROS Notify to customer date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Populate_Cycle_History</fullName>
        <field>Cycle_History__c</field>
        <formula>IF(
   CONTAINS(PRIORVALUE(Cycle_History__c),ROS_Cycle__r.Name),    
   PRIORVALUE(Cycle_History__c), 
   ROS_Cycle__r.Name+&apos;;&apos;+PRIORVALUE(Cycle_History__c)
)</formula>
        <name>ROS_Populate_Cycle_History</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Reset_Customer_Notify_Date</fullName>
        <field>Customer_Notify_Date__c</field>
        <name>ROS_Reset Customer Notify Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Reset_Disposition_Date_Update</fullName>
        <field>Disposition_Date__c</field>
        <name>ROS_Reset Disposition Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Reset_Disposition_Requested_by_Cust</fullName>
        <field>Disposition_Requested_by_Customer__c</field>
        <literalValue>0</literalValue>
        <name>ROS_Reset Disposition Requested by Cust</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Reset_Disposition_Status</fullName>
        <field>ROS_Status__c</field>
        <name>ROS_Reset Disposition Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Reset_GE_Form_Id</fullName>
        <field>GE__c</field>
        <name>ROS_Reset_GE_Form_Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Reset_GE_Form_date</fullName>
        <field>GE_Form_Date__c</field>
        <name>ROS_Reset GE Form date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Reset_STF_Obselence_flag</fullName>
        <field>STF_Obsolence__c</field>
        <literalValue>0</literalValue>
        <name>ROS_Reset STF Obselence flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Shipping_Address_Populate</fullName>
        <field>SAfull__c</field>
        <formula>Shipping_Address__r.Shipping_Address_Full__c</formula>
        <name>ROS_Shipping Address Populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Update_Customer_Obsolescence_flag</fullName>
        <field>Disposition_Requested_by_Customer__c</field>
        <literalValue>1</literalValue>
        <name>ROS_Update Customer Obsolescence flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Update_Invalid_Flag_False</fullName>
        <field>Invalid__c</field>
        <literalValue>0</literalValue>
        <name>ROS_Update Invalid Flag False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Update_Invalid_Reason_as_Blank</fullName>
        <field>Invalid_Reason__c</field>
        <name>ROS_Update Invalid Reason as Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Update_Reticle_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CSR_layout</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ROS_Update Reticle Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Update_Solution_Confirm_on_Forced</fullName>
        <field>Solution_Team_Confirm__c</field>
        <literalValue>1</literalValue>
        <name>ROS_Update Solution Confirm on Forced</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Update_WF_to_Closed_on_Shipment</fullName>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>ROS_Update WF to Closed on Shipment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Update_WF_to_Pending_for_Shipment</fullName>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Pending for Shipment</literalValue>
        <name>ROS_Update WF to Pending for Shipment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Update_Workflow_as_closed_on_debit</fullName>
        <description>Update Workflow as &apos;Closed&apos; on Debit Note confirmation</description>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>ROS_Update Workflow as closed on debit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Update_invalid_flag_as_true</fullName>
        <field>Invalid__c</field>
        <literalValue>1</literalValue>
        <name>ROS_Update invalid flag as true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Workflow_Status_Closed</fullName>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>ROS_Workflow Status Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Workflow_Status_on_Keep</fullName>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Pending Debit Note</literalValue>
        <name>ROS_Workflow Status on Keep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Workflow_Update_on_STF_Obsolescence</fullName>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Pending for Fab&apos;s Follow-up</literalValue>
        <name>ROS_Workflow Update on STF Obsolescence</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reticle_Workflow_Status_Update_for_PSM</fullName>
        <field>Reticle_workflow_Status__c</field>
        <literalValue>Pending for EUC Form,Pending for STF Obsolescence</literalValue>
        <name>Reticle Workflow Status Update for PSM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Inactive_Days_Start_Date</fullName>
        <description>This field update, updates field &apos;Inactive Days Start Date&apos; when value in field &apos;Inactive Days&apos; gets modified.</description>
        <field>Inactive_Days_Start_Date__c</field>
        <formula>IF(NOT(ISBLANK(Day_Inactive__c)),
   (Today() - Day_Inactive__c),
   IF(NOT(ISBLANK(Inactive_Days_Start_Date__c)),
      Inactive_Days_Start_Date__c,
       DATEVALUE(LastModifiedDate)
   )
)</formula>
        <name>Update Inactive Days Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Debit_Note_Date</fullName>
        <field>Pending_Debit_Note_Date__c</field>
        <formula>today()</formula>
        <name>Update Pending Debit Note Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ROS Customer Notify Date</fullName>
        <actions>
            <name>ROS_Customer_Remind_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Notify_to_customer_date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Reticle__c.Reticle_workflow_Status__c</field>
            <operation>equals</operation>
            <value>Pending for Customer Feedback</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROS Cycle History Updation</fullName>
        <actions>
            <name>ROS_Populate_Cycle_History</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update the field Cycle History on Reticle record whenever the ROS_Cycle is changed.</description>
        <formula>ISNEW() || (PRIORVALUE(ROS_Cycle__c) !=  ROS_Cycle__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS Debit Note Update</fullName>
        <actions>
            <name>ROS_Debit_Note_Wf_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Reticle__c.ROS_Status__c</field>
            <operation>equals</operation>
            <value>Keep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Reticle__c.Reticle_workflow_Status__c</field>
            <operation>equals</operation>
            <value>Pending Debit Note</value>
        </criteriaItems>
        <criteriaItems>
            <field>Reticle__c.Debit_Note_Waive_Off__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Reticle__c.Debit_Note_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS Update Inactive Days Start Date</fullName>
        <actions>
            <name>Update_Inactive_Days_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update field &apos;Inactive Days Start Date&apos; when value in field &apos;Inactive Days&apos; gets modified.</description>
        <formula>OR(ISNEW(), ISCHANGED(Day_Inactive__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Active_Reticle_Validation</fullName>
        <actions>
            <name>ROS_FU_INVALID_ACTIVE_RETICLE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow validates Active Reticles after Disposition.</description>
        <formula>AND(OR(ISPICKVAL(ROS_Status__c, &apos;Return&apos;), ISPICKVAL(ROS_Status__c, &apos;Scrap&apos;)), ISPICKVAL(PRIORVALUE(Reticle_workflow_Status__c), &apos;&apos;) , Draft__c == false, ISBLANK(FabStr__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Active_Reticle_Workflow_Status_Update</fullName>
        <actions>
            <name>ROS_Active_Reticle_Initial_WF_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Dispostion_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(NOT(AND(ISPICKVAL(Reticle_Type__c,&apos;PSM&apos;),ISPICKVAL(ROS_Status__c,&apos;Return&apos;), EUC_Form_Required__c)),IF( NOT(CONTAINS( $Setup.ROS_Witness_Arrival_Accounts__c.Account_Short_Name__c , Account__r.Short_Name__c )) , OR(AND(OR(ISPICKVAL(ROS_Status__c,&apos;Return&apos;), ISPICKVAL(ROS_Status__c,&apos;Scrap&apos;)), Solution_Team_Confirm__c), AND(OR(ISPICKVAL(ROS_Status__c,&apos;Return&apos;), ISPICKVAL(ROS_Status__c,&apos;Scrap&apos;)), IsActive__c)), OR(AND(ISPICKVAL(ROS_Status__c,&apos;Return&apos;), Solution_Team_Confirm__c), AND(ISPICKVAL(ROS_Status__c,&apos;Return&apos;), IsActive__c), AND(ISPICKVAL(ROS_Status__c,&apos;Scrap&apos;), OR(Solution_Team_Confirm__c, IsActive__c)))),false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Active_Reticle_Workflow_Status_Update_PSM</fullName>
        <actions>
            <name>Reticle_Workflow_Status_Update_for_PSM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(AND(ISPICKVAL(Reticle_Type__c,&apos;PSM&apos;),ISPICKVAL(ROS_Status__c,&apos;Return&apos;),EUC_Form_Required__c),OR(Solution_Team_Confirm__c, IsActive__c),false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Backtrack Active to None</fullName>
        <actions>
            <name>ROS_Clear_Contact_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Clear_Forwarder_Account_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Clear_Forwarder_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Customer_Notify_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Disposition_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Disposition_Requested_by_Cust</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Disposition_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_GE_Form_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_GE_Form_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_STF_Obselence_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 		ISPICKVAL(Reticle_workflow_Status__c,&apos;&apos;), 		NOT(ISNEW()), 		OR( 			ISPICKVAL(PRIORVALUE(Reticle_workflow_Status__c),&apos;Return&apos;), 			ISPICKVAL(PRIORVALUE(Reticle_workflow_Status__c),&apos;Scrap&apos;) 		) 		)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Backtrack to Pending for Customer Feedback</fullName>
        <actions>
            <name>ROS_Clear_Contact_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Clear_Forwarder_Account_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Clear_Forwarder_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Disposition_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Disposition_Requested_by_Cust</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Disposition_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_GE_Form_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_GE_Form_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_STF_Obselence_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( !ISPICKVAL(PRIORVALUE(Reticle_workflow_Status__c),&apos;Pending to Notify Customer&apos;), !ISPICKVAL(PRIORVALUE(Reticle_workflow_Status__c),&apos;Pending for Customer Feedback&apos;), ISPICKVAL(Reticle_workflow_Status__c,&apos;Pending for Customer Feedback&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Backtrack to Pending for Fab%27s Follow-up</fullName>
        <actions>
            <name>ROS_Reset_GE_Form_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_GE_Form_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Reticle_workflow_Status__c,&quot;Pending for Fab&apos;s Follow-up&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Backtrack to Pending for STF Obselence</fullName>
        <actions>
            <name>ROS_Clear_HS_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Clear_Item</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_GE_Form_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_GE_Form_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_STF_Obselence_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Reticle_workflow_Status__c,&apos;Pending for STF Obsolescence&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Backtrack to Pending to Notify Customer</fullName>
        <actions>
            <name>ROS_Clear_Contact_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Clear_Forwarder_Account_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Clear_Forwarder_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Customer_Notify_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Disposition_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Disposition_Requested_by_Cust</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_Disposition_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_GE_Form_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_GE_Form_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Reset_STF_Obselence_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(IsActive__c==false,ISPICKVAL(Reticle_workflow_Status__c,&apos;Pending to Notify Customer&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Backtrack to Pending to Notify Customer%28New%29</fullName>
        <actions>
            <name>ROS_Reset_Customer_Notify_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Creating this workflow by moving all the field updates in (to reset the field values during backtrack) trigger which was initially added in the workflow:ROS_Backtrack to Pending to Notify Customer.</description>
        <formula>AND(IsActive__c==false,ISPICKVAL(Reticle_workflow_Status__c,&apos;Pending to Notify Customer&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Clear Invalid Reason</fullName>
        <actions>
            <name>ROS_Update_Invalid_Flag_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Update_Invalid_Reason_as_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will be executed only for Invalid Reticle.</description>
        <formula>AND(NOT(ISBLANK(FabStr__c)),NOT(Account__c==null))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Concatenate Invalid Reason on Reticle</fullName>
        <actions>
            <name>ROS_Invalid_Reason_on_Reticle</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Update_invalid_flag_as_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will updates &apos;invalid reason&apos; and &apos;invalid flag&apos; on reticle if account or fab value is blank.</description>
        <formula>OR(Account__c == null, ISBLANK(FabStr__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Field Update on Reticle Confirmation</fullName>
        <actions>
            <name>ROS_Field_Update_on_Reticle_Confirmation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Update_Reticle_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change Workflow Status to &apos;Pending notify to Customer&apos;</description>
        <formula>AND(ISPICKVAL(Reticle_workflow_Status__c,&apos;&apos;), Solution_Team_Confirm__c=true,!IsActive__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_ROS Workflow Change on Keep Status</fullName>
        <actions>
            <name>ROS_Dispostion_Date_Update_On_Keep</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Workflow_Status_on_Keep</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updating Workflow Status to Pending Debit Note</description>
        <formula>AND( ISPICKVAL(Reticle_workflow_Status__c,&apos;Pending for Customer Feedback&apos;), ISPICKVAL(PRIORVALUE(Reticle_workflow_Status__c),&apos;Pending for Customer Feedback&apos;), !ISPICKVAL( ROS_Status__c,&apos;&apos;), ISPICKVAL(ROS_Status__c,&apos;Keep&apos;), ISBLANK( Debit_Note_Number__c), Debit_Note_Waive_Off__c==false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_ROS Workflow on STF  Obsolescence</fullName>
        <actions>
            <name>ROS_Workflow_Update_on_STF_Obsolescence</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change Workflow Status to Pending with Fab User after WWSM Team checks STF Obsolescence Flag as true</description>
        <formula>AND(ISPICKVAL(Reticle_workflow_Status__c,&apos;Pending for STF Obsolescence&apos;),!ISPICKVAL( ROS_Status__c,&apos;&apos;),STF_Obsolence__c==true,OR(ISPICKVAL(ROS_Status__c,&apos;Return&apos;),ISPICKVAL(ROS_Status__c,&apos;Scrap&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Shipping Address Population</fullName>
        <actions>
            <name>ROS_Shipping_Address_Populate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>!ISNULL(Shipping_Address__c) &amp;&amp;  !ISBLANK(Shipping_Address__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Update  Reticle Workflow Status on ROS Status Change</fullName>
        <actions>
            <name>ROS_Dispostion_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ROS_Field_Update_on_ROS_Status_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Change Workflow Status to &apos;Pending for STF Obsolescence&apos;</description>
        <formula>IF (!IsActive__c, AND(OR(ISPICKVAL(ROS_Status__c,&apos;Return&apos;),ISPICKVAL(ROS_Status__c,&apos;Scrap&apos;)),OR(ISPICKVAL(PRIORVALUE(Reticle_workflow_Status__c),&apos;Pending for Customer Feedback&apos;),ISPICKVAL(Reticle_workflow_Status__c,&apos;&apos;)),Draft__c==false), AND(OR(ISPICKVAL(ROS_Status__c,&apos;Return&apos;),ISPICKVAL(ROS_Status__c,&apos;Scrap&apos;)),OR(ISPICKVAL(PRIORVALUE(Reticle_workflow_Status__c),&apos;&apos;),ISPICKVAL(Reticle_workflow_Status__c,&apos;&apos;)),Draft__c==false))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Update Flag on Obselescence by Customer</fullName>
        <actions>
            <name>ROS_Update_Customer_Obsolescence_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISPICKVAL($User.UserType,&apos;Standard&apos;)),ISPICKVAL(PRIORVALUE(ROS_Status__c),&apos;&apos;),NOT(ISPICKVAL(ROS_Status__c,&apos;&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Update WF to Closed on Shipment</fullName>
        <actions>
            <name>ROS_Update_WF_to_Closed_on_Shipment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Updating Workflow Status to Shipped Out once the Reticle AWB Number is updated</description>
        <formula>AND(ISBLANK(PRIORVALUE(AWB_Number__c)),NOT(ISBLANK(AWB_Number__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Update WF to Pending for Shipment</fullName>
        <actions>
            <name>ROS_Update_WF_to_Pending_for_Shipment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update WF Status to Pending for Shipment</description>
        <formula>AND( ISPICKVAL(Reticle_workflow_Status__c, &quot;Pending for Fab&apos;s Follow-up&quot;), !ISBLANK(GE__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Workflow_Close_Date_Update</fullName>
        <actions>
            <name>ROS_FIELD_UPDATE_WF_CLOSE_DATE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Reticle__c.Workflow_End_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Reticle__c.Reticle_workflow_Status__c</field>
            <operation>equals</operation>
            <value>Shipped Out,Scrapped</value>
        </criteriaItems>
        <criteriaItems>
            <field>Reticle__c.ROS_Status__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow will get fired when workflow Status get closed. This will update Workflow Closed Date.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Pending Debit Note Date</fullName>
        <actions>
            <name>Update_Pending_Debit_Note_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Reticle_workflow_Status__c,&apos;Pending Debit Note&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
