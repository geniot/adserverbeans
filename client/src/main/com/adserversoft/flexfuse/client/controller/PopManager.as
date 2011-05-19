package com.adserversoft.flexfuse.client.controller {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.view.titlewindow.BaseTitleWindow;

import flash.display.Sprite;

import mx.core.IFlexDisplayObject;
import mx.managers.PopUpManager;

public class PopManager extends PopUpManager {
    public static var CURRENT_POP_UP:BaseTitleWindow;

    public static function openPopUpWindow(ComponentClass:Class, m:String):IFlexDisplayObject {
        var window:IFlexDisplayObject = PopUpManager.createPopUp(ApplicationConstants.application as Sprite, ComponentClass, true);

        CURRENT_POP_UP = window as BaseTitleWindow;
        CURRENT_POP_UP.mode = m;

        PopUpManager.centerPopUp(window);
        return window;
    }

    public static function closePopUpWindow(window:IFlexDisplayObject, mediatorName:String):void {
        PopUpManager.removePopUp(window);
        ApplicationFacade.getInstance().removeMediator(mediatorName);
        CURRENT_POP_UP = null;
    }

    public static function setEnabledStateToPopUp(enabled:Boolean, MediatorClass:Class):void {
        var mediatorName1:String = ApplicationConstants.EDIT + "::" + MediatorClass.NAME;
        var mediatorName2:String = ApplicationConstants.CREATE + "::" + MediatorClass.NAME;

        var mediator:BaseMediator = BaseMediator(ApplicationFacade.getInstance().retrieveMediator(mediatorName1));
        if (mediator == null)mediator = BaseMediator(ApplicationFacade.getInstance().retrieveMediator(mediatorName2));
        if (mediator != null) {
            mediator.getViewComponent().enabled = enabled;
        }
    }

    public static function setStateToPopUp(enabled:Boolean, mediatorName:String):void {
        ApplicationFacade.getInstance().retrieveMediator(mediatorName).getViewComponent().enabled = enabled;
    }
}
}