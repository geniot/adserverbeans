package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;

import flash.events.Event;

import org.puremvc.as3.interfaces.IMediator;

public class InstallDBCanvasMediator extends BaseMediator implements IMediator {
    public static const NAME:String = 'InstallDBCanvasMediator';


    public function InstallDBCanvasMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);
        registerMediator(NAME, InstallDBManagementCanvasMediator, InstallDBManagementCanvasMediator.NAME, uiComponent.installDBManagementCanvas);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():InstallDBCanvas {
        return viewComponent as InstallDBCanvas;
    }

}
}
