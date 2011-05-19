package com.adserversoft.flexfuse.client
{

import com.adserversoft.flexfuse.client.controller.ServerFaultCommand;
import com.adserversoft.flexfuse.client.controller.StartupCommand;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;

import org.puremvc.as3.interfaces.IFacade;
import org.puremvc.as3.patterns.facade.Facade;

public class ApplicationFacade extends Facade implements IFacade
{


    /**
     * Singleton ApplicationFacade Factory Method
     */
    public static function getInstance():ApplicationFacade {
        if (instance == null) instance = new ApplicationFacade();
        return instance as ApplicationFacade;
    }


    /**
     * Start the application
     */
    public function startup(app:Object):void
    {
        sendNotification(ApplicationConstants.STARTUP, app);
    }

    /**
     * Register Commands with the Controller
     */
    override protected function initializeController():void
    {
        super.initializeController();
        registerCommand(ApplicationConstants.STARTUP, StartupCommand);
        registerCommand(ApplicationConstants.SERVER_FAULT, ServerFaultCommand);
    }

}
}

