public with sharing class GAUTriggerHandler extends TriggerHandler {
  // public override void beforeInsert() {
  //
  // }
  // public override void afterInsert() {
  //
  // }
  public override void beforeUpdate() {
    GAUService.calculateAllocationRollups((Map<Id, npsp__General_Accounting_Unit__c>)trigger.newMap, (Map<Id, npsp__General_Accounting_Unit__c>)trigger.oldMap);
  }
  public override void afterUpdate() {
    GAUService.calculateParentAllocationRollups((Map<Id, npsp__General_Accounting_Unit__c>)trigger.newMap, (Map<Id, npsp__General_Accounting_Unit__c>)trigger.oldMap);
  }
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