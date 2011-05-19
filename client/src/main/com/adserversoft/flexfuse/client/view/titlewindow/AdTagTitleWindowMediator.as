package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.AdPlaceProxy;
import com.adserversoft.flexfuse.client.model.SettingsProxy;

import flash.events.Event;

import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;

import org.puremvc.as3.interfaces.IMediator;

public class AdTagTitleWindowMediator extends BaseMediator implements IMediator {
    public static const NAME:String = 'AdTagTitleWindowMediator';


    public function AdTagTitleWindowMediator(u:String, viewComponent:Object) {
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

    private function onClose(event:Event):void {
        PopManager.closePopUpWindow(uiComponent, getMediatorName());
    }


    private function get uiComponent():AdTagTitleWindow {
        return viewComponent as AdTagTitleWindow;
    }


    private function onInit(event:Event):void {
        uiComponent.addEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.addEventListener(BaseTitleWindow.CANCEL, onClose);
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var res:Array = settingsProxy.getAdTag(uiComponent.adPlace);
        uiComponent.adTagTA.text = (String)(res[0]);


        PopUpManager.centerPopUp(uiComponent);
        uiComponent.setFocus();
    }


}
}