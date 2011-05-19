package com.adserversoft.flexfuse.client.model.vo {
import mx.collections.ArrayCollection;

[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.ui.Settings")]
public dynamic class SettingsVO extends BaseVO {
    public var sessionId:String;
    public var installationId:int;
    public var adFormats:ArrayCollection;
    public var countries:ArrayCollection;
    public var languages:ArrayCollection;
    public var adTag:Array;
    public var maxLogoFileSize:int;
    public var maxBannerFileSize:int;
}
}