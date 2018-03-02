public class XmlHelper {
  public static String generateXmlNode(String name, Object value) {
    return '<' + name + '>' + String.valueOf(value) + '</' + name + '>';
  }

  public static String getImmediateChildNodeValue(Dom.XmlNode parentNode, String childNodeName, String namespace) {
    if (parentNode == null) { return null; }
    Dom.XmlNode childNode = parentNode.getChildElement(childNodeName, namespace);
    return (childNode != null ? childNode.getText() : null);
  }
}