package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;

import mx.core.UIComponent;
import mx.events.FlexEvent;

public class BannerTargetingBrowserCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingBrowserCanvasMediator';
    private var bannerProxy:BannerProxy;


    public function BannerTargetingBrowserCanvasMediator(uid:String, viewComponent:Object) {
        this.uid = uid;
        super(NAME, viewComponent);


        if (UIComponent(viewComponent).initialized) {
            onInit(null);
        } else {
            UIComponent(viewComponent).addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
        }
    }

    private function onInit(event:Event):void {
        bannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
        var isAllBitsSelected:Boolean = (uiComponent.banner.browserBits == null) ? true :
                uiComponent.banner.isAllBitsSelected(uiComponent.banner.browserBits);
        if (isAllBitsSelected) {
            uiComponent.banner.browserBits = ApplicationConstants.initBits(8, true); 
        }
        for (var i:int = 0; i < 8; i++) {
            uiComponent["cb" + i].selected = uiComponent.banner.browserBits.charAt(i) == '1';
        }
        uiComponent.allRB.selected = isAllBitsSelected;
        uiComponent.browsersChangeHandler(null);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():BannerTargetingBrowserCanvas {
        return viewComponent as BannerTargetingBrowserCanvas;
    }
}
}