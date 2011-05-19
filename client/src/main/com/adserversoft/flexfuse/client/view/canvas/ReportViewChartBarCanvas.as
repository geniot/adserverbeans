package com.adserversoft.flexfuse.client.view.canvas {
import mx.charts.CategoryAxis;
import mx.charts.ColumnChart;
import mx.charts.series.ColumnSeries;

public class ReportViewChartBarCanvas extends BaseCanvas {
    [Bindable]
    public var columnChart:ColumnChart;
    [Bindable]
    public var categoryAxis:CategoryAxis;
    public var viewsCS:ColumnSeries;
    public var clicksCS:ColumnSeries;

    public function ReportViewChartBarCanvas() {
        super();
    }
}
}