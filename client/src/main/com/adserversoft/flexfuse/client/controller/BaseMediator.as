package com.adserversoft.flexfuse.client.controller {
import mx.binding.utils.BindingUtils;
import mx.core.UIComponent;
import mx.validators.StringValidator;

import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.patterns.mediator.Mediator;

public class BaseMediator  extends Mediator implements IMediator {
    protected var arr1:Array;
    protected var arr2:Array;
    protected var arr3:Array;

    protected var uid:String;

    public function BaseMediator(n:String, viewComponent:Object) {
        super(n, viewComponent);
    }


    /**
     * Ensuring that only one mediator instance is registered for a ui component
     * @param mediator
     * @param name
     * @param uc
     */
    protected function registerMediator(uid:String, mediatorClass:Class, name:String, uc:Object):void {
        var mediatorName:String = uid + "::" + name;
        var m:BaseMediator = BaseMediator(facade.retrieveMediator(mediatorName));
        if (m == null || m.viewComponent != uc) {
            m = new mediatorClass(uid, uc);
            facade.registerMediator(m);
        }
    }

    protected function retrieveMediator(uid:String, name:String):BaseMediator {
        var mediatorName:String = uid + "::" + name;
        var m:BaseMediator = BaseMediator(facade.retrieveMediator(mediatorName));
        return m;
    }

    protected function unregisterMediator(uid:String, mediatorClass:Class):void {
        var mediatorName:String = uid + "::" + mediatorClass.NAME;
        if (facade.hasMediator(mediatorName)) {
            var m:BaseMediator = BaseMediator(facade.retrieveMediator(mediatorName));
            m.removeEventListeners();
            m.unregisterMediators();
            facade.removeMediator(mediatorName);
        }
    }


    public function unregisterMediators():void {


    }

    public function addEventListeners():void {


    }

    public function removeEventListeners():void {


    }

    protected function bindFields(o:Object):void {
        for (var i:int = 0; i < arr1.length; i++) {
            BindingUtils.bindProperty(arr2[i], arr3[i], o, arr1[i]);
            BindingUtils.bindProperty(o, arr1[i], arr2[i], arr3[i]);
        }
    }


    protected function setValidator(stringValidator:StringValidator, s:UIComponent):void {
        stringValidator.minLength = 2;
        stringValidator.maxLength = 100;
        stringValidator.required = true;
        stringValidator.source = s;
        stringValidator.property = "text";
    }
}
}