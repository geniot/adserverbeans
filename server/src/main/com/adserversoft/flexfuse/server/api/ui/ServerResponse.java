package com.adserversoft.flexfuse.server.api.ui;


import java.io.Serializable;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class ServerResponse  implements Serializable {
    public String result;
    public String message;
    public Object resultingObject;

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getResultingObject() {
        return resultingObject;
    }

    public void setResultingObject(Object resultingObject) {
        this.resultingObject = resultingObject;
    }
}
