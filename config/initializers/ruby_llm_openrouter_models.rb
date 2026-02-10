Rails.application.config.to_prepare do
  Llm::Config.initialize!

  models = RubyLLM.models
  model_id = 'x-ai/grok-4.1-fast'
  provider = 'openrouter'

  next if models.all.any? { |model| model.id == model_id && model.provider == provider }

  template = models.all.find { |model| model.provider == provider } || models.all.first
  next unless template&.respond_to?(:to_h)

  data = template.to_h
  data['id'] = model_id
  data['name'] = model_id
  data['provider'] = provider
  data['source'] = 'custom'

  models.instance_variable_get(:@models) << RubyLLM::Model::Info.new(data)
end
