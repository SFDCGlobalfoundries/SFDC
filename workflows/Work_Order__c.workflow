<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>QMX_Work_Order_Approved</fullName>
        <description>QMX Work Order Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/QMX_Work_Order_Approved</template>
    </alerts>
    <alerts>
        <fullName>QMX_Work_Order_Rejected</fullName>
        <description>QMX Work Order Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/QMX_Work_Order_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>QMX_Bromont_Partial_Crib</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Bromont Partial Crib</literalValue>
        <name>QMX Bromont Partial Crib</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>QMX Work Order Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_BZone88</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Bromont Zone88</literalValue>
        <name>QMX Work Order BZone88</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_BZone_88</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Bromont Zone88</literalValue>
        <name>QMX Work Order BZone 88</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_Bromont_Zone88</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Bromont Zone88</literalValue>
        <name>QMX Work Order Bromont Zone88</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_Date_Closed</fullName>
        <field>Date_Closed__c</field>
        <formula>TODAY()</formula>
        <name>QMX Work Order Date Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_MFG_Release</fullName>
        <field>Approval_Status__c</field>
        <literalValue>MFG Release</literalValue>
        <name>QMX Work Order MFG Release</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_Manufacturing_Quality</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Manufacturing Quality</literalValue>
        <name>QMX Work Order Manufacturing Quality</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_Mfg_Quality_Operations</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Containment Team</literalValue>
        <name>QMX Work Order Mfg. Quality Operations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_OSAT_BNP</fullName>
        <field>Approval_Status__c</field>
        <literalValue>OSAT BNP First Approval</literalValue>
        <name>QMX Work Order OSAT BNP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_OSAT_BNP2</fullName>
        <field>Approval_Status__c</field>
        <literalValue>OSAT BNP Second Approval</literalValue>
        <name>QMX Work Order OSAT BNP2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_Recalled</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>QMX Work Order Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>QMX Work Order Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_Release_Team</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Release Team</literalValue>
        <name>QMX Work Order Release Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QMX_Work_Order_Zone_88</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Zone 88</literalValue>
        <name>QMX Work Order Zone 88</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ApprovalStatus</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Update_ApprovalStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkOrder_BTV_Routing</fullName>
        <field>Approval_Status__c</field>
        <literalValue>BTV Routing</literalValue>
        <name>WorkOrder BTV Routing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkOrder_CQE</fullName>
        <field>Approval_Status__c</field>
        <literalValue>CQE</literalValue>
        <name>WorkOrder CQE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkOrder_Coordonnatrice_Zone_88</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Zone 88</literalValue>
        <name>WorkOrder Coordonnatrice Zone 88</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkOrder_ITAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>ITAR</literalValue>
        <name>WorkOrder ITAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update_ApprovalStatus</fullName>
        <actions>
            <name>Update_ApprovalStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update QMX WO approval status field when a new record get created</description>
        <formula>AND(!$Setup.IntegrationUsers__c.Is_Integration_User__c, !ISPICKVAL(Approval_Status__c, &apos;Draft&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
