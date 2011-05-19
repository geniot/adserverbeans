package com.adserversoft.flexfuse.client.view.component
{
import com.adserversoft.flexfuse.client.model.vo.AdFormatVO;

import mx.collections.IViewCursor;
import mx.controls.ComboBox;

public class FindSelectedItemComboBox extends ComboBox
{
    public function FindSelectedItemComboBox()
    {
        super();
    }

    override public function set selectedItem(value:Object):void
    {
        super.selectedItem = value;
        if (value != null && selectedIndex == -1)
        {
            // do a painful search;
            if (collection && collection.length)
            {
                var cursor:IViewCursor = collection.createCursor();
                while (!cursor.afterLast)
                {
                    var obj:Object = cursor.current;
                    var nope:Boolean = false;


                    if (value is AdFormatVO && obj is AdFormatVO) {
                        var af1:AdFormatVO = value as AdFormatVO;
                        var af2:AdFormatVO = obj as AdFormatVO;
                        if (af1.adFormatName as String != af2.adFormatName as String) {
                            nope = true;
                        }
                    } else {
                        for (var p:String in value)
                        {
                            if (obj[p] !== value[p])
                            {
                                nope = true;
                                break;
                            }
                        }
                    }

                    if (!nope)
                    {
                        super.selectedItem = obj;
                        return;
                    }

                    cursor.moveNext();
                }
            }
        }
    }
}
}
