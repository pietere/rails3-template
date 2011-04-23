
    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec, :fixture => true
      g.view_specs :false
      g.helper_specs :false
      g.integration_tool :cucumber
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    config.logger = Logger.new(config.paths.log.first, 50, 1048576)
