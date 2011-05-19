package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;

import mx.containers.TabNavigator;
import mx.events.FlexEvent;

public class BannerTargetingCanvas extends BaseCanvas {
    public var bannerTargetingTimeCanvas:BannerTargetingTimeCanvas;
    public var bannerTargetingCappingCanvas:BannerTargetingCappingCanvas;
    public var bannerTargetingTimeHourCanvas:BannerTargetingTimeHourCanvas;
    public var bannerTargetingGeoCanvas:BannerTargetingGeoCanvas;
    public var bannerTargetingBrowserCanvas:BannerTargetingBrowserCanvas;
    public var bannerTargetingOsCanvas:BannerTargetingOsCanvas;
    public var bannerTargetingLanguageCanvas:BannerTargetingLanguageCanvas;
    public var bannerTargetingPageUrlCanvas:BannerTargetingPageUrlCanvas;
    public var bannerTargetingReferrerUrlCanvas:BannerTargetingReferrerUrlCanvas;
    public var bannerTargetingDynamicParametersCanvas:BannerTargetingDynamicParametersCanvas;
    public var bannerTargetingIpPatternsCanvas:BannerTargetingIpPatternsCanvas;
    public var tabNavigator:TabNavigator;

    public var banner:BannerVO;

    public function BannerTargetingCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        dispatchEvent(new Event(INIT));
    }
}
}