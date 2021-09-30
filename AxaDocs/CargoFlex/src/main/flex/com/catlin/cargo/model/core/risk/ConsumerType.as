/**
 * Generated by Gas3 v2.2.0 (Granite Data Services).
 *
 * WARNING: DO NOT CHANGE THIS FILE. IT MAY BE OVERWRITTEN EACH TIME YOU USE
 * THE GENERATOR.
 */

package com.catlin.cargo.model.core.risk {

    import org.granite.util.Enum;

    [Bindable]
    [RemoteClass(alias="com.catlin.cargo.model.core.risk.ConsumerType")]
    public class ConsumerType extends Enum {

        public static const CONSUMER:ConsumerType = new ConsumerType("CONSUMER", _);
        public static const NON_CONSUMER:ConsumerType = new ConsumerType("NON_CONSUMER", _);

        function ConsumerType(value:String = null, restrictor:* = null) {
            super((value || CONSUMER.name), restrictor);
        }

        override protected function getConstants():Array {
            return constants;
        }

        public static function get constants():Array {
            return [CONSUMER, NON_CONSUMER];
        }

        public static function valueOf(name:String):ConsumerType {
            return ConsumerType(CONSUMER.constantOf(name));
        }
    }
}