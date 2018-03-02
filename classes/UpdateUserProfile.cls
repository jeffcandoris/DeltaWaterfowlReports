public with sharing class UpdateUserProfile implements Queueable, Database.AllowsCallouts {

  private Set<ID> userIds;
  private Id profileId;

  public UpdateUserProfile(Set<Id> userIds, String profileId) {
    this.userIds = userIds;
    this.profileId = profileId;
  }

  public void execute(QueueableContext context) {
    List<User> users = [select id from user where id in: userIds and isportalenabled = true and profileId !=: profileId];

    for (User userObj : users) {
      userObj.profileId = profileId;
    }
    update users;
    if (!Test.isRunningTest()) {
      System.enqueueJob(new UpdateWordpressProfile(userIds, 'Delta Member'));
    }
  }
}