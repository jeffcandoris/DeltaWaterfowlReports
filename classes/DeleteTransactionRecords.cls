global class DeleteTransactionRecords implements Database.Batchable <sObject>, Schedulable {

  public List<Transaction__c> transList = [SELECT Id FROM Transaction__c WHERE Opportunity_Count__c = 0];
	public class applicationException extends Exception {}

  global void execute(SchedulableContext sc) {
    Database.executebatch(this);
  }

  global List<Transaction__c> start(Database.BatchableContext BC) {
    return transList;
  }

  global void execute(Database.BatchableContext BC, List <Transaction__c> scope) {
		delete scope;
  }

  global void finish(Database.BatchableContext BC) {
  }
}