package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.view.canvas.GuestManagementCanvasMediator;
import com.adserversoft.flexfuse.client.view.viewstack.MainPanelViewStackMediator;

import flash.events.Event;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class LoginTitleWindowMediator extends BaseMediator implements IMediator {
    public static const NAME:String = 'LoginTitleWindowMediator';


    function LoginTitleWindowMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);
        registerMediators();
        uiComponent.addEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.addEventListener(BaseTitleWindow.CANCEL, onClose);
        uiComponent.addEventListener(BaseTitleWindow.SAVE, onLogin);
    }


    private function registerMediators():void {
        registerMediator(NAME, GuestManagementCanvasMediator, GuestManagementCanvasMediator.NAME, uiComponent.guestManagementCanvas);
    }

    override public function unregisterMediators():void {
        unregisterMediator(NAME, GuestManagementCanvasMediator);
    }


    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():LoginTitleWindow {
        return viewComponent as LoginTitleWindow;
    }


    private function onClose(event:Event):void {
        unregisterMediators();
        PopManager.closePopUpWindow(uiComponent, getMediatorName());
    }

    private function onLogin(event:Event):void {
        var gmcm:GuestManagementCanvasMediator = retrieveMediator(NAME, GuestManagementCanvasMediator.NAME) as GuestManagementCanvasMediator;
        gmcm.onLogin(null);
    }


    override public function listNotificationInterests():Array {
        return [  ApplicationConstants.RELOGIN
        ];
    }


    override public function handleNotification(note:INotification):void {
        switch (note.getName()) {
            case ApplicationConstants.RELOGIN:
                onClose(null);
                ApplicationConstants.application.enabled = true;
                break;
        }
    }

}
}
