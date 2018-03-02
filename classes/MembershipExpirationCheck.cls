global class MembershipExpirationCheck implements Schedulable {

  global void execute(SchedulableContext sc) {
    Webstore__c ws = Webstore__c.getInstance('WooCommerce');
    List<User> users = [SELECT Id, ProfileId FROM User WHERE ProfileId != :ws.Delta_Non_Member_Profile_ID__c AND contactId in (SELECT Id FROM Contact WHERE npo02__MembershipEndDate__c < TODAY)];

    Set<Id> userIds = new Set<Id>();
    for (User user : users) {
      userIds.add(user.Id);
    }

    System.enqueueJob(new UpdateUserProfile(userIds, ws.Delta_Non_Member_Profile_ID__c));
    System.enqueueJob(new UpdateWordpressProfile(userIds, 'Delta Non-Member'));
  }
}