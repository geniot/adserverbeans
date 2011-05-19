package com.adserversoft.flexfuse.client.view.viewstack {
import com.adserversoft.flexfuse.client.view.canvas.AdminManagementCanvas;

import com.adserversoft.flexfuse.client.view.canvas.GuestManagementCanvasUI;

import com.adserversoft.flexfuse.client.view.canvas.InstallDBCanvas;
import com.adserversoft.flexfuse.client.view.canvas.LoginCanvasUI;

import flash.events.Event;

import mx.containers.Canvas;
import mx.containers.ViewStack;
import mx.events.FlexEvent;


public class MainPanelViewStack extends ViewStack{
    public static const INIT:String = "INIT";
    public var adminManagementCanvas:AdminManagementCanvas;
    public var loginCanvas:LoginCanvasUI;
    public var installDBCanvas:InstallDBCanvas;

    public function MainPanelViewStack()
    {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    private function onCreationComplete(event:Event):void {
        dispatchEvent(new Event(INIT));
    }


}
}