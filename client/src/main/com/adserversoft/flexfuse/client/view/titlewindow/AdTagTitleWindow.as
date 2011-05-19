package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.model.vo.AdPlaceVO;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.system.System;

import mx.controls.Button;
import mx.controls.Label;
import mx.controls.TextArea;
import mx.events.FlexEvent;

public class AdTagTitleWindow extends BaseTitleWindow {
    public static const COPY2CLIPBOARD:String = "COPY2CLIPBOARD";

    public var getAdTagBtn:Button;
    public var cancelBtn:Button;
    public var adTagTA:TextArea;
    public var tipL:Label;

    public var adPlace:AdPlaceVO;

    public function AdTagTitleWindow() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(e:Event):void {
        cancelBtn.addEventListener(MouseEvent.CLICK, cancel);
        getAdTagBtn.addEventListener(MouseEvent.CLICK, copyToClipboard);
        addEventListener(KeyboardEvent.KEY_UP, keyup);
        adTagTA.addEventListener(MouseEvent.CLICK, onAdTagTAClick);

    }


    private function cancel(e:Event):void {
        dispatchEvent(new Event(CANCEL));
    }


    private function copyToClipboard(event:Event):void {
        System.setClipboard(adTagTA.text);
    }

    private function onAdTagTAClick(event:Event):void {
        if ((adTagTA.selectionBeginIndex != 0) && (adTagTA.selectionEndIndex != adTagTA.length)) {
            adTagTA.setSelection(0, adTagTA.length);
        } else {
            adTagTA.setSelection(0, 0);
        }
    }
}
}