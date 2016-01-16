# Loads config/private.yml (sensitive settings) into Private
# OpenStruct
#
begin
  file = File.join(Rails.root,'config','sapwood.yml')
  Sapwood = YAML.load_file(file).to_ostruct
rescue
  raise "Missing config file: #{file}"
end
