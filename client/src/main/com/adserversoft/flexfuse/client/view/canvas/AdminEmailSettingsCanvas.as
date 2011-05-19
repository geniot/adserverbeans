package com.adserversoft.flexfuse.client.view.canvas {
import flash.events.Event;

import mx.controls.TextInput;
import mx.events.FlexEvent;
import mx.validators.EmailValidator;
import mx.validators.StringValidator;

public class AdminEmailSettingsCanvas extends BaseCanvas {
    [Bindable]
    public var emailSubjectTI:TextInput;
    [Bindable]
    public var userNameTI:TextInput;
    [Bindable]
    public var passwordTI:TextInput;
    [Bindable]
    public var smtpServerTI:TextInput;
    [Bindable]
    public var smtpServerPortTI:TextInput;
    [Bindable]
    public var supportEmailTI:TextInput;
    [Bindable]
    public var fromEmailTI:TextInput;

    public var emailSubjectStringValidator:StringValidator;
    public var userNameStringValidator:StringValidator;
    public var passwordStringValidator:StringValidator;
    public var serverNameStringValidator:StringValidator;
    public var supportEmailStringValidator:EmailValidator;
    public var fromEmailStringValidator:EmailValidator;

    public function AdminEmailSettingsCanvas()
    {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }


    protected function onCreationComplete(event:*):void {
        dispatchEvent(new Event(INIT));
    }

    public function portValidation():Boolean {
        if ((int(smtpServerPortTI.text) > 10000) || (int(smtpServerPortTI.text) < 1))return false; else return true;
    }

}
}