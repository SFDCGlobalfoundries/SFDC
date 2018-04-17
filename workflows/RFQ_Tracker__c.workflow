<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_RFQ_Tracker_is_Past_Due</fullName>
        <description>Alert RFQ Tracker is Past Due</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>RFQ_Tracker_POC__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RFQ_Tracker/RFQ_Tracker_is_Past_Due</template>
    </alerts>
    <alerts>
        <fullName>Alert_RFQ_Tracker_is_Past_Due_5_days</fullName>
        <description>Alert RFQ Tracker is Past Due 5 days</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>RFQ_Tracker_POC__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RFQ_Tracker/RFQ_Tracker_is_Past_Due</template>
    </alerts>
    <alerts>
        <fullName>Alert_RFQ_Tracker_is_almost_due</fullName>
        <description>Alert RFQ Tracker is almost due</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>RFQ_Tracker_POC__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RFQ_Tracker/RFQ_Tracker_is_Near_Due</template>
    </alerts>
    <alerts>
        <fullName>Alert_Update_Stage_to_Preparation_for_Pricing</fullName>
        <description>Alert Update Stage to Preparation for Pricing</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>RFQ_Tracker_POC__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RFQ_Tracker/RFQ_Tracker_Stage_Change</template>
    </alerts>
    <alerts>
        <fullName>Alert_Update_Stage_to_Pricing_Approved</fullName>
        <description>Alert Update Stage to Pricing Approved</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>RFQ_Tracker_POC__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RFQ_Tracker/RFQ_Tracker_Stage_Change</template>
    </alerts>
    <alerts>
        <fullName>Alert_Update_Stage_to_Sent_to_Customer</fullName>
        <description>Alert Update Stage to Sent to Customer</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>RFQ_Tracker_POC__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RFQ_Tracker/RFQ_Tracker_Stage_Change</template>
    </alerts>
    <alerts>
        <fullName>Alert_Update_Stage_to_Submit_for_Pricing</fullName>
        <description>Alert Update Stage to Submit for Pricing</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>RFQ_Tracker_POC__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RFQ_Tracker/RFQ_Tracker_Stage_Change</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Stage_to_Preparation_for_Pricing</fullName>
        <field>Stage__c</field>
        <literalValue>2. Preparation for Pricing</literalValue>
        <name>Update Stage to Preparation for Pricing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Pricing_Approved</fullName>
        <field>Stage__c</field>
        <literalValue>4. Pricing Approved</literalValue>
        <name>Update Stage to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Sent_to_Customer</fullName>
        <field>Stage__c</field>
        <literalValue>5. Quote Sent to Customer</literalValue>
        <name>Update Stage to Sent to Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Submit_for_Pricing</fullName>
        <field>Stage__c</field>
        <literalValue>3. Submit for Pricing</literalValue>
        <name>Update Stage to Submit for Pricing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Early Due Date Alert</fullName>
        <active>true</active>
        <criteriaItems>
            <field>RFQ_Tracker__c.Quote_Sent_to_Customer_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Alert_RFQ_Tracker_is_almost_due</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RFQ_Tracker__c.Quote_Needed_by_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Alert_RFQ_Tracker_is_Past_Due</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RFQ_Tracker__c.Quote_Needed_by_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Alert_RFQ_Tracker_is_Past_Due_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RFQ_Tracker__c.Quote_Needed_by_Date__c</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Stage to Preparation for Pricing</fullName>
        <actions>
            <name>Alert_Update_Stage_to_Preparation_for_Pricing</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Stage_to_Preparation_for_Pricing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RFQ_Tracker__c.Stage__c</field>
            <operation>equals</operation>
            <value>1. Customer&apos;s Submission,3. Submit for Pricing,4. Pricing Approved,5. Quote Sent to Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>RFQ_Tracker__c.Preparation_for_Pricing_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RFQ_Tracker__c.Submit_for_Pricing_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RFQ_Tracker__c.Pricing_Approval_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RFQ_Tracker__c.Quote_Sent_to_Customer_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Stage to Pricing Approved</fullName>
        <actions>
            <name>Alert_Update_Stage_to_Pricing_Approved</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Stage_to_Pricing_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RFQ_Tracker__c.Stage__c</field>
            <operation>equals</operation>
            <value>1. Customer&apos;s Submission,2. Preparation for Pricing,3. Submit for Pricing,5. Quote Sent to Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>RFQ_Tracker__c.Pricing_Approval_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RFQ_Tracker__c.Quote_Sent_to_Customer_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Stage to Sent to Customer</fullName>
        <actions>
            <name>Alert_Update_Stage_to_Sent_to_Customer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Stage_to_Sent_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RFQ_Tracker__c.Stage__c</field>
            <operation>equals</operation>
            <value>1. Customer&apos;s Submission,2. Preparation for Pricing,3. Submit for Pricing,4. Pricing Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>RFQ_Tracker__c.Quote_Sent_to_Customer_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Stage to Submit for Pricing</fullName>
        <actions>
            <name>Alert_Update_Stage_to_Submit_for_Pricing</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Stage_to_Submit_for_Pricing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RFQ_Tracker__c.Submit_for_Pricing_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RFQ_Tracker__c.Stage__c</field>
            <operation>equals</operation>
            <value>1. Customer&apos;s Submission,2. Preparation for Pricing,4. Pricing Approved,5. Quote Sent to Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>RFQ_Tracker__c.Pricing_Approval_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RFQ_Tracker__c.Quote_Sent_to_Customer_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
