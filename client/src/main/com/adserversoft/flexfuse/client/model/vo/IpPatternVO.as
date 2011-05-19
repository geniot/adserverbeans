package com.adserversoft.flexfuse.client.model.vo
{

[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.IpPattern")]
public dynamic class IpPatternVO extends BaseVO
{
    public var id:Object;
    public var ipPattern:String;
    public var bannerUid:String;

    public function IpPatternVO() {
    }


    public function mergeProperties(ipPatternTargeting:IpPatternVO):void {
        id = ipPatternTargeting.id;
        ipPattern = ipPatternTargeting.ipPattern;
        bannerUid = ipPatternTargeting.bannerUid;
    }
}
}