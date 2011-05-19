package com.adserversoft.flexfuse.client.model.vo
{

[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.User")]
public dynamic class UserVO extends BaseVO
{
    public var email:String;
    public var id:Object;
    public var password:String;
    public var confirmPassword:String;
    public var firstName:String;
    public var lastName:String;
    public var sessionId:String;
    public var filename:String;

    public var smtpSubject:String;
    public var smtpServer:String;
    public var smtpPassword:String;
    public var smtpUser:String;
    public var port:int;
    public var supportEmail:String;
    public var fromEmail:String;   

    public var passwordReset:Boolean = false;

    public function UserVO(){
    }

    public function reset():void {
        email = null;
        password = null;
    }
}
}