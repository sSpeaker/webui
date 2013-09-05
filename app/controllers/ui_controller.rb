class UiController < ApplicationController
  include UiHelper
  
  def index
    @yamls_dir = module_dir + "/yamls"
  end
  
  def files
    @yamls_dir = module_dir + "/yamls"
    file=params[:file]
    if file
      @file=File.open("#{@yamls_dir}/#{file}").read
      number=0
      @file_content=[];
      @file.each_line do |line| 
        @file_content[number] = line
        number+=1
      @path=  @yamls_dir + "/" + file
      end 
    else
      @file_content="No content yaml failes"
    end
    render :layout => false
  end
  

  def new
    require 'yaml'
########################################################
#read_yaml_fail_with_repeat begin
########################################################      
    @yamls_dir = module_dir + "/yamls"
    if params[:file]
      @yamls_path = @yamls_dir + "/" + params[:file]
      @yamls_file  = File.open(@yamls_path).read
      yaml_prev = @yamls_file.to_s.split(/\r?\n/)
      yaml_prev.shift
      yaml = []
      yaml_prev.each do |element|
        unless /^#/ =~ element
          yaml.push(element.rstrip.downcase)
        end
      end
      first_cont = 0
      switcher = 0 
      @succ_array = Hash.new()
      other_full = Hash.new()
      $first = []
      yaml.each  do |yaml_element|
        if  /^\S/ =~ yaml_element 
          $first.each  do |element|
            if element == yaml_element
              $first[first_cont] = yaml_element.gsub(/:/, '') + first_cont.to_s
              switcher = 1              
            end
          end
          if switcher == 0
            $first[first_cont] = yaml_element
          else
            switcher = 0  
          end
          first_cont +=1
        elsif  /^  \S/ =~ yaml_element
          @succ_array[$first[($first.size)-2].strip.downcase] = {$second.strip.gsub(/:/, '') => other_full }
          other_full = Hash.new()
          $second = yaml_element
        elsif  /^    \S/ =~ yaml_element
         other_array = yaml_element.to_s.split(/:/)
         if other_array[1] == nil
           other_full[other_array[0]] = nil
         else
           if other_array[1].gsub(/ /, '')  == ''
             other_full[other_array[0]] = nil
           else
             other_full[other_array[0].strip.downcase.gsub(/"/, '') ] = other_array[1].strip.downcase.gsub(/"/, '')  
           end  
         end 
        end      
      end    
      @succ_array[$first[($first.size)-1]] = {$second.strip.gsub(/:/, '') => other_full }
    end
########################################################
#read_yaml_fail_with_repeat end
########################################################    
    tmp_hash = YAML.load_file("/etc/puppet/ui_schema2.yaml")
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
