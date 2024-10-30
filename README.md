[![](https://img.shields.io/badge/dynamic/json?color=orange&label=Factorio&query=downloads_count&suffix=%20downloads&url=https%3A%2F%2Fmods.factorio.com%2Fapi%2Fmods%2Fpowerless&style=for-the-badge)](https://mods.factorio.com/mod/powerless) [![](https://img.shields.io/badge/Discord-Community-blue?style=for-the-badge)](https://discord.gg/K3fXMGVc4z) [![](https://img.shields.io/github/issues/protocol-1903/powerless?label=Bug%20Reports&style=for-the-badge)](https://github.com/protocol-1903/powerless/issues) [![](https://img.shields.io/github/issues-pr/protocol-1903/powerless?label=Pull%20Requests&style=for-the-badge)](https://github.com/protocol_1903/powerless/pulls)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/B0B7145X5R)

#What is this?
This mod turns everything into a burner. This process is done procedurally, so it is (probably) compatible with every mod, although I can't guarantee it will be balanced. I'll be sending balancing patches as I get to all of the entities. As a general rule of thumb, more powerful machines draw more power. 

#Major Changes
- Inserters: Energy draw is increased to become consistent with burner inserter. Speed is unaffected.
- Personal Roboports: Internal buffer recharge rate is decreased to 87.5% of maximum robot charge speed (Note: Vanilla Personal Roboport Mk2 already acts like this). This means that, under continuous use, roboports will run out of power.
- Circuit Network: No energy draw. Due to Factorio engine limitations, combinators, lamps, and other circuit network items cannot be burner powered. Energy draw has been disabled due to minimal gameplay interference. Enjoy making your circuits without substations.

#Optional Settings:
- Burner entity fuel multiplier (default: 1): The fuel consumption multiplier. Can be anywhere from 0 to 1000.
- Inserter fuel leech (default: true)
- Inserter energy cost rebalance (default: true): Rebalance inserters to better match the energy cost of burner inserters
- Other energy cost rebalance (default: true): Rebalance other machines to better match the energy cost of burner machines

#Broken Things
- Roboports: Due to Factorio engine limitations, roboports cannot be burner. Workaround indev.
- Beacons: Due to Factorio engine limitations, beacons cannot be burner. Workaround indev.
- Laser Turret: Due to Factorio engine limitations, laser turrets cannot be burner. Workaround indev.
- Modular Equipment: With the sole exception of the personal roboport, no personal equipment can be burner. Planned workaround: burner generator equipment that consumes fuel to produce power.

#Known bugs
- Solar panels have no name or tooltip
- Portable reactors have no name or tooltip

#Production roadmap (not in order)
- Find a workaround for certain entities
- Fix any bugs that appear
- Create a list of completely compatible mods
- Adjust pollution output of machines
- Tweak module properties (so you have a reason to use efficiency)
- Make refined fuels less polluting
