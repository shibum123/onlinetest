/**
 * Generated by Gas3 v2.2.0 (Granite Data Services).
 *
 * WARNING: DO NOT CHANGE THIS FILE. IT MAY BE OVERWRITTEN EACH TIME YOU USE
 * THE GENERATOR.
 */

package com.catlin.cargo.model.core.originatingoffice {

    import org.granite.util.Enum;

    [Bindable]
    [RemoteClass(alias="com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode")]
    public class OriginatingOfficeCode extends Enum {

        public static const UK:OriginatingOfficeCode = new OriginatingOfficeCode("UK", _);
        public static const SG:OriginatingOfficeCode = new OriginatingOfficeCode("SG", _);
        public static const HK:OriginatingOfficeCode = new OriginatingOfficeCode("HK", _);
        public static const US:OriginatingOfficeCode = new OriginatingOfficeCode("US", _);

        function OriginatingOfficeCode(value:String = null, restrictor:* = null) {
            super((value || UK.name), restrictor);
        }

        override protected function getConstants():Array {
            return constants;
        }

        public static function get constants():Array {
            return [UK, SG, HK, US];
        }

        public static function valueOf(name:String):OriginatingOfficeCode {
            return OriginatingOfficeCode(UK.constantOf(name));
        }
    }
}