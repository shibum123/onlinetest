/**
 * Generated by Gas3 v2.2.0 (Granite Data Services).
 *
 * WARNING: DO NOT CHANGE THIS FILE. IT MAY BE OVERWRITTEN EACH TIME YOU USE
 * THE GENERATOR.
 */

package com.catlin.cargo.model.reference.financialregulation {

    import org.granite.util.Enum;

    [Bindable]
    [RemoteClass(alias="com.catlin.cargo.model.reference.financialregulation.RegulationControlType")]
    public class RegulationControlType extends Enum {

        public static const CONSUMER_BUSINESS_CONTROL:RegulationControlType = new RegulationControlType("CONSUMER_BUSINESS_CONTROL", _);

        function RegulationControlType(value:String = null, restrictor:* = null) {
            super((value || CONSUMER_BUSINESS_CONTROL.name), restrictor);
        }

        override protected function getConstants():Array {
            return constants;
        }

        public static function get constants():Array {
            return [CONSUMER_BUSINESS_CONTROL];
        }

        public static function valueOf(name:String):RegulationControlType {
            return RegulationControlType(CONSUMER_BUSINESS_CONTROL.constantOf(name));
        }
    }
}