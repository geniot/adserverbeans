package com.adserversoft.flexfuse.client.model {
import com.adserversoft.flexfuse.client.model.vo.ServerRequestVO;
import com.adserversoft.flexfuse.client.model.vo.UserVO;

import flash.display.Sprite;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.Operation;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.IProxy;
import org.puremvc.as3.patterns.proxy.Proxy;

public class UserProxy extends Proxy implements IProxy {
    public static const NAME:String = 'UserProxy';

    private var userRO:RemoteObject;
    //user that is created or edited
    private var _user:UserVO = new UserVO;
    //user that is logged in or authenticated with a session id
    private var _authenticatedUser:UserVO = new UserVO;
    private var _selectedUser:UserVO = new UserVO;
    private var _usersList:ArrayCollection = new ArrayCollection();
    public var reloginNeended:Boolean = false;

    public function UserProxy() {
        super(NAME, new ArrayCollection);
        userRO = new RemoteObject();
        userRO.destination = "user";
        userRO.requestTimeout = ApplicationConstants.REQUEST_TIMEOUT_SECONDS;


        userRO.loginUser.addEventListener("result", loginResultHandler);
        userRO.loginUser.addEventListener("fault", faultHandler);

        userRO.logoutUser.addEventListener("result", logoutResultHandler);
        userRO.logoutUser.addEventListener("fault", faultHandler);

        userRO.remindPassword.addEventListener("result", remindPasswordResultHandler);
        userRO.remindPassword.addEventListener("fault", faultHandler);

        userRO.resetPassword.addEventListener("result", resetPasswordResultHandler);
        userRO.resetPassword.addEventListener("fault", faultHandler);

        userRO.verifyRemindPassword.addEventListener("result", verifyPasswordResultHandler);
        userRO.verifyRemindPassword.addEventListener("fault", faultHandler);

        userRO.remindEmail.addEventListener("result", remindEmailHandler);
        userRO.remindEmail.addEventListener("fault", faultHandler);

        userRO.updateSettings.addEventListener("result", updateSettingsHandler);
        userRO.updateSettings.addEventListener("fault", faultHandler);
    }


    private function loginResultHandler(event:*):void {
        if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.USER_LOGIN_FAILED, event.result);
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            var re:ResultEvent = event as ResultEvent;
            authenticatedUser = re.result.resultingObject as UserVO;
            if (reloginNeended) {
                sendNotification(ApplicationConstants.RELOGIN);
                reloginNeended = false;
            } else {
                sendNotification(ApplicationConstants.USER_LOGGED_IN);
            }
        }
    }

    private function updateSettingsHandler(event:*):void {
        if (event.result.result == ApplicationConstants.SUCCESS) {
            sendNotification(ApplicationConstants.SETTINGS_UPDATED);
        } else if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        }
    }


    private function logoutResultHandler(event:*):void {
        if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.USER_LOGOUT_FAILED, event.result);
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            authenticatedUser.reset();
            var bannerProxy:BannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
            var adPlaceProxy:AdPlaceProxy = facade.retrieveProxy(AdPlaceProxy.NAME) as AdPlaceProxy;
            bannerProxy.banners.clear();
            bannerProxy.dynamicParameters.clear();
            bannerProxy.urlPatterns.clear();
            bannerProxy.referrerPatterns.clear();
            bannerProxy.ipPatterns.clear();
            adPlaceProxy.adPlaces.clear();
            sendNotification(ApplicationConstants.USER_LOGGED_OUT);
        }
    }

    private function remindPasswordResultHandler(event:*):void {
        if (event.result.result == ApplicationConstants.FAILURE) {
            //           Alert.show(event.result.result,event.result, Alert.OK, Application.application as Sprite);
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            sendNotification(ApplicationConstants.USER_PASSWORD_RESET_SENT);
        }
    }

    private function resetPasswordResultHandler(event:*):void {
        if (event.result.result == ApplicationConstants.FAILURE) {
            //             Alert.show(event.result.result,event.result, Alert.OK, Application.application as Sprite);
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);

        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            //            authenticatedUser = (ResultEvent)(event).result.resultingObject as UserVO;
            //            authenticatedUser.isLoggedIn = true;
            //            sendNotification(ApplicationConstants.USER_LOGGED_IN);
            sendNotification(ApplicationConstants.NEW_PASSWORD_SET);
        }
    }

    private function verifyPasswordResultHandler(event:*):void {
        ApplicationConstants.application.enabled = true;
        if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.RESET_PASSWORD_SUCCESS) {
            var re:ResultEvent = event as ResultEvent;
            authenticatedUser = re.result.resultingObject as UserVO;
            sendNotification(ApplicationConstants.RESET_PASSWORD_SUCCESS);
        } else if (event.result.result == ApplicationConstants.RESET_CODE_OUTDATED) {
            Alert.show(event.result.message, "Alert", Alert.OK, ApplicationConstants.application as Sprite);
        } else if (event.result.result == ApplicationConstants.RESET_CODE_NOT_CORRECT) {
            Alert.show(event.result.message, "Alert", Alert.OK, ApplicationConstants.application as Sprite);
        }
    }

    private function remindEmailHandler(event:*):void {
        if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            var re:ResultEvent = event as ResultEvent;
            authenticatedUser = re.result.resultingObject as UserVO;
            sendNotification(ApplicationConstants.EMAIL_REMINDED);
        }
    }

    private function faultHandler(event:FaultEvent):void {
        sendNotification(ApplicationConstants.SERVER_FAULT, event);
    }

    public function get user():UserVO {
        return _user;
    }

    public function set user(u:UserVO):void {
        this._user = u;
    }

    public function get authenticatedUser():UserVO {
        return _authenticatedUser;
    }

    public function set authenticatedUser(u:UserVO):void {
        this._authenticatedUser = u;
    }

    public function get usersList():ArrayCollection {
        return _usersList;
    }

    public function set usersList(ac:ArrayCollection):void {
        this._usersList = ac;
    }


    public function login(item:Object):void {
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var sr:ServerRequestVO = new ServerRequestVO(authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(userRO.loginUser).arguments = new Array(sr, item);
        userRO.loginUser(sr, item);
    }

    public function logout():void {
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var sr:ServerRequestVO = new ServerRequestVO(authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(userRO.logoutUser).arguments = new Array(sr, authenticatedUser);
        userRO.logoutUser(sr, authenticatedUser);
    }

    public function remindPassword(email:String):void {
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var sr:ServerRequestVO = new ServerRequestVO(authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(userRO.remindPassword).arguments = new Array(sr, email);
        userRO.remindPassword(sr, email);
    }


    public function resetPassword(newPassword:String):void {
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var sr:ServerRequestVO = new ServerRequestVO(authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(userRO.resetPassword).arguments = new Array(sr, authenticatedUser.email, newPassword);
        userRO.resetPassword(sr, authenticatedUser.email, newPassword);
    }

    public function verifyRemindPassword(resetPassword:String, userId:int):void {
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var sr:ServerRequestVO = new ServerRequestVO(authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(userRO.verifyRemindPassword).arguments = new Array(sr, resetPassword, userId);
        userRO.verifyRemindPassword(sr, resetPassword, userId);
    }

    public function updateSettings(isNewLogo:Boolean):void {
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var sr:ServerRequestVO = new ServerRequestVO(authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(userRO.updateSettings).arguments = new Array(sr, authenticatedUser, isNewLogo);
        userRO.updateSettings(sr, authenticatedUser, isNewLogo);
    }

    public function remindEmail(firstName:String, lastName:String):void {
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var sr:ServerRequestVO = new ServerRequestVO(authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(userRO.remindEmail).arguments = new Array(sr, firstName, lastName);
        userRO.remindEmail(sr, firstName, lastName);
    }

}
}
