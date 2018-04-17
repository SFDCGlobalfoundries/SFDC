<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Status_to_Validated_Internal</fullName>
        <field>ValidationStatus</field>
        <literalValue>Validated Internal</literalValue>
        <name>Change Status to Validated Internal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_status_to_WIP</fullName>
        <description>Sets Validation Status to match Publication Status for draft articles</description>
        <field>ValidationStatus</field>
        <literalValue>Work in Progress</literalValue>
        <name>Set TS status to WIP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_status_to_WIP_from_Ext</fullName>
        <field>ValidationStatus</field>
        <literalValue>Work in Progress</literalValue>
        <name>Set TS status to WIP from Ext</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Cust_box</fullName>
        <description>Uncheck Cust box</description>
        <field>IsVisibleInCsp</field>
        <literalValue>0</literalValue>
        <name>Uncheck Cust box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_PKB_box</fullName>
        <description>Uncheck PKB box</description>
        <field>IsVisibleInPkb</field>
        <literalValue>0</literalValue>
        <name>Uncheck PKB box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Partner_box</fullName>
        <description>Uncheck Partner box</description>
        <field>IsVisibleInPrm</field>
        <literalValue>0</literalValue>
        <name>Uncheck Partner box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publish_Troubleshooting_Article</fullName>
        <action>PublishAsNew</action>
        <description>Publish action for new Troubleshooting articles</description>
        <label>Publish Troubleshooting Article</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <rules>
        <fullName>Knowledge%3A TS set status</fullName>
        <actions>
            <name>Set_TS_status_to_WIP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Troubleshooting__kav.PublishStatus</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <description>Sets Validation Status to match Publication Status for draft articles</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Knowledge%3A Troubleshooting keep internal</fullName>
        <actions>
            <name>Uncheck_Cust_box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_PKB_box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Partner_box</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Troubleshooting__kav.IsVisibleInPkb</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Troubleshooting__kav.IsVisibleInCsp</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Troubleshooting__kav.IsVisibleInPrm</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sets Channel Status to internal only</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Knowledge%3A Troubleshooting prevent setting Validated External</fullName>
        <actions>
            <name>Set_TS_status_to_WIP_from_Ext</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Troubleshooting__kav.ValidationStatus</field>
            <operation>equals</operation>
            <value>Validated External</value>
        </criteriaItems>
        <description>Sets Validation Status back from Validated External to WIP</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
