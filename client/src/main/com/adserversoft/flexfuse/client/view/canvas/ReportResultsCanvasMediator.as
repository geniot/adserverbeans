package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.AdPlaceProxy;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.ReportProxy;
import com.adserversoft.flexfuse.client.model.SettingsProxy;
import com.adserversoft.flexfuse.client.model.UserProxy;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.ReportsRowVO;
import com.adserversoft.flexfuse.client.view.titlewindow.ReportsTitleWindow;

import flash.events.Event;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.formatters.DateFormatter;

import org.puremvc.as3.interfaces.INotification;

public class ReportResultsCanvasMediator extends BaseMediator {
    public static const NAME:String = "ReportResultsCanvasMediator";
    private var bannerProxy:BannerProxy;
    private var adPlaceProxy:AdPlaceProxy;
    private var reportProxy:ReportProxy;

    public function ReportResultsCanvasMediator(uid:String, viewComponent:Object) {
        this.uid = uid;
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

    private function get uiComponent():ReportResultsCanvas {
        return viewComponent as ReportResultsCanvas;
    }

    private function onInit(event:Event):void {
        bannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
        adPlaceProxy = facade.retrieveProxy(AdPlaceProxy.NAME) as AdPlaceProxy;
        reportProxy = facade.retrieveProxy(ReportProxy.NAME) as ReportProxy;
        registerMediators();
        addEventListeners();
        var footerDP:Array = new Array(new Object(), new Object());
        footerDP[0].name = "Total";
        footerDP[1].name = "Average";
        uiComponent.reportViewTableCanvas.footerDG.dataProvider = footerDP;
    }

    private function registerMediators():void {
    }

    override public function unregisterMediators():void {
    }

    public override function addEventListeners():void {
        uiComponent.addEventListener(ReportResultsCanvas.EXPORT_TO_EXCEL, onExportToExcel);
    }

    public override function removeEventListeners():void {
        uiComponent.removeEventListener(ReportResultsCanvas.EXPORT_TO_EXCEL, onExportToExcel);
    }

    private function onExportToExcel(event:Event):void {
        var exportTable:ArrayCollection = new ArrayCollection();
        var tableDP:ArrayCollection = uiComponent.reportViewTableCanvas.reportDG.dataProvider as ArrayCollection;
        for each (var iReportsRowVO:ReportsRowVO in tableDP) {
            var exportRow:Object = new Object();
            exportRow.entityName = iReportsRowVO.entityName;
            exportRow.intervalString = iReportsRowVO.intervalString;
            exportRow.views = iReportsRowVO.views;
            exportRow.clicks = iReportsRowVO.clicks;
            exportRow.ctr = iReportsRowVO.ctr;
            exportTable.addItem(exportRow);
        }
        exportTable.addAll(ArrayCollection(uiComponent.reportViewTableCanvas.footerDG.dataProvider));
        reportProxy.setCustomObjectToSession(exportTable);
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.CUSTOM_REPORT_LOADED,
            ApplicationConstants.REPORT_WINDOW_CLOSED,
            ApplicationConstants.REPORT_VIEW_TABLE,
            ApplicationConstants.REPORT_VIEW_CHART,
            ApplicationConstants.REPORT_VIEW_BY_DATE,
            ApplicationConstants.REPORT_VIEW_BY_TYPE,
            ApplicationConstants.CUSTOM_OBJECT_SET_TO_SESSION
        ];
    }

    override public function handleNotification(note:INotification):void {
        switch (note.getName()) {
            case ApplicationConstants.CUSTOM_REPORT_LOADED:
                // todo clear
                var iReportsRow:ReportsRowVO;
                var key:String;
                var reportsTitleWindow:ReportsTitleWindow = uiComponent.parentDocument as ReportsTitleWindow;
                var type:int = reportsTitleWindow.reportSettingsCanvas.getSelectedType();
                // converted and aggregated results for banner entity
                if (type == ApplicationConstants.REPORT_TYPE_BANNERS) {
                    var reportsRow:Dictionary = new Dictionary();
                    var nBannerVO:BannerVO;
                    for each (iReportsRow in reportProxy.reportsRowsAC) {
                        nBannerVO = bannerProxy.banners.getValue(iReportsRow.bannerUid);
                        key = nBannerVO.parentUid + iReportsRow.date;
                        if (reportsRow[key] == null) {
                            iReportsRow.bannerUid = nBannerVO.parentUid;
                            reportsRow[key] = iReportsRow;
                        } else {
                            reportsRow[key].views += iReportsRow.views;
                            reportsRow[key].clicks += iReportsRow.clicks;
                        }
                    }
                    reportProxy.reportsRowsAC = dictionaryToArrayCollection(reportsRow);
                }

                //define entityName
                switch (type) {
                    case ApplicationConstants.REPORT_TYPE_BANNERS: // banner
                        for each (iReportsRow in reportProxy.reportsRowsAC) {
                            iReportsRow.entityName = bannerProxy.banners.getValue(iReportsRow.bannerUid).bannerName;
                        }
                        break;
                    case ApplicationConstants.REPORT_TYPE_AD_PLACES: // ad place
                        for each (iReportsRow in reportProxy.reportsRowsAC) {
                            iReportsRow.entityName = adPlaceProxy.adPlaces.getValue(iReportsRow.adPlaceUid).adPlaceName;
                        }
                        break;
                    case ApplicationConstants.REPORT_TYPE_BANNER_ON_AD_PLACES: // banner in ad place
                        for each (iReportsRow in reportProxy.reportsRowsAC) {
                            iReportsRow.entityName = bannerProxy.banners.getValue(iReportsRow.bannerUid).bannerName +
                                    " in " + adPlaceProxy.adPlaces.getValue(iReportsRow.adPlaceUid).adPlaceName;
                        }
                        break;
                }
                changeReportTable();
                break;

            case ApplicationConstants.REPORT_WINDOW_CLOSED:
                unregisterMediators();
                break;
            case ApplicationConstants.REPORT_VIEW_TABLE:
                uiComponent.resultVS.selectedChild = uiComponent.reportViewTableCanvas;
                break;
            case ApplicationConstants.REPORT_VIEW_CHART:
                uiComponent.resultVS.selectedChild = uiComponent.reportViewChartVBox;
                break;

            case ApplicationConstants.REPORT_VIEW_BY_DATE:
                changeReportTable();
                break;
            case ApplicationConstants.REPORT_VIEW_BY_TYPE:
                changeReportTable();
                break;
            case ApplicationConstants.CUSTOM_OBJECT_SET_TO_SESSION:
                var userProxy:UserProxy = ApplicationFacade.getInstance().retrieveProxy(UserProxy.NAME) as UserProxy;
                var settingsProxy:SettingsProxy = ApplicationFacade.getInstance().retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
                navigateToURL(new URLRequest('exportexcel?sessionId=' + userProxy.authenticatedUser.sessionId
                        + '&' + ApplicationConstants.INSTALLATION_ID_PARAM + "=" + settingsProxy.settings.installationId));
                break;
        }
    }

    private function dictionaryToArrayCollection(dictionary:Dictionary):ArrayCollection{
        var arrayCollection:ArrayCollection = new ArrayCollection();
        for each (var value:Object in dictionary) {
            arrayCollection.addItem(value);
        }
        return arrayCollection;
    }

    private function changeReportTable():void {
        var tableDP:ArrayCollection = getReportTable();
        var isViewByDate:Boolean = uiComponent.dateAndTypeTBB.selectedIndex == 0;

        uiComponent.reportViewTableCanvas.typeNameDGC.headerText = isViewByDate ? "Interval" : "Entity";
        uiComponent.reportViewTableCanvas.typeNameDGC.dataField = isViewByDate ? "intervalString" : "entityName";
        uiComponent.reportViewTableCanvas.reportDG.dataProvider = tableDP;
        uiComponent.reportViewTableCanvas.validateDisplayList();

        uiComponent.reportViewChartLineCanvas.lineChart.dataProvider = tableDP;
        uiComponent.reportViewChartLineCanvas.categoryAxis.categoryField = isViewByDate ? "dateString" : "entityName";
        uiComponent.reportViewChartLineCanvas.categoryAxis.dataProvider = tableDP;
        uiComponent.reportViewChartLineCanvas.lineChart.validateDisplayList();

        uiComponent.reportViewChartBarCanvas.columnChart.dataProvider = tableDP;
        uiComponent.reportViewChartBarCanvas.categoryAxis.categoryField = isViewByDate ? "dateString" : "entityName";
        uiComponent.reportViewChartBarCanvas.categoryAxis.dataProvider = tableDP;
        uiComponent.reportViewChartBarCanvas.validateDisplayList();

        uiComponent.reportViewChartPieCanvas.viewsPieChart.dataProvider = tableDP;
        uiComponent.reportViewChartPieCanvas.viewsPieSeries.nameField = isViewByDate ? "dateString" : "entityName";
        uiComponent.reportViewChartPieCanvas.clicksPieSeries.nameField = isViewByDate ? "dateString" : "entityName";
        uiComponent.reportViewChartPieCanvas.clicksPieChart.dataProvider = tableDP;
        uiComponent.reportViewChartPieCanvas.viewsPieChart.dataProvider = tableDP;
        uiComponent.reportViewChartPieCanvas.validateDisplayList();
    }

    private function getReportTable():ArrayCollection {
        // change report table and view of line chart
        var tableAndLineDP:ArrayCollection = new ArrayCollection();
        if (reportProxy.reportsRowsAC.length == 0) {
            clearSummaryTable();
        } else {
            var iReportsRow:ReportsRowVO;
            var sort:Sort = new Sort();
            var isViewByDate:Boolean = uiComponent.dateAndTypeTBB.selectedIndex == 0;
            if (isViewByDate) {
                sort.fields = [new SortField("date")];
                reportProxy.reportsRowsAC.sort = sort;
                reportProxy.reportsRowsAC.refresh();
                var reportsTitleWindow:ReportsTitleWindow = uiComponent.parentDocument as ReportsTitleWindow;
                var precision:int = reportsTitleWindow.reportSettingsCanvas.precisionCB.selectedIndex;
                var startIntervalDate:Date = reportsTitleWindow.reportSettingsCanvas.fromPeriodDF.selectedDate;
                if (precision == ApplicationConstants.MONTH_PRECISION) {
                    startIntervalDate = new Date(startIntervalDate.fullYear, startIntervalDate.month, 1);
                } else if (precision == ApplicationConstants.YEAR_PRECISION) {
                    startIntervalDate = new Date(startIntervalDate.fullYear, 1, 1);
                }
                var endIntervalDate:Date = getIntervalEndDate(startIntervalDate, precision);
                var toSelectedDate:Date = reportsTitleWindow.reportSettingsCanvas.toPeriodDF.selectedDate;
                var toDate:Date = new Date(toSelectedDate.fullYear, toSelectedDate.month, toSelectedDate.date + 1);
                var i:int = 0;
                var dateFormatter:DateFormatter = new DateFormatter();
                dateFormatter = new DateFormatter();
                dateFormatter.formatString = precision == ApplicationConstants.HOUR_PRECISION ? "MM/DD/YY JJ:NN" : "MM/DD/YY";
                while (startIntervalDate < toDate) {
                    iReportsRow = new ReportsRowVO();
                    iReportsRow.date = startIntervalDate;
                    iReportsRow.dateString = dateFormatter.format(startIntervalDate);
                    iReportsRow.intervalString = iReportsRow.dateString + " - " + dateFormatter.format(endIntervalDate);
                    iReportsRow.views = 0;
                    iReportsRow.clicks = 0;
                    while (i < reportProxy.reportsRowsAC.length &&
                            ReportsRowVO(reportProxy.reportsRowsAC.getItemAt(i)).date < endIntervalDate) {
                        iReportsRow.views += ReportsRowVO(reportProxy.reportsRowsAC.getItemAt(i)).views;
                        iReportsRow.clicks += ReportsRowVO(reportProxy.reportsRowsAC.getItemAt(i)).clicks;
                        i++;
                    }
                    tableAndLineDP.addItem(iReportsRow);
                    startIntervalDate = endIntervalDate;
                    endIntervalDate = getIntervalEndDate(startIntervalDate, precision);
                }
            } else {
                tableAndLineDP = getEntityTable();
            }
            setSummaryTable(tableAndLineDP);
        }
        return tableAndLineDP;
    }

    private function setSummaryTable(entityTable:ArrayCollection):void {
        var totalViews:int = 0;
        var totalClicks:int = 0;
        for each (var iReportsRow:ReportsRowVO in entityTable) {
            totalViews += iReportsRow.views;
            totalClicks += iReportsRow.clicks;
        }
        var footerDP:Array = new Array(new Object(), new Object());
        footerDP[0].name = "Total";
        footerDP[0].views = totalViews;
        footerDP[0].clicks = totalClicks;
        footerDP[0].ctr = "";
        var averageViews:Number = Math.round(((totalViews * 100 / entityTable.length))) / 100;
        var averageClicks:Number = Math.round(((totalClicks  * 100 / entityTable.length))) / 100;
        footerDP[1].name = "Average";
        footerDP[1].views = averageViews;
        footerDP[1].clicks = averageClicks;
        footerDP[1].ctr = String((averageViews == 0) ? 0 : Math.round(((averageClicks / averageViews) * 100) * 100) / 100) + "%";
        uiComponent.reportViewTableCanvas.footerDG.dataProvider = footerDP;
    }

    private function clearSummaryTable():void {
        var footerDP:Array = new Array(new Object(), new Object());
        footerDP[0].name = "Total";
        footerDP[0].views = "";
        footerDP[0].clicks = "";
        footerDP[0].ctr = "";
        footerDP[1].name = "Average";
        footerDP[1].views = "";
        footerDP[1].clicks = "";
        footerDP[1].ctr = "";
        uiComponent.reportViewTableCanvas.footerDG.dataProvider = footerDP;
    }

    private function getEntityTable():ArrayCollection {
        // created entity table for bar and pie chart
        var key:String;
        var sort:Sort = new Sort();
        sort.fields = [new SortField("adPlaceUid", true), new SortField("bannerUid", true)];
        reportProxy.reportsRowsAC.sort = sort;
        reportProxy.reportsRowsAC.refresh();
        var reportsRow:Dictionary = new Dictionary();
        for each (var iReportsRow:ReportsRowVO in reportProxy.reportsRowsAC) {
            key = iReportsRow.adPlaceUid + iReportsRow.bannerUid;
            if (reportsRow[key] == null) {
                reportsRow[key] = iReportsRow.clone();
            } else {
                reportsRow[key].views += iReportsRow.views;
                reportsRow[key].clicks += iReportsRow.clicks;
            }
        }
        return dictionaryToArrayCollection(reportsRow);
    }

    private function getIntervalEndDate(intervalStartDate:Date, selectedInterval:int):Date {
        var startHours:Number = intervalStartDate.hours;
        var startDate:Number = intervalStartDate.date;
        var startMonth:Number = intervalStartDate.month;
        var startYear:Number = intervalStartDate.fullYear;

        var intervalEndDate:Date;
        switch (selectedInterval) {
            case 0: // hour
                intervalEndDate = new Date(startYear, startMonth, startDate, startHours + 1);
                break;
            case 1: // day
                intervalEndDate = new Date(startYear, startMonth, startDate + 1);
                break;
            case 2: // month
                intervalEndDate = new Date(startYear, startMonth + 1, startDate);
                break;
            case 3: // year
                intervalEndDate = new Date(startYear + 1, startMonth, startDate);
                break;
        }
        return intervalEndDate;
    }
}
}