<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Waiver_Approval_Email_Notification</fullName>
        <description>Waiver Approval Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DesignExecutionWaiver_Approval_Noti</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_Update_as_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Update as Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Update_as_Cancel</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Cancel</literalValue>
        <name>Approval Status Update as Cancel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Update_as_None</fullName>
        <field>Approval_Status__c</field>
        <name>Approval Status Update as None</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Update_as_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status Update as Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Update_as_Review</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Review</literalValue>
        <name>Approval Status Update as Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Waiver_Approval_Comment</fullName>
        <field>Approval_Comment__c</field>
        <formula>Approval_Comment__c + BR() 
+ text(NOW()) + &quot; : &quot; + &quot;Approved by &quot; + $User.FirstName + &quot; &quot; + $User.LastName + &quot; &quot; + $User.Email</formula>
        <name>Update Waiver Approval Comment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Waiver_Approver_Name</fullName>
        <field>Approver_Name__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName + &quot; &quot; + $User.Email</formula>
        <name>Update Waiver Approver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Waiver_Cancel_Comment</fullName>
        <field>Approval_Comment__c</field>
        <formula>Approval_Comment__c + BR() 
+ text(NOW()) + &quot; : &quot; + &quot;Cancelled by &quot; + $User.FirstName + &quot; &quot; + $User.LastName + &quot; &quot; + $User.Email</formula>
        <name>Update Waiver Cancel Comment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Waiver_Rejection_Comment</fullName>
        <field>Approval_Comment__c</field>
        <formula>Approval_Comment__c + BR() 
+ text(NOW()) + &quot; : &quot; + &quot;Rejected by &quot; + $User.FirstName + &quot; &quot; + $User.LastName + &quot; &quot; + $User.Email</formula>
        <name>Update Waiver Rejection Comment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
