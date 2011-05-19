package com.adserversoft.flexfuse.client.view.component.dnd {
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.MouseEvent;

import mx.containers.Box;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.core.BitmapAsset;
import mx.core.DragSource;
import mx.core.UIComponent;
import mx.events.DragEvent;
import mx.managers.DragManager;

public class DraggableControl extends VBox {
    public static var INDICATOR_UPPER:String = "INDICATOR_UPPER";
    public static var INDICATOR_LOWER:String = "INDICATOR_LOWER";

    public function DraggableControl() {
        percentWidth = 100;
        setStyle("verticalGap", "0");

        addEventListener(DragEvent.DRAG_ENTER, doDragEnter);
        addEventListener(DragEvent.DRAG_EXIT, doDragExit);
        addEventListener(DragEvent.DRAG_DROP, doDragDrop);
        addEventListener(DragEvent.DRAG_COMPLETE, doDragComplete);
    }

    protected function doDragEnter(event:DragEvent):void {
    }

    protected function doDragExit(event:DragEvent):void {
        var draggableControl:DraggableControl = event.currentTarget as DraggableControl;
        draggableControl.removeDropIndicators();
        DragManager.acceptDragDrop(draggableControl);
    }

    protected function doDragDrop(event:DragEvent):void {
        var draggedDC:DraggableControl = event.dragInitiator.parent as DraggableControl;
        var droppedDC:DraggableControl = event.currentTarget as DraggableControl;
        if (draggedDC != droppedDC) {
            var indexDroppedDC:int = droppedDC.parent.getChildIndex(droppedDC);
            if (droppedDC.indicatorPos == INDICATOR_LOWER) {
                var childrenLength:int = Box(droppedDC.parent).getChildren().length;
                indexDroppedDC = indexDroppedDC > childrenLength - 3 ? childrenLength - 3 : indexDroppedDC;
                droppedDC.parent.addChildAt(draggedDC, indexDroppedDC + 1);
            } else {
                indexDroppedDC = indexDroppedDC < 1 ? 0 : indexDroppedDC - 1;
                droppedDC.parent.addChildAt(draggedDC, indexDroppedDC);
            }
        }
        draggedDC.removeDropIndicators();
        droppedDC.removeDropIndicators();
    }

    protected function doDragComplete(event:DragEvent):void {
        if (parent != null) {
            for each (var iDisplayObject:DisplayObject in Box(parent).getChildren()) {
                if (iDisplayObject is DraggableControl) {
                    DraggableControl(iDisplayObject).removeDropIndicators();
                }
            }
        }
    }

    protected function doMouseMove(event:MouseEvent):void {
        var dragInitiator:UIComponent = event.currentTarget.parent.parent as UIComponent;

        var dragSource:DragSource = new DragSource();
        var hBox:HBox = event.currentTarget.parent as HBox;
        dragSource.addData(hBox, 'item');

        var dragImage:BitmapAsset = new BitmapAsset();
        dragImage.bitmapData = new BitmapData(hBox.width, hBox.height);
        dragImage.bitmapData.draw(hBox);

        DragManager.doDrag(dragInitiator, dragSource, event, dragImage);
    }


    protected function get indicatorPos():String {
        var arr:Array = getChildren();
        return arr[0] is DropIndicator ? INDICATOR_UPPER :INDICATOR_LOWER;
    }

    protected function removeDropIndicators():void {
        for each (var iDisplayObject:DisplayObject in getChildren()) {
            if (iDisplayObject is DropIndicator) {
                removeChild(iDisplayObject);
            }
        }
    }
}
}