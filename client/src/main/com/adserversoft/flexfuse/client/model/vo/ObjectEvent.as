package com.adserversoft.flexfuse.client.model.vo {
import flash.events.Event;

public dynamic class ObjectEvent extends Event {
    public var object:Object;

    public function ObjectEvent(type:String, value:Object):void {
        super(type);
        object = value;
    }
}
}