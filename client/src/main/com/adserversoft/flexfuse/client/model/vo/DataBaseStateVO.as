package com.adserversoft.flexfuse.client.model.vo {
[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.DataBaseState")]
public dynamic class DataBaseStateVO extends BaseVO {
    public var id:Object;
    public var dbName:String;
    public var dbState:String;
}
}