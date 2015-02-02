wifi.setmode(wifi.STATION)
wifi.sta.config ( 'home-network', "tacocat1234" )

pwm.setup(4,500,512)
pwm.start(4)
pwm.setduty(4, 256)

pwm.setup(led_pin,500,512)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
  conn:on("receive",function(conn,payload)
    print(payload)
    conn:send("<h1> Hello, Adam.</h1>")
  end)
  conn:on("sent",function(conn) conn:close() end)
end)

-- One time ESP Setup --
wifi.setmode(wifi.STATION)
wifi.sta.config ( 'home-network', "tacocat1234" )
print(wifi.sta.getip())

-- Blink using timer alarm --
timerId = 0 -- we have seven timers! 0..6
dly = 500 -- milliseconds
ledPin = 4 -- 4=GPIO2 https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en#gpio-new-table--build-20141219-and-later
gpio.mode(ledPin,gpio.OUTPUT)
ledState = 0
tmr.alarm( timerId, dly, 1, function()
  ledState = 1 - ledState;
  gpio.write(ledPin, ledState)
end)
