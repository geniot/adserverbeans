package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.AdPlaceProxy;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.ReportProxy;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.ReportCriteriaVO;

import flash.display.Sprite;
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.core.UIComponent;
import mx.events.FlexEvent;

public class ReportSettingsCanvasMediator extends BaseMediator {
    public static const NAME:String = "ReportSettingsCanvasMediator";
    private var bannerProxy:BannerProxy;
    private var adPlaceProxy:AdPlaceProxy;
    private var reportProxy:ReportProxy;

    public function ReportSettingsCanvasMediator(uid:String, viewComponent:Object) {
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

    private function get uiComponent():ReportSettingsCanvas {
        return viewComponent as ReportSettingsCanvas;
    }

    private function onInit(event:Event):void {
        bannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
        adPlaceProxy = facade.retrieveProxy(AdPlaceProxy.NAME) as AdPlaceProxy;
        reportProxy = facade.retrieveProxy(ReportProxy.NAME) as ReportProxy;
        addEventListeners();
    }

    public override function addEventListeners():void {
        uiComponent.addEventListener(ReportSettingsCanvas.RELOAD, onReload);
    }

    public override function removeEventListeners():void {
        uiComponent.removeEventListener(ReportSettingsCanvas.RELOAD, onReload);
    }

    private function onReload(event:Event):void {
        var isSelected:Boolean = false;
        var type:int = uiComponent.getSelectedType();
        var uids:ArrayCollection = new ArrayCollection();
        for each (var iCheckBox:CheckBox in uiComponent.entityVB.getChildren()) {
            if (iCheckBox.selected) {
                isSelected = true;
                switch (type) {
                    case ApplicationConstants.REPORT_TYPE_BANNERS: // banner
                        var relatedBanners:ArrayCollection = bannerProxy.getBannersByParentUid(iCheckBox.data.uid);
                        for each (var iBanner:BannerVO in relatedBanners) {
                            uids.addItem(iBanner.uid);
                        }
                        break;
                    case ApplicationConstants.REPORT_TYPE_AD_PLACES: // ad place
                        uids.addItem(iCheckBox.data.uid);
                        break;
                    case ApplicationConstants.REPORT_TYPE_BANNER_ON_AD_PLACES: // banner in ad place
                        if (iCheckBox.data is BannerVO) {
                            uids.addItem(iCheckBox.data.uid + "x" + iCheckBox.data.adPlaceUid);
                        }
                        break;
                }
            }
        }
        if (!isSelected) {
            Alert.show("At least one " + uiComponent.getSelectedTypeName() + " should be selected.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite);
        } else {
            if (uids.length == 0) {
                reportProxy.reportsRowsAC = new ArrayCollection();
                sendNotification(ApplicationConstants.CUSTOM_REPORT_LOADED);
            } else {
                sendNotification(ApplicationConstants.CUSTOM_REPORT_LOAD);
                var reportCriteria:ReportCriteriaVO = new ReportCriteriaVO();
                reportCriteria.type = type;
                reportCriteria.fromDate = uiComponent.fromPeriodDF.selectedDate;
                var toDate:Date = uiComponent.toPeriodDF.selectedDate;
                reportCriteria.toDate = new Date(toDate.fullYear, toDate.month, toDate.date + 1);
                reportCriteria.precision = uiComponent.precisionCB.selectedIndex;
                switch (type) {
                    case ApplicationConstants.REPORT_TYPE_BANNERS: // banner
                        reportCriteria.bannerUids = uids;
                        break;
                    case ApplicationConstants.REPORT_TYPE_AD_PLACES: // ad place
                        reportCriteria.adPlaceUids = uids;
                        break;
                    case ApplicationConstants.REPORT_TYPE_BANNER_ON_AD_PLACES: // banner in ad place
                        reportCriteria.bannerUidByAdPlaceUids = uids;
                        break;
                }
                reportProxy.loadCustomReport(reportCriteria);
            }
        }
    }
}
}