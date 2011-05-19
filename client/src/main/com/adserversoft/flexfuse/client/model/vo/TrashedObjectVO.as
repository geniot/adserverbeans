package com.adserversoft.flexfuse.client.model.vo {
[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.TrashedObject")]
public dynamic class TrashedObjectVO extends BaseVO {

    public var name:String;
    public var type:Boolean;
    public var clicks:int;
    public var views:int;


    public function get typeName():String {
        return type ? "Banner" : "AdPlace";
    }

    public function TrashedObjectVO() {
    }


}
}
