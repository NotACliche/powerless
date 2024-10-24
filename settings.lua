data:extend({
  {
    type = "bool-setting",
    name = "inserter-leech",
    localised_name = "Let inserters leech fuel from entities",
    localised_description = "",
    setting_type = "startup",
    default_value = true,
  },
  {
    type = "double-setting",
    name = "burner-multiplier",
    localised_name = "Burner entity fuel multiplier",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0,
    maximum_value = 100,
  }
})