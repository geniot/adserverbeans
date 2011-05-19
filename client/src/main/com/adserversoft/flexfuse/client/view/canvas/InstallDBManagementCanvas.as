package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.vo.DataBaseStateVO;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import mx.collections.ArrayCollection;
import mx.containers.Form;
import mx.containers.Panel;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.FlexEvent;

public class InstallDBManagementCanvas extends BaseCanvas {

    public static const CREATE_DB:String = "CREATE_DB";

    public var dbLog:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var countDB:ComboBox;
    public var infoDB:DataGrid;
    public var infoDBC:DataGridColumn;
    public var loginDB:TextInput;
    public var passwordDB:TextInput;
    public var createDbBtn:Button;
    public var helpBtn:Button;
    public var loginP:Panel;

    public var userDataForm:Form;

    public function InstallDBManagementCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        createDbBtn.addEventListener(MouseEvent.CLICK, createDB);
        helpBtn.addEventListener(MouseEvent.CLICK, onHelp);
        dispatchEvent(new Event(INIT));
        addEventListener(FlexEvent.SHOW, onShow);
    }


    public function updateDbLog():void {
        var i:int = 1;
        var currentDataProvider:ArrayCollection = new ArrayCollection();
        for each (var currentDataBaseStateVO:DataBaseStateVO in dbLog) {
            //            if (i == 0) {
            //                infoDBC.headerText = currentString;
            //            } else {
            //                currentString = i + ". " + currentString;
            //                currentDataProvider.addItem(currentString);
            //            }
            currentDataBaseStateVO.id = i;
            i++;
            currentDataProvider.addItem(currentDataBaseStateVO);
        }
        var index:int = i - 2;
        countDB.selectedIndex = index;
        infoDB.dataProvider = currentDataProvider;
    }

    private function createDB(event:Event):void {
        dispatchEvent(new Event(CREATE_DB));
    }

    private function onHelp(event:Event):void {
        var urlRequest:URLRequest = new URLRequest("http://code.google.com/p/asb-myads/w/list");
        navigateToURL(urlRequest, "_blank");
    }

    protected function onShow(event:Event):void {
        dispatchEvent(new Event(SHOW));
    }
}
}
