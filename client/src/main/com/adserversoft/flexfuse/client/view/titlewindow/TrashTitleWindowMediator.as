package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.StateProxy;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class TrashTitleWindowMediator extends BaseMediator implements IMediator {
    public static const NAME:String = 'TrashTitleWindowMediator';
    private var stateProxy:StateProxy;

    function TrashTitleWindowMediator(u:String, viewComponent:Object) {

        this.uid = u;
        super(NAME, viewComponent);

        if (UIComponent(viewComponent).initialized) {
            onInit(null);
        } else {
            UIComponent(viewComponent).addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
        }
    }

    private function onInit(event:Event):void {
        stateProxy = facade.retrieveProxy(StateProxy.NAME) as StateProxy;
        stateProxy.loadTrashState();
        registerMediators();
        addEventListeners();
    }

    private function registerMediators():void {

    }

    override public function unregisterMediators():void {

    }

    public override function addEventListeners():void {
        uiComponent.addEventListener(BaseTitleWindow.CANCEL, onClose);

    }

    public override function removeEventListeners():void {
        uiComponent.removeEventListener(BaseTitleWindow.CANCEL, onClose);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():TrashTitleWindow {
        return viewComponent as TrashTitleWindow;
    }


    private function onClose(event:Event):void {
        removeEventListeners();
        unregisterMediators();
        PopManager.closePopUpWindow(uiComponent, getMediatorName());
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.TRASH_STATE_LOADED
        ];
    }


    override public function handleNotification(note:INotification):void {
        PopManager.setEnabledStateToPopUp(true, SettingsTitleWindowMediator);
        switch (note.getName()) {
            case ApplicationConstants.TRASH_STATE_LOADED:
                uiComponent.trashDataGrid.dataProvider = stateProxy.trashState.trashedObjects;
                break;

        }
    }

}
}
