package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.UploadProxy;
import com.adserversoft.flexfuse.client.model.vo.AdFormatVO;
import com.adserversoft.flexfuse.client.model.vo.ObjectFileReference;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.INotification;

public class BannerInfoCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerInfoCanvasMediator';
    private var bannerProxy:BannerProxy;
    private var uploadProxy:UploadProxy;


    public function BannerInfoCanvasMediator(u:String, viewComponent:Object) {
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

    private function onInit(event:Event):void {
        bannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
        uploadProxy = facade.retrieveProxy(UploadProxy.NAME) as UploadProxy;

        addEventListeners();
        if (uiComponent.banner.adPlaceUid != null) {
            uiComponent.adFormat.enabled = false;
        }
        //if banner is already assigned to at least one ad place we can't allow changing it's format
        if (uiComponent.mode == ApplicationConstants.EDIT) {
            if (uiComponent.banner.parentUid != null) {
                uiComponent.bannerFileFI.enabled = false;
                uiComponent.adFormat.enabled = false;
                uiComponent.bannerNameTI.enabled = false;
            } else {
                var relatedBanners:ArrayCollection = bannerProxy.getBannersByParentUid(uiComponent.banner.uid);
                uiComponent.adFormat.enabled = relatedBanners.length == 0;
            }
            uiComponent.bannerFileFI.required = false;
        }

        if (uiComponent.mode == ApplicationConstants.CREATE) {
            uiComponent.banner.adFormat = ApplicationConstants.AD_FORMATS.getValues()[0] as AdFormatVO;
            if (uiComponent.banner.startDate == null || uiComponent.banner.startDate < new Date()) {
                uiComponent.banner.startDate = new Date();
            }
            if (uiComponent.banner.endDate == null) {
                uiComponent.banner.endDate = new Date();
                uiComponent.banner.endDate.month += 1;
            }
            onStartDateChange(null);
        }
        arr1 = new Array("bannerName", "adFormat", "targetUrl", "ongoing", "startDate", "endDate", "filename", "oneOnPage", "partyAdTag", "adTag");
        arr2 = new Array(uiComponent.bannerNameTI, uiComponent.adFormat, uiComponent.targetURLTI, uiComponent.ongoingChB,
                uiComponent.startDateDF, uiComponent.endDateDF, uiComponent.bannerFileTI, uiComponent.oneOnPageChB, uiComponent.partyAdTagChB, uiComponent.partyAdTagTA);
        arr3 = new Array("text", "selectedItem", "text", "selected", "selectedDate", "selectedDate", "text", "selected", "selected", "text");
        bindFields(uiComponent.banner);
        uiComponent.frameTargetingChB.selectedIndex = uiComponent.banner.frameTargeting ? 0 : 1;
        ongoingClick(event);
        uiComponent.startDateDF.disabledRanges = [
            {rangeStart: new Date(1900, 0, 0), rangeEnd: new Date()}
        ];
        uiComponent.endDateDF.disabledRanges = [
            {rangeStart: new Date(1900, 0, 0), rangeEnd: new Date()}
        ];
        onEndDateChange(null);
        uiComponent.adFormat.labelField = "adFormatName";
        uiComponent.adFormat.dataProvider = ApplicationConstants.sortedAdFormatsCollection;
        if (uiComponent.mode == ApplicationConstants.CREATE) {
            uiComponent.adFormat.selectedIndex = 0;
        }
        uiComponent.onPartyAdTagClick(null);

        uiComponent.bannerFilesDP = uiComponent.banner.getBannerFiles();
        uiComponent.bannerFilesDG.rowCount = uiComponent.bannerFilesDP.length;
        uiComponent.bannerFilesDP.refresh(); // todo
    }

    public override function addEventListeners():void {
        uiComponent.addEventListener(BannerInfoCanvas.BROWSE, onBrowse);
        uiComponent.addEventListener(BannerInfoCanvas.ONGOING_CHB_CLICK, ongoingClick);
        uiComponent.addEventListener(BannerInfoCanvas.START_DATE_EDIT, onStartDateChange);
        uiComponent.addEventListener(BannerInfoCanvas.END_DATE_EDIT, onEndDateChange);
    }

    public override function removeEventListeners():void {
        uiComponent.removeEventListener(BannerInfoCanvas.BROWSE, onBrowse);
    }

    private function onDestroy(event:Event):void {
        Alert.show("onDestroy");
    }


    private function get uiComponent():BannerInfoCanvas {
        return viewComponent as BannerInfoCanvas;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.BANNER_FILE_SELECTED,
            ApplicationConstants.BANNER_FILE_TOO_BIG
        ];
    }

    override public function handleNotification(note:INotification):void {
        var fileRef:ObjectFileReference = note.getBody() as ObjectFileReference;
        switch (note.getName()) {
            case ApplicationConstants.BANNER_FILE_SELECTED:
                uiComponent.bannerFileTI.text = fileRef.name;
                break;
            case ApplicationConstants.BANNER_FILE_TOO_BIG:
                Alert.show("Banner file size is too big: " + Math.round((fileRef.size / 1024) * 100) / 100 + " kb");
                break;
        }
    }

    private function onBrowse(event:Event):void {
        uploadProxy.browseBanner(event, uiComponent.banner);
    }

    private function ongoingClick(event:Event):void {
        uiComponent.endDateDF.enabled = !uiComponent.ongoingChB.selected;
    }

    private function onStartDateChange(event:Event):void {
        uiComponent.endDateDF.disabledRanges = [
            {rangeStart: new Date(1900, 0, 0), rangeEnd: uiComponent.banner.startDate}
        ];
        if (uiComponent.banner.endDate <= uiComponent.banner.startDate) {
            uiComponent.banner.endDate = new Date(uiComponent.banner.startDate.getFullYear(), uiComponent.banner.startDate.getMonth(), uiComponent.banner.startDate.getDate() + 1, 0, 0, 0, 0);
        }
    }

    private function onEndDateChange(event:Event):void {
        var yesterday:Date = new Date();
        yesterday.date -= 1;
        uiComponent.startDateDF.disabledRanges = [
            {rangeEnd: yesterday},
            {rangeStart: uiComponent.banner.endDate}
        ];
    }
}
}