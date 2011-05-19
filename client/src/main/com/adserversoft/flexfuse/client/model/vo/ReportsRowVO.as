package com.adserversoft.flexfuse.client.model.vo {

[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.ReportsRow")]
public dynamic class ReportsRowVO extends BaseVO {
    public var adPlaceUid:String;
    public var bannerUid:String;
    public var views:int;
    public var clicks:int;
    public var date:Date;
    public var dateString:String;
    public var intervalString:String;
    public var entityName:String;

    public function get ctr():String {
        return String((views == 0) ? 0 : Math.round(((clicks / views) * 100) * 100) / 100) + "%";
    }
}
}