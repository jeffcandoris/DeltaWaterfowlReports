global without sharing class EventsController {

  @RemoteAction
  global static List<Campaign> getEvents(Integer month, Integer year, String state) {
    Integer numDays = Date.daysInMonth(year, month);
    Datetime beginningDate = Datetime.newInstance(year, month, 1, 0, 0, 0);
    Datetime endingDate = Datetime.newInstance(year, month, numDays, 23, 59, 59);
    String query = 'SELECT ' +
            'ID, ' +
            'Name, ' +
            'StartDate, ' +
            'EndDate, ' +
            'Location__c, ' +
            'City__c, ' +
            'State__c, ' +
            'Location_Address__c, ' +
            'Landing_Page_URL__c, ' +
            'Start_Time__c, ' +
            'End_Time__c ' +
            'FROM Campaign ' +
            'WHERE isactive=true ' +
              'AND RecordType.Name=\'Event\' ' +
              'AND Type != \'Expo\'' +
              'AND Start_Time__c >= :beginningDate ' +
              'AND Start_Time__c <= :endingDate ';
    if (!String.isEmpty(state)) {
      query = query + 'AND State__c = :state ';
    }
    query = query + 'ORDER BY StartDate ASC';
    return Database.query(query);
  }

  @RemoteAction
  global static Campaign getEventDetails(String eventId) {
    List<Campaign> campaignList = [SELECT ID,
                                   Name,
                                   StartDate,
                                   EndDate,
                                   Description_Rich__c,
                                   Location__c,
                                   City__c,
                                   State__c,
                                   Location_Address__c,
                                   Start_Time__c,
                                   End_Time__c,
                                   Primary_Contact__c,
                                   Primary_Contact__r.Phone,
                                   Primary_Contact__r.Email,
                                   Primary_Contact__r.FirstName,
                                   Primary_Contact__r.LastName FROM Campaign WHERE id = :eventId];
    return campaignList.isEmpty() ? null : campaignList[0];
  }
}