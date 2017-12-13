# Chemical-reaction-network-visualizer
A 2D simulation of a chemical reaction networks

Takes in `.cps` files from COPASI

## Running on your machine

### Linux

1. Install Ruby (`apt-get install ruby` or `your-esoteric-pkg-manager install-command ruby`)
2. Install Bundler `gem install bundler`
3. Run: `git clone https://github.com/YourFin/Chemical-reaction-network-visualizer.git`
4. `cd` into the cloned directory
5. Run: `bundle install` to install dependencies
6. To use: `./COPASI-visualizer.rb /path/to/simulation/file.cps`

### OSX
1. Run: [brew](https://brew.sh/)` install ruby`
2. Follow linux commands from step 2

### Windows
**Warning: not well tested**
1. Install newest version of Ruby compatible with your computer from `https://rubyinstaller.org/downloads/`
2. Run `./configure`, which will generate `config.h` and `Makefile`
3. Run `make`
4. Follow linux commands from step 2
