<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ERP_Devices_Email</fullName>
        <description>ERP Devices Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>ERP_Device_SPDBOM_Group_Users</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/ERP_device_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Process_Name_Copy</fullName>
        <description>&quot;Process ID&quot; reference trumps &quot;Process Id Name&quot;.  If &quot;Process ID&quot; is not null then &quot;Process Id Name&quot; will be set to Process ID&apos;s Name.</description>
        <field>Process_Id_Name__c</field>
        <formula>IF( !ISBLANK(Process_ID__c) &amp;&amp; (Process_ID__r.Name &lt;&gt;  Process_Id_Name__c ) , Process_ID__r.Name, Process_Id_Name__c)</formula>
        <name>Process Name Copy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CRMDID</fullName>
        <description>Device&apos;s CRMDID reference trumps ERP Device CRMDID.</description>
        <field>CRMDID__c</field>
        <formula>IF( !ISBLANK(Device__c) &amp;&amp; (Device__r.CRMDID__c &lt;&gt; CRMDID__c), Device__r.CRMDID__c, CRMDID__c)</formula>
        <name>Update CRMDID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_PSC_PSA_Codes_to_Partshub</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/PartsHub/ws/soap/pscpsaupdate;boomi_auth=Z2xvYmFsZm91bmRyaWVzLVlZNU1WODowOWZkNjhiZS1jMTViLTQ0ZjUtYTNkOS1kM2FiOTMxMTYxZGI=</endpointUrl>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>Part_Number__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Send PSC PSA Codes to Partshub</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ERP Device Process and CRMDID Field Update</fullName>
        <actions>
            <name>Process_Name_Copy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Process_ID__r.Name &lt;&gt; Process_Id_Name__c  || Device__r.CRMDID__c &lt;&gt; CRMDID__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email On Creation</fullName>
        <actions>
            <name>ERP_Devices_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ERP_Device__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification of Batch Upload</fullName>
        <actions>
            <name>Send_PSC_PSA_Codes_to_Partshub</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ERP_Device__c.Integration_Status__c</field>
            <operation>equals</operation>
            <value>ReadytoSend</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
