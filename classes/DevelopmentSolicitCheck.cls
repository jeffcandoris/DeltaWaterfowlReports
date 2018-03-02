global class DevelopmentSolicitCheck implements Database.Batchable <sObject>, Schedulable {

  private String query = 'select id, Development_Team_Solicit__c, accountId, account.ownerId, account.owner.delta_department__c from contact';
  public class applicationException extends Exception {}

  global void execute(SchedulableContext sc) {
    Database.executebatch(this);
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List <Contact> scope) {
    for (Contact c : scope) {
      c.Development_Team_Solicit__c = c.account.Owner.delta_department__c == 'DEV';
    }
    update scope;
  }

  global void finish(Database.BatchableContext BC) {
  }
}