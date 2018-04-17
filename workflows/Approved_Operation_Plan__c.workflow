<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AOP_Value_Year_Unique_Check_field_Update</fullName>
        <field>AOP_Value_Year_Unique_Check__c</field>
        <formula>Merit_Index_for_customers__r.Name +  AOP_Year__c</formula>
        <name>AOP Value Year Unique Check field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AOP_Value And Year Combination Unique Check</fullName>
        <actions>
            <name>AOP_Value_Year_Unique_Check_field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Approved_Operation_Plan__c.AOP_in_M__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Approved_Operation_Plan__c.AOP_Year__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
