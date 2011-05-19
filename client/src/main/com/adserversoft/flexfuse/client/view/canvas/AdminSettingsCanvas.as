package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.view.component.NoTrimStringValidator;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Button;
import mx.controls.Image;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.events.FlexEvent;
import mx.validators.StringValidator;

public class AdminSettingsCanvas extends BaseCanvas {

    public static const BROWSE:String = "BROWSE";


    [Bindable]
    public var emailTI:TextInput;
    [Bindable]
    public var passwordTI:TextInput;
    [Bindable]
    public var firstNameTI:TextInput;
    [Bindable]
    public var lastNameTI:TextInput;
    [Bindable]
    public var logoFileTI:TextInput;
    [Bindable]
    public var balanceLbl:Label; 

    public var emailStringValidator:StringValidator;
    public var passwordStringValidator:NoTrimStringValidator;
    public var firstNameStringValidator:StringValidator;
    public var lastNameStringValidator:StringValidator;

    public var passwordReset:Boolean = false;


    public var profileImage:Image;
    public var browseB:Button;


    public function AdminSettingsCanvas()
    {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }


    protected function onCreationComplete(event:*):void {
        browseB.addEventListener(MouseEvent.CLICK, browse);
        dispatchEvent(new Event(INIT));
    }

    private function browse(e:Event):void {
        dispatchEvent(new Event(BROWSE));
    }

}
}