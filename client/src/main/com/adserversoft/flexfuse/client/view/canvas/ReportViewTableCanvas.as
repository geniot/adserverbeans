package com.adserversoft.flexfuse.client.view.canvas {
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;

public class ReportViewTableCanvas extends BaseCanvas {
    public var reportDG:DataGrid;
    public var typeNameDGC:DataGridColumn;
    public var viewsDGC:DataGridColumn;
    public var clicksDGC:DataGridColumn;
    public var footerViewsDGC:DataGridColumn;
    public var footerClicksDGC:DataGridColumn;
    public var footerDG:DataGrid;

    public function ReportViewTableCanvas() {
        super();
    }

    public function setRelativeColumnWidths():void {
        var width:int = reportDG.width;
        reportDG.columns[0].width = width * 0.49;
        reportDG.columns[1].width = width * 0.17;
        reportDG.columns[2].width = width * 0.17;
        reportDG.columns[3].width = width * 0.17;
        footerDG.columns[0].width = width * 0.49;
        footerDG.columns[1].width = width * 0.17;
        footerDG.columns[2].width = width * 0.17;
        footerDG.columns[3].width = width * 0.17;
    }

    public function changedVerticalScrollPolicy():void {
        var widthScrollBar:int = 5;
        var width:int = reportDG.width;
    }
}
}