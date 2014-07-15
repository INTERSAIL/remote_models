# RemoteModels

Gem to create read-only associations with remote objects. The remote objects are retrieved on-demand and cached by a remote service (JsonService).

## Installation

Add this line to your application's Gemfile:

    gem 'remote_models'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install remote_models

## Usage

The following code defines a **Course** class having a one-to-one remote association with an object of type **Person**, called *teacher*. Use the *teacher_id* property as the foreign_key.
 
    class Course
        include RemoteAssociable
                
        has_one_remote :teacher, class: Person, name: :person
        
        self.site = 'http://<path_of_json_service>/ReadEntity.aspx        
    end

Now you can do the following

    c = Course.new
    
    c.teacher_id = 1
    c.teacher # -> returns the Person with id=1, stored on remote location, via the JsonService
    c.teacher # -> returns the same Person, doesn't repeat the remote call
    
    c.teacher_id = 2
    c.teacher # -> returns the Person with id=1, stored on remote location, via the JsonService (setting the teacher_id invalidates the teacher property) 

## Contributing

1. Fork it ( https://github.com/[my-github-username]/remote_models/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request