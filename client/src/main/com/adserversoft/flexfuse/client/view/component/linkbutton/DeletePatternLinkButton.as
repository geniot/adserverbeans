package com.adserversoft.flexfuse.client.view.component.linkbutton {

import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import flash.events.Event;
import flash.events.MouseEvent;
import mx.controls.DataGrid;
import mx.controls.LinkButton;

public class DeletePatternLinkButton extends LinkButton {
    [Embed(source="/images/del.gif")]
    [Bindable]
    public var iconDelete:Class;

    public function DeletePatternLinkButton() {
        super();
        this.addEventListener(MouseEvent.CLICK, click);
        this.setStyle("icon", iconDelete);
        this.toolTip = "Remove";
    }

    private function click(event:Event):void {
        var body:Object;
        var dg:DataGrid=this.owner as DataGrid;      
        body=dg.dataProvider.getItemAt(this.listData.rowIndex);
        ApplicationFacade.getInstance().sendNotification(ApplicationConstants.DELETE_PATTERN, body);
    }

    override public function set data(value:Object):void {
    }

}
}