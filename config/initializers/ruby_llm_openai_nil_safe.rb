# frozen_string_literal: true

Rails.application.config.to_prepare do
  capabilities = RubyLLM::Providers::OpenAI::Capabilities
  next if capabilities.instance_methods.include?(:model_family_without_nil_guard)

  capabilities.module_eval do
    alias_method :model_family_without_nil_guard, :model_family
    alias_method :input_price_for_without_nil_guard, :input_price_for
    alias_method :cached_input_price_for_without_nil_guard, :cached_input_price_for
    alias_method :output_price_for_without_nil_guard, :output_price_for
    alias_method :model_type_without_nil_guard, :model_type
    alias_method :modalities_for_without_nil_guard, :modalities_for
    alias_method :capabilities_for_without_nil_guard, :capabilities_for
    alias_method :pricing_for_without_nil_guard, :pricing_for

    def model_family(model_id)
      model_family_without_nil_guard(model_id.to_s)
    end

    def input_price_for(model_id)
      input_price_for_without_nil_guard(model_id.to_s)
    end

    def cached_input_price_for(model_id)
      cached_input_price_for_without_nil_guard(model_id.to_s)
    end

    def output_price_for(model_id)
      output_price_for_without_nil_guard(model_id.to_s)
    end

    def model_type(model_id)
      model_type_without_nil_guard(model_id.to_s)
    end

    def modalities_for(model_id)
      modalities_for_without_nil_guard(model_id.to_s)
    end

    def capabilities_for(model_id)
      capabilities_for_without_nil_guard(model_id.to_s)
    end

    def pricing_for(model_id)
      pricing_for_without_nil_guard(model_id.to_s)
    end
  end

  capabilities.singleton_class.class_eval do
    unless method_defined?(:normalize_temperature_without_nil_guard)
      alias_method :normalize_temperature_without_nil_guard, :normalize_temperature

      def normalize_temperature(temperature, model_id)
        normalize_temperature_without_nil_guard(temperature, model_id.to_s)
      end
    end
  end
end
