package com.adserversoft.flexfuse.client.model.vo {
import flash.utils.describeType;

import mx.utils.ObjectUtil;

public class ReflectionConverter {
    public function ReflectionConverter() {
    }


    public function marshal(source:Object):XML {

        var writer:XMLWriter = new XMLWriter();
        var objDescriptor:XML = describeType(source);
        var property:XML;
        var propertyType:String;
        var propertyValue:Object;
        var qualifiedClassName:String = objDescriptor.@name;
        qualifiedClassName = qualifiedClassName.replace("::", ".");
        writer.xml.setName(qualifiedClassName);

        for each(property in objDescriptor.elements("accessor")) {
            process(propertyValue, source, property, writer);
        }


        return writer.xml;
    }

    private function process(propertyValue:Object, source:Object, property:XML, writer:XMLWriter):void {
        propertyValue = source[property.@name];

        if (propertyValue != null) {
            if (ObjectUtil.isSimple(propertyValue)) {
                writer.addProperty(property.@name, propertyValue.toString());
            }
            else {
                writer.addProperty(property.@name, (new ReflectionConverter).marshal(propertyValue).toXMLString());
            }
        }
    }
}
}