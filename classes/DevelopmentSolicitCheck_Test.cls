@isTest
private class DevelopmentSolicitCheck_Test {

  static Account generateGenericAccount(Integer i) {
    Account acc = new Account();
    acc.name = 'Test' + i;
    return acc;
  }

  static Contact generateGenericContact(Integer i) {
    Contact con = new Contact();
    con.firstname = 'Test' + i;
    con.lastname = 'Test' + i;
    con.email = i + 'test@email.com';
    return con;
  }

  static User generateGenericUser(Id profileId, Integer i) {
    User newUser = new User();
    newUser.profileId = profileId;
    newUser.Username = i + 'test@email.com';
    newUser.FirstName = 'Test' + i;
    newUser.LastName = 'Test' + i;
    newUser.Email = i + 'test@email.com';
    newUser.Alias = 'Test' + i;
    newUser.TimeZoneSidKey = 'America/Los_Angeles';
    newUser.LocaleSidKey = 'en_US';
    newUser.EmailEncodingKey = 'UTF-8';
    newUser.LanguageLocaleKey = 'en_US';
    return newUser;
  }

  @isTest
  static void testDevelopmentSolicitCheck() {
    User currentUser = [SELECT Id, profileId FROM User WHERE Id = :UserInfo.getUserId()];

    System.runAs(currentUser) {

      Profile nonMemberProfile = [SELECT Id FROM Profile WHERE Name='Delta Non-Member'][0];
      Profile memberProfile = [SELECT Id FROM Profile WHERE Name='Delta Member'][0];

      Webstore__c setting = new Webstore__c();
      setting.Name = 'WooCommerce';
      setting.Web_Merchandise_Pricebook_ID__c = 'blah';
      setting.Web_Merchandise_Pricebook_ID_CAD__c = 'blah';
      setting.Web_Ticket_Pricebook_ID__c = 'blah';
      setting.Web_Ticket_Pricebook_ID_CAD__c = 'blah';
      setting.X3_Year_Benefit_Id__c = 'blah';
      setting.Delta_Member_Profile_ID__c = memberProfile.Id;
      setting.Delta_Non_Member_Profile_ID__c = nonMemberProfile.Id;
      insert setting;

      User devOwner = generateGenericUser(currentUser.profileId, 1);
      devOwner.delta_department__c = 'DEV';
      insert devOwner;

      User nonDevOwner = generateGenericUser(currentUser.profileId, 2);
      insert nonDevOwner;

      Account devOwnerAcc = generateGenericAccount(1);
      devOwnerAcc.ownerId = devOwner.id;
      insert devOwnerAcc;

      Account nonDevOwnerAcc = generateGenericAccount(1);
      nonDevOwnerAcc.ownerId = nonDevOwner.id;
      insert nonDevOwnerAcc;

      Contact devOwnerCon = generateGenericContact(1);
      devOwnerCon.accountId = devOwnerAcc.id;
      Contact anotherDevOwnerCon = generateGenericContact(2);
      anotherDevOwnerCon.accountId = devOwnerAcc.id;
      Contact nonDevOwnerCon = generateGenericContact(3);
      nonDevOwnerCon.accountId = nonDevOwnerAcc.id;
      Contact alreadyMarkedbutNonDev = generateGenericContact(4);
      alreadyMarkedbutNonDev.accountId = nonDevOwnerAcc.id;
      alreadyMarkedbutNonDev.Development_Team_Solicit__c = true;

      List<Contact> contacts = new List<Contact>{
        devOwnerCon,
        anotherDevOwnerCon,
        nonDevOwnerCon,
        alreadyMarkedbutNonDev
      };
      insert contacts;

      Set<Id> contactIds = Utils.listToIdSet(contacts);

      Test.StartTest();
      new DevelopmentSolicitCheck().execute(null, [select id, Development_Team_Solicit__c, accountId, account.ownerId, account.owner.delta_department__c from Contact where id in: contactIds] );
      Test.StopTest();

      System.assertEquals(2, [select id, Development_Team_Solicit__c from Contact where id in: contactIds and Development_Team_Solicit__c = true].size());
    }
  }
}