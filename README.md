# mruby-plato-ble-rn4020   [![Build Status](https://travis-ci.org/mruby-plato/mruby-plato-ble-rn4020.svg?branch=master)](https://travis-ci.org/mruby-plato/mruby-plato-ble-rn4020)
PlatoDevice::RN4020 class (RN4020 - Bluetooth Low Energy device class)
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

  # ... (snip) ...

  conf.gem :git => 'https://github.com/mruby-plato/mruby-plato-serial'
  conf.gem :git => 'https://github.com/mruby-plato/mruby-plato-ble'
end
```

## example
```ruby
bt = PlatoDevice::RN4020.open('BTdev')
bt.puts "test"
```

## License
under the MIT License:
- see LICENSE file
