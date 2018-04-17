<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_on_RTM_Ready_At_DE</fullName>
        <ccEmails>fdryrel@globalfoundries.com</ccEmails>
        <description>Email on RTM Ready At DE</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Backup_Request_Catcher_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Primary_Request_Catcher_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>RTM_Ready_Date_Updated_By_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DWP_Email_Templates/EmailTemplateForOptionRTMReadyAtDE</template>
    </alerts>
    <alerts>
        <fullName>Email_on_RTM_Ready_Before_DE</fullName>
        <ccEmails>fdryrel@globalfoundries.com</ccEmails>
        <description>Email on RTM Ready Before DE</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Backup_Request_Catcher_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Primary_Request_Catcher_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>RTM_Ready_Date_Updated_By_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DWP_Email_Templates/EmailTemplateForOptionRTMReadyBeforeDE</template>
    </alerts>
    <alerts>
        <fullName>ITAR_Related_Value_Changed</fullName>
        <ccEmails>robyn.lemnah@globalfoundries.com.preprod</ccEmails>
        <description>ITAR Related Value Changed</description>
        <protected>false</protected>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLOBALFOUNDRIES/ITAR_Value_Changed_in_Option</template>
    </alerts>
    <fieldUpdates>
        <fullName>UpdateRTMReadyEmailAtDE</fullName>
        <field>RTM_Ready_Email_At_DE__c</field>
        <literalValue>1</literalValue>
        <name>UpdateRTMReadyEmailAtDE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRTMReadyEmailBeforeDE</fullName>
        <field>RTM_Ready_Email_Before_DE__c</field>
        <literalValue>1</literalValue>
        <name>UpdateRTMReadyEmailBeforeDE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Design_ECCN</fullName>
        <field>Design_Export_Control_Classification_Num__c</field>
        <formula>TEXT(Design_ECCN__c)</formula>
        <name>Update Design ECCN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ITAR Value Changed in Option</fullName>
        <actions>
            <name>ITAR_Related_Value_Changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND (  NOT(ISNEW()),  OR  (   ISCHANGED(ITAR__c),   ISCHANGED(Design_ECCN__c),   ISCHANGED(Functional_ECCN__c),    ISCHANGED(If_ITAR_is_Yes_ITAR_Category__c),   ISCHANGED(If_ITAR_is_Yes_Applicable_Suffixes__c)  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Option RTM Ready At DE</fullName>
        <actions>
            <name>Email_on_RTM_Ready_At_DE</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UpdateRTMReadyEmailAtDE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Opportunity__r.Product_Line__c,&apos;RF&apos;), NOT(RTM_Ready_Email_At_DE__c),  OR(  AND(  ISCHANGED(Option_Stage__c),  ISPICKVAL(Option_Stage__c,&apos;Design Execution&apos;),  NOT(ISBLANK(RTM_Ready_Date__c))  ),  AND(  ISCHANGED(RTM_Ready_Date__c),  NOT(ISBLANK(RTM_Ready_Date__c)),  ISPICKVAL(Option_Stage__c,&apos;Design Execution&apos;)  )  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Option RTM Ready Before DE</fullName>
        <actions>
            <name>Email_on_RTM_Ready_Before_DE</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UpdateRTMReadyEmailBeforeDE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Opportunity__r.Product_Line__c,&apos;RF&apos;),  NOT(RTM_Ready_Email_Before_DE__c),   OR(  AND(  ISCHANGED(Option_Stage__c),  OR(ISPICKVAL(Option_Stage__c,&apos;Customer Engagement&apos;),  ISPICKVAL(Option_Stage__c,&apos;Try for Fit&apos;),  ISPICKVAL(Option_Stage__c,&apos;Bid and Quote&apos;),  ISPICKVAL(Option_Stage__c,&apos;Reconciliation&apos;)),  NOT(ISBLANK(RTM_Ready_Date__c))  ),  AND(  ISCHANGED(RTM_Ready_Date__c),  NOT(ISBLANK(RTM_Ready_Date__c)),  OR(ISPICKVAL(Option_Stage__c,&apos;Customer Engagement&apos;),  ISPICKVAL(Option_Stage__c,&apos;Try for Fit&apos;),  ISPICKVAL(Option_Stage__c,&apos;Bid and Quote&apos;),  ISPICKVAL(Option_Stage__c,&apos;Reconciliation&apos;))  )  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Value of Design ECCN</fullName>
        <actions>
            <name>Update_Design_ECCN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR (     ISNEW(),      ISCHANGED(Design_ECCN__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
