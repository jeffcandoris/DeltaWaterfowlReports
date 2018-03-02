@isTest
private class OpportunityBenefitService_Test {
  @isTest
  static void testSetBenefitStats() {
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

    Benefit__c b3 = new Benefit__c();
    b3.Name = 'Magazine';
    b3.Count__c = 2;
    b3.Total_Value__c = 2;
    b3.Unit_Cost__c = 2;
    insert b3;

    Opportunity opp = new Opportunity();
    opp.name = 'Test Opp 1';
    opp.StageName = 'Closed Won - 100%';
    opp.CloseDate = Date.today();
    insert opp;

    Opportunity_Benefit__c ben1 = new Opportunity_Benefit__c();
    ben1.Opportunity__c = opp.id;
    ben1.Benefit__c = b1.id;
    ben1.Count__c = 1;

    Opportunity_Benefit__c ben2 = new Opportunity_Benefit__c();
    ben2.Opportunity__c = opp.id;
    ben2.Benefit__c = b2.id;
    ben2.Count__c = 2;

    Opportunity_Benefit__c ben3 = new Opportunity_Benefit__c();
    ben3.Opportunity__c = opp.id;
    ben3.Benefit__c = b3.id;
    ben3.Count__c = 2;

    List<Opportunity_Benefit__c> bens = new List<Opportunity_Benefit__c>();
    bens.add(ben1);
    bens.add(ben2);
    bens.add(ben3);

    Test.StartTest();
    insert bens;
    Test.StopTest();

    Opportunity selectedOpp = [select id, Benefit_Stats__c from Opportunity where id =: opp.id];
    System.assertEquals('Benefit 1 - 1, Benefit 2 - 2', selectedOpp.Benefit_Stats__c);
  }

  @isTest
  static void testDeleteSetBenefitStats() {
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

    Opportunity opp = new Opportunity();
    opp.name = 'Test Opp 1';
    opp.StageName = 'Closed Won - 100%';
    opp.CloseDate = Date.today();
    insert opp;

    Opportunity_Benefit__c ben1 = new Opportunity_Benefit__c();
    ben1.Opportunity__c = opp.id;
    ben1.Benefit__c = b1.id;
    ben1.Count__c = 1;

    Opportunity_Benefit__c ben2 = new Opportunity_Benefit__c();
    ben2.Opportunity__c = opp.id;
    ben2.Benefit__c = b2.id;
    ben2.Count__c = 2;

    List<Opportunity_Benefit__c> bens = new List<Opportunity_Benefit__c>();
    bens.add(ben1);
    bens.add(ben2);

    insert bens;
    Test.StartTest();
    delete ben1;
    Test.StopTest();

    Opportunity selectedOpp = [select id, Benefit_Stats__c from Opportunity where id =: opp.id];
    System.assertEquals('Benefit 2 - 2', selectedOpp.Benefit_Stats__c);
  }
}