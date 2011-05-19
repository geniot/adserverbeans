package com.adserversoft.flexfuse.client.model.vo {
public class XMLWriter {
    public var xml:XML;

    public function XMLWriter() {
        xml = <obj/>;
    }

    public function addProperty(propertyName:String, propertyValue:String):XML {

        var xmlProperty:XML = <new/>
        xmlProperty.setName(propertyName);
        xmlProperty.appendChild(propertyValue);
        xml.appendChild(xmlProperty);
        return xmlProperty;
    }
}
}
