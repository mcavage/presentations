#!/usr/sbin/dtrace -s
#pragma D option quiet

foo*:::get*-*-start
{
  tracker[arg0, substr(probename, 0, rindex(probename, "-"))] = timestamp;
}

foo*:::get*-*-done
/tracker[arg0, substr(probename, 0, rindex(probename, "-"))]/
{
  this->name = substr(probename, 0, rindex(probename, "-"));
  @[this->name] = quantize(((timestamp - tracker[arg0, this->name]) / 1000000));
  tracker[arg0, substr(probename, 0, rindex(probename, "-"))] = 0;
}

