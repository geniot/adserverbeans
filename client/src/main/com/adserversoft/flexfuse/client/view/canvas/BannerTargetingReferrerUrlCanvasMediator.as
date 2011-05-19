package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;

import com.adserversoft.flexfuse.client.model.BannerProxy;

import com.adserversoft.flexfuse.client.model.vo.ReferrerPatternVO;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.INotification;

public class BannerTargetingReferrerUrlCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingReferrerUrlCanvasMediator';
    private var bannerProxy:BannerProxy;


    public function BannerTargetingReferrerUrlCanvasMediator(uid:String, viewComponent:Object) {
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
        uiComponent.addEventListener(BannerTargetingReferrerUrlCanvas.ADD_PATTERN, onAddPattern);
        uiComponent.referrerUrlDataProvider.addAll(bannerProxy.getReferrerPatternsByBannerUid(uiComponent.bannerUid));
        uiComponent.referrerUrlDataProvider.refresh();
    }


    private function onAddPattern(event:Event):void {
        uiComponent.patternTI.text = ApplicationConstants.deleteWhiteSpaces(uiComponent.patternTI.text);
        if (uiComponent.patternTI.text != "") {
            var isPatternUnique:Boolean = true;
            for each (var currentPattern:String in uiComponent.referrerUrlDataProvider) {
                if (currentPattern == uiComponent.patternTI.text) {
                    isPatternUnique = false;
                    break;
                }
            }
            if (isPatternUnique) {
                var ref:ReferrerPatternVO = new ReferrerPatternVO();
                ref.bannerUid = uiComponent.bannerUid;
                ref.referrerPattern = uiComponent.patternTI.text;
                uiComponent.referrerUrlDataProvider.addItem(ref);
                uiComponent.patternTI.text = "";
                uiComponent.onPatternChange(null);
            } else {
                Alert.show("Such pattern already exists!");
            }

        }
    }


    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():BannerTargetingReferrerUrlCanvas {
        return viewComponent as BannerTargetingReferrerUrlCanvas;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.DELETE_PATTERN

        ];
    }

    override public function handleNotification(note:INotification):void {
        switch (note.getName()) {
            case ApplicationConstants.DELETE_PATTERN:
                var deletedPattern:ReferrerPatternVO = note.getBody() as ReferrerPatternVO;
                var index:int = uiComponent.referrerUrlDataProvider.getItemIndex(deletedPattern);
                if (index != -1) {
                    uiComponent.referrerUrlDataProvider.removeItemAt(index);
                }
                uiComponent.referrerUrlDataProvider.refresh();
                break;
        }
    }
}
}