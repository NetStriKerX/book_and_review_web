RSpec::Matchers.define_negated_matcher :not_change, :not_change

Shoulda::Matchers.configure do |config|
    config.integrate do |with|
        with.test_framework :rspec
        with.library :rails
    end
end
