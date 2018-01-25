# Unit test structure

#### - Unit test file:

For class `ClassName`, create a file `ClassName_spec.rb`.

```ruby
require 'spec_helper'

describe ClassName do
	it "describe what this test do" do
		expect(2 + 3).to eq 5
	end
	it "describe what this other test do" do
		except(4 * 2).to eq 8
	end
end
```

#### - In `spec_helper.rb`:

Add this line to `spec_helper.rb`: 

```ruby
require_relative '../src/ClassName.rb'
```
