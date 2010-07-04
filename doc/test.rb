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


	def read_file o
		lines.each do | line | 
			next if line == nil 
			if line.includes?('')
				
			end
		end
	end
#open file
#find functions
#template
#create

def convert 
		parameters = []
		return_types  = []
		fxName = ''
		fxFault = ''
		fxOk= ''
		args = []
		success_event_type = ''
		fault_event_type = ''
		event_type = ''		
		"
		public function #{fxName} (#{with_type(args)}):void
		{
			noteService.#{name}(#{without_type(args)}, #{fxFault}, #{fxOk})
		}
			private function #{fxOk} (e:Object=null):void
			{
				this.dispatch( new #{event_type}( #{event_type}.#{success_event_type}, e ) ) 
			}
			private function #{fxFault} (e:Object=null):void
			{
				this.dispatch( new #{event_type}( #{event_type}.#{fault_event_type}, e ) ) 
			}
		"
  end

	def output
		puts @output
	end

end

p = Person.new
p.to_s