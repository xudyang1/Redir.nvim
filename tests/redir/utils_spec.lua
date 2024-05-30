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
      assert.are.same(expect, Utils.split_lines(newline_command_output))
    end)
    it("reads command output with carriage return and newline", function()
      assert.are.same(expect, Utils.split_lines(carriage_newline_command_output))
    end)
  end)
end)
