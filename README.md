# ace-cmd


The ace-cmd gem is designed to simplify command execution, emphasizing effective handling of success and failure outcomes. It can be employed as a service object or interactor, fostering clean and organized code for managing complex operations.



- **ace-cmd** provides a simple and flexible way to handle command execution and result handling.

- **ace-cmd** offers a `Success` and `Failure` result classes to handle command execution results.

- **ace-cmd** It provides a `Result` object to access the result value, success, and failure, along with options to attach custom messages and metadata for better context.

## Features

- **Command Execution**: Execute commands seamlessly, allowing for optional parameters.
- **Success Handling**: Provides success responses with transformed messages and additional metadata.
- **Failure Handling**: Handles failures gracefully, returning informative messages and context.


## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Basic Usage](#basic-usage)
  - [Handling Success](#handling-success)
  - [Handling Failure](#handling-failure)
- [Advanced Usage](#advanced-usage)
  - [Custom Metadata](#custom-metadata)
  - [Custom Error Message](#custom-error-message)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add ace-cmd
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install ace-cmd
```

## Basic Usage

To use the `ace-cmd` gem, you can create a command class that includes the `AceCmd::Command` module. Here’s a simple example:

```ruby
require 'ace-cmd'

class GreetingCommand
  include AceCmd::Command

  def call(greeting = nil)
    message = build_greeting(greeting)
    return message if message.failure?
    
    process_message(message)
  end

  def build_greeting(greeting)
    greeting ? Success(greeting) : Failure("No greeting provided")
  end

  def process_message(message)
    message ? Success(message.upcase) : Failure("No message provided")
  end
end
```

### Handling Success

```ruby
result = GreetingCommand.call("Hello, World!")

puts result.success? # Outputs: true
puts result.failure? # Outputs: false

puts result.success  # Outputs: "HELLO, WORLD!"
puts result.failure  # Outputs: nil

puts result.value    # Outputs: "HELLO, WORLD!"
puts result.result   # Outputs: AceCmd::Success

```

### Handling Failure

```ruby
result = GreetingCommand.call

puts result.failure? # Outputs: true
puts result.success? # Outputs: false

puts result.failure  # Outputs: "No message provided"
puts result.success  # Outputs: nil 

puts result.value    # Outputs: "No message provided"
puts result.result   # Outputs: AceCmd::Failure
```

## Advanced Usage

Here are some advanced examples demonstrating the use of `meta:` and `msg:` in the `ace-cmd` gem.

#### Example 1:

```ruby
class GreetingCommand
  include AceCmd::Command
  # ...
  def process_message(message)
    Success(message.upcase, meta: { lang: :eng, length: message.length })
  end
  # ...
end 
```

##### Custom Metadata

```ruby
result = GreetingCommand.("Hello, Advanced World!")
puts result.value         # Outputs: "HELLO, ADVANCED WORLD!"

puts result.meta[:lang]   # Outputs: :eng
puts result.meta[:length] # Outputs: 22
puts result.meta          # Outputs: {:lang=>:eng, :length=>22}
```

#### Example 2: 

```ruby
class GreetingCommand
  include AceCmd::Command
  # ...
  def process_message(message)
    Failure(message, msg: "No message provided")
  end 
end 
```

##### Custom Message

```ruby
result = GreetingCommand.call
puts result.value    # Outputs: nil

puts result.message  # Outputs: "No message provided"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yurigitsu/ace-cmd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yurigitsu/ace-cmd/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AceCmd project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yurigitsu/ace-cmd/blob/main/CODE_OF_CONDUCT.md).
