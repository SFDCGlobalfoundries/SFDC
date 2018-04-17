<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EC_Form_Send_Approval_Email</fullName>
        <description>EC Form - Send Approval Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>GTC_Global_Trade_Compliance</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>OwnerId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/ExpControl_Approved_Changed</template>
    </alerts>
    <alerts>
        <fullName>EC_Form_Send_Resub_Email</fullName>
        <description>EC Form - Send Resub Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>GTC_Global_Trade_Compliance</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>OwnerId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Resubmission_of_Export_Control_VF</template>
    </alerts>
    <alerts>
        <fullName>Email_on_D1_Nat_Access_Is_required_updation</fullName>
        <ccEmails>swift@globalfoundries.com.preprod</ccEmails>
        <description>Export Control - D1 National Access Is Required Update</description>
        <protected>false</protected>
        <recipients>
            <recipient>GTC_Global_Trade_Compliance</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Exp_Con_D1_Nat_Acc_Is_Req_Updtd</template>
    </alerts>
    <fieldUpdates>
        <fullName>EC_Form_Reset_Record_Type</fullName>
        <description>Set&apos;s the Export Control Form to Export Control Form Main record type.</description>
        <field>RecordTypeId</field>
        <lookupValue>Export_Control_Form_Main</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>EC Form - Reset Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EC_Form_Update_Submitted_Date</fullName>
        <field>Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>EC Form - Update Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EC_Form_Update_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>EC Form - Update to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EC_Form_Update_to_Pending_Resub</fullName>
        <field>Status__c</field>
        <literalValue>Pending Resubmission</literalValue>
        <name>EC Form - Update to Pending Resub</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EC_Form_Update_to_ReadOnly</fullName>
        <description>Set&apos;s the Export Control Form into Read Only mode.</description>
        <field>RecordTypeId</field>
        <lookupValue>GF_Internal_Lock</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>EC Form - Update to ReadOnly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EC_Form_Update_to_Submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>EC Form - Update to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Export Control Form - D1 National Is Req Acc Updt</fullName>
        <actions>
            <name>Email_on_D1_Nat_Access_Is_required_updation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Status__c,&apos;Approved&apos;), ISCHANGED( D1_National_Access_is_Allowed__c),!$Setup.IntegrationUsers__c.Is_Integration_User__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
