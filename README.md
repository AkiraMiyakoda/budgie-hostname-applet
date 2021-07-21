# Budgie Hostname Applet

This applet shows your hostname (or any string of your choice) on your budgie panel.

It would be useful for those who run Budgie on multiple hosts. It has some customization points to help you recognize what host you are using.

## Screenshots

![Panel1](https://github.com/AkiraMiyakoda/budgie-hostname-applet/raw/master/assets/panel1.png)

![Panel2](https://github.com/AkiraMiyakoda/budgie-hostname-applet/raw/master/assets/panel2.png)

![Config](https://github.com/AkiraMiyakoda/budgie-hostname-applet/raw/master/assets/config.png)

## Dependencies

```
meson
valac
libgtk-3-dev >= 3.24.0
libpeas-dev >= 1.26.0
budgie-core-dev >= 1.0
```

## Installation

**From source**
```
meson build --buildtype=release --prefix /usr --libdir lib
cd build/
ninja
sudo ninja install
```
