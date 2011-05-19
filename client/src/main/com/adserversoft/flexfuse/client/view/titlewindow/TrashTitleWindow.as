package com.adserversoft.flexfuse.client.view.titlewindow {


import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Button;
import mx.controls.DataGrid;
import mx.events.FlexEvent;

public class TrashTitleWindow extends BaseTitleWindow {


    public var cancelBtn:Button;
    public var trashDataGrid:DataGrid;

    public function TrashTitleWindow() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        cancelBtn.addEventListener(MouseEvent.CLICK, cancel);
    }

    private function cancel(e:Event):void {
        dispatchEvent(new Event(CANCEL));
    }


}
}