package com.adserversoft.flexfuse.client.model.vo
{

[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.UrlPattern")]
public dynamic class UrlPatternVO extends BaseVO
{
    public var id:Object;
    public var urlPattern:String;
    public var bannerUid:String;

    public function UrlPatternVO() {
    }


    public function mergeProperties(urlTargeting:UrlPatternVO):void {
        id = urlTargeting.id;
        urlPattern = urlTargeting.urlPattern;
        bannerUid = urlTargeting.bannerUid;
    }
}
}