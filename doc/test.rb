class Person
  def fname
    @fname
  end
  def fname=(fname)
    @fname = fname
  end
  def lname
    @lname
  end
  def lname=(lname)
    @lname = lname
  end

  def to_s
    puts "test"
  end


	def read_file  
    comment = false
    error_block = false
    args = []
    function = false 
    name = ''
    lines = File.open("thrift/NoteStore.thrift")
		lines.each do | line | 
			next if line == nil || line == true || line.strip.empty?
      comment = true if line.include? '/*'

      if line.include?('*/') && comment
        comment = false         
        next #skip comment line
      end
      next if comment
      
      error_block = true if line.include? 'throws'

      if line.include?(')') && error_block
        error_block = false         
        next #skip last line
      end      
      next if error_block
      
      if line.include? '('
        #puts line
        function = true 
        split = line.split " "

        type = split[0]; name = split[1].gsub('(1:', '' ) ;      
        #puts split.join(' ' )     
        #puts name        
        args = [] 
        args.push( line.split(": ")[1].gsub(',', '' )  )
        next
      end
    
      
      if function 
        split = line.strip.split(': ')
        #puts line.inspect
        #puts split.join(', ')
        args.push( split[1].gsub(',', '' ).gsub(')', '' )  )        
      end
      #next if function         
    
      if line.include?(')') && function
        function = false     
        #puts 'function:'
        #puts name
        #puts args.join(', ')
        convert(name, format_thrift_arg_strings(args))
        #convert_events(name,  format_thrift_arg_strings(args))
        next #skip last line
      end      
 
      

      
			if line.include?('')
				#puts line
			end
		end
	end
#open file
#find functions
#template
#create

#replace as3 types, re order
def format_thrift_arg_strings ( args )
  params = []
  #puts args.inspect  
  args.each do  |  arg  | 
    split = arg.split(' ')
    #next if i%2 > 0
    params.push( [split[1], convert_thrift_type_to_as3_type(split[0])] ) 
    #puts i
  end
  #puts params.inspect
  #asdf.g
  params
end

def convert_thrift_type_to_as3_type ( thrift_type ) 
  types ={ 'string'=>'String', 'i32'=>'int', 'i64'=>'Number', 
  'Types.UserID'=>'String', 'Types.Guid'=> 'String', 
  'binary'=> 'ByteArray', 'Types.Resource'=> 'Resource', 
  'Types.LinkedNotebook'=>'LinkedNotebook',
  'Types.SharedNotebook'=>'SharedNotebook',  
  'Types.Notebook'=>'Notebook',    
  'bool'=> 'Boolean'}
  as3_type = types[thrift_type]
  as3_type =  'Array' if thrift_type.include?('list<')
  as3_type =  thrift_type.split('.')[1] if thrift_type.include?('Types.')  && as3_type ==nil
  #as3_type = 'Object' if as3_type == nil
  as3_type = thrift_type if as3_type == nil
  return as3_type
end
def get_default_as3_type ( as3_type ) 
  types ={ 'String'=>'""', 'int'=>'0', 'Number'=>'0', 'Boolean'=> 'false'}
  as3_type = types[as3_type]
  #as3_type = 'Object' if as3_type == nil
  as3_type = 'null' if as3_type == nil
  return as3_type
end

def convert fx_name, args
		parameters = []
		return_types  = []
    good = underscore(fx_name)
    #puts good
    good = good.upcase
		#fx_name = ''
		fxFault = fx_name + 'FaultHandler'
		fxOk= fx_name + 'ResultHandler'
		#args = []
		success_event_type = good #+ '_RESULT'
		fault_event_type = good+ '_FAULT'
		event_type = 'EvernoteServiceEvent'		
    #main fx arguments, strip out first authenticationtoken , strip out seperator 
    #arg_ = with_type(args).gsub('authenticationToken:String)', '').gsub('( ,', '') 
    fx = "
   
		public function #{fx_name}(#{with_type(args)}):void {
			noteStore.#{fx_name}(#{without_type(args)}, #{fxFault}, #{fxOk})
		}
			private function #{fxOk}(result:Object=null):void {
				this.dispatch( new #{event_type}( #{event_type}.#{success_event_type}, result)) 
			}
			private function #{fxFault}(result:Object=null):void {
				this.dispatch( new #{event_type}( #{event_type}.#{fault_event_type}, result)) 
			}
		"
    puts   fx.rstrip
  end
  
def convert_events fx_name, args
    good = underscore(fx_name)
    good = good.upcase
 
		success_event_type = good.to_s #+ '_RESULT'
		fault_event_type = good+ '_FAULT'
		success_event_type_ = fx_name + 'Result'
		fault_event_type_ = fx_name + 'Fault'    
    fx = "
		public static const #{success_event_type}:String = \"#{success_event_type_}\";		
		public static const #{fault_event_type}:String = \"#{fault_event_type_}\";			
		"
    puts   fx.rstrip
  end  
  

   def underscore(camel_cased_word)
     camel_cased_word.to_s.gsub(/::/, '/').
       gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
       gsub(/([a-z\d])([A-Z])/,'\1_\2').
       tr("-", "_").
       downcase
   end

  def with_type( params ) 
    str = ''
    params = params.clone
      if ( params[0][0] == 'authenticationToken')
        params.delete_at 0
      end    
    
    #puts params.inspect
    params.each do | param |
      next if param[0] == nil
      #puts param

      str += param[0].to_s + ':' + param[1].to_s
      
      if param != params.first
        begin
        str += '='+ get_default_as3_type( param[1].to_s )#.to_s
        rescue 
          puts 'fail'
          puts params.inspect
          puts param[1].to_s  
          asd.g
        end
      end
      str += ', ' if param != params.last
    end
    #str = params2.join(', ')
    return str
  end

  def without_type( params ) 
    str = ''
    params.each do | param |
      if ( param[0] == 'authenticationToken')
        str += 'this.auth.authenticationToken'
      else
        str += param[0].to_s
      end
      str += ', ' if param != params.last
    end
    return str
  end

	def output
		puts @output
	end

end

p = Person.new
p.read_file
p.to_s