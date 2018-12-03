require 'jekyll/prepublish/validator/validator_registry'

# Define empty fake validator for testing purpose.
class FakeValidator
  def test
  end
end

describe JekyllPrepublish::ValidatorRegistry do
  it "registers and unregisters validators without blocks" do
    validator = JekyllPrepublish::ValidatorRegistry.register("fake",
        lambda { return FakeValidator.new })
    registry = JekyllPrepublish::ValidatorRegistry.new
    expect(registry.count).to eql(1)
    # Do not enforce any requirements for key.
    expect(registry.each).to all(include(be_a(String), respond_to(:test)))
    expect(JekyllPrepublish::ValidatorRegistry.unregister("fake")).to be
    expect(registry.count).to eql(0)
  end

  it "automatically unregisters validators with a block" do
    registry = JekyllPrepublish::ValidatorRegistry.new
    JekyllPrepublish::ValidatorRegistry.register(
        "fake", lambda { return FakeValidator.new }) do |_key, _initializer|
      expect(registry.count).to eql(1)
    end
    expect(registry.count).to eql(0)
  end

end
