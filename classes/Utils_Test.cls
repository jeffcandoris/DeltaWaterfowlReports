@isTest
private class Utils_Test {

  static testMethod void testCapitalization() {
    String one = null;
    String two = '';
    String three = 'a';
    String four = 'abc';
    String five = 'abc def';
    Test.StartTest();
    String oneResult = Utils.capitalizeEachFirstLetter(one);
    String twoResult = Utils.capitalizeEachFirstLetter(two);
    String threeResult = Utils.capitalizeEachFirstLetter(three);
    String fourResult = Utils.capitalizeEachFirstLetter(four);
    String fiveResult = Utils.capitalizeEachFirstLetter(five);
    Test.StopTest();
    System.assertEquals(null, oneResult);
    System.assertEquals('', twoResult);
    System.assertEquals('A', threeResult);
    System.assertEquals('Abc', fourResult);
    System.assertEquals('Abc Def', fiveResult);
  }
}