<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MPW_ExtraDie_Update_ERP_Status_2_to_Send</fullName>
        <field>ERP_Status_2__c</field>
        <formula>&quot;SEND&quot;</formula>
        <name>MPW ExtraDie Update ERP Status 2 to Send</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>MPW_After_Void_Out_Msg_for_Extra_Die</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://test.foundryview.com/aianoauth/soa-infra/services/SF/MPWExtraWaferService/MPWExtraWaferService_client_ep</endpointUrl>
        <fields>Approved_On__c</fields>
        <fields>ERP_Error_2__c</fields>
        <fields>ERP_Status_2__c</fields>
        <fields>EXTRA_WAFER_ID__c</fields>
        <fields>Extra_Die_B_Integration__c</fields>
        <fields>Extra_Die_Qty__c</fields>
        <fields>Extra_Die_Type__c</fields>
        <fields>Extra_Wafer_Qty__c</fields>
        <fields>Id</fields>
        <fields>MPW_Form_Number__c</fields>
        <fields>MPW_Train__c</fields>
        <fields>OPTION_C2__c</fields>
        <fields>ObjectType__c</fields>
        <fields>Operation_Type__c</fields>
        <fields>Prime_Die_Name__c</fields>
        <fields>Requestor_Name__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>MPW After Void Out Msg for Extra Die</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>MPW_ExtraDie_Request_Outbound_Message</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://test.foundryview.com/aianoauth/soa-infra/services/SF/MPWExtraWaferService/MPWExtraWaferService_client_ep</endpointUrl>
        <fields>Approved_On__c</fields>
        <fields>ERP_Error_2__c</fields>
        <fields>ERP_Status_2__c</fields>
        <fields>EXTRA_WAFER_ID__c</fields>
        <fields>Extra_Die_B_Integration__c</fields>
        <fields>Extra_Die_Qty__c</fields>
        <fields>Extra_Die_Type__c</fields>
        <fields>Extra_Wafer_Qty__c</fields>
        <fields>Id</fields>
        <fields>MPW_Form_Number__c</fields>
        <fields>MPW_Train__c</fields>
        <fields>OPTION_C2__c</fields>
        <fields>ObjectType__c</fields>
        <fields>Operation_Type__c</fields>
        <fields>Prime_Die_Name__c</fields>
        <fields>Requestor_Name__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>MPW ExtraDie Request Outbound Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>MPW After Void Outbound Message For Extra Die</fullName>
        <actions>
            <name>MPW_ExtraDie_Update_ERP_Status_2_to_Send</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MPW_After_Void_Out_Msg_for_Extra_Die</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND( !$Setup.IntegrationUsers__c.Is_Integration_User__c, ISPICKVAL(  Operation_Type__c  ,&apos;Void&apos;), ISPICKVAL( MPW_Prime_Die__r.MPW_Form__r.Form_Status__c , &apos;Void&apos;), MPW_Prime_Die__r.MPW_Form__r.BARE_DIE_SHIP_DATE_FLAG__c &gt; 0, MPW_Prime_Die__r.Category__c &lt;&gt; &apos;Customer&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MPW ExtraDie Request Outbound Message</fullName>
        <actions>
            <name>MPW_ExtraDie_Update_ERP_Status_2_to_Send</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MPW_ExtraDie_Request_Outbound_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND( !$Setup.IntegrationUsers__c.Is_Integration_User__c, MPW_Prime_Die__r.isExtraDieRequest__c  = true, ISPICKVAL(Operation_Type__c,&apos;Insert&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
