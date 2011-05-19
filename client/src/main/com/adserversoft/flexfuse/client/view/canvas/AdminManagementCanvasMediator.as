package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.AdPlaceProxy;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.ReportProxy;
import com.adserversoft.flexfuse.client.model.SettingsProxy;
import com.adserversoft.flexfuse.client.model.UserProxy;
import com.adserversoft.flexfuse.client.model.vo.AdPlaceVO;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.ObjectEvent;
import com.adserversoft.flexfuse.client.model.vo.ReportsRowVO;
import com.adserversoft.flexfuse.client.view.component.dnd.BannersPanelUI;
import com.adserversoft.flexfuse.client.view.component.dnd.DragNDropWizard;
import com.adserversoft.flexfuse.client.view.component.dnd.DragNDropWizardUI;
import com.adserversoft.flexfuse.client.view.titlewindow.AdTagTitleWindow;
import com.adserversoft.flexfuse.client.view.titlewindow.AdTagTitleWindowMediator;
import com.adserversoft.flexfuse.client.view.titlewindow.AdTagTitleWindowUI;
import com.adserversoft.flexfuse.client.view.titlewindow.BannerTitleWindow;
import com.adserversoft.flexfuse.client.view.titlewindow.BannerTitleWindowMediator;
import com.adserversoft.flexfuse.client.view.titlewindow.BannerTitleWindowUI;

import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class AdminManagementCanvasMediator extends BaseMediator implements IMediator {
    public static const NAME:String = 'AdminManagementCanvasMediator';
    private var userProxy:UserProxy;
    private var settingsProxy:SettingsProxy;
    private var bannerProxy:BannerProxy;
    private var adPlaceProxy:AdPlaceProxy;
    private var reportProxy:ReportProxy;


    public function AdminManagementCanvasMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);

        if (UIComponent(viewComponent).initialized) {
            onInit(null);
        } else {
            UIComponent(viewComponent).addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
        }

    }

    private function onInit(event:Event):void {
        registerMediators();

        uiComponent.dragNDropWizard = new DragNDropWizardUI();
        DragNDropWizardUI(uiComponent.dragNDropWizard).percentHeight = 100;
        DragNDropWizardUI(uiComponent.dragNDropWizard).percentWidth = 100;
        uiComponent.addChild(DragNDropWizardUI(uiComponent.dragNDropWizard));

        userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        settingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        bannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
        adPlaceProxy = facade.retrieveProxy(AdPlaceProxy.NAME) as AdPlaceProxy;
        reportProxy = facade.retrieveProxy(ReportProxy.NAME) as ReportProxy;

        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.ADD_BANNER_BTN_CLICK, onAddBannerBtnClick);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.ADD_AD_PLACE_BTN_CLICK, onAddAdPlaceBtnClick);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.PREVIEW_BANNER_BTN_CLICK, onPreviewBannerBtnClick);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.EDIT_BANNER_BTN_CLICK, onEditBannerBtnClick);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.REMOVE_BANNER_BTN_CLICK, onRemoveBannerBtnClick);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.GET_AD_TAG_AD_PLACE_BTN_CLICK, onGetAdTagAdPlaceBtnClick);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.REMOVE_AD_PLACE_BTN_CLICK, onRemoveAdPlaceBtnClick);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.BANNER_CHANGE, onStateChange);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.AD_PLACE_CHANGE, onStateChange);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.BANNER_TRAFFIC_SHARE_INVALID, onStateChangeInvalid);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.TAB_LABEL_CHANGE, onStateChange);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.REMOVE_AD_PLACE_TAB, onRemoveAdPlaceTab);
        uiComponent.dragNDropWizard.addCustomEventListener(DragNDropWizard.REMOVE_BANNER_TAB, onRemoveBannerTab);

    }

    private function registerMediators():void {
        //                registerMediator(NAME, AdPlacesCanvasMediator, AdPlacesCanvasMediator.NAME, uiComponent.adPlacesCanvas);
        //                registerMediator(NAME, BannersCanvasMediator, BannersCanvasMediator.NAME, uiComponent.bannersCanvas);
    }


    private function unRegisterMediators():void {
        //        unregisterMediator(NAME, AdPlacesCanvasMediator);
        //        unregisterMediator(NAME, BannersCanvasMediator);
    }

    private function onAddBannerBtnClick(event:ObjectEvent):void {
        trace("ObjectEvent: type = " + event.type + " object = " + event.object);

        var mode:String = ApplicationConstants.CREATE;
        var mediatorName:String = mode + "::" + BannerTitleWindowMediator.NAME;
        if (!facade.hasMediator(mediatorName)) {
            var window:BannerTitleWindow = PopManager.openPopUpWindow(BannerTitleWindowUI, mode) as BannerTitleWindow;
            window.banner = new BannerVO();
            var bannersPanel:BannersPanelUI = (event.currentTarget as DragNDropWizardUI).bannersTabNavigator.selectedChild as BannersPanelUI;
            window.banner.label = bannersPanel.name;
            window.banner.displayOrder = bannersPanel.rightVB.getChildren().length;
            facade.registerMediator(new BannerTitleWindowMediator(mediatorName, window));
        }
    }

    private function onAddAdPlaceBtnClick(event:ObjectEvent):void {
        trace("ObjectEvent: type = " + event.type + " object = " + event.object);
        facade.sendNotification(ApplicationConstants.STATE_CHANGED, true);
    }

    private function onPreviewBannerBtnClick(event:ObjectEvent):void {
        trace("ObjectEvent: type = " + event.type + "object = " + event.object);
        var banner:BannerVO = event.object as BannerVO;
        var urlRequest:URLRequest = new URLRequest("preview?" + ApplicationConstants.BANNER_UID + "=" + banner.uid +
                "&" + ApplicationConstants.INSTALLATION_ID_PARAM + "=" + settingsProxy.settings.installationId +
                "&" + ApplicationConstants.AD_FORMAT_ID + "=" + banner.adFormatId +
                "&" + ApplicationConstants.BANNER_CONTENT_TYPE + "=" + banner.bannerContentTypeId +
                "&rnd=" + (new Date()).getTime());

        if (banner.parentUid != null) {
            urlRequest.url += "&" + ApplicationConstants.BANNER_PARENT_UID + "=" + banner.parentUid;
        }
        navigateToURL(urlRequest, "_blank");
    }

    private function onEditBannerBtnClick(event:ObjectEvent):void {
        trace("ObjectEvent: type = " + event.type + " object = " + event.object);

        var mode:String = ApplicationConstants.EDIT;
        var mediatorName:String = mode + "::" + BannerTitleWindowMediator.NAME;
        if (!facade.hasMediator(mediatorName)) {
            var window:BannerTitleWindow = PopManager.openPopUpWindow(BannerTitleWindowUI, mode) as BannerTitleWindow;
            var banner:BannerVO = BannerVO(bannerProxy.banners.getValue(String(event.object)));
            var editedBanner:BannerVO = banner.clone();
            editedBanner.isBannerFileChanged = false;
            window.banner = editedBanner;
            facade.registerMediator(new BannerTitleWindowMediator(mediatorName, window));
        }
    }

    private function onRemoveBannerBtnClick(event:ObjectEvent):void {
        trace("ObjectEvent: type = " + event.type + " object = " + event.object);
        var banner:BannerVO = BannerVO(bannerProxy.banners.getValue(String(event.object)));
        var text:String = "Are you sure you want to remove this banner?";

        var a:Alert = Alert.show(text, "Please Confirm", Alert.OK | Alert.CANCEL, ApplicationConstants.application as Sprite, onRemoveBannerConfirm);
        a.uid = banner.uid;
    }

    private function onRemoveBannerConfirm(eventObj:CloseEvent):void {
        var banner:BannerVO = bannerProxy.banners.getValue(Alert(eventObj.currentTarget).uid);
        if (eventObj.detail == Alert.OK) {
            //removing child banners
            if (banner.adPlaceUid == null) {
                var bannersToDelete:ArrayCollection = bannerProxy.getBannersByParentUid(banner.uid);
                for each (var iBanner:BannerVO in bannersToDelete) {
                    bannerProxy.banners.remove(iBanner.uid);
                    uiComponent.dragNDropWizard.deleteBanner(iBanner);
                }
            }
            bannerProxy.banners.remove(banner.uid);
            uiComponent.dragNDropWizard.deleteBanner(banner);
            sendNotification(ApplicationConstants.STATE_CHANGED, true);
        }
    }

    private function onStateChange(event:ObjectEvent):void {
        sendNotification(ApplicationConstants.STATE_CHANGED, true);
    }

    private function onStateChangeInvalid(event:ObjectEvent):void {
        sendNotification(ApplicationConstants.STATE_INVALID, true);
    }

    private function onStateChangeValid(event:ObjectEvent):void {
        sendNotification(ApplicationConstants.STATE_VALID, true);
    }

    private function onRemoveAdPlaceBtnClick(event:ObjectEvent):void {
        trace("ObjectEvent: type = " + event.type + " object = " + event.object);
        var adPlace:AdPlaceVO = AdPlaceVO(adPlaceProxy.adPlaces.getValue(String(event.object)));
        var a:Alert = Alert.show("Are you sure you want to remove this ad place?", "Please Confirm", Alert.OK | Alert.CANCEL, ApplicationConstants.application as Sprite, onRemoveAdPlaceConfirm);
        a.uid = adPlace.uid;
    }

    private function onRemoveAdPlaceConfirm(eventObj:CloseEvent):void {
        if (eventObj.detail == Alert.OK) {
            var adPlace:AdPlaceVO = adPlaceProxy.adPlaces.getValue(Alert(eventObj.currentTarget).uid);
            var _banners:ArrayCollection = bannerProxy.getBannersByAdPlaceUid(Alert(eventObj.currentTarget).uid);
            for each (var b:BannerVO in _banners) {
                bannerProxy.banners.remove(b.uid);
            }
            adPlaceProxy.adPlaces.remove(adPlace.uid);
            sendNotification(ApplicationConstants.STATE_CHANGED, true);
            uiComponent.dragNDropWizard.deleteAdPlace(adPlace);
        }
    }

    private function onRemoveAdPlaceTab(event:ObjectEvent):void {
        if (event.object is String) {
            var ac:ArrayCollection = adPlaceProxy.getAdPlacesByLabel(event.object as String);
            for each (var adPlace:AdPlaceVO in ac) {
                var _banners:ArrayCollection = bannerProxy.getBannersByAdPlaceUid(adPlace.uid);
                for each (var b:BannerVO in _banners) {
                    bannerProxy.banners.remove(b.uid);
                }
                adPlaceProxy.adPlaces.remove(adPlace.uid);
                uiComponent.dragNDropWizard.deleteAdPlace(adPlace);
            }
            sendNotification(ApplicationConstants.STATE_CHANGED, true);
        }
    }

    private function onRemoveBannerTab(event:ObjectEvent):void {
        if (event.object is String) {
            var ac:ArrayCollection = bannerProxy.getBannersByLabel(event.object as String);
            for each (var banner:BannerVO in ac) {
                bannerProxy.banners.remove(banner.uid);
                //also removing child banners
                if (banner.adPlaceUid == null) {
                    var bannersToDelete:ArrayCollection = bannerProxy.getBannersByParentUid(banner.uid);
                    for each (var iBanner:BannerVO in bannersToDelete) {
                        bannerProxy.banners.remove(iBanner.uid);
                        uiComponent.dragNDropWizard.deleteBanner(iBanner);
                    }
                }
                uiComponent.dragNDropWizard.deleteBanner(banner);
            }
            sendNotification(ApplicationConstants.STATE_CHANGED, true);
        }
    }

    private function onGetAdTagAdPlaceBtnClick(event:ObjectEvent):void {
        trace("ObjectEvent: type = " + event.type + " object = " + event.object);

        var adPlace:AdPlaceVO = AdPlaceVO(adPlaceProxy.adPlaces.getValue(String(event.object)));
        var mode:String = ApplicationConstants.CREATE;
        var mediatorName:String = mode + "::" + AdTagTitleWindowMediator.NAME;
        if (!facade.hasMediator(mediatorName)) {
            var window:IFlexDisplayObject = PopManager.openPopUpWindow(AdTagTitleWindowUI, mode);
            AdTagTitleWindow(window).adPlace = adPlace;
            var mediator:IMediator = new AdTagTitleWindowMediator(mediatorName, window);
            facade.registerMediator(mediator);
        }
    }


    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():AdminManagementCanvas {
        return viewComponent as AdminManagementCanvas;
    }


    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.USER_LOGGED_IN,
            ApplicationConstants.USER_LOGGED_OUT,
            ApplicationConstants.STATE_LOADED,
            ApplicationConstants.BANNER_ADDED,
            ApplicationConstants.BANNER_UPDATED,
            ApplicationConstants.REPORT_LOADED
        ];
    }

    override public function handleNotification(note:INotification):void {
        var banner:BannerVO;
        switch (note.getName()) {
            case ApplicationConstants.STATE_LOADED:
                ApplicationConstants.application.enabled = true;
                uiComponent.dragNDropWizard.setMaps(bannerProxy.banners, adPlaceProxy.adPlaces);
                break;
            case ApplicationConstants.REPORT_LOADED:
                for each(var ap:AdPlaceVO in adPlaceProxy.adPlaces.getValues()) {
                    var key:String = null + "x" + ap.uid;
                    var rr:ReportsRowVO = reportProxy.reportsRowsM.getValue(key) as ReportsRowVO;
                    if (rr != null) {
                        ap.views = rr.views;
                        ap.clicks = rr.clicks;
                    }
                }
                for each(var b:BannerVO in bannerProxy.banners.getValues()) {
                    var key2:String = b.uid + "x" + b.adPlaceUid;
                    var rr2:ReportsRowVO = reportProxy.reportsRowsM.getValue(key2) as ReportsRowVO;
                    if (rr2 != null) {
                        b.views = rr2.views;
                        b.clicks = rr2.clicks;
                    }
                }
                break;
            case ApplicationConstants.USER_LOGGED_OUT:
                uiComponent.dragNDropWizard.setMaps(bannerProxy.banners, adPlaceProxy.adPlaces);
                break;
            case ApplicationConstants.BANNER_ADDED:
                banner = note.getBody() as BannerVO;
                bannerProxy.banners.put(banner.uid, banner);
                uiComponent.dragNDropWizard.addBanner(note.getBody() as BannerVO);
                break;
            case ApplicationConstants.BANNER_UPDATED:
                banner = note.getBody() as BannerVO;
                var originalBanner:BannerVO = bannerProxy.banners.getValue(banner.uid);
                originalBanner.mergeProperties(banner);
                uiComponent.dragNDropWizard.updateBanner(originalBanner);
                break;
        }
    }
}
}