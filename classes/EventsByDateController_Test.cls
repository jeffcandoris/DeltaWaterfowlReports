@isTest
private class EventsByDateController_Test {
  static testMethod void EventsByDateController() {

    Campaign c1 = new Campaign();

    c1.Name = 'Jeff';
    c1.StartDate = Date.today();
    c1.EndDate = Date.today();
    c1.Location__c = 'Here';
    c1.Start_Time__c = Datetime.now();
    c1.End_Time__c = Datetime.now();
    insert c1;

    Test.StartTest();
    List<Campaign> returnData = EventsByDate_Controller.getEventDetails();
    system.assertNotEquals(returnData.size(), 1);
    Test.StopTest();
  }
}