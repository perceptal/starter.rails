group :frontend do

  guard :bundler do
    watch('Gemfile')
  end

  guard :pow do
    watch('.rvmrc')
    watch(%r{^\.pow(rc|env)$})
    watch('Gemfile.lock')
    watch(%r{^config/.+\.rb$})
  end

  guard :livereload do
    watch(%r{^app/.+\.(slim)})
    watch(%r{^app/helpers/.+\.rb})
    watch(%r{^public/.+\.(css|js|html)})
    watch(%r{^app/assets/.+\.(css|js|sass|html|png)})
    watch(%r{^vendor/assets/.+\.(css|js|sass|html|png)})
    watch(%r{^config/locales/.+\.yml})
  end

end

group :backend do

  guard :spork, :wait => 50 do
    watch('Gemfile')
    watch('Gemfile.lock')
    watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.+\.rb})
    watch(%r{^config/initializers/.+\.rb})
    watch('spec/spec_helper.rb')
		watch(%r{^spec/factories/.+\.rb})
  end

	group 'js' do
	  guard 'jasmine' do
	    watch(%r{app/assets/javascripts/app/index\.js\.coffee$})  { "spec/javascripts" }
	    watch(%r{app/assets/javascripts/app/(.+)\.js\.coffee$})   { |m| "spec/javascripts/#{m[1]}_spec.js.coffee" }
	    watch(%r{spec/javascripts/(.+)_spec\.js\.coffee$})        { |m| "spec/javascripts/#{m[1]}_spec.js.coffee" }
	    watch(%r{spec/javascripts/spec\.js$})                     { "spec/javascripts" }
	    watch(%r{spec/javascripts/spec_helper\.js$})              { "spec/javascripts" }
	    watch(%r{spec/javascripts/jasmine-app.*})                 { "spec/javascripts" }
	  end
	end


  guard :rspec, :version => 2, :cli => "--color --drb", :bundler => false, :all_after_pass => false, :all_on_start => true, :keep_failed => false do
    watch('spec/spec_helper.rb')                                               { "spec" }
    watch('app/controllers/application_controller.rb')                         { "spec/controllers" }
    watch(%r{^spec/support/(requests|controllers|mailers|models)_helpers\.rb}) { |m| "spec/#{m[1]}" }
    watch(%r{^spec/.+_spec\.rb})

    watch(%r{^app/controllers/(.+)_(controller)\.rb})                          { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }

    watch(%r{^app/(.+)\.rb})                                                   { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb})                                                   { |m| "spec/lib/#{m[1]}_spec.rb" }
  end

	guard :annotate, :notify => false, :position => 'after' do
	  watch( 'db/schema.rb' )
	end
	
end