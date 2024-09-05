local Redir = require("redir")
local Config = require("redir.config")
local Constants = require("redir.constants")
local View = require("redir.view")

describe("View", function()
  after_each(function()
    Config.options = nil
    if vim.api.nvim_buf_is_valid(View.bufnr) then
      vim.api.nvim_buf_delete(View.bufnr, { force = true })
    end
    View.current_layout_style = nil
    View.win_id = -1
    View.bufnr = -1
  end)

  describe("View.setup", function()
    it("should setup default layout style", function()
      Redir.setup()
      assert.are_same(Config.defaults.layout_style, View.current_layout_style)
    end)
    it("should setup custom layout style", function()
      Redir.setup({ layout_style = Constants.LayoutStyle.float })
      assert.are_same(Constants.LayoutStyle.float, View.current_layout_style)
    end)
  end)

  describe("View.get_first_redir_win", function()
    it("should return nil when no redir win is open", function()
      assert.is_nil(View.get_first_redir_win())
    end)
    it("should return valid win_id when a redir win is open", function()
      Redir.setup()
      Redir.open()

      local win_id = View.get_first_redir_win()

      assert.True(vim.api.nvim_win_is_valid(win_id --[[@as integer]]))
    end)
    it("should return nil when no redir win is open", function()
      assert.is_nil(View.get_first_redir_win())
    end)
  end)

  describe("View.get_or_create_redir_buf", function()
    it("should create and return a valid redir buffer when redir buffer is not open", function()
      Redir.setup()

      local bufnr = View.get_or_create_redir_buf()
      assert.True(vim.api.nvim_buf_is_valid(bufnr))
      assert.are_same(View.bufnr, bufnr)
    end)

    it("should create and return a valid redir buffer when redir buffer is invalid", function()
      Redir.setup()
      Redir.open()

      vim.api.nvim_buf_delete(View.bufnr, { force = true })

      local bufnr = View.get_or_create_redir_buf()
      assert.True(vim.api.nvim_buf_is_valid(bufnr))
      assert.are_same(View.bufnr, bufnr)
    end)
  end)

  describe("View.attach", function()
    it("should call custom attach function", function()
      local called = 0
      Redir.setup({
        attach = function()
          called = called + 1
        end,
      })

      Redir.open()
      assert.are_same(1, called)
      Redir.close()

      Redir.open()
      assert.are_same(2, called)
      Redir.close()

      Redir.open()
      assert.are_same(3, called)
    end)
  end)

  describe("View.open", function()
    it("should open default layout style", function()
      Redir.setup()
      Redir.open()

      assert.are_same(Config.defaults.layout_style, View.current_layout_style)
    end)
    it("should open custom layout style with custom config", function()
      local win_width = 20
      Redir.setup({
        layout_style = Constants.LayoutStyle.vertical,
        layout_config = { vertical = { width = win_width } },
      })
      Redir.open()

      assert.are_same(Constants.LayoutStyle.vertical, View.current_layout_style)
      assert.are_same(win_width, vim.api.nvim_win_get_width(View.win_id))
    end)
  end)

  describe("View.close", function()
    it("should close redir window but keep buffer", function()
      Redir.setup()
      Redir.open()

      Redir.close()

      assert.False(vim.api.nvim_win_is_valid(View.win_id))
      assert.True(vim.api.nvim_buf_is_valid(View.bufnr))
    end)
  end)

  describe("View.toggle", function()
    it("should open redir when no redir window is open", function()
      Redir.setup()

      Redir.toggle()

      assert.True(vim.api.nvim_win_is_valid(View.win_id))
    end)
    it("should close redir when any redir window is open", function()
      Redir.setup()

      Redir.open()
      Redir.toggle()

      assert.False(vim.api.nvim_win_is_valid(View.win_id))
    end)
  end)
end)
