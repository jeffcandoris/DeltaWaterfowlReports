public with sharing class OpportunityBenefitTriggerHandler extends TriggerHandler {
  // public override void beforeInsert() {
  //
  // }
  public override void afterInsert() {
    OpportunityBenefitService.setBenefitStats(trigger.new);
  }
  // public override void beforeUpdate() {
  //
  // }
  public override void afterUpdate() {
    OpportunityBenefitService.setBenefitStats(trigger.new);
  }
  // public override void beforeDelete() {
  //
  // }
  public override void afterDelete() {
    OpportunityBenefitService.setBenefitStats(trigger.old);
  }
  public override void afterUndelete() {
    OpportunityBenefitService.setBenefitStats(trigger.new);
  }
}