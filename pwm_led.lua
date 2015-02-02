led_pin = 4
led_value = 0
pwm.setup(led_pin,500,led_value)
pwm.start(led_pin)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        print("Path:")
        print(path)
        print("Request:")
        print(request)
        if(path ~= "/favicon.ico")then
          local _GET = {}
          if (vars ~= nil)then
              for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                  _GET[k] = v
              end
          end
          led_value = _GET.led
          pwm.setduty(led_pin, led_value)
          buf = buf.."<h1>Control LED</h1>"
          buf = buf.."<form><p>LED on pin 1</p>"
          buf = buf.."<input type='range' min='0' name='led' max='1023' value='"..led_value.."' onchange='form.submit()'>"
          buf = buf.."</form>"
          client:send(buf);
        end
        client:close();
        collectgarbage();
    end)
end)