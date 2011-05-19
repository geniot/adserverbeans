package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.containers.VBox;
import mx.containers.ViewStack;
import mx.controls.Button;
import mx.controls.ToggleButtonBar;
import mx.controls.buttonBarClasses.ButtonBarButton;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;

public class ReportResultsCanvas extends BaseCanvas {
    public static const EXPORT_TO_EXCEL:String = "EXPORT_TO_EXCEL";

    public var resultVS:ViewStack;
    public var reportViewTableCanvas:ReportViewTableCanvas;
    public var reportViewChartVBox: VBox;
    public var reportViewChartLineCanvas:ReportViewChartLineCanvas;
    public var reportViewChartBarCanvas:ReportViewChartBarCanvas;
    public var reportViewChartPieCanvas:ReportViewChartPieCanvas;
    public var reportPanelViewStack:ViewStack;
    public var tableAndChartTBB:ToggleButtonBar;
    public var dateAndTypeTBB:ToggleButtonBar;
    public var viewsTBB:ToggleButtonBar;
    public var clicksTBB:ToggleButtonBar;
    public var chartTBB:ToggleButtonBar;
    public var exportToExcelB:Button;

    public function ReportResultsCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    private function onCreationComplete(event:Event):void {
        dispatchEvent(new Event(INIT));
        reportViewTableCanvas.reportDG.dataProvider = new ArrayCollection();
        reportViewChartLineCanvas.lineChart.dataProvider = new ArrayCollection();
        reportViewChartLineCanvas.categoryAxis.dataProvider = new ArrayCollection();
        reportViewChartBarCanvas.columnChart.dataProvider = new ArrayCollection();
        reportViewChartBarCanvas.categoryAxis.dataProvider = new ArrayCollection();
        reportViewChartPieCanvas.viewsPieChart.dataProvider = new ArrayCollection();
        reportViewChartPieCanvas.clicksPieChart.dataProvider = new ArrayCollection();
        tableAndChartTBB.addEventListener(ItemClickEvent.ITEM_CLICK, onTableAndChartItemClick);
        dateAndTypeTBB.addEventListener(ItemClickEvent.ITEM_CLICK, onDateAndTypeItemClick);
        viewsTBB.addEventListener(ItemClickEvent.ITEM_CLICK, onViewsClicksItemClick);
        clicksTBB.addEventListener(ItemClickEvent.ITEM_CLICK, onViewsClicksItemClick);
        chartTBB.addEventListener(ItemClickEvent.ITEM_CLICK, onChartItemClick);
        exportToExcelB.addEventListener(MouseEvent.CLICK, onExportToExcel);
        onDateAndTypeItemClick(null);
    }


    private function onTableAndChartItemClick(event:ItemClickEvent):void {
        ApplicationFacade.getInstance().sendNotification(tableAndChartTBB.selectedIndex == 0 ?
                ApplicationConstants.REPORT_VIEW_TABLE : ApplicationConstants.REPORT_VIEW_CHART);
    }

    private function onDateAndTypeItemClick(event:ItemClickEvent):void {
        ApplicationFacade.getInstance().sendNotification(dateAndTypeTBB.selectedIndex == 0 ?
                ApplicationConstants.REPORT_VIEW_BY_DATE : ApplicationConstants.REPORT_VIEW_BY_TYPE);
    }

    private function onViewsClicksItemClick(event:ItemClickEvent):void {
        var showViews:Boolean = ButtonBarButton(viewsTBB.getChildAt(0)).selected;
        var showClicks:Boolean = ButtonBarButton(clicksTBB.getChildAt(0)).selected;
        var lineSeries:Array;
        var columnSeries:Array;
        reportViewTableCanvas.viewsDGC.visible = showViews;
        reportViewTableCanvas.footerViewsDGC.visible = showViews;
        reportViewTableCanvas.clicksDGC.visible = showClicks;
        reportViewTableCanvas.footerClicksDGC.visible = showClicks;
        if (showViews && showClicks) {
            viewsTBB.toggleOnClick = true;
            clicksTBB.toggleOnClick = true;
            lineSeries = new Array(reportViewChartLineCanvas.viewsLS, reportViewChartLineCanvas.clicksLS);
            columnSeries = new Array(reportViewChartBarCanvas.viewsCS, reportViewChartBarCanvas.clicksCS);
        } else if (showViews) {
            viewsTBB.toggleOnClick = false;
            clicksTBB.toggleOnClick = true;
            lineSeries = new Array(reportViewChartLineCanvas.viewsLS);
            columnSeries = new Array(reportViewChartBarCanvas.viewsCS);
        } else if (showClicks) {
            viewsTBB.toggleOnClick = true;
            clicksTBB.toggleOnClick = false;
            lineSeries = new Array(reportViewChartLineCanvas.clicksLS);
            columnSeries = new Array(reportViewChartBarCanvas.clicksCS);
        }
        reportViewChartLineCanvas.lineChart.series = lineSeries;
        reportViewChartBarCanvas.columnChart.series = columnSeries;
        reportViewChartPieCanvas.viewsPieChart.visible = showViews;
        reportViewChartPieCanvas.clicksPieChart.visible = showClicks;
    }

    private function onChartItemClick(event:ItemClickEvent):void {
        var notificationName:String;
        switch (chartTBB.selectedIndex) {
            case 0:
                reportPanelViewStack.selectedChild = reportViewChartLineCanvas;
                break;
            case 1:
                reportPanelViewStack.selectedChild = reportViewChartBarCanvas;
                break;
            case 2:
                reportPanelViewStack.selectedChild = reportViewChartPieCanvas;
                break;
        }
        ApplicationFacade.getInstance().sendNotification(notificationName);
    }

    private function onExportToExcel(event:MouseEvent):void {
        dispatchEvent(new Event(EXPORT_TO_EXCEL));
    }
}
}