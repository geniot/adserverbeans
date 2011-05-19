package com.adserversoft.flexfuse.client.view {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.AdPlaceProxy;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.ReportProxy;
import com.adserversoft.flexfuse.client.model.SettingsProxy;
import com.adserversoft.flexfuse.client.model.StateProxy;
import com.adserversoft.flexfuse.client.model.UserProxy;
import com.adserversoft.flexfuse.client.view.titlewindow.ReportsTitleWindowMediator;
import com.adserversoft.flexfuse.client.view.titlewindow.ReportsTitleWindowUI;
import com.adserversoft.flexfuse.client.view.titlewindow.SettingsTitleWindowMediator;
import com.adserversoft.flexfuse.client.view.titlewindow.SettingsTitleWindowUI;
import com.adserversoft.flexfuse.client.view.titlewindow.TrashTitleWindowMediator;
import com.adserversoft.flexfuse.client.view.titlewindow.TrashTitleWindowUI;
import com.adserversoft.flexfuse.client.view.viewstack.MainPanelViewStackMediator;

import flash.display.Sprite;
import flash.events.Event;
import flash.external.ExternalInterface;

import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.events.CloseEvent;
import mx.managers.BrowserManager;
import mx.resources.ResourceManager;
import mx.utils.URLUtil;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class FlexFuseApplicationMediator extends BaseMediator implements IMediator {
    public static const NAME:String = 'FlexFuseApplicationMediator';
    private var userProxy:UserProxy;
    private var settingsProxy:SettingsProxy;
    private var stateProxy:StateProxy;
    private var reportProxy:ReportProxy;
    private var adPlaceProxy:AdPlaceProxy;
    private var bannerProxy:BannerProxy;
    private var isLogOutRequested:Boolean = false;
    private var isStateValid:Boolean = true;


    public function FlexFuseApplicationMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);
        userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        settingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        stateProxy = facade.retrieveProxy(StateProxy.NAME) as StateProxy;
        reportProxy = facade.retrieveProxy(ReportProxy.NAME) as ReportProxy;
        adPlaceProxy = facade.retrieveProxy(AdPlaceProxy.NAME) as AdPlaceProxy;
        bannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;

        uiComponent.addEventListener(FlexFuseApplication.LOG_OUT, onLogOut);
        uiComponent.addEventListener(FlexFuseApplication.SETTINGS, onSettings);
        uiComponent.addEventListener(FlexFuseApplication.SAVE, onSave);
        uiComponent.addEventListener(FlexFuseApplication.CREATE_REPORTS, onCreateReports);
        uiComponent.addEventListener(FlexFuseApplication.TRASH, onTrashOpen);
        //        registerMediator(NAME, AdPlacesCanvasMediator, AdPlacesCanvasMediator.NAME, uiComponent.adPlacesCanvas);
        //        registerMediator(NAME, BannersCanvasMediator, BannersCanvasMediator.NAME, uiComponent.bannersCanvas);
        registerMediator(NAME, MainPanelViewStackMediator, MainPanelViewStackMediator.NAME, uiComponent.mainPanelViewstack);
        stateChanged(false);
    }

    private function onLogOut(event:Event):void {
        if (uiComponent.saveB.enabled) {
            Alert.show("Do you want to save changes?", "Please Confirm", Alert.YES | Alert.NO | Alert.CANCEL, ApplicationConstants.application as Sprite, saveChanged);
        } else {
            ApplicationConstants.application.enabled = false;
            userProxy.logout();
        }
    }

    private function saveChanged(eventObj:CloseEvent):void {
        if (eventObj.detail == Alert.YES) {
            isLogOutRequested = true;
            onSave(null);
        } else if (eventObj.detail == Alert.NO) {
            userProxy.logout();
        } else {//cancel, just doing nothing
        }
    }

    private function onSave(event:Event):void {
        ExternalInterface.call("setSaved", false);
        if (isStateValid) {
            ApplicationConstants.application.enabled = false;
            stateProxy.saveState();
        } else {
            Alert.show(ResourceManager.getInstance().getString('ApplicationResource', 'failure.trafficShareInvalid'), ResourceManager.getInstance().getString('ApplicationResource', 'failure.title.trafficShareInvalid'));
        }
    }

    private function onCreateReports(event:Event):void {
        var mode:String = ApplicationConstants.CREATE;
        var mediatorName:String = mode + "::" + ReportsTitleWindowMediator.NAME;
        if (!facade.hasMediator(mediatorName)) {
            var window:IFlexDisplayObject = PopManager.openPopUpWindow(ReportsTitleWindowUI, mode);
            var mediator:IMediator = new ReportsTitleWindowMediator(mediatorName, window);
            facade.registerMediator(mediator);
        }
    }

    private function onTrashOpen(event:Event):void {
        var mode:String = ApplicationConstants.CREATE;
        var mediatorName:String = mode + "::" + TrashTitleWindowMediator.NAME;
        if (!facade.hasMediator(mediatorName)) {
            var window:IFlexDisplayObject = PopManager.openPopUpWindow(TrashTitleWindowUI, mode);
            var mediator:IMediator = new TrashTitleWindowMediator(mediatorName, window);
            facade.registerMediator(mediator);
        }

    }

    private function onSettings(event:Event):void {
        var mode:String = ApplicationConstants.CREATE;
        var mediatorName:String = mode + "::" + SettingsTitleWindowMediator.NAME;
        if (!facade.hasMediator(mediatorName)) {
            var window:IFlexDisplayObject = PopManager.openPopUpWindow(SettingsTitleWindowUI, mode);
            var mediator:IMediator = new SettingsTitleWindowMediator(mediatorName, window);
            facade.registerMediator(mediator);
        }
    }


    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }


    private function get uiComponent():FlexFuseApplication {
        return viewComponent as FlexFuseApplication;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.SETTINGS_LOADED,
            ApplicationConstants.SETTINGS_UPDATED,
            ApplicationConstants.USER_LOGGED_IN,
            ApplicationConstants.USER_LOGGED_OUT,
            ApplicationConstants.STATE_CHANGED,
            ApplicationConstants.STATE_SAVED,
            ApplicationConstants.STATE_LOADED,
            ApplicationConstants.STATE_INVALID,
            ApplicationConstants.STATE_VALID
        ];
    }


    override public function handleNotification(note:INotification):void {
        ApplicationConstants.application.enabled = true;
        switch (note.getName()) {
            case ApplicationConstants.SETTINGS_LOADED:
                uiComponent.copyRightsText.htmlText = "<a target='_blank' href='http://www.adserverbeans.com'>ASB MyAds</a> v." + ApplicationConstants.VERSION;
                showLogo();
                break;
            case ApplicationConstants.SETTINGS_UPDATED:
                showLogo();
                break;
            case ApplicationConstants.USER_LOGGED_IN:
                isLogOutRequested = false;
                ApplicationConstants.application.enabled = false;
                stateProxy.loadState();
                reportProxy.startReportUpdate();
                uiComponent.buttonsHB.visible = true;
                break;
            case ApplicationConstants.USER_LOGGED_OUT:
                uiComponent.buttonsHB.visible = false;
                reportProxy.stopReportUpdate();
                break;
            case ApplicationConstants.STATE_CHANGED:
                ExternalInterface.call("setSaved", note.getBody() as Boolean);
                stateChanged(note.getBody() as Boolean);
                break;
            case ApplicationConstants.STATE_LOADED:
                stateChanged(false);
                break;
            case ApplicationConstants.STATE_INVALID:
                isStateValid = false;
                break;
            case ApplicationConstants.STATE_VALID:
                isStateValid = true;
                break;
            case ApplicationConstants.STATE_SAVED:
                ApplicationConstants.application.enabled = true;
                stateChanged(false);
                if (isLogOutRequested) {
                    userProxy.logout();
                }
                break;
        }
    }

    private function stateChanged(value:Boolean):void {
        uiComponent.saveB.enabled = value;
    }

    private function showLogo():void {
        uiComponent.logo.source = URLUtil.getFullURL(BrowserManager.getInstance().url,
                "logo?action=get_logo_from_DB&instId=" + settingsProxy.settings.installationId + "&rnd=" + Math.random());
        uiComponent.logo.addEventListener(Event.COMPLETE, onComplete);
    }

    private function onComplete(event:Event):void {
        var maxWidth:Number = uiComponent.hBox.width - uiComponent.buttonsHB.width;
        uiComponent.logo.scaleContent = uiComponent.logo.contentWidth > maxWidth ||
                                        uiComponent.logo.contentHeight > ApplicationConstants.APPLICATION_CONTROL_BAR_HEIGHT;
        uiComponent.logo.width = maxWidth - 10;
    }
}
}