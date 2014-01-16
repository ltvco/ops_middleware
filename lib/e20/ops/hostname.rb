require 'socket'

module E20
  module Ops
    class Hostname

      def to_s
        @hostname ||= Socket.gethostname.strip
      end

    end
  end
end
