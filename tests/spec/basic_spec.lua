local kitty_aider = require("kitty_aider")

describe("kitty_aider", function()
  -- Test plugin version
  describe("version", function()
    it("should be a string with correct version", function()
      assert.equals(type(kitty_aider.version), "string")
      assert.equals(kitty_aider.version, "0.1.0")
    end)
  end)
end)
