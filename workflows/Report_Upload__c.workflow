<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CPK_Report_Email_Alert_to_Approver</fullName>
        <description>CPK Report Email Alert to Approver</description>
        <protected>false</protected>
        <recipients>
            <field>QA_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approve_Report_Uploaded</template>
    </alerts>
    <alerts>
        <fullName>CPK_Report_Rejected</fullName>
        <description>CPK Report Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CPK_Report_Rejected</template>
    </alerts>
    <alerts>
        <fullName>CPK_Report_Verified</fullName>
        <description>CPK Report Verified</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CPK_Report_Verified</template>
    </alerts>
    <outboundMessages>
        <fullName>OBMCPKReportUrl</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/UserInfoService/UserInfoService_Client_ep</endpointUrl>
        <fields>File_Name__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>OpenTextId__c</fields>
        <fields>ParentOpenTextId__c</fields>
        <fields>Short_Name__c</fields>
        <fields>Source__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>CPK OBMCPKReportUserInfo</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CPK ReportUploadUrl</fullName>
        <actions>
            <name>OBMCPKReportUrl</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK(OpenTextId__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
