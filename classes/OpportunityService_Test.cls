@isTest
private class OpportunityService_Test {

  static Opportunity generateGenericOpp(Id conId, Id accId) {
    Opportunity opp = new Opportunity();
    opp.Name = 'test opp';
    opp.StageName = 'Closed Won - 100%';
    opp.CloseDate = Date.newInstance(2001, 1, 1);
    opp.Amount = 5.00;
    opp.Payment_Method__c = 'Cash';
    opp.Years__c = 2;
    opp.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
    opp.AccountId = accId;
    opp.npsp__Primary_Contact__c = conId;
    return opp;
  }
  static Opportunity generateGenericOpp() {
    return generateGenericOpp(null, null);
  }

  static Webstore__c setupWebstore() {
    Benefit__c b1 = new Benefit__c();
    b1.Name = 'Benefit 1';
    b1.Count__c = 1;
    b1.Total_Value__c = 1;
    b1.Unit_Cost__c = 1;
    insert b1;

    Profile nonMemberProfile = [SELECT Id FROM Profile WHERE Name='Delta Non-Member'][0];
    Profile memberProfile = [SELECT Id FROM Profile WHERE Name='Delta Member'][0];
    Webstore__c setting = new Webstore__c();
    setting.Name = 'WooCommerce';
    setting.Web_Merchandise_Pricebook_ID__c = 'blah';
    setting.Web_Merchandise_Pricebook_ID_CAD__c = 'blah';
    setting.Web_Ticket_Pricebook_ID__c = 'blah';
    setting.Web_Ticket_Pricebook_ID_CAD__c = 'blah';
    setting.X3_Year_Benefit_Id__c = b1.id;
    setting.Delta_Member_Profile_ID__c = memberProfile.id;
    setting.Delta_Non_Member_Profile_ID__c = nonMemberProfile.id;
    insert setting;
    return setting;
  }

  @isTest
  static void testSetCampaignDefaults() {
    Webstore__c setting = setupWebstore();
    Campaign c1 = new Campaign();
    c1.Name = 'test 1';
    c1.Primary_Department__c = 'EVT';
    insert c1;

    Opportunity opp = generateGenericOpp();
    opp.campaignId = c1.id;
    Test.StartTest();
    insert opp;
    Test.StopTest();

    Opportunity selectedOpp = [SELECT Id, Department__c FROM Opportunity WHERE Id = :opp.Id];
    System.assertEquals(c1.Primary_Department__c, selectedOpp.Department__c);
  }

  @isTest
  static void testSetBundleMembershipLevel() {
    Webstore__c setting = setupWebstore();
    Membership_Bundle__c mb1 = new Membership_Bundle__c();
    mb1.name = 'Bundle 1';
    mb1.Membership_Level__c = 'Youth';
    insert mb1;

    Opportunity opp = generateGenericOpp();
    opp.Membership_Bundle__c = mb1.id;
    Test.StartTest();
    insert opp;
    Test.StopTest();

    Opportunity selectedOpp = [SELECT Id, npe01__Member_Level__c, description FROM Opportunity WHERE Id = :opp.Id];
    System.assertEquals(selectedOpp.npe01__Member_Level__c, mb1.Membership_Level__c);
    System.assertEquals(selectedOpp.description, 'Youth Membership');
  }

  @isTest
  static void testSetPrimaryGAU() {
    Webstore__c setting = setupWebstore();
    npsp__General_Accounting_Unit__c gau = new npsp__General_Accounting_Unit__c();
    gau.name = 'Test GAU';
    insert gau;

    Campaign c1 = new Campaign();
    c1.name = 'Test Camp 1';
    c1.Primary_GAU__c = gau.id;
    insert c1;

    Opportunity opp1 = new Opportunity();
    opp1.name = 'Test Opp 1';
    opp1.campaignId = c1.id;
    opp1.StageName = 'Closed Won - 100%';
    opp1.CloseDate = Date.today();
    opp1.Amount = 10;

    Opportunity opp2 = new Opportunity();
    opp2.name = 'Test Opp 2';
    opp2.campaignId = c1.id;
    opp2.StageName = 'Closed Won - 100%';
    opp2.CloseDate = Date.today();
    opp2.Amount = 10;
    opp2.Is_Web_Purchase__c = true;
    opp2.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();

    List<Id> ids = new List<Id>();
    Test.StartTest();
    insert opp1;
    insert opp2;
    Test.StopTest();
    ids.add(opp1.id);
    ids.add(opp2.id);

    List<npsp__Allocation__c> allocs = [Select id, npsp__Amount__c, npsp__General_Accounting_Unit__c from npsp__Allocation__c where npsp__Opportunity__c in: ids];
    System.assertEquals(allocs.size(), 1);
    System.assertEquals(allocs[0].npsp__Amount__c, 10);
    System.assertEquals(allocs[0].npsp__General_Accounting_Unit__c, gau.id);
  }

  @isTest
  static void testCreateTransactionsFromOpportunities() {
    Webstore__c setting = setupWebstore();
    Opportunity opp = generateGenericOpp();
    Test.StartTest();
    insert opp;
    Test.StopTest();

    opp = [SELECT Id, Transaction_Number__c FROM Opportunity WHERE Id = :opp.Id];
    Transaction__c tran = [SELECT Id, Amount__c, Opportunity_Count__c FROM Transaction__c WHERE Id = :opp.Transaction_Number__c];
    System.assertEquals(tran.Id, opp.Transaction_Number__c);
  }

  //
  // @isTest
  // static void testUpdateContactAndAccountFields() {
  //   Webstore__c setting = setupWebstore();
  //   Contact con = new Contact();
  //   con.firstname = 'test';
  //   con.lastname = 'contact';
  //   con.email = 'test@email.com';
  //   insert con;
  //
  //   Account acc = [select id from account where npe01__One2OneContact__c =: con.id];
  //
  //   Opportunity opp = generateGenericOpp(con.id, acc.id);
  //   opp.Market_Source_Code__c = 'Event';
  //   insert opp;
  //   List<Contact> selectedCon = [select id, First_Opp_Date__c, Last_Opp_Date__c, First_Opp_Amount__c, Last_Opp_Amount__c, Last_Event_Attended_Market_Source_Code__c from Contact where id =: con.id];
  //   system.assertEquals(Date.newInstance(2001, 1, 1), selectedCon[0].First_Opp_Date__c);
  //   system.assertEquals(Date.newInstance(2001, 1, 1), selectedCon[0].Last_Opp_Date__c);
  //   system.assertEquals(5, selectedCon[0].First_Opp_Amount__c);
  //   system.assertEquals(5, selectedCon[0].Last_Opp_Amount__c);
  //   system.assertEquals(Date.newInstance(2001, 1, 1), selectedCon[0].Last_Event_Attended_Market_Source_Code__c);
  //
  //   List<Account> selectedAcc = [select id, First_Opp_Date__c, Last_Opp_Date__c, First_Opp_Amount__c, Last_Opp_Amount__c from Account where id =: acc.id];
  //   system.assertEquals(Date.newInstance(2001, 1, 1), selectedAcc[0].First_Opp_Date__c);
  //   system.assertEquals(Date.newInstance(2001, 1, 1), selectedAcc[0].Last_Opp_Date__c);
  //   system.assertEquals(5, selectedAcc[0].First_Opp_Amount__c);
  //   system.assertEquals(5, selectedAcc[0].Last_Opp_Amount__c);
  // }

  @isTest
  static void testSingleMembership() {
    Webstore__c setting = setupWebstore();

    Contact con = new Contact();
    con.firstname = 'test';
    con.lastname = 'contact';
    con.email = 'test@email.com';
    insert con;

    Account acc = [select id from account where npe01__One2OneContact__c =: con.id];

    Opportunity opp = generateGenericOpp(con.id, acc.id);
    Test.StartTest();
    insert opp;
    Test.StopTest();

    Opportunity selectedOpp = [SELECT npe01__Membership_Start_Date__c, npe01__Membership_End_Date__c, Membership_Transaction_Type__c, npe01__Membership_Origin__c from Opportunity where id = :opp.id];
    System.assertEquals(2001, selectedOpp.npe01__Membership_Start_Date__c.year());
    System.assertEquals(2003, selectedOpp.npe01__Membership_End_Date__c.year());
    System.assertEquals('Join', selectedOpp.Membership_Transaction_Type__c);
    System.assertEquals('Acquisition', selectedOpp.npe01__Membership_Origin__c);
  }

  @isTest
  static void testOldMembershipCalculateMembershipDuration() {
    Webstore__c setting = setupWebstore();
    Contact con = new Contact();
    con.firstname = 'test';
    con.lastname = 'contact';
    con.email = 'test@email.com';
    insert con;

    Account acc = [select id from account where npe01__One2OneContact__c =: con.id];

    Opportunity opp = generateGenericOpp(con.id, acc.id);
    insert opp;
    con.npo02__LastMembershipLevel__c = 'Friend';
    con.npo02__MembershipEndDate__c = Date.newInstance(2003, 1, 1);
    update con;
    Opportunity opp2 = generateGenericOpp(con.id, acc.id);
    opp2.closeDate = Date.newInstance(2003, 1, 1);
    Test.StartTest();
    insert opp2;
    Test.StopTest();

    Opportunity selectedOpp = [SELECT npe01__Membership_Start_Date__c, npe01__Membership_End_Date__c, Membership_Transaction_Type__c from Opportunity where id = :opp2.id];
    System.assertEquals(2003, selectedOpp.npe01__Membership_Start_Date__c.year());
    System.assertEquals(2005, selectedOpp.npe01__Membership_End_Date__c.year());
    System.assertEquals(1, selectedOpp.npe01__Membership_Start_Date__c.month());
    System.assertEquals(1, selectedOpp.npe01__Membership_End_Date__c.month());
    System.assertEquals('Renew', selectedOpp.Membership_Transaction_Type__c);
  }

  @isTest
  static void testOrganizationMembership() {
    Webstore__c setting = setupWebstore();
    Account acc = new Account();
    acc.name = 'Org';
    acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
    insert acc;

    Opportunity opp = generateGenericOpp(null, acc.id);
    insert opp;
    acc.npo02__LastMembershipLevel__c = 'Friend';
    acc.npo02__MembershipEndDate__c = Date.newInstance(2003, 1, 1);
    update acc;
    Opportunity opp2 = generateGenericOpp(null, acc.id);
    opp2.closeDate = Date.newInstance(2003, 1, 1);
    Test.StartTest();
    insert opp2;
    Test.StopTest();

    Opportunity selectedOpp = [SELECT npe01__Membership_Start_Date__c, npe01__Membership_End_Date__c, Membership_Transaction_Type__c from Opportunity where id = :opp2.id];
    System.assertEquals(2003, selectedOpp.npe01__Membership_Start_Date__c.year());
    System.assertEquals(2005, selectedOpp.npe01__Membership_End_Date__c.year());
    System.assertEquals(1, selectedOpp.npe01__Membership_Start_Date__c.month());
    System.assertEquals(1, selectedOpp.npe01__Membership_End_Date__c.month());
    System.assertEquals('Renew', selectedOpp.Membership_Transaction_Type__c);
  }

  @isTest
  static void testBuildMembershipBenefitsAndSetBundleFields() {
    Webstore__c setting = setupWebstore();
    Benefit__c b1 = new Benefit__c();
    b1.Name = 'Benefit 1';
    b1.Count__c = 1;
    b1.Total_Value__c = 1;
    b1.Unit_Cost__c = 1;
    insert b1;

    Benefit__c b2 = new Benefit__c();
    b2.Name = 'Benefit 2';
    b2.Count__c = 2;
    b2.Total_Value__c = 2;
    b2.Unit_Cost__c = 2;
    insert b2;

    Membership_Bundle__c mb1 = new Membership_Bundle__c();
    mb1.name = 'Bundle 1';
    mb1.Membership_Level__c = 'Youth';
    insert mb1;

    Membership_Bundle_Benefit__c mbb1 = new Membership_Bundle_Benefit__c();
    mbb1.Membership_Bundle__c = mb1.id;
    mbb1.Benefit__c = b1.id;
    insert mbb1;

    Membership_Bundle_Benefit__c mbb2 = new Membership_Bundle_Benefit__c();
    mbb2.Membership_Bundle__c = mb1.id;
    mbb2.Benefit__c = b2.id;
    insert mbb2;

    // Account acc = new Account();
    // acc.name = 'acc';
    // insert acc;
    //
    // Contact con = new Contact();
    // con.firstname = 'first';
    // con.lastname = 'last';
    // con.accountId = acc.id;
    // insert con;
    //
    // Campaign camp = new Campaign();
    // camp.name = 'camp';
    // camp.isActive = true;
    // camp.StartDate = Date.newInstance(2016, 12, 1);
    // camp.EndDate = Date.newInstance(2017, 12, 1);
    // insert camp;

    Opportunity opp = generateGenericOpp();
    opp.Membership_Bundle__c = mb1.id;
    // opp.campaignid = camp.id;
    // opp.accountId = acc.id;
    // opp.npsp__Primary_Contact__c = con.id;
    // opp.stagename = 'Closed Won - 100%';
    // opp.CloseDate = Date.newInstance(2016, 12, 1);
    Test.StartTest();
    insert opp;
    Test.StopTest();

    List<Opportunity_Benefit__c> oppBenefits = [Select Id, Count__c from Opportunity_Benefit__c where Opportunity__c = :opp.id];
    System.assertEquals(2, oppBenefits.size());
    System.assertEquals(1, oppBenefits[0].Count__c);
    System.assertEquals(2, oppBenefits[1].Count__c);
    // List<CampaignMember> campMembers = [select id from campaignmember where campaignId =: camp.id];
    // System.assertEquals(1, campMembers.size());
  }

  @isTest
  static void testBuildCampaignBenefits() {
    Webstore__c setting = setupWebstore();
    Benefit__c b1 = new Benefit__c();
    b1.name = 'Campaign Benefit 1';
    b1.Count__c = 5;
    insert b1;

    Benefit__c b2 = new Benefit__c();
    b2.name = 'Campaign Benefit 2';
    b2.Count__c = 5;
    insert b2;

    Benefit__c b3 = new Benefit__c();
    b3.Name = 'Mem Benefit 1';
    b3.Count__c = 3;
    b3.Total_Value__c = 3;
    b3.Unit_Cost__c = 3;
    insert b3;

    Benefit__c b4 = new Benefit__c();
    b4.Name = 'Mem Benefit 2';
    b4.Count__c = 4;
    b4.Total_Value__c = 4;
    b4.Unit_Cost__c = 2;
    insert b4;

    Membership_Bundle__c mb1 = new Membership_Bundle__c();
    mb1.name = 'Bundle 1';
    mb1.Membership_Level__c = 'Youth';
    insert mb1;

    Membership_Bundle_Benefit__c mbb1 = new Membership_Bundle_Benefit__c();
    mbb1.Membership_Bundle__c = mb1.id;
    mbb1.Benefit__c = b3.id;
    insert mbb1;

    Membership_Bundle_Benefit__c mbb2 = new Membership_Bundle_Benefit__c();
    mbb2.Membership_Bundle__c = mb1.id;
    mbb2.Benefit__c = b4.id;
    insert mbb2;

    Campaign c1 = new Campaign();
    c1.name = 'Test Camp 1';
    insert c1;

    Campaign c2 = new Campaign();
    c2.name = 'Test Camp 2';
    insert c2;

    Campaign_Benefit__c cb1 = new Campaign_Benefit__c();
    cb1.Campaign__c = c1.id;
    cb1.Benefit__c = b1.id;
    insert cb1;

    Campaign_Benefit__c cb2 = new Campaign_Benefit__c();
    cb2.Campaign__c = c1.id;
    cb2.Benefit__c = b2.id;
    insert cb2;

    Opportunity opp1 = generateGenericOpp();
    opp1.campaignId = c1.id;
    opp1.Membership_Bundle__c = mb1.id;

    Opportunity opp2 = generateGenericOpp();
    opp2.campaignId = c2.id;
    opp2.Membership_Bundle__c = mb1.id;

    Opportunity opp3 = generateGenericOpp();

    List<Opportunity> opps = new List<Opportunity>();
    opps.add(opp1);
    opps.add(opp2);
    opps.add(opp3);
    Test.StartTest();
    insert opps;
    Test.StopTest();
    Set<Id> ids = new Set<Id>();
    ids.add(opp1.id);
    ids.add(opp2.id);
    ids.add(opp3.id);

    List<Opportunity_Benefit__c> obs = [Select id, Count__c from Opportunity_Benefit__c where opportunity__c in: ids];
    System.assertEquals(6, obs.size());
  }

  @isTest
  static void test3YearBenefit() {
    Webstore__c setting = setupWebstore();
    Opportunity opp = generateGenericOpp();
    opp.Years__c = 4;
    Test.StartTest();
    insert opp;
    Test.StopTest();
    List<Opportunity_Benefit__c> obs = [Select Benefit__c, Count__c from Opportunity_Benefit__c where opportunity__c =: opp.id];
    System.assertEquals(1, obs.size());
    System.assertEquals(setting.X3_Year_Benefit_Id__c, obs[0].Benefit__c);
  }

  @isTest
  static void testMembershipAcquisitions() {
    Webstore__c setting = setupWebstore();

    Contact con = new Contact();
    con.firstname = 'test';
    con.lastname = 'contact';
    con.email = 'test@email.com';
    insert con;

    Account acc = [select id from account where npe01__One2OneContact__c =: con.id];

    Opportunity opp = generateGenericOpp(con.id, acc.id);
    opp.npe01__Member_Level__c = 'Friend';
    Opportunity opp2 = generateGenericOpp(con.id, acc.id);
    opp2.CloseDate = Date.newInstance(2005, 2, 1);
    opp2.npe01__Member_Level__c = 'Sponsor';
    Test.StartTest();
    insert opp;
    con.npo02__LastMembershipLevel__c = 'Friend';
    con.npo02__MembershipEndDate__c = Date.newInstance(2003, 1, 1);
    update con;
    insert opp2;
    Test.StopTest();
    List<Opportunity> selectedOppList = [SELECT Id, Name, npe01__Membership_Origin__c, npe01__Membership_Start_Date__c, npe01__Membership_End_Date__c, membership_comparision_level__c FROM Opportunity WHERE AccountId = :acc.id Order By CloseDate];

    System.assertEquals('Acquisition', selectedOppList[0].npe01__Membership_Origin__c);
    System.assertEquals('Acquisition', selectedOppList[1].npe01__Membership_Origin__c);
    System.assertEquals(Date.newInstance(2001, 1, 1), selectedOppList[0].npe01__Membership_Start_Date__c);
    System.assertEquals(Date.newInstance(2003, 1, 1), selectedOppList[0].npe01__Membership_End_Date__c);
    System.assertEquals(Date.newInstance(2005, 2, 1), selectedOppList[1].npe01__Membership_Start_Date__c);
    System.assertEquals(Date.newInstance(2007, 2, 1), selectedOppList[1].npe01__Membership_End_Date__c);
    System.assertEquals(null, selectedOppList[0].membership_comparision_level__c);
    System.assertEquals('Upgrade', selectedOppList[1].membership_comparision_level__c);
  }

  @isTest
  static void testMembershipRenewals() {
    Webstore__c setting = setupWebstore();

    Contact con = new Contact();
    con.firstname = 'test';
    con.lastname = 'contact';
    con.email = 'test@email.com';
    insert con;

    Account acc = [select id from account where npe01__One2OneContact__c =: con.id];

    Opportunity opp = generateGenericOpp(con.id, acc.id);
    opp.npe01__Member_Level__c = 'Sponsor';
    Opportunity opp2 = generateGenericOpp(con.id, acc.id);
    opp2.npe01__Member_Level__c = 'Friend';
    opp2.CloseDate = Date.newInstance(2003, 3, 1);

    Test.StartTest();
    insert opp;
    con.npo02__LastMembershipLevel__c = 'Sponsor';
    con.npo02__MembershipEndDate__c = Date.newInstance(2003, 1, 1);
    update con;
    insert opp2;
    Test.StopTest();
    List<Opportunity> selectedOppList = [SELECT Id, Name, npe01__Membership_Origin__c, npe01__Membership_Start_Date__c, npe01__Membership_End_Date__c, membership_comparision_level__c FROM Opportunity WHERE AccountId = :acc.id Order By CloseDate];

    System.assertEquals('Renewal', selectedOppList[1].npe01__Membership_Origin__c);
    System.assertEquals('Downgrade', selectedOppList[1].membership_comparision_level__c);
  }

  @isTest
  static void testMembershipReactivations() {
    Webstore__c setting = setupWebstore();

    Contact con = new Contact();
    con.firstname = 'test';
    con.lastname = 'contact';
    con.email = 'test@email.com';
    insert con;

    Account acc = [select id from account where npe01__One2OneContact__c =: con.id];

    Opportunity opp = generateGenericOpp(con.id, acc.id);
    opp.npe01__Member_Level__c = 'Sponsor';
    Opportunity opp2 = generateGenericOpp(con.id, acc.id);
    opp2.npe01__Member_Level__c = 'Sponsor';
    opp2.CloseDate = Date.newInstance(2004, 3, 1);

    Test.StartTest();
    insert opp;
    con.npo02__LastMembershipLevel__c = 'Sponsor';
    con.npo02__MembershipEndDate__c = Date.newInstance(2003, 1, 1);
    update con;
    insert opp2;
    Test.StopTest();
    List<Opportunity> selectedOppList = [SELECT Id, Name, npe01__Membership_Origin__c, npe01__Membership_Start_Date__c, npe01__Membership_End_Date__c, membership_comparision_level__c FROM Opportunity WHERE AccountId = :acc.id Order By CloseDate];

    System.assertEquals('Reactivate', selectedOppList[1].npe01__Membership_Origin__c);
    System.assertEquals('Same', selectedOppList[1].membership_comparision_level__c);
  }

  @isTest
  static void testUpdateProfile() {
    Webstore__c setting = setupWebstore();
    User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

    System.runAs(currentUser) {
      Contact con = new Contact();
      con.firstname = 'test';
      con.lastname = 'contact';
      con.email = 'test@email.com';
      insert con;

      Account acc = [select id from account where npe01__One2OneContact__c =: con.id][0];

      User us = new User();
      us.contactId = con.id;
      us.profileId = setting.Delta_Non_Member_Profile_ID__c;
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

      Opportunity opp = new Opportunity();
      opp.Name = 'test opp';
      opp.AccountId = acc.id;
      opp.StageName = 'Closed Won - 100%';
      opp.CloseDate = Date.newInstance(2016, 8, 3);
      opp.Amount = 5.00;
      opp.Payment_Method__c = 'Cash';
      opp.Years__c = 3;
      opp.npsp__Primary_Contact__c = con.id;
      opp.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();

      Test.StartTest();
      insert opp;
      Test.StopTest();
      User selectedUser = [select id, profileId from user where id =: us.id];
      System.assertEquals(setting.Delta_Member_Profile_ID__c, selectedUser.profileId);
    }
  }

  @isTest
  static void setValidationDate() {
    Opportunity opp = generateGenericOpp();
    Test.StartTest();
    opp.validated__c = true;
    insert opp;
    opp.name = 'Validated';
    update opp;

    Opportunity selectedOpp = [select Validated_Date__c from opportunity where id =: opp.id];
    system.assertEquals(Date.today(), selectedOpp.Validated_Date__c);
    Test.StopTest();
  }

  @isTest
  static void testUpdateMembershipOrigin() {
    Account acc = new Account();
    acc.name = 'test';
    acc.npo02__LastMembershipDate__c = Date.newInstance(2001, 1, 1);
    insert acc;
    Contact con = new Contact();
    con.lastname = 'test';
    con.npo02__LastMembershipDate__c = Date.newInstance(2001, 1, 1);
    con.AccountId = acc.id;
    insert con;

    Opportunity opp = generateGenericOpp(con.id, acc.id);
    opp.npe01__Membership_End_Date__c = Date.newInstance(2001, 1, 1);
    insert opp;
    opp.npe01__Membership_Origin__c = 'Reactivate';
    opp.npe01__Membership_End_Date__c = Date.newInstance(2020, 1, 1);
    Test.StartTest();
    update opp;
    Test.StopTest();
    Contact selectedCon = [Select id, npo02__LastMembershipOrigin__c from Contact where id =: con.id];
    Account selectedAcc = [Select id, npo02__LastMembershipOrigin__c from Account where id =: acc.id];

    System.assertEquals('Reactivate', selectedCon.npo02__LastMembershipOrigin__c);
    System.assertEquals('Reactivate', selectedAcc.npo02__LastMembershipOrigin__c);
  }
}