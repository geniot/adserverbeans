package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.containers.HBox;
import mx.controls.CheckBox;
import mx.controls.RadioButton;
import mx.events.FlexEvent;

public class BannerTargetingOsCanvas extends BaseCanvas {
    public static const nCheckBox:int = 16;

    public var allRB:RadioButton;
    public var someRB:RadioButton;
    public var osHB:HBox;
    public var cb0: CheckBox;
    public var banner:BannerVO;

    public function BannerTargetingOsCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        allRB.addEventListener(MouseEvent.CLICK, osChangeHandler);
        someRB.addEventListener(MouseEvent.CLICK, osChangeHandler);
        for (var i:int = 0; i < nCheckBox; i++) {
            this["cb" + i].addEventListener(MouseEvent.CLICK, onSomeClick);
        }
        dispatchEvent(new Event(INIT));
    }

    public function osChangeHandler(event:Event):void {
        var isAllOsSelected:Boolean = allRB.selected;
        osHB.enabled = !isAllOsSelected;
        someRB.selected = !isAllOsSelected;
    }

    private function onSomeClick(event:Event):void {
        if (osSelected() == ApplicationConstants.SELECTED_ALL) {
            allRB.selected = true;
            osChangeHandler(null);
        }
    }

    private function osSelected():int {
        var nOsSelected:int = 0;
        if (allRB.selected) {
            nOsSelected = nCheckBox;
        } else {
            for (var i:int = 0; i < nCheckBox; i++) {
                if (this["cb" + i].selected) {
                    nOsSelected++;
                }
            }
        }
        switch (nOsSelected) {
            case 0:
                return ApplicationConstants.SELECTED_NONE;
            case nCheckBox:
                return ApplicationConstants.SELECTED_ALL;
            default: //  0<nOsSelected<nCheckBox
                return ApplicationConstants.SELECTED_SOME;
        }
    }

    public function isOsNotSelected():Boolean {
        return osSelected() == ApplicationConstants.SELECTED_NONE;
    }

    public function getOsBitsSelected():String {
        var osBits:String = "";
        if (allRB.selected) {
            osBits = ApplicationConstants.initBits(nCheckBox, true); // = "1111111";
        } else {
            for (var i:int = 0; i < nCheckBox; i++) {
                osBits += this["cb" + i].selected ? "1" : "0";
            }
        }
        return osBits;
    }
}
}