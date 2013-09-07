module UiHelper
  
  def module_dir
    "/etc/puppet/modules/yaml2catalog"
  end

  def create_yaml
    require 'yaml'
    array, @yaml = [],[]

    params.each { |k,v|
      k = k.to_s
      if k =~ /\w+_\w+_\d+/ and v !=''
        array << k
      end
    }
    
    order = []

    params["sort"].split(',').each do |i|
      if i =~ /dynamicInput_(\d+)/
        order << $1
      end
    end

    until array.empty? do
      array2=[]
      hash1,yaml_tmp={},{}
      num,type=nil,nil

      array.each do |i|
        i.sub(/((\w+)_(\w+)_(\d+))/) {
          num ||= $4.to_s
          if num == $4.to_s
            type ||= $2
            array-=[$1]
            array2 << $3
          end
        }
      end
      
      if array2.include?("name")
        array2-=["name"]
        array2.each do |i|
          hash1[i] = params["#{type}_#{i}_#{num}".to_sym]
        end
        if hash1.empty?
          yaml_tmp[type] = { params["#{type}_name_#{num}".to_sym].to_s => "!!!!" }
        else
          yaml_tmp[type] = { params["#{type}_name_#{num}".to_sym].to_s => hash1 }
        end
        
        if order.empty?
          @yaml << yaml_tmp.to_yaml.sub("--- \n","")
        else
          @yaml[order.index(num)] = yaml_tmp.to_yaml.sub("--- \n","")
        end
      elsif array2.include?("path")
        array2-=["path"]
        array2.each do |i|
          hash1[i] = params["#{type}_#{i}_#{num}".to_sym]
        end
        if hash1.empty?
          yaml_tmp[type] = { params["#{type}_path_#{num}".to_sym].to_s => "!!!!" }
        else
          yaml_tmp[type] = { params["#{type}_path_#{num}".to_sym].to_s => hash1 }
        end

        if order.empty?
          @yaml << yaml_tmp.to_yaml.sub("--- \n","")
        else
          @yaml[order.index(num)] = yaml_tmp.to_yaml.sub("--- \n","")
        end  
      elsif array2.include?("command")
        array2-=["command"]
        array2.each do |i|
          hash1[i] = params["#{type}_#{i}_#{num}".to_sym]
        end
        if hash1.empty?
          yaml_tmp[type] = { params["#{type}_command_#{num}".to_sym].to_s => "!!!!" }
        else
          yaml_tmp[type] = { params["#{type}_command_#{num}".to_sym].to_s => hash1 }
        end

        if order.empty?
          @yaml << yaml_tmp.to_yaml.sub("--- \n","")
        else
          @yaml[order.index(num)] = yaml_tmp.to_yaml.sub("--- \n","")
        end  
      elsif array2.include?("url")
        array2-=["url"]
        array2.each do |i|
          hash1[i] = params["#{type}_#{i}_#{num}".to_sym]
        end
        if hash1.empty?
          yaml_tmp[type] = { params["#{type}_url_#{num}".to_sym].to_s => "!!!!" }
        else
          yaml_tmp[type] = { params["#{type}_url_#{num}".to_sym].to_s => hash1 }
        end

        if order.empty?
          @yaml << yaml_tmp.to_yaml.sub("--- \n","")
        else
          @yaml[order.index(num)] = yaml_tmp.to_yaml.sub("--- \n","")
        end 
      elsif array2.include?("pool")
        array2-=["pool"]
        array2.each do |i|
          hash1[i] = params["#{type}_#{i}_#{num}".to_sym]
        end
        if hash1.empty?
          yaml_tmp[type] = { params["#{type}_pool_#{num}".to_sym].to_s => "!!!!" }
        else
          yaml_tmp[type] = { params["#{type}_pool_#{num}".to_sym].to_s => hash1 }
        end

        if order.empty?
          @yaml << yaml_tmp.to_yaml.sub("--- \n","")
        else
          @yaml[order.index(num)] = yaml_tmp.to_yaml.sub("--- \n","")
        end         
      else
        raise "Where is no name parametr"
      end
    end
    
    File.open('/etc/puppet/modules/yaml2catalog/yamls/module.yaml', 'w') { |f|
      f.write("---\n")
      @yaml.each { |i|
        f.write(i.gsub(/"!!!!"/, ''))
      }
    }
    
    send_file '/etc/puppet/modules/yaml2catalog/yamls/module.yaml'
  end

end
