require('hop').setup {}

-- keymap
vim.keymap.set("", "<LEADER>s", function() require('hop').hint_patterns() end)

