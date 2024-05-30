local Redir = require("redir.config")

Redir.setup({})

describe("open windows", function()
  it("should return false", function()
    assert.are_same(not true, false)
  end)
  it("should return true", function()
    assert.are_same(true, true)
  end)
end)
