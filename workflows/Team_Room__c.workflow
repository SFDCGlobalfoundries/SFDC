<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_for_Team_Room_Creation</fullName>
        <description>Email Notification for Team Room Creation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Notification_Template_for_New_Team_Room_Creation</template>
    </alerts>
    <outboundMessages>
        <fullName>OBMCreationOfTeamRoom</fullName>
        <apiVersion>27.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/SFTeamRoomService/SFTeamRoomService_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFTeamRoomService/SFTeamRoomService_client</endpointUrl>
        <fields>Created_By_Short_Name__c</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>OT_Id__c</fields>
        <fields>Team_Room_Description__c</fields>
        <fields>Team_Room_Type__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OBMCreationOfTeamRoom</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>WFTeamRoomCreation</fullName>
        <actions>
            <name>Email_Notification_for_Team_Room_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>FV2 : Email notification is sent to Primary CSR &amp; Account Owner on creation of Team Room from Portal.</description>
        <formula>($Profile.Name  = &apos;Customer Portal Admin&apos;  || $Profile.Name  = &apos;Customer Portal Profile&apos;  || $Profile.Name  = &apos;Enablement Partner Portal Admin&apos;  || $Profile.Name  = &apos;Enablement Partner Portal Profile&apos;  || $Profile.Name  = &apos;Reseller Portal Admin&apos;  || $Profile.Name  = &apos;Reseller Portal Profile&apos;  || $Profile.Name  = &apos;Supplier Portal Admin&apos;  || $Profile.Name  = &apos;Supplier Portal Profile&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WFTeamRoomCreationOBM</fullName>
        <actions>
            <name>OBMCreationOfTeamRoom</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>FV2 : Outbound Message is sent for Team Room Creation</description>
        <formula>AND($Profile.Name != &apos;GF Integration&apos;, RecordType.DeveloperName != &apos;Pre_FV2_Teamroom&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
