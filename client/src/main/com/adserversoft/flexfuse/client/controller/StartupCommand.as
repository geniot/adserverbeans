package com.adserversoft.flexfuse.client.controller {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.model.AdPlaceProxy;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.ReportProxy;
import com.adserversoft.flexfuse.client.model.SettingsProxy;
import com.adserversoft.flexfuse.client.model.StateProxy;
import com.adserversoft.flexfuse.client.model.UploadProxy;
import com.adserversoft.flexfuse.client.model.UserProxy;
import com.adserversoft.flexfuse.client.view.FlexFuseApplication;
import com.adserversoft.flexfuse.client.view.FlexFuseApplicationMediator;

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.external.ExternalInterface;
import flash.net.SharedObject;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

import mx.events.ResourceEvent;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.styles.StyleManager;
import mx.utils.StringUtil;

import org.puremvc.as3.interfaces.ICommand;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class StartupCommand extends SimpleCommand implements ICommand {
    public var _currentLang:String = "en_US";
    public var _currentSkin:String = "default";
//    private var variables:URLLoader;

    /**
     * Register the Proxies and Mediators.
     *
     * Get the View Components for the Mediators from the app,
     * which passed a reference to itself on the notification.
     */
    override public function execute(note:INotification):void {

        var settingsSO:SharedObject = SharedObject.getLocal("settings");
        if (settingsSO.size != 0) {
            _currentLang = settingsSO.data.lang;
            _currentSkin = settingsSO.data.theme;
        } else {
            settingsSO.data.lang = _currentLang;
            settingsSO.data.theme = _currentSkin;
        }

        var resourceManager:IResourceManager = ResourceManager.getInstance();
        if (resourceManager.getResourceBundle(_currentLang, ApplicationConstants.APP_RES) == null) {
            var rnd:Number = Math.random();
            var resourceModuleURL:String = "ResourceModule_" + _currentLang + ".swf?rnd=" + rnd;
            var eventDispatcher:IEventDispatcher = resourceManager.loadResourceModule(resourceModuleURL, true);
            eventDispatcher.addEventListener(ResourceEvent.COMPLETE, completeHandler);
        } else {
            completeHandler(new ResourceEvent(ApplicationConstants.LOCALE_UPDATED));
        }
    }


    private function completeHandler(event:ResourceEvent):void {
        facade.registerProxy(new UserProxy());
        facade.registerProxy(new SettingsProxy());
        facade.registerProxy(new BannerProxy());
        facade.registerProxy(new AdPlaceProxy());
        facade.registerProxy(new UploadProxy());
        facade.registerProxy(new StateProxy());
        facade.registerProxy(new ReportProxy());
        var rnd:Number = Math.random();
//        variables = new URLLoader();
//        var request:URLRequest = new URLRequest("build.num?rnd=" + rnd);
//        variables.dataFormat = URLLoaderDataFormat.TEXT;
//        variables.addEventListener(Event.COMPLETE, versionLoaded);
//        try {
//            variables.load(request);
//        }
//        catch (error:Error) {
//            trace("Unable to load URL: " + error);
//        }

        langChangeCompleteHandler(new ResourceEvent(ApplicationConstants.LOCALE_UPDATED));
        var ffa:FlexFuseApplication = ApplicationConstants.application as FlexFuseApplication;
        facade.registerMediator(new FlexFuseApplicationMediator(FlexFuseApplicationMediator.NAME, ffa));


        ApplicationConstants.application.enabled = false;
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;

        try {
            var url:String = ExternalInterface.call("window.location.href.toString");//BrowserManager.getInstance().url;
            var splits:Array = url.split(/[?=&#]/);
            for (var i:int = 0; i < splits.length; i++) {
                var split:String = splits[i];
                if (split == ApplicationConstants.INSTALLATION_ID_PARAM) {
                    settingsProxy.settings.installationId = int(splits[i + 1]);
                    break;
                }
            }
        } catch(e:*) {
            settingsProxy.settings.installationId = ApplicationConstants.DEFAULT_INSTALLATION_ID;
        }
        if (settingsProxy.settings.installationId == 0) {
            settingsProxy.settings.installationId = ApplicationConstants.DEFAULT_INSTALLATION_ID;
        }

        ffa.instId = settingsProxy.settings.installationId;

        ApplicationConstants.initializeDataProvider();

        versionLoaded(null);
    }

    private function langChangeCompleteHandler(event:ResourceEvent):void {
        var resourceManager:IResourceManager = ResourceManager.getInstance();
        resourceManager.localeChain = [ _currentLang, "en_US" ];
        resourceManager.update();

        if (_currentSkin != "default")StyleManager.loadStyleDeclarations(_currentSkin, true); // force immediate update
    }

    private function versionLoaded(event:Event):void {
//        var v:String = String(variables.data).split("=")[1];
        ApplicationConstants.VERSION;// += "." + StringUtil.trim(v);
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        settingsProxy.loadSettings();
        verifyUrlForRemindPasswordSupport();

    }

    private function verifyUrlForRemindPasswordSupport():void {
        //        var url:String = BrowserManager.getInstance().url;
        var url:String = ExternalInterface.call("eval", "document.location.href");
        if (url == null) return;
        var searchForRemindPassword:String = "&rmdcod=";
        if (url.indexOf(searchForRemindPassword) != -1) {
            var splits:Array = url.split(/[?=&#]/);
            var remindCode:String = "";
            var userId:int = -1;
            for (var i:int = 0; i < splits.length; i++) {
                var split:String = splits[i];
                if (split == "rmdcod") {
                    remindCode = String(splits[i + 1]);
                }
                if (split == "rmpusid") {
                    userId = int(splits[i + 1]);
                }
            }
            if (remindCode != "" && userId != -1) {
                var userProxy:UserProxy = ApplicationFacade.getInstance().retrieveProxy(UserProxy.NAME) as UserProxy;
                userProxy.user.passwordReset = true;
                userProxy.verifyRemindPassword(remindCode, userId);
            }
        }
    }
}
}