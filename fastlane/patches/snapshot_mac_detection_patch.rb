# frozen_string_literal: true

# Monkey patch to prevent snapshot from detecting this as a Mac-only project
# This allows iOS device screenshots to work properly with iOS 26.0

module FastlaneCore
  class Project
    # Override mac? to always return false for snapshot
    alias_method :original_mac?, :mac? if method_defined?(:mac?)

    def mac?
      # Check if we're being called from snapshot context
      caller_locations = caller
      if caller_locations.any? { |loc| loc.to_s.include?('snapshot') }
        # Return false when called from snapshot to prevent device override
        return false
      end

      # Return original value for other contexts
      original_mac?
    end
  end
end

# Patch loaded successfully