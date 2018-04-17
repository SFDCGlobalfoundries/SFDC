<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Customer_Satisfaction_Unique_Check</fullName>
        <field>Customer_Satisfaction_Unique_Check__c</field>
        <formula>Merit_Index_for_customers__r.Name + &quot; &quot; + Text( Quarter_New__c ) + &quot; &quot; + Score_Year__c</formula>
        <name>Customer Satisfaction Unique Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_Satisfaction_yearly_scor</fullName>
        <field>Name</field>
        <formula>Merit_Index_for_customers__r.Name + &quot; &quot; +  Score_Year__c + &quot; &quot; + Text(Quarter_New__c)</formula>
        <name>Update Customer Satisfaction yearly scor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Selected_Quarter_Date</fullName>
        <field>Selected_Report_Quarter_Date__c</field>
        <formula>IF(ISPICKVAL(Quarter_New__c, &apos;Q1&apos;),Date(VALUE(Score_Year__c),3,31),
IF(ISPICKVAL(Quarter_New__c, &apos;Q2&apos;),Date(VALUE(Score_Year__c),6,30),
IF(ISPICKVAL(Quarter_New__c, &apos;Q3&apos;),Date(VALUE(Score_Year__c),9,30),
Date(VALUE(Score_Year__c),12,31)
)
)
)</formula>
        <name>Update Selected Quarter Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Customer Satisfaction Score Card Unique Check</fullName>
        <actions>
            <name>Customer_Satisfaction_Unique_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Customer_Satisfaction_yearly_scor</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Selected_Quarter_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Customer Satisfaction Score Card Unique Check</description>
        <formula>AND(NOT(ISBLANK(Merit_Index_for_customers__c)), NOT(ISBLANK( Score_Year__c)), NOT(ISBLANK(Text( Quarter_New__c))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
