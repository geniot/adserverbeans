package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.UserProxy;

import flash.events.Event;
import flash.events.KeyboardEvent;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class PasswordReminderTitleWindowMediator extends BaseMediator implements IMediator {
    private var userProxy:UserProxy;
    public static const NAME:String = 'PasswordReminderTitleWindowMediator';
    private var invalidField:UIComponent;

    public function PasswordReminderTitleWindowMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);


        if (UIComponent(viewComponent).initialized) {
            onInit(null);
        } else {
            UIComponent(viewComponent).addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
        }
    }

    public function onKeyboardPress(e:KeyboardEvent):void {
        const KEYCODE_ESCAPE:int = 27;
        if (e.keyCode == KEYCODE_ESCAPE) {
            onClose(null);
        }
    }


    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():PasswordReminderTitleWindow {
        return viewComponent as PasswordReminderTitleWindow;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.TW_RESET_PASSWORD_CLOSED,
            ApplicationConstants.USER_PASSWORD_RESET_SENT,
            ApplicationConstants.EMAIL_REMINDED,
            ApplicationConstants.SERVER_FAULT
        ];
    }

    override public function handleNotification(note:INotification):void {
        uiComponent.enabled = true;
        switch (note.getName()) {

            case ApplicationConstants.TW_RESET_PASSWORD_CLOSED:
                uiComponent.enabled = true;
                uiComponent.email.setFocus();
                break;
            case ApplicationConstants.SERVER_FAULT:
                uiComponent.enabled = true;
                break;
            case ApplicationConstants.USER_PASSWORD_RESET_SENT:
                onClose(null);
                Alert.show("Reset code has been sent to your email address.");
                break;
            case ApplicationConstants.EMAIL_REMINDED:
                onClose(null);
                Alert.show("Username has been sent to your e-mail");
                break;
        }
    }

    private function onFailure(event:Event):void {
        uiComponent.enabled = true;
    }

    private function onClose(event:Event):void {
        PopManager.closePopUpWindow(uiComponent, getMediatorName());
        facade.sendNotification(ApplicationConstants.TW_REMIND_PASSWORD_CLOSED);
    }

    private function onRemindPassword(event:Event):void {
        //        if (validateEmailtoPassword() != ValidationResultEvent.VALID)return;
        uiComponent.enabled = false;
        if (uiComponent.validateForRemind() != ValidationResultEvent.VALID) {
            uiComponent.enabled = true;
            return;
        }
        userProxy.remindPassword(uiComponent.email.text);
    }


    private function onInit(event:Event):void {
        uiComponent.addEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.addEventListener(PasswordReminderTitleWindow.REMIND_PASSWORD, onRemindPassword);
        uiComponent.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardPress);

        userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;

        uiComponent.defaultButton = uiComponent.remindPasswordBtn;
        uiComponent.email.setFocus();
    }


    //    public function validateEmailtoPassword():String {
    //        var result:ValidationResultEvent = uiComponent.emailValidator1.validate();
    //        if (result.type == ValidationResultEvent.INVALID) {
    //            Alert.show(result.message, "Invalid", Alert.OK, uiComponent, onAlertClose);
    //            invalidField = uiComponent.email;
    //            return ValidationResultEvent.INVALID;
    //        }
    //        return ValidationResultEvent.VALID;
    //    }
    //
    //    public function validateEmailtoUsername():String {
    //        var result:ValidationResultEvent = uiComponent.emailValidator2.validate();
    //        if (result.type == ValidationResultEvent.INVALID) {
    //            Alert.show(result.message, "Invalid", Alert.OK, uiComponent, onAlertClose);
    //            invalidField = uiComponent.email;
    //            return ValidationResultEvent.INVALID;
    //        }
    //        return ValidationResultEvent.VALID;
    //    }


    private function onAlertClose(event:CloseEvent):void {
        invalidField.setFocus();
    }

}


}