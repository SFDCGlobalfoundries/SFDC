<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Opportunity_Program_SetGroup</fullName>
        <description>This field update sets the value of the &quot;Account Region&quot; field with the Region field value of the related Account.</description>
        <field>SetGroup__c</field>
        <formula>TEXT(Account__r.Region__c)</formula>
        <name>Opportunity Program-SetGroup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Program_Tech_Category</fullName>
        <description>This field update copies the value from the Process_Technology__c field to the Process Technology Copy field</description>
        <field>Process_Technology_Copy__c</field>
        <formula>Process_Technology__c</formula>
        <name>Opportunity Program-Tech Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity Program-Set Sharing Rule_LeadingEdge</fullName>
        <actions>
            <name>Opportunity_Program_SetGroup</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Program_Tech_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity_Program__c.Process_Technology__c</field>
            <operation>equals</operation>
            <value>Leading Edge</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Program-Set Sharing Rule_Mainstream</fullName>
        <actions>
            <name>Opportunity_Program_SetGroup</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Program_Tech_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity_Program__c.Process_Technology__c</field>
            <operation>equals</operation>
            <value>Mainstream</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Program-Set Sharing Rule_Matured</fullName>
        <actions>
            <name>Opportunity_Program_SetGroup</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Program_Tech_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity_Program__c.Process_Technology__c</field>
            <operation>equals</operation>
            <value>Matured</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
