<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>All_Party_Approved</fullName>
        <field>isAllPartyApproved__c</field>
        <literalValue>1</literalValue>
        <name>All Party Approved?</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_To_Approved</fullName>
        <field>Waiver_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Change Status To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_To_Rejected</fullName>
        <field>Waiver_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Change Status To Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsSubmitForApprovalforInitial</fullName>
        <field>Is_Submit_4_DFM_Apprval__c</field>
        <literalValue>1</literalValue>
        <name>IsSubmitForApprovalforInitial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PTSR_Status_To_Closed</fullName>
        <field>PTSR_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>PTSR Status To Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProgressBarStatus</fullName>
        <field>Progressbar_staus__c</field>
        <formula>&apos;Closed&apos;</formula>
        <name>ProgressBarStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProgressBarStatusForReject</fullName>
        <field>Progressbar_staus__c</field>
        <formula>&apos;Initiated&apos;</formula>
        <name>ProgressBarStatusForReject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProgressBarStatusforInitial</fullName>
        <field>Progressbar_staus__c</field>
        <formula>&apos;Pending for DFM&apos;</formula>
        <name>ProgressBarStatusforInitial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RejectedDFMReport</fullName>
        <description>Indicator</description>
        <field>isAllPartyApproved__c</field>
        <literalValue>0</literalValue>
        <name>Rejected DFM Report</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submit_For_DFM_Approval</fullName>
        <field>Is_Submit_4_DFM_Apprval__c</field>
        <literalValue>0</literalValue>
        <name>Submit For DFM Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Aggregated_Status_To_Rejected</fullName>
        <field>Waiver_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Aggregated Status To Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PTSR_Status</fullName>
        <field>PTSR_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Update PTSR Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PTSR_Status_Rejection</fullName>
        <field>PTSR_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update PTSR Status Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Waiver_Status</fullName>
        <field>Waiver_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Waiver Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Waiver_Status_To_Rejected</fullName>
        <field>Waiver_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Update Waiver Status To Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
