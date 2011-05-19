package com.adserversoft.flexfuse.client.model.vo
{

[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.ReferrerPattern")]
public dynamic class ReferrerPatternVO extends BaseVO
{
    public var id:Object;
    public var referrerPattern:String;
    public var bannerUid:String;

    public function ReferrerPatternVO() {
    }


    public function mergeProperties(referrerTargeting:ReferrerPatternVO):void {
        id = referrerTargeting.id;
        referrerPattern = referrerTargeting.referrerPattern;
        bannerUid = referrerTargeting.bannerUid;
    }
}
}