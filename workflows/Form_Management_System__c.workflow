<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>StateofFormFinal</fullName>
        <field>State_of_the_Form__c</field>
        <formula>&apos;StepPlanComplete&apos;</formula>
        <name>StateofFormFinal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StateofForm_Prelim</fullName>
        <field>State_of_the_Form__c</field>
        <formula>&apos;WaitingForReview&apos;</formula>
        <name>StateofForm Prelim</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_External_Id</fullName>
        <description>Update External Id with main form auto generated number and this external id field was used on dell boomi</description>
        <field>StepPlanExternalID__c</field>
        <formula>Name</formula>
        <name>Update External Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>FMS_to_send_the_status_of_Form</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://test.connect.boomi.com/ws/rest/fmsevent/fmsevent;boomi_auth=Y2xvdWR0ZXN0dXNlckBnbG9iYWxmb3VuZHJpZXMtWVk1TVY4LkhVMkdZQjpjZTYxNWViYy1mNTgyLTQ1ZTUtYTA5Ny1lYjZhZDQ5N2I5NTY=</endpointUrl>
        <fields>Creator_Email__c</fields>
        <fields>FormURL__c</fields>
        <fields>Form_Description__c</fields>
        <fields>Form_Name__c</fields>
        <fields>Form_Type__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Mandatory_State_Change_Comments__c</fields>
        <fields>Name</fields>
        <fields>Previous_State_Of_Form__c</fields>
        <fields>SAP_Account_Number__c</fields>
        <fields>State_of_the_Form__c</fields>
        <fields>eventTypeName__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>FMS - to send the status of Form</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>FMS - To send the status of Form</fullName>
        <actions>
            <name>FMS_to_send_the_status_of_Form</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(State_of_the_Form__c),ISCHANGED(Name))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FMS - UpdateFormStateStepPlanFinal</fullName>
        <actions>
            <name>StateofFormFinal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Form_Management_System__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Step Plan Approval (SP)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Form_Management_System__c.PrelimOrFinal__c</field>
            <operation>equals</operation>
            <value>Final</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FMS UpdateFormStateStepPlanPrelim</fullName>
        <actions>
            <name>StateofForm_Prelim</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Form_Management_System__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Step Plan Approval (SP)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Form_Management_System__c.PrelimOrFinal__c</field>
            <operation>equals</operation>
            <value>Preliminary</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UpdateFMSExternalId</fullName>
        <actions>
            <name>Update_External_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Form_Management_System__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Main Product Definition Form</value>
        </criteriaItems>
        <description>This work flow will update the external id for step plan</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
