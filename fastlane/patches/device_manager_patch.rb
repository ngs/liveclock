# frozen_string_literal: true

# Monkey patch for fastlane 2.228.0 to fix iOS 26.0 simulator detection issue

require 'open3'

module FastlaneCore
  class DeviceManager
    class << self
      # Override the problematic method to handle nil case properly
      alias_method :original_latest_simulator_version_for_device, :latest_simulator_version_for_device if method_defined?(:latest_simulator_version_for_device)

      def latest_simulator_version_for_device(device)
        matching_simulators = simulators.select { |s| s.name == device }

        # Return nil if no matching simulators found
        return nil if matching_simulators.empty?

        # Sort by OS version and return the latest
        matching_simulators
          .sort_by { |s| Gem::Version.create(s.os_version) }
          .last
          &.os_version
      end
    end
  end
end

# Patch loaded successfully