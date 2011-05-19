package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.SettingsProxy;
import com.adserversoft.flexfuse.client.model.UploadProxy;
import com.adserversoft.flexfuse.client.model.UserProxy;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.net.FileReference;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.managers.BrowserManager;
import mx.utils.URLUtil;

import org.puremvc.as3.interfaces.INotification;

public class AdminSettingsCanvasMediator extends BaseMediator {
    public static const NAME:String = 'AdminSettingsCanvasMediator';
    private var userProxy:UserProxy;
    private var uploadProxy:UploadProxy;
    private var settingsProxy:SettingsProxy;
    public var isNewLogoUploaded:Boolean = false;


    public function AdminSettingsCanvasMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);


        if (UIComponent(viewComponent).initialized) {
            onInit(null);
        } else {
            UIComponent(viewComponent).addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
        }
    }


    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }


    private function onInit(event:Event):void {
        userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        uploadProxy = facade.retrieveProxy(UploadProxy.NAME) as UploadProxy;
        settingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        userProxy.user = userProxy.authenticatedUser.clone();
        arr1 = new Array("email", "password", "firstName", "lastName", "filename");
        arr2 = new Array(uiComponent.emailTI, uiComponent.passwordTI, uiComponent.firstNameTI, uiComponent.lastNameTI, uiComponent.logoFileTI);
        arr3 = new Array("text", "text", "text", "text", "text");
        uiComponent.passwordTI.addEventListener(FocusEvent.FOCUS_IN, onPasswordChangeBegin);
        uiComponent.passwordTI.addEventListener(FocusEvent.FOCUS_OUT, onPasswordChangeEnd);
        uiComponent.addEventListener(AdminSettingsCanvas.BROWSE, onBrowse);
        bindFields(userProxy.user);
        uiComponent.passwordTI.text = "0123456";
        uiComponent.firstNameTI.setFocus();
        loadPic();
        settingsProxy.loadBalance();
    }

    private function onDestroy(event:Event):void {
        Alert.show("onDestroy");
    }


    private function get uiComponent():AdminSettingsCanvas {
        return viewComponent as AdminSettingsCanvas;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.LOGO_FILE_SELECTED,
            ApplicationConstants.LOGO_FILE_TOO_BIG,
            ApplicationConstants.LOGO_UPLOADED,
            ApplicationConstants.BALANCE_LOADED
        ];
    }

    override public function handleNotification(note:INotification):void {
        var fileRef:FileReference;
        switch (note.getName()) {
            case ApplicationConstants.LOGO_FILE_SELECTED:
                fileRef = note.getBody() as FileReference;
                uiComponent.logoFileTI.text = fileRef.name;
                break;
            case ApplicationConstants.LOGO_FILE_TOO_BIG:
                fileRef = note.getBody() as FileReference;
                Alert.show("Logo file size is too big: " + Math.round((fileRef.size / 1024) * 100) / 100 + " kb");
                break;
            case ApplicationConstants.LOGO_UPLOADED:
                isNewLogoUploaded = true;
                loadPic();
                break;
            case ApplicationConstants.BALANCE_LOADED:
                uiComponent.balanceLbl.text = ApplicationConstants.currencyFormat(note.getBody(), "$");
                break;
        }
    }


    private function loadPic():void {
        if (isNewLogoUploaded) {
            uiComponent.profileImage.source = URLUtil.getFullURL(BrowserManager.getInstance().url,
                    "logo?action=get_logo_from_session&instId=" + settingsProxy.settings.installationId + "&sessionId=" + userProxy.authenticatedUser.sessionId + "&rnd=" + Math.random());
        } else {
            uiComponent.profileImage.source = URLUtil.getFullURL(BrowserManager.getInstance().url,
                    "logo?action=get_logo_from_DB&instId=" + settingsProxy.settings.installationId + "&rnd=" + Math.random());
        }
        uiComponent.profileImage.visible = uiComponent.profileImage.source != null;
    }

    private function onPasswordChangeBegin(event:Event):void {
        if (!uiComponent.passwordReset) {
            uiComponent.passwordTI.text = "";
            uiComponent.passwordReset = true;
        }
    }

    private function onPasswordChangeEnd(event:Event):void {
        if (uiComponent.passwordTI.text == "") {
            uiComponent.passwordTI.text = "0123456";
            uiComponent.passwordReset = false;
        }
    }

    private function onBrowse(event:Event):void {
        uploadProxy.browseLogo(event);
    }
}
}