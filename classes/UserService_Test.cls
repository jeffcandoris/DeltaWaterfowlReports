@isTest
public class UserService_Test {

  // public class UpdateWordpressProfileMock implements HttpCalloutMock {
  //   protected Integer code;
  //   protected String status;
  //   protected String bodyAsString;
  //   protected Blob bodyAsBlob;
  //   protected Map<String, String> responseHeaders;
  //
  //   public UpdateWordpressProfileMock(Integer code, String status, String body, Map<String, String> responseHeaders) {
  //     this.code = code;
  //     this.status = status;
  //     this.bodyAsString = body;
  //     this.bodyAsBlob = null;
  //     this.responseHeaders = responseHeaders;
  //   }
  //
  //   public UpdateWordpressProfileMock(Integer code, String status, Blob body, Map<String, String> responseHeaders) {
  //     this.code = code;
  //     this.status = status;
  //     this.bodyAsBlob = body;
  //     this.bodyAsString = null;
  //     this.responseHeaders = responseHeaders;
  //   }
  //
  //   public HttpResponse respond(HttpRequest req) {
  //     HttpResponse res = new HttpResponse();
  //     res.setStatusCode(code);
  //     res.setStatus(status);
  //     if (bodyAsBlob != null) {
  //       res.setBodyAsBlob(bodyAsBlob);
  //     } else {
  //       res.setBody(bodyAsString);
  //     }
  //
  //     if (responseHeaders != null) {
  //       for (String key : responseHeaders.keySet()) {
  //         res.setHeader(key, responseHeaders.get(key));
  //       }
  //     }
  //
  //     return res;
  //   }
  // }

  @isTest
  static void testUpdateWordpressProfile() {
    User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

    System.runAs(currentUser) {
      Set<Id> ids = new Set<Id>{currentUser.id};
      Test.StartTest();
      System.enqueueJob(new UpdateWordpressProfile(ids, 'Delta Member'));
      Test.StopTest();
    }
  }

  @isTest
  static void testUpdateUserProfile() {

    Profile nonMemberProfile = [SELECT Id FROM Profile WHERE Name='Delta Non-Member'][0];
    Profile memberProfile = [SELECT Id FROM Profile WHERE Name='Delta Member'][0];

    Contact con = new Contact();
    con.firstname = 'test';
    con.lastname = 'contact';
    con.email = 'test@email.com';
    con.npo02__MembershipEndDate__c = date.newInstance(2016, 10, 10);
    insert con;

    User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

    System.runAs(currentUser) {
      User us = new User();
      us.contactId = con.id;
      us.profileId = nonMemberProfile.id;
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

      Set<Id> ids = new Set<Id>{us.id};
      Test.StartTest();
      System.enqueueJob(new UpdateUserProfile(ids, memberProfile.id));
      Test.StopTest();
      currentUser = [SELECT Id, ProfileId FROM User WHERE Id = :us.Id];
      System.assertEquals(memberProfile.id, currentUser.profileId);
    }
  }
}