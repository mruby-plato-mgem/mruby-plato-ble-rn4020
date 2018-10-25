MRuby::Gem::Specification.new('mruby-plato-ble-rn4020') do |spec|
  spec.license = 'MIT'
  spec.authors = 'Plato developers'
  spec.description = 'PlatoDevice::RN4020 class (RN4020 - Bluetooth Low Energy device class)'

  spec.add_dependency('mruby-plato-serial')
  spec.add_dependency('mruby-plato-ble')
end
