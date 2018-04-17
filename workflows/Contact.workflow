<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EmailNotifyPortalContactDeactivation</fullName>
        <description>EmailNotifyPortalContactDeactivation</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Portal_Admin__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Notification_Template_for_Portal_Contact_De_activation</template>
    </alerts>
    <alerts>
        <fullName>EmailWelcomeEmailtoPortalSupplierUser</fullName>
        <description>Welcome Email when a contact is enabled as portal supplier user.</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GLOBALFOUNDRIES/Community_Supplier_User_Welcome_Mail</template>
    </alerts>
    <alerts>
        <fullName>EmailWelcomeEmailtoPortalUser</fullName>
        <description>Welcome Email when a contact is enabled as portal user.</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GLOBALFOUNDRIES/Community_User_Welcome_Mail</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_for_Portal_Contact_Creation</fullName>
        <description>Email Notification for Portal Contact Creation</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Notification_for_Portal_Contact_Creation</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_sent_to_contact_for_contact_edit</fullName>
        <description>FV2:Email notification sent to contact for contact edit</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Notification_Template_for_Portal_Contact_Edit</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Email_alert</fullName>
        <description>Rejection Email alert</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Customer_Portal_Admin__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>FAE__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Primary_CSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Portal_User_Rejection_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Create_Portal_User</fullName>
        <field>Create_Portal_User__c</field>
        <literalValue>1</literalValue>
        <name>Create Portal User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disable_Button_for_Inactive_Portal_Users</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Disable_Portal_User</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Disable Button for Inactive Portal Users</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateContactStatus</fullName>
        <description>FV2 : The Contact Status is update to &apos;Pending Approval&apos; once it is created from Chatter Community by Portal Admin users.</description>
        <field>Status__c</field>
        <literalValue>Pending approval</literalValue>
        <name>FUUpdateContactStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateContactStatusDraft</fullName>
        <description>FV2 : The Contact Status is update to &apos;Draft&apos; once it is created from Chatter Community by Portal Admin users.</description>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>FUUpdateContactStatusDraft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateDescription</fullName>
        <description>Fv2 : The field Description will be populated with Additional Comments value.</description>
        <field>Description</field>
        <formula>LeadAdditionalComments__c</formula>
        <name>FUUpdateDescription</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Change_Log_field_of_contact</fullName>
        <description>FV2:Update the change log field of contact when contact is edited bu portal admin users</description>
        <field>Change_Log__c</field>
        <formula>IF(ischanged( Address_1__c ),&quot;Address 1: From &quot; &amp; PRIORVALUE(Address_1__c ) &amp; &quot; To &quot; &amp; Address_1__c  , &apos;&apos;)

&amp; BR()  &amp;  IF(ischanged(Address_2__c), &quot;Address 2: From &quot; &amp; PRIORVALUE(Address_2__c ) &amp; &quot; To &quot; &amp; Address_2__c , &apos;&apos;)

&amp; BR()  &amp;  IF(ischanged(Address_3__c), &quot;Address 3: From &quot; &amp; PRIORVALUE(Address_3__c) &amp; &quot; To &quot; &amp; Address_3__c, &apos;&apos;)

&amp; BR()  &amp;  IF(ischanged(Address_4__c), &quot;Address 4: From &quot; &amp; PRIORVALUE(Address_4__c) &amp; &quot; To &quot; &amp; Address_4__c, &apos;&apos;)

&amp; BR()  &amp;  IF(ischanged( City__c ), &quot;City: From &quot; &amp; PRIORVALUE(City__c ) &amp; &quot; To &quot; &amp; City__c   , &apos;&apos;)

&amp; BR()  &amp;  IF(ischanged(Country_Text_Value__c ), &quot;Country: From &quot; &amp; PRIORVALUE(Country_Text_Value__c ) &amp; &quot; To &quot; &amp; Country_Text_Value__c   , &apos;&apos;)

&amp; BR()  &amp;  IF(ischanged(Postal_Zip_Code__c ), &quot;Postal/Zip Code: From &quot; &amp; PRIORVALUE(Postal_Zip_Code__c ) &amp; &quot; To &quot; &amp; Postal_Zip_Code__c   , &apos;&apos;) 

&amp; BR()  &amp; IF(ischanged( Phone), &quot;Phone: From &quot; &amp; PRIORVALUE(Phone ) &amp; &quot; To &quot; &amp; Phone   , &apos;&apos;)
&amp; BR()  &amp;  IF(ischanged( MobilePhone), &quot;Mobile: From &quot; &amp; PRIORVALUE(MobilePhone) &amp; &quot; To &quot; &amp;  MobilePhone, &apos;&apos;)</formula>
        <name>Update Change Log field of contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Country_Text_Value_field</fullName>
        <description>FV2:Used to update the field Country_Text_Value__c from Country picklist</description>
        <field>Country_Text_Value__c</field>
        <formula>TEXT(Country__c)</formula>
        <name>Update Country Text Value field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_Contact_Status_to_Inactive</fullName>
        <description>FV2: Contact Status field set to Inactive</description>
        <field>Status__c</field>
        <literalValue>Inactive</literalValue>
        <name>Update field Contact Status to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_Contact_Status_to_active</fullName>
        <description>FV2:Field update</description>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Update field Contact Status to active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_again_reactivated</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Reactivated_User</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>User again reactivated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>OBMContactinfoToAIA</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When a Contact will be enabled as a portal user, this outbound message will be sent to AIA endpoint carrying all the contact fields to be ultimately synced to Martini Store</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/ContactAIAService/ContactAIAService_client</endpointUrl>
        <fields>AccountId</fields>
        <fields>Account_Short_Name__c</fields>
        <fields>CreatedByHCMLoginId__c</fields>
        <fields>Email</fields>
        <fields>FTP__c</fields>
        <fields>Fax</fields>
        <fields>FirstName</fields>
        <fields>Id</fields>
        <fields>Is_Portal_User_Active__c</fields>
        <fields>Is_Portal_User_Created__c</fields>
        <fields>LastModifiedByHCMLoginId__c</fields>
        <fields>LastName</fields>
        <fields>Login_Id__c</fields>
        <fields>Phone</fields>
        <fields>Role__c</fields>
        <fields>Title</fields>
        <fields>User_Federation_ID__c</fields>
        <fields>User_Name__c</fields>
        <fields>User_Profile_Name__c</fields>
        <fields>User_Time_Zone__c</fields>
        <fields>ftplocation__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OBMContactinfoToAIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>SendContactFTPExtAppToAIA</fullName>
        <actions>
            <name>OBMContactinfoToAIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>AND(ISCHANGED( FTP__c),NOT(Is_Portal_User_Active__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Country Text Value</fullName>
        <actions>
            <name>Update_Country_Text_Value_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Country__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FV2: Used to update the Country_Text_Value__c from Country_c</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WF Contact Portal Supplier User Welcome Mail</fullName>
        <actions>
            <name>EmailWelcomeEmailtoPortalSupplierUser</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>This workflow is used to send Welcome Email to supplier users which are already created at Martini Store and LDAP end. This workflow criteria should be modified when existing users are portal enabled at SFDC and we want to send Welcome email from SFDC.</description>
        <formula>AND(Is_Portal_User_Active__c, Is_Portal_User_Created__c, OR(LastModifiedById  =  &apos;005900000010YhWAAU&apos;,LastModifiedById  =  &apos;005900000010YhW&apos;),FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WF Contact Portal User Welcome Mail</fullName>
        <actions>
            <name>EmailWelcomeEmailtoPortalUser</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>This workflow is used to send Welcome Email to users which are already created at Martini Store and LDAP end. This workflow criteria should be modified when existing users are portal enabled at SFDC and we want to send Welcome email from SFDC.</description>
        <formula>AND(Is_Portal_User_Active__c, Is_Portal_User_Created__c, OR(LastModifiedById  =  &apos;005900000010YhWAAU&apos;,LastModifiedById  =  &apos;005900000010YhW&apos;),FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WF Disable Portal User Button for Portal Admins and Users</fullName>
        <actions>
            <name>Disable_Button_for_Inactive_Portal_Users</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Is_Portal_User_Active__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WF Enable Portal User Button for Portal Admins and Users</fullName>
        <actions>
            <name>User_again_reactivated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Is_Portal_User_Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFNotifyPortalContactChanges</fullName>
        <actions>
            <name>Email_notification_sent_to_contact_for_contact_edit</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>FV2:This workflow will set changed field values in Change Log field of contact to null and sends email notification to contact using the template Email Notification Template for Portal Contact Edit.</description>
        <formula>ISCHANGED( Change_Log__c ) &amp;&amp;  NOT(ISNULL(Change_Log__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFNotifyPortalContactDeactivation</fullName>
        <actions>
            <name>EmailNotifyPortalContactDeactivation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>FV2 : This workflow will send email notification to account portal admin using the template Email Notification Template for Portal Contact De-activation.</description>
        <formula>If(PRIORVALUE( Is_Portal_User_Active__c )=True,True,False) &amp;&amp; Is_Portal_User_Active__c=False &amp;&amp;  NOT(  ISPICKVAL(Account.Stage__c, &apos;Inactive&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFPopulateContactDescription</fullName>
        <actions>
            <name>FUUpdateDescription</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.LeadAdditionalComments__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FV2 : This workflow is used for populating Description field of Contact from Additional Comments field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFPopulateContactStatus</fullName>
        <actions>
            <name>FUUpdateContactStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FV2 : This workflow is used for setting Contact Status &quot;Pending Aprroval&quot; when a Contact is sent for approval from Chatter Community by an Admin Portal user to automate Portal User Creation.</description>
        <formula>LastName  &lt;&gt; null &amp;&amp; ($Profile.Name  = &apos;Customer Portal Admin&apos;  || $Profile.Name  = &apos;Reseller Portal Admin&apos; || $Profile.Name  = &apos;Enablement Partner Portal Admin&apos; ||  $Profile.Name = &apos;Overage Customer Portal Admin&apos; ||  $Profile.Name = &apos;Overage Enablement Partner Portal Admin&apos; ||  $Profile.Name = &apos;Overage Reseller Portal Admin&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WFPopulateContactStatusDraft</fullName>
        <actions>
            <name>FUUpdateContactStatusDraft</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FV2 : This workflow is used for setting Contact Status &quot;Draft&quot; when a Contact is created from Chatter Community by an Admin Portal user.</description>
        <formula>LastName  &lt;&gt; null &amp;&amp; ($Profile.Name  = &apos;Customer Portal Admin&apos;  || $Profile.Name  = &apos;Reseller Portal Admin&apos; || $Profile.Name  = &apos;Enablement Partner Portal Admin&apos; ||  $Profile.Name = &apos;Overage Customer Portal Admin&apos; ||  $Profile.Name = &apos;Overage Enablement Partner Portal Admin&apos; ||  $Profile.Name = &apos;Overage Reseller Portal Admin&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WFSendContactinfoToAIA</fullName>
        <actions>
            <name>OBMContactinfoToAIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a Contact record is enabled or disabled as a portal user or application deleted in GF, this workflow will be triggered which will in turn send an outbound message OBMContactinfoToAIA to AIA.</description>
        <formula>AND(( !$Setup.IntegrationUsers__c.Is_Integration_User__c),
CASESAFEID(AccountId) &lt;&gt; &apos;0019000000Lp3YnAAJ&apos; 
, OR(ISNEW() 
, ISCHANGED(Is_Portal_User_Active__c) 
, ISCHANGED( SynchToDownstream__c ) 
, ISCHANGED(Is_Portal_User_Created__c) 
, ISCHANGED(Email) 
, ISCHANGED( ftplocation__c) 
, ISCHANGED(Fax) 
, ISCHANGED(FirstName) 
, ISCHANGED(Login_Id__c) 
, ISCHANGED(LastName) 
, ISCHANGED(Phone) 
, ISCHANGED(Role__c) 
, ISCHANGED(Title) 
, ISCHANGED(User_Name__c) 
, ISCHANGED(User_Profile_Name__c) 
, ISCHANGED(User_Time_Zone__c) 
, ISCHANGED(FTP__c) 
, ISCHANGED(Description) 
, ISCHANGED(AccountId) 
, ISCHANGED(Status__c)) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFcapturePortalContactChanges</fullName>
        <actions>
            <name>Update_Change_Log_field_of_contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FV2:This workflow will update the Change log field with the prior and new values of contact fields</description>
        <formula>OR(  LastModifiedBy.Profile.Name =&apos;Customer Portal Admin&apos;,  LastModifiedBy.Profile.Name =&apos;Enablement Partner Portal Admin&apos;,  LastModifiedBy.Profile.Name =&apos;Reseller Portal Admin&apos;,  LastModifiedBy.Profile.Name =&apos;Supplier Portal Admin&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
