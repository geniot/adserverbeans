package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.BannerProxy;

import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.FlexEvent;

public class BannerTargetingCappingCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingCappingCanvasMediator';
    private var bannerProxy:BannerProxy;

    public function BannerTargetingCappingCanvasMediator(u:String, viewComponent:Object) {
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
        bannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;


        arr1 = new Array("dailyViewsLimit", "maxNumberViews");
        arr2 = new Array(uiComponent.dvlfTIProxy, uiComponent.mnofTIProxy);
        arr3 = new Array("text", "text");
        bindFields(uiComponent.banner);

        if (uiComponent.banner.dailyViewsLimit != 0)uiComponent.dvlfTI.text = uiComponent.dvlfTIProxy.text;
        if (uiComponent.banner.maxNumberViews != 0)uiComponent.mnofTI.text = uiComponent.mnofTIProxy.text;
        uiComponent.onDailyViewsLimitFocusOut(null);
        uiComponent.onMaxNumberViewsFocusOut(null);
    }


    private function onDestroy(event:Event):void {
        Alert.show("onDestroy");
    }


    private function get uiComponent():BannerTargetingCappingCanvas {
        return viewComponent as BannerTargetingCappingCanvas;
    }

}
}