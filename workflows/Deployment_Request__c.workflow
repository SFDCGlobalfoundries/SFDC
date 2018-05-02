<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DR_Update_Review_Status_to_Approved</fullName>
        <field>RM_Review_Status_txt__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>DR - Update Review Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_1st_Approver_Response</fullName>
        <field>Approver_Response1__c</field>
        <literalValue>1</literalValue>
        <name>Update 1st Approver Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2nd_Approver_Response</fullName>
        <field>Approver_Response2__c</field>
        <literalValue>1</literalValue>
        <name>Update 2nd Approver Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
