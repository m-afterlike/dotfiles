local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
  label = {
    color = colors.white,
    padding_right = 10,
    width = 75,
    align = "right",
    font = { family = settings.font.numbers },
  },
  position = "right",
  update_freq = 30,
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 1
  },
})

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal.name }, {
  background = { color = colors.bg1 }
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })


cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({
    label = os.date("%I:%M %p")  -- Sets the label to "7:26 PM"
  })
end)