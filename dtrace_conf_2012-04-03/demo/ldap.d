#!/usr/sbin/dtrace -s
#pragma D option quiet

ldapjs*:::server-search-start
{
    req[arg0] = timestamp;
}


ldapjs*:::server-search-done
/req[arg0]/
{
    @search = quantize(((timestamp - req[arg0]) / 1000000));
}
