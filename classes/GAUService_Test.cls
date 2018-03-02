@isTest
private class GAUService_Test {

  @isTest
  static void testCalculateAllocationRollups() {
    npsp__General_Accounting_Unit__c grandParent = new npsp__General_Accounting_Unit__c();
    grandParent.name = 'Grand Parent';
    insert grandParent;

    npsp__General_Accounting_Unit__c parent1 = new npsp__General_Accounting_Unit__c();
    parent1.name = 'Parent 1';
    parent1.Parent__c = grandParent.id;
    insert parent1;

    npsp__General_Accounting_Unit__c child1 = new npsp__General_Accounting_Unit__c();
    child1.name = 'Child 1';
    child1.parent__c = parent1.id;
    insert child1;

    npsp__General_Accounting_Unit__c child2 = new npsp__General_Accounting_Unit__c();
    child2.name = 'Child 2';
    child2.parent__c = parent1.id;
    insert child2;

    Opportunity opp1 = new Opportunity();
    opp1.Name = 'Opp 1';
    opp1.StageName = 'Closed Won - 100%';
    opp1.CloseDate = Date.today();
    opp1.Amount = 75;
    insert opp1;

    Opportunity opp2 = new Opportunity();
    opp2.Name = 'Opp 2';
    opp2.StageName = 'Closed Won - 100%';
    opp2.CloseDate = Date.today();
    opp2.Amount = 100;
    insert opp2;

    npsp__Allocation__c opp1child1 = new npsp__Allocation__c();
    opp1child1.npsp__Opportunity__c = opp1.id;
    opp1child1.npsp__General_Accounting_Unit__c = child1.id;
    opp1child1.npsp__Amount__c = 50;
    insert opp1child1;

    npsp__Allocation__c opp1child2 = new npsp__Allocation__c();
    opp1child2.npsp__Opportunity__c = opp1.id;
    opp1child2.npsp__General_Accounting_Unit__c = child2.id;
    opp1child2.npsp__Amount__c = 25;
    insert opp1child2;

    npsp__Allocation__c opp2child1 = new npsp__Allocation__c();
    opp2child1.npsp__Opportunity__c = opp2.id;
    opp2child1.npsp__General_Accounting_Unit__c = child1.id;
    opp2child1.npsp__Amount__c = 50;
    insert opp2child1;

    npsp__Allocation__c opp2parent1 = new npsp__Allocation__c();
    opp2parent1.npsp__Opportunity__c = opp2.id;
    opp2parent1.npsp__General_Accounting_Unit__c = parent1.id;
    opp2parent1.npsp__Amount__c = 50;
    insert opp2parent1;

    npsp__General_Accounting_Unit__c parent2 = new npsp__General_Accounting_Unit__c();
    parent2.name = 'Parent 2';
    parent2.Parent__c = grandParent.id;
    insert parent2;

    npsp__General_Accounting_Unit__c child3 = new npsp__General_Accounting_Unit__c();
    child3.name = 'Child 3';
    child3.parent__c = parent2.id;
    insert child3;

    npsp__General_Accounting_Unit__c child4 = new npsp__General_Accounting_Unit__c();
    child4.name = 'Child 4';
    child4.parent__c = parent2.id;
    insert child4;

    Opportunity opp3 = new Opportunity();
    opp3.Name = 'Opp 3';
    opp3.StageName = 'Closed Won - 100%';
    opp3.CloseDate = Date.today();
    opp3.Amount = 75;
    insert opp3;

    Opportunity opp4 = new Opportunity();
    opp4.Name = 'Opp 4';
    opp4.StageName = 'Closed Won - 100%';
    opp4.CloseDate = Date.today();
    opp4.Amount = 50;
    insert opp4;

    npsp__Allocation__c opp1child12 = new npsp__Allocation__c();
    opp1child12.npsp__Opportunity__c = opp3.id;
    opp1child12.npsp__General_Accounting_Unit__c = child3.id;
    opp1child12.npsp__Amount__c = 50;
    insert opp1child12;

    npsp__Allocation__c opp1child22 = new npsp__Allocation__c();
    opp1child22.npsp__Opportunity__c = opp3.id;
    opp1child22.npsp__General_Accounting_Unit__c = child4.id;
    opp1child22.npsp__Amount__c = 25;
    insert opp1child22;

    npsp__Allocation__c opp2child12 = new npsp__Allocation__c();
    opp2child12.npsp__Opportunity__c = opp4.id;
    opp2child12.npsp__General_Accounting_Unit__c = child3.id;
    opp2child12.npsp__Amount__c = 50;
    insert opp2child12;

    List<Id> gauids = new List<Id>();
    gauIds.add(parent1.id);
    gauIds.add(child1.id);
    gauIds.add(child2.id);
    gauIds.add(parent2.id);
    gauIds.add(child3.id);
    gauIds.add(child4.id);

    Test.startTest();
    parent1.npsp__Total_Allocations__c = 50;
    child1.npsp__Total_Allocations__c = 100;
    child2.npsp__Total_Allocations__c = 25;
    child3.npsp__Total_Allocations__c = 100;
    child4.npsp__Total_Allocations__c = 25;
    update parent1;
    update child1;
    update child2;
    update child3;
    update child4;
    Test.stopTest();

    List<npsp__General_Accounting_Unit__c> gaus = [select id, npsp__Total_Allocations__c, Total_Allocations_With_Children__c from npsp__General_Accounting_Unit__c where id in: gauIds];
    for(npsp__General_Accounting_Unit__c gau : gaus) {
      if (gau.id == child1.id) {
        System.assertEquals(100, gau.npsp__Total_Allocations__c);
        System.assertEquals(100, gau.Total_Allocations_With_Children__c);
      }
      if (gau.id == child2.id) {
        System.assertEquals(25, gau.npsp__Total_Allocations__c);
        System.assertEquals(25, gau.Total_Allocations_With_Children__c);
      }
      if (gau.id == parent1.id) {
        System.assertEquals(50, gau.npsp__Total_Allocations__c);
        System.assertEquals(175, gau.Total_Allocations_With_Children__c);
      }
      if (gau.id == child3.id) {
        System.assertEquals(100, gau.npsp__Total_Allocations__c);
        System.assertEquals(100, gau.Total_Allocations_With_Children__c);
      }
      if (gau.id == child4.id) {
        System.assertEquals(25, gau.npsp__Total_Allocations__c);
        System.assertEquals(25, gau.Total_Allocations_With_Children__c);
      }
      if (gau.id == parent2.id) {
        System.assertEquals(0, gau.npsp__Total_Allocations__c);
        System.assertEquals(125, gau.Total_Allocations_With_Children__c);
      }
      if (gau.id == grandParent.id) {
        System.assertEquals(0, gau.npsp__Total_Allocations__c);
        System.assertEquals(300, gau.Total_Allocations_With_Children__c);
      }
    }
  }
}