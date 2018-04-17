<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>E_Mail_Account_Team_Assignment</fullName>
        <description>E-Mail &quot;Account Team Assignment&quot;</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Account_Team_Assignment</template>
    </alerts>
    <fieldUpdates>
        <fullName>ATP_Fab_Deletion_Sync_Status</fullName>
        <field>Fab_Deletion_Sync_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>ATP - Fab Deletion Sync Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ATP_Martinistore_Status_Message_Sent</fullName>
        <description>Used for integration</description>
        <field>Martinistore_Sync_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>ATP - Martinistore Status Message - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ATP_Siebel_Error_Message_Null</fullName>
        <description>Used by the integration to Siebel
-Clear the previous errors</description>
        <field>Siebel_Error_Message__c</field>
        <name>ATP - Siebel Error Message - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ATP_Siebel_Sent_DateTime_Now</fullName>
        <field>Siebel_Sent_DateTime__c</field>
        <formula>NOW()</formula>
        <name>ATP - Siebel Sent DateTime - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ATP_Siebel_Status_Message_Sent</fullName>
        <description>Used for integration</description>
        <field>Siebel_Status__c</field>
        <literalValue>SENT</literalValue>
        <name>ATP - Siebel Status Message - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ATP_Siebel_Sync_ID_Now</fullName>
        <description>Used for integration to Siebel</description>
        <field>Siebel_Sync_ID__c</field>
        <formula>TEXT(NOW())</formula>
        <name>ATP - Siebel Sync ID - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Account_Team_Proxy_Fab_Delete_To_AIA</fullName>
        <apiVersion>28.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/DeleteATFabsAIAService/DeleteATFabsAIAService_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/DeleteATFabsAIAService/DeleteATFabsAIAService_client</endpointUrl>
        <fields>Account_Short_Name__c</fields>
        <fields>Account__c</fields>
        <fields>CreatedDate</fields>
        <fields>Created_By_HCM_Login_ID__c</fields>
        <fields>Fab_Assignment__c</fields>
        <fields>Fab_Deleted__c</fields>
        <fields>Fab_Deletion_Sync_Status__c</fields>
        <fields>HCM_Login_ID__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>Martinistore_Sync_Status__c</fields>
        <fields>Modified_By_HCM_Login_ID__c</fields>
        <fields>Siebel_Account_ID__c</fields>
        <fields>Siebel_Account_Role_ID__c</fields>
        <fields>Siebel_Operation__c</fields>
        <fields>Siebel_Role__c</fields>
        <fields>Siebel_Sequence__c</fields>
        <fields>Siebel_Sync_ID__c</fields>
        <fields>Team_Role__c</fields>
        <fields>User_First_Name__c</fields>
        <fields>User_Last_Name__c</fields>
        <fields>User_Preferred_Name__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Account Team Proxy Fab Delete To AIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Account_Team_Proxy_To_AIA</fullName>
        <apiVersion>26.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/AccountTeamAIAService/AccountTeamAIAService_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/AccountTeamAIAService/AccountTeamAIAService_client</endpointUrl>
        <fields>Account_Short_Name__c</fields>
        <fields>Account__c</fields>
        <fields>CreatedDate</fields>
        <fields>Created_By_HCM_Login_ID__c</fields>
        <fields>Fab_Assignment__c</fields>
        <fields>HCM_Login_ID__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>Martinistore_Sync_Status__c</fields>
        <fields>Modified_By_HCM_Login_ID__c</fields>
        <fields>Siebel_Account_ID__c</fields>
        <fields>Siebel_Account_Role_ID__c</fields>
        <fields>Siebel_Operation__c</fields>
        <fields>Siebel_Role__c</fields>
        <fields>Siebel_Sequence__c</fields>
        <fields>Siebel_Sync_ID__c</fields>
        <fields>Team_Role__c</fields>
        <fields>User_First_Name__c</fields>
        <fields>User_Last_Name__c</fields>
        <fields>User_Preferred_Name__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Account Team Proxy To AIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Account Team Proxy - Outbound Message - To AIA</fullName>
        <actions>
            <name>Account_Team_Proxy_To_AIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Send the Account proxy only when the Siebel Account ID exists and the record was not updated by the Integration user
Field update actions have been moved to AccountTeamProxy trigger</description>
        <formula>AND( 	NOT(Account__r.RecordType.Name = &apos;IBM Account&apos;), 	OR(  		AND(  			!$Setup.IntegrationUsers__c.Is_Integration_User__c,  			OR (ISNEW(),  			ISCHANGED(Fab_Assignment__c), 			ISCHANGED( Account_Access__c),  			ISCHANGED( Opportunity_Access__c),  			ISCHANGED( Flag_for_Delete__c) ,  			ISCHANGED( Team_Role__c) )  		),  		AND(  			$Setup.IntegrationUsers__c.Is_Integration_User__c,  			ISPICKVAL(Siebel_Status__c, &quot;&quot;)  		),  		ISCHANGED(Batch_Sync_Id__c), 		ISCHANGED(Synch_to_Downstream__c)  	)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Team Proxy Fab Delete - Outbound Message - To AIA</fullName>
        <actions>
            <name>Account_Team_Proxy_Fab_Delete_To_AIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <description>Send the Account proxy only when the Siebel Account ID exists and the record was not updated by the Integration user</description>
        <formula>AND ( 	OR(  		AND( !$Setup.IntegrationUsers__c.Is_Integration_User__c,  NOT(ISBLANK(Fab_Deleted__c)) ),  		AND( $Setup.IntegrationUsers__c.Is_Integration_User__c, ISPICKVAL(Siebel_Status__c, &quot;&quot;), NOT(ISBLANK(Fab_Deleted__c)) ),  		AND( ISCHANGED(Batch_Sync_Id__c), NOT(ISBLANK(Fab_Deleted__c)) )  	), 	NOT(ISBLANK(Account__r.Siebel_Account_ID__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send E-Mail Notification</fullName>
        <actions>
            <name>E_Mail_Account_Team_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
