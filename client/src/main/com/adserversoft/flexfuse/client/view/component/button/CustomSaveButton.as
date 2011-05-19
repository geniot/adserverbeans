package com.adserversoft.flexfuse.client.view.component.button {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;

import mx.controls.Button;

public class CustomSaveButton extends Button {

    public function CustomSaveButton() {
        super();
    }

    override public function set enabled(value:Boolean):void {
        if (super.enabled == value) {
            return;
        }
        this.alpha = value ? ApplicationConstants.ALPHA_ACTIVE : ApplicationConstants.ALPHA_INACTIVE;
        super.enabled = value;
    }
}
}