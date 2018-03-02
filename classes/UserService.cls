public without sharing class UserService {
  // @InvocableMethod
  // public static void updateUserData(List<ID> oppIds) {
  //   List<User> users = [select id from user where isportalenabled = true and contactId in (SELECT npsp__Primary_Contact__c FROM Opportunity WHERE npe01__Membership_End_Date__c > TODAY AND Id IN :oppIds)];
  //   Set<Id> userIds = new Set<Id>();
  //   for (User u : users) {
  //     userIds.add(u.id);
  //   }
  //   if (userIds.size() > 0) {
  //     Webstore__c ws = Webstore__c.getInstance('WooCommerce');
  //     if (ws != null) {
  //       System.enqueueJob(new UpdateUserProfile(userIds, ws.Delta_Member_Profile_ID__c));
  //     }
  //     if (!Test.isRunningTest()) {
  //       System.enqueueJob(new UpdateWordpressProfile(userIds, 'Delta Member'));
  //     }
  //   }
  // }
}