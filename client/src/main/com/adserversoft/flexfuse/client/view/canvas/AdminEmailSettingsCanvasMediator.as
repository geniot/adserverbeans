package com.adserversoft.flexfuse.client.view.canvas
{

import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.UserProxy;

import flash.events.Event;

import mx.controls.Alert;

import org.puremvc.as3.interfaces.INotification;

public class AdminEmailSettingsCanvasMediator extends BaseMediator
{
    public static const NAME:String = 'AdminEmailSettingsCanvasMediator';
    private var userProxy:UserProxy;


    public function AdminEmailSettingsCanvasMediator(u:String, viewComponent:Object)
    {
        this.uid = u;
        super(NAME, viewComponent);
        userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        uiComponent.addEventListener(BaseCanvas.INIT, onInit);
    }


    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }


    private function onInit(event:Event):void {
        arr1 = new Array("smtpSubject", "smtpServer", "smtpPassword", "smtpUser","port","supportEmail","fromEmail");
        arr2 = new Array(uiComponent.emailSubjectTI, uiComponent.smtpServerTI, uiComponent.passwordTI, uiComponent.userNameTI,uiComponent.smtpServerPortTI,uiComponent.supportEmailTI,uiComponent.fromEmailTI);
        arr3 = new Array("text", "text", "text", "text", "text", "text", "text");
        bindFields(userProxy.user);
    }
                                       
    private function onDestroy(event:Event):void
    {
        Alert.show("onDestroy");
    }


    private function get uiComponent():AdminEmailSettingsCanvas
    {
        return viewComponent as AdminEmailSettingsCanvas;
    }

    override public function listNotificationInterests():Array {
        return [
        ];
    }

    override public function handleNotification(note:INotification):void {
        switch (note.getName())
        {

        }
    }


}
}