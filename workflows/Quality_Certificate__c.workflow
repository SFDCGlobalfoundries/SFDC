<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>QC_Approval_Done</fullName>
        <description>QC Approval Done</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Quality_Certificate_Approval_Needed</template>
    </alerts>
    <alerts>
        <fullName>QC_Approval_Template</fullName>
        <description>QC Approval Template</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/QC_Approval_required</template>
    </alerts>
    <fieldUpdates>
        <fullName>QC_Record_type_update_after_approval</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CertificationQualityafterUploadQcApproval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>QC Record type update after approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QC_Recordtype_wo_approval</fullName>
        <field>RecordTypeId</field>
        <lookupValue>QC_wo_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>QC Recordtype wo approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quality_Approval_Done</fullName>
        <field>Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>Quality Approval Done</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quality_Approval_Pending</fullName>
        <field>Stage__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Quality Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quality_Approval_Rejected</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>Quality Approval Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordTypeQC</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CertificationQualityWithUploadQc</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>QC UpdateRecordTypeQC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>OBMQualityCertificateCreateFolder</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/QACreateFolderService/QACreateFolderService_Client_ep</endpointUrl>
        <fields>CertificateType__c</fields>
        <fields>Certificate_Type__c</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>OpenTextIdPublish__c</fields>
        <fields>OpenTextId__c</fields>
        <fields>Source__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>QC OBMQualityCertificateCreateFolder</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>QC CreateFolder</fullName>
        <actions>
            <name>OBMQualityCertificateCreateFolder</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>QC WFQualityWithUploadQC</fullName>
        <actions>
            <name>UpdateRecordTypeQC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK(PRIORVALUE(OpenTextId__c)),NOT(ISBLANK( OpenTextId__c )), Approval_Required__c==true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>QC change recordtype on without approval</fullName>
        <actions>
            <name>QC_Record_type_update_after_approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Approval_Required__c==false,ISPICKVAL(Stage__c,&apos;Approved&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>QC wo approval</fullName>
        <actions>
            <name>QC_Recordtype_wo_approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Approval_Required__c==false,NOT(ISPICKVAL(Stage__c,&apos;Approved&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Quality Edit Approval</fullName>
        <actions>
            <name>UpdateRecordTypeQC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>PRIORVALUE(Approval_Required__c)==FALSE &amp;&amp; Approval_Required__c==TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
