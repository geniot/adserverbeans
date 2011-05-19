package com.adserversoft.flexfuse.client.view.titlewindow {


import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.TextInput;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;
import mx.validators.EmailValidator;


public class PasswordReminderTitleWindow extends BaseTitleWindow {

    public static const REMIND_PASSWORD:String = "remind_password";
    [Bindable]
    public var email:TextInput;
    [Bindable]
    public var remindPasswordBtn:Button;
    public var cancelBtn:Button;


    public var emailValidator:EmailValidator;
//    public var emailValidator2:EmailValidator;

    public function PasswordReminderTitleWindow() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {

        remindPasswordBtn.addEventListener(MouseEvent.CLICK, remindPassword);
        cancelBtn.addEventListener(MouseEvent.CLICK, close);
    }




    private function remindPassword(event:Event):void {
        dispatchEvent(new Event(REMIND_PASSWORD));
    }


    public function validateForRemind():String {
        var regC:PasswordReminderTitleWindow = this;
        var result:ValidationResultEvent = emailValidator.validate();
        if (result.type == ValidationResultEvent.INVALID) {
            Alert.show(result.message, "Invalid", Alert.OK, regC, onAlertClose);
            invalidField = email;
            return ValidationResultEvent.INVALID;
        }

        return ValidationResultEvent.VALID;
    }


}
}