<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Email</fullName>
        <description>Approval Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>ben.lim@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cheeheng.leong@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cheehooi.chong@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>huili.koh@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>huiyi.lim@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rohit.lawrence@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>susan.shee@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>weenee.tan@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yongliang.tan@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>swift@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>Pending_Finance_Write_Off_Value</fullName>
        <description>Pending Finance Write Off Value</description>
        <protected>false</protected>
        <recipients>
            <recipient>exequielsoria.raguini@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fang.peng2@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kelly.cheah@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nancy.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yeeherng.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>swift@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>Rejected_Mail_Alert</fullName>
        <description>Rejected Mail Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>swift@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Rejection_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Closed_1</fullName>
        <description>Send Email Notification (Closed) 1</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>chengteck.lee@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>exequielsoria.raguini@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fang.peng2@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kelly.cheah@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>naidu.balakrishnan@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nancy.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rick.zucker@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yeeherng.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Account_Manager_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Fab_VP__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Finance_Controller__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Email_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Closed_2</fullName>
        <description>Send Email Notification (Closed) 2</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>chengteck.lee@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>exequielsoria.raguini@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fang.peng2@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kelly.cheah@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>naidu.balakrishnan@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nancy.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rick.zucker@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yeeherng.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Account_Manager_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Manager_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Fab_VP__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Finance_Controller__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Email_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Closed_3</fullName>
        <description>Send Email Notification (Closed) 3</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>chengteck.lee@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>exequielsoria.raguini@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fang.peng2@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kelly.cheah@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>naidu.balakrishnan@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nancy.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rick.zucker@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yeeherng.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Account_Manager_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Manager_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Manager_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Fab_VP__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Finance_Controller__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Email_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Closed_FAB_2</fullName>
        <description>Send Email Notification (Closed) FAB 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab2</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Email_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Closed_FAB_3</fullName>
        <description>Send Email Notification (Closed) FAB 3</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab3</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Email_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Closed_FAB_3E</fullName>
        <description>Send Email Notification (Closed) FAB 3E</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab3E</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Email_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Closed_FAB_5</fullName>
        <description>Send Email Notification (Closed) FAB 5</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab5</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Email_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Closed_FAB_6</fullName>
        <description>Send Email Notification (Closed) FAB 6</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab6</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Email_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Closed_FAB_7</fullName>
        <description>Send Email Notification (Closed) FAB 7</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab7</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Email_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Dan_B</fullName>
        <description>Send Email Notification (Dan B)</description>
        <protected>false</protected>
        <recipients>
            <recipient>daniel.berenbaum@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Emai_Dan_B</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Finance</fullName>
        <description>Send Email Notification (Finance)</description>
        <protected>false</protected>
        <recipients>
            <recipient>exequielsoria.raguini@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fang.peng2@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kelly.cheah@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nancy.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yeeherng.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Emai_Finance</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Region_Head</fullName>
        <description>Send Email Notification (Region Head)</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Region_Head__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Emai_Region_Head</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Sales_SVP</fullName>
        <description>Send Email Notification (Sales SVP)</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Sales_SVP__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Emai_Sales_SVP</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES</fullName>
        <description>Send Reminder - Approved and Pending Planning Update in MES (FAB 2)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab2</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES_FAB_3</fullName>
        <description>Send Reminder - Approved and Pending Planning Update in MES (FAB 3)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab3</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES_FAB_3E</fullName>
        <description>Send Reminder - Approved and Pending Planning Update in MES (FAB 3E)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab3E</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES_FAB_5</fullName>
        <description>Send Reminder - Approved and Pending Planning Update in MES (FAB 5)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab5</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES_FAB_6</fullName>
        <description>Send Reminder - Approved and Pending Planning Update in MES (FAB 6)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab6</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES_FAB_7</fullName>
        <description>Send Reminder - Approved and Pending Planning Update in MES (FAB 7)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab7</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Pending_Account_Manager_Confirmation</fullName>
        <description>Send Reminder - Pending Account Manager Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Manager_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Manager_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Manager_3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Pending_Fab_VP_Approval</fullName>
        <description>Send Reminder - Pending Fab VP Approval (Fab 2,3,5,6)</description>
        <protected>false</protected>
        <recipients>
            <recipient>yewkong.tan@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Pending_Fab_VP_Approval_Fab_3E</fullName>
        <description>Send Reminder - Pending Fab VP Approval (Fab 3E)</description>
        <protected>false</protected>
        <recipients>
            <recipient>zhimin.gu@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Pending_Fab_VP_Approval_Fab_7</fullName>
        <description>Send Reminder - Pending Fab VP Approval (Fab 7)</description>
        <protected>false</protected>
        <recipients>
            <recipient>peter.benyon@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Pending_Finance_Controller_Approval</fullName>
        <description>Send Reminder - Pending Finance Controller Approval (Fab 2,3,3E,5,6)</description>
        <protected>false</protected>
        <recipients>
            <recipient>gaurav.luthra@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Pending_Finance_Controller_Approval_Fab_7</fullName>
        <description>Send Reminder - Pending Finance Controller Approval (Fab 7)</description>
        <protected>false</protected>
        <recipients>
            <recipient>sherman.chow@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Pending_Finance_Write_Off_Value</fullName>
        <description>Send Reminder - Pending Finance Write Off Value</description>
        <protected>false</protected>
        <recipients>
            <recipient>exequielsoria.raguini@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fang.peng2@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kelly.cheah@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nancy.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yeeherng.yeo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Pending_Planning_Manager_Approval</fullName>
        <description>Send Reminder - Pending Planning Manager Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>chengteck.lee@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>naidu.balakrishnan@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Pending_SVP_WWS_Approval</fullName>
        <description>Send Reminder - Pending SVP WWS Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>rick.zucker@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Wafer_Write_Off_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Wafer_Write_Off_Info_FAB_2</fullName>
        <description>Send Wafer Write Off Info (FAB 2)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab2</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/WaferWriteOff_Email_Info</template>
    </alerts>
    <alerts>
        <fullName>Send_Wafer_Write_Off_Info_FAB_3</fullName>
        <description>Send Wafer Write Off Info (FAB 3)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab3</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/WaferWriteOff_Email_Info</template>
    </alerts>
    <alerts>
        <fullName>Send_Wafer_Write_Off_Info_FAB_3E</fullName>
        <description>Send Wafer Write Off Info (FAB 3E)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab3E</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/WaferWriteOff_Email_Info</template>
    </alerts>
    <alerts>
        <fullName>Send_Wafer_Write_Off_Info_FAB_5</fullName>
        <description>Send Wafer Write Off Info (FAB 5)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab5</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/WaferWriteOff_Email_Info</template>
    </alerts>
    <alerts>
        <fullName>Send_Wafer_Write_Off_Info_FAB_6</fullName>
        <description>Send Wafer Write Off Info (FAB 6)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab6</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/WaferWriteOff_Email_Info</template>
    </alerts>
    <alerts>
        <fullName>Send_Wafer_Write_Off_Info_FAB_7</fullName>
        <description>Send Wafer Write Off Info (FAB 7)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Planners_Fab7</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/WaferWriteOff_Email_Info</template>
    </alerts>
    <fieldUpdates>
        <fullName>Pending_Account_Manager_Confirmation</fullName>
        <field>Status__c</field>
        <literalValue>Pending Account Manager Confirmation</literalValue>
        <name>Pending Account Manager Confirmation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_Finance_Controller_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Pending Finance Controller Approval</literalValue>
        <name>Pending Finance Controller Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_Planning_Manager_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Pending Planning Manager Approval</literalValue>
        <name>Pending Planning Manager Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_SVP_WWS_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Pending Sales Operations</literalValue>
        <name>Pending SVP WWS Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Stage_1_DateTime_to_Null</fullName>
        <field>Pending_Finance_Write_Off_Value_DateTime__c</field>
        <name>Set Approval Stage 1 DateTime to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Stage_2_DateTime_to_Null</fullName>
        <field>Pending_Planning_Mgr_Approval_DateTiime__c</field>
        <name>Set Approval Stage 2 DateTime to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Stage_3_DateTime_to_Null</fullName>
        <field>Pending_Acct_Mgr_Confirmation_DateTim__c</field>
        <name>Set Approval Stage 3 DateTime to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Stage_4_DateTime_to_Null</fullName>
        <field>Pending_SVP_WWS_Approval_DateTime__c</field>
        <name>Set Approval Stage 4 DateTime to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Stage_5_DateTime_to_Null</fullName>
        <field>Pending_Fab_VP_Approval_DateTime__c</field>
        <name>Set Approval Stage 5 DateTime to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Stage_6_DateTime_to_Null</fullName>
        <field>Pending_Fin_Controller_Approval_DateTime__c</field>
        <name>Set Approval Stage 6 DateTime to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Stage_7_DateTime_to_Null</fullName>
        <field>App_and_Pend_Plan_Update_in_MES_DateTime__c</field>
        <name>Set Approval Stage 7 DateTime to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Fab_VP_Fab_2_3_5_6</fullName>
        <field>Fab_VP__c</field>
        <lookupValue>yewkong.tan@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Fab VP (Fab 2,3,5,6)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Fab_VP_Fab_3E</fullName>
        <field>Fab_VP__c</field>
        <lookupValue>zhimin.gu@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Fab VP (Fab 3E)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Fab_VP_Fab_7</fullName>
        <field>Fab_VP__c</field>
        <lookupValue>peter.benyon@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Fab VP (Fab 7)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Finance_Controller_Fab_2_3_3E_5_6</fullName>
        <field>Finance_Controller__c</field>
        <lookupValue>gaurav.luthra@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Finance Controller (Fab 2,3,3E,5,6)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Finance_Controller_Fab_7</fullName>
        <field>Finance_Controller__c</field>
        <lookupValue>sherman.chow@globalfoundries.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Finance Controller (Fab 7)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_In_Approval_Process_to_False</fullName>
        <field>In_Approval_Process__c</field>
        <literalValue>0</literalValue>
        <name>Set In Approval Process to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_In_Approval_Process_to_True</fullName>
        <field>In_Approval_Process__c</field>
        <literalValue>1</literalValue>
        <name>Set In Approval Process to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Draft</fullName>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_Approved_and_Pending_Plann</fullName>
        <field>Status__c</field>
        <literalValue>Approved and Pending Planning</literalValue>
        <name>Status Update Approved and Pending Plann</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_Pending_Fab_VP_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Pending Fab VP Approval</literalValue>
        <name>Status Update Pending Fab VP Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_Pending_Finance_Write_Off</fullName>
        <field>Status__c</field>
        <literalValue>Pending Finance Update of Write Off Value</literalValue>
        <name>Status Update Pending Finance Write Off</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_Reject</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status Update Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Acct_Mgr_Confirmation</fullName>
        <field>Pending_Acct_Mgr_Confirmation_DateTim__c</field>
        <formula>NOW()</formula>
        <name>Update Pending Acct Mgr Confirmation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Fab_VP_Approval</fullName>
        <field>Pending_Fab_VP_Approval_DateTime__c</field>
        <formula>NOW()</formula>
        <name>Update Pending Fab VP Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Fin_Controller_Approval</fullName>
        <field>Pending_Fin_Controller_Approval_DateTime__c</field>
        <formula>NOW()</formula>
        <name>Update Pending Fin Controller Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Finance_Write_Off_Value</fullName>
        <field>Pending_Finance_Write_Off_Value_DateTime__c</field>
        <formula>NOW()</formula>
        <name>Update Pending Finance Write Off Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Planning_Manager_Approval</fullName>
        <field>Pending_Planning_Mgr_Approval_DateTiime__c</field>
        <formula>NOW()</formula>
        <name>Update Pending Planning Manager Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_SVP_WWS_Approval</fullName>
        <field>Pending_SVP_WWS_Approval_DateTime__c</field>
        <formula>NOW()</formula>
        <name>Update Pending SVP WWS Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Closed%29 1</fullName>
        <actions>
            <name>Send_Email_Notification_Closed_1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Status__c)  , ISPICKVAL(Status__c, &apos;Closed&apos;)  , NOT(ISBLANK(Account_Manager_1__c)) , ISBLANK(Account_Manager_2__c) , ISBLANK(Account_Manager_3__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Closed%29 2</fullName>
        <actions>
            <name>Send_Email_Notification_Closed_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Status__c)  , ISPICKVAL(Status__c, &apos;Closed&apos;)  , NOT(ISBLANK(Account_Manager_1__c)) , NOT(ISBLANK(Account_Manager_2__c)) , ISBLANK(Account_Manager_3__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Closed%29 3</fullName>
        <actions>
            <name>Send_Email_Notification_Closed_3</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Status__c)  , ISPICKVAL(Status__c, &apos;Closed&apos;)  , NOT(ISBLANK(Account_Manager_1__c)) , NOT(ISBLANK(Account_Manager_2__c)) , NOT(ISBLANK(Account_Manager_3__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Closed%29 FAB 2</fullName>
        <actions>
            <name>Send_Email_Notification_Closed_FAB_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Status__c), ISPICKVAL(Status__c, &apos;Closed&apos;), ISPICKVAL(Fab__c, &apos;Fab 2&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Closed%29 FAB 3</fullName>
        <actions>
            <name>Send_Email_Notification_Closed_FAB_3</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Status__c), ISPICKVAL(Status__c, &apos;Closed&apos;), ISPICKVAL(Fab__c, &apos;Fab 3&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Closed%29 FAB 3E</fullName>
        <actions>
            <name>Send_Email_Notification_Closed_FAB_3E</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Status__c), ISPICKVAL(Status__c, &apos;Closed&apos;), ISPICKVAL(Fab__c, &apos;Fab 3E&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Closed%29 FAB 5</fullName>
        <actions>
            <name>Send_Email_Notification_Closed_FAB_5</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Status__c), ISPICKVAL(Status__c, &apos;Closed&apos;), ISPICKVAL(Fab__c, &apos;Fab 5&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Closed%29 FAB 6</fullName>
        <actions>
            <name>Send_Email_Notification_Closed_FAB_6</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Status__c), ISPICKVAL(Status__c, &apos;Closed&apos;), ISPICKVAL(Fab__c, &apos;Fab 6&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Closed%29 FAB 7</fullName>
        <actions>
            <name>Send_Email_Notification_Closed_FAB_7</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Status__c), ISPICKVAL(Status__c, &apos;Closed&apos;), ISPICKVAL(Fab__c, &apos;Fab 7&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Dan B%29</fullName>
        <actions>
            <name>Send_Email_Notification_Dan_B</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Status__c, &apos;Approved and Pending Planning&apos;)  , ISPICKVAL(PRIORVALUE(Status__c), &apos;Pending Finance Controller Approval&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Finance%29</fullName>
        <actions>
            <name>Send_Email_Notification_Finance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Status__c, &apos;Pending Planning Manager Approval&apos;)  , ISPICKVAL(PRIORVALUE(Status__c), &apos;Pending Finance Write Off Value&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Region Head%29</fullName>
        <actions>
            <name>Send_Email_Notification_Region_Head</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Status__c, &apos;Pending Sales Operations&apos;)  , ISPICKVAL(PRIORVALUE(Status__c), &apos;Pending Account Manager Confirmation&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Email Notification %28Sales SVP%29</fullName>
        <actions>
            <name>Send_Email_Notification_Sales_SVP</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Status__c, &apos;Pending Fab VP Approval&apos;)  , ISPICKVAL(PRIORVALUE(Status__c), &apos;Pending Sales Operations&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Info %28FAB 2%29</fullName>
        <actions>
            <name>Send_Wafer_Write_Off_Info_FAB_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Status__c) , TEXT(Status__c) == &apos;Approved and Pending Planning&apos; , TEXT(Fab__c) == &apos;Fab 2&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Info %28FAB 3%29</fullName>
        <actions>
            <name>Send_Wafer_Write_Off_Info_FAB_3</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Status__c) , TEXT(Status__c) == &apos;Approved and Pending Planning&apos; , TEXT(Fab__c) == &apos;Fab 3&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Info %28FAB 3E%29</fullName>
        <actions>
            <name>Send_Wafer_Write_Off_Info_FAB_3E</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Status__c) , TEXT(Status__c) == &apos;Approved and Pending Planning&apos; , TEXT(Fab__c) == &apos;Fab 3E&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Info %28FAB 5%29</fullName>
        <actions>
            <name>Send_Wafer_Write_Off_Info_FAB_5</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Status__c) , TEXT(Status__c) == &apos;Approved and Pending Planning&apos; , TEXT(Fab__c) == &apos;Fab 5&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Info %28FAB 6%29</fullName>
        <actions>
            <name>Send_Wafer_Write_Off_Info_FAB_6</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Status__c) , TEXT(Status__c) == &apos;Approved and Pending Planning&apos; , TEXT(Fab__c) == &apos;Fab 6&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off - Send Info %28FAB 7%29</fullName>
        <actions>
            <name>Send_Wafer_Write_Off_Info_FAB_7</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Status__c) , TEXT(Status__c) == &apos;Approved and Pending Planning&apos; , TEXT(Fab__c) == &apos;Fab 7&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Approved and Pending Planning Update in MES %28FAB 2%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved and Pending Planning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 2</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Approved and Pending Planning Update in MES %28FAB 3%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved and Pending Planning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 3</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES_FAB_3</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Approved and Pending Planning Update in MES %28FAB 3E%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved and Pending Planning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 3E</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES_FAB_3E</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Approved and Pending Planning Update in MES %28FAB 5%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved and Pending Planning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 5</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES_FAB_5</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Approved and Pending Planning Update in MES %28FAB 6%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved and Pending Planning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 6</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES_FAB_6</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Approved and Pending Planning Update in MES %28FAB 7%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved and Pending Planning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 7</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Approved_and_Pending_Planning_Update_in_MES_FAB_7</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Pending Account Manager Confirmation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Account Manager Confirmation</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Pending_Account_Manager_Confirmation</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Pending Fab VP Approval %28Fab 2%2C3%2C5%2C6%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Fab VP Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 2,Fab 3,Fab 5,Fab 6</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Pending_Fab_VP_Approval</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Pending Fab VP Approval %28Fab 3E%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Fab VP Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 3E</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Pending_Fab_VP_Approval_Fab_3E</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Pending Fab VP Approval %28Fab 7%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Fab VP Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 7</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Pending_Fab_VP_Approval_Fab_7</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Pending Finance Controller Approval %28Fab 2%2C3%2C3E%2C5%2C6%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Finance Controller Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 2,Fab 3,Fab 3E,Fab 5,Fab 6</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Pending_Finance_Controller_Approval</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Pending Finance Controller Approval %28Fab 7%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Finance Controller Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Fab__c</field>
            <operation>equals</operation>
            <value>Fab 7</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Pending_Finance_Controller_Approval_Fab_7</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Pending Finance Write Off Value</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Finance Update of Write Off Value</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Pending_Finance_Write_Off_Value</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Pending Planning Manager Approval</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Planning Manager Approval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Pending_Planning_Manager_Approval</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Wafer Write Off Reminder - Pending SVP WWS Approval</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wafer_Write_Off__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Sales Operations</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Pending_SVP_WWS_Approval</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
