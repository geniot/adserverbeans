package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.UploadProxy;
import com.adserversoft.flexfuse.client.model.UserProxy;
import com.adserversoft.flexfuse.client.view.canvas.AdminSettingsCanvasMediator;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.net.SharedObject;
import flash.utils.Timer;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class SettingsTitleWindowMediator extends BaseMediator implements IMediator {
    public static const NAME:String = 'SettingsTitleWindowMediator';
    private var userProxy:UserProxy;
    private var uploadProxy:UploadProxy;

    function SettingsTitleWindowMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);

        if (UIComponent(viewComponent).initialized) {
            onInit(null);
        } else {
            UIComponent(viewComponent).addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
        }
    }

    private function onInit(event:Event):void {

        userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        uploadProxy = facade.retrieveProxy(UploadProxy.NAME) as UploadProxy;
        registerMediators();
        addEventListeners();
    }

    private function registerMediators():void {
        registerMediator(NAME, AdminSettingsCanvasMediator, AdminSettingsCanvasMediator.NAME, uiComponent.adminSettingsCanvas);
        //        registerMediator(NAME, AdminEmailSettingsCanvasMediator, AdminEmailSettingsCanvasMediator.NAME, uiComponent.adminEmailSettingsCanvas);
    }

     override public function unregisterMediators():void {
        unregisterMediator(NAME, AdminSettingsCanvasMediator);
        //        unregisterMediator(NAME, AdminEmailSettingsCanvasMediator);
    }

    public override function addEventListeners():void {
        uiComponent.addEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.addEventListener(BaseTitleWindow.CANCEL, onClose);
        uiComponent.addEventListener(BaseTitleWindow.SAVE, onSave);
        uiComponent.addEventListener(KeyboardEvent.KEY_UP, uiComponent.keyup);
    }

    public override function removeEventListeners():void {
        uiComponent.removeEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.removeEventListener(BaseTitleWindow.CANCEL, onClose);
        uiComponent.removeEventListener(BaseTitleWindow.SAVE, onSave);
        uiComponent.removeEventListener(KeyboardEvent.KEY_UP, uiComponent.keyup);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():SettingsTitleWindow {
        return viewComponent as SettingsTitleWindow;
    }


    private function onClose(event:Event):void {
        userProxy.authenticatedUser.filename = userProxy.user.filename;
        removeEventListeners();
        unregisterMediators();
        PopManager.closePopUpWindow(uiComponent, getMediatorName());
    }

    private function validation():Boolean {
        var result:ValidationResultEvent = uiComponent.adminSettingsCanvas.emailStringValidator.validate();
        if (result.type == ValidationResultEvent.INVALID) {
            removeEventListeners();
            uiComponent.tabNavigator.selectedChild = uiComponent.adminSettingsCanvas;
            uiComponent.invalidField = uiComponent.adminSettingsCanvas.emailTI;
            Alert.show("Email is required.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            return false;
        }
        result = uiComponent.adminSettingsCanvas.passwordStringValidator.validate();
        if (result.type == ValidationResultEvent.INVALID) {
            removeEventListeners();
            uiComponent.tabNavigator.selectedChild = uiComponent.adminSettingsCanvas;
            uiComponent.invalidField = uiComponent.adminSettingsCanvas.passwordTI;
            Alert.show("Your password must be at least 5 characters long", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            return false;
        }
        result = uiComponent.adminSettingsCanvas.firstNameStringValidator.validate();
        if (result.type == ValidationResultEvent.INVALID) {
            removeEventListeners();
            uiComponent.tabNavigator.selectedChild = uiComponent.adminSettingsCanvas;
            uiComponent.invalidField = uiComponent.adminSettingsCanvas.firstNameTI;
            Alert.show("First name required", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            return false;
        }

        result = uiComponent.adminSettingsCanvas.lastNameStringValidator.validate();
        if (result.type == ValidationResultEvent.INVALID) {
            removeEventListeners();
            uiComponent.tabNavigator.selectedChild = uiComponent.adminSettingsCanvas;
            uiComponent.invalidField = uiComponent.adminSettingsCanvas.lastNameTI;
            Alert.show("Last name required", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            return false;
        }
        //        //email settings validation
        //        result = uiComponent.adminEmailSettingsCanvas.emailSubjectStringValidator.validate();
        //        if (result.type == ValidationResultEvent.INVALID) {
        //            removeEventListeners();
        //            uiComponent.tabNavigator.selectedChild = uiComponent.adminEmailSettingsCanvas;
        //            uiComponent.invalidField = uiComponent.adminEmailSettingsCanvas.emailSubjectTI;
        //            Alert.show("Email subject required", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
        //            return false;
        //        }
        //
        //        result = uiComponent.adminEmailSettingsCanvas.userNameStringValidator.validate();
        //        if (result.type == ValidationResultEvent.INVALID) {
        //            removeEventListeners();
        //            uiComponent.tabNavigator.selectedChild = uiComponent.adminEmailSettingsCanvas;
        //            uiComponent.invalidField = uiComponent.adminEmailSettingsCanvas.userNameTI;
        //            Alert.show("User name required", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
        //            return false;
        //        }
        //
        //        result = uiComponent.adminEmailSettingsCanvas.passwordStringValidator.validate();
        //        if (result.type == ValidationResultEvent.INVALID) {
        //            removeEventListeners();
        //            uiComponent.tabNavigator.selectedChild = uiComponent.adminEmailSettingsCanvas;
        //            uiComponent.invalidField = uiComponent.adminEmailSettingsCanvas.passwordTI;
        //            Alert.show("Password required", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
        //            return false;
        //        }
        //
        //        if (!uiComponent.adminEmailSettingsCanvas.portValidation()) {
        //            removeEventListeners();
        //            uiComponent.tabNavigator.selectedChild = uiComponent.adminEmailSettingsCanvas;
        //            uiComponent.invalidField = uiComponent.adminEmailSettingsCanvas.smtpServerPortTI;
        //            Alert.show("Port number invalid", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
        //            return false;
        //        }
        //        result = uiComponent.adminEmailSettingsCanvas.serverNameStringValidator.validate();
        //        if (result.type == ValidationResultEvent.INVALID) {
        //            removeEventListeners();
        //            uiComponent.tabNavigator.selectedChild = uiComponent.adminEmailSettingsCanvas;
        //            uiComponent.invalidField = uiComponent.adminEmailSettingsCanvas.smtpServerTI;
        //            Alert.show("Server smtp required", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
        //            return false;
        //        }
        //
        //        result = uiComponent.adminEmailSettingsCanvas.fromEmailStringValidator.validate();
        //        if (result.type == ValidationResultEvent.INVALID) {
        //            removeEventListeners();
        //            uiComponent.tabNavigator.selectedChild = uiComponent.adminEmailSettingsCanvas;
        //            uiComponent.invalidField = uiComponent.adminEmailSettingsCanvas.fromEmailTI;
        //            Alert.show("From e-mail required", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
        //            return false;
        //        }
        //
        //        result = uiComponent.adminEmailSettingsCanvas.supportEmailStringValidator.validate();
        //        if (result.type == ValidationResultEvent.INVALID) {
        //            removeEventListeners();
        //            uiComponent.tabNavigator.selectedChild = uiComponent.adminEmailSettingsCanvas;
        //            uiComponent.invalidField = uiComponent.adminEmailSettingsCanvas.supportEmailTI;
        //            Alert.show("Support e-mail required", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
        //            return false;
        //        }


        return true;
    }

    public function onAlertClose(event:CloseEvent):void {
        var minuteTimer:Timer = new Timer(300, 1);
        minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
        minuteTimer.start();
        uiComponent.invalidField.setFocus();
    }

    public function onTimerComplete(event:TimerEvent):void {
        addEventListeners();
    }


    private function onSave(event:Event):void {

        if (validation()) {
            PopManager.setEnabledStateToPopUp(false, SettingsTitleWindowMediator);
            userProxy.authenticatedUser.email = userProxy.user.email;
            userProxy.authenticatedUser.firstName = userProxy.user.firstName;
            userProxy.authenticatedUser.lastName = userProxy.user.lastName;
            userProxy.authenticatedUser.smtpSubject = userProxy.user.smtpSubject;
            userProxy.authenticatedUser.smtpPassword = userProxy.user.smtpPassword;
            userProxy.authenticatedUser.smtpServer = userProxy.user.smtpServer;
            userProxy.authenticatedUser.smtpUser = userProxy.user.smtpUser;
            userProxy.authenticatedUser.fromEmail = userProxy.user.fromEmail;
            userProxy.authenticatedUser.port = userProxy.user.port;
            userProxy.authenticatedUser.supportEmail = userProxy.user.supportEmail;


            if (uiComponent.adminSettingsCanvas.passwordReset) {
                userProxy.authenticatedUser.passwordReset = true;
                userProxy.authenticatedUser.password = userProxy.user.password;
                var loginSO:SharedObject = SharedObject.getLocal("login");
                if (loginSO.data.password != "") {
                    loginSO.data.NewPassword = userProxy.authenticatedUser.password;
                    loginSO.flush();
                }
            }
            var ascm:AdminSettingsCanvasMediator = retrieveMediator(NAME, AdminSettingsCanvasMediator.NAME) as AdminSettingsCanvasMediator;
            userProxy.authenticatedUser.filename = userProxy.user.filename;
            userProxy.updateSettings(ascm.isNewLogoUploaded);
        }
    }


    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.SETTINGS_UPDATED,
            ApplicationConstants.LOGO_FILE_SELECTED,
            ApplicationConstants.LOGO_UPLOADED,
            ApplicationConstants.SERVER_FAULT

        ];
    }


    override public function handleNotification(note:INotification):void {
        PopManager.setEnabledStateToPopUp(true, SettingsTitleWindowMediator);
        switch (note.getName()) {
            case ApplicationConstants.SETTINGS_UPDATED:
                var loginSO:SharedObject = SharedObject.getLocal("login");
                if (loginSO.data.NewPassword != null) {
                    loginSO.data.password = loginSO.data.NewPassword;
                    loginSO.data.NewPassword=null;
                    loginSO.flush();
                }
                onClose(null);
                break;
            case ApplicationConstants.LOGO_FILE_SELECTED:
                uiComponent.enabled = false;
                break;
            case ApplicationConstants.LOGO_UPLOADED:
            case ApplicationConstants.SERVER_FAULT:
                uiComponent.enabled = true;
                break;
        }
    }

}
}
