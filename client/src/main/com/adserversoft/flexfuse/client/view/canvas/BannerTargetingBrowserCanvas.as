package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;

import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.containers.VBox;
import mx.controls.CheckBox;
import mx.controls.RadioButton;
import mx.events.FlexEvent;

public class BannerTargetingBrowserCanvas extends BaseCanvas {
    public var allRB:RadioButton;
    public var someRB:RadioButton;
    public var brVB:VBox;
    public var cb0:CheckBox;
    public var cb1:CheckBox;
    public var cb2:CheckBox;
    public var cb3:CheckBox;
    public var cb4:CheckBox;
    public var cb5:CheckBox;
    public var cb6:CheckBox;
    public var cb7:CheckBox;

    public var banner:BannerVO;

    public function BannerTargetingBrowserCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        allRB.addEventListener(MouseEvent.CLICK, browsersChangeHandler);
        someRB.addEventListener(MouseEvent.CLICK, browsersChangeHandler);
        for (var i:int = 0; i < 8; i++) {
            this["cb" + i].addEventListener(MouseEvent.CLICK, onSomeClick);
        }
        dispatchEvent(new Event(INIT));
    }

    public function browsersChangeHandler(event:Event):void {
        var isAllBrowsersSelected:Boolean = allRB.selected;
        brVB.enabled = !isAllBrowsersSelected;
        someRB.selected = !isAllBrowsersSelected;
    }

    private function onSomeClick(event:Event):void {
        if (browsersSelected() == ApplicationConstants.SELECTED_ALL) {
            allRB.selected = true;
            browsersChangeHandler(null);
        }
    }

    private function browsersSelected():int {
        var nBrowsersSelected:int = 0;
        if (allRB.selected) {
            nBrowsersSelected = 8;
        } else {
            for (var i:int = 0; i < 8; i++) {
                if (this["cb" + i].selected) {
                    nBrowsersSelected++;
                }
            }
        }
        switch (nBrowsersSelected) {
            case 0:
                return ApplicationConstants.SELECTED_NONE;
            case 8:
                return ApplicationConstants.SELECTED_ALL;
            default: //  0<nBrowsersSelected<8
                return ApplicationConstants.SELECTED_SOME;
        }
    }

    public function isBrowsersNotSelected():Boolean {
        return browsersSelected() == ApplicationConstants.SELECTED_NONE;
    }

    public function getBrowsersBitsSelected():String {
        var browsersBits:String = "";
        if (allRB.selected) {
            browsersBits = ApplicationConstants.initBits(8, true); // = "1111111";
        } else {
            for (var i:int = 0; i < 8; i++) {
                browsersBits += this["cb" + i].selected ? "1" : "0";
            }
        }
        return browsersBits;
    }
}
}