<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IdeaRejectedByProductTeam</fullName>
        <description>Idea Rejected By Product Team</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Rejected_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Idea_Assessed_as_Existing_Feature</fullName>
        <description>Idea Assessed as Existing Feature</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/New_Idea_Covered_by_Existing_Feature</template>
    </alerts>
    <alerts>
        <fullName>Not</fullName>
        <description>Notify Cases  Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_Cases</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_Acct_Mgmt_Product_Team_of_Idea_for_review</fullName>
        <description>Notify Acct. Mgmt. Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_Account_Mgmt</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_CE_Apps_Product_Team_of_Idea_for_review</fullName>
        <description>Notify CE Apps  Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_CE_Applications</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_Device_Product_Team_of_Idea_for_review</fullName>
        <description>Notify Device Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_Device</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_GLOBALFOUNDRYVIEW_Product_Team_of_Idea_for_review</fullName>
        <description>Notify GLOBALFOUNDRYVIEW Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_GLOBALFOUNDRYVIEW</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_Informal_Quote_Product_Team_of_Idea_for_review</fullName>
        <description>Notify Informal Quote Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_Informal_Quote</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_NDA_Product_Team_of_Idea_for_review</fullName>
        <description>Notify NDA Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_NDA</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_New_Apps_Product_Team_of_Idea_for_review</fullName>
        <description>Notify New Apps Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_New_App_Ideas</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_Opportunity_Mgmt_Product_Team_of_Idea_for_review</fullName>
        <description>Notify Opportunity Mgmt. Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_Opportunity_Mgmt</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_Other_Ideas_Product_Team_of_Idea_for_review</fullName>
        <description>Notify Other Ideas Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_Other_Ideas</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_PDK_Provisioning_Product_Team_of_Idea_for_review</fullName>
        <description>Notify PDK Provisioning Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_PDK_Provisioning</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_Platform_Ideas_Product_Team_of_Idea_for_review</fullName>
        <description>Notify Platform Ideas Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_Platform_Ideas</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_Product_Configurator_Product_Team_of_Idea_for_review</fullName>
        <description>Notify Product Configurator Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_Product_Configurator</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>Notify_Standard_Component_Product_Team_of_Idea_for_review</fullName>
        <description>Notify Standard Component Product Team of Idea for review</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_Standard_Components</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <alerts>
        <fullName>SendEmailToIdeaMgrsOnNewIdeaPost</fullName>
        <description>SendEmailToIdeaMgrsOnNewIdeaPost</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/New_Idea_Posted</template>
    </alerts>
    <alerts>
        <fullName>Send_Notice_that_Idea_approved_for_Development</fullName>
        <description>Send Notice that Idea approved for Development</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Delivery_Team</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Approved_for_Development</template>
    </alerts>
    <alerts>
        <fullName>Send_Notice_that_Idea_installed_to_Production</fullName>
        <description>Send Notice that Idea installed to Production</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Delivered</template>
    </alerts>
    <alerts>
        <fullName>Send_Notice_that_Idea_moved_to_Development</fullName>
        <description>Send Notice that Idea moved to Development</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Moved_to_Development</template>
    </alerts>
    <alerts>
        <fullName>Send_Notice_to_Bug_Tracking_System_Product_Team</fullName>
        <description>Notify Bug Tracking System Product Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ideas_Product_Team_Bug_Tracking_System</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Idea_Templates/Idea_Needs_Review_by_Product_Team</template>
    </alerts>
    <rules>
        <fullName>1%2E0 Send notice on new Idea posted</fullName>
        <actions>
            <name>SendEmailToIdeaMgrsOnNewIdeaPost</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>1%2E1 Send Notice that Idea assessed as Existing Feature</fullName>
        <actions>
            <name>Idea_Assessed_as_Existing_Feature</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Existing Feature</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E01 Notify Acct%2E Mgmt%2E Product Team</fullName>
        <actions>
            <name>Notify_Acct_Mgmt_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>Account</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E02 Notify Bug Tracking System Product Team</fullName>
        <actions>
            <name>Send_Notice_to_Bug_Tracking_System_Product_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>Bug Tracking System</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E03 Notify Cases Product Team</fullName>
        <actions>
            <name>Not</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>Cases</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E04 Notify CE Apps Product Team</fullName>
        <actions>
            <name>Notify_CE_Apps_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>CE Applications</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E05 Notify Device Product Team</fullName>
        <actions>
            <name>Notify_Device_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>Device</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E06 Notify GLOBALFOUNDRYVIEW Product Team</fullName>
        <actions>
            <name>Notify_GLOBALFOUNDRYVIEW_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>GLOBALFOUNDRYVIEW</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E07 Notify Informal Quote Product Team</fullName>
        <actions>
            <name>Notify_Informal_Quote_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>Informal Quote</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E08 Notify NDA Product Team</fullName>
        <actions>
            <name>Notify_NDA_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>NDA</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E09 Notify Opportunity Mgmt%2E Product Team</fullName>
        <actions>
            <name>Notify_Opportunity_Mgmt_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E10 Notify PDK Provisioning Product Team</fullName>
        <actions>
            <name>Notify_PDK_Provisioning_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>PDK</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E11 Notify Product Configurator Product Team</fullName>
        <actions>
            <name>Notify_Product_Configurator_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>Product Configurator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E12 Notify New Application Product Team</fullName>
        <actions>
            <name>Notify_New_Apps_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>New Applications</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E13 Notify Other Ideas Product Team</fullName>
        <actions>
            <name>Notify_Other_Ideas_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>Other</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E14 Notify Platform Ideas Product Team</fullName>
        <actions>
            <name>Notify_Platform_Ideas_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>Platform</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2%2E15 Notify Standard Component Product Team</fullName>
        <actions>
            <name>Notify_Standard_Component_Product_Team_of_Idea_for_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>contains</operation>
            <value>Standard</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>3%2E1 Send Notice that Idea rejected by Product Team</fullName>
        <actions>
            <name>IdeaRejectedByProductTeam</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Rejected by Product Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>3%2E2 Send Notice that Idea approved by Product Team</fullName>
        <actions>
            <name>Send_Notice_that_Idea_approved_for_Development</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>On Roadmap</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>4%2E0 Send Notice that Idea moved to Development</fullName>
        <actions>
            <name>Send_Notice_that_Idea_moved_to_Development</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Development</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>5%2E0 Send Notice that Idea installed to Production</fullName>
        <actions>
            <name>Send_Notice_that_Idea_installed_to_Production</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Delivered</value>
        </criteriaItems>
        <criteriaItems>
            <field>Idea.IdeaThemeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
