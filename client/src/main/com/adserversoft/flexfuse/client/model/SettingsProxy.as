package com.adserversoft.flexfuse.client.model {
import com.adserversoft.flexfuse.client.model.vo.AdPlaceVO;
import com.adserversoft.flexfuse.client.model.vo.HashMap;
import com.adserversoft.flexfuse.client.model.vo.HashMapEntry;
import com.adserversoft.flexfuse.client.model.vo.ServerRequestVO;
import com.adserversoft.flexfuse.client.model.vo.SettingsVO;

import flash.net.SharedObject;

import flash.net.URLRequest;
import flash.net.navigateToURL;

import mx.collections.ArrayCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.Operation;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.IProxy;
import org.puremvc.as3.patterns.proxy.Proxy;

public class SettingsProxy extends Proxy implements IProxy {
    public static const NAME:String = 'SettingsProxy';

    private var settingsRO:RemoteObject;
    private var createDbRO:RemoteObject;
    private var _settings:SettingsVO = new SettingsVO;


    public function SettingsProxy() {
        super(NAME, new ArrayCollection);
        settingsRO = new RemoteObject();
        settingsRO.destination = "settings";
        settingsRO.requestTimeout = ApplicationConstants.REQUEST_TIMEOUT_SECONDS;

        createDbRO = new RemoteObject();
        createDbRO.destination = "settings";
        createDbRO.requestTimeout = 600;

        settingsRO.getSettings.addEventListener("result", getSettingsResultHandler);
        settingsRO.getSettings.addEventListener("fault", faultHandler);

        settingsRO.getBalance.addEventListener("result", getBalanceResultHandler);
        settingsRO.getBalance.addEventListener("fault", faultHandler);

        createDbRO.createDb.addEventListener("result", getCreateDbResultHandler);
        createDbRO.createDb.addEventListener("fault", faultHandler);

    }


    public function loadSettings():void {
        var userProxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        var settingsSO:SharedObject = SharedObject.getLocal("settings");
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var sr:ServerRequestVO = new ServerRequestVO(userProxy.authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(settingsRO.getSettings).arguments = new Array(sr, "en");
        settingsRO.getSettings(sr, "en");
    }

    public function loadBalance():void {
        var userProxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        var settingsSO:SharedObject = SharedObject.getLocal("settings");
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var sr:ServerRequestVO = new ServerRequestVO(userProxy.authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(settingsRO.getSettings).arguments = new Array(sr, "en");
        settingsRO.getBalance(sr, "en");
    }

    public function createDb(dbCount:int, dbLogin:String, dbPassword:String):void {
        var userProxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        var settingsSO:SharedObject = SharedObject.getLocal("settings");
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var sr:ServerRequestVO = new ServerRequestVO(userProxy.authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(createDbRO.getSettings).arguments = new Array(sr, "en");
        createDbRO.createDb(sr, "en", dbCount, dbLogin, dbPassword);
    }

    private function getBalanceResultHandler(event:*):void {
        ApplicationConstants.application.enabled = true;
        if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            var re:ResultEvent = event as ResultEvent;
            var balance:Number = re.result.resultingObject as Number;
            sendNotification(ApplicationConstants.BALANCE_LOADED, balance);
        } else {
            sendNotification(event.result.result);
        }
    }

    private function getCreateDbResultHandler(event:*):void {
        if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            var urlRequest:URLRequest = new URLRequest("javascript:location.reload(true)");
            navigateToURL(urlRequest, "_self");
        } else {
            sendNotification(event.result.result);
        }
    }

    private function getSettingsResultHandler(event:*):void {
        ApplicationConstants.application.enabled = true;

        if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.DB_FAILURE) {
            var result:ResultEvent = event as ResultEvent;
            var dbLog:ArrayCollection = result.result.resultingObject as ArrayCollection;
            sendNotification(ApplicationConstants.DB_FAILURE, dbLog);

        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            var userProxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var re:ResultEvent = event as ResultEvent;
            settings = re.result.resultingObject as SettingsVO;
            userProxy.authenticatedUser.sessionId = settings.sessionId;
            sendNotification(ApplicationConstants.SETTINGS_LOADED);

        } else {
            sendNotification(event.result.result);
        }
    }

    private function faultHandler(event:FaultEvent):void {
        sendNotification(ApplicationConstants.SERVER_FAULT, event);
    }

    //uid, uid, instid, width, height
    public function getAdTag(ap:AdPlaceVO):Array {
        var arr:Array = new Array();
        if (ap.uid == null) {
            ap.uid = ApplicationConstants.getNewUid();
        }
        arr.push(settings.adTag[0] +
                ap.uid +
                settings.adTag[1] +
                ap.uid +
                settings.adTag[2] +
                settings.installationId +
                settings.adTag[3] +
                ap.adFormat.width +
                settings.adTag[4] +
                ap.adFormat.height +
                settings.adTag[5]);
        return arr;
    }

    public function get settings():SettingsVO {
        return _settings;
    }

    public function set settings(u:SettingsVO):void {
        this._settings = u;
    }

}
}