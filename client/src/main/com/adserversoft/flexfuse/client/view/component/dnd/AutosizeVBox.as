package com.adserversoft.flexfuse.client.view.component.dnd {
import mx.containers.VBox;
import mx.core.Container;
import mx.core.UIComponent;

public class AutosizeVBox extends VBox {
    public function AutosizeVBox() {
        super();
    }

    override protected function measure():void {
        super.measure();
        var nh:int = 0;
        var nw:int = 0;
        for (var n:int = 0; n < this.numChildren; n++) {
            var c:UIComponent = this.getChildAt(n) as UIComponent;
            if (c is Container) {
                var cc:Container = c as Container;
                nh += /*cc.viewMetricsAndPadding.top + */cc.viewMetricsAndPadding.bottom + c.height;
                nw = Math.max(nw, cc.viewMetricsAndPadding.left + cc.viewMetricsAndPadding.right + c.width);
            }
            else {
                nh += c.height;
                nw = Math.max(c.width, nw);
            }
        }
        this.measuredWidth = nw;
        this.measuredHeight = nh;
    }
}
}
