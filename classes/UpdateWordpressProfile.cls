public with sharing class UpdateWordpressProfile implements Queueable, Database.AllowsCallouts {

  private Set<ID> userIds;
  private String profileName;

  public UpdateWordpressProfile(Set<Id> userIds, String profileName) {
    this.userIds = userIds;
    this.profileName = profileName;
  }

  private static HttpResponse sendWordpressPayload(String body) {
    HttpRequest req = new HttpRequest();
    req.setBody(body);
    req.setEndpoint('https://deltawaterfowl.wpengine.com/api/salesforce/updateUserSalesforceProfile');
    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    req.setHeader('39f7828f-A81c-4d66-8287-87d95422e7e8', 'a1e97426-29e8-4417-a8c3-265e49a2ad94');
    req.setMethod('POST');
    req.setTimeout(30000);
    Http http = new Http();
    if (Test.isRunningTest()) {
      return null;
    }
    return http.send(req);
  }

  public void execute(QueueableContext context) {
    List<User> users = [select email from user where id in: userIds and isportalenabled = true];
    Integer i = 0;
    String[] parts = new List<String>();
    for (User userObj : users) {
      parts.add('users[' + i + '][email]=' + EncodingUtil.urlEncode(userObj.email, 'UTF-8'));
      parts.add('users[' + i + '][profile]=' + EncodingUtil.urlEncode(profileName, 'UTF-8'));
      i++;
    }
    sendWordpressPayload(String.join(parts, '&'));
  }
}