package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.SettingsProxy;

import flash.events.Event;

import mx.controls.Alert;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class InstallDBManagementCanvasMediator extends BaseMediator implements IMediator {
    private var settingsProxy:SettingsProxy;
    public static const NAME:String = 'InstallDBManagementCanvasMediator';

    public function InstallDBManagementCanvasMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);

        //                uiComponent.addEventListener(BaseCanvas.SHOW, onShow);
        uiComponent.addEventListener(BaseCanvas.INIT, onInit);
        uiComponent.addEventListener(InstallDBManagementCanvas.CREATE_DB, onCreateDB);
        settingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        onInit(null);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():InstallDBManagementCanvas {
        return viewComponent as InstallDBManagementCanvas;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.SERVER_FAULT

        ];
    }

    override public function handleNotification(note:INotification):void {
        ApplicationConstants.application.enabled = true;
        switch (note.getName()) {
            case ApplicationConstants.SERVER_FAULT:
                uiComponent.enabled = true;
                break;

        }
    }

    public function onCreateDB(event:Event):void {

        uiComponent.loginDB.text = ApplicationConstants.deleteWhiteSpaces(uiComponent.loginDB.text);
        uiComponent.passwordDB.text = ApplicationConstants.deleteWhiteSpaces(uiComponent.passwordDB.text);
        if (uiComponent.loginDB.text == "") {
            Alert.show("Please write login to DB!");

            uiComponent.loginDB.setFocus();

        } else if (uiComponent.passwordDB.text == "") {
            Alert.show("Please write password to DB!");

            uiComponent.passwordDB.setFocus();
        } else {
            uiComponent.enabled = false;
            var countDb:int = uiComponent.countDB.selectedIndex + 1;
            settingsProxy.createDb(countDb, uiComponent.loginDB.text, uiComponent.passwordDB.text);
        }
    }

    private function onInit(event:Event):void {
        uiComponent.loginDB.setFocus();
    }

}
}
