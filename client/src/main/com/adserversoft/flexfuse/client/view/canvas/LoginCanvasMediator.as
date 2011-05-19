package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;

import flash.events.Event;

import org.puremvc.as3.interfaces.IMediator;

public class LoginCanvasMediator extends BaseMediator implements IMediator {
    public static const NAME:String = 'LoginCanvasMediator';


    public function LoginCanvasMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);
        registerMediator(NAME, GuestManagementCanvasMediator, GuestManagementCanvasMediator.NAME, uiComponent.guestManagementCanvas);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }


    private function get uiComponent():LoginCanvas {
        return viewComponent as LoginCanvas;
    }



}
}
