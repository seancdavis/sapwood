# Loads config/sapwood.yml (sensitive settings) into Sapwood
# OpenStruct
#
def sapwood_as_hash
  begin
    file = File.join(Rails.root,'config','sapwood.yml')
    settings = { 'installed?' => false, 'version' => '2.0' }
    settings.merge(YAML.load_file(file))
  rescue
    raise "Missing config file: #{file}"
  end
end

def sapwood
  sapwood_as_hash.to_ostruct
end
