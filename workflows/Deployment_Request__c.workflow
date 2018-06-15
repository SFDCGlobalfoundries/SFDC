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
        <fullName>DR_Update_Review_Status_to_Rejected</fullName>
        <field>RM_Review_Status_txt__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>DR - Update Review Status to Rejected</name>
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
    <fieldUpdates>
        <fullName>Update_CAB_Approver</fullName>
        <field>CAB_Approver_Name__c</field>
        <formula>$User.FirstName +&quot; &quot;+$User.LastName</formula>
        <name>Update CAB Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CAB_Approverr</fullName>
        <field>CAB_Approver_Name__c</field>
        <formula>$User.FirstName + $User.LastName</formula>
        <name>Update_CAB_Approverr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DR_CAB_Reviewer</fullName>
        <field>CAB_Approver_Name__c</field>
        <formula>&quot;$User.FirstName&quot;+&quot; &quot;+&quot;$User.LastName&quot;</formula>
        <name>Update_DR_CAB_Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DR_EBIZ_Reviewer</fullName>
        <field>EBIZ_FBO_Approver_Name__c</field>
        <formula>$User.FirstName + $User.LastName</formula>
        <name>Update_DR_EBIZ_Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DR_TA_Reviewer</fullName>
        <field>TA_Approver_Name__c</field>
        <formula>$User.FirstName + $User.LastName</formula>
        <name>Update_DR_TA_Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DR_TFA_Reviewer</fullName>
        <field>TFA_Approver_Name__c</field>
        <formula>$User.FirstName +&quot; &quot;+ $User.LastName</formula>
        <name>Update DR TFA Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_EBIZ_FBO_Approver</fullName>
        <field>EBIZ_FBO_Approver_Name__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>Update EBIZ/FBO Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected_Stage_field</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;TFA Review&quot;</formula>
        <name>Update Rejected Stage field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected_Stage_field_TA</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;TA Review&quot;</formula>
        <name>Update_Rejected_Stage_field_TA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected_Stage_to_CAB_Review</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;CAB Review&quot;</formula>
        <name>Update_Rejected_Stage_to_CAB_Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected_Stage_to_EBiZ_FBO_Review</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;EBiZ/FBO Review&quot;</formula>
        <name>Update Rejected Stage to EBiZ/FBO Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected_Stage_to_SOD_Review</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;SOD Review&quot;</formula>
        <name>Update Rejected Stage to SOD Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected_Stage_to_TA_Review</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;TA Review&quot;</formula>
        <name>Update Rejected Stage to TA Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected_stage_to_Test_Review</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;Test Review&quot;</formula>
        <name>Update Rejected stage to Test Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SOD_Approver</fullName>
        <field>SOD_Approver_Name__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>Update SOD Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SOD_Approver_Update</fullName>
        <field>SOD_Approver_Name__c</field>
        <formula>$User.FirstName + $User.LastName</formula>
        <name>Update_SOD_Approver_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_Approved</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Update_Stage_equals_Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_Approved_Rj</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;CAB Review&quot;</formula>
        <name>Update_Stage_equals_Approved_Rj</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_Approvedd</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Update_Stage_equals_Approvedd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_CAB_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;CAB Review&quot;</formula>
        <name>Update_Stage_equals_CAB_Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_CAB_Review_Rj</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;SOD Review&quot;</formula>
        <name>Update_Stage_equals_CAB_Review_Rj</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_EBiZ_FBO_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;EBiZ/FBO Review&quot;</formula>
        <name>Update_Stage_equals_EBiZ_FBO_Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_Rejected</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Update_Stage_equals_Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_SOD_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;SOD Review&quot;</formula>
        <name>Update_Stage_equals_SOD_Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_SOD_Review_Rj</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;Test Review&quot;</formula>
        <name>Update_Stage_equals_SOD_Review_Rj</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_TA_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;TA Review&quot;</formula>
        <name>Update_Stage_equals_TA_Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_TEST_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;Test Review&quot;</formula>
        <name>Update_Stage_equals_TEST_Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_TEST_Review_Rj</fullName>
        <field>Rejected_Stage__c</field>
        <formula>&quot;EBiZ/FBO Review&quot;</formula>
        <name>Update_Stage_equals_TEST_Review_Rj</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_equals_TFA_Review1</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;TFA Review&quot;</formula>
        <name>Update_Stage_equals_TFA_Review1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Approved</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Update Stage to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_CAB_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;CAB Review&quot;</formula>
        <name>Update Stage to CAB Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Draft</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;Draft&quot;</formula>
        <name>Update Stage to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Draft_Prd</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;Draft&quot;</formula>
        <name>Update_Stage_to_Draft_Prd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_TA_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;TA Review&quot;</formula>
        <name>Update Stage to TA Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_TFA_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;TFA Review&quot;</formula>
        <name>Update Stage to TFA Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_TA_Approver</fullName>
        <field>TA_Approver_Name__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>Update TA Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_TA_Approver_Name</fullName>
        <field>TA_Approver_Name__c</field>
        <formula>&quot; &quot;</formula>
        <name>Update_TA_Approver_Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_TA_Approver_Name_Prd</fullName>
        <field>TA_Approver_Name__c</field>
        <formula>&quot; &quot;</formula>
        <name>Update_TA_Approver_Name_Prd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_TFA_Approver</fullName>
        <field>TFA_Approver_Name__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>Update TFA Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_TFA_Approver_Name</fullName>
        <field>TFA_Approver_Name__c</field>
        <formula>&quot; &quot;</formula>
        <name>Update_TFA_Approver_Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_TFA_Approver_Name_Prd</fullName>
        <field>TFA_Approver_Name__c</field>
        <formula>&quot; &quot;</formula>
        <name>Update_TFA_Approver_Name_Prd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Test_Approver</fullName>
        <field>Test_Approver_Name__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>Update Test Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_stage_to_CAB_Review3</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;CAB Review&quot;</formula>
        <name>Update stage to CAB Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_stage_to_EBiZ_FBO_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;EBiZ/FBO Review&quot;</formula>
        <name>Update stage to EBiZ/FBO Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_stage_to_EBiZ_FBO_Review1</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;EBiZ/FBO Review&quot;</formula>
        <name>Update stage to EBiZ/FBO Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_stage_to_SOD_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;SOD Review&quot;</formula>
        <name>Update stage to SOD Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_stage_to_SOD_Review1</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;SOD Review&quot;</formula>
        <name>Update stage to SOD Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_stage_to_TEST_Review1</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;Test Review&quot;</formula>
        <name>Update stage toTEST Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_stage_to_Test_Review</fullName>
        <field>Stage_txt__c</field>
        <formula>&quot;Test Review&quot;</formula>
        <name>Update stage to Test Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
