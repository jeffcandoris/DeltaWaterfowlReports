public with sharing class CampaignService {
// TODO: Tests
  public static void setParentDefaults(List<Campaign> campaigns) {
    Set<Id> parentIds = new Set<Id>();
    List<Campaign> filteredCampaigns = new List<Campaign>();
    for (Campaign camp : campaigns) {
      if (camp.parentId != null) {
        parentIds.add(camp.parentId);
        filteredCampaigns.add(camp);
      }
    }
    List<Campaign> parentCampaigns = [select id, Landing_Page_URL__c, Primary_Department__c, Primary_GAU__c, Default_Letter_Code__c, Default_Market_Code__c, StartDate, EndDate from Campaign where id in :parentIds];
    for (Campaign camp : filteredCampaigns) {
      for (Campaign parentCamp : parentCampaigns) {
        if (camp.ParentId == parentCamp.id) {
          if (camp.Landing_Page_URL__c == null) {
            camp.Landing_Page_URL__c = parentCamp.Landing_Page_URL__c;
          }
          if (camp.Primary_Department__c == null) {
            camp.Primary_Department__c = parentCamp.Primary_Department__c;
          }
          if (camp.Primary_GAU__c == null) {
            camp.Primary_GAU__c = parentCamp.Primary_GAU__c;
          }
          if (camp.Default_Letter_Code__c == null) {
            camp.Default_Letter_Code__c = parentCamp.Default_Letter_Code__c;
          }
          if (camp.Default_Market_Code__c == null) {
            camp.Default_Market_Code__c = parentCamp.Default_Market_Code__c;
          }
          if (camp.StartDate == null) {
            camp.StartDate = parentCamp.StartDate;
          }
          if (camp.EndDate == null) {
            camp.EndDate = parentCamp.EndDate;
          }
          break;
        }
      }
    }
  }

  public static void addCampaignMemberStatusItems(List<Campaign> campaigns) {
    List<String> statuses = new List<String> { 'Invited', 'Attending', 'Attended', 'Absent' };
    List<CampaignMemberStatus> cmsList = new List<CampaignMemberStatus>();
    for (Campaign camp : campaigns) {
      for(Integer i = 0; i < statuses.size(); i++) {
        String status = statuses[i];
        CampaignMemberStatus cms = new CampaignMemberStatus();
        cms.campaignId = camp.id;
        cms.HasResponded = status != 'Invited';
        cms.IsDefault = status == 'Invited';
        cms.Label = status;
        cms.SortOrder = i + 3;
        cmsList.add(cms);
      }
    }
    insert cmsList;
  }

  public static void setStartEndDate(List<Campaign> campaigns) {
    for(Campaign camp : campaigns) {
      if (camp.Start_Time__c != null) {
        camp.StartDate = Date.newinstance(camp.Start_Time__c.year(), camp.Start_Time__c.month(), camp.Start_Time__c.day());
      }
      if (camp.End_Time__c != null) {
        camp.EndDate = Date.newinstance(camp.End_Time__c.year(), camp.End_Time__c.month(), camp.End_Time__c.day());
      }
    }
  }
}