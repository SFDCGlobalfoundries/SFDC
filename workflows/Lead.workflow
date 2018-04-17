<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUUpdateCorporateAddress1</fullName>
        <description>FV2 : This field is used for updating Corporate Address 1.</description>
        <field>CorporateAddress1Replicate__c</field>
        <formula>Corporate_Address_1__c</formula>
        <name>FUUpdateCorporateAddress1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateCorporateAddress2</fullName>
        <description>FV2 : This ise used for updating Corporate Address 2.</description>
        <field>CorporateAddress2Replicate__c</field>
        <formula>Corporate_Address_2__c</formula>
        <name>FUUpdateCorporateAddress2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateCorporateAddress3</fullName>
        <description>FV2 : This is used for updating Corporate Address 3.</description>
        <field>CorporateAddress3Replicate__c</field>
        <formula>Corporate_Address_3__c</formula>
        <name>FUUpdateCorporateAddress3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateCorporateAddress4</fullName>
        <description>FV2 : This ise used for updating Corporate Address 4.</description>
        <field>CorporateAddress4Replicate__c</field>
        <formula>Corporate_Address_4__c</formula>
        <name>FUUpdateCorporateAddress4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateCorporateCity</fullName>
        <field>CorporateCityReplicate__c</field>
        <formula>Corporate_City__c</formula>
        <name>FUUpdateCorporateCity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateCorporateCountry</fullName>
        <field>CorporateCountryReplicate__c</field>
        <formula>TEXT(Corporate_Country__c)</formula>
        <name>FUUpdateCorporateCountry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateCorporatePostalCode</fullName>
        <description>FV2 : This field is used for mapping Contact field &apos;Corporate Postal Code&quot; from Lead.</description>
        <field>CorporatePostalCodeReplicate__c</field>
        <formula>Corporate_Postal_Zip_Code__c</formula>
        <name>FUUpdateCorporatePostalCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUUpdateCorporateState</fullName>
        <description>FV2 : This field is used for mapping Contact field &apos;Corporate State&quot; from Lead.</description>
        <field>CorporateStateReplicate__c</field>
        <formula>TEXT(Corporate_State__c)</formula>
        <name>FUUpdateCorporateState</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Copy_Owner_Profile</fullName>
        <field>Owner_Profile__c</field>
        <formula>IF(
    NOT(ISBLANK(Owner:User.Id)),
    CASE(Owner:User.Profile.Name,
        &apos;PT1&apos;, &apos;System Administrator&apos;, 
        &apos;PT2&apos;, &apos;Standard User&apos;, 
        &apos;PT3&apos;, &apos;Ready Only&apos;, 
        &apos;PT4&apos;, &apos;Solution Manager&apos;, 
        &apos;PT5&apos;, &apos;Marketing User&apos;, 
        &apos;PT6&apos;, &apos;Contract Manager&apos;, 
        &apos;PT7&apos;, &apos;Partner User&apos;, 
        &apos;PT8&apos;, &apos;Standard Platform User&apos;, 
        &apos;PT9&apos;, &apos;Standard Platform One App User&apos;, 
        &apos;PT13&apos;, &apos;Customer Portal User&apos;, 
        &apos;PT14&apos;, &apos;Customer Portal Manager&apos;, 
        Owner:User.Profile.Name
    ),
    &apos;&apos;
)</formula>
        <name>Lead - Copy Owner Profile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lead - Copy Owner Profile</fullName>
        <actions>
            <name>Lead_Copy_Owner_Profile</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow will populate the Owner Profile field based on the Profile of the Owner.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFPopulateLeadAddress</fullName>
        <actions>
            <name>FUUpdateCorporateAddress1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FUUpdateCorporateAddress2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FUUpdateCorporateAddress3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FUUpdateCorporateAddress4</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FUUpdateCorporateCity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FUUpdateCorporateCountry</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FUUpdateCorporatePostalCode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FUUpdateCorporateState</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FV2 : This field is used for copying Lead field Address fields to Address Replicate fields.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
