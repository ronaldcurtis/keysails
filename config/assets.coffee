# Configure Connect-Mincer Asset Pipeline
connectMincer = require('connect-mincer')
nib           = require('nib')
path          = require('path')
mincer        = null
 
# Config for connect-mincer
# See https://github.com/clarkdave/connect-mincer for more details
mincer = new connectMincer
  root: path.join(__dirname, '../')
  production: process.env.NODE_ENV == 'production'
  mountPoint: '/assets'
  manifestFile: path.join(__dirname, '../.built/manifest.json')
  paths: ['assets/']
 
# Configure Stylus so it can import css files just like .styl files
# Also allows the use of nib (mixin library for stylus)
# Remove is you're not using nib or stylus
mincer.Mincer.StylusEngine.configure (style) ->
  style.set('include css', true)
  style.use(nib())
 
# Uncomment the lines below to top optionally configure Jade or Coffee 
# See http://nodeca.github.io/mincer for more details
 
# mincer.Mincer.JadeEngine.configure({});
# mincer.Mincer.CoffeeEngine.configure({});

module.exports = mincer