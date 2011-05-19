package com.adserversoft.flexfuse.client.view.titlewindow
{
import com.adserversoft.flexfuse.client.view.canvas.ReportResultsCanvas;
import com.adserversoft.flexfuse.client.view.canvas.ReportSettingsCanvas;

import flash.events.Event;
import mx.events.FlexEvent;
import flash.events.MouseEvent;

import mx.controls.Button;

public class ReportsTitleWindow extends BaseTitleWindow {
    public var reportSettingsCanvas:ReportSettingsCanvas;
    public var reportResultsCanvas:ReportResultsCanvas;
    public var cancelB:Button;

    public function ReportsTitleWindow() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        cancelB.addEventListener(MouseEvent.CLICK, onCancelClick);
    }

    private function onCancelClick(e:Event):void {
        dispatchEvent(new Event(CANCEL));
    }
}
}