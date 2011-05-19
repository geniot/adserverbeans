package com.adserversoft.flexfuse.client.controller {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.UserProxy;
import com.adserversoft.flexfuse.client.model.vo.HashMap;
import com.adserversoft.flexfuse.client.model.vo.IHashMapEntry;
import com.adserversoft.flexfuse.client.model.vo.IMap;
import com.adserversoft.flexfuse.client.view.titlewindow.EmailReminderTitleWindow;
import com.adserversoft.flexfuse.client.view.titlewindow.LoginTitleWindow;
import com.adserversoft.flexfuse.client.view.titlewindow.LoginTitleWindowMediator;
import com.adserversoft.flexfuse.client.view.titlewindow.LoginTitleWindowUI;
import com.adserversoft.flexfuse.client.view.titlewindow.PasswordReminderTitleWindow;

import flash.display.Sprite;
import flash.events.IOErrorEvent;
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.events.CloseEvent;
import mx.resources.ResourceManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.Operation;

import org.puremvc.as3.interfaces.ICommand;
import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ServerFaultCommand extends SimpleCommand implements ICommand {
    /**
     * Register the Proxies and Mediators.
     *
     * Get the View Components for the Mediators from the app,
     * which passed a reference to itself on the notification.
     */
    private var faultEvent:FaultEvent;
    private static var alert:Alert;

    override public function execute(note:INotification):void {
        if (PopManager.CURRENT_POP_UP != null) {
            PopManager.CURRENT_POP_UP.enabled = true;
        }
        ApplicationConstants.application.enabled = true;

        var res:* = note.getBody();
        faultEvent = res is FaultEvent ? res as FaultEvent : null;
        if (res is IOErrorEvent) {
            alert = Alert.show(res.text, ResourceManager.getInstance().getString('ApplicationResource', 'failure.title.error'));
        } else if (res.message == ApplicationConstants.SESSION_EXPIRED) {
            if (alert == null
                    && !(PopManager.CURRENT_POP_UP is LoginTitleWindow)
                    && !(PopManager.CURRENT_POP_UP is PasswordReminderTitleWindow)
                    && !(PopManager.CURRENT_POP_UP is EmailReminderTitleWindow)) {
                var msg1:String = ResourceManager.getInstance().getString('ApplicationResource', 'failure.sessionExpired');
                alert = Alert.show(msg1, ResourceManager.getInstance().getString('ApplicationResource', 'failure.title.sessionExpired'),
                        Alert.OK, ApplicationConstants.application as Sprite, onSessionExpiredAlertClose);
            }
        } else if (res.message == ApplicationConstants.VERSION_EXPIRED) {
            var msg2:String = ResourceManager.getInstance().getString('ApplicationResource', 'failure.versionExpired');
            alert = Alert.show(msg2, ResourceManager.getInstance().getString('ApplicationResource', 'failure.title.versionExpired'),
                    Alert.OK, ApplicationConstants.application as Sprite, onVersionExpiredAlertClose);
        } else if (res.message != null
                && res.message.hasOwnProperty("faultDetail")
                && res.message.faultDetail != null
                && res.message.faultDetail.indexOf("NetConnection.Call.Failed") != -1) {
            if (faultEvent != null && faultEvent.target.name.indexOf("loadReport") == -1) {
                alert = Alert.show("Can't establish connection to the server. Would you like to try to reconnect?",
                        ResourceManager.getInstance().getString('ApplicationResource', 'failure.title.error'),
                        Alert.YES | Alert.NO | Alert.CANCEL,
                        ApplicationConstants.application as Sprite,
                        alertListenerOnClose);
            }
        } else {
            alert = Alert.show(res.message == null ? "Internal server error. We have logged it and it is going to be fixed soon." : res.message,
                    ResourceManager.getInstance().getString('ApplicationResource', 'failure.title.error'));
        }
    }

    private function alertListenerOnClose(closeEvent:CloseEvent):void {
        if (closeEvent.detail == Alert.YES && faultEvent != null) {
            if (PopManager.CURRENT_POP_UP != null) {
                PopManager.CURRENT_POP_UP.enabled = false;
            } else {
                ApplicationConstants.application.enabled = false;
            }
            Operation(faultEvent.target).send();
            alert = null;
        }
    }

    private function onVersionExpiredAlertClose(event:CloseEvent):void {
        var rnd:Number = Math.random();
        var url:String = ExternalInterface.call("window.location.href.toString");
        //        var baseUrl:String = url.indexOf("?") != -1 ? url.split("?")[0] : url;
        //        var paramsMap:IMap = getParamsMapFromUrl(url);
        //        paramsMap.put("rnd", rnd);
        //        var newUrl:String = baseUrl + "?" + serializeParamsFromMap(paramsMap);
        var urlRequest:URLRequest = new URLRequest(url);
        navigateToURL(urlRequest, "_self");
    }

    private function serializeParamsFromMap(map:IMap):String {
        var str:String = "";
        for each (var entry:IHashMapEntry in map.getEntries()) {
            str += entry.key + "=" + entry.value + "&";
        }
        if (map.getEntries().length > 0)str = str.substr(0, str.length - 1);
        return str;
    }

    private function getParamsMapFromUrl(url:String):IMap {
        var paramsMap:IMap = new HashMap();
        if (url.indexOf("?") != -1) {
            var params:String = url.split("?")[1];
            var pairs:Array = params.split("&");
            for each (var pair:String in pairs) {
                var paramName:String = pair.split("=")[0];
                var paramValue:String = pair.split("=")[1];
                paramsMap.put(paramName, paramValue);
            }
        }
        return paramsMap;
    }

    private function onSessionExpiredAlertClose(event:CloseEvent):void {
        alert = null;
        var userProxy:UserProxy = ApplicationFacade.getInstance().retrieveProxy(UserProxy.NAME) as UserProxy;
        userProxy.reloginNeended = true;

        var mode:String = ApplicationConstants.CREATE;
        var mediatorName:String = mode + "::" + LoginTitleWindowMediator.NAME;
        if (!facade.hasMediator(mediatorName)) {
            var window:IFlexDisplayObject = PopManager.openPopUpWindow(LoginTitleWindowUI, mode);
            var mediator:IMediator = new LoginTitleWindowMediator(mediatorName, window);
            facade.registerMediator(mediator);
        }
    }


}
}