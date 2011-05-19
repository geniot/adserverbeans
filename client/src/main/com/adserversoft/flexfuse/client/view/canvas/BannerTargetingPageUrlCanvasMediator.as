package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.vo.UrlPatternVO;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.INotification;

public class BannerTargetingPageUrlCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingPageUrlCanvasMediator';
    private var bannerProxy:BannerProxy;


    public function BannerTargetingPageUrlCanvasMediator(uid:String, viewComponent:Object) {
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
        uiComponent.addEventListener(BannerTargetingPageUrlCanvas.ADD_PATTERN, onAddPattern);
        uiComponent.pageUrlDataProvider.addAll(bannerProxy.getPageUrlPatternsByBannerUid(uiComponent.bannerUid));
        uiComponent.pageUrlDataProvider.refresh();
    }


    private function onAddPattern(event:Event):void {
        uiComponent.patternTI.text = ApplicationConstants.deleteWhiteSpaces(uiComponent.patternTI.text);
        if (uiComponent.patternTI.text != "") {
            var isPatternUnique:Boolean = true;
            for each (var currentPattern:String in uiComponent.pageUrlDataProvider) {
                if (currentPattern == uiComponent.patternTI.text) {
                    isPatternUnique = false;
                    break;
                }
            }
            if (isPatternUnique) {
                var pageUrl:UrlPatternVO = new UrlPatternVO();
                pageUrl.bannerUid = uiComponent.bannerUid;
                pageUrl.urlPattern = uiComponent.patternTI.text;
                uiComponent.pageUrlDataProvider.addItem(pageUrl);
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

    private function get uiComponent():BannerTargetingPageUrlCanvas {
        return viewComponent as BannerTargetingPageUrlCanvas;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.DELETE_PATTERN

        ];
    }

    override public function handleNotification(note:INotification):void {
        switch (note.getName()) {
            case ApplicationConstants.DELETE_PATTERN:
                var deletedPattern:UrlPatternVO = note.getBody() as UrlPatternVO;
                var index:int = uiComponent.pageUrlDataProvider.getItemIndex(deletedPattern);
                if (index != -1) {
                    uiComponent.pageUrlDataProvider.removeItemAt(index);
                }
                uiComponent.pageUrlDataProvider.refresh();
                break;
        }
    }
}
}