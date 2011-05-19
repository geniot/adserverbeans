package com.adserversoft.flexfuse.client.view.canvas{
import com.adserversoft.flexfuse.client.model.vo.IDragNDropWizard;
import com.adserversoft.flexfuse.client.view.component.dnd.DragNDropWizard;

import flash.events.Event;

import mx.controls.Image;
import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;

public class AdminManagementCanvas extends BaseCanvas {
    

    public var logo:Image;
    public var dragNDropWizard:IDragNDropWizard;

    public function AdminManagementCanvas()
    {
        super();
//        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

    }

//    private function onCreationComplete(event:Event):void {
//        dispatchEvent(new Event(INIT));
//    }

//    public function tabChanged(e:IndexChangedEvent):void {
//        dispatchEvent(new Event(INDEX_CHANGED_EVENT));
//    }


}
}