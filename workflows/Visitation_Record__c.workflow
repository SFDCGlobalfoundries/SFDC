<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_Executive_Admins_that_an_Executive_is_being_requested_for_Visitation</fullName>
        <description>Alert Executive Admins that an Executive is being requested for Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>Executive_Admins_for_Visitation</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>E_mail_to_Visitation_Host_Owner_in_Pre_Visitation_Stage</fullName>
        <description>E-mail to Visitation Host / Owner in Pre Visitation Stage</description>
        <protected>false</protected>
        <recipients>
            <field>Visitation_Host__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Customer_Pre_Visitation_Reminder</template>
    </alerts>
    <alerts>
        <fullName>E_mail_to_Visitation_Host_Owner_to_close_Visit_Record</fullName>
        <description>E-mail to Visitation Host / Owner to close Visit Record</description>
        <protected>false</protected>
        <recipients>
            <field>Visitation_Host__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Customer_Visitation_Closure_Reminder</template>
    </alerts>
    <alerts>
        <fullName>E_mail_to_Visitation_Host_to_close_Visit_Record</fullName>
        <description>E-mail to Visitation Host and Owner to close Visit Record</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Visitation_Host__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Customer_Visitation_Closure_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Inform_Alexie_Lee_of_Visitation</fullName>
        <description>Inform Alexie Lee of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>alexie.lee@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kim.lazzareschi@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Ana_Hunter_of_Visitation</fullName>
        <description>Inform Ana Hunter of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>ana.hunter@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maria.sotelo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Chuck_Fox_of_Visitation</fullName>
        <description>Inform Chuck Fox of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>chuck.fox@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>patricia.gatto@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Executive_Admin_of_Visitation_with_Executive_Requested</fullName>
        <description>Inform Executive Admin of Visitation with Executive Requested</description>
        <protected>false</protected>
        <recipients>
            <recipient>Executive_Admins_for_Visitation</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Alert_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Executive_of_Visitation_with_Executive_Requested</fullName>
        <description>Inform Executive of Visitation with Executive Requested</description>
        <protected>false</protected>
        <recipients>
            <recipient>Executive_Staff_for_Visitation</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Gregg_Bartlett_of_Visitation</fullName>
        <description>Inform Gregg Bartlett of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gregg.bartlett@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>robin.webb@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Ibrahim_Ajami_of_Visitation</fullName>
        <description>Inform Ibrahim Ajami of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ibrahim.ajami@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>veronica.lira@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_John_Bucher_of_Visitation</fullName>
        <description>Inform John Bucher	 of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>john.bucher@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>robin.webb@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_John_Goldsberry_of_Visitation</fullName>
        <description>Inform John Goldsberry of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>denise.balanon@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>john.goldsberry@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_KC_Ang_of_Visitation</fullName>
        <description>Inform KC Ang	 of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>esther.poh@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kc.ang@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sharon.wong@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Rutger_Wijburg_of_Visitation</fullName>
        <description>Inform Rutger Wijburg of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>deborah.leupold@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rutger.wijburg@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sonja.schoepflin@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Sanjay_Jha_of_Visitation</fullName>
        <description>Inform Sanjay Jha of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kim.lazzareschi@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sanjay.jha@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Suresh_Venkatesan_of_Visitation</fullName>
        <description>Inform Suresh Venkatesan of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>aileen.paris@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>suresh.venkatesan@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Terry_Daly_of_Visitation</fullName>
        <description>Inform Terry Daly of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>aileen.paris@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>terrence.daly@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Inform_Thomas_Caulfield_of_Visitation</fullName>
        <description>Inform Thomas Caulfield  of Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>aileen.paris@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.caulfield@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_Notification_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email</fullName>
        <description>Survey Email</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Visitation_Host__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>cva_email@2hlivkeuktkmxf68d1uzjwx6e9xo4efuullp8o2ott94b78lod.o-539gamay.cs5.apex.sandbox.salesforce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Visitation_Templates/Customer_Survey_for_CVA</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email_1</fullName>
        <description>Survey Email</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Visitation_Host__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>cva_email@2hlivkeuktkmxf68d1uzjwx6e9xo4efuullp8o2ott94b78lod.o-539gamay.cs5.apex.sandbox.salesforce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Visitation_Templates/Customer_Survey_for_CVA</template>
    </alerts>
    <alerts>
        <fullName>Visitation_Communication_BTV</fullName>
        <description>Visitation Communication BTV</description>
        <protected>false</protected>
        <recipients>
            <recipient>Visitation_Communication_BTV</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Visitation_Templates/Customer_Visitation_Meeting_Summary</template>
    </alerts>
    <alerts>
        <fullName>Visitation_Communication_EFK</fullName>
        <description>Visitation Communication EFK</description>
        <protected>false</protected>
        <recipients>
            <recipient>Visitation_Communication_EFK</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Visitation_Templates/Customer_Visitation_Meeting_Summary</template>
    </alerts>
    <alerts>
        <fullName>Visitation_iCal_Notification</fullName>
        <description>Visitation iCal Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Visitation_Host__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>cva_email@2hlivkeuktkmxf68d1uzjwx6e9xo4efuullp8o2ott94b78lod.o-539gamay.cs5.apex.sandbox.salesforce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Visitation_Templates/Visitation_Ical</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_Alexie_Lee</fullName>
        <description>3 Day Alert for Alexie Lee</description>
        <protected>false</protected>
        <recipients>
            <recipient>alexie.lee@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>robin.webb@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_Ana_Hunter</fullName>
        <description>3 Day Alert for Ana Hunter</description>
        <protected>false</protected>
        <recipients>
            <recipient>ana.hunter@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maria.sotelo@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_Chuck_Fox</fullName>
        <description>3 Day Alert for Chuck Fox</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>chuck.fox@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kim.lazzareschi@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_Gregg_Bartlett</fullName>
        <description>3 Day Alert for Gregg Bartlett</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gregg.bartlett@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>robin.webb@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_Ibrahim_Ajami</fullName>
        <description>3 Day Alert for Ibrahim Ajami</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ibrahim.ajami@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>peg.omalley@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_John_B</fullName>
        <description>3 Day Alert for John B</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>john.bucher@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>robin.webb@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_John_Goldsberry</fullName>
        <description>3 Day Alert for John Goldsberry</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>denise.balanon@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>john.goldsberry@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_KC_Ang</fullName>
        <description>3 Day Alert for KC Ang</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>esther.poh@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kc.ang@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sharon.wong@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_Rutger</fullName>
        <description>3 Day Alert for Rutger</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>deborah.leupold@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rutger.wijburg@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sonja.schoepflin@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_Sanjay_Jha</fullName>
        <description>3 Day Alert for Sanjay Jha</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>peg.omalley@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sanjay.jha@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_Suresh_Venkatesan</fullName>
        <description>3 Day Alert for Suresh Venkatesan</description>
        <protected>false</protected>
        <recipients>
            <recipient>aileen.paris@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>suresh.venkatesan@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_Terry_Daly</fullName>
        <description>3 Day Alert for Terry Daly</description>
        <protected>false</protected>
        <recipients>
            <recipient>aileen.paris@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>terrence.daly@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Alert_for_Thomas_Caulfield</fullName>
        <description>3 Day Alert for Thomas Caulfield</description>
        <protected>false</protected>
        <recipients>
            <recipient>aileen.paris@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.caulfield@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>X3_Day_Reminder_for_Executive_Customer_Visitation</fullName>
        <description>3 Day Reminder for Executive Customer Visitation</description>
        <protected>false</protected>
        <recipients>
            <recipient>Executive_Admins_for_Visitation</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>charlesd@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visitation_Templates/Executive_Admin_3_Day_Reminder_of_Customer_Visitation</template>
    </alerts>
    <alerts>
        <fullName>email</fullName>
        <description>email</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Visitation_Host__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>cva_email@2hlivkeuktkmxf68d1uzjwx6e9xo4efuullp8o2ott94b78lod.o-539gamay.cs5.apex.sandbox.salesforce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Visitation_Templates/Customer_Survey_for_CVA</template>
    </alerts>
    <fieldUpdates>
        <fullName>Alexie_Lee_is_Requested</fullName>
        <field>Alexie_Lee__c</field>
        <literalValue>R</literalValue>
        <name>Alexie Lee is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Alexie_reset</fullName>
        <field>Alexie_Lee__c</field>
        <name>Alexie reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ana_Hunter_is_Requested</fullName>
        <description>Update the Executive AH to Requested</description>
        <field>Ana_Hunter__c</field>
        <literalValue>R</literalValue>
        <name>Ana Hunter is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ana_reset</fullName>
        <field>Ana_Hunter__c</field>
        <name>Ana reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Burlington_QA_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_admin_Fab9_10</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Burlington QA queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Dresden_QA_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_Audit_Dresden_Approvers</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Dresden QA queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_East_Fishkill_QA_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_admin_Fab9_10</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to East Fishkill QA queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Malta_QA_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_Audit_Malta_Approvers</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Malta QA queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Singapore_QA_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_Audit_Singapore_Approvers</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Singapore QA queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Singapore_QA_queue_2</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_Audit_Singapore_Approvers_2</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Singapore QA queue 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Singapore_QA_queue_3</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_Audit_Singapore_Approvers_3</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Singapore QA queue 3</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Williston_QA_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_admin_Fab9_10</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Williston QA queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_confirmed_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitations_Confirmed_pre_Visit</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to confirmed queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_post_visit_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitations_Post_Visit</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to post-visit queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_prep_queue_Burlington</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_admin_Fab9_10</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to prep queue - Burlington</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_prep_queue_Dresden</fullName>
        <description>Assign to prep queue - Dresden</description>
        <field>OwnerId</field>
        <lookupValue>Visitation_Prep_Dresden</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to prep queue - Dresden</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_prep_queue_East_Fishkill</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_admin_Fab9_10</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to prep queue - East Fishkill</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_prep_queue_Malta</fullName>
        <description>Assign to prep queue - Malta</description>
        <field>OwnerId</field>
        <lookupValue>Visitation_Prep_Malta</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to prep queue - Malta</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_prep_queue_Singapore</fullName>
        <description>Assign to prep queue - Singapore</description>
        <field>OwnerId</field>
        <lookupValue>Visitation_Prep_Singapore</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to prep queue - Singapore</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_prep_queue_Williston</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_admin_Fab9_10</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to prep queue - Williston</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_prep_queue_non_Fab</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitation_Prep_Non_Fab</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to prep queue - non-Fab</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_reserved_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Visitations_Reserved_Dresden</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to reserved queue for Dresden</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_reserved_queue_for_Malta</fullName>
        <description>Assign to reserved queue for Malta</description>
        <field>OwnerId</field>
        <lookupValue>Visitations_Reserved_Malta</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to reserved queue for Malta</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_reserved_queue_for_Singapore</fullName>
        <description>Assign to reserved queue for Singapore</description>
        <field>OwnerId</field>
        <lookupValue>Visitations_Reserved_Singapore</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to reserved queue for Singapore</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_Visitation_Appr</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Visitation_Confirmed_Approved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to Visitation Appr.</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_Visitation_RecPV</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Visitation_Record_Post_Visit</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to Visitation RecPV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_Visitation_RecRO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Visitation_Record_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to Visitation RecRO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_Visitation_Record</fullName>
        <description>Post visit form</description>
        <field>RecordTypeId</field>
        <lookupValue>Visitation_Record</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to Visitation Record</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_Visitation_Request</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Visitation_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to Visitation Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_Visitation_Reserve</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Visitation_Reservation</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to Visitation Reserve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Stage_to_5_Pending_Survey</fullName>
        <field>Customer_Status__c</field>
        <literalValue>5. Closed-Pending Survey</literalValue>
        <name>Change Stage to 5 Pending Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Stage_to_5_Rejected_v2_0</fullName>
        <field>Customer_Status__c</field>
        <literalValue>5. Closed - Rejected</literalValue>
        <name>Change Stage to 5 Rejected_2.0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_stage_from_0_to_1</fullName>
        <field>Customer_Status__c</field>
        <literalValue>1. Reservation requested</literalValue>
        <name>Change stage from 0 to 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_stage_from_0_to_1_1</fullName>
        <field>Customer_Status__c</field>
        <literalValue>1. Regional Approval</literalValue>
        <name>Change stage from 0 to 1.0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_stage_from_1_to_0</fullName>
        <description>Change stage from 1 to 0</description>
        <field>Customer_Status__c</field>
        <name>Change stage from 1 to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>PreviousValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_stage_to_1</fullName>
        <field>Customer_Status__c</field>
        <literalValue>1. Regional Approval</literalValue>
        <name>Change stage from 0 to 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_stage_to_2</fullName>
        <field>Customer_Status__c</field>
        <literalValue>2. Confirmed</literalValue>
        <name>Change stage to 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_stage_to_3</fullName>
        <field>Customer_Status__c</field>
        <literalValue>3. Logistics Preparation</literalValue>
        <name>Change stage to 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_stage_to_4</fullName>
        <field>Customer_Status__c</field>
        <literalValue>4. Logistics Complete</literalValue>
        <name>Change stage to 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_stage_to_5_cancelled</fullName>
        <field>Customer_Status__c</field>
        <literalValue>5. Closed - Cancelled</literalValue>
        <name>Change stage to 5 cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_stage_to_5_complete</fullName>
        <field>Customer_Status__c</field>
        <literalValue>5. Closed - Completed</literalValue>
        <name>Change stage to 5 complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gregg_Bartlett_is_Requested</fullName>
        <field>Gregg_Bartlett__c</field>
        <literalValue>R</literalValue>
        <name>Gregg Bartlett is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gregg_reset</fullName>
        <field>Gregg_Bartlett__c</field>
        <name>Gregg reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ibrahim_Ajami_is_Requested</fullName>
        <field>Ibrahim_Ajami__c</field>
        <literalValue>R</literalValue>
        <name>Ibrahim Ajami is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ibrahim_reset</fullName>
        <field>Ibrahim_Ajami__c</field>
        <name>Ibrahim reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>John_B_reset</fullName>
        <field>John_Bucher__c</field>
        <name>John B reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>John_Bucher_is_Requested</fullName>
        <description>John Bucher is Requested</description>
        <field>John_Bucher__c</field>
        <literalValue>R</literalValue>
        <name>John Bucher is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>John_G_reset</fullName>
        <field>John_GoldsBerry__c</field>
        <name>John G reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>John_Goldsberry_is_Requested</fullName>
        <description>Update the Executive JG to Requested</description>
        <field>John_GoldsBerry__c</field>
        <literalValue>R</literalValue>
        <name>John Goldsberry is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>KC_Ang_is_Requested</fullName>
        <description>Update the Executive KCA to Requested</description>
        <field>KC_Ang__c</field>
        <literalValue>R</literalValue>
        <name>KC Ang is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>KC_reset</fullName>
        <field>KC_Ang__c</field>
        <name>KC reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rutger_Wijburg_is_Requested</fullName>
        <description>Update the Executive RW to Requested</description>
        <field>Rutger_Wijburg__c</field>
        <literalValue>R</literalValue>
        <name>Rutger Wijburg is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rutger_reset</fullName>
        <field>Rutger_Wijburg__c</field>
        <name>Rutger reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sanjay_Jha_is_Requested</fullName>
        <description>Update the Executive SJ to Requested</description>
        <field>Sanjay_K_Jha__c</field>
        <literalValue>R</literalValue>
        <name>Sanjay Jha is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sanjay_reset</fullName>
        <field>Sanjay_K_Jha__c</field>
        <name>Sanjay reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approved_by_RH_back_to_Null</fullName>
        <field>Approved_by_RH__c</field>
        <literalValue>0</literalValue>
        <name>Set Approved by RH back to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approved_by_RH_to_True</fullName>
        <description>Sets the Approved by RH to True to activate the alert to the executives.</description>
        <field>Approved_by_RH__c</field>
        <literalValue>1</literalValue>
        <name>Set Approved by RH to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Send_Manual_Updates_to_Executive_Now</fullName>
        <description>Set Send Manual Updates to Executive Now back to Null</description>
        <field>Send_Updates_to_Executives_Now__c</field>
        <literalValue>0</literalValue>
        <name>Set Send Manual Updates to Executive Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_stage_to_previous_on_recall</fullName>
        <field>Customer_Status__c</field>
        <name>Set stage to previous on recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>PreviousValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_5_Approval_Required</fullName>
        <field>Stage_5_Approval_Required__c</field>
        <literalValue>1</literalValue>
        <name>Stage 5 Approval Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Terry_Daly_is_Requested</fullName>
        <field>Terry_Daly__c</field>
        <literalValue>R</literalValue>
        <name>Terry Daly is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Terry_reset</fullName>
        <field>Terry_Daly__c</field>
        <name>Terry reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Thomas_Caulfield_is_Requested</fullName>
        <field>Thomas_Caulfield__c</field>
        <literalValue>R</literalValue>
        <name>Thomas Caulfield is Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Thomas_reset</fullName>
        <field>Thomas_Caulfield__c</field>
        <name>Thomas reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Time_Based_WF</fullName>
        <field>Time_Based_WF__c</field>
        <formula>Now()</formula>
        <name>Time Based WF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Objectives_GF_s_Customer_s</fullName>
        <field>Objectives_GF_s_Customer_s__c</field>
        <formula>&quot;&lt;GF&gt; &quot; &amp; GLOBALFOUNDRIES_Objectives__c &amp; BR()&amp; &quot;&lt;CUST&gt; &quot; &amp;Customer_Objectives__c</formula>
        <name>Update Objectives GF&apos;s/Customer&apos;s</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Visitation_Field_Updated</fullName>
        <field>Customer_Status__c</field>
        <literalValue>5. Closed - Completed</literalValue>
        <name>Visitation Field Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Visitation_Stage_Pending_Survey</fullName>
        <field>Customer_Status__c</field>
        <literalValue>5. Closed-Pending Survey</literalValue>
        <name>Visitation Stage_Pending Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Visitation_Stage_Updated</fullName>
        <field>Customer_Status__c</field>
        <literalValue>5. Closed - Completed</literalValue>
        <name>Visitation Stage Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Executive Visit Request Notification - Alexie Lee</fullName>
        <actions>
            <name>Inform_Alexie_Lee_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Alexie_Lee_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;Alexie Lee&quot;) &amp;&amp;  NOT((ISPICKVAL(Alexie_Lee__c, &quot;C&quot;) ||ISPICKVAL(Alexie_Lee__c, &quot;D&quot;)|| ISPICKVAL(Alexie_Lee__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;Alexie Lee&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Executive Visit Request Notification - Ana Hunter</fullName>
        <actions>
            <name>Inform_Ana_Hunter_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Ana_Hunter_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;Ana Hunter&quot;) &amp;&amp;  NOT((ISPICKVAL(Ana_Hunter__c, &quot;C&quot;) ||ISPICKVAL(Ana_Hunter__c, &quot;D&quot;)|| ISPICKVAL(Ana_Hunter__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;Ana Hunter&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Executive Visit Request Notification - Gregg Bartlett</fullName>
        <actions>
            <name>Inform_Gregg_Bartlett_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Gregg_Bartlett_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;Gregg Bartlett&quot;) &amp;&amp;  NOT((ISPICKVAL(Gregg_Bartlett__c, &quot;C&quot;) ||ISPICKVAL(Gregg_Bartlett__c, &quot;D&quot;)|| ISPICKVAL(Gregg_Bartlett__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;Gregg Bartlett&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Executive Visit Request Notification - Ibrahim Ajami</fullName>
        <actions>
            <name>Inform_Ibrahim_Ajami_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Ibrahim_Ajami_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;Ibrahim Ajami&quot;) &amp;&amp;  NOT((ISPICKVAL(Ibrahim_Ajami__c, &quot;C&quot;) ||ISPICKVAL(Ibrahim_Ajami__c, &quot;D&quot;)|| ISPICKVAL(Ibrahim_Ajami__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;Ibrahim Ajami&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Executive Visit Request Notification - John Bucher</fullName>
        <actions>
            <name>Inform_John_Bucher_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>John_Bucher_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;John Bucher&quot;) &amp;&amp;  NOT((ISPICKVAL(John_Bucher__c, &quot;C&quot;) ||ISPICKVAL(John_Bucher__c, &quot;D&quot;)|| ISPICKVAL(John_Bucher__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;John Bucher&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Executive Visit Request Notification - John Goldsberry</fullName>
        <actions>
            <name>Inform_John_Goldsberry_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>John_Goldsberry_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;John Goldsberry&quot;) &amp;&amp;  NOT((ISPICKVAL(John_GoldsBerry__c, &quot;C&quot;) ||ISPICKVAL(John_GoldsBerry__c, &quot;D&quot;)|| ISPICKVAL(John_GoldsBerry__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;John Goldsberry&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Executive Visit Request Notification - KC Ang</fullName>
        <actions>
            <name>Inform_KC_Ang_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>KC_Ang_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;KC Ang&quot;) &amp;&amp;  NOT((ISPICKVAL(KC_Ang__c, &quot;C&quot;) ||ISPICKVAL(KC_Ang__c, &quot;D&quot;)|| ISPICKVAL(KC_Ang__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;KC Ang&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Executive Visit Request Notification - Rutger Wijburg</fullName>
        <actions>
            <name>Inform_Rutger_Wijburg_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Rutger_Wijburg_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;Rutger Wijburg&quot;) &amp;&amp;  NOT((ISPICKVAL(Rutger_Wijburg__c, &quot;C&quot;) ||ISPICKVAL(Rutger_Wijburg__c, &quot;D&quot;)|| ISPICKVAL(Rutger_Wijburg__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;Rutger Wijburg&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Executive Visit Request Notification - Sanjay K%2E Jha</fullName>
        <actions>
            <name>Inform_Sanjay_Jha_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sanjay_Jha_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;Sanjay K. Jha&quot;) &amp;&amp;  NOT((ISPICKVAL(Sanjay_K_Jha__c, &quot;C&quot;) ||ISPICKVAL(Sanjay_K_Jha__c, &quot;D&quot;)|| ISPICKVAL(Sanjay_K_Jha__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;Sanjay K. Jha&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Executive Visit Request Notification - Terry Daly</fullName>
        <actions>
            <name>Inform_Terry_Daly_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Terry_Daly_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;Terry Daly&quot;) &amp;&amp;  NOT((ISPICKVAL(Terry_Daly__c, &quot;C&quot;) ||ISPICKVAL(	Terry_Daly__c, &quot;D&quot;)|| ISPICKVAL(Terry_Daly__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;Terry Daly&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Executive Visit Request Notification - Thomas Caulfield</fullName>
        <actions>
            <name>Inform_Thomas_Caulfield_of_Visitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Send_Manual_Updates_to_Executive_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Thomas_Caulfield_is_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES(Requested_Executives__c, &quot;Thomas Caulfield&quot;) &amp;&amp;  NOT((ISPICKVAL(Thomas_Caulfield__c, &quot;C&quot;) ||ISPICKVAL(	Thomas_Caulfield__c, &quot;D&quot;)|| ISPICKVAL(Thomas_Caulfield__c, &quot;R&quot;)))   &amp;&amp; (Approved_by_RH__c = True) || INCLUDES(Requested_Executives__c, &quot;Thomas Caulfield&quot;)  &amp;&amp;  (Send_Updates_to_Executives_Now__c = True) &amp;&amp; NOT(ISPICKVAL(Customer_Status__c, &quot;0. Draft&quot;)) &amp;&amp;  NOT(ISPICKVAL(Customer_Status__c, &quot;1. Reservation requested&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Executives Requested 1-10 fields to null when in Draft status</fullName>
        <actions>
            <name>Alexie_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Ana_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Gregg_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Ibrahim_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>John_B_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>John_G_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>KC_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Rutger_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sanjay_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 )</booleanFilter>
        <criteriaItems>
            <field>Visitation_Record__c.Customer_Status__c</field>
            <operation>equals</operation>
            <value>0. Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.Alexie_Lee__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.Ana_Hunter__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.Gregg_Bartlett__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.Ibrahim_Ajami__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.John_Bucher__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.John_GoldsBerry__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.KC_Ang__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.Rutger_Wijburg__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.Sanjay_K_Jha__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>keep Requested  fields 1-10 from being set before being submitted.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Executives Requested 11-13 fields to null when in Draft status</fullName>
        <actions>
            <name>Terry_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Thomas_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 )</booleanFilter>
        <criteriaItems>
            <field>Visitation_Record__c.Customer_Status__c</field>
            <operation>equals</operation>
            <value>0. Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.Terry_Daly__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.Thomas_Caulfield__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>keep Requested  fields 11-13 from being set before being submitted.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Visitation Waiting Stage Change</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Visitation_Record__c.Customer_Status__c</field>
            <operation>equals</operation>
            <value>4. Logistics Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Visitation_Stage_Pending_Survey</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Visitation_Record__c.End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Visitation_Closed_Completed</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Visitation_Record__c.Customer_Status__c</field>
            <operation>equals</operation>
            <value>5. Closed-Pending Survey</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Visitation_Field_Updated</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Visitation_Record__c.End_Date__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Visitation_Survey_Send</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Visitation_Record__c.Customer_Status__c</field>
            <operation>equals</operation>
            <value>5. Closed-Pending Survey</value>
        </criteriaItems>
        <criteriaItems>
            <field>Visitation_Record__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Visitation_Record__c.End_Date__c</offsetFromField>
            <timeLength>36</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
