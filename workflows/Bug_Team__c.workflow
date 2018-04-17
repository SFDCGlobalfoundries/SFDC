<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_for_Bug_Team_on_ASICBug</fullName>
        <description>Email Notification for Bug Team on ASICBug</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/Email_Notification_for_Asic_Bug_Team_Update</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_for_Bug_Team_on_Bug_Create</fullName>
        <description>Email Notification for Bug Team on Bug Create</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/Email_Notification_for_Bug_Assignment2</template>
    </alerts>
    <fieldUpdates>
        <fullName>SetUniqueFieldforBugTeamRecord</fullName>
        <field>Bug_Team_Unique__c</field>
        <formula>CASESAFEID(Bug__c) + CASESAFEID(User__c)</formula>
        <name>SetUniqueFieldforBugTeamRecord</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Notification for BugTeam on ASICBug</fullName>
        <actions>
            <name>Email_Notification_for_Bug_Team_on_ASICBug</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>And( User__c != null, User__c != &apos;&apos;, NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c), Bug__r.RecordType.DeveloperName = &apos;ASIC_Bug&apos; ,  ((LastModifiedDate - Bug__r.CreatedDate )*1440*60) &gt;15 )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification for BugTeam on Bug create</fullName>
        <actions>
            <name>Email_Notification_for_Bug_Team_on_Bug_Create</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>And( User__c != null, User__c != &apos;&apos;, NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c), Bug__r.RecordType.DeveloperName != &apos;ASIC_Bug&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SetUniqueFieldforBugTeamRecord</fullName>
        <actions>
            <name>SetUniqueFieldforBugTeamRecord</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Bug_Team__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>WF used to updated the unique field &quot;BugID&quot; + &quot;UserId&quot; to avoid duplicate bug team records for bug.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
