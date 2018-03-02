public without sharing class GAUService {

  public static void calculateAllocationRollups (Map<Id, npsp__General_Accounting_Unit__c> newGaus, Map<Id, npsp__General_Accounting_Unit__c> oldGaus) {
    Set<npsp__General_Accounting_Unit__c> filteredGaus = new Set<npsp__General_Accounting_Unit__c>();
    Set<Id> filteredGauIds = new Set<Id>();
    for (ID gauId : newGaus.keySet()) {
      npsp__General_Accounting_Unit__c newGau = newGaus.get(gauId);
      npsp__General_Accounting_Unit__c oldGau = oldGaus.get(gauId);
      if (newGau.npsp__Total_Allocations__c != oldGau.npsp__Total_Allocations__c) {
        filteredGauIds.add(gauId);
        filteredGaus.add(newGau);
      }
    }

    List<AggregateResult> ars = [Select Sum(Total_Allocations_With_Children__c) total, Parent__c from npsp__General_Accounting_Unit__c Where Parent__c in: filteredGauIds GROUP BY Parent__c];
    for (npsp__General_Accounting_Unit__c gau : filteredGaus) {
      if (gau.npsp__Total_Allocations__c == null) {
        gau.npsp__Total_Allocations__c = 0;
      }
      gau.Total_Allocations_With_Children__c = gau.npsp__Total_Allocations__c;
      for (AggregateResult ar : ars) {
        Id gauId = (Id) ar.get('Parent__c');
        if (gau.id == gauId && ar.get('total') != null) {
          gau.Total_Allocations_With_Children__c = (Decimal) ar.get('total') + gau.npsp__Total_Allocations__c;
        }
      }
    }
  }

  public static void calculateParentAllocationRollups (Map<Id, npsp__General_Accounting_Unit__c> newGaus, Map<Id, npsp__General_Accounting_Unit__c> oldGaus) {
    Set<npsp__General_Accounting_Unit__c> filteredGaus = new Set<npsp__General_Accounting_Unit__c>();
    Set<Id> parentGauIds = new Set<Id>();
    for (ID gauId : newGaus.keySet()) {
      npsp__General_Accounting_Unit__c newGau = newGaus.get(gauId);
      npsp__General_Accounting_Unit__c oldGau = oldGaus.get(gauId);
      if (newGau.parent__c != null && newGau.Total_Allocations_With_Children__c != oldGau.Total_Allocations_With_Children__c) {
        parentGauIds.add(newGau.parent__c);
        filteredGaus.add(newGau);
      }
    }
    List<npsp__General_Accounting_Unit__c> parentGaus = [select id, npsp__Total_Allocations__c from npsp__General_Accounting_Unit__c where id in: parentGauIds];
    for (AggregateResult ar : [Select Sum(Total_Allocations_With_Children__c) total, Parent__c from npsp__General_Accounting_Unit__c Where Parent__c in: parentGauIds GROUP BY Parent__c]) {
      for(npsp__General_Accounting_Unit__c parentGau : parentGaus) {
        if (parentGau.id == (Id) ar.get('Parent__c') && ar.get('total') != null && parentGau.npsp__Total_Allocations__c != null) {
          parentGau.Total_Allocations_With_Children__c = parentGau.npsp__Total_Allocations__c + (Decimal) ar.get('total');
        }
      }
    }
    update parentGaus;
  }
}


// insert child gau alloc
// after trigger on aloc runs and npsp calculates gau totals and calls update
// gau before update runs and i total with children

// after trigger runs on gau with new children
// if children changed, recalculate parents totals with children
// get each parent with a sum of all children