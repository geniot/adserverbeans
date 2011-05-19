package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;

import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.containers.VBox;
import mx.controls.CheckBox;
import mx.controls.RadioButton;
import mx.events.FlexEvent;

public class BannerTargetingTimeCanvas extends BaseCanvas {
    public var allRB:RadioButton;
    public var someRB:RadioButton;
    public var weekVB:VBox;
    public var cb0:CheckBox;
    public var cb1:CheckBox;
    public var cb2:CheckBox;
    public var cb3:CheckBox;
    public var cb4:CheckBox;
    public var cb5:CheckBox;
    public var cb6:CheckBox;

    public var banner:BannerVO;

    public function BannerTargetingTimeCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        allRB.addEventListener(MouseEvent.CLICK, weekDaysChangeHandler);
        someRB.addEventListener(MouseEvent.CLICK, weekDaysChangeHandler);
        for (var i:int = 0; i < 7; i++) {
            this["cb" + i].addEventListener(MouseEvent.CLICK, onSomeClick);
        }
        dispatchEvent(new Event(INIT));
    }

    public function weekDaysChangeHandler(event:Event):void {
        var isAllWeekDaysSelected:Boolean = allRB.selected;
        weekVB.enabled = !isAllWeekDaysSelected;
        someRB.selected = !isAllWeekDaysSelected;
    }

    private function onSomeClick(event:Event):void {
        if (weekDaysSelected() == ApplicationConstants.SELECTED_ALL) {
            allRB.selected = true;
            weekDaysChangeHandler(null);
        }
    }

    private function weekDaysSelected():int {
        var nWeekDaysSelected:int = 0;
        if (allRB.selected) {
            nWeekDaysSelected = 7;
        } else {
            for (var i:int = 0; i < 7; i++) {
                if (this["cb" + i].selected) {
                    nWeekDaysSelected++;
                }
            }
        }
        switch (nWeekDaysSelected) {
            case 0:
                return ApplicationConstants.SELECTED_NONE;
            case 7:
                return ApplicationConstants.SELECTED_ALL;
            default: // 1, 2, 3, 4, 5, 6
                return ApplicationConstants.SELECTED_SOME;
        }
    }

    public function isWeekDaysNotSelected():Boolean {
        return weekDaysSelected() == ApplicationConstants.SELECTED_NONE;
    }

    public function getDayBitsSelected():String {
        var dayBits:String = "";
        if (allRB.selected) {
            dayBits = ApplicationConstants.initBits(7, true); // = "1111111";
        } else {
            for (var i:int = 0; i < 7; i++) {
                dayBits += this["cb" + i].selected ? "1" : "0";
            }
        }
        return dayBits;    
    }
}
}