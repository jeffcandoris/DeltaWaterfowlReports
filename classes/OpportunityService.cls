public without sharing class OpportunityService {

  // TODO: make this a custom setting?
  public static Integer determineComparisonValue(String level) {

    if (level == 'Gratis') {
      return 1;
    } else if (level == 'Youth') {
      return 2;
    } else if (level == 'Friend') {
      return 3;
    } else if (level == 'Supporter') {
      return 4;
    } else if (level == 'Sponsor') {
      return 5;
    } else if (level == 'Canvasback Sponsor') {
      return 6;
    } else if (level == 'Patron') {
      return 7;
    } else if (level == 'President’s Circle') {
      return 8;
    } else if (level == 'Lifetime') {
      return 9;
    } else {
      return 0;
    }
  }

  public static String determineComparisonLevel(String newLevel, String oldLevel) {
    Integer oldValue = determineComparisonValue(oldLevel);
    if (oldValue == 0)  {
      return '';
    }
    Integer newValue = determineComparisonValue(newLevel);
    if (newValue > oldValue) {
      return 'Upgrade';
    } else if (newValue < oldValue) {
      return 'Downgrade';
    } else {
      return 'Same';
    }
  }

  public static void setPrimaryContact(List<Opportunity> oppList) {
    List<Id> accountIds = new List<Id>();
    List<Opportunity> filteredOpps = new List<Opportunity>();
    for (Opportunity opp : oppList) {
      if (opp.npsp__Primary_Contact__c == null && opp.accountId != null) {
        accountIds.add(opp.accountId);
        filteredOpps.add(opp);
      }
    }
    List<Account> accounts = [Select id, npe01__One2OneContact__c from Account where id in :accountIds and npe01__One2OneContact__c != null];
    for (Opportunity opp : filteredOpps) {
      for (Account acc : accounts) {
        if (opp.accountId == acc.id) {
          opp.npsp__Primary_Contact__c = acc.npe01__One2OneContact__c;
        }
      }
    }
  }

  public static void setCampaignDefaults(List<Opportunity> oppList) {
    List<Id> campaignIds = new List<Id>();
    List<Opportunity> filteredOpps = new List<Opportunity>();
    for (Opportunity opp : oppList) {
      if (opp.campaignId != null) {
        campaignIds.add(opp.campaignId);
        filteredOpps.add(opp);
      } else if (opp.Market_Source_Code__c == 'Woocommerce Online') {
        opp.Market_Source_Code__c = 'Online';
      }
    }

    List<Campaign> campaigns = [Select id, Primary_Department__c, Default_Letter_Code__c, Default_Market_Code__c from Campaign where id in :campaignIds and Primary_Department__c != null];
    for (Opportunity opp : filteredOpps) {
      for (Campaign camp : campaigns) {
        if (opp.campaignId == camp.id) {
          if (opp.Department__c == null) {
            opp.Department__c = camp.Primary_Department__c;
          }
          if (opp.Letter_Code__c == null) {
            opp.Letter_Code__c = camp.Default_Letter_Code__c;
          }
          if (opp.Market_Source_Code__c == null) {
            opp.Market_Source_Code__c = camp.Default_Market_Code__c;
          } else if (opp.Market_Source_Code__c == 'Woocommerce Online') {
            opp.Market_Source_Code__c = camp.Default_Market_Code__c == null ? 'Online' : camp.Default_Market_Code__c;
          }
        }
      }
    }
  }

  public static void setBundleMembershipLevel(List<Opportunity> opps) {
    Set<Id> bundleIds = new Set<Id>();
    List<Opportunity> filteredOpps = new List<Opportunity>();
    for (Opportunity opp : opps) {
      if (opp.Membership_Bundle__c != null) {
        bundleIds.add(opp.Membership_Bundle__c);
        filteredOpps.add(opp);
      }
    }

    List<Membership_Bundle__c> bundleBenefits = [Select Id, Membership_Level__c from Membership_Bundle__c where id in :bundleIds];

    for (Opportunity opp : filteredOpps) {
      for (Membership_Bundle__c bundleBenefit : bundleBenefits) {
        if (opp.Membership_Bundle__c == bundleBenefit.id) {
          opp.npe01__Member_Level__c = bundleBenefit.Membership_Level__c;
          if (opp.description == null) {
            opp.description = (bundleBenefit.Membership_Level__c == null ? '' : bundleBenefit.Membership_Level__c + ' ') + 'Membership';
          }
        }
      }
    }
  }

  public static void createTransactionsFromOpportunities(List<Opportunity> oppList) {
    List<Transaction__c> newTransactions = new List<Transaction__c>();
    Map<Opportunity, Transaction__c> oppToTranMap = new Map<Opportunity, Transaction__c>();
    for (Opportunity opp : oppList) {
      if (opp.Transaction_Number__c == null) {
        Transaction__c tran = new Transaction__c();
        tran.Payment_Method__c = opp.Payment_Method__c;
        tran.Card_Type__c = opp.Card_Type__c;
        tran.ownerId = '00536000001teKUAAY';
        opp.Transaction_Number__c = tran.Id;
        newTransactions.add(tran);
        oppToTranMap.put(opp, tran);
      }
    }
    insert newTransactions;
    for (Opportunity opp : oppToTranMap.keySet()) {
      Transaction__c tran = oppToTranMap.get(opp);
      opp.Transaction_Number__c = tran.Id;
    }
  }

  public static void calculateMembershipDetails(List<Opportunity> oppList) {
    List<Opportunity> membershipOpps = new List<Opportunity>();
    Set<Id> contactIds = new Set<Id>();
    Set<Id> accountIds = new Set<Id>();
    Id membershipRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
    for (Opportunity opp : oppList) {
      if (opp.recordTypeId == membershipRecordTypeId) {
        membershipOpps.add(opp);
        contactIds.add(opp.npsp__Primary_Contact__c);
        accountIds.add(opp.accountId);
      }
    }
    if (membershipOpps.size() == 0) {
      return;
    }
    List<SObject> objs = new List<SObject>();
    objs.addAll((List<SObject>)[select id, npo02__MembershipEndDate__c, npo02__LastMembershipLevel__c from Contact where id in: contactIds and Account.RecordType.Name = 'Household Account']);
    objs.addAll((List<SObject>)[select id, npo02__MembershipEndDate__c, npo02__LastMembershipLevel__c from Account where id in: accountIds and Account.RecordType.Name = 'Organization']);

    for (Opportunity opp : membershipOpps) {
      if (opp.npe01__Membership_Start_Date__c == null) {
        opp.npe01__Membership_Start_Date__c = opp.CloseDate;
      }
      for (SObject obj : objs) {
        if ((Id)obj.get('id') == opp.npsp__Primary_Contact__c || (Id)obj.get('id') == opp.accountId) {
          opp.membership_comparision_level__c = determineComparisonLevel(opp.npe01__Member_Level__c, (String) obj.get('npo02__LastMembershipLevel__c'));
          if (obj.get('npo02__MembershipEndDate__c') == null) {
            opp.npe01__Membership_Origin__c = 'Acquisition';
            opp.membership_Transaction_Type__c = 'Join';
            opp.npe01__Membership_End_Date__c = opp.npe01__Membership_Start_Date__c.addYears((Integer)opp.Years__c);
            break;
          }
          opp.membership_Transaction_Type__c = 'Renew';
          if ((Date)obj.get('npo02__MembershipEndDate__c') > opp.CloseDate) {
            opp.npe01__Membership_Start_Date__c = (Date)obj.get('npo02__MembershipEndDate__c');
          }
          if (((Date) obj.get('npo02__MembershipEndDate__c')).monthsBetween(opp.CloseDate) <= 6) {
            opp.npe01__Membership_Origin__c = 'Renewal';
          } else if (((Date)obj.get('npo02__MembershipEndDate__c')).monthsBetween(opp.CloseDate) <= 24) {
            if (((Date)obj.get('npo02__MembershipEndDate__c')).month() == opp.CloseDate.month() && opp.CloseDate.day() > ((Date)obj.get('npo02__MembershipEndDate__c')).day()) {
              opp.npe01__Membership_Origin__c = 'Acquisition';
            } else {
              opp.npe01__Membership_Origin__c = 'Reactivate';
            }
          } else {
            opp.npe01__Membership_Origin__c = 'Acquisition';
          }
          break;
        }
      }
      if (opp.npe01__Membership_End_Date__c == null && opp.Years__c != null) {
        if (opp.npe01__Membership_Start_Date__c.month() == 2 && opp.npe01__Membership_Start_Date__c.day() == 29 && math.mod((Integer)opp.Years__c, 4) != 0) { // Leap Year
          opp.npe01__Membership_End_Date__c = Date.newInstance(opp.npe01__Membership_Start_Date__c.addYears((Integer)opp.Years__c).year(), 2, 28);
        } else {
          opp.npe01__Membership_End_Date__c = opp.npe01__Membership_Start_Date__c.addYears((Integer)opp.Years__c);
        }
      }
    }
  }

  public static void setPrimaryGAU(List<Opportunity> oppList) {
    Id donationRecordId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
    List<Id> campaignIds = new List<Id>();
    List<Opportunity> filteredOpps = new List<Opportunity>();
    for (Opportunity opp : oppList) {
      if (opp.RecordTypeId == donationRecordId && opp.Is_Web_Purchase__c) {
        continue;
      }
      if (opp.Amount != null && opp.Amount != 0 && opp.campaignId != null) {
        campaignIds.add(opp.campaignId);
        filteredOpps.add(opp);
      }
    }
    List<Campaign> campaigns = [Select id, Primary_GAU__c from Campaign where id in :campaignIds and Primary_GAU__c != null and Primary_GAU__r.npsp__Active__c = true];
    List<npsp__Allocation__c> allocs = new List<npsp__Allocation__c>();
    for (Opportunity opp : filteredOpps) {
      for (Campaign camp : campaigns) {
        if (opp.campaignId == camp.id) {
          npsp__Allocation__c alloc = new npsp__Allocation__c();
          alloc.npsp__Amount__c = opp.amount;
          alloc.npsp__General_Accounting_Unit__c = camp.Primary_GAU__c;
          alloc.npsp__Opportunity__c = opp.id;
          alloc.ownerId = '00536000001teKUAAY';
          allocs.add(alloc);
        }
      }
    }
    insert allocs;
  }

  // public static void updateAccountFields(List<Opportunity> opps) {
  //   Set<Id> accountIds = new Set<Id>();
  //   for(Opportunity opp : opps) {
  //     if (opp.AccountId != null) {
  //       accountIds.add(opp.AccountId);
  //     }
  //   }
  //   List<Account> accounts = [select id, First_Opp_Date__c, First_Opp_Amount__c, Last_Opp_Date__c from Account where id in: accountIds];
  //   for (Opportunity opp : opps) {
  //     for (Account acc : accounts) {
  //       if (opp.AccountId == acc.id) {
  //         if (acc.First_Opp_Date__c == null || acc.First_Opp_Amount__c == 0 || (opp.closeDate < acc.First_Opp_Date__c && opp.Amount > 0)) {
  //           acc.First_Opp_Date__c = opp.closeDate;
  //           acc.First_Opp_Amount__c = opp.amount;
  //           acc.First_Opp_Dept__c = opp.Department__c;
  //         }
  //         if (acc.Last_Opp_Date__c == null ||  opp.closeDate > acc.Last_Opp_Date__c) {
  //           acc.Last_Opp_Date__c = opp.closeDate;
  //           acc.Last_Opp_Amount__c = opp.amount;
  //         }
  //       }
  //     }
  //   }
  //   update accounts;
  // }

  public static void updatePrimaryContactFields(List<Opportunity> opps) {
    Set<Id> contactIds = new Set<Id>();
    for(Opportunity opp : opps) {
      if (opp.npsp__Primary_Contact__c != null) {
        contactIds.add(opp.npsp__Primary_Contact__c);
      }
    }
    List<Contact> contacts = [select id, Last_Event_Attended_Market_Source_Code__c from contact where id in: contactIds];
    for (Opportunity opp : opps) {
      for (Contact con : contacts) {
        if (opp.npsp__Primary_Contact__c == con.id) {
          // if (con.First_Opp_Date__c == null ||  opp.closeDate < con.First_Opp_Date__c) {
          //   con.First_Opp_Date__c = opp.closeDate;
          //   con.First_Opp_Amount__c = opp.amount;
          // }
          // if (con.Last_Opp_Date__c == null ||  opp.closeDate > con.Last_Opp_Date__c) {
          //   con.Last_Opp_Date__c = opp.closeDate;
          //   con.Last_Opp_Amount__c = opp.amount;
          // }
          if (opp.Market_Source_Code__c == 'Event' && (con.Last_Event_Attended_Market_Source_Code__c == null || opp.closeDate > con.Last_Event_Attended_Market_Source_Code__c)) {
            con.Last_Event_Attended_Market_Source_Code__c = opp.closeDate;
          }
        }
      }
    }
    update contacts;
  }

  @InvocableMethod
  public static void setDefaultBenefits(List<Id> oppIds) {
    List<Opportunity> opps = [select id, Membership_Bundle__c, Do_Not_Send_Gifts__c, Years__c, campaignId, RecordTypeId from Opportunity where id in :oppIds];
    List<Opportunity_Benefit__c> oppBenefits = buildMembershipBenefitsAndSetBundleFields(opps);
    oppBenefits.addall(buildCampaignBenefits(opps));
    insert oppBenefits;
  }

  // Things this accomplishes
  // 1. Filter out any opps that aren't membership opps
  // 2. Add 3 year benefit if membership is >= 3 years AND Do_Not_Send_Gifts__c is not checked
  // 3. Get list of membership bundle benefits and create Opportunity Benefit for each
  // 4. If Do_Not_Send_Gifts__c is checked, only add magazine and decal
  // 5. Magazine count is multiplied by years
  public static List<Opportunity_Benefit__c> buildMembershipBenefitsAndSetBundleFields(List<Opportunity> oppList) {
    List<Id> bundleIds = new List<Id>();
    List<Opportunity> filteredOpps = new List<Opportunity>();
    List<Opportunity_Benefit__c> newOppBenefits = new List<Opportunity_Benefit__c>();
    Webstore__c ws = Webstore__c.getInstance('WooCommerce');
    for (Opportunity opp : oppList) {
      if (opp.Membership_Bundle__c != null) {
        filteredOpps.add(opp);
        bundleIds.add(opp.Membership_Bundle__c);
      }
      if (!opp.Do_Not_Send_Gifts__c && opp.RecordTypeID == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId() && opp.Years__c > 2) {
        Opportunity_Benefit__c oppBen = new Opportunity_Benefit__c();
        oppBen.Benefit__c = ws.X3_Year_Benefit_Id__c;
        oppBen.Count__c = 1;
        oppBen.opportunity__c = opp.id;
        newOppBenefits.add(oppBen);
      }
    }
    List<Membership_Bundle_Benefit__c> bundleBenefits = [Select Membership_Bundle__c, Benefit__r.id, Benefit__r.Count__c, Benefit__r.Name from Membership_Bundle_Benefit__c where Membership_Bundle__c in :bundleIds];

    Map<String, List<SObject>> mapped = Utils.groupBy(bundleBenefits, 'Membership_Bundle__c');
    for (String bundleId : mapped.keySet()) {
      List<SObject> mappedBenefits = mapped.get(bundleId);
      for (Opportunity opp : filteredOpps) {
        if (String.valueOf(opp.Membership_Bundle__c) == bundleId) {
          for (Membership_Bundle_Benefit__c bundleBenefit : bundleBenefits) {
            if (opp.Do_Not_Send_Gifts__c && !(bundleBenefit.Benefit__r.Name == 'Magazine' || bundleBenefit.Benefit__r.Name == 'Decal')) {
              continue;
            }
            Opportunity_Benefit__c newOppBenefit = new Opportunity_Benefit__c();
            newOppBenefit.Opportunity__c = opp.id;
            newOppBenefit.Benefit__c = bundleBenefit.Benefit__r.id;
            if ((bundleBenefit.Benefit__r.Name == 'Magazine') && opp.Years__c != null) {
              newOppBenefit.Count__c = bundleBenefit.Benefit__r.Count__c * (opp.Years__c == null ? 1 : opp.Years__c);
            } else {
              newOppBenefit.Count__c = bundleBenefit.Benefit__r.Count__c;
            }
            newOppBenefits.add(newOppBenefit);
          }
        }
      }
    }
    return newOppBenefits;
  }
  // Things this accomplishes
  // 1. Filter out any opps without campaigns
  // 2. Get list of campaign bundle benefits and create Opportunity Benefit for each
  // 3. If Do_Not_Send_Gifts__c is checked, only add magazine and decal
  // 4. Magazine count is multiplied by years
  public static List<Opportunity_Benefit__c> buildCampaignBenefits(List<Opportunity> oppList) {
    List<Id> campaignIds = new List<Id>();
    List<Opportunity> filteredOpps = new List<Opportunity>();
    for (Opportunity opp : oppList) {
      if (opp.campaignId != null) {
        filteredOpps.add(opp);
        campaignIds.add(opp.campaignId);
      }
    }

    List<Campaign_Benefit__c> campaignBenefits = [Select Id, Campaign__c, Benefit__r.id, Benefit__r.Count__c, Benefit__r.Name from Campaign_Benefit__c where campaign__c in :campaignIds];

    // List of campaign benefits by campaign id
    Map<String, List<SObject>> mapped = Utils.groupBy(campaignBenefits, 'campaign__c');
    List<Opportunity_Benefit__c> newOppBenefits = new List<Opportunity_Benefit__c>();
    for (String campaignId : mapped.keySet()) {
      List<SObject> mappedBenefits = mapped.get(campaignId);
      for (Opportunity opp : filteredOpps) {
        if (String.valueOf(opp.campaignId) == campaignId) {
          for (Campaign_Benefit__c campaignBenefit : campaignBenefits) {
            if (opp.Do_Not_Send_Gifts__c && !(campaignBenefit.Benefit__r.Name == 'Magazine' || campaignBenefit.Benefit__r.Name == 'Decal')) {
              continue;
            }
            Opportunity_Benefit__c newOppBenefit = new Opportunity_Benefit__c();
            newOppBenefit.Opportunity__c = opp.id;
            newOppBenefit.Benefit__c = campaignBenefit.Benefit__r.id;
            if (campaignBenefit.Benefit__r.Name == 'Magazine' && opp.Years__c != null) {
              newOppBenefit.Count__c = campaignBenefit.Benefit__r.Count__c * opp.Years__c;
            } else {
              newOppBenefit.Count__c = campaignBenefit.Benefit__r.Count__c;
            }
            newOppBenefits.add(newOppBenefit);
          }
        }
      }
    }
    return newOppBenefits;
  }

  public static void setValidationDate(List<Opportunity> opps) {
    for (Opportunity opp : opps) {
      if (opp.Validated__c && opp.Validated_Date__c == null) {
        opp.Validated_Date__c = Date.today();
      }
    }
  }

  // Manually update npsp rollup origin on account and contact
  public static void updateMembershipOrigin(List<Opportunity> opps, Map<Id, Opportunity> oppMap) {
    Set<Id> conIds = new Set<Id>();
    Set<Id> accIds = new Set<Id>();
    for (Opportunity opp : opps) {
      if (opp.RecordTypeID == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId()) {
        Opportunity oldOpp = oppMap.get(opp.id);
        if (oldOpp.npe01__Membership_Origin__c != opp.npe01__Membership_Origin__c) {
          accIds.add(opp.AccountId);
          conIds.add(opp.npsp__Primary_Contact__c);
        }
        if (oldOpp.accountId != opp.accountId) {
          accIds.add(opp.AccountId);
        }
        if (oldOpp.npsp__Primary_Contact__c != opp.npsp__Primary_Contact__c) {
          conIds.add(opp.npsp__Primary_Contact__c);
        }
      }
    }
    List<Contact> cons = [select Id, npo02__LastMembershipOrigin__c, npo02__LastMembershipDate__c from Contact where id in :conIds];
    List<Account> accs = [select Id, npo02__LastMembershipOrigin__c, npo02__LastMembershipDate__c from Account where id in :accIds];
    for (Opportunity opp : opps) {
      for (Contact con : cons) {
        if (con.id == opp.npsp__Primary_Contact__c) {
          if (opp.npe01__Membership_End_Date__c >= con.npo02__LastMembershipDate__c || con.npo02__LastMembershipDate__c == null) {
            con.npo02__LastMembershipOrigin__c = opp.npe01__Membership_Origin__c;
          }
          break;
        }
      }
      for (Account acc : accs) {
        if (acc.id == opp.AccountId) {
          if (opp.npe01__Membership_End_Date__c >= acc.npo02__LastMembershipDate__c || acc.npo02__LastMembershipDate__c == null) {
            acc.npo02__LastMembershipOrigin__c = opp.npe01__Membership_Origin__c;
          }
          break;
        }
      }
    }
    update cons;
    update accs;
  }

  public static void handleNewMembershipEnqueues(List<Id> oppIds) {
    List<User> users = [select id from user where isportalenabled = true and contactId in (SELECT npsp__Primary_Contact__c FROM Opportunity WHERE npe01__Membership_End_Date__c > TODAY AND Id IN :oppIds)];
    Set<Id> userIds = new Set<Id>();
    for (User u : users) {
      userIds.add(u.id);
    }
    if (userIds.size() > 0) {
      Webstore__c ws = Webstore__c.getInstance('WooCommerce');
      if (ws != null) {
        System.enqueueJob(new UpdateUserProfile(userIds, ws.Delta_Member_Profile_ID__c));
      }
    }
  }
}