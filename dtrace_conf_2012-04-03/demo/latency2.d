#!/usr/sbin/dtrace -s

restify*:::get*-*-start
{
      tracker[arg0, substr(probename, 0, rindex(probename, "-"))] = timestamp;
}

restify*:::get*-*-done
/tracker[arg0, substr(probename, 0, rindex(probename, "-"))]/
{
      this->name = substr(probename, 0, rindex(probename, "-"));
          @[this->name] = quantize(((timestamp - tracker[arg0, this->name]) / 1000000));
              tracker[arg0, substr(probename, 0, rindex(probename, "-"))] = 0;
}

