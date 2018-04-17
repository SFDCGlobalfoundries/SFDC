<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Unique_Identifier</fullName>
        <description>Populates the Unique Identifier field concatenating the &quot;Order&quot; and &quot;Category Level&quot; fields</description>
        <field>Unique_Identifier__c</field>
        <formula>IF( Category_Level__c = 1, 
     &quot;Sort Order:&quot; + TEXT(Order__c) + &quot;-Level:&quot;  + TEXT(Category_Level__c),
      &quot;Ancestor Sort Order:&quot; +  TEXT(Ancestor_Sort_Order__c)  + &quot;-Sort Order:&quot; + TEXT(Order__c) + &quot;-Level:&quot;  + TEXT(Category_Level__c) + &quot;-Parent Sort Order:&quot; + TEXT( Parent_Employee_Training__r.Order__c)
)</formula>
        <name>Populate Unique Identifier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Employee Training-Populate Unique Identifier</fullName>
        <actions>
            <name>Populate_Unique_Identifier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmployeeTraining__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow populates the Unique Identifier field on each record concatenating the Sort Order and Category Level fields to prevent duplicate records based on the composite Primary Key</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
