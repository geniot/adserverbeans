package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;

import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.containers.HBox;
import mx.controls.CheckBox;
import mx.controls.RadioButton;
import mx.events.FlexEvent;

public class BannerTargetingTimeHourCanvas extends BaseCanvas {
    public var allHourRB:RadioButton;
    public var someHourRB:RadioButton;
    public var dayHB:HBox;
    public var morningCB:CheckBox;
    public var afternoonCB:CheckBox;
    public var eveningCB:CheckBox;
    public var nightCB:CheckBox;
    public var cb0: CheckBox;
    public var cb1: CheckBox;
    public var cb2: CheckBox;
    public var cb3: CheckBox;
    public var cb4: CheckBox;
    public var cb5: CheckBox;
    public var cb6: CheckBox;
    public var cb7: CheckBox;
    public var cb8: CheckBox;
    public var cb9: CheckBox;
    public var cb10:CheckBox;
    public var cb11:CheckBox;
    public var cb12:CheckBox;
    public var cb13:CheckBox;
    public var cb14:CheckBox;
    public var cb15:CheckBox;
    public var cb16:CheckBox;
    public var cb17:CheckBox;
    public var cb18:CheckBox;
    public var cb19:CheckBox;
    public var cb20:CheckBox;
    public var cb21:CheckBox;
    public var cb22:CheckBox;
    public var cb23:CheckBox;

    public var banner:BannerVO;

    public function BannerTargetingTimeHourCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        allHourRB.addEventListener(MouseEvent.CLICK, dayHourChangeHandler);
        someHourRB.addEventListener(MouseEvent.CLICK, dayHourChangeHandler);

        morningCB.addEventListener(MouseEvent.CLICK, onPartDayClick);
        afternoonCB.addEventListener(MouseEvent.CLICK, onPartDayClick);
        eveningCB.addEventListener(MouseEvent.CLICK, onPartDayClick);
        nightCB.addEventListener(MouseEvent.CLICK, onPartDayClick);

        for (var i:int = 0; i < 23; i++) {
            this["cb" + i].addEventListener(MouseEvent.CLICK, onSomeClick);
        }
        dispatchEvent(new Event(INIT));
    }

    public function dayHourChangeHandler(event:Event):void {
        var isAllHoursSelected:Boolean = allHourRB.selected;
        dayHB.enabled = !isAllHoursSelected;
        someHourRB.selected = !isAllHoursSelected;
    }

    public function onPartDayClick(event:*):void {
        var groupName:String = event.currentTarget.name;
        if (groupName.indexOf("morningCB") != -1 || groupName.indexOf("afternoonCB") != -1 ||
                groupName.indexOf("eveningCB") != -1 || groupName.indexOf("nightCB") != -1) {
            groupName = groupName.substr(0, groupName.length - 2);
            var rangeName:String = groupName.toUpperCase() + "_RANGE";
            var isSelectedAll:Boolean = hoursSelected(ApplicationConstants[rangeName]) == ApplicationConstants.SELECTED_ALL;
            selectRange(ApplicationConstants[rangeName], !isSelectedAll);
            this[groupName + "CB"].selected = !isSelectedAll;
            this[groupName + "CB"].alpha = ApplicationConstants.ALPHA_ACTIVE;
        }
    }

    public function onSomeClick(event:Event):void {
        var name:String = event.currentTarget.name;
        if (name.indexOf("cb") == 0) {
            name = name.substr(2);
            var rangeName:String = ApplicationConstants.getRangeName(int(name));
            var groupName:String = rangeName.substr(0, rangeName.indexOf("_RANGE")).toLowerCase();
            var typeSelected:int = hoursSelected(ApplicationConstants[rangeName]);
            this[groupName + "CB"].selected = (typeSelected != ApplicationConstants.SELECTED_NONE);
            this[groupName + "CB"].alpha = (typeSelected == ApplicationConstants.SELECTED_SOME)
                    ? ApplicationConstants.ALPHA_INACTIVE : ApplicationConstants.ALPHA_ACTIVE;
        }
    }

    private function selectRange(range:Array, selected:Boolean):void {
        for (var i:int = 0; i < range.length; i++) {
            this["cb" + range[i]].selected = selected;
        }
    }

    public function hoursSelected(range:Array):int {
        var nHoursSelected:int = 0;
        if (allHourRB.selected) {
            nHoursSelected = range.length;
        } else {
            for (var i:int = 0; i < range.length; i++) {
                if (this["cb" + range[i]].selected) {
                    nHoursSelected++;
                }
            }
        }
        switch (nHoursSelected) {
            case 0:
                return ApplicationConstants.SELECTED_NONE;
            case range.length:
                return ApplicationConstants.SELECTED_ALL;
            default:
                return ApplicationConstants.SELECTED_SOME;
        }
    }

    public function isHoursNotSelected():Boolean {
        return hoursSelected(ApplicationConstants.HOURS_RANGE)
                == ApplicationConstants.SELECTED_NONE;
    }

    public function getHourBitsSelected():String {
        var dayBits:String = "";
        if (allHourRB.selected) {
            dayBits = ApplicationConstants.initBits(24, true);
        } else {
            for (var i:int = 0; i < 24; i++) {
                dayBits += this["cb" + i].selected ? "1" : "0";
            }
        }
        return dayBits;
    }
}
}