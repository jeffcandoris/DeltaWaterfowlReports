global with sharing class EventsByDate_Controller {
  @AuraEnabled
  public static List<Campaign> getEventDetails() {
    return [SELECT
            ID,
            Name,
            StartDate,
            EndDate,
            Location__c,
            Location_Address__c,
            Start_Time__c,
            End_Time__c
            FROM Campaign
            WHERE isactive=true
            AND RecordType.Name='Event'
            AND EndDate >= TODAY
            ORDER BY StartDate ASC];
  }

  @RemoteAction
  global static List<Campaign> getEvents() {
    return [SELECT
            ID,
            Name,
            StartDate,
            EndDate,
            Location__c,
            Location_Address__c,
            Start_Time__c,
            End_Time__c
            FROM Campaign
            WHERE isactive=true
            AND RecordType.Name='Event'
            AND EndDate >= TODAY
            ORDER BY StartDate ASC];
  }
}