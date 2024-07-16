# flint (development version)

* Do not lint for `x %in% class(y)` where `x` is not a string as this is [not
  equivalent in some cases](https://github.com/vincentarelbundock/marginaleffects/pull/1171#issuecomment-2228497287). Thanks Vincent Arel-Bundock for spotting this.

# flint 0.0.1

* First Github release.
