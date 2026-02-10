# Allow arbitrary model IDs (e.g., OpenRouter models not present in RubyLLM registry).
# This avoids RubyLLM::ModelNotFoundError for unknown models while keeping existing behavior
# when the model is known.
#
# NOTE: This is a deliberate override for deployments that manage model availability externally.
module RubyLLM
  class Models
    # Prepend instance methods to override model lookup behavior.
    module UnlimitedModelsLookup
      private

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

    # Prepend class methods to override resolve behavior safely.
    module UnlimitedModelsResolve
      def resolve(model_id, provider: nil, assume_exists: false, config: nil)
        super
      rescue RubyLLM::ModelNotFoundError
        model_info = RubyLLM::Model::Info.new(
          'id' => model_id.to_s,
          'provider' => (provider || 'openrouter').to_s,
          'name' => model_id.to_s
        )
        [model_info, model_info.provider]
      end
    end

    prepend UnlimitedModelsLookup
    singleton_class.prepend UnlimitedModelsResolve
  end
end
