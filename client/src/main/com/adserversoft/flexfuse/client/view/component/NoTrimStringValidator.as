package com.adserversoft.flexfuse.client.view.component {
import mx.validators.StringValidator;
import mx.validators.ValidationResult;

public class NoTrimStringValidator extends StringValidator {

    override protected function doValidation(value:Object):Array {
        var results:Array = [];

        var result:ValidationResult = validateRequired(value);
        if (result)
            results.push(result);

        // Return if there are errors
        // or if the required property is set to false and length is 0.
        var val:String = value ? String(value) : "";
        if (results.length > 0 || ((val.length == 0) && !required))
            return results;
        else
            return StringValidator.validateString(this, value, null);
    }

    private function validateRequired(value:Object):ValidationResult {
        if (required) {
            var val:String = (value != null) ? String(value) : "";

            //            val = trimString(val);

            // If the string is empty and required is set to true
            // then throw a requiredFieldError.
            if (val.length == 0) {
                return new ValidationResult(true, "", "requiredField",
                        requiredFieldError);
            }
        }

        return null;
    }
}
}
