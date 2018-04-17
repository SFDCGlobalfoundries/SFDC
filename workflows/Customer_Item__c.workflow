<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Customer_Short_Name</fullName>
        <field>Customer_Short_Name__c</field>
        <formula>IF( !ISBLANK(Customer__c) &amp;&amp; Customer__r.Short_Name__c &lt;&gt; Customer_Short_Name__c, Customer__r.Short_Name__c, Customer_Short_Name__c)</formula>
        <name>Update Customer Short Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ERP_Inventory_Id</fullName>
        <field>ERP_Device_Inventory_Id__c</field>
        <formula>IF( !ISBLANK(ERP_Device__c) &amp;&amp; ERP_Device__r.ERP_Inventory_Id__c &lt;&gt; ERP_Device_Inventory_Id__c , ERP_Device__r.ERP_Inventory_Id__c, ERP_Device_Inventory_Id__c)</formula>
        <name>Update ERP Inventory Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Customer Item Device and Customer Short Name Update</fullName>
        <actions>
            <name>Update_Customer_Short_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_ERP_Inventory_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Customer__r.Short_Name__c &lt;&gt; Customer_Short_Name__c || ERP_Device__r.ERP_Inventory_Id__c &lt;&gt; ERP_Device_Inventory_Id__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
