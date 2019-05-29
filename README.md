<p align="center">
  <img alt="logo" src="https://avatars2.githubusercontent.com/u/39745392?s=200&v=4" width="120">
  <br>
  <a href="https://github.com/explosivegaming/scenario/tags">
    <img src="https://img.shields.io/github/tag/explosivegaming/scenario.svg?label=Release" alt="Release">
  </a>
  <a href="https://github.com/explosivegaming/scenario/archive/master.zip">
    <img src="https://img.shields.io/github/downloads/explosivegaming/scenario/total.svg?label=Downloads" alt="Downloads">
  </a>
  <a href="https://github.com/explosivegaming/scenario/stargazers">
    <img src="https://img.shields.io/github/stars/explosivegaming/scenario.svg?label=Stars" alt="Star">
  </a>
  <a href="http://github.com/explosivegaming/scenario/fork">
    <img src="https://img.shields.io/github/forks/explosivegaming/scenario.svg?label=Forks" alt="Fork">
  </a>
  <a href="https://www.codefactor.io/repository/github/explosivegaming/scenario">
    <img src="https://www.codefactor.io/repository/github/explosivegaming/scenario/badge" alt="CodeFactor">
  </a>
  <a href="https://discord.explosivegaming.nl">
    <img src="https://discordapp.com/api/guilds/260843215836545025/widget.png?style=shield" alt="Discord">
  </a>
</p>
<h1 align="center">ExpGaming Scenario Repository</h2>

## Explosive Gaming

Explosive Gaming (often ExpGaming) is a server hosting community with a strong focus on Factorio and games that follow similar ideas. Our factorio server are known for hosting large maps with the main goal of being a "mega base" which can produce as much as possible with in our reset schedule. Although these server tend to the more experienced players our server are open to everyone. You can find us through our [website](website), [discord](discord), [wiki](wiki), or in the public games tab in factorio (ExpGaming S1).

## Use and Installation

1) Download this [git repository](https://github.com/explosivegaming/scenario/archive/master.zip) for the stable release. The dev branch can be found [here](https://github.com/explosivegaming/scenario/archive/dev.zip) for those who want the latest features. See [releases](#releases) for other release branches.

2) Extract the downloaded zip file from the branch you downloaded into factorio's scenario directory:
    * Windows: `%appdata%\Factorio\scenarios`
    * Linux: `~/.factorio/scenarios`

3) Within the scenario you can find `./config/_file_loader.lua` which contains a list of all the modules that will be loaded by the scenario; simply comment out (or remove) features you do not want but note that some modules may load other modules as dependencies even when removed from the list.

4) More advanced users may want to play with the other configs files within `./config` but please be aware that some of the config files will require a basic understanding of lua while others may just be a list of values.

5) Once you have made any config changes that you wish to make open factorio, select play, then start scenario (or host scenario from within multiplayer tab), and select the scenario which will be called `scenario-master` if you have downloaded the latest stable release and have not changed the folder name.

6) The scenario will now load all the selected modules and start the map, any errors or exceptions raised in the scenario should not cause a game/server crash so if any features don't work as expected then it may be returning an error in the log, please report these errors to [the issues page](issues).

## Contributing

All are welcome to make pull requests and issues for this scenario, if you are in any doubt please ask someone in our [discord](discord). If you do not know lua and don't feel like learning you can always make a [feature request](issues). Please keep in mind while making code changes:

* New features should have the branch names: `feature/feature-name`
* New features are merged into `dev` after it has been completed.
* After a number of features have been added a release branch is made: `release/X.Y.0`; this branch should have no new features and only bug fixes or localization.
* A release is merged into `master` on the following friday in time for the the weekly reset.
* Patches may be named `patch/X.Y.Z` and fill be merged into `master` and `dev` when appropriate.

## Releases

| Scenario Version* | Version Name | Factorio Version** |
|---|---|---|
| [v5.6](s5.6) | Information Guis | [v0.17.43](f0.17.43) |
| [v5.5](s5.5) | Gui System | [v0.17.43](f0.17.43) |
| [v5.4](s5.4) | Admin Controls | [v0.17.32](f0.17.32) |
| [v5.3](s5.3) | Custom Roles | [v0.17.28](f0.17.28) |
| [v5.2](s5.2) | Quality of life | [v0.17.22](f0.17.22) |
| [v5.1](s5.1) | Permission Groups | [v0.17.13](f0.17.13) |
| [v5.0](s5.0) | 0.17 Overhaul| [v0.17](f0.17.9) |
| [v4.0](s4.0) | Softmod Manager | [v0.16.51](f0.16.51) |
| [v3.0](s3.0) | 0.16 Overhaul | [v0.16](f0.16) |
| [v2.0](s2.0) | Localization and clean up | [v0.15](f0.15) |
| [v1.0](s1.0) | Modulation | [v0.15](f0.15) |
| [v0.1](s0.1) | First Tracked Version | [v0.14](f0.14) |
\* Scenario patch versions have been omitted.

\** Factorio versions show the version they were made for, often the minimum requirement.

[s5.6]: https://github.com/explosivegaming/scenario/releases/tag/5.6.0
[s5.5]: https://github.com/explosivegaming/scenario/releases/tag/5.5.0
[s5.4]: https://github.com/explosivegaming/scenario/releases/tag/5.4.0
[s5.3]: https://github.com/explosivegaming/scenario/releases/tag/5.3.0
[s5.2]: https://github.com/explosivegaming/scenario/releases/tag/5.2.0
[s5.1]: https://github.com/explosivegaming/scenario/releases/tag/5.1.0
[s5.0]: https://github.com/explosivegaming/scenario/releases/tag/5.0.0
[s4.0]: https://github.com/explosivegaming/scenario/releases/tag/v4.0
[s3.0]: https://github.com/explosivegaming/scenario/releases/tag/v3.0
[s2.0]: https://github.com/explosivegaming/scenario/releases/tag/v2.0
[s1.0]: https://github.com/explosivegaming/scenario/releases/tag/v1.0
[s0.1]: https://github.com/explosivegaming/scenario/releases/tag/v0.1

[f0.17.43]: https://wiki.factorio.com/Version_history/0.17.0#0.17.43
[f0.17.32]: https://wiki.factorio.com/Version_history/0.17.0#0.17.32
[f0.17.28]: https://wiki.factorio.com/Version_history/0.17.0#0.17.28
[f0.17.22]: https://wiki.factorio.com/Version_history/0.17.0#0.17.22
[f0.17.13]: https://wiki.factorio.com/Version_history/0.17.0#0.17.13
[f0.17.9]: https://wiki.factorio.com/Version_history/0.17.0#0.17.9
[f0.16.51]: https://wiki.factorio.com/Version_history/0.16.0#0.16.51
[f0.16]: https://wiki.factorio.com/Version_history/0.16.0
[f0.15]: https://wiki.factorio.com/Version_history/0.15.0
[f0.14]: https://wiki.factorio.com/Version_history/0.14.0

## License

The Explosive Gaming codebase is licensed under the [GNU General Public License v3.0](https://github.com/explosivegaming/scenario/blob/master/LICENSE)

[issues]: https://github.com/explosivegaming/scenario/issues/new/choose
[website]: https://explosivegaming.nl
[discord]: https://discord.explosivegaming.nl
[wiki]: https://wiki.explosivegaming.nl