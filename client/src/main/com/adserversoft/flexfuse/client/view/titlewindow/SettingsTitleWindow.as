package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.view.canvas.AdminEmailSettingsCanvas;
import com.adserversoft.flexfuse.client.view.canvas.AdminSettingsCanvas;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.containers.TabNavigator;
import mx.controls.Button;
import mx.events.FlexEvent;

public class SettingsTitleWindow extends BaseTitleWindow {
    public var tabNavigator:TabNavigator;
    public var adminSettingsCanvas:AdminSettingsCanvas;
//    public var adminEmailSettingsCanvas:AdminEmailSettingsCanvas;

    public var cancelBtn:Button;
    public var saveBtn:Button;


    public function SettingsTitleWindow() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        cancelBtn.addEventListener(MouseEvent.CLICK, cancel);
        saveBtn.addEventListener(MouseEvent.CLICK, save);
    }

    private function cancel(e:Event):void {
        dispatchEvent(new Event(CANCEL));
    }

    private function save(e:Event):void {
        dispatchEvent(new Event(SAVE));
    }


}
}