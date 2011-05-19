package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.view.canvas.ReportResultsCanvasMediator;
import com.adserversoft.flexfuse.client.view.canvas.ReportSettingsCanvasMediator;

import flash.events.Event;
import flash.events.KeyboardEvent;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class ReportsTitleWindowMediator extends BaseMediator implements IMediator {
    public static const NAME:String = "ReportTitleWindowMediator";

    public var adPlaceEntityDP:ArrayCollection;
    public var bannerEntityDP:ArrayCollection;
    public var assignedBannerEntityDP:ArrayCollection;

    public function ReportsTitleWindowMediator(uid:String, viewComponent:Object) {
        this.uid = uid;
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

    private function get uiComponent():ReportsTitleWindow {
        return viewComponent as ReportsTitleWindow;
    }

    private function onInit(event:Event):void {
        registerMediators();
        addEventListeners();
        uiComponent.reportSettingsCanvas.setFocus();
    }

    private function registerMediators():void {
        registerMediator(NAME, ReportSettingsCanvasMediator, ReportSettingsCanvasMediator.NAME, uiComponent.reportSettingsCanvas);
        registerMediator(NAME, ReportResultsCanvasMediator, ReportResultsCanvasMediator.NAME, uiComponent.reportResultsCanvas);
    }

    override public function unregisterMediators():void {
        unregisterMediator(NAME, ReportSettingsCanvasMediator);
        unregisterMediator(NAME, ReportResultsCanvasMediator);
    }

    public override function addEventListeners():void {
        uiComponent.addEventListener(KeyboardEvent.KEY_UP, uiComponent.keyup);
        uiComponent.addEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.addEventListener(BaseTitleWindow.CANCEL, onClose);
    }

    public override function removeEventListeners():void {
        uiComponent.removeEventListener(KeyboardEvent.KEY_UP, uiComponent.keyup);
        uiComponent.removeEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.removeEventListener(BaseTitleWindow.CANCEL, onClose);
    }

    private function onClose(event:Event):void {
        sendNotification(ApplicationConstants.REPORT_WINDOW_CLOSED);
        removeEventListeners();
        unregisterMediators();
        PopManager.closePopUpWindow(uiComponent, getMediatorName());
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.CUSTOM_REPORT_LOAD,
            ApplicationConstants.CUSTOM_REPORT_LOADED,
            ApplicationConstants.SERVER_FAULT
        ];
    }

    override public function handleNotification(note:INotification):void {
        switch (note.getName()) {
            case ApplicationConstants.CUSTOM_REPORT_LOAD:
                PopManager.setStateToPopUp(false, getMediatorName());
                break;
            case ApplicationConstants.CUSTOM_REPORT_LOADED:
            case ApplicationConstants.SERVER_FAULT:
                PopManager.setStateToPopUp(true, getMediatorName());
                break;
        }
    }
}
}