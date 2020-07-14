Control a fan attached to a GPIO via NPN transistor
(defaults to GPIO 14 (pin 8))

For more info see
https://ograblog.wordpress.com/2019/10/09/attaching-a-cpu-fan-to-a-rpi-running-ubuntu-core/

Make sure to connect the snap interface for the correct GPIO
that your fan is attached to (see https://pinout.xyz for correct mapping)

    snap connect pi-fancontrol:gpio pi:bcm-gpio-14

The snap allows a few configurations to be set

Pick a different GPIO to swithc the fan on/off (do not forget to use the
above connect command to enable access to this changed GPIO)

    snap set pi-fancontrol gpio=23

Set the temperature threshold (in degrees celsius) at which the
fan turns on

    snap set pi-fancontrol threshold=40

Set the interval (in seconds) at which the temperature gets scanned

    snap set pi-fancontrol interval=60

