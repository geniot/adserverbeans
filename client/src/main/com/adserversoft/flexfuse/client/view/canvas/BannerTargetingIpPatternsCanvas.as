package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.vo.IpPatternVO;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Button;
import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.events.FlexEvent;

public class BannerTargetingIpPatternsCanvas extends BaseCanvas {
    public static const ADD_PATTERN:String = "ADD_PATTERN";

    public var ipPatternsDataGrid:DataGrid;
    [Bindable]
    public var ipPatternsDataProvider:ArrayCollection;
    public var patternTI1:TextInput;
    public var patternTI2:TextInput;
    public var patternTI3:TextInput;
    public var patternTI4:TextInput;
    public var addPtrnBtn:Button;
    public var bannerUid:String;

    public function BannerTargetingIpPatternsCanvas() {
        super();
        ipPatternsDataProvider = new ArrayCollection();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

    }

    protected function onCreationComplete(event:Event):void {
        addPtrnBtn.addEventListener(MouseEvent.CLICK, addPattern);
        patternTI1.addEventListener(Event.CHANGE, onPatternChange);
        patternTI2.addEventListener(Event.CHANGE, onPatternChange);
        patternTI3.addEventListener(Event.CHANGE, onPatternChange);
        patternTI4.addEventListener(Event.CHANGE, onPatternChange);
        ipPatternsDataGrid.addEventListener(MouseEvent.DOUBLE_CLICK, onDataGridDoubleClick);
        dispatchEvent(new Event(INIT));

        onPatternChange(null);
    }

    public function onPatternChange(e:Event):void {
        if (e!=null && e.currentTarget is TextInput) {
            if ((e.currentTarget as TextInput).text.indexOf("*") > -1) {
                (e.currentTarget as TextInput).text = "*";
            }
        }
        addPtrnBtn.enabled = patternTI1.text.length > 0 &&
                             patternTI2.text.length > 0 &&
                             patternTI3.text.length > 0 &&
                             patternTI4.text.length > 0;
    }


    public function onDataGridDoubleClick(e:Event):void {
        if (ipPatternsDataGrid.selectedItem != null) {
            //Alert.show(ipPatternsDataGrid.selectedItem as String);
            var ip:String = (ipPatternsDataGrid.selectedItem as IpPatternVO).ipPattern;
            var lastDotIndex:int = -1;
            for (var i:int = 0; i < 4; i++) {
                var index:int = ip.indexOf(".", lastDotIndex + 1);
                if (index < 0) index = ip.length;
                this["patternTI" + (i + 1).toString()].text = ip.substring(lastDotIndex + 1, index);
                lastDotIndex = index;
            }

            onPatternChange(null);
        }
    }

    public function addPattern(event:Event):void {
        dispatchEvent(new Event(ADD_PATTERN));
    }

}
}
