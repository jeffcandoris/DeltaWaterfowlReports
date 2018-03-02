public without sharing class OpportunityBenefitService {
  public static void setBenefitStats(List<Opportunity_Benefit__c> benefitList) {
    Set<Id> oppIds = new Set<Id>();
    for(Opportunity_Benefit__c oppBenefit : benefitList) {
      oppIds.add(oppBenefit.Opportunity__c);
    }
    List<Opportunity> opps = [Select id, Benefit_Stats__c, (Select id, Benefit__r.Name, Count__c from Benefits__r where Benefit__r.Name != 'Magazine' AND Benefit__r.Name != 'Decal') from Opportunity where id in :oppIds];

    for(Opportunity opp : opps) {
      String[] parts = new List<String>();
      for (Opportunity_Benefit__c oppBenefit : opp.Benefits__r) {
        String val = oppBenefit.Benefit__r.Name + ' - ' + oppBenefit.Count__c;
        if (String.join(parts, ', ').length() + val.length() > 200) {
          break;
        }
        parts.add(val);
      }
      opp.Benefit_Stats__c = String.join(parts, ', ');
    }
    update opps;
  }
}