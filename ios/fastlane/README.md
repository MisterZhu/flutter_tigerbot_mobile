fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios dev_gym_fir_robot

```sh
[bundle exec] fastlane ios dev_gym_fir_robot
```

打dev包上传fir并且钉钉机器人

### ios dev_gym_fir

```sh
[bundle exec] fastlane ios dev_gym_fir
```

打dev包上传fir

### ios release

```sh
[bundle exec] fastlane ios release
```

打release包上传connection

### ios registerdevice

```sh
[bundle exec] fastlane ios registerdevice
```

添加测试设备

### ios match_dev

```sh
[bundle exec] fastlane ios match_dev
```

拉取描述文件

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
