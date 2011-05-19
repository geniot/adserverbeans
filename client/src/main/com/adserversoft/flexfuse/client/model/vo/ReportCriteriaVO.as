package com.adserversoft.flexfuse.client.model.vo {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;

import mx.collections.ArrayCollection;

[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.ReportCriteria")]
public dynamic class ReportCriteriaVO extends BaseVO {
    public var type:Number;
    public var fromDate:Date;
    public var toDate:Date;
    public var precision:Number = ApplicationConstants.NONE_PRECISION;
    public var bannerUids:ArrayCollection;
    public var adPlaceUids:ArrayCollection;
    public var bannerUidByAdPlaceUids:ArrayCollection;
}
}