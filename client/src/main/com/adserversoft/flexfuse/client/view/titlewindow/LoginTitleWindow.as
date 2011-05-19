package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.view.canvas.GuestManagementCanvas;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Button;
import mx.events.FlexEvent;

public class LoginTitleWindow extends BaseTitleWindow {

    public var guestManagementCanvas:GuestManagementCanvas;
    public var cancelBtn:Button;
    public var loginBtn:Button;

    public function LoginTitleWindow() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        cancelBtn.addEventListener(MouseEvent.CLICK, onClose);
        loginBtn.addEventListener(MouseEvent.CLICK, onLogin);
    }

    private function onClose(e:Event):void {
        dispatchEvent(new Event(CANCEL));
    }

    private function onLogin(e:Event):void {
        dispatchEvent(new Event(SAVE));
    }


}
}