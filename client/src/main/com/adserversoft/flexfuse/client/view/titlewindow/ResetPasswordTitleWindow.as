package com.adserversoft.flexfuse.client.view.titlewindow {
import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Button;
import mx.controls.TextInput;
import mx.events.FlexEvent;
import mx.validators.StringValidator;

public class ResetPasswordTitleWindow extends BaseTitleWindow {
    [Bindable]
    public var password:TextInput;
    //    [Bindable]
    //    public var confirmPassword:TextInput;
    [Bindable]
    public var cancelBtn:Button;
    public var saveBtn:Button;

    public var passwordStringValidator:StringValidator;
    //    public var confirmPasswordStringValidator:StringValidator;

    public function ResetPasswordTitleWindow() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {

        saveBtn.addEventListener(MouseEvent.CLICK, login);
        cancelBtn.addEventListener(MouseEvent.CLICK, close);

    }


    private function login(event:Event):void {
        dispatchEvent(new Event(SAVE));
    }


}
}