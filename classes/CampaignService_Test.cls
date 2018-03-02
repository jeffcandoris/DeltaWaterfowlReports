@isTest
private class CampaignService_Test {

  @isTest
  static void testSetParentDefaults() {
    npsp__General_Accounting_Unit__c gau = new npsp__General_Accounting_Unit__c();
    gau.name = 'Test GAU';
    insert gau;

    Campaign parentCamp = new Campaign();
    parentCamp.name = 'Parent';
    parentCamp.Landing_Page_URL__c = 'http://www.google.com';
    parentCamp.Primary_Department__c = 'DEV';
    parentCamp.Primary_GAU__c = gau.id;
    parentCamp.Default_Letter_Code__c = 'Mem';
    parentCamp.Default_Market_Code__c = 'foo';
    parentCamp.StartDate = Date.newInstance(2016, 8, 3);
    parentCamp.EndDate = Date.newInstance(2016, 8, 3);
    insert parentcamp;

    Campaign childCamp = new Campaign();
    childCamp.name = 'Child';
    childCamp.parentId = parentCamp.id;

    Test.StartTest();
    insert childCamp;
    Test.StopTest();

    Campaign selectedCamp = [Select id, Landing_Page_URL__c, Primary_Department__c, Primary_GAU__c, Default_Letter_Code__c, Default_Market_Code__c, StartDate, EndDate from campaign where id =: childCamp.id][0];
    System.assertEquals(selectedCamp.Landing_Page_URL__c, parentcamp.Landing_Page_URL__c);
    System.assertEquals(selectedCamp.Primary_Department__c, parentcamp.Primary_Department__c);
    System.assertEquals(selectedCamp.Primary_GAU__c, parentcamp.Primary_GAU__c);
    System.assertEquals(selectedCamp.Default_Letter_Code__c, parentcamp.Default_Letter_Code__c);
    System.assertEquals(selectedCamp.Default_Market_Code__c, parentcamp.Default_Market_Code__c);
    System.assertEquals(selectedCamp.StartDate, parentcamp.StartDate);
    System.assertEquals(selectedCamp.EndDate, parentcamp.EndDate);
  }

  @isTest
  static void testAddCampaignMemberStatusItems() {
    Campaign camp = new Campaign();
    camp.name = 'camp';
    insert camp;
    List<CampaignMemberStatus> cmsList = [select id, Label from CampaignMemberStatus where CampaignId =: camp.id];
    System.assertEquals(4, cmsList.size());
    Set<String> statusSet = new Set<String>();
    for (CampaignMemberStatus cms : cmsList) {
      statusSet.add(cms.Label);
    }
    System.assertEquals(true, statusSet.contains('Invited'));
    System.assertEquals(true, statusSet.contains('Attending'));
    System.assertEquals(true, statusSet.contains('Attended'));
    System.assertEquals(true, statusSet.contains('Absent'));
  }

  @isTest
  static void testSetStartEndDate() {
    Campaign camp = new Campaign();
    camp.name = 'camp';
    camp.Start_Time__c = DateTime.newInstance(2016, 8, 3);
    camp.End_Time__c = DateTime.newInstance(2016, 8, 4);
    insert camp;

    Campaign selectedCamp = [Select StartDate, EndDate, Primary_Department__c from campaign where id =: camp.id][0];
    System.assertEquals(selectedCamp.StartDate.year(), 2016);
    System.assertEquals(selectedCamp.EndDate.year(), 2016);
    System.assertEquals(selectedCamp.StartDate.month(), 8);
    System.assertEquals(selectedCamp.EndDate.month(), 8);
    System.assertEquals(selectedCamp.StartDate.day(), 3);
    System.assertEquals(selectedCamp.EndDate.day(), 4);
  }
}