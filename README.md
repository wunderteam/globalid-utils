[![Build Status](https://circleci.com/gh/wunderteam/globalid-utils.svg?style=svg)](https://circleci.com/gh/wunderteam/globalid-utils)

# globalid-utils

Utilities for customizing and validating GlobalIDs. Allows for per-resource customization of GlobalID generation.

# Usage

## GlobalIdModel

By default, GlobalID uses one GlobalID app namespace across a Rails application. Additionally, it includes any module namespaces of in the generated GlobalIDs.

For example:

```ruby
GlobalID.app = 'fish'

module Fish
  class SiameseFighting < ActiveRecord::Base
  end
end

Fish::SimeseFighting.find(1).to_gid.to_s # => "gid://fish/Fish::SiameseFighting/1"
```

With `GlobalIdModel`:

```ruby
module Fish
  class SiameseFighting < ActiveRecord::Base
    gid_model_name 'SiameseFighting'
    gid_model_id   :name
  end
end

Fish::SiameseFighting.find_by(name: 'Pedro').to_gid.to_s # => "gid://fish/SiameseFighting/Pedro"
```

## GlobalIdValidator

Provides validation of GlobalIDs:

```ruby
class MyModel < ActiveRecord::Base
  validates :ref, global_id: true
end

model = Model.new(ref: "//bad-gid")
model.valid?
model.errors[:ref] # => ["is not a valid URI::GID"]
```
