package com.adserversoft.flexfuse.client.view.component.button {
import flash.events.MouseEvent;

import mx.controls.LinkButton;
import mx.events.FlexEvent;

public class ExpandToggleButton extends LinkButton {
    [Embed(source="/images/plus.gif")]
    [Bindable]
    public var iconPlus:Class;
    [Embed(source="/images/minus.gif")]
    [Bindable]
    public var iconMinus:Class;

    [Embed(source="/images/inactive.gif")]
    [Bindable]
    public var iconInactive:Class;
    [Embed(source="/images/active.gif")]
    [Bindable]
    public var iconActive:Class;

    static public var PLUS_MINUS_IMAGE_TYPE:int = 1;
    static public var ACTIVE_INACTIVE_IMAGE_TYPE:int = 2;

    public var imageType:int = PLUS_MINUS_IMAGE_TYPE;

    public function ExpandToggleButton() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    private function onCreationComplete(e:*):void {
        setStyle("icon", imageType == PLUS_MINUS_IMAGE_TYPE ? iconPlus : iconActive);
        setStyle("focusAlpha", "0.0");
        setStyle("rollOverColor", "#f7f7f7");
        setStyle("selectionColor", "#f7f7f7");
        focusEnabled = false;
        selected = false;
        toggle = true;
    }

    override protected function clickHandler(event:MouseEvent):void {
        super.clickHandler(event);
        updateView();

    }

    private function updateView():void {
        if (imageType == PLUS_MINUS_IMAGE_TYPE) {
            setStyle("icon", selected ? iconMinus : iconPlus);
            toolTip = selected ? "Contract" : "Expand";
        } else {
            setStyle("icon", selected ? iconInactive : iconActive);
            toolTip = selected ? "Enable" : "Disable";
        }
    }

    public override function set selected(value:Boolean):void {
        super.selected = value;
        updateView();
    }


}
}