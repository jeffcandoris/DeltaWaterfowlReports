trigger OpportunityBenefitTrigger on Opportunity_Benefit__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	new OpportunityBenefitTriggerHandler().run();
}