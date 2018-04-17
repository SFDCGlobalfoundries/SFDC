<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PNP_Release_TAE_Approval_Complete</fullName>
        <ccEmails>tim.curtin+pnp_release_complete@globalfoundries.com</ccEmails>
        <description>PNP_Release TAE Approval Complete</description>
        <protected>false</protected>
        <recipients>
            <recipient>PNP_Release_Group_BI</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>PNP_Release_Group_PM</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>PNP_Release_Group_TAE</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PNP_Releases/PNP_Release_Complete_email</template>
    </alerts>
    <alerts>
        <fullName>PNP_Release_recall_notification</fullName>
        <ccEmails>tim.curtin+pnp_release_approval_recall@globalfoundries.com</ccEmails>
        <description>PNP_Release recall notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>PNP_Release_Group_PM</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>PNP_Release_Group_TAE</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PNP_Releases/PNP_Release_Approval_Recalled_email</template>
    </alerts>
    <fieldUpdates>
        <fullName>PNP_Release_Populate_prod_id_from_atdb</fullName>
        <field>xATdb_product_id__c</field>
        <formula>ATdb_ProductInfo__r.xATdb_product_id__c</formula>
        <name>PNP_Release Populate prod_id from atdb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Populate_prod_nam_from_atdb</fullName>
        <field>Product_Name__c</field>
        <formula>ATdb_ProductInfo__r.prod_name__c</formula>
        <name>PNP_Release Populate prod_nam from atdb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Populate_tech_from_atdb</fullName>
        <field>Tech__c</field>
        <formula>ATdb_ProductInfo__r.design_system__c</formula>
        <name>PNP_Release Populate tech from atdb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Stage_to_Complete</fullName>
        <field>PNP_Release_Stage__c</field>
        <literalValue>Complete</literalValue>
        <name>PNP_Release Stage to Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Stage_to_New</fullName>
        <field>PNP_Release_Stage__c</field>
        <literalValue>New</literalValue>
        <name>PNP_Release Stage to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Stage_to_OSAT_Accepted</fullName>
        <field>PNP_Release_Stage__c</field>
        <literalValue>OSAT Accepted</literalValue>
        <name>PNP_Release Stage to OSAT Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Stage_to_OSAT_Done</fullName>
        <field>PNP_Release_Stage__c</field>
        <literalValue>OSAT Done</literalValue>
        <name>PNP_Release Stage to OSAT Done</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Stage_to_Sent</fullName>
        <field>PNP_Release_Stage__c</field>
        <literalValue>Sent</literalValue>
        <name>PNP_Release Stage to Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Update_Ack</fullName>
        <description>Check Acknowledged field when selected lot has been input</description>
        <field>Acknowledge__c</field>
        <literalValue>1</literalValue>
        <name>PNP_Release Update Ack</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Update_Ack_By</fullName>
        <field>Acknowledged_By__c</field>
        <formula>$User.FirstName 
&amp; &quot; &quot; 
&amp; $User.LastName 
&amp; &quot; (&quot; 
&amp; $User.Email 
&amp; &quot;) &quot; 
&amp; &quot;at &quot; &amp; TEXT(NOW())</formula>
        <name>PNP_Release Update Ack By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Update_Mark_Complete</fullName>
        <description>Mark Completed when Approved by TAE</description>
        <field>Complete__c</field>
        <literalValue>1</literalValue>
        <name>PNP_Release Update Mark Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNP_Release_Update_Marked_Complete_By</fullName>
        <field>Approved_For_MFG_By__c</field>
        <formula>$User.FirstName 
&amp; &quot; &quot; 
&amp; $User.LastName 
&amp; &quot; (&quot; 
&amp; $User.Email 
&amp; &quot;) &quot; 
&amp; &quot;at &quot; &amp; TEXT(NOW())</formula>
        <name>PNP_Release Update Marked Complete By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PNP Release populate atdb-related fields</fullName>
        <actions>
            <name>PNP_Release_Populate_prod_id_from_atdb</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNP_Release_Populate_prod_nam_from_atdb</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNP_Release_Populate_tech_from_atdb</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PNP_Release__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Auto-populate atdb-related fields when new PNP Release is created or edited</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
