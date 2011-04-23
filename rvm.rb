rvm_lib_path = "#{`echo $rvm_path`.strip}/lib"
$LOAD_PATH.unshift(rvm_lib_path) unless $LOAD_PATH.include?(rvm_lib_path)
require 'rvm'

# Set up rvm private gemset

say "Setting up RVM and installing gems".magenta

desired_ruby = "ree"
gemset_name = @app_name

@env = RVM::Environment.new(desired_ruby)

@rvm = "rvm #{desired_ruby}@#{gemset_name}"
srun "#{@rvm} --create --rvmrc"

@env.gemset_use! gemset_name

# Make the .rvmrc trusted
#srun "rvm rvmrc trust #{@app_path}"
#srun "rvm rvmrc load #{@app_path}"

# Since the gemset is likely empty, manually install bundler so it can install the rest
#srun "#{@rvm} gem install bundler"
srun "gem install bundler"

# Install all other gems needed from Gemfile
srun "bundle"

gitc "RVMRC file and gems"
