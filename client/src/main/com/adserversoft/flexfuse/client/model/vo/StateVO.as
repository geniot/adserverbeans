package com.adserversoft.flexfuse.client.model.vo
{
import mx.collections.ArrayCollection;

[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.State")]
public dynamic class StateVO extends BaseVO
{
    public var adPlaces:ArrayCollection;
    public var banners:ArrayCollection;
    public var urlPatterns:ArrayCollection;
    public var referrerPatterns:ArrayCollection;
    public var dynamicParameters:ArrayCollection;
    public var ipPatterns:ArrayCollection;


}
}
