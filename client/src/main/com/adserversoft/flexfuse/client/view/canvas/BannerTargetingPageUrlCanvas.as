package com.adserversoft.flexfuse.client.view.canvas {
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Button;
import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.events.FlexEvent;

public class BannerTargetingPageUrlCanvas extends BaseCanvas {
    public static const ADD_PATTERN:String = "ADD_PATTERN";

    //    [Bindable]
    public var pageUrlDataGrid:DataGrid;
    [Bindable]
    public var pageUrlDataProvider:ArrayCollection;
    public var patternTI:TextInput;
    public var addPtrnBtn:Button;
    public var bannerUid:String; 

    public function BannerTargetingPageUrlCanvas() {
        super();
        pageUrlDataProvider = new ArrayCollection();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        addPtrnBtn.addEventListener(MouseEvent.CLICK, addPattern);
        patternTI.addEventListener(Event.CHANGE, onPatternChange);
        pageUrlDataGrid.addEventListener(MouseEvent.DOUBLE_CLICK, onDataGridDoubleClick);
        dispatchEvent(new Event(INIT));
        onPatternChange(null);
    }

    public function onPatternChange(e:Event):void {
        addPtrnBtn.enabled = patternTI.text.length > 0;
    }

    public function onDataGridDoubleClick(e:Event):void {
        if (pageUrlDataGrid.selectedItem != null) {
            patternTI.text = pageUrlDataGrid.selectedItem as String;
            onPatternChange(null);
        }
    }

    public function addPattern(event:Event):void {
        dispatchEvent(new Event(ADD_PATTERN));
    }

}
}