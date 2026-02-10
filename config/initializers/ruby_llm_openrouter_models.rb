Rails.application.config.to_prepare do
  singleton = RubyLLM::Models.singleton_class
  next if singleton.method_defined?(:resolve_without_openrouter_fallback)

  singleton.class_eval do
    alias_method :resolve_without_openrouter_fallback, :resolve

    def resolve(model_id, provider: nil, **kwargs)
      resolve_without_openrouter_fallback(model_id, provider: provider, **kwargs)
    rescue RubyLLM::ModelNotFoundError
      provider_name = provider&.to_s
      raise unless provider_name == 'openrouter'

      provider_class = RubyLLM::Provider.providers[provider_name.to_sym]
      raise unless provider_class

      model = RubyLLM::Model::Info.new(
        'id' => model_id,
        'name' => model_id,
        'provider' => provider_name,
        'source' => 'custom'
      )

      [model, provider_class]
    end
  end
end
