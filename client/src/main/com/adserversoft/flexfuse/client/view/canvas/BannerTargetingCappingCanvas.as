package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;
import flash.events.FocusEvent;

import flash.events.MouseEvent;

import mx.controls.Button;
import mx.controls.TextInput;
import mx.events.FlexEvent;

public class BannerTargetingCappingCanvas extends BaseCanvas {
    public var mnofTI:TextInput;
    public var dvlfTI:TextInput;
    public var mnofTIProxy:TextInput = new TextInput();
    public var dvlfTIProxy:TextInput = new TextInput();
    public var infinityMaxViewsBtn:Button;
    public var infinityMaxViewsPerDayBtn:Button;
    
    public var banner:BannerVO;

    public var INFINITE:String = "infinite";//todo: load from resources file

    public function BannerTargetingCappingCanvas()
    {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }


    protected function onCreationComplete(event:*):void {
        mnofTI.addEventListener(FocusEvent.FOCUS_IN, onMaxNumberViewsFocusIn);
        mnofTI.addEventListener(FocusEvent.FOCUS_OUT, onMaxNumberViewsFocusOut);
        dvlfTI.addEventListener(FocusEvent.FOCUS_IN, onDailyViewsLimitFocusIn);
        dvlfTI.addEventListener(FocusEvent.FOCUS_OUT, onDailyViewsLimitFocusOut);
        infinityMaxViewsBtn.addEventListener(MouseEvent.CLICK, onInfinityMaxViews);
        infinityMaxViewsPerDayBtn.addEventListener(MouseEvent.CLICK, onInfinityMaxViewsPerDay);

        dispatchEvent(new Event(INIT));
    }

    public function onDailyViewsLimitFocusIn(event:FocusEvent):void {
        if (dvlfTI.text == INFINITE) {
            dvlfTI.text = "";
            dvlfTI.setStyle("color", 0x000000);
        }
    }

    public function onDailyViewsLimitFocusOut(event:FocusEvent):void {
        if (dvlfTI.text == "" || dvlfTI.text.split("0").length == dvlfTI.text.length + 1) { //empty or all zeros?
            dvlfTI.text = INFINITE;
            dvlfTI.setStyle("color", 0x808080);
        } else {
            //removing trailing zeros
            dvlfTI.text = String(int(dvlfTI.text));
        }

        dvlfTIProxy.text = dvlfTI.text;
    }

    public function onMaxNumberViewsFocusIn(event:FocusEvent):void {
        if (mnofTI.text == INFINITE) {
            mnofTI.text = "";
            mnofTI.setStyle("color", 0x000000);
        }
    }

    public function onMaxNumberViewsFocusOut(event:FocusEvent):void {
        if (mnofTI.text == "" || mnofTI.text.split("0").length == mnofTI.text.length + 1) { //empty or all zeros?
            mnofTI.text = INFINITE;
            mnofTI.setStyle("color", 0x808080);
        } else {
            //removing trailing zeros
            mnofTI.text = String(int(mnofTI.text));
        }

        mnofTIProxy.text = mnofTI.text;
    }

    private function onInfinityMaxViews(event:Event):void {
        mnofTI.text = INFINITE;
        mnofTI.setStyle("color", 0x808080);
        mnofTIProxy.text = mnofTI.text;
    }

    private function onInfinityMaxViewsPerDay(event:Event):void {
        dvlfTI.text = INFINITE;
        dvlfTI.setStyle("color", 0x808080);
        dvlfTIProxy.text = dvlfTI.text;
    }

    public function isMaxNumberViewsGreater():Boolean {
        if (mnofTIProxy.text == "infinite") {
            return true;
        }
        return int(mnofTIProxy.text) >= int(dvlfTIProxy.text);
    }
}
}