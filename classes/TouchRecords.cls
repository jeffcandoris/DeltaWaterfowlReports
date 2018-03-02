global class TouchRecords implements Database.Batchable<sObject> {
  private String query;

  global TouchRecords(String query) {
    this.query = query;
  }

  global Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext bc, List<sObject> scope) {
    update scope;
  }

  global void finish(Database.BatchableContext bc) {}
}