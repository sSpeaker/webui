module UiHelper

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
        yaml_tmp[type] = { params["#{type}_name_#{num}".to_sym].to_s => hash1 }
        if order.empty?
          @yaml << yaml_tmp.to_yaml.sub("---\n","")
        else
          @yaml[order.index(num)] = yaml_tmp.to_yaml.sub("---\n","")
        end
      else
        raise "Where is no name parametr"
      end
    end

    File.open('/tmp/module.yaml', 'w') { |f|
      @yaml.each { |i|
        f.write(i)
      }
    }

    send_file '/tmp/module.yaml'

  end

end
