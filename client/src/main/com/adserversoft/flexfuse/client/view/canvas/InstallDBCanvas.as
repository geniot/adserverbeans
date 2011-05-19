package com.adserversoft.flexfuse.client.view.canvas
{
import com.adserversoft.flexfuse.client.model.vo.HashMap;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;

public class InstallDBCanvas extends BaseCanvas
{

    public var installDBManagementCanvas:InstallDBManagementCanvas;
    public var dbLog:ArrayCollection = new ArrayCollection(); 

    public function InstallDBCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

     public function updateDbLog():void{
        installDBManagementCanvas.dbLog = dbLog;
        installDBManagementCanvas.updateDbLog();
    }


    protected function onCreationComplete(event:Event):void {

    }


}
}
