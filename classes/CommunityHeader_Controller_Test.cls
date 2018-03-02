@isTest
private class CommunityHeader_Controller_Test {

  //private static User createCommunityTestUser() {
  //  Account acc = new Account();
  //  acc.name = 'TEST ACCOUNT';
  //  insert acc;
  //  Contact con = new Contact();
  //  con.lastName = 'Contact' + String.valueOf(Math.Random() * 1000);
  //  con.firstName = 'Test';
  //  con.email = 'testContactEmail@testemail.com';
  //  con.AccountID = acc.id;
  //  insert con;
  //  Profile p = [SELECT Id, Name, UserType FROM Profile WHERE Name = 'Delta Member' ];
  //  User u = new User();
  //  u.Alias = 'gor38ghawo';
  //  u.Email = 'communityuser' + String.valueOf(Math.Random() * 1000) + '@communityTestOrg.com';
  //  u.EmailEncodingKey = 'UTF-8';
  //  u.LastName = 'Testing';
  //  u.LanguageLocaleKey = 'en_US';
  //  u.LocaleSidKey = 'en_US';
  //  u.ProfileId = p.Id;
  //  u.contactId = con.Id;
  //  u.TimeZoneSidKey = 'America/Los_Angeles';
  //  u.UserName = 'communityuser' + String.valueOf(Math.Random() * 1000) + '@communityTestOrg.com';
  //  return u;
  //}

  //static testMethod void testCommunityHeaderController() {

  //  User usr = createCommunityTestUser();

  //  PageReference pageRef = Page.DeltaDashboard;
  //  Test.setCurrentPage(pageRef);
  //  PageReference nextPage = null;

  //  Test.startTest();
  //  CommunityHeader_Controller ctrl = new CommunityHeader_Controller();

  //  String returnDataType = CommunityHeader_Controller.fetchUserType();
  //  system.assertNotEquals(returnDataType, null);

  //  String returnDataID = CommunityHeader_Controller.fetchUserID();
  //  system.assertNotEquals(returnDataID, null);

  //  String returnDataName = CommunityHeader_Controller.fetchName();
  //  system.assertNotEquals(returnDataName, null);

  //  Test.StopTest();
  //}
}