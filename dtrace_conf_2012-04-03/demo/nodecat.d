#!/usr/sbin/dtrace -s
#pragma D option quiet

dtrace:::BEGIN
{
    printf("%-20s\t%-16s\t%-16s\n", "FILE", "SYSTEM TIME", "NODE TIME");
}

nodecat*:::fs-read-start
{
    node[copyinstr(arg0)] = timestamp;
}


syscall::open:entry
/node[substr(copyinstr(arg0), (rindex(copyinstr(arg0), "/") + 1), 128)]/
{
    this->fname = substr(copyinstr(arg0),rindex(copyinstr(arg0),"/")+1,128);
    sys[strjoin("_", this->fname)] = timestamp;
}


syscall::read:entry
/node[fds[arg0].fi_name] && sys[strjoin("_", fds[arg0].fi_name)]/
{
    self->fd = arg0;
}

syscall::read:return
/self->fd > 0 && arg0 == 0 && !sys[fds[self->fd].fi_name]/
{
    this->fname = fds[self->fd].fi_name;
    sys[this->fname] = (timestamp - sys[strjoin("_", this->fname)]) / 1000;
    sys[strjoin("_", this->fname)] = self->fd = 0;
}


nodecat*:::fs-read-done
/node[copyinstr(arg0)] && sys[copyinstr(arg0)]/
{
    this->fname = copyinstr(arg0);
    this->delta = (timestamp - node[this->fname]) / 1000;
    printf("%-20s\t%-16d\t%-16d\n", this->fname, sys[this->fname], this->delta);
    node[this->fname] = sys[this->fname] = 0;
}

