<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IP_Merge_Request_Has_been_submitted_for_Approval</fullName>
        <description>IP Merge Request Has been submitted for Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>IP_Merge_Request</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/IP_Merge_request</template>
    </alerts>
</Workflow>
