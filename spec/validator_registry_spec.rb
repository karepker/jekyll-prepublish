require 'jekyll/prepublish/validator/validator_registry'

# Define empty fake validator for testing purpose.
class FakeValidator
  def test
  end
end

describe JekyllPrepublish::ValidatorRegistry do
  it "runs given validators" do
    validator = JekyllPrepublish::ValidatorRegistry.register("fake",
        lambda { |configuration| return FakeValidator.new })
    registry = JekyllPrepublish::ValidatorRegistry.new
    expect(registry.count).to eql(1)
    configuration = { 'fake' => nil }
    # Do not enforce any requirements for key.
    expect(registry.each_validator(configuration)).to all(
        include(be_a(String), respond_to(:test))).and(
        have_attributes(:count => a_value > 0))
    expect(JekyllPrepublish::ValidatorRegistry.unregister("fake")).to be
    expect(registry.count).to eql(0)
  end

  it "runs only given validators" do
    validator = JekyllPrepublish::ValidatorRegistry.register("fake",
        lambda { |configuration| return FakeValidator.new })
    registry = JekyllPrepublish::ValidatorRegistry.new
    expect(registry.count).to eql(1)
    configuration = Hash.new
    # Don't run the validator if it is not specified in the configuration.
    expect(registry.each_validator(configuration).count).to eql(0)
    expect(JekyllPrepublish::ValidatorRegistry.unregister("fake")).to be
    expect(registry.count).to eql(0)
  end

  it "skips unknown validators" do
    validator = JekyllPrepublish::ValidatorRegistry.register("fake",
        lambda { |configuration| return FakeValidator.new })
    registry = JekyllPrepublish::ValidatorRegistry.new
    expect(registry.count).to eql(1)
    configuration = { 'fake' => nil, 'nonexistent' => nil }
    # Do not enforce any requirements for key.
    expect(registry.each_validator(configuration)).to all(
        include(be_a(String), respond_to(:test))).and(
        have_attributes(:count => a_value > 0))
    expect(JekyllPrepublish::ValidatorRegistry.unregister("fake")).to be
    expect(registry.count).to eql(0)
  end

end
