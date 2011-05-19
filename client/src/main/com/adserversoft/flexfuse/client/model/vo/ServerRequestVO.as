package com.adserversoft.flexfuse.client.model.vo
{


[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.ui.ServerRequest")]
public dynamic class ServerRequestVO extends BaseVO
{
    public var sessionId:String;
    public var version:String;
    public var installationId:int;

    public function ServerRequestVO(sid:String, v:String, iid:int) {
        this.sessionId = sid;
        this.version = v;
        this.installationId = iid;
    }
}
}