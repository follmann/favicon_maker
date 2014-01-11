class MakerConfig
  [:template_dir, :output_dir].each do |method_name|
    define_method method_name do |dir=nil|
      instance_variable_set("@#{method_name}", dir) if dir
      instance_variable_get("@#{method_name}")
    end
  end
end
