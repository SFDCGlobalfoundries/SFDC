/*
    Author: Abhita Bansal
    Description: This Class contains the Constants used in the Classes of eWSR Form
    Created Date: 2/12/2014
    Updated date-21-12-2016 updated by Jabee for the case#00064604 
*/
public class eWSRConstantsVariablesClass{
    
    public Static String FAB2RECORDTYPE = 'FAB 2';
    public Static String FAB3RECORDTYPE = 'FAB 3';
    public Static String FAB3ERECORDTYPE = 'FAB 3E';
    public Static String FAB5RECORDTYPE = 'FAB 5';
    public Static String FAB5JVRECORDTYPE = 'FAB 5JV';
    public Static String FAB6RECORDTYPE = 'FAB 6';
    public Static String FAB7RECORDTYPE = 'FAB 7';
    
    public static String FAB7RECTYPEDEVNAME = 'FAB_7';
    
    public Static String FAB2QNAME = 'eWSR Production Control for FAB 2';
    public Static String FAB3QNAME = 'eWSR Production Control for FAB 3';
    public Static String FAB3EQNAME = 'eWSR Production Control for FAB 3E';
    public Static String FAB5QNAME = 'eWSR Production Control for FAB 5';
    public Static String FAB5JVQNAME = 'eWSR Production Control for FAB 5JV';
    public Static String FAB6QNAME = 'eWSR Production Control for FAB 6';
    public Static String FAB7QNAME = 'eWSR Production Control for FAB 7';
    
    public Static String FAB5JVPUBLICGP = 'eWSR FAB 5JV Users';
    
    public Static String STARTMATERIALFIELDVALUE = 'Yes (This is unknown source unscrap.Lot owner to provide substrate)';
    
    public Static String SYSADMINPROFILE = 'System Administrator'; 
    public Static String GFPLANPROFILE = 'GF Planning platform';//Jabee for the case#00064604 
    public Static String GFPLANSTDPROFILE = 'GF Planning Standard';//Jabee for the case#00064604 
    
    public Static String EDIT = 'Edit';
    public Static String QUEUE = 'Queue';
    public Static String PUBLICGP = 'Regular';
    public Static String EWSRFORMSOBJECT = 'eWSR_Form__c';
    
    public Static String STATUSNEW = 'New';
    public Static String STATUSAPPROVED = 'Approved';
    public static string STATUSREJECTED = 'Rejected';
    public Static String STATUSVOID = 'Void';
    public Static String STATUSPLANAPPROVAL = 'Pending with PC Department;Pending with Planner Approval';
    public static String STATUSPENDINGWITHSUPERVISOR = 'Pending with Supevisor';
    public static String STATUSPENDINGWITHPROGMANAGER = 'Pending with Program Manager';
    
    public Static String ERRORMSGAPPROVAL = 'Please enter the values for the following fields before approving: Lot ID Assigned and Plan Start Date';
    public Static String ERRORMSGONRECALL = 'Cannot recall the Approval Process as the Record Status is Pending with Planner Approval';
    public Static String ERRORMSGNOFAB = 'No Fab is assigned to your Profile';
    public Static String ERRORMSGFAB = 'Please select a Fab.';
    public Static String ERRORMSGYEAR = 'Please enter an year.';
    public Static String ERRORMSGMOD = 'Please select a module.';
    public Static String ERRORMSGPROG = 'Please select a program.';
    public Static String ERRORMSGNORESULTS = 'No results found. Please click on create to allocate wafers.';
    public Static String ERRORMSGNOWAFERS = 'You cannot allocate wafers for this fab.';
    public Static String ERRORMSGEQ = 'Equivalent_Quantity__c is Empty';
    public Static String ERRORMSGNOACCESS = 'No access on this record';
    public Static String ERRORMSGNOSAVE = 'Cannot Save the record as the Status is Void';
    public Static String ERRORMSGLOTQUAN = 'Please fill the value of lot Quantity';
    public Static String ERRORMSGCHKDATE = 'No Wafer Allocation Records are present for this Requested Start Date. Please check it.';
    public Static String ERRORMSGREQ = 'Requested Start Date should be greater than today';
    public Static String ERRORMSGREQFLDS = 'Please fill the required Fields:No of SOP Holds (0.6 day/hold), No of SPSRs (0.8 day/SPSR), No of Additional days required';
    public Static String ERRORMSGUPDATE = 'Please click on Search button after saving the record to get the updated results';
    public Static String ERRORMSGNORECORD = 'No Wafer Allocation Records are present for the Date provided in the Plan Start Date';
    public Static String ERRORMSGWAFERMATERIAL = 'Wafer Quantity value can not be exceeded beyond 500';
    public Static String ERRORMSGCHKFIELDS = 'Either of the fields(Emp Id, Wafer Starting Material, Total Number of Mask Layer, Process ID) are null. Please provide the value. ';
}