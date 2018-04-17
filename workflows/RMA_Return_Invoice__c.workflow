<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>RMA_RI_CustomerRequestDate_fromRMA</fullName>
        <field>Customer_Request_Date__c</field>
        <formula>RMA__r.Customer_Request_Date__c</formula>
        <name>RMA:RI:CustomerRequestDate:fromRMA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_RI_WaferQty_CSR_9_10</fullName>
        <field>Wafer_Qty_Fab_9_10_CSR_Submission__c</field>
        <formula>LEN(Wafer_Id_Fab_9_10_CSR_Submission__c) - LEN(SUBSTITUTE(Wafer_Id_Fab_9_10_CSR_Submission__c,&quot;;&quot;,&quot;&quot;))/LEN(&quot;;&quot;) /*+ 1*/</formula>
        <name>RMA:RI:WaferQty(CSR-9-10)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_RI_WaferQty_FAB_9_10</fullName>
        <field>Wafer_Qty_Fab_9_10_Fab_Validation__c</field>
        <formula>LEN(Wafer_Id_Fab_9_10_Fab_Validated__c) - LEN(SUBSTITUTE(Wafer_Id_Fab_9_10_Fab_Validated__c,&quot;;&quot;,&quot;&quot;))/LEN(&quot;;&quot;) /*+ 1*/</formula>
        <name>RMA:RI:WaferQty(FAB-9-10)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_RI_WaferQty_Regional_9_10</fullName>
        <field>Wafer_Qty_Fab_9_10_Regional_Validation__c</field>
        <formula>LEN( Wafer_Id_Fab_9_10_Regional_Validated__c ) - LEN(SUBSTITUTE(Wafer_Id_Fab_9_10_Regional_Validated__c ,&quot;;&quot;,&quot;&quot;))/LEN(&quot;;&quot;) /*+ 1*/</formula>
        <name>RMA:RI:WaferQty(Regional-9-10)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_RI_WarrantyPeriod_fromAccount</fullName>
        <field>Warranty_Period__c</field>
        <formula>IF(
!ISBLANK(RMA__r.Customer__r.Warranty_period_for_RMA__c) &amp;&amp;
!ISNULL(RMA__r.Customer__r.Warranty_period_for_RMA__c),
RMA__r.Customer__r.Warranty_period_for_RMA__c,
90)</formula>
        <name>RMA:RI:WarrantyPeriod:fromAccount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Unique_RMA_ReturnInvoice_TEXT</fullName>
        <field>Unique_RMA_ReturnInvoice__c</field>
        <formula>RMA__c + &apos;:&apos; +  Invoice_Number__c  + &apos;:&apos; +  Lot_Number__c</formula>
        <name>RMA:Unique RMA:ReturnInvoice:TEXT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RMA%3A Maintain Uniquess for Return Invoice</fullName>
        <actions>
            <name>RMA_Unique_RMA_ReturnInvoice_TEXT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3ARI%3AWaferQty%28CSR-9-10%29</fullName>
        <actions>
            <name>RMA_RI_WaferQty_CSR_9_10</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(Wafer_Id_Fab_9_10_CSR_Submission__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3ARI%3AWaferQty%28FAB-9-10%29</fullName>
        <actions>
            <name>RMA_RI_WaferQty_FAB_9_10</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Wafer_Id_Fab_9_10_Fab_Validated__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3ARI%3AWaferQty%28Regional-9-10%29</fullName>
        <actions>
            <name>RMA_RI_WaferQty_Regional_9_10</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Wafer_Id_Fab_9_10_Regional_Validated__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3AWarranty and CustomerDate</fullName>
        <actions>
            <name>RMA_RI_CustomerRequestDate_fromRMA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RMA_RI_WarrantyPeriod_fromAccount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
