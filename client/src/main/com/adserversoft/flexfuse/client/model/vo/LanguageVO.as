package com.adserversoft.flexfuse.client.model.vo {
[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.Language")]
public dynamic class LanguageVO extends BaseVO {
    public var id:Object;
    public var languageAbbrSmall:String;
    public var languageName:String;

    public function get languageLabel():String {
        return languageName + ": [" + languageAbbrSmall + "]";
    }

    public function set languageLabel(s:String):void {
        trace(s);
    }
}
}