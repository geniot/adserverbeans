package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.AdPlaceProxy;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.UploadProxy;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.BaseVO;
import com.adserversoft.flexfuse.client.model.vo.ObjectFileReference;
import com.adserversoft.flexfuse.client.view.canvas.BannerInfoCanvasMediator;
import com.adserversoft.flexfuse.client.view.canvas.BannerInfoCanvasUI;
import com.adserversoft.flexfuse.client.view.canvas.BannerTargetingCanvasMediator;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class BannerTitleWindowMediator extends BaseMediator implements IMediator {
    public static const NAME:String = 'BannerTitleWindowMediator';

    private var bannerProxy:BannerProxy;
    private var adPlaceProxy:AdPlaceProxy;
    private var uploadProxy:UploadProxy;


    public function BannerTitleWindowMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);


        if (UIComponent(viewComponent).initialized) {
            onInit(null);
        } else {
            UIComponent(viewComponent).addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
        }
    }

    private function onInit(event:Event):void {
        bannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
        adPlaceProxy = facade.retrieveProxy(AdPlaceProxy.NAME) as AdPlaceProxy;
        uploadProxy = facade.retrieveProxy(UploadProxy.NAME) as UploadProxy;
        if (uiComponent.mode == ApplicationConstants.EDIT) {
            uiComponent.title = "Edit Banner";
        } else if (uiComponent.mode == ApplicationConstants.CREATE) {
            uiComponent.banner.uid = ApplicationConstants.getNewUid();
        }
        registerMediators();
        addEventListeners();
        onIndexChanged(event);
    }

    private function registerMediators():void {
        uiComponent.bannerInfoCanvas.banner = uiComponent.banner;
        uiComponent.bannerTargetingCanvas.banner = uiComponent.banner;
        registerMediator(NAME, BannerInfoCanvasMediator, BannerInfoCanvasMediator.NAME, uiComponent.bannerInfoCanvas);
        registerMediator(NAME, BannerTargetingCanvasMediator, BannerTargetingCanvasMediator.NAME, uiComponent.bannerTargetingCanvas);
    }

    override public function unregisterMediators():void {
        unregisterMediator(NAME, BannerInfoCanvasMediator);
        unregisterMediator(NAME, BannerTargetingCanvasMediator);
    }

    public override function addEventListeners():void {
        uiComponent.addEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.addEventListener(BaseTitleWindow.CANCEL, onClose);
        uiComponent.addEventListener(BaseTitleWindow.SAVE, onSave);
        uiComponent.addEventListener(KeyboardEvent.KEY_UP, uiComponent.keyup);
        uiComponent.addEventListener(BaseTitleWindow.INDEX_CHANGED_EVENT, onIndexChanged);
    }

    public override function removeEventListeners():void {
        uiComponent.removeEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.removeEventListener(BaseTitleWindow.CANCEL, onClose);
        uiComponent.removeEventListener(BaseTitleWindow.SAVE, onSave);
        uiComponent.removeEventListener(KeyboardEvent.KEY_UP, uiComponent.keyup);
        uiComponent.removeEventListener(BaseTitleWindow.INDEX_CHANGED_EVENT, onIndexChanged);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():BannerTitleWindow {

        return viewComponent as BannerTitleWindow;
    }


    private function onSave(event:Event):void {
        if (validate()) {
            PopManager.setEnabledStateToPopUp(false, BannerTitleWindowMediator);
            uiComponent.banner.dayBits = uiComponent.bannerTargetingCanvas.bannerTargetingTimeCanvas.getDayBitsSelected();
            uiComponent.banner.hourBits = uiComponent.bannerTargetingCanvas.bannerTargetingTimeHourCanvas.getHourBitsSelected();
            uiComponent.banner.countryBits = uiComponent.bannerTargetingCanvas.bannerTargetingGeoCanvas.getGeoBitsSelected();
            uiComponent.banner.browserBits = uiComponent.bannerTargetingCanvas.bannerTargetingBrowserCanvas.getBrowsersBitsSelected();
            uiComponent.banner.osBits = uiComponent.bannerTargetingCanvas.bannerTargetingOsCanvas.getOsBitsSelected();
            uiComponent.banner.languageBits = uiComponent.bannerTargetingCanvas.bannerTargetingLanguageCanvas.getLanguagesBitsSelected();
            uiComponent.banner.frameTargeting = uiComponent.bannerInfoCanvas.frameTargetingChB.selectedIndex == 0;
            bannerProxy.removeUrlPatternsByBannerUid(uiComponent.banner.uid);
            bannerProxy.removeReferrerPatternsByBannerUid(uiComponent.banner.uid);
            bannerProxy.removeDynamicParametersByBannerUid(uiComponent.banner.uid);

            bannerProxy.urlPatterns = BaseVO.collection2map(uiComponent.bannerTargetingCanvas.bannerTargetingPageUrlCanvas.pageUrlDataProvider, "id");
            bannerProxy.referrerPatterns = BaseVO.collection2map(uiComponent.bannerTargetingCanvas.bannerTargetingReferrerUrlCanvas.referrerUrlDataProvider, "id");
            bannerProxy.dynamicParameters = BaseVO.collection2map(uiComponent.bannerTargetingCanvas.bannerTargetingDynamicParametersCanvas.dynamicParametersDataProvider, "id");
            bannerProxy.ipPatterns = BaseVO.collection2map(uiComponent.bannerTargetingCanvas.bannerTargetingIpPatternsCanvas.ipPatternsDataProvider, "id");

            if (uiComponent.bannerInfoCanvas.partyAdTagChB.selected) {
                uiComponent.banner.targetUrl = "http://www.";
                uiComponent.banner.filename = null;
                uiComponent.banner.fileSize = 0;
                uiComponent.banner.bannerContentTypeId = ApplicationConstants.AD_TAG_BANNER_CONTENT_TYPE_ID;
                uiComponent.fileRef = null;
            } else {
                uiComponent.banner.adTag = null;
            }

            var relatedBanners:ArrayCollection = bannerProxy.getBannersByParentUid(uiComponent.banner.uid);
            for each (var iBanner:BannerVO in relatedBanners) {
                iBanner.bannerName = uiComponent.banner.bannerName;
                iBanner.filename = uiComponent.banner.filename;
                iBanner.fileSize = uiComponent.banner.fileSize;
            }
            uploadProxy.uploadBannerToSession(event);
        }
    }

    private function onClose(event:Event):void {
        removeEventListeners();
        unregisterMediators();
        PopManager.closePopUpWindow(uiComponent, getMediatorName());
    }

    public function validate():Boolean {
        if (uiComponent.bannerInfoCanvas.partyAdTagChB.selected) {
            if (uiComponent.bannerInfoCanvas.isPartyAdTagEmpty()) {
                removeEventListeners();
                Alert.show("3rd party ad tag is required.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
                uiComponent.invalidField = uiComponent.bannerInfoCanvas.partyAdTagTA;
                uiComponent.tabNavigator.selectedChild = uiComponent.bannerInfoCanvas;
                return false;
            }
        } else {
            var result:ValidationResultEvent = uiComponent.bannerInfoCanvas.bannerNameStringValidator.validate();
            if (result.type == ValidationResultEvent.INVALID) {
                removeEventListeners();
                Alert.show("Banner name is required.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
                uiComponent.invalidField = uiComponent.bannerInfoCanvas.bannerNameTI;
                uiComponent.tabNavigator.selectedChild = uiComponent.bannerInfoCanvas;
                return false;
            }
            result = uiComponent.bannerInfoCanvas.targetURLStringValidator.validate();
            if (result.type == ValidationResultEvent.INVALID) {
                removeEventListeners();
                Alert.show("Target URL is required.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
                uiComponent.invalidField = uiComponent.bannerInfoCanvas.targetURLTI;
                uiComponent.tabNavigator.selectedChild = uiComponent.bannerInfoCanvas;
                return false;
            }

            if (!uiComponent.bannerInfoCanvas.validateURL()) {
                removeEventListeners();
                Alert.show("Target URL is required.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
                uiComponent.invalidField = uiComponent.bannerInfoCanvas.targetURLTI;
                uiComponent.tabNavigator.selectedChild = uiComponent.bannerInfoCanvas;
                return false;
            }
            result = uiComponent.bannerInfoCanvas.bannerFileStringValidator.validate();
            if (result.type == ValidationResultEvent.INVALID) {
                removeEventListeners();
                Alert.show(result.message, "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
                uiComponent.invalidField = uiComponent.bannerInfoCanvas.browseBtn;
                uiComponent.tabNavigator.selectedChild = uiComponent.bannerInfoCanvas;
                return false;
            }
        }
        if (uiComponent.bannerTargetingCanvas.bannerTargetingTimeCanvas.isWeekDaysNotSelected()) {
            removeEventListeners();
            Alert.show("At least one day should be selected.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            uiComponent.invalidField = uiComponent.bannerTargetingCanvas.bannerTargetingTimeCanvas.cb0;
            uiComponent.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas;
            uiComponent.bannerTargetingCanvas.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas.bannerTargetingTimeCanvas;
            return false;
        }
        if (uiComponent.bannerTargetingCanvas.bannerTargetingBrowserCanvas.isBrowsersNotSelected()) {
            removeEventListeners();
            Alert.show("At least one browser option should be selected.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            uiComponent.invalidField = uiComponent.bannerTargetingCanvas.bannerTargetingBrowserCanvas.cb0;
            uiComponent.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas;
            uiComponent.bannerTargetingCanvas.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas.bannerTargetingBrowserCanvas;
            return false;
        }
        if (uiComponent.bannerTargetingCanvas.bannerTargetingTimeHourCanvas.isHoursNotSelected()) {
            removeEventListeners();
            Alert.show("At least one hour of the day must be selected.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            uiComponent.invalidField = uiComponent.bannerTargetingCanvas.bannerTargetingTimeHourCanvas.cb5;
            uiComponent.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas;
            uiComponent.bannerTargetingCanvas.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas.bannerTargetingTimeHourCanvas;
            return false;
        }
        if (!uiComponent.bannerTargetingCanvas.bannerTargetingCappingCanvas.isMaxNumberViewsGreater()) {
            removeEventListeners();
            Alert.show("Maximum number of views for the whole display period must be greater then or equal to daily views limit.",
                    "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            uiComponent.invalidField = uiComponent.bannerTargetingCanvas.bannerTargetingCappingCanvas.mnofTI;
            uiComponent.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas;
            uiComponent.bannerTargetingCanvas.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas.bannerTargetingCappingCanvas;
            return false;
        }
        if (!uiComponent.bannerTargetingCanvas.bannerTargetingGeoCanvas.isSomeCountrySelected()) {
            removeEventListeners();
            Alert.show("At least one country should be selected.",
                    "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            uiComponent.invalidField = uiComponent.bannerTargetingCanvas.bannerTargetingGeoCanvas.addAllBtn;
            uiComponent.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas;
            uiComponent.bannerTargetingCanvas.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas.bannerTargetingGeoCanvas;
            return false;
        }
        if (uiComponent.bannerTargetingCanvas.bannerTargetingOsCanvas.isOsNotSelected()) {
            removeEventListeners();
            Alert.show("At least one operating system should be selected.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            uiComponent.invalidField = uiComponent.bannerTargetingCanvas.bannerTargetingOsCanvas.cb0;
            uiComponent.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas;
            uiComponent.bannerTargetingCanvas.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas.bannerTargetingOsCanvas;
            return false;
        }
        if (!uiComponent.bannerTargetingCanvas.bannerTargetingLanguageCanvas.isSomeLanguageSelected()) {
            removeEventListeners();
            Alert.show("At least one language should be selected.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            uiComponent.invalidField = uiComponent.bannerTargetingCanvas.bannerTargetingLanguageCanvas.addAllBtn;
            uiComponent.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas;
            uiComponent.bannerTargetingCanvas.tabNavigator.selectedChild = uiComponent.bannerTargetingCanvas.bannerTargetingLanguageCanvas;
            return false;
        }

        //if editing/creating banner on the right
        if (uiComponent.banner.adPlaceUid == null) {
            if (bannerProxy.isOriginalAlreadyExists(uiComponent.bannerInfoCanvas.bannerNameTI.text, uiComponent.banner.uid)) {
                removeEventListeners();
                Alert.show("Banner with such name already exists.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
                uiComponent.invalidField = uiComponent.bannerInfoCanvas.bannerNameTI;
                uiComponent.tabNavigator.selectedChild = uiComponent.bannerInfoCanvas;
                return false;
            }
        }

        return true;
    }

    public function onAlertClose(event:CloseEvent):void {
        var minuteTimer:Timer = new Timer(300, 1);
        minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
        minuteTimer.start();
        //uiComponent
        uiComponent.invalidField.setFocus();
    }

    public function onTimerComplete(event:TimerEvent):void {
        addEventListeners();
    }


    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.BANNER_FILE_SELECTED,
            ApplicationConstants.BANNER_FILE_UPLOADED,
            ApplicationConstants.SERVER_FAULT
        ];
    }

    override public function handleNotification(note:INotification):void {
        switch (note.getName()) {
            case ApplicationConstants.BANNER_FILE_SELECTED:
                var fileRef:ObjectFileReference = note.getBody() as ObjectFileReference;
                uiComponent.fileRef = fileRef;
                uiComponent.banner.filename = fileRef.name;
                uiComponent.banner.fileSize = fileRef.size;
                uiComponent.banner.isBannerFileChanged = true;
                var filename:String = fileRef.name;
                var fileType:String = "." + ApplicationConstants.getFileType(filename);
                var bannerContentTypeId:int = ApplicationConstants.getBannerContentTypeIdByFileType(fileType);
                BannerVO(fileRef.object).bannerContentTypeId = bannerContentTypeId;
                break;
            case ApplicationConstants.BANNER_FILE_UPLOADED:
                var notificationName:String = uiComponent.mode == ApplicationConstants.CREATE ? ApplicationConstants.BANNER_ADDED : ApplicationConstants.BANNER_UPDATED;
                sendNotification(notificationName, uiComponent.banner);
                sendNotification(ApplicationConstants.STATE_CHANGED, true);
                PopManager.setEnabledStateToPopUp(true, BannerTitleWindowMediator);
                onClose(null);
                break;
            case ApplicationConstants.SERVER_FAULT:
                PopManager.setEnabledStateToPopUp(true, BannerTitleWindowMediator);
                break;
        }
    }

    private function onIndexChanged(event:Event):void {
        if (uiComponent.tabNavigator.selectedChild is BannerInfoCanvasUI) {
            if (uiComponent.banner.parentUid == null) {
                uiComponent.bannerInfoCanvas.bannerNameTI.setFocus();
            } else {
                uiComponent.bannerInfoCanvas.targetURLTI.setFocus();
            }

        }
    }
}
}