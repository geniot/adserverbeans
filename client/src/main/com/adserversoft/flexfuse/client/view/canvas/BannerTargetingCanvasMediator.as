package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.FlexEvent;

public class BannerTargetingCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingCanvasMediator';


    public function BannerTargetingCanvasMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);

        if (UIComponent(viewComponent).initialized) {
            onInit(null);
        } else {
            UIComponent(viewComponent).addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
        }
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function onInit(event:Event):void {
        registerMediators();
    }

    private function onDestroy(event:Event):void {
        Alert.show("onDestroy");
    }

    private function get uiComponent():BannerTargetingCanvas {
        return viewComponent as BannerTargetingCanvas;
    }

    private function registerMediators():void {
        uiComponent.bannerTargetingTimeCanvas.banner = uiComponent.banner;
        uiComponent.bannerTargetingTimeHourCanvas.banner = uiComponent.banner;
        uiComponent.bannerTargetingCappingCanvas.banner = uiComponent.banner;
        uiComponent.bannerTargetingGeoCanvas.banner = uiComponent.banner;
        uiComponent.bannerTargetingBrowserCanvas.banner = uiComponent.banner;
        uiComponent.bannerTargetingOsCanvas.banner = uiComponent.banner;
        uiComponent.bannerTargetingLanguageCanvas.banner = uiComponent.banner;

        uiComponent.bannerTargetingPageUrlCanvas.bannerUid = uiComponent.banner.uid;
        uiComponent.bannerTargetingReferrerUrlCanvas.bannerUid = uiComponent.banner.uid;
        uiComponent.bannerTargetingDynamicParametersCanvas.bannerUid = uiComponent.banner.uid;
        uiComponent.bannerTargetingIpPatternsCanvas.bannerUid = uiComponent.banner.uid;


        registerMediator(NAME, BannerTargetingBrowserCanvasMediator, BannerTargetingBrowserCanvasMediator.NAME, uiComponent.bannerTargetingBrowserCanvas);
        registerMediator(NAME, BannerTargetingTimeCanvasMediator, BannerTargetingTimeCanvasMediator.NAME, uiComponent.bannerTargetingTimeCanvas);
        registerMediator(NAME, BannerTargetingTimeHourCanvasMediator, BannerTargetingTimeHourCanvasMediator.NAME, uiComponent.bannerTargetingTimeHourCanvas);
        registerMediator(NAME, BannerTargetingCappingCanvasMediator, BannerTargetingCappingCanvasMediator.NAME, uiComponent.bannerTargetingCappingCanvas);
        registerMediator(NAME, BannerTargetingGeoCanvasMediator, BannerTargetingGeoCanvasMediator.NAME, uiComponent.bannerTargetingGeoCanvas);
        registerMediator(NAME, BannerTargetingOsCanvasMediator, BannerTargetingOsCanvasMediator.NAME, uiComponent.bannerTargetingOsCanvas);
        registerMediator(NAME, BannerTargetingLanguageCanvasMediator, BannerTargetingLanguageCanvasMediator.NAME, uiComponent.bannerTargetingLanguageCanvas);
        registerMediator(NAME, BannerTargetingPageUrlCanvasMediator, BannerTargetingPageUrlCanvasMediator.NAME, uiComponent.bannerTargetingPageUrlCanvas);
        registerMediator(NAME, BannerTargetingReferrerUrlCanvasMediator, BannerTargetingReferrerUrlCanvasMediator.NAME, uiComponent.bannerTargetingReferrerUrlCanvas);
        registerMediator(NAME, BannerTargetingDynamicParametersCanvasMediator, BannerTargetingDynamicParametersCanvasMediator.NAME, uiComponent.bannerTargetingDynamicParametersCanvas);
        registerMediator(NAME, BannerTargetingIpPatternsCanvasMediator, BannerTargetingIpPatternsCanvasMediator.NAME, uiComponent.bannerTargetingIpPatternsCanvas);

    }

    override public function unregisterMediators():void {
        unregisterMediator(NAME, BannerTargetingBrowserCanvasMediator);
        unregisterMediator(NAME, BannerTargetingTimeCanvasMediator);
        unregisterMediator(NAME, BannerTargetingTimeHourCanvasMediator);
        unregisterMediator(NAME, BannerTargetingCappingCanvasMediator);
        unregisterMediator(NAME, BannerTargetingOsCanvasMediator);
        unregisterMediator(NAME, BannerTargetingLanguageCanvasMediator);
        unregisterMediator(NAME, BannerTargetingPageUrlCanvasMediator);
        unregisterMediator(NAME, BannerTargetingReferrerUrlCanvasMediator);
        unregisterMediator(NAME, BannerTargetingDynamicParametersCanvasMediator);
        unregisterMediator(NAME, BannerTargetingIpPatternsCanvasMediator);
    }


}
}