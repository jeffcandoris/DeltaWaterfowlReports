@isTest
private class MembershipExpirationCheck_Test {

  @isTest
  static void testCheckMembershipExpiration() {
    User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

    System.runAs(currentUser) {
      Contact con = new Contact();
      con.firstname = 'test';
      con.lastname = 'contact';
      con.email = 'test@email.com';
      con.npo02__MembershipEndDate__c = date.newInstance(2016, 10, 10);
      insert con;

      Account acc = [SELECT Id FROM Account WHERE npe01__One2OneContact__c = :con.Id][0];

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

      User us = new User();
      us.contactId = con.id;
      us.profileId = memberProfile.id;
      us.Username = 'test@email.com';
      us.LastName = 'test';
      us.Email = 'test@email.com';
      us.Alias = 'test';
      us.CommunityNickname = 'unit_test';
      us.TimeZoneSidKey = 'America/Los_Angeles';
      us.LocaleSidKey = 'en_US';
      us.EmailEncodingKey = 'UTF-8';
      us.LanguageLocaleKey = 'en_US';
      insert us;

      Test.StartTest();
      User selectedUser = [SELECT Id, ProfileId FROM User WHERE Id = :us.Id];
      System.assertEquals(memberProfile.Id, selectedUser.profileId);
      new MembershipExpirationCheck().execute(null);
      Test.StopTest();
      // Now that the scheduled job has executed after Test.stopTest(),
      // fetch the new ProfileId that got updated.
      selectedUser = [SELECT Id, ProfileId FROM User WHERE Id = :us.Id];
      System.assert(con.npo02__MembershipEndDate__c < DateTime.now());
      System.assertEquals(nonMemberProfile.id, selectedUser.profileId);
    }
  }
}