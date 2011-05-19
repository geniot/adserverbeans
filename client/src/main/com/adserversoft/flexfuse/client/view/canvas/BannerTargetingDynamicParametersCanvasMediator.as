package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.vo.DynamicParameterVO;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.INotification;

public class BannerTargetingDynamicParametersCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingDynamicParametersCanvasMediator';
    private var bannerProxy:BannerProxy;


    public function BannerTargetingDynamicParametersCanvasMediator(uid:String, viewComponent:Object) {
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
        uiComponent.dynamicParametersDataProvider.addAll(bannerProxy.getDynamicParametersBannerUid(uiComponent.bannerUid));
        uiComponent.dynamicParametersDataProvider.refresh();
    }


    private function onAddPattern(event:Event):void {
        uiComponent.paramTI.text = ApplicationConstants.deleteWhiteSpaces(uiComponent.paramTI.text);
        uiComponent.valueTI.text = ApplicationConstants.deleteWhiteSpaces(uiComponent.valueTI.text);
        if (uiComponent.paramTI.text != "" && uiComponent.valueTI.text != "") {
            var isPatternUnique:Boolean = true;
            for each (var currentPattern:DynamicParameterVO in uiComponent.dynamicParametersDataProvider) {
                if (currentPattern.parameterName == uiComponent.paramTI.text && currentPattern.parameterValue == uiComponent.valueTI.text) {
                    isPatternUnique = false;
                    break;
                }
            }
            if (isPatternUnique) {
                var dp:DynamicParameterVO = new DynamicParameterVO();
                dp.bannerUid=uiComponent.bannerUid;
                dp.parameterName = uiComponent.paramTI.text;
                dp.parameterValue = uiComponent.valueTI.text;
                dp.regex = uiComponent.isRegexCB.selected;
                uiComponent.dynamicParametersDataProvider.addItem(dp);
                uiComponent.paramTI.text = "";
                uiComponent.valueTI.text = "";
                uiComponent.isRegexCB.selected = false;
                uiComponent.onPatternChange(null);
            } else {
                Alert.show("Such pattern already exists!");
            }

        }
    }


    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():BannerTargetingDynamicParametersCanvas {
        return viewComponent as BannerTargetingDynamicParametersCanvas;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.DELETE_PATTERN

        ];
    }

    override public function handleNotification(note:INotification):void {
        switch (note.getName()) {
            case ApplicationConstants.DELETE_PATTERN:
                var deletedPattern:DynamicParameterVO = note.getBody() as DynamicParameterVO;
                var index:int = uiComponent.dynamicParametersDataProvider.getItemIndex(deletedPattern);
                if (index != -1) {
                    uiComponent.dynamicParametersDataProvider.removeItemAt(index);
                }
                uiComponent.dynamicParametersDataProvider.refresh();
                break;
        }
    }
}
}