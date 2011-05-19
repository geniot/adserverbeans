package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.model.AdPlaceProxy;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.vo.AdPlaceVO;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.BaseVO;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.containers.VBox;
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.controls.RadioButton;
import mx.events.FlexEvent;

public class ReportSettingsCanvas extends BaseCanvas {
    public static const RELOAD:String = "RELOAD";

    public var fromPeriodDF:DateField;
    public var toPeriodDF:DateField;
    public var periodCB:ComboBox;
    public var precisionCB:ComboBox;
    public var bannersTypeRB:RadioButton;
    public var adPlacesTypeRB:RadioButton;
    public var bannersOnAdPlacesTypeRB:RadioButton;
    public var entityVB:VBox;
    public var reloadB:Button;

    public function ReportSettingsCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    private function onCreationComplete(event:Event):void {
        dispatchEvent(new Event(INIT));
        periodCB.addEventListener(Event.CHANGE, onPeriodChange);
        fromPeriodDF.addEventListener(Event.CHANGE, onFromPeriodChange);
        toPeriodDF.addEventListener(Event.CHANGE, onToPeriodChange);
        bannersTypeRB.addEventListener(MouseEvent.CLICK, onBannersTypeClick);
        adPlacesTypeRB.addEventListener(MouseEvent.CLICK, onAdPlacesTypeRBClick);
        bannersOnAdPlacesTypeRB.addEventListener(MouseEvent.CLICK, onBannersOnAdPlacesTypeRBTypeClick);
        reloadB.addEventListener(MouseEvent.CLICK, onReload);
        onBannersTypeClick(null);
        setPeriodDF(0);
    }

    private function onPeriodChange(event:Event):void {
        setPeriodDF(periodCB.selectedIndex);
    }

    private function onBannersTypeClick(event:MouseEvent):void {
        initializationItems(0);
    }

    private function onAdPlacesTypeRBClick(event:MouseEvent):void {
        initializationItems(1);
    }

    private function onBannersOnAdPlacesTypeRBTypeClick(event:MouseEvent):void {
        initializationItems(2);
    }

    private function initializationItems(type:int):void {
        entityVB.removeAllChildren();
        var facade:ApplicationFacade = ApplicationFacade.getInstance();
        var bannerProxy:BannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
        var adPlaceProxy:AdPlaceProxy = facade.retrieveProxy(AdPlaceProxy.NAME) as AdPlaceProxy;
        var iAdPlace:AdPlaceVO;
        var adPlaceCB:CheckBox;
        switch (type) {
            case 0: // banner
                addEntityArray(bannerProxy.getBannersByParentUid(null), 0);
                break;
            case 1: // ad place
                for each (iAdPlace in adPlaceProxy.adPlaces.getValues()) {
                    adPlaceCB = addEntity(iAdPlace, 0);
                    adPlaceCB.enabled = iAdPlace.banners.length != 0;
                }
                break;
            case 2: // banner on ad place
                for each (iAdPlace in adPlaceProxy.adPlaces.getValues()) {
                    var isBannersOnAdPlace:Boolean = iAdPlace.banners.length != 0;
                    adPlaceCB = addEntity(iAdPlace, 0);
                    adPlaceCB.enabled = isBannersOnAdPlace;
                    if (isBannersOnAdPlace) {
                        adPlaceCB.addEventListener(MouseEvent.CLICK, onAdPlaceClick);
                        addEntityArray(iAdPlace.banners, 16);
                    }
                }
                break;
        }
    }

    private function onReload(event:MouseEvent):void {
        dispatchEvent(new Event(RELOAD));
    }

    private function addEntityArray(entityArray:ArrayCollection, paddingLeft:int):void {
        for each (var iEntity:Object in entityArray) {
            addEntity(iEntity, paddingLeft);
        }
    }

    private function addEntity(entity:Object, paddingLeft:int):CheckBox {
        var entityCB:CheckBox = new CheckBox();
        entityCB.data = entity;
        entityCB.label = (entity is BannerVO) ?
                BannerVO(entity).bannerName : AdPlaceVO(entity).adPlaceName;
        if (paddingLeft != 0) {
            entityCB.setStyle("paddingLeft", paddingLeft);
            entityCB.addEventListener(MouseEvent.CLICK, onBannerClick);
        }
        entityVB.addChild(entityCB);
        return entityCB;
    }

    public function onAdPlaceClick(event:MouseEvent):void {
        var adPlaceCB:CheckBox = CheckBox(event.currentTarget);
        adPlaceCB.alpha = ApplicationConstants.ALPHA_ACTIVE;
        var isSelected:Boolean = adPlaceCB.selected;
        var index:int = entityVB.getChildIndex(adPlaceCB) + 1;
        while (index < entityVB.numChildren && CheckBox(entityVB.getChildAt(index)).data is BannerVO) {
            CheckBox(entityVB.getChildAt(index)).selected = isSelected;
            index += 1;
        }
    }

    public function onBannerClick(event:MouseEvent):void {
        var bannerCB:CheckBox = CheckBox(event.currentTarget);
        var isSelected:Boolean = bannerCB.selected;
        var index:int = entityVB.getChildIndex(bannerCB) - 1;
        while (CheckBox(entityVB.getChildAt(index)).data is BannerVO) {
            index -= 1;
        }
        var adPlaceCB:CheckBox = CheckBox(entityVB.getChildAt(index));
        index += 1;
        var isAllSelected:Boolean = true;
        while (index < entityVB.numChildren && CheckBox(entityVB.getChildAt(index)).data is BannerVO) {
            if (CheckBox(entityVB.getChildAt(index)).selected != isSelected) {
                isAllSelected = false;
            }
            index += 1;
        }
        if (isAllSelected) {
            adPlaceCB.selected = isSelected;
            adPlaceCB.alpha = ApplicationConstants.ALPHA_ACTIVE;
        } else {
            adPlaceCB.selected = true;
            adPlaceCB.alpha = ApplicationConstants.ALPHA_INACTIVE;
        }

    }

    private function setPeriodDF(selectedPeriod:int):void {
        var now:Date = new Date();
        var currentDate:Number = now.date;
        var currentMonth:Number = now.month;
        var currentYear:Number = now.fullYear;

        var fromDate:Date;
        var toDate:Date;
        switch (selectedPeriod) {    
            case 0: // this month
                fromDate = new Date(currentYear, currentMonth, 1);
                toDate   = new Date(currentYear, currentMonth, currentDate);
                break;
            case 1: // last 7 days
                fromDate = new Date(currentYear, currentMonth, currentDate - 6);
                toDate   = new Date(currentYear, currentMonth, currentDate);
                break;
            case 2: // today
                fromDate = new Date(currentYear, currentMonth, currentDate);
                toDate   = new Date(currentYear, currentMonth, currentDate);
                break;
            case 3: // yesterday
                fromDate = new Date(currentYear, currentMonth, currentDate - 1);
                toDate   = new Date(currentYear, currentMonth, currentDate - 1);
                break;
            case 4: // last week
                fromDate = new Date(currentYear, currentMonth, currentDate - now.day);
                toDate   = new Date(currentYear, currentMonth, currentDate);
                break;
            case 5: // last month
                fromDate = new Date(currentYear, currentMonth - 1, 1);
                toDate = new Date(currentYear, currentMonth, 0);
                break;
        }
        fromPeriodDF.selectedDate = fromDate;
        toPeriodDF.selectedDate = toDate;
        onFromPeriodChange(null);
        onToPeriodChange(null);
    }

    private function onFromPeriodChange(event:Event):void {
        var selectedDate:Date = fromPeriodDF.selectedDate;
        var yesterday:Date = new Date(selectedDate.fullYear, selectedDate.month, selectedDate.date - 1);
        toPeriodDF.disabledRanges = [{rangeEnd: yesterday}];
    }

    private function onToPeriodChange(event:Event):void {
        var selectedDate:Date = toPeriodDF.selectedDate;
        var tomorrow:Date = new Date(selectedDate.fullYear, selectedDate.month, selectedDate.date + 1);
        fromPeriodDF.disabledRanges = [{rangeStart: tomorrow}];
    }

    public function getSelectedType():int {
        var type:int = ApplicationConstants.REPORT_TYPE_BANNERS;
        if (adPlacesTypeRB.selected) {
            type = ApplicationConstants.REPORT_TYPE_AD_PLACES;
        } else if (bannersOnAdPlacesTypeRB.selected) {
            type = ApplicationConstants.REPORT_TYPE_BANNER_ON_AD_PLACES;
        }
        return type;
    }

    public function getSelectedTypeName():String {
        return adPlacesTypeRB.selected ? "ad place" : "banner";
    }
}
}