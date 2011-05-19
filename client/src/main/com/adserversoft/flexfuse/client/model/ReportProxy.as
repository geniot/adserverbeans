package com.adserversoft.flexfuse.client.model {
import com.adserversoft.flexfuse.client.model.vo.BaseVO;
import com.adserversoft.flexfuse.client.model.vo.HashMap;
import com.adserversoft.flexfuse.client.model.vo.IMap;
import com.adserversoft.flexfuse.client.model.vo.ReportCriteriaVO;
import com.adserversoft.flexfuse.client.model.vo.ReportsRowVO;
import com.adserversoft.flexfuse.client.model.vo.ServerRequestVO;

import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.Operation;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.IProxy;
import org.puremvc.as3.patterns.proxy.Proxy;

public class ReportProxy extends Proxy implements IProxy {
    public static const NAME:String = 'ReportProxy';

    private var reportRO:RemoteObject;
    public var reportsRowsM:IMap = new HashMap();//key=banner uid x ad place uid
    public var reportsRowsAC:ArrayCollection = new ArrayCollection();//result for report popup

    private var timeUpdateTimer:Timer = new Timer(ApplicationConstants.REPORTS_TIMER_INTERVAL, 0);

    public function ReportProxy() {
        super(NAME, new ArrayCollection);
        reportRO = new RemoteObject();
        reportRO.destination = "report";
        reportRO.requestTimeout = ApplicationConstants.REQUEST_TIMEOUT_SECONDS;

        reportRO.loadReport.addEventListener("result", loadReportResultHandler);
        reportRO.loadReport.addEventListener("fault", faultHandler);

        reportRO.loadCustomReport.addEventListener("result", loadCustomReportResultHandler);
        reportRO.loadCustomReport.addEventListener("fault", faultHandler);

        reportRO.setCustomObjectToSession.addEventListener("result", setCustomObjectToSessionResultHandler);
        reportRO.setCustomObjectToSession.addEventListener("fault", faultHandler);

       timeUpdateTimer.addEventListener(TimerEvent.TIMER, onTimerUpdateHandler)
    }


    private function loadReportResultHandler(event:*):void {
        if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            var re:ResultEvent = event as ResultEvent;
            var rrAC:ArrayCollection = re.result.resultingObject as ArrayCollection;
            for (var i:int = 0; i < rrAC.length; i++) {
                var rr:ReportsRowVO = rrAC.getItemAt(i) as ReportsRowVO;
                var key:String = rr.bannerUid + "x" + rr.adPlaceUid;
                reportsRowsM.put(key, rr);
            }
            sendNotification(ApplicationConstants.REPORT_LOADED);
        }
    }

    private function loadCustomReportResultHandler(event:*):void {
        if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            var re:ResultEvent = event as ResultEvent;
            reportsRowsAC = re.result.resultingObject as ArrayCollection;
            sendNotification(ApplicationConstants.CUSTOM_REPORT_LOADED);
        }
    }

    private function setCustomObjectToSessionResultHandler(event:*):void {
        if (event.result.result == ApplicationConstants.FAILURE) {
            sendNotification(ApplicationConstants.SERVER_FAULT, event.result);
        } else if (event.result.result == ApplicationConstants.SUCCESS) {
            sendNotification(ApplicationConstants.CUSTOM_OBJECT_SET_TO_SESSION);
        }
    }

    public function startReportUpdate():void {
        this.timeUpdateTimer.start();
    }

    public function stopReportUpdate():void {
        this.timeUpdateTimer.stop();
    }

    private function onTimerUpdateHandler(event:Event):void {
        var adPlaceProxy:AdPlaceProxy = facade.retrieveProxy(AdPlaceProxy.NAME) as AdPlaceProxy;
        var bannerProxy:BannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
        if (adPlaceProxy.adPlaces.getValues().length != 0) {
            var reportCriteria:ReportCriteriaVO = new ReportCriteriaVO();
            reportCriteria.type = ApplicationConstants.REPORT_TYPE_AD_PLACES;
            reportCriteria.precision = ApplicationConstants.NONE_PRECISION;
            reportCriteria.adPlaceUids = null;
            reportCriteria.bannerUidByAdPlaceUids = null;
            reportCriteria.adPlaceUids = BaseVO.extractAdPlaceUidsArrayCollection(BaseVO.array2collection(adPlaceProxy.adPlaces.getValues()));
            loadReport(reportCriteria);

            reportCriteria.type = ApplicationConstants.REPORT_TYPE_BANNERS;
            reportCriteria.adPlaceUids = null;
            reportCriteria.bannerUidByAdPlaceUids = null;
            reportCriteria.bannerUids = BaseVO.extractBannerUidsArrayCollection(BaseVO.array2collection(bannerProxy.banners.getValues()));
            loadReport(reportCriteria);

            reportCriteria.type = ApplicationConstants.REPORT_TYPE_BANNER_ON_AD_PLACES;
            reportCriteria.adPlaceUids = null;
            reportCriteria.bannerUids = null;
            reportCriteria.bannerUidByAdPlaceUids = BaseVO.generateBannerUidsByAdPlaceUidsCollection(bannerProxy.banners.getValues());
            loadReport(reportCriteria);
        }
    }


    private function faultHandler(event:FaultEvent):void {
        sendNotification(ApplicationConstants.SERVER_FAULT, event);
    }

    public function loadReport(report:ReportCriteriaVO):void {
        var userProxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var serverRequest:ServerRequestVO = new ServerRequestVO(userProxy.authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(reportRO.loadReport).arguments = new Array(serverRequest, report);
        reportRO.loadReport(serverRequest, report);
    }

    public function loadCustomReport(report:ReportCriteriaVO):void {
        var userProxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var serverRequest:ServerRequestVO = new ServerRequestVO(userProxy.authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(reportRO.loadCustomReport).arguments = new Array(serverRequest, report);
        reportRO.loadCustomReport(serverRequest, report);
    }

    public function setCustomObjectToSession(dataServlet:Object):void {
        var userProxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var serverRequest:ServerRequestVO = new ServerRequestVO(userProxy.authenticatedUser.sessionId, ApplicationConstants.VERSION, settingsProxy.settings.installationId);
        Operation(reportRO.setCustomObjectToSession).arguments = new Array(serverRequest, dataServlet);
        reportRO.setCustomObjectToSession(serverRequest, dataServlet);
    }

}
}