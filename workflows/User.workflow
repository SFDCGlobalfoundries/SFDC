<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SOC_User_Deactivation_Email</fullName>
        <description>SOC User Deactivation Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>devendrababu.itraju@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLOBALFOUNDRIES/Malta_SOC_User_with_ADFS_Access_Deactivation</template>
    </alerts>
    <alerts>
        <fullName>Send_Chatter_External_User_Login_Email</fullName>
        <description>Send Chatter External User Login Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/New_Chatter_Login_Flow_Notification</template>
    </alerts>
    <rules>
        <fullName>SOC User deactivation notification</fullName>
        <actions>
            <name>SOC_User_Deactivation_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(CONTAINS(&quot;jbeckwit:ZBELL:JCENIZA:CCHARLAN:mheath:JJOHNSO4:LLEW:bloucks1:FNISSEN:twood&quot;, HCM_Login_ID__c), NOT(IsActive) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>User%3A Chatter New Login Flow Notification</fullName>
        <actions>
            <name>Send_Chatter_External_User_Login_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Chatter External User</value>
        </criteriaItems>
        <description>This workflow sends the new Globalfoundries login flow to newly registered Chatter user.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
