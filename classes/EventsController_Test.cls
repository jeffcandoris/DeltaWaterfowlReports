@isTest
private class EventsController_Test {
  @isTest
  static void testGetEvents() {

    Integer numDays = Date.daysInMonth(2016, 10);
    List<Campaign> testCampaignList = new List<Campaign>();

    // Event in current month
    Campaign testCampaign1 = new Campaign();
    testCampaign1.Name = 'testCampaign1';
    testCampaign1.isactive = true;
    testCampaign1.City__c = 'Annville';
    testCampaign1.State__c = 'MD';
    testCampaign1.Location_Address__c = '456 testAddress2';
    testCampaign1.Landing_Page_URL__c = 'www.testCampaign1.com';
    testCampaign1.RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Event').getRecordTypeId();
    testCampaign1.Start_Time__c = Datetime.newInstance(2016, 10, 15, 12, 0, 0);
    testCampaign1.End_Time__c = Datetime.newInstance(2016, 10, 15, 17, 30, 0);

    // Another event in current month
    Campaign testCampaign2 = new Campaign();
    testCampaign2.Name = 'testCampaign2';
    testCampaign2.isactive = true;
    testCampaign2.City__c = 'Annville';
    testCampaign2.State__c = 'PA';
    testCampaign2.Location_Address__c = '456 testAddress3';
    testCampaign2.Landing_Page_URL__c = 'www.testCampaign2.com';
    testCampaign2.RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Event').getRecordTypeId();
    testCampaign2.Start_Time__c = Datetime.newInstance(2016, 10, 20, 13, 0, 0);
    testCampaign2.End_Time__c = Datetime.newInstance(2016, 10, 20, 17, 30, 0);

    // Another event in current month
    Campaign testCampaign3 = new Campaign();
    testCampaign3.Name = 'testCampaign3';
    testCampaign3.isactive = true;
    testCampaign3.City__c = 'Annville';
    testCampaign3.State__c = 'NY';
    testCampaign3.Location_Address__c = '456 testAddress3';
    testCampaign3.Landing_Page_URL__c = 'www.testCampaign3.com';
    testCampaign3.RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Event').getRecordTypeId();
    testCampaign3.Start_Time__c = Datetime.newInstance(2016, 11, 20, 13, 0, 0);
    testCampaign3.End_Time__c = Datetime.newInstance(2016, 11, 20, 17, 30, 0);

    insert testCampaign1;
    insert testCampaign2;
    insert testCampaign3;

    Test.StartTest();

    List<Campaign> eventList = EventsController.getEvents(10, 2016, null);
    System.assertEquals(2, eventList.size());

    eventList = EventsController.getEvents(10, 2016, 'PA');
    System.assertEquals(1, eventList.size());

    Test.StopTest();
  }
}