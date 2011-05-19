package com.adserversoft.flexfuse.client.model {
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.HashMap;
import com.adserversoft.flexfuse.client.model.vo.IMap;
import com.adserversoft.flexfuse.client.model.vo.ObjectFileReference;

import flash.events.DataEvent;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import mx.collections.ArrayCollection;
import mx.managers.BrowserManager;
import mx.managers.IBrowserManager;
import mx.utils.URLUtil;

import org.puremvc.as3.interfaces.IProxy;
import org.puremvc.as3.patterns.proxy.Proxy;

public class UploadProxy extends Proxy implements IProxy {
    public static const NAME:String = 'UploadProxy';
    private var fileReferences:IMap = new HashMap();

    public function UploadProxy() {
        super(NAME, new ArrayCollection);
    }

    private function configureListenersBanner(dispatcher:FileReference):void {
        dispatcher.addEventListener(Event.SELECT, selectHandlerBanner);
        dispatcher.addEventListener(Event.COMPLETE, completeHandlerBanner);
        configureListeners(dispatcher);
    }

    private function configureListenersLogo(dispatcher:FileReference):void {
        dispatcher.addEventListener(Event.SELECT, selectHandlerLogo);
        dispatcher.addEventListener(Event.COMPLETE, completeHandlerLogo);
        configureListeners(dispatcher);
    }

    private function configureListeners(dispatcher:FileReference):void {
        dispatcher.addEventListener(Event.CANCEL, cancelHandler);
        dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
        dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        dispatcher.addEventListener(Event.OPEN, openHandler);
        dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
    }

    public function browseBanner(event:Event, banner:BannerVO):void {
        var allTypes:ArrayCollection = new ArrayCollection();
        allTypes.addItem(new FileFilter("Images (" + ApplicationConstants.IMAGE_BANNER_CONTENT_TYPE_FILE + ")",
                ApplicationConstants.IMAGE_BANNER_CONTENT_TYPE_FILE.replace(/,/g, ';')));
        allTypes.addItem(new FileFilter("Flash (" + ApplicationConstants.FLASH_BANNER_CONTENT_TYPE_FILE + ")",
                ApplicationConstants.FLASH_BANNER_CONTENT_TYPE_FILE));
        allTypes.addItem(new FileFilter("Html (" + ApplicationConstants.HTML_BANNER_CONTENT_TYPE_FILE + ")",
                ApplicationConstants.HTML_BANNER_CONTENT_TYPE_FILE.replace(/,/g, ';')));

        var fileRefBanner:ObjectFileReference = new ObjectFileReference();
        fileRefBanner.object = banner;
        fileReferences.put(banner.uid, fileRefBanner);

        configureListenersBanner(fileRefBanner);
        fileRefBanner.browse(allTypes.toArray());
    }

    public function browseLogo(event:Event):void {
        var imageTypes:FileFilter = new FileFilter("Images (" + ApplicationConstants.IMAGE_BANNER_CONTENT_TYPE_FILE + ")",
                ApplicationConstants.IMAGE_BANNER_CONTENT_TYPE_FILE.replace(/,/g, ';'));
        var allTypes:Array = new Array(imageTypes);
        var fileRefLogo:ObjectFileReference = new ObjectFileReference();
        fileReferences.put(fileRefLogo.uid, fileRefLogo);
        configureListenersLogo(fileRefLogo);
        fileRefLogo.browse(allTypes);
    }

    public function uploadBannerToSession(event:Event):void {
        var fileRef:ObjectFileReference = null;
        var banner:BannerVO = null;
        if (PopManager.CURRENT_POP_UP != null) {
            PopManager.CURRENT_POP_UP.enabled = false;
            fileRef = event.target.fileRef as ObjectFileReference;
            banner = event.target.banner as BannerVO;
        } else {
            var bannerProxy:BannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
            banner = bannerProxy.banners.getValue(event.target.parent.parent.parent.parent.bannerUid);
        }

        var request:URLRequest = prepareToUpload(ApplicationConstants.UPLOAD_ACTION_BANNER, banner);
        if (fileRef != null) {
            fileRef.upload(request);
        } else {
            var urlLoader:URLLoader = new URLLoader();
            urlLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE, completeHandlerBanner, false, 0, true);
            urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
            urlLoader.load(request);
        }
    }

    public function uploadLogoToDB(event:Event):void {
        var request:URLRequest = prepareToUpload(ApplicationConstants.UPLOAD_ACTION_LOGO, null);
        var fileRef:ObjectFileReference = event.target as ObjectFileReference;
        fileRef.upload(request);
    }

    private function prepareToUpload(uploadAction:String, banner:BannerVO):URLRequest {
        var userProxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var variables:URLVariables = new URLVariables();
        var browserManager:IBrowserManager = BrowserManager.getInstance();
        variables.sessionId = userProxy.authenticatedUser.sessionId;
        variables.action = uploadAction;
        variables.version = ApplicationConstants.VERSION;
        variables.instId = settingsProxy.settings.installationId;

        if (uploadAction == ApplicationConstants.UPLOAD_ACTION_LOGO) {
            variables.userId = userProxy.authenticatedUser.id;
        } else if (uploadAction == ApplicationConstants.UPLOAD_ACTION_BANNER) {
            variables.bannerUid = banner.uid;
            variables.targetUrl = banner.targetUrl;
            variables.adFormatId = banner.adFormatId;
            variables.bannerContentType = banner.bannerContentTypeId;
            if (banner.parentUid != null) {
                variables.bannerParentUid = banner.parentUid;
            }
            if (banner.adTag != null) {
                variables.adTag = banner.adTag;
            }
        }
        var request:URLRequest = new URLRequest(URLUtil.getFullURL(browserManager.url, "asb"));
        request.method = URLRequestMethod.POST;
        request.data = variables;
        return request;
    }

    protected function selectHandlerBanner(event:Event):void {
        var fileRef:ObjectFileReference = event.target as ObjectFileReference;
        fileReferences.remove(fileRef.uid);
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var notificationName:String = fileRef.size <= settingsProxy.settings.maxBannerFileSize ?
                ApplicationConstants.BANNER_FILE_SELECTED : ApplicationConstants.BANNER_FILE_TOO_BIG;
        sendNotification(notificationName, fileRef);
    }

    protected function selectHandlerLogo(event:Event):void {
        var fileRef:ObjectFileReference = event.target as ObjectFileReference;
        fileReferences.remove(fileRef.uid);
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        if (fileRef.size <= settingsProxy.settings.maxLogoFileSize) {
            uploadLogoToDB(event);
            sendNotification(ApplicationConstants.LOGO_FILE_SELECTED, fileRef);
        } else if (fileRef.size > settingsProxy.settings.maxLogoFileSize) {
            sendNotification(ApplicationConstants.LOGO_FILE_TOO_BIG, fileRef);
        }
    }

    private function completeHandlerBanner(event:Event):void {
        trace("completeHandler: " + event);
        if (PopManager.CURRENT_POP_UP != null) {
            PopManager.CURRENT_POP_UP.enabled = true;
        }
        sendNotification(ApplicationConstants.BANNER_FILE_UPLOADED, event);
    }

    private function completeHandlerLogo(event:Event):void {
        trace("completeHandler: " + event);
        sendNotification(ApplicationConstants.LOGO_UPLOADED, event);
    }

    private function cancelHandler(event:Event):void {
        trace("cancelHandler: " + event);
    }

    private function uploadCompleteDataHandler(event:Event):void {
    }

    private function httpStatusHandler(event:HTTPStatusEvent):void {
        trace("httpStatusHandler: " + event);
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
        trace("ioErrorHandler: " + event);
        sendNotification(ApplicationConstants.SERVER_FAULT, event);
    }

    private function openHandler(event:Event):void {
        trace("openHandler: " + event);
    }

    private function progressHandler(event:ProgressEvent):void {
        var fileRef:FileReference = event.target as FileReference;
        trace("progressHandler name=" + fileRef.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
        trace("securityErrorHandler: " + event);
    }
}
}