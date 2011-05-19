package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;

import mx.core.UIComponent;
import mx.events.FlexEvent;

public class BannerTargetingOsCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingOsCanvasMediator';
    private var bannerProxy:BannerProxy;


    public function BannerTargetingOsCanvasMediator(uid:String, viewComponent:Object) {
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
        var isAllBitsSelected:Boolean = (uiComponent.banner.osBits == null) ? true :
                uiComponent.banner.isAllBitsSelected(uiComponent.banner.osBits);
        if (isAllBitsSelected) {
            uiComponent.banner.osBits = ApplicationConstants.initBits(BannerTargetingOsCanvas.nCheckBox, true);
        }
        for (var i:int = 0; i < BannerTargetingOsCanvas.nCheckBox; i++) {
            uiComponent["cb" + i].selected = uiComponent.banner.osBits.charAt(i) == '1';
        }
        uiComponent.allRB.selected = isAllBitsSelected;
        uiComponent.osChangeHandler(null);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():BannerTargetingOsCanvas {
        return viewComponent as BannerTargetingOsCanvas;
    }
}
}