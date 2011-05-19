package com.adserversoft.flexfuse.client.view.viewstack {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.UserProxy;
import com.adserversoft.flexfuse.client.model.vo.UserVO;
import com.adserversoft.flexfuse.client.view.canvas.AdminManagementCanvasMediator;
import com.adserversoft.flexfuse.client.view.canvas.GuestManagementCanvasMediator;

import com.adserversoft.flexfuse.client.view.canvas.InstallDBCanvasMediator;
import com.adserversoft.flexfuse.client.view.canvas.LoginCanvasMediator;

import mx.collections.ArrayCollection;
import mx.core.Application;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;

public class MainPanelViewStackMediator extends BaseMediator implements IMediator {
    private var userProxy:UserProxy;
    public static const NAME:String = 'MainPanelViewStackMediator';

    public function MainPanelViewStackMediator(u:String, viewComponent:Object) {
        this.uid = u;
        super(NAME, viewComponent);
        userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
        registerMediator(NAME, LoginCanvasMediator, LoginCanvasMediator.NAME, uiComponent.loginCanvas);
        registerMediator(NAME, AdminManagementCanvasMediator, AdminManagementCanvasMediator.NAME, uiComponent.adminManagementCanvas);
        registerMediator(NAME, InstallDBCanvasMediator, InstallDBCanvasMediator.NAME, uiComponent.installDBCanvas);
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }


    public function get uiComponent():MainPanelViewStack {
        return viewComponent as MainPanelViewStack;
    }

    override public function listNotificationInterests():Array {
        return [
            ApplicationConstants.USER_LOGGED_IN,
            ApplicationConstants.USER_LOGGED_OUT,
            ApplicationConstants.SETTINGS_LOADED,
            ApplicationConstants.USER_LOGIN_FAILED,
            ApplicationConstants.DB_FAILURE
        ];
    }

    override public function handleNotification(note:INotification):void {
        switch (note.getName()) {
            case ApplicationConstants.USER_LOGIN_FAILED:
                uiComponent.selectedChild = uiComponent.loginCanvas;
                break;
            case ApplicationConstants.DB_FAILURE:
                uiComponent.selectedChild = uiComponent.installDBCanvas;
                uiComponent.installDBCanvas.dbLog = note.getBody() as ArrayCollection;
                uiComponent.installDBCanvas.updateDbLog();
                break;
            case ApplicationConstants.USER_LOGGED_IN:
                uiComponent.selectedChild = uiComponent.adminManagementCanvas;
                ApplicationConstants.application.enabled = true;
                break;
            case ApplicationConstants.USER_LOGGED_OUT:
                uiComponent.selectedChild = uiComponent.loginCanvas;
                ApplicationConstants.application.enabled = true;
                break;
            case ApplicationConstants.SETTINGS_LOADED:
                ApplicationConstants.application.enabled = true;
                //used for testing
                //                                var u:UserVO = new UserVO();
                //                                u.email = "admin@gmail.com";
                //                                u.password = "admin";
                //                                userProxy.login(u);

                //used for testing
                //                var m:TopLinksViewStackMediator = TopLinksViewStackMediator(facade.retrieveMediator(TopLinksViewStackMediator.NAME));
                //                m.onRegisterUser(null);

                break;

        }
    }
}
}
