public with sharing class CarouselController {
  //public class CarouselData {
  //  @AuraEnabled public String type {get; set;}
  //  @AuraEnabled public List<CarouselItem> items {get; set;}
  //  @AuraEnabled public List<CarouselButton> navButtons {get; set;}
  //}

  //public class CarouselItem {
  //  @AuraEnabled public String img {get; set;}
  //  @AuraEnabled public String title {get; set;}
  //  @AuraEnabled public String description {get; set;}
  //  @AuraEnabled public String align {get; set;}
  //  @AuraEnabled public List<CarouselButton> buttons {get; set;}
  //}

  //public class CarouselButton {
  //  @AuraEnabled public String label {get; set;}
  //  @AuraEnabled public String url {get; set;}

  //  public CarouselButton(String label, String url) {
  //    this.label = label;
  //    this.url = url;
  //  }
  //}

  //@AuraEnabled
  //public static CarouselData fetchData(String carouselType) {
  //  CarouselData cd = new CarouselData();
  //  cd.items = new List<CarouselItem>();
  //  cd.navButtons = new List<CarouselButton>();

  //  // Query for carousel__c by type
  //  // Query for carousel_item__c by carousel id
  //  // Query for carousel_button__c by carousel id
  //  // query for carousel_item id

  //  List<Carousel__c> carousels = [SELECT Id, Type__c FROM Carousel__c WHERE Type__c = :carouselType];
  //  if (carousels.isEmpty()) {
  //    return cd;
  //  }

  //  Carousel__c carousel = carousels[0];
  //  cd.type = carousel.Type__c;

  //  List<Carousel_Button__c> navButtons = [SELECT Id, Label__c, URL__c FROM Carousel_Button__c WHERE Carousel__c = :carousel.Id ORDER BY Order__c];
  //  Map<Id, Carousel_Item__c> carouselItemMap = new Map<Id, Carousel_Item__c>([SELECT Id, Image__c, Title__c, Description__c, Alignment__c FROM Carousel_Item__c WHERE Carousel__c = :carousel.Id ORDER BY Order__c ASC]);
  //  Map<Id, List<Carousel_Button__c>> carouselItemIdToButtonsMap = new Map<Id, List<Carousel_Button__c>>();

  //  for (Carousel_Button__c carouselButton : [SELECT Id, Label__c, URL__c, Carousel_Item__c FROM Carousel_Button__c WHERE Carousel_Item__c IN :carouselItemMap.keySet()]) {
  //    List<Carousel_Button__c> itemButtons = carouselItemIdToButtonsMap.get(carouselButton.Carousel_Item__c);
  //    if (itemButtons == null) {
  //      itemButtons = new List<Carousel_Button__c>();
  //    }
  //    itemButtons.add(carouselButton);
  //    carouselItemIdToButtonsMap.put(carouselButton.Carousel_Item__c, itemButtons);
  //  }

  //  // build stuff
  //  for (Carousel_Item__c cItem : carouselItemMap.values()) {
  //    CarouselItem webCarouselItem = new CarouselItem();
  //    webCarouselItem.img = cItem.Image__c;
  //    webCarouselItem.title = cItem.Title__c;
  //    webCarouselItem.description = cItem.Description__c;
  //    webCarouselItem.align = cItem.Alignment__c;

  //    webCarouselItem.buttons = new List<CarouselButton>();

  //    List<Carousel_Button__c> itemButtons = carouselItemIdToButtonsMap.get(cItem.Id);
  //    if (itemButtons != null) {
  //      for (Carousel_Button__c cButton : itemButtons) {
  //        webCarouselItem.buttons.add(new CarouselButton(cButton.Label__c, cButton.URL__c));
  //      }
  //    }
  //    cd.items.add(webCarouselItem);
  //  }

  //  for (Carousel_Button__c navButton : navButtons) {
  //    cd.navButtons.add(new CarouselButton(navButton.Label__c, navButton.URL__c));
  //  }

  //  return cd;
  //}
}