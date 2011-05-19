package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;


import com.adserversoft.flexfuse.client.model.vo.IpPatternVO;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.INotification;

public class BannerTargetingIpPatternsCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingIpPatternsCanvasMediator';
    private var bannerProxy:BannerProxy;


    public function BannerTargetingIpPatternsCanvasMediator(uid:String, viewComponent:Object) {
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
        uiComponent.addEventListener(BannerTargetingDynamicParametersCanvas.ADD_PATTERN, onAddPattern);
        uiComponent.ipPatternsDataProvider.addAll(bannerProxy.getIpPatternsBannerUid(uiComponent.bannerUid));
        uiComponent.ipPatternsDataProvider.refresh();
    }


    private function onAddPattern(event:Event):void {
        uiComponent.patternTI1.text = ApplicationConstants.deleteWhiteSpaces(uiComponent.patternTI1.text);
            var isPatternUnique:Boolean = true;
            for each (var currentPattern:IpPatternVO in uiComponent.ipPatternsDataProvider) {
                if (currentPattern.ipPattern == getIpFromPart()) {
                    isPatternUnique = false;
                    break;
                }
            }
            if (isPatternUnique) {
                var ipPattern:IpPatternVO = new IpPatternVO();
                ipPattern.bannerUid=uiComponent.bannerUid;
                ipPattern.ipPattern = getIpFromPart();
                uiComponent.ipPatternsDataProvider.addItem(ipPattern);
                uiComponent.patternTI1.text = "";
                uiComponent.patternTI2.text = "";
                uiComponent.patternTI3.text = "";
                uiComponent.patternTI4.text = "";
                uiComponent.onPatternChange(null);
            } else {
                Alert.show("Such pattern already exists!");
            }
    }


    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():BannerTargetingIpPatternsCanvas {
        return viewComponent as BannerTargetingIpPatternsCanvas;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.DELETE_PATTERN

        ];
    }

    override public function handleNotification(note:INotification):void {
        switch (note.getName()) {
            case ApplicationConstants.DELETE_PATTERN:
                var deletedPattern:IpPatternVO = note.getBody() as IpPatternVO;
                var index:int = uiComponent.ipPatternsDataProvider.getItemIndex(deletedPattern);
                if (index != -1) {
                    uiComponent.ipPatternsDataProvider.removeItemAt(index);
                }
                uiComponent.ipPatternsDataProvider.refresh();
                break;
        }
    }

    private function getIpFromPart():String{
        return uiComponent.patternTI1.text+"."+uiComponent.patternTI2.text+"."+uiComponent.patternTI3.text+"."+uiComponent.patternTI4.text;
    }


}
}