package com.adserversoft.flexfuse.client.view.canvas
{
import flash.events.Event;

import mx.events.FlexEvent;

public class LoginCanvas extends BaseCanvas
{

    public var guestManagementCanvas:GuestManagementCanvas;

    public function LoginCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }


    protected function onCreationComplete(event:Event):void {

    }


}
}
