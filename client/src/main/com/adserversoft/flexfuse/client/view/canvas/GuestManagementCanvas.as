package com.adserversoft.flexfuse.client.view.canvas
{
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.vo.UserVO;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import mx.binding.utils.BindingUtils;
import mx.containers.Form;
import mx.containers.Panel;
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.Image;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.events.FlexEvent;
import mx.validators.EmailValidator;
import mx.validators.StringValidator;

public class GuestManagementCanvas extends BaseCanvas
{

    public static const LOGIN:String = "LOGIN";
    public static const REMIND_PASSWORD:String = "REMIND_PASSWORD";
    public static const REMIND_EMAIL:String = "REMIND_EMAIL";
    public static const REGISTER_USER:String = "REGISTER_USER";
    public static const REMEMBER_ME:String = "REMEMBER_ME";

    public var passwordStringValidator:StringValidator;
    public var emailValidator:EmailValidator;

    [Bindable]
    public var email:TextInput;
    [Bindable]
    public var password:TextInput;
    public var rememberMe:CheckBox;
    public var loginBtn:Button;
    public var registerBtn:Button;
    public var cancelBtn:Button;
    [Bindable]
    public var user:UserVO = new UserVO();
    [Bindable]
    public var instId:int;

    public var greetingLabel:Image;
    public var introLabel:Image;
    public var loginLabel:Image;
    public var startButton:Image;
    public var signUp:Label;
    public var forgot:Label;

    public var loginP:Panel;


    public var userDataForm:Form;

    public function GuestManagementCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }


    protected function onCreationComplete(event:Event):void {
        if(mode==ApplicationConstants.RELOGIN) {
            loginBtn.height=0;
            loginBtn.visible=false;
        }
        rememberMe.addEventListener(MouseEvent.CLICK, rememberMeClick);
        loginBtn.addEventListener(MouseEvent.CLICK, login);
        BindingUtils.bindProperty(email, "text", user, "email");
        BindingUtils.bindProperty(user, "email", email, "text");
        BindingUtils.bindProperty(password, "text", user, "password");
        BindingUtils.bindProperty(user, "password", password, "text");
        dispatchEvent(new Event(INIT));
        addEventListener(FlexEvent.SHOW, onShow);
    }

    private function login(event:Event):void {
        dispatchEvent(new Event(LOGIN));

    }


    private function remindPassword(event:Event):void {
        dispatchEvent(new Event(REMIND_PASSWORD));
    }

    private function remindEmail(event:Event):void {
        dispatchEvent(new Event(REMIND_EMAIL));
    }

    private function rememberMeClick(event:Event):void {
        dispatchEvent(new Event(REMEMBER_ME));
    }


    private function register(event:Event):void {
        dispatchEvent(new Event(REGISTER_USER));
    }

    public function signUp_initialize():void {
        signUp.htmlText = "Don't have an account? <u><a href='event:signUp'>Sign up</a></u>. ";
    }

    public function signUp_link(evt:TextEvent):void {
        var urlRequest:URLRequest = new URLRequest("http://www.openadstore.com");
        navigateToURL(urlRequest, "_blank");
    }

    public function forgot_initialize():void {
        forgot.htmlText = "Forgot your <u><a href='event:email'>email</a></u> or <u><a href='event:pass'>password</a></u>? ";
    }

    public function forgot_link(evt:TextEvent):void {

        switch (evt.text) {
            case "email":
                remindEmail(evt);
                break;
            case "pass":
                remindPassword(evt);
                break;
        }

    }

    protected function onShow(event:Event):void {
        dispatchEvent(new Event(SHOW));
    }
}
}
