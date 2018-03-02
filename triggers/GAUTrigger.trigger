trigger GAUTrigger on npsp__General_Accounting_Unit__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	new GAUTriggerHandler().run();
}