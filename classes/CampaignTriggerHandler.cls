public with sharing class CampaignTriggerHandler extends TriggerHandler {
  public override void beforeInsert() {
    CampaignService.setStartEndDate(trigger.new);
    CampaignService.setParentDefaults(trigger.new);
  }
  public override void afterInsert() {
    CampaignService.addCampaignMemberStatusItems(trigger.new);
    // CampaignService.setChildrenLandingURL(trigger.new);
  }
  public override void beforeUpdate() {
    CampaignService.setStartEndDate(trigger.new);
  }
  // public override void afterUpdate() {
  //   // CampaignService.setChildrenLandingURL(trigger.new);
  // }
  // public override void beforeDelete() {
  //
  // }
  // public override void afterDelete() {
  //
  // }
  // public override void afterUndelete() {
  //
  // }
}