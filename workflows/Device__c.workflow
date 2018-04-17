<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EmailAlert_for_PSA_and_PSC</fullName>
        <description>EmailAlert for PSA and PSC</description>
        <protected>false</protected>
        <recipients>
            <recipient>kim.tomlinson@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Device_PSA_PSC_ValueTemplate</template>
    </alerts>
    <alerts>
        <fullName>Email_on_ITAR_Classification_Status_Change</fullName>
        <description>Email on ITAR Classification Status Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>ITAR_Classification_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Primary_Device_AM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>TapeOut_AM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/EmailTemplateForDeviceITARStatusChange</template>
    </alerts>
    <fieldUpdates>
        <fullName>Device_Martinistore_Sync_Status_Sent</fullName>
        <description>Used for integration to Martinistore. Updates status to &apos;SENT&apos; to indicate that the record were already sent via outbound message.</description>
        <field>Martinistore_Sync_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>Device - Martinistore Sync Status - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_Populate_Product_TO_Date</fullName>
        <description>Pre-populate Product TO Date with Forecasted Lot Start Date/Original Forecasted Tapeout Date on Device creation.</description>
        <field>Product_TO_Date__c</field>
        <formula>Forecasted_Lot_Start_Date__c</formula>
        <name>Device- Populate Product TO Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_RecType_to_Design_In_ReadOnly</fullName>
        <description>Update device record type to ‘Design In – Read Only’.</description>
        <field>RecordTypeId</field>
        <lookupValue>Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Device - RecType to Design In - ReadOnly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_RecType_to_Device</fullName>
        <description>Set Record type to &apos;Device&apos; when stage is Design In/Tapeout/ Prototype/ RTR/ Production</description>
        <field>RecordTypeId</field>
        <lookupValue>Device</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Device - RecType to Device</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_RecType_to_EOL</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Device - RecType to EOL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_RecType_to_Internal_Device</fullName>
        <description>This field update will Change the the Record Type to Internal Device.</description>
        <field>RecordTypeId</field>
        <lookupValue>Internal_Device</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Device - RecType to Internal Device</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_RecType_to_Production</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Device - RecType to Production</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_RecType_to_Prototyping</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Device - RecType to Prototyping</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_RecType_to_RTR</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Device - RecType to RTR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_RecType_to_ReadOnly</fullName>
        <description>Change Record Type to ‘Read Only’ when status is ‘Void’.</description>
        <field>RecordTypeId</field>
        <lookupValue>Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Device - RecType to ReadOnly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_RecType_to_Tapeout</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Device - RecType to Tapeout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_SetGroup</fullName>
        <description>This field update sets the value of the &quot;Account Region&quot; field with the Region field value of the Account.</description>
        <field>SetGroup__c</field>
        <formula>TEXT(Account__r.Region__c)</formula>
        <name>Device-SetGroup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_Set_Siebel_Device_Id_as_SFDC_Id</fullName>
        <field>Siebel_Device_ID__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Device - Set Siebel Device Id as SFDC Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_Siebel_Error_Message_Null</fullName>
        <description>Used by the integration to Siebel
-Clear the previous error message</description>
        <field>Siebel_Error_Message__c</field>
        <name>Device - Siebel Error Message - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_Siebel_Sent_DateTime_Now</fullName>
        <description>Generates Siebel Sent Date/Time based on current time stamp.</description>
        <field>Siebel_Sent_DateTime__c</field>
        <formula>NOW()</formula>
        <name>Device - Siebel Sent DateTime - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_Siebel_Status_Message_Sent</fullName>
        <description>Used for integration to Siebel. Updates status to &apos;SENT&apos; to indicate that the record were already sent via outbound message.</description>
        <field>Siebel_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>Device - Siebel Status Message - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_Siebel_Sync_ID_Now</fullName>
        <description>Creates a text version of the time stamp. Used for integration to Siebel Used for order management within AIA.</description>
        <field>Siebel_Sync_ID__c</field>
        <formula>TEXT(NOW())</formula>
        <name>Device - Siebel Sync ID - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_Tech_Category</fullName>
        <description>This field update copies the value from the Process_Technology__c field to the Process Technology Copy field</description>
        <field>Process_Technology_Copy__c</field>
        <formula>Process_Technology__c</formula>
        <name>Device-Tech Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_Uncheck_Send_for_Integration</fullName>
        <field>Send_for_Integration__c</field>
        <literalValue>0</literalValue>
        <name>Device - Uncheck Send for Integration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_Update_Currrent_Tapeout_Date</fullName>
        <description>Update ‘Current Forecasted Tapeout Date’ field to the value of the ‘Original Forecasted Tapeout Date’ field.</description>
        <field>Current_Forecast_Tapeout_Date__c</field>
        <formula>Original_Forecasted_Tapeout_Date__c</formula>
        <name>Device - Update Currrent Tapeout Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Device_Update_Geometry_Range</fullName>
        <field>Device_Geometry_Range_Copy__c</field>
        <formula>Device_Geometry_Range__c</formula>
        <name>Device - Update Geometry Range</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RecType_to_Internal_Device_ReadOnly</fullName>
        <description>This field update will Change the the Record Type to Internal Device-Read Only.</description>
        <field>RecordTypeId</field>
        <lookupValue>Internal_Device_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecType to Internal Device ReadOnly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Publish_Report_Flag_to_NO</fullName>
        <field>Publish_Report__c</field>
        <literalValue>No</literalValue>
        <name>Set Publish Report Flag to NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Device_To_AIA</fullName>
        <apiVersion>27.0</apiVersion>
        <endpointUrl>https://test.foundryview.com/aianoauth/soa-infra/services/SF/DeviceAIAService/DeviceAIAService_client</endpointUrl>
        <fields>Account_Short_Name__c</fields>
        <fields>Account__c</fields>
        <fields>Actual_Tapeout_Date_GMT__c</fields>
        <fields>Actual_Tapeout_Date__c</fields>
        <fields>Assigned_Process_ID__c</fields>
        <fields>Assigned_Process_Name__c</fields>
        <fields>Automotive_Device__c</fields>
        <fields>BX041_Status__c</fields>
        <fields>BX041_Submission_Date__c</fields>
        <fields>Base_Device_Device_Id__c</fields>
        <fields>Base_Device__c</fields>
        <fields>CDRS_approval_User__c</fields>
        <fields>CRMDID__c</fields>
        <fields>Confidence_LevelTapeout__c</fields>
        <fields>Confidence_Level_Tapeout__c</fields>
        <fields>Confidence_Level_Volume__c</fields>
        <fields>Configuration__c</fields>
        <fields>Copy_Device_CRMDID__c</fields>
        <fields>Copy_Siebel_Device_ID__c</fields>
        <fields>CreatedBy_HCMLoginID__c</fields>
        <fields>Current_Forecast_Tapeout_Date__c</fields>
        <fields>Customer_Tapeout_Date__c</fields>
        <fields>D1_National_Access_Allowed__c</fields>
        <fields>Device_Base_Id__c</fields>
        <fields>Device_Description__c</fields>
        <fields>Device_ID__c</fields>
        <fields>Device_Mask_Set_Title__c</fields>
        <fields>Device_Purpose__c</fields>
        <fields>Device_Sourcing__c</fields>
        <fields>Device_Type__c</fields>
        <fields>End_Application__c</fields>
        <fields>End_Customer__c</fields>
        <fields>Expected_no_of_Prime_Die__c</fields>
        <fields>Export_Control_Status__c</fields>
        <fields>Export_Control_Waiver_Flag__c</fields>
        <fields>Expose_Device_to_Customer__c</fields>
        <fields>Fab__c</fields>
        <fields>Forecasted_GDSII_Date__c</fields>
        <fields>Forecasted_Lot_Start_Date__c</fields>
        <fields>GSOP_Assignment_Quarter__c</fields>
        <fields>GSOP_Assignment_Tapeout_Plan__c</fields>
        <fields>Geometry__c</fields>
        <fields>IP_Declaration_Status__c</fields>
        <fields>IP_Technology__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>MES_Device_Id__c</fields>
        <fields>Market_Segment__c</fields>
        <fields>Martinistore_Sync_Status__c</fields>
        <fields>Mask_Set_Classification__c</fields>
        <fields>Mask_Set_Title_MPRF__c</fields>
        <fields>Modifiedby_HCMLoginID__c</fields>
        <fields>Name</fields>
        <fields>Opportunity2__c</fields>
        <fields>Original_Forecasted_Tapeout_Date__c</fields>
        <fields>Other_Party_IP_Check__c</fields>
        <fields>PLM_Device_ID__c</fields>
        <fields>PTRF_ID__c</fields>
        <fields>Pre_PTRF_Validation_Status__c</fields>
        <fields>Process_Family__c</fields>
        <fields>Process_ID_Technology__c</fields>
        <fields>Process_Technology_Number__c</fields>
        <fields>Process_Technology__c</fields>
        <fields>Project_Name__c</fields>
        <fields>Proto_Lot_Start_Date__c</fields>
        <fields>Proto_Lot_Start_ID__c</fields>
        <fields>Requested_Process_ID__c</fields>
        <fields>Requested_Process_Name__c</fields>
        <fields>Reticle_Type__c</fields>
        <fields>STF_Process_ID__c</fields>
        <fields>Secure_Device_Level__c</fields>
        <fields>Secure_Device__c</fields>
        <fields>Semiconductor_Device__c</fields>
        <fields>Siebel_Account_ID__c</fields>
        <fields>Siebel_Device_ID__c</fields>
        <fields>Siebel_Error_Message__c</fields>
        <fields>Siebel_Operation__c</fields>
        <fields>Siebel_Opportunity_ID__c</fields>
        <fields>Siebel_Status__c</fields>
        <fields>Siebel_Sync_ID__c</fields>
        <fields>Special_Scribe_Width__c</fields>
        <fields>Stage__c</fields>
        <fields>Starting_Material__c</fields>
        <fields>Status__c</fields>
        <fields>Tapeout_Readiness_Validation_Error__c</fields>
        <fields>Tapeout_Type__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Device To AIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Device - Change Record Type to Design In %E2%80%93 Read Only</fullName>
        <actions>
            <name>Device_RecType_to_Design_In_ReadOnly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Device__c.Stage__c</field>
            <operation>equals</operation>
            <value>Design In</value>
        </criteriaItems>
        <description>Change Record Type to ‘Design In – Read Only’ when Stage is ‘Design In’.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Device - Change Record Type to Device</fullName>
        <actions>
            <name>Device_RecType_to_Device</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Device__c.Stage__c</field>
            <operation>equals</operation>
            <value>Design In,Tapeout,Prototype,RTR,Production</value>
        </criteriaItems>
        <criteriaItems>
            <field>Device__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Read Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Device__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>Change the Record Type to &apos;Device&apos; when Stage is moved to Design In/Tapeout/Prototype/RTR/Production and record type is &apos;Read Only&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Device - Change Record Type to EOL</fullName>
        <actions>
            <name>Device_RecType_to_EOL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Device__c.Stage__c</field>
            <operation>equals</operation>
            <value>EOL</value>
        </criteriaItems>
        <description>Change Record Type to ‘EOL’.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Device - Change Record Type to Production</fullName>
        <actions>
            <name>Device_RecType_to_Production</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Device__c.Stage__c</field>
            <operation>equals</operation>
            <value>Production</value>
        </criteriaItems>
        <description>Change Record Type to ‘Production’.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Device - Change Record Type to Prototyping</fullName>
        <actions>
            <name>Device_RecType_to_Prototyping</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Device__c.Stage__c</field>
            <operation>equals</operation>
            <value>Prototype</value>
        </criteriaItems>
        <description>Change Record Type to ‘Prototyping’.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Device - Change Record Type to RTR</fullName>
        <actions>
            <name>Device_RecType_to_RTR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Device__c.Stage__c</field>
            <operation>equals</operation>
            <value>RTR</value>
        </criteriaItems>
        <description>Change Record Type to ‘RTR’.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Device - Change Record Type to Read Only</fullName>
        <actions>
            <name>Device_RecType_to_ReadOnly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Device__c.Status__c</field>
            <operation>equals</operation>
            <value>Inactive,Void</value>
        </criteriaItems>
        <criteriaItems>
            <field>Device__c.Stage__c</field>
            <operation>equals</operation>
            <value>EOL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Device__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Device</value>
        </criteriaItems>
        <description>Change Record Type to ‘Read Only  when Status is ‘Void’/&apos;Inactive&apos; or the stage is moved to &apos;EOL&apos; and the record type is &apos;Device&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Device - Change Record Type to Tapeout</fullName>
        <actions>
            <name>Device_RecType_to_Tapeout</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Device__c.Stage__c</field>
            <operation>equals</operation>
            <value>Tapeout</value>
        </criteriaItems>
        <description>Change Record Type to ‘Tapeout’.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Device - Outbound Message - To AIA</fullName>
        <actions>
            <name>Device_Martinistore_Sync_Status_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Device_Siebel_Error_Message_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Device_Siebel_Sent_DateTime_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Device_Siebel_Status_Message_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Device_Siebel_Sync_ID_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Device_Uncheck_Send_for_Integration</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Device_To_AIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Integration to Siebel</description>
        <formula>AND(  CONTAINS(Siebel_Device_Complete__c, &apos;TRUE&apos;),  OR(  !$Setup.IntegrationUsers__c.Is_Integration_User__c,  ISCHANGED(Account__c), ISCHANGED(Opportunity2__c),
ISCHANGED(Device_Mask_Set_Title__c),                  
ISCHANGED(CDRS_approval_User__c),
ISCHANGED(Configuration__c),
ISCHANGED(Reticle_Type__c),
ISCHANGED(Opportunity_Program__c),  Send_for_Integration__c  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Device - Set Siebel Device Id</fullName>
        <actions>
            <name>Device_Set_Siebel_Device_Id_as_SFDC_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Name))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Device - Update Current Tapeout Date</fullName>
        <actions>
            <name>Device_Update_Currrent_Tapeout_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Current Forecasted Tapeout Date value from Original Tapeout date for the first time.</description>
        <formula>AND( NOT(ISBLANK(Original_Forecasted_Tapeout_Date__c)), OR(NOT(ISPICKVAL(Tapeout_Type__c, &quot;GlobalShuttle MPW&quot;)),ISBLANK(MPW_Train_Number__c)), OR(ISNEW(), ISBLANK(Current_Forecast_Tapeout_Date__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Device - Update Geometry Range</fullName>
        <actions>
            <name>Device_Update_Geometry_Range</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Device Geometry Range Copy field based of the Device Geometry Range formula field.</description>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Device- Initialize Product TO Date</fullName>
        <actions>
            <name>Device_Populate_Product_TO_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Initialize Product TO Date with Forecasted Lot Start Date on Device creation.</description>
        <formula>!ISBLANK(Forecasted_Lot_Start_Date__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DeviceSet-Sharing Rule_LeadingEdge</fullName>
        <actions>
            <name>Device_SetGroup</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Device_Tech_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Device__c.Process_Technology__c</field>
            <operation>equals</operation>
            <value>Leading Edge</value>
        </criteriaItems>
        <description>If the Process Technology value is &quot;Leading Edge&quot;, then this Workflow fires.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DeviceSet-Sharing Rule_Mainstream</fullName>
        <actions>
            <name>Device_SetGroup</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Device_Tech_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Device__c.Process_Technology__c</field>
            <operation>equals</operation>
            <value>Mainstream</value>
        </criteriaItems>
        <description>If the Process Technology value is &quot;Mainstream&quot;, then this Workflow fires.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DeviceSet-Sharing Rule_Matured</fullName>
        <actions>
            <name>Device_SetGroup</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Device_Tech_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Device__c.Process_Technology__c</field>
            <operation>equals</operation>
            <value>Matured</value>
        </criteriaItems>
        <description>If the Process Technology value is &quot;Matured&quot;, then this Workflow fires.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Internal Device - Change Record Type to Internal Device</fullName>
        <actions>
            <name>Device_RecType_to_Internal_Device</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Device__c.Stage__c</field>
            <operation>equals</operation>
            <value>Design In,Tapeout,Prototype</value>
        </criteriaItems>
        <criteriaItems>
            <field>Device__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Internal Device Read Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Device__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>Set Record Type to Internal Device when Stage is Design In/Tapeout/Prototype.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Internal Device - Change Record Type to Internal Device Read Only</fullName>
        <actions>
            <name>RecType_to_Internal_Device_ReadOnly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Device__c.Stage__c</field>
            <operation>equals</operation>
            <value>EOL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Device__c.Status__c</field>
            <operation>equals</operation>
            <value>Inactive,Void</value>
        </criteriaItems>
        <criteriaItems>
            <field>Device__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Internal Device</value>
        </criteriaItems>
        <description>Change Record Type to ‘Read Only when Status is ‘Void’/&apos;Inactive&apos; or the stage is moved to &apos;EOL&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify on ITAR Classification Status</fullName>
        <actions>
            <name>Email_on_ITAR_Classification_Status_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Is_ITAR__c),     TEXT(PRIORVALUE(Is_ITAR__c)) != TEXT(Is_ITAR__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Publish Report Flag to NO</fullName>
        <actions>
            <name>Set_Publish_Report_Flag_to_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The Publish Report flag should go to No immediately the device stage moved either from Tapeout to Prototype or Prototype to Production or Production to EOL.</description>
        <formula>OR(AND(OR(ISPICKVAL(PRIORVALUE(Stage__c),&apos;Tapeout&apos;),ISPICKVAL(PRIORVALUE(Stage__c),&apos;Design In&apos;)),ISPICKVAL(Stage__c,&apos;Prototype&apos;)),AND(OR(ISPICKVAL(PRIORVALUE(Stage__c),&apos;Prototype&apos;),ISPICKVAL(PRIORVALUE(Stage__c),&apos;RTR&apos;)),ISPICKVAL(Stage__c,&apos;Production&apos;)),AND(ISPICKVAL(PRIORVALUE(Stage__c),&apos;Production&apos;),ISPICKVAL(Stage__c,&apos;EOL&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
