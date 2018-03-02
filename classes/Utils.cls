public class Utils {
  public static Map<String, List<SObject>> groupBy(List<SObject> objList, String prop) {
    Map<String, List<SObject>> mapped = new Map<String, List<SObject>>();
    for (SObject iter : objList) {
      String val = String.valueOf(iter.get(prop));
      if (val == null) {
        System.debug('Value is null');
        continue;
      }
      List<SObject> curList = mapped.get(val);
      if (curList == null) {
        curList = new List<SObject>();
        mapped.put(val, curList);
      }
      curList.add(iter);
    }
    return mapped;
  }

  public static Set<Id> listToIdSet(List<SObject> objList) {
    Set<Id> newSet = new Set<Id>();
    for (SObject iter : objList) {
      newSet.add(iter.id);
    }
    return newSet;
  }

  public static String capitalizeFirstLetter(String str) {
    if (str != null) {
      return str.substring(0,1).toUpperCase() + (str.length() > 1 ? str.substring(1).toLowerCase() : '');
    } else {
      return str;
    }
  }

  public static String capitalizeEachFirstLetter(String str) {
    return capitalizeEachFirstLetter(str, ' ');
  }

  public static String capitalizeEachFirstLetter(String str, String delimiter) {
    if (str == null || str == '') {
      return str;
    }
    String[] words = str.split(delimiter);
    String[] newWords = new String[]{};
    for (String word : words) {
      newWords.add(capitalizeFirstLetter(word));
    }
    return String.join(newWords, delimiter);
  }
}