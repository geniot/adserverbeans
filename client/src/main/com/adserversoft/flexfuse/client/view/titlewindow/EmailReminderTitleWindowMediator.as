package com.adserversoft.flexfuse.client.view.titlewindow {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.controller.PopManager;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.UserProxy;

import flash.events.Event;
import flash.events.KeyboardEvent;

import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class EmailReminderTitleWindowMediator extends BaseMediator implements IMediator {
    private var userProxy:UserProxy;
    public static const NAME:String = 'EmailReminderTitleWindowMediator';
    private var invalidField:UIComponent;

    public function EmailReminderTitleWindowMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);


        if (UIComponent(viewComponent).initialized) {
            onInit(null);
        } else {
            UIComponent(viewComponent).addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
        }
    }

    public function onKeyboardPress(e:KeyboardEvent):void {
        const KEYCODE_ESCAPE:int = 27;
        if (e.keyCode == KEYCODE_ESCAPE) {
            onClose(null);
        }
    }


    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():EmailReminderTitleWindow {
        return viewComponent as EmailReminderTitleWindow;
    }


    private function onFailure(event:Event):void {
        uiComponent.enabled = true;
    }

    private function onClose(event:Event):void {
        PopManager.closePopUpWindow(uiComponent, getMediatorName());
    }

    private function onRemindEmail(event:Event):void {
        uiComponent.enabled = false;
        if (uiComponent.validateForRemind() != ValidationResultEvent.VALID) {
            uiComponent.enabled = true;
            return;
        }
        userProxy.remindEmail(uiComponent.firstNameTI.text, uiComponent.lastNameTI.text);
    }

    private function onInit(event:Event):void {

        userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;

        uiComponent.addEventListener(BaseTitleWindow.CLOSE_POPUP, onClose);
        uiComponent.addEventListener(EmailReminderTitleWindow.REMIND_EMAIL, onRemindEmail);
        uiComponent.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardPress);

        uiComponent.firstNameTI.setFocus();
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.EMAIL_REMINDED,
            ApplicationConstants.SERVER_FAULT
        ];
    }

    override public function handleNotification(note:INotification):void {
        uiComponent.enabled = true;
        switch (note.getName()) {

            case ApplicationConstants.SERVER_FAULT:
                uiComponent.enabled = true;
                break;
            case ApplicationConstants.EMAIL_REMINDED:
                onClose(null);
                break;
        }
    }
}
}