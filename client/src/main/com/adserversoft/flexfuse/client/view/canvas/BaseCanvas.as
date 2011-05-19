package com.adserversoft.flexfuse.client.view.canvas {

import com.adserversoft.flexfuse.client.model.ApplicationConstants;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.system.Capabilities;

import flash.ui.Keyboard;

import mx.containers.Canvas;
import mx.core.UIComponent;
import mx.events.CloseEvent;

public class BaseCanvas extends Canvas {

    public static const INIT:String = "INIT";
    public static const HIDE:String = "HIDE";
    public static const SHOW:String = "SHOW";
    public static const ITEM_CLICK:String = "ITEM_CLICK";
    public static const ITEM_DOUBLE_CLICK:String = "ITEM_DOUBLE_CLICK";
    public static const INDEX_CHANGED_EVENT:String = 'INDEX_CHANGED_EVENT';
    public static const SAVE:String = "SAVE";
    public static const CANCEL:String = "CANCEL";

    [Bindable]
    public var mode:String = ApplicationConstants.CREATE;
    public var invalidField:UIComponent;

    public function BaseCanvas() {
        super();
    }

    public function onAlertClose(event:CloseEvent):void {
        if (invalidField != null) invalidField.setFocus();
    }

    public function keyup(e:KeyboardEvent):void {
        if (e.keyCode == Keyboard.ESCAPE) {
            dispatchEvent(new Event(CANCEL));
        } else if (e.keyCode == Keyboard.ENTER) {
            dispatchEvent(new Event(SAVE));
        }
    }

    public function correctLinux(e:Event):void
    {
        if (Capabilities.os.indexOf('Linux') == -1) {
            return;
        }
        var str:String = e.currentTarget.text;

        str = str.replace("Ñ‘", "ё");
        str = str.replace("Ð", "Ё");

        str = str.replace("Ð¹", "й");
        str = str.replace("Ñ†", "ц");
        str = str.replace("Ñƒ", "у");
        str = str.replace("Ðº", "к");
        str = str.replace("Ðµ", "е");
        str = str.replace("Ð½", "н");
        str = str.replace("Ð³", "г");
        str = str.replace("Ñˆ", "ш");
        str = str.replace("Ñ‰", "щ");
        str = str.replace("Ð·", "з");
        str = str.replace("Ñ…", "х");
        str = str.replace("ÑŠ", "ъ");

        str = str.replace("Ð™", "Й");
        str = str.replace("Ð¦", "Ц");
        str = str.replace("Ð£", "У");
        str = str.replace("Ðš", "К");
        str = str.replace("Ð•", "Е");
        str = str.replace("Ð", "Н");
        str = str.replace("Ð“", "Г");
        str = str.replace("Ð¨", "Ш");
        str = str.replace("Ð©", "Щ");
        str = str.replace("Ð—", "З");
        str = str.replace("Ð¥", "Х");
        str = str.replace("Ðª", "Ъ");

        str = str.replace("Ñ„", "ф");
        str = str.replace("Ñ‹", "ы");
        str = str.replace("Ð²", "в");
        str = str.replace("Ð°", "а");
        str = str.replace("Ð¿", "п");
        str = str.replace("Ñ€", "р");
        str = str.replace("Ð¾", "о");
        str = str.replace("Ð»", "л");
        str = str.replace("Ð´", "д");
        str = str.replace("Ð¶", "ж");
        str = str.replace("Ñ", "э");

        str = str.replace("Ð¤", "Ф");
        str = str.replace("Ð«", "Ы");
        str = str.replace("Ð’", "В");
        str = str.replace("Ð", "А");
        str = str.replace("ÐŸ", "П");
        str = str.replace("Ð ", "Р");
        str = str.replace("Ðž", "О");
        str = str.replace("Ð›", "Л");
        str = str.replace("Ð”", "Д");
        str = str.replace("Ð–", "Ж");
        str = str.replace("Ð­", "Э");

        str = str.replace("Ñ", "я");
        str = str.replace("Ñ‡", "ч");
        str = str.replace("Ñ", "с");
        str = str.replace("Ð¼", "м");
        str = str.replace("Ð¸", "и");
        str = str.replace("Ñ‚", "т");
        str = str.replace("ÑŒ", "ь");
        str = str.replace("Ð±", "б");
        str = str.replace("ÑŽ", "ю");

        str = str.replace("Ð¯", "Я");
        str = str.replace("Ð§", "Ч");
        str = str.replace("Ð¡", "С");
        str = str.replace("Ðœ", "М");
        str = str.replace("Ð˜", "И");
        str = str.replace("Ð¢", "Т");
        str = str.replace("Ð¬", "Ь");
        str = str.replace("Ð‘", "Б");
        str = str.replace("Ð®", "Ю");


        e.currentTarget.text = str;
    }
}
}