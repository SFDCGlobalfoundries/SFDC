trigger URLUpdateOnPartTrigger on Part_Family__c (after insert, after update,before update,before insert) {
    MDD_familyURLUpdateHelper obj = new MDD_familyURLUpdateHelper();
    if(trigger.isAfter && trigger.isInsert){
        obj.getFolderLinks(trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate){
        obj.getOldFolderLinks(trigger.new,trigger.old);
    }
}