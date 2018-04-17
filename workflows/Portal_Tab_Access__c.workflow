<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Access_Setup_Change_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Supplier</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Access Setup Change Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateUniquePortalAccess</fullName>
        <description>FV2 : Field Update FUUpdateUniquePortalAccess will use the following formula for enforcing uniqueness across portal tab access records:
Account__c + Portal_User</description>
        <field>PortalAccountIdentifier__c</field>
        <formula>CASESAFEID(Account__c) + CASESAFEID(User__c)</formula>
        <name>FUUpdateUniquePortalAccess</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>OBMOnAccessSetUpExtAppToAIA</fullName>
        <apiVersion>29.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/ContactAccessSetupAIAService/ContactAccessSetupAIAService_client</endpointUrl>
        <fields>Account__c</fields>
        <fields>CCAR__c</fields>
        <fields>Contact_CreatedByHCMLoginId__c</fields>
        <fields>Contact_ModifiedHCMLoginId__c</fields>
        <fields>Contact__c</fields>
        <fields>Id</fields>
        <fields>PCRB__c</fields>
        <fields>PTRF__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OBMOnAccessSetUpExtAppToAIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Access Setup Record Type Update</fullName>
        <actions>
            <name>Access_Setup_Change_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Suppliers,Suppliers</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>OBMAccessSetupExtAppToAIA</fullName>
        <actions>
            <name>OBMOnAccessSetUpExtAppToAIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND(( !$Setup.IntegrationUsers__c.Is_Integration_User__c), 
CASESAFEID( Account__r.Id ) &lt;&gt; &apos;0019000000Lp3YnAAJ&apos;,
OR(ISCHANGED( CCAR__c ),ISCHANGED(  PCRB__c ),ISCHANGED(  PTRF__c ),ISCHANGED( Martini_Sync__c ),ISCHANGED(My_Devices__c),ISCHANGED(Product_Services__c),ISCHANGED(My_Wafers__c),ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFUpdateUniquePortalTabAccess</fullName>
        <actions>
            <name>FUUpdateUniquePortalAccess</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Portal_Tab_Access__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FV2 : Set the field PortalAccountIdentifier to &quot;Account__c + User__c&quot; to uniquely identify Account to that Portal user. There needs to be validation which will make sure that there is only one such portal tab access record exist for each portal user.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
