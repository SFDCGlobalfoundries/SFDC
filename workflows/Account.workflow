<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Detail_changed</fullName>
        <description>Account Detail changed</description>
        <protected>false</protected>
        <recipients>
            <recipient>Alert_for_Account_Name_Change</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Detail_change</template>
    </alerts>
    <alerts>
        <fullName>Account_Parent_Account_Change</fullName>
        <description>Account- Parent Account Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>linnie.fong@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>saikhong.saw@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_ParentId_Update</template>
    </alerts>
    <alerts>
        <fullName>EmailOnQualifiedFab9_10Account</fullName>
        <description>EmailOnQualifiedFab9/10Account</description>
        <protected>false</protected>
        <recipients>
            <recipient>gregory.lanzon@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/EmailOnQualifiedFab9_10Account</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_Portal_Admin_for_account_deactivation</fullName>
        <description>Email Notification to Portal Admin for account deactivation</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Customer_Portal_Admin__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Notification_Template_for_In_active_Account</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Primary_CSR</fullName>
        <description>Notification to Primary CSR</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_CSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Notification_Template_to_Primary_CSR_for_approval_change_request</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Account_Approved</fullName>
        <description>Send E-Mail &quot;Account Approved&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Account_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Account_Rejected</fullName>
        <description>Send E-Mail &quot;Account Rejected&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Account_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Account_Submit_for_Approval</fullName>
        <description>Send E-Mail &quot;Account Submit for Approval&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Account_Submit_for_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>AccApproval_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Acc - Approval Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AccStageQualified</fullName>
        <field>Stage__c</field>
        <literalValue>Qualified</literalValue>
        <name>Acc - StageQualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AccStage_Authorized</fullName>
        <field>Stage__c</field>
        <literalValue>Authorized</literalValue>
        <name>Acc -Stage - Authorized</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AccStage_Qualified</fullName>
        <field>Stage__c</field>
        <literalValue>Qualified</literalValue>
        <name>Acc - Stage - Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Approval_Request_Null</fullName>
        <field>Approval_Request__c</field>
        <name>Acc - Approval Request - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Approval_Status_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Acc - Approval Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Approval_Status_Null</fullName>
        <description>Set Approval Status to Null</description>
        <field>Approval_Status__c</field>
        <name>Acc - Approval Status - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Approval_Status_Pending_Approval</fullName>
        <description>Set Account Approval Status to &quot;Pending Approval&quot;</description>
        <field>Approval_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Acc - Approval Status - Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Approval_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Acc - Approval Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_FE_Territory_Null</fullName>
        <field>FE_Territory__c</field>
        <name>Acc - FE Territory - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Martinistore_Status_Message_Sent</fullName>
        <description>Update Martinistore Status to SENT</description>
        <field>Martinistore_Sync_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>Acc - Martinistore Status Message - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Record_Type_Customer</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Customer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Acc - Record Type - Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Record_Type_Enablement_Partner</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Enablement_Partner</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Acc - Record Type - Enablement Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Record_Type_GLOBALFOUNDRIES</fullName>
        <field>RecordTypeId</field>
        <lookupValue>GLOBALFOUNDRIES_Internal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Acc - Record Type - GLOBALFOUNDRIES</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Record_Type_Reseller</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Reseller</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Acc - Record Type - Reseller</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Sales_Territory_Null</fullName>
        <field>Sales_Territory__c</field>
        <name>Acc - Sales Territory - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Siebel_Account_ID_Null</fullName>
        <field>Siebel_Account_ID__c</field>
        <name>Acc - Siebel Account ID - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Siebel_Error_Message_Null</fullName>
        <description>Used for the integration to Siebel
- clear the previous errors</description>
        <field>Siebel_Error_Message__c</field>
        <name>Acc - Siebel Error Message - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Siebel_Sent_DateTime_Now</fullName>
        <description>Set the datetime when the Account is sent to Siebel</description>
        <field>Siebel_Sent_DateTime__c</field>
        <formula>NOW()</formula>
        <name>Acc - Siebel Sent DateTime - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Siebel_Status_Message_Null</fullName>
        <field>Siebel_Status__c</field>
        <name>Acc - Siebel Status Message - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Siebel_Status_Message_Sent</fullName>
        <description>Update Siebel Status to SENT</description>
        <field>Siebel_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>Acc - Siebel Status Message - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Siebel_Sync_ID_Now</fullName>
        <description>Set the Siebel Sync ID to the current date-time - used by the integration</description>
        <field>Siebel_Sync_ID__c</field>
        <formula>TEXT(NOW())</formula>
        <name>Acc - Siebel Sync ID - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Siebel_Sync_ID_Null</fullName>
        <field>Siebel_Sync_ID__c</field>
        <name>Acc - Siebel Sync ID - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_StageQualified</fullName>
        <field>Stage__c</field>
        <literalValue>Qualified</literalValue>
        <name>Acc - Stage - Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Stage_Authorized</fullName>
        <field>Stage__c</field>
        <literalValue>Authorized</literalValue>
        <name>Acc - Stage - Authorized</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Stage_Inactive</fullName>
        <field>Stage__c</field>
        <literalValue>Inactive</literalValue>
        <name>Acc - Stage - Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Stage_Qualified</fullName>
        <field>Stage__c</field>
        <literalValue>Qualified</literalValue>
        <name>Acc - Stage - Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Stage_Unqualified</fullName>
        <field>Stage__c</field>
        <literalValue>Unqualified</literalValue>
        <name>Acc - Stage - Unqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Sub_Type_Direct</fullName>
        <field>Sub_Type__c</field>
        <literalValue>Direct</literalValue>
        <name>Acc - Sub Type - Direct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Sub_Type_Indirect</fullName>
        <field>Sub_Type__c</field>
        <literalValue>Indirect</literalValue>
        <name>Acc - Sub Type - Indirect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Transaction_Type_Non_Transactional</fullName>
        <field>Transaction_Type__c</field>
        <literalValue>Non-Transactional</literalValue>
        <name>Acc - Transaction Type-Non-Transactional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acc_Transaction_Type_Transactional</fullName>
        <field>Transaction_Type__c</field>
        <literalValue>Transactional</literalValue>
        <name>Acc - Transaction Type - Transactional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Approval_Request_Update</fullName>
        <field>Approval_Request__c</field>
        <name>Account Approval Request Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Copy_Owner_Profile</fullName>
        <description>Converts and copies the owners profile name.</description>
        <field>Owner_Profile__c</field>
        <formula>CASE(Owner.Profile.Name,
&apos;PT1&apos;, &apos;System Administrator&apos;, 
&apos;PT2&apos;, &apos;Standard User&apos;, 
&apos;PT3&apos;, &apos;Ready Only&apos;, 
&apos;PT4&apos;, &apos;Solution Manager&apos;, 
&apos;PT5&apos;, &apos;Marketing User&apos;, 
&apos;PT6&apos;, &apos;Contract Manager&apos;, 
&apos;PT7&apos;, &apos;Partner User&apos;, 
&apos;PT8&apos;, &apos;Standard Platform User&apos;, 
&apos;PT9&apos;, &apos;Standard Platform One App User&apos;, 
&apos;PT13&apos;, &apos;Customer Portal User&apos;, 
&apos;PT14&apos;, &apos;Customer Portal Manager&apos;, 
Owner.Profile.Name
)</formula>
        <name>Account - Copy Owner Profile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Stage_Authorized</fullName>
        <field>Stage__c</field>
        <literalValue>Authorized</literalValue>
        <name>Account Stage Authorized</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_change_request_update_set_to_true</fullName>
        <description>FV2:Set the value of Is change request update  to true</description>
        <field>Is_change_request_update__c</field>
        <literalValue>1</literalValue>
        <name>Is change request update set to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Account_OB_Send_NDA_Tech_Geo_to_OpenText</fullName>
        <apiVersion>28.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/SFNDAService/SFNDAService_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFNDAService/SFNDAService_client</endpointUrl>
        <fields>ASIC_Business_Flag__c</fields>
        <fields>ASIC_Flag_Changed__c</fields>
        <fields>Account_Present_In_OT__c</fields>
        <fields>Corporate_Country__c</fields>
        <fields>Financial_Territory__c</fields>
        <fields>Has_Valid_NDA__c</fields>
        <fields>Id</fields>
        <fields>Latest_NDA_Expiration_Date__c</fields>
        <fields>Name</fields>
        <fields>Record_Type_Name__c</fields>
        <fields>Region__c</fields>
        <fields>Short_Name__c</fields>
        <fields>Sub_Type__c</fields>
        <fields>Tech_Geo_Granted__c</fields>
        <fields>Valid_Tech_Geos__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Account OB Send NDA Tech Geo to OpenText</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Account_To_AIA</fullName>
        <apiVersion>26.0</apiVersion>
        <description>https://www.global-foundryview.com/sfaia/soa-infra/services/SF/AccountAIAService/AccountAIAService_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/AccountAIAService/AccountAIAService_client</endpointUrl>
        <fields>Account_Present_In_OT__c</fields>
        <fields>Account_Profile__c</fields>
        <fields>Alias__c</fields>
        <fields>Approval_Request__c</fields>
        <fields>Authorized_Approval_Date__c</fields>
        <fields>Authorized_for_ASIC_business__c</fields>
        <fields>Bill_To_Address_1__c</fields>
        <fields>Bill_To_Address_2__c</fields>
        <fields>Bill_To_Address_3__c</fields>
        <fields>Bill_To_Address_4__c</fields>
        <fields>Bill_To_City__c</fields>
        <fields>Bill_To_Country__c</fields>
        <fields>Bill_To_Location__c</fields>
        <fields>Bill_To_Postal_Zip_Code__c</fields>
        <fields>Bill_To_State__c</fields>
        <fields>Corporate_Address_1__c</fields>
        <fields>Corporate_Address_2__c</fields>
        <fields>Corporate_Address_3__c</fields>
        <fields>Corporate_Address_4__c</fields>
        <fields>Corporate_City__c</fields>
        <fields>Corporate_Country__c</fields>
        <fields>Corporate_Postal_Zip_Code__c</fields>
        <fields>Corporate_State__c</fields>
        <fields>CreatedDate</fields>
        <fields>Created_By_HCM_Login_ID__c</fields>
        <fields>Current_Quarterly_Revenue__c</fields>
        <fields>Customer_Number__c</fields>
        <fields>Customer_Shipping_Label__c</fields>
        <fields>DUNS__c</fields>
        <fields>Disengaged__c</fields>
        <fields>Employees_At_Site__c</fields>
        <fields>Export_Control_Template__c</fields>
        <fields>FE_Territory__c</fields>
        <fields>Financial_Territory__c</fields>
        <fields>Founded__c</fields>
        <fields>Has_Valid_NDA__c</fields>
        <fields>IP_Declaration_Template__c</fields>
        <fields>Id</fields>
        <fields>Inactive_Approval_Date__c</fields>
        <fields>Invoice_Term__c</fields>
        <fields>LastModifiedDate</fields>
        <fields>Latest_NDA_Expiration_Date__c</fields>
        <fields>Market_Segment__c</fields>
        <fields>Martinistore_Sync_Status__c</fields>
        <fields>Modified_By_HCM_Login_ID__c</fields>
        <fields>Name</fields>
        <fields>ParentId</fields>
        <fields>Parent_Account_Short_Name__c</fields>
        <fields>Parent_Siebel_Account_ID__c</fields>
        <fields>Primary_Contact__c</fields>
        <fields>Process_Tech_Interested__c</fields>
        <fields>Publicly_Listed__c</fields>
        <fields>Qualified_Approval_Date__c</fields>
        <fields>Record_Type_Name__c</fields>
        <fields>Region_Head_Backup__c</fields>
        <fields>Region_Head__c</fields>
        <fields>Region__c</fields>
        <fields>Revenue_Potential__c</fields>
        <fields>Sales_Group__c</fields>
        <fields>Sales_Territory__c</fields>
        <fields>Short_Name__c</fields>
        <fields>Siebel_Account_ID__c</fields>
        <fields>Siebel_Operation__c</fields>
        <fields>Siebel_Sync_ID__c</fields>
        <fields>Site_Department__c</fields>
        <fields>Stage__c</fields>
        <fields>Stock_Ticker__c</fields>
        <fields>Sub_Type__c</fields>
        <fields>Sweet_Sixteen__c</fields>
        <fields>Target_Account__c</fields>
        <fields>Tech_Geo_Granted__c</fields>
        <fields>Total_Employee__c</fields>
        <fields>Transaction_Type__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Account To AIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Account - Copy Owner Profile</fullName>
        <actions>
            <name>Account_Copy_Owner_Profile</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow will populate the Owner Profile field based on the Profile of the Owner.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account - Field Update - Approval Status</fullName>
        <actions>
            <name>Acc_Approval_Status_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>or (AND(ISCHANGED(Approval_Request__c), NOT(ISPICKVAL(Approval_Request__c, &quot;&quot;))), and (ISCHANGED( Bill_To_Address_1_Change_Request__c ), not(ISBLANK(Bill_To_Address_1_Change_Request__c ))), and (ISCHANGED( Bill_To_Address_2_Change_Request__c ), not(ISBLANK(Bill_To_Address_2_Change_Request__c ))), and (ISCHANGED( Bill_To_Address_3_Change_Request__c ), not(ISBLANK(Bill_To_Address_3_Change_Request__c ))), and (ISCHANGED( Bill_To_Address_4_Change_Request__c ), not(ISBLANK(Bill_To_Address_4_Change_Request__c ))), and (ISCHANGED( Bill_To_City_Change_Request__c ), not(ISBLANK(Bill_To_City_Change_Request__c ))), and (ISCHANGED( Bill_To_State_Change_Request__c ), not(ispickval(Bill_To_State_Change_Request__c, &quot;&quot;) )), and (ISCHANGED( Bill_To_Postal_Code_Change_Request__c ), not(ISBLANK(Bill_To_Postal_Code_Change_Request__c ))), and (ISCHANGED( Bill_To_Country_Change_Request__c ), not(ispickval(Bill_To_Country_Change_Request__c,&quot;&quot; ))), and (ISCHANGED( Bill_To_Location_Change_Request__c ), not(ISBLANK(Bill_To_Location_Change_Request__c ))), and (ISCHANGED( Account_Name_Change_Request__c ), not(ISBLANK(Account_Name_Change_Request__c ))), and (ISCHANGED( Region_Change_Request__c ), not(ispickval(Region_Change_Request__c,&quot;&quot; ))), and (ISCHANGED( Financial_Territory_Change_Request__c ), not(ispickval(Financial_Territory_Change_Request__c,&quot;&quot; ))), AND(ISCHANGED(New_Organization_Unit_Request__c), NOT(ISPICKVAL(New_Organization_Unit_Request__c, &quot;&quot;))) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account - Outbound Message - To AIA</fullName>
        <actions>
            <name>Account_To_AIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Check if the Siebel Account ID is blank - then it must be a new account</description>
        <formula>if (!ispickval(Stage__c, &quot;Unqualified&quot;),     AND(!$Setup.IntegrationUsers__c.Is_Integration_User__c,         OR(Record_Type_Name__c = &apos;Customer&apos;, Record_Type_Name__c = &apos;Reseller&apos;, Record_Type_Name__c = &apos;Enablement Partner&apos;, Record_Type_Name__c = &apos;GLOBALFOUNDRIES Internal&apos;),         CONTAINS(Siebel_AccountComplete__c, &apos;TRUE&apos;)), AND(!$Setup.IntegrationUsers__c.Is_Integration_User__c,         OR(Record_Type_Name__c = &apos;Customer&apos;, Record_Type_Name__c = &apos;Reseller&apos;, Record_Type_Name__c = &apos;Enablement Partner&apos;, Record_Type_Name__c = &apos;GLOBALFOUNDRIES Internal&apos;),         CONTAINS(Siebel_AccountComplete__c, &apos;TRUE&apos;),         OR(ISNEW(),             ISCHANGED(Account_Profile__c),             ISCHANGED(Disengaged__c),             ISCHANGED(Founded__c),             ISCHANGED(Market_Segment__c),             ISCHANGED(ParentId),             ISCHANGED(Process_Tech_Interested__c),             ISCHANGED(Site_Department__c),             ISCHANGED(Bill_To_Address_1__c),             ISCHANGED(Bill_To_Address_2__c),             ISCHANGED(Bill_To_Address_3__c),             ISCHANGED(Bill_To_Address_4__c),             ISCHANGED(Bill_To_City__c),             ISCHANGED(Bill_To_State__c),             ISCHANGED(Bill_To_Postal_Zip_Code__c),             ISCHANGED(Bill_To_Country__c),             ISCHANGED(Bill_To_Location__c),             ISCHANGED(Name),             ISCHANGED(Region__c),             ISCHANGED(Corporate_Address_1__c),             ISCHANGED(Corporate_Address_2__c),             ISCHANGED(Corporate_Address_3__c),             ISCHANGED(Corporate_Address_4__c),             ISCHANGED(Corporate_City__c),             ISCHANGED(Corporate_State__c),             ISCHANGED(Corporate_Postal_Zip_Code__c),             ISCHANGED(Corporate_Country__c),             ISCHANGED(Tech_Geo_Granted__c),             ISCHANGED(Sub_Type__c),             ISCHANGED(Has_Valid_NDA__c),             ISCHANGED(Authorized_for_ASIC_business__c),             ISCHANGED(Account_Present_In_OT__c),             ISCHANGED(Latest_NDA_Expiration_Date__c),             ISCHANGED(Transaction_Type__c),             ISCHANGED(Short_Name__c),             ISCHANGED(Financial_Territory__c),             ISCHANGED(Invoice_Term__c),             ISCHANGED(Sales_Group__c),             ISCHANGED(Region_Head__c),             ISCHANGED(Description),             ISCHANGED(Region_Head_Backup__c))     ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account - Parent Account Change</fullName>
        <actions>
            <name>Account_Parent_Account_Change</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>OR(ISCHANGED(ParentId), ISCHANGED(Sales_Territory__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account - Record Type - Customer %28on Lead Conversion%29</fullName>
        <actions>
            <name>Acc_Record_Type_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Account_Type__c</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <description>Set Account Record = &quot;Customer&quot;. (Workflow created to set the correct Account Record Type when account is created through Lead Conversion)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account - Record Type - Enablement Partner %28on Lead Conversion%29</fullName>
        <actions>
            <name>Acc_Record_Type_Enablement_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Account_Type__c</field>
            <operation>equals</operation>
            <value>Enablement Partner</value>
        </criteriaItems>
        <description>Set Account Record Type = &quot;Enablement Partner&quot;. (Workflow created to set the correct Account Record Type when account is created through Lead Conversion)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account - Record Type - GLOBALFOUNDRIES Internal %28on Lead Conversion%29</fullName>
        <actions>
            <name>Acc_Record_Type_GLOBALFOUNDRIES</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Account_Type__c</field>
            <operation>equals</operation>
            <value>GLOBALFOUNDRIES Internal</value>
        </criteriaItems>
        <description>Set Account Record Type = &quot;GLOBALFOUNDRIES Internal&quot;. (Workflow created to set the correct Account Record Type when account is created through Lead Conversion)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account - Record Type - Reseller %28on Lead Conversion%29</fullName>
        <actions>
            <name>Acc_Record_Type_Reseller</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Account_Type__c</field>
            <operation>equals</operation>
            <value>Reseller</value>
        </criteriaItems>
        <description>Set Account Record Type = &quot;Reseller&quot;. (Workflow created to set the correct Account Record Type when account is created through Lead Conversion)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account - Reset Fields on Clone</fullName>
        <actions>
            <name>Acc_Approval_Request_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acc_Approval_Status_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acc_Siebel_Account_ID_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acc_Siebel_Error_Message_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acc_Siebel_Status_Message_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acc_Siebel_Sync_ID_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acc_Stage_Unqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set some specific fields to Null when a new record is created. (Mainly applicable when an Account is created using the &quot;Clone&quot; button)</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account WF Send NDA Info to OpenText</fullName>
        <actions>
            <name>Account_OB_Send_NDA_Tech_Geo_to_OpenText</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>FV2.0:This workflow sends NDA information to Open Text when account present in OT checkbox is true.</description>
        <formula>OR(  $Profile.Name == &apos;GF Integration&apos;,  $Profile.Name == &apos;System Administrator&apos;  )   &amp;&amp;   AND(  PRIORVALUE(Account_Present_In_OT__c)==false,  Account_Present_In_OT__c==true  )   &amp;&amp;   AND(  Has_Valid_NDA__c == true,  OR 	( 		NOT(ISBLANK( Valid_Tech_Geos__c ) ),  		NOT(ISBLANK( Tech_Geo_Granted__c ) )  	)	 )  &amp;&amp;   NOT(ISBLANK(Short_Name__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account WF Send Tech Geo to OpenText</fullName>
        <actions>
            <name>Account_OB_Send_NDA_Tech_Geo_to_OpenText</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>AND(
	NOT(Record_Type_Name__c = &apos;IBM Account&apos;),
	$Profile.Name != &apos;GF Integration&apos;,
	OR(
		ISCHANGED( Valid_Tech_Geos__c ),
		ISCHANGED( Tech_Geo_Granted__c ),
		ISCHANGED( Has_Valid_NDA__c ),
		isnew()
	),
	NOT(ISBLANK(Short_Name__c))
)</description>
        <formula>AND(NOT(Record_Type_Name__c = &apos;IBM Account&apos;),     $Profile.Name != &apos;GF Integration&apos;,     OR(         ISCHANGED(Authorized_for_ASIC_business__c),         ISCHANGED(Corporate_Country__c),         ISCHANGED(Financial_Territory__c),         ISCHANGED(Region__c),         ISCHANGED(Sub_Type__c),         ISCHANGED(Account_Present_In_OT__c),         ISCHANGED(Latest_NDA_Expiration_Date__c),         ISCHANGED(Account_Type__c),         ISCHANGED(Valid_Tech_Geos__c),         ISCHANGED(Tech_Geo_Granted__c),         ISCHANGED(Synch_to_Downstream__c),         ISCHANGED(Has_Valid_NDA__c),         isnew()     ),     NOT(ISBLANK(Short_Name__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SendEmailOnAccountQualified</fullName>
        <actions>
            <name>EmailOnQualifiedFab9_10Account</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Stage__c</field>
            <operation>equals</operation>
            <value>Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Fab_9_10__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WFNotifyPortalAdminofAccountDeActivation</fullName>
        <actions>
            <name>Email_Notification_to_Portal_Admin_for_account_deactivation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Stage__c</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Portal_Admin__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FV2:This workflow will send email message to portal admin notifying him of account de-activation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
