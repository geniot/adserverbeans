package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.SettingsProxy;
import com.adserversoft.flexfuse.client.model.UserProxy;
import com.adserversoft.flexfuse.client.model.vo.UserVO;
import com.adserversoft.flexfuse.client.view.FlexFuseApplicationMediator;
import com.adserversoft.flexfuse.client.view.titlewindow.EmailReminderTitleWindowMediator;
import com.adserversoft.flexfuse.client.view.titlewindow.EmailReminderTitleWindowUI;
import com.adserversoft.flexfuse.client.view.titlewindow.PasswordReminderTitleWindowMediator;
import com.adserversoft.flexfuse.client.view.titlewindow.PasswordReminderTitleWindowUI;
import com.adserversoft.flexfuse.client.view.titlewindow.ResetPasswordTitleWindowMediator;
import com.adserversoft.flexfuse.client.view.titlewindow.ResetPasswordTitleWindowUI;
import com.adserversoft.flexfuse.client.view.viewstack.MainPanelViewStackMediator;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.net.SharedObject;
import flash.ui.Keyboard;

import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ValidationResultEvent;
import mx.managers.IFocusManager;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class GuestManagementCanvasMediator extends BaseMediator implements IMediator {
    private var userProxy:UserProxy;
    public static const NAME:String = 'GuestManagementCanvasMediator';
    private var invalidField:UIComponent;
    private var focusManager:IFocusManager;
    private var avtoLogin:Boolean = true;

    public function GuestManagementCanvasMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);

        //                uiComponent.addEventListener(BaseCanvas.SHOW, onShow);
        uiComponent.addEventListener(BaseCanvas.INIT, onInit);
        uiComponent.addEventListener(GuestManagementCanvas.LOGIN, onLogin);
        uiComponent.addEventListener(GuestManagementCanvas.REMIND_PASSWORD, onRemindPassword);
        uiComponent.addEventListener(GuestManagementCanvas.REMIND_EMAIL, onRemindEmail);
        //        uiComponent.addEventListener(GuestManagementCanvas.HIDE_PASS_CLICK, onHidePass);
        uiComponent.addEventListener(GuestManagementCanvas.REGISTER_USER, onRegisterUser);
        uiComponent.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;

        onInit(null);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }


    private function get uiComponent():GuestManagementCanvas {
        return viewComponent as GuestManagementCanvas;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.USER_LOGGED_IN,
            ApplicationConstants.USER_LOGGED_OUT,
            ApplicationConstants.TW_REMIND_PASSWORD_CLOSED,
            ApplicationConstants.SERVER_FAULT,
            ApplicationConstants.RESET_PASSWORD_SUCCESS,
            ApplicationConstants.NEW_PASSWORD_SET,
            ApplicationConstants.SETTINGS_LOADED,
            ApplicationConstants.EMAIL_REMINDED

        ];
    }

    override public function handleNotification(note:INotification):void {
        ApplicationConstants.application.enabled = true;
        uiComponent.enabled = true;
        var mpvs:MainPanelViewStackMediator = retrieveMediator(FlexFuseApplicationMediator.NAME, MainPanelViewStackMediator.NAME) as MainPanelViewStackMediator;
        switch (note.getName()) {
            case ApplicationConstants.SETTINGS_LOADED:
                uiComponent.email.setFocus();
                if (avtoLogin && !userProxy.user.passwordReset) {
                    var res:String = onLogin(null);
                    if (res == ValidationResultEvent.INVALID) {
                        mpvs.uiComponent.selectedChild = mpvs.uiComponent.loginCanvas;
                    }
                } else {
                    mpvs.uiComponent.selectedChild = mpvs.uiComponent.loginCanvas;
                }
                break;
            case ApplicationConstants.USER_LOGGED_IN:
                //                PopManager.closePopUpWindow(ResetPasswordTitleWindow, ResetPasswordT.itleWindowMediator.NAME);
                //                  Alert.show("Attempt to log");
                //                PopManager.closePopUpWindow(guestManagementCanvas, NAME);
                break;
            case ApplicationConstants.USER_LOGGED_OUT:
                onLogOut(null);
                break;
            case ApplicationConstants.TW_REMIND_PASSWORD_CLOSED:
                uiComponent.email.setFocus();
                break;
            case ApplicationConstants.SERVER_FAULT:
                uiComponent.enabled = true;
                break;
            case ApplicationConstants.RESET_PASSWORD_SUCCESS:
                var mode:String = ApplicationConstants.CREATE;
                var mediatorName:String = mode + "::" + ResetPasswordTitleWindowMediator.NAME;
                if (!facade.hasMediator(mediatorName)) {
                    var window:IFlexDisplayObject = PopManager.openPopUpWindow(ResetPasswordTitleWindowUI, mode);
                    var mediator:IMediator = new ResetPasswordTitleWindowMediator(mediatorName, window);
                    facade.registerMediator(mediator);
                }
                break;
            case ApplicationConstants.NEW_PASSWORD_SET:
                Alert.show("Your password has been reset");
                break;
            case ApplicationConstants.EMAIL_REMINDED:
                Alert.show("Your email address is: " + userProxy.authenticatedUser.email);
                break;
        }
    }

    /* public function onHidePass(event:Event):void {

     if (uiComponent.hidePass.selected == true) {
     uiComponent.password.displayAsPassword = true;
     }
     else {
     uiComponent.password.displayAsPassword = false;
     }
     }*/

    public function onKeyDown(e:KeyboardEvent):void {
        if (e.keyCode == Keyboard.ENTER) {
            onLogin(e);
        }
    }

    public function onRegisterUser(event:Event):void {
        var aUserProxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        aUserProxy.user = new UserVO();
        //        var acampaignProxy:CampaignProxy = facade.retrieveProxy(CampaignProxy.NAME) as CampaignProxy;
        //        acampaignProxy.campaign = new CampaignVO();
        //        PopManager.openPopUpWindow(CampaignTitleWindowUI, CampaignTitleWindowMediator, ApplicationConstants.CREATE);
    }

    private function onFailure(event:Event):void {
        uiComponent.enabled = true;
    }


    private function onRemindPassword(event:Event):void {
        var mode:String = ApplicationConstants.CREATE;
        var mediatorName:String = mode + "::" + PasswordReminderTitleWindowMediator.NAME;
        if (!facade.hasMediator(mediatorName)) {
            var window:IFlexDisplayObject = PopManager.openPopUpWindow(PasswordReminderTitleWindowUI, mode);
            var mediator:IMediator = new PasswordReminderTitleWindowMediator(mediatorName, window);
            facade.registerMediator(mediator);
        }
    }

    private function onRemindEmail(event:Event):void {
        var mode:String = ApplicationConstants.CREATE;
        var mediatorName:String = mode + "::" + EmailReminderTitleWindowMediator.NAME;
        if (!facade.hasMediator(mediatorName)) {
            var window:IFlexDisplayObject = PopManager.openPopUpWindow(EmailReminderTitleWindowUI, mode);
            var mediator:IMediator = new EmailReminderTitleWindowMediator(mediatorName, window);
            facade.registerMediator(mediator);
        }
    }

    public function onLogin(event:Event):String {
        var validationResult:String = validate();
        if (validationResult == ValidationResultEvent.INVALID) return ValidationResultEvent.INVALID;

        var loginSO:SharedObject = SharedObject.getLocal("login");
        if (uiComponent.rememberMe.selected == false) {
            loginSO.data.email = uiComponent.email.text;
            loginSO.data.password = uiComponent.password.text;
            loginSO.flush();
        } else {
            //            loginSO.clear();
            loginSO.data..email = "";
            loginSO.data..password = "";
            loginSO.flush();
        }
        var user:UserVO = uiComponent.user;
        ApplicationConstants.application.enabled = false;
        uiComponent.enabled = false;
        userProxy.login(user);
        return ValidationResultEvent.VALID;
    }

    protected function updateLoginFields():void {
        var loginSO:SharedObject = SharedObject.getLocal("login");
        if (loginSO.size != 0) {
            uiComponent.email.text = loginSO.data.email;
            uiComponent.password.text = loginSO.data.password;
            if (uiComponent.email.text == "") {
                uiComponent.rememberMe.selected = true;
                avtoLogin = false;
            } else {
                uiComponent.rememberMe.selected = false;
                avtoLogin = true;
            }
        } else {
            uiComponent.email.text = "";
            uiComponent.password.text = "";
            uiComponent.rememberMe.selected = false;
            avtoLogin = false;
        }
    }

    private function onLogOut(event:Event):void {
        // uiComponent.visible = false;
        updateLoginFields();
        uiComponent.email.setFocus();
    }

    //    private function onShow(event:Event):void {
    //        organizeTabOrder();
    //        this.updateLoginFields();
    ////        uicomponent.defaultButton = uicomponent.loginBtn;
    //        uicomponent.username.setFocus();
    //
    //        //todo replace following.
    //        uicomponent.displayArea.visible = true;
    //    }

    private function onInit(event:Event):void {
        //
        organizeTabOrder();
        this.updateLoginFields();
        //                uicomponent.defaultButton = uicomponent.loginBtn;
        uiComponent.email.setFocus();

        var facade:ApplicationFacade = ApplicationFacade.getInstance();
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        uiComponent.instId = settingsProxy.settings.installationId;
        //        uiComponent.greetingLabel.source = "images/" + uiComponent.instId + "/greetingLabel.gif"
        //        uiComponent.introLabel.source = "images/" + uiComponent.instId + "/introLabel.gif"
        //        uiComponent.loginLabel.source = "images/" + uiComponent.instId + "/loginFrameLabel.gif"
        //        uiComponent.startButton.source = "images/" + uiComponent.instId + "/startButtonImage.gif"


        //todo replace following.
        //        uiComponent.displayArea.visible = true;
    }

    public function organizeTabOrder():void {
        uiComponent.email.tabIndex = 1;
        uiComponent.password.tabIndex = 2;
        uiComponent.rememberMe.tabIndex = 3;
        //       uiComponent.passwordReminderBtn.tabIndex = 4;
        uiComponent.loginBtn.tabIndex = 5;
    }


    public function onAlertClose(event:CloseEvent):void {
        if (invalidField != null)invalidField.setFocus();
    }


    public function validate():String {
        var result:ValidationResultEvent = uiComponent.emailValidator.validate();
        if (result.type == ValidationResultEvent.INVALID) {
            Alert.show(result.message, "Invalid", Alert.OK, uiComponent, onAlertClose);
            invalidField = uiComponent.email;
            return ValidationResultEvent.INVALID;
        }

        if (result.type == ValidationResultEvent.VALID)result = uiComponent.passwordStringValidator.validate();
        if (result.type == ValidationResultEvent.INVALID) {
            Alert.show(result.message, "Invalid", Alert.OK, uiComponent, onAlertClose);
            invalidField = uiComponent.password;
            return ValidationResultEvent.INVALID;
        }
        return ValidationResultEvent.VALID;
    }


}
}
