<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Book_Price_for_the_Lot_Instr</fullName>
        <description>Sets the Book Price for the Lot Instruction</description>
        <field>Book_Price_for_Lot_Expedite__c</field>
        <formula>CASE ( Expedite_Type_To_Meet_CRD_CSR__c , 
&quot;Hot&quot;, Lot_Request__r.Lot_Request_Price_Table__r.Standard_Price_to_Expedite_to_Hot__c , 
&quot;Bullet/Rocket&quot;,  Lot_Request__r.Lot_Request_Price_Table__r.Standard_Price_to_Expedite_to_Bullet__c ,
&quot;Hand Carry/Super Rocket&quot;,  Lot_Request__r.Lot_Request_Price_Table__r.Standard_Price_to_Expedite_to_Hand_Carry__c ,
0)</formula>
        <name>LotInstr:BookPrice:Formula</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Concat_Unique_String_for_LotInstruction</fullName>
        <field>UniqueField__c</field>
        <formula>Lot_Request__c +&apos;;&apos;+ Manufacturing_Lot__c</formula>
        <name>LotInstr:UniqueField:LotReq+MFG Lot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_for_Able_to_Support_Fabout_Date</fullName>
        <field>New_CSD_P__c</field>
        <formula>Current_Schedule_Date_CSD_ML__c</formula>
        <name>LotInstr:NewCSD(P):CurrentSchDate(ML)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Did_ActaulFOD_meets_AbleToSupp_to_Yes</fullName>
        <field>Did_Actual_FOD_meets_AbleToSupport_FOD__c</field>
        <literalValue>Yes</literalValue>
        <name>LotInstr:ActualFODmeetAbleToSupFOD:Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Did_ActualFOD_meets_AbleToSupp_to_No</fullName>
        <field>Did_Actual_FOD_meets_AbleToSupport_FOD__c</field>
        <literalValue>No</literalValue>
        <name>LotInstr:ActualFODmeetAbleToSupFOD:No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LotInstr_LSR_NoOfMissed_Increment</fullName>
        <field>No_of_Missed_Instructions__c</field>
        <formula>Lot_Request__r.No_of_Missed_Instructions__c + 1</formula>
        <name>LotInstr:LSR NoOfMissed: Increment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Lot_Request__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LotInstr_LSR_NoOfPassed_Increment</fullName>
        <description>Increase the count of No. of Passed Instructions by 1</description>
        <field>No_of_Passed_Instructions__c</field>
        <formula>Lot_Request__r.No_of_Passed_Instructions__c + 1</formula>
        <name>LotInstr:LSR NoOfPassed: Increment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Lot_Request__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lot_Instr_Mark_PE_Lot_false</fullName>
        <description>Marks Wafer Lot is is on Expedite (PE) based upon the Lot Type Code.</description>
        <field>Wafer_Lot_is_on_PE__c</field>
        <literalValue>0</literalValue>
        <name>LotInstr:WaferLotInPE:FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lot_Instr_Mark_PE_Lot_true</fullName>
        <description>Marks Wafer Lot is on PE to indicate status of expedites.</description>
        <field>Wafer_Lot_is_on_PE__c</field>
        <literalValue>1</literalValue>
        <name>LotInstr:WaferLotInPE:TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lot_Instr_Set_Wafer_Quantity_in_the_Lot</fullName>
        <description>Sets the Wafer Quantity in the Lot in the Lot Instruction equal the Wafer Quantity in the Lot for the Manufacturing Lot</description>
        <field>Current_Wafer_Quantity_in_the_Lot_ML__c</field>
        <formula>Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c</formula>
        <name>LotInstr:CurrentWaferQtyinLot(ML):FromML</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lot_Instr_Update_Current_Wafer_in_Lot</fullName>
        <description>Update the Current Wafers in the Lot in Lot Instruction to Match the Manufacturing Lot</description>
        <field>Current_Wafer_Quantity_in_the_Lot_ML__c</field>
        <formula>Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c</formula>
        <name>Lot Instr Update Current Wafer in Lot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Did_ActaulFOD_meets_AbleToSupp</fullName>
        <field>Did_Actual_FOD_meets_AbleToSupport_FOD__c</field>
        <literalValue>Not Assigned</literalValue>
        <name>LotInstr:ActualFODmeetAbleToSupFOD:NA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Lot_Type_from_Mfg_Lot</fullName>
        <field>Lot_Type__c</field>
        <formula>Manufacturing_Lot__r.Lot_Type__c</formula>
        <name>LotInstr:LotType:LotType(ML)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Book_Price_for_the_Lot_Expedite</fullName>
        <description>Sets the Book Price based upon the Lot Expedite Type and the Discount and the mask layer remaining.</description>
        <field>Book_Price_for_Lot_Expedite__c</field>
        <formula>CASE( Expedite_Type_To_Meet_CRD_CSR__c ,
&quot;Hot&quot;,  Lot_Request__r.Lot_Request_Price_Table__r.Standard_Price_to_Expedite_to_Hot__c ,
&quot;Bullet/Rocket&quot;,
Lot_Request__r.Lot_Request_Price_Table__r.Standard_Price_to_Expedite_to_Bullet__c ,
&quot;Hand Carry/Super Rocket&quot;,
 Lot_Request__r.Lot_Request_Price_Table__r.Standard_Price_to_Expedite_to_Hand_Carry__c ,
0) * (1-
CASE ( Manufacturing_Lot__r.Current_Wafer_Lot_Progress_Quartile__c ,
&quot;Lot Progress 100%&quot;,0,
&quot;Lot Progress between 75% - 100%&quot;, Lot_Request__r.Lot_Request_Price_Table__r.Discount_if_75_Processed__c ,
&quot;Lot Progress between 50% - 75%&quot;,  Lot_Request__r.Lot_Request_Price_Table__r.Discount_if_50_Processed__c ,
&quot;Lot Progress between 25% - 50%&quot;,
 Lot_Request__r.Lot_Request_Price_Table__r.Discount_if_25_processed__c ,
&quot;Lot Progress &lt; 25%&quot;, 1,
&quot;Lot Not Started 0%&quot;,1,
1))</formula>
        <name>Set Book Price for the Lot Expedite</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_Approved_Lot_Removed_from_Exped</fullName>
        <description>Sets the date that an approved lot is off expedite.</description>
        <field>Date_Approved_Lot_Removed_from_Expedited__c</field>
        <formula>Today()</formula>
        <name>LotInstr:DateApprovedLotRemoved:TODAY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Expedite_Price_for_Lot_Instruction</fullName>
        <description>Set the Book Price for the Lot Expedite</description>
        <field>Book_Price_for_Lot_Expedite__c</field>
        <formula>CASE( Expedite_Type_To_Meet_CRD_CSR__c , 
&quot;Hot&quot;,Lot_Request__r.Lot_Request_Price_Table__r.Standard_Price_to_Expedite_to_Hot__c,
&quot;Bullet/Rocket&quot;, Lot_Request__r.Lot_Request_Price_Table__r.Standard_Price_to_Expedite_to_Bullet__c ,
&quot;Hand Carry/Super Rocket&quot;, Lot_Request__r.Lot_Request_Price_Table__r.Standard_Price_to_Expedite_to_Hand_Carry__c ,
0)</formula>
        <name>Set Expedite Price for Lot Instruction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Submitted_Customer_Request_Date_CRD</fullName>
        <field>Submitted_Customer_Request_Date_CRD__c</field>
        <formula>Lot_Request__r.New_Customer_Requested_Date_CRD_CSR__c</formula>
        <name>LotInstr:SubmitteddCRD:NewCRD(P)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sets_Able_to_Support_minus_Fabout_Out</fullName>
        <description>Sets Able to Support minus Fabout Date. If positive value then we met commitment.</description>
        <field>Able_to_Support_Minus_Fabout_Date__c</field>
        <formula>( New_CSD_P__c )- ( Current_Fabout_Date_ML__c )</formula>
        <name>LotInstr:AbleToSupMinusFaboutDate:Frmula</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sets_Date_Approved_Lots_Expedited_Toda</fullName>
        <description>This captures the date when a Planner Approved Lot was expedited.</description>
        <field>Date_Approved_Lot_Expedited__c</field>
        <formula>Today()</formula>
        <name>LotInstr:DateApprovedLotExpedited:TODAY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sets_Did_Ship_Date_Meet_New_CSD_No_Ship</fullName>
        <description>Sets Did Ship Date Meet New CSD to No Ship Date</description>
        <field>Did_Ship_Date_Meet_New_CSD__c</field>
        <literalValue>No Ship Date</literalValue>
        <name>LotInstr:ShipDateMeetNewCSD:NoShipDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sets_Did_Ship_Date_Meet_New_CSD_to_No</fullName>
        <field>Did_Ship_Date_Meet_New_CSD__c</field>
        <literalValue>No</literalValue>
        <name>LotInstr:ShipDateMeetNewCSD:No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sets_Did_Ship_Date_Meet_New_CSD_to_Yes</fullName>
        <description>Sets the Did Ship Date Meet the New CSD to yes.</description>
        <field>Did_Ship_Date_Meet_New_CSD__c</field>
        <literalValue>Yes</literalValue>
        <name>LotInstr:ShipDateMeetNewCSD:Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sets_Expedite_Type_to_Bullet_to_Meet_CRD</fullName>
        <description>Sets Expedite Type to Meet CRD Bullet</description>
        <field>Expedite_Type_To_Meet_CRD_CSR__c</field>
        <literalValue>Bullet/Rocket</literalValue>
        <name>LotInstr:ExpediteType(CSR):Bullet/Rocket</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sets_Expedite_Type_to_Hand_Carry_to_Meet</fullName>
        <description>Sets Expedite Type to meet CRD to Hand Carry</description>
        <field>Expedite_Type_To_Meet_CRD_CSR__c</field>
        <literalValue>Hand Carry/Super Rocket</literalValue>
        <name>LotInstr:ExpediteType(CSR):HandCarry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sets_Expedite_Type_to_Hot_to_Meet_CRD</fullName>
        <description>Sets Expedite Type to Hot</description>
        <field>Expedite_Type_To_Meet_CRD_CSR__c</field>
        <literalValue>Hot</literalValue>
        <name>LotInstr:ExpediteType(CSR):Hot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sets_Expedite_Type_to_Standard_to_Meet_C</fullName>
        <description>Sets Expedite Type to Standard.</description>
        <field>Expedite_Type_To_Meet_CRD_CSR__c</field>
        <literalValue>Standard</literalValue>
        <name>LotInstr:ExpediteType(CSR):Standard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Count_Against_Corridor</fullName>
        <field>Count_Against_Corridor__c</field>
        <literalValue>Yes</literalValue>
        <name>LotInstr:CountAgainstCorridor:Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Field_Approved_Under_Corridor</fullName>
        <field>Approved_Under_Corridor__c</field>
        <literalValue>Yes</literalValue>
        <name>LotInstr:ApprovedUnderCorridor:Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_CRD_Submitted_Date_to_Today</fullName>
        <field>New_CRD_Submitted_Date__c</field>
        <formula>Today()</formula>
        <name>LotInstr:NewCRDsubmittedDate:TODAY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_CSD_Submitted_Date</fullName>
        <field>New_CSD_Submitted_Date__c</field>
        <formula>Today()</formula>
        <name>LotInstr:NewCSDsubmittedDate:TODAY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Remaining_Mask_Count_at_New_CRD</fullName>
        <field>Remaining_Mask_Count_at_New_CRD_Submiss__c</field>
        <formula>Remaining_Mask_Count_ML__c</formula>
        <name>LotInstr:RemainingMaskCountAtCRDsub:FrML</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Remaining_Mask_Count_at_New_CSD</fullName>
        <field>Remaining_Mask_Count_at_New_CSD_Submiss__c</field>
        <formula>Remaining_Mask_Count_ML__c</formula>
        <name>LotInstr:RemainingMaskCountAtCSDsub:FrML</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Default values from Lot Request to Lot Instruction</fullName>
        <actions>
            <name>Default_for_Able_to_Support_Fabout_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>For new lot instructions, the default value of submitted fab out date to equal the customer requested new fabout date from the the lot request.
Similarly default for able to support request date equal to planner approved fabout date from the lot request.</description>
        <formula>ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lot Instr Mark Approved PE Lot %3D false</fullName>
        <actions>
            <name>Lot_Instr_Mark_PE_Lot_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Date_Approved_Lot_Removed_from_Exped</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lot_Instruction__c.Lot_Type__c</field>
            <operation>notContain</operation>
            <value>PE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lot_Instruction__c.Able_to_Support_Request_P__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lot_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Closed - Cancelled by Customer,Closed - Fully Executed,Closed - Cancelled Internally,Closed - Rejected,Closed - Partially Executed,Fully Approved,Under Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lot_Instruction__c.Wafer_Lot_is_on_PE__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Changes the Wafer Lot is on PE to false when the Lot Type is not PE after it was approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lot Instr Mark Approved PE Lot %3D true</fullName>
        <actions>
            <name>Lot_Instr_Mark_PE_Lot_true</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sets_Date_Approved_Lots_Expedited_Toda</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lot_Instruction__c.Lot_Type__c</field>
            <operation>contains</operation>
            <value>PE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lot_Instruction__c.Able_to_Support_Request_P__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lot_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Closed - Cancelled by Customer,Closed - Fully Executed,Closed - Cancelled Internally,Closed - Rejected,Closed - Partially Executed,Fully Approved,Under Execution</value>
        </criteriaItems>
        <description>Sets the Lot is on PE wafer flag necessary for Summary Roll up.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lot Instr Set Current Wafers in the Lot Value</fullName>
        <actions>
            <name>Lot_Instr_Set_Wafer_Quantity_in_the_Lot</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Current Wafers in the Lot (ML) in the Lot Instruction to the Value Set from the Manufacturing Lot</description>
        <formula>Current_Wafer_Quantity_in_the_Lot_ML__c  &lt;&gt; Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LotInstr%3AShipToCustomerDate DidNotMeet NewCSD%28P%29</fullName>
        <actions>
            <name>LotInstr_LSR_NoOfMissed_Increment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sets_Did_Ship_Date_Meet_New_CSD_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ship to Customer Date Met New CSD is set to No if there is Ship to Customer Date and the Ship to Customer Date is past the New CSD</description>
        <formula>!ISBLANK(Ship_to_Customer_Date_ML__c) &amp;&amp; Ship_to_Customer_Date_ML__c &gt; New_CSD_P__c &amp;&amp; Stage__c  = &apos;Fully Approved&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LotInstr%3AShipToCustomerDate Meet NewCSD%28P%29</fullName>
        <actions>
            <name>LotInstr_LSR_NoOfPassed_Increment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sets_Did_Ship_Date_Meet_New_CSD_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ship to Customer Date has met the New CSD Date</description>
        <formula>!ISBLANK(Ship_to_Customer_Date_ML__c) &amp;&amp;  New_CSD_P__c &gt;= Ship_to_Customer_Date_ML__c &amp;&amp; Stage__c  = &apos;Fully Approved&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LotInstr%3AShipToCustomerDate%3A NoShipDate</fullName>
        <actions>
            <name>Sets_Did_Ship_Date_Meet_New_CSD_No_Ship</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lot_Instruction__c.Ship_to_Customer_Date_ML__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Maintain Uniqueness for combination of MgfLot and LotRequest</fullName>
        <actions>
            <name>Concat_Unique_String_for_LotInstruction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Instruction Status to No</fullName>
        <actions>
            <name>Did_ActualFOD_meets_AbleToSupp_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( !ISBLANK(Actual_Fab_Out_Date__c)&amp;&amp; !ISBLANK(New_CSD_P__c) &amp;&amp; Actual_Fab_Out_Date__c &gt; New_CSD_P__c , True, False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Instruction Status to Not Assigned</fullName>
        <actions>
            <name>Populate_Did_ActaulFOD_meets_AbleToSupp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( ISBLANK(Actual_Fab_Out_Date__c) || ISBLANK(New_CSD_P__c), True, False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Instruction Status to Yes</fullName>
        <actions>
            <name>Did_ActaulFOD_meets_AbleToSupp_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( !ISBLANK(Actual_Fab_Out_Date__c)&amp;&amp; !ISBLANK(New_CSD_P__c) &amp;&amp; Actual_Fab_Out_Date__c &lt;= New_CSD_P__c , True, False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Submitted Customer Request Date CRD on creation</fullName>
        <actions>
            <name>Set_Submitted_Customer_Request_Date_CRD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lot_Instruction__c.Submitted_Customer_Request_Date_CRD__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Populate Submitted_Customer_Request_Date_CRD__c from LotRequest--&gt; New_Customer_Requested_Date_CRD_CSR__c if the fild is blank.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Submitted_Customer_Request_Date_CRD%5F%5Fc on creation</fullName>
        <actions>
            <name>Set_Submitted_Customer_Request_Date_CRD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lot_Instruction__c.Submitted_Customer_Request_Date_CRD__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Populate Submitted_Customer_Request_Date_CRD__c from LotRequest--&gt; New_Customer_Requested_Date_CRD_CSR__c if the fild is blank.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Field - Approved Under Corridor</fullName>
        <actions>
            <name>Update_Field_Approved_Under_Corridor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lot_Request__c.Planner_Recommendation_P__c</field>
            <operation>equals</operation>
            <value>Approved Under Corridor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lot_Instruction__c.Able_to_Support_Request_P__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lot_Request__c.Expedite_Manager_Recommendation_EM__c</field>
            <operation>equals</operation>
            <value>Approved Under Corridor</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Field - Count Against Corridor</fullName>
        <actions>
            <name>Update_Count_Against_Corridor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lot_Instruction__c.Actual_Fab_Out_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lot_Instruction__c.Approved_Under_Corridor__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sets Able to Support minus Fabout Out</fullName>
        <actions>
            <name>Sets_Able_to_Support_minus_Fabout_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lot_Instruction__c.Fabout_Quantity_ML__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sets Expedite Type to Bullet to Meet CRD</fullName>
        <actions>
            <name>Book_Price_for_the_Lot_Instr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sets_Expedite_Type_to_Bullet_to_Meet_CRD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Expedite Type to Meet CRD upon creation. Assumes 2 days post fab processing. Bullet.</description>
        <formula>(Submitted_Customer_Request_Date_CRD__c  -2 &lt; Fabout_Ship_Date_if_Hot_LR__c ) &amp;&amp;  (Submitted_Customer_Request_Date_CRD__c  -2 &gt;=   Fabout_Ship_Date_if_Bullet_LR__c )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sets Expedite Type to Hand Carry to Meet CRD</fullName>
        <actions>
            <name>Book_Price_for_the_Lot_Instr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sets_Expedite_Type_to_Hand_Carry_to_Meet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Expedite Type to Meet CRD upon creation. Assumes 2 days post fab processing. Hand Carry.</description>
        <formula>/*(New_Customer_Requested_Date_CRD_CSR__c -2 &lt; Fabout_Ship_Date_if_Bullet_LR__c ) &amp;&amp; (New_Customer_Requested_Date_CRD_CSR__c -2 &gt;=   Fabout_Ship_Date_if_Hand_Carry_LR__c )*/  Submitted_Customer_Request_Date_CRD__c  -2 &lt; Fabout_Ship_Date_if_Bullet_LR__c</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sets Expedite Type to Hot to Meet CRD</fullName>
        <actions>
            <name>Book_Price_for_the_Lot_Instr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sets_Expedite_Type_to_Hot_to_Meet_CRD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Expedite Type to Meet CRD upon creation.  Assumes 2 days post fab processing. Hot.</description>
        <formula>(Submitted_Customer_Request_Date_CRD__c  -2 &lt; Fabout_Ship_Date_If_Standard_LR__c ) &amp;&amp;  (Submitted_Customer_Request_Date_CRD__c  -2 &gt;= Fabout_Ship_Date_if_Hot_LR__c )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sets Expedite Type to Standard to Meet CRD</fullName>
        <actions>
            <name>Book_Price_for_the_Lot_Instr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sets_Expedite_Type_to_Standard_to_Meet_C</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Expedite Type to Meet CRD upon creation.  Assumes 2 days post fab processing. Standard.</description>
        <formula>( Submitted_Customer_Request_Date_CRD__c  -2 &gt;= Fabout_Ship_Date_If_Standard_LR__c )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Ship to Customer Date Did Not Meet New CSD</fullName>
        <actions>
            <name>Sets_Did_Ship_Date_Meet_New_CSD_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Ship to Customer Date Met New CSD is set to No if there is Ship to Customer Date and the Ship to Customer Date is past the New CSD</description>
        <formula>(Ship_to_Customer_Date_ML__c &lt;&gt; null) &amp;&amp;  (Ship_to_Customer_Date_ML__c &gt; New_CSD_P__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Ship to Customer Date Met New CSD</fullName>
        <actions>
            <name>Sets_Did_Ship_Date_Meet_New_CSD_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Ship to Customer Date has met the New CSD Date</description>
        <formula>(Ship_to_Customer_Date_ML__c &lt;&gt; null) &amp;&amp; ( New_CSD_P__c &gt;= Ship_to_Customer_Date_ML__c   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Ship to Customer Date is NULL</fullName>
        <actions>
            <name>Sets_Did_Ship_Date_Meet_New_CSD_No_Ship</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lot_Instruction__c.Ship_to_Customer_Date_ML__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Submitted New CRD</fullName>
        <actions>
            <name>Update_New_CRD_Submitted_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Remaining_Mask_Count_at_New_CRD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Fields when Submitted Customer Request Date (CRD) has been added or modified</description>
        <formula>ISNEW()||ISCHANGED(Submitted_Customer_Request_Date_CRD__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Submitted New CSD</fullName>
        <actions>
            <name>Update_New_CSD_Submitted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Remaining_Mask_Count_at_New_CSD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update fields upon New CSD submitted or edited</description>
        <formula>ISNEW()||ISCHANGED(New_CSD_P__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lot Instruction with Manufacturing Lot Data</fullName>
        <actions>
            <name>Lot_Instr_Update_Current_Wafer_in_Lot</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>Current_Wafer_Quantity_in_the_Lot_ML__c &lt;&gt; Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lot Type from Mfg Lot</fullName>
        <actions>
            <name>Populate_Lot_Type_from_Mfg_Lot</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the Book Price for Lot Instr</fullName>
        <actions>
            <name>Book_Price_for_the_Lot_Instr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Book Price for the Lot Instruction.</description>
        <formula>OR(    /*ISNEW(),*/    AND(         !ISPICKVAL(Expedite_Type_To_Meet_CRD_CSR__c,&apos;&apos;),         ISCHANGED(Expedite_Type_To_Meet_CRD_CSR__c)    ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
