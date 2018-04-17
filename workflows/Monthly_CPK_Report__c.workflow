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
    <fieldUpdates>
        <fullName>CPK_UpdateFieldAfterApproval_NoReports</fullName>
        <field>Approved__c</field>
        <literalValue>No Reports</literalValue>
        <name>CPK UpdateFieldAfterApproval-NoReports</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DontMoveToProvisioning</fullName>
        <field>Move_To_Provisioning__c</field>
        <literalValue>0</literalValue>
        <name>CPK DontMoveToProvisioning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MoveToProvisioning</fullName>
        <field>Move_To_Provisioning__c</field>
        <literalValue>1</literalValue>
        <name>CPK MoveToProvisioning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_type_Update_on_Monthly_CPK_Report</fullName>
        <field>RecordTypeId</field>
        <lookupValue>MonthlyCPKNoReports</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record type Update on Monthly CPK Report</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldAfterApproval</fullName>
        <field>Approved__c</field>
        <literalValue>Approved</literalValue>
        <name>CPK UpdateFieldAfterApproval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldAfterRejection</fullName>
        <field>Approved__c</field>
        <literalValue>Rejected</literalValue>
        <name>CPK UpdateFieldAfterRejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldBeforeApproval</fullName>
        <field>Approved__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>CPK UpdateFieldBeforeApproval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>MonthlyCPKSubmitForApproval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPK UpdateRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordTypeWithAAttachment</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CPKReportWithAttachment</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPK UpdateRecordTypeWithAAttachment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_After_Approval</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Monthly_CPK_After_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPK Update Record Type After Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>OBMCPKReportMovedToProvisioning</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/MoveObjectService/MoveObjectService_Client_ep</endpointUrl>
        <fields>CPK_Report__c</fields>
        <fields>Id</fields>
        <fields>IsAsic__c</fields>
        <fields>Move_To_Provisioning__c</fields>
        <fields>OpenTextId__c</fields>
        <fields>ParentOpenTextId__c</fields>
        <fields>Source__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>CPK OBMCPKReportMovedToProvisioning</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>OBMCPKReportSubFolder</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/QACreateFolderService/QACreateFolderService_Client_ep</endpointUrl>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>OpenTextId__c</fields>
        <fields>ParentOpenTextId__c</fields>
        <fields>Source__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>CPK OBMCPKReportSubFolder</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CPK CreateCPKReportSubFolder</fullName>
        <actions>
            <name>OBMCPKReportSubFolder</name>
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
        <fullName>CPK MonthlyCPKReportUpdateRecordType</fullName>
        <actions>
            <name>UpdateRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Monthly_CPK_Report__c.Count_Report_Uploaded__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Monthly_CPK_Report__c.Approved__c</field>
            <operation>equals</operation>
            <value>No Reports</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPK ReportWithAttachmentButton</fullName>
        <actions>
            <name>UpdateRecordTypeWithAAttachment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(OpenTextId__c)), AND(ISPICKVAL(PRIORVALUE
(Approved__c), &quot;No Reports&quot;), NOT(ISPICKVAL(Approved__c, &quot;Draft&quot;))), NOT(ISPICKVAL(Approved__c , &quot;No Reports&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>No Reports for Month Record Update</fullName>
        <actions>
            <name>Record_type_Update_on_Monthly_CPK_Report</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Monthly_CPK_Report__c.Reason_for_No_Reports__c</field>
            <operation>equals</operation>
            <value>No WIP,Lots &lt; 10</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
