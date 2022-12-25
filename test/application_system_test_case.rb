require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Run tests headlessly
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
end
