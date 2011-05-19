package com.adserversoft.flexfuse.client.view.titlewindow {
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import mx.containers.TitleWindow;
import mx.core.UIComponent;
import mx.events.CloseEvent;

public class BaseTitleWindow extends TitleWindow {

    public static const CLOSE_POPUP:String = "CLOSE_POPUP";
    public static const SAVE:String = "SAVE";
    public static const BROWSE:String = "BROWSE";
    public static const CANCEL:String = "CANCEL";
    public static const INDEX_CHANGED_EVENT:String = 'INDEX_CHANGED_EVENT';
    [Bindable]
    public var mode:String;
    public var invalidField:UIComponent;

    public function BaseTitleWindow() {
        super();
        addEventListener(Event.CLOSE, close);
    }

    protected function close(event:Event):void {
        dispatchEvent(new Event(CLOSE_POPUP));
    }

    public function onAlertClose(event:CloseEvent):void {
        invalidField.setFocus();
    }

    public function keyup(e:KeyboardEvent):void {
        if (e.keyCode == Keyboard.ESCAPE) {
            dispatchEvent(new Event(CANCEL));
        } else if (e.keyCode == Keyboard.ENTER) {
            dispatchEvent(new Event(SAVE));
        }
    }
}
}
