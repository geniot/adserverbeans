package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;

import mx.core.UIComponent;
import mx.events.FlexEvent;

public class BannerTargetingTimeCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingTimeCanvasMediator';
    private var bannerProxy:BannerProxy;


    public function BannerTargetingTimeCanvasMediator(uid:String, viewComponent:Object) {
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
        var isAllBitsSelected:Boolean = (uiComponent.banner.dayBits == null) ? true :
                uiComponent.banner.isAllBitsSelected(uiComponent.banner.dayBits);
        if (isAllBitsSelected) {
            uiComponent.banner.dayBits = ApplicationConstants.initBits(7, true); // = "0000000";
        }
        for (var i:int = 0; i < 7; i++) {
            uiComponent["cb" + i].selected = uiComponent.banner.dayBits.charAt(i) == '1';
        }
        uiComponent.allRB.selected = isAllBitsSelected;
        uiComponent.weekDaysChangeHandler(null);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():BannerTargetingTimeCanvas {
        return viewComponent as BannerTargetingTimeCanvas;
    }
}
}