<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Customer_Case_Re_open_Request_Email_Alert_for_SFDC_Support</fullName>
        <description>Customer Case Re-open Request Email Alert for SFDC Support</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager (Internal)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Customer_Case_Re_Open_Request_for_SFDC_Support</template>
    </alerts>
    <alerts>
        <fullName>Customer_Case_Survey_Submitted</fullName>
        <description>Customer Case Survey Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Case_Survey_Result_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Case_Reopen_Request_Date</fullName>
        <field>Reopen_Request_Date__c</field>
        <formula>Now()</formula>
        <name>Case Reopen Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reopen_Request_Field</fullName>
        <description>This will update Reopen_Request_Status__c field as Submitted.</description>
        <field>Reopen_Request_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Case Reopen Request Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Resolution_Score_Field_Update</fullName>
        <description>This field update will Update the Case Resolution Score field as Resolution Score of Customer Survey Object at the time of Customer Survey Creation .</description>
        <field>Case_Resolution_Score__c</field>
        <formula>Resolution_Score__c</formula>
        <name>Case Resolution Score Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Satisfication_Score_Field_Update</fullName>
        <description>This field update will Update the Case Satisfication Score field as Satisfication Score Field of Customer Survey Object at the time of Customer Survey Creation .</description>
        <field>Case_Satisfication_Score__c</field>
        <formula>Survey_Score__c</formula>
        <name>Case Satisfication Score Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Survey_Comments_Field_Update</fullName>
        <description>This field update will Update the Survey Comments field as Survey Comments Field of Customer Survey Object at the time of Customer Survey Creation .</description>
        <field>Survey_Comments__c</field>
        <formula>IF( LEN( Survey_Comments__c ) &gt;250, LEFT(Survey_Comments__c, 250)+&apos; ..&apos; , Survey_Comments__c)</formula>
        <name>Case Survey Comments Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_isReopenBySurvey_Field_Update_Open</fullName>
        <description>This Field Update will update the Field Update check box to true when Case is Open.</description>
        <field>isReopenBySurvey__c</field>
        <literalValue>1</literalValue>
        <name>Case isReopenBySurvey Field Update Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_re_Open_By_Field_Update</fullName>
        <description>This field update will Update the Name of the Case Re-Open Survey Creator at the time of Customer Survey Creation .</description>
        <field>Survey_re_Open_User__c</field>
        <formula>Record_Owner__r.FirstName + &apos; &apos; +Record_Owner__r.LastName</formula>
        <name>Case re-Open By Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Survey_re_Open_Case</fullName>
        <description>This field update will turn the Case status into re-Open status, customer wants to reopen the Case from Survey.</description>
        <field>Status</field>
        <literalValue>Reopen</literalValue>
        <name>Customer Survey re-Open Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Customer Case Survey Submitted</fullName>
        <actions>
            <name>Customer_Case_Survey_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>CustomerSurvey__c.Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This Workflow rule will send the survey result to Case Owner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Survey re-Open Case</fullName>
        <actions>
            <name>Case_Reopen_Request_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Reopen_Request_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Resolution_Score_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Satisfication_Score_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Survey_Comments_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_isReopenBySurvey_Field_Update_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_re_Open_By_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow rule will update the Case status into re-Open, customer wants to reopen the Case from Survey.</description>
        <formula>Case_re_open__c ==true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
