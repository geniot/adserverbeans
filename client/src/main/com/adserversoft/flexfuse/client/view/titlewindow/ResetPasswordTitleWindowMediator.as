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
import mx.validators.Validator;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class ResetPasswordTitleWindowMediator extends BaseMediator implements IMediator {
    private var userProxy:UserProxy;
    public static const NAME:String = 'ResetPasswordTitleWindowMediator';
    private var invalidField:UIComponent;

    public function ResetPasswordTitleWindowMediator(u:String, viewComponent:Object) {
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

    private function get uiComponent():ResetPasswordTitleWindow {
        return viewComponent as ResetPasswordTitleWindow;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.SERVER_FAULT,
            ApplicationConstants.USER_LOGGED_IN,
            ApplicationConstants.NEW_PASSWORD_SET
        ];
    }

    override public function handleNotification(note:INotification):void {
        switch (note.getName()) {
            case ApplicationConstants.SERVER_FAULT:
                uiComponent.enabled = true;
                break;
            case ApplicationConstants.USER_LOGGED_IN:
                onClose(null);
                break;
            case ApplicationConstants.NEW_PASSWORD_SET:
                onClose(null);
                break;
        }
    }

    private function onFailure(event:Event):void {
        uiComponent.enabled = true;
    }

    private function onClose(event:Event):void {
        PopManager.closePopUpWindow(uiComponent, getMediatorName());
        facade.sendNotification(ApplicationConstants.TW_RESET_PASSWORD_CLOSED);
    }

    private function onSave(event:Event):void {
        if (validate() != ValidationResultEvent.VALID) {
            return;
        }
        uiComponent.enabled = false;
        userProxy.resetPassword(uiComponent.password.text);
    }


    private function onInit(event:Event):void {
        uiComponent.addEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.addEventListener(BaseTitleWindow.SAVE, onSave);
        uiComponent.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardPress);

        userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;

        uiComponent.defaultButton = uiComponent.saveBtn;
        uiComponent.password.setFocus();
    }


    public function validate():String {
        if (validateField(uiComponent.passwordStringValidator, uiComponent.password) == ValidationResultEvent.INVALID)return ValidationResultEvent.INVALID;
        //        if (validateField(uiComponent.confirmPasswordStringValidator, uiComponent.confirmPassword) == ValidationResultEvent.INVALID)return ValidationResultEvent.INVALID;
        //        if (uiComponent.password.text != uiComponent.confirmPassword.text) {
        //            Alert.show("Password does not match the confirmed password", "Invalid", Alert.OK, uiComponent, onAlertClose);
        //            invalidField = uiComponent.confirmPassword;
        //            return ValidationResultEvent.INVALID;
        //        }
        return ValidationResultEvent.VALID;
    }

    protected function validateField(v:Validator, f:UIComponent):String {
        var result:ValidationResultEvent = v.validate();
        if (result.type == ValidationResultEvent.INVALID) {
            Alert.show(result.message, "Invalid", Alert.OK, uiComponent, onAlertClose);
            invalidField = f;
        }
        return result.type;
    }

    private function onAlertClose(event:CloseEvent):void {
        invalidField.setFocus();
    }

}
}


