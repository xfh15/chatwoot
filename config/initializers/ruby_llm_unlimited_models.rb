# Allow arbitrary model IDs (e.g., OpenRouter models not present in RubyLLM registry).
# This avoids RubyLLM::ModelNotFoundError for unknown models while keeping existing behavior
# when the model is known.
#
# NOTE: This is a deliberate override for deployments that manage model availability externally.
module RubyLLM
  class Models
    class << self
      alias_method :resolve_without_any_model, :resolve

      def resolve(model_id, provider: nil, assume_exists: false, config: nil)
        resolve_without_any_model(model_id, provider: provider, assume_exists: assume_exists, config: config)
      rescue RubyLLM::ModelNotFoundError
        # Create a minimal Model::Info to allow the request to proceed.
        model_info = RubyLLM::Model::Info.new(
          'id' => model_id.to_s,
          'provider' => (provider || 'openrouter').to_s,
          'name' => model_id.to_s
        )
        [model_info, model_info.provider]
      end
    end

    private

    # Instance-level helpers used by resolve; override to allow unknown models.
    def find_with_provider(model_id, provider)
      super
    rescue RubyLLM::ModelNotFoundError
      RubyLLM::Model::Info.new(
        'id' => model_id.to_s,
        'provider' => provider.to_s,
        'name' => model_id.to_s
      )
    end

    def find_without_provider(model_id)
      super
    rescue RubyLLM::ModelNotFoundError
      RubyLLM::Model::Info.new(
        'id' => model_id.to_s,
        'provider' => 'openrouter',
        'name' => model_id.to_s
      )
    end
  end
end
