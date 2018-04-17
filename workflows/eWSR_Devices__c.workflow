<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>eWSR_Update_Fab_String_field_eWSR_Dev</fullName>
        <field>Fab_String__c</field>
        <formula>IF( INCLUDES( Fab__c, &quot;FAB 2&quot;), &quot;FAB 2 &quot;,&quot;&quot;)
&amp;
IF( INCLUDES( Fab__c, &quot;FAB 3&quot;), &quot;FAB 3 &quot;, &quot;&quot;)
&amp;
IF( INCLUDES( Fab__c, &quot;FAB 3E&quot;), &quot;FAB 3E &quot;,&quot;&quot;)
&amp;
IF( INCLUDES( Fab__c, &quot;FAB 5&quot;), &quot;FAB 5 &quot;, &quot;&quot;)
&amp;
IF( INCLUDES( Fab__c, &quot;FAB 6&quot;), &quot;FAB 6 &quot;, &quot;&quot;)
&amp;
IF( INCLUDES( Fab__c, &quot;FAB 7&quot;), &quot;FAB 7 &quot;, &quot;&quot;)</formula>
        <name>eWSR Update Fab String field eWSR Dev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>eWSR Update Fab String field</fullName>
        <actions>
            <name>eWSR_Update_Fab_String_field_eWSR_Dev</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>eWSR_Devices__c.Fab__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This will update the Fab String field in eWSR Device with multiselect field Fab</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
