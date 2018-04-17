<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CXM_L5_Leadership_Alert</fullName>
        <description>CXM L5 Leadership Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CXM_L5_Senior_Leadership_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLOBALFOUNDRIES/CXM_L5_Leadership_Alert_Template</template>
    </alerts>
    <alerts>
        <fullName>CXM_Regional_VP_Rejection_Alert</fullName>
        <description>CXM_Regional VP Rejection Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Assigned_Resolution_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Escalation_User_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Escalation_User_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Escalation_User_3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLOBALFOUNDRIES/CXM_Regional_VP_Rejection_Template_for_SLT</template>
    </alerts>
    <fieldUpdates>
        <fullName>CXM_L5_Alert_Uncheck_on_Rejection</fullName>
        <field>Alert_Senior_Leadership_Team__c</field>
        <literalValue>0</literalValue>
        <name>CXM_L5 Alert Uncheck on Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_date_Field_Update1</fullName>
        <field>Closed_Date__c</field>
        <formula>NOW()</formula>
        <name>Closed date Field Update1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_date_Field_Update2</fullName>
        <field>Closed_Date__c</field>
        <name>Closed date Field Update2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Action_Owner_field_update</fullName>
        <field>Escalation_User_3__c</field>
        <lookupValue>david.lehtonen@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Action Owner field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalation_Level_Date_Stamp_Update</fullName>
        <field>Escalation_Level_Change_Date__c</field>
        <formula>TODAY()</formula>
        <name>Escalation Level Date Stamp Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_update_when_Res_Owner_Assigned</fullName>
        <field>Stage__c</field>
        <literalValue>Assigned</literalValue>
        <name>Stage update when Res Owner Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_update_when_Res_Owner_Reassigned</fullName>
        <field>Stage__c</field>
        <literalValue>Reassign</literalValue>
        <name>Stage update when Res Owner Reassigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Escalation_Level_value</fullName>
        <field>Escalation_Level__c</field>
        <literalValue>L1 - Customer Action</literalValue>
        <name>Update Escalation Level value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Reset Escalation Level Rule</fullName>
        <actions>
            <name>Update_Escalation_Level_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( TEXT(Escalation_Level__c) &lt;&gt; &quot;L1 - Customer Action&quot; , ISCHANGED( Expected_Close_Date__c ) , Expected_Close_Date__c &gt; TODAY() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Resolution Owner Reassigned Rule</fullName>
        <actions>
            <name>Stage_update_when_Res_Owner_Reassigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( PRIORVALUE(Assigned_Resolution_Owner__c)  &lt;&gt; Assigned_Resolution_Owner__c,  TEXT( Stage__c ) &lt;&gt; &quot;New&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Resolution Owner assigned Rule</fullName>
        <actions>
            <name>Stage_update_when_Res_Owner_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( !ISBLANK(Assigned_Resolution_Owner__c),  ISPICKVAL( Stage__c , &quot;New&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Closed date Rule1</fullName>
        <actions>
            <name>Closed_date_Field_Update1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( !ISPICKVAL( PRIORVALUE(Stage__c) , &quot;Closed&quot;)  , ISPICKVAL(Stage__c , &quot;Closed&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Closed date Rule2</fullName>
        <actions>
            <name>Closed_date_Field_Update2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( PRIORVALUE(Stage__c) , &quot;Closed&quot;)  , !ISPICKVAL(Stage__c , &quot;Closed&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Default Action Owner</fullName>
        <actions>
            <name>Default_Action_Owner_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISBLANK(Escalation_User_3__c) , ISCHANGED(Escalation_User_3__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Escalation Level Change Date Rule</fullName>
        <actions>
            <name>Escalation_Level_Date_Stamp_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( AND(ISNEW(),  !ISNULL(TEXT(Escalation_Level__c)) ) , ISCHANGED(Escalation_Level__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
