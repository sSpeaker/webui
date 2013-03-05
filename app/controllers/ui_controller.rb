class UiController < ApplicationController
  include UiHelper
  def test
  end
  def index
    @yamls_dir = module_dir + "/yamls"
  end

  def new
    require 'yaml'
    tmp_hash = YAML.load_file("/etc/puppet/ui_schema.yaml")

    tmp_hash.each do |type,param|
      param.each do |param_name,param_value|
        if param_value == nil
          tmp_hash[type][param_name] = {}
        end
      end
    end

    @hash = tmp_hash
  end

  def download
    create_yaml
  end
end
