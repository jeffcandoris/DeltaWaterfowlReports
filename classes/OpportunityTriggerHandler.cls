public without sharing class OpportunityTriggerHandler extends TriggerHandler {

  public override void beforeInsert() {
    OpportunityService.setPrimaryContact(trigger.new);
    OpportunityService.setCampaignDefaults(trigger.new);
    OpportunityService.setBundleMembershipLevel(trigger.new);
    OpportunityService.calculateMembershipDetails(trigger.new);
    OpportunityService.createTransactionsFromOpportunities(trigger.new);
    OpportunityService.setValidationDate(trigger.new);
  }
  public override void afterInsert() {
    OpportunityService.setPrimaryGAU(trigger.new);
    OpportunityService.updatePrimaryContactFields(trigger.new);
    List<Id> membershipOppsIds = new List<Id>();
    Id membershipRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
    for (Opportunity opp : (List<Opportunity>)trigger.new) {
      if (opp.recordTypeId == membershipRecordTypeId) {
        membershipOppsIds.add(opp.id);
      }
    }
    OpportunityService.handleNewMembershipEnqueues(membershipOppsIds);
    // OpportunityService.updateAccountFields(trigger.new);
  }
  public override void beforeUpdate() {
    OpportunityService.setValidationDate(trigger.new);
  }
  public override void afterUpdate() {
    OpportunityService.updatePrimaryContactFields(trigger.new);
    // OpportunityService.updateAccountFields(trigger.new);
    OpportunityService.updateMembershipOrigin(trigger.new, (Map<Id, Opportunity>)trigger.oldMap);
  }
  // public override void beforeDelete() {
  //
  // }
}