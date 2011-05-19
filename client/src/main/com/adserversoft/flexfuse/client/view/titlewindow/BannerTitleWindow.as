package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.ObjectFileReference;
import com.adserversoft.flexfuse.client.view.canvas.BannerInfoCanvas;
import com.adserversoft.flexfuse.client.view.canvas.BannerTargetingCanvas;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.containers.TabNavigator;
import mx.controls.Button;
import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;

public class BannerTitleWindow extends BaseTitleWindow {
    public var bannerInfoCanvas:BannerInfoCanvas;
    public var bannerTargetingCanvas:BannerTargetingCanvas;
    public var tabNavigator:TabNavigator;
    public var cancelBtn:Button;
    public var saveBtn:Button;

    public var fileRef:ObjectFileReference;
    public var banner:BannerVO;
    public var displayOrder:int;

    public function BannerTitleWindow() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        cancelBtn.addEventListener(MouseEvent.CLICK, cancel);
        saveBtn.addEventListener(MouseEvent.CLICK, save);
        tabNavigator.addEventListener(IndexChangedEvent.CHANGE, onTabChage);

    }

    private function cancel(e:Event):void {
        dispatchEvent(new Event(CANCEL));
    }

    private function save(e:Event):void {
        dispatchEvent(new Event(SAVE));
    }

    private function onTabChage(e:Event):void {
        dispatchEvent(new Event(INDEX_CHANGED_EVENT));
    }


}
}