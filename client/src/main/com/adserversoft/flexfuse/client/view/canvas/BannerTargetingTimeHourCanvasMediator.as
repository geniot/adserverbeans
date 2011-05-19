package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;

import mx.core.UIComponent;
import mx.events.FlexEvent;

public class BannerTargetingTimeHourCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingTimeHourCanvasMediator';
    private var bannerProxy:BannerProxy;

    public function BannerTargetingTimeHourCanvasMediator(uid:String, viewComponent:Object) {
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
        var isAllBitsSelected:Boolean = (uiComponent.banner.hourBits == null) ? true :
                uiComponent.banner.isAllBitsSelected(uiComponent.banner.hourBits);
        if (isAllBitsSelected) {
            uiComponent.banner.hourBits = ApplicationConstants.initBits(24, true);
        }
        for (var i:int = 0; i < 24; i++) {
            uiComponent["cb" + i].selected = uiComponent.banner.hourBits.charAt(i) == '1';
        }
        uiComponent.allHourRB.selected = isAllBitsSelected;
        uiComponent.dayHourChangeHandler(null);
        var typeSelected:int = uiComponent.hoursSelected(ApplicationConstants.MORNING_RANGE);
        uiComponent.morningCB.selected = (typeSelected != ApplicationConstants.SELECTED_NONE);
        uiComponent.morningCB.alpha = (typeSelected == ApplicationConstants.SELECTED_SOME)
                ? ApplicationConstants.ALPHA_INACTIVE : ApplicationConstants.ALPHA_ACTIVE;
        typeSelected = uiComponent.hoursSelected(ApplicationConstants.AFTERNOON_RANGE);
        uiComponent.afternoonCB.selected = (typeSelected != ApplicationConstants.SELECTED_NONE);
        uiComponent.afternoonCB.alpha = (typeSelected == ApplicationConstants.SELECTED_SOME)
                ? ApplicationConstants.ALPHA_INACTIVE : ApplicationConstants.ALPHA_ACTIVE;
        typeSelected = uiComponent.hoursSelected(ApplicationConstants.EVENING_RANGE);
        uiComponent.eveningCB.selected = (typeSelected != ApplicationConstants.SELECTED_NONE);
        uiComponent.eveningCB.alpha = (typeSelected == ApplicationConstants.SELECTED_SOME)
                ? ApplicationConstants.ALPHA_INACTIVE : ApplicationConstants.ALPHA_ACTIVE;
        typeSelected = uiComponent.hoursSelected(ApplicationConstants.NIGHT_RANGE);
        uiComponent.nightCB.selected = (typeSelected != ApplicationConstants.SELECTED_NONE);
        uiComponent.nightCB.alpha = (typeSelected == ApplicationConstants.SELECTED_SOME)
                ? ApplicationConstants.ALPHA_INACTIVE : ApplicationConstants.ALPHA_ACTIVE;
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():BannerTargetingTimeHourCanvas {
        return viewComponent as BannerTargetingTimeHourCanvas;
    }
}
}