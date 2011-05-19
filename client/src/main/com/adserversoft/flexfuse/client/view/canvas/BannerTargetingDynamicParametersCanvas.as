package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.events.FlexEvent;

public class BannerTargetingDynamicParametersCanvas extends BaseCanvas {
    public static const ADD_PATTERN:String = "ADD_PATTERN";

    //    [Bindable]
    public var referrerUrlDataGrid:DataGrid;
    [Bindable]
    public var dynamicParametersDataProvider:ArrayCollection;
    public var paramTI:TextInput;
    public var valueTI:TextInput;
    public var addPtrnBtn:Button;
    public var isRegexCB:CheckBox;
    public var bannerUid:String;

    public function BannerTargetingDynamicParametersCanvas() {
        super();
        dynamicParametersDataProvider = new ArrayCollection();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

    }

    protected function onCreationComplete(event:Event):void {
        addPtrnBtn.addEventListener(MouseEvent.CLICK, addPattern);
        paramTI.addEventListener(Event.CHANGE, onPatternChange);
        valueTI.addEventListener(Event.CHANGE, onPatternChange);
        referrerUrlDataGrid.addEventListener(MouseEvent.DOUBLE_CLICK, onDataGridDoubleClick);
        dispatchEvent(new Event(INIT));

        onPatternChange(null);
    }

    public function onPatternChange(e:Event):void {
        addPtrnBtn.enabled = paramTI.text.length > 0 && valueTI.text.length>0;
    }

    public function onDataGridDoubleClick(e:Event):void {
        if (referrerUrlDataGrid.selectedItem != null) {
            paramTI.text = referrerUrlDataGrid.selectedItem as String;
            onPatternChange(null);
        }
    }

    public function addPattern(event:Event):void {
        dispatchEvent(new Event(ADD_PATTERN));
    }

}
}
