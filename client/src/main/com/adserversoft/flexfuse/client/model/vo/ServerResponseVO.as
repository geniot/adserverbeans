package com.adserversoft.flexfuse.client.model.vo
{


[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.ui.ServerResponse")]
public dynamic class ServerResponseVO extends BaseVO
{
    public var result:String;
    public var message:String;
    public var resultingObject:Object;

}
}