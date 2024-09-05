local Utils = require("redir.utils")
describe("Utils", function()
  describe("split_lines", function()
    local expect = {
      "",
      "",
      "line3 of the command output",
      "",
      "line5 of the command output",
      "",
      "",
      "line8 of the input, last line of command output",
      "",
    }

    local function get_fake_command_output(line_ending)
      return table.concat(expect, line_ending)
    end

    local newline_command_output = get_fake_command_output("\n")
    local carriage_newline_command_output = get_fake_command_output("\r\n")

    it("reads command output with newline only", function()
      assert.are_same(expect, Utils.split_lines(newline_command_output))
    end)
    it("reads command output with carriage return and newline", function()
      assert.are_same(expect, Utils.split_lines(carriage_newline_command_output))
    end)
  end)

  describe("get_size", function()
    it("should return nil if input size is invalid", function()
      assert.is_nil(Utils.get_size(10, 0))
    end)
    it("should return floor of size when it is less than max_val", function()
      local max_val = 10
      local val = 5.5
      assert.are_same(math.floor(val), Utils.get_size(max_val, val))

      val = 8
      assert.are_same(math.floor(val), Utils.get_size(max_val, val))
    end)
    it("should return max_val when val is greater than max_val", function()
      local max_val = 10
      local val = 15.5
      assert.are_same(max_val, Utils.get_size(max_val, val))

      val = 18
      assert.are_same(max_val, Utils.get_size(max_val, val))
    end)
  end)
end)
