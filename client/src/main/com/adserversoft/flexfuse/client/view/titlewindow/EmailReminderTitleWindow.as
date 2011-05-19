package com.adserversoft.flexfuse.client.view.titlewindow {
import flash.events.Event;

import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.TextInput;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;
import mx.validators.StringValidator;

public class EmailReminderTitleWindow extends BaseTitleWindow {

    public static const REMIND_EMAIL:String = "REMIND_EMAIL";
    [Bindable]
    public var firstNameTI:TextInput;
    [Bindable]
    public var lastNameTI:TextInput;
    public var remindEmailBtn:Button;
    public var cancelBtn:Button;
    public var firstNameStringValidator:StringValidator;
    public var lastNameStringValidator:StringValidator;


    public function EmailReminderTitleWindow() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {

        remindEmailBtn.addEventListener(MouseEvent.CLICK, remindEmail);
        cancelBtn.addEventListener(MouseEvent.CLICK, close);
    }




    private function remindEmail(event:Event):void {
        dispatchEvent(new Event(REMIND_EMAIL));
    }


    public function validateForRemind():String {
        var regC:EmailReminderTitleWindow = this;
        var result:ValidationResultEvent = firstNameStringValidator.validate();
        if (result.type == ValidationResultEvent.INVALID) {
            Alert.show(result.message, "Invalid", Alert.OK, regC, onAlertClose);
            invalidField = firstNameTI;
            return ValidationResultEvent.INVALID;
        }
        result = lastNameStringValidator.validate();
        if (result.type == ValidationResultEvent.INVALID) {
            Alert.show(result.message, "Invalid", Alert.OK, regC, onAlertClose);
            invalidField = lastNameTI;
            return ValidationResultEvent.INVALID;
        }
        return ValidationResultEvent.VALID;
    }

}
}